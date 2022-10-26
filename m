Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D306760DFC1
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 13:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbiJZLjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 07:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbiJZLjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 07:39:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9D1D73C5;
        Wed, 26 Oct 2022 04:38:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D99F0B821AB;
        Wed, 26 Oct 2022 11:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F43C433C1;
        Wed, 26 Oct 2022 11:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666784292;
        bh=u4RHwleJ+f84r3U5dgTrACKSLlnwP0eGyyDUnXXP024=;
        h=From:To:Cc:Subject:Date:From;
        b=ZQOLWHu94X8uggUIhj11QroQXbwTrVhD0RS2OHCapuysBzbYO335Db2KZSh3dWYew
         mRYyuFxzeXP3PNGnn7a3SZtanWSw5/6OR3H8DNcGagamNrQxoi1jq6ozs7TJ6hW5bj
         hJLhVT41XRulkXohro45Qlu9aaiaB+g134VrhErI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.150
Date:   Wed, 26 Oct 2022 13:38:05 +0200
Message-Id: <1666784285170114@kroah.com>
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

I'm announcing the release of the 5.10.150 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-iio                    |    2 
 Makefile                                                   |    8 
 arch/arm/Kconfig                                           |    1 
 arch/arm/boot/dts/armada-385-turris-omnia.dts              |    4 
 arch/arm/boot/dts/exynos4412-midas.dtsi                    |    2 
 arch/arm/boot/dts/exynos4412-origen.dts                    |    2 
 arch/arm/boot/dts/imx6dl.dtsi                              |    3 
 arch/arm/boot/dts/imx6q.dtsi                               |    3 
 arch/arm/boot/dts/imx6qp.dtsi                              |    6 
 arch/arm/boot/dts/imx6sl.dtsi                              |    3 
 arch/arm/boot/dts/imx6sll.dtsi                             |    3 
 arch/arm/boot/dts/imx6sx.dtsi                              |    6 
 arch/arm/boot/dts/imx7d-sdb.dts                            |    7 
 arch/arm/boot/dts/kirkwood-lsxl.dtsi                       |   16 
 arch/arm/mm/dump.c                                         |    2 
 arch/arm/mm/mmu.c                                          |    4 
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi          |    1 
 arch/arm64/kernel/ftrace.c                                 |   17 
 arch/arm64/kernel/topology.c                               |    2 
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
 arch/powerpc/kernel/pci_dn.c                               |    1 
 arch/powerpc/math-emu/math_efp.c                           |    1 
 arch/powerpc/platforms/powernv/opal.c                      |    1 
 arch/powerpc/sysdev/fsl_msi.c                              |    2 
 arch/riscv/Makefile                                        |    2 
 arch/riscv/include/asm/io.h                                |   16 
 arch/riscv/kernel/sys_riscv.c                              |    3 
 arch/riscv/mm/fault.c                                      |    3 
 arch/sh/include/asm/sections.h                             |    2 
 arch/sh/kernel/machvec.c                                   |   10 
 arch/um/kernel/um_arch.c                                   |    2 
 arch/x86/include/asm/hyperv-tlfs.h                         |    4 
 arch/x86/include/asm/microcode.h                           |    1 
 arch/x86/kernel/cpu/feat_ctl.c                             |    2 
 arch/x86/kernel/cpu/microcode/amd.c                        |    3 
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c                  |   12 
 arch/x86/kvm/emulate.c                                     |    2 
 arch/x86/kvm/vmx/nested.c                                  |   30 +
 arch/x86/kvm/vmx/vmx.c                                     |   12 
 arch/x86/xen/enlighten_pv.c                                |    3 
 block/blk-mq.c                                             |    3 
 block/blk-throttle.c                                       |    8 
 crypto/akcipher.c                                          |    8 
 drivers/acpi/acpi_video.c                                  |   16 
 drivers/acpi/apei/ghes.c                                   |    2 
 drivers/ata/libahci_platform.c                             |   14 
 drivers/block/nbd.c                                        |    6 
 drivers/bluetooth/btusb.c                                  |   47 +-
 drivers/bluetooth/hci_ldisc.c                              |    7 
 drivers/bluetooth/hci_serdev.c                             |   10 
 drivers/char/hw_random/imx-rngc.c                          |   14 
 drivers/clk/baikal-t1/ccu-div.c                            |   65 +++
 drivers/clk/baikal-t1/ccu-div.h                            |   10 
 drivers/clk/baikal-t1/clk-ccu-div.c                        |   26 +
 drivers/clk/bcm/clk-bcm2835.c                              |    8 
 drivers/clk/berlin/bg2.c                                   |    5 
 drivers/clk/berlin/bg2q.c                                  |    6 
 drivers/clk/clk-ast2600.c                                  |    2 
 drivers/clk/clk-oxnas.c                                    |    6 
 drivers/clk/clk-qoriq.c                                    |   10 
 drivers/clk/clk-versaclock5.c                              |    2 
 drivers/clk/mediatek/clk-mt8183-mfgcfg.c                   |    6 
 drivers/clk/meson/meson-aoclk.c                            |    5 
 drivers/clk/meson/meson-eeclk.c                            |    5 
 drivers/clk/meson/meson8b.c                                |    5 
 drivers/clk/qcom/apss-ipq6018.c                            |    2 
 drivers/clk/sprd/common.c                                  |    9 
 drivers/clk/tegra/clk-tegra114.c                           |    1 
 drivers/clk/tegra/clk-tegra20.c                            |    1 
 drivers/clk/tegra/clk-tegra210.c                           |    1 
 drivers/clk/ti/clk-dra7-atl.c                              |    9 
 drivers/clk/zynqmp/clkc.c                                  |    7 
 drivers/clk/zynqmp/pll.c                                   |   31 -
 drivers/crypto/cavium/cpt/cptpf_main.c                     |    6 
 drivers/crypto/ccp/ccp-dmaengine.c                         |    6 
 drivers/crypto/hisilicon/zip/zip_crypto.c                  |    4 
 drivers/crypto/inside-secure/safexcel_hash.c               |    8 
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c          |   18 
 drivers/crypto/qat/qat_common/qat_algs.c                   |  109 +++--
 drivers/crypto/qat/qat_common/qat_crypto.h                 |   24 +
 drivers/crypto/sahara.c                                    |   18 
 drivers/dma-buf/udmabuf.c                                  |    9 
 drivers/dma/hisi_dma.c                                     |   28 -
 drivers/dma/ioat/dma.c                                     |    6 
 drivers/firmware/efi/libstub/fdt.c                         |    8 
 drivers/firmware/google/gsmi.c                             |    9 
 drivers/fpga/dfl.c                                         |    2 
 drivers/fsi/fsi-core.c                                     |    3 
 drivers/gpu/drm/Kconfig                                    |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c             |    7 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                 |   14 
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c                |    2 
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c                     |    5 
 drivers/gpu/drm/amd/amdgpu/soc15.c                         |   25 +
 drivers/gpu/drm/amd/display/dc/calcs/bw_fixed.c            |    6 
 drivers/gpu/drm/amd/display/dc/core/dc.c                   |   16 
 drivers/gpu/drm/amd/display/dc/dc_stream.h                 |    6 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |   35 -
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h  |    3 
 drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h          |    8 
 drivers/gpu/drm/bridge/adv7511/adv7511.h                   |    5 
 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c               |    4 
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
 drivers/gpu/drm/i915/intel_pm.c                            |    8 
 drivers/gpu/drm/meson/meson_drv.c                          |    8 
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c                    |   12 
 drivers/gpu/drm/msm/disp/dpu1/dpu_vbif.c                   |   29 -
 drivers/gpu/drm/msm/dp/dp_catalog.c                        |    2 
 drivers/gpu/drm/nouveau/nouveau_bo.c                       |    4 
 drivers/gpu/drm/nouveau/nouveau_connector.c                |    3 
 drivers/gpu/drm/nouveau/nouveau_prime.c                    |    1 
 drivers/gpu/drm/omapdrm/dss/dss.c                          |    3 
 drivers/gpu/drm/pl111/pl111_versatile.c                    |    1 
 drivers/gpu/drm/udl/udl_modeset.c                          |    3 
 drivers/gpu/drm/vc4/vc4_vec.c                              |    4 
 drivers/gpu/drm/virtio/virtgpu_vq.c                        |    2 
 drivers/hid/hid-multitouch.c                               |    8 
 drivers/hid/hid-roccat.c                                   |    4 
 drivers/hsi/controllers/omap_ssi_core.c                    |    1 
 drivers/hsi/controllers/omap_ssi_port.c                    |    8 
 drivers/hwmon/gsc-hwmon.c                                  |    1 
 drivers/i2c/busses/i2c-mlxbf.c                             |   44 +-
 drivers/iio/adc/ad7923.c                                   |    4 
 drivers/iio/adc/at91-sama5d2_adc.c                         |   28 -
 drivers/iio/adc/ltc2497.c                                  |   13 
 drivers/iio/dac/ad5593r.c                                  |   46 +-
 drivers/iio/inkern.c                                       |    6 
 drivers/iio/pressure/dps310.c                              |  262 ++++++++-----
 drivers/infiniband/core/cm.c                               |   14 
 drivers/infiniband/core/uverbs_cmd.c                       |    5 
 drivers/infiniband/core/verbs.c                            |    2 
 drivers/infiniband/hw/hns/hns_roce_mr.c                    |    1 
 drivers/infiniband/hw/mlx4/mr.c                            |    1 
 drivers/infiniband/sw/rxe/rxe_qp.c                         |   10 
 drivers/infiniband/sw/siw/siw_qp_rx.c                      |   27 -
 drivers/iommu/omap-iommu-debug.c                           |    6 
 drivers/isdn/mISDN/l1oip.h                                 |    1 
 drivers/isdn/mISDN/l1oip_core.c                            |   13 
 drivers/leds/leds-lm3601x.c                                |    2 
 drivers/mailbox/bcm-flexrm-mailbox.c                       |    8 
 drivers/md/bcache/writeback.c                              |   73 ++-
 drivers/md/raid0.c                                         |    2 
 drivers/md/raid5.c                                         |   14 
 drivers/media/pci/cx88/cx88-vbi.c                          |    9 
 drivers/media/pci/cx88/cx88-video.c                        |   43 +-
 drivers/media/platform/exynos4-is/fimc-is.c                |    1 
 drivers/media/platform/xilinx/xilinx-vipp.c                |    9 
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
 drivers/mtd/nand/raw/meson_nand.c                          |    4 
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h                |    2 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c           |    3 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c          |    2 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c           |   79 +++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c            |    1 
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c           |    2 
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h                 |    1 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c         |   10 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c            |   13 
 drivers/net/usb/r8152.c                                    |    4 
 drivers/net/wireless/ath/ath10k/mac.c                      |   54 +-
 drivers/net/wireless/ath/ath11k/mac.c                      |   25 -
 drivers/net/wireless/ath/ath9k/htc_hst.c                   |   43 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c    |    3 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c     |   12 
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c             |   34 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c      |   75 +++
 drivers/nvme/host/core.c                                   |    3 
 drivers/nvme/host/pci.c                                    |    3 
 drivers/nvme/target/tcp.c                                  |   11 
 drivers/pci/setup-res.c                                    |   11 
 drivers/phy/qualcomm/phy-qcom-usb-hsic.c                   |    6 
 drivers/platform/chrome/chromeos_laptop.c                  |   24 -
 drivers/platform/chrome/cros_ec.c                          |    8 
 drivers/platform/chrome/cros_ec_chardev.c                  |    3 
 drivers/platform/chrome/cros_ec_proto.c                    |   32 +
 drivers/platform/x86/msi-laptop.c                          |   14 
 drivers/power/supply/adp5061.c                             |    6 
 drivers/powercap/intel_rapl_common.c                       |    4 
 drivers/regulator/core.c                                   |    2 
 drivers/regulator/qcom_rpm-regulator.c                     |   24 -
 drivers/scsi/3w-9xxx.c                                     |    2 
 drivers/scsi/iscsi_tcp.c                                   |   73 ++-
 drivers/scsi/iscsi_tcp.h                                   |    2 
 drivers/scsi/libsas/sas_expander.c                         |    2 
 drivers/scsi/qedf/qedf_main.c                              |   21 +
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
 drivers/staging/rtl8723bs/core/rtw_cmd.c                   |   16 
 drivers/staging/vt6655/device_main.c                       |    8 
 drivers/thermal/intel/intel_powerclamp.c                   |    4 
 drivers/thermal/qcom/tsens-v0_1.c                          |    2 
 drivers/thunderbolt/switch.c                               |   24 +
 drivers/thunderbolt/tb.h                                   |    1 
 drivers/thunderbolt/tb_regs.h                              |    1 
 drivers/thunderbolt/usb4.c                                 |   20 
 drivers/tty/serial/8250/8250_core.c                        |   19 
 drivers/tty/serial/8250/8250_port.c                        |   15 
 drivers/tty/serial/fsl_lpuart.c                            |    2 
 drivers/tty/serial/jsm/jsm_driver.c                        |    3 
 drivers/tty/serial/xilinx_uartps.c                         |    2 
 drivers/usb/common/common.c                                |  102 +++++
 drivers/usb/common/debug.c                                 |   78 +++
 drivers/usb/core/devices.c                                 |   21 -
 drivers/usb/core/endpoint.c                                |   35 -
 drivers/usb/core/quirks.c                                  |    4 
 drivers/usb/gadget/function/f_printer.c                    |   12 
 drivers/usb/host/xhci-mem.c                                |    7 
 drivers/usb/host/xhci-plat.c                               |   18 
 drivers/usb/host/xhci.c                                    |    3 
 drivers/usb/host/xhci.h                                    |    1 
 drivers/usb/misc/idmouse.c                                 |    8 
 drivers/usb/musb/musb_gadget.c                             |    3 
 drivers/usb/storage/unusual_devs.h                         |    6 
 drivers/vhost/vsock.c                                      |    2 
 drivers/video/fbdev/smscufx.c                              |   14 
 drivers/video/fbdev/stifb.c                                |    2 
 fs/btrfs/qgroup.c                                          |   15 
 fs/btrfs/scrub.c                                           |   36 +
 fs/cifs/file.c                                             |    9 
 fs/cifs/smb2pdu.c                                          |    7 
 fs/dlm/ast.c                                               |    6 
 fs/dlm/lock.c                                              |   16 
 fs/ext4/fast_commit.c                                      |   40 +
 fs/ext4/file.c                                             |    6 
 fs/ext4/inode.c                                            |   14 
 fs/ext4/namei.c                                            |    2 
 fs/ext4/resize.c                                           |    2 
 fs/ext4/super.c                                            |   19 
 fs/f2fs/checkpoint.c                                       |   23 -
 fs/f2fs/data.c                                             |    4 
 fs/f2fs/extent_cache.c                                     |    3 
 fs/f2fs/f2fs.h                                             |   27 -
 fs/f2fs/gc.c                                               |   10 
 fs/f2fs/recovery.c                                         |   23 -
 fs/f2fs/segment.c                                          |   47 +-
 fs/f2fs/super.c                                            |    4 
 fs/io_uring.c                                              |    8 
 fs/jbd2/commit.c                                           |    2 
 fs/jbd2/journal.c                                          |   10 
 fs/jbd2/recovery.c                                         |    1 
 fs/jbd2/transaction.c                                      |    6 
 fs/nfsd/nfs4recover.c                                      |    4 
 fs/nfsd/nfs4state.c                                        |    5 
 fs/nfsd/nfs4xdr.c                                          |    2 
 fs/quota/quota_tree.c                                      |   38 +
 fs/userfaultfd.c                                           |    4 
 include/linux/ata.h                                        |   39 +
 include/linux/dynamic_debug.h                              |   11 
 include/linux/iova.h                                       |    2 
 include/linux/once.h                                       |   28 +
 include/linux/ring_buffer.h                                |    2 
 include/linux/serial_8250.h                                |    1 
 include/linux/skbuff.h                                     |    2 
 include/linux/tcp.h                                        |    2 
 include/linux/usb/ch9.h                                    |   62 ---
 include/net/ieee802154_netdev.h                            |   12 
 include/net/sock.h                                         |    2 
 include/net/tcp.h                                          |    5 
 include/uapi/linux/usb/ch9.h                               |   13 
 kernel/bpf/btf.c                                           |    2 
 kernel/bpf/syscall.c                                       |    2 
 kernel/cgroup/cpuset.c                                     |   18 
 kernel/gcov/gcc_4_7.c                                      |   18 
 kernel/livepatch/transition.c                              |   18 
 kernel/rcu/tasks.h                                         |    2 
 kernel/rcu/tree.c                                          |   17 
 kernel/trace/ftrace.c                                      |    8 
 kernel/trace/kprobe_event_gen_test.c                       |   49 ++
 kernel/trace/ring_buffer.c                                 |   87 ++++
 kernel/trace/trace.c                                       |   23 +
 lib/dynamic_debug.c                                        |   45 --
 lib/once.c                                                 |   30 +
 mm/hugetlb.c                                               |   29 -
 mm/mmap.c                                                  |    5 
 net/bluetooth/hci_core.c                                   |   34 +
 net/bluetooth/hci_sysfs.c                                  |    3 
 net/bluetooth/l2cap_core.c                                 |   17 
 net/can/bcm.c                                              |    7 
 net/core/stream.c                                          |    3 
 net/ieee802154/socket.c                                    |    4 
 net/ipv4/af_inet.c                                         |    2 
 net/ipv4/inet_hashtables.c                                 |    4 
 net/ipv4/netfilter/nft_fib_ipv4.c                          |    3 
 net/ipv4/tcp.c                                             |   19 
 net/ipv4/tcp_input.c                                       |    2 
 net/ipv4/tcp_ipv4.c                                        |   11 
 net/ipv4/tcp_output.c                                      |   19 
 net/ipv4/udp.c                                             |    6 
 net/ipv6/netfilter/nft_fib_ipv6.c                          |    6 
 net/ipv6/tcp_ipv6.c                                        |   11 
 net/ipv6/udp.c                                             |    4 
 net/mac80211/cfg.c                                         |    3 
 net/openvswitch/datapath.c                                 |   18 
 net/rds/tcp.c                                              |    2 
 net/sctp/auth.c                                            |   18 
 net/unix/garbage.c                                         |   20 
 net/vmw_vsock/virtio_transport_common.c                    |    2 
 net/xfrm/xfrm_ipcomp.c                                     |    1 
 scripts/Kbuild.include                                     |   23 +
 scripts/package/mkspec                                     |    4 
 scripts/selinux/install_policy.sh                          |    2 
 security/Kconfig.hardening                                 |   63 ++-
 sound/core/pcm_dmaengine.c                                 |    8 
 sound/core/rawmidi.c                                       |    2 
 sound/core/sound_oss.c                                     |   13 
 sound/pci/hda/hda_beep.c                                   |   15 
 sound/pci/hda/hda_beep.h                                   |    1 
 sound/pci/hda/patch_hdmi.c                                 |    6 
 sound/pci/hda/patch_realtek.c                              |   11 
 sound/pci/hda/patch_sigmatel.c                             |   25 -
 sound/soc/codecs/da7219.c                                  |    5 
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
 sound/usb/endpoint.c                                       |    6 
 tools/bpf/bpftool/btf_dumper.c                             |    2 
 tools/bpf/bpftool/main.c                                   |   10 
 tools/lib/bpf/xsk.c                                        |    6 
 tools/objtool/elf.c                                        |    7 
 tools/perf/util/intel-pt.c                                 |    9 
 tools/testing/selftests/arm64/signal/testcases/testcases.c |    2 
 tools/testing/selftests/tpm2/tpm2.py                       |    4 
 379 files changed, 3232 insertions(+), 1463 deletions(-)

