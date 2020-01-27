Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 746BB14A712
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 16:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgA0PWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 10:22:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729321AbgA0PWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 10:22:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BE772071E;
        Mon, 27 Jan 2020 15:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580138555;
        bh=eSv4zRox3ZNhzSsCLLzRDpakbqaVg73onSYOUb9ZPUM=;
        h=Date:From:To:Cc:Subject:From;
        b=nWcaqjyOIcDVnCDZetGcvzyi7orJ5agnQTcnB0nvDFS8VhZvqvbM74cHBbShlOo21
         zGbv/NU9dfhjBkjADTExXKyxYcPxIZ6V8AHSSHDTkErF2pc1aSCAo30yE/RkQDxo4u
         j6DVSi3N9Ad9XZ2berRC8n1EDkSH9jBS3tBbOmkU=
Date:   Mon, 27 Jan 2020 16:22:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.168
Message-ID: <20200127152232.GA667804@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.168 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                      |    6=20
 arch/arm/boot/dts/lpc3250-phy3250.dts                         |    4=20
 arch/arm/boot/dts/lpc32xx.dtsi                                |   10=20
 arch/arm/boot/dts/ls1021a-twr.dts                             |    9=20
 arch/arm/boot/dts/ls1021a.dtsi                                |   11=20
 arch/arm/boot/dts/stm32h743i-eval.dts                         |    1=20
 arch/arm/boot/dts/sun8i-h3-beelink-x2.dts                     |    4=20
 arch/arm/common/mcpm_entry.c                                  |    2=20
 arch/arm/include/asm/suspend.h                                |    1=20
 arch/arm/kernel/hyp-stub.S                                    |    4=20
 arch/arm/kernel/sleep.S                                       |   12=20
 arch/arm/mach-omap2/omap_hwmod.c                              |    2=20
 arch/arm/mach-rpc/irq.c                                       |    3=20
 arch/arm/plat-pxa/ssp.c                                       |    6=20
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi                 |    3=20
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts  |    1=20
 arch/arm64/boot/dts/arm/juno-clocks.dtsi                      |    4=20
 arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi                     |    2=20
 arch/m68k/amiga/cia.c                                         |    9=20
 arch/m68k/atari/ataints.c                                     |    4=20
 arch/m68k/atari/time.c                                        |   15 -
 arch/m68k/bvme6000/config.c                                   |   20 -
 arch/m68k/hp300/time.c                                        |   10=20
 arch/m68k/mac/via.c                                           |  119 ++++-=
