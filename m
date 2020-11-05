Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A40E2A7EB1
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 13:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgKEMfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 07:35:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730344AbgKEMfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 07:35:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 857702078E;
        Thu,  5 Nov 2020 12:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604579747;
        bh=dYGNJTInWm30u9hLSleZk5Fsx2et1+g6wgSDt5T3jHQ=;
        h=From:To:Cc:Subject:Date:From;
        b=0QL7jjro98BhueAiJh9eAfeSHUQoi8J1nl39tHs3NTrWQHcIYN6TJUVSv8xkTm5rp
         pldofdMiajmiWCCEzkHVrrdc9JtSpPj2beNl/ursds4br1P2o0LkALrfTMDdlUd4HK
         94sH/gRLD9jaPdSclTQS2aLjB0q18Ss6qe5oRu+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.9.5
Date:   Thu,  5 Nov 2020 13:36:29 +0100
Message-Id: <160457978922441@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.9.5 kernel.

All users of the 5.9 kernel series must upgrade.

The updated 5.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt                 |    8 
 Documentation/devicetree/bindings/soc/ti/k3-ringacc.yaml        |    6 
 Documentation/userspace-api/media/v4l/colorspaces-defs.rst      |    9 
 Documentation/userspace-api/media/v4l/colorspaces-details.rst   |    5 
 Makefile                                                        |    2 
 arch/Kconfig                                                    |    7 
 arch/arc/boot/dts/axc001.dtsi                                   |    2 
 arch/arc/boot/dts/axc003.dtsi                                   |    2 
 arch/arc/boot/dts/axc003_idu.dtsi                               |    2 
 arch/arc/boot/dts/vdk_axc003.dtsi                               |    2 
 arch/arc/boot/dts/vdk_axc003_idu.dtsi                           |    2 
 arch/arc/kernel/perf_event.c                                    |   27 
 arch/arm/Kconfig                                                |    2 
 arch/arm/boot/dts/aspeed-g5.dtsi                                |    1 
 arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts                   |    1 
 arch/arm/boot/dts/omap4.dtsi                                    |    2 
 arch/arm/boot/dts/omap443x.dtsi                                 |   10 
 arch/arm/boot/dts/s5pv210-aries.dtsi                            |   26 
 arch/arm/boot/dts/s5pv210-fascinate4g.dts                       |   98 ++
 arch/arm/boot/dts/s5pv210-galaxys.dts                           |   85 ++
 arch/arm/boot/dts/s5pv210.dtsi                                  |  163 +--
 arch/arm/configs/aspeed_g4_defconfig                            |    3 
 arch/arm/configs/aspeed_g5_defconfig                            |    3 
 arch/arm/kernel/hw_breakpoint.c                                 |  100 +-
 arch/arm/plat-samsung/Kconfig                                   |    1 
 arch/arm64/Kconfig.platforms                                    |    1 
 arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7-emmc.dts |   10 
 arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7.dts      |   10 
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi        |   12 
 arch/arm64/boot/dts/qcom/msm8994-sony-xperia-kitakami.dtsi      |    7 
 arch/arm64/boot/dts/renesas/ulcb.dtsi                           |    1 
 arch/arm64/include/asm/kvm_host.h                               |    1 
 arch/arm64/include/asm/numa.h                                   |    3 
 arch/arm64/kernel/efi-header.S                                  |    2 
 arch/arm64/kernel/topology.c                                    |   32 
 arch/arm64/kvm/sys_regs.c                                       |    6 
 arch/arm64/lib/memcpy.S                                         |    3 
 arch/arm64/lib/memmove.S                                        |    3 
 arch/arm64/lib/memset.S                                         |    3 
 arch/arm64/mm/numa.c                                            |    6 
 arch/ia64/kernel/Makefile                                       |    2 
 arch/ia64/kernel/kprobes.c                                      |   77 -
 arch/mips/configs/qi_lb60_defconfig                             |    1 
 arch/mips/dec/setup.c                                           |    9 
 arch/powerpc/Kconfig                                            |   14 
 arch/powerpc/include/asm/drmem.h                                |    4 
 arch/powerpc/include/asm/mmu_context.h                          |    2 
 arch/powerpc/kernel/head_32.S                                   |    8 
 arch/powerpc/kernel/head_32.h                                   |   72 -
 arch/powerpc/kernel/mce.c                                       |    7 
 arch/powerpc/kernel/process.c                                   |   16 
 arch/powerpc/kernel/ptrace/ptrace-noadv.c                       |    2 
 arch/powerpc/kernel/rtas.c                                      |  153 +++
 arch/powerpc/kernel/sysfs.c                                     |   42 
 arch/powerpc/kernel/traps.c                                     |    2 
 arch/powerpc/kvm/book3s_hv.c                                    |   13 
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                         |    8 
 arch/powerpc/mm/hugetlbpage.c                                   |   18 
 arch/powerpc/mm/init_64.c                                       |   35 
 arch/powerpc/platforms/powermac/sleep.S                         |    9 
 arch/powerpc/platforms/powernv/opal-elog.c                      |   33 
 arch/powerpc/platforms/powernv/smp.c                            |    2 
 arch/powerpc/platforms/pseries/hotplug-memory.c                 |   43 -
 arch/riscv/include/uapi/asm/auxvec.h                            |    3 
 arch/s390/boot/head.S                                           |   21 
 arch/s390/kernel/time.c                                         |  118 ++
 arch/sparc/kernel/smp_64.c                                      |   65 -
 arch/um/kernel/sigio.c                                          |    6 
 arch/x86/boot/compressed/kaslr.c                                |   41 
 arch/x86/events/amd/ibs.c                                       |   38 
 arch/x86/events/amd/uncore.c                                    |   28 
 arch/x86/events/core.c                                          |    4 
 arch/x86/events/intel/core.c                                    |    2 
 arch/x86/include/asm/asm-prototypes.h                           |    1 
 arch/x86/include/asm/msr-index.h                                |    1 
 arch/x86/kernel/alternative.c                                   |    9 
 arch/x86/kernel/unwind_orc.c                                    |    9 
 arch/x86/kvm/x86.c                                              |    8 
 block/bio.c                                                     |   11 
 block/blk-mq.c                                                  |    2 
 drivers/acpi/acpi_configfs.c                                    |    1 
 drivers/acpi/acpi_dbg.c                                         |    3 
 drivers/acpi/acpi_extlog.c                                      |    6 
 drivers/acpi/button.c                                           |   13 
 drivers/acpi/ec.c                                               |   10 
 drivers/acpi/numa/hmat.c                                        |    3 
 drivers/acpi/numa/srat.c                                        |    2 
 drivers/acpi/pci_mcfg.c                                         |   20 
 drivers/acpi/video_detect.c                                     |    9 
 drivers/ata/sata_nv.c                                           |    2 
 drivers/base/core.c                                             |    4 
 drivers/base/firmware_loader/main.c                             |    5 
 drivers/base/power/runtime.c                                    |    5 
 drivers/block/nbd.c                                             |    2 
 drivers/block/null_blk.h                                        |    1 
 drivers/block/null_blk_zoned.c                                  |  157 ++-
 drivers/block/xen-blkback/blkback.c                             |   22 
 drivers/block/xen-blkback/xenbus.c                              |    5 
 drivers/bus/fsl-mc/mc-io.c                                      |    7 
 drivers/bus/mhi/core/pm.c                                       |    6 
 drivers/clk/ti/clockdomain.c                                    |    2 
 drivers/cpufreq/Kconfig                                         |    2 
 drivers/cpufreq/acpi-cpufreq.c                                  |    3 
 drivers/cpufreq/cpufreq.c                                       |   15 
 drivers/cpufreq/intel_pstate.c                                  |   13 
 drivers/cpufreq/sti-cpufreq.c                                   |    6 
 drivers/cpuidle/cpuidle-tegra.c                                 |   34 
 drivers/dma/dma-jz4780.c                                        |    7 
 drivers/extcon/extcon-ptn5150.c                                 |    8 
 drivers/firmware/arm_scmi/base.c                                |    2 
 drivers/firmware/arm_scmi/bus.c                                 |    6 
 drivers/firmware/arm_scmi/clock.c                               |    2 
 drivers/firmware/arm_scmi/common.h                              |    5 
 drivers/firmware/arm_scmi/driver.c                              |   24 
 drivers/firmware/arm_scmi/notify.c                              |   22 
 drivers/firmware/arm_scmi/perf.c                                |    2 
 drivers/firmware/arm_scmi/reset.c                               |    4 
 drivers/firmware/arm_scmi/sensors.c                             |    2 
 drivers/firmware/arm_scmi/smc.c                                 |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c                         |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                      |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c                         |   10 
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c                         |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                         |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c                         |   13 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c                        |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h                        |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c                       |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                         |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c                         |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h                         |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h                          |    4 
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                          |   72 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c                          |   24 
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c                           |   28 
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.h                           |    3 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v10.c       |    5 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c               |    7 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dce112/dce112_clk_mgr.c  |    3 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c       |    7 
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                   |    2 
 drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h             |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c     |    4 
 drivers/gpu/drm/amd/display/dc/gpio/gpio_base.c                 |    4 
 drivers/gpu/drm/amd/display/dc/os_types.h                       |    2 
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c                |    2 
 drivers/gpu/drm/amd/powerplay/inc/smu_types.h                   |    1 
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c                      |   26 
 drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c              |    6 
 drivers/gpu/drm/ast/ast_drv.c                                   |   59 -
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c        |   12 
 drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c                   |    9 
 drivers/gpu/drm/drm_bridge_connector.c                          |    1 
 drivers/gpu/drm/drm_gem.c                                       |    4 
 drivers/gpu/drm/drm_gem_shmem_helper.c                          |    7 
 drivers/gpu/drm/exynos/exynos_drm_g2d.c                         |   10 
 drivers/gpu/drm/i915/i915_drv.h                                 |    6 
 drivers/gpu/drm/lima/lima_gem.c                                 |   11 
 drivers/gpu/drm/lima/lima_vm.c                                  |    5 
 drivers/gpu/drm/panfrost/panfrost_gem.c                         |    4 
 drivers/gpu/drm/panfrost/panfrost_mmu.c                         |    7 
 drivers/gpu/drm/scheduler/sched_main.c                          |    4 
 drivers/gpu/drm/ttm/ttm_bo.c                                    |    2 
 drivers/gpu/drm/vkms/vkms_crtc.c                                |    5 
 drivers/hid/wacom_wac.c                                         |    4 
 drivers/hwmon/pmbus/max34440.c                                  |   23 
 drivers/hwtracing/coresight/coresight-cti-sysfs.c               |    7 
 drivers/hwtracing/coresight/coresight-priv.h                    |    3 
 drivers/hwtracing/coresight/coresight.c                         |   62 -
 drivers/i2c/busses/i2c-imx.c                                    |   24 
 drivers/idle/intel_idle.c                                       |    9 
 drivers/iio/adc/ad7292.c                                        |    4 
 drivers/iio/adc/at91-sama5d2_adc.c                              |   16 
 drivers/iio/adc/rcar-gyroadc.c                                  |   21 
 drivers/iio/adc/ti-adc0832.c                                    |   11 
 drivers/iio/adc/ti-adc12138.c                                   |   13 
 drivers/iio/gyro/itg3200_buffer.c                               |   15 
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h                       |   12 
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c                      |   12 
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h                         |    6 
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c                  |   42 
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c                    |    2 
 drivers/iio/light/si1145.c                                      |   19 
 drivers/iio/temperature/ltc2983.c                               |   19 
 drivers/infiniband/core/rdma_core.c                             |   30 
 drivers/infiniband/hw/mlx5/main.c                               |    6 
 drivers/infiniband/hw/qedr/qedr_iw_cm.c                         |    1 
 drivers/input/serio/hil_mlc.c                                   |   21 
 drivers/input/serio/hp_sdc_mlc.c                                |    8 
 drivers/interconnect/qcom/sdm845.c                              |    2 
 drivers/irqchip/irq-loongson-htvec.c                            |    4 
 drivers/leds/leds-bcm6328.c                                     |    2 
 drivers/leds/leds-bcm6358.c                                     |    2 
 drivers/md/md-bitmap.c                                          |    2 
 drivers/md/md.c                                                 |    2 
 drivers/md/raid5.c                                              |    4 
 drivers/media/i2c/imx274.c                                      |    8 
 drivers/media/pci/tw5864/tw5864-video.c                         |    6 
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c                 |    7 
 drivers/media/usb/uvc/uvc_ctrl.c                                |   27 
 drivers/memory/brcmstb_dpfe.c                                   |   16 
 drivers/memory/emif.c                                           |   33 
 drivers/memory/tegra/tegra124.c                                 |    1 
 drivers/message/fusion/mptscsih.c                               |   13 
 drivers/misc/fastrpc.c                                          |    4 
 drivers/misc/habanalabs/gaudi/gaudi_security.c                  |   55 -
 drivers/mmc/host/sdhci-acpi.c                                   |   37 
 drivers/mmc/host/sdhci-esdhc.h                                  |    2 
 drivers/mmc/host/sdhci-of-esdhc.c                               |   28 
 drivers/mmc/host/sdhci-pci-core.c                               |  154 +++
 drivers/mmc/host/sdhci.c                                        |    6 
 drivers/mmc/host/via-sdmmc.c                                    |    3 
 drivers/mtd/ubi/wl.c                                            |   13 
 drivers/net/can/flexcan.c                                       |   30 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                       |    6 
 drivers/net/ethernet/marvell/octeontx2/af/npc.h                 |    4 
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h              |    5 
 drivers/net/ethernet/mellanox/mlxsw/core.c                      |    3 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                 |    1 
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c                |   13 
 drivers/net/ethernet/pensando/ionic/ionic_txrx.h                |    1 
 drivers/net/wan/hdlc_fr.c                                       |   98 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c                        |   16 
 drivers/net/wireless/ath/ath10k/mac.c                           |    5 
 drivers/net/wireless/ath/ath10k/sdio.c                          |    4 
 drivers/net/wireless/ath/ath11k/dp_rx.c                         |    2 
 drivers/net/wireless/ath/ath11k/dp_tx.c                         |    4 
 drivers/net/wireless/ath/ath11k/reg.c                           |    6 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c         |   10 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c         |    1 
 drivers/net/xen-netback/common.h                                |   15 
 drivers/net/xen-netback/interface.c                             |   61 +
 drivers/net/xen-netback/netback.c                               |   11 
 drivers/net/xen-netback/rx.c                                    |   13 
 drivers/nfc/s3fwrn5/Kconfig                                     |    1 
 drivers/nvme/host/rdma.c                                        |    1 
 drivers/pci/controller/dwc/pcie-qcom.c                          |   13 
 drivers/pci/ecam.c                                              |   10 
 drivers/pci/pci-acpi.c                                          |   10 
 drivers/power/supply/bq27xxx_battery.c                          |    6 
 drivers/power/supply/test_power.c                               |    6 
 drivers/remoteproc/remoteproc_debugfs.c                         |    2 
 drivers/rpmsg/qcom_glink_native.c                               |    6 
 drivers/rtc/rtc-rx8010.c                                        |   24 
 drivers/s390/crypto/ap_bus.h                                    |    1 
 drivers/s390/crypto/ap_queue.c                                  |    8 
 drivers/s390/crypto/zcrypt_debug.h                              |    8 
 drivers/s390/crypto/zcrypt_error.h                              |   88 --
 drivers/s390/crypto/zcrypt_msgtype50.c                          |   50 -
 drivers/s390/crypto/zcrypt_msgtype6.c                           |   92 +-
 drivers/scsi/qla2xxx/qla_attr.c                                 |   10 
 drivers/scsi/qla2xxx/qla_gbl.h                                  |    1 
 drivers/scsi/qla2xxx/qla_init.c                                 |    2 
 drivers/scsi/qla2xxx/qla_isr.c                                  |    2 
 drivers/scsi/qla2xxx/qla_target.c                               |   13 
 drivers/scsi/qla2xxx/qla_tmpl.c                                 |   49 -
 drivers/scsi/scsi_lib.c                                         |   22 
 drivers/scsi/sd.c                                               |   27 
 drivers/scsi/sr.c                                               |   16 
 drivers/soc/qcom/rpmh-internal.h                                |    4 
 drivers/soc/qcom/rpmh-rsc.c                                     |  115 +-
 drivers/soc/ti/k3-ringacc.c                                     |   33 
 drivers/spi/spi-mtk-nor.c                                       |    6 
 drivers/spi/spi-sprd.c                                          |    2 
 drivers/staging/comedi/drivers/cb_pcidas.c                      |    1 
 drivers/staging/fieldbus/anybuss/arcx-anybus.c                  |    2 
 drivers/staging/octeon/ethernet-mdio.c                          |    6 
 drivers/staging/octeon/ethernet-rx.c                            |   34 
 drivers/staging/octeon/ethernet.c                               |    9 
 drivers/staging/wfx/sta.c                                       |   28 
 drivers/tee/tee_core.c                                          |    3 
 drivers/tty/serial/21285.c                                      |   12 
 drivers/tty/serial/fsl_lpuart.c                                 |   13 
 drivers/tty/vt/keyboard.c                                       |   39 
 drivers/tty/vt/vt_ioctl.c                                       |   47 -
 drivers/uio/uio.c                                               |    4 
 drivers/usb/cdns3/ep0.c                                         |   65 -
 drivers/usb/cdns3/gadget.c                                      |  102 +-
 drivers/usb/cdns3/gadget.h                                      |    3 
 drivers/usb/class/cdc-acm.c                                     |   12 
 drivers/usb/class/cdc-acm.h                                     |    3 
 drivers/usb/core/driver.c                                       |   30 
 drivers/usb/core/generic.c                                      |    4 
 drivers/usb/core/usb.h                                          |    2 
 drivers/usb/dwc3/core.c                                         |   21 
 drivers/usb/dwc3/core.h                                         |    1 
 drivers/usb/dwc3/dwc3-pci.c                                     |    3 
 drivers/usb/dwc3/ep0.c                                          |   27 
 drivers/usb/dwc3/gadget.c                                       |   70 +
 drivers/usb/dwc3/gadget.h                                       |    1 
 drivers/usb/host/ehci-tegra.c                                   |    4 
 drivers/usb/host/fsl-mph-dr-of.c                                |    9 
 drivers/usb/host/xhci-pci.c                                     |   17 
 drivers/usb/host/xhci.c                                         |    7 
 drivers/usb/host/xhci.h                                         |    1 
 drivers/usb/misc/adutux.c                                       |    1 
 drivers/usb/misc/apple-mfi-fastcharge.c                         |   17 
 drivers/usb/typec/tcpm/tcpm.c                                   |    8 
 drivers/vdpa/mlx5/core/mr.c                                     |    5 
 drivers/vdpa/vdpa_sim/vdpa_sim.c                                |    7 
 drivers/vhost/vdpa.c                                            |  129 +--
 drivers/vhost/vringh.c                                          |    9 
 drivers/video/fbdev/pvr2fb.c                                    |    2 
 drivers/w1/masters/mxc_w1.c                                     |   14 
 drivers/watchdog/rdc321x_wdt.c                                  |    5 
 drivers/xen/events/events_2l.c                                  |    9 
 drivers/xen/events/events_base.c                                |  423 +++++++++-
 drivers/xen/events/events_fifo.c                                |   83 -
 drivers/xen/events/events_internal.h                            |   20 
 drivers/xen/evtchn.c                                            |    7 
 drivers/xen/gntdev-dmabuf.c                                     |   13 
 drivers/xen/pvcalls-back.c                                      |   76 +
 drivers/xen/xen-pciback/pci_stub.c                              |   13 
 drivers/xen/xen-pciback/pciback.h                               |   12 
 drivers/xen/xen-pciback/pciback_ops.c                           |   48 -
 drivers/xen/xen-pciback/xenbus.c                                |    2 
 drivers/xen/xen-scsiback.c                                      |   23 
 fs/9p/vfs_file.c                                                |    4 
 fs/afs/dir.c                                                    |   12 
 fs/afs/dir_edit.c                                               |    6 
 fs/afs/file.c                                                   |   77 +
 fs/afs/internal.h                                               |   57 +
 fs/afs/server.c                                                 |    7 
 fs/afs/write.c                                                  |  105 +-
 fs/afs/xattr.c                                                  |    2 
 fs/btrfs/block-group.c                                          |    1 
 fs/btrfs/ctree.c                                                |    6 
 fs/btrfs/ctree.h                                                |    4 
 fs/btrfs/delayed-inode.c                                        |    3 
 fs/btrfs/dev-replace.c                                          |    7 
 fs/btrfs/disk-io.c                                              |    8 
 fs/btrfs/extent-tree.c                                          |    7 
 fs/btrfs/inode.c                                                |    2 
 fs/btrfs/ioctl.c                                                |    6 
 fs/btrfs/reada.c                                                |   47 +
 fs/btrfs/reflink.c                                              |    2 
 fs/btrfs/root-tree.c                                            |   13 
 fs/btrfs/send.c                                                 |  201 +++-
 fs/btrfs/tree-checker.c                                         |   35 
 fs/btrfs/tree-log.c                                             |    8 
 fs/btrfs/volumes.c                                              |   42 
 fs/btrfs/volumes.h                                              |    1 
 fs/buffer.c                                                     |   16 
 fs/cachefiles/rdwr.c                                            |    3 
 fs/ceph/addr.c                                                  |    2 
 fs/ceph/mds_client.c                                            |   89 +-
 fs/cifs/cifsglob.h                                              |    2 
 fs/cifs/connect.c                                               |   15 
 fs/cifs/inode.c                                                 |   13 
 fs/cifs/smb2maperror.c                                          |    2 
 fs/cifs/smb2ops.c                                               |   15 
 fs/exec.c                                                       |   24 
 fs/ext4/balloc.c                                                |    1 
 fs/ext4/extents.c                                               |   33 
 fs/ext4/ialloc.c                                                |    1 
 fs/ext4/inode.c                                                 |   29 
 fs/ext4/resize.c                                                |    4 
 fs/ext4/super.c                                                 |   20 
 fs/f2fs/checkpoint.c                                            |   10 
 fs/f2fs/compress.c                                              |    7 
 fs/f2fs/dir.c                                                   |    8 
 fs/f2fs/f2fs.h                                                  |    4 
 fs/f2fs/file.c                                                  |    2 
 fs/f2fs/inode.c                                                 |    3 
 fs/f2fs/node.c                                                  |    2 
 fs/f2fs/segment.c                                               |   12 
 fs/f2fs/super.c                                                 |    6 
 fs/gfs2/glock.c                                                 |   18 
 fs/gfs2/glops.c                                                 |   11 
 fs/gfs2/incore.h                                                |    1 
 fs/gfs2/log.c                                                   |   61 -
 fs/gfs2/ops_fstype.c                                            |   40 
 fs/gfs2/rgrp.c                                                  |    9 
 fs/gfs2/rgrp.h                                                  |    2 
 fs/gfs2/super.c                                                 |    3 
 fs/gfs2/sys.c                                                   |    5 
 fs/gfs2/util.c                                                  |    2 
 fs/gfs2/util.h                                                  |   10 
 fs/io-wq.c                                                      |    1 
 fs/io_uring.c                                                   |    8 
 fs/jbd2/recovery.c                                              |   78 +
 fs/nfs/namespace.c                                              |   12 
 fs/nfs/nfs4_fs.h                                                |    8 
 fs/nfs/nfs4file.c                                               |    3 
 fs/nfs/nfs4proc.c                                               |   90 +-
 fs/nfs/nfs4trace.h                                              |    1 
 fs/nfsd/nfs4state.c                                             |    5 
 fs/nfsd/nfsproc.c                                               |   16 
 fs/nfsd/trace.h                                                 |    4 
 fs/ubifs/debug.c                                                |    1 
 fs/ubifs/journal.c                                              |    6 
 fs/ubifs/orphan.c                                               |    2 
 fs/ubifs/super.c                                                |   44 -
 fs/ubifs/tnc.c                                                  |    3 
 fs/ubifs/xattr.c                                                |    2 
 fs/udf/super.c                                                  |   21 
 fs/xfs/libxfs/xfs_bmap.c                                        |   19 
 fs/xfs/libxfs/xfs_defer.c                                       |   37 
 fs/xfs/libxfs/xfs_defer.h                                       |    6 
 fs/xfs/xfs_bmap_item.c                                          |    2 
 fs/xfs/xfs_log_recover.c                                        |   39 
 fs/xfs/xfs_refcount_item.c                                      |    2 
 fs/xfs/xfs_rtalloc.c                                            |   19 
 include/asm-generic/vmlinux.lds.h                               |    5 
 include/drm/gpu_scheduler.h                                     |   12 
 include/linux/cpufreq.h                                         |   11 
 include/linux/fs.h                                              |    1 
 include/linux/hil_mlc.h                                         |    2 
 include/linux/mlx5/driver.h                                     |   18 
 include/linux/pci-ecam.h                                        |    1 
 include/linux/rcupdate_trace.h                                  |    4 
 include/linux/time64.h                                          |    4 
 include/linux/usb/pd.h                                          |    1 
 include/rdma/ib_verbs.h                                         |    5 
 include/scsi/scsi_cmnd.h                                        |    3 
 include/trace/events/afs.h                                      |   22 
 include/trace/events/btrfs.h                                    |   10 
 include/uapi/linux/btrfs_tree.h                                 |   14 
 include/uapi/linux/nfs4.h                                       |    3 
 include/uapi/linux/videodev2.h                                  |   17 
 include/xen/events.h                                            |   21 
 init/Kconfig                                                    |    3 
 kernel/bpf/verifier.c                                           |    4 
 kernel/debug/debug_core.c                                       |   22 
 kernel/futex.c                                                  |    9 
 kernel/locking/lockdep.c                                        |    4 
 kernel/module.c                                                 |    2 
 kernel/rcu/tasks.h                                              |   16 
 kernel/rcu/tree.c                                               |    2 
 kernel/sched/cpufreq_schedutil.c                                |    6 
 kernel/seccomp.c                                                |   38 
 kernel/stop_machine.c                                           |    2 
 kernel/time/itimer.c                                            |    4 
 kernel/time/sched_clock.c                                       |    4 
 kernel/trace/ring_buffer.c                                      |   18 
 kernel/trace/trace_events_synth.c                               |   23 
 lib/scatterlist.c                                               |    2 
 mm/slab.c                                                       |    2 
 mm/slab.h                                                       |   42 
 mm/slub.c                                                       |    3 
 net/9p/trans_fd.c                                               |    2 
 net/ceph/messenger.c                                            |    5 
 net/mac80211/tx.c                                               |    6 
 net/sunrpc/sysctl.c                                             |    8 
 net/sunrpc/xprt.c                                               |    6 
 samples/bpf/xdpsock_user.c                                      |    1 
 security/integrity/digsig.c                                     |    2 
 security/integrity/ima/ima_fs.c                                 |    2 
 security/integrity/ima/ima_main.c                               |    6 
 security/selinux/include/security.h                             |   14 
 security/selinux/ss/services.c                                  |    3 
 sound/soc/amd/acp3x-rt5682-max9836.c                            |   11 
 sound/soc/sof/intel/hda-codec.c                                 |    4 
 tools/perf/pmu-events/arch/x86/amdzen1/cache.json               |   18 
 tools/perf/util/print_binary.c                                  |    2 
 tools/testing/selftests/bpf/progs/test_sysctl_prog.c            |    4 
 tools/testing/selftests/powerpc/utils.c                         |    4 
 tools/testing/selftests/x86/fsgsbase.c                          |   68 +
 458 files changed, 5293 insertions(+), 2527 deletions(-)

