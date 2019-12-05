Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6068114280
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 15:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbfLEOYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 09:24:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbfLEOYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Dec 2019 09:24:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F460206DB;
        Thu,  5 Dec 2019 14:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575555847;
        bh=rVWb72HY/4FsCnlWj7iOGvqDvo2KI2LUE1aerm13qqI=;
        h=Date:From:To:Cc:Subject:From;
        b=trDTopRaJvVSzcMWA2/o/kliAnQb7ZG3pOmvvkDdclPopVryo6zPaevfMJORW6rd2
         mFunQnIoBDQWKq4+2dEPncvOYx3vxL0uyBKcX/+ShByDir4o+kNnc1DVl3qwwGclm4
         aT2rukQhJHvDbgNTjATAG3gquQwmtW/ZtEx/ZMHc=
Date:   Thu, 5 Dec 2019 15:24:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.88
Message-ID: <20191205142405.GA693507@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.88 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/hid/uhid.txt                                  |    2=20
 Makefile                                                    |    2=20
 arch/arm/Kconfig.debug                                      |   28 +--
 arch/arm/boot/dts/gemini-sq201.dts                          |   37 ----
 arch/arm/boot/dts/imx1-ads.dts                              |    1=20
 arch/arm/boot/dts/imx1-apf9328.dts                          |    1=20
 arch/arm/boot/dts/imx1.dtsi                                 |    2=20
 arch/arm/boot/dts/imx23-evk.dts                             |    1=20
 arch/arm/boot/dts/imx23-olinuxino.dts                       |    1=20
 arch/arm/boot/dts/imx23-sansa.dts                           |    1=20
 arch/arm/boot/dts/imx23-stmp378x_devb.dts                   |    1=20
 arch/arm/boot/dts/imx23-xfi3.dts                            |    1=20
 arch/arm/boot/dts/imx23.dtsi                                |    2=20
 arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi                |    1=20
 arch/arm/boot/dts/imx25-karo-tx25.dts                       |    1=20
 arch/arm/boot/dts/imx25-pdk.dts                             |    1=20
 arch/arm/boot/dts/imx25.dtsi                                |    2=20
 arch/arm/boot/dts/imx27-apf27.dts                           |    1=20
 arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi                |    1=20
 arch/arm/boot/dts/imx27-pdk.dts                             |    1=20
 arch/arm/boot/dts/imx27-phytec-phycard-s-som.dtsi           |    1=20
 arch/arm/boot/dts/imx27-phytec-phycore-som.dtsi             |    1=20
 arch/arm/boot/dts/imx27.dtsi                                |    2=20
 arch/arm/boot/dts/imx31-bug.dts                             |    1=20
 arch/arm/boot/dts/imx31-lite.dts                            |    1=20
 arch/arm/boot/dts/imx31.dtsi                                |    2=20
 arch/arm/boot/dts/imx35-eukrea-cpuimx35.dtsi                |    1=20
 arch/arm/boot/dts/imx35-pdk.dts                             |    1=20
 arch/arm/boot/dts/imx35.dtsi                                |    2=20
 arch/arm/boot/dts/imx50-evk.dts                             |    1=20
 arch/arm/boot/dts/imx50.dtsi                                |    2=20
 arch/arm/boot/dts/imx51-apf51.dts                           |    1=20
 arch/arm/boot/dts/imx51-babbage.dts                         |    1=20
 arch/arm/boot/dts/imx51-digi-connectcore-som.dtsi           |    1=20
 arch/arm/boot/dts/imx51-eukrea-cpuimx51.dtsi                |    1=20
 arch/arm/boot/dts/imx51-ts4800.dts                          |    1=20
 arch/arm/boot/dts/imx51-zii-rdu1.dts                        |    1=20
 arch/arm/boot/dts/imx51-zii-scu2-mezz.dts                   |    1=20
 arch/arm/boot/dts/imx51-zii-scu3-esb.dts                    |    1=20
 arch/arm/boot/dts/imx51.dtsi                                |    2=20
 arch/arm/boot/dts/imx53-ard.dts                             |    1=20
 arch/arm/boot/dts/imx53-cx9020.dts                          |    1=20
 arch/arm/boot/dts/imx53-m53.dtsi                            |    1=20
 arch/arm/boot/dts/imx53-qsb-common.dtsi                     |    1=20
 arch/arm/boot/dts/imx53-smd.dts                             |    1=20
 arch/arm/boot/dts/imx53-tqma53.dtsi                         |    1=20
 arch/arm/boot/dts/imx53-tx53.dtsi                           |    1=20
 arch/arm/boot/dts/imx53-usbarmory.dts                       |    1=20
 arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi                 |    8 -
 arch/arm/boot/dts/imx53.dtsi                                |    2=20
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi                    |    8 +
 arch/arm/boot/dts/imx6sl-evk.dts                            |    1=20
 arch/arm/boot/dts/imx6sl-warp.dts                           |    1=20
 arch/arm/boot/dts/imx6sl.dtsi                               |    2=20
 arch/arm/boot/dts/imx6sll-evk.dts                           |    1=20
 arch/arm/boot/dts/imx6sx-nitrogen6sx.dts                    |    1=20
 arch/arm/boot/dts/imx6sx-sabreauto.dts                      |    1=20
 arch/arm/boot/dts/imx6sx-sdb.dtsi                           |    1=20
 arch/arm/boot/dts/imx6sx-softing-vining-2000.dts            |    1=20
 arch/arm/boot/dts/imx6sx-udoo-neo-basic.dts                 |    1=20
 arch/arm/boot/dts/imx6sx-udoo-neo-extended.dts              |    1=20
 arch/arm/boot/dts/imx6sx-udoo-neo-full.dts                  |    1=20
 arch/arm/boot/dts/imx6sx.dtsi                               |    2=20
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi                     |    1=20
 arch/arm/boot/dts/imx6ul-geam.dts                           |    1=20
 arch/arm/boot/dts/imx6ul-isiot.dtsi                         |    1=20
 arch/arm/boot/dts/imx6ul-litesom.dtsi                       |    1=20
 arch/arm/boot/dts/imx6ul-opos6ul.dtsi                       |    1=20
 arch/arm/boot/dts/imx6ul-pico-hobbit.dts                    |    1=20
 arch/arm/boot/dts/imx6ul-tx6ul.dtsi                         |    1=20
 arch/arm/boot/dts/imx6ul.dtsi                               |    2=20
 arch/arm/boot/dts/imx6ull-colibri-nonwifi.dtsi              |    1=20
 arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi                 |    1=20
 arch/arm/boot/dts/imx7d-cl-som-imx7.dts                     |    3=20
 arch/arm/boot/dts/imx7d-colibri-emmc.dtsi                   |    1=20
 arch/arm/boot/dts/imx7d-colibri.dtsi                        |    1=20
 arch/arm/boot/dts/imx7d-nitrogen7.dts                       |    1=20
 arch/arm/boot/dts/imx7d-pico.dtsi                           |    1=20
 arch/arm/boot/dts/imx7d-sdb.dts                             |    1=20
 arch/arm/boot/dts/imx7s-colibri.dtsi                        |    1=20
 arch/arm/boot/dts/imx7s-warp.dts                            |    1=20
 arch/arm/boot/dts/imx7s.dtsi                                |    2=20
 arch/arm/boot/dts/omap4-l4.dtsi                             |    4=20
 arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts                   |    1=20
 arch/arm/mach-ks8695/board-acs5k.c                          |    2=20
 arch/arm/mach-omap1/Makefile                                |    2=20
 arch/arm/mach-omap1/include/mach/usb.h                      |    2=20
 arch/arm64/boot/dts/renesas/r8a77995-draak.dts              |    2=20
 arch/arm64/include/asm/assembler.h                          |    8 -
 arch/arm64/kernel/entry.S                                   |    6=20
 arch/arm64/kernel/head.S                                    |   26 +++
 arch/arm64/kernel/smp.c                                     |    6=20
 arch/microblaze/Makefile                                    |   14 +
 arch/microblaze/boot/Makefile                               |   23 +-
 arch/openrisc/kernel/entry.S                                |    2=20
 arch/openrisc/kernel/head.S                                 |    2=20
 arch/powerpc/Makefile                                       |    9 +
 arch/powerpc/boot/dts/bamboo.dts                            |    4=20
 arch/powerpc/include/asm/cputable.h                         |    1=20
 arch/powerpc/include/asm/reg.h                              |    2=20
 arch/powerpc/kernel/cputable.c                              |   10 -
 arch/powerpc/kernel/exceptions-64s.S                        |    2=20
 arch/powerpc/kernel/prom.c                                  |    6=20
 arch/powerpc/mm/fault.c                                     |   17 +-
 arch/powerpc/mm/ppc_mmu_32.c                                |    4=20
 arch/powerpc/net/bpf_jit_comp64.c                           |   13 +
 arch/powerpc/perf/isa207-common.c                           |   25 ++-
 arch/powerpc/perf/isa207-common.h                           |    4=20
 arch/powerpc/platforms/83xx/misc.c                          |   17 ++
 arch/powerpc/platforms/powernv/eeh-powernv.c                |    8 -
 arch/powerpc/platforms/powernv/pci-ioda.c                   |    4=20
 arch/powerpc/platforms/powernv/pci.c                        |    4=20
 arch/powerpc/platforms/pseries/dlpar.c                      |    4=20
 arch/powerpc/platforms/pseries/hotplug-memory.c             |    1=20
 arch/powerpc/xmon/xmon.c                                    |    2=20
 arch/s390/kvm/kvm-s390.c                                    |   17 +-
 arch/s390/mm/gup.c                                          |    9 -
 arch/um/Kconfig.debug                                       |    1=20
 arch/um/drivers/vector_user.c                               |    1=20
 arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c                 |    4=20
 arch/x86/kernel/kprobes/core.c                              |    6=20
 arch/x86/kvm/vmx.c                                          |   24 +--
 arch/x86/xen/xen-asm_64.S                                   |    2=20
 crypto/crypto_user.c                                        |   37 ++--
 drivers/acpi/acpi_lpss.c                                    |    7=20
 drivers/acpi/apei/ghes.c                                    |   32 +---
 drivers/ata/ahci_mvebu.c                                    |   68 ++++++--
 drivers/base/platform.c                                     |    3=20
 drivers/block/drbd/drbd_main.c                              |    1=20
 drivers/block/drbd/drbd_nl.c                                |   43 ++++-
 drivers/block/drbd/drbd_receiver.c                          |   52 ++++++
 drivers/block/drbd/drbd_state.h                             |    2=20
 drivers/bluetooth/hci_bcm.c                                 |   22 ++
 drivers/bus/ti-sysc.c                                       |   32 +++-
 drivers/char/hw_random/stm32-rng.c                          |    8 +
 drivers/clk/at91/clk-generated.c                            |   28 +--
 drivers/clk/at91/clk-main.c                                 |    7=20
 drivers/clk/at91/sckc.c                                     |   20 ++
 drivers/clk/clk-stm32mp1.c                                  |   28 +--
 drivers/clk/meson/gxbb.c                                    |    1=20
 drivers/clk/samsung/clk-exynos5420.c                        |    6=20
 drivers/clk/samsung/clk-exynos5433.c                        |   14 +
 drivers/clk/sunxi-ng/ccu-sun9i-a80.c                        |    2=20
 drivers/clk/sunxi/clk-sunxi.c                               |    4=20
 drivers/clk/ti/clk-dra7-atl.c                               |    6=20
 drivers/clk/ti/clkctrl.c                                    |    5=20
 drivers/clocksource/timer-fttmr010.c                        |   73 +++++--=
