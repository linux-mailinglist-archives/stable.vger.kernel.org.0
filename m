Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6711A410623
	for <lists+stable@lfdr.de>; Sat, 18 Sep 2021 14:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbhIRMJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Sep 2021 08:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhIRMJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Sep 2021 08:09:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10B2D60F51;
        Sat, 18 Sep 2021 12:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631966862;
        bh=L1ZJDHNlLVQW9aWIzD+zy8Qtq2kwxafe5U4PlgLrGBA=;
        h=From:To:Cc:Subject:Date:From;
        b=EfgX8TUU7BVTiQ+p3el/1+77C6bmaG4JMiJHnPyBa/ztWC1GdISLfVSGNccgbtcEY
         9yEjQ6hpj/uE9IIg2A8HmV/rJXvyKgDASQVlgI0IXsvnAITG6OKSAR+UKsRTh3TeKf
         uZV6qnsStDIdWRjwfLmiXmYybP+0mljiPNpHFGgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.67
Date:   Sat, 18 Sep 2021 14:07:30 +0200
Message-Id: <163196685010890@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.67 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/devices.txt                                     |    6 
 Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt |    8 
 Makefile                                                                  |    2 
 arch/arm/boot/compressed/Makefile                                         |    2 
 arch/arm/boot/dts/at91-kizbox3_common.dtsi                                |    2 
 arch/arm/boot/dts/at91-sam9x60ek.dts                                      |    2 
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts                               |    2 
 arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts                             |    2 
 arch/arm/boot/dts/at91-sama5d2_icp.dts                                    |    2 
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts                                 |    2 
 arch/arm/boot/dts/at91-sama5d2_xplained.dts                               |    2 
 arch/arm/boot/dts/imx53-ppd.dts                                           |   23 
 arch/arm/boot/dts/qcom-apq8064.dtsi                                       |    6 
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi                             |    8 
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi                        |    6 
 arch/arm/boot/dts/stm32mp15xx-dkx.dtsi                                    |    8 
 arch/arm/boot/dts/tegra20-acer-a500-picasso.dts                           |   25 
 arch/arm/boot/dts/tegra20-tamonten.dtsi                                   |   14 
 arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts                     |    4 
 arch/arm64/boot/dts/freescale/fsl-ls1046a-frwy.dts                        |    8 
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts                         |    7 
 arch/arm64/boot/dts/nvidia/tegra132.dtsi                                  |    4 
 arch/arm64/boot/dts/nvidia/tegra194.dtsi                                  |    6 
 arch/arm64/boot/dts/qcom/ipq6018.dtsi                                     |    2 
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts                                 |    2 
 arch/arm64/boot/dts/qcom/ipq8074.dtsi                                     |   16 
 arch/arm64/boot/dts/qcom/msm8994.dtsi                                     |    6 
 arch/arm64/boot/dts/qcom/msm8996.dtsi                                     |    4 
 arch/arm64/boot/dts/qcom/sdm630.dtsi                                      |  257 +++++----
 arch/arm64/boot/dts/qcom/sm8250.dtsi                                      |    2 
 arch/arm64/include/asm/kernel-pgtable.h                                   |    4 
 arch/arm64/include/asm/mmu.h                                              |   29 -
 arch/arm64/include/asm/tlbflush.h                                         |   11 
 arch/arm64/kernel/head.S                                                  |   11 
 arch/m68k/Kconfig.bus                                                     |    2 
 arch/mips/mti-malta/malta-dtshim.c                                        |    2 
 arch/openrisc/kernel/entry.S                                              |    2 
 arch/parisc/kernel/signal.c                                               |    6 
 arch/powerpc/configs/mpc885_ads_defconfig                                 |    1 
 arch/powerpc/include/asm/pmc.h                                            |    7 
 arch/powerpc/kernel/smp.c                                                 |   11 
 arch/powerpc/kernel/stacktrace.c                                          |    1 
 arch/powerpc/kvm/book3s_64_mmu_radix.c                                    |    6 
 arch/powerpc/kvm/book3s_64_vio_hv.c                                       |    9 
 arch/powerpc/kvm/book3s_hv.c                                              |   20 
 arch/powerpc/mm/numa.c                                                    |   13 
 arch/powerpc/perf/hv-gpci.c                                               |    2 
 arch/s390/include/asm/setup.h                                             |    2 
 arch/s390/kernel/early.c                                                  |    4 
 arch/s390/kernel/jump_label.c                                             |    2 
 arch/s390/mm/init.c                                                       |    2 
 arch/s390/pci/pci.c                                                       |    5 
 arch/x86/kernel/cpu/mshyperv.c                                            |    9 
 arch/x86/xen/p2m.c                                                        |    4 
 arch/xtensa/platforms/iss/console.c                                       |   17 
 block/bfq-iosched.c                                                       |    2 
 block/blk-zoned.c                                                         |    6 
 block/bsg.c                                                               |    5 
 drivers/ata/libata-core.c                                                 |    4 
 drivers/ata/sata_dwc_460ex.c                                              |   12 
 drivers/bus/fsl-mc/fsl-mc-bus.c                                           |   24 
 drivers/clk/at91/clk-generated.c                                          |    6 
 drivers/clk/imx/clk-composite-8m.c                                        |    3 
 drivers/clk/imx/clk-imx8mm.c                                              |    7 
 drivers/clk/imx/clk-imx8mn.c                                              |    7 
 drivers/clk/imx/clk-imx8mq.c                                              |    7 
 drivers/clk/imx/clk.h                                                     |   16 
 drivers/clk/rockchip/clk-pll.c                                            |    2 
 drivers/clk/socfpga/clk-agilex.c                                          |   19 
 drivers/cpufreq/powernv-cpufreq.c                                         |   16 
 drivers/cpuidle/cpuidle-pseries.c                                         |   18 
 drivers/crypto/ccp/sev-dev.c                                              |   49 -
 drivers/crypto/ccp/sp-pci.c                                               |   12 
 drivers/crypto/mxs-dcp.c                                                  |   36 -
 drivers/dma/imx-sdma.c                                                    |   13 
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c                                   |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                                |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c                            |    2 
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c                                     |    2 
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c                                     |    2 
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c                                     |    2 
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c                                     |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c                              |   84 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h                              |    1 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c                 |   16 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c                 |   11 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c                        |   14 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c                     |    2 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c                       |   90 ++-
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c                        |   12 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c                     |   42 +
 drivers/gpu/drm/bridge/nwl-dsi.c                                          |    2 
 drivers/gpu/drm/drm_auth.c                                                |   42 +
 drivers/gpu/drm/drm_debugfs.c                                             |    3 
 drivers/gpu/drm/drm_dp_mst_topology.c                                     |   10 
 drivers/gpu/drm/drm_file.c                                                |    1 
 drivers/gpu/drm/drm_lease.c                                               |   81 ++-
 drivers/gpu/drm/exynos/exynos_drm_dma.c                                   |    2 
 drivers/gpu/drm/mgag200/mgag200_drv.h                                     |   16 
 drivers/gpu/drm/mgag200/mgag200_mode.c                                    |   20 
 drivers/gpu/drm/mgag200/mgag200_reg.h                                     |    9 
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c                                  |   17 
 drivers/gpu/drm/msm/dp/dp_panel.c                                         |    9 
 drivers/gpu/drm/msm/dsi/dsi_cfg.c                                         |    1 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c                                |    2 
 drivers/gpu/drm/panfrost/panfrost_device.h                                |    8 
 drivers/gpu/drm/panfrost/panfrost_drv.c                                   |   50 -
 drivers/gpu/drm/panfrost/panfrost_gem.c                                   |   20 
 drivers/gpu/drm/panfrost/panfrost_job.c                                   |    4 
 drivers/gpu/drm/panfrost/panfrost_mmu.c                                   |  191 ++++---
 drivers/gpu/drm/panfrost/panfrost_mmu.h                                   |    5 
 drivers/gpu/drm/panfrost/panfrost_regs.h                                  |    2 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                            |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c                                   |    4 
 drivers/gpu/drm/xlnx/zynqmp_disp.c                                        |    3 
 drivers/gpu/drm/xlnx/zynqmp_dp.c                                          |   22 
 drivers/hid/hid-input.c                                                   |    2 
 drivers/hid/i2c-hid/i2c-hid-core.c                                        |    5 
 drivers/hwmon/pmbus/ibm-cffps.c                                           |    6 
 drivers/iio/dac/ad5624r_spi.c                                             |   18 
 drivers/iio/temperature/ltc2983.c                                         |   30 -
 drivers/infiniband/core/iwcm.c                                            |   19 
 drivers/infiniband/hw/efa/efa_verbs.c                                     |    1 
 drivers/infiniband/hw/hfi1/init.c                                         |    7 
 drivers/infiniband/hw/hns/hns_roce_qp.c                                   |    3 
 drivers/infiniband/hw/mlx5/qp.c                                           |    3 
 drivers/iommu/intel/pasid.h                                               |   10 
 drivers/mailbox/mtk-cmdq-mailbox.c                                        |    3 
 drivers/md/dm-crypt.c                                                     |    7 
 drivers/media/cec/platform/stm32/stm32-cec.c                              |   26 
 drivers/media/cec/platform/tegra/tegra_cec.c                              |   10 
 drivers/media/dvb-frontends/dib8000.c                                     |   58 +-
 drivers/media/i2c/imx258.c                                                |    4 
 drivers/media/i2c/tda1997x.c                                              |    5 
 drivers/media/rc/rc-loopback.c                                            |    2 
 drivers/media/usb/uvc/uvc_v4l2.c                                          |   34 -
 drivers/media/v4l2-core/v4l2-dv-timings.c                                 |    4 
 drivers/misc/vmw_vmci/vmci_queue_pair.c                                   |    6 
 drivers/mmc/core/block.c                                                  |    3 
 drivers/mmc/host/rtsx_pci_sdmmc.c                                         |   36 -
 drivers/mmc/host/sdhci-of-arasan.c                                        |   36 +
 drivers/net/bonding/bond_main.c                                           |    3 
 drivers/net/dsa/lantiq_gswip.c                                            |    3 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c                    |    9 
 drivers/net/ethernet/intel/iavf/iavf_main.c                               |   58 +-
 drivers/net/ethernet/intel/igc/igc_main.c                                 |    9 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c                  |   15 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                             |    8 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c                |    2 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c                |    1 
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c                       |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c                       |   18 
 drivers/net/ethernet/wiznet/w5100.c                                       |    2 
 drivers/net/phy/dp83822.c                                                 |    8 
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                            |    3 
 drivers/net/wireless/ath/ath9k/hw.c                                       |   12 
 drivers/net/wireless/ath/wcn36xx/main.c                                   |    5 
 drivers/net/wireless/ath/wcn36xx/txrx.c                                   |    4 
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h                                |    1 
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c                               |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c                         |    4 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                         |    8 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                              |   24 
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c                             |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                              |   30 -
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c                              |    5 
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c                           |    3 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h                          |    2 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c                     |   33 -
 drivers/net/wireless/realtek/rtw88/Makefile                               |    2 
 drivers/net/wireless/realtek/rtw88/fw.c                                   |    8 
 drivers/net/wireless/realtek/rtw88/fw.h                                   |    1 
 drivers/net/wireless/realtek/rtw88/wow.c                                  |   21 
 drivers/nvdimm/pmem.c                                                     |    4 
 drivers/nvme/host/core.c                                                  |    3 
 drivers/nvme/host/nvme.h                                                  |   47 +
 drivers/nvme/host/pci.c                                                   |    2 
 drivers/nvme/host/rdma.c                                                  |    4 
 drivers/nvme/host/tcp.c                                                   |   38 -
 drivers/nvme/target/loop.c                                                |    4 
 drivers/nvmem/qfprom.c                                                    |    6 
 drivers/of/kobj.c                                                         |    2 
 drivers/opp/of.c                                                          |   12 
 drivers/parport/ieee1284_ops.c                                            |    2 
 drivers/pci/controller/pci-aardvark.c                                     |  266 +++++++++-
 drivers/pci/controller/pcie-xilinx-nwl.c                                  |   12 
 drivers/pci/msi.c                                                         |    3 
 drivers/pci/pci.c                                                         |    7 
 drivers/pci/pcie/portdrv_core.c                                           |    9 
 drivers/pci/quirks.c                                                      |    1 
 drivers/pci/syscall.c                                                     |    4 
 drivers/pinctrl/actions/pinctrl-owl.c                                     |    1 
 drivers/pinctrl/core.c                                                    |    1 
 drivers/pinctrl/freescale/pinctrl-imx1-core.c                             |    1 
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c                               |   17 
 drivers/pinctrl/pinctrl-at91.c                                            |    1 
 drivers/pinctrl/pinctrl-ingenic.c                                         |    6 
 drivers/pinctrl/pinctrl-single.c                                          |    1 
 drivers/pinctrl/pinctrl-st.c                                              |    1 
 drivers/pinctrl/pinctrl-stmfx.c                                           |    6 
 drivers/pinctrl/pinctrl-sx150x.c                                          |    1 
 drivers/pinctrl/qcom/pinctrl-sdm845.c                                     |    1 
 drivers/pinctrl/qcom/pinctrl-ssbi-mpp.c                                   |    1 
 drivers/pinctrl/renesas/pfc-r8a77950.c                                    |    1 
 drivers/pinctrl/renesas/pfc-r8a77951.c                                    |    1 
 drivers/pinctrl/renesas/pfc-r8a7796.c                                     |    1 
 drivers/pinctrl/renesas/pfc-r8a77965.c                                    |    1 
 drivers/pinctrl/samsung/pinctrl-samsung.c                                 |    2 
 drivers/platform/chrome/cros_ec_proto.c                                   |    9 
 drivers/platform/x86/dell-smbios-wmi.c                                    |    1 
 drivers/power/supply/max17042_battery.c                                   |    6 
 drivers/rtc/rtc-tps65910.c                                                |    2 
 drivers/s390/cio/qdio_main.c                                              |   82 +--
 drivers/scsi/BusLogic.c                                                   |    6 
 drivers/scsi/pcmcia/fdomain_cs.c                                          |    4 
 drivers/scsi/qedf/qedf_main.c                                             |   10 
 drivers/scsi/qedi/qedi_main.c                                             |   14 
 drivers/scsi/qla2xxx/qla_nvme.c                                           |    5 
 drivers/scsi/qla2xxx/qla_os.c                                             |    6 
 drivers/scsi/smartpqi/smartpqi_init.c                                     |    1 
 drivers/scsi/ufs/ufs-exynos.c                                             |    4 
 drivers/scsi/ufs/ufs-exynos.h                                             |    2 
 drivers/scsi/ufs/ufshcd.c                                                 |    8 
 drivers/soc/aspeed/aspeed-lpc-ctrl.c                                      |    2 
 drivers/soc/aspeed/aspeed-p2a-ctrl.c                                      |    2 
 drivers/soc/qcom/qcom_aoss.c                                              |    8 
 drivers/soundwire/intel.c                                                 |   23 
 drivers/staging/board/board.c                                             |    7 
 drivers/staging/ks7010/ks7010_sdio.c                                      |    2 
 drivers/staging/media/atomisp/pci/atomisp_v4l2.c                          |    4 
 drivers/staging/media/hantro/hantro_g1_vp8_dec.c                          |   13 
 drivers/staging/media/hantro/rk3399_vpu_hw_vp8_dec.c                      |   13 
 drivers/staging/rts5208/rtsx_scsi.c                                       |   10 
 drivers/thunderbolt/switch.c                                              |    2 
 drivers/tty/hvc/hvsi.c                                                    |   19 
 drivers/tty/serial/8250/8250_omap.c                                       |   25 
 drivers/tty/serial/8250/8250_pci.c                                        |    2 
 drivers/tty/serial/8250/8250_port.c                                       |    3 
 drivers/tty/serial/jsm/jsm_neo.c                                          |    2 
 drivers/tty/serial/jsm/jsm_tty.c                                          |    3 
 drivers/tty/serial/sh-sci.c                                               |    7 
 drivers/usb/chipidea/host.c                                               |   14 
 drivers/usb/gadget/composite.c                                            |    8 
 drivers/usb/gadget/function/u_ether.c                                     |    5 
 drivers/usb/host/ehci-mv.c                                                |   23 
 drivers/usb/host/fotg210-hcd.c                                            |   41 -
 drivers/usb/host/fotg210.h                                                |    5 
 drivers/usb/host/xhci.c                                                   |   24 
 drivers/usb/musb/musb_dsps.c                                              |   13 
 drivers/usb/usbip/vhci_hcd.c                                              |   32 +
 drivers/vfio/Kconfig                                                      |    2 
 drivers/video/fbdev/asiliantfb.c                                          |    3 
 drivers/video/fbdev/kyro/fbdev.c                                          |    8 
 drivers/video/fbdev/riva/fbdev.c                                          |    3 
 fs/btrfs/inode.c                                                          |   10 
 fs/btrfs/tree-log.c                                                       |    4 
 fs/btrfs/volumes.c                                                        |    3 
 fs/ceph/caps.c                                                            |    3 
 fs/cifs/sess.c                                                            |    2 
 fs/f2fs/compress.c                                                        |   12 
 fs/f2fs/data.c                                                            |   16 
 fs/f2fs/dir.c                                                             |   14 
 fs/f2fs/file.c                                                            |    4 
 fs/f2fs/gc.c                                                              |    4 
 fs/f2fs/super.c                                                           |  106 ++-
 fs/fscache/cookie.c                                                       |   14 
 fs/fscache/internal.h                                                     |    2 
 fs/fscache/main.c                                                         |   39 +
 fs/gfs2/glops.c                                                           |   17 
 fs/gfs2/lock_dlm.c                                                        |    5 
 fs/io-wq.c                                                                |    8 
 fs/io_uring.c                                                             |   70 +-
 fs/iomap/buffered-io.c                                                    |    2 
 fs/lockd/svclock.c                                                        |   30 -
 fs/nfs/pnfs.c                                                             |   16 
 fs/nfsd/nfs4state.c                                                       |    5 
 fs/notify/fanotify/fanotify.c                                             |    6 
 fs/overlayfs/dir.c                                                        |    6 
 fs/userfaultfd.c                                                          |   91 +--
 include/crypto/public_key.h                                               |    4 
 include/drm/drm_auth.h                                                    |    1 
 include/drm/drm_file.h                                                    |   18 
 include/linux/ethtool.h                                                   |    4 
 include/linux/hugetlb.h                                                   |    9 
 include/linux/hugetlb_cgroup.h                                            |   12 
 include/linux/intel-iommu.h                                               |    6 
 include/linux/rcupdate.h                                                  |    2 
 include/linux/sunrpc/xprt.h                                               |    1 
 include/linux/sunrpc/xprtsock.h                                           |    1 
 include/net/flow_offload.h                                                |    1 
 include/uapi/linux/serial_reg.h                                           |    1 
 kernel/dma/debug.c                                                        |    7 
 kernel/fork.c                                                             |    1 
 kernel/pid_namespace.c                                                    |    3 
 kernel/rcu/tree_plugin.h                                                  |    8 
 kernel/workqueue.c                                                        |   12 
 lib/test_bpf.c                                                            |   13 
 lib/test_stackinit.c                                                      |   20 
 mm/hmm.c                                                                  |    5 
 mm/hugetlb.c                                                              |    4 
 mm/vmscan.c                                                               |    2 
 net/9p/trans_xen.c                                                        |    4 
 net/bluetooth/hci_event.c                                                 |  108 ++--
 net/bluetooth/sco.c                                                       |   74 +-
 net/core/flow_dissector.c                                                 |   12 
 net/core/flow_offload.c                                                   |   89 +++
 net/ethtool/ioctl.c                                                       |  136 ++++-
 net/ipv4/ip_output.c                                                      |    5 
 net/ipv4/tcp_fastopen.c                                                   |    3 
 net/mac80211/iface.c                                                      |   11 
 net/netfilter/nf_flow_table_offload.c                                     |    1 
 net/netfilter/nf_tables_offload.c                                         |    1 
 net/netlabel/netlabel_cipso_v4.c                                          |    4 
 net/netlink/af_netlink.c                                                  |    4 
 net/sched/cls_api.c                                                       |    1 
 net/sched/sch_taprio.c                                                    |    4 
 net/socket.c                                                              |  125 ----
 net/sunrpc/auth_gss/svcauth_gss.c                                         |    2 
 net/sunrpc/xprt.c                                                         |    8 
 net/sunrpc/xprtrdma/transport.c                                           |   11 
 net/sunrpc/xprtsock.c                                                     |    7 
 net/tipc/socket.c                                                         |   36 +
 samples/bpf/test_override_return.sh                                       |    1 
 samples/bpf/tracex7_user.c                                                |    5 
 scripts/gen_ksymdeps.sh                                                   |    8 
 security/smack/smack_access.c                                             |   17 
 sound/soc/atmel/Kconfig                                                   |    1 
 sound/soc/intel/boards/bytcr_rt5640.c                                     |    9 
 sound/soc/intel/boards/sof_pcm512x.c                                      |   13 
 sound/soc/intel/skylake/skl-messages.c                                    |   11 
 sound/soc/intel/skylake/skl-pcm.c                                         |   25 
 sound/soc/rockchip/rockchip_i2s.c                                         |   35 -
 tools/lib/bpf/libbpf.c                                                    |   63 ++
 tools/testing/selftests/arm64/mte/mte_common_util.c                       |    2 
 tools/testing/selftests/arm64/pauth/pac.c                                 |   10 
 tools/testing/selftests/bpf/prog_tests/send_signal.c                      |   16 
 tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c                  |    4 
 tools/testing/selftests/bpf/progs/xdp_tx.c                                |    2 
 tools/testing/selftests/bpf/test_maps.c                                   |    2 
 tools/testing/selftests/bpf/test_xdp_veth.sh                              |    2 
 tools/testing/selftests/firmware/fw_namespace.c                           |    3 
 tools/testing/selftests/ftrace/test.d/functions                           |    2 
 tools/thermal/tmon/Makefile                                               |    2 
 343 files changed, 3169 insertions(+), 1638 deletions(-)