---
 arch/m68k/mvme147/config.c                                    |   18 -
 arch/m68k/mvme16x/config.c                                    |   21 -
 arch/m68k/q40/q40ints.c                                       |   19 -
 arch/m68k/sun3/sun3ints.c                                     |    3=20
 arch/m68k/sun3x/time.c                                        |   16 -
 arch/mips/bcm63xx/Makefile                                    |    6=20
 arch/mips/bcm63xx/boards/board_bcm963xx.c                     |   20 -
 arch/mips/bcm63xx/dev-dsp.c                                   |   56 ---
 arch/mips/include/asm/io.h                                    |   14=20
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_dev_dsp.h          |   14=20
 arch/mips/include/asm/mach-bcm63xx/board_bcm963xx.h           |    5=20
 arch/mips/kernel/setup.c                                      |    2=20
 arch/nios2/kernel/nios2_ksyms.c                               |   12=20
 arch/powerpc/Makefile                                         |    2=20
 arch/powerpc/include/asm/archrandom.h                         |    2=20
 arch/powerpc/kernel/cacheinfo.c                               |   21 +
 arch/powerpc/kernel/cacheinfo.h                               |    4=20
 arch/powerpc/kernel/dt_cpu_ftrs.c                             |   17 -
 arch/powerpc/kvm/book3s_64_vio.c                              |    1=20
 arch/powerpc/mm/dump_hashpagetable.c                          |    2=20
 arch/powerpc/platforms/pseries/mobility.c                     |   10=20
 arch/x86/Kconfig.debug                                        |    2=20
 arch/x86/kernel/kgdb.c                                        |    2=20
 arch/x86/mm/tlb.c                                             |    3=20
 block/blk-merge.c                                             |    8=20
 crypto/pcrypt.c                                               |    2=20
 crypto/tgr192.c                                               |    6=20
 drivers/ata/libahci.c                                         |    1=20
 drivers/base/core.c                                           |   20 -
 drivers/base/power/wakeup.c                                   |    2=20
 drivers/bcma/driver_pci.c                                     |    4=20
 drivers/block/drbd/drbd_main.c                                |    2=20
 drivers/clk/clk-highbank.c                                    |    1=20
 drivers/clk/clk-qoriq.c                                       |    1=20
 drivers/clk/imx/clk-imx6q.c                                   |    1=20
 drivers/clk/imx/clk-imx6sx.c                                  |    1=20
 drivers/clk/imx/clk-imx7d.c                                   |    1=20
 drivers/clk/imx/clk-vf610.c                                   |    1=20
 drivers/clk/mvebu/armada-370.c                                |    4=20
 drivers/clk/mvebu/armada-xp.c                                 |    4=20
 drivers/clk/mvebu/dove.c                                      |    8=20
 drivers/clk/mvebu/kirkwood.c                                  |    2=20
 drivers/clk/mvebu/mv98dx3236.c                                |    4=20
 drivers/clk/qcom/gcc-msm8996.c                                |   36 --
 drivers/clk/samsung/clk-exynos4.c                             |    1=20
 drivers/clk/socfpga/clk-pll-a10.c                             |    1=20
 drivers/clk/socfpga/clk-pll.c                                 |    1=20
 drivers/clk/sunxi-ng/ccu-sun8i-a23.c                          |    2=20
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c                          |   19 +
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.h                          |    6=20
 drivers/clocksource/exynos_mct.c                              |   14=20
 drivers/clocksource/timer-sun5i.c                             |   10=20
 drivers/cpufreq/brcmstb-avs-cpufreq.c                         |   12=20
 drivers/crypto/amcc/crypto4xx_trng.h                          |    4=20
 drivers/crypto/bcm/cipher.c                                   |    6=20
 drivers/crypto/caam/caamrng.c                                 |    5=20
 drivers/crypto/caam/error.c                                   |    2=20
 drivers/crypto/ccp/ccp-crypto-aes.c                           |    8=20
 drivers/crypto/ccp/ccp-ops.c                                  |   67 ++--
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c                       |   21 -
 drivers/dma/dma-axi-dmac.c                                    |    2=20
 drivers/dma/dw/platform.c                                     |   14=20
 drivers/dma/edma.c                                            |    6=20
 drivers/dma/hsu/hsu.c                                         |    4=20
 drivers/dma/imx-sdma.c                                        |    8=20
 drivers/dma/mv_xor.c                                          |    2=20
 drivers/dma/tegra210-adma.c                                   |   72 ++++
 drivers/edac/edac_mc.c                                        |   12=20
 drivers/gpu/drm/drm_dp_mst_topology.c                         |   15 -
 drivers/gpu/drm/etnaviv/etnaviv_dump.c                        |    2=20
 drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c                   |    2=20
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_fbdev.c             |    1=20
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c                         |   24 -
 drivers/gpu/drm/msm/dsi/dsi_host.c                            |    6=20
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c                       |    2=20
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gddr3.c                |    2=20
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/memx.c                |    4=20
 drivers/gpu/drm/radeon/cik.c                                  |    4=20
 drivers/gpu/drm/radeon/r600.c                                 |    4=20
 drivers/gpu/drm/radeon/si.c                                   |    4=20
 drivers/gpu/drm/shmobile/shmob_drm_drv.c                      |    4=20
 drivers/gpu/drm/sti/sti_hda.c                                 |    1=20
 drivers/gpu/drm/sti/sti_hdmi.c                                |    1=20
 drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c                   |    2=20
 drivers/gpu/drm/virtio/virtgpu_vq.c                           |    5=20
 drivers/hwmon/lm75.c                                          |    2=20
 drivers/hwmon/pmbus/tps53679.c                                |    9=20
 drivers/hwmon/shtc1.c                                         |    2=20
 drivers/hwmon/w83627hf.c                                      |   42 ++
 drivers/iio/dac/ad5380.c                                      |    2=20
 drivers/infiniband/core/cma.c                                 |    2=20
 drivers/infiniband/hw/cxgb4/cm.c                              |   24 -
 drivers/infiniband/hw/hfi1/chip.c                             |   26 +
 drivers/infiniband/hw/hns/hns_roce_qp.c                       |    1=20
 drivers/infiniband/hw/mlx5/qp.c                               |   21 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c                   |    2=20
 drivers/infiniband/hw/qedr/verbs.c                            |   27 -
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c                  |    2=20
 drivers/infiniband/sw/rxe/rxe_cq.c                            |    4=20
 drivers/infiniband/sw/rxe/rxe_pool.c                          |   26 -
 drivers/infiniband/sw/rxe/rxe_qp.c                            |    5=20
 drivers/infiniband/ulp/iser/iscsi_iser.h                      |    2=20
 drivers/infiniband/ulp/iser/iser_memory.c                     |   10=20
 drivers/input/keyboard/nomadik-ske-keypad.c                   |    2=20
 drivers/iommu/amd_iommu.c                                     |    2=20
 drivers/iommu/amd_iommu_init.c                                |    3=20
 drivers/iommu/intel-iommu.c                                   |   39 +-
 drivers/iommu/iommu.c                                         |    6=20
 drivers/iommu/mtk_iommu.c                                     |   26 +
 drivers/lightnvm/pblk-rb.c                                    |    2=20
 drivers/media/i2c/ov2659.c                                    |    2=20
 drivers/media/pci/cx18/cx18-fileops.c                         |    2=20
 drivers/media/pci/cx23885/cx23885-dvb.c                       |    5=20
 drivers/media/pci/ivtv/ivtv-fileops.c                         |    2=20
 drivers/media/pci/tw5864/tw5864-video.c                       |    4=20
 drivers/media/platform/atmel/atmel-isi.c                      |    2=20
 drivers/media/platform/davinci/isif.c                         |    9=20
 drivers/media/platform/davinci/vpbe.c                         |    2=20
 drivers/media/platform/omap/omap_vout.c                       |   15 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c                   |    2=20
 drivers/media/platform/vivid/vivid-osd.c                      |    2=20
 drivers/media/radio/wl128x/fmdrv_common.c                     |    5=20
 drivers/mfd/intel-lpss-pci.c                                  |   28 +
 drivers/mfd/intel-lpss.c                                      |    1=20
 drivers/misc/mic/card/mic_x100.c                              |   28 -
 drivers/misc/sgi-xp/xpc_partition.c                           |    2=20
 drivers/mmc/core/host.c                                       |    2=20
 drivers/mmc/core/quirks.h                                     |    7=20
 drivers/mmc/host/sdhci-brcmstb.c                              |    4=20
 drivers/net/dsa/qca8k.c                                       |   12=20
 drivers/net/dsa/qca8k.h                                       |    1=20
 drivers/net/ethernet/amazon/ena/ena_com.c                     |    3=20
 drivers/net/ethernet/amazon/ena/ena_ethtool.c                 |    4=20
 drivers/net/ethernet/amazon/ena/ena_netdev.c                  |    1=20
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c               |   15 -
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c     |    4=20
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c     |    4=20
 drivers/net/ethernet/broadcom/bcmsysport.c                    |    2=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c             |   18 -
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c                 |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h       |    2=20
 drivers/net/ethernet/ibm/ehea/ehea_main.c                     |    2=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                 |   16 -
 drivers/net/ethernet/mellanox/mlx5/core/qp.c                  |    5=20
 drivers/net/ethernet/mellanox/mlxsw/reg.h                     |   22 +
 drivers/net/ethernet/natsemi/sonic.c                          |    6=20
 drivers/net/ethernet/pasemi/pasemi_mac.c                      |    2=20
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c                   |   16 -
 drivers/net/ethernet/qlogic/qed/qed_l2.c                      |   34 +-
 drivers/net/ethernet/qualcomm/qca_spi.c                       |    9=20
 drivers/net/ethernet/qualcomm/qca_spi.h                       |    1=20
 drivers/net/ethernet/renesas/sh_eth.c                         |    6=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c           |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c           |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c             |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c              |    2=20
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c             |    2=20
 drivers/net/hyperv/netvsc_drv.c                               |   13=20
 drivers/net/phy/fixed_phy.c                                   |    6=20
 drivers/net/phy/phy_device.c                                  |   11=20
 drivers/net/vxlan.c                                           |    7=20
 drivers/net/wireless/ath/ath10k/sdio.c                        |   29 +-
 drivers/net/wireless/ath/ath9k/dynack.c                       |    8=20
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                   |   12=20
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c                 |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                  |   19 -
 drivers/net/wireless/marvell/libertas_tf/cmd.c                |    2=20
 drivers/net/wireless/mediatek/mt7601u/phy.c                   |    2=20
 drivers/ntb/hw/idt/ntb_hw_idt.c                               |    8=20
 drivers/nvme/host/pci.c                                       |    2=20
 drivers/nvmem/imx-ocotp.c                                     |    3=20
 drivers/of/of_mdio.c                                          |    2=20
 drivers/pci/endpoint/functions/pci-epf-test.c                 |    4=20
 drivers/pci/host/pcie-iproc.c                                 |    8=20
 drivers/pci/switch/switchtec.c                                |    4=20
 drivers/pinctrl/bcm/pinctrl-iproc-gpio.c                      |   96 +++++-
 drivers/pinctrl/sh-pfc/pfc-emev2.c                            |   20 +
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c                          |    3=20
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c                          |    8=20
 drivers/pinctrl/sh-pfc/pfc-r8a7792.c                          |    1=20
 drivers/pinctrl/sh-pfc/pfc-r8a7794.c                          |    2=20
 drivers/pinctrl/sh-pfc/pfc-r8a77995.c                         |    8=20
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                           |    2=20
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c                           |    4=20
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                           |    4=20
 drivers/platform/mips/cpu_hwmon.c                             |    2=20
 drivers/platform/x86/alienware-wmi.c                          |   19 -
 drivers/platform/x86/wmi.c                                    |    3=20
 drivers/power/supply/power_supply_core.c                      |   10=20
 drivers/pwm/pwm-lpss.c                                        |    6=20
 drivers/pwm/pwm-meson.c                                       |    9=20
 drivers/rapidio/rio_cm.c                                      |    4=20
 drivers/regulator/lp87565-regulator.c                         |    2=20
 drivers/regulator/pv88060-regulator.c                         |    2=20
 drivers/regulator/pv88080-regulator.c                         |    2=20
 drivers/regulator/pv88090-regulator.c                         |    2=20
 drivers/regulator/tps65086-regulator.c                        |    4=20
 drivers/regulator/wm831x-dcdc.c                               |    4=20
 drivers/rtc/rtc-88pm80x.c                                     |   21 -
 drivers/rtc/rtc-88pm860x.c                                    |   21 -
 drivers/rtc/rtc-ds1307.c                                      |    7=20
 drivers/rtc/rtc-ds1672.c                                      |    3=20
 drivers/rtc/rtc-mc146818-lib.c                                |    2=20
 drivers/rtc/rtc-pcf2127.c                                     |   32 --
 drivers/rtc/rtc-pcf8563.c                                     |   13=20
 drivers/rtc/rtc-pm8xxx.c                                      |    6=20
 drivers/scsi/fnic/fnic_isr.c                                  |    4=20
 drivers/scsi/libfc/fc_exch.c                                  |    2=20
 drivers/scsi/megaraid/megaraid_sas_base.c                     |    4=20
 drivers/scsi/qla2xxx/qla_os.c                                 |   34 +-
 drivers/scsi/qla2xxx/qla_target.c                             |   14=20
 drivers/soc/fsl/qe/gpio.c                                     |    4=20
 drivers/spi/spi-bcm2835aux.c                                  |   13=20
 drivers/spi/spi-cadence.c                                     |   11=20
 drivers/spi/spi-fsl-spi.c                                     |    2=20
 drivers/spi/spi-tegra114.c                                    |  145 +++++=