Adrian Hunter (1):
      perf intel-pt: Fix segfault in intel_pt_print_info() with uClibc

Adrián Larumbe (1):
      drm/meson: explicitly remove aggregate driver at module unload time

Albert Briscoe (1):
      usb: gadget: function: fix dangling pnp_string in f_printer.c

Alex Deucher (1):
      Revert "drm/amdgpu: make sure to init common IP before gmc"

Alexander Aring (4):
      fs: dlm: fix race between test_bit() and queue_work()
      fs: dlm: handle -EBUSY first in lock arg validation
      net: ieee802154: return -EINVAL for unknown addr type
      Revert "net/ieee802154: reject zero-sized raw_sendmsg()"

Alexander Coffin (1):
      wifi: brcmfmac: fix use-after-free bug in brcmf_netdev_start_xmit()

Alexander Stein (6):
      ARM: dts: imx6q: add missing properties for sram
      ARM: dts: imx6dl: add missing properties for sram
      ARM: dts: imx6qp: add missing properties for sram
      ARM: dts: imx6sl: add missing properties for sram
      ARM: dts: imx6sll: add missing properties for sram
      ARM: dts: imx6sx: add missing properties for sram

Alvin Šipraga (1):
      drm: bridge: adv7511: fix CEC power down control register offset

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

