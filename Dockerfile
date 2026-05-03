# syntax=docker/dockerfile:1.2

# ETAP 1: Klonowanie repozytorium przez SSH
FROM alpine:3.19 AS builder

# Instalacja klienta git i ssh
RUN apk add --no-cache git openssh-client

# Konfiguracja zaufanych hostów dla GitHuba
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

WORKDIR /build

# Pobranie plików z repozytorium GitHub wykorzystując klucz SSH maszyny budującej
RUN --mount=type=ssh git clone git@github.com:anna-wojcik/pawcho-zadanie1.git .

# ETAP 2: Ostateczny, lekki obraz docelowy
FROM alpine:3.19

# Aktualizacja pakietów łatająca podatności (w tym CVE-2026-40200 dla musl)
RUN apk upgrade --no-cache

# Etykieta zgodna ze standardem OCI (informacja o autorze)
LABEL org.opencontainers.image.authors="Anna Wójcik"

WORKDIR /app

# Optymalizacja warstw: kopiowanie tylko niezbędnych plików z etapu budowania
COPY --from=builder /build/index.html /build/run.sh ./

# Nadanie uprawnień do wykonania skryptu startowego
RUN chmod +x run.sh

# Informacja o porcie
EXPOSE 3000

# Healthcheck sprawdzający czy serwer odpowiada
# wget jest lekkim narzędziem wbudowanym w Alpine, zamiast instalować curl
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:3000/ || exit 1

# Uruchomienie aplikacji
CMD ["/app/run.sh"]