--
 drivers/clocksource/timer-mediatek.c                        |   10 -
 drivers/crypto/chelsio/chtls/chtls.h                        |    5=20
 drivers/crypto/chelsio/chtls/chtls_main.c                   |   50 +++---
 drivers/crypto/mxc-scc.c                                    |   12 -
 drivers/crypto/stm32/stm32-hash.c                           |    2=20
 drivers/dma/stm32-dma.c                                     |   20 --
 drivers/firmware/arm_sdei.c                                 |    6=20
 drivers/gpio/gpio-pca953x.c                                 |    2=20
 drivers/gpio/gpio-raspberrypi-exp.c                         |    1=20
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c             |    2=20
 drivers/gpu/ipu-v3/ipu-pre.c                                |    6=20
 drivers/hid/hid-core.c                                      |   51 +++++-
 drivers/hid/intel-ish-hid/ishtp-hid.c                       |    2=20
 drivers/infiniband/hw/bnxt_re/qplib_sp.c                    |    5=20
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                  |   15 +
 drivers/infiniband/hw/hns/hns_roce_mr.c                     |    4=20
 drivers/infiniband/hw/hns/hns_roce_qp.c                     |    3=20
 drivers/infiniband/hw/qedr/qedr_iw_cm.c                     |    2=20
 drivers/infiniband/hw/qib/qib_sdma.c                        |    4=20
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c             |    2=20
 drivers/infiniband/sw/rxe/rxe_hw_counters.c                 |    2=20
 drivers/infiniband/sw/rxe/rxe_verbs.h                       |    6=20
 drivers/infiniband/ulp/srp/ib_srp.c                         |    1=20
 drivers/input/serio/gscps2.c                                |    4=20
 drivers/input/serio/hp_sdc.c                                |    4=20
 drivers/iommu/amd_iommu.c                                   |    8 -
 drivers/mailbox/mailbox-test.c                              |   14 +
 drivers/mailbox/stm32-ipcc.c                                |   37 +++-
 drivers/md/bcache/debug.c                                   |    3=20
 drivers/md/bcache/super.c                                   |    3=20
 drivers/md/bcache/writeback.c                               |    3=20
 drivers/md/dm-flakey.c                                      |   33 ++--
 drivers/md/dm-raid.c                                        |    3=20
 drivers/media/platform/atmel/atmel-isc.c                    |   12 +
 drivers/media/platform/stm32/stm32-dcmi.c                   |   23 ++
 drivers/media/v4l2-core/v4l2-ctrls.c                        |    1=20
 drivers/memory/omap-gpmc.c                                  |    1=20
 drivers/misc/mei/bus.c                                      |    9 -
 drivers/misc/mei/hw-me-regs.h                               |    1=20
 drivers/misc/mei/pci-me.c                                   |    1=20
 drivers/mmc/core/block.c                                    |    6=20
 drivers/mmc/core/queue.c                                    |    9 +
 drivers/mmc/host/meson-gx-mmc.c                             |   73 +++++++=