Ahmad Fatoum (1):
      clk: imx8m: fix clock tree update of TF-A managed clocks

Alexey Kardashevskiy (1):
      KVM: PPC: Fix clearing never mapped TCEs in realmode

Alim Akhtar (1):
      scsi: ufs: ufs-exynos: Fix static checker warning

Alyssa Rosenzweig (3):
      drm/panfrost: Simplify lock_region calculation
      drm/panfrost: Use u64 for size in lock_region
      drm/panfrost: Clamp lock region to Bifrost minimum

Amir Goldstein (1):
      fanotify: limit number of event merge attempts

Andreas Obergschwandtner (1):
      ARM: tegra: tamonten: Fix UART pad setting

Andrey Grodzovsky (1):
      drm/amdgpu: Fix BUG_ON assert

Andy Shevchenko (1):
      ata: sata_dwc_460ex: No need to call phy_exit() befre phy_init()

AngeloGioacchino Del Regno (2):
      arm64: dts: qcom: sdm630: Rewrite memory map
      arm64: dts: qcom: sdm630: Fix TLMM node and pinctrl configuration

Ani Sinha (1):
      x86/hyperv: fix for unwanted manipulation of sched_clock when TSC marked unstable

Anirudh Rayabharam (1):
      usbip: give back URBs for unsent unlink requests during cleanup

