Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B279855F8A6
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 09:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiF2HQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 03:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiF2HQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 03:16:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0ED433890;
        Wed, 29 Jun 2022 00:16:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B48C61B4D;
        Wed, 29 Jun 2022 07:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23806C34114;
        Wed, 29 Jun 2022 07:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656487016;
        bh=BJGEUxs+eowjxLcuCAMavPjidE7iTv+YDJEssZ0S0xE=;
        h=From:To:Cc:Subject:Date:From;
        b=dV8k6gozrluf3u/tzS+3AkM6zAG7Kf41mLJj6iUjYJT9oOA6McASiBJDbWcheV+HU
         EfqqYFuZ8cd1FX4BtaCxr3wGryh/a9nCaBm4HEYgxLwNdCby9ERoSzFw151zXVffK0
         LydsU0sLe+KUttB0nGxU69wbNy/25ZQg/tVD+2uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.202
Date:   Wed, 29 Jun 2022 09:16:52 +0200
Message-Id: <165648701319366@kroah.com>
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

I'm announcing the release of the 5.4.202 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
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
 arch/parisc/Kconfig                           |    1 
 arch/powerpc/kernel/process.c                 |    2 
 arch/powerpc/kernel/rtas.c                    |   11 +
 arch/powerpc/platforms/powernv/powernv.h      |    2 
 arch/powerpc/platforms/powernv/rng.c          |   52 ++++++---
 arch/powerpc/platforms/powernv/setup.c        |    2 
 arch/powerpc/platforms/pseries/pseries.h      |    2 
 arch/powerpc/platforms/pseries/rng.c          |   11 -
 arch/powerpc/platforms/pseries/setup.c        |    2 
 arch/s390/kernel/perf_cpum_cf.c               |   22 +++
 arch/xtensa/kernel/time.c                     |    1 
 arch/xtensa/platforms/xtfpga/setup.c          |    1 
 drivers/base/regmap/regmap-irq.c              |    5 
 drivers/char/random.c                         |    6 -
 drivers/dma-buf/udmabuf.c                     |    5 
 drivers/gpio/gpio-vr41xx.c                    |    2 
 drivers/gpio/gpio-winbond.c                   |    7 -
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c      |    2 
 drivers/iio/accel/bma180.c                    |    3 
 drivers/iio/accel/mma8452.c                   |   10 +
 drivers/iio/accel/mxc4005.c                   |    4 
 drivers/iio/adc/axp288_adc.c                  |    8 +
 drivers/iio/adc/stm32-adc-core.c              |    2 
 drivers/iio/chemical/ccs811.c                 |    4 
 drivers/iio/gyro/mpu3050-core.c               |    1 
 drivers/iio/trigger/iio-trig-sysfs.c          |    1 
 drivers/md/dm-era-target.c                    |    8 +
 drivers/md/dm-log.c                           |    2 
 drivers/mmc/host/sdhci-pci-o2micro.c          |    2 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c    |    2 
 drivers/net/bonding/bond_main.c               |    4 
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   39 ++++++
 drivers/net/ethernet/intel/igb/igb_main.c     |   12 --
 drivers/net/phy/aquantia_main.c               |   15 ++
 drivers/net/virtio_net.c                      |   25 +---
 drivers/soc/bcm/brcmstb/pm/pm-arm.c           |    1 
 drivers/tty/vt/vt.c                           |   39 ------
 drivers/tty/vt/vt_ioctl.c                     |  147 --------------------------
 drivers/usb/chipidea/udc.c                    |    3 
 drivers/usb/host/xhci-hub.c                   |    2 
 drivers/usb/host/xhci.c                       |   15 ++
 drivers/usb/host/xhci.h                       |    2 
 drivers/usb/serial/option.c                   |    6 +
 drivers/xen/features.c                        |    2 
 fs/afs/inode.c                                |    3 
 include/linux/kd.h                            |    8 -
 include/linux/ratelimit.h                     |   12 +-
 include/trace/events/libata.h                 |    1 
 net/core/filter.c                             |   34 ++++--
 net/ipv4/ip_gre.c                             |   15 +-
 net/ipv6/ip6_gre.c                            |   15 +-
 net/openvswitch/flow.c                        |    2 
 net/sched/sch_netem.c                         |    4 
 scripts/mod/modpost.c                         |    2 
 sound/pci/hda/patch_conexant.c                |    4 
 sound/pci/hda/patch_realtek.c                 |   10 +
 sound/pci/hda/patch_via.c                     |    4 
 64 files changed, 314 insertions(+), 309 deletions(-)

Aidan MacDonald (1):
      regmap-irq: Fix a bug in regmap_irq_enable() for type_in_mask chips

Anatolii Gerasymenko (1):
      ice: ethtool: advertise 1000M speeds properly

Andrew Donnellan (1):
      powerpc/rtas: Allow ibm,platform-dump RTAS call with null buffer address

Baruch Siach (1):
      iio: adc: vf610: fix conversion mode sysfs node name

