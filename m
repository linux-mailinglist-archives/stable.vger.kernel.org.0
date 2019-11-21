Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8E5310535B
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 14:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfKUNlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 08:41:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:55792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfKUNlf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 08:41:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFA952071B;
        Thu, 21 Nov 2019 13:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574343693;
        bh=iKEDwxTulviZPpl6HP8f72QlqiwwCFLj7FnMDGDIfGQ=;
        h=Date:From:To:Cc:Subject:From;
        b=rI1LXxeGMm0lwNI3QzsFTAXkIo4VYW/CU/wfNyvH8zRl28pv0MeLcjayrq0qjYhCS
         Iw9WKtDtIJ/P4smzmKzdt4MfU2RYy9c7suWkoFXeI5IvVsIWFLo4nxeDMTdMqfgaGg
         IXB3SVHaPe1eo2EHkPQS0ylBJ6N40nnsUuXF9xNg=
Date:   Thu, 21 Nov 2019 14:41:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.85
Message-ID: <20191121134130.GA548314@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.85 kernel.

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

 Documentation/devicetree/bindings/media/i2c/adv748x.txt             |    4=
=20
 Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt          |    3=
=20
 Makefile                                                            |    2=
=20
 arch/arm/boot/compressed/libfdt_env.h                               |    2=
=20
 arch/arm/boot/dts/am335x-boneblack-common.dtsi                      |    2=
=20
 arch/arm/boot/dts/am335x-evm.dts                                    |   12=
=20
 arch/arm/boot/dts/am335x-osd3358-sm-red.dts                         |    2=
=20
 arch/arm/boot/dts/am335x-pdu001.dts                                 |    2=
=20
 arch/arm/boot/dts/am4372.dtsi                                       |    2=
=20
 arch/arm/boot/dts/am57xx-cl-som-am57x.dts                           |    2=
=20
 arch/arm/boot/dts/arm-realview-eb.dtsi                              |    2=
=20
 arch/arm/boot/dts/arm-realview-pb1176.dts                           |    2=
=20
 arch/arm/boot/dts/arm-realview-pb11mp.dts                           |    2=
=20
 arch/arm/boot/dts/arm-realview-pbx.dtsi                             |    2=
=20
 arch/arm/boot/dts/armada-388-clearfog.dtsi                          |    2=
=20
 arch/arm/boot/dts/aspeed-g4.dtsi                                    |    2=
=20
 arch/arm/boot/dts/aspeed-g5.dtsi                                    |    2=
=20
 arch/arm/boot/dts/at91-dvk_su60_somc.dtsi                           |    4=
=20
 arch/arm/boot/dts/at91-dvk_su60_somc_lcm.dtsi                       |    4=
=20
 arch/arm/boot/dts/at91-vinco.dts                                    |    2=
=20
 arch/arm/boot/dts/at91sam9260ek.dts                                 |    2=
=20
 arch/arm/boot/dts/at91sam9261ek.dts                                 |    2=
=20
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi                         |    2=
=20
 arch/arm/boot/dts/at91sam9g45.dtsi                                  |    2=
=20
 arch/arm/boot/dts/bcm-hr2.dtsi                                      |    2=
=20
 arch/arm/boot/dts/bcm-nsp.dtsi                                      |    2=
=20
 arch/arm/boot/dts/dove-cubox.dts                                    |    2=
=20
 arch/arm/boot/dts/dove.dtsi                                         |    6=
=20
 arch/arm/boot/dts/dra7.dtsi                                         |    2=
=20
 arch/arm/boot/dts/exynos3250-artik5.dtsi                            |    7=
=20
 arch/arm/boot/dts/exynos5250-arndale.dts                            |   41=
 ++
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi                           |   11=
=20
 arch/arm/boot/dts/exynos5250-snow-rev5.dts                          |   11=
=20
 arch/arm/boot/dts/exynos5420-peach-pit.dts                          |    5=
=20
 arch/arm/boot/dts/exynos5800-peach-pi.dts                           |    5=
=20
 arch/arm/boot/dts/imx51-zii-rdu1.dts                                |    2=
=20
 arch/arm/boot/dts/imx6ull.dtsi                                      |    2=
=20
 arch/arm/boot/dts/keystone-k2g.dtsi                                 |    2=
=20
 arch/arm/boot/dts/lpc32xx.dtsi                                      |    4=
=20
 arch/arm/boot/dts/meson8.dtsi                                       |    2=
=20
 arch/arm/boot/dts/meson8b.dtsi                                      |    2=
=20
 arch/arm/boot/dts/omap2.dtsi                                        |    4=
=20
 arch/arm/boot/dts/omap2430.dtsi                                     |    2=
=20
 arch/arm/boot/dts/omap3-gta04.dtsi                                  |   49=
 ++-
 arch/arm/boot/dts/omap3-n9.dts                                      |    2=
=20
 arch/arm/boot/dts/orion5x-linkstation.dtsi                          |    2=
=20
 arch/arm/boot/dts/pxa25x.dtsi                                       |    4=
=20
 arch/arm/boot/dts/pxa27x.dtsi                                       |    6=
=20
 arch/arm/boot/dts/qcom-ipq4019.dtsi                                 |    2=
=20
 arch/arm/boot/dts/r8a7779.dtsi                                      |    2=
=20
 arch/arm/boot/dts/r8a7790.dtsi                                      |    4=
=20
 arch/arm/boot/dts/r8a7791.dtsi                                      |    4=
=20
 arch/arm/boot/dts/rk3036.dtsi                                       |    2=
=20
 arch/arm/boot/dts/rk3188-radxarock.dts                              |    8=
=20
 arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts                   |    2=
=20
 arch/arm/boot/dts/ste-dbx5x0.dtsi                                   |    6=
=20
 arch/arm/boot/dts/ste-href-family-pinctrl.dtsi                      |    8=
=20
 arch/arm/boot/dts/ste-hrefprev60.dtsi                               |    2=
=20
 arch/arm/boot/dts/ste-snowball.dts                                  |    2=
=20
 arch/arm/boot/dts/ste-u300.dts                                      |    2=
=20
 arch/arm/boot/dts/stm32mp157c-ev1.dts                               |   73=
 ++++
 arch/arm/boot/dts/stm32mp157c.dtsi                                  |    2=
=20
 arch/arm/boot/dts/sun5i-reference-design-tablet.dtsi                |    3=
=20
 arch/arm/boot/dts/sun8i-reference-design-tablet.dtsi                |    3=
=20
 arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts                   |    2=
=20
 arch/arm/boot/dts/sun9i-a80.dtsi                                    |    2=
=20
 arch/arm/boot/dts/tegra20-paz00.dts                                 |    6=
=20
 arch/arm/boot/dts/tegra20.dtsi                                      |   26=
 -
 arch/arm/boot/dts/tegra30-apalis.dtsi                               |   10=
=20
 arch/arm/boot/dts/tegra30-colibri-eval-v3.dts                       |    3=
=20
 arch/arm/boot/dts/tegra30.dtsi                                      |    6=
=20
 arch/arm/boot/dts/versatile-ab.dts                                  |    2=
=20
 arch/arm/boot/dts/zynq-zc702.dts                                    |   12=
=20
 arch/arm/boot/dts/zynq-zc770-xm010.dts                              |    2=
=20
 arch/arm/boot/dts/zynq-zc770-xm013.dts                              |    2=
=20
 arch/arm/crypto/crc32-ce-glue.c                                     |    2=
=20
 arch/arm/mach-at91/pm.c                                             |    6=
=20
 arch/arm/mach-imx/pm-imx6.c                                         |   25=
 +
 arch/arm64/boot/dts/allwinner/sun50i-a64-nanopi-a64.dts             |    6=
=20
 arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts              |    8=
=20
 arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts           |    4=
=20
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts              |    2=
=20
 arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi                        |    4=
=20
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi                          |    2=
=20
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi                         |    2=
=20
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts        |    2=
=20
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi                          |    2=
=20
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi                    |    4=
=20
 arch/arm64/boot/dts/broadcom/stingray/bcm958742-base.dtsi           |    2=
=20
 arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi                 |    4=
=20
 arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi                      |    2=
=20
 arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi                      |    6=
=20
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts                   |    4=
=20
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi                      |    4=
=20
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi                      |    4=
=20
 arch/arm64/boot/dts/lg/lg1312.dtsi                                  |    4=
=20
 arch/arm64/boot/dts/lg/lg1313.dtsi                                  |    4=
=20
 arch/arm64/boot/dts/nvidia/tegra194.dtsi                            |   16=
 -
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi                      |    1=
=20
 arch/arm64/boot/dts/renesas/r8a77965.dtsi                           |   30=
 +
 arch/arm64/boot/dts/renesas/salvator-common.dtsi                    |    5=
