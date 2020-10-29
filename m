Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D0129E92F
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 11:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgJ2KnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 06:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgJ2KnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 06:43:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1548520838;
        Thu, 29 Oct 2020 10:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603968183;
        bh=uKRXSlv/+FKYLmjrYLSVwbEl3QqRfp9lGO6Rlsnsios=;
        h=From:To:Cc:Subject:Date:From;
        b=UBHTXKO6aSz4x+2lT0AOpBFW+ug51LIvgzMMPDPmn+4k/aNR7MB5i5ZkkTOYiEpkX
         q25Z7IfFkHKAtuYBiBtlAD5/tMDy5Fx8sIjAA4AdWuKWI81o0yQD9Fv0wBDbzSI78Z
         IJwcP389nazQjqmuHtyCBykGCl8PrOUkgcGx34YE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.73
Date:   Thu, 29 Oct 2020 11:43:47 +0100
Message-Id: <1603968227224116@kroah.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.73 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt                                                |    2 
 Documentation/networking/ip-sysctl.txt                                                         |    4 
 Makefile                                                                                       |    2 
 arch/arc/plat-hsdk/Kconfig                                                                     |    1 
 arch/arm/boot/dts/imx6sl.dtsi                                                                  |    2 
 arch/arm/boot/dts/meson8.dtsi                                                                  |    2 
 arch/arm/boot/dts/owl-s500.dtsi                                                                |    6 
 arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts                                              |   10 
 arch/arm/mach-at91/pm.c                                                                        |    1 
 arch/arm/mach-omap2/cpuidle44xx.c                                                              |    4 
 arch/arm/mach-s3c24xx/mach-at2440evb.c                                                         |    2 
 arch/arm/mach-s3c24xx/mach-h1940.c                                                             |    4 
 arch/arm/mach-s3c24xx/mach-mini2440.c                                                          |    4 
 arch/arm/mach-s3c24xx/mach-n30.c                                                               |    4 
 arch/arm/mach-s3c24xx/mach-rx1950.c                                                            |    4 
 arch/arm/mm/cache-l2x0.c                                                                       |   16 
 arch/arm64/boot/dts/actions/s700.dtsi                                                          |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi                                                   |    6 
 arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi                                             |    4 
 arch/arm64/boot/dts/freescale/imx8mq.dtsi                                                      |    1 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                                                          |   10 
 arch/arm64/boot/dts/qcom/pm8916.dtsi                                                           |    2 
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi                                                      |    5 
 arch/arm64/boot/dts/renesas/r8a77990.dtsi                                                      |    5 
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi                                                         |    4 
 arch/powerpc/include/asm/book3s/64/hash-4k.h                                                   |   13 
 arch/powerpc/include/asm/drmem.h                                                               |   39 -
 arch/powerpc/include/asm/reg.h                                                                 |    2 
 arch/powerpc/include/asm/tlb.h                                                                 |   13 
 arch/powerpc/kernel/tau_6xx.c                                                                  |  147 ++---
 arch/powerpc/mm/book3s64/radix_tlb.c                                                           |   23 
 arch/powerpc/mm/drmem.c                                                                        |    6 
 arch/powerpc/perf/hv-gpci-requests.h                                                           |    6 
 arch/powerpc/perf/isa207-common.c                                                              |   10 
 arch/powerpc/platforms/Kconfig                                                                 |   14 
 arch/powerpc/platforms/powernv/opal-dump.c                                                     |   41 +
 arch/powerpc/platforms/pseries/hotplug-memory.c                                                |   24 
 arch/powerpc/platforms/pseries/ras.c                                                           |  118 ++--
 arch/powerpc/platforms/pseries/rng.c                                                           |    1 
 arch/powerpc/sysdev/xics/icp-hv.c                                                              |    1 
 arch/x86/boot/compressed/pgtable_64.c                                                          |    9 
 arch/x86/events/amd/iommu.c                                                                    |    2 
 arch/x86/events/intel/ds.c                                                                     |   32 -
 arch/x86/events/intel/uncore_snb.c                                                             |   31 -
 arch/x86/include/asm/special_insns.h                                                           |   28 -
 arch/x86/kernel/cpu/common.c                                                                   |    4 
 arch/x86/kernel/cpu/mce/core.c                                                                 |   72 ++
 arch/x86/kernel/cpu/mce/internal.h                                                             |   10 
 arch/x86/kernel/cpu/mce/severity.c                                                             |   28 -
 arch/x86/kernel/fpu/init.c                                                                     |   30 -
 arch/x86/kernel/nmi.c                                                                          |    5 
 arch/x86/kvm/emulate.c                                                                         |    2 
 arch/x86/kvm/mmu.c                                                                             |    1 
 arch/x86/kvm/svm.c                                                                             |    1 
 arch/x86/kvm/vmx/nested.c                                                                      |    6 
 block/blk-core.c                                                                               |    9 
 block/blk-mq-sysfs.c                                                                           |    2 
 block/blk-sysfs.c                                                                              |    9 
 crypto/algif_aead.c                                                                            |    7 
 crypto/algif_skcipher.c                                                                        |    2 
 drivers/android/binder.c                                                                       |   37 -
 drivers/bluetooth/btusb.c                                                                      |    1 
 drivers/bluetooth/hci_ldisc.c                                                                  |    1 
 drivers/bluetooth/hci_serdev.c                                                                 |    2 
 drivers/char/ipmi/ipmi_si_intf.c                                                               |    2 
 drivers/clk/at91/clk-main.c                                                                    |   11 
 drivers/clk/bcm/clk-bcm2835.c                                                                  |    4 
 drivers/clk/imx/clk-imx8mq.c                                                                   |    4 
 drivers/clk/keystone/sci-clk.c                                                                 |    2 
 drivers/clk/mediatek/clk-mt6779.c                                                              |    2 
 drivers/clk/meson/g12a.c                                                                       |   11 
 drivers/clk/qcom/gcc-sdm660.c                                                                  |    2 
 drivers/clk/rockchip/clk-half-divider.c                                                        |    2 
 drivers/cpufreq/armada-37xx-cpufreq.c                                                          |    6 
 drivers/cpufreq/powernv-cpufreq.c                                                              |    9 
 drivers/crypto/caam/Kconfig                                                                    |    1 
 drivers/crypto/caam/caamalg_qi.c                                                               |   70 ++
 drivers/crypto/ccp/ccp-ops.c                                                                   |    2 
 drivers/crypto/chelsio/chtls/chtls_cm.c                                                        |    3 
 drivers/crypto/chelsio/chtls/chtls_io.c                                                        |    5 
 drivers/crypto/ixp4xx_crypto.c                                                                 |    2 
 drivers/crypto/mediatek/mtk-platform.c                                                         |    8 
 drivers/crypto/omap-sham.c                                                                     |    3 
 drivers/crypto/picoxcell_crypto.c                                                              |    9 
 drivers/dma/dmatest.c                                                                          |    5 
 drivers/dma/dw/core.c                                                                          |    4 
 drivers/dma/dw/dw.c                                                                            |    2 
 drivers/dma/dw/of.c                                                                            |    7 
 drivers/edac/aspeed_edac.c                                                                     |    4 
 drivers/edac/i5100_edac.c                                                                      |   11 
 drivers/edac/ti_edac.c                                                                         |    3 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                                              |    3 
 drivers/gpu/drm/drm_debugfs_crc.c                                                              |    4 
 drivers/gpu/drm/gma500/cdv_intel_dp.c                                                          |    2 
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c                                                    |    2 
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c                                                       |    8 
 drivers/gpu/drm/mxsfb/mxsfb_drv.c                                                              |   21 
 drivers/gpu/drm/panel/panel-simple.c                                                           |    4 
 drivers/gpu/drm/panfrost/panfrost_gpu.c                                                        |   14 
 drivers/gpu/drm/panfrost/panfrost_gpu.h                                                        |    2 
 drivers/gpu/drm/panfrost/panfrost_regs.h                                                       |    4 
 drivers/gpu/drm/virtio/virtgpu_kms.c                                                           |    2 
 drivers/gpu/drm/virtio/virtgpu_vq.c                                                            |   10 
 drivers/gpu/drm/vkms/vkms_composer.c                                                           |    2 
 drivers/hid/hid-ids.h                                                                          |    1 
 drivers/hid/hid-input.c                                                                        |    4 
 drivers/hid/hid-ite.c                                                                          |    4 
 drivers/hid/hid-roccat-kone.c                                                                  |   23 
 drivers/hwmon/pmbus/max34440.c                                                                 |    3 
 drivers/hwtracing/coresight/coresight-etm-perf.c                                               |   14 
 drivers/i2c/busses/Kconfig                                                                     |    1 
 drivers/i2c/i2c-core-acpi.c                                                                    |   11 
 drivers/i3c/master.c                                                                           |   19 
 drivers/i3c/master/i3c-master-cdns.c                                                           |    4 
 drivers/iio/adc/stm32-adc-core.c                                                               |    9 
 drivers/infiniband/core/cma.c                                                                  |   84 +--
 drivers/infiniband/core/ucma.c                                                                 |    6 
 drivers/infiniband/core/umem.c                                                                 |   15 
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c                                                     |    1 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                                                     |    5 
 drivers/infiniband/hw/hns/hns_roce_qp.c                                                        |    6 
 drivers/infiniband/hw/i40iw/i40iw.h                                                            |    9 
 drivers/infiniband/hw/i40iw/i40iw_cm.c                                                         |   10 
 drivers/infiniband/hw/i40iw/i40iw_hw.c                                                         |    4 
 drivers/infiniband/hw/i40iw/i40iw_utils.c                                                      |   59 --
 drivers/infiniband/hw/i40iw/i40iw_verbs.c                                                      |   31 -
 drivers/infiniband/hw/i40iw/i40iw_verbs.h                                                      |    3 
 drivers/infiniband/hw/mlx4/cm.c                                                                |    3 
 drivers/infiniband/hw/mlx4/mad.c                                                               |   34 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h                                                           |    2 
 drivers/infiniband/hw/mlx5/cq.c                                                                |    5 
 drivers/infiniband/hw/mlx5/main.c                                                              |    4 
 drivers/infiniband/hw/qedr/main.c                                                              |    2 
 drivers/infiniband/hw/qedr/qedr_iw_cm.c                                                        |    6 
 drivers/infiniband/hw/qedr/verbs.c                                                             |    4 
 drivers/infiniband/sw/rdmavt/vt.c                                                              |    4 
 drivers/infiniband/sw/rxe/rxe_recv.c                                                           |   20 
 drivers/infiniband/ulp/ipoib/ipoib_main.c                                                      |    2 
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c                                                   |   11 
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c                                                      |    2 
 drivers/input/keyboard/ep93xx_keypad.c                                                         |    4 
 drivers/input/keyboard/omap4-keypad.c                                                          |    6 
 drivers/input/keyboard/twl4030_keypad.c                                                        |    8 
 drivers/input/serio/sun4i-ps2.c                                                                |    9 
 drivers/input/touchscreen/imx6ul_tsc.c                                                         |   27 
 drivers/input/touchscreen/stmfts.c                                                             |    2 
 drivers/lightnvm/core.c                                                                        |    5 
 drivers/mailbox/mailbox.c                                                                      |   12 
 drivers/mailbox/mtk-cmdq-mailbox.c                                                             |    8 
 drivers/md/md-bitmap.c                                                                         |    3 
 drivers/md/md-cluster.c                                                                        |    1 
 drivers/media/firewire/firedtv-fw.c                                                            |    6 
 drivers/media/i2c/m5mols/m5mols_core.c                                                         |    3 
 drivers/media/i2c/ov5640.c                                                                     |  196 +++----
 drivers/media/i2c/tc358743.c                                                                   |   14 
 drivers/media/pci/bt8xx/bttv-driver.c                                                          |   13 
 drivers/media/pci/saa7134/saa7134-tvaudio.c                                                    |    3 
 drivers/media/platform/exynos4-is/fimc-isp.c                                                   |    4 
 drivers/media/platform/exynos4-is/fimc-lite.c                                                  |    2 
 drivers/media/platform/exynos4-is/media-dev.c                                                  |    8 
 drivers/media/platform/exynos4-is/mipi-csis.c                                                  |    4 
 drivers/media/platform/mx2_emmaprp.c                                                           |    7 
 drivers/media/platform/omap3isp/isp.c                                                          |    6 
 drivers/media/platform/qcom/camss/camss-csiphy.c                                               |    4 
 drivers/media/platform/qcom/venus/core.c                                                       |    5 
 drivers/media/platform/qcom/venus/vdec.c                                                       |   10 
 drivers/media/platform/rcar-fcp.c                                                              |    4 
 drivers/media/platform/rcar-vin/rcar-csi2.c                                                    |   24 
 drivers/media/platform/rcar-vin/rcar-dma.c                                                     |    4 
 drivers/media/platform/rcar_drif.c                                                             |   30 -
 drivers/media/platform/rockchip/rga/rga-buf.c                                                  |    1 
 drivers/media/platform/s3c-camif/camif-core.c                                                  |    5 
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c                                                    |    4 
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c                                                  |    3 
 drivers/media/platform/sti/delta/delta-v4l2.c                                                  |    4 
 drivers/media/platform/sti/hva/hva-hw.c                                                        |    4 
 drivers/media/platform/stm32/stm32-dcmi.c                                                      |    4 
 drivers/media/platform/ti-vpe/vpe.c                                                            |    2 
 drivers/media/platform/vsp1/vsp1_drv.c                                                         |   11 
 drivers/media/rc/ati_remote.c                                                                  |    4 
 drivers/media/tuners/tuner-simple.c                                                            |    5 
 drivers/media/usb/uvc/uvc_ctrl.c                                                               |    6 
 drivers/media/usb/uvc/uvc_entity.c                                                             |   35 +
 drivers/media/usb/uvc/uvc_v4l2.c                                                               |   30 +
 drivers/memory/fsl-corenet-cf.c                                                                |    6 
 drivers/memory/omap-gpmc.c                                                                     |    8 
 drivers/mfd/sm501.c                                                                            |    8 
 drivers/misc/cardreader/rtsx_pcr.c                                                             |    4 
 drivers/misc/eeprom/at25.c                                                                     |    2 
 drivers/misc/mic/scif/scif_rma.c                                                               |    4 
 drivers/misc/mic/vop/vop_main.c                                                                |    2 
 drivers/misc/mic/vop/vop_vringh.c                                                              |   24 
 drivers/misc/vmw_vmci/vmci_queue_pair.c                                                        |   10 
 drivers/mmc/core/sdio_cis.c                                                                    |    3 
 drivers/mtd/lpddr/lpddr2_nvm.c                                                                 |   35 -
 drivers/mtd/mtdoops.c                                                                          |   11 
 drivers/mtd/nand/raw/vf610_nfc.c                                                               |    6 
 drivers/mtd/nand/spi/gigadevice.c                                                              |   14 
 drivers/net/can/flexcan.c                                                                      |   34 +
 drivers/net/can/m_can/m_can_platform.c                                                         |    2 
 drivers/net/dsa/realtek-smi-core.h                                                             |    4 
 drivers/net/dsa/rtl8366.c                                                                      |  280 +++++-----
 drivers/net/dsa/rtl8366rb.c                                                                    |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c                                           |  175 +++++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h                                           |   15 
 drivers/net/ethernet/cisco/enic/enic.h                                                         |    1 
 drivers/net/ethernet/cisco/enic/enic_api.c                                                     |    6 
 drivers/net/ethernet/cisco/enic/enic_main.c                                                    |   27 
 drivers/net/ethernet/faraday/ftgmac100.c                                                       |    5 
 drivers/net/ethernet/faraday/ftgmac100.h                                                       |    8 
 drivers/net/ethernet/freescale/fec_main.c                                                      |   35 +
 drivers/net/ethernet/ibm/ibmveth.c                                                             |   19 
 drivers/net/ethernet/ibm/ibmvnic.c                                                             |   10 
 drivers/net/ethernet/ibm/ibmvnic.h                                                             |    2 
 drivers/net/ethernet/korina.c                                                                  |    3 
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                                                     |    3 
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                                                     |    2 
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c                                            |    5 
 drivers/net/ethernet/realtek/r8169_main.c                                                      |   12 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                                              |   33 -
 drivers/net/usb/qmi_wwan.c                                                                     |    1 
 drivers/net/wan/hdlc.c                                                                         |   10 
 drivers/net/wan/hdlc_raw_eth.c                                                                 |    1 
 drivers/net/wireless/ath/ath10k/ce.c                                                           |    2 
 drivers/net/wireless/ath/ath10k/htt_rx.c                                                       |    8 
 drivers/net/wireless/ath/ath10k/mac.c                                                          |    2 
 drivers/net/wireless/ath/ath6kl/main.c                                                         |    3 
 drivers/net/wireless/ath/ath6kl/wmi.c                                                          |    5 
 drivers/net/wireless/ath/ath9k/hif_usb.c                                                       |   19 
 drivers/net/wireless/ath/ath9k/htc_hst.c                                                       |    2 
 drivers/net/wireless/ath/wcn36xx/main.c                                                        |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c                                        |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c                                      |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c                                 |    4 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                                              |    9 
 drivers/net/wireless/marvell/mwifiex/scan.c                                                    |    2 
 drivers/net/wireless/marvell/mwifiex/sdio.c                                                    |    2 
 drivers/net/wireless/marvell/mwifiex/usb.c                                                     |    3 
 drivers/net/wireless/quantenna/qtnfmac/commands.c                                              |    2 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c                                          |   10 
 drivers/net/wireless/realtek/rtw88/pci.h                                                       |    4 
 drivers/ntb/hw/amd/ntb_hw_amd.c                                                                |    1 
 drivers/nvme/host/pci.c                                                                        |    3 
 drivers/nvme/target/core.c                                                                     |    3 
 drivers/nvmem/core.c                                                                           |   33 -
 drivers/opp/core.c                                                                             |    6 
 drivers/pci/controller/pci-aardvark.c                                                          |   11 
 drivers/pci/controller/pcie-iproc-msi.c                                                        |   13 
 drivers/pci/iov.c                                                                              |    1 
 drivers/perf/thunderx2_pmu.c                                                                   |    7 
 drivers/perf/xgene_pmu.c                                                                       |   32 -
 drivers/pinctrl/bcm/Kconfig                                                                    |    1 
 drivers/pinctrl/pinctrl-mcp23s08.c                                                             |   24 
 drivers/platform/x86/mlx-platform.c                                                            |   15 
 drivers/pwm/pwm-img.c                                                                          |    3 
 drivers/pwm/pwm-lpss.c                                                                         |    7 
 drivers/rapidio/devices/rio_mport_cdev.c                                                       |   18 
 drivers/regulator/core.c                                                                       |   21 
 drivers/rpmsg/qcom_smd.c                                                                       |   32 -
 drivers/s390/net/qeth_l2_main.c                                                                |    6 
 drivers/scsi/be2iscsi/be_main.c                                                                |    4 
 drivers/scsi/bfa/bfad.c                                                                        |    1 
 drivers/scsi/csiostor/csio_hw.c                                                                |    2 
 drivers/scsi/ibmvscsi/ibmvfc.c                                                                 |    1 
 drivers/scsi/mpt3sas/mpt3sas_base.c                                                            |   14 
 drivers/scsi/mvumi.c                                                                           |    1 
 drivers/scsi/qedf/qedf_main.c                                                                  |    2 
 drivers/scsi/qedi/qedi_fw.c                                                                    |   23 
 drivers/scsi/qedi/qedi_iscsi.c                                                                 |    2 
 drivers/scsi/qla2xxx/qla_init.c                                                                |   10 
 drivers/scsi/qla2xxx/qla_inline.h                                                              |    5 
 drivers/scsi/qla2xxx/qla_nvme.c                                                                |    2 
 drivers/scsi/qla2xxx/qla_target.c                                                              |    2 
 drivers/scsi/qla4xxx/ql4_os.c                                                                  |    2 
 drivers/scsi/smartpqi/smartpqi.h                                                               |    2 
 drivers/scsi/smartpqi/smartpqi_init.c                                                          |  101 ++-
 drivers/scsi/ufs/ufs-qcom.c                                                                    |    5 
 drivers/slimbus/core.c                                                                         |    6 
 drivers/slimbus/qcom-ngd-ctrl.c                                                                |    4 
 drivers/soc/fsl/qbman/bman.c                                                                   |    2 
 drivers/spi/spi-omap2-mcspi.c                                                                  |   17 
 drivers/spi/spi-s3c64xx.c                                                                      |   52 +
 drivers/staging/emxx_udc/emxx_udc.c                                                            |    4 
 drivers/staging/media/ipu3/ipu3-css-params.c                                                   |    2 
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c                                              |    2 
 drivers/staging/wilc1000/wilc_mon.c                                                            |    3 
 drivers/target/target_core_user.c                                                              |    2 
 drivers/tty/hvc/hvcs.c                                                                         |   14 
 drivers/tty/ipwireless/network.c                                                               |    4 
 drivers/tty/ipwireless/tty.c                                                                   |    2 
 drivers/tty/pty.c                                                                              |    2 
 drivers/tty/serial/Kconfig                                                                     |    1 
 drivers/tty/serial/fsl_lpuart.c                                                                |   16 
 drivers/usb/cdns3/gadget.c                                                                     |    2 
 drivers/usb/class/cdc-acm.c                                                                    |   23 
 drivers/usb/class/cdc-wdm.c                                                                    |   72 +-
 drivers/usb/core/urb.c                                                                         |   89 +--
 drivers/usb/dwc2/gadget.c                                                                      |   40 +
 drivers/usb/dwc2/params.c                                                                      |    2 
 drivers/usb/dwc3/core.c                                                                        |   25 
 drivers/usb/dwc3/core.h                                                                        |    7 
 drivers/usb/dwc3/dwc3-of-simple.c                                                              |    1 
 drivers/usb/gadget/function/f_ncm.c                                                            |    8 
 drivers/usb/gadget/function/f_printer.c                                                        |   16 
 drivers/usb/gadget/function/u_ether.c                                                          |    2 
 drivers/usb/host/ohci-hcd.c                                                                    |   16 
 drivers/usb/host/xhci.c                                                                        |    3 
 drivers/vfio/pci/vfio_pci_config.c                                                             |   24 
 drivers/vfio/pci/vfio_pci_intrs.c                                                              |    4 
 drivers/vfio/vfio_iommu_type1.c                                                                |    3 
 drivers/video/backlight/sky81452-backlight.c                                                   |    1 
 drivers/video/fbdev/aty/radeon_base.c                                                          |    2 
 drivers/video/fbdev/core/fbmem.c                                                               |    4 
 drivers/video/fbdev/sis/init.c                                                                 |   11 
 drivers/video/fbdev/vga16fb.c                                                                  |   14 
 drivers/virt/fsl_hypervisor.c                                                                  |   17 
 drivers/watchdog/sp5100_tco.h                                                                  |    2 
 drivers/watchdog/watchdog_dev.c                                                                |    6 
 fs/cifs/asn1.c                                                                                 |   16 
 fs/cifs/smb2ops.c                                                                              |   14 
 fs/d_path.c                                                                                    |    6 
 fs/dlm/config.c                                                                                |    3 
 fs/ext4/fsmap.c                                                                                |    3 
 fs/f2fs/sysfs.c                                                                                |    1 
 fs/iomap/buffered-io.c                                                                         |    1 
 fs/iomap/direct-io.c                                                                           |   10 
 fs/ntfs/inode.c                                                                                |    6 
 fs/proc/base.c                                                                                 |    3 
 fs/quota/quota_v2.c                                                                            |    1 
 fs/ramfs/file-nommu.c                                                                          |    2 
 fs/reiserfs/inode.c                                                                            |    3 
 fs/reiserfs/super.c                                                                            |    8 
 fs/udf/inode.c                                                                                 |   25 
 fs/udf/super.c                                                                                 |    6 
 fs/xfs/libxfs/xfs_rtbitmap.c                                                                   |   11 
 fs/xfs/xfs_fsmap.c                                                                             |   48 +
 fs/xfs/xfs_fsmap.h                                                                             |    6 
 fs/xfs/xfs_ioctl.c                                                                             |  144 +++--
 fs/xfs/xfs_rtalloc.c                                                                           |   11 
 include/linux/bpf_verifier.h                                                                   |    1 
 include/linux/oom.h                                                                            |    1 
 include/linux/overflow.h                                                                       |    1 
 include/linux/page_owner.h                                                                     |    6 
 include/linux/pci.h                                                                            |    1 
 include/linux/platform_data/dma-dw.h                                                           |    2 
 include/linux/sched/coredump.h                                                                 |    1 
 include/net/ip.h                                                                               |    6 
 include/net/netfilter/nf_log.h                                                                 |    1 
 include/rdma/ib_umem.h                                                                         |    9 
 include/scsi/scsi_common.h                                                                     |    7 
 include/sound/hda_codec.h                                                                      |    1 
 include/trace/events/target.h                                                                  |   12 
 include/uapi/linux/perf_event.h                                                                |    2 
 kernel/bpf/verifier.c                                                                          |   29 +
 kernel/debug/kdb/kdb_io.c                                                                      |    8 
 kernel/fork.c                                                                                  |   21 
 kernel/module.c                                                                                |   13 
 kernel/power/hibernate.c                                                                       |   11 
 kernel/sched/core.c                                                                            |    2 
 kernel/sched/fair.c                                                                            |    9 
 kernel/sched/sched.h                                                                           |   13 
 lib/crc32.c                                                                                    |    2 
 lib/idr.c                                                                                      |    1 
 mm/filemap.c                                                                                   |    8 
 mm/huge_memory.c                                                                               |    2 
 mm/memcontrol.c                                                                                |    5 
 mm/oom_kill.c                                                                                  |    2 
 mm/page_alloc.c                                                                                |    4 
 mm/page_owner.c                                                                                |    4 
 mm/swapfile.c                                                                                  |    4 
 net/bluetooth/l2cap_sock.c                                                                     |    7 
 net/bridge/netfilter/ebt_dnat.c                                                                |    2 
 net/bridge/netfilter/ebt_redirect.c                                                            |    2 
 net/bridge/netfilter/ebt_snat.c                                                                |    2 
 net/can/j1939/transport.c                                                                      |    2 
 net/core/filter.c                                                                              |    3 
 net/core/sock.c                                                                                |   12 
 net/ipv4/icmp.c                                                                                |    7 
 net/ipv4/ip_gre.c                                                                              |   15 
 net/ipv4/netfilter/nf_log_arp.c                                                                |   19 
 net/ipv4/netfilter/nf_log_ipv4.c                                                               |    6 
 net/ipv4/nexthop.c                                                                             |    2 
 net/ipv4/route.c                                                                               |    4 
 net/ipv4/tcp_input.c                                                                           |    2 
 net/ipv6/ip6_fib.c                                                                             |    4 
 net/ipv6/netfilter/nf_log_ipv6.c                                                               |    8 
 net/mac80211/cfg.c                                                                             |    3 
 net/mac80211/sta_info.c                                                                        |    4 
 net/netfilter/ipvs/ip_vs_ctl.c                                                                 |    7 
 net/netfilter/ipvs/ip_vs_xmit.c                                                                |    6 
 net/netfilter/nf_conntrack_proto_tcp.c                                                         |   19 
 net/netfilter/nf_dup_netdev.c                                                                  |    1 
 net/netfilter/nf_log_common.c                                                                  |   12 
 net/netfilter/nft_fwd_netdev.c                                                                 |    1 
 net/nfc/netlink.c                                                                              |    2 
 net/sched/act_api.c                                                                            |   14 
 net/sched/act_tunnel_key.c                                                                     |    2 
 net/smc/smc_core.c                                                                             |    2 
 net/sunrpc/auth_gss/svcauth_gss.c                                                              |   27 
 net/sunrpc/xprtrdma/svc_rdma_sendto.c                                                          |    3 
 net/tipc/msg.c                                                                                 |    3 
 net/tls/tls_device.c                                                                           |   11 
 net/wireless/nl80211.c                                                                         |   21 
 samples/mic/mpssd/mpssd.c                                                                      |    4 
 security/integrity/ima/ima_crypto.c                                                            |    2 
 sound/core/seq/oss/seq_oss.c                                                                   |    7 
 sound/firewire/bebob/bebob_hwdep.c                                                             |    3 
 sound/pci/hda/hda_intel.c                                                                      |   14 
 sound/pci/hda/patch_ca0132.c                                                                   |   24 
 sound/pci/hda/patch_hdmi.c                                                                     |   20 
 sound/pci/hda/patch_realtek.c                                                                  |   56 ++
 sound/soc/codecs/tlv320aic32x4.c                                                               |    9 
 sound/soc/fsl/fsl_sai.c                                                                        |   19 
 sound/soc/fsl/fsl_sai.h                                                                        |    1 
 sound/soc/fsl/imx-es8328.c                                                                     |   12 
 sound/soc/qcom/lpass-cpu.c                                                                     |   16 
 sound/soc/qcom/lpass-platform.c                                                                |    3 
 tools/perf/builtin-stat.c                                                                      |    4 
 tools/perf/util/intel-pt.c                                                                     |    8 
 tools/testing/radix-tree/idr-test.c                                                            |   29 +
 tools/testing/selftests/bpf/progs/test_sysctl_loop1.c                                          |    4 
 tools/testing/selftests/bpf/progs/test_sysctl_loop2.c                                          |    4 
 tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-inter-event-combined-hist.tc |    8 
 tools/testing/selftests/net/config                                                             |    1 
 tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh                                     |   10 
 tools/testing/selftests/net/forwarding/vxlan_symmetric.sh                                      |   10 
 tools/testing/selftests/net/rtnetlink.sh                                                       |    5 
 tools/testing/selftests/powerpc/eeh/eeh-basic.sh                                               |    9 
 428 files changed, 3304 insertions(+), 1731 deletions(-)