Anna Schumaker (1):
      sunrpc: Fix return value of get_srcport()

Anson Jacob (1):
      drm/amd/amdgpu: Update debugfs link_settings output link_rate field in hex

Anthony Iliopoulos (1):
      dma-debug: fix debugfs initialization order

Arnd Bergmann (2):
      ethtool: improve compat ioctl handling
      m68knommu: only set CONFIG_ISA_DMA_API for ColdFire sub-arch

Arne Welzel (1):
      dm crypt: Avoid percpu_counter spinlock contention in crypt_page_alloc()

Aurabindo Pillai (1):
      drm/amd/display: Update number of DCN3 clock states

Bart Van Assche (1):
      scsi: ufs: Fix memory corruption by ufshcd_read_desc_param()

Bob Peterson (2):
      gfs2: Fix glock recursion in freeze_go_xmote_bh
      gfs2: Don't call dlm after protocol is unmounted

Boris Brezillon (1):
      drm/panfrost: Make sure MMU context lifetime is not bound to panfrost_priv

Brandon Wyman (1):
      hwmon: (pmbus/ibm-cffps) Fix write bits for LED control

Brijesh Singh (1):
      crypto: ccp - shutdown SEV firmware on kexec

Cezary Rojewski (1):
      ASoC: Intel: Skylake: Fix module configuration for KPB and MIXER

