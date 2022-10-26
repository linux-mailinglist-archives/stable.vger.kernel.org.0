Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478D360DFCC
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 13:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbiJZLkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 07:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233666AbiJZLjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 07:39:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD7CD8EEA;
        Wed, 26 Oct 2022 04:38:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCF6261E3C;
        Wed, 26 Oct 2022 11:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4E6C433C1;
        Wed, 26 Oct 2022 11:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666784305;
        bh=GpBRA7YWHo1us+rFgwI1AxfYK5IAoC5yk9YfrExt8Vs=;
        h=From:To:Cc:Subject:Date:From;
        b=lKzB+kkmmeUjwTA+jfjPASv/FaE86NfMtCeRYlL1u6vhr3GDAJW+oGYVJaIrZ5nUJ
         dXnWSuQU2jZPSjePiacbgiLCOzlBv9BYLpycoG0dhJRoZrehjivT7JtTMY21xph3HP
         fcpqutfWvpNYnF2xqP5vNatrvtJcJ0LfT4RMD0YA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.75
Date:   Wed, 26 Oct 2022 13:38:12 +0200
Message-Id: <166678429336155@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.75 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-iio                    |    2 
 Documentation/arm64/silicon-errata.rst                     |    2 
 Documentation/filesystems/vfs.rst                          |    3 
 Makefile                                                   |    8 
 arch/arm/Kconfig                                           |    1 
 arch/arm/boot/compressed/vmlinux.lds.S                     |    2 
 arch/arm/boot/dts/armada-385-turris-omnia.dts              |    4 
 arch/arm/boot/dts/exynos4412-midas.dtsi                    |    2 
 arch/arm/boot/dts/exynos4412-origen.dts                    |    2 
 arch/arm/boot/dts/imx6dl.dtsi                              |    3 
 arch/arm/boot/dts/imx6q.dtsi                               |    3 
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi              |    6 
 arch/arm/boot/dts/imx6qp.dtsi                              |    6 
 arch/arm/boot/dts/imx6sl.dtsi                              |    3 
 arch/arm/boot/dts/imx6sll.dtsi                             |    3 
 arch/arm/boot/dts/imx6sx.dtsi                              |    6 
 arch/arm/boot/dts/imx7d-sdb.dts                            |    7 
 arch/arm/boot/dts/kirkwood-lsxl.dtsi                       |   16 
 arch/arm/mm/dump.c                                         |    2 
 arch/arm/mm/kasan_init.c                                   |    9 
 arch/arm/mm/mmu.c                                          |    4 
 arch/arm64/Kconfig                                         |   17 
 arch/arm64/boot/dts/freescale/imx8mp.dtsi                  |    4 
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi          |    1 
 arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts      |   10 
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi                  |   11 
 arch/arm64/kernel/cpu_errata.c                             |    5 
 arch/arm64/kernel/ftrace.c                                 |   17 
 arch/arm64/kernel/topology.c                               |   40 -
 arch/ia64/mm/numa.c                                        |    1 
 arch/mips/bcm47xx/prom.c                                   |    4 
 arch/mips/sgi-ip27/ip27-xtalk.c                            |   74 ++-
 arch/powerpc/Makefile                                      |    2 
 arch/powerpc/boot/Makefile                                 |    1 
 arch/powerpc/boot/dts/fsl/e500v1_power_isa.dtsi            |   51 ++
 arch/powerpc/boot/dts/fsl/mpc8540ads.dts                   |    2 
 arch/powerpc/boot/dts/fsl/mpc8541cds.dts                   |    2 
 arch/powerpc/boot/dts/fsl/mpc8555cds.dts                   |    2 
 arch/powerpc/boot/dts/fsl/mpc8560ads.dts                   |    2 
 arch/powerpc/configs/pseries_defconfig                     |    1 
 arch/powerpc/include/asm/syscalls.h                        |   12 
 arch/powerpc/kernel/kprobes.c                              |    8 
 arch/powerpc/kernel/pci_dn.c                               |    1 
 arch/powerpc/kernel/sys_ppc32.c                            |   14 
 arch/powerpc/kernel/syscalls.c                             |    4 
 arch/powerpc/math-emu/math_efp.c                           |    1 
 arch/powerpc/platforms/powernv/opal.c                      |    1 
 arch/powerpc/platforms/pseries/vas.c                       |    2 
 arch/powerpc/sysdev/fsl_msi.c                              |    2 
 arch/riscv/Kconfig                                         |    2 
 arch/riscv/Makefile                                        |    2 
 arch/riscv/include/asm/io.h                                |   16 
 arch/riscv/kernel/setup.c                                  |    4 
 arch/riscv/kernel/smpboot.c                                |    3 
 arch/riscv/kernel/sys_riscv.c                              |    3 
 arch/riscv/mm/fault.c                                      |    3 
 arch/sh/include/asm/sections.h                             |    2 
 arch/sh/kernel/machvec.c                                   |   10 
 arch/um/kernel/um_arch.c                                   |    2 
 arch/x86/include/asm/hyperv-tlfs.h                         |    4 
 arch/x86/include/asm/microcode.h                           |    1 
 arch/x86/kernel/cpu/feat_ctl.c                             |    2 
 arch/x86/kernel/cpu/mce/apei.c                             |   13 
 arch/x86/kernel/cpu/microcode/amd.c                        |    3 
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c                  |   12 
 arch/x86/kvm/emulate.c                                     |    2 
 arch/x86/kvm/vmx/nested.c                                  |   37 +
 arch/x86/kvm/vmx/vmx.c                                     |   12 
 arch/x86/xen/enlighten_pv.c                                |    3 
 block/blk-throttle.c                                       |    8 
 block/blk-wbt.c                                            |   10 
 crypto/akcipher.c                                          |    8 
 drivers/acpi/acpi_fpdt.c                                   |   22 +
 drivers/acpi/acpi_video.c                                  |   16 
 drivers/acpi/apei/ghes.c                                   |    2 
 drivers/acpi/x86/utils.c                                   |   19 
 drivers/ata/libahci_platform.c                             |   14 
 drivers/base/arch_topology.c                               |   19 
 drivers/block/nbd.c                                        |    6 
 drivers/bluetooth/btintel.c                                |   17 
 drivers/bluetooth/btusb.c                                  |   14 
 drivers/bluetooth/hci_ldisc.c                              |    7 
 drivers/bluetooth/hci_serdev.c                             |   10 
 drivers/char/hw_random/arm_smccc_trng.c                    |    4 
 drivers/char/hw_random/imx-rngc.c                          |   14 
 drivers/clk/baikal-t1/ccu-div.c                            |   65 +++
 drivers/clk/baikal-t1/ccu-div.h                            |   10 
 drivers/clk/baikal-t1/clk-ccu-div.c                        |   26 +
 drivers/clk/bcm/clk-bcm2835.c                              |   43 +-
 drivers/clk/berlin/bg2.c                                   |    5 
 drivers/clk/berlin/bg2q.c                                  |    6 
 drivers/clk/clk-ast2600.c                                  |    2 
 drivers/clk/clk-oxnas.c                                    |    6 
 drivers/clk/clk-qoriq.c                                    |   10 
 drivers/clk/clk-versaclock5.c                              |    2 
 drivers/clk/imx/clk-scu.c                                  |    6 
 drivers/clk/mediatek/clk-mt8183-mfgcfg.c                   |    6 
 drivers/clk/meson/meson-aoclk.c                            |    5 
 drivers/clk/meson/meson-eeclk.c                            |    5 
 drivers/clk/meson/meson8b.c                                |    5 
 drivers/clk/qcom/Kconfig                                   |    1 
 drivers/clk/qcom/apss-ipq6018.c                            |    2 
 drivers/clk/qcom/gcc-sm6115.c                              |   46 +-
 drivers/clk/sprd/common.c                                  |    9 
 drivers/clk/tegra/clk-tegra114.c                           |    1 
 drivers/clk/tegra/clk-tegra20.c                            |    1 
 drivers/clk/tegra/clk-tegra210.c                           |    1 
 drivers/clk/ti/clk-dra7-atl.c                              |    9 
 drivers/clk/zynqmp/clkc.c                                  |    7 
 drivers/clk/zynqmp/pll.c                                   |   31 -
 drivers/cpufreq/intel_pstate.c                             |    1 
 drivers/crypto/cavium/cpt/cptpf_main.c                     |    6 
 drivers/crypto/ccp/ccp-dmaengine.c                         |    6 
 drivers/crypto/hisilicon/qm.c                              |    6 
 drivers/crypto/hisilicon/zip/zip_crypto.c                  |    4 
 drivers/crypto/inside-secure/safexcel_hash.c               |    8 
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c          |   18 
 drivers/crypto/qat/qat_common/adf_gen4_hw_data.h           |    2 
 drivers/crypto/qat/qat_common/qat_algs.c                   |   18 
 drivers/crypto/sahara.c                                    |   18 
 drivers/dma-buf/udmabuf.c                                  |    9 
 drivers/dma/hisi_dma.c                                     |   28 -
 drivers/dma/ioat/dma.c                                     |    6 
 drivers/dma/mxs-dma.c                                      |   11 
 drivers/dma/ti/k3-udma.c                                   |   25 -
 drivers/firmware/efi/libstub/fdt.c                         |    8 
 drivers/firmware/google/gsmi.c                             |    9 
 drivers/fpga/dfl.c                                         |    2 
 drivers/fsi/fsi-core.c                                     |    3 
 drivers/gpio/gpio-rockchip.c                               |    7 
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c             |    7 
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c                |   14 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                    |    5 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c          |   67 +--
 drivers/gpu/drm/amd/display/dc/calcs/bw_fixed.c            |    6 
 drivers/gpu/drm/amd/display/dc/core/dc.c                   |   16 
 drivers/gpu/drm/amd/display/dc/dc_stream.h                 |    6 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |   35 -
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h  |    3 
 drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h          |    8 
 drivers/gpu/drm/arm/display/komeda/komeda_crtc.c           |    4 
 drivers/gpu/drm/arm/display/komeda/komeda_kms.c            |   21 -
 drivers/gpu/drm/arm/display/komeda/komeda_kms.h            |    2 
 drivers/gpu/drm/bridge/adv7511/adv7511.h                   |    5 
 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c               |    4 
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c               |    4 
 drivers/gpu/drm/bridge/lontium-lt9611.c                    |    3 
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c   |    4 
 drivers/gpu/drm/bridge/parade-ps8640.c                     |    4 
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                  |   13 
 drivers/gpu/drm/drm_bridge.c                               |    4 
 drivers/gpu/drm/drm_dp_helper.c                            |    9 
 drivers/gpu/drm/drm_dp_mst_topology.c                      |    6 
 drivers/gpu/drm/drm_ioctl.c                                |    8 
 drivers/gpu/drm/drm_mipi_dsi.c                             |    1 
 drivers/gpu/drm/drm_panel_orientation_quirks.c             |    6 
 drivers/gpu/drm/i915/intel_pm.c                            |   10 
 drivers/gpu/drm/meson/meson_drv.c                          |   10 
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c                    |   12 
 drivers/gpu/drm/msm/disp/dpu1/dpu_vbif.c                   |   29 -
 drivers/gpu/drm/msm/dp/dp_catalog.c                        |    2 
 drivers/gpu/drm/nouveau/nouveau_bo.c                       |    4 
 drivers/gpu/drm/nouveau/nouveau_connector.c                |    3 
 drivers/gpu/drm/nouveau/nouveau_prime.c                    |    1 
 drivers/gpu/drm/omapdrm/dss/dss.c                          |    3 
 drivers/gpu/drm/pl111/pl111_versatile.c                    |    1 
 drivers/gpu/drm/tiny/bochs.c                               |    2 
 drivers/gpu/drm/udl/udl_modeset.c                          |    3 
 drivers/gpu/drm/vc4/vc4_vec.c                              |    4 
 drivers/gpu/drm/virtio/virtgpu_object.c                    |    3 
 drivers/gpu/drm/virtio/virtgpu_plane.c                     |    6 
 drivers/gpu/drm/virtio/virtgpu_vq.c                        |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                        |    1 
 drivers/hid/hid-multitouch.c                               |    8 
 drivers/hid/hid-roccat.c                                   |    4 
 drivers/hsi/controllers/omap_ssi_core.c                    |    1 
 drivers/hsi/controllers/omap_ssi_port.c                    |    8 
 drivers/hwmon/gsc-hwmon.c                                  |    1 
 drivers/hwmon/pmbus/mp2888.c                               |   13 
 drivers/hwmon/sht4x.c                                      |    2 
 drivers/i2c/busses/i2c-designware-core.h                   |    7 
 drivers/i2c/busses/i2c-designware-master.c                 |   13 
 drivers/i2c/busses/i2c-mlxbf.c                             |   44 +-
 drivers/iio/adc/ad7923.c                                   |    4 
 drivers/iio/adc/at91-sama5d2_adc.c                         |   28 -
 drivers/iio/adc/ltc2497.c                                  |   13 
 drivers/iio/dac/ad5593r.c                                  |   46 +-
 drivers/iio/inkern.c                                       |    8 
 drivers/iio/magnetometer/yamaha-yas530.c                   |    2 
 drivers/iio/pressure/dps310.c                              |  262 ++++++++-----
 drivers/infiniband/core/cm.c                               |   14 
 drivers/infiniband/core/uverbs_cmd.c                       |    5 
 drivers/infiniband/core/verbs.c                            |    2 
 drivers/infiniband/hw/hns/hns_roce_mr.c                    |    1 
 drivers/infiniband/hw/irdma/defs.h                         |    1 
 drivers/infiniband/hw/irdma/hw.c                           |   51 +-
 drivers/infiniband/hw/irdma/type.h                         |    1 
 drivers/infiniband/hw/irdma/user.h                         |    1 
 drivers/infiniband/hw/irdma/utils.c                        |    3 
 drivers/infiniband/hw/irdma/verbs.c                        |    2 
 drivers/infiniband/hw/mlx4/mr.c                            |    1 
 drivers/infiniband/hw/mlx5/main.c                          |    3 
 drivers/infiniband/hw/mlx5/odp.c                           |    3 
 drivers/infiniband/sw/rxe/rxe_qp.c                         |   10 
 drivers/infiniband/sw/rxe/rxe_queue.c                      |   12 
 drivers/infiniband/sw/siw/siw.h                            |    1 
 drivers/infiniband/sw/siw/siw_qp.c                         |    2 
 drivers/infiniband/sw/siw/siw_qp_rx.c                      |   27 -
 drivers/infiniband/sw/siw/siw_verbs.c                      |    3 
 drivers/infiniband/ulp/srp/ib_srp.c                        |    4 
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c                |   21 +
 drivers/iommu/omap-iommu-debug.c                           |    6 
 drivers/isdn/mISDN/l1oip.h                                 |    1 
 drivers/isdn/mISDN/l1oip_core.c                            |   13 
 drivers/leds/flash/leds-lm3601x.c                          |    2 
 drivers/mailbox/bcm-flexrm-mailbox.c                       |    8 
 drivers/mailbox/mailbox-mpfs.c                             |   25 -
 drivers/md/bcache/writeback.c                              |   73 ++-
 drivers/md/raid0.c                                         |    2 
 drivers/md/raid5.c                                         |   15 
 drivers/media/pci/cx88/cx88-vbi.c                          |    9 
 drivers/media/pci/cx88/cx88-video.c                        |   43 +-
 drivers/media/platform/exynos4-is/fimc-is.c                |    1 
 drivers/media/platform/meson/ge2d/ge2d.c                   |    1 
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c            |    1 
 drivers/media/platform/s5p-mfc/s5p_mfc.c                   |    3 
 drivers/media/platform/xilinx/xilinx-vipp.c                |    9 
 drivers/media/usb/uvc/uvc_ctrl.c                           |   83 ++--
 drivers/media/usb/uvc/uvc_driver.c                         |    8 
 drivers/memory/of_memory.c                                 |    2 
 drivers/memory/pl353-smc.c                                 |    1 
 drivers/mfd/fsl-imx25-tsadc.c                              |   34 +
 drivers/mfd/intel_soc_pmic_core.c                          |    1 
 drivers/mfd/lp8788-irq.c                                   |    3 
 drivers/mfd/lp8788.c                                       |   12 
 drivers/mfd/sm501.c                                        |    7 
 drivers/misc/ocxl/file.c                                   |    2 
 drivers/mmc/host/au1xmmc.c                                 |    3 
 drivers/mmc/host/sdhci-msm.c                               |    1 
 drivers/mmc/host/sdhci-sprd.c                              |    2 
 drivers/mmc/host/wmt-sdmmc.c                               |    5 
 drivers/mtd/devices/docg3.c                                |    7 
 drivers/mtd/nand/raw/atmel/nand-controller.c               |    1 
 drivers/mtd/nand/raw/fsl_elbc_nand.c                       |   28 -
 drivers/mtd/nand/raw/intel-nand-controller.c               |   12 
 drivers/mtd/nand/raw/meson_nand.c                          |    4 
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h                |    2 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c           |    3 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c          |    2 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c           |   79 +++
 drivers/net/ethernet/atheros/alx/main.c                    |    5 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c            |    1 
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c           |    2 
 drivers/net/ethernet/intel/iavf/iavf_main.c                |  177 ++++++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c               |    1 
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h                 |    1 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c         |   10 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c            |   13 
 drivers/net/ethernet/ti/Kconfig                            |    1 
 drivers/net/ethernet/ti/davinci_mdio.c                     |  242 +++++++++++-
 drivers/net/hyperv/hyperv_net.h                            |    3 
 drivers/net/hyperv/netvsc.c                                |    4 
 drivers/net/hyperv/netvsc_drv.c                            |   19 
 drivers/net/thunderbolt.c                                  |   28 -
 drivers/net/usb/r8152.c                                    |    4 
 drivers/net/wireless/ath/ath10k/mac.c                      |   54 +-
 drivers/net/wireless/ath/ath11k/mac.c                      |   25 -
 drivers/net/wireless/ath/ath9k/htc_hst.c                   |   43 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c    |    3 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c     |   12 
 drivers/net/wireless/mediatek/mt76/mt7615/main.c           |    4 
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c        |    6 
 drivers/net/wireless/mediatek/mt76/mt7921/main.c           |    1 
 drivers/net/wireless/mediatek/mt76/sdio.c                  |    2 
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c             |   34 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c      |   75 +++
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c       |    9 
 drivers/net/wireless/realtek/rtw88/main.c                  |    8 
 drivers/net/wwan/iosm/iosm_ipc_wwan.c                      |    5 
 drivers/nvme/host/core.c                                   |    3 
 drivers/nvme/host/multipath.c                              |    1 
 drivers/nvme/host/pci.c                                    |    3 
 drivers/nvme/target/tcp.c                                  |   11 
 drivers/nvmem/core.c                                       |   15 
 drivers/pci/setup-res.c                                    |   11 
 drivers/phy/amlogic/phy-meson-axg-mipi-pcie-analog.c       |    6 
 drivers/phy/mediatek/phy-mtk-tphy.c                        |    7 
 drivers/phy/qualcomm/phy-qcom-usb-hsic.c                   |    6 
 drivers/pinctrl/pinctrl-rockchip.c                         |   13 
 drivers/platform/chrome/chromeos_laptop.c                  |   24 -
 drivers/platform/chrome/cros_ec.c                          |    8 
 drivers/platform/chrome/cros_ec_chardev.c                  |    3 
 drivers/platform/chrome/cros_ec_proto.c                    |   32 +
 drivers/platform/chrome/cros_ec_typec.c                    |    2 
 drivers/platform/x86/msi-laptop.c                          |   14 
 drivers/power/supply/adp5061.c                             |    6 
 drivers/powercap/intel_rapl_common.c                       |    4 
 drivers/regulator/core.c                                   |    2 
 drivers/regulator/qcom_rpm-regulator.c                     |   24 -
 drivers/scsi/3w-9xxx.c                                     |    2 
 drivers/scsi/cxgbi/libcxgbi.c                              |    2 
 drivers/scsi/iscsi_tcp.c                                   |  140 +++++-
 drivers/scsi/iscsi_tcp.h                                   |    5 
 drivers/scsi/libiscsi.c                                    |   41 +-
 drivers/scsi/libsas/sas_expander.c                         |    2 
 drivers/scsi/qedf/qedf_main.c                              |   21 +
 drivers/slimbus/Kconfig                                    |    3 
 drivers/slimbus/qcom-ngd-ctrl.c                            |   14 
 drivers/soc/qcom/smem_state.c                              |    3 
 drivers/soc/qcom/smsm.c                                    |   20 
 drivers/soc/tegra/Kconfig                                  |    1 
 drivers/soundwire/cadence_master.c                         |    9 
 drivers/soundwire/intel.c                                  |    1 
 drivers/spi/spi-dw-bt1.c                                   |    4 
 drivers/spi/spi-meson-spicc.c                              |    6 
 drivers/spi/spi-mt7621.c                                   |    8 
 drivers/spi/spi-omap-100k.c                                |    1 
 drivers/spi/spi-qup.c                                      |   21 -
 drivers/spi/spi-s3c64xx.c                                  |    9 
 drivers/spi/spi.c                                          |    2 
 drivers/spmi/spmi-pmic-arb.c                               |   13 
 drivers/staging/greybus/audio_helper.c                     |   11 
 drivers/staging/media/meson/vdec/vdec_hevc.c               |    6 
 drivers/staging/media/sunxi/cedrus/cedrus.c                |    4 
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c           |    5 
 drivers/staging/rtl8723bs/core/rtw_cmd.c                   |   16 
 drivers/staging/rtl8723bs/os_dep/os_intfs.c                |   60 +-
 drivers/staging/vt6655/device_main.c                       |    8 
 drivers/thermal/cpufreq_cooling.c                          |   10 
 drivers/thermal/intel/intel_powerclamp.c                   |    4 
 drivers/thermal/qcom/tsens-v0_1.c                          |    2 
 drivers/thunderbolt/nhi.c                                  |   49 ++
 drivers/thunderbolt/switch.c                               |   24 +
 drivers/thunderbolt/tb.h                                   |    1 
 drivers/thunderbolt/tb_regs.h                              |    1 
 drivers/thunderbolt/usb4.c                                 |   20 
 drivers/tty/serial/8250/8250_core.c                        |   16 
 drivers/tty/serial/8250/8250_pci.c                         |    5 
 drivers/tty/serial/8250/8250_port.c                        |   18 
 drivers/tty/serial/fsl_lpuart.c                            |    2 
 drivers/tty/serial/jsm/jsm_driver.c                        |    3 
 drivers/tty/serial/xilinx_uartps.c                         |    2 
 drivers/usb/common/debug.c                                 |   96 +++-
 drivers/usb/core/quirks.c                                  |    4 
 drivers/usb/dwc3/core.c                                    |   17 
 drivers/usb/dwc3/core.h                                    |    4 
 drivers/usb/gadget/function/f_printer.c                    |   12 
 drivers/usb/host/xhci-dbgcap.c                             |    2 
 drivers/usb/host/xhci-mem.c                                |    7 
 drivers/usb/host/xhci-plat.c                               |   18 
 drivers/usb/host/xhci.c                                    |    3 
 drivers/usb/host/xhci.h                                    |    1 
 drivers/usb/misc/idmouse.c                                 |    8 
 drivers/usb/mtu3/mtu3_core.c                               |    2 
 drivers/usb/mtu3/mtu3_plat.c                               |    2 
 drivers/usb/musb/musb_gadget.c                             |    3 
 drivers/usb/storage/unusual_devs.h                         |    6 
 drivers/vhost/vsock.c                                      |    2 
 drivers/video/fbdev/smscufx.c                              |   14 
 drivers/video/fbdev/stifb.c                                |    2 
 drivers/xen/gntdev-common.h                                |    3 
 drivers/xen/gntdev.c                                       |   80 ++-
 fs/btrfs/extent-tree.c                                     |    3 
 fs/btrfs/free-space-cache.c                                |    6 
 fs/btrfs/qgroup.c                                          |   15 
 fs/btrfs/scrub.c                                           |   36 +
 fs/btrfs/super.c                                           |   11 
 fs/cifs/file.c                                             |    9 
 fs/cifs/smb2pdu.c                                          |    7 
 fs/cifs/smb2transport.c                                    |   10 
 fs/dlm/ast.c                                               |    6 
 fs/dlm/lock.c                                              |   16 
 fs/dlm/lowcomms.c                                          |    4 
 fs/eventfd.c                                               |   10 
 fs/ext2/super.c                                            |    6 
 fs/ext4/fast_commit.c                                      |   40 +
 fs/ext4/file.c                                             |    6 
 fs/ext4/inode.c                                            |   14 
 fs/ext4/namei.c                                            |   17 
 fs/ext4/resize.c                                           |    2 
 fs/ext4/super.c                                            |   25 -
 fs/f2fs/checkpoint.c                                       |   47 +-
 fs/f2fs/data.c                                             |    4 
 fs/f2fs/extent_cache.c                                     |    3 
 fs/f2fs/f2fs.h                                             |    9 
 fs/f2fs/gc.c                                               |   10 
 fs/f2fs/recovery.c                                         |   23 -
 fs/f2fs/segment.c                                          |    2 
 fs/f2fs/super.c                                            |   15 
 fs/file_table.c                                            |    7 
 fs/fs-writeback.c                                          |   37 +
 fs/internal.h                                              |   10 
 fs/io-wq.c                                                 |    2 
 fs/io_uring.c                                              |   43 +-
 fs/jbd2/commit.c                                           |    2 
 fs/jbd2/journal.c                                          |   10 
 fs/jbd2/recovery.c                                         |    1 
 fs/jbd2/transaction.c                                      |    6 
 fs/ksmbd/server.c                                          |    4 
 fs/ksmbd/smb2pdu.c                                         |   13 
 fs/ksmbd/smb_common.c                                      |    6 
 fs/nfsd/nfs3proc.c                                         |   11 
 fs/nfsd/nfs4proc.c                                         |   19 
 fs/nfsd/nfs4recover.c                                      |    4 
 fs/nfsd/nfs4state.c                                        |    5 
 fs/nfsd/nfs4xdr.c                                          |   13 
 fs/nfsd/nfsproc.c                                          |    6 
 fs/nfsd/xdr4.h                                             |    3 
 fs/ntfs3/inode.c                                           |    2 
 fs/ntfs3/xattr.c                                           |  102 -----
 fs/open.c                                                  |   11 
 fs/quota/quota_tree.c                                      |   38 +
 fs/splice.c                                                |   10 
 fs/userfaultfd.c                                           |    4 
 fs/xfs/xfs_super.c                                         |   10 
 include/linux/ata.h                                        |   39 +
 include/linux/bpf_verifier.h                               |   11 
 include/linux/dynamic_debug.h                              |   11 
 include/linux/eventfd.h                                    |    2 
 include/linux/fs.h                                         |    9 
 include/linux/iova.h                                       |    2 
 include/linux/once.h                                       |   28 +
 include/linux/ring_buffer.h                                |    2 
 include/linux/sched.h                                      |    2 
 include/linux/serial_8250.h                                |    1 
 include/linux/serial_core.h                                |    3 
 include/linux/skbuff.h                                     |    2 
 include/linux/sunrpc/svc.h                                 |   19 
 include/linux/tcp.h                                        |    2 
 include/linux/trace.h                                      |   36 +
 include/linux/trace_events.h                               |    1 
 include/net/ieee802154_netdev.h                            |   12 
 include/net/tcp.h                                          |    5 
 include/scsi/libiscsi.h                                    |    6 
 include/uapi/rdma/mlx5-abi.h                               |    1 
 kernel/bpf/bpf_local_storage.c                             |    4 
 kernel/bpf/bpf_task_storage.c                              |    8 
 kernel/bpf/btf.c                                           |    2 
 kernel/bpf/hashtab.c                                       |   30 +
 kernel/bpf/syscall.c                                       |    2 
 kernel/bpf/verifier.c                                      |   42 +-
 kernel/cgroup/cgroup.c                                     |    6 
 kernel/cgroup/cpuset.c                                     |   18 
 kernel/gcov/gcc_4_7.c                                      |   18 
 kernel/livepatch/transition.c                              |   18 
 kernel/rcu/tasks.h                                         |    2 
 kernel/rcu/tree.c                                          |   17 
 kernel/rcu/tree_plugin.h                                   |    3 
 kernel/trace/ftrace.c                                      |    8 
 kernel/trace/kprobe_event_gen_test.c                       |   49 ++
 kernel/trace/ring_buffer.c                                 |   87 ++++
 kernel/trace/trace.c                                       |   66 +++
 kernel/trace/trace_eprobe.c                                |   60 --
 kernel/trace/trace_events_synth.c                          |   23 -
 kernel/trace/trace_kprobe.c                                |   60 --
 kernel/trace/trace_osnoise.c                               |    3 
 kernel/trace/trace_probe_kernel.h                          |  115 +++++
 lib/Kconfig.debug                                          |    8 
 lib/dynamic_debug.c                                        |   45 --
 lib/once.c                                                 |   30 +
 mm/damon/vaddr.c                                           |   10 
 mm/hugetlb.c                                               |   37 -
 mm/mmap.c                                                  |    5 
 net/bluetooth/hci_core.c                                   |   34 +
 net/bluetooth/hci_sysfs.c                                  |    3 
 net/bluetooth/l2cap_core.c                                 |   17 
 net/bluetooth/rfcomm/sock.c                                |    3 
 net/can/bcm.c                                              |    7 
 net/core/skmsg.c                                           |   12 
 net/core/stream.c                                          |    3 
 net/ieee802154/socket.c                                    |    4 
 net/ipv4/inet_hashtables.c                                 |    4 
 net/ipv4/netfilter/nft_fib_ipv4.c                          |    3 
 net/ipv4/tcp.c                                             |   16 
 net/ipv4/tcp_output.c                                      |   19 
 net/ipv6/netfilter/nft_fib_ipv6.c                          |    6 
 net/mac80211/cfg.c                                         |    3 
 net/netfilter/nf_conntrack_core.c                          |   18 
 net/openvswitch/datapath.c                                 |   18 
 net/rds/tcp.c                                              |    2 
 net/sctp/auth.c                                            |   18 
 net/unix/garbage.c                                         |   20 
 net/vmw_vsock/virtio_transport_common.c                    |    2 
 net/xdp/xsk.c                                              |   22 -
 net/xdp/xsk_queue.h                                        |   22 -
 net/xfrm/xfrm_input.c                                      |   18 
 net/xfrm/xfrm_ipcomp.c                                     |    1 
 scripts/Kbuild.include                                     |   23 +
 scripts/package/mkspec                                     |    4 
 scripts/selinux/install_policy.sh                          |    2 
 security/Kconfig.hardening                                 |   13 
 security/integrity/ima/ima_appraise.c                      |   12 
 sound/core/pcm_dmaengine.c                                 |    8 
 sound/core/rawmidi.c                                       |    2 
 sound/core/sound_oss.c                                     |   13 
 sound/pci/hda/hda_beep.c                                   |   15 
 sound/pci/hda/hda_beep.h                                   |    1 
 sound/pci/hda/patch_hdmi.c                                 |    6 
 sound/pci/hda/patch_realtek.c                              |   11 
 sound/pci/hda/patch_sigmatel.c                             |   25 -
 sound/soc/codecs/da7219.c                                  |    5 
 sound/soc/codecs/lpass-tx-macro.c                          |   13 
 sound/soc/codecs/mt6359-accdet.c                           |    6 
 sound/soc/codecs/mt6660.c                                  |    8 
 sound/soc/codecs/tas2764.c                                 |   78 +--
 sound/soc/codecs/wcd9335.c                                 |    2 
 sound/soc/codecs/wcd934x.c                                 |    2 
 sound/soc/codecs/wm5102.c                                  |    6 
 sound/soc/codecs/wm5110.c                                  |    6 
 sound/soc/codecs/wm8997.c                                  |    6 
 sound/soc/fsl/eukrea-tlv320.c                              |    8 
 sound/soc/sh/rcar/ctu.c                                    |    6 
 sound/soc/sh/rcar/dvc.c                                    |    6 
 sound/soc/sh/rcar/mix.c                                    |    6 
 sound/soc/sh/rcar/src.c                                    |    5 
 sound/soc/sh/rcar/ssi.c                                    |    4 
 sound/soc/sof/sof-pci-dev.c                                |    2 
 sound/usb/card.c                                           |   32 +
 sound/usb/endpoint.c                                       |    6 
 sound/usb/quirks.c                                         |   42 --
 sound/usb/quirks.h                                         |    2 
 sound/usb/usbaudio.h                                       |    1 
 tools/bpf/bpftool/btf_dumper.c                             |    2 
 tools/bpf/bpftool/main.c                                   |   10 
 tools/lib/bpf/xsk.c                                        |    6 
 tools/objtool/elf.c                                        |    7 
 tools/perf/util/intel-pt.c                                 |    9 
 tools/testing/selftests/arm64/signal/testcases/testcases.c |    2 
 tools/testing/selftests/tpm2/tpm2.py                       |    4 
 529 files changed, 4804 insertions(+), 2195 deletions(-)

