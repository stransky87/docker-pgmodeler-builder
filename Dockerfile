FROM ubuntu:22.04 AS cc
LABEL com.handcraftedbits.image.authors="opensource@handcraftedbits.com"
LABEL net.baotran.image.authors="contact@baotran.net"

RUN apt-get update && \
  apt-get install -y autoconf automake autopoint bash bison bzip2 flex g++ g++-multilib gettext git gperf gtk-doc-tools intltool \
  libc6-dev-i386 libgdk-pixbuf2.0-dev libltdl-dev libgl-dev libssl-dev libtool-bin libxml-parser-perl lzip make openssl \
  p7zip-full patch perl python3 python3-mako python-pkg-resources ruby sed unzip wget xz-utils && \
  cd /opt && \
  update-alternatives --install /usr/bin/python python /usr/bin/python2 1 && \
  update-alternatives --install /usr/bin/python python /usr/bin/python3 2 && \
  echo "LANG=C.UTF-8" > /etc/default/locale && \
  git clone https://github.com/mxe/mxe.git && \
  cd mxe && \
  make MXE_TARGETS='x86_64-w64-mingw32.shared x86_64-w64-mingw32.static' cc

FROM cc AS deps1
RUN cd /opt/mxe && \
  make MXE_TARGETS='x86_64-w64-mingw32.shared x86_64-w64-mingw32.static' zlib && \
  make MXE_TARGETS='x86_64-w64-mingw32.shared' dbus openssl pcre2 fontconfig freetype harfbuzz jpeg zstd \
    sqlite mesa postgresql libxml2 && \
  mkdir -p /opt/src && \
  cd /opt/src && \
  git clone https://github.com/digitalist/pydeployqt.git

FROM deps1 AS deps2
RUN cd /opt/mxe && \
  make MXE_TARGETS='x86_64-w64-mingw32.shared' qt6-qtbase qt6-qtimageformats qt6-qtsvg && \
  ln -s /opt/mxe/usr/x86_64-w64-mingw32.shared/qt6/bin/qmake /opt/mxe/usr/bin/x86_64-w64-mingw32.shared-qmake-qt6 && \
  rm -rf pkg .ccache

FROM deps2 AS postgres
ARG VERSION_POSTGRESQL=REL_15_3

RUN cd /opt/src && \
  git clone https://github.com/postgres/postgres.git && \
  cd postgres && \
  git checkout -b ${VERSION_POSTGRESQL} ${VERSION_POSTGRESQL} && \
  cd /opt/src/postgres && \
  PATH=/opt/mxe/usr/bin:${PATH} ./configure --host=x86_64-w64-mingw32.static --prefix=/opt/postgresql && \
  PATH=/opt/mxe/usr/bin:${PATH} make && \
  PATH=/opt/mxe/usr/bin:${PATH} make install && \
  cd /opt/src && \
  rm -rf postgres

FROM postgres AS builder
COPY data /

WORKDIR /opt


