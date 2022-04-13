Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05754FFD33
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 19:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiDMR7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 13:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237401AbiDMR7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 13:59:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0E867D21;
        Wed, 13 Apr 2022 10:57:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6271EB826FE;
        Wed, 13 Apr 2022 17:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BB2C385A4;
        Wed, 13 Apr 2022 17:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649872627;
        bh=olYvFhb9CEXbHJAkCz5srEHqa/kbzpf0a7aR6zEqVDU=;
        h=From:To:Cc:Subject:Date:From;
        b=a1Lw6Lt/6wPALYrdwant0xj90Z/SDsQMjw81ClXnzMS/fxslNQg1WcOu8gqq2RVmO
         zjD32qQ6k1d326B5SsplaRXSrBJm3xUivT37gG2dOLZEKpHK3oG4Gf8L4iVHYOQ02o
         4+yWZ4IpvRzfp2iA61boopQh4J/fjEvRU8tJ/MP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.17.3
Date:   Wed, 13 Apr 2022 19:57:02 +0200
Message-Id: <16498726229578@kroah.com>
X-Mailer: git-send-email 2.35.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.17.3 kernel.

All users of the 5.17 kernel series must upgrade.

The updated 5.17.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.17.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/virt/kvm/devices/vcpu.rst                        |    2 
 Makefile                                                       |    2 
 arch/arm64/include/asm/cputype.h                               |    2 
 arch/arm64/include/asm/kvm_host.h                              |    1 
 arch/arm64/kernel/patching.c                                   |    4 
 arch/arm64/kernel/proton-pack.c                                |    1 
 arch/arm64/kernel/smp.c                                        |    2 
 arch/arm64/kvm/arm.c                                           |    4 
 arch/arm64/kvm/pmu-emul.c                                      |   33 
 arch/mips/boot/dts/ingenic/jz4780.dtsi                         |    2 
 arch/mips/include/asm/setup.h                                  |    2 
 arch/mips/kernel/traps.c                                       |   22 
 arch/mips/ralink/ill_acc.c                                     |    1 
 arch/parisc/kernel/patch.c                                     |   25 
 arch/powerpc/boot/dts/fsl/t104xrdb.dtsi                        |    4 
 arch/powerpc/include/asm/interrupt.h                           |    2 
 arch/powerpc/include/asm/page.h                                |    6 
 arch/powerpc/kernel/rtas.c                                     |    6 
 arch/powerpc/kernel/secvar-sysfs.c                             |    9 
 arch/powerpc/kexec/core.c                                      |   15 
 arch/powerpc/kvm/book3s_64_entry.S                             |   10 
 arch/powerpc/lib/code-patching.c                               |   14 
 arch/powerpc/mm/book3s64/hash_utils.c                          |   54 
 arch/powerpc/mm/mem.c                                          |    2 
 arch/powerpc/mm/pageattr.c                                     |   32 
 arch/powerpc/perf/callchain.h                                  |    9 
 arch/powerpc/perf/callchain_64.c                               |   27 
 arch/powerpc/platforms/Kconfig.cputype                         |    3 
 arch/powerpc/sysdev/xive/common.c                              |    2 
 arch/riscv/lib/memmove.S                                       |  368 +++++-
 arch/um/include/asm/xor.h                                      |    4 
 arch/x86/Kconfig                                               |    5 
 arch/x86/events/intel/core.c                                   |    8 
 arch/x86/include/asm/asm.h                                     |   20 
 arch/x86/include/asm/bug.h                                     |    4 
 arch/x86/include/asm/irq_stack.h                               |    3 
 arch/x86/include/asm/kvm_host.h                                |    1 
 arch/x86/include/asm/msi.h                                     |   19 
 arch/x86/include/asm/perf_event.h                              |    5 
 arch/x86/kernel/cpu/mce/core.c                                 |   64 +
 arch/x86/kernel/cpu/mce/internal.h                             |    5 
 arch/x86/kernel/static_call.c                                  |    5 
 arch/x86/kvm/emulate.c                                         |    4 
 arch/x86/kvm/kvm_emulate.h                                     |    1 
 arch/x86/kvm/pmu.c                                             |   18 
 arch/x86/kvm/svm/pmu.c                                         |    9 
 arch/x86/kvm/svm/svm.h                                         |    2 
 arch/x86/kvm/svm/svm_onhyperv.c                                |    1 
 arch/x86/kvm/vmx/pmu_intel.c                                   |   14 
 arch/x86/kvm/x86.c                                             |    6 
 arch/x86/mm/tlb.c                                              |   37 
 arch/x86/power/cpu.c                                           |   21 
 arch/x86/xen/smp_hvm.c                                         |    6 
 arch/x86/xen/time.c                                            |   24 
 arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi                    |    8 
 arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi                     |    8 
 arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi                      |    4 
 drivers/acpi/processor_idle.c                                  |    3 
 drivers/ata/sata_dwc_460ex.c                                   |    6 
 drivers/block/drbd/drbd_int.h                                  |    8 
 drivers/block/drbd/drbd_main.c                                 |    6 
 drivers/block/drbd/drbd_nl.c                                   |   41 
 drivers/block/drbd/drbd_state.c                                |   18 
 drivers/block/drbd/drbd_state_change.h                         |    8 
 drivers/bluetooth/btmtk.h                                      |    1 
 drivers/bluetooth/btmtksdio.c                                  |    9 
 drivers/bluetooth/btusb.c                                      |    8 
 drivers/char/virtio_console.c                                  |    8 
 drivers/clk/clk-si5341.c                                       |   16 
 drivers/clk/clk.c                                              |   24 
 drivers/clk/mediatek/clk-mt8192.c                              |   36 
 drivers/clk/rockchip/clk-rk3568.c                              |    6 
 drivers/clk/ti/clk.c                                           |   13 
 drivers/cpufreq/cppc_cpufreq.c                                 |   43 
 drivers/dma/sh/shdma-base.c                                    |    4 
 drivers/gpio/gpiolib.c                                         |   19 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c               |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c                         |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                     |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c                        |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                     |    3 
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c                          |    4 
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c                       |   14 
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c                          |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_process.c                       |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c                    |   24 
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c                           |   80 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c              |    7 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h              |    6 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c      |   80 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c          |    6 
 drivers/gpu/drm/amd/display/dc/core/dc.c                       |   66 +
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c               |   15 
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c              |    3 
 drivers/gpu/drm/amd/display/dc/dc.h                            |    3 
 drivers/gpu/drm/amd/display/dc/dce/dmub_outbox.c               |   25 
 drivers/gpu/drm/amd/display/dc/dce/dmub_outbox.h               |    4 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c      |   11 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c          |    2 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c             |    2 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c          |    2 
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c                            |   11 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c           |    8 
 drivers/gpu/drm/bridge/nwl-dsi.c                               |   18 
 drivers/gpu/drm/drm_edid.c                                     |   19 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                 |    6 
 drivers/gpu/drm/imx/dw_hdmi-imx.c                              |    8 
 drivers/gpu/drm/imx/imx-ldb.c                                  |    2 
 drivers/gpu/drm/imx/parallel-display.c                         |    4 
 drivers/gpu/drm/msm/dsi/dsi_host.c                             |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c                |    1 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c                |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c                |    1 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h                 |    1 
 drivers/gpu/drm/panel/panel-ilitek-ili9341.c                   |    4 
 drivers/gpu/drm/sprd/sprd_dpu.c                                |    5 
 drivers/gpu/drm/sprd/sprd_drm.c                                |    2 
 drivers/gpu/drm/sprd/sprd_dsi.c                                |    5 
 drivers/gpu/drm/v3d/v3d_gem.c                                  |    6 
 drivers/hid/hid-apple.c                                        |    6 
 drivers/hv/channel_mgmt.c                                      |    6 
 drivers/hv/vmbus_drv.c                                         |   16 
 drivers/infiniband/core/cm.c                                   |    3 
 drivers/infiniband/hw/hfi1/mmu_rb.c                            |    6 
 drivers/infiniband/hw/mlx5/mr.c                                |    5 
 drivers/infiniband/sw/rdmavt/qp.c                              |    6 
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                         |   40 
 drivers/infiniband/ulp/rtrs/rtrs-clt.h                         |    1 
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c                    |    1 
 drivers/iommu/omap-iommu.c                                     |    2 
 drivers/irqchip/irq-gic-v3-its.c                               |   28 
 drivers/irqchip/irq-gic-v3.c                                   |   14 
 drivers/irqchip/irq-gic.c                                      |    6 
 drivers/md/dm-ioctl.c                                          |    2 
 drivers/md/dm-rq.c                                             |    7 
 drivers/md/dm.c                                                |   11 
 drivers/misc/habanalabs/common/memory.c                        |   30 
 drivers/misc/habanalabs/common/mmu/mmu_v1.c                    |    2 
 drivers/misc/habanalabs/gaudi/gaudi.c                          |   48 
 drivers/mmc/core/block.c                                       |   46 
 drivers/mmc/core/quirks.h                                      |    5 
 drivers/mmc/host/mmci_stm32_sdmmc.c                            |    6 
 drivers/mmc/host/renesas_sdhi_core.c                           |    8 
 drivers/mmc/host/sdhci-xenon.c                                 |   10 
 drivers/net/can/usb/etas_es58x/es58x_fd.c                      |    3 
 drivers/net/dsa/ocelot/felix_vsc9959.c                         |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                      |    7 
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                      |    5 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c              |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c                  |   14 
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h                  |    2 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c               |    4 
 drivers/net/ethernet/intel/i40e/i40e_common.c                  |   21 
 drivers/net/ethernet/intel/iavf/iavf.h                         |    5 
 drivers/net/ethernet/intel/iavf/iavf_main.c                    |  173 ++-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c                |   18 
 drivers/net/ethernet/intel/ice/ice.h                           |    2 
 drivers/net/ethernet/intel/ice/ice_lib.c                       |    3 
 drivers/net/ethernet/intel/ice/ice_main.c                      |   13 
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c               |    4 
 drivers/net/ethernet/intel/ice/ice_xsk.c                       |    6 
 drivers/net/ethernet/marvell/mv643xx_eth.c                     |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c     |    7 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c         |   10 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c              |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h                |    2 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c     |    6 
 drivers/net/ethernet/mellanox/mlx5/core/port.c                 |   23 
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c                 |    4 
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h                 |    7 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c             |    3 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c       |    3 
 drivers/net/ethernet/qlogic/qed/qed_debug.c                    |    2 
 drivers/net/ethernet/qlogic/qede/qede_fp.c                     |    3 
 drivers/net/ethernet/sfc/efx_channels.c                        |  148 +-
 drivers/net/ethernet/sfc/rx_common.c                           |    3 
 drivers/net/ethernet/sfc/tx.c                                  |    3 
 drivers/net/ethernet/sfc/tx_common.c                           |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c          |    3 
 drivers/net/macvtap.c                                          |    6 
 drivers/net/mdio/mdio-mscc-miim.c                              |    6 
 drivers/net/phy/sfp-bus.c                                      |    6 
 drivers/net/tap.c                                              |    3 
 drivers/net/tun.c                                              |    3 
 drivers/net/vrf.c                                              |   15 
 drivers/net/wireless/ath/ath11k/ahb.c                          |    2 
 drivers/net/wireless/ath/ath11k/mac.c                          |    2 
 drivers/net/wireless/ath/ath11k/mhi.c                          |    2 
 drivers/net/wireless/ath/ath11k/pci.c                          |   10 
 drivers/net/wireless/ath/ath5k/eeprom.c                        |    3 
 drivers/net/wireless/intel/iwlwifi/Kconfig                     |    1 
 drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h            |    5 
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c              |   31 
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c                  |    5 
 drivers/net/wireless/mediatek/mt76/dma.c                       |    1 
 drivers/net/wireless/mediatek/mt76/mt76.h                      |    2 
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                |    2 
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c                |    1 
 drivers/net/wireless/mediatek/mt76/mt7921/main.c               |    1 
 drivers/net/wireless/realtek/rtw88/debug.c                     |    2 
 drivers/net/wireless/realtek/rtw88/debug.h                     |    1 
 drivers/net/wireless/realtek/rtw88/fw.c                        |    2 
 drivers/net/wireless/realtek/rtw88/mac80211.c                  |    8 
 drivers/net/wireless/realtek/rtw88/main.c                      |    8 
 drivers/net/wireless/realtek/rtw88/rtw8821c.c                  |    2 
 drivers/net/wireless/realtek/rtw88/rtw8822b.c                  |    4 
 drivers/net/wireless/realtek/rtw88/rtw8822c.c                  |    4 
 drivers/net/wireless/realtek/rtw88/sar.c                       |    8 
 drivers/net/wireless/realtek/rtw89/core.c                      |    5 
 drivers/opp/debugfs.c                                          |    5 
 drivers/opp/opp.h                                              |    1 
 drivers/parisc/dino.c                                          |   41 
 drivers/parisc/gsc.c                                           |   31 
 drivers/parisc/gsc.h                                           |    1 
 drivers/parisc/lasi.c                                          |    7 
 drivers/parisc/wax.c                                           |    7 
 drivers/pci/controller/pci-aardvark.c                          |   16 
 drivers/pci/endpoint/functions/pci-epf-test.c                  |   14 
 drivers/pci/hotplug/pciehp_hpc.c                               |    2 
 drivers/perf/qcom_l2_pmu.c                                     |    6 
 drivers/phy/amlogic/phy-meson-gxl-usb2.c                       |    5 
 drivers/phy/amlogic/phy-meson8b-usb2.c                         |    9 
 drivers/platform/x86/Kconfig                                   |    2 
 drivers/platform/x86/hp-wmi.c                                  |   93 +
 drivers/platform/x86/thinkpad_acpi.c                           |   15 
 drivers/power/supply/Kconfig                                   |    4 
 drivers/power/supply/axp20x_battery.c                          |   13 
 drivers/power/supply/axp288_charger.c                          |   21 
 drivers/power/supply/axp288_fuel_gauge.c                       |   14 
 drivers/ptp/ptp_sysfs.c                                        |    4 
 drivers/regulator/atc260x-regulator.c                          |    1 
 drivers/regulator/rtq2134-regulator.c                          |    1 
 drivers/rtc/rtc-wm8350.c                                       |   11 
 drivers/scsi/aha152x.c                                         |    6 
 drivers/scsi/bfa/bfad_attr.c                                   |   26 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                         |   68 +
 drivers/scsi/libfc/fc_exch.c                                   |    1 
 drivers/scsi/mpi3mr/mpi3mr.h                                   |    4 
 drivers/scsi/mpi3mr/mpi3mr_fw.c                                |    4 
 drivers/scsi/mpi3mr/mpi3mr_os.c                                |  108 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                           |    5 
 drivers/scsi/mvsas/mv_init.c                                   |    4 
 drivers/scsi/pm8001/pm8001_hwi.c                               |   79 -
 drivers/scsi/pm8001/pm8001_init.c                              |    3 
 drivers/scsi/pm8001/pm8001_sas.c                               |   15 
 drivers/scsi/pm8001/pm8001_sas.h                               |    2 
 drivers/scsi/pm8001/pm80xx_hwi.c                               |   22 
 drivers/scsi/scsi_logging.c                                    |    2 
 drivers/scsi/scsi_scan.c                                       |    5 
 drivers/scsi/sd.c                                              |    2 
 drivers/scsi/smartpqi/smartpqi_init.c                          |   45 
 drivers/scsi/sr.c                                              |    2 
 drivers/scsi/ufs/ufshcd-pci.c                                  |   17 
 drivers/scsi/ufs/ufshpb.c                                      |   11 
 drivers/scsi/zorro7xx.c                                        |    2 
 drivers/spi/spi-bcm-qspi.c                                     |    4 
 drivers/spi/spi-rpc-if.c                                       |    8 
 drivers/spi/spi.c                                              |    4 
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c  |    3 
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c |    6 
 drivers/staging/wfx/bus_sdio.c                                 |    3 
 drivers/staging/wfx/main.c                                     |    7 
 drivers/tty/serial/samsung_tty.c                               |    5 
 drivers/usb/cdns3/cdnsp-debug.h                                |  305 ++---
 drivers/usb/dwc3/dwc3-omap.c                                   |    2 
 drivers/usb/dwc3/dwc3-pci.c                                    |   11 
 drivers/usb/gadget/udc/tegra-xudc.c                            |   20 
 drivers/usb/host/ehci-pci.c                                    |    9 
 drivers/usb/host/xen-hcd.c                                     |   57 -
 drivers/vdpa/mlx5/net/mlx5_vnet.c                              |   21 
 drivers/vfio/pci/vfio_pci_rdwr.c                               |    2 
 drivers/vhost/net.c                                            |    1 
 drivers/video/fbdev/core/fbmem.c                               |    9 
 drivers/w1/slaves/w1_therm.c                                   |    8 
 fs/btrfs/extent_io.h                                           |    2 
 fs/btrfs/inode.c                                               |   22 
 fs/btrfs/ioctl.c                                               |   20 
 fs/btrfs/volumes.c                                             |   65 -
 fs/btrfs/zoned.c                                               |    9 
 fs/ceph/dir.c                                                  |   11 
 fs/ceph/inode.c                                                |   10 
 fs/cifs/connect.c                                              |   15 
 fs/cifs/netmisc.c                                              |    2 
 fs/file_table.c                                                |    1 
 fs/io-wq.h                                                     |    1 
 fs/io_uring.c                                                  |  388 +++----
 fs/jfs/inode.c                                                 |    3 
 fs/minix/inode.c                                               |    3 
 fs/nfs/dir.c                                                   |   10 
 fs/nfs/direct.c                                                |   48 
 fs/nfs/file.c                                                  |    4 
 fs/nfs/inode.c                                                 |    1 
 fs/nfs/internal.h                                              |   17 
 fs/nfs/nfs42proc.c                                             |    9 
 fs/nfs/nfs4file.c                                              |    6 
 fs/nfs/nfs4state.c                                             |   12 
 fs/nfs/pagelist.c                                              |   10 
 fs/nfs/pnfs_nfs.c                                              |    8 
 fs/nfs/write.c                                                 |   34 
 include/linux/gpio/driver.h                                    |    9 
 include/linux/ipv6.h                                           |    2 
 include/linux/mmzone.h                                         |   11 
 include/linux/nfs_fs.h                                         |   10 
 include/linux/ref_tracker.h                                    |    2 
 include/linux/static_call.h                                    |    5 
 include/linux/vfio_pci_core.h                                  |    9 
 include/net/arp.h                                              |    1 
 include/net/bluetooth/bluetooth.h                              |   14 
 include/net/bluetooth/hci_core.h                               |    3 
 include/net/mctp.h                                             |    2 
 include/net/net_namespace.h                                    |    6 
 include/trace/events/sunrpc.h                                  |    1 
 include/uapi/linux/bpf.h                                       |    6 
 include/uapi/linux/can/isotp.h                                 |   28 
 init/main.c                                                    |    8 
 kernel/Makefile                                                |    3 
 kernel/events/core.c                                           |    3 
 kernel/sched/core.c                                            |   16 
 kernel/sched/idle.c                                            |    1 
 kernel/sched/sched.h                                           |    6 
 kernel/static_call.c                                           |  542 ---------
 kernel/static_call_inline.c                                    |  543 ++++++++++
 lib/Kconfig.debug                                              |    3 
 lib/logic_iomem.c                                              |    8 
 lib/lz4/lz4_decompress.c                                       |    8 
 lib/ref_tracker.c                                              |    5 
 mm/highmem.c                                                   |    4 
 mm/kfence/core.c                                               |   11 
 mm/kfence/kfence.h                                             |    3 
 mm/mempolicy.c                                                 |    1 
 mm/mremap.c                                                    |    3 
 mm/rmap.c                                                      |   25 
 net/batman-adv/multicast.c                                     |    2 
 net/bluetooth/hci_conn.c                                       |    1 
 net/bluetooth/hci_event.c                                      |   79 +
 net/bluetooth/hci_sync.c                                       |    7 
 net/bluetooth/l2cap_core.c                                     |    1 
 net/bpf/test_run.c                                             |    4 
 net/can/isotp.c                                                |   12 
 net/core/dev.c                                                 |    3 
 net/core/filter.c                                              |   46 
 net/core/net_namespace.c                                       |   17 
 net/core/rtnetlink.c                                           |   13 
 net/core/skbuff.c                                              |   15 
 net/dsa/master.c                                               |   25 
 net/ipv4/arp.c                                                 |    9 
 net/ipv4/fib_frontend.c                                        |    5 
 net/ipv4/fib_semantics.c                                       |    7 
 net/ipv4/inet_hashtables.c                                     |   53 
 net/ipv6/addrconf.c                                            |    4 
 net/ipv6/af_inet6.c                                            |   24 
 net/ipv6/inet6_hashtables.c                                    |    5 
 net/ipv6/ip6_input.c                                           |    2 
 net/ipv6/ip6mr.c                                               |    8 
 net/ipv6/ipv6_sockglue.c                                       |    6 
 net/ipv6/route.c                                               |    2 
 net/mctp/af_mctp.c                                             |   46 
 net/mctp/device.c                                              |   21 
 net/mctp/route.c                                               |   21 
 net/mctp/test/utils.c                                          |    1 
 net/netfilter/nf_conntrack_core.c                              |   85 +
 net/netfilter/nft_bitwise.c                                    |    4 
 net/netlabel/netlabel_kapi.c                                   |    2 
 net/openvswitch/actions.c                                      |    2 
 net/openvswitch/flow_netlink.c                                 |   99 +
 net/rxrpc/net_ns.c                                             |    2 
 net/sctp/outqueue.c                                            |    6 
 net/smc/af_smc.c                                               |    8 
 net/smc/smc_core.c                                             |    2 
 net/smc/smc_tx.c                                               |   25 
 net/smc/smc_tx.h                                               |    1 
 net/sunrpc/clnt.c                                              |    7 
 net/sunrpc/sched.c                                             |    7 
 net/sunrpc/svcsock.c                                           |    4 
 net/sunrpc/xprt.c                                              |   23 
 net/sunrpc/xprtrdma/transport.c                                |    2 
 net/sunrpc/xprtsock.c                                          |   70 -
 net/tls/tls_sw.c                                               |    2 
 net/wireless/scan.c                                            |    9 
 tools/build/feature/Makefile                                   |    9 
 tools/lib/bpf/Makefile                                         |    4 
 tools/lib/bpf/bpf_tracing.h                                    |   14 
 tools/objtool/check.c                                          |   11 
 tools/perf/Makefile.config                                     |    6 
 tools/perf/arch/arm64/util/arm-spe.c                           |    6 
 tools/perf/perf.c                                              |    2 
 tools/perf/tests/dwarf-unwind.c                                |    2 
 tools/perf/util/arm64-frame-pointer-unwind-support.c           |    2 
 tools/perf/util/machine.c                                      |    2 
 tools/perf/util/session.c                                      |   15 
 tools/perf/util/setup.py                                       |    8 
 tools/perf/util/unwind-libdw.c                                 |   10 
 tools/perf/util/unwind-libdw.h                                 |    1 
 tools/perf/util/unwind-libunwind-local.c                       |   10 
 tools/perf/util/unwind-libunwind.c                             |    6 
 tools/perf/util/unwind.h                                       |   13 
 tools/testing/selftests/bpf/progs/test_sk_lookup.c             |    3 
 tools/testing/selftests/bpf/xdpxceiver.c                       |   80 -
 tools/testing/selftests/bpf/xdpxceiver.h                       |    2 
 tools/testing/selftests/kvm/aarch64/vgic_irq.c                 |   45 
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c               |   12 
 tools/testing/selftests/kvm/lib/aarch64/vgic.c                 |    9 
 virt/kvm/kvm_main.c                                            |    2 
 404 files changed, 4509 insertions(+), 2533 deletions(-)