Adam Skladowski (1):
      clk: qcom: gcc-sm6115: Override default Alpha PLL regs

Adrian Hunter (1):
      perf intel-pt: Fix segfault in intel_pt_print_info() with uClibc

Adrián Larumbe (2):
      drm/meson: reorder driver deinit sequence to fix use-after-free bug
      drm/meson: explicitly remove aggregate driver at module unload time

Aharon Landau (1):
      RDMA/mlx5: Don't compare mkey tags in DEVX indirect mkey

Albert Briscoe (1):
      usb: gadget: function: fix dangling pnp_string in f_printer.c

Alex Sverdlin (1):
      ARM: 9242/1: kasan: Only map modules if CONFIG_KASAN_VMALLOC=n

Alexander Aring (5):
      fs: dlm: fix race between test_bit() and queue_work()
      fs: dlm: handle -EBUSY first in lock arg validation
      fs: dlm: fix race in lowcomms
      net: ieee802154: return -EINVAL for unknown addr type
      Revert "net/ieee802154: reject zero-sized raw_sendmsg()"

Alexander Coffin (1):
      wifi: brcmfmac: fix use-after-free bug in brcmf_netdev_start_xmit()

Alexander Stein (7):
      ARM: dts: imx6q: add missing properties for sram
      ARM: dts: imx6dl: add missing properties for sram
      ARM: dts: imx6qp: add missing properties for sram
      ARM: dts: imx6sl: add missing properties for sram
      ARM: dts: imx6sll: add missing properties for sram
      ARM: dts: imx6sx: add missing properties for sram
      arm64: dts: imx8mp: Add snps,gfladj-refclk-lpm-sel quirk to USB nodes

