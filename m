Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE5E55F8A2
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 09:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbiF2HRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 03:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiF2HRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 03:17:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51DC33A2A;
        Wed, 29 Jun 2022 00:17:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 830D5B821CC;
        Wed, 29 Jun 2022 07:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD90CC34114;
        Wed, 29 Jun 2022 07:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656487024;
        bh=jk4BCbAYOazMiS6DaGXAsveq+kZ/+SlY7TWm3XS1HSM=;
        h=From:To:Cc:Subject:Date:From;
        b=19PLR70AQ+TFv4tnYSfBTHUev8Ad0zmi30zypMox7gyB1n18HftAOGCWtsUmK5w+K
         v9OT8QOCz2wNEW4XQl3HvHam/ghjMiuGbbhDAyuuPqRpJYLWVAYEmzyNFmMwM3pwqL
         zAMafux4ZIGjREeQB2HZgKcOJh3Cd/97HmjG+sDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.127
Date:   Wed, 29 Jun 2022 09:16:57 +0200
Message-Id: <1656487017196110@kroah.com>
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

I'm announcing the release of the 5.10.127 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-iio-vf610         |    2 
 Makefile                                              |    4 
 arch/arm/boot/dts/imx6qdl.dtsi                        |    2 
 arch/arm/boot/dts/imx7s.dtsi                          |    2 
 arch/arm/mach-axxia/platsmp.c                         |    1 
 arch/arm/mach-cns3xxx/core.c                          |    2 
 arch/arm/mach-exynos/exynos.c                         |    1 
 arch/mips/vr41xx/common/icu.c                         |    2 
 arch/parisc/Kconfig                                   |    1 
 arch/parisc/include/asm/fb.h                          |    2 
 arch/powerpc/kernel/process.c                         |    2 
 arch/powerpc/kernel/rtas.c                            |   11 +
 arch/powerpc/platforms/powernv/powernv.h              |    2 
 arch/powerpc/platforms/powernv/rng.c                  |   52 ++++--
 arch/powerpc/platforms/powernv/setup.c                |    2 
 arch/powerpc/platforms/pseries/pseries.h              |    2 
 arch/powerpc/platforms/pseries/rng.c                  |   11 -
 arch/powerpc/platforms/pseries/setup.c                |    2 
 arch/s390/kernel/perf_cpum_cf.c                       |   22 ++
 arch/x86/net/bpf_jit_comp.c                           |    3 
 arch/xtensa/kernel/time.c                             |    1 
 arch/xtensa/platforms/xtfpga/setup.c                  |    1 
 drivers/base/regmap/regmap-irq.c                      |    5 
 drivers/char/random.c                                 |    6 
 drivers/dma-buf/udmabuf.c                             |    5 
 drivers/gpio/gpio-vr41xx.c                            |    2 
 drivers/gpio/gpio-winbond.c                           |    7 
 drivers/gpu/drm/msm/adreno/adreno_gpu.c               |    3 
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c              |    2 
 drivers/gpu/drm/msm/dp/dp_catalog.c                   |    2 
 drivers/gpu/drm/msm/dp/dp_catalog.h                   |    2 
 drivers/gpu/drm/msm/dp/dp_ctrl.c                      |   40 ++++
 drivers/gpu/drm/msm/dp/dp_display.c                   |  149 +++++++++++------
 drivers/gpu/drm/msm/dp/dp_panel.c                     |    5 
 drivers/gpu/drm/msm/msm_iommu.c                       |    2 
 drivers/gpu/drm/sun4i/sun4i_drv.c                     |    4 
 drivers/iio/accel/bma180.c                            |    3 
 drivers/iio/accel/mma8452.c                           |   22 +-
 drivers/iio/accel/mxc4005.c                           |    4 
 drivers/iio/adc/adi-axi-adc.c                         |    3 
 drivers/iio/adc/axp288_adc.c                          |    8 
 drivers/iio/adc/stm32-adc-core.c                      |    9 -
 drivers/iio/adc/stm32-adc.c                           |   10 -
 drivers/iio/chemical/ccs811.c                         |    4 
 drivers/iio/gyro/mpu3050-core.c                       |    1 
 drivers/iio/imu/inv_icm42600/inv_icm42600.h           |    1 
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c      |    2 
 drivers/iio/trigger/iio-trig-sysfs.c                  |    1 
 drivers/md/dm-era-target.c                            |    8 
 drivers/md/dm-log.c                                   |    2 
 drivers/memory/samsung/exynos5422-dmc.c               |   29 ++-
 drivers/mmc/host/sdhci-pci-o2micro.c                  |    2 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c            |    2 
 drivers/net/bonding/bond_main.c                       |    4 
 drivers/net/ethernet/intel/ice/ice_ethtool.c          |   39 ++++
 drivers/net/ethernet/intel/igb/igb_main.c             |   19 +-
 drivers/net/phy/aquantia_main.c                       |   15 +
 drivers/net/virtio_net.c                              |   25 --
 drivers/nvme/host/core.c                              |  102 +++++++++---
 drivers/nvme/host/lightnvm.c                          |    8 
 drivers/nvme/host/nvme.h                              |    2 
 drivers/nvme/host/pci.c                               |   21 --
 drivers/nvme/target/passthru.c                        |    2 
 drivers/scsi/scsi_debug.c                             |   22 ++
 drivers/soc/bcm/brcmstb/pm/pm-arm.c                   |    1 
 drivers/tty/vt/vt.c                                   |   39 ----
 drivers/tty/vt/vt_ioctl.c                             |  151 ------------------
 drivers/usb/chipidea/udc.c                            |    3 
 drivers/usb/gadget/legacy/raw_gadget.c                |   63 +++++--
 drivers/usb/host/xhci-hub.c                           |    2 
 drivers/usb/host/xhci-pci.c                           |    6 
 drivers/usb/host/xhci.c                               |   15 +
 drivers/usb/host/xhci.h                               |    2 
 drivers/usb/serial/option.c                           |    6 
 drivers/usb/typec/tcpm/Kconfig                        |    1 
 drivers/video/console/sticore.c                       |    2 
 drivers/xen/features.c                                |    2 
 fs/afs/inode.c                                        |    3 
 fs/btrfs/super.c                                      |   39 +++-
 fs/f2fs/namei.c                                       |   17 +-
 include/linux/kd.h                                    |    8 
 include/linux/ratelimit_types.h                       |   12 -
 include/net/netfilter/nf_tables.h                     |   10 -
 include/net/netfilter/nf_tables_core.h                |   12 -
 include/net/netfilter/nft_fib.h                       |    2 
 include/net/netfilter/nft_meta.h                      |    4 
 include/trace/events/libata.h                         |    1 
 net/bridge/netfilter/nft_meta_bridge.c                |    5 
 net/core/filter.c                                     |   34 +++-
 net/ipv4/ip_gre.c                                     |   15 +
 net/ipv4/netfilter/nft_dup_ipv4.c                     |   18 +-
 net/ipv6/ip6_gre.c                                    |   15 +
 net/ipv6/netfilter/nft_dup_ipv6.c                     |   18 +-
 net/netfilter/nf_tables_api.c                         |   52 +++++-
 net/netfilter/nft_bitwise.c                           |   23 +-
 net/netfilter/nft_byteorder.c                         |   14 -
 net/netfilter/nft_cmp.c                               |    8 
 net/netfilter/nft_ct.c                                |   12 -
 net/netfilter/nft_dup_netdev.c                        |    6 
 net/netfilter/nft_dynset.c                            |   12 -
 net/netfilter/nft_exthdr.c                            |   14 -
 net/netfilter/nft_fib.c                               |    5 
 net/netfilter/nft_fwd_netdev.c                        |   18 +-
 net/netfilter/nft_hash.c                              |   25 +-
 net/netfilter/nft_immediate.c                         |    6 
 net/netfilter/nft_lookup.c                            |   14 -
 net/netfilter/nft_masq.c                              |   18 --
 net/netfilter/nft_meta.c                              |   21 --
 net/netfilter/nft_nat.c                               |   35 +---
 net/netfilter/nft_numgen.c                            |   27 +--
 net/netfilter/nft_objref.c                            |    6 
 net/netfilter/nft_osf.c                               |    8 
 net/netfilter/nft_payload.c                           |   10 -
 net/netfilter/nft_queue.c                             |   12 -
 net/netfilter/nft_range.c                             |    6 
 net/netfilter/nft_redir.c                             |   18 --
 net/netfilter/nft_rt.c                                |    7 
 net/netfilter/nft_socket.c                            |    7 
 net/netfilter/nft_tproxy.c                            |   14 -
 net/netfilter/nft_tunnel.c                            |    8 
 net/netfilter/nft_xfrm.c                              |    7 
 net/openvswitch/flow.c                                |    2 
 net/sched/sch_netem.c                                 |    4 
 net/tipc/core.c                                       |    7 
 net/tipc/core.h                                       |    8 
 net/tipc/discover.c                                   |    4 
 net/tipc/link.c                                       |    5 
 net/tipc/link.h                                       |    1 
 net/tipc/net.c                                        |   15 -
 scripts/mod/modpost.c                                 |    2 
 sound/pci/hda/hda_auto_parser.c                       |    7 
 sound/pci/hda/hda_local.h                             |    1 
 sound/pci/hda/patch_conexant.c                        |    4 
 sound/pci/hda/patch_realtek.c                         |   36 ++++
 sound/pci/hda/patch_via.c                             |    4 
 tools/testing/selftests/netfilter/nft_concat_range.sh |    2 
 136 files changed, 999 insertions(+), 756 deletions(-)

