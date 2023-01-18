Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA73671B0F
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 12:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjARLpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 06:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjARLoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 06:44:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC7465ECF;
        Wed, 18 Jan 2023 03:05:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A0C6B81C1F;
        Wed, 18 Jan 2023 11:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858A3C433EF;
        Wed, 18 Jan 2023 11:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674039907;
        bh=odR0jxZ2Esh58Imv73Dvu73NXahuOjSyZH6eetLTIvc=;
        h=From:To:Cc:Subject:Date:From;
        b=ed9jTON1tNISniPyf23ro9KlgivSkLmkVPxEpvoesXcEaplSG7GSc1q9dj5eX5YyB
         kH7laHjSxbcRx79hStC5V7iR/B7wGpDC3YfrVGCHw35CssAq/byG98DX60cCAiXiMY
         lR8ldb0heSuo8gR+LEZkNSZYndiI3XAn58blR35g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.229
Date:   Wed, 18 Jan 2023 12:05:03 +0100
Message-Id: <167403990362123@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.229 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/sound/qcom,wcd9335.txt            |    2 
 Documentation/driver-api/spi.rst                                    |    4 
 Documentation/fault-injection/fault-injection.rst                   |   16 
 Documentation/sphinx/load_config.py                                 |    6 
 Makefile                                                            |    2 
 arch/alpha/kernel/entry.S                                           |    4 
 arch/arm/boot/dts/armada-370.dtsi                                   |    2 
 arch/arm/boot/dts/armada-375.dtsi                                   |    2 
 arch/arm/boot/dts/armada-380.dtsi                                   |    4 
 arch/arm/boot/dts/armada-385-turris-omnia.dts                       |   18 
 arch/arm/boot/dts/armada-385.dtsi                                   |    6 
 arch/arm/boot/dts/armada-39x.dtsi                                   |    6 
 arch/arm/boot/dts/armada-xp-mv78230.dtsi                            |    8 
 arch/arm/boot/dts/armada-xp-mv78260.dtsi                            |   16 
 arch/arm/boot/dts/dove.dtsi                                         |    2 
 arch/arm/boot/dts/qcom-apq8064.dtsi                                 |    2 
 arch/arm/boot/dts/spear600.dtsi                                     |    2 
 arch/arm/mach-mmp/time.c                                            |   11 
 arch/arm/nwfpe/Makefile                                             |    6 
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts              |    3 
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts                         |   12 
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi                           |   22 
 arch/arm64/boot/dts/mediatek/mt6797.dtsi                            |    2 
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi                          |    4 
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts                |    6 
 arch/arm64/include/asm/atomic_ll_sc.h                               |  114 +-
 arch/arm64/include/asm/atomic_lse.h                                 |   16 
 arch/arm64/include/asm/kvm_emulate.h                                |   22 
 arch/mips/bcm63xx/clk.c                                             |    2 
 arch/mips/cavium-octeon/executive/cvmx-helper-board.c               |    2 
 arch/mips/cavium-octeon/executive/cvmx-helper.c                     |    2 
 arch/mips/kernel/vpe-cmp.c                                          |    4 
 arch/mips/kernel/vpe-mt.c                                           |    4 
 arch/parisc/include/uapi/asm/mman.h                                 |   23 
 arch/parisc/kernel/sys_parisc.c                                     |   27 
 arch/parisc/kernel/syscalls/syscall.tbl                             |    2 
 arch/powerpc/include/asm/imc-pmu.h                                  |    2 
 arch/powerpc/kernel/rtas.c                                          |   20 
 arch/powerpc/perf/callchain.c                                       |    1 
 arch/powerpc/perf/hv-gpci-requests.h                                |    4 
 arch/powerpc/perf/hv-gpci.c                                         |   33 
 arch/powerpc/perf/hv-gpci.h                                         |    1 
 arch/powerpc/perf/imc-pmu.c                                         |  136 +--
 arch/powerpc/perf/req-gen/perf.h                                    |   20 
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c                       |    1 
 arch/powerpc/platforms/83xx/mpc832x_rdb.c                           |    2 
 arch/powerpc/sysdev/xive/spapr.c                                    |    1 
 arch/riscv/include/asm/uaccess.h                                    |    2 
 arch/s390/include/asm/percpu.h                                      |    2 
 arch/s390/kernel/machine_kexec_file.c                               |    5 
 arch/x86/boot/bioscall.S                                            |    4 
 arch/x86/events/intel/uncore_snbep.c                                |    1 
 arch/x86/ia32/ia32_aout.c                                           |    3 
 arch/x86/include/asm/vmx.h                                          |    6 
 arch/x86/include/uapi/asm/vmx.h                                     |    4 
 arch/x86/kernel/cpu/bugs.c                                          |    2 
 arch/x86/kernel/cpu/microcode/intel.c                               |    8 
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                              |   26 
 arch/x86/kernel/uprobes.c                                           |    4 
 arch/x86/kvm/vmx/nested.c                                           |   31 
 arch/x86/kvm/vmx/vmx.c                                              |   66 -
 arch/x86/xen/smp.c                                                  |   41 
 arch/x86/xen/smp_pv.c                                               |   12 
 arch/x86/xen/spinlock.c                                             |    6 
 arch/x86/xen/xen-ops.h                                              |    2 
 block/blk-mq-sysfs.c                                                |   11 
 crypto/tcrypt.c                                                     |    9 
 drivers/acpi/acpica/dsmethod.c                                      |   10 
 drivers/acpi/acpica/utcopy.c                                        |    7 
 drivers/ata/ahci.c                                                  |   32 
 drivers/ata/pata_ixp4xx_cf.c                                        |    2 
 drivers/base/class.c                                                |    5 
 drivers/base/dd.c                                                   |    8 
 drivers/base/power/runtime.c                                        |   18 
 drivers/bluetooth/btusb.c                                           |    6 
 drivers/bluetooth/hci_bcsp.c                                        |    2 
 drivers/bluetooth/hci_h5.c                                          |    2 
 drivers/bluetooth/hci_ll.c                                          |    2 
 drivers/bluetooth/hci_qca.c                                         |    2 
 drivers/char/hw_random/amd-rng.c                                    |   18 
 drivers/char/hw_random/geode-rng.c                                  |   36 
 drivers/char/ipmi/ipmi_msghandler.c                                 |   12 
 drivers/char/ipmi/ipmi_si_intf.c                                    |   27 
 drivers/char/tpm/tpm_crb.c                                          |   31 
 drivers/char/tpm/tpm_tis.c                                          |    9 
 drivers/clk/imx/clk-imx8mn.c                                        |   14 
 drivers/clk/qcom/clk-krait.c                                        |    2 
 drivers/clk/renesas/r9a06g032-clocks.c                              |    3 
 drivers/clk/rockchip/clk-pll.c                                      |    1 
 drivers/clk/samsung/clk-pll.c                                       |    1 
 drivers/clk/socfpga/clk-gate.c                                      |   16 
 drivers/clk/socfpga/clk-periph.c                                    |    8 
 drivers/clk/socfpga/clk-pll.c                                       |   17 
 drivers/clk/st/clkgen-fsyn.c                                        |    5 
 drivers/clocksource/sh_cmt.c                                        |   16 
 drivers/counter/stm32-lptimer-cnt.c                                 |    2 
 drivers/cpufreq/amd_freq_sensitivity.c                              |    2 
 drivers/cpufreq/cpufreq.c                                           |    2 
 drivers/cpuidle/dt_idle_states.c                                    |    2 
 drivers/crypto/ccree/cc_debugfs.c                                   |    2 
 drivers/crypto/ccree/cc_driver.c                                    |   11 
 drivers/crypto/ccree/cc_hash.c                                      |   49 -
 drivers/crypto/ccree/cc_hash.h                                      |    2 
 drivers/crypto/img-hash.c                                           |    8 
 drivers/crypto/n2_core.c                                            |    6 
 drivers/crypto/omap-sham.c                                          |    2 
 drivers/devfreq/devfreq.c                                           |    6 
 drivers/devfreq/governor_userspace.c                                |   12 
 drivers/dio/dio.c                                                   |    8 
 drivers/edac/edac_device.c                                          |   17 
 drivers/edac/edac_module.h                                          |    2 
 drivers/edac/i10nm_base.c                                           |    3 
 drivers/firmware/efi/efi.c                                          |    9 
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c                            |    1 
 drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c                  |    3 
 drivers/gpu/drm/drm_connector.c                                     |    3 
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c                               |   11 
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c                           |    5 
 drivers/gpu/drm/i915/gvt/scheduler.c                                |    1 
 drivers/gpu/drm/mediatek/mtk_dpi.c                                  |   12 
 drivers/gpu/drm/msm/adreno/adreno_gpu.h                             |   10 
 drivers/gpu/drm/panel/panel-sitronix-st7701.c                       |   10 
 drivers/gpu/drm/radeon/radeon_bios.c                                |   19 
 drivers/gpu/drm/rockchip/cdn-dp-core.c                              |    2 
 drivers/gpu/drm/rockchip/inno_hdmi.c                                |    2 
 drivers/gpu/drm/rockchip/rk3066_hdmi.c                              |    2 
 drivers/gpu/drm/sti/sti_dvo.c                                       |    7 
 drivers/gpu/drm/sti/sti_hda.c                                       |    7 
 drivers/gpu/drm/sti/sti_hdmi.c                                      |    7 
 drivers/gpu/drm/tegra/dc.c                                          |    4 
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                              |   10 
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                                 |    3 
 drivers/hid/hid-ids.h                                               |    5 
 drivers/hid/hid-ite.c                                               |   26 
 drivers/hid/hid-multitouch.c                                        |    4 
 drivers/hid/hid-plantronics.c                                       |    9 
 drivers/hid/hid-sensor-custom.c                                     |    2 
 drivers/hid/hid-uclogic-core.c                                      |    1 
 drivers/hid/wacom_sys.c                                             |    8 
 drivers/hid/wacom_wac.c                                             |    4 
 drivers/hid/wacom_wac.h                                             |    1 
 drivers/hsi/controllers/omap_ssi_core.c                             |   14 
 drivers/i2c/busses/i2c-ismt.c                                       |    3 
 drivers/i2c/busses/i2c-pxa-pci.c                                    |   10 
 drivers/iio/adc/ad_sigma_delta.c                                    |    8 
 drivers/iio/adc/ti-adc128s052.c                                     |   14 
 drivers/infiniband/core/device.c                                    |    2 
 drivers/infiniband/core/nldev.c                                     |    4 
 drivers/infiniband/core/uverbs_cmd.c                                |    2 
 drivers/infiniband/hw/hfi1/affinity.c                               |    2 
 drivers/infiniband/hw/hfi1/firmware.c                               |    6 
 drivers/infiniband/hw/mlx5/qp.c                                     |   49 -
 drivers/infiniband/sw/rxe/rxe_qp.c                                  |    6 
 drivers/infiniband/sw/siw/siw_cq.c                                  |   24 
 drivers/infiniband/sw/siw/siw_qp_tx.c                               |    2 
 drivers/infiniband/sw/siw/siw_verbs.c                               |   40 
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c                        |    7 
 drivers/input/touchscreen/elants_i2c.c                              |    9 
 drivers/iommu/amd_iommu_init.c                                      |    7 
 drivers/iommu/amd_iommu_v2.c                                        |    1 
 drivers/iommu/fsl_pamu.c                                            |    2 
 drivers/iommu/mtk_iommu_v1.c                                        |   26 
 drivers/irqchip/irq-gic-pm.c                                        |    2 
 drivers/isdn/hardware/mISDN/hfcmulti.c                              |   19 
 drivers/isdn/hardware/mISDN/hfcpci.c                                |   13 
 drivers/isdn/hardware/mISDN/hfcsusb.c                               |   12 
 drivers/macintosh/macio-adb.c                                       |    4 
 drivers/macintosh/macio_asic.c                                      |    2 
 drivers/mailbox/zynqmp-ipi-mailbox.c                                |    4 
 drivers/mcb/mcb-core.c                                              |    4 
 drivers/mcb/mcb-parse.c                                             |    2 
 drivers/md/dm-cache-metadata.c                                      |   54 +
 drivers/md/dm-cache-target.c                                        |   11 
 drivers/md/dm-clone-target.c                                        |    1 
 drivers/md/dm-integrity.c                                           |    2 
 drivers/md/dm-thin-metadata.c                                       |   60 +
 drivers/md/dm-thin.c                                                |   18 
 drivers/md/md-bitmap.c                                              |   47 -
 drivers/md/md.c                                                     |    9 
 drivers/md/raid1.c                                                  |    1 
 drivers/media/dvb-core/dmxdev.c                                     |    8 
 drivers/media/dvb-core/dvb_ca_en50221.c                             |    2 
 drivers/media/dvb-core/dvb_frontend.c                               |   10 
 drivers/media/dvb-core/dvbdev.c                                     |   33 
 drivers/media/dvb-frontends/bcm3510.c                               |    1 
 drivers/media/dvb-frontends/stv0288.c                               |    5 
 drivers/media/i2c/ad5820.c                                          |   10 
 drivers/media/pci/saa7164/saa7164-core.c                            |    4 
 drivers/media/pci/solo6x10/solo6x10-core.c                          |    1 
 drivers/media/platform/coda/coda-bit.c                              |   14 
 drivers/media/platform/exynos4-is/fimc-core.c                       |    2 
 drivers/media/platform/exynos4-is/media-dev.c                       |    6 
 drivers/media/platform/qcom/camss/camss-video.c                     |    3 
 drivers/media/platform/s5p-mfc/s5p_mfc.c                            |   17 
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c                       |    4 
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c                        |   12 
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c                     |   14 
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c               |    1 
 drivers/media/platform/vivid/vivid-vid-cap.c                        |    1 
 drivers/media/radio/si470x/radio-si470x-usb.c                       |    4 
 drivers/media/rc/imon.c                                             |    6 
 drivers/media/usb/dvb-usb/az6027.c                                  |    4 
 drivers/media/usb/dvb-usb/dvb-usb-init.c                            |    4 
 drivers/media/v4l2-core/videobuf-dma-contig.c                       |   22 
 drivers/misc/cxl/guest.c                                            |   24 
 drivers/misc/cxl/pci.c                                              |   21 
 drivers/misc/ocxl/file.c                                            |    7 
 drivers/misc/sgi-gru/grufault.c                                     |   13 
 drivers/misc/sgi-gru/grumain.c                                      |   22 
 drivers/misc/sgi-gru/grutables.h                                    |    2 
 drivers/misc/tifm_7xx1.c                                            |    2 
 drivers/mmc/host/alcor.c                                            |    5 
 drivers/mmc/host/atmel-mci.c                                        |    9 
 drivers/mmc/host/meson-gx-mmc.c                                     |    4 
 drivers/mmc/host/mmci.c                                             |    4 
 drivers/mmc/host/moxart-mmc.c                                       |    4 
 drivers/mmc/host/mxcmmc.c                                           |    4 
 drivers/mmc/host/omap_hsmmc.c                                       |    4 
 drivers/mmc/host/pxamci.c                                           |    7 
 drivers/mmc/host/rtsx_usb_sdmmc.c                                   |   11 
 drivers/mmc/host/sdhci-sprd.c                                       |   16 
 drivers/mmc/host/sdhci_f_sdh30.c                                    |    3 
 drivers/mmc/host/toshsd.c                                           |    6 
 drivers/mmc/host/via-sdmmc.c                                        |    4 
 drivers/mmc/host/vub300.c                                           |   13 
 drivers/mmc/host/wbsd.c                                             |   12 
 drivers/mmc/host/wmt-sdmmc.c                                        |    6 
 drivers/mtd/lpddr/lpddr2_nvm.c                                      |    2 
 drivers/mtd/maps/pxa2xx-flash.c                                     |    2 
 drivers/mtd/mtdcore.c                                               |    4 
 drivers/mtd/spi-nor/spi-nor.c                                       |    2 
 drivers/net/bonding/bond_3ad.c                                      |    1 
 drivers/net/bonding/bond_alb.c                                      |    4 
 drivers/net/bonding/bond_main.c                                     |   98 +-
 drivers/net/can/m_can/tcan4x5x.c                                    |    5 
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h                         |   30 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c                    |  115 ++
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c                   |  167 +++
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c                    |  437 ++++++++--
 drivers/net/dsa/lan9303-core.c                                      |    4 
 drivers/net/ethernet/amd/atarilance.c                               |    2 
 drivers/net/ethernet/amd/lance.c                                    |    2 
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                            |    3 
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c                            |    4 
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c                           |    4 
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c                         |   23 
 drivers/net/ethernet/apple/bmac.c                                   |    2 
 drivers/net/ethernet/apple/mace.c                                   |    2 
 drivers/net/ethernet/dnet.c                                         |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c           |    3 
 drivers/net/ethernet/intel/igb/igb_main.c                           |   10 
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c                        |   14 
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c                 |    4 
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c                    |    1 
 drivers/net/ethernet/neterion/s2io.c                                |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c               |    8 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h                     |   10 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c                    |    8 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c            |    2 
 drivers/net/ethernet/rdc/r6040.c                                    |    5 
 drivers/net/ethernet/renesas/ravb_main.c                            |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c               |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h                    |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c              |    8 
 drivers/net/ethernet/ti/netcp_core.c                                |    2 
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                       |    2 
 drivers/net/fddi/defxx.c                                            |   22 
 drivers/net/hamradio/baycom_epp.c                                   |    2 
 drivers/net/hamradio/scc.c                                          |    6 
 drivers/net/loopback.c                                              |    2 
 drivers/net/ntb_netdev.c                                            |    4 
 drivers/net/phy/xilinx_gmii2rgmii.c                                 |    1 
 drivers/net/ppp/ppp_generic.c                                       |    2 
 drivers/net/usb/rndis_host.c                                        |    3 
 drivers/net/wan/farsync.c                                           |    2 
 drivers/net/wireless/ath/ar5523/ar5523.c                            |    6 
 drivers/net/wireless/ath/ath10k/pci.c                               |   20 
 drivers/net/wireless/ath/ath9k/hif_usb.c                            |   46 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c         |    5 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c             |    6 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c             |    1 
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                         |   12 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h                    |    2 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c               |   16 
 drivers/net/wireless/rsi/rsi_91x_core.c                             |    4 
 drivers/net/wireless/rsi/rsi_91x_hal.c                              |    6 
 drivers/net/xen-netback/xenbus.c                                    |    3 
 drivers/nfc/pn533/pn533.c                                           |    4 
 drivers/nfc/pn533/usb.c                                             |   44 -
 drivers/nvme/host/pci.c                                             |   25 
 drivers/of/overlay.c                                                |    4 
 drivers/parisc/led.c                                                |    3 
 drivers/pci/irq.c                                                   |    2 
 drivers/pci/pci-sysfs.c                                             |   13 
 drivers/pci/pci.c                                                   |    2 
 drivers/perf/arm_dsu_pmu.c                                          |    6 
 drivers/perf/arm_smmuv3_pmu.c                                       |    8 
 drivers/pinctrl/pinconf-generic.c                                   |    4 
 drivers/platform/x86/mxm-wmi.c                                      |    8 
 drivers/platform/x86/sony-laptop.c                                  |   21 
 drivers/pnp/core.c                                                  |    4 
 drivers/power/avs/smartreflex.c                                     |    1 
 drivers/power/supply/power_supply_core.c                            |    7 
 drivers/pwm/pwm-sifive.c                                            |    5 
 drivers/rapidio/devices/rio_mport_cdev.c                            |   15 
 drivers/rapidio/rio-scan.c                                          |    8 
 drivers/rapidio/rio.c                                               |    9 
 drivers/regulator/core.c                                            |   15 
 drivers/regulator/da9211-regulator.c                                |   11 
 drivers/remoteproc/qcom_q6v5_pas.c                                  |    1 
 drivers/remoteproc/qcom_sysmon.c                                    |    5 
 drivers/rtc/rtc-mxc_v2.c                                            |    4 
 drivers/rtc/rtc-pcf85063.c                                          |    8 
 drivers/rtc/rtc-pic32.c                                             |    8 
 drivers/rtc/rtc-snvs.c                                              |   16 
 drivers/rtc/rtc-st-lpc.c                                            |    1 
 drivers/s390/net/ctcm_main.c                                        |   11 
 drivers/s390/net/lcs.c                                              |    8 
 drivers/s390/net/netiucv.c                                          |    9 
 drivers/scsi/fcoe/fcoe.c                                            |    1 
 drivers/scsi/fcoe/fcoe_sysfs.c                                      |   19 
 drivers/scsi/hpsa.c                                                 |    9 
 drivers/scsi/ipr.c                                                  |   10 
 drivers/scsi/mpt3sas/mpt3sas_transport.c                            |    2 
 drivers/scsi/scsi_debug.c                                           |    2 
 drivers/scsi/snic/snic_disc.c                                       |    3 
 drivers/soc/qcom/Kconfig                                            |    1 
 drivers/soc/ti/knav_qmss_queue.c                                    |    6 
 drivers/soc/ux500/ux500-soc-id.c                                    |   10 
 drivers/spi/spi-gpio.c                                              |   16 
 drivers/spi/spidev.c                                                |   21 
 drivers/staging/rtl8192e/rtllib_rx.c                                |    2 
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c                   |    4 
 drivers/staging/wilc1000/wilc_sdio.c                                |    1 
 drivers/tty/hvc/hvc_xen.c                                           |   46 -
 drivers/tty/serial/altera_uart.c                                    |   21 
 drivers/tty/serial/amba-pl011.c                                     |   14 
 drivers/tty/serial/pch_uart.c                                       |    4 
 drivers/tty/serial/serial-tegra.c                                   |  115 +-
 drivers/tty/serial/sunsab.c                                         |    8 
 drivers/uio/uio_dmem_genirq.c                                       |   13 
 drivers/usb/dwc3/core.c                                             |    7 
 drivers/usb/gadget/function/f_hid.c                                 |  271 ++++--
 drivers/usb/gadget/function/f_uvc.c                                 |    5 
 drivers/usb/gadget/function/u_hid.h                                 |    1 
 drivers/usb/gadget/udc/fotg210-udc.c                                |   12 
 drivers/usb/musb/musb_gadget.c                                      |    2 
 drivers/usb/roles/class.c                                           |    5 
 drivers/usb/serial/cp210x.c                                         |    2 
 drivers/usb/serial/f81232.c                                         |   12 
 drivers/usb/serial/f81534.c                                         |   12 
 drivers/usb/serial/option.c                                         |    3 
 drivers/usb/storage/alauda.c                                        |    2 
 drivers/usb/typec/bus.c                                             |    2 
 drivers/usb/typec/tcpm/tcpci.c                                      |    5 
 drivers/vfio/platform/vfio_platform_common.c                        |    3 
 drivers/vhost/vhost.c                                               |    4 
 drivers/video/fbdev/Kconfig                                         |    1 
 drivers/video/fbdev/pm2fb.c                                         |    9 
 drivers/video/fbdev/uvesafb.c                                       |    1 
 drivers/video/fbdev/vermilion/vermilion.c                           |    4 
 drivers/video/fbdev/via/via-core.c                                  |    9 
 drivers/vme/bridges/vme_fake.c                                      |    2 
 drivers/vme/bridges/vme_tsi148.c                                    |    1 
 drivers/xen/events/events_base.c                                    |   10 
 drivers/xen/privcmd.c                                               |    2 
 fs/binfmt_aout.c                                                    |    2 
 fs/binfmt_elf_fdpic.c                                               |    7 
 fs/binfmt_flat.c                                                    |    3 
 fs/binfmt_misc.c                                                    |    8 
 fs/btrfs/backref.c                                                  |    4 
 fs/btrfs/ioctl.c                                                    |    9 
 fs/btrfs/rcu-string.h                                               |    6 
 fs/char_dev.c                                                       |    2 
 fs/cifs/cifsfs.c                                                    |    8 
 fs/cifs/cifsglob.h                                                  |   70 +
 fs/cifs/cifsproto.h                                                 |    4 
 fs/cifs/connect.c                                                   |    4 
 fs/cifs/link.c                                                      |    1 
 fs/cifs/misc.c                                                      |    4 
 fs/cifs/smb2ops.c                                                   |  143 +--
 fs/configfs/dir.c                                                   |    2 
 fs/debugfs/file.c                                                   |   28 
 fs/ext4/ext4.h                                                      |    5 
 fs/ext4/extents.c                                                   |    8 
 fs/ext4/extents_status.c                                            |    3 
 fs/ext4/indirect.c                                                  |    9 
 fs/ext4/inode.c                                                     |   48 -
 fs/ext4/ioctl.c                                                     |   13 
 fs/ext4/namei.c                                                     |    3 
 fs/ext4/resize.c                                                    |    6 
 fs/ext4/super.c                                                     |   50 -
 fs/ext4/verity.c                                                    |    7 
 fs/ext4/xattr.c                                                     |  182 ++--
 fs/ext4/xattr.h                                                     |    1 
 fs/f2fs/gc.c                                                        |    6 
 fs/f2fs/segment.c                                                   |    2 
 fs/hfs/inode.c                                                      |   13 
 fs/hfs/trans.c                                                      |    2 
 fs/hfsplus/hfsplus_fs.h                                             |    2 
 fs/hfsplus/inode.c                                                  |   16 
 fs/hfsplus/options.c                                                |    4 
 fs/hugetlbfs/inode.c                                                |    6 
 fs/jfs/jfs_dmap.c                                                   |   27 
 fs/libfs.c                                                          |   22 
 fs/mbcache.c                                                        |  121 +-
 fs/nfs/nfs4proc.c                                                   |   34 
 fs/nfs/nfs4state.c                                                  |    2 
 fs/nfs/nfs4xdr.c                                                    |   12 
 fs/nfsd/nfs4callback.c                                              |    4 
 fs/nfsd/nfs4state.c                                                 |   51 -
 fs/nfsd/nfs4xdr.c                                                   |   11 
 fs/nfsd/nfscache.c                                                  |   57 -
 fs/nfsd/nfssvc.c                                                    |    2 
 fs/nfsd/trace.h                                                     |   65 +
 fs/nilfs2/the_nilfs.c                                               |   31 
 fs/ocfs2/dlmglue.c                                                  |    8 
 fs/ocfs2/journal.c                                                  |    2 
 fs/ocfs2/journal.h                                                  |    1 
 fs/ocfs2/stackglue.c                                                |    8 
 fs/ocfs2/super.c                                                    |  108 +-
 fs/orangefs/orangefs-debugfs.c                                      |   29 
 fs/orangefs/orangefs-mod.c                                          |    8 
 fs/overlayfs/dir.c                                                  |   46 -
 fs/pnode.c                                                          |    2 
 fs/pstore/Kconfig                                                   |    1 
 fs/pstore/pmsg.c                                                    |    7 
 fs/pstore/ram.c                                                     |    2 
 fs/pstore/ram_core.c                                                |    6 
 fs/quota/dquot.c                                                    |  110 +-
 fs/reiserfs/namei.c                                                 |    4 
 fs/reiserfs/xattr_security.c                                        |    2 
 fs/sysv/itree.c                                                     |    2 
 fs/udf/inode.c                                                      |   76 -
 fs/udf/namei.c                                                      |    8 
 fs/udf/truncate.c                                                   |   48 -
 fs/xattr.c                                                          |    2 
 include/linux/debugfs.h                                             |   19 
 include/linux/devfreq.h                                             |   11 
 include/linux/eventfd.h                                             |    2 
 include/linux/fs.h                                                  |   12 
 include/linux/highmem.h                                             |   18 
 include/linux/mbcache.h                                             |   41 
 include/linux/netdevice.h                                           |   58 -
 include/linux/nvme.h                                                |   56 +
 include/linux/proc_fs.h                                             |    2 
 include/linux/quotaops.h                                            |    2 
 include/linux/sunrpc/rpc_pipe_fs.h                                  |    5 
 include/linux/timerqueue.h                                          |    2 
 include/linux/tpm_eventlog.h                                        |    4 
 include/media/dvbdev.h                                              |   32 
 include/net/bonding.h                                               |    2 
 include/net/dst.h                                                   |    5 
 include/net/mrp.h                                                   |    1 
 include/sound/hdaudio.h                                             |    2 
 include/sound/hdaudio_ext.h                                         |    1 
 include/sound/pcm.h                                                 |   36 
 include/trace/events/jbd2.h                                         |   40 
 include/uapi/linux/swab.h                                           |    2 
 include/uapi/sound/asequencer.h                                     |    8 
 kernel/acct.c                                                       |    2 
 kernel/bpf/btf.c                                                    |    5 
 kernel/bpf/verifier.c                                               |    5 
 kernel/events/core.c                                                |    8 
 kernel/gcov/gcc_4_7.c                                               |    5 
 kernel/irq/internals.h                                              |    2 
 kernel/irq/irqdesc.c                                                |   15 
 kernel/power/snapshot.c                                             |    4 
 kernel/rcu/tree.c                                                   |    2 
 kernel/relay.c                                                      |    4 
 kernel/trace/blktrace.c                                             |    3 
 kernel/trace/ring_buffer.c                                          |    1 
 kernel/trace/trace.c                                                |   15 
 kernel/trace/trace_events_hist.c                                    |   13 
 lib/fonts/fonts.c                                                   |    4 
 lib/iov_iter.c                                                      |   14 
 lib/notifier-error-inject.c                                         |    2 
 lib/test_firmware.c                                                 |    1 
 mm/compaction.c                                                     |   18 
 mm/memblock.c                                                       |    8 
 net/802/mrp.c                                                       |   18 
 net/bluetooth/hci_core.c                                            |    2 
 net/bluetooth/l2cap_core.c                                          |    3 
 net/bluetooth/rfcomm/core.c                                         |    2 
 net/bpf/test_run.c                                                  |    3 
 net/caif/cfctrl.c                                                   |    6 
 net/core/dev.c                                                      |   14 
 net/core/filter.c                                                   |   18 
 net/core/skbuff.c                                                   |    3 
 net/core/sock_map.c                                                 |    2 
 net/core/stream.c                                                   |    6 
 net/hsr/hsr_framereg.c                                              |   16 
 net/hsr/hsr_framereg.h                                              |    1 
 net/ipv4/inet_connection_sock.c                                     |   16 
 net/ipv4/tcp_bpf.c                                                  |    8 
 net/ipv4/udp_tunnel.c                                               |    1 
 net/ipv6/raw.c                                                      |    4 
 net/netfilter/ipset/ip_set_bitmap_ip.c                              |    4 
 net/netfilter/nf_conntrack_proto_icmpv6.c                           |   53 +
 net/nfc/netlink.c                                                   |   52 -
 net/openvswitch/datapath.c                                          |   25 
 net/packet/af_packet.c                                              |   20 
 net/rxrpc/output.c                                                  |    2 
 net/rxrpc/sendmsg.c                                                 |    2 
 net/sched/act_mpls.c                                                |    8 
 net/sched/cls_tcindex.c                                             |   12 
 net/sched/ematch.c                                                  |    2 
 net/sched/sch_api.c                                                 |    5 
 net/sched/sch_atm.c                                                 |    5 
 net/sched/sch_cbq.c                                                 |    5 
 net/sunrpc/auth_gss/auth_gss.c                                      |   19 
 net/sunrpc/auth_gss/svcauth_gss.c                                   |    9 
 net/sunrpc/clnt.c                                                   |    2 
 net/sunrpc/xprtrdma/verbs.c                                         |    1 
 net/tipc/core.c                                                     |   16 
 net/tipc/core.h                                                     |    6 
 net/tipc/discover.c                                                 |    4 
 net/tipc/msg.h                                                      |   19 
 net/tipc/name_distr.c                                               |    2 
 net/tipc/node.c                                                     |  172 +++
 net/tipc/node.h                                                     |    5 
 net/tipc/socket.c                                                   |    6 
 net/vmw_vsock/vmci_transport.c                                      |    6 
 net/wireless/reg.c                                                  |    4 
 samples/vfio-mdev/mdpy-fb.c                                         |    8 
 security/apparmor/apparmorfs.c                                      |    4 
 security/apparmor/lsm.c                                             |    4 
 security/apparmor/policy.c                                          |    2 
 security/apparmor/policy_unpack.c                                   |    2 
 security/device_cgroup.c                                            |   33 
 security/integrity/digsig.c                                         |    6 
 security/integrity/ima/ima.h                                        |   16 
 security/integrity/ima/ima_main.c                                   |    1 
 security/integrity/ima/ima_policy.c                                 |   65 -
 security/integrity/ima/ima_template.c                               |    9 
 security/integrity/platform_certs/load_uefi.c                       |    1 
 sound/core/control_compat.c                                         |    4 
 sound/drivers/mts64.c                                               |    3 
 sound/hda/ext/hdac_ext_stream.c                                     |   17 
 sound/hda/hdac_stream.c                                             |   27 
 sound/pci/asihpi/hpioctl.c                                          |    2 
 sound/pci/hda/hda_controller.c                                      |    4 
 sound/pci/hda/patch_hdmi.c                                          |    2 
 sound/pci/hda/patch_realtek.c                                       |   27 
 sound/soc/codecs/pcm512x.c                                          |    8 
 sound/soc/codecs/rt298.c                                            |    7 
 sound/soc/codecs/rt5670.c                                           |    2 
 sound/soc/codecs/wm8994.c                                           |    5 
 sound/soc/generic/audio-graph-card.c                                |    4 
 sound/soc/intel/boards/bytcr_rt5640.c                               |   15 
 sound/soc/intel/skylake/skl.c                                       |    7 
 sound/soc/mediatek/common/mtk-btcvsd.c                              |    6 
 sound/soc/mediatek/mt8173/mt8173-afe-pcm.c                          |   20 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c                    |    7 
 sound/soc/pxa/mmp-pcm.c                                             |    2 
 sound/soc/rockchip/rockchip_pdm.c                                   |    1 
 sound/soc/rockchip/rockchip_spdif.c                                 |    1 
 sound/usb/line6/driver.c                                            |    3 
 sound/usb/line6/midi.c                                              |    6 
 sound/usb/line6/midibuf.c                                           |   25 
 sound/usb/line6/midibuf.h                                           |    5 
 sound/usb/line6/pod.c                                               |    3 
 tools/arch/parisc/include/uapi/asm/mman.h                           |   12 
 tools/arch/x86/include/uapi/asm/vmx.h                               |    4 
 tools/objtool/check.c                                               |    2 
 tools/perf/bench/bench.h                                            |   12 
 tools/perf/builtin-trace.c                                          |  135 ++-
 tools/perf/trace/beauty/beauty.h                                    |    3 
 tools/perf/util/auxtrace.c                                          |    2 
 tools/perf/util/data.c                                              |    2 
 tools/perf/util/dwarf-aux.c                                         |   23 
 tools/perf/util/symbol-elf.c                                        |    2 
 tools/testing/ktest/ktest.pl                                        |   23 
 tools/testing/selftests/Makefile                                    |   28 
 tools/testing/selftests/efivarfs/efivarfs.sh                        |    5 
 tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc |   15 
 tools/testing/selftests/kvm/include/x86_64/vmx.h                    |    8 
 tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c            |    2 
 tools/testing/selftests/lib.mk                                      |    5 
 tools/testing/selftests/netfilter/conntrack_icmp_related.sh         |   36 
 tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c              |    5 
 tools/testing/selftests/proc/proc-uptime-002.c                      |    3 
 582 files changed, 5504 insertions(+), 2439 deletions(-)

