Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581062C2D70
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 17:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390612AbgKXQwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 11:52:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403777AbgKXQwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 11:52:12 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 082132137B;
        Tue, 24 Nov 2020 16:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606236729;
        bh=bzUUg+do9lPrspuKDjKdQDjt8VuJb1sSpdoccEjlFJw=;
        h=From:To:Cc:Subject:Date:From;
        b=K+a+z8mydoYemacF60iTBwGZmkMSRaVRKXXM0WRJNmnnKz7G5NeZ3T/8JS1Kl6yB2
         O70QVujksCqrWearVpt3hPw1z44wJQU8ntDlQ8nUp55HgzsdALypNpy0JIjXeMeDc0
         85WvGgJ+4GklpOjfhNreB84w84oaGHenA94kt5Ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.9.11
Date:   Tue, 24 Nov 2020 17:51:53 +0100
Message-Id: <160623671354173@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.9.11 kernel.

All users of the 5.9 kernel series must upgrade.

The updated 5.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/xtensa/mmu.rst                                    |    9 
 Makefile                                                        |    2 
 arch/arm/boot/compressed/head.S                                 |    3 
 arch/arm/boot/dts/imx50-evk.dts                                 |    2 
 arch/arm/boot/dts/imx6q-prti6q.dts                              |    4 
 arch/arm/boot/dts/imx6qdl-udoo.dtsi                             |    2 
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi                   |   19 -
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi                    |    2 
 arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi                    |    4 
 arch/arm/boot/dts/sun6i-a31-hummingbird.dts                     |    2 
 arch/arm/boot/dts/sun7i-a20-bananapi-m1-plus.dts                |    2 
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts                      |    2 
 arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts                    |    2 
 arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts                |    2 
 arch/arm/boot/dts/sun8i-h3-orangepi-pc-plus.dts                 |    5 
 arch/arm/boot/dts/sun8i-h3-orangepi-plus2e.dts                  |    2 
 arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts               |    2 
 arch/arm/boot/dts/sun9i-a80-cubieboard4.dts                     |    2 
 arch/arm/boot/dts/sun9i-a80-optimus.dts                         |    2 
 arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi                   |    2 
 arch/arm/boot/dts/vf610-zii-dev-rev-b.dts                       |    3 
 arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts       |    2 
 arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts       |    2 
 arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts        |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h5-libretech-all-h5-cc.dts |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts        |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts      |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts         |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64.dts            |    2 
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts          |    2 
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts     |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi                  |    1 
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi                  |    1 
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi                  |    1 
 arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi            |    1 
 arch/arm64/boot/dts/freescale/imx8mm.dtsi                       |    2 
 arch/arm64/boot/dts/freescale/imx8mn.dtsi                       |   30 --
 arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts              |    2 
 arch/arm64/include/asm/cpufeature.h                             |    2 
 arch/arm64/include/asm/cputype.h                                |    4 
 arch/arm64/kernel/cpu_errata.c                                  |    2 
 arch/arm64/kernel/cpufeature.c                                  |    2 
 arch/arm64/kernel/process.c                                     |    5 
 arch/arm64/kernel/psci.c                                        |    5 
 arch/arm64/kernel/smp.c                                         |    1 
 arch/mips/alchemy/common/clock.c                                |    9 
 arch/mips/mm/tlb-r4k.c                                          |    1 
 arch/s390/kernel/entry.S                                        |    2 
 arch/s390/kernel/perf_cpum_sf.c                                 |    2 
 arch/um/include/asm/pgalloc.h                                   |    8 
 arch/x86/kernel/cpu/microcode/intel.c                           |   63 -----
 arch/x86/kernel/tboot.c                                         |    3 
 arch/x86/platform/efi/efi_64.c                                  |   24 +-
 arch/xtensa/include/asm/pgtable.h                               |    2 
 arch/xtensa/mm/cache.c                                          |   14 +
 block/blk-cgroup.c                                              |    1 
 drivers/accessibility/speakup/spk_ttyio.c                       |   12 -
 drivers/acpi/button.c                                           |   13 +
 drivers/acpi/fan.c                                              |    1 
 drivers/atm/nicstar.c                                           |    2 
 drivers/counter/ti-eqep.c                                       |    4 
 drivers/dma/dmaengine.c                                         |   17 -
 drivers/dma/idxd/device.c                                       |   31 +-
 drivers/dma/idxd/idxd.h                                         |    3 
 drivers/dma/idxd/init.c                                         |    5 
 drivers/dma/idxd/registers.h                                    |   25 ++
 drivers/dma/idxd/submit.c                                       |    2 
 drivers/dma/ti/omap-dma.c                                       |   37 ++-
 drivers/dma/xilinx/xilinx_dma.c                                 |   36 ++-
 drivers/gpio/gpio-omap.c                                        |   12 -
 drivers/gpu/drm/amd/display/dc/irq/dcn20/irq_service_dcn20.c    |    4 
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                       |    6 
 drivers/gpu/drm/i915/display/intel_display.c                    |    3 
 drivers/gpu/drm/i915/gt/intel_rc6.c                             |   22 +
 drivers/gpu/drm/i915/i915_reg.h                                 |   12 -
 drivers/gpu/drm/i915/intel_pm.c                                 |   13 -
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c                           |    1 
 drivers/hid/hid-logitech-dj.c                                   |   22 +
 drivers/hid/hid-logitech-hidpp.c                                |   26 ++
 drivers/hid/hid-mcp2221.c                                       |   48 +++-
 drivers/hv/hv.c                                                 |    8 
 drivers/hwmon/pwm-fan.c                                         |   16 -
 drivers/iio/accel/kxcjk-1013.c                                  |   51 ++++
 drivers/iio/adc/ingenic-adc.c                                   |   34 ++
 drivers/iio/adc/mt6577_auxadc.c                                 |    6 
 drivers/iio/adc/stm32-adc-core.c                                |   41 +--
 drivers/iio/adc/stm32-adc.c                                     |   50 ++++
 drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c       |   16 -
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c                    |    6 
 drivers/iio/light/Kconfig                                       |    1 
 drivers/infiniband/Kconfig                                      |    3 
 drivers/infiniband/hw/hfi1/chip.c                               |    3 
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c                  |    2 
 drivers/infiniband/sw/rdmavt/Kconfig                            |    3 
 drivers/infiniband/sw/rxe/Kconfig                               |    2 
 drivers/infiniband/sw/siw/Kconfig                               |    1 
 drivers/input/misc/adxl34x.c                                    |    2 
 drivers/input/mouse/elan_i2c.h                                  |    2 
 drivers/input/mouse/elan_i2c_core.c                             |    3 
 drivers/input/mouse/elan_i2c_i2c.c                              |   10 
 drivers/input/mouse/elan_i2c_smbus.c                            |    2 
 drivers/input/touchscreen/Kconfig                               |    1 
 drivers/iommu/intel/iommu.c                                     |    5 
 drivers/misc/habanalabs/include/gaudi/gaudi_masks.h             |    1 
 drivers/mmc/host/sdhci-of-arasan.c                              |   51 +---
 drivers/mmc/host/sdhci-pci-core.c                               |   13 -
 drivers/net/can/dev.c                                           |    2 
 drivers/net/can/flexcan.c                                       |   26 +-
 drivers/net/can/kvaser_pciefd.c                                 |    4 
 drivers/net/can/m_can/Kconfig                                   |    3 
 drivers/net/can/m_can/m_can.c                                   |   18 +
 drivers/net/can/m_can/m_can.h                                   |    1 
 drivers/net/can/m_can/m_can_platform.c                          |   23 +-
 drivers/net/can/m_can/tcan4x5x.c                                |   32 ++
 drivers/net/can/ti_hecc.c                                       |   13 -
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c               |    2 
 drivers/net/can/usb/mcba_usb.c                                  |    4 
 drivers/net/can/usb/peak_usb/pcan_usb_core.c                    |    4 
 drivers/net/dsa/lantiq_gswip.c                                  |   11 
 drivers/net/dsa/mv88e6xxx/global1_vtu.c                         |   59 ++++-
 drivers/net/ethernet/broadcom/b44.c                             |    3 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                       |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c               |    2 
 drivers/net/ethernet/faraday/ftgmac100.c                        |    4 
 drivers/net/ethernet/freescale/enetc/Kconfig                    |    1 
 drivers/net/ethernet/freescale/enetc/enetc.c                    |   62 +++--
 drivers/net/ethernet/freescale/enetc/enetc_hw.h                 |  115 +++++++++-
 drivers/net/ethernet/freescale/enetc/enetc_mdio.c               |    8 
 drivers/net/ethernet/freescale/fec_main.c                       |   12 -
 drivers/net/ethernet/marvell/mvneta.c                           |    5 
 drivers/net/ethernet/mediatek/mtk_star_emac.c                   |    3 
 drivers/net/ethernet/mellanox/mlx4/fw.c                         |    6 
 drivers/net/ethernet/mellanox/mlx4/fw.h                         |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c           |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c      |   13 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c               |   20 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c               |    7 
 drivers/net/ethernet/mellanox/mlxsw/core.c                      |    3 
 drivers/net/ethernet/microchip/lan743x_main.c                   |   13 -
 drivers/net/ethernet/qlogic/qed/qed_cxt.c                       |    4 
 drivers/net/ethernet/qlogic/qed/qed_cxt.h                       |    3 
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c                     |   12 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c           |    3 
 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c            |    5 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c               |    2 
 drivers/net/ethernet/ti/am65-cpts.c                             |    3 
 drivers/net/ethernet/ti/cpsw.c                                  |   11 
 drivers/net/ethernet/ti/cpsw_new.c                              |    9 
 drivers/net/geneve.c                                            |    3 
 drivers/net/ipa/gsi_trans.c                                     |   15 +
 drivers/net/netdevsim/dev.c                                     |    2 
 drivers/net/netdevsim/health.c                                  |    1 
 drivers/net/netdevsim/udp_tunnels.c                             |    1 
 drivers/net/phy/mscc/mscc_macsec.c                              |    1 
 drivers/net/usb/qmi_wwan.c                                      |    2 
 drivers/pinctrl/pinctrl-mcp23s08_spi.c                          |    2 
 drivers/pinctrl/pinctrl-rockchip.c                              |    2 
 drivers/regulator/core.c                                        |   38 +--
 drivers/regulator/pfuze100-regulator.c                          |   13 -
 drivers/regulator/ti-abb-regulator.c                            |   12 -
 drivers/s390/block/dasd.c                                       |    6 
 drivers/scsi/ufs/ufshcd.c                                       |   32 ++
 drivers/scsi/ufs/ufshcd.h                                       |    2 
 drivers/spi/spi-bcm2835aux.c                                    |   21 -
 drivers/spi/spi-cadence-quadspi.c                               |    2 
 drivers/spi/spi-fsl-lpspi.c                                     |    3 
 drivers/spi/spi-npcm-fiu.c                                      |    2 
 drivers/spi/spi.c                                               |   81 +++++--
 drivers/staging/mt7621-pci/pci-mt7621.c                         |   15 -
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c                    |    1 
 drivers/tee/amdtee/amdtee_private.h                             |    8 
 drivers/tee/amdtee/core.c                                       |   26 +-
 drivers/tty/serial/ar933x_uart.c                                |    6 
 drivers/tty/serial/imx.c                                        |   30 --
 drivers/usb/dwc2/platform.c                                     |    3 
 fs/afs/dir.c                                                    |    1 
 fs/afs/inode.c                                                  |    8 
 fs/afs/internal.h                                               |    1 
 fs/efivarfs/super.c                                             |    1 
 fs/ext4/ext4.h                                                  |    3 
 fs/gfs2/aops.c                                                  |    2 
 fs/gfs2/glops.c                                                 |   13 +
 fs/gfs2/log.c                                                   |    2 
 fs/gfs2/rgrp.c                                                  |   10 
 fs/io_uring.c                                                   |    1 
 fs/libfs.c                                                      |    6 
 fs/notify/fsnotify.c                                            |   12 -
 fs/super.c                                                      |   33 --
 fs/xfs/libxfs/xfs_attr_leaf.c                                   |    8 
 fs/xfs/libxfs/xfs_rmap_btree.c                                  |   16 -
 fs/xfs/scrub/bmap.c                                             |    8 
 fs/xfs/scrub/btree.c                                            |   45 ++-
 fs/xfs/scrub/dir.c                                              |   21 +
 fs/xfs/xfs_iwalk.c                                              |   27 ++
 fs/xfs/xfs_mount.c                                              |   11 
 include/drm/intel-gtt.h                                         |    5 
 include/linux/intel-iommu.h                                     |    2 
 include/linux/pagemap.h                                         |    2 
 include/linux/pm_runtime.h                                      |   21 +
 include/linux/sched.h                                           |   16 +
 include/linux/spi/spi.h                                         |   19 +
 include/linux/swiotlb.h                                         |    1 
 include/net/ip_tunnels.h                                        |    7 
 include/net/neighbour.h                                         |    1 
 include/net/tls.h                                               |   16 +
 include/trace/events/sunrpc.h                                   |    3 
 kernel/fail_function.c                                          |    5 
 kernel/ptrace.c                                                 |   16 -
 kernel/rcu/tree.c                                               |    2 
 kernel/rcu/tree_stall.h                                         |   22 +
 kernel/sched/core.c                                             |   15 -
 kernel/sched/fair.c                                             |    3 
 kernel/seccomp.c                                                |    5 
 kernel/trace/bpf_trace.c                                        |   10 
 lib/strncpy_from_user.c                                         |   19 +
 mm/filemap.c                                                    |   18 +
 mm/huge_memory.c                                                |    9 
 mm/memcontrol.c                                                 |    9 
 mm/page_alloc.c                                                 |    5 
 net/bridge/br_device.c                                          |    1 
 net/can/af_can.c                                                |   38 ++-
 net/core/devlink.c                                              |    6 
 net/core/neighbour.c                                            |    2 
 net/core/netpoll.c                                              |   22 +
 net/core/skmsg.c                                                |   94 ++++++--
 net/ipv4/arp.c                                                  |    6 
 net/ipv4/inet_diag.c                                            |    4 
 net/ipv4/tcp_bbr.c                                              |    2 
 net/ipv4/tcp_bpf.c                                              |   18 -
 net/ipv6/addrconf.c                                             |    8 
 net/ipv6/ah6.c                                                  |    3 
 net/ipv6/ndisc.c                                                |    7 
 net/mac80211/rc80211_minstrel.c                                 |   27 --
 net/mac80211/rc80211_minstrel.h                                 |    1 
 net/mac80211/sta_info.c                                         |   14 -
 net/ncsi/ncsi-manage.c                                          |    5 
 net/ncsi/ncsi-netlink.c                                         |   22 -
 net/ncsi/ncsi-netlink.h                                         |    3 
 net/netlabel/netlabel_unlabeled.c                               |   17 +
 net/rfkill/core.c                                               |    3 
 net/sctp/input.c                                                |    4 
 net/sctp/sm_sideeffect.c                                        |    4 
 net/sctp/transport.c                                            |    2 
 net/smc/smc_ib.c                                                |    6 
 net/tls/tls_device.c                                            |   37 ++-
 net/tls/tls_sw.c                                                |    2 
 net/vmw_vsock/af_vsock.c                                        |    2 
 net/x25/af_x25.c                                                |    1 
 sound/core/control.c                                            |    2 
 sound/firewire/fireworks/fireworks_transaction.c                |    4 
 sound/pci/hda/patch_realtek.c                                   |   85 +++++++
 sound/pci/mixart/mixart_core.c                                  |    5 
 sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c             |    2 
 sound/soc/intel/keembay/kmb_platform.c                          |    6 
 sound/soc/qcom/lpass-platform.c                                 |    5 
 sound/usb/quirks.c                                              |   10 
 tools/bpf/bpftool/feature.c                                     |    7 
 tools/bpf/bpftool/net.c                                         |   18 -
 tools/lib/bpf/Makefile                                          |    2 
 tools/perf/builtin-lock.c                                       |    4 
 tools/testing/kunit/.gitattributes                              |    1 
 tools/testing/selftests/bpf/prog_tests/sockopt_multi.c          |    3 
 tools/testing/selftests/kvm/include/x86_64/processor.h          |    2 
 tools/testing/selftests/kvm/lib/x86_64/processor.c              |    3 
 tools/testing/selftests/seccomp/seccomp_bpf.c                   |    8 
 265 files changed, 1919 insertions(+), 913 deletions(-)