Adrian Hunter (1):
      mmc: sdhci: Add LTR support for some Intel BYT based controllers

Akshu Agrawal (1):
      ASoC: AMD: Clean kernel log from deferred probe error messages

Alain Volmat (1):
      cpufreq: sti-cpufreq: add stih418 support

Alex Deucher (1):
      drm/amdgpu/swsmu: drop smu i2c bus on navi1x

Alex Dewar (1):
      memory: brcmstb_dpfe: Fix memory leak

Alex Hung (1):
      ACPI: video: use ACPI backlight for HP 635 Notebook

Alexander Sverdlin (2):
      staging: octeon: repair "fixed-link" support
      staging: octeon: Drop on uncorrectable alignment or FCS error

Alok Prasad (1):
      RDMA/qedr: Fix memory leak in iWARP CM

Amit Cohen (1):
      mlxsw: core: Fix use-after-free in mlxsw_emad_trans_finish()

Anand Jain (3):
      btrfs: fix replace of seed device
      btrfs: improve device scanning messages
      btrfs: skip devices without magic signature when mounting

Anant Thazhemadam (2):
      net: 9p: initialize sun_server.sun_path to have addr's value only when addr is valid
      gfs2: add validation checks for size of superblock

Andreas Gruenbacher (1):
      gfs2: Make sure we don't miss any delayed withdraws