Abel Vesa (1):
      clk: imx8mq: Fix usdhc parents order

Abhishek Pandit-Subedi (1):
      Bluetooth: Only mark socket zapped after unlocking

Adam Goode (1):
      media: uvcvideo: Ensure all probed info is returned to v4l2

Aditya Pakki (1):
      media: st-delta: Fix reference count leak in delta_run_work

Adrian Hunter (1):
      perf intel-pt: Fix "context_switch event has no tid" error

Al Grant (1):
      perf: correct SNOOPX field offset

Alex Dewar (2):
      staging: emxx_udc: Fix passing of NULL to dma_alloc_coherent()
      VMCI: check return value of get_user_pages_fast() for errors

Alex Williamson (1):
      vfio/pci: Clear token on bypass registration failure

Alexander Aring (1):
      fs: dlm: fix configfs memory leak

Alexei Starovoitov (1):
      mm/error_inject: Fix allow_error_inject function signatures.

Amit Singh Tomar (1):
      arm64: dts: actions: limit address range for pinctrl node

Andrei Botila (1):
      crypto: caam/qi - add fallback for XTS with more than 8B IV

Andrii Nakryiko (1):
      fs: fix NULL dereference due to data race in prepend_path()

Andy Shevchenko (1):
      dmaengine: dmatest: Check list for emptiness before access its last entry

