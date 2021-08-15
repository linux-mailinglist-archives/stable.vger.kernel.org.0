Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219623EC8BE
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 13:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhHOLko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 07:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237749AbhHOLkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 07:40:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3037761056;
        Sun, 15 Aug 2021 11:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629027613;
        bh=0t0JRy1yH5SJqDMYdEa4bqx61qBKv2TJaA0ThnAXj/8=;
        h=From:To:Cc:Subject:Date:From;
        b=syAmhbFq+Y2VJ0chXzCEibMrtlmN1602iDArDZ1LvmZ6iXdvToF+tDtk9nQuCEQW+
         RgY7YgLiGNCkYgGkUnLmAwUNE+oXXAgXO14HgoxRD1hgLQ3I/YWtqhgO+LPFGx/c3V
         etFTfHfN0+OqKjrYgtmxy2+WYZ2yzODLahY84Hno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.280
Date:   Sun, 15 Aug 2021 13:40:07 +0200
Message-Id: <1629027608144244@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.280 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/alpha/kernel/smp.c                         |    2 
 arch/mips/Makefile                              |    2 
 arch/mips/mti-malta/malta-platform.c            |    3 -
 arch/x86/events/perf_event.h                    |    3 -
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c         |   11 ++++-
 drivers/media/v4l2-core/videobuf2-core.c        |   13 +++++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    3 -
 drivers/net/ethernet/freescale/fec_main.c       |    2 
 drivers/net/ethernet/natsemi/natsemi.c          |    8 ---
 drivers/net/ethernet/neterion/vxge/vxge-main.c  |    6 +-
 drivers/net/ethernet/qlogic/qla3xxx.c           |    6 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c   |    5 --
 drivers/net/ppp/ppp_generic.c                   |   19 +++++++--
 drivers/net/usb/pegasus.c                       |   14 +++++-
 drivers/pcmcia/i82092.c                         |    1 
 drivers/scsi/sr.c                               |    2 
 drivers/tty/serial/8250/8250_port.c             |   12 ++++-
 drivers/usb/class/usbtmc.c                      |    8 ---
 drivers/usb/common/usb-otg-fsm.c                |    6 ++
 drivers/usb/host/ehci-pci.c                     |    3 +
 drivers/usb/serial/ch341.c                      |    1 
 drivers/usb/serial/ftdi_sio.c                   |    1 
 drivers/usb/serial/ftdi_sio_ids.h               |    3 +
 drivers/usb/serial/option.c                     |    2 
 fs/namespace.c                                  |   42 +++++++++++++-------
 fs/pipe.c                                       |   19 ++++++++-
 fs/reiserfs/stree.c                             |   31 ++++++++++++---
 fs/reiserfs/super.c                             |    8 +++
 include/linux/usb/otg-fsm.h                     |    1 
 include/net/bluetooth/hci_core.h                |    1 
 net/bluetooth/hci_core.c                        |   16 +++----
 net/bluetooth/hci_sock.c                        |   49 ++++++++++++++++--------
 net/bluetooth/hci_sysfs.c                       |    3 +
 scripts/tracing/draw_functrace.py               |    6 +-
 sound/core/seq/seq_ports.c                      |   39 +++++++++++++------
 36 files changed, 249 insertions(+), 104 deletions(-)

Alex Xu (Hello71) (1):
      pipe: increase minimum default pipe size to 2 pages

Dan Carpenter (1):
      bnx2x: fix an error code in bnx2x_nic_load()

Daniele Palmas (1):
      USB: serial: option: add Telit FD980 composition 0x1056

David Bauer (1):
      USB: serial: ftdi_sio: add device ID for Auto-M3 OP-COM v2

Dmitry Osipenko (1):
      usb: otg-fsm: Fix hrtimer list corruption

Greg Kroah-Hartman (1):
      Linux 4.9.280

H. Nikolaus Schaller (1):
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

Miklos Szeredi (1):
      ovl: prevent private clone if bind mount is not allowed

Pali Rohár (1):
      ppp: Fix generating ppp unit id when ifname is not specified

Pavel Skripkin (3):
      net: pegasus: fix uninit-value in get_interrupt_interval
      net: fec: fix use-after-free in fec_drv_remove
      net: vxge: fix use-after-free in vxge_device_unregister

Prarit Bhargava (1):
      alpha: Send stop IPI to send to online CPUs

Qiang.zhang (1):
      USB: usbtmc: Fix RCU stall warning

Shreyansh Chouhan (1):
      reiserfs: check directory items on read from disk

Takashi Iwai (1):
      ALSA: seq: Fix racy deletion of subscriber

Tetsuo Handa (1):
      Bluetooth: defer cleanup of resources in hci_unregister_dev()

Wang Hai (1):
      net: natsemi: Fix missing pci_disable_device() in probe and remove

Willy Tarreau (1):
      USB: serial: ch341: fix character loss at high transfer rates

Yu Kuai (1):
      reiserfs: add check for root_inode in reiserfs_fill_super

YueHaibing (1):
      net: xilinx_emaclite: Do not print real IOMEM pointer

Zheyu Ma (1):
      pcmcia: i82092: fix a null pointer dereference bug

