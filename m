Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202545640C6
	for <lists+stable@lfdr.de>; Sat,  2 Jul 2022 16:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiGBOim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 10:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbiGBOii (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 10:38:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8A1FD26;
        Sat,  2 Jul 2022 07:38:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADEFFB82AE6;
        Sat,  2 Jul 2022 14:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7D1C341C7;
        Sat,  2 Jul 2022 14:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656772710;
        bh=M5d6vZmGIGwK1Z3Sx7+59Y917aBV3RcXS4jRxyHSlwA=;
        h=From:To:Cc:Subject:Date:From;
        b=xMRKIrdoodjzA/+vY21dNg7iHJaFvCQTqU3SlZOPrYCrH+chYexR/w25TyFzLyG6Y
         16382YcOTCXEDCSV15LRrrGsqeAHoGUwYmWpeKsdW9PSKSZJBtqwxFSJZhNMK+K8mz
         yJT8Bxu8OZafNoUtjhmlvDvA19rmsPNF8UYq1kYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.250
Date:   Sat,  2 Jul 2022 16:38:18 +0200
Message-Id: <1656772698234219@kroah.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.250 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-iio-vf610 |    2 
 Makefile                                      |    4 
 arch/arm/boot/dts/imx6qdl.dtsi                |    2 
 arch/arm/mach-axxia/platsmp.c                 |    1 
 arch/arm/mach-cns3xxx/core.c                  |    2 
 arch/arm/mach-exynos/exynos.c                 |    1 
 arch/mips/vr41xx/common/icu.c                 |    2 
 arch/powerpc/kernel/process.c                 |    2 
 arch/powerpc/kernel/rtas.c                    |   11 +
 arch/powerpc/platforms/powernv/powernv.h      |    2 
 arch/powerpc/platforms/powernv/rng.c          |   52 ++++++---
 arch/powerpc/platforms/powernv/setup.c        |    2 
 arch/powerpc/platforms/pseries/pseries.h      |    2 
 arch/powerpc/platforms/pseries/rng.c          |   11 -
 arch/powerpc/platforms/pseries/setup.c        |    1 
 arch/s390/include/asm/kexec.h                 |   10 +
 arch/x86/include/asm/kexec.h                  |    9 +
 arch/xtensa/kernel/time.c                     |    1 
 arch/xtensa/platforms/xtfpga/setup.c          |    1 
 drivers/char/random.c                         |    4 
 drivers/gpio/gpio-vr41xx.c                    |    2 
 drivers/gpio/gpio-winbond.c                   |    7 -
 drivers/gpu/drm/drm_crtc_helper_internal.h    |   10 -
 drivers/gpu/drm/drm_fb_helper.c               |   21 ---
 drivers/gpu/drm/drm_kms_helper_common.c       |   25 ++--
 drivers/iio/accel/bma180.c                    |    3 
 drivers/iio/accel/mma8452.c                   |   10 +
 drivers/iio/adc/axp288_adc.c                  |    8 +
 drivers/iio/chemical/ccs811.c                 |    4 
 drivers/iio/gyro/mpu3050-core.c               |    1 
 drivers/iio/trigger/iio-trig-sysfs.c          |    1 
 drivers/md/dm-era-target.c                    |    8 +
 drivers/net/bonding/bond_main.c               |    4 
 drivers/net/ethernet/intel/igb/igb_main.c     |   12 --
 drivers/net/ethernet/mscc/ocelot.c            |    8 +
 drivers/net/virtio_net.c                      |   25 +---
 drivers/of/fdt.c                              |    8 +
 drivers/soc/bcm/brcmstb/pm/pm-arm.c           |    1 
 drivers/tty/vt/vt.c                           |   39 ------
 drivers/tty/vt/vt_ioctl.c                     |  149 --------------------------
 drivers/usb/chipidea/udc.c                    |    3 
 drivers/usb/host/xhci-hub.c                   |    2 
 drivers/usb/host/xhci.c                       |   15 ++
 drivers/usb/host/xhci.h                       |    2 
 drivers/usb/serial/option.c                   |    6 +
 drivers/xen/features.c                        |    2 
 drivers/xen/xlate_mmu.c                       |    1 
 fs/afs/inode.c                                |    3 
 include/linux/kd.h                            |    8 -
 include/linux/kexec.h                         |   46 ++++++--
 include/linux/ratelimit.h                     |   12 +-
 include/trace/events/libata.h                 |    1 
 kernel/dma/swiotlb.c                          |    3 
 kernel/kexec_file.c                           |   34 -----
 net/ipv4/ip_gre.c                             |   15 +-
 net/ipv6/ip6_gre.c                            |   15 +-
 net/sched/sch_generic.c                       |    5 
 net/sched/sch_netem.c                         |    4 
 scripts/mod/modpost.c                         |    2 
 sound/pci/hda/patch_conexant.c                |    4 
 sound/pci/hda/patch_realtek.c                 |    1 
 sound/pci/hda/patch_via.c                     |    4 
 62 files changed, 270 insertions(+), 386 deletions(-)

Andrew Donnellan (1):
      powerpc/rtas: Allow ibm,platform-dump RTAS call with null buffer address

Baruch Siach (1):
      iio: adc: vf610: fix conversion mode sysfs node name

Carlo Lobrano (1):
      USB: serial: option: add Telit LE910Cx 0x1250 composition

Christoph Hellwig (1):
      drm: remove drm_fb_helper_modinit

Dan Carpenter (1):
      gpio: winbond: Fix error code in winbond_gpio_get()

David Howells (1):
      afs: Fix dynamic root getattr

Diederik de Haas (1):
      net/sched: move NULL ptr check to qdisc_put() too

Dmitry Rokosov (2):
      iio:chemical:ccs811: rearrange iio trigger get and register
      iio:accel:bma180: rearrange iio trigger get and register

Edward Wu (1):
      ata: libata: add qc->flags in ata_qc_complete_template tracepoint

Eric Dumazet (1):
      erspan: do not assume transport header is always set

Greg Kroah-Hartman (1):
      Linux 4.19.250

Haibo Chen (1):
      iio: accel: mma8452: ignore the return value of reset operation

Hans de Goede (1):
      iio: adc: axp288: Override TS pin bias current for some models

Hsin-Yi Wang (1):
      fdt: Update CRC check for rng-seed

Jason A. Donenfeld (4):
      random: schedule mix_interrupt_randomness() less often
      random: quiet urandom warning ratelimit suppression message
      powerpc/powernv: wire up rng during setup_arch
      powerpc/pseries: wire up rng during setup_arch()

Jay Vosburgh (1):
      bonding: ARP monitor spams NETDEV_NOTIFY_PEERS notifiers

Jiri Slaby (1):
      vt: drop old FONT ioctls

Julien Grall (1):
      x86/xen: Remove undefined behavior in setup_features()

Kai-Heng Feng (1):
      igb: Make DMA faster when CPU is active on the PCIe link

Liang He (2):
      xtensa: xtfpga: Fix refcount leak bug in setup
      xtensa: Fix refcount leak bug in time.c

Liu Shixin (1):
      swiotlb: skip swiotlb_bounce when orig_addr is zero

Lucas Stach (1):
      ARM: dts: imx6qdl: correct PU regulator ramp delay

Macpaul Lin (1):
      USB: serial: option: add Quectel RM500K module support

Masahiro Yamada (3):
      modpost: fix section mismatch check for exported init/exit sections
      kbuild: link vmlinux only once for CONFIG_TRIM_UNUSED_KSYMS (2nd attempt)
      xen: unexport __init-annotated xen_xlate_map_ballooned_pages()

Mathias Nyman (1):
      xhci: turn off port power in shutdown

Miaoqian Lin (4):
      ARM: exynos: Fix refcount leak in exynos_map_pmu
      soc: bcm: brcmstb: pm: pm-arm: Fix refcount leak in brcmstb_pm_probe
      ARM: Fix refcount leak in axxia_boot_secondary
      ARM: cns3xxx: Fix refcount leak in cns3xxx_init

Naveen N. Rao (2):
      powerpc: Enable execve syscall exit tracepoint
      kexec_file: drop weak attribute from arch_kexec_apply_relocations[_add]

Nikos Tsironis (1):
      dm era: commit metadata in postsuspend after worker stops

Peilin Ye (1):
      net/sched: sch_netem: Fix arithmetic in netem_dump() for 32-bit platforms

Stephan Gerhold (1):
      virtio_net: fix xdp_rxq_info bug after suspend/resume

Takashi Iwai (2):
      ALSA: hda/via: Fix missing beep setup
      ALSA: hda/conexant: Fix missing beep setup

Tim Crawford (1):
      ALSA: hda/realtek: Add quirk for Clevo PD70PNT

Vincent Whitchurch (1):
      iio: trigger: sysfs: fix use-after-free on remove

Vladimir Oltean (1):
      net: mscc: ocelot: allow unregistered IP multicast flooding

Xu Yang (1):
      usb: chipidea: udc: check request status before setting device address

Yonglin Tan (1):
      USB: serial: option: add Quectel EM05-G modem

Zheyu Ma (1):
      iio: gyro: mpu3050: Fix the error handling in mpu3050_power_up()

huhai (1):
      MIPS: Remove repetitive increase irq_err_count

