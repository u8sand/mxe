PKG             := mochi-player
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.0
$(PKG)_CHECKSUM := 
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/mochi-player/mochi-player/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc mpv qt5 libzip

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/mochi-player/mochi-player/releases' | \
    $(SED) -n 's,.*/archive/v\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' &&                                        \
      '$(PREFIX)/$(TARGET)/qt5/bin/qmake'               \
        CONFIG+=embed_translations                      \
        lupdate='$(PREFIX)/$(TARGET)/qt5/bin/lupdate'   \
        lrelease='$(PREFIX)/$(TARGET)/qt5/bin/lrelease'

    cd '$(1)' &&                                        \
      $(MAKE) -j $(JOBS)

    $(INSTALL) -m755 '$(1)/build/mochi-player.exe' '$(PREFIX)/$(TARGET)/bin/mochi-player.exe'
endef
