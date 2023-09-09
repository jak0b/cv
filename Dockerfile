FROM debian:12.0

RUN apt-get update && \
    apt-get install -y texlive-base texlive-xetex curl

RUN apt-get clean autoclean && \ 
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/