Aakarsh Jain (1):
      media: s5p-mfc: Add variant data for MFC v7 hardware for Exynos 3250 SoC

Aaron Thompson (1):
      mm: Always release pages to the buddy allocator in memblock_free_late().

Adam Vodopjan (1):
      ata: ahci: Fix PCS quirk application for suspend

Aditya Garg (2):
      hfsplus: fix bug causing custom uid and gid being unable to be assigned with mount
      efi: Add iMac Pro 2017 to uefi skip cert quirk

Adrian Chan (1):
      ALSA: hda/hdmi: Add a HP device 0x8715 to force connect list

Adrian Hunter (1):
      perf auxtrace: Fix address filter duplicate symbol selection

Ajay Kaher (1):
      perf symbol: correction while adjusting symbol

Akinobu Mita (3):
      libfs: add DEFINE_SIMPLE_ATTRIBUTE_SIGNED for signed value
      lib/notifier-error-inject: fix error when writing -errno to debugfs file
      debugfs: fix error when writing negative value to atomic_t debugfs file

Al Viro (1):
      alpha: fix syscall entry in !AUDUT_SYSCALL case

Alexander Egorenkov (1):
      s390/kexec: fix ipl report address for kdump

Alexander Potapenko (1):
      fs: ext4: initialize fsdata in pagecache_write()

