#!/bin/sh

#Wygenerowanie logu o dacie, autorze i porcie serwera
echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Autor: Anna Wójcik, Serwer uruchomiony na porcie: 3000"

# Uruchomienie serwera Netcat w pętli, który będzie nasłuchiwał na porcie 3000 i zwracał zawartość pliku index.html
while true; do 
  echo -e "HTTP/1.1 200 OK\n\n$(cat /app/index.html)" | nc -l -p 3000
done