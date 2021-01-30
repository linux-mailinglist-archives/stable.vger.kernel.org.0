Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A3C3095BC
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 15:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhA3OKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 09:10:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229763AbhA3OKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 09:10:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E006A61481;
        Sat, 30 Jan 2021 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612015811;
        bh=Vyo429r/5ZLCTm3U2V3TB5WpAYdshIEnAksuz3T896M=;
        h=From:To:Cc:Subject:Date:From;
        b=WtojH1uMTlh+t8WMnI5EekhIG2PJmUS0GwUah+XoRl/BThvJu4594dRKkD8DW9C51
         58OfXL0ZwpzMKtnLloRK9A8yi34pFVH5CLKpVLdVHPxRBAzHJU7r5UDcNLN0ivCJMC
         hFwTd/3tuoVrx5zXccq5nCkxLrveTbiCdCpzzXDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.254
Date:   Sat, 30 Jan 2021 15:10:07 +0100
Message-Id: <1612015807198144@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.254 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 +-
 arch/sh/drivers/dma/Kconfig                        |    3 +--
 arch/x86/boot/compressed/Makefile                  |    2 ++
 drivers/acpi/scan.c                                |    2 ++
 drivers/block/xen-blkback/xenbus.c                 |    1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c  |    2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm204.c |    8 ++++----
 drivers/iio/dac/ad5504.c                           |    4 ++--
 drivers/md/dm-table.c                              |   15 ++++++++++++---
 drivers/net/can/dev.c                              |    4 ++--
 drivers/net/ethernet/renesas/sh_eth.c              |    4 ++--
 drivers/scsi/ufs/ufshcd.c                          |   11 ++++-------
 drivers/usb/gadget/udc/bdc/Kconfig                 |    2 +-
 drivers/usb/host/ehci-hcd.c                        |   12 ++++++++++++
 drivers/usb/host/xhci-ring.c                       |    2 ++
 include/linux/compiler-gcc.h                       |    6 ++++++
 kernel/trace/ring_buffer.c                         |    4 ++++
 mm/slub.c                                          |    4 +---
 net/core/skbuff.c                                  |    6 +++++-
 net/ipv4/netfilter/ipt_rpfilter.c                  |    2 +-
 net/ipv6/addrconf.c                                |    1 +
 net/sched/cls_tcindex.c                            |    8 ++++++--
 sound/core/seq/oss/seq_oss_synth.c                 |    3 ++-
 sound/pci/hda/patch_via.c                          |    1 +
 sound/soc/intel/boards/haswell.c                   |    1 +
 25 files changed, 77 insertions(+), 33 deletions(-)

Alexander Lobakin (1):
      skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too

Arvind Sankar (1):
      x86/boot/compressed: Disable relocation relaxation

Ben Skeggs (2):
      drm/nouveau/bios: fix issue shadowing expansion ROMs
      drm/nouveau/i2c/gm200: increase width of aux semaphore owner fields

Can Guo (1):
      scsi: ufs: Correct the LUN used in eh_device_reset_handler() callback

Cezary Rojewski (1):
      ASoC: Intel: haswell: Add missing pm_ops

Eric Dumazet (1):
      net_sched: avoid shift-out-of-bounds in tcindex_set_parms()

Eugene Korenevsky (1):
      ehci: fix EHCI host controller initialization sequence

Gaurav Kohli (1):
      tracing: Fix race in trace_open and buffer resize call

Geert Uytterhoeven (1):
      sh_eth: Fix power down vs. is_opened flag ordering

Greg Kroah-Hartman (1):
      Linux 4.4.254

Guillaume Nault (1):
      netfilter: rpfilter: mask ecn bits before fib lookup

Hannes Reinecke (1):
      dm: avoid filesystem lookup in dm_get_dev_t()

Hans de Goede (1):
      ACPI: scan: Make acpi_bus_get_device() clear return pointer on error

Lars-Peter Clausen (1):
      iio: ad5504: Fix setting power-down state

Mathias Nyman (1):
      xhci: make sure TRB is fully written before giving it to the controller

Matteo Croce (1):
      ipv6: create multicast route with RTPROT_KERNEL

Necip Fazil Yildiran (1):
      sh: dma: fix kconfig dependency for G2_DMA

Patrik Jakobsson (1):
      usb: bdc: Make bdc pci driver depend on BROKEN

Pawel Wieczorkiewicz (1):
      xen-blkback: set ring->xenblkd to NULL after kthread_stop()

Takashi Iwai (2):
      ALSA: seq: oss: Fix missing error check in snd_seq_oss_synth_make_info()
      ALSA: hda/via: Add minimum mute flag

Vincent Mailhol (1):
      can: dev: can_restart: fix use after free bug

Wang Hai (1):
      Revert "mm/slub: fix a memory leak in sysfs_slab_add()"

Will Deacon (1):
      compiler.h: Raise minimum version of GCC to 5.1 for arm64