Aneesh Kumar K.V (1):
      powerpc/book3s64/hash/4k: Support large linear mapping range with 4K

Arnd Bergmann (2):
      mtd: lpddr: fix excessive stack usage with clang
      ARM: s3c24xx: fix mmc gpio lookup tables

Artem Savkov (1):
      pty: do tty_flip_buffer_push without port->lock in pty_write

Arvind Sankar (2):
      x86/fpu: Allow multiple bits in clearcpuid= parameter
      x86/asm: Replace __force_order with a memory clobber

Aswath Govindraju (1):
      spi: omap2-mcspi: Improve performance waiting for CHSTAT

Athira Rajeev (1):
      powerpc/perf: Exclude pmc5/6 from the irrelevant PMU group constraints

Bob Pearson (2):
      RDMA/rxe: Fix skb lifetime in rxe_rcv_mcast_pkt()
      RDMA/rxe: Handle skb_clone() failure in rxe_recv.c

Borislav Petkov (2):
      x86/mce: Add Skylake quirk for patrol scrub reported errors
      x86/mce: Make mce_rdmsrl() panic on an inaccessible MSR

Brooke Basile (1):
      ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()

Bryan O'Donoghue (1):
      wcn36xx: Fix reported 802.11n rx_highest rate wcn3660/wcn3680