=20
 arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts                 |    2=
=20
 arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi                   |   26=
 +
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi                            |   10=
=20
 arch/arm64/boot/dts/ti/k3-am65.dtsi                                 |   44=
 +-
 arch/arm64/kernel/traps.c                                           |    1=
=20
 arch/mips/bcm47xx/workarounds.c                                     |    8=
=20
 arch/mips/bcm63xx/reset.c                                           |    2=
=20
 arch/mips/include/asm/kexec.h                                       |    6=
=20
 arch/mips/txx9/generic/setup.c                                      |    5=
=20
 arch/powerpc/boot/libfdt_env.h                                      |    2=
=20
 arch/powerpc/include/asm/drmem.h                                    |    5=
=20
 arch/powerpc/include/asm/uaccess.h                                  |    6=
=20
 arch/powerpc/kernel/iommu.c                                         |    2=
=20
 arch/powerpc/kernel/rtas.c                                          |    2=
=20
 arch/powerpc/kernel/vdso32/datapage.S                               |    1=
=20
 arch/powerpc/kernel/vdso32/gettimeofday.S                           |    1=
=20
 arch/powerpc/kernel/vdso64/datapage.S                               |    1=
=20
 arch/powerpc/kernel/vdso64/gettimeofday.S                           |    1=
=20
 arch/powerpc/mm/slb.c                                               |    2=
=20
 arch/powerpc/platforms/pseries/hotplug-memory.c                     |   55=
 +--
 arch/s390/include/asm/mmu.h                                         |    2=
=20
 arch/s390/include/asm/mmu_context.h                                 |    1=
=20
 arch/s390/kernel/vdso.c                                             |    7=
=20
 arch/s390/kernel/vdso32/clock_gettime.S                             |   19=
 -
 arch/s390/kernel/vdso32/gettimeofday.S                              |    3=
=20
 arch/s390/kernel/vdso64/clock_gettime.S                             |   25=
 -
 arch/s390/kernel/vdso64/gettimeofday.S                              |    3=
=20
 arch/x86/hyperv/hv_init.c                                           |   19=
 +
 arch/x86/kernel/cpu/common.c                                        |    4=
=20
 arch/x86/kernel/cpu/cyrix.c                                         |    2=
=20
 arch/x86/kernel/cpu/mcheck/mce-inject.c                             |    6=
=20
 arch/x86/kernel/uprobes.c                                           |    2=
=20
 arch/x86/kvm/vmx.c                                                  |    7=
=20
 arch/x86/kvm/x86.c                                                  |    8=
=20
 arch/x86/kvm/x86.h                                                  |    5=
=20
 block/bfq-iosched.c                                                 |   78=
 ++++-
 block/bfq-iosched.h                                                 |   26=
 +
 crypto/chacha20_generic.c                                           |    7=
=20
 crypto/rsa-pkcs1pad.c                                               |    9=
=20
 drivers/acpi/acpi_lpss.c                                            |   22=
 +
 drivers/acpi/pci_root.c                                             |    5=
=20
 drivers/android/binder.c                                            |   44=
 ++
 drivers/ata/ahci_platform.c                                         |   15=
=20
 drivers/base/component.c                                            |    6=
=20
 drivers/bluetooth/btrsi.c                                           |   13=
=20
 drivers/bluetooth/hci_serdev.c                                      |    1=
=20
 drivers/char/ipmi/ipmi_dmi.c                                        |    4=
=20
 drivers/char/ipmi/ipmi_msghandler.c                                 |    2=
=20
 drivers/char/ipmi/ipmi_si_mem_io.c                                  |    2=
=20
 drivers/char/ipmi/ipmi_si_pci.c                                     |    4=
=20
 drivers/char/random.c                                               |   24=
 -
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c                                |    2=
=20
 drivers/crypto/s5p-sss.c                                            |   16=
 -
 drivers/dma/Kconfig                                                 |    2=
=20
 drivers/dma/at_xdmac.c                                              |    2=
=20
 drivers/dma/dma-jz4780.c                                            |    2=
=20
 drivers/edac/i3200_edac.c                                           |    2=
=20
 drivers/edac/i7core_edac.c                                          |    2=
=20
 drivers/edac/sb_edac.c                                              |   70=
 ++--
 drivers/edac/skx_edac.c                                             |    4=
=20
 drivers/extcon/extcon-intel-cht-wc.c                                |    2=
=20
 drivers/firmware/arm_scmi/base.c                                    |    2=
=20
 drivers/firmware/arm_scmi/clock.c                                   |    2=
=20
 drivers/firmware/arm_scmi/perf.c                                    |    2=
=20
 drivers/firmware/arm_scmi/power.c                                   |    2=
=20
 drivers/firmware/arm_scmi/sensors.c                                 |    2=
=20
 drivers/firmware/dell_rbu.c                                         |    8=
=20
 drivers/gpio/gpiolib.c                                              |   36=
 +-
 drivers/gpu/drm/qxl/qxl_drv.c                                       |   26=
 -
 drivers/hv/channel.c                                                |   20=
 -
 drivers/hv/hv.c                                                     |   15=
=20
 drivers/hwtracing/coresight/coresight-dynamic-replicator.c          |   64=
 +++-
 drivers/hwtracing/coresight/coresight-etm-perf.c                    |   59=
 ++-
 drivers/hwtracing/coresight/coresight-etm4x.c                       |   40=
 +-
 drivers/hwtracing/coresight/coresight-tmc-etf.c                     |    4=
=20
 drivers/hwtracing/coresight/coresight-tmc-etr.c                     |   60=
 ++-
 drivers/hwtracing/coresight/coresight-tmc.h                         |    2=
=20
 drivers/hwtracing/coresight/coresight.c                             |   22=
 -
 drivers/i2c/busses/i2c-aspeed.c                                     |   65=
 ++--
 drivers/i2c/busses/i2c-mt65xx.c                                     |   62=
 +++
 drivers/i2c/i2c-core-acpi.c                                         |   28=
 +
 drivers/iio/adc/max9611.c                                           |    2=
=20
 drivers/iio/dac/mcp4922.c                                           |   11=
=20
 drivers/infiniband/core/device.c                                    |    2=
=20
 drivers/infiniband/core/mad.c                                       |   72=
 ++--
 drivers/infiniband/hw/cxgb4/cq.c                                    |    2=
=20
 drivers/infiniband/hw/cxgb4/qp.c                                    |    7=
=20
 drivers/infiniband/hw/hfi1/pcie.c                                   |    4=
=20
 drivers/infiniband/hw/hfi1/sdma.c                                   |    5=
=20
 drivers/infiniband/hw/hfi1/user_sdma.c                              |    4=
=20
 drivers/infiniband/hw/hfi1/verbs.c                                  |   10=
=20
 drivers/infiniband/hw/hns/Kconfig                                   |    1=
=20
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                          |    1=
=20
 drivers/infiniband/hw/i40iw/i40iw_cm.c                              |    2=
=20
 drivers/infiniband/hw/mlx4/Kconfig                                  |    1=
=20
 drivers/infiniband/hw/mlx5/main.c                                   |    8=
=20
 drivers/infiniband/hw/mlx5/mlx5_ib.h                                |    4=
=20
 drivers/infiniband/hw/mlx5/qp.c                                     |   63=
 ++--
 drivers/infiniband/sw/rxe/rxe_comp.c                                |   39=
 ++
 drivers/infiniband/sw/rxe/rxe_req.c                                 |   15=
=20
 drivers/infiniband/sw/rxe/rxe_verbs.h                               |    1=
=20
 drivers/infiniband/ulp/ipoib/ipoib_main.c                           |    3=
=20
 drivers/infiniband/ulp/iser/iser_initiator.c                        |   18=
 -
 drivers/input/ff-memless.c                                          |    9=
=20
 drivers/input/rmi4/rmi_f11.c                                        |    4=
=20
 drivers/input/rmi4/rmi_f12.c                                        |   32=
 +-
 drivers/input/rmi4/rmi_f54.c                                        |    5=
=20
 drivers/media/i2c/ov13858.c                                         |    2=
=20
 drivers/media/i2c/ov2680.c                                          |   26=
 -
 drivers/media/i2c/ov2685.c                                          |    2=
=20
 drivers/media/i2c/ov5670.c                                          |    2=
=20
 drivers/media/i2c/ov5695.c                                          |    2=
=20
 drivers/media/i2c/ov772x.c                                          |    1=
=20
 drivers/media/i2c/ov7740.c                                          |    2=
=20
 drivers/media/pci/ivtv/ivtv-yuv.c                                   |    2=
=20
 drivers/media/pci/meye/meye.c                                       |    2=
=20
 drivers/media/platform/davinci/vpbe_display.c                       |    2=