++---
 drivers/spi/spi-topcliff-pch.c                                |    6=20
 drivers/staging/comedi/drivers/ni_mio_common.c                |   24 +
 drivers/staging/greybus/light.c                               |   12=20
 drivers/staging/most/aim-cdev/cdev.c                          |    5=20
 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c |    5=20
 drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c |    9=20
 drivers/target/target_core_device.c                           |    4=20
 drivers/thermal/cpu_cooling.c                                 |    2=20
 drivers/thermal/mtk_thermal.c                                 |    6=20
 drivers/tty/ipwireless/hardware.c                             |    2=20
 drivers/tty/serial/fsl_lpuart.c                               |   28 -
 drivers/tty/serial/stm32-usart.c                              |  123 ++++-=
---
 drivers/tty/serial/stm32-usart.h                              |   10=20
 drivers/uio/uio.c                                             |   10=20
 drivers/usb/class/cdc-wdm.c                                   |    2=20
 drivers/usb/dwc2/gadget.c                                     |    1=20
 drivers/usb/host/xhci-hub.c                                   |    2=20
 drivers/usb/phy/Kconfig                                       |    2=20
 drivers/usb/phy/phy-twl6030-usb.c                             |    2=20
 drivers/vfio/mdev/mdev_core.c                                 |   11=20
 drivers/vfio/pci/vfio_pci.c                                   |   19 -
 drivers/video/backlight/lm3630a_bl.c                          |    4=20
 drivers/video/fbdev/chipsfb.c                                 |    3=20
 drivers/xen/cpu_hotplug.c                                     |    2=20
 drivers/xen/pvcalls-back.c                                    |    2=20
 fs/affs/super.c                                               |    6=20
 fs/afs/super.c                                                |    1=20
 fs/afs/xattr.c                                                |    4=20
 fs/btrfs/file.c                                               |    3=20
 fs/btrfs/inode-map.c                                          |   28 +
 fs/cifs/connect.c                                             |    3=20
 fs/exportfs/expfs.c                                           |    1=20
 fs/ext4/inline.c                                              |    2=20
 fs/jfs/jfs_txnmgr.c                                           |    3=20
 fs/nfs/delegation.c                                           |   20 -
 fs/nfs/delegation.h                                           |    1=20
 fs/nfs/flexfilelayout/flexfilelayout.h                        |   32 +-
 fs/nfs/pnfs.c                                                 |   33 +-
 fs/nfs/pnfs.h                                                 |    1=20
 fs/nfs/super.c                                                |    2=20
 fs/nfs/write.c                                                |    2=20
 fs/xfs/xfs_quotaops.c                                         |    3=20
 include/linux/device.h                                        |    3=20
 include/linux/irqchip/arm-gic-v3.h                            |   12=20
 include/linux/mlx5/mlx5_ifc.h                                 |    2=20
 include/linux/mmc/sdio_ids.h                                  |    2=20
 include/linux/platform_data/dma-imx-sdma.h                    |    3=20
 include/linux/signal.h                                        |   15 -
 include/media/davinci/vpbe.h                                  |    2=20
 include/net/request_sock.h                                    |    4=20
 include/net/tcp.h                                             |    2=20
 kernel/debug/kdb/kdb_main.c                                   |    2=20
 kernel/events/core.c                                          |    3=20
 kernel/irq/irqdomain.c                                        |    1=20
 kernel/signal.c                                               |    5=20
 lib/devres.c                                                  |    3=20
 lib/kfifo.c                                                   |    3=20
 net/6lowpan/nhc.c                                             |    2=20
 net/bridge/netfilter/ebtables.c                               |    4=20
 net/core/neighbour.c                                          |    4=20
 net/core/sock.c                                               |    4=20
 net/ieee802154/6lowpan/reassembly.c                           |    2=20
 net/ipv4/inet_connection_sock.c                               |    2=20
 net/ipv4/tcp.c                                                |    4=20
 net/ipv6/reassembly.c                                         |    2=20
 net/iucv/af_iucv.c                                            |   27 +
 net/l2tp/l2tp_core.c                                          |    3=20
 net/llc/af_llc.c                                              |   34 +-
 net/llc/llc_conn.c                                            |   35 --
 net/llc/llc_if.c                                              |   12=20
 net/mac80211/rc80211_minstrel_ht.c                            |    2=20
 net/mac80211/rx.c                                             |   11=20
 net/mpls/mpls_iptunnel.c                                      |    2=20
 net/netfilter/nft_set_hash.c                                  |   23 +
 net/packet/af_packet.c                                        |   25 +
 net/rds/ib_stats.c                                            |    2=20
 net/rds/stats.c                                               |    2=20
 net/rxrpc/output.c                                            |    3=20
 net/sched/act_mirred.c                                        |    6=20
 net/sched/sch_netem.c                                         |   18 -
 net/tipc/link.c                                               |   29 +-
 net/tipc/node.c                                               |    7=20
 net/tipc/socket.c                                             |    2=20
 net/tipc/sysctl.c                                             |    8=20
 security/apparmor/include/context.h                           |    2=20
 security/apparmor/lsm.c                                       |    4=20
 security/keys/key.c                                           |    1=20
 sound/aoa/codecs/onyx.c                                       |    4=20
 sound/pci/hda/hda_controller.h                                |    9=20
 sound/soc/codecs/cs4349.c                                     |    1=20
 sound/soc/codecs/es8328.c                                     |    2=20
 sound/soc/codecs/wm8737.c                                     |    2=20
 sound/soc/davinci/davinci-mcasp.c                             |   13=20
 sound/soc/fsl/imx-sgtl5000.c                                  |    3=20
 sound/soc/qcom/apq8016_sbc.c                                  |   21 +
 sound/soc/soc-pcm.c                                           |    4=20
 sound/soc/sunxi/sun4i-i2s.c                                   |    4=20
 sound/usb/mixer.c                                             |    4=20
 sound/usb/quirks-table.h                                      |    9=20
 tools/testing/selftests/ipc/msgque.c                          |   11=20
 340 files changed, 1946 insertions(+), 1258 deletions(-)