Alvin Šipraga (2):
      drm: bridge: adv7511: fix CEC power down control register offset
      drm: bridge: adv7511: unregister cec i2c device after cec adapter

Amir Goldstein (1):
      locks: fix TOCTOU race when granting write lease

Andreas Pape (1):
      ALSA: dmaengine: increment buffer pointer atomically

Andrew Bresticker (2):
      riscv: Allow PROT_WRITE-only mmap()
      riscv: Make VM_WRITE imply VM_READ

Andrew Gaul (1):
      r8152: Rate limit overflow messages

Andrew Perepechko (1):
      jbd2: wake up journal waiters in FIFO order, not LIFO

Andri Yngvason (1):
      HID: multitouch: Add memory barriers

Anna Schumaker (1):
      NFSD: Return nfserr_serverfault if splice_ok but buf->pages have data

Anssi Hannula (4):
      can: kvaser_usb: Fix use of uninitialized completion
      can: kvaser_usb_leaf: Fix overread with an invalid command
      can: kvaser_usb_leaf: Fix TX queue out of sync after restart
      can: kvaser_usb_leaf: Fix CAN state after restart

Antoine Tenart (2):
      netfilter: conntrack: fix the gc rescheduling delay
      netfilter: conntrack: revisit the gc initial rescheduling bias