Aaron Lewis (1):
      selftests: kvm: Fix the segment descriptor layout to match the actual layout

Adam Ford (2):
      arm64: dts: imx8mm-beacon-som: Fix Choppy BT audio
      arm64: dts imx8mn: Remove non-existent USB OTG2

Adrian Hunter (1):
      mmc: sdhci-pci: Prefer SDR25 timing for High Speed mode for BYT-based Intel controllers

Alejandro Concepcion Rodriguez (1):
      can: dev: can_restart(): post buffer from the right context

Alex Deucher (1):
      drm/amd/display: Add missing pflip irq for dcn2.0

Alex Elder (1):
      net: ipa: lock when freeing transaction

Alex Marginean (1):
      enetc: Workaround for MDIO register access issue

Amir Goldstein (1):
      fanotify: fix logic of reporting name info with watched parent

Anant Thazhemadam (2):
      can: af_can: prevent potential access of uninitialized member in can_rcv()
      can: af_can: prevent potential access of uninitialized member in canfd_rcv()

Andrew Lunn (1):
      ARM: dts: vf610-zii-dev-rev-b: Fix MDIO over clocking

Andy Shevchenko (2):
      pinctrl: mcp23s08: Print error message when regmap init fails
      iommu/vt-d: Move intel_iommu_gfx_mapped to Intel IOMMU header