Chao Yu (5):
      f2fs: fix to do sanity check for sb/cp fields correctly
      f2fs: quota: fix potential deadlock
      f2fs: fix to account missing .skipped_gc_rwsem
      f2fs: fix unexpected ENOENT comes from f2fs_map_blocks()
      f2fs: fix to unmap pages from userspace process in punch_hole()

Chengfeng Ye (1):
      selftests/bpf: Fix potential unreleased lock

Chin-Yen Lee (2):
      rtw88: use read_poll_timeout instead of fixed sleep
      rtw88: wow: fix size access error of probe request

Chris Chiu (1):
      rtl8xxxu: Fix the handling of TX A-MPDU aggregation

Christoph Hellwig (1):
      scsi: bsg: Remove support for SCSI_IOCTL_SEND_COMMAND

Christophe JAILLET (1):
      staging: ks7010: Fix the initialization of the 'sleep_status' structure

Codrin Ciubotariu (1):
      clk: at91: clk-generated: Limit the requested rate to our range

Colin Ian King (3):
      ceph: fix dereference of null pointer cf
      scsi: BusLogic: Use %X for u32 sized integer rather than %lX
      parport: remove non-zero check on count

Damien Le Moal (1):
      block: bfq: fix bfq_set_next_ioprio_data()

Dan Carpenter (3):
      scsi: smartpqi: Fix an error code in pqi_get_raid_map()
      scsi: qedi: Fix error codes in qedi_alloc_global_queues()
      scsi: qedf: Fix error codes in qedf_alloc_global_queues()