=20
 drivers/media/platform/vicodec/vicodec-codec.c                      |   10=
=20
 drivers/media/platform/vsp1/vsp1_drm.c                              |   11=
=20
 drivers/media/platform/vsp1/vsp1_regs.h                             |    2=
=20
 drivers/media/usb/au0828/au0828-core.c                              |    4=
=20
 drivers/misc/genwqe/card_utils.c                                    |   13=
=20
 drivers/misc/kgdbts.c                                               |   16=
 -
 drivers/mmc/host/sdhci-of-at91.c                                    |    2=
=20
 drivers/mtd/nand/raw/fsl_ifc_nand.c                                 |   36=
 ++
 drivers/mtd/nand/raw/marvell_nand.c                                 |   23=
 -
 drivers/mtd/nand/raw/qcom_nandc.c                                   |    1=
=20
 drivers/net/can/slcan.c                                             |    1=
=20
 drivers/net/ethernet/amd/am79c961a.c                                |    2=
=20
 drivers/net/ethernet/amd/atarilance.c                               |    6=
=20
 drivers/net/ethernet/amd/declance.c                                 |    2=
=20
 drivers/net/ethernet/amd/sun3lance.c                                |    6=
=20
 drivers/net/ethernet/amd/sunlance.c                                 |    2=
=20
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                            |    4=
=20
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c          |    8=
=20
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h          |    3=
=20
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h |   13=
=20
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c        |   36=
 +-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h        |    5=
=20
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c   |    5=
=20
 drivers/net/ethernet/broadcom/bcm63xx_enet.c                        |    5=
=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c                    |   10=
=20
 drivers/net/ethernet/broadcom/genet/bcmmii.c                        |    7=
=20
 drivers/net/ethernet/broadcom/sb1250-mac.c                          |    4=
=20
 drivers/net/ethernet/cavium/liquidio/lio_main.c                     |    2=
=20
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c                  |    2=
=20
 drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c                   |    5=
=20
 drivers/net/ethernet/cavium/liquidio/octeon_device.c                |    5=
=20
 drivers/net/ethernet/cavium/liquidio/octeon_iq.h                    |    2=
=20
 drivers/net/ethernet/cavium/liquidio/request_manager.c              |    2=
=20
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c                    |    5=
=20
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                          |    2=
=20
 drivers/net/ethernet/cortina/gemini.c                               |    1=
=20
 drivers/net/ethernet/faraday/ftgmac100.c                            |    4=
=20
 drivers/net/ethernet/faraday/ftmac100.c                             |    7=
=20
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c                      |    3=
=20
 drivers/net/ethernet/freescale/fec_mpc52xx.c                        |    3=
=20
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c               |    3=
=20
 drivers/net/ethernet/freescale/gianfar.c                            |    4=
=20
 drivers/net/ethernet/freescale/ucc_geth.c                           |    3=
=20
 drivers/net/ethernet/hisilicon/hip04_eth.c                          |    3=
=20
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c                       |    2=
=20
 drivers/net/ethernet/hisilicon/hns3/hnae3.c                         |   12=
=20
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                         |    3=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c                  |   18=
 -
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c             |   93=
 +++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c               |    2=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c            |    4=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c           |   42=
 ++
 drivers/net/ethernet/ibm/ehea/ehea_main.c                           |    2=
=20
 drivers/net/ethernet/ibm/emac/core.c                                |    7=
=20
 drivers/net/ethernet/ibm/ibmvnic.c                                  |    4=
=20
 drivers/net/ethernet/intel/i40e/i40e_main.c                         |   35=
 ++
 drivers/net/ethernet/intel/i40e/i40e_ptp.c                          |    3=
=20
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c                  |   10=
=20
 drivers/net/ethernet/intel/i40evf/i40evf_main.c                     |   15=
=20
 drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c                 |   32=
 ++
 drivers/net/ethernet/intel/ice/ice_common.c                         |   75=
 +++-
 drivers/net/ethernet/intel/ice/ice_common.h                         |    2=
=20
 drivers/net/ethernet/intel/ice/ice_controlq.c                       |    3=
=20
 drivers/net/ethernet/intel/ice/ice_main.c                           |   36=
 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c                            |    2=
=20
 drivers/net/ethernet/intel/ice/ice_status.h                         |    1=
=20
 drivers/net/ethernet/intel/ice/ice_type.h                           |   10=
=20
 drivers/net/ethernet/marvell/mvneta.c                               |    2=
=20
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h                          |    3=
=20
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                     |    9=
=20
 drivers/net/ethernet/marvell/pxa168_eth.c                           |    3=
=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c                      |   12=
=20
 drivers/net/ethernet/micrel/ks8695net.c                             |    2=
=20
 drivers/net/ethernet/micrel/ks8851_mll.c                            |    4=
=20
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c                 |   16=
 -
 drivers/net/ethernet/smsc/smc911x.c                                 |    3=
=20
 drivers/net/ethernet/smsc/smc91x.c                                  |    3=
=20
 drivers/net/ethernet/smsc/smsc911x.c                                |    3=
=20
 drivers/net/ethernet/socionext/sni_ave.c                            |    4=
=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c                   |    2=
=20
 drivers/net/ethernet/sun/ldmvsw.c                                   |    2=
=20
 drivers/net/ethernet/sun/sunbmac.c                                  |    3=
=20
 drivers/net/ethernet/sun/sunqe.c                                    |    2=
=20
 drivers/net/ethernet/sun/sunvnet.c                                  |    2=
=20
 drivers/net/ethernet/sun/sunvnet_common.c                           |   14=
=20
 drivers/net/ethernet/sun/sunvnet_common.h                           |    7=
=20
 drivers/net/ethernet/toshiba/ps3_gelic_net.c                        |    4=
=20
 drivers/net/ethernet/toshiba/ps3_gelic_net.h                        |    2=
=20
 drivers/net/ethernet/toshiba/spider_net.c                           |    4=
=20
 drivers/net/ethernet/toshiba/tc35815.c                              |    6=
=20
 drivers/net/ethernet/xilinx/ll_temac_main.c                         |    3=
=20
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c                   |    3=
=20
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                       |    9=
=20
 drivers/net/net_failover.c                                          |    4=
=20
 drivers/net/phy/mdio-bcm-unimac.c                                   |   83=
 +++++
 drivers/net/phy/mscc.c                                              |   11=
=20
 drivers/net/slip/slip.c                                             |    1=
=20
 drivers/net/usb/ax88172a.c                                          |    2=
=20
 drivers/net/usb/lan78xx.c                                           |    5=
=20
 drivers/net/usb/qmi_wwan.c                                          |    2=
=20
 drivers/net/wireless/ath/ath10k/ahb.c                               |    4=
=20
 drivers/net/wireless/ath/ath10k/core.c                              |   17=
 +
 drivers/net/wireless/ath/ath10k/hw.h                                |    5=
=20
 drivers/net/wireless/ath/ath10k/mac.c                               |    2=
=20
 drivers/net/wireless/ath/ath10k/pci.c                               |    2=
=20
 drivers/net/wireless/ath/ath10k/wmi.c                               |   10=
=20
 drivers/net/wireless/ath/ath9k/main.c                               |    1=
=20
 drivers/net/wireless/ath/ath9k/tx99.c                               |   10=
=20
 drivers/net/wireless/ath/wil6210/debugfs.c                          |    3=
=20
 drivers/net/wireless/ath/wil6210/main.c                             |    9=
=20
 drivers/net/wireless/ath/wil6210/pcie_bus.c                         |    1=
=20
 drivers/net/wireless/ath/wil6210/txrx.c                             |   15=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c           |    4=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c          |    2=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c      |    6=
=20
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c                      |    2=
=20
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h                      |   63=
 ++++
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h                      |    6=
=20
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c                         |    9=
=20
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h                      |    1=
=20
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c                   |    4=
=20
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                        |    4=
=20
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                         |   55=
 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h                  |   60=
 ---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c                        |    8=
=20
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c                     |   16=
 -
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c                   |    7=
=20
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c                        |    2=
=20
 drivers/net/wireless/marvell/mwifiex/usb.c                          |   13=
=20
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c                      |    2=
=20
 drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c               |    2=
=20
 drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c                 |    2=
=20
 drivers/nvmem/core.c                                                |    2=
=20
 drivers/of/base.c                                                   |    2=
=20
 drivers/of/unittest-data/overlay_15.dts                             |    4=
=20
 drivers/of/unittest-data/tests-overlay.dtsi                         |    4=
=20
 drivers/opp/core.c                                                  |   21=
 +
 drivers/opp/cpu.c                                                   |    2=
=20
 drivers/opp/opp.h                                                   |    2=
=20
 drivers/pci/controller/pcie-mediatek.c                              |    4=
=20
 drivers/pci/hotplug/pciehp_core.c                                   |    3=