Ard Biesheuvel (1):
      efi/arm: set HSCTLR Thumb2 bit correctly for HVC calls from HYP

Arvind Sankar (1):
      efi/x86: Free efi_pgd with free_pages()

Aya Levin (1):
      net/mlx4_core: Fix init_hca fields offset

Biwen Li (1):
      arm64: dts: fsl: fix endianness issue of rcpm

Bob Peterson (2):
      gfs2: Fix case in which ail writes are done to jdata holes
      gfs2: Fix regression in freeze_go_sync

Brendan Higgins (1):
      kunit: tool: unmark test_data as binary blobs

Brian O'Keefe (1):
      staging: rtl8723bs: Add 024c:0627 to the list of SDIO device-ids

Can Guo (2):
      scsi: ufs: Fix unbalanced scsi_block_reqs_cnt caused by ufshcd_hold()
      scsi: ufs: Try to save power mode change and UIC cmd completion timeout

Chen Yu (1):
      x86/microcode/intel: Check patch signature before saving microcode for early loading

Chen-Yu Tsai (10):
      Revert "arm: sun8i: orangepi-pc-plus: Set EMAC activity LEDs to active high"
      ARM: dts: sun6i: a31-hummingbird: Enable RGMII RX/TX delay on Ethernet PHY
      ARM: dts: sun7i: cubietruck: Enable RGMII RX/TX delay on Ethernet PHY
      ARM: dts: sun7i: bananapi-m1-plus: Enable RGMII RX/TX delay on Ethernet PHY
      ARM: dts: sun8i: h3: orangepi-plus2e: Enable RGMII RX/TX delay on Ethernet PHY
      ARM: dts: sun8i: a83t: Enable both RGMII RX/TX delay on Ethernet PHY
      ARM: dts: sun9i: Enable both RGMII RX/TX delay on Ethernet PHY
      ARM: dts: sunxi: bananapi-m2-plus: Enable RGMII RX/TX delay on Ethernet PHY
      arm64: dts: allwinner: h5: libretech-all-h5-cc: Enable RGMII RX/TX delay on PHY
      arm64: dts: allwinner: a64: bananapi-m64: Enable RGMII RX/TX delay on PHY

