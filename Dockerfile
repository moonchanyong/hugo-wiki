FROM debian:buster

ARG HUGO_VERSION=0.60.1

WORKDIR "/app"

RUN set -xe \
    && apt update \
    && apt install -y --no-install-recommends apt-utils \
    && apt install -y mg \
    && apt install -y git \
    && apt install -y wget \
    && wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.deb \
    && apt install -y ./hugo_${HUGO_VERSION}_Linux-64bit.deb \
    && rm -fr hugo_${HUGO_VERSION}_Linux-64bit.deb \
    && hugo new site wiki \
    && cd wiki \
    && git init \
    && git submodule add https://github.com/budparr/gohugo-theme-ananke.git themes/ananke \
    && echo 'theme = "ananke"' >> config.toml 
#    && cd /app \
#    && git clone https://github.com/seungjin/hugo-wiki.git \
#    #&& hugo new posts/my-first-post.md
#    && mv huggo-wiki/posts ./wiki/contents/posts \
#    && rm -fr hugo-wiki

COPY ./content /app/wiki/content

RUN  cd /app/wiki \
    && hugo
     
EXPOSE 80

CMD ["hugo", "server", "-w", "-D", "--source", "/app/wiki", "--port", "80", "--bind", "0.0.0.0"]