Adam Wujek (1):
      clk: si5341: fix reported clk_rate when output divider is 2

Adrian Hunter (2):
      perf tools: Fix perf's libperf_print callback
      scsi: ufs: ufs-pci: Add support for Intel MTL

Aharon Landau (2):
      RDMA/mlx5: Don't remove cache MRs when a delay is needed
      RDMA/mlx5: Add a missing update of cache->last_add

Akihiko Odaki (1):
      Revert "ACPI: processor: idle: Only flush cache on entering C3"

Alex Deucher (3):
      drm/amdkfd: make CRAT table missing message informational only
      drm/amdgpu/smu10: fix SoC/fclk units in auto mode
      drm/amdgpu: don't use BACO for reset in S3

Alex Williamson (1):
      vfio/pci: Stub vfio_pci_vga_rw when !CONFIG_VFIO_PCI_VGA

Alexander Lobakin (1):
      MIPS: fix fortify panic when copying asm exception handlers

Amit Cohen (1):
      mlxsw: spectrum: Guard against invalid local ports

Amjad Ouled-Ameur (3):
      phy: amlogic: phy-meson-gxl-usb2: fix shared reset controller use
      phy: amlogic: meson8b-usb2: Use dev_err_probe()
      phy: amlogic: meson8b-usb2: fix shared reset control use