--
 drivers/mtd/mtdcore.h                                       |    2=20
 drivers/mtd/mtdpart.c                                       |   35 +++-
 drivers/mtd/nand/raw/atmel/nand-controller.c                |    2=20
 drivers/mtd/nand/raw/atmel/pmecc.c                          |   21 +-
 drivers/mtd/nand/raw/sunxi_nand.c                           |    2=20
 drivers/mtd/spi-nor/spi-nor.c                               |    2=20
 drivers/mtd/ubi/build.c                                     |    2=20
 drivers/mtd/ubi/kapi.c                                      |    2=20
 drivers/net/Kconfig                                         |    4=20
 drivers/net/can/c_can/c_can.c                               |   26 +++
 drivers/net/can/flexcan.c                                   |   10 +
 drivers/net/can/rx-offload.c                                |   96 +++++++=
+++--
 drivers/net/can/spi/mcp251x.c                               |    2=20
 drivers/net/can/usb/peak_usb/pcan_usb.c                     |   15 +
 drivers/net/dsa/bcm_sf2.c                                   |    7=20
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c             |    4=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   |   57 +++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                   |    1=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c           |   78 +++++++=
--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c              |    7=20
 drivers/net/ethernet/broadcom/genet/bcmmii.c                |   33 ++++
 drivers/net/ethernet/cadence/macb.h                         |    6=20
 drivers/net/ethernet/cadence/macb_main.c                    |   19 +-
 drivers/net/ethernet/cadence/macb_ptp.c                     |    5=20
 drivers/net/ethernet/freescale/fec_main.c                   |   13 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c             |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c      |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h      |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c      |    7=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h     |    1=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c       |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c   |    7=20
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c             |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/main.c              |    8 -
 drivers/net/ethernet/mscc/ocelot.h                          |    2=20
 drivers/net/ethernet/sfc/ef10.c                             |   29 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c           |    4=20
 drivers/net/ethernet/ti/cpts.c                              |    4=20
 drivers/net/macvlan.c                                       |    3=20
 drivers/net/slip/slip.c                                     |    1=20
 drivers/net/vxlan.c                                         |   13 +
 drivers/net/wan/fsl_ucc_hdlc.c                              |    1=20
 drivers/net/wireless/ath/ath6kl/cfg80211.c                  |    4=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |   10 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c     |   29 +++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h     |    9 +
 drivers/net/wireless/intel/iwlwifi/dvm/main.c               |   17 ++
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c       |   19 --
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h       |    5=20
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                 |    4=20
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c              |   14 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c           |   24 +--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c                |   10 -
 drivers/net/wireless/marvell/mwifiex/debugfs.c              |   14 -
 drivers/net/wireless/marvell/mwifiex/scan.c                 |   18 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c          |    3=20
 drivers/nvme/host/core.c                                    |   41 ++++-
 drivers/nvme/host/nvme.h                                    |    3=20
 drivers/pci/msi.c                                           |   22 +-
 drivers/pinctrl/intel/pinctrl-cherryview.c                  |   24 +--
 drivers/pinctrl/pinctrl-xway.c                              |   39 +++-
 drivers/pinctrl/sh-pfc/pfc-r8a77990.c                       |    2=20
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                         |    9 -
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                         |   16 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c                       |   26 ++-
 drivers/platform/x86/hp-wmi.c                               |   10 -
 drivers/platform/x86/mlx-platform.c                         |    4=20
 drivers/power/avs/smartreflex.c                             |    3=20
 drivers/pwm/core.c                                          |    1=20
 drivers/pwm/pwm-bcm-iproc.c                                 |    1=20
 drivers/pwm/pwm-berlin.c                                    |    1=20
 drivers/pwm/pwm-clps711x.c                                  |    4=20
 drivers/pwm/pwm-pca9685.c                                   |    1=20
 drivers/pwm/pwm-samsung.c                                   |    1=20
 drivers/regulator/palmas-regulator.c                        |    5=20
 drivers/regulator/tps65910-regulator.c                      |    4=20
 drivers/reset/core.c                                        |    1=20
 drivers/s390/crypto/ap_queue.c                              |   23 ++
 drivers/scsi/csiostor/csio_init.c                           |    2=20
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                      |   12 +
 drivers/scsi/libsas/sas_expander.c                          |   29 +++
 drivers/scsi/lpfc/lpfc.h                                    |    6=20
 drivers/scsi/lpfc/lpfc_attr.c                               |    4=20
 drivers/scsi/lpfc/lpfc_bsg.c                                |    6=20
 drivers/scsi/lpfc/lpfc_els.c                                |    4=20
 drivers/scsi/lpfc/lpfc_hbadisc.c                            |    2=20
 drivers/scsi/lpfc/lpfc_init.c                               |    7=20
 drivers/scsi/lpfc/lpfc_scsi.c                               |   18 ++
 drivers/scsi/lpfc/lpfc_sli.c                                |    2=20
 drivers/scsi/qla2xxx/qla_attr.c                             |    2=20
 drivers/scsi/qla2xxx/qla_init.c                             |   10 -
 drivers/scsi/qla2xxx/qla_nvme.c                             |   16 --
 drivers/scsi/qla2xxx/qla_os.c                               |    2=20
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                          |   48 +-----
 drivers/scsi/qla2xxx/tcm_qla2xxx.h                          |    3=20
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c                |    5=20
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c                |    7=20
 drivers/target/target_core_user.c                           |    2=20
 drivers/thunderbolt/switch.c                                |   54 +++++-
 drivers/tty/serial/8250/8250_core.c                         |   26 +++
 drivers/tty/serial/8250/8250_fsl.c                          |   23 ++
 drivers/tty/serial/8250/8250_of.c                           |    5=20
 drivers/tty/serial/max310x.c                                |    7=20
 drivers/tty/serial/sh-sci.c                                 |    2=20
 drivers/usb/dwc2/core.c                                     |    2=20
 drivers/usb/host/ehci-omap.c                                |    7=20
 drivers/usb/serial/ftdi_sio.c                               |    3=20
 drivers/usb/serial/ftdi_sio_ids.h                           |    7=20
 drivers/vfio/vfio_iommu_spapr_tce.c                         |   10 -
 drivers/watchdog/meson_gxbb_wdt.c                           |    4=20
 drivers/watchdog/sama5d4_wdt.c                              |    4=20
 drivers/xen/xen-pciback/pci_stub.c                          |    3=20
 fs/btrfs/delayed-ref.c                                      |    3=20
 fs/btrfs/dev-replace.c                                      |   21 +-
 fs/btrfs/disk-io.c                                          |    7=20
 fs/btrfs/extent-tree.c                                      |    7=20
 fs/btrfs/extent_io.h                                        |    4=20
 fs/btrfs/volumes.c                                          |   13 -
 fs/ceph/super.c                                             |   11 +
 fs/exofs/super.c                                            |   37 +++-
 fs/ext4/inode.c                                             |   15 +
 fs/ext4/super.c                                             |   21 +-
 fs/f2fs/file.c                                              |    2=20
 fs/f2fs/segment.c                                           |    2=20
 fs/gfs2/bmap.c                                              |    2=20
 fs/ocfs2/journal.c                                          |    6=20
 fs/ubifs/sb.c                                               |   13 +
 fs/xfs/libxfs/xfs_symlink_remote.c                          |   14 +
 fs/xfs/xfs_buf.c                                            |    3=20
 fs/xfs/xfs_ioctl32.c                                        |   40 ++++-
 fs/xfs/xfs_rtalloc.c                                        |    4=20
 fs/xfs/xfs_symlink.c                                        |   33 ++--
 include/linux/blktrace_api.h                                |    8 -
 include/linux/genalloc.h                                    |   13 -
 include/linux/gpio/consumer.h                               |    2=20
 include/linux/idr.h                                         |    2=20
 include/linux/kprobes.h                                     |    3=20
 include/linux/memory_hotplug.h                              |   18 +-
 include/linux/netdevice.h                                   |    2=20
 include/linux/reset-controller.h                            |    2=20
 include/linux/sched/task.h                                  |    2=20
 include/linux/serial_8250.h                                 |    4=20
 include/linux/swap.h                                        |    6=20
 include/linux/trace_events.h                                |    2=20
 include/net/fq_impl.h                                       |    4=20
 include/net/sctp/structs.h                                  |    3=20
 include/net/sock.h                                          |    2=20
 include/trace/events/rpcrdma.h                              |   28 +++
 init/main.c                                                 |    1=20
 kernel/bpf/cpumap.c                                         |   13 +
 kernel/bpf/syscall.c                                        |    6=20
 kernel/fork.c                                               |    5=20
 kernel/kprobes.c                                            |   67 ++++++--
 kernel/trace/trace_events.c                                 |   34 +++-
 kernel/trace/trace_events_hist.c                            |   24 +--
 lib/genalloc.c                                              |   25 +--
 lib/radix-tree.c                                            |    2=20
 mm/internal.h                                               |   10 +
 mm/memblock.c                                               |    7=20
 mm/page_alloc.c                                             |   29 +--
 net/bridge/netfilter/ebt_dnat.c                             |   19 +-
 net/core/neighbour.c                                        |   13 +
 net/core/net_namespace.c                                    |    3=20
 net/core/sock.c                                             |    2=20
 net/decnet/dn_dev.c                                         |    2=20
 net/ipv4/ip_gre.c                                           |   33 ++--
 net/ipv4/ip_tunnel.c                                        |    8 -
 net/ipv4/tcp_timer.c                                        |    6=20
 net/ipv6/ip6_gre.c                                          |   36 ++--
 net/mac80211/sta_info.c                                     |    3=20
 net/netfilter/nf_nat_sip.c                                  |   39 ++++
 net/netfilter/nf_tables_api.c                               |    2=20
 net/openvswitch/datapath.c                                  |   17 +-
 net/psample/psample.c                                       |    2=20
 net/sched/sch_mq.c                                          |    3=20
 net/sched/sch_mqprio.c                                      |    4=20
 net/sched/sch_multiq.c                                      |    2=20
 net/sched/sch_prio.c                                        |    2=20
 net/sctp/associola.c                                        |    1=20
 net/sctp/endpointola.c                                      |    1=20
 net/sctp/input.c                                            |    4=20
 net/sctp/sm_statefuns.c                                     |    4=20
 net/sctp/transport.c                                        |    3=20
 net/smc/smc_cdc.c                                           |    7=20
 net/smc/smc_cdc.h                                           |   45 ++++-
 net/smc/smc_core.c                                          |    4=20
 net/smc/smc_tx.c                                            |   10 -
 net/sunrpc/xprtrdma/rpc_rdma.c                              |    4=20
 net/tipc/link.c                                             |    2=20
 net/tipc/netlink_compat.c                                   |   15 +
 net/vmw_vsock/af_vsock.c                                    |    7=20
 net/xfrm/xfrm_state.c                                       |    2=20
 samples/bpf/Makefile                                        |    1=20
 samples/vfio-mdev/mtty.c                                    |   26 +--
 scripts/gdb/linux/symbols.py                                |    3=20
 security/apparmor/apparmorfs.c                              |    1=20
 sound/core/compress_offload.c                               |    2=20
 sound/soc/codecs/msm8916-wcd-analog.c                       |    4=20
 sound/soc/codecs/rt5645.c                                   |   14 +
 sound/soc/kirkwood/kirkwood-i2s.c                           |   11 -
 sound/soc/samsung/i2s.c                                     |    8 -
 sound/soc/stm/stm32_i2s.c                                   |   29 +--
 sound/soc/stm/stm32_sai.c                                   |   11 +
 sound/soc/stm/stm32_sai_sub.c                               |   12 +
 tools/testing/selftests/bpf/test_sockmap.c                  |    9 +
 tools/vm/page-types.c                                       |    2=20
 virt/kvm/kvm_main.c                                         |    2=20
 397 files changed, 2586 insertions(+), 1181 deletions(-)