Darrick J. Wong (1):
      iomap: pass writeback errors to the mapping

David Heidelberg (4):
      ARM: 9105/1: atags_to_fdt: don't warn about stack size
      ARM: dts: qcom: apq8064: correct clock names
      drm/msm: mdp4: drop vblank get/put from prepare/complete_commit
      drm/msi/mdp4: populate priv->kms in mdp4_kms_init

David Howells (1):
      fscache: Fix cookie key hashing

David Laight (1):
      fs/io_uring Don't use the return value from import_iovec().

Desmond Cheong Zhi Xi (8):
      btrfs: reset replace target device to allocation state on close
      drm: avoid blocking in drm_clients_info's rcu section
      drm: serialize drm_file.master with a new spinlock
      drm: protect drm_master pointers in drm_lease.c
      Bluetooth: skip invalid hci_sync_conn_complete_evt
      drm/vmwgfx: fix potential UAF in vmwgfx_surface.c
      Bluetooth: schedule SCO timeouts with delayed_work
      Bluetooth: avoid circular locks in sco_sock_connect

Ding Hui (1):
      cifs: fix wrong release in sess_alloc_buffer() failed path

Dinghao Liu (1):
      media: atomisp: Fix runtime PM imbalance in atomisp_pci_probe

Dinh Nguyen (3):
      clk: socfpga: agilex: fix the parents of the psi_ref_clk
      clk: socfpga: agilex: fix up s2f_user0_clk representation
      clk: socfpga: agilex: add the bypass register for s2f_usr0 clock

Dmitry Osipenko (2):
      rtc: tps65910: Correct driver module alias
      ARM: tegra: acer-a500: Remove bogus USB VBUS regulators

Dmitry Torokhov (1):
      HID: input: do not report stylus battery state as "full"

Dom Cobley (1):
      drm/vc4: hdmi: Set HD_CTL_WHOLSMP and HD_CTL_CHALIGN_SET

Eli Cohen (1):
      net: Fix offloading indirect devices dependency on qdisc order creation

Eran Ben Elisha (1):
      net/mlx5: Fix variable type to match 64bit

Evan Wang (1):
      PCI: aardvark: Fix checking for PIO status

Evgeny Novikov (3):
      USB: EHCI: ehci-mv: improve error handling in mv_ehci_enable()
      media: platform: stm32: unprepare clocks at handling errors in probe
      media: tegra-cec: Handle errors of clk_prepare_enable()

Ezequiel Garcia (1):
      media: hantro: vp8: Move noisy WARN_ON to vpu_debug

Fabiano Rosas (1):
      KVM: PPC: Book3S HV: Fix copy_tofrom_guest routines

Gautham R. Shenoy (1):
      cpuidle: pseries: Fixup CEDE0 latency only for POWER10 onwards

Geert Uytterhoeven (2):
      staging: board: Fix uninitialized spinlock when attaching genpd
      drm/bridge: nwl-dsi: Avoid potential multiplication overflow on 32-bit

Georgi Djakov (1):
      arm64: dts: qcom: sm8250: Fix epss_l3 unit address

Greg Kroah-Hartman (2):
      serial: 8250_pci: make setup_port() parameters explicitly unsigned
      Linux 5.10.67

Guojia Liao (1):
      net: hns3: clean up a type mismatch warning

Gustavo A. R. Silva (2):
      ipv4: ip_output.c: Fix out-of-bounds warning in ip_copy_addrs()
      flow_dissector: Fix out-of-bounds warnings

Gustaw Lewandowski (1):
      ASoC: Intel: Skylake: Fix passing loadable flag for module

Haimin Zhang (1):
      fix array-index-out-of-bounds in taprio_change

Halil Pasic (1):
      s390/pv: fix the forcing of the swiotlb

Hans Verkuil (1):
      media: v4l2-dv-timings.c: fix wrong condition in two for-loops

Hans de Goede (3):
      libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and 870 SSDs
      platform/x86: dell-smbios-wmi: Add missing kfree in error-exit from run_smbios_call
      ASoC: Intel: bytcr_rt5640: Move "Platform Clock" routes to the maps for the matching in-/output

