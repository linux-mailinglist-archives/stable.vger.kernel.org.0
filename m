Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF2A105352
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 14:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfKUNlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 08:41:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfKUNlH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 08:41:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2833D2070A;
        Thu, 21 Nov 2019 13:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574343664;
        bh=jv/RBEje1Qmcih64hmNGH2o3XxdunvRYnTGeBgOlB84=;
        h=Date:From:To:Cc:Subject:From;
        b=GB4BuvS7Qgg6O3zrIrMVJ1N4qmuIwuuaQ701LdPXfZO48qikqH/uHqYbPv9FoTqxR
         R9TKboGnVWKvFRumVUIwASXa0cM/s/JGtLy72+kOuQsDC6+/cqgV0BZmKBGv67FapS
         8j2nt/+9XXLGQawdXByk+vDP8TetCdeJlxWhRGCU=
Date:   Thu, 21 Nov 2019 14:41:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.155
Message-ID: <20191121134102.GA548190@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.155 kernel.

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

 Documentation/devicetree/bindings/media/i2c/adv748x.txt      |    4=20
 Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt   |    3=20
 Makefile                                                     |    2=20
 arch/arm/boot/compressed/libfdt_env.h                        |    2=20
 arch/arm/boot/dts/am335x-evm.dts                             |   12=20
 arch/arm/boot/dts/arm-realview-eb.dtsi                       |    2=20
 arch/arm/boot/dts/arm-realview-pb1176.dts                    |    2=20
 arch/arm/boot/dts/arm-realview-pb11mp.dts                    |    2=20
 arch/arm/boot/dts/arm-realview-pbx.dtsi                      |    2=20
 arch/arm/boot/dts/armada-388-clearfog.dtsi                   |    2=20
 arch/arm/boot/dts/at91sam9g45.dtsi                           |    2=20
 arch/arm/boot/dts/dove-cubox.dts                             |    2=20
 arch/arm/boot/dts/dove.dtsi                                  |    6=20
 arch/arm/boot/dts/exynos5250-arndale.dts                     |    9=20
 arch/arm/boot/dts/exynos5250-snow-rev5.dts                   |   11=20
 arch/arm/boot/dts/exynos5420-peach-pit.dts                   |    3=20
 arch/arm/boot/dts/exynos5800-peach-pi.dts                    |    3=20
 arch/arm/boot/dts/lpc32xx.dtsi                               |    4=20
 arch/arm/boot/dts/meson8.dtsi                                |    2=20
 arch/arm/boot/dts/meson8b.dtsi                               |    2=20
 arch/arm/boot/dts/omap3-gta04.dtsi                           |   49 ++-
 arch/arm/boot/dts/orion5x-linkstation.dtsi                   |    2=20
 arch/arm/boot/dts/pxa25x.dtsi                                |    4=20
 arch/arm/boot/dts/pxa27x.dtsi                                |    6=20
 arch/arm/boot/dts/qcom-ipq4019.dtsi                          |    2=20
 arch/arm/boot/dts/rk3036.dtsi                                |    2=20
 arch/arm/boot/dts/rk3188-radxarock.dts                       |    8=20
 arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts            |    2=20
 arch/arm/boot/dts/ste-dbx5x0.dtsi                            |    6=20
 arch/arm/boot/dts/ste-href-family-pinctrl.dtsi               |    8=20
 arch/arm/boot/dts/ste-hrefprev60.dtsi                        |    2=20
 arch/arm/boot/dts/ste-snowball.dts                           |    2=20
 arch/arm/boot/dts/ste-u300.dts                               |    2=20
 arch/arm/boot/dts/tegra20-paz00.dts                          |    6=20
 arch/arm/boot/dts/tegra30-apalis.dtsi                        |    6=20
 arch/arm/boot/dts/tegra30.dtsi                               |    6=20
 arch/arm/boot/dts/versatile-ab.dts                           |    2=20
 arch/arm/crypto/crc32-ce-glue.c                              |    2=20
 arch/arm/mach-imx/pm-imx6.c                                  |   25 +
 arch/arm64/boot/dts/allwinner/sun50i-a64-nanopi-a64.dts      |    6=20
 arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts       |    8=20
 arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi                 |    4=20
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi                  |    2=20
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts |    2=20
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi                   |    2=20
 arch/arm64/boot/dts/lg/lg1312.dtsi                           |    4=20
 arch/arm64/boot/dts/lg/lg1313.dtsi                           |    4=20
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi               |    1=20
 arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi            |   26 +
 arch/mips/bcm47xx/workarounds.c                              |    8=20
 arch/mips/bcm63xx/reset.c                                    |    2=20
 arch/mips/include/asm/kexec.h                                |    6=20
 arch/mips/txx9/generic/setup.c                               |    5=20
 arch/powerpc/boot/libfdt_env.h                               |    2=20
 arch/powerpc/include/asm/imc-pmu.h                           |    6=20
 arch/powerpc/include/asm/uaccess.h                           |    6=20
 arch/powerpc/kernel/iommu.c                                  |    2=20
 arch/powerpc/kernel/rtas.c                                   |    2=20
 arch/powerpc/kernel/vdso32/datapage.S                        |    1=20
 arch/powerpc/kernel/vdso32/gettimeofday.S                    |    1=20
 arch/powerpc/kernel/vdso64/datapage.S                        |    1=20
 arch/powerpc/kernel/vdso64/gettimeofday.S                    |    1=20
 arch/powerpc/mm/slb.c                                        |    2=20
 arch/powerpc/perf/imc-pmu.c                                  |   17 -
 arch/powerpc/platforms/powernv/opal-imc.c                    |   16 +
 arch/x86/hyperv/hv_init.c                                    |   19 +
 arch/x86/kernel/cpu/common.c                                 |    4=20
 arch/x86/kernel/cpu/cyrix.c                                  |    2=20
 arch/x86/kernel/cpu/mcheck/mce-inject.c                      |    6=20
 arch/x86/kernel/uprobes.c                                    |    2=20
 arch/x86/kvm/vmx.c                                           |    7=20
 arch/x86/kvm/x86.c                                           |    8=20
 arch/x86/kvm/x86.h                                           |    5=20
 block/bfq-iosched.c                                          |   10=20
 crypto/rsa-pkcs1pad.c                                        |    9=20
 drivers/acpi/acpi_lpss.c                                     |   22 +
 drivers/acpi/pci_root.c                                      |    5=20
 drivers/base/component.c                                     |    6=20
 drivers/base/power/opp/core.c                                |   21 +
 drivers/base/power/opp/cpu.c                                 |    2=20
 drivers/base/power/opp/opp.h                                 |    2=20
 drivers/bluetooth/hci_serdev.c                               |    1=20
 drivers/char/ipmi/ipmi_dmi.c                                 |    4=20
 drivers/crypto/s5p-sss.c                                     |    4=20
 drivers/dma/Kconfig                                          |    2=20
 drivers/dma/dma-jz4780.c                                     |    2=20
 drivers/edac/sb_edac.c                                       |   68 ++--
 drivers/extcon/extcon-intel-cht-wc.c                         |    2=20
 drivers/firmware/dell_rbu.c                                  |    8=20
 drivers/hv/hv.c                                              |   15 -
 drivers/hwtracing/coresight/coresight-etm-perf.c             |   59 +++-
 drivers/hwtracing/coresight/coresight-etm4x.c                |   40 +-
 drivers/hwtracing/coresight/coresight-tmc-etf.c              |    4=20
 drivers/hwtracing/coresight/coresight.c                      |   22 +
 drivers/i2c/busses/i2c-aspeed.c                              |   65 +++-
 drivers/i2c/i2c-core-acpi.c                                  |   28 +
 drivers/iio/adc/max9611.c                                    |    2=20
 drivers/iio/dac/mcp4922.c                                    |   11=20
 drivers/infiniband/core/device.c                             |    2=20
 drivers/infiniband/core/mad.c                                |   72 ++---
 drivers/infiniband/hw/hfi1/pcie.c                            |    4=20
 drivers/infiniband/hw/hfi1/user_sdma.c                       |    4=20
 drivers/infiniband/hw/i40iw/i40iw_cm.c                       |    2=20
 drivers/infiniband/sw/rxe/rxe_comp.c                         |   21 +
 drivers/infiniband/sw/rxe/rxe_req.c                          |   15 -
 drivers/infiniband/ulp/ipoib/ipoib_main.c                    |    3=20
 drivers/infiniband/ulp/iser/iser_initiator.c                 |   18 -
 drivers/input/ff-memless.c                                   |    9=20
 drivers/input/rmi4/rmi_driver.c                              |    6=20
 drivers/input/rmi4/rmi_f11.c                                 |    4=20
 drivers/input/rmi4/rmi_f12.c                                 |   32 +-
 drivers/input/rmi4/rmi_f54.c                                 |    5=20
 drivers/media/pci/ivtv/ivtv-yuv.c                            |    2=20
 drivers/media/pci/meye/meye.c                                |    2=20
 drivers/media/platform/davinci/vpbe_display.c                |    2=20
 drivers/media/usb/au0828/au0828-core.c                       |    4=20
 drivers/misc/genwqe/card_utils.c                             |   13=20
 drivers/misc/kgdbts.c                                        |   16 -
 drivers/mmc/host/sdhci-of-at91.c                             |    2=20
 drivers/net/can/slcan.c                                      |    1=20
 drivers/net/ethernet/amd/am79c961a.c                         |    2=20
 drivers/net/ethernet/amd/atarilance.c                        |    6=20
 drivers/net/ethernet/amd/declance.c                          |    2=20
 drivers/net/ethernet/amd/sun3lance.c                         |    6=20
 drivers/net/ethernet/amd/sunlance.c                          |    2=20
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                     |    4=20
 drivers/net/ethernet/broadcom/bcm63xx_enet.c                 |    5=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c             |   10=20
 drivers/net/ethernet/broadcom/sb1250-mac.c                   |    4=20
 drivers/net/ethernet/cavium/liquidio/octeon_device.c         |    5=20
 drivers/net/ethernet/cavium/liquidio/octeon_iq.h             |    2=20
 drivers/net/ethernet/cavium/liquidio/request_manager.c       |    2=20
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                   |    2=20
 drivers/net/ethernet/faraday/ftgmac100.c                     |    4=20
 drivers/net/ethernet/faraday/ftmac100.c                      |    7=20
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c               |    3=20
 drivers/net/ethernet/freescale/fec_mpc52xx.c                 |    3=20
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c        |    3=20
 drivers/net/ethernet/freescale/gianfar.c                     |    4=20
 drivers/net/ethernet/freescale/ucc_geth.c                    |    3=20
 drivers/net/ethernet/hisilicon/hip04_eth.c                   |    3=20
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c                |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c      |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c        |    2=20
 drivers/net/ethernet/intel/i40e/i40e_main.c                  |    8=20
 drivers/net/ethernet/intel/i40e/i40e_ptp.c                   |    3=20
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c           |   10=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c               |    7=20
 drivers/net/ethernet/micrel/ks8695net.c                      |    2=20
 drivers/net/ethernet/micrel/ks8851_mll.c                     |    4=20
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c          |   16 -
 drivers/net/ethernet/smsc/smc911x.c                          |    3=20
 drivers/net/ethernet/smsc/smc91x.c                           |    3=20
 drivers/net/ethernet/smsc/smsc911x.c                         |    3=20
 drivers/net/ethernet/sun/ldmvsw.c                            |    2=20
 drivers/net/ethernet/sun/sunbmac.c                           |    3=20
 drivers/net/ethernet/sun/sunqe.c                             |    2=20
 drivers/net/ethernet/sun/sunvnet.c                           |    2=20
 drivers/net/ethernet/sun/sunvnet_common.c                    |   14=20
 drivers/net/ethernet/sun/sunvnet_common.h                    |    7=20
 drivers/net/ethernet/toshiba/ps3_gelic_net.c                 |    4=20
 drivers/net/ethernet/toshiba/ps3_gelic_net.h                 |    2=20
 drivers/net/ethernet/toshiba/spider_net.c                    |    4=20
 drivers/net/ethernet/toshiba/tc35815.c                       |    6=20
 drivers/net/ethernet/xilinx/ll_temac_main.c                  |    3=20
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c            |    3=20
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                |    9=20
 drivers/net/phy/mdio-bcm-unimac.c                            |   83 +++++
 drivers/net/phy/mscc.c                                       |   11=20
 drivers/net/slip/slip.c                                      |    1=20
 drivers/net/usb/ax88172a.c                                   |    2=20
 drivers/net/usb/lan78xx.c                                    |    5=20
 drivers/net/usb/qmi_wwan.c                                   |    2=20
 drivers/net/wireless/ath/ath10k/ahb.c                        |    4=20
 drivers/net/wireless/ath/ath10k/mac.c                        |    2=20
 drivers/net/wireless/ath/ath10k/pci.c                        |    2=20
 drivers/net/wireless/ath/ath10k/wmi.c                        |    3=20
 drivers/net/wireless/ath/ath9k/main.c                        |    1=20
 drivers/net/wireless/ath/ath9k/tx99.c                        |   10=20
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h               |    6=20
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c                  |    9=20
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                 |    4=20
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                  |    8=20
 drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c          |    2=20
 drivers/nvmem/core.c                                         |    2=20
 drivers/of/base.c                                            |    2=20
 drivers/phy/broadcom/Kconfig                                 |    3=20
 drivers/phy/lantiq/phy-lantiq-rcu-usb2.c                     |    1=20
 drivers/phy/renesas/phy-rcar-gen3-usb2.c                     |    2=20
 drivers/phy/ti/phy-twl4030-usb.c                             |   29 ++
 drivers/pinctrl/pinctrl-at91-pio4.c                          |    8=20
 drivers/pinctrl/pinctrl-at91.c                               |   28 -
 drivers/pinctrl/pinctrl-ingenic.c                            |    2=20
 drivers/power/reset/at91-sama5d2_shdwc.c                     |    3=20
 drivers/power/supply/ab8500_fg.c                             |   31 --
 drivers/power/supply/max8998_charger.c                       |    2=20
 drivers/power/supply/twl4030_charger.c                       |   30 +-
 drivers/remoteproc/da8xx_remoteproc.c                        |    2=20
 drivers/rtc/rtc-armada38x.c                                  |   22 -
 drivers/rtc/rtc-mt6397.c                                     |   13=20
 drivers/rtc/rtc-pl030.c                                      |   15 -
 drivers/rtc/rtc-rv8803.c                                     |    2=20
 drivers/s390/net/qeth_l2_main.c                              |    3=20
 drivers/s390/net/qeth_l3_main.c                              |    3=20
 drivers/scsi/NCR5380.c                                       |  156 ++++++=
