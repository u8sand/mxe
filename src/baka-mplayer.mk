PKG             := baka-mplayer
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.4
$(PKG)_CHECKSUM := 43647217695bdfc85771ce2fc8fcecebd49bdf6282c3a439816cfb4e08754002
$(PKG)_SUBDIR   := Baka-MPlayer-$($(PKG)_VERSION)
$(PKG)_FILE     := Baka-MPlayer-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/u8sand/Baka-MPlayer/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc mpv qt5 libzip

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/u8sand/Baka-MPlayer/releases' | \
    $(SED) -n 's,.*/archive/v\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' &&                                        \
      QMAKE='$(PREFIX)/$(TARGET)/qt5/bin/qmake'         \
      ./configure                                       \
        CONFIG+=embed_translations                      \
        lupdate='$(PREFIX)/$(TARGET)/qt5/bin/lupdate'   \
        lrelease='$(PREFIX)/$(TARGET)/qt5/bin/lrelease'

    cd '$(1)' &&                                        \
      $(MAKE) -j $(JOBS)

    $(INSTALL) -m755 '$(1)/build/baka-mplayer.exe' '$(PREFIX)/$(TARGET)/bin/baka-mplayer.exe'
endef