Harshvardhan Jha (1):
      9p/xen: Fix end of loop tests for list_for_each_entry

Heiko Carstens (1):
      s390/jump_label: print real address in a case of a jump label bug

Hyun Kwon (1):
      PCI: xilinx-nwl: Enable the clock through CCF

Ilan Peer (1):
      iwlwifi: mvm: Fix scan channel flags settings

Iwona Winiarska (2):
      soc: aspeed: lpc-ctrl: Fix boundary check for mmap
      soc: aspeed: p2a-ctrl: Fix boundary check for mmap

J. Bruce Fields (3):
      rpc: fix gss_svc_init cleanup on failure
      lockd: lockd server-side shouldn't set fl_ops
      nfsd: fix crash on LOCKT on reexported NFSv3

Jack Pham (1):
      usb: gadget: composite: Allow bMaxPower=0 if self-powered

Jaegeuk Kim (2):
      f2fs: deallocate compressed pages when error happens
      f2fs: should put a page beyond EOF when preparing a write

Jaehyoung Choi (1):
      pinctrl: samsung: Fix pinctrl bank pin count

Jan Hoffmann (1):
      net: dsa: lantiq_gswip: fix maximum frame length

Jason Gunthorpe (1):
      vfio: Use config not menuconfig for VFIO_NOIOMMU

Jens Axboe (1):
      io-wq: fix wakeup race when adding new work

Jernej Skrabec (1):
      arm64: dts: allwinner: h6: tanix-tx6: Fix regulator node names

Jerry (Fangzhi) Zuo (1):
      drm/amd/display: Update bounding box states (v2)

Jianjun Wang (1):
      PCI: Export pci_pio_to_address() for module use

Jim Broadus (1):
      HID: i2c-hid: Fix Elan touchpad regression

Jiri Slaby (2):
      xtensa: ISS: don't panic in rs_init
      hvsi: don't panic on tty_register_driver failure

Joel Stanley (1):
      powerpc/config: Renable MTD_PHYSMAP_OF

Johan Almbladh (3):
      bpf/tests: Fix copy-and-paste error in double word test
      bpf/tests: Do not PASS tests without actually testing the result
      mac80211: Fix monitor MTU limit so that A-MSDUs get through

Johannes Berg (4):
      iwlwifi: pcie: free RBs during configure
      iwlwifi: mvm: avoid static queue number aliasing
      iwlwifi: mvm: fix access to BSS elements
      iwlwifi: fw: correctly limit to monitor dump

Jonathan Cameron (1):
      iio: dac: ad5624r: Fix incorrect handling of an optional regulator.

Josef Bacik (1):
      btrfs: wake up async_delalloc_pages waiters after submit

Joseph Gates (1):
      wcn36xx: Ensure finish scan is not requested before start scan

Juergen Gross (1):
      xen: fix setting of max_pfn in shared_info

Juhee Kang (1):
      samples: bpf: Fix tracex7 error raised on the missing argument

Julian Wiedmann (2):
      s390/qdio: fix roll-back after timeout on ESTABLISH ccw
      s390/qdio: cancel the ESTABLISH ccw after timeout

Jussi Maki (1):
      selftests/bpf: Fix xdp_tx.c prog section name

Kajol Jain (1):
      powerpc/perf/hv-gpci: Fix counter value parsing

Kees Cook (2):
      staging: rts5208: Fix get_ms_information() heap buffer size
      lib/test_stackinit: Fix static initializer test

Kelly Devilliv (2):
      usb: host: fotg210: fix the endpoint's transactional opportunities calculation
      usb: host: fotg210: fix the actual_length of an iso packet

Konrad Dybcio (1):
      drm/msm/dsi: Fix DSI and DSI PHY regulator config from SDM660

Krzysztof Hałasa (1):
      media: TDA1997x: fix tda1997x_query_dv_timings() return value

Krzysztof Kozlowski (1):
      power: supply: max17042: handle fails of reading status register

Krzysztof Wilczyński (1):
      PCI: Return ~0 data on pciconfig_read() CAP_SYS_ADMIN failure

Kuogee Hsieh (1):
      drm/msm/dp: return correct edid checksum after corrupted edid checksum read

Laurent Dufour (1):
      powerpc/numa: Consider the max NUMA node for migratable LPAR

Laurent Pinchart (1):
      media: imx258: Rectify mismatch of VTS value

Laurentiu Tudor (1):
      bus: fsl-mc: fix mmio base address for child DPRCs

Leon Romanovsky (4):
      RDMA/iwcm: Release resources if iw_cm module initialization fails
      docs: Fix infiniband uverbs minor number
      RDMA/efa: Remove double QP type assignment
      RDMA/mlx5: Delete not-available udata check

Li Jun (1):
      usb: chipidea: host: fix port index underflow and UBSAN complains

Li Zhijian (2):
      selftests/bpf: Enlarge select() timeout for test_maps
      mm/hmm: bypass devmap pte when all pfn requested flags are fulfilled

Liu Zixian (1):
      mm/hugetlb: initialize hugetlb_usage in mm_init

Loic Poulain (1):
      wcn36xx: Fix missing frame timestamp for beacon/probe-resp

Lu Baolu (1):
      iommu/vt-d: Update the virtual command related registers

Luben Tuikov (1):
      drm/amdgpu: Fix amdgpu_ras_eeprom_init()

Luiz Augusto von Dentz (1):
      Bluetooth: Fix handling of LE Enhanced Connection Complete

Luke Hsiao (1):
      tcp: enable data-less, empty-cookie SYN with TFO_SERVER_COOKIE_NOT_REQD

Maciej W. Rozycki (2):
      serial: 8250: Define RX trigger levels for OxSemi 950 devices
      scsi: BusLogic: Fix missing pr_cont() use

Maciej Żenczykowski (1):
      usb: gadget: u_ether: fix a potential null pointer dereference

Manish Narani (2):
      mmc: sdhci-of-arasan: Modified SD default speed to 19MHz for ZynqMP
      mmc: sdhci-of-arasan: Check return value of non-void funtions

Manivannan Sadhasivam (1):
      soc: qcom: aoss: Fix the out of bound usage of cooling_devs

