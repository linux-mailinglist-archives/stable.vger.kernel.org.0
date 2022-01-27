Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F2249E390
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 14:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241749AbiA0Ndl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 08:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242058AbiA0Nct (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 08:32:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75ABFC06175C;
        Thu, 27 Jan 2022 05:32:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEDA9B8223C;
        Thu, 27 Jan 2022 13:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BC4C340E8;
        Thu, 27 Jan 2022 13:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643290351;
        bh=uf93jGnqzoq6MMccYXuymlU/anKabOH+d3OS2G5xGXw=;
        h=From:To:Cc:Subject:Date:From;
        b=ygtta9h6gkfLzNUhOCauvAyNDYGuMBBRUei1tAifOix+9byN8YA9K1/fv8KcdbaO0
         b4zLd/tMfyUsT+JZqI5/KpdvtCKos9oBih90YTJnMopJUDVXsTBqAPJ7WReIvrvR4v
         5EUBxji+76x75l9ZnHKpbjaCa/GJaP1ShNAruad8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.94
Date:   Thu, 27 Jan 2022 14:32:11 +0100
Message-Id: <164329033285234@kroah.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.94 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-iio-lptimer-stm32                |   62 
 Documentation/admin-guide/hw-vuln/spectre.rst                        |    2 
 Documentation/devicetree/bindings/display/amlogic,meson-dw-hdmi.yaml |    5 
 Documentation/devicetree/bindings/display/amlogic,meson-vpu.yaml     |    6 
 Documentation/devicetree/bindings/thermal/thermal-zones.yaml         |    9 
 Documentation/devicetree/bindings/watchdog/samsung-wdt.yaml          |    5 
 Documentation/driver-api/dmaengine/dmatest.rst                       |    7 
 Documentation/driver-api/firewire.rst                                |    4 
 Documentation/firmware-guide/acpi/dsd/data-node-references.rst       |   10 
 Makefile                                                             |    2 
 arch/arm/Kconfig.debug                                               |   14 
 arch/arm/boot/compressed/efi-header.S                                |   22 
 arch/arm/boot/compressed/head.S                                      |    3 
 arch/arm/boot/dts/armada-38x.dtsi                                    |    4 
 arch/arm/boot/dts/gemini-nas4220b.dts                                |    2 
 arch/arm/boot/dts/omap3-n900.dts                                     |   50 
 arch/arm/boot/dts/stm32f429-disco.dts                                |    2 
 arch/arm/include/debug/imx-uart.h                                    |   18 
 arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c                   |    5 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi                    |    2 
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi                |    2 
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi                    |    3 
 arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts                    |   14 
 arch/arm64/boot/dts/marvell/cn9130.dtsi                              |   15 
 arch/arm64/boot/dts/nvidia/tegra186.dtsi                             |    2 
 arch/arm64/boot/dts/nvidia/tegra194.dtsi                             |    9 
 arch/arm64/boot/dts/qcom/ipq6018.dtsi                                |    2 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                                |    4 
 arch/arm64/boot/dts/qcom/msm8996.dtsi                                |    3 
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts                 |   27 
 arch/arm64/boot/dts/renesas/cat875.dtsi                              |    1 
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi                            |    2 
 arch/arm64/boot/dts/ti/k3-j7200.dtsi                                 |    6 
 arch/arm64/boot/dts/ti/k3-j721e.dtsi                                 |    6 
 arch/arm64/lib/clear_page.S                                          |   14 
 arch/arm64/lib/copy_page.S                                           |    4 
 arch/mips/Kconfig                                                    |    6 
 arch/mips/bcm63xx/clk.c                                              |    6 
 arch/mips/cavium-octeon/octeon-platform.c                            |    2 
 arch/mips/cavium-octeon/octeon-usb.c                                 |    1 
 arch/mips/include/asm/mach-loongson64/kernel-entry-init.h            |    4 
 arch/mips/include/asm/octeon/cvmx-bootinfo.h                         |    4 
 arch/mips/lantiq/clk.c                                               |    6 
 arch/openrisc/include/asm/syscalls.h                                 |    2 
 arch/openrisc/kernel/entry.S                                         |    5 
 arch/parisc/include/asm/special_insns.h                              |   44 
 arch/parisc/kernel/traps.c                                           |    2 
 arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi                        |    2 
 arch/powerpc/include/asm/cpu_setup_power.h                           |   12 
 arch/powerpc/include/asm/hw_irq.h                                    |   51 
 arch/powerpc/include/asm/reg.h                                       |    1 
 arch/powerpc/kernel/btext.c                                          |    4 
 arch/powerpc/kernel/cpu_setup_power.S                                |  252 --
 arch/powerpc/kernel/cpu_setup_power.c                                |  272 ++
 arch/powerpc/kernel/cputable.c                                       |   12 
 arch/powerpc/kernel/dt_cpu_ftrs.c                                    |    1 
 arch/powerpc/kernel/fadump.c                                         |    8 
 arch/powerpc/kernel/head_40x.S                                       |    9 
 arch/powerpc/kernel/prom_init.c                                      |    2 
 arch/powerpc/kernel/smp.c                                            |   42 
 arch/powerpc/kernel/traps.c                                          |   31 
 arch/powerpc/kernel/watchdog.c                                       |   41 
 arch/powerpc/kvm/book3s_hv.c                                         |    8 
 arch/powerpc/kvm/book3s_hv_nested.c                                  |    2 
 arch/powerpc/mm/book3s64/radix_pgtable.c                             |    4 
 arch/powerpc/mm/kasan/book3s_32.c                                    |    3 
 arch/powerpc/mm/pgtable_64.c                                         |   14 
 arch/powerpc/perf/core-book3s.c                                      |   97 -
 arch/powerpc/perf/core-fsl-emb.c                                     |   25 
 arch/powerpc/perf/isa207-common.c                                    |    8 
 arch/powerpc/platforms/cell/iommu.c                                  |    1 
 arch/powerpc/platforms/cell/pervasive.c                              |    1 
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c                        |    1 
 arch/powerpc/platforms/powermac/low_i2c.c                            |    3 
 arch/powerpc/platforms/powernv/opal-lpc.c                            |    1 
 arch/powerpc/sysdev/xive/spapr.c                                     |    3 
 arch/s390/mm/pgalloc.c                                               |    4 
 arch/um/drivers/virtio_uml.c                                         |    4 
 arch/um/include/asm/delay.h                                          |    4 
 arch/um/include/shared/registers.h                                   |    4 
 arch/um/os-Linux/registers.c                                         |    4 
 arch/um/os-Linux/start_up.c                                          |    2 
 arch/x86/boot/compressed/Makefile                                    |    7 
 arch/x86/configs/i386_defconfig                                      |    1 
 arch/x86/configs/x86_64_defconfig                                    |    1 
 arch/x86/include/asm/realmode.h                                      |    1 
 arch/x86/include/asm/uaccess.h                                       |    5 
 arch/x86/kernel/cpu/mce/core.c                                       |   42 
 arch/x86/kernel/cpu/mce/inject.c                                     |    2 
 arch/x86/kernel/early-quirks.c                                       |   10 
 arch/x86/kernel/reboot.c                                             |   12 
 arch/x86/kernel/tsc.c                                                |    1 
 arch/x86/kvm/vmx/posted_intr.c                                       |   16 
 arch/x86/realmode/init.c                                             |   26 
 arch/x86/um/syscalls_64.c                                            |    3 
 block/blk-flush.c                                                    |    4 
 block/blk-pm.c                                                       |   22 
 crypto/jitterentropy.c                                               |    3 
 drivers/acpi/acpica/exfield.c                                        |    7 
 drivers/acpi/acpica/exoparg1.c                                       |    3 
 drivers/acpi/acpica/hwesleep.c                                       |    4 
 drivers/acpi/acpica/hwsleep.c                                        |    4 
 drivers/acpi/acpica/hwxfsleep.c                                      |    2 
 drivers/acpi/acpica/utdelete.c                                       |    1 
 drivers/acpi/battery.c                                               |   22 
 drivers/acpi/bus.c                                                   |    4 
 drivers/acpi/ec.c                                                    |   57 
 drivers/acpi/internal.h                                              |    2 
 drivers/acpi/scan.c                                                  |   13 
 drivers/acpi/x86/utils.c                                             |  116 -
 drivers/android/binder.c                                             |    4 
 drivers/base/core.c                                                  |    3 
 drivers/base/power/runtime.c                                         |   41 
 drivers/base/property.c                                              |    4 
 drivers/base/regmap/regmap.c                                         |    1 
 drivers/base/swnode.c                                                |    2 
 drivers/block/floppy.c                                               |    6 
 drivers/bluetooth/btmtksdio.c                                        |    2 
 drivers/bluetooth/hci_bcm.c                                          |    7 
 drivers/bluetooth/hci_qca.c                                          |    5 
 drivers/bluetooth/hci_vhci.c                                         |    2 
 drivers/char/mwave/3780i.h                                           |    2 
 drivers/char/random.c                                                |   19 
 drivers/char/tpm/tpm_tis_core.c                                      |   14 
 drivers/clk/bcm/clk-bcm2835.c                                        |   13 
 drivers/clk/clk-bm1880.c                                             |   20 
 drivers/clk/clk-si5341.c                                             |    2 
 drivers/clk/clk-stm32f4.c                                            |    4 
 drivers/clk/clk.c                                                    |   18 
 drivers/clk/imx/clk-imx8mn.c                                         |    6 
 drivers/clk/meson/gxbb.c                                             |   44 
 drivers/counter/Kconfig                                              |    2 
 drivers/counter/stm32-lptimer-cnt.c                                  |  297 ---
 drivers/cpufreq/cpufreq.c                                            |    4 
 drivers/crypto/caam/caamalg_qi2.c                                    |    2 
 drivers/crypto/omap-aes.c                                            |    2 
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c                        |   45 
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c                        |    4 
 drivers/crypto/qce/sha.c                                             |    2 
 drivers/crypto/qce/skcipher.c                                        |    2 
 drivers/crypto/stm32/stm32-crc32.c                                   |    4 
 drivers/crypto/stm32/stm32-cryp.c                                    |  938 +++-------
 drivers/crypto/stm32/stm32-hash.c                                    |    6 
 drivers/dma-buf/dma-fence-array.c                                    |    6 
 drivers/dma/at_xdmac.c                                               |   57 
 drivers/dma/mmp_pdma.c                                               |    6 
 drivers/dma/pxa_dma.c                                                |    7 
 drivers/dma/stm32-mdma.c                                             |    2 
 drivers/dma/uniphier-xdmac.c                                         |    5 
 drivers/edac/synopsys_edac.c                                         |    3 
 drivers/firmware/google/Kconfig                                      |    6 
 drivers/gpio/gpio-aspeed.c                                           |   52 
 drivers/gpio/gpiolib-acpi.c                                          |   15 
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c                       |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c                              |    1 
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c                                |   13 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                    |    3 
 drivers/gpu/drm/amd/display/dc/core/dc.c                             |    3 
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                                   |    6 
 drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c                    |   14 
 drivers/gpu/drm/bridge/display-connector.c                           |    2 
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c             |   40 
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c                  |   10 
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-audio.h                      |    4 
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-i2s-audio.c                  |    9 
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                            |   12 
 drivers/gpu/drm/bridge/ti-sn65dsi86.c                                |    1 
 drivers/gpu/drm/drm_drv.c                                            |    9 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                       |    6 
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c                         |    6 
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h                                |    1 
 drivers/gpu/drm/etnaviv/etnaviv_sched.c                              |    4 
 drivers/gpu/drm/lima/lima_device.c                                   |    1 
 drivers/gpu/drm/mediatek/mtk_mipi_tx.c                               |    2 
 drivers/gpu/drm/msm/Kconfig                                          |    1 
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c                              |    4 
 drivers/gpu/drm/nouveau/dispnv04/disp.c                              |    4 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c                       |   37 
 drivers/gpu/drm/panel/panel-innolux-p079zca.c                        |   10 
 drivers/gpu/drm/panel/panel-kingdisplay-kd097d04.c                   |    8 
 drivers/gpu/drm/radeon/radeon_kms.c                                  |   42 
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c                               |   20 
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c                      |   82 
 drivers/gpu/drm/tegra/vic.c                                          |    7 
 drivers/gpu/drm/ttm/ttm_bo.c                                         |    2 
 drivers/gpu/drm/vboxvideo/vbox_main.c                                |    4 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                       |   24 
 drivers/gpu/host1x/dev.c                                             |   15 
 drivers/hid/hid-apple.c                                              |    2 
 drivers/hid/hid-input.c                                              |    6 
 drivers/hid/hid-uclogic-params.c                                     |   31 
 drivers/hid/hid-vivaldi.c                                            |   34 
 drivers/hid/uhid.c                                                   |   29 
 drivers/hid/wacom_wac.c                                              |   39 
 drivers/hsi/hsi_core.c                                               |    1 
 drivers/hwmon/mr75203.c                                              |    2 
 drivers/i2c/busses/i2c-designware-pcidrv.c                           |    8 
 drivers/i2c/busses/i2c-i801.c                                        |   15 
 drivers/i2c/busses/i2c-mpc.c                                         |   23 
 drivers/iio/adc/ti-adc081c.c                                         |   22 
 drivers/infiniband/core/cma.c                                        |   12 
 drivers/infiniband/core/device.c                                     |    3 
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c                           |    6 
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h                           |    1 
 drivers/infiniband/hw/cxgb4/qp.c                                     |    1 
 drivers/infiniband/hw/hns/hns_roce_main.c                            |    5 
 drivers/infiniband/hw/qedr/verbs.c                                   |    2 
 drivers/infiniband/sw/rxe/rxe_opcode.c                               |    2 
 drivers/iommu/amd/init.c                                             |   48 
 drivers/iommu/io-pgtable-arm-v7s.c                                   |    6 
 drivers/iommu/io-pgtable-arm.c                                       |    9 
 drivers/iommu/iova.c                                                 |    3 
 drivers/irqchip/irq-gic-v3.c                                         |   16 
 drivers/md/dm.c                                                      |    4 
 drivers/md/persistent-data/dm-btree.c                                |    8 
 drivers/md/persistent-data/dm-space-map-common.c                     |    5 
 drivers/media/Kconfig                                                |    8 
 drivers/media/cec/core/cec-pin.c                                     |   31 
 drivers/media/common/saa7146/saa7146_fops.c                          |    2 
 drivers/media/common/videobuf2/videobuf2-dma-contig.c                |    8 
 drivers/media/dvb-core/dmxdev.c                                      |   18 
 drivers/media/dvb-frontends/dib8000.c                                |    4 
 drivers/media/pci/b2c2/flexcop-pci.c                                 |    3 
 drivers/media/pci/saa7146/hexium_gemini.c                            |    7 
 drivers/media/pci/saa7146/hexium_orion.c                             |    8 
 drivers/media/pci/saa7146/mxb.c                                      |    8 
 drivers/media/platform/aspeed-video.c                                |   14 
 drivers/media/platform/coda/coda-common.c                            |    8 
 drivers/media/platform/coda/coda-jpeg.c                              |   21 
 drivers/media/platform/coda/imx-vdoa.c                               |    6 
 drivers/media/platform/imx-pxp.c                                     |    4 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c               |    2 
 drivers/media/platform/qcom/venus/core.c                             |   39 
 drivers/media/platform/qcom/venus/core.h                             |    2 
 drivers/media/platform/qcom/venus/pm_helpers.c                       |   94 -
 drivers/media/platform/qcom/venus/pm_helpers.h                       |    7 
 drivers/media/platform/rcar-vin/rcar-csi2.c                          |   18 
 drivers/media/platform/rcar-vin/rcar-v4l2.c                          |   15 
 drivers/media/radio/si470x/radio-si470x-i2c.c                        |    3 
 drivers/media/rc/igorplugusb.c                                       |    4 
 drivers/media/rc/mceusb.c                                            |    8 
 drivers/media/rc/redrat3.c                                           |   22 
 drivers/media/tuners/msi001.c                                        |    7 
 drivers/media/tuners/si2157.c                                        |    2 
 drivers/media/usb/b2c2/flexcop-usb.c                                 |   10 
 drivers/media/usb/b2c2/flexcop-usb.h                                 |   12 
 drivers/media/usb/cpia2/cpia2_usb.c                                  |    4 
 drivers/media/usb/dvb-usb/dib0700_core.c                             |    2 
 drivers/media/usb/dvb-usb/dw2102.c                                   |  338 ++-
 drivers/media/usb/dvb-usb/m920x.c                                    |   12 
 drivers/media/usb/em28xx/em28xx-cards.c                              |   18 
 drivers/media/usb/em28xx/em28xx-core.c                               |    4 
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                              |    8 
 drivers/media/usb/s2255/s2255drv.c                                   |    4 
 drivers/media/usb/stk1160/stk1160-core.c                             |    4 
 drivers/media/usb/uvc/uvcvideo.h                                     |    2 
 drivers/media/v4l2-core/v4l2-ioctl.c                                 |    4 
 drivers/memory/renesas-rpc-if.c                                      |    2 
 drivers/mfd/atmel-flexcom.c                                          |   11 
 drivers/misc/lattice-ecp3-config.c                                   |   12 
 drivers/misc/lkdtm/Makefile                                          |    2 
 drivers/mmc/core/sdio.c                                              |    4 
 drivers/mmc/host/meson-mx-sdhc-mmc.c                                 |    5 
 drivers/mmc/host/meson-mx-sdio.c                                     |    5 
 drivers/mtd/hyperbus/rpc-if.c                                        |    8 
 drivers/mtd/mtdpart.c                                                |    2 
 drivers/mtd/nand/bbt.c                                               |    2 
 drivers/mtd/nand/raw/davinci_nand.c                                  |   16 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                           |   37 
 drivers/net/bonding/bond_main.c                                      |   36 
 drivers/net/can/softing/softing_cs.c                                 |    2 
 drivers/net/can/softing/softing_fw.c                                 |   11 
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c                       |    6 
 drivers/net/can/xilinx_can.c                                         |    7 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                       |   10 
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c                    |    3 
 drivers/net/ethernet/cortina/gemini.c                                |    9 
 drivers/net/ethernet/freescale/fman/mac.c                            |   21 
 drivers/net/ethernet/freescale/xgmac_mdio.c                          |   28 
 drivers/net/ethernet/i825xx/sni_82596.c                              |    3 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                          |    2 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                        |   36 
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c                |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                    |   10 
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                      |    7 
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c                     |    6 
 drivers/net/ethernet/mellanox/mlxsw/cmd.h                            |   12 
 drivers/net/ethernet/mellanox/mlxsw/pci.c                            |    7 
 drivers/net/ethernet/mscc/ocelot_flower.c                            |   15 
 drivers/net/ethernet/rocker/rocker_ofdpa.c                           |    3 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c                    |  135 -
 drivers/net/phy/marvell.c                                            |    6 
 drivers/net/phy/mdio_bus.c                                           |    2 
 drivers/net/phy/phy-core.c                                           |    2 
 drivers/net/phy/sfp.c                                                |   25 
 drivers/net/ppp/ppp_generic.c                                        |    7 
 drivers/net/usb/mcs7830.c                                            |   12 
 drivers/net/wireless/ath/ar5523/ar5523.c                             |    4 
 drivers/net/wireless/ath/ath10k/core.c                               |   19 
 drivers/net/wireless/ath/ath10k/htt_tx.c                             |    3 
 drivers/net/wireless/ath/ath10k/hw.h                                 |    3 
 drivers/net/wireless/ath/ath10k/txrx.c                               |    2 
 drivers/net/wireless/ath/ath11k/ahb.c                                |   28 
 drivers/net/wireless/ath/ath11k/core.h                               |    2 
 drivers/net/wireless/ath/ath11k/dp.h                                 |    3 
 drivers/net/wireless/ath/ath11k/dp_tx.c                              |    2 
 drivers/net/wireless/ath/ath11k/hal.c                                |   22 
 drivers/net/wireless/ath/ath11k/hal.h                                |    2 
 drivers/net/wireless/ath/ath11k/hw.c                                 |    2 
 drivers/net/wireless/ath/ath11k/mac.c                                |   52 
 drivers/net/wireless/ath/ath11k/pci.c                                |   12 
 drivers/net/wireless/ath/ath11k/reg.c                                |  103 -
 drivers/net/wireless/ath/ath11k/wmi.c                                |    5 
 drivers/net/wireless/ath/ath9k/hif_usb.c                             |    7 
 drivers/net/wireless/ath/wcn36xx/dxe.c                               |   49 
 drivers/net/wireless/ath/wcn36xx/main.c                              |   34 
 drivers/net/wireless/ath/wcn36xx/smd.c                               |    8 
 drivers/net/wireless/ath/wcn36xx/txrx.c                              |   41 
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h                           |    1 
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c                         |   17 
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c               |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                    |   17 
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c                        |   27 
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c                        |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c                  |   27 
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c                         |    7 
 drivers/net/wireless/intel/iwlwifi/queue/tx.c                        |    1 
 drivers/net/wireless/marvell/mwifiex/sta_event.c                     |    8 
 drivers/net/wireless/marvell/mwifiex/usb.c                           |    3 
 drivers/net/wireless/realtek/rtw88/main.c                            |    2 
 drivers/net/wireless/realtek/rtw88/rtw8821c.h                        |    2 
 drivers/net/wireless/realtek/rtw88/rtw8822b.c                        |    2 
 drivers/net/wireless/realtek/rtw88/rtw8822c.c                        |    2 
 drivers/net/wireless/rsi/rsi_91x_main.c                              |    4 
 drivers/net/wireless/rsi/rsi_91x_usb.c                               |    9 
 drivers/net/wireless/rsi/rsi_usb.h                                   |    2 
 drivers/nvmem/core.c                                                 |    2 
 drivers/of/base.c                                                    |   11 
 drivers/of/unittest.c                                                |   21 
 drivers/parisc/pdc_stable.c                                          |    4 
 drivers/pci/controller/pci-aardvark.c                                |    4 
 drivers/pci/controller/pci-mvebu.c                                   |    8 
 drivers/pci/controller/pci-xgene.c                                   |    2 
 drivers/pci/hotplug/pciehp.h                                         |    3 
 drivers/pci/hotplug/pciehp_core.c                                    |    2 
 drivers/pci/hotplug/pciehp_hpc.c                                     |   21 
 drivers/pci/msi.c                                                    |   26 
 drivers/pci/pci-bridge-emul.c                                        |   70 
 drivers/pci/quirks.c                                                 |    3 
 drivers/pcmcia/cs.c                                                  |    8 
 drivers/pcmcia/rsrc_nonstatic.c                                      |    6 
 drivers/phy/socionext/phy-uniphier-usb3ss.c                          |   10 
 drivers/power/reset/mt6323-poweroff.c                                |    3 
 drivers/regulator/qcom_smd-regulator.c                               |  100 -
 drivers/rpmsg/rpmsg_core.c                                           |   20 
 drivers/rtc/rtc-cmos.c                                               |    3 
 drivers/rtc/rtc-pxa.c                                                |    4 
 drivers/scsi/lpfc/lpfc.h                                             |    2 
 drivers/scsi/lpfc/lpfc_attr.c                                        |   62 
 drivers/scsi/lpfc/lpfc_hbadisc.c                                     |    8 
 drivers/scsi/lpfc/lpfc_sli.c                                         |    6 
 drivers/scsi/pm8001/pm8001_hwi.c                                     |    4 
 drivers/scsi/scsi_debugfs.c                                          |    1 
 drivers/scsi/scsi_pm.c                                               |    2 
 drivers/scsi/sr.c                                                    |    2 
 drivers/scsi/sr_vendor.c                                             |    4 
 drivers/scsi/ufs/tc-dwc-g210-pci.c                                   |    1 
 drivers/scsi/ufs/ufshcd-pci.c                                        |    2 
 drivers/scsi/ufs/ufshcd-pltfrm.c                                     |    2 
 drivers/scsi/ufs/ufshcd.c                                            |    7 
 drivers/soc/mediatek/mtk-scpsys.c                                    |   15 
 drivers/soc/qcom/cpr.c                                               |    2 
 drivers/soc/ti/pruss.c                                               |    2 
 drivers/spi/spi-meson-spifc.c                                        |    1 
 drivers/spi/spi-uniphier.c                                           |   11 
 drivers/staging/greybus/audio_topology.c                             |   15 
 drivers/staging/media/atomisp/i2c/ov2680.h                           |   24 
 drivers/staging/media/atomisp/pci/atomisp_cmd.c                      |   92 
 drivers/staging/media/atomisp/pci/atomisp_fops.c                     |   11 
 drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c            |    2 
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c                    |  185 +
 drivers/staging/media/atomisp/pci/atomisp_subdev.c                   |   15 
 drivers/staging/media/atomisp/pci/atomisp_subdev.h                   |    3 
 drivers/staging/media/atomisp/pci/atomisp_v4l2.c                     |   13 
 drivers/staging/media/atomisp/pci/atomisp_v4l2.h                     |    3 
 drivers/staging/media/atomisp/pci/sh_css.c                           |   27 
 drivers/staging/media/atomisp/pci/sh_css_mipi.c                      |   41 
 drivers/staging/media/atomisp/pci/sh_css_params.c                    |    8 
 drivers/staging/media/hantro/hantro_drv.c                            |    3 
 drivers/staging/rtl8192e/rtllib.h                                    |    2 
 drivers/staging/rtl8192e/rtllib_module.c                             |   16 
 drivers/staging/rtl8192e/rtllib_softmac.c                            |    6 
 drivers/tee/tee_core.c                                               |    4 
 drivers/thermal/imx8mm_thermal.c                                     |    3 
 drivers/thermal/imx_thermal.c                                        |  145 -
 drivers/thunderbolt/acpi.c                                           |   13 
 drivers/tty/serial/amba-pl010.c                                      |    3 
 drivers/tty/serial/amba-pl011.c                                      |   27 
 drivers/tty/serial/atmel_serial.c                                    |   14 
 drivers/tty/serial/imx.c                                             |    7 
 drivers/tty/serial/serial_core.c                                     |    7 
 drivers/tty/serial/uartlite.c                                        |    2 
 drivers/usb/core/hub.c                                               |    5 
 drivers/usb/dwc3/dwc3-qcom.c                                         |    7 
 drivers/usb/gadget/function/f_fs.c                                   |    4 
 drivers/usb/host/uhci-platform.c                                     |    3 
 drivers/usb/misc/ftdi-elan.c                                         |    1 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                                    |    2 
 drivers/video/backlight/qcom-wled.c                                  |  122 -
 drivers/virtio/virtio_ring.c                                         |    4 
 drivers/w1/slaves/w1_ds28e04.c                                       |   26 
 drivers/xen/gntdev.c                                                 |    6 
 fs/btrfs/backref.c                                                   |   21 
 fs/btrfs/ctree.c                                                     |   19 
 fs/btrfs/inode.c                                                     |   11 
 fs/btrfs/qgroup.c                                                    |   19 
 fs/debugfs/file.c                                                    |    2 
 fs/dlm/lock.c                                                        |    9 
 fs/dlm/lowcomms.c                                                    |   45 
 fs/ext4/ext4.h                                                       |    1 
 fs/ext4/ext4_jbd2.c                                                  |    2 
 fs/ext4/extents.c                                                    |    2 
 fs/ext4/fast_commit.c                                                |   18 
 fs/ext4/inode.c                                                      |   14 
 fs/ext4/ioctl.c                                                      |    2 
 fs/ext4/mballoc.c                                                    |   48 
 fs/ext4/migrate.c                                                    |   23 
 fs/ext4/super.c                                                      |   27 
 fs/f2fs/compress.c                                                   |   50 
 fs/f2fs/f2fs.h                                                       |   11 
 fs/f2fs/gc.c                                                         |    3 
 fs/f2fs/segment.h                                                    |    3 
 fs/f2fs/super.c                                                      |   44 
 fs/f2fs/sysfs.c                                                      |    4 
 fs/fuse/file.c                                                       |    2 
 fs/jffs2/file.c                                                      |   40 
 fs/ubifs/super.c                                                     |    1 
 fs/udf/ialloc.c                                                      |    2 
 include/acpi/acpi_bus.h                                              |    5 
 include/acpi/actypes.h                                               |   10 
 include/linux/blk-pm.h                                               |    2 
 include/linux/bpf_verifier.h                                         |    7 
 include/linux/clocksource.h                                          |    3 
 include/linux/hid.h                                                  |    2 
 include/linux/mmzone.h                                               |    9 
 include/linux/pm_runtime.h                                           |    3 
 include/net/inet_frag.h                                              |   11 
 include/net/ipv6_frag.h                                              |    3 
 include/net/sch_generic.h                                            |    5 
 include/net/xfrm.h                                                   |    5 
 include/trace/events/cgroup.h                                        |   12 
 include/uapi/linux/xfrm.h                                            |    1 
 kernel/audit.c                                                       |   18 
 kernel/bpf/btf.c                                                     |    3 
 kernel/bpf/verifier.c                                                |   18 
 kernel/dma/pool.c                                                    |    4 
 kernel/rcu/tree_exp.h                                                |    1 
 kernel/sched/cputime.c                                               |    4 
 kernel/sched/fair.c                                                  |    4 
 kernel/sched/rt.c                                                    |   23 
 kernel/time/clocksource.c                                            |   96 -
 kernel/time/jiffies.c                                                |   15 
 kernel/trace/bpf_trace.c                                             |    6 
 kernel/trace/trace_kprobe.c                                          |    5 
 kernel/tsacct.c                                                      |    7 
 lib/mpi/mpi-mod.c                                                    |    2 
 lib/test_hmm.c                                                       |   24 
 lib/test_meminit.c                                                   |    1 
 mm/hmm.c                                                             |    5 
 mm/page_alloc.c                                                      |   19 
 mm/shmem.c                                                           |   37 
 net/ax25/af_ax25.c                                                   |   10 
 net/batman-adv/netlink.c                                             |   30 
 net/bluetooth/cmtp/core.c                                            |    4 
 net/bluetooth/hci_core.c                                             |    1 
 net/bluetooth/hci_event.c                                            |    8 
 net/bluetooth/hci_request.c                                          |    2 
 net/bluetooth/l2cap_sock.c                                           |   45 
 net/bridge/br_netfilter_hooks.c                                      |    7 
 net/core/dev.c                                                       |    6 
 net/core/devlink.c                                                   |    2 
 net/core/filter.c                                                    |    8 
 net/core/net-sysfs.c                                                 |    3 
 net/core/net_namespace.c                                             |    4 
 net/ipv4/fib_semantics.c                                             |   47 
 net/ipv4/inet_fragment.c                                             |    8 
 net/ipv4/ip_fragment.c                                               |    3 
 net/ipv4/ip_gre.c                                                    |    5 
 net/ipv4/netfilter/ipt_CLUSTERIP.c                                   |    5 
 net/ipv6/ip6_gre.c                                                   |    5 
 net/mac80211/rx.c                                                    |    2 
 net/netfilter/nft_set_pipapo.c                                       |    8 
 net/netrom/af_netrom.c                                               |   12 
 net/nfc/llcp_sock.c                                                  |    5 
 net/sched/sch_generic.c                                              |    1 
 net/smc/smc_core.c                                                   |   17 
 net/unix/garbage.c                                                   |   14 
 net/unix/scm.c                                                       |    6 
 net/xfrm/xfrm_compat.c                                               |    6 
 net/xfrm/xfrm_interface.c                                            |   14 
 net/xfrm/xfrm_policy.c                                               |   24 
 net/xfrm/xfrm_state.c                                                |   23 
 net/xfrm/xfrm_user.c                                                 |   41 
 scripts/dtc/dtx_diff                                                 |    8 
 scripts/sphinx-pre-install                                           |    4 
 security/selinux/hooks.c                                             |   12 
 sound/core/jack.c                                                    |    3 
 sound/core/oss/pcm_oss.c                                             |    2 
 sound/core/pcm.c                                                     |    6 
 sound/core/seq/seq_queue.c                                           |   14 
 sound/pci/hda/hda_codec.c                                            |    3 
 sound/soc/codecs/rt5663.c                                            |   12 
 sound/soc/fsl/fsl_asrc.c                                             |   69 
 sound/soc/fsl/fsl_mqs.c                                              |    2 
 sound/soc/intel/catpt/dsp.c                                          |   14 
 sound/soc/mediatek/mt8173/mt8173-max98090.c                          |    3 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c                     |    2 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c                     |    2 
 sound/soc/mediatek/mt8173/mt8173-rt5650.c                            |    2 
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c                   |    6 
 sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c           |    7 
 sound/soc/samsung/idma.c                                             |    2 
 sound/soc/uniphier/Kconfig                                           |    2 
 sound/usb/format.c                                                   |    2 
 sound/usb/mixer_quirks.c                                             |    2 
 sound/usb/quirks.c                                                   |    2 
 tools/bpf/bpftool/Documentation/Makefile                             |    1 
 tools/bpf/bpftool/Makefile                                           |    1 
 tools/bpf/bpftool/main.c                                             |    2 
 tools/include/nolibc/nolibc.h                                        |   33 
 tools/perf/util/debug.c                                              |    2 
 tools/perf/util/evsel.c                                              |   25 
 tools/perf/util/probe-event.c                                        |    3 
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c                     |    2 
 tools/testing/selftests/clone3/clone3.c                              |    6 
 tools/testing/selftests/ftrace/test.d/kprobe/profile.tc              |    2 
 tools/testing/selftests/kselftest_harness.h                          |    2 
 tools/testing/selftests/powerpc/security/spectre_v2.c                |    2 
 tools/testing/selftests/vm/hmm-tests.c                               |   42 
 539 files changed, 5552 insertions(+), 3319 deletions(-)

Adam Ford (1):
      clk: imx8mn: Fix imx8mn_clko1_sels

Adrian Hunter (1):
      perf script: Fix hex dump character output

Alan Stern (1):
      scsi: block: pm: Always set request queue runtime active in blk_post_runtime_resume()

Alex Deucher (1):
      drm/amdgpu/display: set vblank_disable_immediate for DC

Alexander Aring (4):
      fs: dlm: use sk->sk_socket instead of con->sock
      fs: dlm: don't call kernel_getpeername() in error_report()
      fs: dlm: fix build with CONFIG_IPV6 disabled
      fs: dlm: filter user dlm messages for kernel locks

Alexander Gordeev (1):
      s390/mm: fix 2KB pgtable release race

Alexander Stein (4):
      arm64: dts: amlogic: meson-g12: Fix GPU operating point table node name
      arm64: dts: amlogic: Fix SPI NOR flash node name for ODROID N2/N2+
      dt-bindings: display: meson-dw-hdmi: add missing sound-name-prefix property
      dt-bindings: display: meson-vpu: Add missing amlogic,canvas property

Alexei Starovoitov (1):
      bpf: Adjust BTF log size limit.

Alexey Kardashevskiy (2):
      KVM: PPC: Book3S: Suppress warnings when allocating too big memory slots
      KVM: PPC: Book3S: Suppress failed alloc warning in H_COPY_TOFROM_GUEST

Aline Santana Cordeiro (1):
      media: staging: media: atomisp: pci: Balance braces around conditional statements in file atomisp_cmd.c

Alistair Francis (1):
      HID: quirks: Allow inverting the absolute X/Y values

Alistair Popple (1):
      mm/hmm.c: allow VM_MIXEDMAP to work with hmm_range_fault

Alyssa Ross (1):
      ASoC: fsl_mqs: fix MODULE_ALIAS

Amelie Delaunay (1):
      dmaengine: stm32-mdma: fix STM32_MDMA_CTBR_TSEL_MASK

Ammar Faizi (2):
      tools/nolibc: x86-64: Fix startup code bug
      powerpc/xive: Add missing null check after calling kmalloc

Anders Roxell (2):
      selftests: clone3: clone3: add case CLONE3_ARGS_NO_TEST
      powerpc/cell: Fix clang -Wimplicit-fallthrough warning

Andre Przywara (1):
      ARM: 9159/1: decompressor: Avoid UNPREDICTABLE NOP encoding

Andreas Oetken (1):
      mtd: Fixed breaking list in __mtd_del_partition.

Andrey Konovalov (1):
      lib/test_meminit: destroy cache in kmem_cache_alloc_bulk() test

Andrey Ryabinin (1):
      cputime, cpuacct: Include guest time in user time in cpuacct.stat

Andrii Nakryiko (1):
      selftests/bpf: Fix bpf_object leak in skb_ctx selftest

Anilkumar Kolli (1):
      ath11k: Use host CE parameters for CE interrupts configuration

Antoine Tenart (1):
      net-sysfs: update the queue counts in the unregistration path

Anton Vasilyev (1):
      media: dw2102: Fix use after free

Antony Antony (3):
      xfrm: interface with if_id 0 should return error
      xfrm: state and policy should fail if XFRMA_IF_ID 0
      xfrm: rate limit SA mapping change message to user space

Arnaud Pouliquen (1):
      rpmsg: core: Clean up resources on announce_create failure.

Arnd Bergmann (1):
      dmaengine: pxa/mmp: stop referencing config->slave_id

Arseny Demidov (1):
      hwmon: (mr75203) fix wrong power-up delay value

Athira Rajeev (2):
      powerpc/perf: MMCR0 control for PMU registers under PMCC=00
      powerpc/perf: Fix PMU callbacks to clear pending PMI before resetting an overflown PMC

Avihai Horon (2):
      RDMA/core: Let ib_find_gid() continue search even after empty entry
      RDMA/cma: Let cma_resolve_ib_dev() continue search even after empty entry

Aya Levin (2):
      net/mlx5e: Fix page DMA map/unmap attributes
      Revert "net/mlx5e: Block offload of outer header csum for UDP tunnels"

Baochen Qiang (2):
      ath11k: Fix crash caused by uninitialized TX ring
      ath11k: Avoid false DEADLOCK warning reported by lockdep

Baoquan He (3):
      mm_zone: add function to check if managed dma zone exists
      dma/pool: create dma atomic pool only if dma zone has managed pages
      mm/page_alloc.c: do not warn allocation failure on zone DMA if no managed pages

Bart Van Assche (2):
      scsi: ufs: Fix race conditions related to driver data
      scsi: core: Show SCMD_LAST in text form

Baruch Siach (3):
      arm64: dts: qcom: ipq6018: Fix gpio-ranges property
      of: base: Fix phandle argument length mismatch error message
      of: base: Improve argument length mismatch error

Ben Greear (1):
      ath11k: Fix napi related hang

Ben Hutchings (1):
      firmware: Update Kconfig help text for Google firmware

Ben Skeggs (1):
      drm/nouveau/pmu/gm200-: avoid touching PMU outside of DEVINIT/PREOS/ACR

Benjamin Li (3):
      wcn36xx: ensure pairing of init_scan/finish_scan and start_scan/end_scan
      wcn36xx: populate band before determining rate on RX
      wcn36xx: fix RX BD rate mapping for 5GHz legacy rates

Bernard Zhao (1):
      selinux: fix potential memleak in selinux_add_opt()

Bhaskar Chowdhury (1):
      crypto: qat - fix spelling mistake: "messge" -> "message"

Biju Das (1):
      arm64: dts: renesas: cat875: Add rx/tx delays

Biwen Li (1):
      arm64: dts: ls1028a-qds: move rtc node to the correct i2c bus

Bixuan Cui (1):
      ALSA: oss: fix compile error when OSS_DEBUG is enabled

Borislav Petkov (4):
      x86/mce: Allow instrumentation during task work queueing
      x86/mce: Mark mce_panic() noinstr
      x86/mce: Mark mce_end() noinstr
      x86/mce: Mark mce_read_aux() noinstr

Brian Norris (8):
      drm/panel: kingdisplay-kd097d04: Delete panel on attach() failure
      drm/panel: innolux-p079zca: Delete panel on attach() failure
      drm/rockchip: dsi: Fix unbalanced clock on probe error
      drm/rockchip: dsi: Hold pm-runtime across bind/unbind
      drm/rockchip: dsi: Disable PLL clock on bind error
      drm/rockchip: dsi: Reconfigure hardware on resume()
      mwifiex: Fix possible ABBA deadlock
      drm/bridge: analogix_dp: Make PSR-exit block less

Bryan O'Donoghue (5):
      wcn36xx: Indicate beacon not connection loss on MISSED_BEACON_IND
      wcn36xx: Fix DMA channel enable/disable cycle
      wcn36xx: Release DMA channel descriptor allocations
      wcn36xx: Put DXE block into reset before freeing memory
      media: venus: core, venc, vdec: Fix probe dependency error

Cezary Rojewski (1):
      ASoC: Intel: catpt: Test dmaengine_submit() result before moving on

Changcheng Deng (1):
      PM: AVS: qcom-cpr: Use div64_ul instead of do_div

Chao Yu (2):
      f2fs: fix to do sanity check in is_alive()
      f2fs: fix to reserve space for IO align feature

Chen Jun (1):
      tpm: add request_locality before write TPM_INT_ENABLE

Chengfeng Ye (3):
      crypto: qce - fix uaf on qce_ahash_register_one
      crypto: qce - fix uaf on qce_skcipher_register_one
      HSI: core: Fix return freed object in hsi_new_client

Chengguang Xu (1):
      RDMA/rxe: Fix a typo in opcode name

Christian Eggers (1):
      mtd: rawnand: gpmi: Add ERR007117 protection for nfc_apply_timings

Christian Hewitt (2):
      arm64: dts: meson-gxbb-wetek: fix HDMI in early boot
      arm64: dts: meson-gxbb-wetek: fix missing GPIO binding

Christian König (1):
      drm/radeon: fix error handling in radeon_driver_open_kms

Christian Lamparter (1):
      ARM: dts: gemini: NAS4220-B: fis-index-block with 128 KiB sectors

Christoph Hellwig (2):
      dm: fix alloc_dax error handling in alloc_dev
      scsi: sr: Don't use GFP_DMA

Christophe JAILLET (3):
      media: venus: core: Fix a potential NULL pointer dereference in an error handling path
      media: venus: core: Fix a resource leak in the error handling path of 'venus_probe()'
      RDMA/bnxt_re: Scan the whole bitmap when checking if "disabling RCFW with pending cmd-bit"

Christophe Jaillet (1):
      tpm_tis: Fix an error handling path in 'tpm_tis_core_init()'

Christophe Leroy (7):
      lkdtm: Fix content of section containing lkdtm_rodata_do_nothing()
      powerpc/irq: Add helper to set regs->softe
      powerpc/32s: Fix shift-out-of-bounds in KASAN init
      powerpc/powermac: Add additional missing lockdep_register_key()
      powerpc/powermac: Add missing lockdep_register_key()
      w1: Misuse of get_user()/put_user() reported by sparse
      powerpc/40x: Map 32Mbytes of memory at startup

Chunguang Xu (1):
      ext4: fix a possible ABBA deadlock due to busy PA

Claudiu Beznea (2):
      mfd: atmel-flexcom: Remove #ifdef CONFIG_PM_SLEEP
      mfd: atmel-flexcom: Use .resume_noirq

Clément Léger (1):
      software node: fix wrong node passed to find nargs_prop

Conor Dooley (1):
      clk: bm1880: remove kfrees on static allocations

Dafna Hirschfeld (1):
      media: mtk-vcodec: call v4l2_m2m_ctx_release first when file is released

Dan Carpenter (7):
      drm/bridge: display-connector: fix an uninitialized pointer in probe()
      media: atomisp: fix uninitialized bug in gmin_get_pmic_id_and_addr()
      drm/vboxvideo: fix a NULL vs IS_ERR() check
      rocker: fix a sleeping in atomic bug
      Bluetooth: L2CAP: uninitialized variables in l2cap_sock_setsockopt()
      ax25: uninitialized variable in ax25_setsockopt()
      netrom: fix api breakage in nr_setsockopt()

Daniel Borkmann (1):
      bpf: Don't promote bogus looking registers after null check.

Daniel Thompson (1):
      Documentation: dmaengine: Correctly describe dmatest with channel unset

Danielle Ratson (2):
      mlxsw: pci: Add shutdown method in PCI driver
      mlxsw: pci: Avoid flow control for EMAD packets

David Heidelberg (1):
      arm64: dts: qcom: msm8996: drop not documented adreno properties

Dillon Min (3):
      media: videobuf2: Fix the size printk format
      ARM: dts: stm32: fix dtbs_check warning on ili9341 dts binding on stm32f429 disco
      clk: stm32: Fix ltdc's clock turn off by clk_disable_unused() after system enter shell

Dinh Nguyen (1):
      EDAC/synopsys: Use the quirk for version instead of ddr version

Dmitry Baryshkov (2):
      arm64: dts: qcom: msm8916: fix MMC controller aliases
      drm/msm/dpu: fix safe status debugfs file

Dmitry Osipenko (1):
      gpu: host1x: Add back arm_iommu_detach_device()

Dmitry Torokhov (1):
      HID: vivaldi: fix handling devices not using numbered reports

Dominik Brodowski (1):
      pcmcia: fix setting of kthread task states

Dongliang Mu (1):
      media: em28xx: fix memory leak in em28xx_init_dev

Doyle, Patrick (1):
      mtd: nand: bbt: Fix corner case in bad block table handling

Eli Cohen (1):
      vdpa/mlx5: Fix wrong configuration of virtio_version_1_0

Eric Dumazet (7):
      xfrm: fix a small bug in xfrm_sa_len()
      ppp: ensure minimum packet size in ppp_write()
      ipv4: update fib_info_cnt under spinlock protection
      ipv4: avoid quadratic behavior in netns dismantle
      af_unix: annote lockless accesses to unix_tot_inflight & gc_in_progress
      inet: frags: annotate races around fqdir->dead and fqdir->high_thresh
      netns: add schedule point in ops_exit_list()

Eric W. Biederman (1):
      taskstats: Cleanup the use of task->exit_code

Fabio Estevam (3):
      media: imx-pxp: Initialize the spinlock prior to using it
      regmap: Call regmap_debugfs_exit() prior to _init()
      ath10k: Fix the MTU size on QCA9377 SDIO

Fabrice Gasnier (1):
      counter: stm32-lptimer-cnt: remove iio counter abi

Filipe Manana (2):
      btrfs: fix deadlock between quota enable and other quota operations
      btrfs: respect the max size in the header when activating swap file

Florian Fainelli (1):
      net: mdio: Demote probed message to debug print

Florian Westphal (2):
      netfilter: bridge: add support for pppoe filtering
      netfilter: nft_set_pipapo: allocate pcpu scratch maps on clone

Frank Rowand (1):
      of: unittest: 64 bit dma address test requires arch support

Frederic Weisbecker (1):
      rcu/exp: Mark current CPU as exp-QS in IPI loop second pass

Fugang Duan (1):
      tty: serial: imx: disable UCR4_OREN in .stop_rx() instead of .shutdown()

Gang Li (1):
      shmem: fix a race between shmem_unused_huge_shrink and shmem_evict_inode

George G. Davis (1):
      mtd: hyperbus: rpc-if: fix bug in rpcif_hb_remove

German Gomez (1):
      perf evsel: Override attr->sample_period for non-libpfm4 events

Ghalem Boudour (1):
      xfrm: fix policy lookup for ipv6 gre packets

Giovanni Cabiddu (1):
      crypto: qat - fix undetected PFVF timeout in ACK loop

Greg Kroah-Hartman (1):
      Linux 5.10.94

Guillaume Nault (3):
      xfrm: Don't accidentally set RTO_ONLINK in decode_session4()
      gre: Don't accidentally set RTO_ONLINK in gre_fill_metadata_dst()
      libcxgb: Don't accidentally set RTO_ONLINK in cxgb_find_route()

Hans Verkuil (2):
      media: v4l2-ioctl.c: readbuffers depends on V4L2_CAP_READWRITE
      media: cec-pin: fix interrupt en/disable handling

Hans de Goede (9):
      ACPI: scan: Create platform device for BCM4752 and LNV4752 ACPI nodes
      media: atomisp-ov2680: Fix ov2680_set_fmt() clobbering the exposure
      drm: panel-orientation-quirks: Add quirk for the Lenovo Yoga Book X91F/L
      gpiolib: acpi: Do not set the IRQ type if the IRQ is already in use
      ACPI / x86: Drop PWM2 device on Lenovo Yoga Book from always present table
      ACPI: Change acpi_device_always_present() into acpi_device_override_status()
      ACPI / x86: Allow specifying acpi_device_override_status() quirks by path
      ACPI / x86: Add not-present quirk for the PCI0.SDHB.BRC1 device on the GPD win
      PCI: pciehp: Use down_read/write_nested(reset_lock) to fix lockdep errors

Hari Bathini (2):
      powerpc: handle kdump appropriately with crash_kexec_post_notifiers option
      powerpc/fadump: Fix inaccurate CPU state info in vmcore generated with panic

Harshad Shirwadkar (1):
      ext4: initialize err_blk before calling __ext4_get_inode_loc

Hector Martin (1):
      iommu/io-pgtable-arm: Fix table descriptor paddr formatting

Heiko Carstens (1):
      selftests/ftrace: make kprobe profile testcase description unique

Heiner Kallweit (2):
      i2c: i801: Don't silently correct invalid transfer size
      crypto: omap-aes - Fix broken pm_runtime_and_get() usage

Herbert Xu (2):
      crypto: stm32 - Fix last sparse warning in stm32_cryp_check_ctr_counter
      crypto: stm32 - Revert broken pm_runtime_resume_and_get changes

Hou Tao (1):
      bpf: Disallow BPF_LOG_KERNEL log level for bpf(BPF_BTF_LOAD)

Hyeong-Jun Kim (1):
      f2fs: compress: fix potential deadlock of compress file

Igor Pylypiv (1):
      scsi: pm80xx: Update WARN_ON check in pm8001_mpi_build_cmd()

Ilan Peer (2):
      iwlwifi: mvm: Fix calculation of frame length
      iwlwifi: mvm: Increase the scan timeout guard to 30 seconds

Ilia Mirkin (1):
      drm/nouveau/kms/nv04: use vzalloc for nv04_display

Ingo Molnar (1):
      x86/kbuild: Enable CONFIG_KALLSYMS_ALL=y in the defconfigs

Iwona Winiarska (1):
      gpio: aspeed: Convert aspeed_gpio.lock to raw_spinlock

Jackie Liu (1):
      drm/msm/dp: displayPort driver need algorithm rational

Jakub Kicinski (1):
      selftests: harness: avoid false negatives if test has no ASSERTs

James Hilliard (1):
      media: uvcvideo: Increase UVC_CTRL_CONTROL_TIMEOUT to 5 seconds.

James Smart (1):
      scsi: lpfc: Trigger SLI4 firmware dump before doing driver cleanup

Jammy Huang (2):
      media: aspeed: fix mode-detect always time out at 2nd run
      media: aspeed: Update signal status immediately to ensure sane hw state

Jan Kara (4):
      ext4: avoid trim error on fs with small groups
      udf: Fix error handling in udf_new_inode()
      ext4: make sure to reset inode lockdep class when quota enabling fails
      ext4: make sure quota gets properly shutdown on error

Jan Kiszka (1):
      soc: ti: pruss: fix referenced node in error message

Jann Horn (1):
      HID: uhid: Fix worker destroying device without any protection

Jason A. Donenfeld (1):
      random: do not throw away excess input to crng_fast_load

Jason Gerecke (3):
      HID: wacom: Reset expected and received contact counts at the same time
      HID: wacom: Ignore the confidence flag when a touch is removed
      HID: wacom: Avoid using stale array indicies to read contact count

Jens Wiklander (1):
      tee: fix put order in teedev_close_context()

Jernej Skrabec (1):
      media: hantro: Fix probe func error path

Jiasheng Jiang (9):
      media: coda/imx-vdoa: Handle dma_set_coherent_mask error codes
      power: reset: mt6397: Check for null res pointer
      staging: greybus: audio: Check null pointer
      fsl/fman: Check for null pointer after calling devm_ioremap
      Bluetooth: hci_bcm: Check for error irq
      can: xilinx_can: xcan_probe(): check for error irq
      ASoC: rt5663: Handle device_property_read_u32_array error codes
      ASoC: mediatek: Check for error clk pointer
      ASoC: samsung: idma: Check of ioremap return value

Jie Wang (1):
      net: bonding: fix bond_xmit_broadcast return value error bug

Jim Quinlan (1):
      of: unittest: fix warning on PowerPC frame size warning

Joakim Tjernlund (1):
      i2c: mpc: Correct I2C reset procedure

Joe Thornber (2):
      dm btree: add a defensive bounds check to insert_at()
      dm space map common: add bounds check to sm_ll_lookup_bitmap()

Joerg Roedel (1):
      x86/mm: Flush global TLB when switching to trampoline page-table

Johan Hovold (9):
      media: flexcop-usb: fix control-message timeouts
      media: mceusb: fix control-message timeouts
      media: em28xx: fix control-message timeouts
      media: cpia2: fix control-message timeouts
      media: s2255: fix control-message timeouts
      media: redrat3: fix control-message timeouts
      media: pvrusb2: fix control-message timeouts
      media: stk1160: fix control-message timeouts
      can: softing_cs: softingcs_probe(): fix memleak on registration failure

Johannes Berg (6):
      iwlwifi: mvm: fix 32-bit build in FTM
      um: fix ndelay/udelay defines
      um: virtio_uml: Fix time-travel external time propagation
      iwlwifi: mvm: synchronize with FW after multicast commands
      iwlwifi: fix leaks/bad data after failed firmware load
      iwlwifi: remove module loading failure message

John David Anglin (2):
      parisc: Avoid calling faulthandler_disabled() twice
      parisc: Fix lpa and lpa_user defines

Jonathan Cameron (1):
      iio: adc: ti-adc081c: Partial revert of removal of ACPI IDs

Jordan Niethe (1):
      powerpc/64s: Convert some cpu_setup() and cpu_restore() functions to C

Josef Bacik (3):
      btrfs: remove BUG_ON() in find_parent_nodes()
      btrfs: remove BUG_ON(!eie) in find_parent_nodes
      btrfs: check the root node for uptodate before returning it

José Expósito (5):
      HID: hid-uclogic-params: Invalid parameter check in uclogic_params_init
      HID: hid-uclogic-params: Invalid parameter check in uclogic_params_get_str_desc
      HID: hid-uclogic-params: Invalid parameter check in uclogic_params_huion_init
      HID: hid-uclogic-params: Invalid parameter check in uclogic_params_frame_init_v1_buttonpad
      HID: apple: Do not reset quirks when the Fn key is not found

Julia Lawall (4):
      powerpc/6xx: add missing of_node_put
      powerpc/powernv: add missing of_node_put
      powerpc/cell: add missing of_node_put
      powerpc/btext: add missing of_node_put

Kai-Heng Feng (1):
      usb: hub: Add delay for SuperSpeed hub resume to let links transit to U0

Kajol Jain (1):
      bpf: Remove config check to enable bpf support for branch records

Kamal Heib (3):
      RDMA/hns: Validate the pkey index
      RDMA/qedr: Fix reporting max_{send/recv}_wr attrs
      RDMA/cxgb4: Set queue pair state when being queried

Karthikeyan Kathirvel (2):
      ath11k: clear the keys properly via DISABLE_KEY
      ath11k: reset RSN/WPA present state for open BSS

Kees Cook (2):
      x86/uaccess: Move variable into switch case statement
      char/mwave: Adjust io port register size

Kevin Bracey (1):
      net_sched: restore "mpu xxx" handling

Kirill A. Shutemov (1):
      ACPICA: Hardware: Do not flush CPU cache when entering S4 and S5

Kishon Vijay Abraham I (1):
      arm64: dts: ti: j7200-main: Fix 'dtbs_check' serdes_ln_ctrl node

Konrad Dybcio (1):
      regulator: qcom_smd: Align probe function with rpmh-regulator

Krzysztof Kozlowski (1):
      nfc: llcp: fix NULL error pointer dereference on sendmsg() after failed bind()

Kunihiko Hayashi (2):
      spi: uniphier: Fix a bug that doesn't point to private data correctly
      dmaengine: uniphier-xdmac: Fix type of address variables

Kuniyuki Iwashima (1):
      bpf: Fix SO_RCVBUF/SO_SNDBUF handling in _bpf_setsockopt().

Kyeong Yoo (1):
      jffs2: GC deadlock reading a page that is used in jffs2_write_begin()

Lad Prabhakar (2):
      mtd: hyperbus: rpc-if: Check return value of rpcif_sw_init()
      memory: renesas-rpc-if: Return error in case devm_ioremap_resource() fails

Lakshmi Sowjanya D (1):
      i2c: designware-pci: Fix to change data types of hcnt and lcnt parameters

Laurence de Bruxelles (1):
      rtc: pxa: fix null pointer dereference

Laurent Pinchart (1):
      drm: rcar-du: Fix CRTC timings when CMM is used

Leon Romanovsky (1):
      devlink: Remove misleading internal_flags from health reporter dump

Li Hua (1):
      sched/rt: Try to restart rt period timer when rt runtime exceeded

Lino Sanfilippo (1):
      serial: amba-pl011: do not request memory region twice

Linus Lüssing (1):
      batman-adv: allow netlink usage in unprivileged containers

Lizhi Hou (1):
      tty: serial: uartlite: allow 64 bit address

Luca Coelho (1):
      iwlwifi: pcie: make sure prph_info is set when treating wakeup IRQ

Lucas De Marchi (1):
      x86/gpu: Reserve stolen memory for first integrated Intel GPU

Lucas Stach (2):
      drm/etnaviv: consider completed fence seqno in hang check
      drm/etnaviv: limit submit sizes

Luiz Augusto von Dentz (4):
      Bluetooth: L2CAP: Fix not initializing sk_peer_pid
      Bluetooth: L2CAP: Fix using wrong mode
      Bluetooth: vhci: Set HCI_QUIRK_VALID_LE_STATES
      Bluetooth: hci_sync: Fix not setting adv set duration

Lukas Bulwahn (5):
      ASoC: uniphier: drop selecting non-existing SND_SOC_UNIPHIER_AIO_DMA
      mips: add SYS_HAS_CPU_MIPS64_R5 config for MIPS Release 5 support
      mips: fix Kconfig reference to PHYS_ADDR_T_64BIT
      ARM: imx: rename DEBUG_IMX21_IMX27_UART to DEBUG_IMX27_UART
      Documentation: refer to config RANDOMIZE_BASE for kernel address-space randomization

Lukas Wunner (3):
      serial: pl010: Drop CR register reset on set_termios
      serial: core: Keep mctrl register state and cached copy in sync
      serial: Fix incorrect rs485 polarity on uart open

Luís Henriques (1):
      ext4: set csum seed in tmp inode while migrating to extents

Lv Yunlong (1):
      wireless: iwlwifi: Fix a double free in iwl_txq_dyn_alloc_dma

Mansur Alisha Shaik (1):
      media: venus: avoid calling core_clk_setrate() concurrently during concurrent video sessions

Maor Dickman (1):
      net/mlx5e: Don't block routes with nexthop objects in SW

Marc Kleine-Budde (3):
      can: mcp251xfd: add missing newline to printed strings
      can: softing: softing_startstop(): fix set but not used variable warning
      can: mcp251xfd: mcp251xfd_tef_obj_read(): fix typo in error message

Marc Zyngier (1):
      irqchip/gic-v4: Disable redistributors' view of the VPE table at boot time

Marcelo Tosatti (1):
      KVM: VMX: switch blocked_vcpu_on_cpu_lock to raw spinlock

Marco Chiappero (2):
      crypto: qat - remove unnecessary collision prevention step in PFVF
      crypto: qat - make pfvf send message direction agnostic

Marek Behún (1):
      ARM: dts: armada-38x: Add generic compatible to UART nodes

Marek Vasut (1):
      crypto: stm32/crc32 - Fix kernel BUG triggered in probe()

Marijn Suijten (6):
      backlight: qcom-wled: Validate enabled string indices in DT
      backlight: qcom-wled: Pass number of elements to read to read_u32_array
      backlight: qcom-wled: Fix off-by-one maximum with default num_strings
      backlight: qcom-wled: Override default length with qcom,enabled-strings
      backlight: qcom-wled: Use cpu_to_le16 macro to perform conversion
      backlight: qcom-wled: Respect enabled-strings in set_brightness

Marina Nikolic (1):
      amdgpu/pm: Make sysfs pm attributes as read-only for VFs

Mark Langsdorf (1):
      ACPICA: actypes.h: Expand the ACPI_ACCESS_ definitions

Martin Blumenstingl (1):
      clk: meson: gxbb: Fix the SDM_EN bit for MPLL0 on GXBB

Martyn Welch (1):
      drm/bridge: megachips: Ensure both bridges are probed before registration

Mateusz Jończyk (1):
      rtc: cmos: take rtc_lock while reading from CMOS

Matthias Schiffer (1):
      scripts/dtc: dtx_diff: remove broken example from help text

Mauro Carvalho Chehab (7):
      media: atomisp: fix enum formats logic
      media: atomisp: fix try_fmt logic
      media: atomisp: set per-device's default mode
      media: atomisp: handle errors at sh_css_create_isp_params()
      media: m920x: don't use stack on USB reads
      scripts: sphinx-pre-install: add required ctex dependency
      scripts: sphinx-pre-install: Fix ctex support on Debian

Maxim Levitsky (1):
      iommu/amd: Restore GA log/tail pointer on host resume

Maxime Ripard (4):
      clk: bcm-2835: Pick the closest clock rate
      clk: bcm-2835: Remove rounding up the dividers
      drm/vc4: hdmi: Set a default HSM rate
      drm/vc4: hdmi: Make sure the device is powered with CEC

Meng Li (1):
      crypto: caam - replace this_cpu_ptr with raw_cpu_ptr

Miaoqian Lin (6):
      Bluetooth: hci_qca: Fix NULL vs IS_ERR_OR_NULL check in qca_serdev_probe
      usb: dwc3: qcom: Fix NULL vs IS_ERR checking in dwc3_qcom_probe
      spi: spi-meson-spifc: Add missing pm_runtime_disable() in meson_spifc_probe
      phy: mediatek: Fix missing check in mtk_mipi_tx_probe
      parisc: pdc_stable: Fix memory leak in pdcs_register_pathentries
      lib82596: Fix IRQ check in sni_82596_probe

Michael Ellerman (1):
      powerpc/smp: Move setup_profiling_timer() under CONFIG_PROFILING

Michael Kuron (1):
      media: dib0700: fix undefined behavior in tuner shutdown

Michael S. Tsirkin (1):
      virtio_ring: mark ring unused on error

Michal Suchanek (1):
      debugfs: lockdown: Allow reading debugfs files that are not world readable

Mika Westerberg (1):
      thunderbolt: Runtime PM activate both ends of the device link

Moshe Shemesh (2):
      net/mlx5: Set command entry semaphore up once got index free
      Revert "net/mlx5: Add retry mechanism to the command entry index allocation"

Nathan Chancellor (3):
      x86/boot/compressed: Move CLANG_FLAGS to beginning of KBUILD_CFLAGS
      iwlwifi: mvm: Use div_s64 instead of do_div in iwl_mvm_ftm_rtt_smoothing()
      MIPS: Loongson64: Use three arguments for slti

Nathan Errera (1):
      iwlwifi: mvm: test roc running status bits before removing the sta

Neal Liu (1):
      usb: uhci: add aspeed ast2600 uhci support

Neil Armstrong (1):
      drm/bridge: dw-hdmi: handle ELD when DRM_BRIDGE_ATTACH_NO_CONNECTOR

Nicholas Piggin (3):
      powerpc/perf: move perf irq/nmi handling details into traps.c
      powerpc/watchdog: Fix missed watchdog reset due to memory ordering race
      powerpc/64s/radix: Fix huge vmap false positive

Nicolas Toromanoff (6):
      crypto: stm32/cryp - fix CTR counter carry
      crypto: stm32/cryp - fix xts and race condition in crypto_engine requests
      crypto: stm32/cryp - check early input data
      crypto: stm32/cryp - fix double pm exit
      crypto: stm32/cryp - fix lrw chaining mode
      crypto: stm32/cryp - fix bugs and crash in tests

Niklas Söderlund (2):
      dt-bindings: thermal: Fix definition of cooling-maps contribution property
      media: rcar-vin: Update format alignment constraints

Nishanth Menon (3):
      arm64: dts: ti: k3-j7200: Fix the L2 cache sets
      arm64: dts: ti: k3-j721e: Fix the L2 cache sets
      arm64: dts: ti: k3-j7200: Correct the d-cache-sets info

Oleksandr Andrushchenko (1):
      xen/gntdev: fix unmap notification order

Oleksij Rempel (1):
      thermal/drivers/imx: Implement runtime PM support

Pali Rohár (5):
      PCI: pci-bridge-emul: Make expansion ROM Base Address register read-only
      PCI: pci-bridge-emul: Properly mark reserved PCIe bits in PCI config space
      PCI: pci-bridge-emul: Fix definitions of reserved bits
      PCI: pci-bridge-emul: Correctly set PCIe capabilities
      PCI: pci-bridge-emul: Set PCI_STATUS_CAP_LIST for PCIe device

Panicker Harish (1):
      Bluetooth: hci_qca: Stop IBS timer during BT OFF

Paolo Abeni (1):
      bpf: Do not WARN in bpf_warn_invalid_xdp_action()

Patrick Williams (1):
      tpm: fix NPE on probe for missing device

Paul Cercueil (3):
      mtd: rawnand: davinci: Don't calculate ECC when reading page
      mtd: rawnand: davinci: Avoid duplicated page read
      mtd: rawnand: davinci: Rewrite function description

Paul Chaignon (1):
      bpftool: Enable line buffering for stdout

Paul E. McKenney (1):
      clocksource: Reduce clocksource-skew threshold

Paul Gerber (1):
      thermal/drivers/imx8mm: Enable ADC when enabling monitor

Paul Moore (1):
      audit: ensure userspace is penalized the same as the kernel when under pressure

Pavankumar Kondeti (1):
      usb: gadget: f_fs: Use stream_open() for endpoint files

Pavel Skripkin (2):
      Bluetooth: stop proccessing malicious adv data
      net: mcs7830: handle usb read errors properly

Peiwei Hu (1):
      powerpc/prom_init: Fix improper check of prom_getprop()

Peng Fan (1):
      arm64: dts: ti: k3-j721e: correct cache-sets info

Petr Cvachoucek (1):
      ubifs: Error path in ubifs_remount_rw() seems to wrongly free write buffers

Philipp Zabel (1):
      media: coda: fix CODA960 JPEG encoder buffer overflow

Ping-Ke Shih (1):
      mac80211: allow non-standard VHT MCS-10/11

Po-Hao Huang (1):
      rtw88: 8822c: update rx settings to prevent potential hw deadlock

Qiang Yu (1):
      drm/lima: fix warning when CONFIG_DEBUG_SG=y & CONFIG_DMA_API_DEBUG=y

Quentin Monnet (1):
      bpftool: Remove inclusion of utilities.mak from Makefiles

Rafael J. Wysocki (5):
      ACPI: EC: Rework flushing of EC work while suspended to idle
      PM: runtime: Add safety net to supplier device release
      cpufreq: Fix initialization of min and max frequency QoS requests
      ACPICA: Utilities: Avoid deleting the same object twice in a row
      ACPICA: Executer: Fix the REFCLASS_REFOF case in acpi_ex_opcode_1A_0T_1R()

Rameshkumar Sundaram (2):
      ath11k: Send PPDU_STATS_CFG with proper pdev mask to firmware
      ath11k: Fix deleting uninitialized kernel timer during fragment cache flush

Randy Dunlap (5):
      mips: lantiq: add support for clk_set_parent()
      mips: bcm63xx: add support for clk_set_parent()
      um: registers: Rename function names to avoid conflicts and build problems
      media: correct MEDIA_TEST_SUPPORT help text
      Documentation: fix firewire.rst ABI file path error

Reiji Watanabe (1):
      arm64: clear_page() shouldn't use DC ZVA when DCZID_EL0.DZP == 1

Rob Herring (1):
      PCI: xgene: Fix IB window setup

Robert Hancock (10):
      clk: si5341: Fix clock HW provider cleanup
      net: axienet: increase reset timeout
      net: axienet: Wait for PhyRstCmplt after core reset
      net: axienet: reset core on initialization prior to MDIO access
      net: axienet: add missing memory barriers
      net: axienet: limit minimum TX ring size
      net: axienet: Fix TX ring slot available check
      net: axienet: fix number of TX ring slots for available check
      net: axienet: fix for TX busy handling
      net: axienet: increase default TX ring size to 128

Robert Marko (2):
      arm64: dts: marvell: cn9130: add GPIO and SPI aliases
      arm64: dts: marvell: cn9130: enable CP0 GPIO controllers

Robert Schlabbach (1):
      media: si2157: Fix "warm" tuner state detection

Robin Murphy (1):
      drm/tegra: vic: Fix DMA API misuse

Russell King (Oracle) (4):
      net: phy: prefer 1000baseT over 1000baseKX
      net: phy: marvell: configure RGMII delays for 88E1118
      net: gemini: allow any RGMII interface mode
      net: sfp: fix high power modules without diagnostic monitoring

Ryuta NAKANISHI (1):
      phy: uniphier-usb3ss: fix unintended writing zeros to PHY register

Sakari Ailus (2):
      device property: Fix fwnode_graph_devcon_match() fwnode leak
      Documentation: ACPI: Fix data node reference documentation

Sam Protsenko (1):
      dt-bindings: watchdog: Require samsung,syscon-phandle for Exynos7

Sameer Pujar (2):
      arm64: tegra: Fix Tegra194 HDA {clock,reset}-names ordering
      arm64: tegra: Remove non existent Tegra194 reset

Sean Wang (1):
      Bluetooth: btmtksdio: fix resume failure

Sean Young (1):
      media: igorplugusb: receiver overflow should be reported

Sebastian Andrzej Siewior (1):
      ext4: destroy ext4_fc_dentry_cachep kmemcache on module removal

Sebastian Gottschall (1):
      ath10k: Fix tx hanging

Sergey Shtylyov (3):
      mmc: meson-mx-sdhc: add IRQ check
      mmc: meson-mx-sdio: add IRQ check
      bcmgenet: add WOL IRQ check

Shaul Triebitz (1):
      iwlwifi: mvm: avoid clearing a just saved session protection id

Shengjiu Wang (1):
      ASoC: fsl_asrc: refine the check of available clock divider

Sicelo A. Mhlongo (1):
      ARM: dts: omap3-n900: Fix lp5523 for multi color

Srinivas Kandagatla (2):
      arm64: dts: qcom: c630: Fix soundcard setup
      nvmem: core: set size for sysfs bin file

Sriram R (1):
      ath11k: Avoid NULL ptr access during mgmt tx cleanup

Stafford Horne (1):
      openrisc: Add clone3 ABI wrapper

Stanimir Varbanov (1):
      media: venus: pm_helpers: Control core power domain manually

Stefan Riedmueller (1):
      mtd: rawnand: gpmi: Remove explicit default gpmi clock setting for i.MX6

Stephan Müller (1):
      crypto: jitter - consider 32 LSB for APT

Stephen Boyd (2):
      drm/bridge: ti-sn65dsi86: Set max register for regmap
      clk: Emit a stern warning with writable debugfs enabled

Sudeep Holla (1):
      ACPICA: Fix wrong interpretation of PCC address

Suravee Suthikulpanit (1):
      iommu/amd: Remove iommu_init_ga()

Suresh Kumar (1):
      net: bonding: debug: avoid printing debug logs when bond is not notifying peers

Suresh Udipi (2):
      media: rcar-csi2: Correct the selection of hsfreqrange
      media: rcar-csi2: Optimize the selection PHTW register

Sven Eckelmann (1):
      ath11k: Fix ETSI regd with weather radar overlap

Takashi Iwai (5):
      ALSA: jack: Add missing rwsem around snd_ctl_remove() calls
      ALSA: PCM: Add missing rwsem around snd_ctl_remove() calls
      ALSA: hda: Add missing rwsem around snd_ctl_remove() calls
      ALSA: usb-audio: Drop superfluous '0' in Presonus Studio 1810c's ID
      ALSA: seq: Set upper limit of processed events

Tasos Sahanidis (1):
      floppy: Fix hang in watchdog when disk is ejected

Thadeu Lima de Souza Cascardo (1):
      selftests/powerpc/spectre_v2: Return skip code when miss_percent is high

Theodore Ts'o (1):
      ext4: don't use the orphan list when migrating an inode

Thierry Reding (1):
      arm64: tegra: Adjust length of CCPLEX cluster MMIO region

Thomas Gleixner (1):
      PCI/MSI: Fix pci_irq_vector()/pci_irq_get_affinity()

Thomas Hellström (1):
      dma_fence_array: Fix PENDING_ERROR leak in dma_fence_array_signaled()

Thomas Weißschuh (1):
      ACPI: battery: Add the ThinkPad "Not Charging" quirk

Tianjia Zhang (1):
      MIPS: Octeon: Fix build errors using clang

Tobias Waldekranz (3):
      powerpc/fsl/dts: Enable WA for erratum A-009885 on fman3l MDIO buses
      net/fsl: xgmac_mdio: Add workaround for erratum A-009885
      net/fsl: xgmac_mdio: Fix incorrect iounmap when removing module

Todd Kjos (1):
      binder: fix handling of error during copy

Toke Høiland-Jørgensen (1):
      xdp: check prog type before updating BPF link

Tom Rix (2):
      net: ethernet: mtk_eth_soc: fix error checking in mtk_mac_config()
      net: mscc: ocelot: fix using match before it is set

Tsuchiya Yuto (7):
      media: atomisp: add missing media_device_cleanup() in atomisp_unregister_entities()
      media: atomisp: fix punit_ddr_dvfs_enable() argument for mrfld_power up case
      media: atomisp: fix inverted logic in buffers_needed()
      media: atomisp: do not use err var when checking port validity for ISP2400
      media: atomisp: fix inverted error check for ia_css_mipi_is_source_port_valid()
      media: atomisp: fix ifdefs in sh_css.c
      media: atomisp: add NULL check for asd obtained from atomisp_video_pipe

Tudor Ambarus (8):
      tty: serial: atmel: Check return code of dmaengine_submit()
      tty: serial: atmel: Call dma_async_issue_pending()
      dmaengine: at_xdmac: Don't start transactions at tx_submit level
      dmaengine: at_xdmac: Start transfer for cyclic channels in issue_pending
      dmaengine: at_xdmac: Print debug message after realeasing the lock
      dmaengine: at_xdmac: Fix concurrency over xfers_list
      dmaengine: at_xdmac: Fix lld view setting
      dmaengine: at_xdmac: Fix at_xdmac_lld struct definition

Tzung-Bi Shih (2):
      ASoC: mediatek: mt8173: fix device_node leak
      ASoC: mediatek: mt8183: fix device_node leak

Ulf Hansson (1):
      mmc: core: Fixup storing of OCR for MMC_QUIRK_NONSTD_SDIO

Vincent Donnefort (2):
      sched/fair: Fix detection of per-CPU kthreads waking a task
      sched/fair: Fix per-CPU kthread and wakee stacking for asym CPU capacity

Waiman Long (1):
      clocksource: Avoid accidental unstable marking of clocksources

Wan Jiabing (1):
      ARM: shmobile: rcar-gen2: Add missing of_node_put()

Wang Hai (4):
      drm: fix null-ptr-deref in drm_dev_init_release()
      Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails
      media: dmxdev: fix UAF when dvb_register_device() fails
      media: msi001: fix possible null-ptr-deref in msi001_probe()

Wei Yongjun (3):
      usb: ftdi-elan: fix memory leak on device disconnect
      misc: lattice-ecp3-config: Fix task hung when firmware load failed
      Bluetooth: Fix debugfs entry leak in hci_register_dev()

Wen Gong (1):
      ath11k: avoid deadlock by change ieee80211_queue_work for regd_update_work

Wen Gu (1):
      net/smc: Fix hung_task when removing SMC-R devices

Will Deacon (1):
      arm64: lib: Annotate {clear, copy}_page() as position-independent

William Kucharski (1):
      cgroup: Trace event cgroup id fields should be u64

Willy Tarreau (2):
      tools/nolibc: i386: fix initial stack alignment
      tools/nolibc: fix incorrect truncation of exit code

Xiangyang Zhang (1):
      tracing/kprobes: 'nmissed' not showed correctly for kretprobe

Xie Yongji (1):
      fuse: Pass correct lend value to filemap_write_and_wait_range()

Xin Xiong (1):
      netfilter: ipt_CLUSTERIP: fix refcount leak in clusterip_tg_check()

Xin Yin (3):
      ext4: fix fast commit may miss tracking range for FALLOC_FL_ZERO_RANGE
      ext4: use ext4_ext_remove_space() for fast commit replay delete range
      ext4: fast commit may miss tracking unwritten range during ftruncate

Xiongfeng Wang (1):
      iommu/iova: Fix race between FQ timeout and teardown

Xiongwei Song (1):
      floppy: Add max size check for user space request

Yang Li (1):
      drm/amd/display: check top_pipe_to_program pointer

Yang Yingliang (3):
      media: si470x-i2c: fix possible memory leak in si470x_i2c_probe()
      staging: rtl8192e: return error code from rtllib_softmac_init()
      staging: rtl8192e: rtllib_module: fix error handle case in alloc_rtllib()

Ye Bin (3):
      ext4: Fix BUG_ON in ext4_bread when write quota data
      ext4: fix null-ptr-deref in '__ext4_journal_ensure_credits'
      block: Fix fsync always failed if once failed

Ye Guojin (1):
      MIPS: OCTEON: add put_device() after of_find_device_by_node()

Yifeng Li (1):
      PCI: Add function 1 DMA alias quirk for Marvell 88SE9125 SATA controller

Yixing Liu (1):
      RDMA/hns: Modify the mapping attribute of doorbell to device

Yunfei Wang (1):
      iommu/io-pgtable-arm-v7s: Add error handle for page table allocation failure

Zechuan Chen (1):
      perf probe: Fix ppc64 'perf probe add events failed' case

Zekun Shen (5):
      ar5523: Fix null-ptr-deref with unexpected WDCMSG_TARGET_START reply
      mwifiex: Fix skb_over_panic in mwifiex_usb_recv()
      rsi: Fix use-after-free in rsi_rx_done_handler()
      rsi: Fix out-of-bounds read in rsi_read_pkt()
      ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream

Zhang Zixun (1):
      x86/mce/inject: Avoid out-of-bounds write when setting flags

Zheyu Ma (1):
      media: b2c2: Add missing check in flexcop_pci_isr:

Zhou Qingyang (9):
      drm/amdgpu: Fix a NULL pointer dereference in amdgpu_connector_lcd_native_mode()
      drm/radeon/radeon_kms: Fix a NULL pointer dereference in radeon_driver_open_kms()
      media: dib8000: Fix a memleak in dib8000_init()
      media: saa7146: mxb: Fix a NULL pointer dereference in mxb_attach()
      ath11k: Fix a NULL pointer dereference in ath11k_mac_op_hw_scan()
      pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in __nonstatic_find_io_region()
      pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in nonstatic_find_mem_region()
      media: saa7146: hexium_orion: Fix a NULL pointer dereference in hexium_attach()
      media: saa7146: hexium_gemini: Fix a NULL pointer dereference in hexium_attach()

Zizhuang Deng (1):
      lib/mpi: Add the return value check of kcalloc()

Zongmin Zhou (1):
      drm/amdgpu: fixup bad vram size on gmc v8

xinhui pan (1):
      drm/ttm: Put BO in its memory manager's lru list