Aidan MacDonald (1):
      regmap-irq: Fix a bug in regmap_irq_enable() for type_in_mask chips

Alan Stern (2):
      usb: gadget: Fix non-unique driver names in raw-gadget driver
      USB: gadget: Fix double-free bug in raw_gadget driver

Alexander Stein (1):
      ARM: dts: imx7: Move hsic_phy power domain to HSIC PHY node

Anatolii Gerasymenko (1):
      ice: ethtool: advertise 1000M speeds properly

Andrew Donnellan (1):
      powerpc/rtas: Allow ibm,platform-dump RTAS call with null buffer address

Andy Shevchenko (1):
      usb: typec: wcove: Drop wrong dependency to INTEL_SOC_PMIC

Baruch Siach (1):
      iio: adc: vf610: fix conversion mode sysfs node name

Carlo Lobrano (1):
      USB: serial: option: add Telit LE910Cx 0x1250 composition

Chaitanya Kulkarni (4):
      nvme: centralize setting the timeout in nvme_alloc_request
      nvme: split nvme_alloc_request()
      nvme: mark nvme_setup_passsthru() inline
      nvme: don't check nvme_req flags for new req

Chevron Li (1):
      mmc: sdhci-pci-o2micro: Fix card detect by dealing with debouncing

Christoph Hellwig (1):
      nvme: move the Samsung X5 quirk entry to the core quirks