Andrei Vagin (1):
      futex: Adjust absolute futex timeouts with per time namespace offset

Andrew Donnellan (1):
      powerpc/rtas: Restrict RTAS requests from userspace

Andrew Price (1):
      gfs2: Fix NULL pointer dereference in gfs2_rgrp_dump

Andrey Grodzovsky (2):
      drm/amd/display: Avoid MST manager resource leak.
      drm/amd/psp: Fix sysfs: cannot create duplicate filename

Andy Lutomirski (2):
      selftests/x86/fsgsbase: Reap a forgotten child
      selftests/x86/fsgsbase: Test PTRACE_PEEKUSER for GSBASE with invalid LDT GS

Andy Shevchenko (2):
      device property: Keep secondary firmware node secondary by type
      device property: Don't clear secondary pointer for shared primary firmware node

Aneesh Kumar K.V (3):
      powerpc/vmemmap: Fix memory leak with vmemmap list allocation failures.
      powerpc/drmem: Make lmb_size 64 bit
      powerpc/memhotplug: Make lmb size 64bit

Ansuel Smith (1):
      PCI: qcom: Make sure PCIe is reset before init for rev 2.1.0

Antonio Borneo (1):
      drm/bridge/synopsys: dsi: add support for non-continuous HS clock

Ard Biesheuvel (1):
      arm64: efi: increase EFI PE/COFF header padding to 64 KB