Aaro Koskinen (1):
      ARM: OMAP1: fix USB configuration for device-only setups

Aaron Lu (2):
      mm/page_alloc.c: free order-0 pages through PCP in page_frag_free()
      mm/page_alloc.c: use a single function to free page

Aaron Ma (1):
      iommu/amd: Fix NULL dereference bug in match_hid_uid

Aditya Pakki (4):
      net/netlink_compat: Fix a missing check of nla_parse_nested
      net/net_namespace: Check the return value of register_pernet_subsys()
      infiniband: bnxt_re: qplib: Check the return value of send_message
      infiniband/qedr: Potential null ptr dereference of qp

Ahmed Zaki (1):
      mac80211: fix station inactive_time shortly after boot

Al Viro (1):
      exofs_mount(): fix leaks on failure exits

Alexander Shiyan (2):
      serial: max310x: Fix tx_empty() callback
      pwm: clps711x: Fix period calculation

Alexander Usyskin (2):
      mei: bus: prefix device names on bus with the bus name
      mei: me: add comet point V device id

Alexandre Belloni (2):
      clk: at91: avoid sleeping early
      clk: at91: generated: set audio_pll_allowed in at91_clk_register_gene=
rated()

Alexandre Torgue (1):
      pinctrl: stm32: fix memory leak issue

