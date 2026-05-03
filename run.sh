#!/bin/sh

#Wygenerowanie logu o dacie, autorze i porcie serwera
echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Autor: Anna Wójcik, Serwer uruchomiony na porcie: 3000"

# Uruchomienie wbudowanego w Alpine lekkiego serwera HTTP
exec busybox httpd -f -p 3000 -h /app