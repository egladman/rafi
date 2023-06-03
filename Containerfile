ARG REGISTRY=docker.io/
ARG FEDORA_VERSION=37
ARG XDG_CONFIG_HOME=/app
ARG XDG_STATE_HOME=/app
ARG XDG_DATA_HOME=/app

FROM ${REGISTRY}fedora:${FEDORA_VERSION} as fedora

RUN set -eux; \
    dnf update -y

FROM fedora as runtime-rootfs-build

ARG FEDORA_VERSION

RUN set -eux; \
    dnf install \
      --releasever=$FEDORA_VERSION \
      --setopt=install_weak_deps=False \
      --assumeyes \
      --installroot=/rootfs \
      bash \
      glslang \
      libaio \
      libdecor \
      libgcc \
      libglvnd-glx \
      libglvnd-opengl \
      libpng \
      libusb \
      libstdc++ \
      libwayland-client \
      libwayland-cursor \
      libwayland-egl \
      libX11 \
      libxcb \
      libXext \
      libXinerama \
      libxkbcommon \
      libxml2 \
      libXrandr \
      libXv \
      mbedtls \
      mesa-libEGL \
      spirv-tools-libs \
      vulkan \
      xz-lzma-compat \
      xz \
      zlib \
    ;


FROM fedora as devel-rootfs-build

ARG FEDORA_VERSION

# Reuse packages installed in previous stage to save time
COPY --from=runtime-rootfs-build /rootfs /

RUN set -eux; \
    dnf install \
      --releasever=$FEDORA_VERSION \
      --setopt=install_weak_deps=False \
      --assumeyes \
      --installroot=/rootfs \
      ccache \
      clang \
      cmake3 \
      ffmpeg-free \
      gcc \
      gcc-c++ \
      git \
      glslang-devel \
      libaio-devel \
      make \
      mbedtls-devel \
      mesa-libEGL-devel \
      python \
      spirv-tools-libs \
      wayland-devel \
      wayland-protocols-devel \
      xxd \
      xz-devel \
      zlib-devel \
    ;


FROM fedora as retroarch-build

COPY --from=devel-rootfs-build /rootfs /

WORKDIR /src

COPY . .

ARG XDG_CONFIG_HOME
ARG XDG_STATE_HOME
ARG XDG_DATA_HOME

RUN set -eux; \
    ./main install @retroarch; \
    rm -rf "${XDG_DATA_HOME}/rafi"


FROM scratch

ARG XDG_CONFIG_HOME
ARG XDG_STATE_HOME
ARG XDG_DATA_HOME

ENV XDG_CONFIG_HOME=$XDG_CONFIG_HOME
ENV XDG_STATE_HOME=$XDG_STATE_HOME
ENV XDG_DATA_HOME=$XDG_DATA_HOME
ENV XDG_RUNTIME_DIR=/dev/shm

COPY --from=runtime-rootfs-build /rootfs /
COPY --from=retroarch-build /app /app
COPY --from=retroarch-build /src /src

WORKDIR /app

USER 4826

CMD [ "retroarch" ]