Alexey Kardashevskiy (2):
      vfio/spapr_tce: Get rid of possible infinite loop
      powerpc/powernv/eeh/npu: Fix uninitialized variables in opal_pci_eeh_=
freeze_status

Alexey Skidanov (1):
      lib/genalloc.c: fix allocation of aligned buffer from non-aligned chu=
nk

Alin Nastac (1):
      netfilter: nf_nat_sip: fix RTP/RTCP source port translations

Anand Jain (1):
      btrfs: dev-replace: set result code of cancel by status of scrub

Anatoliy Glagolev (1):
      scsi: qla2xxx: deadlock by configfs_depend_item

Andrea Righi (1):
      kprobes/x86/xen: blacklist non-attachable xen interrupt functions

Andy Shevchenko (2):
      pinctrl: cherryview: Allocate IRQ chip dynamic
      net: dev: Use unsigned integer as an argument to left-shift

Anthony Yznaga (1):
      tools/vm/page-types.c: fix "kpagecount returned fewer pages than expe=
cted" failures

Arnaud Pouliquen (1):
      mailbox: stm32_ipcc: add spinlock to fix channels concurrent access

Arnd Bergmann (1):
      ARM: ks8695: fix section mismatch warning

Atul Gupta (1):
      crypto/chelsio/chtls: listen fails with multiadapt

Avraham Stern (1):
      iwlwifi: mvm: force TCM re-evaluation on TCM resume

Bart Van Assche (2):
      scsi: target/tcmu: Fix queue_cmd_ring() declaration
      RDMA/srp: Propagate ib_post_send() failures to the SCSI mid-layer

Benjamin Herrenschmidt (2):
      powerpc/44x/bamboo: Fix PCI range
      powerpc: Fix HMIs on big-endian with CONFIG_RELOCATABLE=3Dy

Bert Kenward (1):
      sfc: initialise found bitmap in efx_ef10_mtd_probe

Bj=F6rn T=F6pel (1):
      samples/bpf: fix build by setting HAVE_ATTR_TEST to zero

Bob Peterson (1):
      gfs2: take jdata unstuff into account in do_grow

Boris Brezillon (3):
      mtd: rawnand: sunxi: Write pageprog related opcodes to WCMD_SET
      mtd: Check add_mtd_device() ret code
      mtd: Remove a debug trace in mtdpart.c

Brian Foster (1):
      xfs: end sync buffer I/O properly on shutdown error

Brian Norris (1):
      mwifiex: debugfs: correct histogram spacing, formatting

Candle Sun (1):
      HID: core: check whether Usage Page item is after Usage ID items

Chao Yu (1):
      f2fs: fix to dirty inode synchronously

Chris Coulson (1):
      apparmor: delete the dentry in aafs_remove() to avoid a leak

Christophe Leroy (5):
      powerpc/book3s/32: fix number of bats in p/v_block_mapped()
      powerpc/xmon: fix dump_segments()
      powerpc/prom: fix early DEBUG messages
      powerpc/mm: Make NULL pointer deferences explicit on bad page faults.
      powerpc/83xx: handle machine check caused by watchdog timer

Chuck Lever (1):
      xprtrdma: Prevent leak of rpcrdma_rep objects

Chuhong Yuan (3):
      net: fec: add missed clk_disable_unprepare in remove
      net: macb: add missed tasklet_kill
      net: fec: fix clock count mis-match

Claudiu Beznea (1):
      drm/atmel-hlcdc: revert shift by 8

Colin Ian King (1):
      clk: sunxi-ng: a80: fix the zero'ing of bits 16 and 18

Dan Carpenter (2):
      block: drbd: remove a stray unlock in __drbd_send_protocol()
      IB/qib: Fix an error code in qib_sdma_verbs_send()

Darrick J. Wong (1):
      xfs: require both realtime inodes to mount

Darwin Dingel (1):
      serial: 8250: Rate limit serial port rx interrupts during input overr=
uns

Dave Chinner (1):
      xfs: zero length symlinks are not valid

Doug Berger (2):
      net: bcmgenet: use RGMII loopback for MAC reset
      net: bcmgenet: reapply manual settings to the PHY

Dust Li (1):
      net: sched: fix `tc -s class show` no bstats on class with nolock sub=
queues

Edward Cree (1):
      sfc: suppress duplicate nvmem partition types in efx_ef10_mtd_probe

Eric Biggers (1):
      crypto: user - support incremental algorithm dumps

Eric Dumazet (2):
      powerpc/bpf: Fix tail call implementation
      net: fix possible overflow in __sk_mem_raise_allocated()

Eugen Hristev (5):
      clk: at91: fix update bit maps on CFG_MOR write
      media: v4l2-ctrl: fix flags for DO_WHITE_BALANCE
      media: atmel: atmel-isc: fix asd memory allocation
      media: atmel: atmel-isc: fix INIT_WORK misplacement
      watchdog: sama5d4: fix WDD value to be always set to max

Fabien Dessenne (1):
      mailbox: mailbox-test: fix null pointer if no mmio

Fabien Parent (1):
      clocksource/drivers/mediatek: Fix error handling

Fabio D'Urso (1):
      USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P

Fabio Estevam (16):
      ARM: dts: imx6qdl-sabreauto: Fix storm of accelerometer interrupts
      ARM: dts: imx51: Fix memory node duplication
      ARM: dts: imx53: Fix memory node duplication
      ARM: dts: imx31: Fix memory node duplication
      ARM: dts: imx35: Fix memory node duplication
      ARM: dts: imx7: Fix memory node duplication
      ARM: dts: imx6ul: Fix memory node duplication
      ARM: dts: imx6sx: Fix memory node duplication
      ARM: dts: imx6sl: Fix memory node duplication
      ARM: dts: imx50: Fix memory node duplication
      ARM: dts: imx23: Fix memory node duplication
      ARM: dts: imx1: Fix memory node duplication
      ARM: dts: imx27: Fix memory node duplication
      ARM: dts: imx25: Fix memory node duplication
      ARM: dts: imx53-voipac-dmm-668: Fix memory node duplication
      crypto: mxc-scc - fix build warnings on ARM64

Filipe Manana (1):
      Btrfs: allow clear_extent_dirty() to receive a cached extent state re=
cord

Florian Westphal (1):
      bridge: ebtables: don't crash when using dnat target in output chains

Gabor Juhos (1):
      ubifs: Fix default compression selection in ubifs

Gabriel Fernandez (4):
      clk: stm32mp1: fix HSI divider flag
      clk: stm32mp1: fix mcu divider table
      clk: stm32mp1: add CLK_SET_RATE_NO_REPARENT to Kernel clocks
      clk: stm32mp1: parent clocks update