Ard Biesheuvel (1):
      efi: libstub: drop pointless get_memory_map() call

Aric Cyr (1):
      drm/amd/display: Remove interface for periodic interrupt 1

Arnd Bergmann (1):
      Bluetooth: btusb: fix excessive stack usage

Arvid Norlander (1):
      ACPI: video: Add Toshiba Satellite/Portege Z830 quirk

Asmaa Mnebhi (1):
      i2c: mlxbf: support lock mechanism

Baokun Li (1):
      ext4: fix null-ptr-deref in ext4_write_info

Bernard Metzler (1):
      RDMA/siw: Always consume all skbuf data in sk_data_ready() upcall.

Bitterblue Smith (4):
      wifi: rtl8xxxu: Fix skb misuse in TX queue selection
      wifi: rtl8xxxu: gen2: Fix mistake in path B IQ calibration
      wifi: rtl8xxxu: Remove copy-paste leftover in gen2_update_rate_mask
      wifi: rtl8xxxu: Fix AIFS written to REG_EDCA_*_PARAM

Callum Osmotherly (1):
      ALSA: hda/realtek: remove ALC289_FIXUP_DUAL_SPK for Dell 5530

Carlos Llamas (1):
      mm/mmap: undo ->mmap() when arch_validate_flags() fails