Marc Zyngier (2):
      pinctrl: stmfx: Fix hazardous u8[] to unsigned long cast
      of: Don't allow __of_attached_node_sysfs() without CONFIG_SYSFS

Marcos Paulo de Souza (1):
      btrfs: tree-log: check btrfs_lookup_data_extent return value

Marek Behún (2):
      PCI: Restrict ASMedia ASM1062 SATA Max Payload Size Supported
      pinctrl: armada-37xx: Correct PWM pins definitions

Marek Marczykowski-Górecki (1):
      PCI/MSI: Skip masking MSI-X on Xen PV

Marek Vasut (4):
      net: phy: Fix data type in DP83822 dp8382x_disable_wol()
      ARM: dts: stm32: Set {bitclock,frame}-master phandles on DHCOM SoM
      ARM: dts: stm32: Set {bitclock,frame}-master phandles on ST DKx
      ARM: dts: stm32: Update AV96 adv7513 node per dtbs_check

Mark Brown (2):
      kselftest/arm64: mte: Fix misleading output when skipping tests
      kselftest/arm64: pac: Fix skipping of tests on systems without PAC

Mark Rutland (1):
      arm64: head: avoid over-mapping in map_memory

Martynas Pumputis (2):
      libbpf: Fix reuse of pinned map on older kernel
      libbpf: Fix race when pinning maps in parallel

Masahiro Yamada (1):
      kbuild: Fix 'no symbols' warning when CONFIG_TRIM_UNUSD_KSYMS=y

Mathias Nyman (1):
      Revert "USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set"

Mauro Carvalho Chehab (2):
      media: uvc: don't do DMA on stack
      media: dib8000: rewrite the init prbs logic

Miaoqing Pan (1):
      ath9k: fix sleeping in atomic context

Michal Suchanek (1):
      powerpc/stacktrace: Include linux/delay.h

Mike Kravetz (1):
      hugetlb: fix hugetlb cgroup refcounting during vma split

Mike Marciniszyn (1):
      IB/hfi1: Adjust pkey entry in index 0

Mikulas Patocka (1):
      parisc: fix crash with signals and alloca

Nadav Amit (1):
      userfaultfd: prevent concurrent API initialization

Nadezda Lutovinova (1):
      usb: musb: musb_dsps: request_irq() after initializing musb

Nathan Chancellor (3):
      cpuidle: pseries: Mark pseries_idle_proble() as __init
      net: ethernet: stmmac: Do not use unreachable() in ipq806x_gmac_probe()
      drm/exynos: Always initialize mapping in exynos_drm_register_dma()

Nicholas Piggin (1):
      KVM: PPC: Book3S HV Nested: Reflect guest PMU in-use to L0 when guest SPRs are live

Nicolas Ferre (1):
      ARM: dts: at91: use the right property for shutdown controller

Niklas Cassel (2):
      blk-zoned: allow zone management send operations without CAP_SYS_ADMIN
      blk-zoned: allow BLKREPORTZONE without CAP_SYS_ADMIN

Niklas Schnelle (1):
      s390: make PCI mio support a machine flag

Niklas Söderlund (1):
      nfp: fix return statement in nfp_net_parse_meta()

Nishad Kamdar (1):
      mmc: core: Return correct emmc response in case of ioctl error

Nuno Sá (1):
      iio: ltc2983: fix device probe

Oak Zeng (1):
      drm/amdgpu: Fix a printing message

Oleksij Rempel (1):
      MIPS: Malta: fix alignment of the devicetree buffer

Olga Kornievskaia (1):
      SUNRPC query transport's source port

Oliver Logush (1):
      drm/amd/display: Fix timer_per_pixel unit error

Pali Rohár (2):
      PCI: aardvark: Configure PCIe resources from 'ranges' DT property
      PCI: aardvark: Fix masking and unmasking legacy INTx interrupts

Patryk Duda (1):
      platform/chrome: cros_ec_proto: Send command again when timeout occurs

Paul Cercueil (1):
      pinctrl: ingenic: Fix incorrect pull up/down info

Pavel Begunkov (5):
      io_uring: limit fixed table size by RLIMIT_NOFILE
      io_uring: place fixed tables under memcg limits
      io_uring: add ->splice_fd_in checks
      io_uring: fail links of cancelled timeouts
      io_uring: remove duplicated io_size from rw

Peter Geis (1):
      clk: rockchip: drop GRF dependency for rk3328/rk3036 pll types

Pierre-Louis Bossart (2):
      ASoC: Intel: update sof_pcm512x quirks
      soundwire: intel: fix potential race condition during power down

Ping-Ke Shih (1):
      rtw88: wow: build wow function only if CONFIG_PM is on

Pratik R. Sampat (1):
      cpufreq: powernv: Fix init_chip_info initialization in numa=off

Quanyang Wang (2):
      drm: xlnx: zynqmp_dpsub: Call pm_runtime_get_sync before setting pixel clock
      drm: xlnx: zynqmp: release reset to DP controller before accessing DP registers

Raag Jadav (1):
      arm64: dts: ls1046a: fix eeprom entries

Rafael J. Wysocki (1):
      PCI: Use pci_update_current_state() in pci_enable_device_flags()

Rajendra Nayak (2):
      nvmem: qfprom: Fix up qfprom_disable_fuse_blowing() ordering
      opp: Don't print an error if required-opps is missing

Rajkumar Subbiah (1):
      drm/dp_mst: Fix return code on sideband message failure

Randy Dunlap (2):
      openrisc: don't printk() unconditionally
      ASoC: atmel: ATMEL drivers don't need HAS_DMA

Rik van Riel (1):
      mm,vmscan: fix divide by zero in get_scan_count

Robin Gong (2):
      Revert "dmaengine: imx-sdma: refine to load context only once"
      dmaengine: imx-sdma: remove duplicated sdma_load_context

Rolf Eike Beer (1):
      tools/thermal/tmon: Add cross compiling support

Roy Chan (2):
      drm/amd/display: fix missing writeback disablement if plane is removed
      drm/amd/display: fix incorrect CM/TF programming sequence in dwb

Sagi Grimberg (2):
      nvme-tcp: don't check blk_mq_tag_to_rq when receiving pdu data
      nvme: code command_id with a genctr for use-after-free validation

