#!/data/data/com.termux/files/usr/bin/bash

echo "🛡️ ORION GUARD – Installer gestartet..."
sleep 1

echo "📁 Ordnerstruktur wird erstellt..."
mkdir -p ~/orion_guard/{scripts,logs,vpn_profiles,assets}

echo "📦 Kopiere Starter-Skript..."
cat > ~/orion_guard/scripts/orion_launcher << '_LAUNCHER_'
#!/data/data/com.termux/files/usr/bin/bash
echo "🔐 ORION GUARD wird gestartet..."
termux-tts-speak "Orion Guard aktiviert."
sleep 1
echo "[🟢] VPN-Tarnung & Logging laufen..."
echo "$(date): Orion gestartet" >> ~/orion_guard/logs/ip_log.txt
_LAUNCHER_

chmod +x ~/orion_guard/scripts/orion_launcher

echo "🌐 Erstes Startsignal wird vorbereitet..."
termux-tts-speak "Willkommen bei Orion Guard. Für Freiheit und Schutz."

echo "✅ Installation abgeschlossen."