Claudiu Manoil (1):
      phy: aquantia: Fix AN when higher speeds than 1G are not advertised

Damien Le Moal (1):
      scsi: scsi_debug: Fix zone transition to full condition

Dan Carpenter (1):
      gpio: winbond: Fix error code in winbond_gpio_get()

David Howells (1):
      afs: Fix dynamic root getattr

David Sterba (1):
      btrfs: add error messages to all unrecognized mount options

Dmitry Rokosov (3):
      iio:chemical:ccs811: rearrange iio trigger get and register
      iio:accel:bma180: rearrange iio trigger get and register
      iio:accel:mxc4005: rearrange iio trigger get and register

Edward Wu (1):
      ata: libata: add qc->flags in ata_qc_complete_template tracepoint

Enzo Matsumiya (1):
      nvme-pci: add NO APST quirk for Kioxia device

Eric Dumazet (1):
      erspan: do not assume transport header is always set

Florian Westphal (1):
      netfilter: use get_random_u32 instead of prandom

Gerd Hoffmann (1):
      udmabuf: add back sanity check

Greg Kroah-Hartman (1):
      Linux 5.10.127

Haibo Chen (2):
      iio: mma8452: fix probe fail when device tree compatible is used.
      iio: accel: mma8452: ignore the return value of reset operation

Hans de Goede (1):
      iio: adc: axp288: Override TS pin bias current for some models

Helge Deller (2):
      parisc/stifb: Fix fb_is_primary_device() only available with CONFIG_FB_STI
      parisc: Enable ARCH_HAS_STRICT_MODULE_RWX

Hoang Le (1):
      tipc: fix use-after-free Read in tipc_named_reinit

Jaegeuk Kim (1):
      f2fs: attach inline_data after setting compression

Jakub Kicinski (1):
      Revert "net/tls: fix tls_sk_proto_close executed repeatedly"

Jakub Sitnicki (1):
      bpf, x86: Fix tail call count offset calculation on bpf2bpf call

Jason A. Donenfeld (5):
      random: schedule mix_interrupt_randomness() less often
      random: quiet urandom warning ratelimit suppression message
      powerpc/powernv: wire up rng during setup_arch
      random: update comment from copy_to_user() -> copy_to_iter()
      powerpc/pseries: wire up rng during setup_arch()

Jay Vosburgh (1):
      bonding: ARP monitor spams NETDEV_NOTIFY_PEERS notifiers

Jean-Baptiste Maneyrol (1):
      iio: imu: inv_icm42600: Fix broken icm42600 (chip id 0 value)

Jie2x Zhou (1):
      selftests: netfilter: correct PKTGEN_SCRIPT_PATHS in nft_concat_range.sh

Jiri Slaby (1):
      vt: drop old FONT ioctls

Jon Maxwell (1):
      bpf: Fix request_sock leak in sk lookup helpers

Jonathan Marek (1):
      drm/msm: use for_each_sgtable_sg to iterate over scatterlist

Julien Grall (1):
      x86/xen: Remove undefined behavior in setup_features()

Kai-Heng Feng (1):
      igb: Make DMA faster when CPU is active on the PCIe link

