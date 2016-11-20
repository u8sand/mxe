PKG             := mpv
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.22.0
$(PKG)_CHECKSUM := c0f9ac8f0e37a391d19007b333ef8787c2f45d75a0d4401c0098cde52c5082f6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/mpv-player/mpv/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc ffmpeg libass lua luajit jpeg pthreads libssh2 waf \
                   libbluray libdvdread libdvdnav libcdio rubberband lcms \
                   libarchive sdl2 jack openal

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/mpv-player/mpv/releases' | \
    $(SED) -n 's,.*/archive/v\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' &&                                  \
        AR='$(TARGET)-ar'                         \
        CC='$(TARGET)-gcc'                        \
        DEST_OS='win$(BITS)'                      \
        TARGET='$(TARGET)'                        \
        PREFIX='$(PREFIX)/$(TARGET)'              \
        '$(PREFIX)/$(BUILD)/bin/waf'              \
            configure                             \
            -j '$(JOBS)'                          \
            $(if $(BUILD_STATIC),                 \
                --enable-libmpv-static,           \
                --enable-libmpv-shared)

    cd '$(1)' && '$(PREFIX)/$(BUILD)/bin/waf' build install
endef
