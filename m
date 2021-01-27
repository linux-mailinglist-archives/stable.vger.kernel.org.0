Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2105305964
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 12:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbhA0LQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 06:16:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236177AbhA0KsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 05:48:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D1692076D;
        Wed, 27 Jan 2021 10:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611744437;
        bh=91TJ70sGN31M6K9znkuCjasmtjIEGTYIM+T8aaJa2Ec=;
        h=From:To:Cc:Subject:Date:From;
        b=qlnNxPjN3WBX2uN/d7aGV71dNTFUlBaWzfgteCI+LZhIp9r36UFZxEf3HSJYjSVqA
         18u+2DB42n/VOYByzh/tXHsxXbjcgE3F4JXmjhox7uy0hkrLiYD1gZTtywxiPFEG6x
         heS65c/sL4GLBsQZ6KWmcv8YaQjzqqSgeZS+lT04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.171
Date:   Wed, 27 Jan 2021 11:47:13 +0100
Message-Id: <16117444335135@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.171 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm/xen/enlighten.c                           |    2 
 arch/riscv/kernel/time.c                           |    3 
 arch/sh/drivers/dma/Kconfig                        |    3 
 drivers/acpi/scan.c                                |    2 
 drivers/base/core.c                                |   17 ++++
 drivers/clk/tegra/clk-tegra30.c                    |    2 
 drivers/gpu/drm/drm_atomic_helper.c                |    2 
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |    4 -
 drivers/gpu/drm/nouveau/dispnv50/disp.h            |    2 
 drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c        |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c  |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c |    8 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gf100.c   |   10 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gk104.c   |   10 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/base.c     |    6 -
 drivers/hid/hid-ids.h                              |    1 
 drivers/hid/hid-input.c                            |    2 
 drivers/hwtracing/intel_th/pci.c                   |    5 +
 drivers/hwtracing/stm/heartbeat.c                  |    6 +
 drivers/i2c/busses/i2c-octeon-core.c               |    2 
 drivers/i2c/busses/i2c-tegra-bpmp.c                |    2 
 drivers/iio/dac/ad5504.c                           |    4 -
 drivers/irqchip/irq-mips-cpu.c                     |    7 +
 drivers/md/dm-integrity.c                          |    6 +
 drivers/md/dm-table.c                              |   15 +++
 drivers/mmc/core/queue.c                           |    4 -
 drivers/mmc/host/sdhci-xenon.c                     |    7 +
 drivers/net/can/dev.c                              |    4 -
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |    8 +-
 drivers/net/can/vxcan.c                            |    6 +
 drivers/net/dsa/b53/b53_common.c                   |    2 
 drivers/net/ethernet/mscc/ocelot.c                 |    4 -
 drivers/net/ethernet/renesas/sh_eth.c              |    4 -
 drivers/platform/x86/intel-vbtn.c                  |    6 -
 drivers/scsi/megaraid/megaraid_sas_base.c          |    6 -
 drivers/scsi/qedi/qedi_main.c                      |    4 -
 drivers/scsi/ufs/ufshcd.c                          |   11 +-
 drivers/tty/serial/mvebu-uart.c                    |   10 ++
 drivers/usb/gadget/udc/aspeed-vhub/epn.c           |    5 +
 drivers/usb/gadget/udc/bdc/Kconfig                 |    2 
 drivers/usb/gadget/udc/core.c                      |   13 ++-
 drivers/usb/host/ehci-hcd.c                        |   12 +++
 drivers/usb/host/ehci-hub.c                        |    3 
 drivers/usb/host/xhci-ring.c                       |    2 
 drivers/usb/host/xhci-tegra.c                      |    7 +
 drivers/xen/events/events_base.c                   |   10 --
 drivers/xen/platform-pci.c                         |    1 
 drivers/xen/xenbus/xenbus.h                        |    1 
 drivers/xen/xenbus/xenbus_comms.c                  |    8 --
 drivers/xen/xenbus/xenbus_probe.c                  |   81 +++++++++++++++++----
 fs/btrfs/volumes.c                                 |    2 
 include/xen/xenbus.h                               |    2 
 mm/kasan/kasan_init.c                              |   23 +++--
 net/core/dev.c                                     |    5 +
 net/core/skbuff.c                                  |    6 +
 net/ipv4/netfilter/ipt_rpfilter.c                  |    2 
 net/ipv4/udp.c                                     |    3 
 net/ipv6/addrconf.c                                |    3 
 net/sched/cls_tcindex.c                            |    8 +-
 net/sched/sch_api.c                                |    3 
 sound/core/seq/oss/seq_oss_synth.c                 |    3 
 sound/pci/hda/patch_via.c                          |    1 
 sound/soc/intel/boards/haswell.c                   |    1 
 tools/testing/selftests/net/fib_tests.sh           |    1 
 65 files changed, 284 insertions(+), 127 deletions(-)