Alexander Stein (1):
      rtc: pcf85063: Fix reading alarm

Alexander Sverdlin (2):
      spi: spidev: mask SPI_CS_HIGH in SPI_IOC_RD_MODE
      mtd: spi-nor: Check for zero erase size in spi_nor_find_best_erase_type()

Alexey Dobriyan (1):
      proc: fixup uptime selftest

Amadeusz Sławiński (1):
      ASoC: codecs: rt298: Add quirk for KBL-R RVP platform

Anastasia Belova (1):
      MIPS: BCM63xx: Add check for NULL for clk in clk_enable

Andrea Arcangeli (2):
      KVM: x86: optimize more exit handlers in vmx.c
      KVM: retpolines: x86: eliminate retpoline from vmx.c exit handlers

Andrii Nakryiko (1):
      bpf: propagate precision in ALU/ALU64 operations

Andy Shevchenko (1):
      fbdev: ssd1307fb: Drop optional dependency

AngeloGioacchino Del Regno (5):
      arm64: dts: mt2712e: Fix unit_address_vs_reg warning for oscillators
      arm64: dts: mt2712e: Fix unit address for pinctrl node
      arm64: dts: mt2712-evb: Fix vproc fixed regulators unit names
      arm64: dts: mt2712-evb: Fix usb vbus regulators unit names
      arm64: dts: mediatek: mt6797: Fix 26M oscillator unit name

