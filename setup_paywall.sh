#!/data/data/com.termux/files/usr/bin/bash
set -e
PROJECT_DIR="$HOME/orion_guard"
PUBLIC_DIR="$PROJECT_DIR/public"
README="$PROJECT_DIR/README.md"
QR_SRC=""
# -------- QR-Code suchen ------------------------------- #
for f in \
  "$PROJECT_DIR/releases/paypal_qr_code.png" \
  "$HOME/downloads/paypal_qr_code.png" \
  "/sdcard/Download/paypal_qr_code.png"; do
  [ -f "$f" ] && QR_SRC="$f" && break
done
if [ -z "$QR_SRC" ]; then
  echo "❗  QR-Code paypal_qr_code.png nicht gefunden – Abbruch."; exit 1
fi
mkdir -p "$PUBLIC_DIR"
cp "$QR_SRC" "$PUBLIC_DIR/paypal_qr_code.png"
# -------- Landing-Page generieren ---------------------- #
cat > "$PUBLIC_DIR/index.html" <<"EOL"
<!DOCTYPE html><html lang="de"><head><meta charset="UTF-8">
<title>🛡️ ORION GUARD – Digitale Verteidigung</title>
<style>body{background:#111;color:#eee;font-family:sans-serif;padding:2rem}
h1,h2{color:#7ed957}.box{background:#222;padding:1em;margin:1em 0;border-radius:8px}
.btn{background:#7ed957;color:#111;padding:.6em 1.2em;text-decoration:none;border-radius:4px}
img.qr{max-width:220px;margin-top:1em}</style></head><body>
<h1>🛡️ ORION GUARD</h1>
<p>Das erste ethische VPN-Terminal mit Schutz, Sprache und Autonomie.</p>

<div class="box"><h2>🎁 Kostenlos – Vision&nbsp;&amp;&nbsp;README</h2>
<p>Erhalte das README und erfahre die Idee dahinter.</p>
<a class="btn" href="../README.md">README&nbsp;ansehen</a></div>

<div class="box"><h2>🌍 Zugang 1 – Community (19 €)</h2>
<p>DEB-Installer &amp; Basis-Funktionen.</p></div>

<div class="box"><h2>💎 Zugang 2 – Vollversion (49 €)</h2>
<p>Autostart, Sprachsteuerung, Ethik-Kern, Launcher u.&nbsp;v.&nbsp;m.</p></div>

<div class="box"><h2>🌟 Lebensfreunde – 149 €+</h2>
<p>Alles inklusive, Lifetime-Support &amp; Dank im Code.</p></div>

<h2>💳 Zahlung</h2>
<p>Scanne den QR-Code und gib <b>Zugang 1 / 2 / 3</b> als Betreff an.</p>
<img class="qr" src="paypal_qr_code.png" alt="PayPal QR">
<p>Nach Zahlung Screenshot + Versions­wunsch an <b>kontakt@orion-guard.org</b> senden.<br>
Du erhältst dann den Download-Link manuell.</p></body></html>
EOL
# -------- README aktualisieren ------------------------- #
cat > "$README" <<"EOR"
# 🛡️ ORION GUARD – Staffelpreise

| Paket            | Inhalt (👓 Kurzfassung) | Preis |
|------------------|-------------------------|------:|
| Vision           | README & Idee           | 0 €   |
| Community        | DEB-Installer           | 19 €  |
| Vollversion      | Launcher + Ethik-Kern   | 49 €  |
| Lebensfreunde    | Lifetime-Support, Dank  | 149 € |

**Zahlung:** PayPal-QR scannen, Betreff „Zugang 1/2/3“.  
Mail an kontakt@orion-guard.org → du bekommst deinen Download-Link.
EOR
echo "✅ Paywall-Dateien erzeugt."