Akinobu Mita (1):
      media: ov2659: fix unbalanced mutex_lock/unlock

Alex Estrin (1):
      IB/hfi1: Add mtu check for operational data VLs

Alexandre Kroupski (1):
      media: atmel: atmel-isi: fix timeout value for stop streaming

Alexandru Ardelean (1):
      dmaengine: axi-dmac: Don't check the number of frames for alignment

Alexey Kardashevskiy (1):
      KVM: PPC: Release all hardware TCE tables attached to a group

Anders Roxell (1):
      ALSA: hda: fix unused variable warning

Andre Przywara (1):
      arm64: dts: juno: Fix UART frequency

Andrey Smirnov (1):
      tty: serial: fsl_lpuart: Use appropriate lpuart32_* I/O funcs

Andy Shevchenko (4):
      dmaengine: hsu: Revert "set HSU_CH_MTSR to memory width"
      mfd: intel-lpss: Release IDA resources
      dmaengine: dw: platform: Switch to acpi_dma_controller_register()
      ahci: Do not export local variable ahci_em_messages

Antonio Borneo (1):
      net: stmmac: fix length of PTP clock's name string

Ard Biesheuvel (2):
      powerpc/archrandom: fix arch_get_random_seed_int()
      nvme: retain split access workaround for capability reads

