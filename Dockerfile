FROM ubuntu:16.04
MAINTAINER Stephen Foster <stephen@thoughtstem.com>

RUN apt-get update && \
    apt-get install -y wget sqlite3 && \
    rm -rf /var/lib/apt/lists/*

ENV RACKET_VERSION 7.0
ENV RACKET_INSTALLER_URL https://mirror.racket-lang.org/installers/$RACKET_VERSION/racket-$RACKET_VERSION-x86_64-linux.sh

RUN wget --output-document=racket-install.sh $RACKET_INSTALLER_URL && \
    echo "yes\n1\n" | /bin/bash racket-install.sh && \
    rm racket-install.sh


RUN apt-get update
RUN apt-get install -y git libssl-dev ca-certificates sqlite libglib2.0 libfontconfig1 libcairo2 libpango-1.0-0 libpangocairo-1.0-0 libjpeg-dev mesa-common-dev freeglut3 freeglut3-dev

EXPOSE 8000
EXPOSE 80

#RUN git clone https://github.com/ldhandley/mailing-list.git

COPY . mailing-list
RUN raco pkg install --auto mailing-list/

WORKDIR "/mailing-list"