-----
 drivers/scsi/NCR5380.h                                       |    2=20
 drivers/scsi/libsas/sas_expander.c                           |   13=20
 drivers/scsi/lpfc/lpfc_nvme.c                                |    2=20
 drivers/scsi/lpfc/lpfc_nvmet.c                               |    7=20
 drivers/scsi/pm8001/pm8001_hwi.c                             |    6=20
 drivers/scsi/pm8001/pm8001_sas.c                             |    9=20
 drivers/scsi/pm8001/pm8001_sas.h                             |    1=20
 drivers/scsi/pm8001/pm80xx_hwi.c                             |   80 +++++
 drivers/scsi/pm8001/pm80xx_hwi.h                             |    3=20
 drivers/scsi/qla2xxx/qla_gs.c                                |    4=20
 drivers/scsi/qla2xxx/qla_isr.c                               |    2=20
 drivers/scsi/qla2xxx/qla_os.c                                |   28 +
 drivers/scsi/scsi_lib.c                                      |    3=20
 drivers/scsi/sym53c8xx_2/sym_hipd.c                          |   15 -
 drivers/soc/imx/gpc.c                                        |    2=20
 drivers/soc/qcom/wcnss_ctrl.c                                |    2=20
 drivers/spi/spi-mt65xx.c                                     |   37 +-
 drivers/spi/spi-pic32.c                                      |    4=20
 drivers/tee/optee/core.c                                     |    2=20
 drivers/tty/serial/mxs-auart.c                               |    3=20
 drivers/tty/serial/samsung.c                                 |    8=20
 drivers/tty/serial/xilinx_uartps.c                           |   41 --
 drivers/usb/chipidea/otg.c                                   |    9=20
 drivers/usb/chipidea/usbmisc_imx.c                           |    2=20
 drivers/usb/gadget/function/uvc_configfs.c                   |    7=20
 drivers/usb/gadget/function/uvc_video.c                      |   32 +-
 drivers/usb/host/xhci-mtk-sch.c                              |    4=20
 drivers/vfio/pci/vfio_pci.c                                  |    8=20
 drivers/vfio/pci/vfio_pci_config.c                           |   31 ++
 fs/compat_ioctl.c                                            |   10=20
 fs/ecryptfs/inode.c                                          |   19 -
 fs/f2fs/recovery.c                                           |   17 +
 fs/f2fs/super.c                                              |    6=20
 fs/fuse/control.c                                            |    4=20
 fs/gfs2/rgrp.c                                               |    2=20
 fs/kernfs/symlink.c                                          |    5=20
 include/linux/cpufeature.h                                   |    2=20
 include/linux/edac.h                                         |    3=20
 include/linux/intel-iommu.h                                  |    6=20
 include/linux/libfdt_env.h                                   |    1=20
 include/net/llc.h                                            |    1=20
 include/trace/events/sched.h                                 |   11=20
 kernel/events/uprobes.c                                      |    4=20
 kernel/kprobes.c                                             |    8=20
 kernel/signal.c                                              |    4=20
 mm/hugetlb_cgroup.c                                          |    2=20
 mm/memcontrol.c                                              |    2=20
 mm/shmem.c                                                   |    2=20
 net/bluetooth/l2cap_core.c                                   |   10=20
 net/ipv4/gre_demux.c                                         |    7=20
 net/ipv4/ip_gre.c                                            |    9=20
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c                  |   22 +
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c                  |   19 +
 net/llc/llc_core.c                                           |    4=20
 net/wireless/reg.c                                           |   46 +++
 samples/bpf/sockex2_kern.c                                   |   11=20
 samples/bpf/sockex3_kern.c                                   |    8=20
 samples/bpf/sockex3_user.c                                   |    4=20
 sound/core/oss/pcm_plugin.c                                  |    4=20
 sound/core/seq/seq_system.c                                  |   18 +
 sound/pci/intel8x0m.c                                        |   20 -
 sound/soc/codecs/hdac_hdmi.c                                 |    6=20
 sound/soc/codecs/sgtl5000.c                                  |    2=20
 sound/soc/sh/rcar/rsnd.h                                     |    1=20
 sound/soc/sh/rcar/ssi.c                                      |    4=20
 sound/soc/soc-pcm.c                                          |    2=20
 sound/usb/endpoint.c                                         |    3=20
 sound/usb/mixer.c                                            |    4=20
 273 files changed, 1715 insertions(+), 749 deletions(-)