Arnd Bergmann (7):
      jfs: fix bogus variable self-initialization
      media: davinci-isif: avoid uninitialized variable use
      usb: gadget: fsl: fix link error against usb-gadget module
      devres: allow const resource arguments
      qed: reduce maximum stack frame size
      mic: avoid statically declaring a 'struct device'.
      crypto: ccp - Reduce maximum stack usage

Axel Lin (6):
      regulator: pv88060: Fix array out-of-bounds access
      regulator: pv88080: Fix array out-of-bounds access
      regulator: pv88090: Fix array out-of-bounds access
      regulator: wm831x-dcdc: Fix list of wm831x_dcdc_ilim from mA to uA
      regulator: lp87565: Fix missing register for LP87565_BUCK_0
      regulator: tps65086: Fix tps65086_ldoa1_ranges for selector 0xB

Bart Van Assche (4):
      scsi: qla2xxx: Unregister chrdev if module initialization fails
      scsi: target/core: Fix a race condition in the LUN lookup code
      scsi: qla2xxx: Fix a format specifier
      scsi: qla2xxx: Avoid that qlt_send_resp_ctio() corrupts memory

Ben Hutchings (1):
      powerpc: vdso: Make vdso32 installation conditional in vdso_install

Bichao Zheng (1):
      pwm: meson: Don't disable PWM when setting duty repeatedly

Brian Masney (1):
      backlight: lm3630a: Return 0 on success in update_status functions

Bruno Thomsen (1):
      rtc: pcf2127: bugfix: read rtc disables watchdog

Bryan O'Donoghue (1):
      nvmem: imx-ocotp: Ensure WAIT bits are preserved when setting timing

Charles Keepax (1):
      spi: cadence: Correct initialisation of runtime PM

Chen-Yu Tsai (4):
      clk: sunxi-ng: sun8i-a23: Enable PLL-MIPI LDOs when ungating it
      clocksource/drivers/sun5i: Fail gracefully when clock rate is unavail=
able
      rtc: pcf8563: Fix interrupt trigger method
      rtc: pcf8563: Clear event flags and disable interrupts before request=
ing irq

Christophe Leroy (1):
      spi: spi-fsl-spi: call spi_finalize_current_message() at the end

Chuhong Yuan (1):
      dmaengine: ti: edma: fix missed failure handling

Colin Ian King (14):
      pcrypt: use format specifier in kobject_add
      staging: most: cdev: add missing check for cdev_add failure
      rtc: ds1672: fix unintended sign extension
      rtc: 88pm860x: fix unintended sign extension
      rtc: 88pm80x: fix unintended sign extension
      rtc: pm8xxx: fix unintended sign extension
      drm/nouveau/bios/ramcfg: fix missing parentheses when calculating RON
      drm/nouveau/pmu: don't print reply values if exec is false
      platform/x86: alienware-wmi: fix kfree on potentially uninitialized p=
ointer
      media: vivid: fix incorrect assignment operation when setting video m=
ode
      scsi: libfc: fix null pointer dereference on a null lport
      ext4: set error return correctly when ext4_htree_store_dirent fails
      bcma: fix incorrect update of BCMA_CORE_PCI_MDIO_DATA
      iio: dac: ad5380: fix incorrect assignment to val

Corentin Labbe (2):
      crypto: sun4i-ss - fix big endian issues
      crypto: crypto4xx - Fix wrong ppc4xx_trng_probe()/ppc4xx_trng_remove(=
) arguments

Dan Carpenter (23):
      drm/virtio: fix bounds check in virtio_gpu_cmd_get_capset()
      Input: nomadik-ske-keypad - fix a loop timeout test
      drm/etnaviv: NULL vs IS_ERR() buf in etnaviv_core_dump()
      drm/etnaviv: potential NULL dereference
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
      net: aquantia: Fix aq_vec_isr_legacy() return value
      net: hisilicon: Fix signedness bug in hix5hd2_dev_probe()
      net: broadcom/bcmsysport: Fix signedness in bcm_sysport_probe()
      net: stmmac: dwmac-meson8b: Fix signedness bug in probe
      net: axienet: fix a signedness bug in probe
      of: mdio: Fix a signedness bug in of_phy_get_and_connect()
      net: ethernet: stmmac: Fix signedness bug in ipq806x_gmac_of_parse()

Dan Robertson (1):
      hwmon: (shtc1) fix shtc1 and shtw1 id mask

David Howells (3):
      keys: Timestamp new keys
      afs: Fix the afs.cell and afs.volume xattr handlers
      rxrpc: Fix uninitialized error code in rxrpc_send_data_packet()

Dexuan Cui (1):
      irqdomain: Add the missing assignment of domain->fwnode for named fwn=
ode

Eric Auger (2):
      vfio_pci: Enable memory accesses before calling pci_map_rom
      iommu/vt-d: Duplicate iommu_resv_region objects per device list

Eric Biggers (3):
      crypto: tgr192 - fix unaligned memory access
      llc: fix another potential sk_buff leak in llc_ui_sendmsg()
      llc: fix sk_buff refcounting in llc_conn_state_process()

Eric Dumazet (6):
      inet: frags: call inet_frags_fini() after unregister_pernet_subsys()
      net: avoid possible false sharing in sk_leave_memory_pressure()
      net: add {READ|WRITE}_ONCE() annotations on ->rskq_accept_head
      tcp: annotate lockless access to tcp_memory_pressure
      net: neigh: use long type to store jiffies delta
      packet: fix data-race in fanout_flow_is_huge()

