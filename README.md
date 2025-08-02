# SecureOps
Infrastructure Scan & Monitoring Tool

## Description
Un outil d'automatisation de scans de sécurité pour les environnements DevOps

## Structure
SecureOps/
├── scripts/
│ ├── scan_nmap.sh
│ ├── scan_lynis.sh
│ └── scan_trivy.sh
├── config/
│ ├── targets.list
│ └── alert_recipients.list
├── reports/
├── .github/workflows/
│ └── daily_scan.yml
└── README.md

## Créer les dossiers et fichiers supplémentaires

1. **Créer le dossier scripts**:
   - "Add file" > "Create new file"
   - Nom: `scripts/scan_nmap.sh`
   - Contenu:

```bash
#!/bin/bash

TARGETS_FILE="../config/targets.list"
OUTPUT_DIR="../reports"
DATE=$(date +%Y%m%d)

mkdir -p "$OUTPUT_DIR"

echo "Début du scan Nmap..."
while read -r target; do
    if [[ -n "$target" && ! "$target" =~ ^# ]]; then
        echo "Scan de $target..."
        nmap -sV -T4 -O -F --script vuln -oN "$OUTPUT_DIR/nmap-report-$DATE.txt" "$target"
        xsltproc "$OUTPUT_DIR/nmap-report-$DATE.txt" -o "$OUTPUT_DIR/nmap-report-$DATE.html"
    fi
done < "$TARGETS_FILE"

echo "Scan Nmap terminé. Rapports disponibles dans $OUTPUT_DIR/"