Chris Co (1):
      Drivers: hv: vmbus: Allow cleanup of VMBUS_CONNECT_CPU if disconnected

Christoph Hellwig (2):
      RMDA/sw: Don't allow drivers using dma_virt_ops on highmem configs
      blk-cgroup: fix a hd_struct leak in blkcg_fill_root_iostats

Claire Chang (1):
      rfkill: Fix use-after-free in rfkill_resume()

Clément Péron (1):
      arm64: dts: allwinner: beelink-gs1: Enable both RGMII RX/TX delay

Colin Ian King (1):
      can: peak_usb: fix potential integer overflow on shift of a int

Corentin Labbe (1):
      arm64: dts: allwinner: Pine H64: Enable both RGMII RX/TX delay

Dan Carpenter (3):
      Input: adxl34x - clean up a data type in adxl34x_probe()
      dmaengine: fix error codes in channel_register()
      ALSA: firewire: Clean up a locking issue in copy_resp_to_buf()

Dan Murphy (2):
      can: m_can: m_can_class_free_dev(): introduce new function
      can: m_can: Fix freeing of can device from peripherials

Daniel Xu (1):
      lib/strncpy_from_user.c: Mask out bytes after NUL terminator.

Darrick J. Wong (6):
      vfs: remove lockdep bogosity in __sb_start_write
      xfs: fix the minrecs logic when dealing with inode root child blocks
      xfs: strengthen rmap record flags checking
      xfs: directory scrub should check the null bestfree entries too
      xfs: ensure inobt record walks always make forward progress
      xfs: revert "xfs: fix rmap key and record comparison functions"

