Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167A63EC8C1
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 13:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238047AbhHOLkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 07:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237877AbhHOLkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 07:40:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54CF96103A;
        Sun, 15 Aug 2021 11:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629027619;
        bh=oKs32rhY5KrrBDmm+KEr2QK6RvWmxWgEBSRXZvHu30M=;
        h=From:To:Cc:Subject:Date:From;
        b=Qw7E+jF1pIIuAn1L/X5a+TJm6jpsJz1gyAbl0aL3u5ja3eGwi1OiYF8y09aTSiUVr
         QHDuhbGFJbwU3IsJ2v2NwQGabrACF3lvy5rO+aE5jyFHLaAh90KAg+Rs0y/xestGaY
         1QdBJ49eLGJgef4mRmS72Ymp7MzRB9cfaIkPXh1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.244
Date:   Sun, 15 Aug 2021 13:40:13 +0200
Message-Id: <16290276146511@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.244 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 arch/alpha/kernel/smp.c                              |    2 
 arch/arm/boot/dts/omap5-board-common.dtsi            |    9 --
 arch/mips/Makefile                                   |    2 
 arch/mips/mti-malta/malta-platform.c                 |    3 
 arch/x86/events/perf_event.h                         |    3 
 drivers/acpi/acpica/nsrepair2.c                      |    7 -
 drivers/ata/libata-sff.c                             |   35 ++++++--
 drivers/clk/clk-stm32f4.c                            |   10 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c              |   11 ++
 drivers/media/v4l2-core/videobuf2-core.c             |   13 +++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c      |    3 
 drivers/net/ethernet/freescale/fec_main.c            |    2 
 drivers/net/ethernet/natsemi/natsemi.c               |    8 --
 drivers/net/ethernet/neterion/vxge/vxge-main.c       |    6 -
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c |    2 
 drivers/net/ethernet/qlogic/qla3xxx.c                |    6 -
 drivers/net/ethernet/xilinx/xilinx_emaclite.c        |    5 -
 drivers/net/ppp/ppp_generic.c                        |   19 +++-
 drivers/net/usb/pegasus.c                            |   14 ++-
 drivers/net/usb/qmi_wwan.c                           |   76 +++++++++++++++++--
 drivers/pcmcia/i82092.c                              |    1 
 drivers/scsi/sr.c                                    |    2 
 drivers/spi/spi-meson-spicc.c                        |    2 
 drivers/staging/rtl8723bs/hal/sdio_ops.c             |    2 
 drivers/tty/serial/8250/8250_port.c                  |   12 ++-
 drivers/usb/class/usbtmc.c                           |    8 --
 drivers/usb/common/usb-otg-fsm.c                     |    6 +
 drivers/usb/gadget/function/f_hid.c                  |   44 +++++++++--
 drivers/usb/host/ehci-pci.c                          |    3 
 drivers/usb/serial/ch341.c                           |    1 
 drivers/usb/serial/ftdi_sio.c                        |    1 
 drivers/usb/serial/ftdi_sio_ids.h                    |    3 
 drivers/usb/serial/option.c                          |    2 
 fs/ext4/namei.c                                      |    2 
 fs/namespace.c                                       |   42 +++++++---
 fs/pipe.c                                            |   19 ++++
 fs/reiserfs/stree.c                                  |   31 ++++++-
 fs/reiserfs/super.c                                  |    8 ++
 include/linux/usb/otg-fsm.h                          |    1 
 include/net/bluetooth/hci_core.h                     |    1 
 net/bluetooth/hci_core.c                             |   16 ++--
 net/bluetooth/hci_sock.c                             |   49 ++++++++----
 net/bluetooth/hci_sysfs.c                            |    3 
 scripts/tracing/draw_functrace.py                    |    6 -
 sound/core/seq/seq_ports.c                           |   39 ++++++---
 46 files changed, 399 insertions(+), 143 deletions(-)

Alex Xu (Hello71) (1):
      pipe: increase minimum default pipe size to 2 pages