Chao Qin (1):
      powercap: intel_rapl: fix UBSAN shift-out-of-bounds issue

Chao Yu (5):
      f2fs: fix to do sanity check on destination blkaddr during recovery
      f2fs: fix to do sanity check on summary info
      f2fs: fix to avoid REQ_TIME and CP_TIME collision
      f2fs: fix to account FS_CP_DATA_IO correctly
      f2fs: fix wrong condition to trigger background checkpoint correctly

Chen-Yu Tsai (2):
      drm/bridge: parade-ps8640: Fix regulator supply order
      clk: mediatek: mt8183: mfgcfg: Propagate rate changes to parent

Christophe JAILLET (11):
      MIPS: SGI-IP27: Free some unused memory
      nfsd: Fix a memory leak in an error handling path
      spi: mt7621: Fix an error message in mt7621_spi_probe()
      mmc: au1xmmc: Fix an error handling path in au1xmmc_probe()
      ASoC: da7219: Fix an error handling path in da7219_register_dai_clks()
      mmc: wmt-sdmmc: Fix an error handling path in wmt_mci_probe()
      serial: 8250: Add an empty line and remove some useless {}
      mfd: intel_soc_pmic: Fix an error handling path in intel_soc_pmic_i2c_probe()
      mfd: fsl-imx25: Fix an error handling path in mx25_tsadc_setup_irq()
      mfd: lp8788: Fix an error handling path in lp8788_probe()
      mfd: lp8788: Fix an error handling path in lp8788_irq_init() and lp8788_irq_init()