Dave Jiang (2):
      dmaengine: idxd: fix wq config registers offset programming
      dmaengine: idxd: fix mapping of portal size

David Howells (1):
      afs: Fix speculative status fetch going out of order wrt to modifications

David Lechner (1):
      counter/ti-eqep: Fix regmap max_register

Dinh Nguyen (1):
      arm64: dts: agilex/stratix10: Fix qspi node compatible

Dmitry Bogdanov (1):
      qed: fix ILT configuration of SRC block

Dongli Zhang (1):
      page_frag: Recover from memory pressure

Edwin Peer (1):
      bnxt_en: read EEPROM A2h address using page 0

Eli Cohen (1):
      net/mlx5: E-Switch, Fail mlx5_esw_modify_vport_rate if qos disabled

Enric Balletbo i Serra (1):
      can: tcan4x5x: replace depends on REGMAP_SPI with depends on SPI

Fabien Parent (1):
      iio: adc: mediatek: fix unset field

Fabio Estevam (1):
      ARM: dts: imx50-evk: Fix the chip select 1 IOMUX

Faiz Abbas (1):
      can: m_can: m_can_stop(): set device to software init mode before closing

Felix Fietkau (2):
      mac80211: minstrel: remove deferred sampling code
      mac80211: minstrel: fix tx status processing corner case

Filip Moc (1):
      net: usb: qmi_wwan: Set DTR quirk for MR400

Florian Fainelli (1):
      net: Have netpoll bring-up DSA management interface

Fugang Duan (1):
      tty: serial: imx: keep console clocks always on

Gao Xiang (1):
      xfs: fix forkoff miscalculation related to XFS_LITINO(mp)

Gerald Schaefer (1):
      mm/userfaultfd: do not access vma->vm_mm after calling handle_userfault()

Greg Kroah-Hartman (1):
      Linux 5.9.11

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: fix cpts irq after suspend

Guenter Roeck (2):
      ASOC: Intel: kbl_rt5663_rt5514_max98927: Do not try to disable disabled clock
      ACPI: fan: Initialize performance state sysfs attribute

Gwendal Grignou (1):
      iio: cros_ec: Use default frequencies when EC returns invalid information

Hans de Goede (6):
      ACPI: button: Add DMI quirk for Medion Akoya E2228T
      HID: logitech-dj: Handle quad/bluetooth keyboards with a builtin trackpad
      HID: logitech-dj: Fix Dinovo Mini when paired with a MX5x00 receiver
      HID: logitech-dj: Fix an error in mse_bluetooth_descriptor
      iio: accel: kxcjk1013: Replace is_smo8500_device with an acpi_type enum
      iio: accel: kxcjk1013: Add support for KIOX010A ACPI DSM for setting tablet-mode