Gal Pressman (1):
      RDMA/vmw_pvrdma: Use atomic memory allocation in create AH

Geert Uytterhoeven (5):
      serial: sh-sci: Fix crash in rx_timer_fn() on PIO fallback
      pinctrl: sh-pfc: r8a77990: Fix MOD_SEL0 SEL_I2C1 field width
      pinctrl: sh-pfc: sh7264: Fix PFCR3 and PFCR0 register configuration
      pinctrl: sh-pfc: sh7734: Fix shifted values in IPSR10
      openrisc: Fix broken paths to arch/or32

Gen Zhang (1):
      powerpc/pseries/dlpar: Fix a missing check in dlpar_parse_cc_property=
()

Giridhar Malavali (1):
      scsi: qla2xxx: Fix for FC-NVMe discovery for NPIV port

Greg Kroah-Hartman (4):
      Revert "KVM: nVMX: reset cache/shadows when switching loaded VMCS"
      Revert "KVM: nVMX: move check_vmentry_postreqs() call to nested_vmx_e=
nter_non_root_mode()"
      kvm: properly check debugfs dentry before using it
      Linux 4.19.88

Gustavo A. R. Silva (1):
      tipc: fix memory leak in tipc_nl_compat_publ_dump

Hans de Goede (5):
      ACPI / LPSS: Ignore acpi_device_fix_up_power() return value
      staging: rtl8723bs: Drop ACPI device ids
      staging: rtl8723bs: Add 024c:0525 to the list of SDIO device-ids
      platform/x86: hp-wmi: Fix ACPI errors caused by too small buffer
      platform/x86: hp-wmi: Fix ACPI errors caused by passing 0 as input si=
ze

Hans van Kranenburg (1):
      btrfs: fix ncopies raid_attr for RAID56

Harald Freudenberger (1):
      s390/zcrypt: make sysfs reset attribute trigger queue reset

Harini Katakam (1):
      net: macb: Fix SUBNS increment and increase resolution

He Zhe (1):
      serial: 8250: Fix serial8250 initialization crash

Heinz Mauelshagen (1):
      dm raid: fix false -EBUSY when handling check/repair message

Helge Deller (2):
      parisc: Fix serio address output
      parisc: Fix HP SDC hpa address output

Himanshu Madhani (1):
      scsi: qla2xxx: Fix NPIV handling for FC-NVMe

Hoang Le (1):
      tipc: fix skb may be leaky in tipc_link_input

Huang Shijie (1):
      lib/genalloc.c: use vzalloc_node() to allocate the bitmap

Hugues Fruchet (2):
      media: stm32-dcmi: fix DMA corruption when stopping streaming
      media: stm32-dcmi: fix check of pm_runtime_get_sync return value

Hui Wang (1):
      ASoC: rt5645: Headphone Jack sense inverts on the LattePanda board

Ilya Leoshkevich (1):
      scripts/gdb: fix debugging modules compiled with hot/cold partitioning

Jakub Kicinski (1):
      selftests: bpf: test_sockmap: handle file creation failures gracefully

James Morse (3):
      firmware: arm_sdei: Fix DT platform device creation
      ACPI / APEI: Don't wait to serialise with oops messages when panic()i=
ng
      ACPI / APEI: Switch estatus pool to use vmalloc memory

James Smart (3):
      scsi: lpfc: Fix kernel Oops due to null pring pointers
      scsi: lpfc: Fix dif and first burst use in write commands
      scsi: lpfc: Enable Management features for IF_TYPE=3D6

Jan Kara (1):
      blktrace: Show requests without sector

Jeff Layton (1):
      ceph: return -EINVAL if given fsc mount option on kernel w/o support

Jens Axboe (1):
      nvme: provide fallback for discard alloc failure

Jeroen Hofstee (3):
      can: peak_usb: report bus recovery as well
      can: c_can: D_CAN: c_can_chip_config(): perform a sofware reset on op=
en
      can: rx-offload: can_rx_offload_irq_offload_timestamp(): continue on =
error

Jerome Brunet (1):
      mmc: meson-gx: make sure the descriptor is stopped on errors

Jesper Dangaard Brouer (2):
      bpf/cpumap: make sure frame_size for build_skb is aligned if headroom=
 isn't
      xdp: fix cpumap redirect SKB creation bug

Jim Mattson (1):
      kvm: vmx: Set IA32_TSC_AUX for legacy mode guests

Joel Stanley (1):
      powerpc/32: Avoid unsupported flags with clang

Johannes Berg (1):
      decnet: fix DN_IFREQ_SIZE

John Garry (2):
      scsi: libsas: Support SATA PHY connection rate unmatch fixing during =
discovery
      scsi: libsas: Check SMP PHY control function result

John Rutherford (1):
      tipc: fix link name length check

Jonathan Bakker (1):
      Bluetooth: hci_bcm: Handle specific unknown packets after firmware lo=
ading

Josef Bacik (1):
      btrfs: only track ref_heads in delayed_ref_updates

Jouni Hogander (1):
      slip: Fix use-after-free Read in slip_open

Junxiao Bi (1):
      ocfs2: clear journal dirty flag after shutdown journal

Kangjie Lu (9):
      drivers/regulator: fix a missing check of return value
      regulator: tps65910: fix a missing check of return value
      net: (cpts) fix a missing check of clk_prepare
      net: stmicro: fix a missing check of clk_prepare
      net: dsa: bcm_sf2: Propagate error value from mdio_write
      atl1e: checking the status of atl1e_write_phy_reg
      tipc: fix a missing check of genlmsg_put
      net: marvell: fix a missing check of acpi_match_device
      netfilter: nf_tables: fix a missing check of nla_put_failure

Karsten Graul (2):
      net/smc: prevent races between smc_lgr_terminate() and smc_conn_free()
      net/smc: don't wait for send buffer space when data was already sent

Kishon Vijay Abraham I (1):
      reset: Fix memory leak in reset_control_array_put()

Konstantin Khlebnikov (2):
      net/core/neighbour: tell kmemleak about hash tables
      net/core/neighbour: fix kmemleak minimal reference count for hash tab=
les

Krzysztof Kozlowski (1):
      gpiolib: Fix return value of gpio_to_desc() stub if !GPIOLIB

Kyle Roeschley (2):
      ath6kl: Only use match sets when firmware supports it
      ath6kl: Fix off by one error in scan completion

Lars Ellenberg (3):
      drbd: ignore "all zero" peer volume sizes in handshake
      drbd: reject attach of unsuitable uuids even if connected
      drbd: do not block when adjusting "disk-options" while IO is frozen

Laurent Pinchart (1):
      arm64: dts: renesas: draak: Fix CVBS input

Leon Romanovsky (1):
      net/mlx5: Continue driver initialization despite debugfs failure

Lepton Wu (1):
      VSOCK: bind to random port for VMADDR_PORT_ANY