Carlo Lobrano (1):
      USB: serial: option: add Telit LE910Cx 0x1250 composition

Chevron Li (1):
      mmc: sdhci-pci-o2micro: Fix card detect by dealing with debouncing

Claudiu Manoil (1):
      phy: aquantia: Fix AN when higher speeds than 1G are not advertised

Dan Carpenter (1):
      gpio: winbond: Fix error code in winbond_gpio_get()

David Howells (1):
      afs: Fix dynamic root getattr

Dmitry Rokosov (3):
      iio:chemical:ccs811: rearrange iio trigger get and register
      iio:accel:bma180: rearrange iio trigger get and register
      iio:accel:mxc4005: rearrange iio trigger get and register

Edward Wu (1):
      ata: libata: add qc->flags in ata_qc_complete_template tracepoint

Eric Dumazet (1):
      erspan: do not assume transport header is always set

Gerd Hoffmann (1):
      udmabuf: add back sanity check

Greg Kroah-Hartman (1):
      Linux 5.4.202

Haibo Chen (1):
      iio: accel: mma8452: ignore the return value of reset operation

Hans de Goede (1):
      iio: adc: axp288: Override TS pin bias current for some models

Helge Deller (1):
      parisc: Enable ARCH_HAS_STRICT_MODULE_RWX

Jakub Kicinski (1):
      Revert "net/tls: fix tls_sk_proto_close executed repeatedly"

Jason A. Donenfeld (5):
      random: schedule mix_interrupt_randomness() less often
      random: quiet urandom warning ratelimit suppression message
      powerpc/powernv: wire up rng during setup_arch
      random: update comment from copy_to_user() -> copy_to_iter()
      powerpc/pseries: wire up rng during setup_arch()

Jay Vosburgh (1):
      bonding: ARP monitor spams NETDEV_NOTIFY_PEERS notifiers

Jiri Slaby (1):
      vt: drop old FONT ioctls

Jon Maxwell (1):
      bpf: Fix request_sock leak in sk lookup helpers

Julien Grall (1):
      x86/xen: Remove undefined behavior in setup_features()

Kai-Heng Feng (1):
      igb: Make DMA faster when CPU is active on the PCIe link

Kailang Yang (1):
      ALSA: hda/realtek - ALC897 headset MIC no sound

Liang He (2):
      xtensa: xtfpga: Fix refcount leak bug in setup
      xtensa: Fix refcount leak bug in time.c

Lucas Stach (1):
      ARM: dts: imx6qdl: correct PU regulator ramp delay

Macpaul Lin (1):
      USB: serial: option: add Quectel RM500K module support

Masahiro Yamada (2):
      modpost: fix section mismatch check for exported init/exit sections
      kbuild: link vmlinux only once for CONFIG_TRIM_UNUSED_KSYMS (2nd attempt)

Mathias Nyman (1):
      xhci: turn off port power in shutdown

Miaoqian Lin (5):
      drm/msm/mdp4: Fix refcount leak in mdp4_modeset_init_intf
      ARM: exynos: Fix refcount leak in exynos_map_pmu
      soc: bcm: brcmstb: pm: pm-arm: Fix refcount leak in brcmstb_pm_probe
      ARM: Fix refcount leak in axxia_boot_secondary
      ARM: cns3xxx: Fix refcount leak in cns3xxx_init

Mikulas Patocka (1):
      dm mirror log: clear log bits up to BITS_PER_LONG boundary

Naveen N. Rao (1):
      powerpc: Enable execve syscall exit tracepoint

Nikos Tsironis (1):
      dm era: commit metadata in postsuspend after worker stops

Olivier Moysan (1):
      iio: adc: stm32: fix maximum clock rate for stm32mp15x

Peilin Ye (1):
      net/sched: sch_netem: Fix arithmetic in netem_dump() for 32-bit platforms

Rosemarie O'Riorden (1):
      net: openvswitch: fix parsing of nw_proto for IPv6 fragments

Sascha Hauer (1):
      mtd: rawnand: gpmi: Fix setting busy timeout setting

Stephan Gerhold (1):
      virtio_net: fix xdp_rxq_info bug after suspend/resume

Takashi Iwai (2):
      ALSA: hda/via: Fix missing beep setup
      ALSA: hda/conexant: Fix missing beep setup

Thomas Richter (1):
      s390/cpumf: Handle events cycles and instructions identical

Tim Crawford (1):
      ALSA: hda/realtek: Add quirk for Clevo PD70PNT

Vincent Whitchurch (1):
      iio: trigger: sysfs: fix use-after-free on remove

Xu Yang (1):
      usb: chipidea: udc: check request status before setting device address

Yonglin Tan (1):
      USB: serial: option: add Quectel EM05-G modem

Zheyu Ma (1):
      iio: gyro: mpu3050: Fix the error handling in mpu3050_power_up()

Ziyang Xuan (1):
      net/tls: fix tls_sk_proto_close executed repeatedly

huhai (1):
      MIPS: Remove repetitive increase irq_err_count