Artur Molchanov (1):
      net/sunrpc: Fix return value for sysctl sunrpc.transports

Arun Easi (2):
      scsi: qla2xxx: Fix MPI reset needed message
      scsi: qla2xxx: Fix reset of MPI firmware

Arvind Sankar (1):
      x86/kaslr: Initialize mem_limit to the real maximum address

Ashish Sangwan (1):
      NFS: fix nfs_path in case of a rename retry

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: During PR_SWAP, source caps should be sent only after tSwapSourceStart

Bartosz Golaszewski (1):
      rtc: rx8010: don't modify the global rtc ops

Bastien Nocera (2):
      usbcore: Check both id_table and match() when both available
      USB: apple-mfi-fastcharge: don't probe unhandled devices

Ben Hutchings (1):
      ACPI / extlog: Check for RDMSR failure

Benjamin Coddington (1):
      NFSv4: Wait for stateid updates after CLOSE/OPEN_DOWNGRADE

Bharata B Rao (1):
      mm: memcg/slab: uncharge during kmem_cache_free_bulk()

Bhaumik Bhatt (1):
      bus: mhi: core: Abort suspends due to outgoing pending packets

Bob Peterson (2):
      gfs2: call truncate_inode_pages_final for address space glocks
      gfs2: Only access gl_delete for iopen glocks