Lijun Ou (3):
      RDMA/hns: Fix the bug while use multi-hop of pbl
      RDMA/hns: Fix the bug with updating rq head pointer when flush cqe
      RDMA/hns: Bugfix for the scene without receiver queue

Linus Walleij (2):
      ARM: dts: Fix up SQ201 flash access
      memory: omap-gpmc: Get the header of the enum

Lionel Debieve (2):
      crypto: stm32/hash - Fix hmac issue more than 256 bytes
      hwrng: stm32 - fix unbalanced pm_runtime_enable

Lorenzo Bianconi (2):
      net: ip_gre: do not report erspan_ver for gre or gretap
      net: ip6_gre: do not report erspan_ver for ip6gre or ip6gretap

Luc Van Oostenryck (1):
      drbd: fix print_st_err()'s prototype to match the definition

Luca Ceresoli (1):
      net: macb: fix error format in dev_err()

Luca Coelho (1):
      iwlwifi: move iwl_nvm_check_version() into dvm

Lucas Stach (1):
      gpu: ipu-v3: pre: don't trigger update if buffer address doesn't chan=
ge

Maciej Kwiecien (1):
      sctp: don't compare hb_timer expire date before starting it

Madhan Mohan R (1):
      brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373

Madhavan Srinivasan (1):
      powerpc/perf: Fix unit_sel/cache_sel checks

Marc Kleine-Budde (6):
      can: rx-offload: can_rx_offload_queue_tail(): fix error handling, avo=
id skb mem leak
      can: rx-offload: can_rx_offload_offload_one(): do not increase the sk=
b_queue beyond skb_queue_len_max
      can: rx-offload: can_rx_offload_offload_one(): increment rx_fifo_erro=
rs on queue overflow or OOM
      can: rx-offload: can_rx_offload_offload_one(): use ERR_PTR() to propa=
gate error value in case of errors
      can: rx-offload: can_rx_offload_irq_offload_fifo(): continue on error
      can: flexcan: increase error counters if skb enqueueing via can_rx_of=
fload_queue_sorted() fails

Marek Szyprowski (2):
      clk: samsung: exynos5433: Fix error paths
      clk: samsung: exynos5420: Preserve PLL configuration during suspend/r=
esume

Marek Vasut (1):
      gpio: pca953x: Fix AI overflow on PCAL6524

Martin Blumenstingl (1):
      clk: meson: gxbb: let sar_adc_clk_div set the parent clock rate

Martin Schiller (1):
      pinctrl: xway: fix gpio-hog related boot issues

Masahiro Yamada (3):
      microblaze: adjust the help to the real behavior
      microblaze: move "... is ready" messages to arch/microblaze/Makefile
      microblaze: fix multiple bugs in arch/microblaze/boot/Makefile

Masami Hiramatsu (3):
      tracing: Lock event_mutex before synth_event_mutex
      kprobes: Blacklist symbols in arch-defined prohibited area
      kprobes/x86: Show x86-64 specific blacklisted symbols correctly

Mathias Kresin (1):
      usb: dwc2: use a longer core rest timeout in dwc2_core_reset()

Matteo Croce (1):
      geneve: change NET_UDP_TUNNEL dependency to select

Matthew Wilcox (Oracle) (2):
      idr: Fix integer overflow in idr_for_each_entry
      idr: Fix idr_alloc_u32 on 32-bit systems

Menglong Dong (1):
      macvlan: schedule bc_work even if error

Michael Chan (1):
      bnxt_en: Save ring statistics before reset.

Michael Ellerman (1):
      powerpc/pseries: Fix node leak in update_lmb_associativity_index()

Michael Mueller (1):
      KVM: s390: unregister debug feature on failing arch init

Mika Westerberg (1):
      thunderbolt: Power cycle the router if NVM authentication fails

Ming Lei (2):
      PCI/MSI: Return -ENOSPC from pci_alloc_irq_vectors_affinity()
      mmc: core: align max segment size with logical block size

Miquel Raynal (2):
      ata: ahci: mvebu: do Armada 38x configuration only on relevant SoCs
      mtd: rawnand: atmel: Fix spelling mistake in error message

Nathan Chancellor (2):
      clk: sunxi: Fix operator precedence in sunxi_divs_clk_setup
      vfio-mdev/samples: Use u8 instead of char for handle functions

Navid Emamdoost (1):
      sctp: Fix memory leak in sctp_sf_do_5_2_4_dupcook

Nick Bowler (2):
      xfs: Align compat attrlist_by_handle with native implementation.
      xfs: Fix bulkstat compat ioctls on x32 userspace.

Nicolas Saenz Julienne (2):
      gpio: raspberrypi-exp: decrease refcount on firmware dt node
      firmware: arm_sdei: fix wrong of_node_put() in init function

Nikolay Aleksandrov (1):
      net: psample: fix skb_over_panic

Nikolay Borisov (1):
      btrfs: Check for missing device before bio submission in btrfs_map_bio

Olivier Moysan (4):
      ASoC: stm32: sai: add restriction on mmap support
      ASoC: stm32: i2s: fix dma configuration
      ASoC: stm32: i2s: fix 16 bit format support
      ASoC: stm32: i2s: fix IRQ clearing

Olof Johansson (1):
      lib/genalloc.c: include vmalloc.h

Ondrej Jirman (1):
      ARM: dts: sun8i-a83t-tbs-a711: Fix WiFi resume from suspend

Pan Bian (6):
      mwifiex: fix potential NULL dereference and use after free
      rtl818x: fix potential use after free
      ubi: Put MTD device after it is not used
      ubi: Do not drop UBI device reference before using
      HID: intel-ish-hid: fixes incorrect error handling
      staging: rtl8192e: fix potential use after free

Paolo Abeni (3):
      openvswitch: fix flow command message size
      openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()
      openvswitch: remove another BUG_ON()

Parav Pandit (1):
      IB/rxe: Make counters thread safe

Paul Thomas (1):
      net: macb driver, check for SKBTX_HW_TSTAMP

Peng Li (2):
      net: hns3: fix an issue for hclgevf_ae_get_hdev
      net: hns3: fix an issue for hns3_update_new_int_gl

Peng Sun (2):
      bpf: decrease usercnt if bpf_map_new_fd() fails in bpf_map_get_fd_by_=
id()
      bpf: drop refcount if bpf_map_new_fd() fails in map_create()

Peter Hutterer (1):
      HID: doc: fix wrong data structure reference for UHID_OUTPUT

Peter Ujfalusi (1):
      clk: ti: dra7-atl-clock: Remove ti_clk_add_alias call

Petr Machata (1):
      vxlan: Fix error path in __vxlan_dev_create()

Pierre-Yves MORDRET (1):
      dmaengine: stm32-dma: check whether length is aligned on FIFO thresho=
ld

Qian Cai (2):
      drivers/base/platform.c: kmemleak ignore a known leak
      mm/hotplug: invalid PFNs from pfn_to_online_page()

Qiuyang Sun (1):
      f2fs: fix block address for __check_sit_bitmap