Anssi Hannula (4):
      can: kvaser_usb_leaf: Set Warning state even without bus errors
      can: kvaser_usb_leaf: Fix improved state not being reported
      can: kvaser_usb_leaf: Fix wrong CAN state after stopping
      can: kvaser_usb_leaf: Fix bogus restart events

Ard Biesheuvel (1):
      efi: tpm: Avoid READ_ONCE() for accessing the event log

Arnaldo Carvalho de Melo (5):
      perf trace: Separate 'struct syscall_fmt' definition from syscall_fmts variable
      perf trace: Factor out the initialization of syscal_arg_fmt->scnprintf
      perf trace: Add the syscall_arg_fmt pointer to syscall_arg
      perf trace: Allow associating scnprintf routines with well known arg names
      perf trace: Add a strtoul() method to 'struct syscall_arg_fmt'

Arnd Bergmann (2):
      RDMA/siw: Fix pointer cast warning
      hfs/hfsplus: use WARN_ON for sanity check

Artem Chernyshev (1):
      net: vmw_vsock: vmci: Check memcpy_from_msg()

Artem Egorkine (2):
      ALSA: line6: correct midi status byte when receiving data from podxt
      ALSA: line6: fix stack overflow in line6_midi_transmit

Ashok Raj (1):
      x86/microcode/intel: Do not retry microcode reloading on the APs

Baisong Zhong (3):
      ALSA: pcm: fix undefined behavior in bit shift for SNDRV_PCM_RATE_KNOT
      ALSA: seq: fix undefined behavior in bit shift for SNDRV_SEQ_FILTER_USE_EVENT
      media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()

Baokun Li (8):
      ext4: add inode table check in __ext4_get_inode_loc to aovid possible infinite loop
      ext4: add EXT4_IGET_BAD flag to prevent unexpected bad inode
      ext4: add helper to check quota inums
      ext4: fix bug_on in __es_tree_search caused by bad boot loader inode
      ext4: fix corruption when online resizing a 1K bigalloc fs
      ext4: correct inconsistent error msg in nojournal mode
      ext4: fix bug_on in __es_tree_search caused by bad quota inode
      ext4: fix use-after-free in ext4_orphan_cleanup

Barnabás Pőcze (1):
      timerqueue: Use rb_entry_safe() in timerqueue_getnext()

Ben Dooks (1):
      riscv: uaccess: fix type of 0 variable on error in get_user()

Ben Greear (1):
      wifi: iwlwifi: mvm: fix double free on tx path.

Bernard Metzler (2):
      RDMA/siw: Fix immediate work request flush to completion queue
      RDMA/siw: Set defined status for work completion with undefined status

Biju Das (1):
      ravb: Fix "failed to switch device to config mode" message during unbind

Bitterblue Smith (2):
      wifi: rtl8xxxu: Fix reading the vendor of combo chips
      wifi: rtl8xxxu: Add __packed to struct rtl8723bu_c2h

Bixuan Cui (1):
      jbd2: use the correct print format

Boris Burkov (1):
      btrfs: fix resolving backrefs for inline extent followed by prealloc

Bruno Thomsen (1):
      USB: serial: cp210x: add Kamstrup RF sniffer PIDs

Cai Xinchen (1):
      rapidio: devices: fix missing put_device in mport_cdev_open

Cezary Rojewski (1):
      ASoC: Intel: Skylake: Fix driver hang during shutdown

Chaitanya Kulkarni (1):
      ext4: use memcpy_to_page() in pagecache_write()

Chen Jiahao (1):
      drivers: soc: ti: knav_qmss_queue: Mark knav_acc_firmwares as static

Chen Zhongjin (7):
      perf: Fix possible memleak in pmu_dev_alloc()
      fs: sysv: Fix sysv_nblocks() returns wrong value
      media: dvb-core: Fix ignored return value in dvb_register_frontend()
      wifi: cfg80211: Fix not unregister reg_pdev when load_builtin_regdb_keys() fails
      configfs: fix possible memory leak in configfs_create_dir()
      scsi: fcoe: Fix transport not deattached when fcoe_if_init() fails
      vme: Fix error not catched in fake_init()

Christian Brauner (1):
      pnode: terminate at peers of source