Kailang Yang (1):
      ALSA: hda/realtek - ALC897 headset MIC no sound

Keith Busch (1):
      nvme-pci: allocate nvme_command within driver pdu

Kuogee Hsieh (5):
      drm/msm/dp: check core_initialized before disable interrupts at dp_display_unbind()
      drm/msm/dp: fixes wrong connection state caused by failure of link train
      drm/msm/dp: deinitialize mainlink if link training failed
      drm/msm/dp: promote irq_hpd handle to handle link training correctly
      drm/msm/dp: fix connect/disconnect handled at irq_hpd

Liang He (2):
      xtensa: xtfpga: Fix refcount leak bug in setup
      xtensa: Fix refcount leak bug in time.c

Lorenzo Bianconi (1):
      igb: fix a use-after-free issue in igb_clean_tx_ring

Lucas Stach (1):
      ARM: dts: imx6qdl: correct PU regulator ramp delay

Macpaul Lin (1):
      USB: serial: option: add Quectel RM500K module support

Masahiro Yamada (2):
      modpost: fix section mismatch check for exported init/exit sections
      kbuild: link vmlinux only once for CONFIG_TRIM_UNUSED_KSYMS (2nd attempt)

Mathias Nyman (1):
      xhci: turn off port power in shutdown

Maximilian Luz (1):
      drm/msm: Fix double pm_runtime_disable() call

Miaoqian Lin (7):
      drm/msm/mdp4: Fix refcount leak in mdp4_modeset_init_intf
      iio: adc: adi-axi-adc: Fix refcount leak in adi_axi_adc_attach_client
      ARM: exynos: Fix refcount leak in exynos_map_pmu
      soc: bcm: brcmstb: pm: pm-arm: Fix refcount leak in brcmstb_pm_probe
      ARM: Fix refcount leak in axxia_boot_secondary
      memory: samsung: exynos5422-dmc: Fix refcount leak in of_get_dram_timings
      ARM: cns3xxx: Fix refcount leak in cns3xxx_init

Mikulas Patocka (1):
      dm mirror log: clear log bits up to BITS_PER_LONG boundary

Naveen N. Rao (1):
      powerpc: Enable execve syscall exit tracepoint

Nikos Tsironis (1):
      dm era: commit metadata in postsuspend after worker stops

Olivier Moysan (1):
      iio: adc: stm32: fix maximum clock rate for stm32mp15x

Pablo Neira Ayuso (2):
      netfilter: nftables: add nft_parse_register_load() and use it
      netfilter: nftables: add nft_parse_register_store() and use it

Peilin Ye (1):
      net/sched: sch_netem: Fix arithmetic in netem_dump() for 32-bit platforms

Rosemarie O'Riorden (1):
      net: openvswitch: fix parsing of nw_proto for IPv6 fragments

Samuel Holland (1):
      drm/sun4i: Fix crash during suspend after component bind failure

Sascha Hauer (1):
      mtd: rawnand: gpmi: Fix setting busy timeout setting

Soham Sen (1):
      ALSA: hda/realtek: Add mute LED quirk for HP Omen laptop

Stephan Gerhold (1):
      virtio_net: fix xdp_rxq_info bug after suspend/resume

Takashi Iwai (3):
      ALSA: hda/via: Fix missing beep setup
      ALSA: hda/conexant: Fix missing beep setup
      ALSA: hda/realtek: Apply fixup for Lenovo Yoga Duet 7 properly

Tanveer Alam (1):
      xhci-pci: Allow host runtime PM as default for Intel Raptor Lake xHCI

Thomas Richter (1):
      s390/cpumf: Handle events cycles and instructions identical

Tim Crawford (2):
      ALSA: hda/realtek: Add quirk for Clevo PD70PNT
      ALSA: hda/realtek: Add quirk for Clevo NS50PU

Utkarsh Patel (1):
      xhci-pci: Allow host runtime PM as default for Intel Meteor Lake xHCI

Vincent Whitchurch (1):
      iio: trigger: sysfs: fix use-after-free on remove

Xin Long (1):
      tipc: simplify the finalize work queue

Xu Yang (1):
      usb: chipidea: udc: check request status before setting device address

Yannick Brosseau (2):
      iio: adc: stm32: Fix ADCs iteration in irq handler
      iio: adc: stm32: Fix IRQs on STM32F4 by removing custom spurious IRQs message

Yonglin Tan (1):
      USB: serial: option: add Quectel EM05-G modem

Zheyu Ma (1):
      iio: gyro: mpu3050: Fix the error handling in mpu3050_power_up()

Ziyang Xuan (1):
      net/tls: fix tls_sk_proto_close executed repeatedly

huhai (1):
      MIPS: Remove repetitive increase irq_err_count