Anatolii Gerasymenko (2):
      ice: Set txq_teid to ICE_INVAL_TEID on ring creation
      ice: Do not skip not enabled queues in ice_vc_dis_qs_msg

Andre Przywara (1):
      irqchip/gic, gic-v3: Prevent GSI to SGI translations

Andrea Parri (Microsoft) (2):
      Drivers: hv: vmbus: Fix initialization of device object in vmbus_device_register()
      Drivers: hv: vmbus: Replace smp_store_mb() with virt_store_mb()

Andrew Lunn (1):
      net: ethernet: mv643xx: Fix over zealous checking of_get_mac_address()

Andy Gospodarek (1):
      bnxt_en: reserve space inside receive page for skb_shared_info

Anisse Astier (1):
      drm: Add orientation quirk for GPD Win Max

Arnaldo Carvalho de Melo (4):
      perf build: Don't use -ffat-lto-objects in the python feature test when building with clang-13
      perf python: Fix probing for some clang command line options
      tools build: Filter out options and warnings not supported by clang
      tools build: Use $(shell ) instead of `` to get embedded libperl's ccopts

Arnd Bergmann (1):
      iwlwifi: mei: fix building iwlmei

Avraham Stern (1):
      cfg80211: don't add non transmitted BSS to 6GHz scanned channels