Christian Marangi (1):
      clk: qcom: clk-krait: fix wrong div2 functions

Christoph Hellwig (2):
      media: videobuf-dma-contig: use dma_mmap_coherent
      nvme: fix the NVME_CMD_EFFECTS_CSE_MASK definition

Christophe JAILLET (4):
      fbdev: uvesafb: Fixes an error handling path in uvesafb_probe()
      powerpc/52xx: Fix a resource leak in an error handling path
      myri10ge: Fix an error handling path in myri10ge_probe()
      iommu/mediatek-v1: Fix an error handling path in mtk_iommu_v1_probe()

Christophe Leroy (1):
      objtool: Fix SEGFAULT

Chuck Lever (2):
      NFSD: Add tracepoints to NFSD's duplicate reply cache
      SUNRPC: Don't leak netobj memory when gss_read_proxy_verf() fails

Clement Lecigne (1):
      ALSA: pcm: Move rwsem lock inside snd_ctl_elem_read to prevent UAF

Cong Wang (1):
      net_sched: reject TCF_EM_SIMPLE case for complex ematch module

Corentin Labbe (1):
      crypto: n2 - add missing hash statesize

Dan Aloni (1):
      nfsd: under NFSv4.1, fix double svc_xprt_put on rpc_create failure

Dan Carpenter (5):
      amdgpu/pm: prevent array underflow in vega20_odn_edit_dpm_table()
      bonding: uninitialized variable in bond_miimon_inspect()
      staging: rtl8192u: Fix use after free in ieee80211_rx()
      ipmi: fix use after free in _ipmi_destroy_user()
      drm/i915: unpin on error in intel_vgpu_shadow_mm_pin()

Daniil Tatianin (2):
      qlcnic: prevent ->dcb use-after-free on qlcnic_dcb_enable() failure
      drivers/net/bonding/bond_3ad: return when there's no aggregator

Dario Binacchi (1):
      clk: imx: replace osc_hdmi with dummy

David Howells (3):
      net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
      rxrpc: Fix ack.bufferSize to be 0 when generating an ack
      rxrpc: Fix missing unlock in rxrpc_do_sendmsg()

Deren Wu (1):
      mmc: vub300: fix warning - do not call blocking ops when !TASK_RUNNING

Dinh Nguyen (1):
      clk: socfpga: use clk_hw_register for a5/c5

Dmitry Osipenko (2):
      tty: serial: tegra: Activate RX DMA transfer by request
      tty: serial: tegra: Handle RX transfer in PIO mode if DMA wasn't started

Dmitry Torokhov (1):
      ASoC: dt-bindings: wcd9335: fix reset line polarity in example

Dongdong Zhang (1):
      f2fs: fix normal discard process

Dongliang Mu (1):
      fs: jfs: fix shift-out-of-bounds in dbAllocAG

Doug Brown (2):
      ARM: mmp: fix timer_read delay
      drm/etnaviv: add missing quirks for GC300

Douglas Anderson (1):
      Input: elants_i2c - properly handle the reset GPIO when power is off

Dragos Tatulea (1):
      IB/IPoIB: Fix queue count inconsistency for PKEY child interfaces

Duke Xin (1):
      USB: serial: option: add Quectel EM05-G modem

Edward Pacman (1):
      ALSA: hda/realtek: Add quirk for Lenovo TianYi510Pro-14IOB

Eelco Chaudron (1):
      openvswitch: Fix flow lookup to use unmasked key

Eliav Farber (1):
      EDAC/device: Fix period calculation in edac_device_reset_delay_period()

Eran Ben Elisha (1):
      net/mlx5: Rename ptp clock info

Eric Biggers (1):
      ext4: don't allow journal inode to have encrypt flag

Eric Dumazet (4):
      bpf, sockmap: fix race in sock_map_free()
      net: stream: purge sk_error_queue in sk_stream_kill_queues()
      net: add atomic_long_t to net_device_stats fields
      net/af_packet: make sure to pull mac header

Eric Pilmore (1):
      ntb_netdev: Use dev_kfree_skb_any() in interrupt context

Eric W. Biederman (1):
      binfmt: Move install_exec_creds after setup_new_exec to match binfmt_elf

Eric Whitney (1):
      ext4: fix delayed allocation bug in ext4_clu_mapped for bigalloc + inline

Fabrice Gasnier (1):
      counter: stm32-lptimer-cnt: fix the check on arr and cmp registers update

Fedor Pchelkin (3):
      wifi: ath9k: hif_usb: fix memory leak of urbs in ath9k_hif_usb_dealloc_tx_urbs()
      wifi: ath9k: hif_usb: Fix use-after-free in ath9k_hif_usb_reg_in_cb()
      wifi: ath9k: verify the expected usb_endpoints are present

Ferry Toth (3):
      usb: dwc3: core: defer probe on ulpi_read_id timeout
      usb: ulpi: defer ulpi_register on ulpi_read_id timeout
      Revert "usb: ulpi: defer ulpi_register on ulpi_read_id timeout"

Florian Westphal (1):
      netfilter: conntrack: set icmpv6 redirects as RELATED

Florian-Ewald Mueller (1):
      md/bitmap: Fix bitmap chunk size overflow issues

Frederick Lawler (1):
      net: sched: disallow noqueue for qdisc classes

GUO Zihua (3):
      ima: Handle -ESTALE returned by ima_filter_rule_match()
      integrity: Fix memory leakage in keyring allocation error path
      rtc: mxc_v2: Add missing clk_disable_unprepare()

Gabriel Somlo (1):
      serial: altera_uart: fix locking in polling mode

Gaosheng Cui (11):
      lib/fonts: fix undefined behavior in bit shift for get_default_font
      ALSA: mts64: fix possible null-ptr-defer in snd_mts64_interrupt
      apparmor: fix a memleak in multi_transaction_new()
      crypto: ccree - Remove debugfs when platform_driver_register failed
      scsi: snic: Fix possible UAF in snic_tgt_create()
      crypto: img-hash - Fix variable dereferenced before check 'hdev->req'
      staging: vme_user: Fix possible UAF in tsi148_dma_list_add
      remoteproc: sysmon: fix memory leak in qcom_add_sysmon_subdev()
      rtc: st-lpc: Add missing clk_disable_unprepare in st_rtc_probe()
      rtc: pic32: Move devm_rtc_allocate_device earlier in pic32_rtc_probe()
      ext4: fix undefined behavior in bit shift for ext4_check_flag_values

Gautam Menghani (1):
      media: imon: fix a race condition in send_packet()

Gavrilov Ilia (2):
      relay: fix type mismatch when allocating memory in relay_create_buf()
      netfilter: ipset: Fix overflow before widen in the bitmap_ip_create() function.

Geert Uytterhoeven (2):
      clocksource/drivers/sh_cmt: Make sure channel clock supply is enabled
      crypto: ccree - swap SHA384 and SHA512 larval hashes at build time

Greg Kroah-Hartman (1):
      Linux 5.4.229

Gustavo A. R. Silva (1):
      ima: Fix fall-through warnings for Clang

Hangbin Liu (2):
      net/tunnel: wait until all sk_user_data reader finish before releasing the sock
      net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO

Hanjun Guo (3):
      drm/radeon: Add the missed acpi_put_table() to fix memory leak
      tpm: tpm_crb: Add the missed acpi_put_table() to fix memory leak
      tpm: tpm_tis: Add the missed acpi_put_table() to fix memory leak

Hans de Goede (6):
      HID: ite: Add support for Acer S1002 keyboard-dock
      HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch 10E
      HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch V 10
      ASoC: rt5670: Remove unbalanced pm_runtime_put()
      ASoC: Intel: bytcr_rt5640: Add quirk for the Advantech MICA-071 tablet
      platform/x86: sony-laptop: Don't turn off 0x153 keyboard backlight during probe

Harshit Mogalapalli (2):
      xen/privcmd: Fix a possible warning in privcmd_ioctl_mmap_resource()
      scsi: scsi_debug: Fix a warning in resp_write_scat()

Hawkins Jiawei (2):
      hugetlbfs: fix null-ptr-deref in hugetlbfs_parse_param()
      net: sched: fix memory leak in tcindex_set_parms

Heiko Carstens (1):
      s390/percpu: add READ_ONCE() to arch_this_cpu_to_op_simple()

Helge Deller (1):
      parisc: Align parisc MADV_XXX constants with all other architectures

Heming Zhao (1):
      ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown

Heming Zhao via Ocfs2-devel (2):
      ocfs2: ocfs2_mount_volume does cleanup job before return error
      ocfs2: rewrite error handling of ocfs2_fill_super

Herbert Xu (1):
      ipv6: raw: Deduct extension header length in rawv6_push_pending_frames

Hoang Le (3):
      tipc: improve throughput between nodes in netns
      tipc: eliminate checking netns if node established
      tipc: Add a missing case of TIPC_DIRECT_MSG type

Hoi Pok Wu (1):
      fs: jfs: fix shift-out-of-bounds in dbDiscardAG

Huaxin Lu (1):
      ima: Fix a potential NULL pointer access in ima_restore_measurement_list

Hui Tang (2):
      mtd: lpddr2_nvm: Fix possible null-ptr-deref
      i2c: pxa-pci: fix missing pci_disable_device() on error in ce4100_i2c_probe

Ido Schimmel (1):
      net/sched: act_mpls: Fix warning during failed attribute validation

Ira Weiny (1):
      mm/highmem: Lift memcpy_[to|from]_page to core

Isaac J. Manjarres (1):
      driver core: Fix bus_type.match() error handling in __driver_attach()

Ivaylo Dimitrov (1):
      usb: musb: remove extra check in musb_gadget_vbus_draw

Jakub Kicinski (1):
      bpf: pull before calling skb_postpull_rcsum()

Jamal Hadi Salim (2):
      net: sched: atm: dont intepret cls results when asked to drop
      net: sched: cbq: dont intepret cls results when asked to drop

Jan Kara (17):
      udf: Discard preallocation before extending file with a hole
      udf: Fix preallocation discarding at indirect extent boundary
      udf: Do not bother looking for prealloc extents if i_lenExtents matches i_size
      udf: Fix extending file within last block
      ext4: avoid BUG_ON when creating xattrs
      ext4: initialize quota before expanding inode in setproject ioctl
      ext4: avoid unaccounted block allocation when expanding inode
      mbcache: don't reclaim used entries
      mbcache: add functions to delete entry if unused
      ext4: remove EA inode entry from mbcache on inode eviction
      ext4: unindent codeblock in ext4_xattr_block_set()
      ext4: fix race when reusing xattr blocks
      mbcache: automatically delete entries from cache on freeing
      ext4: fix deadlock due to mbcache entry corruption
      udf: Fix extension of the last extent in the file
      mbcache: Avoid nesting of cache->c_list_lock under bit locks
      quota: Factor out setup of quota inode