=20
 drivers/pci/pci.c                                                   |   37=
 ++
 drivers/pci/pci.h                                                   |    2=
=20
 drivers/pci/pcie/aer.c                                              |   13=
=20
 drivers/pci/pcie/dpc.c                                              |    3=
=20
 drivers/pci/pcie/err.c                                              |   87=
 +----
 drivers/pci/pcie/pme.c                                              |    3=
=20
 drivers/pci/pcie/portdrv.h                                          |   24=
 +
 drivers/pci/pcie/portdrv_pci.c                                      |    9=
=20
 drivers/pci/slot.c                                                  |    1=
=20
 drivers/phy/broadcom/Kconfig                                        |    3=
=20
 drivers/phy/lantiq/phy-lantiq-rcu-usb2.c                            |    1=
=20
 drivers/phy/renesas/phy-rcar-gen3-usb2.c                            |    2=
=20
 drivers/phy/ti/phy-twl4030-usb.c                                    |   29=
 +
 drivers/pinctrl/pinctrl-at91-pio4.c                                 |    8=
=20
 drivers/pinctrl/pinctrl-at91.c                                      |   28=
 -
 drivers/pinctrl/pinctrl-ingenic.c                                   |    2=
=20
 drivers/power/reset/at91-sama5d2_shdwc.c                            |    3=
=20
 drivers/power/supply/ab8500_fg.c                                    |   31=
 -
 drivers/power/supply/max8998_charger.c                              |    2=
=20
 drivers/power/supply/twl4030_charger.c                              |   30=
 +
 drivers/remoteproc/da8xx_remoteproc.c                               |    2=
=20
 drivers/rtc/rtc-armada38x.c                                         |   22=
 -
 drivers/rtc/rtc-isl1208.c                                           |   27=
 -
 drivers/rtc/rtc-mt6397.c                                            |   13=
=20
 drivers/rtc/rtc-pl030.c                                             |   15=
=20
 drivers/rtc/rtc-rv8803.c                                            |    2=
=20
 drivers/rtc/rtc-sysfs.c                                             |    4=
=20
 drivers/rtc/rtc-tx4939.c                                            |    4=
=20
 drivers/s390/crypto/ap_bus.c                                        |   18=
 -
 drivers/s390/net/qeth_core_main.c                                   |  102=
 +++---
 drivers/s390/net/qeth_l2_main.c                                     |    3=
=20
 drivers/s390/net/qeth_l3_main.c                                     |    3=
=20
 drivers/scsi/NCR5380.c                                              |  156=
 +++++-----
 drivers/scsi/NCR5380.h                                              |    2=
=20
 drivers/scsi/libsas/sas_expander.c                                  |   13=
=20
 drivers/scsi/lpfc/lpfc_ct.c                                         |    5=
=20
 drivers/scsi/lpfc/lpfc_hbadisc.c                                    |    2=
=20
 drivers/scsi/lpfc/lpfc_nportdisc.c                                  |    3=
=20
 drivers/scsi/lpfc/lpfc_nvme.c                                       |    2=
=20
 drivers/scsi/lpfc/lpfc_nvmet.c                                      |    7=
=20
 drivers/scsi/lpfc/lpfc_sli.c                                        |    6=
=20
 drivers/scsi/pm8001/pm8001_hwi.c                                    |    6=
=20
 drivers/scsi/pm8001/pm8001_sas.c                                    |    9=
=20
 drivers/scsi/pm8001/pm8001_sas.h                                    |    1=
=20
 drivers/scsi/pm8001/pm80xx_hwi.c                                    |   80=
 ++++-
 drivers/scsi/pm8001/pm80xx_hwi.h                                    |    3=
=20
 drivers/scsi/qla2xxx/qla_gs.c                                       |   28=
 +
 drivers/scsi/qla2xxx/qla_init.c                                     |   36=
 --
 drivers/scsi/qla2xxx/qla_iocb.c                                     |   12=
=20
 drivers/scsi/qla2xxx/qla_isr.c                                      |   50=
 +--
 drivers/scsi/qla2xxx/qla_os.c                                       |   29=
 +
 drivers/scsi/qla2xxx/qla_target.c                                   |    6=
=20
 drivers/scsi/scsi_lib.c                                             |    3=
=20
 drivers/scsi/sym53c8xx_2/sym_hipd.c                                 |   15=
=20
 drivers/scsi/ufs/ufshcd.c                                           |   53=
 ++-
 drivers/slimbus/qcom-ngd-ctrl.c                                     |   24=
 -
 drivers/soc/imx/gpc.c                                               |    2=
=20
 drivers/soc/qcom/apr.c                                              |    4=
=20
 drivers/soc/qcom/qcom-geni-se.c                                     |   41=
 +-
 drivers/soc/qcom/rpmh-rsc.c                                         |    2=
=20
 drivers/soc/qcom/wcnss_ctrl.c                                       |    2=
=20
 drivers/soc/tegra/pmc.c                                             |   55=
 ++-
 drivers/soundwire/bus.c                                             |    1=
=20
 drivers/soundwire/intel_init.c                                      |    2=
=20
 drivers/spi/spi-bcm63xx-hsspi.c                                     |   20=
 +
 drivers/spi/spi-mt65xx.c                                            |   37=
 +-
 drivers/spi/spi-pic32.c                                             |    4=
=20
 drivers/staging/media/imx/imx-media-csi.c                           |    5=
=20
 drivers/tee/optee/core.c                                            |    2=
=20
 drivers/tty/serial/mxs-auart.c                                      |    3=
=20
 drivers/tty/serial/qcom_geni_serial.c                               |   55=
 +--
 drivers/tty/serial/samsung.c                                        |    8=
=20
 drivers/tty/serial/xilinx_uartps.c                                  |   41=
 --
 drivers/uio/uio_hv_generic.c                                        |    5=
=20
 drivers/usb/chipidea/otg.c                                          |    9=
=20
 drivers/usb/chipidea/usbmisc_imx.c                                  |    2=
=20
 drivers/usb/class/usbtmc.c                                          |   17=
 -
 drivers/usb/gadget/function/uvc_configfs.c                          |   20=
 +
 drivers/usb/gadget/function/uvc_video.c                             |   32=
 +-
 drivers/usb/host/xhci-mtk-sch.c                                     |    4=
=20
 drivers/usb/mtu3/mtu3_core.c                                        |    4=
=20
 drivers/usb/mtu3/mtu3_gadget.c                                      |   22=
 -
 drivers/vfio/pci/vfio_pci.c                                         |    8=
=20
 drivers/vfio/pci/vfio_pci_config.c                                  |   31=
 +
 fs/btrfs/inode.c                                                    |   15=
=20
 fs/compat_ioctl.c                                                   |   10=
=20
 fs/ecryptfs/inode.c                                                 |   19=
 -
 fs/f2fs/data.c                                                      |   35=
 +-
 fs/f2fs/f2fs.h                                                      |    3=
=20
 fs/f2fs/file.c                                                      |   63=
 ++--
 fs/f2fs/node.c                                                      |    5=
=20
 fs/f2fs/recovery.c                                                  |   17=
 +
 fs/f2fs/segment.c                                                   |    6=
=20
 fs/f2fs/super.c                                                     |   11=
=20
 fs/fuse/control.c                                                   |    4=
=20
 fs/gfs2/rgrp.c                                                      |    2=
=20
 fs/kernfs/symlink.c                                                 |    5=
=20
 fs/udf/super.c                                                      |   65=
 +++-
 include/crypto/chacha20.h                                           |    3=
=20
 include/linux/cpufeature.h                                          |    2=
=20
 include/linux/edac.h                                                |    3=
=20
 include/linux/fsl_ifc.h                                             |    2=
=20
 include/linux/hyperv.h                                              |    2=
=20
 include/linux/intel-iommu.h                                         |    6=
=20
 include/linux/libfdt_env.h                                          |    1=
=20
 include/linux/mlx5/driver.h                                         |    5=
=20
 include/linux/timekeeping32.h                                       |   15=
=20
 include/media/vsp1.h                                                |    2=
=20
 include/net/llc.h                                                   |    1=
=20
 include/soc/tegra/pmc.h                                             |    1=
=20
 include/trace/events/sched.h                                        |   11=
=20
 kernel/events/uprobes.c                                             |    4=
=20
 kernel/kprobes.c                                                    |    8=
=20
 kernel/sched/sched.h                                                |    2=
=20
 kernel/signal.c                                                     |    4=
=20
 kernel/time/time.c                                                  |   15=
=20
 kernel/time/timekeeping.c                                           |   24=
 -
 lib/chacha20.c                                                      |    6=
=20
 mm/hugetlb_cgroup.c                                                 |    2=
=20
 mm/memcontrol.c                                                     |    2=