Eric W. Biederman (3):
      fs/nfs: Fix nfs_parse_devname to not modify it's argument
      signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of for=
ce_sig
      signal: Allow cifs and drbd to receive their terminating signals

Eric Wong (1):
      rtc: cmos: ignore bogus century byte

Erwan Le Ray (4):
      serial: stm32: fix rx error handling
      serial: stm32: fix transmit_chars when tx is stopped
      serial: stm32: Add support of TC bit status check
      serial: stm32: fix wakeup source initialization

Fabrice Gasnier (2):
      ARM: dts: stm32: add missing vdda-supply to adc on stm32h743i-eval
      serial: stm32: fix clearing interrupt error flags

Felix Fietkau (1):
      mac80211: minstrel_ht: fix per-group max throughput rate initializati=
on

Filipe Manana (3):
      Btrfs: fix hang when loading existing inode cache off disk
      Btrfs: fix inode cache waiters hanging on failure to start caching th=
read
      Btrfs: fix inode cache waiters hanging on path allocation failure

Filippo Sironi (1):
      iommu/amd: Wait for completion of IOTLB flush in attach_device

Finn Thain (2):
      m68k: mac: Fix VIA timer counter accesses
      m68k: Call timer_interrupt() with interrupts disabled

Firo Yang (1):
      ixgbe: sync the first fragment unconditionally

Florian Fainelli (2):
      cpufreq: brcmstb-avs-cpufreq: Fix initial command check
      cpufreq: brcmstb-avs-cpufreq: Fix types for voltage/frequency

Florian Westphal (1):
      netfilter: ebtables: CONFIG_COMPAT: reject trailing data after last r=
ule

Gal Pressman (3):
      IB/usnic: Fix out of bounds index check in query pkey
      RDMA/ocrdma: Fix out of bounds index check in query pkey
      RDMA/qedr: Fix out of bounds index check in query pkey

Geert Uytterhoeven (14):
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
      pinctrl: sh-pfc: r8a77995: Remove bogus SEL_PWM[0-3]_3 configurations
      pinctrl: sh-pfc: sh7269: Add missing PCIOR0 field
      pinctrl: sh-pfc: sh7734: Remove bogus IPSR10 value
      pinctrl: sh-pfc: emev2: Add missing pinmux functions
      pinctrl: sh-pfc: r8a7791: Fix scifb2_data_c pin group
      pinctrl: sh-pfc: r8a7792: Fix vin1_data18_b pin group
      pinctrl: sh-pfc: sh73a0: Fix fsic_spdif pin groups

George Wilkie (1):
      mpls: fix warning with multi-label encap

Gerd Rausch (2):
      net/rds: Add a few missing rds_stat_names entries
      net/rds: Fix 'ib_evt_handler_call' element in 'rds_ib_stat_names'

Govindarajulu Varadarajan (1):
      scsi: fnic: fix msix interrupt allocation

Greg Kroah-Hartman (1):
      Linux 4.14.168

Guenter Roeck (3):
      nios2: ksyms: Add missing symbol exports
      hwmon: (w83627hf) Use request_muxed_region for Super-IO accesses
      hwmon: (lm75) Fix write operations for negative temperatures

Gustavo A. R. Silva (1):
      NTB: ntb_hw_idt: replace IS_ERR_OR_NULL with regular NULL checks

H. Nikolaus Schaller (2):
      mmc: sdio: fix wl1251 vendor id
      mmc: core: fix wl1251 sdio quirks

Hans de Goede (1):
      pwm: lpss: Release runtime-pm reference from the driver's remove call=
back

Hongbo Yao (1):
      irqchip/gic-v3-its: fix some definitions of inner cacheability attrib=
utes

Hook, Gary (2):
      crypto: ccp - fix AES CFB error exposed by new test vectors
      crypto: ccp - Fix 3DES complaint from ccp-crypto module

H=E5kon Bugge (1):
      RDMA/cma: Fix false error message

Icenowy Zheng (1):
      clk: sunxi-ng: v3s: add the missing PLL_DDR1

Igor Konopko (1):
      lightnvm: pblk: fix lock order in pblk_rb_tear_down_check

Igor Russkikh (1):
      net: aquantia: fixed instack structure overflow

Israel Rukshin (1):
      IB/iser: Pass the correct number of entries for dma mapped SGL

Iuliana Prodan (2):
      crypto: caam - fix caam_dump_sg that iterates through scatterlist
      crypto: caam - free resources in case caam_rng registration failed

Jack Morgenstein (1):
      IB/mlx5: Add missing XRC options to QP optional params mask

Jakub Kicinski (3):
      net: netem: fix backlog accounting for corrupted GSO frames
      net: netem: fix error path for corrupted GSO frames
      net: netem: correct the parent's backlog when corrupted packet was dr=
opped

Jan Kara (1):
      xfs: Sanity check flags of Q_XQUOTARM call

Jann Horn (1):
      apparmor: don't try to replace stale label in ptrace access check

Jarkko Nikula (1):
      mfd: intel-lpss: Add default I2C device properties for Gemini Lake

Jeffrey Hugo (2):
      drm/msm/mdp5: Fix mdp5_cfg_init error return
      drm/msm/dsi: Implement reset correctly

Jernej Skrabec (1):
      ARM: dts: sun8i-h3: Fix wifi in Beelink X2 DT

Jerome Brunet (2):
      ASoC: fix valid stream condition
      arm64: dts: meson: libretech-cc: set eMMC as removable

Jie Liu (1):
      tipc: set sysctl_tipc_rmem and named_timeout right range

Jitendra Bhivare (1):
      PCI: iproc: Remove PAXC slot check to allow VF support

Johannes Berg (3):
      iwlwifi: mvm: fix A-MPDU reference assignment
      ALSA: aoa: onyx: always initialize register read value
      mac80211: accept deauth frames in IBSS mode

John Garry (1):
      drm/hisilicon: hibmc: Don't overwrite fb helper surface depth

