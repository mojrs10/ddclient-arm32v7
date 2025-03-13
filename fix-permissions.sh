#!/bin/bash

set -e

# Postavi korisničke podatke za Git
git config --global user.name "GitHub Actions"
git config --global user.email "actions@github.com"

echo "🔧 Postavljam prava na izvršavanje za potrebne fajlove..."

# chmod 755 root/donate.txt
chmod 755 root/etc/s6-overlay/s6-rc.d/isvc-inotify/run
chmod 755 root/etc/s6-overlay/s6-rc.d/svc-ddclient/run
chmod 755 root/etc/s6-overlay/s6-rc.d/init-ddclient-config/run

./root/etc/s6-overlay/s6-rc.d/svc-inotify/run
./root/etc/s6-overlay/s6-rc.d/svc-ddclient/run
./root/etc/s6-overlay/s6-rc.d/svc-ddclient/run

# git add root/donate.txt
git add root/etc/s6-overlay/s6-rc.d/init-radarr-config/run
git add root/etc/s6-overlay/s6-rc.d/svc-radarr/run
git add root/etc/s6-overlay/s6-rc.d/svc-radarr/data/check

# Provjeri je li bilo promjena
if ! git diff-index --quiet HEAD --; then
  echo "✅ Dodani fajlovi s ispravnim pravima."
  git commit -m "Fix: Set executable permissions on s6 scripts"
  echo "✅ Commit napravljen."
  git push
  echo "🚀 Pushano na GitHub!"
else
  echo "Nema promjena za commit."
fi