=20
 mm/memfd.c                                                          |    2=
=20
 mm/mempolicy.c                                                      |   14=
=20
 net/bluetooth/l2cap_core.c                                          |   10=
=20
 net/core/rtnetlink.c                                                |    2=
=20
 net/ipv4/gre_demux.c                                                |    7=
=20
 net/ipv4/ip_gre.c                                                   |    9=
=20
 net/ipv4/ipmr.c                                                     |    3=
=20
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c                         |   22=
 +
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c                         |   19=
 +
 net/llc/llc_core.c                                                  |    4=
=20
 net/mac80211/mlme.c                                                 |   17=
 -
 net/netfilter/nf_tables_api.c                                       |    9=
=20
 net/netfilter/nft_cmp.c                                             |    6=
=20
 net/netfilter/nft_reject.c                                          |    6=
=20
 net/wireless/reg.c                                                  |  110=
 +++++--
 samples/bpf/sockex2_kern.c                                          |   11=
=20
 samples/bpf/sockex3_kern.c                                          |    8=
=20
 samples/bpf/sockex3_user.c                                          |    4=
=20
 sound/core/oss/pcm_plugin.c                                         |    4=
=20
 sound/core/seq/seq_system.c                                         |   18=
 -
 sound/pci/hda/patch_ca0132.c                                        |    1=
=20
 sound/pci/intel8x0m.c                                               |   20=
 -
 sound/soc/amd/acp-da7219-max98357a.c                                |    2=
=20
 sound/soc/codecs/hdac_hdmi.c                                        |    6=
=20
 sound/soc/codecs/rt5682.c                                           |    5=
=20
 sound/soc/codecs/sgtl5000.c                                         |    2=
=20
 sound/soc/meson/axg-fifo.c                                          |    2=
=20
 sound/soc/sh/rcar/rsnd.h                                            |    1=
=20
 sound/soc/sh/rcar/ssi.c                                             |    4=
=20
 sound/soc/soc-dapm.c                                                |    4=
=20
 sound/soc/soc-pcm.c                                                 |    2=
=20
 sound/usb/endpoint.c                                                |    3=
=20
 sound/usb/mixer.c                                                   |    4=
=20
 sound/usb/quirks.c                                                  |    4=
=20
 sound/usb/validate.c                                                |    6=
=20
 tools/testing/selftests/powerpc/tm/tm-unavailable.c                 |    9=
=20
 tools/testing/selftests/powerpc/tm/tm.h                             |    9=
=20
 516 files changed, 3845 insertions(+), 1904 deletions(-)

Aapo Vienamo (2):
      soc/tegra: pmc: Fix pad voltage configuration for Tegra186
      arm64: dts: tegra210-p2180: Correct sdmmc4 vqmmc-supply

Akshu Agrawal (1):
      ASoC: AMD: Change MCLK to 48Mhz

Al Viro (2):
      ecryptfs_lookup_interpose(): lower_dentry->d_inode is not stable
      ecryptfs_lookup_interpose(): lower_dentry->d_parent is not stable eit=
her

Alan Modra (1):
      powerpc/vdso: Correct call frame information

Alan Tull (1):
      arm64: dts: stratix10: i2c clock running out of spec

Aleksander Morgado (1):
      net: usb: qmi_wwan: add support for Foxconn T77W968 LTE modules

Alex Williamson (1):
      vfio/pci: Mask buggy SR-IOV VF INTx support

Alexandre Belloni (6):
      rtc: rv8803: fix the rv8803 id in the OF table
      rtc: mt6397: fix possible race condition
      rtc: pl030: fix possible race condition
      rtc: isl1208: avoid possible sysfs race
      rtc: tx4939: fixup nvmem name and register size
      rtc: armada38x: fix possible race condition

Alexey Khoroshilov (1):
      media: ov772x: Disable clk on error path

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

Andrew Lunn (1):
      net: bcmgenet: Fix speed selection for reverse MII

Andrzej Hajda (2):
      ARM: dts: exynos: Use i2c-gpio for HDMI-DDC on Arndale
      ARM: dts: exynos: Fix HDMI-HPD line handling on Arndale

Andy Shevchenko (1):
      extcon: cht-wc: Return from default case to avoid warnings

Anirudh Venkataramanan (2):
      ice: Prevent control queue operations during reset
      ice: Fix and update driver version string

Anson Huang (1):
      ARM: dts: imx6ull: update vdd_soc voltage for 900MHz operating point

Antoine Tenart (1):
      net: mvpp2: fix the number of queues per cpu for PPv2.2

Anton Blanchard (1):
      powerpc: Fix duplicate const clang warning in user access code

Anton Vasilyev (1):
      serial: mxs-auart: Fix potential infinite loop

Ard Biesheuvel (1):
      tee: optee: take DT status property into account

Arend van Spriel (1):
      brcmfmac: increase buffer for obtaining firmware capabilities

Arnd Bergmann (5):
      y2038: make do_gettimeofday() and get_seconds() inline
      media: dvb: fix compat ioctl translation
      media: imx: work around false-positive warning, again
      RDMA: Fix dependencies for rdma_user_mmap_io
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

Breno Leitao (2):
      powerpc/iommu: Avoid derefence before pointer check
      selftests/powerpc: Do not fail with reschedule

Chao Yu (5):
      f2fs: fix memory leak of write_io in fill_super()
      f2fs: fix memory leak of percpu counter in fill_super()
      f2fs: fix to recover inode's uid/gid during POR
      f2fs: fix to recover inode's project id during POR
      f2fs: mark inode dirty explicitly in recover_inode()

Charles Keepax (3):
      ASoC: dapm: Don't fail creating new DAPM control on NULL pinctrl
      ASoC: dpcm: Properly initialise hw->rate_max
      ASoC: dapm: Avoid uninitialised variable warning

Chengguang Xu (1):
      f2fs: fix remount problem of option io_bits

Christian Brauner (1):
      rtnetlink: move type calculation out of loop

Christian Lamparter (1):
      ARM: dts: qcom: ipq4019: fix cpu0's qcom,saw2 reg value

Christoph Hellwig (1):
      mtd: rawnand: qcom: don't include dma-direct.h

Christoph Manszewski (2):
      crypto: s5p-sss: Fix race in error handling
      crypto: s5p-sss: Fix Fix argument list alignment

Chuhong Yuan (2):
      net: gemini: add missed free_netdev
      Input: synaptics-rmi4 - destroy F54 poller workqueue when removing

Chunfeng Yun (2):
      usb: mtu3: disable vbus rise/fall interrupts of ltssm
      usb: xhci-mtk: fix ISOC error when interval is zero

Claudiu Beznea (1):
      power: reset: at91-poweroff: do not procede if at91_shdwc is allocated

Colin Ian King (2):
      ASoC: sgtl5000: avoid division by zero if lo_vag is zero
      ipmi_si: fix potential integer overflow on large shift

Cong Wang (1):
      llc: avoid blocking in llc_sap_close()

Corentin Labbe (1):
      net: ethernet: dwmac-sun8i: Use the correct function in exit path

Corey Minyard (1):
      ipmi:dmi: Ignore IPMI SMBIOS entries with a zero base address

Dan Aloni (1):
      crypto: fix a memory leak in rsa-kcs1pad's encryption mode

Dan Carpenter (7):
      ALSA: pcm: signedness bug in snd_pcm_plug_alloc()
      rtc: sysfs: fix NULL check in rtc_add_groups()
      dmaengine: at_xdmac: remove a stray bottom half unlock
      RDMA/hns: Fix an error code in hns_roce_v2_init_eq_table()
      pinctrl: at91-pio4: fix has_config check in atmel_pctl_dt_subnode_to_=
map()
      power: supply: ab8500_fg: silence uninitialized variable warnings
      ath9k: Fix a locking bug in ath9k_add_interface()

Dan Nowlin (1):
      ice: Update request resource command to latest specification

Daniel Silsby (1):
      dmaengine: dma-jz4780: Further residue status fix

Dedy Lansky (2):
      wil6210: drop Rx multicast packets that are looped-back to STA
      wil6210: fix invalid memory access for rx_buff_mgmt debugfs

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

Douglas Anderson (3):
      soc: qcom: geni: Don't ignore clk_round_rate() errors in geni_se_clk_=
tbl_get()
      soc: qcom: geni: geni_se_clk_freq_match() should always accept multip=
les
      tty: serial: qcom_geni_serial: Fix serial when not used as console

Emmanuel Grumbach (1):
      iwlwifi: dbg: don't crash if the firmware crashes in the middle of a =
debug dump

Erel Geron (1):
      iwlwifi: fix non_shared_ant for 22000 devices

Eric Auger (1):
      iommu/vt-d: Fix QI_DEV_IOTLB_PFSID and QI_DEV_EIOTLB_PFSID macros