Jon Hunter (1):
      dmaengine: tegra210-adma: Fix crash during probe

Jon Maloy (2):
      tipc: tipc clang warning
      tipc: reduce risk of wakeup queue starvation

Jonas Gorski (1):
      MIPS: BCM63XX: drop unused and broken DSP platform device

Jose Abreu (1):
      net: stmmac: gmac4+: Not all Unicast addresses may be available

Julian Wiedmann (1):
      net/af_iucv: always register net_device notifier

Kangjie Lu (1):
      net: sh_eth: fix a missing check of of_get_phy_mode

Kees Cook (1):
      selftests/ipc: Fix msgque compiler warnings

Kelvin Cao (1):
      switchtec: Remove immediate status check after submitting MRPC command

Kevin Mitchell (1):
      iommu/amd: Make iommu_disable safer

Li Jin (1):
      pinctrl: iproc-gpio: Fix incorrect pinconf configurations

Linus Torvalds (1):
      Partially revert "kfifo: fix kfifo_alloc() and kfifo_init()"

Liu Jian (2):
      driver: uio: fix possible memory leak in __uio_register_device
      driver: uio: fix possible use-after-free in __uio_register_device

Loic Poulain (1):
      arm64: dts: apq8016-sbc: Increase load on l11 for SDCARD

Lorenzo Bianconi (2):
      mt7601u: fix bbp version check in mt7601u_wait_bbp_ready
      ath9k: dynack: fix possible deadlock in ath_dynack_node_{de}init

Lu Baolu (2):
      iommu/vt-d: Make kernel parameter igfx_off work with vIOMMU
      iommu: Use right function to get group for device

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

Martin Blumenstingl (1):
      pwm: meson: Consider 128 a valid pre-divider

Martin Sperl (1):
      spi: bcm2835aux: fix driver to not allow 65535 (=3D-1) cs-gpios

Masahiro Yamada (1):
      kbuild: mark prepare0 as PHONY to fix external module build

Masami Hiramatsu (1):
      x86, perf: Fix the dependency of the x86 insn decoder selftest

Matthias Kaehlcke (1):
      thermal: cpu_cooling: Actually trace CPU load in thermal_power_cpu_ge=
t_power

Mattias Jacobsson (1):
      platform/x86: wmi: fix potential null pointer dereference

Max Gurtovoy (1):
      IB/iser: Fix dma_nents type definition

Maxime Ripard (3):
      drm/sun4i: hdmi: Fix double flag assignation
      arm64: dts: allwinner: a64: Add missing PIO clocks
      ASoC: sun4i-i2s: RX and TX counter registers are swapped

Michael Chan (1):
      bnxt_en: Fix ethtool selftest crash under error conditions.

Michael Ellerman (1):
      powerpc/64s: Fix logic when handling unknown CPU features

Michael Kao (1):
      thermal: mediatek: fix register index error

Michal Kalderon (1):
      qed: iWARP - Use READ_ONCE and smp_store_release to access ep->state

Minas Harutyunyan (1):
      dwc2: gadget: Fix completed transfer size calculation in DDMA

Ming Lei (1):
      block: don't use bio->bi_vcnt to figure out segment number

Moni Shoua (1):
      net/mlx5: Take lock with IRQs disabled to avoid deadlock

Mordechay Goodstein (1):
      iwlwifi: mvm: avoid possible access out of array.

Moritz Fischer (1):
      net: phy: fixed_phy: Fix fixed_phy not checking GPIO

Nathan Chancellor (2):
      staging: rtlwifi: Use proper enum for return in halmac_parse_psd_data=
_88xx
      misc: sgi-xp: Properly initialize buf in xpc_get_rsvd_page_pa

Nathan Huckleberry (1):
      clk: qcom: Fix -Wunused-const-variable

Nathan Lynch (2):
      powerpc/cacheinfo: add cacheinfo_teardown, cacheinfo_rebuild
      powerpc/pseries/mobility: rebuild cacheinfo hierarchy post-migration

Navid Emamdoost (1):
      affs: fix a memory leak in affs_remount

Nicholas Mc Guire (2):
      staging: r8822be: check kzalloc return or bail
      media: cx23885: check allocation return

Nick Desaulniers (1):
      mips: avoid explicit UB in assignment of mips_io_port_base

Nicolas Boichat (1):
      ath10k: adjust skb length in ath10k_sdio_mbox_rx_packet

Nicolas Huaman (1):
      ALSA: usb-audio: update quirk for B&W PX to remove microphone

Omar Sandoval (1):
      btrfs: use correct count in btrfs_file_write_iter()

Pablo Neira Ayuso (1):
      netfilter: nft_set_hash: fix lookups with fixed size hash on big endi=
an

Pan Bian (1):
      mmc: core: fix possible use after free of host

Parav Pandit (2):
      vfio/mdev: Avoid release parent reference during error path
      vfio/mdev: Fix aborting mdev child device removal if one fails

Pawe? Chmiel (1):
      media: s5p-jpeg: Correct step and max values for V4L2_CID_JPEG_RESTAR=
T_INTERVAL

Peter Rosin (1):
      drm/sti: do not remove the drm_bridge that was never added

Peter Ujfalusi (1):
      ASoC: ti: davinci-mcasp: Fix slot mask settings when using multiple A=
XRs

Petr Machata (2):
      mlxsw: reg: QEEC: Add minimum shaper fields
      vxlan: changelink: Fix handling of default remotes

Qian Cai (1):
      x86/mm: Remove unused variable 'cpu'

Rafael J. Wysocki (2):
      driver core: Do not resume suppliers under device_links_write_lock()
      PM: sleep: Fix possible overflow in pm_system_cancel_wakeup()

Raju Rangoju (1):
      RDMA/iw_cxgb4: Fix the unchecked ep dereference

Rashmica Gupta (1):
      powerpc/mm: Check secondary hash page table