Ard Biesheuvel (1):
      efi: libstub: drop pointless get_memory_map() call

Aric Cyr (1):
      drm/amd/display: Remove interface for periodic interrupt 1

Arun Easi (1):
      scsi: tracing: Fix compile error in trace_array calls when TRACING is disabled

Arvid Norlander (1):
      ACPI: video: Add Toshiba Satellite/Portege Z830 quirk

Asmaa Mnebhi (1):
      i2c: mlxbf: support lock mechanism

Baokun Li (1):
      ext4: fix null-ptr-deref in ext4_write_info

Baolin Wang (1):
      mm/damon: validate if the pmd entry is present before accessing

Bart Van Assche (1):
      RDMA/srp: Fix srp_abort()

Bernard Metzler (2):
      RDMA/siw: Always consume all skbuf data in sk_data_ready() upcall.
      RDMA/siw: Fix QP destroy to wait for all references dropped.

Bitterblue Smith (4):
      wifi: rtl8xxxu: Fix skb misuse in TX queue selection
      wifi: rtl8xxxu: gen2: Fix mistake in path B IQ calibration
      wifi: rtl8xxxu: Remove copy-paste leftover in gen2_update_rate_mask
      wifi: rtl8xxxu: Fix AIFS written to REG_EDCA_*_PARAM

Bob Pearson (1):
      RDMA/rxe: Fix resize_finish() in rxe_queue.c

Callum Osmotherly (1):
      ALSA: hda/realtek: remove ALC289_FIXUP_DUAL_SPK for Dell 5530

Carlos Llamas (1):
      mm/mmap: undo ->mmap() when arch_validate_flags() fails

Chao Qin (1):
      powercap: intel_rapl: fix UBSAN shift-out-of-bounds issue

Chao Yu (3):
      f2fs: fix to do sanity check on destination blkaddr during recovery
      f2fs: fix to do sanity check on summary info
      f2fs: fix to account FS_CP_DATA_IO correctly

Chen-Yu Tsai (2):
      drm/bridge: parade-ps8640: Fix regulator supply order
      clk: mediatek: mt8183: mfgcfg: Propagate rate changes to parent

Christian Brauner (1):
      ntfs3: rework xattr handlers and switch to POSIX ACL VFS helpers

Christophe JAILLET (10):
      MIPS: SGI-IP27: Free some unused memory
      nfsd: Fix a memory leak in an error handling path
      spi: mt7621: Fix an error message in mt7621_spi_probe()
      mmc: au1xmmc: Fix an error handling path in au1xmmc_probe()
      ASoC: da7219: Fix an error handling path in da7219_register_dai_clks()
      mmc: wmt-sdmmc: Fix an error handling path in wmt_mci_probe()
      mfd: intel_soc_pmic: Fix an error handling path in intel_soc_pmic_i2c_probe()
      mfd: fsl-imx25: Fix an error handling path in mx25_tsadc_setup_irq()
      mfd: lp8788: Fix an error handling path in lp8788_probe()
      mfd: lp8788: Fix an error handling path in lp8788_irq_init() and lp8788_irq_init()