Eric Biggers (1):
      crypto: chacha20 - Fix chacha20_block() keystream alignment (again)

Eric W. Biederman (3):
      signal: Always ignore SIGKILL and SIGSTOP sent to the global init
      signal: Properly deliver SIGILL from uprobes
      signal: Properly deliver SIGSEGV from x86 uprobes

Erik Stromdahl (1):
      ath10k: wmi: disable softirq's while calling ieee80211_rx

Eugen Hristev (1):
      mmc: sdhci-of-at91: fix quirk2 overwrite

Fabio Estevam (1):
      ARM: dts: imx51-zii-rdu1: Fix the rtc compatible string

Felix Fietkau (2):
      ath9k: fix tx99 with monitor mode interface
      ath9k: add back support for using active monitor interfaces for tx99

Filipe Manana (1):
      Btrfs: fix log context list corruption after rename exchange operation

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

Florian Westphal (1):
      netfilter: nf_tables: avoid BUG_ON usage

Fuyun Liang (1):
      net: hns3: Fix for setting speed for phy failed problem

Ganapathi Bhat (2):
      mwifiex: do no submit URB in suspended state
      mwifex: free rx_cmd skb in suspended state

Ganesh Goudar (1):
      cxgb4: Fix endianness issue in t4_fwcache()

Geert Uytterhoeven (6):
      ARM: dts: rcar: Correct SATA device sizes to 2 MiB
      mt76: Fix comparisons with invalid hardware key index
      media: dt-bindings: adv748x: Fix decimal unit addresses
      arm64: dts: renesas: r8a77965: Fix HS-USB compatible
      arm64: dts: renesas: r8a77965: Fix clock/reset for usb2_phy1
      ARM: dts: ux500: Correct SCU unit address

George Kennedy (1):
      scsi: sym53c8xx: fix NULL pointer dereference panic in sym_int_sir()

Golan Ben Ami (1):
      iwlwifi: pcie: fit reclaim msg to MAX_MSG_LEN

Greg Kroah-Hartman (1):
      Linux 4.19.85

Grygorii Strashko (1):
      ARM: dts: am335x-evm: fix number of cpsw

Guido Kiener (2):
      usb: usbtmc: Fix ioctl USBTMC_IOCTL_ABORT_BULK_OUT
      usb: usbtmc: uninitialized symbol 'actual' in usbtmc_ioctl_clear

Guillaume Nault (1):
      ipmr: Fix skb headroom in ipmr_get_route().

Gustavo A. R. Silva (1):
      PCI: mediatek: Fix unchecked return value

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

Halil Pasic (1):
      s390/zcrypt: enable AP bus scan without a valid default domain

Hannes Reinecke (1):
      scsi: NCR5380: Clear all unissued commands on host reset

Hans Verkuil (1):
      media: vicodec: fix out-of-range values when decoding

Hans de Goede (2):
      i2c: acpi: Force bus speed to 400KHz if a Silead touchscreen is prese=
nt
      ACPI / LPSS: Exclude I2C busses shared with PUNIT from pmc_atom_d3_ma=
sk

Hari Vyas (1):
      arm64: fix for bad_mode() handler to always result in panic

Hauke Mehrtens (1):
      phy: lantiq: Fix compile warning

Heiko Stuebner (1):
      ARM: dts: rockchip: explicitly set vcc_sd0 pin to gpio on rk3188-radx=
arock

Henry Lin (1):
      ALSA: usb-audio: not submit urb for stopped endpoint

Huazhong Tan (1):
      net: hns3: Fix for multicast failure

H=C3=A5kon Bugge (1):
      RDMA/i40iw: Fix incorrect iterator type

Ilan Peer (1):
      iwlwifi: mvm: Allow TKIP for AP mode

Israel Rukshin (1):
      IB/iser: Fix possible NULL deref at iser_inv_desc()

Jaegeuk Kim (4):
      f2fs: avoid wrong decrypted data from disk
      f2fs: submit bio after shutdown
      f2fs: avoid infinite loop in f2fs_alloc_nid
      f2fs: update i_size after DIO completion

Jakub Kicinski (1):
      nfp: provide a better warning when ring allocation fails

James Erwin (1):
      IB/hfi1: Ensure full Gen3 speed in a Gen4 system

James Smart (3):
      scsi: lpfc: Fix GFT_ID and PRLI logic for RSCN
      scsi: lpfc: Correct invalid EQ doorbell write on if_type=3D6
      scsi: lpfc: Fix errors in log messages.

Jan Kara (1):
      udf: Fix crash during mount

Jan Sokolowski (1):
      i40e: Check and correct speed values for link on open

Jason Yan (1):
      scsi: libsas: always unregister the old device if going to discover n=
ew

Javier Martinez Canillas (1):
      media: ov2680: don't register the v4l2 subdevice before checking chip=
 ID

Jay Foster (1):
      ARM: dts: at91/trivial: Fix USART1 definition for at91sam9g45

Jerome Brunet (2):
      ASoC: meson: axg-fifo: report interrupt request failure
      arm64: dts: meson: libretech: update board model

Jia-Ju Bai (2):
      net: socionext: Fix two sleep-in-atomic-context bugs in ave_rxfifo_re=
set()
      media: pci: ivtv: Fix a sleep-in-atomic-context bug in ivtv_yuv_init()

Jiada Wang (1):
      ASoC: rsnd: ssi: Fix issue in dma data address assignment

Jian Shen (5):
      net: hns3: Fix error of checking used vlan id
      net: hns3: Fix cmdq registers initialization issue for vf
      net: hns3: Clear client pointer when initialize client failed or unin=
tialize finished
      net: hns3: Fix client initialize state issue when roce client initial=
ize failed
      net: hns3: Fix parameter type for q_id in hclge_tm_q_to_qs_map_cfg()

Joel Pepper (1):
      usb: gadget: uvc: configfs: Prevent format changes after linking head=
er

Johannes Berg (3):
      iwlwifi: don't WARN on trying to dump dead firmware
      iwlwifi: api: annotate compressed BA notif array sizes
      iwlwifi: pcie: gen2: build A-MSDU only for GSO

Jonas Gorski (2):
      MIPS: BCM63XX: fix switch core reset on BCM6368
      spi/bcm63xx-hsspi: keep pll clk enabled

Jouni Hogander (2):
      slip: Fix memory leak in slip_open error path
      slcan: Fix memory leak in error path

Julian Wiedmann (2):
      s390/qeth: uninstall IRQ handler on device removal
      s390/qeth: invoke softirqs after napi_schedule()

Jun Gao (1):
      i2c: mediatek: Use DMA safe buffers for i2c transactions

Justin Ernst (1):
      EDAC: Raise the maximum number of memory controllers

K.T.VIJAYAKUMAAR (1):
      ath10k: avoid possible memory access violation

Keith Busch (5):
      PCI: portdrv: Initialize service drivers directly
      PCI/AER: Take reference on error devices
      PCI/AER: Don't read upstream ports below fatal errors
      PCI/ERR: Use slot reset if available
      PCI/ERR: Run error recovery callbacks for all affected devices

Kieran Bingham (1):
      arm64: dts: renesas: salvator-common: adv748x: Override secondary add=
resses

Kirill Tkhai (1):
      fuse: use READ_ONCE on congestion_threshold and max_background

Kishon Vijay Abraham I (1):
      arm64: dts: ti: k3-am65: Change #address-cells and #size-cells of int=
erconnect to 2

Koji Matsuoka (1):
      media: vsp1: Fix YCbCr planar formats pitch calculation

Kurt Kanzenbach (2):
      mtd: rawnand: fsl_ifc: check result of SRAM initialization
      mtd: rawnand: fsl_ifc: fixup SRAM init for newer ctrl versions

Lao Wei (1):
      media: fix: media: pci: meye: validate offset to avoid arbitrary acce=
ss

Larry Finger (1):
      rtl8187: Fix warning generated when strncpy() destination length matc=
hes the sixe argument

Laura Abbott (1):
      misc: kgdbts: Fix restrict error

Laurent Pinchart (4):
      media: vsp1: Fix vsp1_regs.h license header
      usb: gadget: uvc: configfs: Drop leaked references to config items
      usb: gadget: uvc: Factor out video USB request queueing
      usb: gadget: uvc: Only halt video streaming endpoint in bulk mode

Leo Yan (1):
      coresight: tmc: Fix byte-address alignment for RRP

Li Qiang (1):
      vfio/pci: Fix potential memory leak in vfio_msi_cap_len

Lihong Yang (2):
      i40evf: set IFF_UNICAST_FLT flag for the VF
      i40evf: cancel workqueue sync for adminq when a VF is removed

Lina Iyer (1):
      drivers: qcom: rpmh-rsc: clear wait_for_compl after use

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

