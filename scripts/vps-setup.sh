#!/usr/bin/env bash
# Aethos Instagram Pipeline — VPS One-Time Setup
# Run on VPS: bash scripts/vps-setup.sh
# VPS: 148.230.73.61

set -e

echo "=== Aethos Pipeline VPS Setup ==="

# 1. Create content directories
mkdir -p /data/aethos-content
mkdir -p /data/aethos-music
echo "✅ Directories created: /data/aethos-content, /data/aethos-music"

# 2. Install ffmpeg if not present
if ! command -v ffmpeg &>/dev/null; then
  echo "Installing ffmpeg..."
  apt-get update -qq && apt-get install -y ffmpeg
  echo "✅ ffmpeg installed"
else
  echo "✅ ffmpeg already installed: $(ffmpeg -version 2>&1 | head -1)"
fi

# 3. Install ImageMagick (fallback for failed image gen)
if ! command -v convert &>/dev/null; then
  apt-get install -y imagemagick
  echo "✅ ImageMagick installed"
else
  echo "✅ ImageMagick already installed"
fi

# 4. Create nginx site config for asset serving
NGINX_CONF="/etc/nginx/sites-available/aethos-assets"
cat > "$NGINX_CONF" << 'NGINX_EOF'
server {
    listen 80;
    server_name assets.aethostech.com.br;

    location /content/ {
        alias /data/aethos-content/;
        autoindex off;
        add_header Cache-Control "public, max-age=86400";
        add_header Access-Control-Allow-Origin "*";
    }

    # Let certbot handle HTTPS redirect after SSL setup
}
NGINX_EOF

# Enable site
ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/aethos-assets
nginx -t && systemctl reload nginx
echo "✅ Nginx configured for assets.aethostech.com.br"

# 5. Create publish log and costs log
touch /data/aethos-content/publish-log.jsonl
touch /data/aethos-content/costs.log
touch /data/aethos-content/errors.log
echo "✅ Log files initialized"

# 6. Create token renewal script placeholder
cat > /home/$(logname)/scripts/renew-instagram-token.sh << 'RENEW_EOF'
#!/usr/bin/env bash
# Instagram token renewal — runs every 45 days via cron
# Requires: FB_APP_ID, FB_APP_SECRET, INSTAGRAM_ACCESS_TOKEN in /etc/environment
source /etc/environment

NEW_TOKEN=$(curl -s "https://graph.facebook.com/v19.0/oauth/access_token?\
grant_type=fb_exchange_token\
&client_id=${FB_APP_ID}\
&client_secret=${FB_APP_SECRET}\
&fb_exchange_token=${INSTAGRAM_ACCESS_TOKEN}" | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")

if [ -n "$NEW_TOKEN" ]; then
  sed -i "s/INSTAGRAM_ACCESS_TOKEN=.*/INSTAGRAM_ACCESS_TOKEN=${NEW_TOKEN}/" /etc/environment
  echo "$(date): Token renewed successfully" >> /data/aethos-content/token-renewal.log
else
  echo "$(date): Token renewal FAILED" >> /data/aethos-content/errors.log
fi
RENEW_EOF
chmod +x /home/$(logname)/scripts/renew-instagram-token.sh
echo "✅ Token renewal script created"

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Point DNS: assets.aethostech.com.br → 148.230.73.61"
echo "2. Run SSL: certbot --nginx -d assets.aethostech.com.br"
echo "3. Add to /etc/environment:"
echo "   INSTAGRAM_ACCESS_TOKEN=your_long_lived_token"
echo "   INSTAGRAM_ACCOUNT_ID=your_account_id"
echo "   FB_APP_ID=your_app_id"
echo "   FB_APP_SECRET=your_app_secret"
echo "   OPENAI_API_KEY=your_openai_key"
echo "4. Download royalty-free music to /data/aethos-music/"
echo "   Sources: pixabay.com/music, freemusicarchive.org"
echo "5. Run pipeline cron setup: scripts/setup-cron.sh"