Can Guo (1):
      scsi: ufs: ufs-qcom: Fix race conditions caused by ufs_qcom_testbus_config()

Chris Chiu (1):
      rtl8xxxu: prevent potential memory leak

Christian Eggers (2):
      socket: fix option SO_TIMESTAMPING_NEW
      eeprom: at25: set minimum read/write access stride to 1

Christoph Hellwig (1):
      PM: hibernate: remove the bogus call to get_gendisk() in software_resume()

Christophe JAILLET (6):
      crypto: ixp4xx - Fix the size used in a 'dma_free_coherent()' call
      media: staging/intel-ipu3: css: Correctly reset some memory
      ath10k: Fix the size used in a 'dma_free_coherent()' call in an error handling path
      mwifiex: Do not use GFP_KERNEL in atomic context
      staging: rtl8192u: Do not use GFP_KERNEL in atomic context
      scsi: qla4xxx: Fix an error handling path in 'qla4xxx_get_host_stats()'

Claudiu Beznea (2):
      clk: at91: clk-main: update key before writing AT91_CKGR_MOR
      ARM: at91: pm: of_node_put() after its usage

Colin Ian King (5):
      x86/events/amd/iommu: Fix sizeof mismatch
      video: fbdev: vga16fb: fix setting of pixclock because a pass-by-value error
      qtnfmac: fix resource leaks on unsupported iftype error return path
      IB/rdmavt: Fix sizeof mismatch
      lightnvm: fix out-of-bounds write to array devices->info[]

