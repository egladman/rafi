ARG REGISTRY=docker.io/

FROM ${REGISTRY}archlinux:latest

WORKDIR /build

RUN set -eux; \
    pacman -Sy --noconfirm \
      bash \
      base-devel \
      ccache \
      cmake \
      ffmpeg \
      gamemode \
      git \
      gcc \
      libaio \
      libdecor \
      libx11 \
      libxcb \
      libxext \
      libxinerama \
      libxkbcommon \
      libxrandr \
      libxv \
      make \
      mesa \
      python \
      tree \
      # xxd
      vim \
      vulkan-headers \
      vulkan-icd-loader \
      wayland \
      wayland-protocols \
    ; \
    git clone -c feature.manyFiles=true https://github.com/spack/spack.git /spack

RUN set -eux; \
    /spack/bin/spack install \
      gcc@9 \
    ;

WORKDIR /src

ENTRYPOINT [ "/src/docker-entrypoint.sh" ]