Harry Cutts (1):
      HID: logitech-hidpp: Add PID for MX Anywhere 2

Heiko Carstens (1):
      s390: fix system call exit path

Heiner Kallweit (1):
      net: bridge: add missing counters to ndo_get_stats64 callback

Ian Rogers (1):
      tools, bpftool: Avoid array index warnings.

Ido Schimmel (1):
      mlxsw: core: Use variable timeout for EMAD retries

Jan Kara (1):
      ext4: fix bogus warning in ext4_update_dx_flag()

Jarkko Nikula (1):
      can: m_can: process interrupt only when not runtime suspended

Jeff Dike (1):
      Exempt multicast addresses from five-second neighbor lifetime

Jens Axboe (2):
      io_uring: don't double complete failed reissue request
      mm: never attempt async page lock if we've transferred data already

Jernej Skrabec (4):
      arm64: dts: allwinner: a64: OrangePi Win: Fix ethernet node
      arm64: dts: allwinner: a64: Pine64 Plus: Fix ethernet node
      arm64: dts: allwinner: h5: OrangePi PC2: Fix ethernet node
      ARM: dts: sun8i: r40: bananapi-m2-ultra: Fix ethernet node

Jianqun Xu (1):
      pinctrl: rockchip: enable gpio pclk for rockchip_gpio_to_irq

Jimmy Assarsson (2):
      can: kvaser_pciefd: Fix KCAN bittiming limits
      can: kvaser_usb: kvaser_usb_hydra: Fix KCAN bittiming limits

Jiri Olsa (1):
      libbpf: Fix VERSIONED_SYM_COUNT number parsing

Joakim Tjernlund (1):
      ALSA: usb-audio: Add delay quirk for all Logitech USB devices

Joel Stanley (2):
      net: ftgmac100: Fix crash when removing driver
      net/ncsi: Fix netlink registration

Johannes Berg (1):
      mac80211: free sta in sta_info_insert_finish() on errors

John Fastabend (6):
      bpf, sockmap: Fix partial copy_page_to_iter so progress can still be made
      bpf, sockmap: Ensure SO_RCVBUF memory is observed on ingress redirect
      bpf, sockmap: Skb verdict SK_PASS to self already checked rmem limits
      bpf, sockmap: On receive programs try to fast track SK_PASS ingress
      bpf, sockmap: Use truesize with sk_rmem_schedule()
      bpf, sockmap: Avoid returning unneeded EAGAIN when redirecting to self

Jonathan Liu (1):
      drm: bridge: dw-hdmi: Avoid resetting force in the detect function

Kailang Yang (3):
      ALSA: hda/realtek - Add supported for Lenovo ThinkPad Headset Button
      ALSA: hda/realtek - Add supported mute Led for HP
      ALSA: hda/realtek - HP Headset Mic can't detect after boot

Karsten Graul (1):
      net/smc: fix direct access to ib_gid_addr->ndev in smc_ib_determine_gid()

Kees Cook (2):
      selftests/seccomp: powerpc: Fix typo in macro variable name
      selftests/seccomp: sh: Fix register names

Konrad Dybcio (3):
      arm64: Add MIDR value for KRYO2XX gold/silver CPU cores
      arm64: kpti: Add KRYO2XX gold/silver CPU cores to kpti safelist
      arm64: cpu_errata: Apply Erratum 845719 to KRYO2XX Silver

Lars Povlsen (1):
      HID: mcp2221: Fix GPIO output handling

Leo Yan (2):
      perf lock: Correct field name "flags"
      perf lock: Don't free "lock_seq_stat" if read_count isn't zero

Lorenzo Bianconi (2):
      net: mvneta: fix possible memory leak in mvneta_swbm_add_rx_fragment
      iio: imu: st_lsm6dsx: set 10ms as min shub slave timeout

Lucas Stach (1):
      arm64: dts: imx8mm: fix voltage for 1.6GHz CPU operating point

Lukas Wunner (4):
      spi: lpspi: Fix use-after-free on unbind
      spi: Introduce device-managed SPI controller allocation
      spi: npcm-fiu: Don't leak SPI master in probe error path
      spi: bcm2835aux: Fix use-after-free on unbind

Luo Meng (1):
      fail_function: Remove a redundant mutex unlock

Manish Narani (3):
      mmc: sdhci-of-arasan: Allow configuring zero tap values
      mmc: sdhci-of-arasan: Use Mask writes for Tap delays
      mmc: sdhci-of-arasan: Issue DLL reset explicitly

Maor Dickman (1):
      net/mlx5e: Fix check if netdev is bond slave

Marc Kleine-Budde (4):
      can: mcba_usb: mcba_usb_start_xmit(): first fill skb, then pass to can_put_echo_skb()
      can: tcan4x5x: tcan4x5x_can_probe(): add missing error checking for devm_regmap_init()
      can: tcan4x5x: tcan4x5x_can_remove(): fix order of deregistration
      can: flexcan: flexcan_chip_start(): fix erroneous flexcan_transceiver_enable() during bus-off recovery