Aapo Vienamo (1):
      arm64: dts: tegra210-p2180: Correct sdmmc4 vqmmc-supply

Al Viro (2):
      ecryptfs_lookup_interpose(): lower_dentry->d_inode is not stable
      ecryptfs_lookup_interpose(): lower_dentry->d_parent is not stable eit=
her

Alan Modra (1):
      powerpc/vdso: Correct call frame information

Aleksander Morgado (1):
      net: usb: qmi_wwan: add support for Foxconn T77W968 LTE modules

Alex Williamson (1):
      vfio/pci: Mask buggy SR-IOV VF INTx support

Alexandre Belloni (4):
      rtc: rv8803: fix the rv8803 id in the OF table
      rtc: mt6397: fix possible race condition
      rtc: pl030: fix possible race condition
      rtc: armada38x: fix possible race condition

Andre Przywara (2):
      arm64: dts: allwinner: a64: Olinuxino: fix DRAM voltage
      arm64: dts: allwinner: a64: NanoPi-A64: Fix DCDC1 voltage

Andreas Kemnade (3):
      power: supply: twl4030_charger: fix charging current out-of-bounds
      power: supply: twl4030_charger: disable eoc interrupt on linear charge
      phy: phy-twl4030-usb: fix denied runtime access

Andrew Duggan (2):
      Input: synaptics-rmi4 - disable the relative position IRQ in the F12 =
