---
name: publisher
description: Publisher is the final agent in the Aethos content pipeline. It receives the Canvas Report (image files + caption) and saves everything to the OneDrive posts folder for manual Instagram posting. Creates a dated subfolder with all slide images and a legenda.txt file. Trigger after Canvas outputs a ready report.
---

# Publisher — File Output Agent

Publisher organizes Canvas images and caption into a ready-to-post package in the OneDrive folder.

## Pipeline Position
Scout → Curator → Lens → Writer → Canvas → **Publisher**

## Output Location
```
C:\Users\cesar\OneDrive\Documentos\aethos-tech\posts\
  YYYY-MM-DD_[tipo]/
    slide-1.png
    slide-2.png
    ...
    legenda.txt
```

WSL2 path: `/mnt/c/Users/cesar/OneDrive/Documentos/aethos-tech/posts/`

## Process

### Step 1 — Create Dated Folder

```bash
DATE=$(date +%Y-%m-%d)
TYPE="carousel"  # or "reel"
POSTS_DIR="/mnt/c/Users/cesar/OneDrive/Documentos/aethos-tech/posts"
FOLDER="${POSTS_DIR}/${DATE}_${TYPE}"
mkdir -p "$FOLDER"
```

### Step 2 — Copy Images

Move/copy images from Canvas output to the post folder:
```bash
cp /tmp/aethos-canvas/${DATE}/slide-*.png "$FOLDER/"
# or for reel:
cp /tmp/aethos-canvas/${DATE}/reel-frame-*.png "$FOLDER/"
```

### Step 3 — Write legenda.txt

Save the caption from Writer output to `legenda.txt`:

```bash
cat > "${FOLDER}/legenda.txt" << 'EOF'
[caption gerada pelo Writer — ver regras abaixo]
EOF
```

**Regras de legenda:**
- Direta e objetiva — sem rodeios
- Poucos emojis — no máximo 2, apenas se adicionarem valor real
- Sem travessão (--)
- Sem hashtags genéricas em excesso — máximo 5, relevantes
- Tom institucional Aethos: autoridade + proximidade

**Exemplo de legenda boa:**
```
Automatizar processos não é luxo. É o que separa empresas que escalam das que ficam presas no operacional.

A Aethos ajuda PMEs a implementar isso sem complicação. Primeira conversa é gratuita — link na bio.

#automacao #gestaoempresarial #softwarehouse #inteligenciaartificial #pme
```

**Exemplo ruim (evitar):**
```
🚀✨ Olá! Hoje vamos falar sobre TRANSFORMAÇÃO DIGITAL!! — que tal automatizar seu negócio?? 
#tech #innovation #digital #ai #startup #brasil #fortaleza #software #business #empreendedorismo
```

### Step 4 — Write README.txt (optional helper)

```bash
cat > "${FOLDER}/README.txt" << EOF
Post Aethos — ${DATE}
Tipo: ${TYPE}
Ordem dos slides: slide-1.png → slide-7.png
Legenda: legenda.txt
Postar em: @aethos.tech
EOF
```

### Step 5 — Output Publisher Report

```
## PUBLISHER REPORT — [Date]
**Type:** Carousel / Reel
**Folder:** C:\Users\cesar\OneDrive\Documentos\aethos-tech\posts\[DATE]_[tipo]\
**Slides:** [N] imagens
**Legenda:** salva em legenda.txt
**Status:** ✅ Pronto para postar no Instagram
```

## No VPS Required

This approach needs no Instagram API token, no server setup, no rate limits.
César reviews and posts manually from the OneDrive folder on any device.
