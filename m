Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24B0014D784
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 09:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgA3Iae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 03:30:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbgA3Iae (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 03:30:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1FC0206D5;
        Thu, 30 Jan 2020 08:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580373031;
        bh=dmHBVtaO7LMiH3hQxO/DsmOMInTCiFjatp2k3FubWL8=;
        h=Date:From:To:Cc:Subject:From;
        b=whiDFCuHZIXS1sjWk0CI6SWhAW4I1fyxZpc7K7t9W+ohMvR+Nn4YGyzcD4ueEXEL0
         FTyK3wBlB62d7te1kDtWJ2kN6xqSBeoxRMWOKPhjtUK31E65bxMcTK2re45hqqvNtp
         gnQg4+hyVYFRkroIdhM4oHIWXcQwR4Ea/H0Neb0Y=
Date:   Thu, 30 Jan 2020 09:30:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.212
Message-ID: <20200130083028.GA646019@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.212 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt                 |    6 +
 Makefile                                            |    2=20
 arch/arm/boot/dts/lpc3250-phy3250.dts               |    4=20
 arch/arm/boot/dts/lpc32xx.dtsi                      |   10 +
 arch/arm/boot/dts/ls1021a-twr.dts                   |    9 +
 arch/arm/boot/dts/ls1021a.dtsi                      |   11 +
 arch/arm/common/mcpm_entry.c                        |    2=20
 arch/arm/include/asm/suspend.h                      |    1=20
 arch/arm/kernel/hyp-stub.S                          |    4=20
 arch/arm/kernel/sleep.S                             |   12 ++
 arch/arm/mach-omap2/omap_hwmod.c                    |    2=20
 arch/arm/mach-rpc/irq.c                             |    3=20
 arch/arm/plat-pxa/ssp.c                             |    6 -
 arch/arm64/boot/dts/arm/juno-clocks.dtsi            |    4=20
 arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi           |    2=20
 arch/arm64/kernel/cpufeature.c                      |    5=20
 arch/m68k/amiga/cia.c                               |    9 +
 arch/m68k/atari/ataints.c                           |    4=20
 arch/m68k/atari/time.c                              |   15 ++
 arch/m68k/bvme6000/config.c                         |   20 +--
 arch/m68k/hp300/time.c                              |   10 +
 arch/m68k/mac/via.c                                 |  119 +++++++++++----=
-----
 arch/m68k/mvme147/config.c                          |   18 +--
 arch/m68k/mvme16x/config.c                          |   21 +--
 arch/m68k/q40/q40ints.c                             |   19 +--
 arch/m68k/sun3/sun3ints.c                           |    3=20
 arch/m68k/sun3x/time.c                              |   16 +-
 arch/mips/include/asm/io.h                          |   14 --
 arch/mips/kernel/setup.c                            |    2=20
 arch/nios2/kernel/nios2_ksyms.c                     |   12 ++
 arch/powerpc/Makefile                               |    2=20
 arch/powerpc/include/asm/archrandom.h               |    2=20
 arch/powerpc/kernel/cacheinfo.c                     |   17 ++
 arch/powerpc/kernel/cacheinfo.h                     |    4=20
 arch/x86/Kconfig.debug                              |    2=20
 arch/x86/kernel/kgdb.c                              |    2=20
 block/blk-merge.c                                   |    8 -
 crypto/pcrypt.c                                     |    2=20
 crypto/tgr192.c                                     |    6 -
 drivers/ata/libahci.c                               |    1=20
 drivers/atm/firestream.c                            |    3=20
 drivers/bcma/driver_pci.c                           |    4=20
 drivers/block/drbd/drbd_main.c                      |    2=20
 drivers/clk/clk-highbank.c                          |    1=20
 drivers/clk/clk-qoriq.c                             |    1=20
 drivers/clk/imx/clk-imx6q.c                         |    1=20
 drivers/clk/imx/clk-imx6sx.c                        |    1=20
 drivers/clk/imx/clk-imx7d.c                         |    1=20
 drivers/clk/imx/clk-vf610.c                         |    1=20
 drivers/clk/mvebu/armada-370.c                      |    4=20
 drivers/clk/mvebu/armada-xp.c                       |    4=20
 drivers/clk/mvebu/dove.c                            |    8 +
 drivers/clk/mvebu/kirkwood.c                        |    2=20
 drivers/clk/qcom/gcc-msm8996.c                      |   36 ------
 drivers/clk/samsung/clk-exynos4.c                   |    1=20
 drivers/clk/socfpga/clk-pll-a10.c                   |    1=20
 drivers/clk/socfpga/clk-pll.c                       |    1=20
 drivers/clk/sunxi-ng/ccu-sun8i-a23.c                |    2=20
 drivers/clocksource/exynos_mct.c                    |   14 ++
 drivers/clocksource/timer-sun5i.c                   |   10 +
 drivers/crypto/amcc/crypto4xx_trng.h                |    4=20
 drivers/crypto/caam/caamrng.c                       |    5=20
 drivers/crypto/ccp/ccp-crypto-aes.c                 |    8 -
 drivers/dma/dma-axi-dmac.c                          |    2=20
 drivers/dma/dw/platform.c                           |   14 ++
 drivers/dma/edma.c                                  |    6 -
 drivers/dma/hsu/hsu.c                               |    4=20
 drivers/dma/imx-sdma.c                              |    8 +
 drivers/dma/mv_xor.c                                |    2=20
 drivers/dma/tegra210-adma.c                         |   72 +++++++++---
 drivers/gpu/drm/drm_dp_mst_topology.c               |   15 ++
 drivers/gpu/drm/etnaviv/etnaviv_dump.c              |    2=20
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c               |   24 +---
 drivers/gpu/drm/msm/dsi/dsi_host.c                  |    6 -
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c             |    2=20
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gddr3.c      |    2=20
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/memx.c      |    4=20
 drivers/gpu/drm/radeon/cik.c                        |    4=20
 drivers/gpu/drm/radeon/r600.c                       |    4=20
 drivers/gpu/drm/radeon/si.c                         |    4=20
 drivers/gpu/drm/sti/sti_hda.c                       |    1=20
 drivers/gpu/drm/sti/sti_hdmi.c                      |    1=20
 drivers/gpu/drm/virtio/virtgpu_vq.c                 |    5=20
 drivers/hwmon/adt7475.c                             |    5=20
 drivers/hwmon/hwmon.c                               |   98 ++++++++++------
 drivers/hwmon/lm75.c                                |    2=20
 drivers/hwmon/nct7802.c                             |    4=20
 drivers/hwmon/shtc1.c                               |    2=20
 drivers/hwmon/w83627hf.c                            |   42 ++++++-
 drivers/hwtracing/coresight/coresight-etb10.c       |    4=20
 drivers/hwtracing/coresight/coresight-tmc-etf.c     |    4=20
 drivers/iio/dac/ad5380.c                            |    2=20
 drivers/infiniband/hw/cxgb4/cm.c                    |    7 -
 drivers/infiniband/hw/hns/hns_roce_qp.c             |    1=20
 drivers/infiniband/hw/mlx5/qp.c                     |   21 +++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c         |    2=20
 drivers/infiniband/hw/qedr/verbs.c                  |    2=20
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c        |    2=20
 drivers/infiniband/sw/rxe/rxe_cq.c                  |    4=20
 drivers/infiniband/sw/rxe/rxe_qp.c                  |    5=20
 drivers/infiniband/ulp/iser/iscsi_iser.h            |    2=20
 drivers/infiniband/ulp/iser/iser_memory.c           |   10 -
 drivers/infiniband/ulp/isert/ib_isert.c             |   12 --
 drivers/input/keyboard/nomadik-ske-keypad.c         |    2=20
 drivers/input/misc/keyspan_remote.c                 |    9 +
 drivers/input/tablet/aiptek.c                       |    6 -
 drivers/input/tablet/gtco.c                         |   10 -
 drivers/input/tablet/pegasus_notetaker.c            |    2=20
 drivers/input/touchscreen/sun4i-ts.c                |    6 -
 drivers/input/touchscreen/sur40.c                   |    2=20
 drivers/iommu/amd_iommu.c                           |    2=20
 drivers/iommu/amd_iommu_init.c                      |    3=20
 drivers/iommu/intel-iommu.c                         |    5=20
 drivers/iommu/iommu.c                               |    6 -
 drivers/md/bcache/super.c                           |    3=20
 drivers/md/bitmap.c                                 |    8 -
 drivers/media/i2c/ov2659.c                          |    2=20
 drivers/media/i2c/soc_camera/ov6650.c               |   72 ++++++++----
 drivers/media/pci/cx18/cx18-fileops.c               |    2=20
 drivers/media/pci/cx23885/cx23885-dvb.c             |    5=20
 drivers/media/pci/ivtv/ivtv-fileops.c               |    2=20
 drivers/media/pci/tw5864/tw5864-video.c             |    4=20
 drivers/media/platform/davinci/isif.c               |    9 -
 drivers/media/platform/davinci/vpbe.c               |    2=20
 drivers/media/platform/omap/omap_vout.c             |   15 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c         |    2=20
 drivers/media/platform/vivid/vivid-osd.c            |    2=20
 drivers/media/radio/wl128x/fmdrv_common.c           |    5=20
 drivers/mfd/intel-lpss.c                            |    1=20
 drivers/misc/mic/card/mic_x100.c                    |   28 ++--
 drivers/misc/sgi-xp/xpc_partition.c                 |    2=20
 drivers/mmc/host/sdhci-brcmstb.c                    |    4=20
 drivers/mmc/host/sdhci-tegra.c                      |    2=20
 drivers/mmc/host/sdhci.c                            |   10 +
 drivers/net/can/slcan.c                             |   12 +-
 drivers/net/dsa/qca8k.c                             |   12 ++
 drivers/net/dsa/qca8k.h                             |    1=20
 drivers/net/ethernet/amazon/ena/ena_com.c           |    3=20
 drivers/net/ethernet/amazon/ena/ena_ethtool.c       |    4=20
 drivers/net/ethernet/amazon/ena/ena_netdev.c        |    1=20
 drivers/net/ethernet/broadcom/bcmsysport.c          |    2=20
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c     |    2=20
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c       |    2=20
 drivers/net/ethernet/ibm/ehea/ehea_main.c           |    2=20
 drivers/net/ethernet/mellanox/mlxsw/reg.h           |   22 +++
 drivers/net/ethernet/natsemi/sonic.c                |    6 -
 drivers/net/ethernet/pasemi/pasemi_mac.c            |    2=20
 drivers/net/ethernet/qlogic/qed/qed_l2.c            |   34 ++---
 drivers/net/ethernet/qualcomm/qca_spi.c             |    9 -
 drivers/net/ethernet/qualcomm/qca_spi.h             |    1=20
 drivers/net/ethernet/renesas/sh_eth.c               |    6 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c   |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c    |    2=20
 drivers/net/gtp.c                                   |    4=20
 drivers/net/phy/fixed_phy.c                         |    6 -
 drivers/net/phy/phy.c                               |    3=20
 drivers/net/phy/phy_device.c                        |   11 +
 drivers/net/slip/slip.c                             |   12 +-
 drivers/net/usb/lan78xx.c                           |   15 ++
 drivers/net/wireless/ath/ath9k/dynack.c             |    8 -
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c         |   12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c       |    2=20
 drivers/net/wireless/marvell/libertas/cfg.c         |   16 ++
 drivers/net/wireless/marvell/libertas_tf/cmd.c      |    2=20
 drivers/net/wireless/mediatek/mt7601u/phy.c         |    2=20
 drivers/nvme/host/pci.c                             |    2=20
 drivers/of/of_mdio.c                                |    2=20
 drivers/pinctrl/sh-pfc/pfc-emev2.c                  |   20 +++
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c                |    3=20
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c                |    8 -
 drivers/pinctrl/sh-pfc/pfc-r8a7792.c                |    1=20
 drivers/pinctrl/sh-pfc/pfc-r8a7794.c                |    2=20
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                 |    2=20
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c                 |    4=20
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                 |    4=20
 drivers/platform/mips/cpu_hwmon.c                   |    2=20
 drivers/platform/x86/alienware-wmi.c                |    2=20
 drivers/power/supply/power_supply_core.c            |   10 -
 drivers/pwm/pwm-lpss.c                              |    6 +
 drivers/pwm/pwm-meson.c                             |    5=20
 drivers/rapidio/rio_cm.c                            |    4=20
 drivers/regulator/pv88060-regulator.c               |    2=20
 drivers/regulator/pv88080-regulator.c               |    2=20
 drivers/regulator/pv88090-regulator.c               |    2=20
 drivers/regulator/tps65086-regulator.c              |    4=20
 drivers/regulator/wm831x-dcdc.c                     |    4=20
 drivers/rtc/rtc-88pm80x.c                           |   21 ++-
 drivers/rtc/rtc-88pm860x.c                          |   21 ++-
 drivers/rtc/rtc-ds1672.c                            |    3=20
 drivers/rtc/rtc-mc146818-lib.c                      |    2=20
 drivers/rtc/rtc-pcf8563.c                           |   11 -
 drivers/rtc/rtc-pm8xxx.c                            |    6 -
 drivers/scsi/libfc/fc_exch.c                        |    2=20
 drivers/scsi/megaraid/megaraid_sas_base.c           |    4=20
 drivers/scsi/qla2xxx/qla_os.c                       |   34 +++--
 drivers/scsi/scsi_transport_iscsi.c                 |    7 +
 drivers/soc/fsl/qe/gpio.c                           |    4=20
 drivers/spi/spi-bcm2835aux.c                        |   13 ++
 drivers/spi/spi-fsl-spi.c                           |    2=20
 drivers/spi/spi-tegra114.c                          |   45 ++++++-
 drivers/staging/comedi/drivers/ni_mio_common.c      |   24 ++--
 drivers/staging/greybus/light.c                     |   12 +-
 drivers/staging/most/aim-cdev/cdev.c                |    5=20
 drivers/target/iscsi/iscsi_target.c                 |    6 -
 drivers/thermal/cpu_cooling.c                       |    2=20
 drivers/thermal/mtk_thermal.c                       |    6 -
 drivers/tty/ipwireless/hardware.c                   |    2=20
 drivers/tty/serial/stm32-usart.c                    |   11 -
 drivers/usb/class/cdc-wdm.c                         |    2=20
 drivers/usb/host/xhci-hub.c                         |    2=20
 drivers/usb/phy/Kconfig                             |    2=20
 drivers/usb/phy/phy-twl6030-usb.c                   |    2=20
 drivers/vfio/pci/vfio_pci.c                         |   19 ++-
 drivers/video/backlight/lm3630a_bl.c                |    4=20
 drivers/video/fbdev/chipsfb.c                       |    3=20
 drivers/xen/cpu_hotplug.c                           |    2=20
 fs/afs/super.c                                      |    1=20
 fs/btrfs/inode-map.c                                |    1=20
 fs/cifs/connect.c                                   |    3=20
 fs/exportfs/expfs.c                                 |    1=20
 fs/ext4/inline.c                                    |    2=20
 fs/jfs/jfs_txnmgr.c                                 |    3=20
 fs/namei.c                                          |   17 +-
 fs/nfs/delegation.c                                 |   20 ++-
 fs/nfs/delegation.h                                 |    1=20
 fs/nfs/super.c                                      |    2=20
 fs/xfs/xfs_quotaops.c                               |    3=20
 include/linux/bitmap.h                              |    8 +
 include/linux/device.h                              |    3=20
 include/linux/mlx5/mlx5_ifc.h                       |    2=20
 include/linux/netfilter/ipset/ip_set.h              |    7 -
 include/linux/platform_data/dma-imx-sdma.h          |    3=20
 include/linux/signal.h                              |   15 ++
 include/media/davinci/vpbe.h                        |    2=20
 include/trace/events/xen.h                          |    6 -
 include/uapi/linux/ethtool.h                        |    6 -
 kernel/debug/kdb/kdb_main.c                         |    2=20
 kernel/events/core.c                                |    3=20
 kernel/signal.c                                     |    5=20
 lib/bitmap.c                                        |   20 +++
 lib/devres.c                                        |    3=20
 lib/kfifo.c                                         |    3=20
 net/6lowpan/nhc.c                                   |    2=20
 net/bridge/netfilter/ebtables.c                     |    4=20
 net/core/ethtool.c                                  |    2=20
 net/core/neighbour.c                                |    4=20
 net/ieee802154/6lowpan/reassembly.c                 |    2=20
 net/ipv4/ip_tunnel.c                                |    4=20
 net/ipv4/tcp_bbr.c                                  |    3=20
 net/ipv6/ip6_tunnel.c                               |    4=20
 net/ipv6/reassembly.c                               |    2=20
 net/iucv/af_iucv.c                                  |   27 +++-
 net/l2tp/l2tp_core.c                                |    3=20
 net/llc/af_llc.c                                    |   34 +++--
 net/llc/llc_conn.c                                  |   35 +----
 net/llc/llc_if.c                                    |   12 +-
 net/mac80211/rc80211_minstrel_ht.c                  |    2=20
 net/mac80211/rx.c                                   |   11 +
 net/netfilter/ipset/ip_set_bitmap_gen.h             |    2=20
 net/netfilter/ipset/ip_set_bitmap_ip.c              |    6 -
 net/netfilter/ipset/ip_set_bitmap_ipmac.c           |    6 -
 net/netfilter/ipset/ip_set_bitmap_port.c            |    6 -
 net/packet/af_packet.c                              |   25 +++-
 net/rds/ib_stats.c                                  |    2=20
 net/rxrpc/output.c                                  |    3=20
 net/sched/act_mirred.c                              |    6 -
 net/sched/ematch.c                                  |    2=20
 net/sched/sch_netem.c                               |   18 ++-
 net/tipc/node.c                                     |    7 -
 net/tipc/sysctl.c                                   |    8 +
 net/x25/af_x25.c                                    |    6 -
 scripts/recordmcount.c                              |   17 ++
 security/keys/key.c                                 |    1=20
 sound/aoa/codecs/onyx.c                             |    4=20
 sound/pci/hda/hda_controller.h                      |    9 -
 sound/soc/codecs/cs4349.c                           |    1=20
 sound/soc/codecs/es8328.c                           |    2=20
 sound/soc/codecs/wm8737.c                           |    2=20
 sound/soc/davinci/davinci-mcasp.c                   |   13 +-
 sound/soc/fsl/imx-sgtl5000.c                        |    3=20
 sound/soc/qcom/apq8016_sbc.c                        |   21 ++-
 sound/soc/soc-pcm.c                                 |    4=20
 sound/soc/sunxi/sun4i-i2s.c                         |    4=20
 sound/usb/mixer.c                                   |    4=20
 sound/usb/quirks-table.h                            |    9 -
 287 files changed, 1446 insertions(+), 802 deletions(-)

Akinobu Mita (1):
      media: ov2659: fix unbalanced mutex_lock/unlock

Al Viro (1):
      do_last(): fetch directory ->i_mode and ->i_uid before it's too late

Alex Sverdlin (1):
      ARM: 8950/1: ftrace/recordmcount: filter relocation types

Alexandru Ardelean (1):
      dmaengine: axi-dmac: Don't check the number of frames for alignment

Anders Roxell (1):
      ALSA: hda: fix unused variable warning

Andre Przywara (1):
      arm64: dts: juno: Fix UART frequency

Andy Shevchenko (6):
      dmaengine: hsu: Revert "set HSU_CH_MTSR to memory width"
      mfd: intel-lpss: Release IDA resources
      dmaengine: dw: platform: Switch to acpi_dma_controller_register()
      ahci: Do not export local variable ahci_em_messages
      md: Avoid namespace collision with bitmap API
      bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()

Antonio Borneo (1):
      net: stmmac: fix length of PTP clock's name string

Ard Biesheuvel (2):
      powerpc/archrandom: fix arch_get_random_seed_int()
      nvme: retain split access workaround for capability reads

Arnd Bergmann (6):
      jfs: fix bogus variable self-initialization
      media: davinci-isif: avoid uninitialized variable use
      usb: gadget: fsl: fix link error against usb-gadget module
      devres: allow const resource arguments
      qed: reduce maximum stack frame size
      mic: avoid statically declaring a 'struct device'.

Axel Lin (5):
      regulator: pv88060: Fix array out-of-bounds access
      regulator: pv88080: Fix array out-of-bounds access
      regulator: pv88090: Fix array out-of-bounds access
      regulator: wm831x-dcdc: Fix list of wm831x_dcdc_ilim from mA to uA
      regulator: tps65086: Fix tps65086_ldoa1_ranges for selector 0xB

Bart Van Assche (2):
      scsi: qla2xxx: Unregister chrdev if module initialization fails
      scsi: RDMA/isert: Fix a recently introduced regression related to log=
out

Ben Hutchings (1):
      powerpc: vdso: Make vdso32 installation conditional in vdso_install

Bichao Zheng (1):
      pwm: meson: Don't disable PWM when setting duty repeatedly

Bo Wu (1):
      scsi: iscsi: Avoid potential deadlock in iscsi_if_rx func

Brian Masney (1):
      backlight: lm3630a: Return 0 on success in update_status functions

Changbin Du (1):
      tracing: xen: Ordered comparison of function pointers

Chen-Yu Tsai (3):
      clk: sunxi-ng: sun8i-a23: Enable PLL-MIPI LDOs when ungating it
      clocksource/drivers/sun5i: Fail gracefully when clock rate is unavail=
able
      rtc: pcf8563: Clear event flags and disable interrupts before request=
ing irq

Christophe Leroy (1):
      spi: spi-fsl-spi: call spi_finalize_current_message() at the end

Chuhong Yuan (2):
      dmaengine: ti: edma: fix missed failure handling
      Input: sun4i-ts - add a check for devm_thermal_zone_of_sensor_register

Colin Ian King (13):
      pcrypt: use format specifier in kobject_add
      staging: most: cdev: add missing check for cdev_add failure
      rtc: ds1672: fix unintended sign extension
      rtc: 88pm860x: fix unintended sign extension
      rtc: 88pm80x: fix unintended sign extension
      rtc: pm8xxx: fix unintended sign extension
      drm/nouveau/bios/ramcfg: fix missing parentheses when calculating RON
      drm/nouveau/pmu: don't print reply values if exec is false
      media: vivid: fix incorrect assignment operation when setting video m=
ode
      scsi: libfc: fix null pointer dereference on a null lport
      ext4: set error return correctly when ext4_htree_store_dirent fails
      bcma: fix incorrect update of BCMA_CORE_PCI_MDIO_DATA
      iio: dac: ad5380: fix incorrect assignment to val

Cong Wang (1):
      net_sched: fix datalen for ematch

Corentin Labbe (1):
      crypto: crypto4xx - Fix wrong ppc4xx_trng_probe()/ppc4xx_trng_remove(=
) arguments

Dan Carpenter (21):
      drm/virtio: fix bounds check in virtio_gpu_cmd_get_capset()
      Input: nomadik-ske-keypad - fix a loop timeout test
      drm/etnaviv: NULL vs IS_ERR() buf in etnaviv_core_dump()
      drivers/rapidio/rio_cm.c: fix potential oops in riocm_ch_listen()
      xen, cpu_hotplug: Prevent an out of bounds access
      media: ivtv: update *pos correctly in ivtv_read_pos()
      media: cx18: update *pos correctly in cx18_read_pos()
      media: wl128x: Fix an error code in fm_download_firmware()
      soc/fsl/qe: Fix an error code in qe_pin_request()
      6lowpan: Off by one handling ->nexthdr
      media: omap_vout: potential buffer overflow in vidioc_dqbuf()
      media: davinci/vpbe: array underflow in vpbe_enum_outputs()
      platform/x86: alienware-wmi: printing the wrong error code
      kdb: do a sanity check on the cpu in kdb_per_cpu()
      staging: greybus: light: fix a couple double frees
      net: hisilicon: Fix signedness bug in hix5hd2_dev_probe()
      net: broadcom/bcmsysport: Fix signedness in bcm_sysport_probe()
      net: stmmac: dwmac-meson8b: Fix signedness bug in probe
      of: mdio: Fix a signedness bug in of_phy_get_and_connect()
      net: ethernet: stmmac: Fix signedness bug in ipq806x_gmac_of_parse()
      bcache: silence static checker warning

Dan Robertson (1):
      hwmon: (shtc1) fix shtc1 and shtw1 id mask

David Howells (2):
      keys: Timestamp new keys
      rxrpc: Fix uninitialized error code in rxrpc_send_data_packet()

Dmitry Osipenko (1):
      hwmon: (core) Fix double-free in __hwmon_device_register()

Eric Auger (1):
      vfio_pci: Enable memory accesses before calling pci_map_rom

Eric Biggers (3):
      crypto: tgr192 - fix unaligned memory access
      llc: fix another potential sk_buff leak in llc_ui_sendmsg()
      llc: fix sk_buff refcounting in llc_conn_state_process()

Eric Dumazet (4):
      inet: frags: call inet_frags_fini() after unregister_pernet_subsys()
      net: neigh: use long type to store jiffies delta
      packet: fix data-race in fanout_flow_is_huge()
      gtp: make sure only SOCK_DGRAM UDP sockets are accepted

Eric W. Biederman (3):
      fs/nfs: Fix nfs_parse_devname to not modify it's argument
      signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of for=
ce_sig
      signal: Allow cifs and drbd to receive their terminating signals

Eric Wong (1):
      rtc: cmos: ignore bogus century byte

Erwan Le Ray (1):
      serial: stm32: fix transmit_chars when tx is stopped

Felix Fietkau (1):
      mac80211: minstrel_ht: fix per-group max throughput rate initializati=
on

Filipe Manana (1):
      Btrfs: fix hang when loading existing inode cache off disk

Filippo Sironi (1):
      iommu/amd: Wait for completion of IOTLB flush in attach_device

Finn Thain (2):
      m68k: mac: Fix VIA timer counter accesses
      m68k: Call timer_interrupt() with interrupts disabled

Florian Fainelli (2):
      net: ethtool: Add back transceiver type
      net: phy: Keep reporting transceiver type

Florian Westphal (1):
      netfilter: ebtables: CONFIG_COMPAT: reject trailing data after last r=
ule

Gal Pressman (3):
      IB/usnic: Fix out of bounds index check in query pkey
      RDMA/ocrdma: Fix out of bounds index check in query pkey
      RDMA/qedr: Fix out of bounds index check in query pkey

Geert Uytterhoeven (13):
      pinctrl: sh-pfc: r8a7740: Add missing REF125CK pin to gether_gmii gro=
up
      pinctrl: sh-pfc: r8a7740: Add missing LCD0 marks to lcd0_data24_1 gro=
up
      pinctrl: sh-pfc: r8a7791: Remove bogus ctrl marks from qspi_data4_b g=
roup
      pinctrl: sh-pfc: r8a7791: Remove bogus marks from vin1_b_data18 group
      pinctrl: sh-pfc: sh73a0: Add missing TO pin to tpu4_to3 group
      pinctrl: sh-pfc: r8a7794: Remove bogus IPSR9 field
      pinctrl: sh-pfc: sh7734: Add missing IPSR11 field
      pinctrl: sh-pfc: sh7269: Add missing PCIOR0 field
      pinctrl: sh-pfc: sh7734: Remove bogus IPSR10 value
      pinctrl: sh-pfc: emev2: Add missing pinmux functions
      pinctrl: sh-pfc: r8a7791: Fix scifb2_data_c pin group
      pinctrl: sh-pfc: r8a7792: Fix vin1_data18_b pin group
      pinctrl: sh-pfc: sh73a0: Fix fsic_spdif pin groups

Gerd Rausch (1):
      net/rds: Fix 'ib_evt_handler_call' element in 'rds_ib_stat_names'

Gilles Buloz (1):
      hwmon: (nct7802) Fix voltage limits to wrong registers

Greg Kroah-Hartman (1):
      Linux 4.9.212

Guenter Roeck (5):
      nios2: ksyms: Add missing symbol exports
      hwmon: (w83627hf) Use request_muxed_region for Super-IO accesses
      hwmon: (lm75) Fix write operations for negative temperatures
      hwmon: (core) Simplify sysfs attribute name allocation
      hwmon: (core) Do not use device managed functions for memory allocati=
ons

Hans de Goede (1):
      pwm: lpss: Release runtime-pm reference from the driver's remove call=
back

Hook, Gary (1):
      crypto: ccp - fix AES CFB error exposed by new test vectors

Israel Rukshin (1):
      IB/iser: Pass the correct number of entries for dma mapped SGL

Iuliana Prodan (1):
      crypto: caam - free resources in case caam_rng registration failed

Jack Morgenstein (1):
      IB/mlx5: Add missing XRC options to QP optional params mask

Jakub Kicinski (3):
      net: netem: fix backlog accounting for corrupted GSO frames
      net: netem: fix error path for corrupted GSO frames
      net: netem: correct the parent's backlog when corrupted packet was dr=
opped

James Hughes (1):
      net: usb: lan78xx: Add .ndo_features_check

Jan Kara (1):
      xfs: Sanity check flags of Q_XQUOTARM call

Janusz Krzysztofik (3):
      media: ov6650: Fix incorrect use of JPEG colorspace
      media: ov6650: Fix some format attributes not under control
      media: ov6650: Fix .get_fmt() V4L2_SUBDEV_FORMAT_TRY support

Jeffrey Hugo (2):
      drm/msm/mdp5: Fix mdp5_cfg_init error return
      drm/msm/dsi: Implement reset correctly

Jeremy Linton (1):
      Documentation: Document arm64 kpti control

Jerome Brunet (1):
      ASoC: fix valid stream condition

Jie Liu (1):
      tipc: set sysctl_tipc_rmem and named_timeout right range

Johan Hovold (5):
      Input: keyspan-remote - fix control-message timeouts
      Input: sur40 - fix interface sanity checks
      Input: gtco - fix endpoint sanity check
      Input: aiptek - fix endpoint sanity check
      Input: pegasus_notetaker - fix endpoint sanity check

Johannes Berg (3):
      iwlwifi: mvm: fix A-MPDU reference assignment
      ALSA: aoa: onyx: always initialize register read value
      mac80211: accept deauth frames in IBSS mode

Jon Hunter (1):
      dmaengine: tegra210-adma: Fix crash during probe

Jon Maloy (1):
      tipc: tipc clang warning

Jose Abreu (1):
      net: stmmac: gmac4+: Not all Unicast addresses may be available

Julian Wiedmann (1):
      net/af_iucv: always register net_device notifier

Kadlecsik J=C3=B3zsef (1):
      netfilter: ipset: use bitmap infrastructure completely

Kangjie Lu (1):
      net: sh_eth: fix a missing check of of_get_phy_mode

Kevin Mitchell (1):
      iommu/amd: Make iommu_disable safer

Linus Torvalds (1):
      Partially revert "kfifo: fix kfifo_alloc() and kfifo_init()"

Linus Walleij (1):
      hwmon: Deal with errors from the thermal subsystem

Loic Poulain (1):
      arm64: dts: apq8016-sbc: Increase load on l11 for SDCARD

Lorenzo Bianconi (2):
      mt7601u: fix bbp version check in mt7601u_wait_bbp_ready
      ath9k: dynack: fix possible deadlock in ath_dynack_node_{de}init

Lu Baolu (2):
      iommu/vt-d: Make kernel parameter igfx_off work with vIOMMU
      iommu: Use right function to get group for device

Luuk Paulussen (1):
      hwmon: (adt7475) Make volt2reg return same reg as reg2volt input

Lyude Paul (1):
      drm/dp_mst: Skip validating ports during destruction, just ref

Mao Wenan (2):
      net: sonic: return NETDEV_TX_OK if failed to map buffer
      net: sonic: replace dev_kfree_skb in sonic_send_packet

Marc Dionne (1):
      afs: Fix large file support

Marek Szyprowski (2):
      clocksource/drivers/exynos_mct: Fix error path in timer resources ini=
tialization
      ARM: 8847/1: pm: fix HYP/SVC mode mismatch when MCPM is used

Mark Zhang (1):
      net/mlx5: Fix mlx5_ifc_query_lag_out_bits

Martin Schiller (1):
      net/x25: fix nonblocking connect

Martin Sperl (1):
      spi: bcm2835aux: fix driver to not allow 65535 (=3D-1) cs-gpios

Masami Hiramatsu (1):
      x86, perf: Fix the dependency of the x86 insn decoder selftest

Matthias Kaehlcke (1):
      thermal: cpu_cooling: Actually trace CPU load in thermal_power_cpu_ge=
t_power

Max Gurtovoy (1):
      IB/iser: Fix dma_nents type definition

Maxime Ripard (1):
      ASoC: sun4i-i2s: RX and TX counter registers are swapped

Michael Ellerman (1):
      net: cxgb3_main: Add CAP_NET_ADMIN check to CHELSIO_GET_MEM

Michael Kao (1):
      thermal: mediatek: fix register index error

Micha=C5=82 Miros=C5=82aw (2):
      mmc: tegra: fix SDR50 tuning override
      mmc: sdhci: fix minimum clock rate for v3 controller

Ming Lei (1):
      block: don't use bio->bi_vcnt to figure out segment number

Moritz Fischer (1):
      net: phy: fixed_phy: Fix fixed_phy not checking GPIO

Nathan Chancellor (1):
      misc: sgi-xp: Properly initialize buf in xpc_get_rsvd_page_pa

Nathan Huckleberry (1):
      clk: qcom: Fix -Wunused-const-variable

Nathan Lynch (1):
      powerpc/cacheinfo: add cacheinfo_teardown, cacheinfo_rebuild

Nicholas Mc Guire (1):
      media: cx23885: check allocation return

Nick Desaulniers (1):
      mips: avoid explicit UB in assignment of mips_io_port_base

Nicolas Huaman (1):
      ALSA: usb-audio: update quirk for B&W PX to remove microphone

Pawe? Chmiel (1):
      media: s5p-jpeg: Correct step and max values for V4L2_CID_JPEG_RESTAR=
T_INTERVAL

Peter Rosin (1):
      drm/sti: do not remove the drm_bridge that was never added

Peter Ujfalusi (1):
      ASoC: ti: davinci-mcasp: Fix slot mask settings when using multiple A=
XRs

Petr Machata (1):
      mlxsw: reg: QEEC: Add minimum shaper fields

Ravi Bangoria (1):
      perf/ioctl: Add check for the sample_period value

Richard Palethorpe (1):
      can, slip: Protect tty->disc_data in write_wakeup and close with RCU

Rob Clark (1):
      drm/msm/a3xx: remove TPL1 regs from snapshot

Robin Gong (1):
      dmaengine: imx-sdma: fix size check for sdma script_number

Robin Murphy (1):
      dmaengine: mv_xor: Use correct device for DMA API

Ruslan Bilovol (1):
      usb: host: xhci-hub: fix extra endianness conversion

Russell King (1):
      ARM: riscpc: fix lack of keyboard interrupts after irq conversion

Sam Bobroff (1):
      drm/radeon: fix bad DMA from INTERRUPT_CNTL2

Sameeh Jubran (4):
      net: ena: fix swapped parameters when calling ena_com_indirect_table_=
fill_entry
      net: ena: fix: Free napi resources when ena_up() fails
      net: ena: fix incorrect test of supported hash function
      net: ena: fix ena_com_fill_hash_function() implementation

Sameer Pujar (1):
      dmaengine: tegra210-adma: restore channel status

Sara Sharon (1):
      iwlwifi: mvm: fix RSS config command

Sowjanya Komatineni (2):
      spi: tegra114: clear packed bit for unpacked mode
      spi: tegra114: fix for unpacked mode transfers

Spencer E. Olson (1):
      staging: comedi: ni_mio_common: protect register write overflow

Stefan Agner (1):
      ASoC: imx-sgtl5000: put of nodes if finding codec fails

Stefan Wahren (2):
      mmc: sdhci-brcmstb: handle mmc_of_parse() errors during probe
      net: qca_spi: Move reset_count to struct qcaspi

Stephen Boyd (1):
      power: supply: Init device wakeup after device_add()

Steve French (1):
      cifs: fix rmmod regression in cifs.ko caused by force_sig changes

Steve Sistare (1):
      scsi: megaraid_sas: reduce module load time

Steve Wise (2):
      iw_cxgb4: use tos when importing the endpoint
      iw_cxgb4: use tos when finding ipv6 routes

Suzuki K Poulose (2):
      coresight: etb10: Do not call smp_processor_id from preemptible
      coresight: tmc-etf: Do not call smp_processor_id from preemptible

Sven Van Asbroeck (1):
      usb: phy: twl6030-usb: fix possible use-after-free on remove

Takashi Iwai (2):
      ASoC: qcom: Fix of-node refcount unbalance in apq8016_sbc_parse_of()
      ALSA: usb-audio: Handle the error from snd_usb_mixer_apply_create_qui=
rk()

Thomas Gleixner (1):
      x86/kgbd: Use NMI_VECTOR not APIC_DM_NMI

Tiezhu Yang (1):
      MIPS: Loongson: Fix return value of loongson_hwmon_init

Tony Lindgren (1):
      ARM: OMAP2+: Fix potentially uninitialized return value for _setup_re=
set()

Trond Myklebust (1):
      NFS: Fix a soft lockup in the delegation recovery code

Vinod Koul (1):
      net: dsa: qca8k: Enable delay for RGMII_ID mode

Vladimir Murzin (1):
      ARM: 8848/1: virt: Align GIC version check with arm64 counterpart

Vladimir Oltean (1):
      ARM: dts: ls1021: Fix SGMII PCS link remaining down after PHY disconn=
ect

Vladimir Zapolskiy (5):
      ARM: dts: lpc32xx: add required clocks property to keypad device node
      ARM: dts: lpc32xx: reparent keypad controller to SIC1
      ARM: dts: lpc32xx: fix ARM PrimeCell LCD controller variant
      ARM: dts: lpc32xx: fix ARM PrimeCell LCD controller clocks property
      ARM: dts: lpc32xx: phy3250: fix SD card regulator voltage

Wen Huang (1):
      libertas: Fix two buffer overflows at parsing bss descriptor

Wen Yang (2):
      net: pasemi: fix an use-after-free in pasemi_mac_phy_init()
      tcp_bbr: improve arithmetic division in bbr_update_bw()

Wenwen Wang (1):
      firestream: fix memory leaks

Will Deacon (1):
      arm64: kpti: Whitelist Cortex-A CPUs that don't implement the CSV3 fi=
eld

Willem de Bruijn (1):
      packet: in recvmsg msg_name return at least sizeof sockaddr_ll

William Dauchy (2):
      net, ip6_tunnel: fix namespaces move
      net, ip_tunnel: fix namespaces move

Xi Wang (1):
      RDMA/hns: Fixs hw access invalid dma memory error

Yangtao Li (12):
      clk: highbank: fix refcount leak in hb_clk_init()
      clk: qoriq: fix refcount leak in clockgen_init()
      clk: socfpga: fix refcount leak
      clk: samsung: exynos4: fix refcount leak in exynos4_get_xom()
      clk: imx6q: fix refcount leak in imx6q_clocks_init()
      clk: imx6sx: fix refcount leak in imx6sx_clocks_init()
      clk: imx7d: fix refcount leak in imx7d_clocks_init()
      clk: vf610: fix refcount leak in vf610_clocks_init()
      clk: armada-370: fix refcount leak in a370_clk_init()
      clk: kirkwood: fix refcount leak in kirkwood_clk_init()
      clk: armada-xp: fix refcount leak in axp_clk_init()
      clk: dove: fix refcount leak in dove_clk_init()

Yoshihiro Shimoda (1):
      net: phy: Fix not to call phy_resume() if PHY is not attached

YueHaibing (13):
      exportfs: fix 'passing zero to ERR_PTR()' warning
      tty: ipwireless: Fix potential NULL pointer dereference
      fbdev: chipsfb: remove set but not used variable 'size'
      cdc-wdm: pass return value of recover_from_urb_loss
      media: tw5864: Fix possible NULL pointer dereference in tw5864_handle=
_frame
      ehea: Fix a copy-paste err in ehea_init_port_res
      ARM: pxa: ssp: Fix "WARNING: invalid free of devm_ allocated data"
      l2tp: Fix possible NULL pointer dereference
      libertas_tf: Use correct channel range in lbtf_geo_init
      ASoC: es8328: Fix copy-paste error in es8328_right_line_controls
      ASoC: cs4349: Use PM ops 'cs4349_runtime_pm'
      ASoC: wm8737: Fix copy-paste error in wm8737_snd_controls
      act_mirred: Fix mirred_init_module error handling

Zhu Yanjun (1):
      IB/rxe: replace kvfree with vfree


--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4ylCIACgkQONu9yGCS
aT7KtQ//V7WTQggHgC4dmLlCK2Ko90kjzaWhYx82Nd1cqJiMfDUuGFmZLeoxzP4W
duzeOo86EOnBQzIJNIQbyHGTLv+etyVbf2Tirzb/MvHxfNADwiIgebpWjYLI6sua
nZ6FYVCCAGcw8IzGfgyplXLuM4rmbexvp05EehkY4HxT6pvIJGWO5yUEpwSPLsL0
j0kGej1FwG0FJYCLTmKDmOZst6G3buEb2F/FPtzg3Ps1IJOE6+2fQgiOZJ6rND1E
wnbiic0jJmugCvoO5v/EeD9c63KjLuPLawwSs2gFCZ52v3F8OK//l2JqzGk64bCP
rV6XwRT+dkyBhYIsev9JccU6QZdxlngqRcjrqzLhExtoDpyb4Xf928bWCtDqN0d0
QTN/FIL6pi+11yQjRrDcWGfQ6jYHn0ZjwiNVkIDUvN4xF0piCqrlc4Ry7vJW/NyK
eHRpIUxIfG85E0qQSWT+l7aKeREMHuZ8v9JAZjXR6xAZnqrW2jMnOmxE/NG83hkm
pMRTM/S39DvSucmeLdoySEKBOeujIxyxyrMcmdaJno+2dAnstf6VGvErAw4HL01g
vM+cp+TmTX5/2xJrjm80M22/XD9FgY7x+knkBOBEuM/p0TfpraF0mdhPznDbiu6k
jT34/9XIzFryGimRijBrlo+Yfc/XHaKP01I108pkhK+zcwHNh2I=
=z+cP
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