driver
      Input: synaptics-rmi4 - do not consume more data than we have (F11, F=
12)

Andy Shevchenko (1):
      extcon: cht-wc: Return from default case to avoid warnings

Anju T Sudhakar (1):
      powerpc/perf: Fix kfree memory allocated for nest pmus

Anton Blanchard (1):
      powerpc: Fix duplicate const clang warning in user access code

Anton Vasilyev (1):
      serial: mxs-auart: Fix potential infinite loop

Ard Biesheuvel (1):
      tee: optee: take DT status property into account

Arnd Bergmann (2):
      media: dvb: fix compat ioctl translation
      net: phy: mdio-bcm-unimac: mark PM functions as __maybe_unused

Balakrishna Godavarthi (1):
      Bluetooth: hci_serdev: clear HCI_UART_PROTO_READY to avoid closing pr=
oto races

Banajit Goswami (1):
      component: fix loop condition to call unbind() if bind() fails

Baruch Siach (1):
      ARM: dts: clearfog: fix sdhci supply property name

Bernd Edlinger (1):
      kernfs: Fix range checks in kernfs_get_target_path

Bjorn Andersson (1):
      remoteproc/davinci: Use %zx for formating size_t

Bob Peterson (1):
      gfs2: Don't set GFS2_RDF_UPTODATE when the lvb is updated

