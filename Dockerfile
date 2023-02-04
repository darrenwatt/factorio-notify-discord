FROM alpine
RUN apk update

RUN apk add --no-cache --upgrade bash bats curl jq

COPY script.sh /app/
COPY discord.sh /usr/local/bin/
LABEL maintainer=thedarrenwatt@gmail.com

CMD ["sh", "/app/script.sh"] 