Axel Lin (2):
      regulator: rtq2134: Fix missing active_discharge_on setting
      regulator: atc260x: Fix missing active_discharge_on setting

Baochen Qiang (1):
      ath11k: Fix frames flush failure caused by deadlock

Ben Greear (1):
      mt76: mt7921: fix crash when startup fails.

Benjamin Beichler (1):
      um: fix and optimize xor select template for CONFIG64 and timetravel mode

Benjamin Marty (1):
      drm/amdgpu/display: change pipe policy for DCN 2.1

CHANDAN VURDIGERE NATARAJ (1):
      drm/amd/display: Fix by adding FPU protection for dcn30_internal_validate_bw

Chanho Park (1):
      arm64: Add part number for Arm Cortex-A78AE

Chen-Yu Tsai (1):
      net: stmmac: Fix unset max_speed difference between DT and non-DT platforms

ChenXiaoSong (2):
      Revert "NFSv4: Handle the special Linux file open access mode"
      NFSv4: fix open failure with O_ACCMODE flag

Christian Lamparter (1):
      ata: sata_dwc_460ex: Fix crash due to OOB write

Christian Löhle (1):
      mmc: block: Check for errors after write on SPI

Christophe JAILLET (1):
      scsi: zorro7xx: Fix a resource leak in zorro7xx_remove_one()