Borislav Petkov (1):
      x86/mce-inject: Reset injection struct after injection

Brad Love (1):
      media: au0828: Fix incorrect error messages

Brendan Higgins (1):
      i2c: aspeed: fix invalid clock parameters for very large divisors

Breno Leitao (1):
      powerpc/iommu: Avoid derefence before pointer check

Chao Yu (4):
      f2fs: fix memory leak of percpu counter in fill_super()
      f2fs: fix to recover inode's uid/gid during POR
      f2fs: fix to recover inode's project id during POR
      f2fs: mark inode dirty explicitly in recover_inode()

Charles Keepax (1):
      ASoC: dpcm: Properly initialise hw->rate_max

Christian Lamparter (1):
      ARM: dts: qcom: ipq4019: fix cpu0's qcom,saw2 reg value

Christoph Manszewski (1):
      crypto: s5p-sss: Fix Fix argument list alignment

Chuhong Yuan (1):
      Input: synaptics-rmi4 - destroy F54 poller workqueue when removing

Chunfeng Yun (1):
      usb: xhci-mtk: fix ISOC error when interval is zero

Claudiu Beznea (1):
      power: reset: at91-poweroff: do not procede if at91_shdwc is allocated

Colin Ian King (1):
      ASoC: sgtl5000: avoid division by zero if lo_vag is zero

Cong Wang (1):
      llc: avoid blocking in llc_sap_close()

Corey Minyard (1):
      ipmi:dmi: Ignore IPMI SMBIOS entries with a zero base address

Dan Aloni (1):
      crypto: fix a memory leak in rsa-kcs1pad's encryption mode

Dan Carpenter (4):
      ALSA: pcm: signedness bug in snd_pcm_plug_alloc()
      pinctrl: at91-pio4: fix has_config check in atmel_pctl_dt_subnode_to_=
map()
      power: supply: ab8500_fg: silence uninitialized variable warnings
      ath9k: Fix a locking bug in ath9k_add_interface()

Daniel Silsby (1):
      dmaengine: dma-jz4780: Further residue status fix

Deepak Ukey (2):
      scsi: pm80xx: Corrected dma_unmap_sg() parameter
      scsi: pm80xx: Fixed system hang issue during kexec boot

Dengcheng Zhu (1):
      MIPS: kexec: Relax memory restriction

Dexuan Cui (1):
      x86/hyperv: Suppress "PCI: Fatal: No config space access function fou=
nd"

Ding Xiang (1):
      mips: txx9: fix iounmap related issue

Dinh Nguyen (1):
      ARM: dts: socfpga: Fix I2C bus unit-address error

Emmanuel Grumbach (1):
      iwlwifi: dbg: don't crash if the firmware crashes in the middle of a =
debug dump

Eric Auger (1):
      iommu/vt-d: Fix QI_DEV_IOTLB_PFSID and QI_DEV_EIOTLB_PFSID macros

Eric W. Biederman (3):
      signal: Always ignore SIGKILL and SIGSTOP sent to the global init
      signal: Properly deliver SIGILL from uprobes
      signal: Properly deliver SIGSEGV from x86 uprobes

Erik Stromdahl (1):
      ath10k: wmi: disable softirq's while calling ieee80211_rx

Eugen Hristev (1):
      mmc: sdhci-of-at91: fix quirk2 overwrite

Evan Green (1):
      Revert "Input: synaptics-rmi4 - avoid processing unknown IRQs"

Felix Fietkau (2):
      ath9k: fix tx99 with monitor mode interface
      ath9k: add back support for using active monitor interfaces for tx99

Finn Thain (8):
      scsi: NCR5380: Have NCR5380_select() return a bool
      scsi: NCR5380: Withhold disconnect privilege for REQUEST SENSE
      scsi: NCR5380: Use DRIVER_SENSE to indicate valid sense data
      scsi: NCR5380: Check for invalid reselection target
      scsi: NCR5380: Don't clear busy flag when abort fails
      scsi: NCR5380: Don't call dsprintk() following reselection interrupt
      scsi: NCR5380: Handle BUS FREE during reselection
      scsi: NCR5380: Check for bus reset

