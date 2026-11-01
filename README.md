# lab-seguridad

# Laboratorio de Seguridad en Aplicaciones – Entorno de práctica

Entorno: **GitHub Codespaces** (Ubuntu, Docker preinstalado).

## 1. Repositorio Git
Repositorio: https://github.com/KEVIN18xD/lab-seguridad
Estructura: `app/` (código de práctica), `reportes/` (salidas de herramientas), `evidencias/` (capturas).

## 2. Docker
- Versión: 29.9.2
- Verificación: `docker run hello-world` → "Hello from Docker!"

## 3. Semgrep (SAST)
- Versión: 1.183.0
- Comando: `semgrep scan --config auto app/`
- Resultado: **6 hallazgos** (203 reglas, 3 archivos)

| Hallazgo | Línea | Riesgo |
|---|---|---|
| Inyección de comandos (`child_process.exec` con `req`) | 9 | Ejecución de comandos del SO |
| Uso de `eval()` | 13 | Ejecución de código arbitrario |
| Datos de la petición hacia `eval` (code-string-concat) | 13 | Ejecución de código arbitrario |
| Escritura directa en la respuesta | 13 | XSS |
| Secreto JWT hardcodeado | 16 | Fuga de credenciales |
| Sin middleware CSRF | 4 | CSRF |

Reporte: `reportes/semgrep.json`

## 4. OWASP Dependency-Check (SCA)
- Ejecución: imagen Docker `owasp/dependency-check:latest` con API key de NVD (417 611 registros CVE)
- Resultado: **41 vulnerabilidades en 10 dependencias**

| Dependencia | Vulnerabilidades |
|---|---|
| lodash 4.17.15 | 12 |
| jsonwebtoken 8.5.0 | 6 |
| lodash.js | 6 |
| qs 6.5.1 | 5 |
| body-parser 1.18.2 | 3 |
| path-to-regexp 0.1.7 | 3 |
| express 4.16.0 | 2 |
| send 0.16.0 | 2 |
| cookie 0.3.1 | 1 |
| serve-static 1.13.0 | 1 |

Remediación: actualizar a versiones soportadas (`npm audit fix` / subir versiones mayores).
Reportes: `reportes/dependency-check-report.html` y `.json`

## 5. OWASP ZAP (DAST)
- Objetivo: OWASP Juice Shop (contenedor `bkimminich/juice-shop`)
- Comando: `zap-baseline.py -t http://juice:3000`
- Resultado: **FAIL 0 · WARN 7 · PASS 61** (116 URL)

| Alerta | ID |
|---|---|
| Content Security Policy (CSP) no definida | 10038 |
| Contenido almacenable en caché | 10049 |
| Cabecera Feature-Policy obsoleta | 10063 |
| Configuración cross-domain incorrecta (CORS) | 10098 |
| Aplicación web moderna (informativa) | 10109 |
| Funciones JS peligrosas | 10110 |
| Falta Cross-Origin-Embedder-Policy | 90004 |

Reportes: `reportes/zap-report.html` y `.json`

## 6. Evidencias
| Captura | Contenido |
|---|---|
| `evidencias/01-repo.png` | git status / remote |
| `evidencias/02-docker.png` | docker --version + hello-world |
| `evidencias/03-semgrep.png` | versión + 6 findings |
| `evidencias/04-dependency-check.png` | Analysis Complete + reporte HTML |
| `evidencias/05-zap.png` | resumen ZAP + Juice Shop |

> Nota de seguridad: la API key de NVD se usó solo como variable de entorno y no se guardó en el repositorio.