Jason A. Donenfeld (2):
      media: stv0288: use explicitly signed char
      ARM: ux500: do not directly dereference __iomem

Jason Gerecke (1):
      HID: wacom: Ensure bootloader PID is usable in hidraw mode

Jason Yan (1):
      ext4: goto right label 'failed_mount3a'

Jeff Layton (3):
      nfsd: don't call nfsd_file_put from client states seqfile display
      nfsd: shut down the NFSv4 state objects before the filecache
      nfsd: fix handling of readdir in v4root vs. mount upcall timeout

Jerry Ray (1):
      net: lan9303: Fix read error execution path

Jiamei Xie (1):
      serial: amba-pl011: avoid SBSA UART accessing DMACR register

Jiang Li (1):
      md/raid1: stop mdx_raid1 thread when raid1 array run failed

Jiao Zhou (1):
      ALSA: hda/hdmi: Add HP Device 0x8711 to force connect list

Jiasheng Jiang (4):
      ASoC: mediatek: mtk-btcvsd: Add checks for write and read of mtk_btcvsd_snd
      media: coda: Add check for dcoda_iram_alloc
      media: coda: Add check for kmalloc
      usb: storage: Add check for kcalloc

Jie Wang (1):
      net: hns3: add interrupts re-initialization while doing VF FLR

Jiguang Xiao (1):
      net: amd-xgbe: add missed tasklet_kill

Jimmy Assarsson (5):
      can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device
      can: kvaser_usb: kvaser_usb_leaf: Rename {leaf,usbcan}_cmd_error_event to {leaf,usbcan}_cmd_can_error_event
      can: kvaser_usb: kvaser_usb_leaf: Handle CMD_ERROR_EVENT
      can: kvaser_usb: Add struct kvaser_usb_busparams
      can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming

Jiri Slaby (2):
      tty: serial: clean up stop-tx part in altera_uart_tx_chars()
      tty: serial: altera_uart_{r,t}x_chars() need only uart_port

Johan Hovold (4):
      USB: serial: f81232: fix division by zero on line-speed change
      USB: serial: f81534: fix division by zero on line-speed change
      regulator: core: fix deadlock on regulator enable
      efi: fix NULL-deref in init error path

John Johansen (2):
      apparmor: fix lockdep warning when removing a namespace
      apparmor: Fix abi check to include v8 abi

John Keeping (2):
      usb: gadget: f_hid: fix f_hidg lifetime vs cdev
      usb: gadget: f_hid: fix refcount leak on error path

John Stultz (2):
      pstore: Switch pmsg_lock to an rt_mutex to avoid priority inversion
      pstore: Make sure CONFIG_PSTORE_PMSG selects CONFIG_RT_MUTEXES

Jonathan Corbet (1):
      docs: Fix the docs build with Sphinx 6.0

Jonathan Neuschäfer (1):
      spi: Update reference to struct spi_controller

Jonathan Toppins (1):
      bonding: fix link recovery in mode 2 when updelay is nonzero

José Expósito (2):
      HID: uclogic: Add HID_QUIRK_HIDINPUT_FORCE quirk
      HID: multitouch: fix Asus ExpertBook P2 P2451FA trackpoint

Juergen Gross (1):
      xen/events: only register debug interrupt for 2-level events

Junlin Yang (1):
      pata_ipx4xx_cf: Fix unsigned comparison with less than zero

Kajol Jain (2):
      powerpc/hv-gpci: Fix hv_gpci event list
      powerpc/imc-pmu: Fix use of mutex in IRQs disabled section

Kant Fan (1):
      PM/devfreq: governor: Add a private governor_data for governor

Kartik (1):
      serial: tegra: Read DMA status before terminating

Kees Cook (1):
      igb: Do not free q_vector unless new one was allocated

Keita Suzuki (1):
      media: dvb-core: Fix double free in dvb_register_device()

Kim Phillips (1):
      iommu/amd: Fix ivrs_acpihid cmdline parsing code

Klaus Jensen (1):
      nvme-pci: fix doorbell buffer value endianness

Konrad Dybcio (1):
      drm/msm/adreno: Make adreno quirks not overwrite each other

Kory Maincent (1):
      arm: dts: spear600: Fix clcd interrupt

Kris Bahnsen (1):
      spi: spi-gpio: Don't set MOSI as an input if not 3WIRE mode

Krzysztof Kozlowski (2):
      arm64: dts: qcom: sdm845-cheza: fix AP suspend pin bias
      arm64: dts: qcom: sdm850-lenovo-yoga-c630: correct I2C12 pins drive strength

Kunihiko Hayashi (1):
      mmc: f-sdh30: Add quirks for broken timeout clock capability

Ladislav Michl (1):
      MIPS: OCTEON: warn only once if deprecated link status is being used

Lee Jones (1):
      clk: socfpga: clk-pll: Remove unused variable 'rc'

Leo Yan (3):
      perf trace: Return error if a system call doesn't exist
      perf trace: Use macro RAW_SYSCALL_ARGS_NUM to replace number
      perf trace: Handle failure when trace point folder is missed

Leon Romanovsky (2):
      RDMA/core: Fix order of nldev_exit call
      RDMA/uverbs: Silence shiftTooManyBitsSigned warning

Li Jun (1):
      clk: imx8mn: correct the usb1_ctrl parent to be usb_bus

Li Zetao (4):
      ocfs2: fix memory leak in ocfs2_mount_volume()
      ACPICA: Fix use-after-free in acpi_ut_copy_ipackage_to_ipackage()
      net: farsync: Fix kmemleak when rmmods farsync
      r6040: Fix kmemleak in probe and remove

Li Zhong (1):
      drivers/md/md-bitmap: check the return value of md_bitmap_get_counter()

Liang He (1):
      media: c8sectpfe: Add of_node_put() when breaking out of loop

Lin Ma (3):
      media: dvbdev: adopts refcnt to avoid UAF
      media: dvbdev: fix build warning due to comments
      media: dvbdev: fix refcnt bug

Linus Torvalds (1):
      hfs/hfsplus: avoid WARN_ON() for sanity check, use proper error handling

Linus Walleij (1):
      usb: fotg210-udc: Fix ages old endianness issues

Liu Shixin (4):
      media: vivid: fix compose size exceed boundary
      ALSA: asihpi: fix missing pci_disable_device()
      media: saa7164: fix missing pci_disable_device()
      binfmt_misc: fix shift-out-of-bounds in check_special_flags

Luca Weiss (1):
      ARM: dts: qcom: apq8064: fix coresight compatible

Luo Meng (5):
      dm thin: Fix UAF in run_timer_softirq()
      dm integrity: Fix UAF in dm_integrity_dtr()
      dm clone: Fix UAF in clone_dtr()
      dm cache: Fix UAF in destroy()
      dm thin: resume even if in FAIL mode

Luís Henriques (1):
      ext4: fix error code return to user-space in ext4_get_branch()

Manivannan Sadhasivam (1):
      soc: qcom: Select REMAP_MMIO for LLCC driver

Maor Gottlieb (3):
      bonding: Export skip slave logic to function
      bonding: Rename slave_arr to usable_slaves
      RDMA/mlx5: Fix validation of max_rd_atomic caps for DC

Marc Zyngier (1):
      KVM: arm64: Fix S1PTW handling on RO memslots

Marcus Folkesson (1):
      HID: hid-sensor-custom: set fixed size for custom attributes

Marek Szyprowski (1):
      ASoC: wm8994: Fix potential deadlock

Marek Vasut (3):
      clk: renesas: r9a06g032: Repair grave increment error
      drm/panel/panel-sitronix-st7701: Remove panel on DSI attach failure
      wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port

Mark Rutland (3):
      arm64: atomics: format whitespace consistently
      arm64: atomics: remove LL/SC trampolines
      arm64: cmpxchg_double*: hazard against entire exchange variable

Mark Zhang (1):
      RDMA/nldev: Return "-EAGAIN" if the cm_id isn't from expected port

Markus Schneider-Pargmann (1):
      can: tcan4x5x: Remove invalid write in clear_interrupts

Masami Hiramatsu (Google) (2):
      perf probe: Use dwarf_attr_integrate as generic DWARF attr accessor
      perf probe: Fix to get the DW_AT_decl_file and DW_AT_call_file as unsinged data

Matt Redfearn (1):
      include/uapi/linux/swab: Fix potentially missing __always_inline

Maxim Devaev (1):
      usb: gadget: f_hid: optional SETUP/SET_REPORT mode

Mazin Al Haddad (1):
      media: dvb-usb: fix memory leak in dvb_usb_adapter_init()

Miaoqian Lin (5):
      cxl: Fix refcount leak in cxl_calc_capp_routing
      selftests/powerpc: Fix resource leaks
      nfc: Fix potential resource leaks
      net: phy: xgmiitorgmii: Fix refcount leak in xgmiitorgmii_probe
      perf tools: Fix resources leak in perf_data__open_dir()

Michael Kelley (1):
      tpm/tpm_crb: Fix error message in __crb_relinquish_locality()

Michael S. Tsirkin (1):
      PCI: Fix pci_device_is_present() for VFs by checking PF

Michael Walle (1):
      wifi: wilc1000: sdio: fix module autoloading

Mickaël Salaün (1):
      selftests: Use optional USERCFLAGS and USERLDFLAGS

Mike Snitzer (2):
      dm cache: Fix ABBA deadlock between shrink_slab and dm_cache_metadata_abort
      dm cache: set needs_check flag after aborting metadata

Mikulas Patocka (1):
      md: fix a crash in mempool_free

Minghao Chi (1):
      soc: ti: knav_qmss_queue: Use pm_runtime_resume_and_get instead of pm_runtime_get_sync

Minsuk Kang (3):
      nfc: pn533: Clear nfc_target before being used
      wifi: brcmfmac: Fix potential shift-out-of-bounds in brcmf_fw_alloc_request()
      nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()

Muhammad Usama Anjum (1):
      selftests: set the BUILD variable to absolute path

NARIBAYASHI Akira (1):
      mm, compaction: fix fast_isolate_around() to stay within boundaries

Nathan Chancellor (7):
      net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
      hamradio: baycom_epp: Fix return type of baycom_send_packet()
      s390/ctcm: Fix return type of ctc{mp,}m_tx()
      s390/netiucv: Fix return type of netiucv_tx()
      s390/lcs: Fix return type of lcs_start_xmit()
      drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()
      drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()

Nathan Lynch (2):
      powerpc/rtas: avoid device tree lookups in rtas_os_term()
      powerpc/rtas: avoid scheduling in rtas_os_term()