Florian Fainelli (2):
      net: phy: mdio-bcm-unimac: Allow configuring MDIO clock divider
      phy: brcm-sata: allow PHY_BRCM_SATA driver to be built for DSL SoCs

Fuyun Liang (1):
      net: hns3: Fix for setting speed for phy failed problem

Ganesh Goudar (1):
      cxgb4: Fix endianness issue in t4_fwcache()

Geert Uytterhoeven (2):
      media: dt-bindings: adv748x: Fix decimal unit addresses
      ARM: dts: ux500: Correct SCU unit address

George Kennedy (1):
      scsi: sym53c8xx: fix NULL pointer dereference panic in sym_int_sir()

Greg Kroah-Hartman (1):
      Linux 4.14.155

Grygorii Strashko (1):
      ARM: dts: am335x-evm: fix number of cpsw

H. Nikolaus Schaller (6):
      ARM: dts: omap3-gta04: give spi_lcd node a label so that we can overw=
rite in other DTS files
      ARM: dts: omap3-gta04: fixes for tvout / venc
      ARM: dts: omap3-gta04: tvout: enable as display1 alias
      ARM: dts: omap3-gta04: fix touchscreen tsc2007
      ARM: dts: omap3-gta04: make NAND partitions compatible with recent U-=
Boot
      ARM: dts: omap3-gta04: keep vpll2 always on

Haishuang Yan (1):
      ip_gre: fix parsing gre header in ipgre_err

Hannes Reinecke (1):
      scsi: NCR5380: Clear all unissued commands on host reset

Hans de Goede (2):
      i2c: acpi: Force bus speed to 400KHz if a Silead touchscreen is prese=
nt
      ACPI / LPSS: Exclude I2C busses shared with PUNIT from pmc_atom_d3_ma=
sk

Hauke Mehrtens (1):
      phy: lantiq: Fix compile warning

Heiko Stuebner (1):
      ARM: dts: rockchip: explicitly set vcc_sd0 pin to gpio on rk3188-radx=
arock

Henry Lin (1):
      ALSA: usb-audio: not submit urb for stopped endpoint

H=C3=A5kon Bugge (1):
      RDMA/i40iw: Fix incorrect iterator type

Ilan Peer (1):
      iwlwifi: mvm: Allow TKIP for AP mode

Israel Rukshin (1):
      IB/iser: Fix possible NULL deref at iser_inv_desc()

Jakub Kicinski (1):
      nfp: provide a better warning when ring allocation fails

James Erwin (1):
      IB/hfi1: Ensure full Gen3 speed in a Gen4 system

James Smart (1):
      scsi: lpfc: Fix errors in log messages.

Jason Yan (1):
      scsi: libsas: always unregister the old device if going to discover n=
ew

Jay Foster (1):
      ARM: dts: at91/trivial: Fix USART1 definition for at91sam9g45

Jerome Brunet (1):
      arm64: dts: meson: libretech: update board model

Jia-Ju Bai (1):
      media: pci: ivtv: Fix a sleep-in-atomic-context bug in ivtv_yuv_init()

Jiada Wang (1):
      ASoC: rsnd: ssi: Fix issue in dma data address assignment

Jian Shen (1):
      net: hns3: Fix parameter type for q_id in hclge_tm_q_to_qs_map_cfg()

Joel Pepper (1):
      usb: gadget: uvc: configfs: Prevent format changes after linking head=
er

Johannes Berg (2):
      iwlwifi: don't WARN on trying to dump dead firmware
      iwlwifi: api: annotate compressed BA notif array sizes

Jonas Gorski (1):
      MIPS: BCM63XX: fix switch core reset on BCM6368

Jouni Hogander (2):
      slip: Fix memory leak in slip_open error path
      slcan: Fix memory leak in error path

Julian Wiedmann (1):
      s390/qeth: invoke softirqs after napi_schedule()

Junaid Shahid (1):
      kvm: mmu: Don't read PDPTEs when paging is not enabled

Justin Ernst (1):
      EDAC: Raise the maximum number of memory controllers

Kirill Tkhai (1):
      fuse: use READ_ONCE on congestion_threshold and max_background

Lao Wei (1):
      media: fix: media: pci: meye: validate offset to avoid arbitrary acce=
ss

Larry Finger (1):
      rtl8187: Fix warning generated when strncpy() destination length matc=
hes the sixe argument

Laura Abbott (1):
      misc: kgdbts: Fix restrict error

Laurent Pinchart (3):
      usb: gadget: uvc: configfs: Drop leaked references to config items
      usb: gadget: uvc: Factor out video USB request queueing
      usb: gadget: uvc: Only halt video streaming endpoint in bulk mode

Leo Yan (1):
      coresight: tmc: Fix byte-address alignment for RRP

Li Qiang (1):
      vfio/pci: Fix potential memory leak in vfio_msi_cap_len

Linus Walleij (1):
      ARM: dts: ux500: Fix LCDA clock line muxing

Loic Poulain (1):
      usb: chipidea: Fix otg event handler

Lucas Stach (2):
      Input: synaptics-rmi4 - fix video buffer size
      Input: synaptics-rmi4 - clear IRQ enables for F54