Chuck Lever (7):
      NFSD: Protect against send buffer overflow in NFSv3 READDIR
      NFSD: Protect against send buffer overflow in NFSv2 READ
      NFSD: Protect against send buffer overflow in NFSv3 READ
      SUNRPC: Fix svcxdr_init_decode's end-of-buffer calculation
      SUNRPC: Fix svcxdr_init_encode's buflen calculation
      NFSD: Protect against send buffer overflow in NFSv2 READDIR
      NFSD: Fix handling of oversized NFSv4 COMPOUND requests

Chunfeng Yun (2):
      phy: phy-mtk-tphy: fix the phy type setting issue
      usb: mtu3: fix failed runtime suspend in host only mode

Claudiu Beznea (4):
      iio: adc: at91-sama5d2_adc: fix AT91_SAMA5D2_MR_TRACKTIM_MAX
      iio: adc: at91-sama5d2_adc: check return status for pressure and touch
      iio: adc: at91-sama5d2_adc: lock around oversampling and sample freq
      iio: adc: at91-sama5d2_adc: disable/prepare buffer on suspend/resume

Coly Li (1):
      bcache: fix set_at_max_writeback_rate() for multiple attached devices

Conor Dooley (4):
      arm64: topology: move store_cpu_topology() to shared code
      riscv: topology: fix default topology reporting
      mailbox: mpfs: fix handling of the reg property
      mailbox: mpfs: account for mbox offsets while sending

Dai Ngo (1):
      NFSD: fix use-after-free on source server when doing inter-server copy

Daisuke Matsuda (1):
      IB: Set IOVA/LENGTH on IB_MR in core/uverbs layers

Damian Muszynski (1):
      crypto: qat - fix DMA transfer direction

Dan Carpenter (11):
      wifi: rtl8xxxu: tighten bounds checking in rtl8xxxu_read_efuse()
      drm/bridge: Avoid uninitialized variable warning
      ASoC: mt6359: fix tests for platform_get_irq() failure
      platform/chrome: fix memory corruption in ioctl
      fpga: prevent integer overflow in dfl_feature_ioctl_set_irq()
      mtd: rawnand: meson: fix bit map use in meson_nfc_ecc_correct()
      drivers: serial: jsm: fix some leaks in probe
      mfd: fsl-imx25: Fix check for platform_get_irq() errors
      iommu/omap: Fix buffer overflow in debugfs
      crypto: marvell/octeontx - prevent integer overflows
      crypto: cavium - prevent integer overflow loading firmware

Dang Huynh (1):
      clk: qcom: sm6115: Select QCOM_GDSC

Daniel Golle (5):
      wifi: rt2x00: don't run Rt5592 IQ calibration on MT7620
      wifi: rt2x00: set correct TX_SW_CFG1 MAC register for MT7620
      wifi: rt2x00: set VGC gain for both chains of MT7620
      wifi: rt2x00: set SoC wmac clock register
      wifi: rt2x00: correctly set BBP register 86 for MT7620

Dario Binacchi (1):
      dmaengine: mxs: use platform_driver_register

Dave Jiang (1):
      dmaengine: ioat: stop mod_timer from resurrecting deleted timer in __cleanup()

David Collins (1):
      spmi: pmic-arb: correct duplicate APID to PPID mapping logic

David Gow (1):
      drm/amd/display: fix overflow on MIN_I64 definition

David Sloan (1):
      md/raid5: Remove unnecessary bio_put() in raid5_read_one_chunk()

Dmitry Baryshkov (1):
      drm/msm/dpu: index dpu_kms->hw_vbif using vbif_idx

Dmitry Osipenko (7):
      drm/virtio: Check whether transferred 2D BO is shmem
      drm/virtio: Unlock reservations on virtio_gpu_object_shmem_init() error
      drm/virtio: Use appropriate atomic state in virtio_gpu_plane_cleanup_fb()
      media: cedrus: Set the platform driver data earlier
      media: cedrus: Fix endless loop in cedrus_h265_skip_bits()
      drm/virtio: Correct drm_gem_shmem_get_sg_table() error handling
      soc/tegra: fuse: Drop Kconfig dependency on TEGRA20_APB_DMA

Dmitry Torokhov (2):
      ARM: dts: exynos: correct s5k6a3 reset polarity on Midas family
      ARM: dts: exynos: fix polarity of VBUS GPIO of Origen

Dongliang Mu (2):
      phy: qualcomm: call clk_disable_unprepare in the error handling
      usb: idmouse: fix an uninit-value in idmouse_open

Doug Smythies (1):
      cpufreq: intel_pstate: Add Tigerlake support in no-HWP mode

Duoming Zhou (2):
      mISDN: fix use-after-free bugs in l1oip timer handlers
      scsi: libsas: Fix use-after-free bug in smp_execute_task_sg()

Dylan Yudaken (1):
      eventfd: guard wake_up in eventfd fs calls as well

Eddie James (2):
      iio: pressure: dps310: Refactor startup procedure
      iio: pressure: dps310: Reset chip after timeout

Enzo Matsumiya (1):
      cifs: return correct error in ->calc_signature()

Eric Dumazet (2):
      once: add DO_ONCE_SLOW() for sleepable contexts
      tcp: annotate data-race around tcp_md5sig_pool_populated

Fangrui Song (1):
      riscv: Pass -mno-relax only on lld < 15.0.0

Filipe Manana (1):
      btrfs: fix race between quota enable and quota rescan ioctl

Gaosheng Cui (1):
      nvmem: core: Fix memleak in nvmem_register()

Gaurav Kohli (1):
      hv_netvsc: Fix race between VF offering and VF association message from host

Geert Uytterhoeven (1):
      ARM: Drop CMDLINE_* dependency on ATAGS

Gerd Hoffmann (1):
      drm/bochs: fix blanking

Greg Kroah-Hartman (3):
      staging: greybus: audio_helper: remove unused and wrong debugfs usage
      selinux: use "grep -E" instead of "egrep"
      Linux 5.15.75

Guilherme G. Piccoli (1):
      firmware: google: Test spinlock on panic path to avoid lockups

Haibo Chen (1):
      ARM: dts: imx7d-sdb: config the max pressure for tsc2046

Hamza Mahfooz (1):
      Revert "drm/amdgpu: use dirty framebuffer helper"

Hangyu Hua (2):
      misc: ocxl: fix possible refcount leak in afu_ioctl()
      media: platform: fix some double free in meson-ge2d and mtk-jpeg and s5p-mfc

Hans de Goede (4):
      platform/x86: msi-laptop: Fix old-ec check for backlight registering
      platform/x86: msi-laptop: Fix resource cleanup
      ACPI: tables: FPDT: Don't call acpi_os_map_memory() on invalid phys address
      platform/x86: msi-laptop: Change DMI match / alias strings to fix module autoloading

Haren Myneni (1):
      powerpc/pseries/vas: Pass hw_cpu_id to node associativity HCALL

Hari Chandrakanthan (1):
      wifi: mac80211: allow bw change during channel switch in mesh

Helge Deller (1):
      parisc: fbdev/stifb: Align graphics memory size to 4MB

Hou Tao (3):
      bpf: Disable preemption when increasing per-cpu map_locked
      bpf: Propagate error from htab_lock_bucket() to userspace
      bpf: Use this_cpu_{inc|dec|inc_return} for bpf_task_storage_busy

Howard Hsu (1):
      wifi: mt76: mt7915: do not check state before configuring implicit beamform

Huacai Chen (1):
      UM: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Hyunwoo Kim (2):
      fbdev: smscufx: Fix use-after-free in ufx_ops_open()
      HID: roccat: Fix use-after-free in roccat_read()