Cong Wang (4):
      tipc: fix the skb_unshare() in tipc_buf_append()
      can: j1935: j1939_tp_tx_dat_new(): fix missing initialization of skbcnt
      net_sched: remove a redundant goto chain check
      ip_gre: set dev->hard_header_len and dev->needed_headroom properly

Connor McAdams (2):
      ALSA: hda/ca0132 - Add AE-7 microphone selection commands.
      ALSA: hda/ca0132 - Add new quirk ID for SoundBlaster AE-7.

Cristian Ciocaltea (1):
      ARM: dts: owl-s500: Fix incorrect PPI interrupt specifiers

Dan Aloni (1):
      svcrdma: fix bounce buffers for unaligned offsets and multiple pages

Dan Carpenter (11):
      ALSA: bebob: potential info leak in hwdep_read()
      cifs: remove bogus debug code
      ath6kl: prevent potential array overflow in ath6kl_add_new_sta()
      ath9k: Fix potential out of bounds in ath9k_htc_txcompletion_cb()
      HID: roccat: add bounds checking in kone_sysfs_write_settings()
      ath6kl: wmi: prevent a shift wrapping bug in ath6kl_wmi_delete_pstream_cmd()
      mfd: sm501: Fix leaks in probe()
      scsi: be2iscsi: Fix a theoretical leak in beiscsi_create_eqs()
      rpmsg: smd: Fix a kobj leak in in qcom_smd_parse_edge()
      Input: imx6ul_tsc - clean up some errors in imx6ul_tsc_resume()
      memory: omap-gpmc: Fix a couple off by ones

Daniel Jordan (1):
      module: statically initialize init section freeing data

Daniel Thompson (1):
      kdb: Fix pager search for multi-line strings

Daniel Wagner (1):
      scsi: qla2xxx: Warn if done() or free() are called on an already freed srb

Darrick J. Wong (5):
      xfs: limit entries returned when counting fsmap records
      xfs: fix deadlock and streamline xfs_getfsmap performance
      xfs: fix high key handling in the rt allocator's query_range function
      ext4: limit entries returned when counting fsmap records
      xfs: make sure the rt allocator doesn't run off the end

David Ahern (1):
      ipv4: Restore flowi4_oif update before call to xfrm_lookup_route

David Milburn (1):
      nvme-pci: disable the write zeros command for Intel 600P/P3100

David Wilder (2):
      ibmveth: Switch order of ibmveth_helper calls.
      ibmveth: Identify ingress large send packets.

Davide Caratti (1):
      net/sched: act_tunnel_key: fix OOB write in case of IPv6 ERSPAN tunnels

Defang Bo (1):
      nfc: Ensure presence of NFC_ATTR_FIRMWARE_NAME attribute in nfc_genl_fw_download()

Dinghao Liu (13):
      EDAC/i5100: Fix error handling order in i5100_init_one()
      media: omap3isp: Fix memleak in isp_probe
      media: mx2_emmaprp: Fix memleak in emmaprp_probe
      drm/crc-debugfs: Fix memleak in crc_control_write
      video: fbdev: radeon: Fix memleak in radeonfb_pci_register
      watchdog: Fix memleak in watchdog_cdev_register
      watchdog: Use put_device on error
      media: vsp1: Fix runtime PM imbalance on error
      media: platform: s3c-camif: Fix runtime PM imbalance on error
      media: platform: sti: hva: Fix runtime PM imbalance on error
      media: bdisp: Fix runtime PM imbalance on error
      media: venus: core: Fix runtime PM imbalance in venus_probe
      Bluetooth: btusb: Fix memleak in btusb_mtk_submit_wmt_recv_urb

Dirk Behme (1):
      i2c: rcar: Auto select RESET_CONTROLLER

Dmitry Torokhov (1):
      HID: hid-input: fix stylus battery reporting

Doug Horn (1):
      Fix use after free in get_capset_info callback.

Dylan Hung (1):
      net: ftgmac100: Fix Aspeed ast2600 TX hang issue

Eli Billauer (1):
      usb: core: Solve race condition in anchor cleanup functions

Emmanuel Grumbach (1):
      iwlwifi: mvm: split a print to avoid a WARNING in ROC

Eran Ben Elisha (1):
      net/mlx5: Don't call timecounter cyc2time directly from 1PPS flow

Eric Biggers (1):
      reiserfs: only call unlock_new_inode() if I_NEW

Eric Dumazet (2):
      icmp: randomize the global rate limiter
      quota: clear padding in v2r1_mem2diskdqb()

Evgeny Novikov (1):
      mtd: rawnand: vf610: disable clk on error handling path in probe

Fabrice Gasnier (1):
      iio: adc: stm32-adc: fix runtime autosuspend delay when slow polling

Finn Thain (5):
      powerpc/tau: Use appropriate temperature sample interval
      powerpc/tau: Convert from timer to workqueue
      powerpc/tau: Remove duplicated set_thresholds() call
      powerpc/tau: Check processor type before enabling TAU interrupt
      powerpc/tau: Disable TAU between measurements

Francesco Ruggeri (1):
      netfilter: conntrack: connection timeout after re-register

Ganesh Goudar (1):
      powerpc/pseries: Avoid using addr_to_pfn in real mode

Geert Uytterhoeven (2):
      arm64: dts: renesas: r8a77990: Fix MSIOF1 DMA channels
      arm64: dts: renesas: r8a774c0: Fix MSIOF1 DMA channels

George Kennedy (1):
      fbmem: add margin check to fb_check_caps()

Greg Kroah-Hartman (1):
      Linux 5.4.73

Guenter Roeck (2):
      hwmon: (pmbus/max34440) Fix status register reads for MAX344{51,60,61}
      watchdog: sp5100: Fix definition of EFCH_PM_DECODEEN3

Guillaume Tucker (1):
      ARM: 9007/1: l2c: fix prefetch bits init in L2X0_AUX_CTRL using DT values

Hamish Martin (1):
      usb: ohci: Default to per-port over-current protection

Hanks Chen (1):
      clk: mediatek: add UART0 clock support