Sanjay R Mehta (1):
      thunderbolt: Fix port linking by checking all adapters

Sasha Neftin (1):
      igc: Check if num of q_vectors is smaller than max before array access

Saurav Kashyap (2):
      scsi: qla2xxx: Changes to support kdump kernel
      scsi: qla2xxx: Sync queue idx with queue_pair_map idx

Sean Anderson (1):
      crypto: mxs-dcp - Use sg_mapping_iter to copy data

Sean Keely (1):
      drm/amdkfd: Account for SH/SE count when setting up cu masks.

Sean Young (1):
      media: rc-loopback: return number of emitters rather than error

Sebastian Reichel (1):
      ARM: dts: imx53-ppd: Fix ACHC entry

Shuah Khan (2):
      selftests: firmware: Fix ignored return val of asprintf() warn
      usbip:vhci_hcd USB port can get stuck in the disabled state

Srikar Dronamraju (1):
      powerpc/smp: Update cpu_core_map on all PowerPc systems

Stefan Assmann (2):
      iavf: do not override the adapter state in the watchdog task
      iavf: fix locking of critical sections

Steven Rostedt (VMware) (1):
      selftests/ftrace: Fix requirement check of README file

Stuart Hayes (1):
      PCI/portdrv: Enable Bandwidth Notification only if port supports it

Subbaraya Sundeep (1):
      octeontx2-pf: Fix NIX1_RX interface backpressure

Sugar Zhang (1):
      ASoC: rockchip: i2s: Fix regmap_ops hang

Thierry Reding (1):
      arm64: tegra: Fix compatible string for Tegra132 CPUs

Thomas Hebb (1):
      mmc: rtsx_pci: Fix long reads when clock is prescaled

Thomas Zimmermann (1):
      drm/mgag200: Select clock in PLL update functions

Tianjia Zhang (1):
      Smack: Fix wrong semantics in smk_access_entry()

Tony Lindgren (1):
      serial: 8250_omap: Handle optional overrun-throttle-ms property

Trond Myklebust (5):
      NFSv4/pNFS: Fix a layoutget livelock loop
      NFSv4/pNFS: Always allow update of a zero valued layout barrier
      NFSv4/pnfs: The layout barrier indicate a minimal value for the seqid
      SUNRPC: Fix potential memory corruption
      SUNRPC/xprtrdma: Fix reconnection locking

Tuo Li (2):
      gpu: drm: amd: amdgpu: amdgpu_i2c: fix possible uninitialized-variable access in amdgpu_i2c_router_select_ddc_port()
      drm/display: fix possible null-pointer dereference in dcn10_set_clock()

Ulrich Hecht (1):
      serial: sh-sci: fix break handling for sysrq

Umang Jain (1):
      media: imx258: Limit the max analogue gain to 480

Vasily Averin (1):
      memcg: enable accounting for pids in nested pid namespaces

Vidya Sagar (1):
      arm64: tegra: Fix Tegra194 PCIe EP compatible string

Vinod Koul (6):
      arm64: dts: qcom: ipq8074: fix pci node reg property
      arm64: dts: qcom: sdm660: use reg value for memory node
      arm64: dts: qcom: ipq6018: drop '0x' from unit address
      arm64: dts: qcom: sdm630: don't use underscore in node name
      arm64: dts: qcom: msm8994: don't use underscore in node name
      arm64: dts: qcom: msm8996: don't use underscore in node name

Wang Hai (1):
      VMCI: fix NULL pointer dereference when unmapping queue pair

Wei Li (1):
      scsi: fdomain: Fix error return code in fdomain_probe()

Wenpeng Liang (1):
      RDMA/hns: Fix QP's resp incomplete assignment

Wentao_Liang (1):
      net/mlx5: DR, fix a potential use-after-free bug

Will Deacon (1):
      arm64: mm: Fix TLBI vs ASID rollover

Xiaotan Luo (1):
      ASoC: rockchip: i2s: Fixup config for DAIFMT_DSP_A/B

Xin Long (1):
      tipc: keep the skb in rcv queue until the whole data is read

Yajun Deng (1):
      netlink: Deal with ESRCH error in nlmsg_notify()

Yang Yingliang (2):
      media: atomisp: pci: fix error return code in atomisp_pci_probe()
      net: w5100: check return value after calling platform_get_resource()

Yangtao Li (1):
      f2fs: reduce the scope of setting fsck tag when de->name_len is zero

Yevgeny Kliteynik (1):
      net/mlx5: DR, Enable QP retransmission

Yonghong Song (1):
      selftests/bpf: Fix flaky send_signal test

Yongqiang Niu (1):
      soc: mediatek: cmdq: add address shift in jump

Yufeng Mo (1):
      bonding: 3ad: fix the concurrency between __bond_release_one() and bond_3ad_state_machine_handler()

Zekun Shen (1):
      ath9k: fix OOB read ar9300_eeprom_restore_internal

Zhang Qilong (1):
      iwlwifi: mvm: fix a memory leak in iwl_mvm_mac_ctxt_beacon_changed

Zhaoyu Liu (1):
      pinctrl: remove empty lines in pinctrl subsystem

Zhen Lei (2):
      pinctrl: single: Fix error return code in pcs_parse_bits_in_pinctrl_entry()
      workqueue: Fix possible memory leaks in wq_numa_init()

Zheyu Ma (5):
      video: fbdev: kyro: fix a DoS bug by restricting user input
      tty: serial: jsm: hold port lock when reporting modem line changes
      video: fbdev: asiliantfb: Error out if 'pixclock' equals zero
      video: fbdev: kyro: Error out if 'pixclock' equals zero
      video: fbdev: riva: Error out if 'pixclock' equals zero

Zhouyi Zhou (1):
      rcu: Fix macro name CONFIG_TASKS_RCU_TRACE

chenying (1):
      ovl: fix BUG_ON() in may_delete() when called from ovl_cleanup()

sumiyawang (1):
      libnvdimm/pmem: Fix crash triggered when I/O in-flight during unbind

zhenwei pi (1):
      crypto: public_key: fix overflow during implicit conversion

王贇 (1):
      net: fix NULL pointer reference in cipso_v4_doi_free

