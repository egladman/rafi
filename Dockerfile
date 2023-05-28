ARG REGISTRY=docker.io/
ARG FEDORA_VERSION=37

FROM ${REGISTRY}fedora:${FEDORA_VERSION}

WORKDIR /build

RUN set -eux; \
    dnf install \
      --setopt=install_weak_deps=False \
      --assumeyes \
      bash \
      ccache \
      clang \
      cmake3 \
      ffmpeg-free \
      gamemode \
      gcc \
      gcc-c++ \
      git \
      glslang-devel \
      libaio-devel \
      libdecor \
      libpng \
      libusb \
      libX11 \
      libxcb \
      libXext \
      libXinerama \
      libxkbcommon \
      libxml2 \
      libXrandr \
      libXv \
      make \
      mbedtls-devel \
      mesa-libEGL-devel \
      python \
      spirv-tools-libs \
      vulkan \
      wayland-devel \
      wayland-protocols-devel \
      xxd \
      xz-lzma-compat \
      xz-devel \
      zlib-devel \
    ;

WORKDIR /src

ENTRYPOINT [ "/src/docker-entrypoint.sh" ]
