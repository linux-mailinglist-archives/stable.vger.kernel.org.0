Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5796F3095C6
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 15:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhA3OMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 09:12:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231620AbhA3OLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 09:11:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2228764E12;
        Sat, 30 Jan 2021 14:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612015829;
        bh=gOP5lLov7oMRasldvkNmC748gVMf19LsJDL0ctXBSSM=;
        h=From:To:Cc:Subject:Date:From;
        b=Nx5v9A+nuD9mLmmZBrI78HEh7KOa8OCZdhLsxdAW2vax4n+8178emDFvJ49in9M50
         G/u/va0t0bujS+R9CgtDQXhYJL6XwshDot/oCoVpUmD6eWMQldPjuOAfYrKfRn/oT9
         8opdxYGy6Ie860B/96WfUjwJD3dpCU84PEqh5xtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.218
Date:   Sat, 30 Jan 2021 15:10:17 +0100
Message-Id: <161201581729@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.218 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm/xen/enlighten.c                           |    2 
 arch/sh/drivers/dma/Kconfig                        |    3 
 arch/x86/boot/compressed/Makefile                  |    2 
 drivers/acpi/scan.c                                |    2 
 drivers/gpio/gpio-mvebu.c                          |   25 --
 drivers/gpu/drm/drm_atomic_helper.c                |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c  |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c |    8 
 drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gf100.c   |   10 
 drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gk104.c   |   10 
 drivers/hwtracing/intel_th/pci.c                   |    5 
 drivers/hwtracing/stm/heartbeat.c                  |    6 
 drivers/i2c/busses/i2c-octeon-core.c               |    2 
 drivers/i2c/busses/i2c-tegra-bpmp.c                |    2 
 drivers/iio/dac/ad5504.c                           |    4 
 drivers/irqchip/irq-mips-cpu.c                     |    7 
 drivers/md/dm-table.c                              |   15 +
 drivers/mmc/host/sdhci-xenon.c                     |    7 
 drivers/net/can/dev.c                              |    4 
 drivers/net/can/vxcan.c                            |    6 
 drivers/net/dsa/b53/b53_common.c                   |    2 
 drivers/net/ethernet/renesas/sh_eth.c              |    4 
 drivers/scsi/ufs/ufshcd.c                          |   11 -
 drivers/usb/gadget/udc/bdc/Kconfig                 |    2 
 drivers/usb/gadget/udc/core.c                      |   13 -
 drivers/usb/host/ehci-hcd.c                        |   12 +
 drivers/usb/host/ehci-hub.c                        |    3 
 drivers/usb/host/xhci-ring.c                       |    2 
 drivers/usb/host/xhci-tegra.c                      |    7 
 drivers/xen/events/events_base.c                   |   10 
 drivers/xen/platform-pci.c                         |    1 
 drivers/xen/xenbus/xenbus.h                        |    1 
 drivers/xen/xenbus/xenbus_comms.c                  |    8 
 drivers/xen/xenbus/xenbus_probe.c                  |   81 ++++++-
 fs/ext4/inode.c                                    |    6 
 fs/fs-writeback.c                                  |   43 +---
 fs/gfs2/super.c                                    |    2 
 include/linux/compiler-gcc.h                       |    6 
 include/linux/fs.h                                 |    4 
 include/trace/events/writeback.h                   |    1 
 include/xen/xenbus.h                               |    2 
 kernel/futex.c                                     |  223 +++++++++------------
 kernel/locking/rtmutex.c                           |    3 
 kernel/locking/rtmutex_common.h                    |    3 
 kernel/trace/ring_buffer.c                         |    4 
 mm/slub.c                                          |    4 
 net/core/skbuff.c                                  |    6 
 net/ipv4/netfilter/ipt_rpfilter.c                  |    2 
 net/ipv4/udp.c                                     |    3 
 net/ipv6/addrconf.c                                |    1 
 net/sched/cls_tcindex.c                            |    8 
 sound/core/seq/oss/seq_oss_synth.c                 |    3 
 sound/pci/hda/patch_via.c                          |    1 
 sound/soc/intel/boards/haswell.c                   |    1 
 55 files changed, 346 insertions(+), 263 deletions(-)

Alex Leibovich (1):
      mmc: sdhci-xenon: fix 1.8v regulator stabilization

