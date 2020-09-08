################################################################################
#
# qt_hydrogen
#
################################################################################
QT_HYDROGEN_VERSION = 2020-08-03
QT_HYDROGEN_SOURCE = qt_hydrogen-$(QT_HYDROGEN_VERSION).tar.bz2
QT_HYDROGEN_SITE = git://github.com/hydrogen-music/hydrogen.git
QT_HYDROGEN_INSTALL_STAGING = NO
QT_HYDROGEN_INSTALL_TARGET = YES
QT_HYDROGEN_DEPENDENCIES = qt5multimedia qt5xmlpatterns qt5tools libarchive libsndfile liblo 
QT_HYDROGEN_CMAKE_OPTIONS=\
    -DCMAKE_COLOR_MAKEFILE=1 \
    -DWANT_DEBUG=1 \
    -DWANT_JACK=1 \
    -DWANT_ALSA=1 \
    -DWANT_LIBARCHIVE=1 \
    -DWANT_RUBBERBAND=1 \
    -DWANT_OSS=1 \
    -DWANT_PORTAUDIO=1 \
    -DWANT_PORTMIDI=1 \
    -DWANT_LASH=0 \
    -DWANT_LRDF=1 \
    -DWANT_COREAUDIO=1 \
    -DWANT_COREMIDI=1

$(eval $(cmake-package))