Hans de Goede (4):
      pwm: lpss: Fix off by one error in base_unit math in pwm_lpss_prepare()
      pwm: lpss: Add range limit check for the base_unit register value
      i2c: core: Restore acpi_walk_dep_device_list() getting called after registering the ACPI i2c devs
      HID: ite: Add USB id match for Acer One S1003 keyboard dock

Hauke Mehrtens (3):
      mtd: spinand: gigadevice: Only one dummy byte in QUADIO
      mtd: spinand: gigadevice: Add QE Bit
      pwm: img: Fix null pointer access in probe

Heiner Kallweit (2):
      r8169: fix data corruption issue on RTL8402
      r8169: fix operation under forced interrupt threading

Herat Ramani (1):
      cxgb4: handle 4-tuple PEDIT to NAT mode translation

Herbert Xu (2):
      crypto: algif_aead - Do not set MAY_BACKLOG on the async path
      crypto: algif_skcipher - EBUSY on aio should be an error

Horia Geantă (1):
      ARM: dts: imx6sl: fix rng node

Huang Guobin (1):
      net: wilc1000: clean up resource in error path of init mon interface

Hui Wang (1):
      ALSA: hda/realtek - set mic to auto detect on a HP AIO machine

Håkon Bugge (2):
      IB/mlx4: Fix starvation in paravirt mux/demux
      IB/mlx4: Adjust delayed work when a dup is observed

Ido Schimmel (2):
      nexthop: Fix performance regression in nexthop deletion
      selftests: forwarding: Add missing 'rp_filter' configuration

Jamie Iles (1):
      f2fs: wait for sysfs kobject removal before freeing f2fs_sb_info

Jan Kara (3):
      udf: Limit sparing table size
      udf: Avoid accessing uninitialized data on failed inode read
      reiserfs: Fix memory leak in reiserfs_parse_options()

Jann Horn (1):
      binder: Remove bogus warning on failed same-process transaction

Jason Gunthorpe (8):
      RDMA/ucma: Fix locking for ctx->events_reported
      RDMA/ucma: Add missing locking around rdma_leave_multicast()
      RDMA/umem: Fix signature of stub ib_umem_find_best_pgsz()
      RDMA/umem: Fix ib_umem_find_best_pgsz() for mappings that cross a page boundary
      RDMA/umem: Prevent small pages from being returned by ib_umem_find_best_pgsz()
      RDMA/cma: Remove dead code for kernel rdmacm multicast
      RDMA/cma: Consolidate the destruction of a cma_multicast in one place
      RDMA/mlx5: Disable IB_DEVICE_MEM_MGT_EXTENSIONS if IB_WR_REG_MR can't work

Jassi Brar (1):
      mailbox: avoid timer start from callback

Jeremy Szu (1):
      ALSA: hda/realtek - The front Mic on a HP machine doesn't work

Jernej Skrabec (1):
      ARM: dts: sun8i: r40: bananapi-m2-ultra: Fix dcdc1 regulator

Jerome Brunet (1):
      arm64: dts: meson: vim3: correct led polarity

Jian-Hong Pan (1):
      ALSA: hda/realtek: Enable audio jacks of ASUS D700SA with ALC887

Jin Yao (1):
      perf stat: Skip duration_time in setup_system_wide

Jing Xiangfeng (5):
      i3c: master: Fix error return in cdns_i3c_master_probe()
      rapidio: fix the missed put_device() for rio_mport_add_riodev
      scsi: bfa: Fix error return in bfad_pci_init()
      scsi: mvumi: Fix error return in mvumi_io_attach()
      scsi: ibmvfc: Fix error return in ibmvfc_probe()

Joakim Zhang (1):
      can: flexcan: flexcan_chip_stop(): add error handling and propagate error value

Johan Hovold (1):
      USB: cdc-acm: handle broken union descriptors

Johannes Berg (1):
      nl80211: fix non-split wiphy information

John Donnelly (1):
      scsi: target: tcmu: Fix warning: 'page' may be used uninitialized

Jonathan Lemon (1):
      mlx4: handle non-napi callers to napi_poll

Julian Anastasov (1):
      ipvs: clear skb->tstamp in forwarding path

Julian Wiedmann (1):
      s390/qeth: don't let HW override the configured port role

Juri Lelli (1):
      sched/features: Fix !CONFIG_JUMP_LABEL case

Kai Vehmanen (2):
      ALSA: hda: fix jack detection with Realtek codecs when in D3
      ALSA: hda/hdmi: fix incorrect locking in hdmi_pcm_close

Kaige Li (1):
      NTB: hw: amd: fix an issue about leak system resources

Kajol Jain (1):
      powerpc/perf/hv-gpci: Fix starting index value

Kamal Heib (1):
      RDMA/ipoib: Set rtnl_link_ops for ipoib interfaces

Kan Liang (3):
      perf/x86/intel/ds: Fix x86_pmu_stop warning for large PEBS
      perf/x86/intel/uncore: Update Ice Lake uncore units
      perf/x86/intel/uncore: Reduce the number of CBOX counters

Karsten Graul (1):
      net/smc: fix valid DMBE buffer sizes

Ke Li (1):
      net: Properly typecast int values to set sk_max_pacing_rate

Keita Suzuki (2):
      misc: rtsx: Fix memory leak in rtsx_pci_probe
      brcmsmac: fix memory leak in wlc_phy_attach_lcnphy

Kevin Barnett (1):
      scsi: smartpqi: Avoid crashing kernel for controller issues

Konrad Dybcio (1):
      clk: qcom: gcc-sdm660: Fix wrong parent_map

Krzysztof Kozlowski (10):
      EDAC/aspeed: Fix handling of platform_get_irq() error
      EDAC/ti: Fix handling of platform_get_irq() error
      maiblox: mediatek: Fix handling of platform_get_irq() error
      Input: ep93xx_keypad - fix handling of platform_get_irq() error
      Input: omap4-keypad - fix handling of platform_get_irq() error
      Input: twl4030_keypad - fix handling of platform_get_irq() error
      Input: sun4i-ps2 - fix handling of platform_get_irq() error
      memory: fsl-corenet-cf: Fix handling of platform_get_irq() error
      arm64: dts: imx8mq: Add missing interrupts to GPC
      soc: fsl: qbman: Fix return value on success

Lad Prabhakar (3):
      media: i2c: ov5640: Remain in power down for DVP mode unless streaming
      media: i2c: ov5640: Separate out mipi configuration from s_power
      media: i2c: ov5640: Enable data pins on poweron for DVP mode

Lang Cheng (1):
      RDMA/hns: Add a check for current state before modifying QP

Laurent Pinchart (7):
      media: uvcvideo: Set media controller entity functions
      media: uvcvideo: Silence shift-out-of-bounds warning
      media: rcar_drif: Fix fwnode reference leak when parsing DT
      media: rcar_drif: Allocate v4l2_async_subdev dynamically
      media: rcar-csi2: Allocate v4l2_async_subdev dynamically
      drm: panel: Fix bus format for OrtusTech COM43H4M85ULC panel
      drm: panel: Fix bpc for OrtusTech COM43H4M85ULC panel

Leon Romanovsky (2):
      RDMA/mlx5: Fix potential race between destroy and CQE poll
      overflow: Include header file with SIZE_MAX declaration

Libing Zhou (1):
      x86/nmi: Fix nmi_handle() duration miscalculation

Lijun Ou (1):
      RDMA/hns: Set the unsupported wr opcode

Lijun Pan (2):
      ibmvnic: save changed mac address to adapter->mac_addr
      ibmvnic: set up 200GBPS speed

Linus Walleij (4):
      net: dsa: rtl8366: Check validity of passed VLANs
      net: dsa: rtl8366: Refactor VLAN/PVID init
      net: dsa: rtl8366: Skip PVID setting if not requested
      net: dsa: rtl8366rb: Support all 4096 VLANs

Lorenzo Colitti (3):
      usb: gadget: f_ncm: fix ncm_bitrate for SuperSpeed and above.
      usb: gadget: u_ether: enable qmult on SuperSpeed Plus as well
      usb: gadget: f_ncm: allow using NCM in SuperSpeed Plus gadgets.