Alexander Lobakin (1):
      skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too

Alexander Shishkin (1):
      intel_th: pci: Add Alder Lake-P support

Arvind Sankar (1):
      x86/boot/compressed: Disable relocation relaxation

Baruch Siach (1):
      gpio: mvebu: fix pwm .get_state period calculation

Ben Skeggs (3):
      drm/nouveau/bios: fix issue shadowing expansion ROMs
      drm/nouveau/privring: ack interrupts the same way as RM
      drm/nouveau/i2c/gm200: increase width of aux semaphore owner fields

Can Guo (1):
      scsi: ufs: Correct the LUN used in eh_device_reset_handler() callback

Cezary Rojewski (1):
      ASoC: Intel: haswell: Add missing pm_ops

Christoph Hellwig (1):
      fs: move I_DIRTY_INODE to fs.h

Dan Carpenter (1):
      net: dsa: b53: fix an off by one in checking "vlan->vid"

David Woodhouse (1):
      xen: Fix event channel callback via INTX/GSI

Eric Biggers (1):
      fs: fix lazytime expiration handling in __writeback_single_inode()

Eric Dumazet (1):
      net_sched: avoid shift-out-of-bounds in tcindex_set_parms()

Eugene Korenevsky (1):
      ehci: fix EHCI host controller initialization sequence

Gaurav Kohli (1):
      tracing: Fix race in trace_open and buffer resize call

Geert Uytterhoeven (1):
      sh_eth: Fix power down vs. is_opened flag ordering

Greg Kroah-Hartman (1):
      Linux 4.14.218

Guillaume Nault (2):
      netfilter: rpfilter: mask ecn bits before fib lookup
      udp: mask TOS bits in udp_v4_early_demux()

Hannes Reinecke (1):
      dm: avoid filesystem lookup in dm_get_dev_t()

Hans de Goede (1):
      ACPI: scan: Make acpi_bus_get_device() clear return pointer on error

JC Kuo (1):
      xhci: tegra: Delay for disabling LFPS detector

Jan Kara (1):
      writeback: Drop I_DIRTY_TIME_EXPIRE

Jiri Slaby (1):
      futex: futex_wake_op, fix sign_extend32 sign bits

Lars-Peter Clausen (1):
      iio: ad5504: Fix setting power-down state

Longfang Liu (1):
      USB: ehci: fix an interrupt calltrace error

Mathias Kresin (1):
      irqchip/mips-cpu: Set IPI domain parent chip

Mathias Nyman (1):
      xhci: make sure TRB is fully written before giving it to the controller

Matteo Croce (1):
      ipv6: create multicast route with RTPROT_KERNEL

Mikko Perttunen (1):
      i2c: bpmp-tegra: Ignore unknown I2C_M flags

Necip Fazil Yildiran (1):
      sh: dma: fix kconfig dependency for G2_DMA

Pan Bian (1):
      drm/atomic: put state on error path

Patrik Jakobsson (1):
      usb: bdc: Make bdc pci driver depend on BROKEN

Takashi Iwai (2):
      ALSA: seq: oss: Fix missing error check in snd_seq_oss_synth_make_info()
      ALSA: hda/via: Add minimum mute flag

Thinh Nguyen (1):
      usb: udc: core: Use lock when write to soft_connect

Thomas Gleixner (7):
      futex: Ensure the correct return value from futex_lock_pi()
      futex: Replace pointless printk in fixup_owner()
      futex: Provide and use pi_state_update_owner()
      rtmutex: Remove unused argument from rt_mutex_proxy_unlock()
      futex: Use pi_state_update_owner() in put_pi_state()
      futex: Simplify fixup_pi_state_owner()
      futex: Handle faults correctly for PI futexes

Vincent Mailhol (2):
      can: dev: can_restart: fix use after free bug
      can: vxcan: vxcan_xmit: fix use after free bug

Wang Hai (1):
      Revert "mm/slub: fix a memory leak in sysfs_slab_add()"

Wang Hui (1):
      stm class: Fix module init return on allocation failure

Will Deacon (1):
      compiler.h: Raise minimum version of GCC to 5.1 for arm64

Wolfram Sang (1):
      i2c: octeon: check correct size of maximum RECV_LEN packet

