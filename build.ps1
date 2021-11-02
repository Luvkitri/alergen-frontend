docker build -t test:latest .
docker run --rm -v "${pwd}:/app" test:latest /bin/bash -c "flutter clean && flutter build apk -v"