Borislav Petkov (1):
      x86/mce: Allow for copy_mc_fragile symbol checksum to be generated

Carl Huang (1):
      ath11k: fix warning caused by lockdep_assert_held

Chandan Babu R (2):
      xfs: Set xfs_buf type flag when growing summary/bitmap files
      xfs: Set xfs_buf's b_ops member when zeroing bitmap/summary files

Chao Leng (1):
      nvme-rdma: fix crash when connect rejected

Chao Yu (6):
      f2fs: allocate proper size memory for zstd decompress
      f2fs: do sanity check on zoned block device path
      f2fs: fix uninit-value in f2fs_lookup
      f2fs: fix to check segment boundary during SIT page readahead
      f2fs: compress: fix to disallow enabling compress on non-empty file
      f2fs: fix to set SBI_NEED_FSCK flag for inconsistent inode

Chen Yu (1):
      intel_idle: Fix max_cstate for processor models without C-state tables

Chris Lew (1):
      rpmsg: glink: Use complete_all for open states

Chris Wilson (1):
      drm/i915: Force VT'd workarounds when running as a guest OS

Christian König (1):
      drm/amdgpu: increase the reserved VM size to 2MB

Christoph Hellwig (1):
      scsi: core: Clean up allocation and freeing of sgtables

Christophe Leroy (4):
      powerpc: Fix random segfault when freeing hugetlb range
      powerpc/powermac: Fix low_sleep_handler with KUAP and KUEP
      powerpc/32: Fix vmap stack - Do not activate MMU before reading task struct
      powerpc/32: Fix vmap stack - Properly set r1 before activating MMU

Chuanhong Guo (1):
      spi: spi-mtk-nor: fix timeout calculation overflow

Chuck Lever (2):
      SUNRPC: Mitigate cond_resched() in xprt_transmit()
      NFSD: Add missing NFSv2 .pc_func methods

Cristian Marussi (1):
      firmware: arm_scmi: Fix locking in notifications

Damien Le Moal (2):
      null_blk: Fix zone reset all tracing
      null_blk: Fix locking in zoned mode

Dan Carpenter (3):
      afs: Fix a use after free in afs_xattr_get_acl()
      memory: emif: Remove bogus debugfs error handling
      vhost_vdpa: Return -EFAULT if copy_from_user() fails

Daniel Vetter (1):
      drm/shme-helpers: Fix dma_buf_mmap forwarding bug

Daniel W. S. Almeida (1):
      media: uvcvideo: Fix dereference of out-of-bound list iterator

Daniel Xu (1):
      btrfs: tree-checker: validate number of chunk stripes and parity

Darrick J. Wong (4):
      xfs: log new intent items created as part of finishing recovered intent items
      xfs: change the order in which child and parent defer ops are finished
      xfs: fix realtime bitmap/summary file truncation when growing rt volume
      xfs: don't free rt blocks when we're doing a REMAP bunmapi call

Dave Airlie (1):
      drm/ttm: fix eviction valuable range check.

Dave Wysochanski (1):
      NFS4: Fix oops when copy_file_range is attempted with NFS4.0 source

David Galiffi (1):
      drm/amd/display: Fix incorrect backlight register offset for DCN

David Howells (9):
      afs: Fix afs_launder_page to not clear PG_writeback
      afs: Fix to take ref on page when PG_private is set
      afs: Fix page leak on afs_write_begin() failure
      afs: Fix where page->private is set during write
      afs: Wrap page->private manipulations in inline functions
      afs: Alter dirty range encoding in page->private
      afs: Fix afs_invalidatepage to adjust the dirty region
      afs: Fix dirty-region encoding on ppc32 with 64K pages
      afs: Don't assert on unpurgeable server records

Denis Efremov (1):
      btrfs: use kvzalloc() to allocate clone_roots in btrfs_ioctl_send()

Diana Craciun (1):
      bus/fsl_mc: Do not rely on caller to provide non NULL mc_io

Dinghao Liu (1):
      ext4: fix error handling code in add_new_gdb

Dmitry Osipenko (2):
      brcmfmac: increase F2 watermark for BCM4329
      cpuidle: tegra: Correctly handle result of arm_cpuidle_simple_enter()

Douglas Anderson (2):
      ARM: 8997/2: hw_breakpoint: Handle inexact watchpoint addresses
      kgdb: Make "kgdbcon" work properly with "kgdb_earlycon"

Douglas Gilbert (1):
      sgl_alloc_order: fix memory leak

Enric Balletbo i Serra (1):
      drm/bridge_connector: Set default status connected for eDP connectors

Eric Biggers (1):
      ext4: fix leaking sysfs kobject after failed mount

Etienne Carriere (2):
      firmware: arm_scmi: Fix ARCH_COLD_RESET
      firmware: arm_scmi: Expand SMC/HVC message pool to more than one

Eugen Hristev (1):
      iio: adc: at91-sama5d2_adc: fix DMA conversion crash

Evan Quan (2):
      drm/amdgpu: correct the gpu reset handling for job != NULL case
      drm/amd/pm: increase mclk switch threshold to 200 us

Fabiano Rosas (1):
      KVM: PPC: Book3S HV: Do not allocate HPT for a nested guest

Fangrui Song (1):
      arm64: Change .weak to SYM_FUNC_START_WEAK_PI for arch/arm64/lib/mem*.S

Fangzhi Zuo (1):
      drm/amd/display: HDMI remote sink need mode validation for Linux

Felix Fietkau (1):
      mac80211: add missing queue/hash initialization to 802.3 xmit

Filipe Manana (5):
      btrfs: reschedule if necessary when logging directory items
      btrfs: send, orphanize first all conflicting inodes when processing references
      btrfs: send, recompute reference path after orphanization of a directory
      btrfs: fix use-after-free on readahead extent after failure to create it
      btrfs: fix readahead hang and use-after-free after removing a device

Florian Fainelli (1):
      firmware: arm_scmi: Fix duplicate workqueue name

Frank Wunderlich (1):
      arm: dts: mt7623: add missing pause for switchport

Gabriel Krisman Bertazi (1):
      block: Consider only dispatched requests for inflight statistic