Alex Leibovich (1):
      mmc: sdhci-xenon: fix 1.8v regulator stabilization

Alexander Lobakin (1):
      skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too

Alexander Shishkin (1):
      intel_th: pci: Add Alder Lake-P support

Arnd Bergmann (1):
      scsi: megaraid_sas: Fix MEGASAS_IOC_FIRMWARE regression

Ben Skeggs (5):
      drm/nouveau/bios: fix issue shadowing expansion ROMs
      drm/nouveau/privring: ack interrupts the same way as RM
      drm/nouveau/i2c/gm200: increase width of aux semaphore owner fields
      drm/nouveau/mmu: fix vram heap sizing
      drm/nouveau/kms/nv50-: fix case where notifier buffer is at offset 0

Can Guo (1):
      scsi: ufs: Correct the LUN used in eh_device_reset_handler() callback

Cezary Rojewski (1):
      ASoC: Intel: haswell: Add missing pm_ops

Damien Le Moal (1):
      riscv: Fix kernel time_init()

Dan Carpenter (1):
      net: dsa: b53: fix an off by one in checking "vlan->vid"

David Woodhouse (1):
      xen: Fix event channel callback via INTX/GSI

Eric Dumazet (2):
      net_sched: avoid shift-out-of-bounds in tcindex_set_parms()
      net_sched: reject silly cell_log in qdisc_get_rtab()

Eugene Korenevsky (1):
      ehci: fix EHCI host controller initialization sequence

Geert Uytterhoeven (1):
      sh_eth: Fix power down vs. is_opened flag ordering

Greg Kroah-Hartman (1):
      Linux 4.19.171

Guillaume Nault (2):
      netfilter: rpfilter: mask ecn bits before fib lookup
      udp: mask TOS bits in udp_v4_early_demux()

Hangbin Liu (1):
      selftests: net: fib_tests: remove duplicate log test

Hannes Reinecke (1):
      dm: avoid filesystem lookup in dm_get_dev_t()

Hans de Goede (2):
      ACPI: scan: Make acpi_bus_get_device() clear return pointer on error
      platform/x86: intel-vbtn: Drop HP Stream x360 Convertible PC 11 from allow-list

JC Kuo (1):
      xhci: tegra: Delay for disabling LFPS detector

Josef Bacik (1):
      btrfs: fix lockdep splat in btrfs_recover_relocation

Lars-Peter Clausen (1):
      iio: ad5504: Fix setting power-down state

Lecopzer Chen (2):
      kasan: fix unaligned address is unhandled in kasan_remove_zero_shadow
      kasan: fix incorrect arguments passing in kasan_add_zero_shadow

Longfang Liu (1):
      USB: ehci: fix an interrupt calltrace error

Mathias Kresin (1):
      irqchip/mips-cpu: Set IPI domain parent chip

Mathias Nyman (1):
      xhci: make sure TRB is fully written before giving it to the controller

Matteo Croce (2):
      ipv6: create multicast route with RTPROT_KERNEL
      ipv6: set multicast flag on the multicast route

Mikko Perttunen (1):
      i2c: bpmp-tegra: Ignore unknown I2C_M flags

Mikulas Patocka (1):
      dm integrity: fix a crash if "recalculate" used without "internal_hash"

Necip Fazil Yildiran (1):
      sh: dma: fix kconfig dependency for G2_DMA

Nilesh Javali (1):
      scsi: qedi: Correct max length of CHAP secret

Pali Rohár (1):
      serial: mvebu-uart: fix tx lost characters at power off

Pan Bian (1):
      drm/atomic: put state on error path

Patrik Jakobsson (1):
      usb: bdc: Make bdc pci driver depend on BROKEN

Peter Collingbourne (1):
      mmc: core: don't initialize block size from ext_csd if not present

Peter Geis (1):
      clk: tegra30: Add hda clock default rates to clock driver

Rafael J. Wysocki (1):
      driver core: Extend device_is_dependent()

Ryan Chen (1):
      usb: gadget: aspeed: fix stop dma register setting.

Seth Miller (1):
      HID: Ignore battery for Elan touchscreen on ASUS UX550

Takashi Iwai (2):
      ALSA: seq: oss: Fix missing error check in snd_seq_oss_synth_make_info()
      ALSA: hda/via: Add minimum mute flag

Tariq Toukan (1):
      net: Disable NETIF_F_HW_TLS_RX when RXCSUM is disabled

Thinh Nguyen (1):
      usb: udc: core: Use lock when write to soft_connect

Vincent Mailhol (3):
      can: dev: can_restart: fix use after free bug
      can: vxcan: vxcan_xmit: fix use after free bug
      can: peak_usb: fix use after free bugs

Vladimir Oltean (1):
      net: mscc: ocelot: allow offloading of bridge on top of LAG

Wang Hui (1):
      stm class: Fix module init return on allocation failure

Wolfram Sang (1):
      i2c: octeon: check correct size of maximum RECV_LEN packet