Christophe Leroy (3):
      powerpc/set_memory: Avoid spinlock recursion in change_page_attr()
      powerpc/64: Fix build failure with allyesconfig in book3s_64_entry.S
      static_call: Don't make __static_call_return0 static

Dale Zhao (1):
      drm/amd/display: Add signal type check when verify stream backends same

Damien Le Moal (7):
      scsi: pm8001: Fix pm80xx_pci_mem_copy() interface
      scsi: pm8001: Fix pm8001_mpi_task_abort_resp()
      scsi: pm8001: Fix tag values handling
      scsi: pm8001: Fix task leak in pm8001_send_abort_all()
      scsi: pm8001: Fix tag leaks on error
      scsi: pm8001: Fix memory leak in pm8001_chip_fw_flash_update_req()
      scsi: mpt3sas: Fix use after free in _scsih_expander_node_remove()

Dan Carpenter (1):
      drm/amdgpu: fix off by one in amdgpu_gfx_kiq_acquire()

Daniel Mack (1):
      drm/panel: ili9341: fix optional regulator handling

Daniel Thompson (1):
      drm/msm/dsi: Remove spurious IRQF_ONESHOT flag

Dave Hansen (1):
      x86/mm/tlb: Revert retpoline avoidance approach

David Ahern (1):
      ipv6: Fix stats accounting in ip6_pkt_drop

Denis Nikitin (1):
      perf session: Remap buf if there is no space for event

Deren Wu (1):
      mt76: fix monitor mode crash with sdio driver

Don Brace (1):
      scsi: smartpqi: Fix rmmod stack trace

Dongli Zhang (1):
      xen: delay xen_hvm_init_time_ops() if kdump is boot on vcpu>=32

Douglas Miller (1):
      RDMA/hfi1: Fix use-after-free bug for mm struct

Dust Li (2):
      net/smc: correct settings of RMB window update limit
      net/smc: send directly on setting TCP_NODELAY

Emily Deng (1):
      drm/amdgpu/vcn: Fix the register setting for vcn1

Eric Dumazet (5):
      ipv6: make mc_forwarding atomic
      ref_tracker: implement use-after-free detection
      net: initialize init_net earlier
      ipv6: annotate some data-races around sk->sk_prot
      rxrpc: fix a race in rxrpc_exit_net()

Eric Huang (1):
      drm/amdkfd: enable heavy-weight TLB flush on Arcturus

Ethan Lien (1):
      btrfs: fix qgroup reserve overflow the qgroup limit

Eugene Syromiatnikov (1):
      io_uring: implement compat handling for IORING_REGISTER_IOWQ_AFF

Evgeny Boger (1):
      power: supply: axp20x_battery: properly report current when discharging

Eyal Birger (1):
      vrf: fix packet sniffing for traffic originating from ip tunnels

Feng Tang (1):
      lib/Kconfig.debug: add ARCH dependency for FUNCTION_ALIGN option

Florian Westphal (1):
      netfilter: conntrack: revisit gc autotuning

Gal Pressman (1):
      net/mlx5e: Remove overzealous validations in netlink EEPROM query

Geert Uytterhoeven (1):
      spi: rpc-if: Fix RPM imbalance in probe error path

Greg Kroah-Hartman (1):
      Linux 5.17.3

Guilherme G. Piccoli (1):
      Drivers: hv: vmbus: Fix potential crash on module unload

Guo Ren (1):
      arm64: patch_text: Fixup last cpu should be master

Guo Xuenan (1):
      lz4: fix LZ4_decompress_safe_partial read out of bound

H. Nikolaus Schaller (1):
      usb: dwc3: omap: fix "unbalanced disables for smps10_out1" on omap5evm

Haimin Zhang (1):
      jfs: prevent NULL deref in diFree

Hangyu Hua (2):
      mips: ralink: fix a refcount leak in ill_acc_of_setup()
      powerpc/secvar: fix refcount leak in format_show()

Hans de Goede (5):
      power: supply: axp288-charger: Set Vhold to 4.4V
      usb: dwc3: pci: Set the swnode from inside dwc3_pci_quirks()
      power: supply: axp288_charger: Use acpi_quirk_skip_acpi_ac_and_battery()
      power: supply: axp288_fuel_gauge: Use acpi_quirk_skip_acpi_ac_and_battery()
      platform/x86: x86-android-tablets: Depend on EFI and SPI

Harold Huang (1):
      tuntap: add sanity checks about msg_controllen in sendmsg

Helge Deller (1):
      parisc: Fix CPU affinity for Lasi, WAX and Dino chips

Hou Wenlong (1):
      KVM: x86/emulator: Emulate RDPID only if it is enabled in guest

Hou Zhiqiang (1):
      PCI: endpoint: Fix alignment fault error in copy tests

Ido Schimmel (1):
      ipv4: Invalidate neighbour for broadcast address upon address addition

Ilan Peer (1):
      iwlwifi: mvm: Correctly set fragmented EBS

Ilya Leoshkevich (3):
      libbpf: Fix accessing syscall arguments on powerpc
      libbpf: Fix accessing the first syscall argument on arm64
      libbpf: Fix accessing the first syscall argument on s390

Ilya Maximets (2):
      net: openvswitch: don't send internal clone attribute to the userspace.
      net: openvswitch: fix leak of nested actions