Nicholas Piggin (1):
      powerpc/perf: callchain validate kernel stack pointer bounds

Nick Desaulniers (1):
      ARM: 9256/1: NWFPE: avoid compiler-generated __aeabi_uldivmod

Nuno Sá (1):
      iio: adc: ad_sigma_delta: do not use internal iio_dev lock

Oleg Nesterov (1):
      uprobes/x86: Allow to probe a NOP instruction with 0x66 prefix

Ondrej Mosnacek (1):
      fs: don't audit the capability check in simple_xattr_list()

Pali Rohár (9):
      ARM: dts: dove: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: armada-370: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: armada-xp: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: armada-375: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: armada-38x: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: armada-39x: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: turris-omnia: Add ethernet aliases
      ARM: dts: turris-omnia: Add switch port 6 node
      arm64: dts: armada-3720-turris-mox: Add missing interrupt for RTC

Paolo Abeni (1):
      net/ulp: prevent ULP without clone op from entering the LISTEN status

Paulo Alcantara (2):
      cifs: fix oops during encryption
      cifs: fix confusing debug message

Pavel Machek (1):
      f2fs: should put a page when checking the summary info

Pengcheng Yang (2):
      bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data
      bpf, sockmap: Fix data loss caused by using apply_bytes on ingress redirect

Peter Newman (1):
      x86/resctrl: Fix task CLOSID/RMID update race

Peter Zijlstra (1):
      x86/boot: Avoid using Intel mnemonics in AT&T syntax asm

Piergiorgio Beruto (1):
      stmmac: fix potential division by 0

Pierre-Louis Bossart (2):
      ALSA/ASoC: hda: move/rename snd_hdac_ext_stop_streams to hdac_stream.c
      ALSA: hda: add snd_hdac_stop_streams() helper

Pratyush Yadav (2):
      tracing/ring-buffer: Only do full wait when cpu != RING_BUFFER_ALL_CPUS
      xen-netback: move removal of "hotplug-status" to the right place

Rafael J. Wysocki (2):
      PM: runtime: Do not call __rpm_callback() from rpm_idle()
      ACPICA: Fix error code path in acpi_ds_call_control_method()

Rafael Mendonca (3):
      vfio: platform: Do not pass return buffer to ACPI _RST method
      uio: uio_dmem_genirq: Fix missing unlock in irq configuration
      uio: uio_dmem_genirq: Fix deadlock between irq config and handling

Rahul Rameshbabu (1):
      net/mlx5: Fix ptp max frequency adjustment range

Rasmus Villemoes (2):
      net: loopback: use NET_NAME_PREDICTABLE for name_assign_type
      iio: adc128s052: add proper .data members in adc128_of_match table

Reinette Chatre (1):
      x86/resctrl: Use task_curr() instead of task_struct->on_cpu to prevent unnecessary IPI

Revanth Rajashekar (1):
      nvme: resync include/linux/nvme.h with nvmecli

Ricardo Ribalda (3):
      media: i2c: ad5820: Fix error path
      ASoC: mediatek: mt8173: Enable IRQ when pdata is ready
      regulator: da9211: Use irq handler when ready

Rickard x Andersson (1):
      gcov: add support for checksum field

Rob Clark (1):
      drm/virtio: Fix GEM handle creation UAF

Roberto Sassu (1):
      reiserfs: Add missing calls to reiserfs_security_free()

Rodrigo Branco (1):
      x86/bugs: Flush IBP in ib_prctl_set()

Roger Pau Monne (1):
      hvc/xen: lock console list traversal

Rui Zhang (1):
      regulator: core: fix use_count leakage when handling boot-on

Ryusuke Konishi (1):
      nilfs2: fix shift-out-of-bounds/overflow in nilfs_sb2_bad_offset()

Sascha Hauer (1):
      PCI/sysfs: Fix double free in error path

Sasha Levin (1):
      btrfs: replace strncpy() with strscpy()

Schspa Shi (1):
      mrp: introduce active flags to prevent UAF when applicant uninit

Sean Christopherson (1):
      KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1

Sebastian Andrzej Siewior (1):
      hsr: Avoid double remove of a node.

Shang XiaoJing (8):
      perf/smmuv3: Fix hotplug callback leak in arm_smmu_pmu_init()
      ocfs2: fix memory leak in ocfs2_stack_glue_init()
      irqchip: gic-pm: Use pm_runtime_resume_and_get() in gic_probe()
      scsi: ipr: Fix WARNING in ipr_init()
      crypto: omap-sham - Use pm_runtime_resume_and_get() in omap_sham_probe()
      samples: vfio-mdev: Fix missing pci_disable_device() in mdpy_fb_probe()
      fbdev: via: Fix error in via_core_init()
      parisc: led: Fix potential null-ptr-deref in start_task()

Shigeru Yoshida (3):
      udf: Avoid double brelse() in udf_rename()
      wifi: ar5523: Fix use-after-free on ar5523_cmd() timed out
      media: si470x: Fix use-after-free in si470x_int_in_callback()

Shuah Khan (1):
      selftests: Fix kselftest O=objdir build from cluttering top level objdir

Shuqi Zhang (1):
      ext4: use kmemdup() to replace kmalloc + memcpy

Simon Ser (1):
      drm/connector: send hotplug uevent on connector cleanup

Smitha T Murthy (3):
      media: s5p-mfc: Fix to handle reference queue during finishing
      media: s5p-mfc: Clear workbit to handle error condition
      media: s5p-mfc: Fix in register read and write for H264

Stanislav Fomichev (4):
      bpf: Move skb->len == 0 checks into __bpf_redirect
      bpf: make sure skb->len != 0 when redirecting to a tunneling device
      ppp: associate skb with a device at tx
      bpf: Prevent decl_tag from being referenced in func_proto arg

Stefan Eichenberger (1):
      rtc: snvs: Allow a time difference on clock register read

Stefano Garzarella (1):
      vhost: fix range used in translate_desc()

Stephen Boyd (1):
      pstore: Avoid kcore oops by vmap()ing with VM_IOREMAP

Steve French (1):
      cifs: fix missing display of three mount options

Steven Rostedt (2):
      kest.pl: Fix grub2 menu handling for rebooting
      ktest.pl minconfig: Unset configs instead of just removing them

Subash Abhinov Kasiviswanathan (1):
      skbuff: Account for tail adjustment during pull operations

Sungwoo Kim (1):
      Bluetooth: L2CAP: Fix u8 overflow

Sven Peter (1):
      usb: typec: Check for ops->exit instead of ops->enter in altmode_exit

Szymon Heidrich (2):
      usb: gadget: uvc: Prevent buffer overflow in setup handler
      usb: rndis_host: Secure rndis_query check against int overflow

Takashi Iwai (1):
      media: dvb-core: Fix UAF due to refcount races at releasing

Terry Junge (1):
      HID: plantronics: Additional PIDs for double volume key presses quirk

Tom Lendacky (2):
      net: amd-xgbe: Fix logic around active and passive cables
      net: amd-xgbe: Check only the minimum speed for active/passive cables

Tony Nguyen (1):
      igb: Initialize mailbox message for VF reset

Trond Myklebust (6):
      NFSv4.2: Clear FATTR4_WORD2_SECURITY_LABEL when done decoding
      NFSv4.2: Fix a memory stomp in decode_attr_security_label
      NFSv4.2: Fix initialisation of struct nfs4_label
      NFSv4: Fix a deadlock between nfs4_open_recover_helper() and delegreturn
      NFSv4.x: Fail client initialisation if state manager thread can't run
      nfsd: Define the file access mode enum for tracing

Tung Nguyen (1):
      tipc: fix unexpected link reset due to discovery messages

Tuong Lien (1):
      tipc: fix use-after-free in tipc_disc_rcv()

Tyler Hicks (1):
      ima: Rename internal filter rule functions

Ulf Hansson (2):
      cpuidle: dt: Return the correct numbers of parsed idle states
      PM: runtime: Improve path in rpm_idle() when no callback

Uwe Kleine-König (2):
      crypto: ccree - Make cc_debugfs_global_fini() available for module init function
      pwm: sifive: Call pwm_sifive_update_clock() while mutex is held

Ville Syrjälä (2):
      drm/rockchip: Use drm_mode_copy()
      drm/sti: Use drm_mode_copy()

Vincent Mailhol (1):
      can: kvaser_usb: do not increase tx statistics when sending error message frames

Vladimir Zapolskiy (1):
      media: camss: Clean up received buffers on failed start of streaming

Volker Lendecke (1):
      cifs: Fix uninitialized memory read for smb311 posix symlink create

Wang Jingjin (2):
      ASoC: rockchip: pdm: Add missing clk_disable_unprepare() in rockchip_pdm_runtime_resume()
      ASoC: rockchip: spdif: Add missing clk_disable_unprepare() in rk_spdif_runtime_resume()

Wang ShaoBo (2):
      regulator: core: use kfree_const() to free space conditionally
      SUNRPC: Fix missing release socket in rpc_sockname()

Wang Weiyang (2):
      rapidio: fix possible UAF when kfifo_alloc() fails
      device_cgroup: Roll back to original exceptions after copy failure

Wang Yufen (6):
      pstore/ram: Fix error return code in ramoops_probe()
      wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()
      RDMA/hfi1: Fix error return code in parse_platform_config()
      ASoC: mediatek: mt8173-rt5650-rt5514: fix refcount leak in mt8173_rt5650_rt5514_dev_probe()
      ASoC: audio-graph-card: fix refcount leak of cpu_ep in __graph_for_each_link()
      binfmt: Fix error return code in load_elf_fdpic_binary()

Wenchao Chen (1):
      mmc: sdhci-sprd: Disable CLK_AUTO when the clock is less than 400K

Wolfram Sang (1):
      docs: fault-injection: fix non-working usage of negative values

Wright Feng (1):
      brcmfmac: return error when getting invalid max_flowrings from dongle

Xiaoyao Li (3):
      KVM: VMX: Rename INTERRUPT_PENDING to INTERRUPT_WINDOW
      KVM: VMX: Rename NMI_PENDING to NMI_WINDOW
      KVM: VMX: Fix the spelling of CPU_BASED_USE_TSC_OFFSETTING

Xie Shaowen (1):
      macintosh/macio-adb: check the return value of ioremap()

Xin Long (1):
      tipc: call tipc_lxc_xmit without holding node_read_lock

Xinlei Lee (1):
      drm/mediatek: Modify dpi power on/off sequence.