Chunfeng Yun (2):
      usb: common: add function to get interval expressed in us unit
      usb: common: move function's kerneldoc next to its definition

Claudiu Beznea (4):
      iio: adc: at91-sama5d2_adc: fix AT91_SAMA5D2_MR_TRACKTIM_MAX
      iio: adc: at91-sama5d2_adc: check return status for pressure and touch
      iio: adc: at91-sama5d2_adc: lock around oversampling and sample freq
      iio: adc: at91-sama5d2_adc: disable/prepare buffer on suspend/resume

Coly Li (1):
      bcache: fix set_at_max_writeback_rate() for multiple attached devices

Dai Ngo (1):
      NFSD: fix use-after-free on source server when doing inter-server copy

Daisuke Matsuda (1):
      IB: Set IOVA/LENGTH on IB_MR in core/uverbs layers

Damian Muszynski (1):
      crypto: qat - fix DMA transfer direction

Dan Carpenter (10):
      wifi: rtl8xxxu: tighten bounds checking in rtl8xxxu_read_efuse()
      drm/bridge: Avoid uninitialized variable warning
      platform/chrome: fix memory corruption in ioctl
      fpga: prevent integer overflow in dfl_feature_ioctl_set_irq()
      mtd: rawnand: meson: fix bit map use in meson_nfc_ecc_correct()
      drivers: serial: jsm: fix some leaks in probe
      mfd: fsl-imx25: Fix check for platform_get_irq() errors
      iommu/omap: Fix buffer overflow in debugfs
      crypto: marvell/octeontx - prevent integer overflows
      crypto: cavium - prevent integer overflow loading firmware

Daniel Golle (5):
      wifi: rt2x00: don't run Rt5592 IQ calibration on MT7620
      wifi: rt2x00: set correct TX_SW_CFG1 MAC register for MT7620
      wifi: rt2x00: set VGC gain for both chains of MT7620
      wifi: rt2x00: set SoC wmac clock register
      wifi: rt2x00: correctly set BBP register 86 for MT7620

Dave Jiang (1):
      dmaengine: ioat: stop mod_timer from resurrecting deleted timer in __cleanup()

David Collins (1):
      spmi: pmic-arb: correct duplicate APID to PPID mapping logic

David Gow (1):
      drm/amd/display: fix overflow on MIN_I64 definition

Dmitry Baryshkov (1):
      drm/msm/dpu: index dpu_kms->hw_vbif using vbif_idx

Dmitry Osipenko (3):
      drm/virtio: Check whether transferred 2D BO is shmem
      media: cedrus: Set the platform driver data earlier
      soc/tegra: fuse: Drop Kconfig dependency on TEGRA20_APB_DMA

Dmitry Torokhov (2):
      ARM: dts: exynos: correct s5k6a3 reset polarity on Midas family
      ARM: dts: exynos: fix polarity of VBUS GPIO of Origen

Dongliang Mu (2):
      phy: qualcomm: call clk_disable_unprepare in the error handling
      usb: idmouse: fix an uninit-value in idmouse_open

Duoming Zhou (2):
      mISDN: fix use-after-free bugs in l1oip timer handlers
      scsi: libsas: Fix use-after-free bug in smp_execute_task_sg()