Ian Nam (1):
      clk: zynqmp: Fix stack-out-of-bounds in strncpy`

Ian Rogers (1):
      selftests/xsk: Avoid use-after-free on ctx

Ignat Korchagin (1):
      crypto: akcipher - default implementation for setting a private key

Ilpo Järvinen (1):
      serial: 8250: Toggle IER bits on only after irq has been set up

Ivan T. Ivanov (1):
      clk: bcm2835: Round UART input clock up

Jack Wang (2):
      HSI: omap_ssi_port: Fix dma_map_sg error check
      mailbox: bcm-ferxrm-mailbox: Fix error check for dma_map_sg

Jacob Keller (1):
      ice: set tx_tstamps when creating new Tx rings via ethtool

Jaegeuk Kim (3):
      f2fs: complete checkpoints during remount
      f2fs: flush pending checkpoints when freezing super
      f2fs: increase the limit for reserve_root

Jairaj Arava (1):
      ASoC: SOF: pci: Change DMI match info to support all Chrome platforms

Jakob Hauser (1):
      iio: magnetometer: yas530: Change data type of hard_offsets to signed

Jakub Kicinski (1):
      eth: alx: take rtnl_lock on resume

James Cowgill (1):
      hwrng: arm-smccc-trng - fix NO_ENTROPY handling

James Morse (1):
      arm64: errata: Add Cortex-A55 to the repeat tlbi list

Jameson Thies (1):
      platform/chrome: cros_ec: Notify the PM of wake events during resume

Jan Kara (3):
      ext4: avoid crash when inline data creation follows DIO write
      ext4: fix check for block being out of directory size
      ext2: Use kvmalloc() for group descriptor array

Jane Chu (1):
      x86/mce: Retrieve poison range from hardware

Janis Schoetterl-Glausch (1):
      kbuild: rpm-pkg: fix breakage when V=1 is used

Jarkko Nikula (1):
      i2c: designware: Fix handling of real but unexpected device interrupts

Jason A. Donenfeld (1):
      hwmon: (sht4x) do not overflow clamping operation on 32-bit platforms

Javier Martinez Canillas (2):
      drm: Use size_t type for len variable in drm_copy_field()
      drm: Prevent drm_copy_field() to attempt copying a NULL pointer

Jean-Francois Le Fillatre (1):
      usb: add quirks for Lenovo OneLink+ Dock

Jerry Lee 李修賢 (1):
      ext4: continue to expand file system when the target size doesn't reach

Jesus Fernandez Manzano (1):
      wifi: ath11k: fix number of VHT beamformee spatial streams

Jianglei Nie (4):
      drm/nouveau: fix a use-after-free in nouveau_gem_prime_import_sg_table()
      bnx2x: fix potential memory leak in bnx2x_tpa_stop()
      drm/nouveau/nouveau_bo: fix potential memory leak in nouveau_bo_alloc()
      usb: host: xhci: Fix potential memory leak in xhci_alloc_stream_info()

Jiasheng Jiang (3):
      ASoC: rsnd: Add check for rsnd_mod_power_on
      fsi: core: Check error number after calling ida_simple_get
      mfd: sm501: Add check for platform_driver_register()

Jie Hai (3):
      dmaengine: hisilicon: Disable channels when unregister hisi_dma
      dmaengine: hisilicon: Fix CQ head update
      dmaengine: hisilicon: Add multi-thread support for a DMA channel

Jim Cromie (4):
      dyndbg: fix static_branch manipulation
      dyndbg: fix module.dyndbg handling
      dyndbg: let query-modname override actual module name
      dyndbg: drop EXPORTed dynamic_debug_exec_queries

Jinke Han (1):
      ext4: place buffer head allocation before handle start

Joel Stanley (1):
      clk: ast2600: BCLK comes from EPLL

Jonathan Cameron (1):
      iio: ABI: Fix wrong format of differential capacitance channel ABI.

Josh Triplett (1):
      ext4: don't run ext4lazyinit for read-only filesystems

José Expósito (1):
      media: uvcvideo: Fix memory leak in uvc_gpio_parse

Junichi Uekawa (1):
      vhost/vsock: Use kvmalloc/kvfree for larger packets.

Justin Chen (2):
      usb: host: xhci-plat: suspend and resume clocks
      usb: host: xhci-plat: suspend/resume clks for brcm

Kees Cook (7):
      hardening: Avoid harmless Clang option under CONFIG_INIT_STACK_ALL_ZERO
      hardening: Remove Clang's enable flag for -ftrivial-auto-var-init=zero
      sh: machvec: Use char[] for section boundaries
      x86/microcode/AMD: Track patch allocation size explicitly
      MIPS: BCM47XX: Cast memcmp() of function to (void *)
      ARM: decompressor: Include .data.rel.ro.local
      x86/entry: Work around Clang __bdos() bug

Keith Busch (1):
      nvme: copy firmware_rev on each init

Khaled Almahallawy (1):
      drm/dp: Don't rewrite link config when setting phy test pattern

Khalid Masum (1):
      xfrm: Update ipcomp_scratches with NULL when freed

Kiran K (1):
      Bluetooth: btintel: Mark Intel controller to support LE_STATES quirk

Koba Ko (1):
      crypto: ccp - Release dma channels before dmaengine unrgister

Kohei Tarumizu (1):
      x86/resctrl: Fix to restore to original value when re-enabling hardware prefetch register

Krzysztof Kozlowski (5):
      ASoC: wcd9335: fix order of Slimbus unprepare/disable
      ASoC: wcd934x: fix order of Slimbus unprepare/disable
      slimbus: qcom-ngd: use correct error in message of pdr_add_lookup() failure
      slimbus: qcom-ngd: cleanup in probe error path
      slimbus: qcom-ngd-ctrl: allow compile testing without QCOM_RPROC_COMMON

Kshitiz Varshney (1):
      hwrng: imx-rngc - Moving IRQ handler registering after imx_rngc_irq_mask_clear()

Kumar Kartikeya Dwivedi (1):
      bpf: Fix reference state management for synchronous callbacks

Kuogee Hsieh (1):
      drm/msm/dp: correct 1.62G link rate at dp_catalog_ctrl_config_msa()

Lalith Rajendran (1):
      ext4: make ext4_lazyinit_thread freezable

Lam Thai (1):
      bpftool: Fix a wrong type cast in btf_dumper_int

Lee Jones (1):
      bpf: Ensure correct locking around vulnerable function find_vpid()

Letu Ren (1):
      scsi: 3w-9xxx: Avoid disabling device if failing to enable it

Li Huafei (1):
      powerpc/kprobes: Fix null pointer reference in arch_prepare_kprobe()

Liang He (18):
      hwmon: (gsc-hwmon) Call of_node_get() before of_find_xxx API
      drm:pl111: Add of_node_put() when breaking out of for_each_available_child_of_node()
      drm/omap: dss: Fix refcount leak bugs
      ASoC: eureka-tlv320: Hold reference returned from of_find_xxx API
      memory: pl353-smc: Fix refcount leak bug in pl353_smc_probe()
      memory: of: Fix refcount leak bug in of_get_ddr_timings()
      memory: of: Fix refcount leak bug in of_lpddr3_get_ddr_timings()
      soc: qcom: smsm: Fix refcount leak bugs in qcom_smsm_probe()
      soc: qcom: smem_state: Add refcounting for the 'state->of_node'
      clk: meson: Hold reference returned by of_get_parent()
      clk: oxnas: Hold reference returned by of_get_parent()
      clk: qoriq: Hold reference returned by of_get_parent()
      clk: berlin: Add of_node_put() for of_get_parent()
      clk: sprd: Hold reference returned by of_get_parent()
      media: exynos4-is: fimc-is: Add of_node_put() when breaking out of loop
      phy: amlogic: phy-meson-axg-mipi-pcie-analog: Hold reference returned by of_get_parent()
      powerpc/sysdev/fsl_msi: Add missing of_node_put()
      powerpc/pci_dn: Add missing of_node_put()

Lin Yujun (2):
      MIPS: SGI-IP27: Fix platform-device leak in bridge_platform_create()
      clk: imx: scu: fix memleak on platform_device_add() fails

Linus Walleij (1):
      regulator: qcom_rpm: Fix circular deferral regression

Liu Jian (3):
      skmsg: Schedule psock work if the cached skb exists on the psock
      xfrm: Reinject transport-mode packets through workqueue
      net: If sock is dead don't access sock's sk_wq in sk_stream_wait_memory

Liu Shixin (1):
      mm: hugetlb: fix UAF in hugetlb_handle_userfault

Liviu Dudau (1):
      drm/komeda: Fix handling of atomic commits in the atomic_commit_tail hook

Logan Gunthorpe (2):
      md/raid5: Ensure stripe_fill happens on non-read IO with journal
      md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d

Lorenz Bauer (1):
      bpf: btf: fix truncated last_member_type_id in btf_struct_resolve

Lorenzo Bianconi (1):
      wifi: mt76: mt7615: add mt7615_mutex_acquire/release in mt7615_sta_set_decap_offload

Lucas Segarra Fernandez (1):
      crypto: qat - fix default value of WDT timer

Lucas Stach (2):
      ARM: dts: imx6qdl-kontron-samx6i: hook up DDC i2c bus
      drm: bridge: dw_hdmi: only trigger hotplug event on link change

Luciano Leão (1):
      x86/cpu: Include the header of init_ia32_feat_ctl()'s prototype

Luiz Augusto von Dentz (4):
      Bluetooth: RFCOMM: Fix possible deadlock on socket shutdown/release
      Bluetooth: hci_core: Fix not handling link timeouts propertly
      Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times
      Bluetooth: L2CAP: Fix user-after-free

Lukas Czerner (2):
      fs: record I_DIRTY_TIME even if inode already has I_DIRTY_INODE
      ext4: don't increase iversion counter for ea_inodes

Luke D. Jones (2):
      ALSA: hda/realtek: Correct pin configs for ASUS G533Z
      ALSA: hda/realtek: Add quirk for ASUS GV601R laptop

Lyude Paul (1):
      drm/nouveau/kms/nv140-: Disable interlacing

M. Vefa Bicakci (2):
      xen/gntdev: Prevent leaking grants
      xen/gntdev: Accommodate VMA splitting

Maciej Fijalkowski (1):
      xsk: Fix backpressure mechanism on Tx

Maciej S. Szmigiero (1):
      btrfs: don't print information about space cache or tree every remount

Maciej W. Rozycki (4):
      RISC-V: Make port I/O string accessors actually work
      PCI: Sanitise firmware BAR assignments behind a PCI-PCI bridge
      serial: 8250: Let drivers request full 16550A feature probing
      serial: 8250: Request full 16550A feature probing for OxSemi PCIe devices

Marek Behún (1):
      ARM: dts: turris-omnia: Fix mpp26 pin name and comment

Marek Szyprowski (1):
      spi: Ensure that sg_table won't be used after being freed

Mario Limonciello (3):
      thunderbolt: Explicitly enable lane adapter hotplug events at startup
      xhci: Don't show warning for reinit on known broken suspend
      ACPI: x86: Add a quirk for Dell Inspiron 14 2-in-1 for StorageD3Enable

Mark Brown (1):
      kselftest/arm64: Fix validatation termination record after EXTRA_CONTEXT

Mark Rutland (1):
      arm64: ftrace: fix module PLTs with mcount

Mark Zhang (1):
      RDMA/cm: Use SLID in the work completion as the DLID in responder side

Martin Blumenstingl (2):
      mtd: rawnand: intel: Read the chip-select line from the correct OF node
      mtd: rawnand: intel: Remove undocumented compatible string

Martin Liska (1):
      gcov: support GCC 12.1 and newer compilers

Martin Povišer (3):
      ASoC: tas2764: Allow mono streams
      ASoC: tas2764: Drop conflicting set_bias_level power setting
      ASoC: tas2764: Fix mute/unmute

Masahiro Yamada (3):
      kbuild: remove the target in signal traps when interrupted
      Kconfig.debug: simplify the dependency of DEBUG_INFO_DWARF4/5
      Kconfig.debug: add toolchain checks for DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT

Mateusz Kwiatkowski (1):
      drm/vc4: vec: Fix timings for VEC modes

Matt Ranostay (1):
      arm64: dts: ti: k3-j7200: fix main pinmux range

Maxim Mikityanskiy (1):
      net: wwan: iosm: Call mutex_init before locking it

Maxime Ripard (2):
      drm/mipi-dsi: Detach devices when removing the host
      clk: bcm2835: Make peripheral PLLC critical

Maya Matuszczyk (1):
      drm: panel-orientation-quirks: Add quirk for Anbernic Win600

Miaoqian Lin (6):
      clk: tegra: Fix refcount leak in tegra210_clock_init
      clk: tegra: Fix refcount leak in tegra114_clock_init
      clk: tegra20: Fix refcount leak in tegra20_clock_init
      HSI: omap_ssi: Fix refcount leak in ssi_probe
      media: xilinx: vipp: Fix refcount leak in xvip_graph_dma_init
      clk: ti: dra7-atl: Fix reference leak in of_dra7_atl_clk_probe

Michael Ellerman (1):
      powerpc/configs: Properly enable PAPR_SCM in pseries_defconfig

Michael Hennerich (1):
      iio: dac: ad5593r: Fix i2c read protocol requirements

Michael Walle (2):
      ARM: dts: kirkwood: lsxl: fix serial line
      ARM: dts: kirkwood: lsxl: remove first ethernet port

Michal Hocko (1):
      rcu: Back off upon fill_page_cache_func() allocation failure

Michal Jaron (1):
      iavf: Fix race between iavf_close and iavf_reset_task

Michal Koutný (1):
      cgroup: Honor caller's cgroup NS when resolving path

Michal Luczaj (1):
      KVM: x86/emulator: Fix handing of POP SS to correctly set interruptibility

Mickaël Salaün (1):
      ksmbd: Fix user namespace mapping

Mika Westerberg (2):
      net: thunderbolt: Enable DMA paths only after rings are enabled
      thunderbolt: Add back Intel Falcon Ridge end-to-end flow control workaround

Mike Christie (4):
      scsi: iscsi: Rename iscsi_conn_queue_work()
      scsi: iscsi: Add recv workqueue helpers
      scsi: iscsi: Run recv path from workqueue
      scsi: iscsi: iscsi_tcp: Fix null-ptr-deref while calling getpeername()

Mike Pattrick (2):
      openvswitch: Fix double reporting of drops in dropwatch
      openvswitch: Fix overreporting of drops in dropwatch

Mimi Zohar (1):
      ima: fix blocking of security.ima xattrs of unsupported algorithms

Nam Cao (2):
      staging: vt6655: fix some erroneous memory clean-up loops
      staging: vt6655: fix potential memory leak

Namjae Jeon (1):
      ksmbd: fix endless loop when encryption for response fails

Nathan Chancellor (3):
      powerpc/math_emu/efp: Include module.h
      drm/amd/display: Fix build breakage with CONFIG_DEBUG_FS=n
      lib/Kconfig.debug: Add check for non-constant .{s,u}leb128 support to DWARF5

Neal Cardwell (1):
      tcp: fix tcp_cwnd_validate() to not forget is_cwnd_limited

Neil Armstrong (1):
      spi: meson-spicc: do not rely on busy flag in pow2 clk ops

Nicholas Piggin (1):
      powerpc/64s: Fix GENERIC_CPU build flags for PPC970 / G5

Nico Pache (1):
      tracing/osnoise: Fix possible recursive locking in stop_per_cpu_kthreads

Niklas Cassel (4):
      ata: fix ata_id_sense_reporting_enabled() and ata_id_has_sense_reporting()
      ata: fix ata_id_has_devslp()
      ata: fix ata_id_has_ncq_autosense()
      ata: fix ata_id_has_dipm()

Nuno Sá (3):
      iio: adc: ad7923: fix channel readings for some variants
      iio: inkern: only release the device node when done with it
      iio: inkern: fix return value in devm_of_iio_channel_get_by_name()

Oleksandr Shamray (1):
      hwmon: (pmbus/mp2888) Fix sensors readouts for MPS Multi-phase mp2888 controller

Ondrej Mosnacek (1):
      userfaultfd: open userfaultfds with O_RDONLY

Pali Rohár (4):
      powerpc/boot: Explicitly disable usage of SPE instructions
      mtd: rawnand: fsl_elbc: Fix none ECC mode
      serial: 8250: Fix restoring termios speed after suspend
      powerpc: Fix SPE Power ISA properties for e500v1 platforms

Patrick Rudolph (1):
      regulator: core: Prevent integer underflow

Patryk Duda (1):
      platform/chrome: cros_ec_proto: Update version on GET_NEXT_EVENT failure

Pavel Begunkov (6):
      io_uring/net: don't update msg_name if not provided
      io_uring/af_unix: defer registered files gc to io_uring release
      io_uring: correct pinned_vm accounting
      io_uring/rw: fix short rw error handling
      io_uring/rw: fix error'ed retry return values
      io_uring/rw: fix unexpected link breakage

Peter Harliman Liem (1):
      crypto: inside-secure - Change swab to swab32

Phil Sutter (1):
      netfilter: nft_fib: Fix for rpath check with VRF devices

Pierre-Louis Bossart (1):
      soundwire: intel: fix error handling on dai registration issues

Ping-Ke Shih (1):
      wifi: rtlwifi: 8192de: correct checking of IQK reload

Piyush Mehta (1):
      usb: dwc3: core: Enable GUCTL1 bit 10 for fixing termination error after resume bug

Prashant Malani (1):
      platform/chrome: cros_ec_typec: Correct alt mode index

Qu Wenruo (2):
      btrfs: dump extra info if one free space cache has more bitmaps than it should
      btrfs: scrub: try to fix super block errors

Quanyang Wang (1):
      clk: zynqmp: pll: rectify rate rounding in zynqmp_pll_round_rate

Quentin Monnet (1):
      bpftool: Clear errno after libcap's checks

Quentin Schulz (2):
      gpio: rockchip: request GPIO mux to pinctrl when setting direction
      pinctrl: rockchip: add pinmux_ops.gpio_set_direction callback

Rafael J. Wysocki (1):
      thermal: intel_powerclamp: Use first online CPU as control_cpu

Rafael Mendonca (4):
      xhci: dbc: Fix memory leak in xhci_alloc_dbc()
      drm/amdgpu: Fix memory leak in hpd_rx_irq_create_workqueue()
      drm/vmwgfx: Fix memory leak in vmw_mksstat_add_ioctl()
      io-wq: Fix memory leak in worker creation

Randy Dunlap (2):
      ia64: export memory_add_physaddr_to_nid to fix cxl build error
      net: ethernet: ti: davinci_mdio: fix build for mdio bitbang uses

Ravi Gunasekaran (1):
      net: ethernet: ti: davinci_mdio: Add workaround for errata i2329

Richard Acayan (1):
      mmc: sdhci-msm: add compatible string check for sdm670

Richard Fitzgerald (1):
      soundwire: cadence: Don't overwrite msg->buf during write commands

Rik van Riel (1):
      livepatch: fix race between fork and KLP transition

Rishabh Bhatnagar (1):
      nvme-pci: set min_align_mask before calculating max_hw_sectors

Robert Marko (1):
      clk: qcom: apss-ipq6018: mark apcs_alias0_core_clk as critical

Robin Guo (1):
      usb: musb: Fix musb_gadget.c rxstate overflow bug

Robin Murphy (1):
      iommu/iova: Fix module config properly

Rohan McLure (1):
      powerpc: Fix fallocate and fadvise64_64 compat parameter combination

Ronnie Sahlberg (1):
      cifs: destage dirty pages before re-reading them for cache=none

Russell King (Oracle) (1):
      net: mvpp2: fix mvpp2 debugfs leak

Rustam Subkhankulov (1):
      platform/chrome: fix double-free in chromeos_laptop_prepare()

Sagi Grimberg (1):
      nvme-multipath: fix possible hang in live ns resize with ANA access

Sami Tolvanen (1):
      objtool: Preserve special st_shndx indexes in elf_update_symbol

Saranya Gopal (1):
      ALSA: hda/realtek: Add Intel Reference SSID to support headset keys

Sasha Levin (1):
      Revert "fs: check FMODE_LSEEK to control internal pipe splicing"

Saurabh Sengar (1):
      md: Replace snprintf with scnprintf

Saurav Kashyap (1):
      scsi: qedf: Populate sysfs attributes for vport

Sean Christopherson (3):
      KVM: nVMX: Unconditionally purge queued/injected events on nested "exit"
      KVM: nVMX: Don't propagate vmcs12's PERF_GLOBAL_CTRL settings to vmcs02
      KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS

Sean Wang (2):
      Bluetooth: btusb: mediatek: fix WMT failure during runtime suspend
      wifi: mt76: mt7921: reset msta->airtime_ac while clearing up hw value

Sebastian Krzyszkowiak (1):
      arm64: dts: imx8mq-librem5: Add bq25895 as max17055's power supply

Serge Semin (5):
      clk: vc5: Fix 5P49V6901 outputs disabling when enabling FOD
      clk: baikal-t1: Fix invalid xGMAC PTP clock divider
      clk: baikal-t1: Add shared xGMAC ref/ptp clocks internal parent
      clk: baikal-t1: Add SATA internal ref clock buffer
      ata: libahci_platform: Sanity check the DT child nodes number

Sherry Sun (1):
      tty: serial: fsl_lpuart: disable dma rx/tx use flags in lpuart_dma_shutdown

Shigeru Yoshida (1):
      nbd: Fix hung when signal interrupts nbd_start_device_ioctl()

Shuai Xue (1):
      ACPI: APEI: do not add task_work to kernel thread to avoid memory leak

Shubhrajyoti Datta (1):
      tty: xilinx_uartps: Fix the ignore_status

Simon Ser (1):
      drm/dp_mst: fix drm_dp_dpcd_read return value checks

Sindhu-Devale (1):
      RDMA/irdma: Align AE id codes to correct flush code and event

Srinivas Kandagatla (1):
      ASoC: codecs: tx-macro: fix kcontrol put

Srinivas Pandruvada (1):
      thermal: intel_powerclamp: Use get_cpu() instead of smp_processor_id() to avoid crash

Stefan Berger (1):
      selftest: tpm2: Add Client.__del__() to close /dev/tpm* handle

Stefan Wahren (1):
      clk: bcm2835: fix bcm2835_clock_rate_from_divisor declaration

Steve French (1):
      smb3: must initialize two ACL struct fields to zero

Steven Rostedt (Google) (11):
      ring-buffer: Allow splice to read previous partially read pages
      ring-buffer: Have the shortest_full queue be the shortest not longest
      ring-buffer: Check pending waiters when doing wake ups as well
      ring-buffer: Add ring_buffer_wake_waiters()
      ring-buffer: Fix race between reset page and reading page
      tracing: Wake up ring buffer waiters on closing of the file
      tracing: Wake up waiters when tracing is disabled
      tracing: Add ioctl() to force ring buffer waiters to wake up
      tracing: Move duplicate code of trace_kprobe/eprobe.c into header
      tracing: Add "(fault)" name injection to kernel probes
      tracing: Fix reading strings from synthetic events

Takashi Iwai (9):
      ALSA: oss: Fix potential deadlock at unregistration
      ALSA: rawmidi: Drop register_mutex in snd_rawmidi_free()
      ALSA: usb-audio: Fix potential memory leaks
      ALSA: usb-audio: Fix NULL dererence at error path
      drm/udl: Restore display mode on resume
      ALSA: hda: beep: Simplify keep-power-at-enable behavior
      ALSA: hda/hdmi: Don't skip notification handling during PM operation
      ALSA: usb-audio: Register card at the last interface
      ALSA: usb-audio: Fix last interface check for registration

Tetsuo Handa (7):
      btrfs: set generation before calling btrfs_clean_tree_block in btrfs_init_new_buffer
      Bluetooth: hci_{ldisc,serdev}: check percpu_init_rwsem() failure
      net: rds: don't hold sock lock when cancelling work from rds_tcp_reset_callbacks()
      net/ieee802154: reject zero-sized raw_sendmsg()
      wifi: ath9k: avoid uninit memory read in ath9k_htc_rx_msg()
      Bluetooth: L2CAP: initialize delayed works at l2cap_chan_create()
      net/ieee802154: don't warn zero-sized raw_sendmsg()

Thinh Nguyen (1):
      usb: common: debug: Check non-standard control requests

Tudor Ambarus (1):
      mtd: rawnand: atmel: Unmap streaming DMA mappings

Uwe Kleine-König (2):
      iio: ltc2497: Fix reading conversion results
      leds: lm3601x: Don't use mutex after it was destroyed

Vaishnav Achath (1):
      dmaengine: ti: k3-udma: Reset UDMA_CHAN_RT byte counters to prevent overflow

Varun Prakash (1):
      nvmet-tcp: add bounds check on Transfer Tag

Ville Syrjälä (3):
      drm/i915: Fix watermark calculations for gen12+ RC CCS modifier
      drm/i915: Fix watermark calculations for gen12+ MC CCS modifier
      drm/i915: Fix watermark calculations for gen12+ CCS+CC modifier

Vincent Knecht (1):
      thermal/drivers/qcom/tsens-v0_1: Fix MSM8939 fourth sensor hw_id

Vincent Whitchurch (1):
      spi: s3c64xx: Fix large transfers with DMA

Vitaly Kuznetsov (1):
      x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition

Vivek Kasireddy (1):
      udmabuf: Set ubuf->sg = NULL if the creation of sg table fails

Waiman Long (2):
      tracing: Disable interrupt or preemption before acquiring arch_spinlock_t
      cgroup/cpuset: Enable update_tasks_cpumask() on top_cpuset

Wang Kefeng (2):
      ARM: 9244/1: dump: Fix wrong pg_level in walk_pmd()
      ARM: 9247/1: mm: set readonly for MT_MEMORY_RO with ARM_LPAE

Wei Yongjun (1):
      power: supply: adp5061: fix out-of-bounds read in adp5061_get_chg_type()

Weili Qian (1):
      crypto: hisilicon/qm - fix missing put dfx access

Wen Gong (1):
      wifi: ath10k: add peer map clean up for peer delete in ath10k_sta_state()

Wenchao Chen (1):
      mmc: sdhci-sprd: Fix minimum clock limit

Wenting Zhang (1):
      riscv: always honor the CONFIG_CMDLINE_FORCE when parsing dtb

William Dean (1):
      mtd: devices: docg3: check the return value of devm_ioremap() in the probe

Wright Feng (1):
      wifi: brcmfmac: fix invalid address access when enabling SCAN log level

Xiaoke Wang (2):
      staging: rtl8723bs: fix potential memory leak in rtw_init_drv_sw()
      staging: rtl8723bs: fix a potential memory leak in rtw_init_cmd_priv()

Xin Long (1):
      sctp: handle the error returned from sctp_auth_asoc_init_active_key

Xu Qiang (3):
      spi: qup: add missing clk_disable_unprepare on error in spi_qup_resume()
      spi: qup: add missing clk_disable_unprepare on error in spi_qup_pm_resume_runtime()
      media: meson: vdec: add missing clk_disable_unprepare on error in vdec_hevc_start()

Xuewen Yan (1):
      thermal: cpufreq_cooling: Check the policy first in cpufreq_cooling_register()

YN Chen (1):
      wifi: mt76: sdio: fix transmitting packet hangs

Yang Yingliang (2):
      wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()
      drm/amdgpu: add missing pci_disable_device() in amdgpu_pmops_runtime_resume()

Ye Bin (7):
      jbd2: fix potential buffer head reference count leak
      jbd2: fix potential use-after-free in jbd2_fc_wait_bufs
      jbd2: add miss release buffer head in fc_do_one_pass()
      ext4: fix miss release buffer head in ext4_fc_write_inode
      ext4: fix potential memory leak in ext4_fc_record_modified_inode()
      ext4: fix potential memory leak in ext4_fc_record_regions()
      ext4: update 'state->fc_regions_size' after successful memory allocation

Ye Weihua (1):
      crypto: hisilicon/zip - fix mismatch in get/set sgl_sge_nr

Yicong Yang (1):
      iommu/arm-smmu-v3: Make default domain type of HiSilicon PTT device to identity

Yipeng Zou (2):
      tracing: kprobe: Fix kprobe event gen test module on exit
      tracing: kprobe: Make gen test module work in arm and riscv

Yu Kuai (3):
      blk-wbt: call rq_qos_add() after wb_normal is initialized
      blk-throttle: prevent overflow while calculating wait time
      blk-wbt: fix that 'rwb->wc' is always set to 1 in wbt_init()

Yunke Cao (1):
      media: uvcvideo: Use entity get_cur in uvc_ctrl_set

Yunxiang Li (1):
      drm/amd/display: Fix vblank refcount in vrr transition

Zeng Jingxiang (1):
      gpu: lontium-lt9611: Fix NULL pointer dereference in lt9611_connector_init()

Zhang Qilong (7):
      spi: dw: Fix PM disable depth imbalance in dw_spi_bt1_probe
      spi/omap100k:Fix PM disable depth imbalance in omap1_spi100k_probe
      ASoC: wm8997: Fix PM disable depth imbalance in wm8997_probe
      ASoC: wm5110: Fix PM disable depth imbalance in wm5110_probe
      ASoC: wm5102: Fix PM disable depth imbalance in wm5102_probe
      ASoC: mt6660: Fix PM disable depth imbalance in mt6660_i2c_probe
      f2fs: fix race condition on setting FI_NO_EXTENT flag

Zhang Rui (1):
      powercap: intel_rapl: Use standard Energy Unit for SPR Dram RAPL domain

Zhang Xiaoxu (2):
      cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message
      ksmbd: Fix wrong return value and message length check in smb2_ioctl()

Zhang Yi (1):
      ext4: ext4_read_bh_lock() should submit IO if the buffer isn't uptodate

Zheng Yejian (1):
      ftrace: Properly unset FTRACE_HASH_FL_MOD

Zheng Yongjun (2):
      net: fs_enet: Fix wrong check in do_pd_setup
      powerpc/powernv: add missing of_node_put() in opal_export_attrs()

Zhengchao Shao (1):
      crypto: sahara - don't sleep when in softirq

Zheyu Ma (2):
      drm/bridge: megachips: Fix a null pointer dereference bug
      media: cx88: Fix a null-ptr-deref bug in buffer_prepare()

Zhihao Cheng (2):
      quota: Check next/prev free block number after reading from quota file
      ext4: fix dir corruption when ext4_dx_add_entry() fails

Zhu Yanjun (2):
      RDMA/rxe: Fix "kernel NULL pointer dereference" error
      RDMA/rxe: Fix the error caused by qp->sk

Ziyang Xuan (1):
      can: bcm: check the result of can_send() in bcm_can_tx()

Zqiang (2):
      rcu: Avoid triggering strict-GP irq-work when RCU is idle
      rcu-tasks: Convert RCU_LOCKDEP_WARN() to WARN_ONCE()

hongao (1):
      drm/amdgpu: fix initial connector audio value

sunghwan jung (1):
      Revert "usb: storage: Add quirk for Samsung Fit flash"