Marek Vasut (5):
      ARM: dts: stm32: Fix TA3-GPIO-C key on STM32MP1 DHCOM PDK2
      ARM: dts: stm32: Fix LED5 on STM32MP1 DHCOM PDK2
      ARM: dts: stm32: Define VIO regulator supply on DHCOM
      ARM: dts: stm32: Enable thermal sensor support on stm32mp15xx-dhcor
      ARM: dts: stm32: Keep VDDA LDO1 always on on DHCOM

Martin Blumenstingl (2):
      net: lantiq: Wait for the GPHY firmware to be ready
      usb: dwc2: Avoid leaving the error_debugfs label unused

Matthew Murrian (2):
      dmaengine: xilinx_dma: Fix usage of xilinx_aximcdma_tx_segment
      dmaengine: xilinx_dma: Fix SG capability check for MCDMA

Matthew Wilcox (Oracle) (1):
      mm: fix readahead_page_batch for retry entries

Max Filippov (2):
      xtensa: fix TLBTEMP area placement
      xtensa: disable preemption around cache alias management calls

Maxim Mikityanskiy (1):
      net/mlx5e: Fix refcount leak on kTLS RX resync

Michael Chan (2):
      bnxt_en: Fix counter overflow logic.
      bnxt_en: Free port stats during firmware reset.

Michael Guralnik (1):
      net/mlx5: Add handling of port type in rule deletion

Michael Sit Wei Hong (1):
      ASoC: Intel: KMB: Fix S24_LE configuration

Michał Mirosław (3):
      regulator: fix memory leak with repeated set_machine_constraints()
      regulator: avoid resolve_supply() infinite recursion
      regulator: workaround self-referent regulators

Mickaël Salaün (2):
      ptrace: Set PF_SUPERPRIV when checking capability
      seccomp: Set PF_SUPERPRIV when checking capability

Muchun Song (1):
      mm: memcg/slab: fix root memcg vmstats

Necip Fazil Yildiran (2):
      Input: resistive-adc-touch - fix kconfig dependency on IIO_BUFFER
      iio: light: fix kconfig dependency bug for VCNL4035

Nenad Peric (1):
      arm64: dts: allwinner: h5: OrangePi Prime: Fix ethernet node

Nishanth Menon (1):
      regulator: ti-abb: Fix array out of bound read access on the first transition

Oded Gabbay (1):
      habanalabs/gaudi: mask WDT error in QMAN

Oleksij Rempel (1):
      ARM: dts: imx6q-prti6q: fix PHY address

Olivier Moysan (1):
      iio: adc: stm32-adc: fix a regression when using dma and irq

Paul Barker (1):
      hwmon: (pwm-fan) Fix RPM calculation

Paul Cercueil (2):
      iio/adc: ingenic: Fix AUX/VBAT readings when touchscreen is used
      iio/adc: ingenic: Fix battery VREF for JZ4770 SoC

Paul E. McKenney (1):
      rcu: Don't invoke try_invoke_on_locked_down_task() with irqs disabled

Paul Moore (2):
      netlabel: fix our progress tracking in netlbl_unlabel_staticlist()
      netlabel: fix an uninitialized warning in netlbl_unlabel_staticlist()

PeiSen Hou (1):
      ALSA: hda/realtek: Add some Clove SSID in the ALC293(ALC1220)

Peter Zijlstra (2):
      sched: Fix data-race in wakeup
      sched: Fix rq->nr_iowait ordering

Qinglang Miao (1):
      RDMA/pvrdma: Fix missing kfree() in pvrdma_register_device()

Quentin Perret (1):
      sched/fair: Fix overutilized update in enqueue_task_fair()

Randy Dunlap (1):
      MIPS: export has_transparent_hugepage() for modules

Richard Weinberger (1):
      um: Call pgtable_pmd_page_dtor() in __pmd_free_tlb()

Rijo Thomas (2):
      tee: amdtee: fix memory leak due to reset of global shm list
      tee: amdtee: synchronize access to shm list

Rodrigo Vivi (1):
      drm/i915/tgl: Fix Media power gate sequence.

Ryan Sharpelletti (1):
      tcp: only postpone PROBE_RTT if RTT is < current min_rtt estimate

Sam Nobs (1):
      tty: serial: imx: fix potential deadlock

Samuel Thibault (1):
      speakup: Do not let the line discipline be used several times

Scott Mayhew (1):
      SUNRPC: Fix oops in the rpc_xdr_buf event class

Sean Nyekjaer (1):
      regulator: pfuze100: limit pfuze-support-disable-sw to pfuze{100,200}

Sebastian Andrzej Siewior (1):
      atm: nicstar: Unmap DMA on send error

Sergey Matyukevich (1):
      arm: dts: imx6qdl-udoo: fix rgmii phy-mode for ksz9031 phy

Sergio Paracuellos (1):
      staging: mt7621-pci: avoid to request pci bus resources