Eddie James (2):
      iio: pressure: dps310: Refactor startup procedure
      iio: pressure: dps310: Reset chip after timeout

Eric Dumazet (3):
      once: add DO_ONCE_SLOW() for sleepable contexts
      tcp: annotate data-race around tcp_md5sig_pool_populated
      inet: fully convert sk->sk_rx_dst to RCU rules

Fangrui Song (1):
      riscv: Pass -mno-relax only on lld < 15.0.0

Filipe Manana (1):
      btrfs: fix race between quota enable and quota rescan ioctl

Geert Uytterhoeven (1):
      ARM: Drop CMDLINE_* dependency on ATAGS

Giovanni Cabiddu (1):
      crypto: qat - use pre-allocated buffers in datapath

Greg Kroah-Hartman (3):
      staging: greybus: audio_helper: remove unused and wrong debugfs usage
      selinux: use "grep -E" instead of "egrep"
      Linux 5.10.150

Guilherme G. Piccoli (1):
      firmware: google: Test spinlock on panic path to avoid lockups

Haibo Chen (1):
      ARM: dts: imx7d-sdb: config the max pressure for tsc2046

Hangyu Hua (1):
      misc: ocxl: fix possible refcount leak in afu_ioctl()

Hans de Goede (3):
      platform/x86: msi-laptop: Fix old-ec check for backlight registering
      platform/x86: msi-laptop: Fix resource cleanup
      platform/x86: msi-laptop: Change DMI match / alias strings to fix module autoloading

Hari Chandrakanthan (1):
      wifi: mac80211: allow bw change during channel switch in mesh

Helge Deller (1):
      parisc: fbdev/stifb: Align graphics memory size to 4MB

Huacai Chen (1):
      UM: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Hui Tang (1):
      crypto: qat - fix use of 'dma_map_single'

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

Jack Wang (2):
      HSI: omap_ssi_port: Fix dma_map_sg error check
      mailbox: bcm-ferxrm-mailbox: Fix error check for dma_map_sg

Jaegeuk Kim (1):
      f2fs: increase the limit for reserve_root

Jairaj Arava (1):
      ASoC: SOF: pci: Change DMI match info to support all Chrome platforms

Jameson Thies (1):
      platform/chrome: cros_ec: Notify the PM of wake events during resume

Jan Kara (2):
      ext4: avoid crash when inline data creation follows DIO write
      ext4: fix check for block being out of directory size

Janis Schoetterl-Glausch (1):
      kbuild: rpm-pkg: fix breakage when V=1 is used

Javier Martinez Canillas (2):
      drm: Use size_t type for len variable in drm_copy_field()
      drm: Prevent drm_copy_field() to attempt copying a NULL pointer

Jean-Francois Le Fillatre (1):
      usb: add quirks for Lenovo OneLink+ Dock

Jeffle Xu (1):
      block: fix inflight statistics of part0

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

Junichi Uekawa (1):
      vhost/vsock: Use kvmalloc/kvfree for larger packets.

Justin Chen (2):
      usb: host: xhci-plat: suspend and resume clocks
      usb: host: xhci-plat: suspend/resume clks for brcm

Kees Cook (7):
      hardening: Clarify Kconfig text for auto-var-init
      hardening: Avoid harmless Clang option under CONFIG_INIT_STACK_ALL_ZERO
      hardening: Remove Clang's enable flag for -ftrivial-auto-var-init=zero
      sh: machvec: Use char[] for section boundaries
      x86/microcode/AMD: Track patch allocation size explicitly
      MIPS: BCM47XX: Cast memcmp() of function to (void *)
      x86/entry: Work around Clang __bdos() bug

Keith Busch (1):
      nvme: copy firmware_rev on each init

Khaled Almahallawy (1):
      drm/dp: Don't rewrite link config when setting phy test pattern

Khalid Masum (1):
      xfrm: Update ipcomp_scratches with NULL when freed

Koba Ko (1):
      crypto: ccp - Release dma channels before dmaengine unrgister

Kohei Tarumizu (1):
      x86/resctrl: Fix to restore to original value when re-enabling hardware prefetch register

Krzysztof Kozlowski (2):
      ASoC: wcd9335: fix order of Slimbus unprepare/disable
      ASoC: wcd934x: fix order of Slimbus unprepare/disable

Kshitiz Varshney (1):
      hwrng: imx-rngc - Moving IRQ handler registering after imx_rngc_irq_mask_clear()

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

Liang He (17):
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
      powerpc/sysdev/fsl_msi: Add missing of_node_put()
      powerpc/pci_dn: Add missing of_node_put()

Lin Yujun (1):
      MIPS: SGI-IP27: Fix platform-device leak in bridge_platform_create()

Linus Walleij (1):
      regulator: qcom_rpm: Fix circular deferral regression

Liu Jian (1):
      net: If sock is dead don't access sock's sk_wq in sk_stream_wait_memory

Liu Shixin (1):
      mm: hugetlb: fix UAF in hugetlb_handle_userfault

Logan Gunthorpe (2):
      md/raid5: Ensure stripe_fill happens on non-read IO with journal
      md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d

Lorenz Bauer (1):
      bpf: btf: fix truncated last_member_type_id in btf_struct_resolve

Lucas Stach (1):
      drm: bridge: dw_hdmi: only trigger hotplug event on link change

Luciano Leão (1):
      x86/cpu: Include the header of init_ia32_feat_ctl()'s prototype

Luiz Augusto von Dentz (3):
      Bluetooth: hci_core: Fix not handling link timeouts propertly
      Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times
      Bluetooth: L2CAP: Fix user-after-free