Xiongfeng Wang (9):
      perf/x86/intel/uncore: Fix reference count leak in hswep_has_limit_sbox()
      cpufreq: amd_freq_sensitivity: Add missing pci_dev_put()
      drm/radeon: Fix PCI device refcount leak in radeon_atrm_get_bios()
      drm/amdgpu: Fix PCI device refcount leak in amdgpu_atrm_get_bios()
      RDMA/hfi: Decrease PCI device reference count in error path
      hwrng: amd - Fix PCI device refcount leak
      hwrng: geode - Fix PCI device refcount leak
      serial: pch: Fix PCI device refcount leak in pch_request_dma()
      fbdev: vermilion: decrease reference count in error path

Xiu Jianfeng (9):
      x86/xen: Fix memory leak in xen_smp_intr_init{_pv}()
      x86/xen: Fix memory leak in xen_init_lock_cpu()
      ima: Fix misuse of dereference of pointer in template_desc_init_fields()
      wifi: ath10k: Fix return value in ath10k_pci_init()
      clk: rockchip: Fix memory leak in rockchip_clk_register_pll()
      clk: samsung: Fix memory leak in _samsung_clk_register_pll()
      clk: socfpga: Fix memory leak in socfpga_gate_init()
      apparmor: Use pointer to struct aa_label for lbs_cred
      clk: st: Fix memory leak in st_of_quadfs_setup()

Yan Lei (1):
      media: dvb-frontends: fix leak of memory fw

Yang Jihong (2):
      blktrace: Fix output non-blktrace event when blk_classic option enabled
      tracing: Fix infinite loop in tracing_read_pipe on overflowed print_trace_line

Yang Yingliang (64):
      MIPS: vpe-mt: fix possible memory leak while module exiting
      MIPS: vpe-cmp: fix possible memory leak while module exiting
      PNP: fix name memory leak in pnp_alloc_dev()
      EDAC/i10nm: fix refcount leak in pci_get_dev_wrapper()
      genirq/irqdesc: Don't try to remove non-existing sysfs files
      rapidio: fix possible name leaks when rio_add_device() fails
      rapidio: rio: fix possible name leak in rio_register_mport()
      regulator: core: fix unbalanced of node refcount in regulator_dev_lookup()
      media: solo6x10: fix possible memory leak in solo_sysfs_init()
      regulator: core: fix module refcount leak in set_supply()
      regulator: core: fix resource leak in regulator_register()
      mmc: alcor: fix return value check of mmc_add_host()
      mmc: moxart: fix return value check of mmc_add_host()
      mmc: mxcmmc: fix return value check of mmc_add_host()
      mmc: pxamci: fix return value check of mmc_add_host()
      mmc: rtsx_usb_sdmmc: fix return value check of mmc_add_host()
      mmc: toshsd: fix return value check of mmc_add_host()
      mmc: vub300: fix return value check of mmc_add_host()
      mmc: wmt-sdmmc: fix return value check of mmc_add_host()
      mmc: atmel-mci: fix return value check of mmc_add_host()
      mmc: omap_hsmmc: fix return value check of mmc_add_host()
      mmc: meson-gx: fix return value check of mmc_add_host()
      mmc: via-sdmmc: fix return value check of mmc_add_host()
      mmc: wbsd: fix return value check of mmc_add_host()
      mmc: mmci: fix return value check of mmc_add_host()
      ethernet: s2io: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: apple: mace: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: apple: bmac: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: emaclite: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: ethernet: dnet: don't call dev_kfree_skb() under spin_lock_irqsave()
      hamradio: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: amd: lance: don't call dev_kfree_skb() under spin_lock_irqsave()
      Bluetooth: btusb: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_qca: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_ll: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_h5: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_bcsp: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_core: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: RFCOMM: don't call kfree_skb() under spin_lock_irqsave()
      scsi: mpt3sas: Fix possible resource leaks in mpt3sas_transport_port_add()
      scsi: hpsa: Fix error handling in hpsa_add_sas_host()
      scsi: hpsa: Fix possible memory leak in hpsa_add_sas_device()
      scsi: fcoe: Fix possible name leak when device_register() fails
      drivers: dio: fix possible memory leak in dio_init()
      class: fix possible memory leak in __class_register()
      usb: typec: tcpci: fix of node refcount leak in tcpci_register_port()
      misc: ocxl: fix possible name leak in ocxl_file_register_afu()
      cxl: fix possible null-ptr-deref in cxl_guest_init_afu|adapter()
      cxl: fix possible null-ptr-deref in cxl_pci_init_afu|adapter()
      usb: roles: fix of node refcount leak in usb_role_switch_is_parent()
      mcb: mcb-parse: fix error handing in chameleon_parse_gdd()
      chardev: fix error handling in cdev_device_add()
      fbdev: pm2fb: fix missing pci_disable_device()
      HSI: omap_ssi_core: fix unbalanced pm_runtime_disable()
      HSI: omap_ssi_core: fix possible memory leak in ssi_probe()
      iommu/amd: Fix pci device refcount leak in ppr_notifier()
      macintosh: fix possible memory leak in macio_add_one_device()
      powerpc/xive: add missing iounmap() in error path in xive_spapr_populate_irq_data()
      powerpc/83xx/mpc832x_rdb: call platform_device_put() in error case in of_fsl_spi_probe()
      mISDN: hfcsusb: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
      mISDN: hfcpci: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
      mISDN: hfcmulti: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
      mailbox: zynq-ipi: fix error handling while device_register() fails
      ixgbe: fix pci device refcount leak

Ye Bin (6):
      blk-mq: fix possible memleak when register 'hctx' failed
      ext4: fix reserved cluster accounting in __es_remove_extent()
      ext4: init quota for 'old.inode' in 'ext4_rename'
      ext4: fix inode leak in ext4_xattr_inode_create() on an error path
      ext4: allocate extended attribute value in vmalloc area
      ext4: fix uninititialized value in 'ext4_evict_inode'

Yipeng Zou (1):
      selftests/ftrace: event_triggers: wait longer for test_event_enable

Yong Wu (1):
      iommu/mediatek-v1: Add error handle for mtk_iommu_probe

Yonggil Song (1):
      f2fs: avoid victim selection from previous victim section

Yongqiang Liu (2):
      net: defxx: Fix missing err handling in dfx_init()
      cpufreq: Init completion before kobject_init_and_add()

Yu Liao (1):
      platform/x86: mxm-wmi: fix memleak in mxm_wmi_call_mx[ds|mx]()

Yuan Can (9):
      perf: arm_dsu: Fix hotplug callback leak in dsu_pmu_init()
      media: platform: exynos4-is: Fix error handling in fimc_md_init()
      drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()
      scsi: hpsa: Fix possible memory leak in hpsa_init_one()
      RDMA/nldev: Add checks for nla_nest_start() in fill_stat_counter_qps()
      serial: sunsab: Fix error handling in sunsab_init()
      HSI: omap_ssi_core: Fix error handling in ssi_init()
      iommu/fsl_pamu: Fix resource leak in fsl_pamu_probe()
      remoteproc: qcom_q6v5_pas: Fix missing of_node_put() in adsp_alloc_memory_region()

YueHaibing (1):
      staging: rtl8192e: Fix potential use-after-free in rtllib_rx_Monitor()

Zack Rusin (1):
      drm/vmwgfx: Validate the box size for the snooped cursor

Zeng Heng (3):
      ASoC: pxa: fix null-pointer dereference in filter()
      PCI: Check for alloc failure in pci_request_irq()
      power: supply: fix residue sysfs file in error handle route of __power_supply_register()

Zhang Changzhong (1):
      net: stmmac: selftests: fix potential memleak in stmmac_test_arpoffload()

Zhang Qilong (4):
      soc: ti: knav_qmss_queue: Fix PM disable depth imbalance in knav_queue_probe
      soc: ti: smartreflex: Fix PM disable depth imbalance in omap_sr_probe
      eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD
      ASoC: pcm512x: Fix PM disable depth imbalance in pcm512x_probe

Zhang Tianci (1):
      ovl: Use ovl mounter's fsuid and fsgid in ovl_link()

Zhang Xiaoxu (6):
      mtd: Fix device name leak when register device failed in add_mtd_device()
      xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()
      RDMA/rxe: Fix NULL-ptr-deref in rxe_qp_do_cleanup() when socket create failed
      orangefs: Fix sysfs not cleanup when dev init failed
      orangefs: Fix kmemleak in orangefs_prepare_debugfs_help_string()
      orangefs: Fix kmemleak in orangefs_{kernel,client}_debug_init()

Zhang Yiqun (1):
      crypto: tcrypt - Fix multibuffer skcipher speed test mem leak

Zhang Yuchen (2):
      ipmi: fix memleak when unload ipmi driver
      ipmi: fix long wait in unload when IPMI disconnect

Zhang Zekun (1):
      drm/tegra: Add missing clk_disable_unprepare() in tegra_dc_probe()

ZhangPeng (3):
      hfs: Fix OOB Write in hfs_asc2mac
      pinctrl: pinconf-generic: add missing of_node_put()
      hfs: fix OOB Read in __hfs_brec_find

Zhao Gongyi (1):
      selftests/efivarfs: Add checking of the test return value

Zheng Wang (1):
      misc: sgi-gru: fix use-after-free error in gru_set_context_option, gru_fault and gru_handle_user_call_os

Zheng Yejian (4):
      tracing/hist: Fix issue of losting command info in error_log
      acct: fix potential integer overflow in encode_comp_t()
      tracing/hist: Fix out-of-bound write on 'action_data.var_ref_idx'
      tracing/hist: Fix wrong return value in parse_action_params()

Zheng Yongjun (1):
      mtd: maps: pxa2xx-flash: fix memory leak in probe

Zhengchao Shao (3):
      test_firmware: fix memory leak in test_firmware_init()
      drivers: mcb: fix resource leak in mcb_probe()
      caif: fix memory leak in cfctrl_linkup_request()

Zheyu Ma (1):
      i2c: ismt: Fix an out-of-bounds bug in ismt_access()

Zhihao Cheng (2):
      dm thin: Fix ABBA deadlock between shrink_slab and dm_pool_abort_metadata
      dm thin: Use last transaction's pmd->root when commit failed

Zqiang (1):
      rcu: Fix __this_cpu_read() lockdep warning in rcu_force_quiescent_state()

delisun (1):
      serial: pl011: Do not clear RX FIFO & RX interrupt in unthrottle.

minoura makoto (1):
      SUNRPC: ensure the matching upcall is in-flight upon downcall

ruanjinjie (3):
      of: overlay: fix null pointer dereferencing in find_dup_cset_node_entry() and find_dup_cset_prop()
      misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()
      power: supply: fix null pointer dereferencing in power_supply_get_battery_info

xiongxin (1):
      PM: hibernate: Fix mistake in kerneldoc comment

zhengliang (1):
      ext4: lost matching-pair of trace in ext4_truncate