Magnus Damm (1):
      arm64: dts: renesas: r8a77965: Attach the SYS-DMAC to the IPMMU

Majd Dibbiny (1):
      IB/mlx5: Change TX affinity assignment in RoCE LAG mode

Marc Dietrich (1):
      ARM: dts: paz00: fix wakeup gpio keycode

Marcel Ziswiler (6):
      ARM: dts: pxa: fix power i2c base address
      ARM: dts: tegra30: fix xcvr-setup-use-fuses
      ARM: dts: tegra20: restore address order
      ARM: tegra: apalis_t30: fix mmc1 cmd pull-up
      ARM: tegra: apalis_t30: fix mcp2515 can controller interrupt polarity
      ARM: tegra: colibri_t30: fix mcp2515 can controller interrupt polarity

Marcus Folkesson (1):
      iio: dac: mcp4922: fix error handling in mcp4922_write_raw

Marek Szyprowski (6):
      ARM: dts: exynos: Fix sound in Snow-rev5 Chromebook
      ARM: dts: exynos: Fix regulators configuration on Peach Pi/Pit Chrome=
books
      ARM: dts: exynos: Disable pull control for S5M8767 PMIC
      ARM: dts: exynos: Disable pull control for PMIC IRQ line on Artik5 bo=
ard
      serial: samsung: Enable baud clock for UART reset procedure in resume
      ARM: dts: exynos: Correct audio subsystem parent clock on Peach Chrom=
ebooks

Mark Brown (1):
      ALSA: hda: Fix implicit definition of pci_iomap() on SH

Martin Blumenstingl (2):
      ARM: dts: meson8: fix the clock controller register size
      ARM: dts: meson8b: fix the clock controller register size

Masami Hiramatsu (1):
      kprobes: Don't call BUG_ON() if there is a kprobe in use on free list

Matthew Whitehead (2):
      x86/CPU: Use correct macros for Cyrix calls
      x86/CPU: Change query logic so CPUID is enabled before testing

Maya Erez (2):
      wil6210: set edma variables only for Talyn-MB devices
      wil6210: prevent usage of tx ring 0 for eDMA

Meelis Roos (1):
      ipmi_si_pci: fix NULL device in ipmi_si error message

Michael J. Ruhl (1):
      IB/hfi1: Missing return value in error path for user sdma

Michael Kelley (1):
      Drivers: hv: vmbus: Fix synic per-cpu context initialization

Michael Schmitz (1):
      scsi: core: Handle drivers which set sg_tablesize to zero

Mike Marciniszyn (1):
      IB/hfi1: Use a common pad buffer for 9B and 16B packets

Mitch Williams (1):
      i40e: use correct length for strncpy

Moni Shoua (1):
      net/mlx5: Fix atomic_mode enum values

Muhammad Sammar (1):
      IB/ipoib: Ensure that MTU isn't less than minimum permitted

Naftali Goldstein (1):
      mac80211: fix saving a few HE values

Nathan Chancellor (3):
      spi: pic32: Use proper enum in dmaengine_prep_slave_rg
      media: davinci: Fix implicit enum conversion warning
      iw_cxgb4: Use proper enumerated type in c4iw_bar2_addrs

Nathan Fontenot (2):
      powerpc/pseries/memory-hotplug: Only update DT once per memory DLPAR =
request
      powerpc/pseries: Disable CPU hotplug across migrations

Nava kishore Manne (1):
      serial: uartps: Fix suspend functionality

Neil Armstrong (1):
      arm64: dts: meson-axg: use the proper compatible for ethmac

Nicholas Piggin (1):
      powerpc/64s/hash: Fix stab_rr off by one initialization

Nicolas Adell (1):
      usb: chipidea: imx: enable OTG overcurrent in case USB subsystem is a=
lready started

Niklas Cassel (2):
      soc: qcom: wcnss_ctrl: Avoid string overflow
      soc: qcom: apr: Avoid string overflow

Oleksij Rempel (1):
      ARM: imx6: register pm_power_off handler if "fsl,pmic-stby-poweroff" =
is set

Oliver Neukum (2):
      ax88172a: fix information leak on short answers
      Input: ff-memless - kill timer in destroy()

Paolo Bonzini (1):
      KVM: x86: introduce is_pae_paging

Paolo Valente (2):
      block, bfq: inject other-queue I/O into seeky idle queues on NCQ flash
      blok, bfq: do not plug I/O if all queues are weight-raised

Parav Pandit (3):
      IB/mlx5: Don't hold spin lock while checking device state
      RDMA/core: Rate limit MAD error messages
      RDMA/core: Follow correct unregister order between sysfs and cgroup

Patryk Ma=C5=82ek (3):
      i40evf: Don't enable vlan stripping when rx offload is turned on
      i40e: hold the rtnl lock on clearing interrupt scheme
      i40e: Prevent deleting MAC address from VF when set by PF

Paul Cercueil (2):
      pinctrl: ingenic: Probe driver at subsys_initcall
      dmaengine: dma-jz4780: Don't depend on MACH_JZ4780

Paul Elder (1):
      usb: gadget: uvc: configfs: Sort frame intervals upon writing

Paul M Stillwell Jr (1):
      i40evf: Validate the number of queues a PF sends

Peter Shih (1):
      spi: mediatek: Don't modify spi_transfer when transfer.

Peter Wu (1):
      qxl: fix null-pointer crash during suspend

Peter Zijlstra (1):
      sched/debug: Explicitly cast sched_feat() to bool

Petr Machata (2):
      mlxsw: spectrum: Init shaper for TCs 8..15
      mlxsw: Make MLXSW_SP1_FWREV_MINOR a hard requirement

Prashant Bhole (1):
      samples/bpf: fix compilation failure

Qiuxu Zhuo (2):
      EDAC, sb_edac: Return early on ADDRV bit and address type test
      EDAC: Correct DIMM capacity unit symbol

Quentin Schulz (2):
      net: phy: mscc: read 'vsc8531,vddmac' as an u32
      net: phy: mscc: read 'vsc8531, edge-slowdown' as an u32

Quinn Tran (9):
      scsi: qla2xxx: Use correct qpair for ABTS/CMD
      scsi: qla2xxx: Fix iIDMA error
      scsi: qla2xxx: Defer chip reset until target mode is enabled
      scsi: qla2xxx: Terminate Plogi/PRLI if WWN is 0
      scsi: qla2xxx: Fix deadlock between ATIO and HW lock
      scsi: qla2xxx: Increase abort timeout value
      scsi: qla2xxx: Fix port speed display on chip reset
      scsi: qla2xxx: Fix dropped srb resource.
      scsi: qla2xxx: Fix duplicate switch's Nport ID entries

Rajeev Kumar Sirasanagandla (1):
      cfg80211: Avoid regulatory restore when COUNTRY_IE_IGNORE is set

Rakesh Pillai (1):
      ath10k: skip resetting rx filter for WCN3990

Rasmus Villemoes (1):
      brcmfmac: fix wrong strnchr usage

Ricardo Ribalda Delgado (1):
      gpiolib: Fix gpio_direction_* for single direction GPIOs

Rick Farrington (1):
      liquidio: fix race condition in instruction completion processing

Rob Herring (22):
      of: make PowerMac cache node search conditional on CONFIG_PPC_PMAC
      arm64: dts: broadcom: Fix I2C and SPI bus warnings
      ARM: dts: bcm: Fix SPI bus warnings
      ARM: dts: aspeed: Fix I2C bus warnings
      ARM: dts: sunxi: Fix I2C bus warnings
      ARM: dts: sun9i: Fix I2C bus warnings
      arm64: dts: meson: Fix erroneous SPI bus warnings
      ARM: dts: rockchip: Fix erroneous SPI bus dtc warnings on rk3036
      arm64: dts: rockchip: Fix I2C bus unit-address error on rk3399-puma-h=
aikou
      ARM: dts: xilinx: Fix I2C and SPI bus warnings
      ARM: dts: atmel: Fix I2C and SPI bus warnings
      of/unittest: Fix I2C bus unit-address error
      libfdt: Ensure INT_MAX is defined in libfdt_env.h
      ARM: dts: ti: Fix SPI and I2C bus warnings
      ARM: dts: ste: Fix SPI controller node names
      ARM: dts: marvell: Fix SPI and I2C bus warnings
      ARM: dts: stm32: Fix SPI controller node names
      arm64: dts: fsl: Fix I2C and SPI bus warnings
      ARM: dts: realview: Fix SPI controller node names
      arm64: dts: amd: Fix SPI bus warnings
      arm64: dts: lg: Fix SPI controller node names
      ARM: dts: lpc32xx: Fix SPI controller node names

Robert Jarzmik (1):
      ARM: dts: pxa: fix the rtc controller