Ludovic Desroches (1):
      pinctrl: at91: don't use the same irqchip with multiple gpiochips

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Detect if remote is not able to use the whole MPS

Madhavan Srinivasan (1):
      powerpc/perf: Fix IMC_MAX_PMU macro

Marc Dietrich (1):
      ARM: dts: paz00: fix wakeup gpio keycode

Marcel Ziswiler (3):
      ARM: dts: pxa: fix power i2c base address
      ARM: dts: tegra30: fix xcvr-setup-use-fuses
      ARM: tegra: apalis_t30: fix mmc1 cmd pull-up

Marcus Folkesson (1):
      iio: dac: mcp4922: fix error handling in mcp4922_write_raw

Marek Szyprowski (4):
      ARM: dts: exynos: Fix sound in Snow-rev5 Chromebook
      ARM: dts: exynos: Fix regulators configuration on Peach Pi/Pit Chrome=
books
      ARM: dts: exynos: Disable pull control for S5M8767 PMIC
      serial: samsung: Enable baud clock for UART reset procedure in resume

Martin Blumenstingl (2):
      ARM: dts: meson8: fix the clock controller register size
      ARM: dts: meson8b: fix the clock controller register size

Masami Hiramatsu (1):
      kprobes: Don't call BUG_ON() if there is a kprobe in use on free list

Matthew Whitehead (2):
      x86/CPU: Use correct macros for Cyrix calls
      x86/CPU: Change query logic so CPUID is enabled before testing

Michael J. Ruhl (1):
      IB/hfi1: Missing return value in error path for user sdma

Michael Kelley (1):
      Drivers: hv: vmbus: Fix synic per-cpu context initialization

Michael Schmitz (1):
      scsi: core: Handle drivers which set sg_tablesize to zero

Mitch Williams (1):
      i40e: use correct length for strncpy

Muhammad Sammar (1):
      IB/ipoib: Ensure that MTU isn't less than minimum permitted

Nathan Chancellor (2):
      spi: pic32: Use proper enum in dmaengine_prep_slave_rg
      media: davinci: Fix implicit enum conversion warning

Nathan Fontenot (1):
      powerpc/pseries: Disable CPU hotplug across migrations

Nava kishore Manne (1):
      serial: uartps: Fix suspend functionality

Nicholas Piggin (1):
      powerpc/64s/hash: Fix stab_rr off by one initialization

Nicolas Adell (1):
      usb: chipidea: imx: enable OTG overcurrent in case USB subsystem is a=
lready started

Niklas Cassel (1):
      soc: qcom: wcnss_ctrl: Avoid string overflow

Oleksij Rempel (1):
      ARM: imx6: register pm_power_off handler if "fsl,pmic-stby-poweroff" =
is set

Oliver Neukum (2):
      ax88172a: fix information leak on short answers
      Input: ff-memless - kill timer in destroy()

Paolo Bonzini (1):
      KVM: x86: introduce is_pae_paging

Paolo Valente (1):
      blok, bfq: do not plug I/O if all queues are weight-raised

Parav Pandit (2):
      RDMA/core: Rate limit MAD error messages
      RDMA/core: Follow correct unregister order between sysfs and cgroup

Patryk Ma=C5=82ek (2):
      i40e: hold the rtnl lock on clearing interrupt scheme
      i40e: Prevent deleting MAC address from VF when set by PF

Paul Cercueil (2):
      pinctrl: ingenic: Probe driver at subsys_initcall
      dmaengine: dma-jz4780: Don't depend on MACH_JZ4780

Peter Shih (1):
      spi: mediatek: Don't modify spi_transfer when transfer.

Petr Machata (1):
      mlxsw: spectrum: Init shaper for TCs 8..15

Prashant Bhole (1):
      samples/bpf: fix compilation failure

Qiuxu Zhuo (1):
      EDAC, sb_edac: Return early on ADDRV bit and address type test

Quentin Schulz (2):
      net: phy: mscc: read 'vsc8531,vddmac' as an u32
      net: phy: mscc: read 'vsc8531, edge-slowdown' as an u32

Quinn Tran (3):
      scsi: qla2xxx: Fix iIDMA error
      scsi: qla2xxx: Defer chip reset until target mode is enabled
      scsi: qla2xxx: Fix dropped srb resource.

Rajeev Kumar Sirasanagandla (1):
      cfg80211: Avoid regulatory restore when COUNTRY_IE_IGNORE is set

Rick Farrington (1):
      liquidio: fix race condition in instruction completion processing

Rob Herring (10):
      of: make PowerMac cache node search conditional on CONFIG_PPC_PMAC
      arm64: dts: meson: Fix erroneous SPI bus warnings
      ARM: dts: rockchip: Fix erroneous SPI bus dtc warnings on rk3036
      libfdt: Ensure INT_MAX is defined in libfdt_env.h
      ARM: dts: ste: Fix SPI controller node names
      ARM: dts: marvell: Fix SPI and I2C bus warnings
      ARM: dts: realview: Fix SPI controller node names
      arm64: dts: amd: Fix SPI bus warnings
      arm64: dts: lg: Fix SPI controller node names
      ARM: dts: lpc32xx: Fix SPI controller node names

Robert Jarzmik (1):
      ARM: dts: pxa: fix the rtc controller