Randy Dunlap (1):
      reset: fix reset_control_ops kerneldoc comment

Richard Weinberger (2):
      um: Include sys/uio.h to have writev()
      um: Make GCOV depend on !KCOV

Roger Quadros (1):
      usb: ehci-omap: Fix deferred probe for phy handling

Ross Lagerwall (1):
      xen/pciback: Check dev_data before using it

Russell King (2):
      ASoC: kirkwood: fix external clock probe defer
      ASoC: kirkwood: fix device remove ordering

Sagi Grimberg (1):
      nvme: fix kernel paging oops

Sara Sharon (2):
      iwlwifi: pcie: fix erroneous print
      iwlwifi: pcie: set cmd_len in the correct place

Shenghui Wang (2):
      bcache: do not check if debug dentry is ERR or NULL explicitly on rem=
ove
      bcache: do not mark writeback_running too early

Stefan Wahren (1):
      brcmfmac: Fix access point mode

Steffen Klassert (1):
      xfrm: Fix memleak on xfrm state destroy

Stephan Gerhold (1):
      ASoC: msm8916-wcd-analog: Fix RX1 selection in RDAC2 MUX

Steve Capper (1):
      arm64: mm: Prevent mismatched 52-bit VA support

Suzuki K Poulose (1):
      arm64: smp: Handle errors reported by the firmware

Sweet Tea (1):
      dm flakey: Properly corrupt multi-page bios.

Sylwester Nawrocki (1):
      ASoC: samsung: i2s: Fix prescaler setting for the secondary DAI

Tao Ren (1):
      clocksource/drivers/fttmr010: Fix invalid interrupt register access

Theodore Ts'o (1):
      ext4: add more paranoia checking in ext4_expand_extra_isize handling

Thomas Meyer (1):
      PM / AVS: SmartReflex: NULL check before some freeing functions is no=
t needed

Timo Schl=FC=DFler (1):
      can: mcp251x: mcp251x_restart_work_handler(): Fix potential force_qui=
t race condition

Toke H=F8iland-J=F8rgensen (1):
      net/fq_impl: Switch to kvmalloc() for memory allocation

Tony Lindgren (3):
      clk: ti: clkctrl: Fix failed to enable error with double udelay timeo=
ut
      ARM: dts: Fix hsi gdd range for omap4
      bus: ti-sysc: Check for no-reset and no-idle flags at the child level

Ursula Braun (2):
      net/smc: fix sender_free computation
      net/smc: fix byte_order for rx_curs_confirmed

Uwe Kleine-K=F6nig (3):
      pwm: bcm-iproc: Prevent unloading the driver module while in use
      ARM: debug-imx: only define DEBUG_IMX_UART_PORT if needed
      pwm: Clear chip_data in pwm_put()

Vadim Pasternak (1):
      platform/x86: mlx-platform: Fix LED configuration

Varun Prakash (1):
      scsi: csiostor: fix incorrect dma device in case of vport

Vasundhara Volam (2):
      bnxt_en: Return linux standard errors in bnxt_ethtool.c
      bnxt_en: query force speeds before disabling autoneg mode.

Vladimir Oltean (1):
      net: mscc: ocelot: fix __ocelot_rmw_ix prototype

Vlastimil Babka (1):
      mm, gup: add missing refcount overflow checks on s390

Wei Yang (1):
      vmscan: return NODE_RECLAIM_NOSCAN in node_reclaim() when CONFIG_NUMA=
 is n

Wen Yang (3):
      net/wan/fsl_ucc_hdlc: Avoid double free in ucc_hdlc_probe()
      mtd: rawnand: atmel: fix possible object reference leak
      ASoC: stm32: sai: add missing put_device()

Wentao Wang (1):
      mm/page_alloc.c: deduplicate __memblock_free_early() and memblock_fre=
e()

Will Deacon (1):
      arm64: preempt: Fix big-endian when checking preempt count in assembly

Wright Feng (1):
      brcmfmac: set F2 watermark to 256 for 4373

Xiang Chen (1):
      scsi: hisi_sas: shutdown axi bus to avoid exception CQ returned

Xiaochen Shen (1):
      x86/resctrl: Prevent NULL pointer dereference when reading mondata

Xiaojun Sang (1):
      ASoC: compress: fix unsigned integer overflow check

Xin Long (1):
      sctp: cache netns in sctp_ep_common

Xingyu Chen (1):
      watchdog: meson: Fix the wrong value of left time

Yi Wang (1):
      fork: fix some -Wmissing-prototypes warnings

Yixian Liu (1):
      RDMA/hns: Fix the state of rereg mr

Yuchung Cheng (1):
      tcp: exit if nothing to retransmit on RTO timeout

YueHaibing (1):
      RDMA/hns: Use GFP_ATOMIC in hns_roce_v2_modify_qp

Yunsheng Lin (2):
      net: hns3: Change fw error code NOT_EXEC to NOT_SUPPORTED
      net: hns3: fix PFC not setting problem for DCB module

huijin.park (1):
      mtd: spi-nor: cast to u64 to avoid uint overflows

wenxu (1):
      ip_tunnel: Make none-tunnel-dst tunnel port work with lwtunnel


--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3pEwIACgkQONu9yGCS
aT5zsBAAh8i9EJy8zDitXkLZLooQ3d/jWEpQtd0hyVQJsD5MerFwCJyfRTkMFEHP
LWUsJv9lS7Ie7mAkBZLsfwUrAuNTZeifRqUlAAdQkThrJEcm4t8Y+TE9NUIGshRc
b6m7iJBQV2y40tHduPNrDWh5EPJI2dfpvvMGOn6ZRBfCYPrGd9YxcmC23caf1ulu
Xih3MZFCpDvH0U/ganbD7/B4VKvzsNKqkFNgQpam1MK2lWjIdWFZ2MIbfxkoQLjk
p9RAzTjOOaOQNn0xV/kBD4K4IFLZUgnWdtWL6PtNHDn7CXtQk05n3S61ZKKmaySO
jary4XgoObqoSQhate1xAs6k6PopN4q3WjrjTilstw/DGDBFgRYEPoKhRrYFE5+d
6x/GuUwIziu8ZQhAep1bQDmpvmFzAp5tUxRHxYtRAb5L9Vhei2X4Ib1mzCaQN1gd
5CaDerfhXNqPu1v0mdN/KGrS6RBOi+Si4gblGlLJUb4uxT48Bqd/jtsW7p/cf4rn
jUJDm0oqVbroq5Yw8pcbnlcqBS6YKskIP7z9GTS3Dv4GrZmrrzdat2+prgH5BeSM
Zm2b8QsWcPECyel7pudvu0+3Wgi0D1ky18y2FEbiboxWPoRTI47cSG4/MkPKGV+8
PsOy9+eoPoDsksT/wL/vJylpiSxqFPMl9LESTZeRjaRTA9gmtZ0=
=7rKS
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