Ganesh Goudar (1):
      powerpc/mce: Avoid nmi_enter/exit in real mode on pseries hash

Gao Xiang (1):
      xfs: avoid LR buffer overrun due to crafted h_len

Gaurav Kohli (1):
      tracing: Fix race in trace_open and buffer resize call

Georgi Djakov (1):
      interconnect: qcom: sdm845: Enable keepalive for the MM1 BCM

Greg Kroah-Hartman (1):
      Linux 5.9.5

Grygorii Strashko (2):
      soc: ti: k3: ringacc: add am65x sr2.0 support
      bindings: soc: ti: soc: ringacc: remove ti,dma-ring-reset-quirk

Guchun Chen (1):
      drm/amdgpu: restore ras flags when user resets eeprom(v2)

Guoqing Jiang (1):
      md: fix the checking of wrong work queue

Hanjun Guo (1):
      ACPI: configfs: Add missing config_item_put() to fix refcount leak

Hans Verkuil (2):
      media: videodev2.h: RGB BT2020 and HSV are always full range
      media: imx274: fix frame interval handling

Hans de Goede (1):
      media: uvcvideo: Fix uvc_ctrl_fixup_xu_info() not having any effect

Harald Freudenberger (1):
      s390/ap/zcrypt: revisit ap and zcrypt error handling

Helge Deller (2):
      scsi: mptfusion: Fix null pointer dereferences in mptscsih_remove()
      hil/parisc: Disable HIL driver when it gets stuck

Hou Tao (1):
      nfsd: rename delegation related tracepoints to make them less confusing

Huacai Chen (1):
      irqchip/loongson-htvec: Fix initial interrupt clearing

Ian Abbott (1):
      staging: comedi: cb_pcidas: Allow 2-channel commands for AO subdevice

Ilya Dryomov (1):
      libceph: clear con->out_msg on Policy::stateful_server faults

J. Bruce Fields (1):
      nfsd4: remove check_conflicting_opens warning

Jaegeuk Kim (1):
      f2fs: handle errors of f2fs_get_meta_page_nofail

Jamie Iles (2):
      gfs2: use-after-free in sysfs deregistration
      ACPI: debug: don't allow debugging when ACPI is disabled

Jan Kara (3):
      ext4: Detect already used quota file early
      fs: Don't invalidate page buffers in block_write_full_page()
      udf: Fix memory leak when mounting

Jann Horn (1):
      seccomp: Make duplicate listener detection non-racy

Jason Gerecke (1):
      HID: wacom: Avoid entering wacom_wac_pen_report for pad / battery

Jason Gunthorpe (1):
      RDMA/core: Change how failing destroy is handled during uobj abort

Jay Cornwall (1):
      drm/amdkfd: Use same SQ prefetch setting as amdgpu

Jens Axboe (2):
      io-wq: assign NUMA node locality if appropriate
      io_uring: use type appropriate io_kiocb handler for double poll

Jerome Brunet (1):
      usb: cdc-acm: fix cooldown mechanism

Jing Xiangfeng (2):
      staging: fieldbus: anybuss: jump to correct label in an error path
      vdpa/mlx5: Fix error return in map_direct_mr()

Jiri Olsa (1):
      perf python scripting: Fix printable strings in python3 scripts

Jiri Slaby (4):
      x86/unwind/orc: Fix inactive tasks with stack pointer in %sp on GCC 10 compiled kernels
      vt: keyboard, simplify vt_kdgkbsent
      vt: keyboard, extend func_buf_lock to readers
      vt_ioctl: fix GIO_UNIMAP regression

Jisheng Zhang (2):
      mmc: sdhci: Use Auto CMD Auto Select only when v4_mode is true
      arm64: berlin: Select DW_APB_TIMER_OF

Joakim Zhang (1):
      can: flexcan: disable clocks during stop mode

Joel Stanley (3):
      powerpc: Warn about use of smt_snooze_delay
      ARM: aspeed: g5: Do not set sirq polarity
      ARM: config: aspeed: Fix selection of media drivers

Johannes Berg (1):
      um: change sigio_spinlock to a mutex

Johannes Thumshirn (1):
      btrfs: reschedule when cloning lots of extents

John Ogness (1):
      printk: reduce LOG_BUF_SHIFT range for H8300

Jonathan Bakker (1):
      ARM: dts: s5pv210: Enable audio on Aries boards

Jonathan Cameron (8):
      ACPI: Add out of bounds and numa_off protections to pxm_to_node()
      ACPI: HMAT: Fix handling of changes from ACPI 6.2 to ACPI 6.3
      iio:imu:inv_mpu6050 Fix dma and ts alignment and data leak issues.
      iio:light:si1145: Fix timestamp alignment and prevent data leak.
      iio:adc:ti-adc0832 Fix alignment issue with timestamp
      iio:adc:ti-adc12138 Fix alignment issue with timestamp
      iio:imu:st_lsm6dsx Fix alignment and data leak issues
      iio:gyro:itg3200: Fix timestamp alignment and prevent data leak.

Josef Bacik (3):
      btrfs: sysfs: init devices outside of the chunk_mutex
      btrfs: cleanup cow block on error
      btrfs: drop the path before adding block group sysfs files

Juergen Gross (14):
      xen/events: avoid removing an event channel while handling it
      xen/events: add a proper barrier to 2-level uevent unmasking
      xen/events: fix race in evtchn_fifo_unmask()
      xen/events: add a new "late EOI" evtchn framework
      xen/blkback: use lateeoi irq binding
      xen/netback: use lateeoi irq binding
      xen/scsiback: use lateeoi irq binding
      xen/pvcallsback: use lateeoi irq binding
      xen/pciback: use lateeoi irq binding
      xen/events: switch user event channels to lateeoi model
      xen/events: use a common cpu hotplug hook for event channels
      xen/events: defer eoi in case of excessive number of events
      xen/events: block rogue events for some time
      x86/alternative: Don't call text_poke() in lazy TLB mode

Jérôme Pouiller (1):
      staging: wfx: fix potential use before init

Kan Liang (1):
      perf/x86/intel: Fix Ice Lake event constraint table

Kanchan Joshi (1):
      null_blk: synchronization fix for zoned device

Kees Cook (1):
      fs/kernel_read_file: Remove FIRMWARE_PREALLOC_BUFFER enum

Kenneth Feng (1):
      drm/amd/pm: fix pp_dpm_fclk

Kevin Wang (1):
      drm/amd/swsmu: add missing feature map for sienna_cichlid

Kim Phillips (5):
      perf/x86/amd: Fix sampling Large Increment per Cycle events
      perf/amd/uncore: Set all slices and threads to restore perf stat -a behaviour
      perf/x86/amd/ibs: Don't include randomized bits in get_ibs_op_count()
      perf/x86/amd/ibs: Fix raw sample data accumulation
      perf vendor events amd: Add L2 Prefetch events for zen1

Konrad Dybcio (1):
      arm64: dts: qcom: kitakami: Temporarily disable SDHCI1

Krzysztof Kozlowski (15):
      power: supply: bq27xxx: report "not charging" on all types
      nfc: s3fwrn5: Add missing CRYPTO_HASH dependency
      ARM: dts: s5pv210: remove DMA controller bus node name to fix dtschema warnings
      ARM: dts: s5pv210: move fixed clocks under root node
      ARM: dts: s5pv210: move PMU node out of clock controller
      ARM: dts: s5pv210: remove dedicated 'audio-subsystem' node
      ARM: dts: s5pv210: add RTC 32 KHz clock in Aries family
      ARM: dts: s5pv210: align SPI GPIO node name with dtschema in Aries
      spi: sprd: Release DMA channel also on probe deferral
      extcon: ptn5150: Fix usage of atomic GPIO with sleeping GPIO chips
      ia64: fix build error with !COREDUMP
      i2c: imx: Fix external abort on interrupt in exit paths
      ARM: dts: s5pv210: fix pinctrl property of "vibrator-en" regulator in Aries
      ARM: samsung: fix PM debug build with DEBUG_LL but !MMU
      ARM: s3c24xx: fix missing system reset