Roman Gushchin (2):
      mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()
      mm: hugetlb: switch to css_tryget() in hugetlb_cgroup_charge_cgroup()

Sara Sharon (1):
      iwlwifi: mvm: avoid sending too many BARs

Shahed Shaikh (1):
      bnx2x: Ignore bandwidth attention in single function mode

Sinan Kaya (1):
      PCI/ACPI: Correct error message for ASPM disabling

Srinivas Kandagatla (1):
      nvmem: core: return error code instead of NULL from nvmem_device_get

Stefan Agner (3):
      iio: adc: max9611: explicitly cast gain_selectors
      cpufeature: avoid warning when compiling with clang
      crypto: arm/crc32 - avoid warning when compiling with Clang

Stefan Wahren (1):
      net: lan78xx: Bail out if lan78xx_get_endpoints fails

Stuart Hayes (1):
      firmware: dell_rbu: Make payload memory uncachable

Suzuki K Poulose (3):
      coresight: Fix handling of sinks
      coresight: perf: Fix per cpu path management
      coresight: perf: Disable trace path upon source error

Sven Eckelmann (1):
      ath10k: limit available channels via DT ieee80211-freq-limit

Sven Schmitt (1):
      soc: imx: gpc: fix PDN delay

Takashi Iwai (3):
      ALSA: usb-audio: Fix missing error check at mixer resolution test
      ALSA: seq: Do error checks at creating system ports
      ALSA: intel8x0m: Register irq handler after register initializations

Tamizh chelvam (1):
      ath10k: fix kernel panic by moving pci flush after napi_disable

Tan Hu (1):
      netfilter: masquerade: don't flush all conntracks if only one address=
 deleted on device

Tomasz Figa (1):
      power: supply: max8998-charger: Fix platform data retrieval

Tomasz Nowicki (1):
      coresight: etm4x: Configure EL2 exception level when kernel is runnin=
g in HYP

Tuomas Tynkkynen (1):
      MIPS: BCM47XX: Enable USB power on Netgear WNDR3400v3

Uwe Kleine-K=C3=B6nig (1):
      sched/debug: Use symbolic names for task state constants

Vicente Bergas (2):
      arm64: dts: rockchip: Fix VCC5V0_HOST_EN on rk3399-sapphire
      arm64: dts: rockchip: Fix microSD in rk3399 sapphire board

Vijay Immanuel (1):
      IB/rxe: fixes for rdma read retry

Viresh Kumar (1):
      OPP: Protect dev_list with opp_table lock

Yong Zhi (1):
      ASoC: Intel: hdac_hdmi: Limit sampling rates at dai creation

Yonghong Song (1):
      samples/bpf: fix a compilation failure

Yoshihiro Shimoda (1):
      phy: renesas: rcar-gen3-usb2: fix vbus_ctrl for role sysfs

YueHaibing (10):
      net: hns3: fix return type of ndo_start_xmit function
      net: toshiba: fix return type of ndo_start_xmit function
      net: xilinx: fix return type of ndo_start_xmit function
      net: broadcom: fix return type of ndo_start_xmit function
      net: amd: fix return type of ndo_start_xmit function
      net: sun: fix return type of ndo_start_xmit function
      net: micrel: fix return type of ndo_start_xmit function
      net: freescale: fix return type of ndo_start_xmit function
      net: smsc: fix return type of ndo_start_xmit function
      net: faraday: fix return type of ndo_start_xmit function

zhong jiang (2):
      misc: genwqe: should return proper error value.
      memfd: Use radix_tree_deref_slot_protected to avoid the warning.


--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3Wk+sACgkQONu9yGCS
aT4TRRAAmIApkPyW/zg/Q3xnKXVVwF0FXtuYhungUZTFzxrwjLLCG6V+EtbvN761
OPUetgaeEd3ONDNFqkeabn084Rb1t508RKlaJr9ZIfa6dVUQVC/ZQJhBhEmB5+13
NCBNbH7pXgPBzMSIPYSTOsXFnLZP8csx8tD59gDiZgykM5CBmeNKy5hL4/TBhlof
5sgqSIJLCp3xHl/7syMgRjaB/qV8PCkygFNVndgxg2A7mgUkAV30yyediI2wPp8L
RGKivUWj8diMri8V1Ph/po/XfvTf2V/K8uqj3YbyQuo9wpR7J7aX22w0GBEr3q1k
zF3SLXNEWTp3+Uj3DhkOKSHynNJl90XEmd2b6dlnEa25HxtOaIJP3/TCeBTFcFFR
oYsOOF284vp353El3u8XHFR0mdqwO/iUQHiMT3jKsETt/KUcPyj5JsMBMtXAZnp7
zgHuHqei6TdYwlkzmhudIKJWda4MLFalC6xSaFdk63V4+H/nF/vPwS/WH1ROyAar
ZpQ+bId6uDy4cfbPF1JEE8fqeVtstzF+0rlkANE1s2ntIW9WfwLuj5+ZIG5AxfCd
BliLq/Aq7ehy26kHuzbEwx1D+xqshzWgT1T7eHnPduTkzNXG4h9Ow+IcQH9iHqgx
kl4tvyWmUDCrqkAXYyd9ENnove6/svwegV4chkU41OSnL6WjHB0=
=behU
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