Lucas Stach (1):
      can: m_can_platform: don't call m_can_class_suspend in runtime suspend

Maciej Fijalkowski (1):
      bpf: Limit caller's stack depth 256 for subprogs with tailcalls

Maciej Żenczykowski (1):
      net/ipv4: always honour route mtu during forwarding

Madhuparna Bhowmik (1):
      crypto: picoxcell - Fix potential race condition bug

Marc Kleine-Budde (1):
      net: j1939: j1939_session_fresh_new(): fix missing initialization of skbcnt

Marek Vasut (2):
      net: fec: Fix phy_device lookup for phy_reset_after_clk_enable()
      net: fec: Fix PHY init after phy_reset_after_clk_enable()

Mark Salter (2):
      drivers/perf: xgene_pmu: Fix uninitialized resource struct
      drivers/perf: thunderx2_pmu: Fix memory resource error handling

Mark Tomlinson (2):
      mtd: mtdoops: Don't write panic data twice
      PCI: iproc: Set affinity mask on MSI interrupts

Martijn de Gouw (1):
      SUNRPC: fix copying of multiple pages in gss_read_proxy_verf()

Martin Blumenstingl (1):
      ARM: dts: meson8: remove two invalid interrupt lines from the GPU node

Mathias Nyman (1):
      xhci: don't create endpoint debugfs entry before ring buffer is set.

Matthew Rosato (2):
      PCI/IOV: Mark VFs as not implementing PCI_COMMAND_MEMORY
      vfio/pci: Decouple PCI_COMMAND_MEMORY bit checks from is_virtfn

Matthew Wilcox (Oracle) (4):
      iomap: Clear page error before beginning a write
      ida: Free allocated bitmap in error path
      mm/page_owner: change split_page_owner to take a count
      ramfs: fix nommu mmap with gaps in the page cache

Mauro Carvalho Chehab (2):
      media: saa7134: avoid a shift overflow
      usb: dwc3: simple: add support for Hikey 970

Melissa Wen (1):
      drm/vkms: fix xrgb on compute crc

Miaohe Lin (1):
      mm/swapfile.c: fix potential memory leak in sys_swapon

Michal Kalderon (4):
      RDMA/qedr: Fix qp structure memory leak
      RDMA/qedr: Fix use of uninitialized field
      RDMA/qedr: Fix return code if accept is called on a destroyed qp
      RDMA/qedr: Fix inline size returned for iWARP

Michal Simek (1):
      arm64: dts: zynqmp: Remove additional compatible string for i2c IPs

Michał Mirosław (1):
      regulator: resolve supply after creating regulator

Minas Harutyunyan (1):
      usb: dwc2: Fix INTR OUT transfers in DDMA mode.

Miquel Raynal (1):
      ASoC: tlv320aic32x4: Fix bdiv clock rate derivation

Nathan Chancellor (1):
      usb: dwc2: Fix parameter type in function pointer prototype

Nathan Lynch (1):
      powerpc/pseries: explicitly reschedule during drmem_lmb list traversal

Navid Emamdoost (1):
      clk: bcm2835: add missing release if devm_clk_hw_register fails

Neal Cardwell (1):
      tcp: fix to update snd_wl1 in bulk receiver fast path

Necip Fazil Yildiran (2):
      pinctrl: bcm: fix kconfig dependency warning when !GPIOLIB
      arc: plat-hsdk: fix kconfig dependency warning when !RESET_CONTROLLER

Neil Armstrong (1):
      drm/panfrost: add amlogic reset quirk callback

Nicholas Mc Guire (2):
      powerpc/pseries: Fix missing of_node_put() in rng_init()
      powerpc/icp-hv: Fix missing of_node_put() in success path

Nicholas Piggin (1):
      powerpc/64s/radix: Fix mm_cpumask trimming race vs kthread_use_mm

Nilesh Javali (2):
      scsi: qedi: Protect active command list to avoid list corruption
      scsi: qedi: Fix list_del corruption while removing active I/O

Oliver Neukum (2):
      media: ati_remote: sanity check for both endpoints
      USB: cdc-wdm: Make wdm_flush() interruptible and add wdm_fsync().

Oliver O'Halloran (1):
      selftests/powerpc: Fix eeh-basic.sh exit codes

Ong Boon Leong (1):
      net: stmmac: use netif_tx_start|stop_all_queues() function

Pablo Neira Ayuso (2):
      netfilter: nf_log: missing vlan offload tag and proto
      netfilter: nf_fwd_netdev: clear timestamp in forwarding path

Pali Rohár (3):
      cpufreq: armada-37xx: Add missing MODULE_DEVICE_TABLE
      PCI: aardvark: Check for errors from pci_bridge_emul_init() call
      mmc: sdio: Check for CISTPL_VERS_1 buffer size

Parshuram Thombare (1):
      i3c: master add i3c_master_attach_boardinfo to preserve boardinfo

Paul Kocialkowski (1):
      media: ov5640: Correct Bit Div register in clock tree diagram

Pavel Machek (2):
      crypto: ccp - fix error handling
      media: firewire: fix memory leak

Peilin Ye (1):
      ipvs: Fix uninit-value in do_ip_vs_set_ctl()

Peng Fan (2):
      tty: serial: lpuart: fix lpuart32_write usage
      tty: serial: fsl_lpuart: fix lpuart32_poll_get_char

Peter Chen (1):
      usb: cdns3: gadget: free interrupt after gadget has deleted

Po-Hsu Lin (1):
      selftests: rtnetlink: load fou module for kci_test_encap_fou() test

Qian Cai (1):
      iomap: fix WARN_ON_ONCE() from unprivileged users

Qiang Yu (1):
      arm64: dts: allwinner: h5: remove Mali GPU PMU module

Qiu Wenbo (1):
      ALSA: hda/realtek - Add mute Led support for HP Elitebook 845 G7

Qiushi Wu (11):
      media: rcar-vin: Fix a reference count leak.
      media: rockchip/rga: Fix a reference count leak.
      media: platform: fcp: Fix a reference count leak.
      media: camss: Fix a reference count leak.
      media: s5p-mfc: Fix a reference count leak
      media: stm32-dcmi: Fix a reference count leak
      media: ti-vpe: Fix a missing check and reference count leak
      media: sti: Fix reference count leaks
      media: exynos4-is: Fix several reference count leaks due to pm_runtime_get_sync
      media: exynos4-is: Fix a reference count leak due to pm_runtime_get_sync
      media: exynos4-is: Fix a reference count leak

Rajkumar Manoharan (1):
      nl80211: fix OBSS PD min and max offset validation

Ralph Campbell (1):
      mm/memcg: fix device private memcg accounting

Robert Hoo (1):
      KVM: x86: emulating RDPID failure shall return #UD rather than #GP

Roberto Sassu (1):
      ima: Don't ignore errors from crypto_shash_update()

Rohit Maheshwari (1):
      net/tls: sendfile fails with ktls offload

Rohit kumar (2):
      ASoC: qcom: lpass-platform: fix memory leak
      ASoC: qcom: lpass-cpu: fix concurrency issue

Rohith Surabattula (1):
      SMB3: Resolve data corruption of TCP server info fields

Roman Bolshakov (1):
      scsi: target: core: Add CONTROL field for trace events

Rustam Kovhaev (1):
      ntfs: add check for mft record size in superblock

Samuel Holland (1):
      Bluetooth: hci_uart: Cancel init work before unregistering

Saurav Kashyap (1):
      scsi: qedf: Return SUCCESS if stale rport is encountered

Scott Cheloha (1):
      pseries/drmem: don't cache node id in drmem_lmb struct

Sean Christopherson (3):
      KVM: nVMX: Reset the segment cache when stuffing guest segs
      KVM: nVMX: Reload vmcs01 if getting vmcs12's pages fails
      KVM: x86/mmu: Commit zap of remaining invalid pages when recovering lpages

Serge Semin (2):
      dmaengine: dw: Add DMA-channels mask cell support
      dmaengine: dw: Activate FIFO-mode for memory peripherals only

Shengjiu Wang (1):
      ASoC: fsl_sai: Instantiate snd_soc_dai_driver