Ivan Vecera (2):
      ice: Clear default forwarding VSI during VSI release
      ice: Fix MAC address setting

Jack Wang (1):
      RDMA/rtrs-clt: Do stop and failover outside reconnect work.

Jakub Kicinski (3):
      net: account alternate interface name memory
      net: limit altnames to 64k total
      Revert "selftests: net: Add tls config dependency for tls selftests"

Jakub Sitnicki (4):
      bpf: Make dst_port field in struct bpf_sock 16-bit wide
      bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide
      selftests/bpf: Fix u8 narrow load checks for bpf_sk_lookup remote_port
      bpf: Treat bpf_sk_lookup remote_port as a 2-byte field

James Clark (2):
      perf unwind: Don't show unwind error messages when augmenting frame pointer stack
      perf: arm-spe: Fix perf report --mem-mode

Jamie Bainbridge (2):
      sctp: count singleton chunks in assoc user stats
      qede: confirm skb is allocated before using

Jani Nikula (1):
      drm/edid: improve non-desktop quirk logging

Jason Wang (1):
      vdpa: mlx5: prevent cvq work from hogging CPU

Jean-Philippe Brucker (1):
      skbuff: fix coalescing for page_pool fragment recycling

Jedrzej Jagielski (1):
      i40e: Add sending commands in atomic context

Jens Axboe (7):
      io_uring: don't check req->file in io_fsync_prep()
      io_uring: defer splice/tee file validity check until command issue
      io_uring: fix race between timeout flush and removal
      io_uring: move read/write file prep state into actual opcode handler
      io_uring: propagate issue_flags state down to file assignment
      io_uring: defer file assignment
      io_uring: drop the old style inflight file tracking

Jeremy Sowden (1):
      netfilter: bitwise: fix reduce comparisons

Jianglei Nie (1):
      scsi: libfc: Fix use after free in fc_exch_abts_resp()

Jiasheng Jiang (2):
      rtc: wm8350: Handle error for wm8350_register_irq
      drm/imx: imx-ldb: Check for null pointer after calling kmemdup

Jim Mattson (2):
      KVM: x86/pmu: Use different raw event masks for AMD and Intel
      KVM: x86/svm: Clear reserved bits written to PerfEvtSeln MSRs

Jiri Kosina (1):
      rtw89: fix RCU usage in rtw89_core_txq_push()

Jiri Slaby (1):
      serial: samsung_tty: do not unlock port->lock for uart_write_wakeup()

Johan Almbladh (1):
      mt76: mt7915: fix injected MPDU transmission to not use HW A-MSDU

Johannes Berg (1):
      lib/logic_iomem: correct fallback config references

Johannes Thumshirn (1):
      btrfs: zoned: traverse devices under chunk_mutex in btrfs_can_activate_zone

John David Anglin (1):
      parisc: Fix patch code locking and flushing

John Garry (1):
      scsi: core: Fix sbitmap depth in scsi_realloc_sdev_budget_map()

Jordy Zomer (1):
      dm ioctl: prevent potential spectre v1 gadget

Jorge Lopez (2):
      platform/x86: hp-wmi: Fix SW_TABLET_MODE detection method
      platform/x86: hp-wmi: Fix 0x05 error code reported by several WMI calls

José Expósito (4):
      HID: apple: Report Magic Keyboard 2021 battery over USB
      HID: apple: Report Magic Keyboard 2021 with fingerprint reader battery over USB
      clk: mediatek: Fix memory leaks on probe
      drm/imx: Fix memory leak in imx_pd_connector_get_modes

Jue Wang (1):
      x86/mce: Work around an erratum on fast string copy instructions

Juergen Gross (1):
      xen/usb: harden xen_hcd against malicious backends

Jérôme Pouiller (1):
      staging: wfx: apply the necessary SDIO quirks for the Silabs WF200

Kaiwen Hu (1):
      btrfs: prevent subvol with swapfile from being deleted

Kalle Valo (2):
      ath11k: pci: fix crash on suspend if board file is not found
      ath11k: mhi: use mhi_sync_power_up()

Kamal Dasu (1):
      spi: bcm-qspi: fix MSPI only access with bcm_qspi_exec_mem_op()

Kan Liang (2):
      perf/x86/intel: Update the FRONTEND MSR mask on Sapphire Rapids
      perf/x86/intel: Don't extend the pseudo-encoding to GP counters

Karol Herbst (1):
      drm/nouveau/pmu: Add missing callbacks for Tegra devices

Kefeng Wang (2):
      powerpc: Fix virt_addr_valid() for 64-bit Book3E & 32-bit
      Revert "powerpc: Set max_mapnr correctly"

Kevin Groeneveld (1):
      scsi: sr: Fix typo in CDROM(CLOSETRAY|EJECT) handling

Kevin Tang (2):
      drm/sprd: fix potential NULL dereference
      drm/sprd: check the platform_get_resource() return value

Krzysztof Kozlowski (1):
      MIPS: ingenic: correct unit node address

Lee Jones (1):
      drm/amdkfd: Create file descriptor after client is added to smi_clients list

Li Chen (1):
      PCI: endpoint: Fix misused goto label

Like Xu (1):
      KVM: x86/pmu: Fix and isolate TSX-specific performance event logic

Liu Ying (1):
      drm/imx: dw_hdmi-imx: Fix bailout in error cases of probe

Lorenzo Bianconi (1):
      mt76: dma: initialize skip_unmap in mt76_dma_rx_fill

Luca Coelho (1):
      iwlwifi: fix small doc mistake for iwl_fw_ini_addr_val

Lucas Denefle (1):
      w1: w1_therm: fixes w1_seq for ds28ea00 sensors

Luiz Augusto von Dentz (4):
      Bluetooth: hci_sync: Fix compilation warning
      Bluetooth: hci_sync: Fix queuing commands when HCI_UNREGISTER is set
      Bluetooth: Fix not checking for valid hdev on bt_dev_{info,warn,err,dbg}
      Bluetooth: Fix use after free in hci_send_acl

Lv Yunlong (1):
      drbd: Fix five use after free bugs in get_initial_state

Maciej Fijalkowski (3):
      ice: synchronize_rcu() when terminating rings
      ice: xsk: fix VSI state check in ice_xsk_wakeup()
      ice: clear cmd_type_offset_bsz for TX rings

Magnus Karlsson (1):
      selftests, xsk: Fix bpf_res cleanup test

Mahesh Rajashekhara (1):
      scsi: smartpqi: Fix kdump issue when controller is locked up

Manish Chopra (1):
      qed: fix ethtool register dump

Manivannan Sadhasivam (1):
      PCI: pciehp: Add Qualcomm quirk for Command Completed erratum