Christoph Hellwig (1):
      libata: fix ata_pio_sector for CONFIG_HIGHMEM

Dan Carpenter (1):
      bnx2x: fix an error code in bnx2x_nic_load()

Daniele Palmas (1):
      USB: serial: option: add Telit FD980 composition 0x1056

Dario Binacchi (1):
      clk: stm32f4: fix post divisor setup for I2S/SAI PLLs

David Bauer (1):
      USB: serial: ftdi_sio: add device ID for Auto-M3 OP-COM v2

Dmitry Osipenko (1):
      usb: otg-fsm: Fix hrtimer list corruption

Dongliang Mu (1):
      spi: meson-spicc: fix memory leak in meson_spicc_remove

Fei Qin (1):
      nfp: update ethtool reporting of pauseframe control

Greg Kroah-Hartman (1):
      Linux 4.14.244

H. Nikolaus Schaller (2):
      omap5-board-common: remove not physically existing vdds_1v8_main fixed-regulator
      mips: Fix non-POSIX regexp

Hans Verkuil (1):
      media: videobuf2-core: dequeue if start_streaming fails

Hui Su (1):
      scripts/tracing: fix the bug that can't parse raw_trace_func

Johan Hovold (1):
      media: rtl28xxu: fix zero-length control request

Letu Ren (1):
      net/qla3xxx: fix schedule while atomic in ql_wait_for_drvr_lock and ql_adapter_reset

Li Manyi (1):
      scsi: sr: Return correct event when media event code is 3

Like Xu (1):
      perf/x86/amd: Don't touch the AMD64_EVENTSEL_HOSTONLY bit inside the guest

Longfang Liu (1):
      USB:ehci:fix Kunpeng920 ehci hardware problem

Maciej W. Rozycki (2):
      serial: 8250: Mask out floating 16/32-bit bus bits
      MIPS: Malta: Do not byte-swap accesses to the CBUS UART

Maxim Devaev (2):
      usb: gadget: f_hid: added GET_IDLE and SET_IDLE handlers
      usb: gadget: f_hid: idle uses the highest byte for duration

Miklos Szeredi (1):
      ovl: prevent private clone if bind mount is not allowed

Pali Rohár (1):
      ppp: Fix generating ppp unit id when ifname is not specified

Pavel Skripkin (3):
      net: pegasus: fix uninit-value in get_interrupt_interval
      net: fec: fix use-after-free in fec_drv_remove
      net: vxge: fix use-after-free in vxge_device_unregister

Phil Elwell (1):
      usb: gadget: f_hid: fixed NULL pointer dereference

Prarit Bhargava (1):
      alpha: Send stop IPI to send to online CPUs

Qiang.zhang (1):
      USB: usbtmc: Fix RCU stall warning

Rafael J. Wysocki (1):
      Revert "ACPICA: Fix memory leak caused by _CID repair function"

Reinhard Speyerer (1):
      qmi_wwan: add network device usage statistics for qmimux devices

Shreyansh Chouhan (1):
      reiserfs: check directory items on read from disk

Takashi Iwai (1):
      ALSA: seq: Fix racy deletion of subscriber

Tetsuo Handa (1):
      Bluetooth: defer cleanup of resources in hci_unregister_dev()

Theodore Ts'o (1):
      ext4: fix potential htree corruption when growing large_dir directories

Wang Hai (1):
      net: natsemi: Fix missing pci_disable_device() in probe and remove

Willy Tarreau (1):
      USB: serial: ch341: fix character loss at high transfer rates

Xiangyang Zhang (1):
      staging: rtl8723bs: Fix a resource leak in sd_int_dpc

Yu Kuai (1):
      reiserfs: add check for root_inode in reiserfs_fill_super

YueHaibing (1):
      net: xilinx_emaclite: Do not print real IOMEM pointer

Zheyu Ma (1):
      pcmcia: i82092: fix a null pointer dereference bug