Lukas Czerner (1):
      ext4: don't increase iversion counter for ea_inodes

Luke D. Jones (2):
      ALSA: hda/realtek: Correct pin configs for ASUS G533Z
      ALSA: hda/realtek: Add quirk for ASUS GV601R laptop

Lyude Paul (1):
      drm/nouveau/kms/nv140-: Disable interlacing

Maciej W. Rozycki (2):
      RISC-V: Make port I/O string accessors actually work
      PCI: Sanitise firmware BAR assignments behind a PCI-PCI bridge

Marek Behún (1):
      ARM: dts: turris-omnia: Fix mpp26 pin name and comment

Marek Szyprowski (1):
      spi: Ensure that sg_table won't be used after being freed

Mario Limonciello (2):
      thunderbolt: Explicitly enable lane adapter hotplug events at startup
      xhci: Don't show warning for reinit on known broken suspend

Mark Brown (1):
      kselftest/arm64: Fix validatation termination record after EXTRA_CONTEXT

Mark Chen (1):
      Bluetooth: btusb: Fine-tune mt7663 mechanism.

Mark Rutland (1):
      arm64: ftrace: fix module PLTs with mcount

Mark Zhang (1):
      RDMA/cm: Use SLID in the work completion as the DLID in responder side

Martin Liska (1):
      gcov: support GCC 12.1 and newer compilers

Martin Povišer (3):
      ASoC: tas2764: Allow mono streams
      ASoC: tas2764: Drop conflicting set_bias_level power setting
      ASoC: tas2764: Fix mute/unmute

Masahiro Yamada (1):
      kbuild: remove the target in signal traps when interrupted

Mateusz Kwiatkowski (1):
      drm/vc4: vec: Fix timings for VEC modes

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

Michael Hennerich (1):
      iio: dac: ad5593r: Fix i2c read protocol requirements

Michael Walle (2):
      ARM: dts: kirkwood: lsxl: fix serial line
      ARM: dts: kirkwood: lsxl: remove first ethernet port

Michal Hocko (1):
      rcu: Back off upon fill_page_cache_func() allocation failure

Michal Luczaj (1):
      KVM: x86/emulator: Fix handing of POP SS to correctly set interruptibility

Mike Christie (1):
      scsi: iscsi: iscsi_tcp: Fix null-ptr-deref while calling getpeername()

Mike Pattrick (2):
      openvswitch: Fix double reporting of drops in dropwatch
      openvswitch: Fix overreporting of drops in dropwatch

Nam Cao (2):
      staging: vt6655: fix some erroneous memory clean-up loops
      staging: vt6655: fix potential memory leak

Nathan Chancellor (1):
      powerpc/math_emu/efp: Include module.h

Neal Cardwell (1):
      tcp: fix tcp_cwnd_validate() to not forget is_cwnd_limited

Neil Armstrong (1):
      spi: meson-spicc: do not rely on busy flag in pow2 clk ops

Nicholas Piggin (1):
      powerpc/64s: Fix GENERIC_CPU build flags for PPC970 / G5

Niklas Cassel (4):
      ata: fix ata_id_sense_reporting_enabled() and ata_id_has_sense_reporting()
      ata: fix ata_id_has_devslp()
      ata: fix ata_id_has_ncq_autosense()
      ata: fix ata_id_has_dipm()

Nuno Sá (2):
      iio: adc: ad7923: fix channel readings for some variants
      iio: inkern: only release the device node when done with it

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

Pavel Begunkov (2):
      io_uring: correct pinned_vm accounting
      io_uring/af_unix: defer registered files gc to io_uring release

Peter Harliman Liem (1):
      crypto: inside-secure - Change swab to swab32

Phil Sutter (1):
      netfilter: nft_fib: Fix for rpath check with VRF devices

Pierre-Louis Bossart (1):
      soundwire: intel: fix error handling on dai registration issues

Qu Wenruo (1):
      btrfs: scrub: try to fix super block errors

Quanyang Wang (1):
      clk: zynqmp: pll: rectify rate rounding in zynqmp_pll_round_rate

Quentin Monnet (1):
      bpftool: Clear errno after libcap's checks

Rafael J. Wysocki (1):
      thermal: intel_powerclamp: Use first online CPU as control_cpu

Randy Dunlap (2):
      drm: fix drm_mipi_dbi build errors
      ia64: export memory_add_physaddr_to_nid to fix cxl build error

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

Ronnie Sahlberg (1):
      cifs: destage dirty pages before re-reading them for cache=none

Russell King (Oracle) (1):
      net: mvpp2: fix mvpp2 debugfs leak

Rustam Subkhankulov (1):
      platform/chrome: fix double-free in chromeos_laptop_prepare()

Sami Tolvanen (1):
      objtool: Preserve special st_shndx indexes in elf_update_symbol

Saranya Gopal (1):
      ALSA: hda/realtek: Add Intel Reference SSID to support headset keys

Saurabh Sengar (1):
      md: Replace snprintf with scnprintf

Saurav Kashyap (1):
      scsi: qedf: Populate sysfs attributes for vport

Sean Christopherson (2):
      KVM: nVMX: Unconditionally purge queued/injected events on nested "exit"
      KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS

Sean Wang (1):
      Bluetooth: btusb: mediatek: fix WMT failure during runtime suspend

Sebastian Krzyszkowiak (1):
      arm64: dts: imx8mq-librem5: Add bq25895 as max17055's power supply