Marc Zyngier (3):
      KVM: arm64: Do not change the PMU event filter after a VCPU has run
      irqchip/gic-v3: Fix GICR_CTLR.RWP polling
      irqchip/gic-v4: Wait for GICR_VPENDBASER.Dirty to clear before descheduling

Mark Pearson (1):
      platform/x86: thinkpad_acpi: Add dual fan probe

Mark Zhang (1):
      IB/cm: Cancel mad on the DREQ event when the state is MRA_REP_RCVD

Martin Habets (1):
      sfc: Do not free an empty page_ring

Martin K. Petersen (1):
      scsi: sd: sd_read_cpr() requires VPD pages

Mateusz Palczewski (1):
      iavf: stop leaking iavf_status as "errno" values

Matt Johnston (3):
      mctp: make __mctp_dev_get() take a refcount hold
      mctp: Fix check for dev_hard_header() result
      mctp: Use output netdev to allocate skb headroom

Mauricio Faria de Oliveira (1):
      mm: fix race between MADV_FREE reclaim and blkdev direct IO read

Max Filippov (2):
      xtensa: fix DTC warning unit_address_format
      highmem: fix checks in __kmap_local_sched_{in,out}

Maxim Kiselev (1):
      powerpc: dts: t104xrdb: fix phy type for FMAN 4/5

Maxim Mikityanskiy (2):
      net/mlx5e: Disable TX queues before registering the netdev
      bpf: Support dual-stack sockets in bpf_tcp_check_syncookie

Maxime Ripard (1):
      clk: Enforce that disjoints limits are invalid

Meenakshikumar Somasundaram (1):
      drm/amd/display: Fix for dmub outbox notification enable

Miaohe Lin (1):
      mm/mempolicy: fix mpol_new leak in shared_policy_replace

Miaoqian Lin (1):
      dpaa2-ptp: Fix refcount leak in dpaa2_ptp_probe

Michael Chan (1):
      bnxt_en: Eliminate unintended link toggle during FW reset

Michael Ellerman (2):
      powerpc/code-patching: Pre-map patch area
      powerpc/64e: Tie PPC_BOOK3E_64 to PPC_FSL_BOOK3E

Michael T. Kloos (1):
      riscv: Fixed misaligned memory access. Fixed pointer comparison.

Michael Walle (2):
      net: sfp: add 2500base-X quirk for Lantech SFP module
      net: phy: mscc-miim: reject clause 45 register accesses

Michael Wu (1):
      mmc: core: Fixup support for writeback-cache for eMMC and SD

Mike Snitzer (1):
      dm: requeue IO if mapping table not yet available

Minghao Chi (CGEL ZTE) (1):
      Bluetooth: use memset avoid memory leaks

Miri Korenblit (1):
      iwlwifi: mvm: move only to an enabled channel

Muchun Song (1):
      mm: kfence: fix objcgs vector allocation

Namhyung Kim (1):
      perf/core: Inherit event_caps

Naresh Kamboju (1):
      selftests: net: Add tls config dependency for tls selftests

Nathan Chancellor (1):
      x86/Kconfig: Do not allow CONFIG_X86_X32_ABI=y with llvm-objcopy

Neal Liu (1):
      usb: ehci: add pci device support for Aspeed platforms

NeilBrown (4):
      SUNRPC/xprt: async tasks mustn't block waiting for memory
      SUNRPC: remove scheduling boost for "SWAPPER" tasks.
      NFS: swap IO handling is slightly different for O_DIRECT IO
      NFS: swap-out must always use STABLE writes.

Nicholas Kazlauskas (1):
      drm/amd/display: Use PSR version selected during set_psr_caps

Nicholas Piggin (1):
      powerpc/64s/hash: Make hash faults work in NMI context

Nick Desaulniers (1):
      x86/extable: Prefer local labels in .set directives

Niels Dossche (1):
      IB/rdmavt: add lock to call to rvt_error_qp to prevent a race condition

Nikolay Aleksandrov (1):
      net: ipv4: fix route with nexthop object delete warning

Oded Gabbay (2):
      habanalabs: reject host map with mmu disabled
      habanalabs/gaudi: handle axi errors from NIC engines

Ohad Sharabi (1):
      habanalabs: fix possible memory leak in MMU DR fini

Oliver Hartkopp (1):
      can: isotp: set default value for N_As to 50 micro seconds

Pali Rohár (2):
      PCI: aardvark: Fix support for MSI interrupts
      Revert "mmc: sdhci-xenon: fix annoying 1.8V regulator warning"

Paolo Bonzini (2):
      mmmremap.c: avoid pointless invalidate_range_start/end on mremap(old_size=0)
      KVM: avoid NULL pointer dereference in kvm_dirty_ring_push

Paulo Alcantara (2):
      cifs: fix potential race with cifsd thread
      cifs: force new session setup and tcon for dfs

Pavan Chebbi (1):
      bnxt_en: Synchronize tx when xdp redirects happen on same ring

Pavel Begunkov (2):
      io_uring: nospec index for tags on files update
      io_uring: don't touch scm_fp_list after queueing skb

Pawan Gupta (2):
      x86/pm: Save the MSR validity status at context setup
      x86/speculation: Restore speculation related MSRs during S3 resume

Pawel Laszczak (1):
      usb: cdnsp: fix cdnsp_decode_trb function to properly handle ret value

Peter Gonda (1):
      KVM: SVM: Fix kvm_cache_regs.h inclusions for is_guest_mode()

Peter Zijlstra (4):
      x86: Annotate call_on_stack()
      objtool: Fix SLS validation for kcov tail-call replacement
      sched/core: Fix forceidle balancing
      x86,static_call: Fix __static_call_return0 for i386

Phil Auld (1):
      arch/arm64: Fix topology initialization for core scheduling

Philip Yang (4):
      drm/amdkfd: Don't take process mutex for svm ioctls
      drm/amdkfd: Ensure mm remain valid in svm deferred_list work
      drm/amdkfd: svm range restore work deadlock when process exit
      drm/amdkfd: Fix variable set but not used warning

Philipp Zabel (1):
      drm/edid: remove non_desktop quirk for HPN-3515 and LEN-B800.

Pierre Gondois (1):
      cpufreq: CPPC: Fix performance/frequency conversion

Ping-Ke Shih (1):
      rtw88: change rtw_info() to proper message level

Qi Liu (1):
      scsi: hisi_sas: Free irq vectors in order for v3 HW

Qinghua Jin (1):
      minix: fix bug when opening a file with O_DIRECT

Qu Wenruo (2):
      btrfs: remove device item and update super block in the same transaction
      btrfs: avoid defragging extents whose next extents are not targets

Rajneesh Bhardwaj (1):
      drm/amdgpu: Fix recursive locking warning