Lang Dai (1):
      uio: free uio id after uio file node is freed

Laurent Vivier (2):
      vdpasim: fix MAC address configuration
      vdpa_sim: Fix DMA mask

Li Jun (4):
      usb: dwc3: core: do not queue work if dr_mode is not USB_DR_MODE_OTG
      usb: dwc3: core: add phy cleanup for probe error handling
      usb: dwc3: core: don't trigger runtime pm when remove driver
      usb: typec: tcpm: reset hard_reset_count for any disconnect

Likun Gao (3):
      drm/amdgpu: update golden setting for sienna_cichlid
      drm/amdgpu: add function to program pbb mode for sienna cichlid
      drm/amdgpu: correct the cu and rb info for sienna cichlid

Linu Cherian (1):
      coresight: Make sysfs functional on topologies with per core sink

Linus Torvalds (1):
      tty: make FONTX ioctl use the tty pointer they were actually passed

Luben Tuikov (2):
      drm/scheduler: Scheduler priority fixes (v2)
      drm/amdgpu: No sysfs, not an error condition

Lukas Wunner (1):
      PCI/ACPI: Whitelist hotplug ports for D3 if power managed by ACPI

Luo Meng (1):
      ext4: fix invalid inode checksum

Maciej W. Rozycki (1):
      MIPS: DEC: Restore bootmem reservation for firmware working memory area

Madhav Chauhan (1):
      drm/amdgpu: don't map BO in reserved region

Madhuparna Bhowmik (2):
      mmc: via-sdmmc: Fix data race bug
      drivers: watchdog: rdc321x_wdt: Fix race condition bugs

Magnus Karlsson (1):
      samples/bpf: Fix possible deadlock in xdpsock

Mahesh Salgaonkar (1):
      powerpc/powernv/elog: Fix race while processing OPAL error log event.

Marc Zyngier (1):
      KVM: arm64: Fix AArch32 handling of DBGD{CCINT,SCRext} and DBGVCR

Marek Behún (1):
      leds: bcm6328, bcm6358: use devres LED registering function

Marek Szyprowski (5):
      misc: fastrpc: fix common struct sg_table related issues
      drm: exynos: fix common struct sg_table related issues
      xen: gntdev: fix common struct sg_table related issues
      drm: lima: fix common struct sg_table related issues
      drm: panfrost: fix common struct sg_table related issues

Martin Fuzzey (1):
      w1: mxc_w1: Fix timeout resolution problem leading to bus error

Masami Hiramatsu (1):
      ia64: kprobes: Use generic kretprobe trampoline handler

Mateusz Nosek (1):
      futex: Fix incorrect should_fail_futex() handling

Matthew Wilcox (Oracle) (3):
      ceph: promote to unsigned long long before shifting
      9P: Cast to loff_t before multiplying
      cachefiles: Handle readpage error correctly

Mel Gorman (1):
      intel_idle: Ignore _CST if control cannot be taken from the platform

Michael Chan (1):
      bnxt_en: Log unknown link speed appropriately.

Michael Ellerman (1):
      selftests/powerpc: Make using_hash_mmu() work on Cell & PowerMac

Michael Neuling (1):
      powerpc: Fix undetected data corruption with P9N DD2.1 VSX CI load emulation

Michael S. Tsirkin (1):
      Revert "vhost-vdpa: fix page pinning leakage in error path"

Michael Walle (1):
      mmc: sdhci-of-esdhc: set timeout to max before tuning

Nadezda Lutovinova (1):
      drm/brige/megachips: Add checking if ge_b850v3_lvds_init() is working correctly

Naohiro Aota (1):
      block: advance iov_iter on bio_add_hw_page failure

Nicholas Piggin (4):
      mm: fix exec activate_mm vs TLB shootdown and lazy tlb switching race
      powerpc: select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
      sparc64: remove mm_cpumask clearing to fix kthread_use_mm race
      powerpc/64s: handle ISA v3.1 local copy-paste context switches

Nick Desaulniers (1):
      vmlinux.lds.h: Add PGO and AutoFDO input sections

Nuno Sá (2):
      iio: ltc2983: Fix of_node refcounting
      iio: ad7292: Fix of_node refcounting

Olga Kornievskaia (1):
      NFSv4.2: support EXCHGID4_FLAG_SUPP_FENCE_OPS 4.2 EXCHANGE_ID flag

Oliver Neukum (1):
      USB: adutux: fix debugging

Oliver O'Halloran (1):
      powerpc/powernv/smp: Fix spurious DBG() warning

Pali Rohár (1):
      arm64: dts: marvell: espressobin: Add ethernet switch aliases

Parav Pandit (1):
      RDMA/mlx5: Fix devlink deadlock on net namespace deletion

Paul Cercueil (2):
      dmaengine: dma-jz4780: Fix race in jz4780_dma_tx_status
      MIPS: configs: lb60: Fix defconfig not selecting correct board

Paul E. McKenney (3):
      rcu-tasks: Fix grace-period/unlock race in RCU Tasks Trace
      rcu-tasks: Fix low-probability task_struct leak
      rcu-tasks: Enclose task-list scan in rcu_read_lock()

Pavel Begunkov (1):
      io_uring: don't set COMP_LOCKED if won't put

Pawel Laszczak (1):
      usb: cdns3: Fix on-chip memory overflow issue

Peter Chen (1):
      usb: xhci: omit duplicate actions when suspending a runtime suspended host.

Peter Zijlstra (1):
      lockdep: Fix preemption WARN for spurious IRQ-enable

Qiujun Huang (1):
      ring-buffer: Return 0 on success from ring_buffer_resize()

Qu Wenruo (4):
      btrfs: qgroup: fix wrong qgroup metadata reserve for delayed inode
      btrfs: qgroup: fix qgroup meta rsv leak for subvolume operations
      btrfs: tracepoints: output proper root owner for trace_find_free_extent()
      btrfs: tree-checker: fix false alert caused by legacy btrfs root item

Quanyang Wang (1):
      time/sched_clock: Mark sched_clock_read_begin/retry() as notrace

Quinn Tran (1):
      scsi: qla2xxx: Fix crash on session cleanup with unload

Rafael J. Wysocki (7):
      ACPI: EC: PM: Flush EC work unconditionally after wakeup
      ACPI: EC: PM: Drop ec_no_wakeup check from acpi_ec_dispatch_gpe()
      cpufreq: Avoid configuring old governors as default with intel_pstate
      cpufreq: Introduce CPUFREQ_NEED_UPDATE_LIMITS driver flag
      cpufreq: intel_pstate: Avoid missing HWP max updates in passive mode
      cpufreq: Introduce cpufreq_driver_test_flags()
      cpufreq: schedutil: Always call driver if CPUFREQ_NEED_UPDATE_LIMITS is set

Ran Wang (1):
      usb: host: fsl-mph-dr-of: check return of dma_set_mask()

Rander Wang (1):
      ASoC: SOF: fix a runtime pm issue in SOF when HDMI codec doesn't work

Raul E Rangel (1):
      mmc: sdhci-acpi: AMDI0040: Set SDHCI_QUIRK2_PRESET_VALUE_BROKEN