Serge Semin (5):
      clk: vc5: Fix 5P49V6901 outputs disabling when enabling FOD
      clk: baikal-t1: Fix invalid xGMAC PTP clock divider
      clk: baikal-t1: Add shared xGMAC ref/ptp clocks internal parent
      clk: baikal-t1: Add SATA internal ref clock buffer
      ata: libahci_platform: Sanity check the DT child nodes number

Sergey Shtylyov (1):
      arm64: topology: fix possible overflow in amu_fie_setup()

Sherry Sun (1):
      tty: serial: fsl_lpuart: disable dma rx/tx use flags in lpuart_dma_shutdown

Shigeru Yoshida (1):
      nbd: Fix hung when signal interrupts nbd_start_device_ioctl()

Shuah Khan (2):
      Revert "drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega"
      Revert "drm/amdgpu: use dirty framebuffer helper"

Shuai Xue (1):
      ACPI: APEI: do not add task_work to kernel thread to avoid memory leak

Shubhrajyoti Datta (1):
      tty: xilinx_uartps: Fix the ignore_status

Simon Ser (1):
      drm/dp_mst: fix drm_dp_dpcd_read return value checks

Srinivas Pandruvada (1):
      thermal: intel_powerclamp: Use get_cpu() instead of smp_processor_id() to avoid crash

Stefan Berger (1):
      selftest: tpm2: Add Client.__del__() to close /dev/tpm* handle

Stefan Wahren (1):
      clk: bcm2835: fix bcm2835_clock_rate_from_divisor declaration

Steve French (1):
      smb3: must initialize two ACL struct fields to zero

Steven Rostedt (Google) (5):
      ring-buffer: Allow splice to read previous partially read pages
      ring-buffer: Have the shortest_full queue be the shortest not longest
      ring-buffer: Check pending waiters when doing wake ups as well
      ring-buffer: Add ring_buffer_wake_waiters()
      ring-buffer: Fix race between reset page and reading page

Takashi Iwai (7):
      ALSA: oss: Fix potential deadlock at unregistration
      ALSA: rawmidi: Drop register_mutex in snd_rawmidi_free()
      ALSA: usb-audio: Fix potential memory leaks
      ALSA: usb-audio: Fix NULL dererence at error path
      drm/udl: Restore display mode on resume
      ALSA: hda: beep: Simplify keep-power-at-enable behavior
      ALSA: hda/hdmi: Don't skip notification handling during PM operation

Tetsuo Handa (6):
      Bluetooth: hci_{ldisc,serdev}: check percpu_init_rwsem() failure
      net: rds: don't hold sock lock when cancelling work from rds_tcp_reset_callbacks()
      net/ieee802154: reject zero-sized raw_sendmsg()
      wifi: ath9k: avoid uninit memory read in ath9k_htc_rx_msg()
      Bluetooth: L2CAP: initialize delayed works at l2cap_chan_create()
      net/ieee802154: don't warn zero-sized raw_sendmsg()

Thinh Nguyen (3):
      usb: ch9: Add USB 3.2 SSP attributes
      usb: common: Parse for USB SSP genXxY
      usb: common: debug: Check non-standard control requests

Tudor Ambarus (1):
      mtd: rawnand: atmel: Unmap streaming DMA mappings

Uwe Kleine-König (2):
      iio: ltc2497: Fix reading conversion results
      leds: lm3601x: Don't use mutex after it was destroyed

Varun Prakash (1):
      nvmet-tcp: add bounds check on Transfer Tag

Ville Syrjälä (2):
      drm/i915: Fix watermark calculations for gen12+ RC CCS modifier
      drm/i915: Fix watermark calculations for gen12+ MC CCS modifier

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

Wen Gong (1):
      wifi: ath10k: add peer map clean up for peer delete in ath10k_sta_state()

Wenchao Chen (1):
      mmc: sdhci-sprd: Fix minimum clock limit

William Dean (1):
      mtd: devices: docg3: check the return value of devm_ioremap() in the probe

Wright Feng (1):
      wifi: brcmfmac: fix invalid address access when enabling SCAN log level

Xiaoke Wang (1):
      staging: rtl8723bs: fix a potential memory leak in rtw_init_cmd_priv()

Xin Long (1):
      sctp: handle the error returned from sctp_auth_asoc_init_active_key

Xu Qiang (3):
      spi: qup: add missing clk_disable_unprepare on error in spi_qup_resume()
      spi: qup: add missing clk_disable_unprepare on error in spi_qup_pm_resume_runtime()
      media: meson: vdec: add missing clk_disable_unprepare on error in vdec_hevc_start()

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

Yipeng Zou (2):
      tracing: kprobe: Fix kprobe event gen test module on exit
      tracing: kprobe: Make gen test module work in arm and riscv

Yu Kuai (1):
      blk-throttle: prevent overflow while calculating wait time

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

Zhang Xiaoxu (1):
      cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message

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

Zhihao Cheng (1):
      quota: Check next/prev free block number after reading from quota file

Zhu Yanjun (2):
      RDMA/rxe: Fix "kernel NULL pointer dereference" error
      RDMA/rxe: Fix the error caused by qp->sk

Ziyang Xuan (1):
      can: bcm: check the result of can_send() in bcm_can_tx()

Zqiang (1):
      rcu-tasks: Convert RCU_LOCKDEP_WARN() to WARN_ONCE()

hongao (1):
      drm/amdgpu: fix initial connector audio value

sunghwan jung (1):
      Revert "usb: storage: Add quirk for Samsung Fit flash"

