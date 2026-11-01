#!/usr/bin/env bash
# Uso: NVD_KEY=<tu-clave> ./scripts/run-scans.sh
set -e
cd "$(dirname "$0")/.."

semgrep scan --config auto app/ --json -o reportes/semgrep.json

docker run --rm -v "$PWD":/src -v ~/dc-data:/usr/share/dependency-check/data -v "$PWD/reportes":/report \
  owasp/dependency-check:latest --scan /src/app --format HTML --format JSON --out /report \
  --project lab-seguridad --nvdApiKey "$NVD_KEY"

docker network create labnet 2>/dev/null || true
docker run -d --name juice --network labnet -p 3000:3000 bkimminich/juice-shop
sleep 30
docker run --rm --network labnet -v "$PWD/reportes":/zap/wrk:rw -t zaproxy/zap-stable \
  zap-baseline.py -t http://juice:3000 -r zap-report.html -J zap-report.json || true
docker rm -f juice