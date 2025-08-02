#!/bin/bash

# Configuration
OUTPUT_DIR="../reports"
DATE=$(date +%Y%m%d)
LOG_FILE="$OUTPUT_DIR/lynis-report-$DATE.log"
CRITICAL_FILE="$OUTPUT_DIR/lynis-critical-$DATE.txt"

# Vérification de l'installation de Lynis
if ! command -v lynis &> /dev/null; then
    echo "Erreur: Lynis n'est pas installé."
    echo "Installez-le avec: sudo apt install lynis"
    exit 1
fi

# Création du dossier de rapports
mkdir -p "$OUTPUT_DIR"

echo "=== Début de l'audit Lynis ==="
echo "Heure: $(date)"
echo "Système: $(uname -a)"
echo ""

# Exécution de l'audit
sudo lynis audit system --quick --no-colors --logfile "$LOG_FILE"

# Extraction des problèmes critiques
echo ""
echo "=== Analyse des résultats ==="
grep -E 'warning|suggestion' "$LOG_FILE" > "$CRITICAL_FILE"

# Affichage du résumé
echo ""
echo "=== Résumé de l'audit ==="
echo "Rapport complet: $LOG_FILE"
echo "Problèmes critiques: $CRITICAL_FILE"
echo ""
echo "Nombre de warnings: $(grep -c 'warning' "$CRITICAL_FILE" || true)"
echo "Nombre de suggestions: $(grep -c 'suggestion' "$CRITICAL_FILE" || true)"

exit 0