Roman Gushchin (2):
      mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()
      mm: hugetlb: switch to css_tryget() in hugetlb_cgroup_charge_cgroup()

Rongyi Chen (1):
      clk: sunxi-ng: h6: fix PWM gate/reset offset

Rui Miguel Silva (1):
      media: ov2680: fix null dereference at power on

Sakari Ailus (1):
      media: i2c: Fix pm_runtime_get_if_in_use() usage in sensor drivers

Samuel Holland (1):
      arm64: dts: allwinner: a64: Orange Pi Win: Fix SD card node

Sanjay Kumar Konduri (1):
      Bluetooth: btrsi: fix bt tx timeout issue

Sara Sharon (4):
      iwlwifi: drop packets with bad status in CD
      iwlwifi: mvm: avoid sending too many BARs
      iwlwifi: pcie: read correct prph address for newer devices
      iwlwifi: mvm: use correct FIFO length

Sawan Chandak (1):
      scsi: qla2xxx: Check for Register disconnect

Shahed Shaikh (1):
      bnx2x: Ignore bandwidth attention in single function mode

Sherry Yang (1):
      android: binder: no outgoing transaction when thread todo has transac=
tion

Shreyas NC (1):
      soundwire: Initialize completion for defer messages

Shuming Fan (1):
      ASoC: rt5682: Fix the boost volume at the begining of playback

Sinan Kaya (1):
      PCI/ACPI: Correct error message for ASPM disabling

Srinivas Kandagatla (4):
      nvmem: core: return error code instead of NULL from nvmem_device_get
      slimbus: ngd: register ngd driver only once.
      slimbus: ngd: return proper error code instead of zero
      silmbus: ngd: register controller after power up.

Stanislaw Gruszka (1):
      cfg80211: validate wmm rule when setting

Stefan Agner (3):
      iio: adc: max9611: explicitly cast gain_selectors
      cpufeature: avoid warning when compiling with clang
      crypto: arm/crc32 - avoid warning when compiling with Clang

Stefan Wahren (1):
      net: lan78xx: Bail out if lan78xx_get_endpoints fails

Stephen Hemminger (1):
      vmbus: keep pointer to ring buffer page

Stuart Hayes (1):
      firmware: dell_rbu: Make payload memory uncachable

Sudeep Holla (1):
      firmware: arm_scmi: use strlcpy to ensure NULL-terminated strings

Suman Tripathi (1):
      ata: Disable AHCI ALPM feature for Ampere Computing eMAG SATA

Suzuki K Poulose (5):
      coresight: Fix handling of sinks
      coresight: perf: Fix per cpu path management
      coresight: perf: Disable trace path upon source error
      coresight: tmc-etr: Handle driver mode specific ETR buffers
      coresight: dynamic-replicator: Handle multiple connections

Sven Eckelmann (1):
      ath10k: limit available channels via DT ieee80211-freq-limit

Sven Schmitt (1):
      soc: imx: gpc: fix PDN delay

Takashi Iwai (6):
      ALSA: usb-audio: Fix missing error check at mixer resolution test
      ALSA: usb-audio: Fix incorrect NULL check in create_yamaha_midi_quirk=
()
      ALSA: usb-audio: Fix incorrect size check for processing/extension un=
its
      ALSA: seq: Do error checks at creating system ports
      ALSA: intel8x0m: Register irq handler after register initializations
      brcmsmac: Use kvmalloc() for ucode allocations

Tamizh chelvam (1):
      ath10k: fix kernel panic by moving pci flush after napi_disable

Tan Hu (1):
      netfilter: masquerade: don't flush all conntracks if only one address=
 deleted on device

Thierry Reding (1):
      arm64: tegra: I2C on Tegra194 is not compatible with Tegra114

Thomas Petazzoni (1):
      mtd: rawnand: marvell: use regmap_update_bits() for syscon access

Tomasz Figa (1):
      power: supply: max8998-charger: Fix platform data retrieval

Tomasz Nowicki (1):
      coresight: etm4x: Configure EL2 exception level when kernel is runnin=
g in HYP

Tuomas Tynkkynen (1):
      MIPS: BCM47XX: Enable USB power on Netgear WNDR3400v3

Uwe Kleine-K=C3=B6nig (1):
      sched/debug: Use symbolic names for task state constants

Vasily Gorbik (3):
      s390/vdso: avoid 64-bit vdso mapping for compat tasks
      s390/vdso: correct CFI annotations of vDSO functions
      s390/vdso: correct vdso mapping for compat tasks

Vicente Bergas (2):
      arm64: dts: rockchip: Fix VCC5V0_HOST_EN on rk3399-sapphire
      arm64: dts: rockchip: Fix microSD in rk3399 sapphire board

Vijay Immanuel (2):
      IB/rxe: avoid back-to-back retries
      IB/rxe: fixes for rdma read retry

Vinod Koul (1):
      soundwire: intel: Fix uninitialized adev deref

Viresh Kumar (1):
      OPP: Protect dev_list with opp_table lock

Vivek Gautam (1):
      scsi: ufshcd: Fix NULL pointer dereference for in ufshcd_init

Wang Shilong (1):
      f2fs: fix setattr project check upon fssetxattr ioctl

Yana Esina (1):
      net: aquantia: fix hw_atl_utils_fw_upload_dwords

Yang Shi (1):
      mm: mempolicy: fix the wrong return value and potential pages leak of=
 mbind

Yannick Fertr=C3=A9 (1):
      ARM: dts: stm32: enable display on stm32mp157c-ev1 board

Yong Zhi (1):
      ASoC: Intel: hdac_hdmi: Limit sampling rates at dai creation

Yonghong Song (1):
      samples/bpf: fix a compilation failure

Yoshihiro Shimoda (1):
      phy: renesas: rcar-gen3-usb2: fix vbus_ctrl for role sysfs

YueHaibing (15):
      failover: Fix error return code in net_failover_create
      ipmi: fix return value of ipmi_set_my_LUN
      net: hns3: fix return type of ndo_start_xmit function
      net: cavium: fix return type of ndo_start_xmit function
      net: ibm: fix return type of ndo_start_xmit function
      net: marvell: fix return type of ndo_start_xmit function
      net: toshiba: fix return type of ndo_start_xmit function
      net: xilinx: fix return type of ndo_start_xmit function
      net: broadcom: fix return type of ndo_start_xmit function
      net: amd: fix return type of ndo_start_xmit function
      net: sun: fix return type of ndo_start_xmit function
      net: micrel: fix return type of ndo_start_xmit function
      net: freescale: fix return type of ndo_start_xmit function
      net: smsc: fix return type of ndo_start_xmit function
      net: faraday: fix return type of ndo_start_xmit function

Yunsheng Lin (2):
      net: hns3: Fix for loopback selftest failed problem
      net: hns3: Change the dst mac addr of loopback packet

zhong jiang (4):
      ARM: at91: pm: call put_device instead of of_node_put in at91_pm_conf=
ig_ws
      coresight: Use ERR_CAST instead of ERR_PTR
      misc: genwqe: should return proper error value.
      memfd: Use radix_tree_deref_slot_protected to avoid the warning.


--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3WlAoACgkQONu9yGCS
aT7OfRAA0UTvMiC4muIaCTbse6sW980jmHRRSXkHbGrfKZMhcPUOSEEffWgmT2BY
W70NwJ8d7ESSu/rN4+mhHol5eSI/IyZvGjZOmMDFnL8vmpGjHpi4nkvOfLI796NL
pSB5kxN/NvE3sFpFWDfh1mpK8NejXmamSM3vSlINzGp3ARp1TD99hr5HO4g5Huh1
lsw7rVI1efqDjAnIsEiSeLx2H5Sk6TQWyf9hgubLXVT2KN3XwesWb6U2GIYNj0Wc
CgY3oTAYJRQk/JnG7er2e0iJUs70LVAozqwrHfC0H2FBjf7BNCaxivoBg/1wx1Va
yX45XMuTlZTiKpF1pKFK3EemSbe8cdhnTqOEBT6kknB0Gfss+GbZXT0Vbx177HTx
qxcrXoo59GOoiQy8DjVpwvc+LNZC4YIwZS0dQd8BlP3ZonD48CsCAFKln4idbic7
LCnHW5fsBxXrs+B/gLUiDEH5Zr33VzvXjxkZp54KhiAsb1jNwuOmit60ijZ7xwg7
iHkwHBe0zcN4xSbSDjZDxZXC+RyMnmuq+MKjXVIOp5J3KS05c8rx4LLDGk3C8CE5
iByGd2cjcIOJt/csPmci1xzMUVnWgvb4aFv7Wsog/4pC+f6ZNwcaCDIn5mziC7g/
FjsDVGvvVOhFjeghf0DQZjj+IIu4E2jXk3XoQDXQafDOKnkv6bc=
=ZbrQ
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
