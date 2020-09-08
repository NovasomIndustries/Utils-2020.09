***************************
Novasis NOVAsomM9 board
***************************

This file documents the Buildroot support for the NOVAsomM9 board.

Please read the Quick Start Guide [1] for an introduction to the board.

Build
=====

Configure Buildroot for your NOVAsomM9 board:

  make novasis_novasomm9_defconfig

Build all components:

  make

You will find in ./output/images/ the following files:
  - rootfs.ext2
  - rootfs.tar
  - uInitrd

Enjoy!

References
==========
[1] http://www.novasis.it/NOVAsomM9.html