Srinivasa Rao Mandadapu (1):
      ASoC: qcom: lpass-platform: Fix memory leak

Steen Hegelund (1):
      net: phy: mscc: remove non-MACSec compatible phy

Stefan Haberland (1):
      s390/dasd: fix null pointer dereference for ERP requests

Stefano Garzarella (1):
      vsock: forward all packets to the host when no H2G is registered

Stephen Rothwell (1):
      swiotlb: using SIZE_MAX needs limits.h included

Subash Abhinov Kasiviswanathan (1):
      net: qualcomm: rmnet: Fix incorrect receive packet handling during cleanup

Sven Van Asbroeck (3):
      lan743x: fix issue causing intermittent kernel log warnings
      lan743x: prevent entire kernel HANG on open, for some platforms
      spi: fix client driver breakages when using GPIO descriptors

Taehee Yoo (1):
      netdevsim: set .owner to THIS_MODULE

Takashi Iwai (1):
      ALSA: mixart: Fix mutex deadlock

Takashi Sakamoto (1):
      ALSA: ctl: fix error path at adding user-defined element set

Tariq Toukan (1):
      net/tls: Fix wrong record sn in async mode of device resync

Thomas Richter (1):
      s390/cpum_sf.c: fix file permission for cpum_sfb_size

Tobias Waldekranz (1):
      net: dsa: mv88e6xxx: Avoid VTU corruption on 6097

Tony Lindgren (2):
      Revert "Revert "gpio: omap: Fix lost edge wake-up interrupts""
      dmaengine: ti: omap-dma: Block PM if SDMA is busy to fix audio

Vadim Fedorenko (1):
      net/tls: fix corrupted data in recvmsg

Vamshi K Sthambamkadi (1):
      efivarfs: fix memory leak in efivarfs_create()

Ville Syrjälä (1):
      drm/i915: Handle max_bpc==16

Vincent Stehlé (1):
      net: ethernet: mtk-star-emac: return ok when xmit drops

Vladyslav Tarasiuk (2):
      net/mlx5: Clear bw_share upon VF disable
      net/mlx5: Disable QoS when min_rates on all VFs are zero

Wang Hai (4):
      devlink: Add missing genlmsg_cancel() in devlink_nl_sb_port_pool_fill()
      inet_diag: Fix error path to cancel the meseage in inet_req_diag_fill()
      tools, bpftool: Add missing close before bpftool net attach exit
      selftests/bpf: Fix error return code in run_getsockopt_test()

Wang Qing (1):
      net: ethernet: ti: am65-cpts: update ret when ptp_clock is ERROR

Will Deacon (3):
      arm64: errata: Fix handling of 1418040 with late CPU onlining
      arm64: psci: Avoid printing in cpu_psci_cpu_die()
      arm64: smp: Tell RCU about CPUs that fail to come online

Wong Vee Khee (1):
      net: stmmac: Use rtnl_lock/unlock on netif_set_real_num_rx_queues() call

Wu Bo (1):
      can: m_can: m_can_handle_state_change(): fix state change

Xie He (1):
      net: x25: Increase refcnt of "struct x25_neigh" in x25_rx_call_request

Xin Long (1):
      sctp: change to hold/put transport for proto_unreach_timer

Xiongfeng Wang (1):
      drm/sun4i: dw-hdmi: fix error return code in sun8i_dw_hdmi_bind()

Yi-Hung Wei (1):
      ip_tunnels: Set tunnel option flag when tunnel metadata is present

Yicong Yang (1):
      libfs: fix error cast of negative value in simple_attr_write()

Yu Kuai (1):
      xfs: return corresponding errcode if xfs_initialize_perag() fail

Zhang Changzhong (7):
      ah6: fix error return code in ah6_input()
      net: b44: fix error return code in b44_init_one()
      net: ethernet: mtk-star-emac: fix error return code in mtk_star_enable()
      net: ethernet: ti: cpsw: fix error return code in cpsw_probe()
      qed: fix error return code in qed_iwarp_ll2_start()
      qlcnic: fix error return code in qlcnic_83xx_restart_hw()
      IB/hfi1: Fix error return code in hfi1_init_dd()

Zhang Qilong (7):
      ipv6: Fix error path to cancel the meseage
      PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter
      net: fec: Fix reference count leak in fec series ops
      gfs2: fix possible reference leak in gfs2_check_blk_type
      can: ti_hecc: Fix memleak in ti_hecc_probe
      can: flexcan: fix failure handling of pm_runtime_get_sync()
      MIPS: Alchemy: Fix memleak in alchemy_clk_setup_cpu

Zheng Zengkai (1):
      serial: ar933x_uart: disable clk on error handling path in probe

Zhenzhong Duan (1):
      iommu/vt-d: Avoid panic if iommu init fails in tboot system

Zhihao Cheng (1):
      spi: cadence-quadspi: Fix error return code in cqspi_probe

jingle.wu (1):
      Input: elan_i2c - fix firmware update on newer ICs