Randy Dunlap (3):
      scsi: aha152x: Fix aha152x_setup() __setup handler return value
      init/main.c: return 1 from handled __setup() functions
      virtio_console: eliminate anonymous module_init & module_exit

Ray Jui (1):
      bnxt_en: Prevent XDP redirect from running when stopping TX queue

Reto Buerki (1):
      x86/msi: Fix msi message data shadow struct

Ricardo Koller (5):
      kvm: selftests: aarch64: fix assert in gicv3_access_reg
      kvm: selftests: aarch64: pass vgic_irq guest args as a pointer
      kvm: selftests: aarch64: fix the failure check in kvm_set_gsi_routing_irqchip_check
      kvm: selftests: aarch64: fix some vgic related comments
      kvm: selftests: aarch64: use a tighter assert in vgic_poke_irq()

Roi Dayan (1):
      net/mlx5e: TC, Hold sample_attr on stack instead of pointer

Roman Li (1):
      drm/amd/display: Remove redundant dsc power gating from init_hw

Sachin Sant (1):
      powerpc/xive: Export XIVE IPI information for online-only processors.

Sascha Hauer (1):
      clk: rockchip: drop CLK_SET_RATE_PARENT from dclk_vop* on rk3568

Sean Wang (1):
      Bluetooth: mediatek: fix the conflict between mtk and msft vendor event

Sebastian Andrzej Siewior (2):
      tcp: Don't acquire inet_listen_hashbucket::lock with disabled BH.
      sched: Teach the forced-newidle balancer about CPU affinity limitation.

Shirish S (1):
      amd/display: set backlight only if required

Shreeya Patel (1):
      gpio: Restrict usage of GPIO chip irq members before initialization

Soenke Huster (2):
      Bluetooth: fix null ptr deref on hci_sync_conn_complete_evt
      Bluetooth: hci_event: Ignore multiple conn complete events

Sourabh Jain (1):
      powerpc: Set crashkernel offset to mid of RMA region

Sreekanth Reddy (3):
      scsi: mpi3mr: Fix deadlock while canceling the fw event
      scsi: mpi3mr: Fix reporting of actual data transfer size
      scsi: mpi3mr: Fix memory leaks

Stefan Wahren (2):
      staging: vchiq_arm: Avoid NULL ptr deref in vchiq_dump_platform_instances
      staging: vchiq_core: handle NULL result of find_service_by_handle

Sung Joon Kim (1):
      drm/amd/display: reset lane settings after each PHY repeater LT

Sven Eckelmann (1):
      macvtap: advertise link netns via netlink

Taehee Yoo (2):
      net: sfc: add missing xdp queue reinitialization
      net: sfc: fix using uninitialized xdp tx_queue

Thomas Zimmermann (1):
      fbdev: Fix unregistering of framebuffers without device

Tianci.Yin (1):
      drm/amdgpu: Fix an error message in rmmod

Tomas Henzl (1):
      scsi: core: scsi_logging: Fix a BUG

Tony Lindgren (2):
      clk: ti: Preserve node in ti_dt_clocks_register()
      iommu/omap: Fix regression in probe for NULL pointer dereference

Tony Lu (1):
      net/smc: Send directly when TCP_CORK is cleared

Trond Myklebust (8):
      NFSv4: Protect the state recovery thread against direct reclaim
      SUNRPC: Fix socket waits for write buffer space
      NFS: nfsiod should not block forever in mempool_alloc()
      NFS: Avoid writeback threads getting stuck in mempool_alloc()
      SUNRPC: Handle ENOMEM in call_transmit_status()
      SUNRPC: Handle low memory situations in call_status()
      SUNRPC: svc_tcp_sendmsg() should handle errors from xdr_alloc_bvec()
      SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()

Venkateswara Naralasetty (1):
      ath11k: fix kernel panic during unload/load ath11k modules

Vincent Mailhol (2):
      can: etas_es58x: es58x_fd_rx_event_msg(): initialize rx_event_msg before calling es58x_check_msg_len()
      x86/bug: Prevent shadowing in __WARN_FLAGS

Vinod Koul (2):
      spi: core: add dma_map_dev for __spi_unmap_msg()
      dmaengine: Revert "dmaengine: shdma: Fix runtime PM imbalance on error"

Viresh Kumar (1):
      opp: Expose of-node's name in debugfs

Vladimir Oltean (1):
      Revert "net: dsa: stop updating master MTU from master.c"

Waiman Long (1):
      mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning

Wang Yufen (1):
      netlabel: fix out-of-bounds memory accesses

Wayne Chang (2):
      usb: gadget: tegra-xudc: Do not program SPARAM
      usb: gadget: tegra-xudc: Fix control endpoint's definitions

Wolfram Sang (2):
      mmc: renesas_sdhi: special 4tap settings only apply to HS400
      mmc: renesas_sdhi: don't overwrite TAP settings when HS400 tuning is complete

Xiang Chen (1):
      scsi: hisi_sas: Limit users changing debugfs BIST count value

Xiaoke Wang (1):
      staging: wfx: fix an error handling in wfx_init_common()

Xiaomeng Tong (3):
      scsi: ufs: ufshpb: Fix a NULL check on list iterator
      drbd: fix an invalid memory access caused by incorrect use of list iterator
      perf: qcom_l2_pmu: fix an incorrect NULL check on list iterator

Xin Xiong (2):
      drm/amd/amdgpu/amdgpu_cs: fix refcount leak of a dma_fence obj
      NFSv4.2: fix reference count leaks in _nfs42_proc_copy_notify()

Xiubo Li (2):
      ceph: fix inode reference leakage in ceph_get_snapdir()
      ceph: fix memory leak in ceph_readdir when note_last_dentry returns error

Yang Guang (3):
      ptp: replace snprintf with sysfs_emit
      scsi: mvsas: Replace snprintf() with sysfs_emit()
      scsi: bfa: Replace snprintf() with sysfs_emit()

Yang Li (1):
      mt76: mt7615: Fix assigning negative values to unsigned variable

Yann Gautier (1):
      mmc: mmci: stm32: correctly check all elements of sg list

Yonghong Song (1):
      libbpf: Fix build issue with llvm-readelf

Yongzhi Liu (3):
      drm/amd/display: Fix memory leak
      drm/bridge: Add missing pm_runtime_put_sync
      drm/v3d: fix missing unlock

Zekun Shen (1):
      ath5k: fix OOB in ath5k_eeprom_read_pcal_info_5111

Zheng Yongjun (1):
      net: dsa: felix: fix possible NULL pointer dereference

Zhou Guanghui (1):
      iommu/arm-smmu-v3: fix event handling soft lockup

Ziyang Xuan (1):
      net/tls: fix slab-out-of-bounds bug in decrypt_internal