Ravi Bangoria (1):
      perf/ioctl: Add check for the sample_period value

Rob Clark (1):
      drm/msm/a3xx: remove TPL1 regs from snapshot

Robert Richter (1):
      EDAC/mc: Fix edac_mc_find() in case no device is found

Robin Gong (1):
      dmaengine: imx-sdma: fix size check for sdma script_number

Robin Murphy (1):
      dmaengine: mv_xor: Use correct device for DMA API

Ruslan Bilovol (1):
      usb: host: xhci-hub: fix extra endianness conversion

Russell King (1):
      ARM: riscpc: fix lack of keyboard interrupts after irq conversion

Sagiv Ozeri (1):
      RDMA/qedr: Fix incorrect device rate.

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

Sowjanya Komatineni (5):
      spi: tegra114: clear packed bit for unpacked mode
      spi: tegra114: fix for unpacked mode transfers
      spi: tegra114: terminate dma and reset on transfer timeout
      spi: tegra114: flush fifos
      spi: tegra114: configure dma burst size to fifo trig level

Spencer E. Olson (1):
      staging: comedi: ni_mio_common: protect register write overflow

Stefan Agner (1):
      ASoC: imx-sgtl5000: put of nodes if finding codec fails

Stefan Wahren (3):
      staging: bcm2835-camera: Abort probe if there is no camera
      mmc: sdhci-brcmstb: handle mmc_of_parse() errors during probe
      net: qca_spi: Move reset_count to struct qcaspi

Stephen Boyd (1):
      power: supply: Init device wakeup after device_add()

Stephen Hemminger (2):
      netvsc: unshare skb in VF rx handler
      hv_netvsc: flag software created hash value

Steve French (1):
      cifs: fix rmmod regression in cifs.ko caused by force_sig changes

Steve Sistare (1):
      scsi: megaraid_sas: reduce module load time

Steve Wise (2):
      iw_cxgb4: use tos when importing the endpoint
      iw_cxgb4: use tos when finding ipv6 routes

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

Trond Myklebust (4):
      NFS: Fix a soft lockup in the delegation recovery code
      NFS/pnfs: Bulk destroy of layouts needs to be safe w.r.t. umount
      NFSv4/flexfiles: Fix invalid deref in FF_LAYOUT_DEVID_NODE()
      NFS: Don't interrupt file writeout due to fatal errors

Tung Nguyen (1):
      tipc: fix wrong timeout input for tipc_wait_for_cond()

Uwe Kleine-K=F6nig (1):
      rtc: ds1307: rx8130: Fix alarm handling

Vadim Pasternak (1):
      hwmon: (pmbus/tps53679) Fix driver info initialization in probe routi=
ne

Vasundhara Volam (1):
      bnxt_en: Fix handling FRAG_ERR when NVM_INSTALL_UPDATE cmd fails

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

Wen Yang (2):
      PCI: endpoint: functions: Use memcpy_fromio()/memcpy_toio()
      net: pasemi: fix an use-after-free in pasemi_mac_phy_init()

Willem de Bruijn (1):
      packet: in recvmsg msg_name return at least sizeof sockaddr_ll

Xi Wang (1):
      RDMA/hns: Fixs hw access invalid dma memory error

Yangtao Li (13):
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
      clk: mv98dx3236: fix refcount leak in mv98dx3236_clk_init()
      clk: dove: fix refcount leak in dove_clk_init()

Yong Wu (1):
      iommu/mediatek: Fix iova_to_phys PA start for 4GB mode

Yoshihiro Shimoda (1):
      net: phy: Fix not to call phy_resume() if PHY is not attached

YueHaibing (16):
      exportfs: fix 'passing zero to ERR_PTR()' warning
      drm/shmob: Fix return value check in shmob_drm_probe
      crypto: brcm - Fix some set-but-not-used warning
      spi/topcliff_pch: Fix potential NULL dereference on allocation error
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

Yunsheng Lin (1):
      net: hns3: fix for vport->bw_limit overflow problem

Yuval Shaia (1):
      IB/rxe: Fix incorrect cache cleanup in error flow

Zhu Yanjun (1):
      IB/rxe: replace kvfree with vfree


--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4vADYACgkQONu9yGCS
aT4QQBAApJ51dPnsqyMbLbL3vVsNXMOfHk1xFm8mWG7YJiECdQzjnc1nLBbsGqeQ
w68ThUYTF0hCBCXLaMWVYJCE9dT3fGrRrvbPDOsKGoOpIK7r1PQCnhD9NnbtDZFv
ngu++UBduKxx7rj7LOJorLYtq1aktoVq9+WtkyZ60bxZhMYZ/6RmW/QI8EXTXogX
gnI1XZUPFqsxSGx0/ZEo5+L4u1kMYaqaRVJ2wT4df8fyxg7aIZElAvKaCH8LEUI8
V4Dx6zzXWw3M//iZpT/gnaSvL1drU+VE4DGYGyRM4/AqW3CJFTKDMotiweEIjmaW
SOP4we5OC1anNZBGoUhH/cHwPmQkDB8NziZbrBiKp+uBp27N2C2OuxUK71uXAG/U
o7IygyrMBItcymZs11jBZicMitfyXw4AnqAZtzFnvPYMkMMtz1BuSvPJSy9ePvVn
YMlideW63qehPhnGcLUCSLAt9pLAC/0IzA9ohoaCDyU+03T7DcumDk/NAoufREsh
73+NTx+y/J7tZTkbMRfSff2zGI+52ikL2pUsR1ExNpWhot5XWLLS2qpma95K1Swq
g/oE5TtrMA7BhEGfBWkduXi5ZcYSzXi4nJgjQ3rvk1z7OImfOA1ORS9U5tnlMo9E
rHVoU1FXbAHQOPj9Gw7P+DA4fjpkg9oPh9+3ur1QSDOioojmkps=
=Sn4D
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