Sherry Sun (2):
      mic: vop: copy data to kernel space then write to io memory
      misc: vop: add round_up(x,4) for vring_size to avoid kernel panic

Shyam Prasad N (1):
      cifs: Return the error from crypt_message when enc/dec key not found.

Sindhu, Devale (1):
      i40iw: Add support to make destroy QP synchronous

Souptick Joarder (3):
      drivers/virt/fsl_hypervisor: Fix error handling path
      misc: mic: scif: Fix error handling path
      rapidio: fix error handling path

Srikar Dronamraju (1):
      cpufreq: powernv: Fix frame-size-overflow in powernv_cpufreq_reboot_notifier

Srinivas Kandagatla (3):
      slimbus: core: check get_addr before removing laddr ida
      slimbus: core: do not enter to clock pause mode in core
      slimbus: qcom-ngd-ctrl: disable ngd in qmi server down callback

Stefan Agner (2):
      drm: mxsfb: check framebuffer pitch
      clk: meson: g12a: mark fclk_div2 as critical

Stephan Gerhold (3):
      arm64: dts: qcom: msm8916: Remove one more thermal trip point unit name
      arm64: dts: qcom: pm8916: Remove invalid reg size from wcd_codec
      arm64: dts: qcom: msm8916: Fix MDP/DSI interrupts

Stephen Boyd (2):
      drm/msm: Avoid div-by-zero in dpu_crtc_atomic_check()
      clk: rockchip: Initialize hw to error to avoid undefined behavior

Steven Price (1):
      drm/panfrost: Ensure GPU quirks are always initialised

Suravee Suthikulpanit (1):
      KVM: SVM: Initialize prev_ga_tag before use

Suren Baghdasaryan (1):
      mm, oom_adj: don't loop through tasks in __set_oom_adj when not necessary

Suzuki K Poulose (1):
      coresight: etm4x: Handle unreachable sink in perf mode

Sylwester Nawrocki (1):
      media: Revert "media: exynos4-is: Add missed check for pinctrl_lookup_state()"

Takashi Iwai (1):
      ALSA: seq: oss: Avoid mutex lock for a long-time ioctl

Tero Kristo (2):
      crypto: omap-sham - fix digcnt register handling with export/import
      clk: keystone: sci-clk: fix parsing assigned-clock data during probe

Tetsuo Handa (2):
      block: ratelimit handle_bad_sector() message
      mwifiex: don't call del_timer_sync() on uninitialized timer

Thomas Gleixner (1):
      net: enic: Cure the enic api locking trainwreck

Thomas Pedersen (1):
      mac80211: handle lack of sband->bitrates in rates

Thomas Preston (2):
      pinctrl: mcp23s08: Fix mcp23x17_regmap initialiser
      pinctrl: mcp23s08: Fix mcp23x17 precious range

Tianjia Zhang (6):
      crypto: mediatek - Fix wrong return value in mtk_desc_ring_alloc()
      drm/amd/display: Fix wrong return value in dm_update_plane_state()
      scsi: qla2xxx: Fix wrong return value in qlt_chk_unresolv_exchg()
      scsi: qla2xxx: Fix wrong return value in qla_nvme_register_hba()
      scsi: csiostor: Fix wrong return value in csio_hw_prep_fw()
      ipmi_si: Fix wrong return value in try_smi_init()

Timothée COCAULT (1):
      netfilter: ebtables: Fixes dropping of small packets in bridge nat

Tingwei Zhang (1):
      coresight: etm: perf: Fix warning caused by etm_setup_aux failure

Tobias Jordan (1):
      lib/crc32.c: fix trivial typo in preprocessor condition

Todd Kjos (1):
      binder: fix UAF when releasing todo list

Tom Rix (8):
      media: tuner-simple: fix regression in simple_set_radio_freq
      media: m5mols: Check function pointer in m5mols_sensor_power
      media: tc358743: initialize variable
      media: tc358743: cleanup tc358743_cec_isr
      brcmfmac: check ndev pointer
      drm/gma500: fix error check
      video: fbdev: sis: fix null ptr dereference
      mwifiex: fix double free

Tom Zanussi (1):
      selftests/ftrace: Change synthetic event name for inter-event-combined test

Tomas Henzl (1):
      scsi: mpt3sas: Fix sync irqs

Tong Zhang (2):
      tty: serial: earlycon dependency
      tty: ipwireless: fix error handling

Tony Lindgren (1):
      ARM: OMAP2+: Restore MPU power domain if cpu_cluster_pm_enter() fails

Tyrel Datwyler (1):
      tty: hvcs: Don't NULL tty->driver_data until hvcs_cleanup()

Tzu-En Huang (1):
      rtw88: increse the size of rx buffer size

Vadim Pasternak (1):
      platform/x86: mlx-platform: Remove PSU EEPROM configuration

Vadym Kochan (1):
      nvmem: core: fix possibly memleak when use nvmem_cell_info_to_nvmem_cell()

Valentin Vidic (2):
      net: korina: fix kfree of rx/tx descriptor array
      net: korina: cast KSEG0 address to pointer in kfree

Vasant Hegde (1):
      powerpc/powernv/dump: Fix race while processing OPAL dump

Venkateswara Naralasetty (1):
      ath10k: provide survey info as accumulated data

Vikash Garodia (1):
      media: venus: fixes for list corruption

Vinay Kumar Yadav (3):
      chelsio/chtls: fix socket lock
      chelsio/chtls: correct netdevice for vlan interface
      chelsio/chtls: correct function return and return type

Vincent Mailhol (1):
      usb: cdc-acm: add quirk to blacklist ETAS ES58X devices

Viresh Kumar (1):
      opp: Prevent memory leak in dev_pm_opp_attach_genpd()

Wang Yufen (1):
      brcm80211: fix possible memleak in brcmf_proto_msgbuf_attach

Weihang Li (1):
      RDMA/hns: Fix missing sq_sig_type when querying QP

Wenpeng Liang (1):
      RDMA/hns: Fix the wrong value of rnr_retry when querying qp

Wilken Gottwalt (1):
      net: usb: qmi_wwan: add Cellient MPL200 card

Xiaoliang Pang (1):
      cypto: mediatek - fix leaks in mtk_desc_ring_alloc

Xiaolong Huang (1):
      media: media/pci: prevent memory leak in bttv_probe

Xiaoyang Xu (1):
      vfio iommu type1: Fix memory leak in vfio_iommu_type1_pin_pages

Xie He (2):
      net: hdlc: In hdlc_rcv, check to make sure dev is an HDLC device
      net: hdlc_raw_eth: Clear the IFF_TX_SKB_SHARING flag after calling ether_setup

Xunlei Pang (1):
      sched/fair: Fix wrong cpu selecting from isolated domain

Yang Yang (1):
      blk-mq: move cancel of hctx->run_work to the front of blk_exit_queue

Yonghong Song (2):
      net: fix pos incrementment in ipv6_route_seq_next
      selftests/bpf: Fix test_sysctl_loop{1, 2} failure due to clang change

Yu Chen (1):
      usb: dwc3: Add splitdisable quirk for Hisilicon Kirin Soc

Yu Kuai (1):
      ASoC: fsl: imx-es8328: add missing put_device() call in imx_es8328_probe()

YueHaibing (2):
      Input: stmfts - fix a & vs && typo
      memory: omap-gpmc: Fix build error without CONFIG_OF

Zekun Shen (1):
      ath10k: check idx validity in __ath10k_htt_rx_ring_fill_n()

Zhao Heming (1):
      md/bitmap: fix memory leak of temporary bitmap

Zhenzhong Duan (1):
      drm/msm/a6xx: fix a potential overflow issue

Zqiang (1):
      usb: gadget: function: printer: fix use-after-free in __lock_acquire

dinghao.liu@zju.edu.cn (1):
      backlight: sky81452-backlight: Fix refcount imbalance on error

zhenwei pi (1):
      nvmet: fix uninitialized work for zero kato

Łukasz Stelmach (2):
      spi: spi-s3c64xx: swap s3c64xx_spi_set_cs() and s3c64xx_enable_datapath()
      spi: spi-s3c64xx: Check return values