Ravi Bangoria (1):
      powerpc/watchpoint/ptrace: Fix SETHWDEBUG when CONFIG_HAVE_HW_BREAKPOINT=N

Raymond Tan (1):
      usb: dwc3: pci: Allow Elkhart Lake to utilize DSM method for PM functionality

Richard Weinberger (1):
      ubifs: journal: Make sure to not dirty twice for auth nodes

Ritesh Harjani (2):
      ext4: implement swap_activate aops using iomap
      ext4: fix bs < ps issue reported with dioread_nolock mount opt

Rodrigo Siqueira (2):
      drm/amd/display: Check clock table return
      drm/amd/display: Avoid set zero in the requested clk

Rohith Surabattula (1):
      Handle STATUS_IO_TIMEOUT gracefully

Ronnie Sahlberg (1):
      cifs: handle -EINTR in cifs_setattr

Russell King (1):
      tty: serial: 21285: fix lockup on open

Sandeep Singh (1):
      usb: xhci: Workaround for S3 issue on AMD SNPS 3.0 xHC

Sascha Hauer (1):
      ata: sata_nv: Fix retrieving of active qcs

Sasha Levin (2):
      ionic: no rx flush in deinit
      tracing, synthetic events: Replace buggy strcat() with seq_buf operations

Sathishkumar Muruganandam (1):
      ath10k: fix VHT NSS calculation when STBC is enabled

Sibi Sankar (1):
      remoteproc: Fixup coredump debugfs disable request

Sidong Yang (1):
      drm/vkms: avoid warning in vkms_get_vblank_timestamp

Song Liu (1):
      md/raid5: fix oops during stripe resizing

Stanislaw Kardach (1):
      octeontx2-af: fix LD CUSTOM LTYPE aliasing

Stefano Garzarella (1):
      vringh: fix __vringh_iov() when riov and wiov are different

Stephen Boyd (1):
      soc: qcom: rpmh-rsc: Sleep waiting for tcs slots to be free

Stephen Smalley (1):
      selinux: access policycaps with READ_ONCE/WRITE_ONCE

Steve Foreman (1):
      hwmon: (pmbus/max34440) Fix OC fault limits

Sudeep Holla (2):
      firmware: arm_scmi: Add missing Rx size re-initialisation
      firmware: arm_scmi: Move scmi bus init and exit calls into the driver

Sumit Garg (1):
      tee: client UUID: Skip REE kernel login method as well

Suzuki K Poulose (1):
      coresight: cti: Initialize dynamic sysfs attributes

Sven Schnelle (1):
      s390/stp: add locking to sysfs functions

Takashi Iwai (3):
      drm/amd/display: Don't invoke kgdb_breakpoint() unconditionally
      drm/amd/display: Fix kernel panic by dal_gpio_open() error
      KVM: x86: Fix NULL dereference at kvm_msr_ignored_check()

Tang Bin (1):
      usb: host: ehci-tegra: Fix error handling in tegra_ehci_probe()

Tero Kristo (1):
      clk: ti: clockdomain: fix static checker warning

Thierry Reding (1):
      memory: tegra: Remove GPU from DRM IOMMU group

Thinh Nguyen (5):
      usb: dwc3: ep0: Fix ZLP for OUT ep0 requests
      usb: dwc3: gadget: Check MPS of the request length
      usb: dwc3: gadget: Reclaim extra TRBs after request completion
      usb: dwc3: gadget: Resume pending requests after CLEAR_STALL
      usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command

Thomas Zimmermann (1):
      drm/ast: Separate DRM driver from PCI code

Tobias Jordan (1):
      iio: adc: gyroadc: fix leak of device node iterator

Tom Rix (3):
      video: fbdev: pvr2fb: initialize variables
      media: tw5864: check status of tw5864_frameinterval_get
      iio:imu:st_lsm6dsx: check st_lsm6dsx_shub_read_output return

Tony Lindgren (1):
      ARM: dts: omap4: Fix sgx clock rate for 4430

Tuan Phan (1):
      PCI/ACPI: Add Ampere Altra SOC MCFG quirk

Valentin Schneider (1):
      arm64: topology: Stop using MPIDR for topology information

Vasily Gorbik (1):
      s390/startup: avoid save_area_sync overflow

Veerabadhran G (1):
      drm/amdgpu: vcn and jpeg ring synchronization

Venkateswara Naralasetty (1):
      ath10k: fix retry packets update in station dump

Vineet Gupta (1):
      ARC: perf: redo the pct irq missing in device-tree handling

Vladimir Oltean (1):
      tty: serial: fsl_lpuart: LS1021A has a FIFO size of 16 words, like LS1028A

Wei Huang (1):
      acpi-cpufreq: Honor _PSD table setting on new AMD CPUs

Wen Gong (3):
      ath10k: start recovery process when payload length exceeds max htc length for sdio
      ath11k: Use GFP_ATOMIC instead of GFP_KERNEL in ath11k_dp_htt_get_ppdu_desc
      ath11k: change to disable softirqs for ath11k_regd_update to solve deadlock

Wesley Chalmers (1):
      drm/amd/display: Increase timeout for DP Disable

Wright Feng (1):
      brcmfmac: Fix warning message after dongle setup failed

Xia Jiang (1):
      media: platform: Improve queue set up flow for bug fixing

Xiang Chen (1):
      PM: runtime: Remove link state checks in rpm_get/put_supplier()

Xie He (1):
      drivers/net/wan/hdlc_fr: Correctly handle special skb->protocol values

Xiongfeng Wang (1):
      power: supply: test_power: add missing newlines when printing parameters by sysfs

Xiubo Li (1):
      nbd: make the config put is called before the notifying the waiter

Yan, Zheng (1):
      ceph: encode inodes' parent/d_name in cap reconnect message

Yangbo Lu (1):
      mmc: sdhci-of-esdhc: make sure delay chain locked for HS400

Yonghong Song (2):
      bpf: Permit map_ptr arithmetic with opcode add and offset 0
      selftests/bpf: Define string const as global for test_sysctl_prog.c

Yoshihiro Shimoda (1):
      arm64: dts: renesas: ulcb: add full-pwr-cycle-in-suspend into eMMC nodes

Zeng Tao (1):
      time: Prevent undefined behaviour in timespec64_to_ns()

Zhang Qilong (1):
      f2fs: add trace exit in exception path

Zhang Xiaoxu (1):
      ext4: fix bdev write error check failed when mount fs with ro

Zhao Heming (1):
      md/bitmap: md_bitmap_get_counter returns wrong blocks

Zhen Lei (1):
      ARC: [dts] fix the errors detected by dtbs_check

Zhengyuan Liu (1):
      arm64/mm: return cpu_all_mask when node is NUMA_NO_NODE

Zhihao Cheng (6):
      ubifs: dent: Fix some potential memory leaks while iterating entries
      ubifs: xattr: Fix some potential memory leaks while iterating entries
      ubifs: Fix a memleak after dumping authentication mount options
      ubifs: Don't parse authentication mount options in remount process
      ubifs: mount_ubifs: Release authentication resource in error handling path
      ubi: check kthread_should_stop() after the setting of task state

Zong Li (2):
      riscv: Define AT_VECTOR_SIZE_ARCH for ARCH_DLINFO
      stop_machine, rcu: Mark functions as notrace

changfengnan (1):
      jbd2: avoid transaction reuse after reformatting

dmitry.torokhov@gmail.com (1):
      ACPI: button: fix handling lid state changes when input device closed

farah kassabri (1):
      habanalabs: remove security from ARB_MST_QUIET register

yangerkun (1):
      ext4: do not use extent after put_bh

zhangyi (F) (1):
      ext4: clear buffer verified flag if read meta block from disk

