Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AE22D7960
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731349AbgLKP34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:29:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389590AbgLKP32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 10:29:28 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.248
Date:   Fri, 11 Dec 2020 15:12:42 +0100
Message-Id: <1607695961254222@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.248 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/nfc/nxp-nci.txt |    2 
 Documentation/devicetree/bindings/net/nfc/pn544.txt   |    2 
 Makefile                                              |    2 
 arch/arm64/include/asm/assembler.h                    |   36 +++++++---
 arch/arm64/kernel/head.S                              |    3 
 arch/powerpc/lib/ppc_ksyms.c                          |    1 
 arch/x86/include/asm/insn.h                           |   15 ++++
 arch/x86/kernel/uprobes.c                             |   10 +-
 drivers/i2c/busses/i2c-imx.c                          |   30 +++++++-
 drivers/input/joystick/xpad.c                         |    2 
 drivers/input/serio/i8042-x86ia64io.h                 |    4 +
 drivers/input/serio/i8042.c                           |    3 
 drivers/iommu/amd_iommu.c                             |    2 
 drivers/net/bonding/bond_main.c                       |   61 ++++++++++++------
 drivers/net/bonding/bond_sysfs_slave.c                |   18 -----
 drivers/net/ethernet/chelsio/cxgb3/sge.c              |    1 
 drivers/net/ethernet/pasemi/pasemi_mac.c              |    8 +-
 drivers/net/usb/ipheth.c                              |    2 
 drivers/spi/spi-bcm2835.c                             |   22 ++----
 drivers/spi/spi.c                                     |   54 +++++++++++++++
 drivers/tty/tty_io.c                                  |   51 ++++++++++-----
 drivers/usb/gadget/function/f_fs.c                    |    6 +
 drivers/usb/serial/ch341.c                            |    5 -
 drivers/usb/serial/kl5kusb105.c                       |   10 +-
 drivers/usb/serial/option.c                           |    5 +
 fs/btrfs/ctree.c                                      |    6 +
 fs/btrfs/volumes.c                                    |    7 +-
 fs/cifs/connect.c                                     |    2 
 fs/gfs2/rgrp.c                                        |    4 +
 include/linux/if_vlan.h                               |   29 ++++++--
 include/linux/spi/spi.h                               |    2 
 include/linux/tty.h                                   |    4 +
 include/net/bonding.h                                 |    8 ++
 include/net/inet_ecn.h                                |    1 
 kernel/trace/trace.c                                  |    9 +-
 kernel/trace/trace.h                                  |    6 +
 mm/huge_memory.c                                      |    8 --
 net/bridge/br_netfilter_hooks.c                       |    7 +-
 net/iucv/af_iucv.c                                    |    4 -
 net/rose/rose_loopback.c                              |   17 +++--
 net/x25/af_x25.c                                      |    6 +
 sound/pci/hda/hda_generic.c                           |   12 ++-
 sound/pci/hda/hda_generic.h                           |    1 
 sound/pci/hda/patch_realtek.c                         |    2 
 44 files changed, 353 insertions(+), 137 deletions(-)

Anmol Karn (1):
      rose: Fix Null pointer dereference in rose_send_frame()

Antoine Tenart (1):
      netfilter: bridge: reset skb->pkt_type after NF_INET_POST_ROUTING traversal

Ard Biesheuvel (1):
      arm64: assembler: make adr_l work in modules under KASLR

Bob Peterson (1):
      gfs2: check for empty rgrp tree in gfs2_ri_update

Christian Eggers (2):
      i2c: imx: Fix reset of I2SR_IAL flag
      i2c: imx: Check for I2SR_IAL after every byte

Dan Carpenter (1):
      net/x25: prevent a couple of overflows

Gerald Schaefer (1):
      mm/userfaultfd: do not access vma->vm_mm after calling handle_userfault()

Giacinto Cifelli (1):
      USB: serial: option: add support for Thales Cinterion EXS82

Greg Kroah-Hartman (1):
      Linux 4.4.248

Jamie Iles (1):
      bonding: wait for sysfs kobject destruction before freeing struct slave

Jan-Niklas Burfeind (1):
      USB: serial: ch341: add new Product ID for CH341A

Jann Horn (2):
      tty: Fix ->pgrp locking in tiocspgrp()
      tty: Fix ->session locking

Johan Hovold (2):
      USB: serial: kl5kusb105: fix memleak on open
      USB: serial: ch341: sort device-id entries

Josef Bacik (2):
      btrfs: sysfs: init devices outside of the chunk_mutex
      btrfs: cleanup cow block on error

Julian Wiedmann (1):
      net/af_iucv: set correct sk_protocol for child sockets

Kailang Yang (1):
      ALSA: hda/realtek - Add new codec supported for ALC897

Krzysztof Kozlowski (1):
      dt-bindings: net: correct interrupt flags in examples

Lukas Wunner (2):
      spi: Introduce device-managed SPI controller allocation
      spi: bcm2835: Fix use-after-free on unbind

Luo Meng (1):
      Input: i8042 - fix error return code in i8042_setup_aux()

Masami Hiramatsu (1):
      x86/uprobes: Do not use prefixes.nbytes when looping over prefixes.bytes

Michal Suchanek (1):
      powerpc: Stop exporting __clear_user which is now inlined.

Paulo Alcantara (1):
      cifs: fix potential use-after-free in cifs_echo_request()

Peter Ujfalusi (1):
      spi: bcm2835: Release the DMA channel if probe fails after dma_init

Po-Hsu Lin (1):
      Input: i8042 - add ByteSpeed touchpad to noloop table

Sanjay Govind (1):
      Input: xpad - support Ardwiino Controllers

Steven Rostedt (VMware) (1):
      tracing: Fix userstacktrace option for instances

Suravee Suthikulpanit (1):
      iommu/amd: Set DTE[IntTabLen] to represent 512 IRTEs

Takashi Iwai (1):
      ALSA: hda/generic: Add option to enforce preferred_dacs pairs

Toke Høiland-Jørgensen (1):
      vlan: consolidate VLAN parsing code and limit max parsing depth

Vamsi Krishna Samavedam (1):
      usb: gadget: f_fs: Use local copy of descriptors for userspace copy

Vincent Palatin (1):
      USB: serial: option: add Fibocom NL668 variants

Yves-Alexis Perez (1):
      usbnet: ipheth: fix connectivity with iOS 14

Zhang Changzhong (2):
      cxgb3: fix error return code in t3_sge_alloc_qset()
      net: pasemi: fix error return code in pasemi_mac_open()

