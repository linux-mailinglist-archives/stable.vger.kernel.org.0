Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E006C3CFC39
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 16:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237489AbhGTNqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 09:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239141AbhGTNni (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 09:43:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C29F6101E;
        Tue, 20 Jul 2021 14:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626791056;
        bh=bBKMqMUtHeU710BwgEW8uhTuXpGy29DJh5+aCVn/QNw=;
        h=From:To:Cc:Subject:Date:From;
        b=RRrvkFTeUKGVX0ltdeWjxdd3g1qwfJv0AF12QebtvCSDTlDUXPY+bHhE/qkWo27Bw
         AH85w6Z7V//nwvTtN0MnIF9Vy/FijuZX924rK0L6uR+6Nt5HUcpOejDUF276vwU9u/
         c8tfCFVq47HL4d61KerTysQlUkn4sMKPSCZozyeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.13.4
Date:   Tue, 20 Jul 2021 16:24:12 +0200
Message-Id: <162679105176149@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.13.4 kernel.

All users of the 5.13 kernel series must upgrade.

The updated 5.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.13.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/i2c/i2c-at91.txt                 |    2 
 Documentation/devicetree/bindings/power/supply/maxim,max17040.yaml |    2 
 Documentation/filesystems/f2fs.rst                                 |   16 
 Makefile                                                           |    7 
 arch/arm/boot/dts/am335x-cm-t335.dts                               |    2 
 arch/arm/boot/dts/am43x-epos-evm.dts                               |    4 
 arch/arm/boot/dts/am5718.dtsi                                      |    6 
 arch/arm/boot/dts/bcm283x-rpi-usb-otg.dtsi                         |    2 
 arch/arm/boot/dts/bcm283x-rpi-usb-peripheral.dtsi                  |    2 
 arch/arm/boot/dts/bcm5301x.dtsi                                    |   18 
 arch/arm/boot/dts/dra7-l4.dtsi                                     |   22 
 arch/arm/boot/dts/dra71x.dtsi                                      |    4 
 arch/arm/boot/dts/dra72x.dtsi                                      |    4 
 arch/arm/boot/dts/dra74x.dtsi                                      |   92 -
 arch/arm/boot/dts/exynos5422-odroidhc1.dts                         |    2 
 arch/arm/boot/dts/exynos5422-odroidxu4.dts                         |    2 
 arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi                    |    4 
 arch/arm/boot/dts/gemini-rut1xx.dts                                |   12 
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi                             |   41 
 arch/arm/boot/dts/qcom-sdx55-t55.dts                               |    2 
 arch/arm/boot/dts/qcom-sdx55-telit-fn980-tlb.dts                   |    4 
 arch/arm/boot/dts/r8a7779-marzen.dts                               |    2 
 arch/arm/boot/dts/r8a7779.dtsi                                     |    1 
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi                       |    8 
 arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts                       |    2 
 arch/arm/mach-exynos/exynos.c                                      |    2 
 arch/arm/probes/kprobes/test-thumb.c                               |   10 
 arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts      |    2 
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi                       |    2 
 arch/arm64/boot/dts/qcom/sc7180.dtsi                               |    4 
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi                |   12 
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts               |    2 
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi                          |    1 
 arch/arm64/boot/dts/renesas/r8a77960.dtsi                          |    7 
 arch/arm64/boot/dts/renesas/r8a77961.dtsi                          |    7 
 arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts                     |    2 
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi                          |    1 
 arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts                  |    2 
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts                 |    2 
 arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi                    |    3 
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi                           |    5 
 arch/arm64/boot/dts/ti/k3-am64-mcu.dtsi                            |    2 
 arch/arm64/boot/dts/ti/k3-am642-evm.dts                            |    2 
 arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi                 |    2 
 arch/arm64/boot/dts/ti/k3-am654-base-board.dts                     |    2 
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi                          |    5 
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi                    |    2 
 arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts              |   52 
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi                          |   58 
 arch/arm64/configs/defconfig                                       |    1 
 arch/arm64/lib/copy_from_user.S                                    |   13 
 arch/arm64/lib/copy_in_user.S                                      |   21 
 arch/arm64/lib/copy_to_user.S                                      |   14 
 arch/hexagon/kernel/vmlinux.lds.S                                  |    9 
 arch/m68k/68000/dragen2.c                                          |    1 
 arch/m68k/68000/screen.h                                           |  804 ++++++++++
 arch/mips/boot/compressed/Makefile                                 |    4 
 arch/mips/boot/compressed/decompress.c                             |    2 
 arch/mips/include/asm/vdso/vdso.h                                  |    2 
 arch/powerpc/boot/devtree.c                                        |   59 
 arch/powerpc/boot/ns16550.c                                        |    9 
 arch/powerpc/include/asm/inst.h                                    |    7 
 arch/powerpc/include/asm/ps3.h                                     |    2 
 arch/powerpc/mm/book3s64/radix_tlb.c                               |   26 
 arch/powerpc/net/bpf_jit_comp64.c                                  |    4 
 arch/powerpc/platforms/ps3/mm.c                                    |   12 
 arch/s390/Kconfig                                                  |    1 
 arch/s390/Makefile                                                 |    1 
 arch/s390/boot/ipl_parm.c                                          |   19 
 arch/s390/boot/mem_detect.c                                        |   47 
 arch/s390/include/asm/processor.h                                  |    4 
 arch/s390/kernel/setup.c                                           |    2 
 arch/s390/purgatory/Makefile                                       |    1 
 arch/um/drivers/chan_user.c                                        |    3 
 arch/um/drivers/slip_user.c                                        |    3 
 arch/um/drivers/ubd_kern.c                                         |    3 
 arch/um/kernel/skas/clone.c                                        |    2 
 arch/um/os-Linux/helper.c                                          |    4 
 arch/um/os-Linux/signal.c                                          |    2 
 arch/um/os-Linux/skas/process.c                                    |    2 
 arch/x86/include/asm/fpu/internal.h                                |   19 
 arch/x86/kernel/fpu/regset.c                                       |    2 
 arch/x86/kernel/fpu/xstate.c                                       |  105 -
 arch/x86/kernel/signal.c                                           |   24 
 arch/x86/kvm/cpuid.c                                               |   27 
 arch/x86/kvm/mmu/mmu.c                                             |    2 
 arch/x86/kvm/mmu/paging.h                                          |   14 
 arch/x86/kvm/mmu/paging_tmpl.h                                     |    4 
 arch/x86/kvm/mmu/spte.h                                            |    6 
 arch/x86/kvm/svm/svm.c                                             |   21 
 arch/x86/kvm/x86.c                                                 |    2 
 block/blk-core.c                                                   |    2 
 block/genhd.c                                                      |    4 
 block/partitions/ldm.c                                             |    2 
 block/partitions/ldm.h                                             |    3 
 block/partitions/msdos.c                                           |   24 
 drivers/acpi/acpi_amba.c                                           |    1 
 drivers/acpi/acpi_video.c                                          |    9 
 drivers/base/arch_topology.c                                       |   27 
 drivers/block/virtio_blk.c                                         |    2 
 drivers/char/virtio_console.c                                      |    4 
 drivers/cpufreq/cppc_cpufreq.c                                     |   27 
 drivers/cpufreq/scmi-cpufreq.c                                     |    2 
 drivers/dma/fsl-qdma.c                                             |    6 
 drivers/edac/Kconfig                                               |    2 
 drivers/firmware/arm_scmi/driver.c                                 |   12 
 drivers/firmware/tegra/bpmp-tegra210.c                             |    2 
 drivers/firmware/turris-mox-rwtm.c                                 |   55 
 drivers/fsi/fsi-master-aspeed.c                                    |    1 
 drivers/fsi/fsi-master-ast-cf.c                                    |    1 
 drivers/fsi/fsi-master-gpio.c                                      |    1 
 drivers/fsi/fsi-occ.c                                              |    1 
 drivers/gpio/gpio-pca953x.c                                        |    1 
 drivers/gpio/gpio-zynq.c                                           |   15 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                            |    1 
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                             |   95 +
 drivers/gpu/drm/amd/amdkfd/kfd_process.c                           |   14 
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c             |    1 
 drivers/gpu/drm/drm_dp_mst_topology.c                              |   68 
 drivers/gpu/drm/gma500/framebuffer.c                               |    7 
 drivers/gpu/drm/i915/gt/gen8_ppgtt.c                               |    5 
 drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c                       |    2 
 drivers/hwtracing/intel_th/core.c                                  |   17 
 drivers/hwtracing/intel_th/gth.c                                   |   16 
 drivers/hwtracing/intel_th/intel_th.h                              |    3 
 drivers/i2c/i2c-core-base.c                                        |    3 
 drivers/iio/gyro/fxas21002c_core.c                                 |   11 
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c                       |    6 
 drivers/iio/magnetometer/bmc150_magn.c                             |   10 
 drivers/input/touchscreen/hideep.c                                 |   13 
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c                         |   13 
 drivers/iommu/arm/arm-smmu/arm-smmu.c                              |   10 
 drivers/iommu/intel/iommu.c                                        |   34 
 drivers/leds/leds-tlc591xx.c                                       |    8 
 drivers/leds/leds-turris-omnia.c                                   |    1 
 drivers/memory/atmel-ebi.c                                         |    4 
 drivers/memory/fsl_ifc.c                                           |    8 
 drivers/memory/pl353-smc.c                                         |    1 
 drivers/memory/stm32-fmc2-ebi.c                                    |    4 
 drivers/mfd/da9052-i2c.c                                           |    1 
 drivers/mfd/motorola-cpcap.c                                       |    4 
 drivers/mfd/stmpe-i2c.c                                            |    2 
 drivers/misc/cardreader/alcor_pci.c                                |    8 
 drivers/misc/habanalabs/common/device.c                            |    5 
 drivers/misc/habanalabs/common/firmware_if.c                       |    5 
 drivers/misc/habanalabs/common/habanalabs_drv.c                    |    2 
 drivers/misc/habanalabs/common/mmu/mmu.c                           |   14 
 drivers/misc/habanalabs/gaudi/gaudi.c                              |    7 
 drivers/misc/habanalabs/goya/goya.c                                |    1 
 drivers/misc/ibmasm/module.c                                       |    5 
 drivers/net/virtio_net.c                                           |   27 
 drivers/nvme/target/tcp.c                                          |    1 
 drivers/pci/controller/dwc/pcie-intel-gw.c                         |   10 
 drivers/pci/controller/dwc/pcie-tegra194.c                         |    2 
 drivers/pci/controller/pci-ftpci100.c                              |   30 
 drivers/pci/controller/pci-hyperv.c                                |   30 
 drivers/pci/controller/pci-tegra.c                                 |    1 
 drivers/pci/controller/pcie-iproc-msi.c                            |   29 
 drivers/pci/controller/pcie-mediatek-gen3.c                        |    1 
 drivers/pci/controller/pcie-rockchip-host.c                        |   12 
 drivers/pci/ecam.c                                                 |   54 
 drivers/pci/hotplug/pciehp_hpc.c                                   |   36 
 drivers/pci/p2pdma.c                                               |   34 
 drivers/pci/pci-label.c                                            |    2 
 drivers/pci/pci.h                                                  |    4 
 drivers/pci/pcie/dpc.c                                             |   74 
 drivers/phy/intel/phy-intel-keembay-emmc.c                         |    3 
 drivers/power/reset/gpio-poweroff.c                                |    1 
 drivers/power/reset/regulator-poweroff.c                           |    1 
 drivers/power/supply/Kconfig                                       |    3 
 drivers/power/supply/ab8500-bm.h                                   |    6 
 drivers/power/supply/ab8500_btemp.c                                |  119 -
 drivers/power/supply/ab8500_charger.c                              |  378 ++--
 drivers/power/supply/ab8500_fg.c                                   |  137 -
 drivers/power/supply/abx500_chargalg.c                             |  116 -
 drivers/power/supply/axp288_fuel_gauge.c                           |   18 
 drivers/power/supply/charger-manager.c                             |    1 
 drivers/power/supply/max17040_battery.c                            |    4 
 drivers/power/supply/max17042_battery.c                            |    2 
 drivers/power/supply/rt5033_battery.c                              |    7 
 drivers/power/supply/sc2731_charger.c                              |    1 
 drivers/power/supply/sc27xx_fuel_gauge.c                           |    1 
 drivers/power/supply/surface_battery.c                             |   14 
 drivers/power/supply/surface_charger.c                             |    2 
 drivers/pwm/pwm-img.c                                              |    2 
 drivers/pwm/pwm-imx1.c                                             |    2 
 drivers/pwm/pwm-pca9685.c                                          |   74 
 drivers/pwm/pwm-spear.c                                            |    4 
 drivers/pwm/pwm-tegra.c                                            |   13 
 drivers/pwm/pwm-visconti.c                                         |   17 
 drivers/remoteproc/remoteproc_cdev.c                               |    2 
 drivers/remoteproc/remoteproc_core.c                               |    2 
 drivers/remoteproc/stm32_rproc.c                                   |   16 
 drivers/remoteproc/ti_k3_r5_remoteproc.c                           |    2 
 drivers/reset/Kconfig                                              |    4 
 drivers/reset/core.c                                               |    5 
 drivers/reset/reset-a10sr.c                                        |    1 
 drivers/reset/reset-brcmstb.c                                      |    1 
 drivers/rtc/Kconfig                                                |    3 
 drivers/rtc/proc.c                                                 |    4 
 drivers/s390/char/sclp_vt220.c                                     |    4 
 drivers/s390/scsi/zfcp_sysfs.c                                     |    1 
 drivers/scsi/arcmsr/arcmsr_hba.c                                   |   19 
 drivers/scsi/be2iscsi/be_main.c                                    |    5 
 drivers/scsi/bnx2i/bnx2i_iscsi.c                                   |    2 
 drivers/scsi/cxgbi/libcxgbi.c                                      |    4 
 drivers/scsi/device_handler/scsi_dh_alua.c                         |   11 
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c                             |   12 
 drivers/scsi/hosts.c                                               |    4 
 drivers/scsi/libiscsi.c                                            |  122 -
 drivers/scsi/lpfc/lpfc_els.c                                       |    9 
 drivers/scsi/lpfc/lpfc_sli.c                                       |    5 
 drivers/scsi/megaraid/megaraid_sas.h                               |   12 
 drivers/scsi/megaraid/megaraid_sas_base.c                          |   96 +
 drivers/scsi/megaraid/megaraid_sas_fp.c                            |    6 
 drivers/scsi/megaraid/megaraid_sas_fusion.c                        |   10 
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                               |   22 
 drivers/scsi/qedi/qedi.h                                           |    1 
 drivers/scsi/qedi/qedi_fw.c                                        |   24 
 drivers/scsi/qedi/qedi_iscsi.c                                     |   37 
 drivers/scsi/qedi/qedi_main.c                                      |    2 
 drivers/scsi/scsi_lib.c                                            |   10 
 drivers/scsi/scsi_transport_iscsi.c                                |   12 
 drivers/scsi/scsi_transport_sas.c                                  |    9 
 drivers/scsi/sd.c                                                  |   12 
 drivers/scsi/sr.c                                                  |    2 
 drivers/scsi/storvsc_drv.c                                         |   61 
 drivers/soc/mediatek/mtk-pm-domains.c                              |   42 
 drivers/soundwire/bus.c                                            |  151 -
 drivers/staging/rtl8723bs/hal/odm.h                                |    5 
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c                     |    7 
 drivers/thermal/rcar_gen3_thermal.c                                |    2 
 drivers/thermal/sprd_thermal.c                                     |    1 
 drivers/thunderbolt/eeprom.c                                       |   19 
 drivers/tty/serial/8250/8250_of.c                                  |    4 
 drivers/tty/serial/8250/serial_cs.c                                |   11 
 drivers/tty/serial/fsl_lpuart.c                                    |    9 
 drivers/tty/serial/uartlite.c                                      |   27 
 drivers/usb/common/usb-conn-gpio.c                                 |   44 
 drivers/usb/dwc3/dwc3-pci.c                                        |    8 
 drivers/usb/gadget/function/f_hid.c                                |    2 
 drivers/usb/gadget/legacy/hid.c                                    |    4 
 drivers/usb/host/xhci.c                                            |    9 
 drivers/vdpa/mlx5/core/mr.c                                        |    9 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                                  |   30 
 drivers/vdpa/virtio_pci/vp_vdpa.c                                  |    1 
 drivers/video/backlight/lm3630a_bl.c                               |   12 
 drivers/video/fbdev/core/fbmem.c                                   |   12 
 drivers/virtio/virtio_mem.c                                        |   15 
 drivers/w1/slaves/w1_ds2438.c                                      |    4 
 drivers/watchdog/aspeed_wdt.c                                      |    2 
 drivers/watchdog/iTCO_wdt.c                                        |   12 
 drivers/watchdog/imx_sc_wdt.c                                      |   11 
 drivers/watchdog/jz4740_wdt.c                                      |    4 
 drivers/watchdog/keembay_wdt.c                                     |   15 
 drivers/watchdog/lpc18xx_wdt.c                                     |    2 
 drivers/watchdog/sbc60xxwdt.c                                      |    2 
 drivers/watchdog/sc520_wdt.c                                       |    2 
 drivers/watchdog/w83877f_wdt.c                                     |    2 
 fs/btrfs/block-group.c                                             |  355 +++-
 fs/btrfs/block-group.h                                             |    6 
 fs/btrfs/ctree.c                                                   |   67 
 fs/btrfs/inode.c                                                   |  147 +
 fs/btrfs/transaction.c                                             |   15 
 fs/btrfs/transaction.h                                             |    9 
 fs/btrfs/tree-log.c                                                |    2 
 fs/btrfs/volumes.c                                                 |  355 +++-
 fs/btrfs/volumes.h                                                 |    5 
 fs/ceph/addr.c                                                     |   10 
 fs/cifs/cifs_dfs_ref.c                                             |    6 
 fs/cifs/cifsglob.h                                                 |    4 
 fs/cifs/connect.c                                                  |   61 
 fs/cifs/dns_resolve.c                                              |   10 
 fs/cifs/dns_resolve.h                                              |    2 
 fs/cifs/misc.c                                                     |    2 
 fs/ext4/ext4_jbd2.c                                                |    2 
 fs/ext4/super.c                                                    |   12 
 fs/f2fs/gc.c                                                       |    5 
 fs/f2fs/namei.c                                                    |   16 
 fs/f2fs/super.c                                                    |    1 
 fs/fuse/dir.c                                                      |    2 
 fs/fuse/fuse_i.h                                                   |   10 
 fs/fuse/inode.c                                                    |   44 
 fs/fuse/readdir.c                                                  |    7 
 fs/fuse/virtio_fs.c                                                |    1 
 fs/io-wq.h                                                         |    1 
 fs/io_uring.c                                                      |  221 +-
 fs/jfs/jfs_logmgr.c                                                |    1 
 fs/nfs/delegation.c                                                |   71 
 fs/nfs/delegation.h                                                |    1 
 fs/nfs/direct.c                                                    |   17 
 fs/nfs/fscache.c                                                   |   18 
 fs/nfs/getroot.c                                                   |   12 
 fs/nfs/inode.c                                                     |   54 
 fs/nfs/nfs3proc.c                                                  |    4 
 fs/nfs/nfs4_fs.h                                                   |    1 
 fs/nfs/nfs4client.c                                                |   82 -
 fs/nfs/nfs4proc.c                                                  |   33 
 fs/nfs/pnfs.c                                                      |   40 
 fs/nfs/pnfs_nfs.c                                                  |   52 
 fs/nfs/read.c                                                      |   11 
 fs/nfsd/nfs3acl.c                                                  |    3 
 fs/nfsd/nfs4state.c                                                |   14 
 fs/nfsd/trace.h                                                    |   31 
 fs/nfsd/vfs.c                                                      |   18 
 fs/orangefs/super.c                                                |    2 
 fs/seq_file.c                                                      |    3 
 fs/ubifs/dir.c                                                     |    7 
 fs/ubifs/journal.c                                                 |    1 
 include/linux/compiler-clang.h                                     |   17 
 include/linux/compiler-gcc.h                                       |    6 
 include/linux/compiler_types.h                                     |    2 
 include/linux/nfs_fs.h                                             |    1 
 include/linux/pci-ecam.h                                           |    1 
 include/linux/rcupdate.h                                           |    2 
 include/linux/sched/signal.h                                       |   19 
 include/linux/soundwire/sdw.h                                      |    2 
 include/scsi/libiscsi.h                                            |   11 
 include/scsi/scsi_transport_iscsi.h                                |    2 
 include/uapi/linux/fuse.h                                          |   10 
 kernel/cgroup/cgroup-v1.c                                          |    2 
 kernel/jump_label.c                                                |   13 
 kernel/kprobes.c                                                   |    2 
 kernel/module.c                                                    |    3 
 kernel/rcu/rcu.h                                                   |    2 
 kernel/rcu/srcutree.c                                              |    3 
 kernel/rcu/tree.c                                                  |   16 
 kernel/rcu/update.c                                                |    2 
 kernel/sched/sched.h                                               |   21 
 kernel/static_call.c                                               |   13 
 kernel/trace/trace_events_hist.c                                   |    6 
 lib/decompress_unlz4.c                                             |    8 
 lib/iov_iter.c                                                     |    5 
 mm/hugetlb.c                                                       |    5 
 net/bridge/br_multicast.c                                          |    6 
 net/sunrpc/xdr.c                                                   |    7 
 net/sunrpc/xprtsock.c                                              |    3 
 sound/ac97/bus.c                                                   |    2 
 sound/core/control_led.c                                           |    2 
 sound/firewire/Kconfig                                             |    5 
 sound/firewire/bebob/bebob.c                                       |    5 
 sound/firewire/motu/motu-protocol-v2.c                             |   13 
 sound/firewire/oxfw/oxfw.c                                         |    2 
 sound/isa/cmi8330.c                                                |    2 
 sound/isa/sb/sb16_csp.c                                            |    8 
 sound/mips/snd-n64.c                                               |    4 
 sound/pci/hda/hda_tegra.c                                          |    3 
 sound/ppc/powermac.c                                               |    6 
 sound/soc/codecs/cs42l42.c                                         |   47 
 sound/soc/codecs/cs42l42.h                                         |    2 
 sound/soc/fsl/fsl_xcvr.c                                           |    4 
 sound/soc/img/img-i2s-in.c                                         |    2 
 sound/soc/intel/boards/kbl_da7219_max98357a.c                      |    4 
 sound/soc/intel/boards/sof_da7219_max98373.c                       |    1 
 sound/soc/intel/boards/sof_rt5682.c                                |    1 
 sound/soc/intel/boards/sof_sdw.c                                   |   19 
 sound/soc/intel/boards/sof_sdw_common.h                            |    1 
 sound/soc/intel/common/soc-acpi-intel-kbl-match.c                  |    2 
 sound/soc/soc-core.c                                               |    2 
 sound/soc/soc-pcm.c                                                |    2 
 sound/soc/sof/topology.c                                           |    2 
 sound/usb/mixer_scarlett_gen2.c                                    |   39 
 sound/usb/usx2y/usX2Yhwdep.c                                       |   56 
 sound/usb/usx2y/usX2Yhwdep.h                                       |    2 
 sound/usb/usx2y/usb_stream.c                                       |    7 
 sound/usb/usx2y/usbus428ctldefs.h                                  |  102 -
 sound/usb/usx2y/usbusx2y.c                                         |  218 +-
 sound/usb/usx2y/usbusx2y.h                                         |   58 
 sound/usb/usx2y/usbusx2yaudio.c                                    |  448 ++---
 sound/usb/usx2y/usx2yhwdeppcm.c                                    |  410 ++---
 sound/usb/usx2y/usx2yhwdeppcm.h                                    |    4 
 tools/perf/util/parse-events.y                                     |    2 
 tools/perf/util/pmu.c                                              |   36 
 tools/perf/util/pmu.h                                              |    1 
 tools/perf/util/scripting-engines/trace-event-python.c             |   17 
 tools/testing/selftests/kvm/set_memory_region_test.c               |    3 
 tools/testing/selftests/powerpc/pmu/ebb/no_handler_test.c          |    2 
 tools/testing/selftests/timers/rtcpie.c                            |   10 
 virt/kvm/coalesced_mmio.c                                          |    2 
 379 files changed, 5440 insertions(+), 2844 deletions(-)

Al Viro (1):
      iov_iter_advance(): use consistent semantics for move past the end

Alex Bee (2):
      arm64: dts: rockchip: Re-add regulator-boot-on, regulator-always-on for vdd_gpu on rk3399-roc-pc
      arm64: dts: rockchip: Re-add regulator-always-on for vcc_sdio for rk3399-roc-pc

Alexander Shishkin (1):
      intel_th: Wait until port is in reset before programming it

Amir Goldstein (1):
      fuse: fix illegal access to inode with reused nodeid

Aneesh Kumar K.V (1):
      powerpc/mm/book3s64: Fix possible build error

Anna Schumaker (1):
      sunrpc: Avoid a KASAN slab-out-of-bounds bug in xdr_set_page_base()

Arnaud Pouliquen (1):
      remoteproc: stm32: fix mbox_send_message call

Arnd Bergmann (4):
      partitions: msdos: fix one-byte get_unaligned()
      remoteproc: stm32: fix phys_addr_t format string
      rtc: bd70528: fix BD71815 watchdog dependency
      mips: always link byteswap helpers into decompressor

Aswath Govindraju (6):
      arm64: dts: ti: k3-am64-mcu: Fix the compatible string in GPIO DT node
      arm64: dts: ti: k3-j7200: Remove "#address-cells" property from GPIO DT nodes
      ARM: dts: am335x: align ti,pindir-d0-out-d1-in property with dt-shema
      ARM: dts: am437x: align ti,pindir-d0-out-d1-in property with dt-shema
      arm64: dts: ti: am65: align ti,pindir-d0-out-d1-in property with dt-shema
      arm64: dts: ti: k3-am642-evm: align ti,pindir-d0-out-d1-in property with dt-shema

Athira Rajeev (1):
      selftests/powerpc: Fix "no_handler" EBB selftest

Benjamin Herrenschmidt (1):
      powerpc/boot: Fixup device-tree on little endian

Bixuan Cui (1):
      power: reset: gpio-poweroff: add missing MODULE_DEVICE_TABLE

Caleb Connolly (1):
      arm64: dts: qcom: sdm845-oneplus-common: guard rmtfs-mem

Chandrakanth Patil (2):
      scsi: megaraid_sas: Fix resource leak in case of probe failure
      scsi: megaraid_sas: Handle missing interrupts while re-enabling IRQs

Chang S. Bae (1):
      x86/signal: Detect and prevent an alternate signal stack overflow

Chao Yu (4):
      f2fs: atgc: fix to set default age threshold
      f2fs: add MODULE_SOFTDEP to ensure crc32 is included in the initramfs
      f2fs: compress: fix to disallow temp extension
      f2fs: fix to avoid adding tab before doc section

Chen-Yu Tsai (1):
      arm64: dts: rockchip: Drop fephy pinctrl from gmac2phy on rk3328 rock-pi-e

Christian Borntraeger (1):
      KVM: selftests: do not require 64GB in set_memory_region_test

Christian Brauner (1):
      cgroup: verify that source is a string

Christoph Hellwig (1):
      block: grab a device refcount in disk_uevent

Christoph Niedermaier (3):
      ARM: dts: imx6q-dhcom: Fix ethernet reset time properties
      ARM: dts: imx6q-dhcom: Fix ethernet plugin detection problems
      ARM: dts: imx6q-dhcom: Add gpios pinctrl for i2c bus recovery

Christophe JAILLET (4):
      tty: serial: 8250: serial_cs: Fix a memory leak in error handling path
      cpufreq: scmi: Fix an error message
      remoteproc: k3-r5: Fix an error message
      scsi: be2iscsi: Fix an error handling path in beiscsi_dev_probe()

Christophe Leroy (1):
      powerpc/inst: Fix sparse detection on get_user_instr()

Chuck Lever (3):
      NFSD: Fix TP_printk() format specifier in nfsd_clid_class
      NFSD: Add nfsd_clid_confirmed tracepoint
      NFSD: Prevent a possible oops in the nfs_dirent() tracepoint

Chunfeng Yun (1):
      usb: common: usb-conn-gpio: fix NULL pointer dereference of charger

Chunguang Xu (1):
      block: fix the problem of io_ticks becoming smaller

Chunyan Zhang (1):
      thermal/drivers/sprd: Add missing MODULE_DEVICE_TABLE

Clemens Gruber (1):
      pwm: pca9685: Restrict period change for enabled PWMs

Corentin Labbe (1):
      ARM: dts: gemini-rut1xx: remove duplicate ethernet node

Cristian Marussi (2):
      firmware: arm_scmi: Reset Rx buffer to max size during async commands
      firmware: arm_scmi: Add delayed response status check

Dan Carpenter (2):
      rtc: fix snprintf() checking in is_rtc_hctosys()
      scsi: scsi_dh_alua: Fix signedness bug in alua_rtpg()

Daniel Mack (1):
      serial: tty: uartlite: fix console setup

Dave Wysochanski (2):
      NFS: Ensure nfs_readpage returns promptly when internal error occurs
      NFS: Fix fscache read from NFS after cache error

David Hildenbrand (1):
      virtio-mem: don't read big block size in Sub Block Mode

David Sterba (1):
      btrfs: zoned: fix types for u64 division in btrfs_reclaim_bgs_work

Dimitri John Ledkov (1):
      lib/decompress_unlz4.c: correctly handle zero-padding around initrds.

Dmitry Torokhov (1):
      i2c: core: Disable client irq on reboot/shutdown

Douglas Anderson (1):
      arm64: dts: qcom: sc7180: Fix sc7180-qmp-usb3-dp-phy reg sizes

Eli Cohen (4):
      vdpa/mlx5: Fix umem sizes assignments on VQ create
      vdpa/mlx5: Fix possible failure in umem size calculation
      vdp/mlx5: Fix setting the correct dma_device
      vdpa/mlx5: Clear vq ready indication upon device reset

Enric Balletbo i Serra (1):
      arm64: defconfig: Do not override the MTK_PMIC_WRAP symbol

Eric Anholt (1):
      iommu/arm-smmu-qcom: Skip the TTBR1 quirk for db820c.

Eric Sandeen (1):
      seq_file: disallow extremely large seq buffer allocations

Evan Quan (1):
      drm/amdgpu: fix Navi1x tcp power gating hang when issuing lightweight invalidaiton

Fabio Aiuto (2):
      staging: rtl8723bs: fix macro value for 2.4Ghz only device
      staging: rtl8723bs: fix check allowing 5Ghz settings

Fabrice Fontaine (1):
      s390: disable SSP when needed

Filipe Manana (3):
      btrfs: fix deadlock with concurrent chunk allocations involving system chunks
      btrfs: rework chunk allocation to avoid exhaustion of the system chunk array
      btrfs: zoned: fix wrong mutex unlock on failure to allocate log root tree

Frederic Weisbecker (1):
      srcu: Fix broken node geometry after early ssp init

Gao Xiang (1):
      nfs: fix acl memory leak of posix_acl_create()

Geert Uytterhoeven (6):
      reset: RESET_BRCMSTB_RESCAL should depend on ARCH_BRCMSTB
      reset: RESET_INTEL_GW should depend on X86
      ARM: dts: r8a7779, marzen: Fix DU clock names
      arm64: dts: renesas: Add missing opp-suspend properties
      arm64: dts: renesas: r8a7796[01]: Fix OPP table entry voltages
      arm64: dts: renesas: r8a779a0: Drop power-domains property from GIC node

Geoff Levand (1):
      powerpc/ps3: Add dma_mask to ps3_dma_region

Geoffrey D. Bennett (4):
      ALSA: usb-audio: scarlett2: Fix 18i8 Gen 2 PCM Input count
      ALSA: usb-audio: scarlett2: Fix data_mutex lock
      ALSA: usb-audio: scarlett2: Fix scarlett2_*_ctl_put() return values
      ALSA: usb-audio: scarlett2: Fix 6i6 Gen 2 line out descriptions

Gil Fine (1):
      thunderbolt: Fix DROM handling for USB4 DROM

Gowtham Tammana (1):
      ARM: dts: dra7: Fix duplicate USB4 target module node

Greg Kroah-Hartman (1):
      Linux 5.13.4

Greg Kurz (1):
      virtiofs: propagate sync() to file server

Greg Ungerer (1):
      m68knommu: fix missing LCD splash screen data initializer

Grygorii Strashko (1):
      arm64: dts: ti: k3-am642-main: fix ports mac properties

Hannes Reinecke (2):
      scsi: core: Fixup calling convention for scsi_mode_sense()
      scsi: scsi_dh_alua: Check for negative result value

Hans de Goede (2):
      power: supply: axp288_fuel_gauge: Make "T3 MRD" no_battery_list DMI entry more generic
      ACPI: video: Add quirk for the Dell Vostro 3350

Heiko Carstens (4):
      s390/processor: always inline stap() and __load_psw_mask()
      s390/ipl_parm: fix program check new psw handling
      s390/mem_detect: fix diag260() program check new psw handling
      s390/mem_detect: fix tprot() program check new psw handling

Hsin-Yi Wang (1):
      soc: mtk-pm-domains: do not register smi node as syscon

Icenowy Zheng (1):
      arm64: dts: allwinner: a64-sopine-baseboard: change RGMII mode to TXID

J. Bruce Fields (2):
      nfsd: move fsnotify on client creation outside spinlock
      nfsd: fix NULL dereference in nfs3svc_encode_getaclres

Jaegeuk Kim (1):
      f2fs: remove false alarm on iget failure during GC

James Smart (2):
      scsi: lpfc: Fix "Unexpected timeout" error in direct attach topology
      scsi: lpfc: Fix crash when lpfc_sli4_hba_setup() fails to initialize the SGLs

Jan Kiszka (1):
      watchdog: iTCO_wdt: Account for rebooting on second timeout

Jaroslav Kysela (2):
      ALSA: control_led - fix initialization in the mode show callback
      ASoC: soc-pcm: fix the return value in dpcm_apply_symmetry()

Jaska Uimonen (1):
      ASoC: SOF: topology: fix assignment to use le32_to_cpu

Jason Wang (1):
      vp_vdpa: correct the return value when fail to map notification

Javier Martinez Canillas (1):
      PCI: rockchip: Register IRQ handlers after device and data are ready

Jeff Layton (1):
      ceph: remove bogus checks and WARN_ONs from ceph_set_page_dirty

Jiajun Cao (1):
      ALSA: hda: Add IRQ check for platform_get_irq()

Jiapeng Chong (1):
      fs/jfs: Fix missing error code in lmLogInit()

Jim Quinlan (1):
      serial: 8250: of: Check for CONFIG_SERIAL_8250_BCM7271

Jin Yao (1):
      perf tools: Fix pattern matching for same substring in different PMU type

Jing Xiangfeng (1):
      drm/gma500: Add the missed drm_gem_object_put() in psb_user_framebuffer_create()

Jinzhou Su (1):
      drm/amdgpu: add another Renoir DID

Joao Martins (1):
      mm/hugetlb: fix refs calculation from unaligned @vaddr

Johannes Thumshirn (1):
      btrfs: don't block if we can't acquire the reclaim lock

John Garry (1):
      scsi: core: Cap scsi_host cmd_per_lun at can_queue

Jon Hunter (1):
      PCI: tegra194: Fix tegra_pcie_ep_raise_msi_irq() ill-defined shift

Jon Mediero (1):
      module: correctly exit module_kallsyms_on_each_symbol when fn() != 0

Jonathan Cameron (2):
      iio: gyro: fxa21002c: Balance runtime pm + use pm_runtime_resume_and_get().
      iio: magn: bmc150: Balance runtime pm + use pm_runtime_resume_and_get()

José Roberto de Souza (1):
      drm/dp_mst: Add missing drm parameters to recently added call to drm_dbg_kms()

Kajol Jain (1):
      perf script python: Fix buffer size to report iregs in perf script

Kashyap Desai (1):
      scsi: megaraid_sas: Early detection of VD deletion through RaidMap update

Kefeng Wang (1):
      KVM: mmio: Fix use-after-free Read in kvm_vm_ioctl_unregister_coalesced_mmio

Kishon Vijay Abraham I (3):
      arm64: dts: ti: k3-j721e-main: Fix external refclk input to SERDES
      arm64: dts: ti: k3-j721e-common-proc-board: Use external clock for SERDES
      arm64: dts: ti: k3-j721e-common-proc-board: Re-name "link" name as "phy"

Koby Elbaz (4):
      habanalabs/gaudi: set the correct cpu_id on MME2_QM failure
      habanalabs: set rc as 'valid' in case of intentional func exit
      habanalabs: remove node from list before freeing the node
      habanalabs/gaudi: set the correct rc in case of err

Krzysztof Kozlowski (11):
      power: supply: max17042: Do not enforce (incorrect) interrupt trigger type
      power: supply: max17040: Do not enforce (incorrect) interrupt trigger type
      reset: a10sr: add missing of_match_table reference
      ARM: exynos: add missing of_node_put for loop iteration
      ARM: dts: exynos: fix PWM LED max brightness on Odroid XU/XU3
      ARM: dts: exynos: fix PWM LED max brightness on Odroid HC1
      ARM: dts: exynos: fix PWM LED max brightness on Odroid XU4
      memory: stm32-fmc2-ebi: add missing of_node_put for loop iteration
      memory: atmel-ebi: add missing of_node_put for loop iteration
      memory: fsl_ifc: fix leak of IO mapping on probe failure
      memory: fsl_ifc: fix leak of private memory on probe failure

Krzysztof Wilczyński (1):
      PCI/sysfs: Fix dsm_label_utf16s_to_utf8s() buffer overrun

Lai Jiangshan (1):
      KVM: X86: Disable hardware breakpoints unconditionally before kvm_x86->run()

Liguang Zhang (1):
      ACPI: AMBA: Fix resource name in /proc/iomem

Linus Walleij (3):
      power: supply: ab8500: Move to componentized binding
      power: supply: ab8500: Avoid NULL pointers
      power: supply: ab8500: Enable USB and AC

Logan Gunthorpe (1):
      PCI/P2PDMA: Avoid pci_get_slot(), which may sleep

Long Li (1):
      PCI: hv: Fix a race condition when removing the device

Lu Baolu (1):
      iommu/vt-d: Fix clearing real DMA device's scalable-mode context entries

Lucas Tanure (1):
      ASoC: cs42l42: Fix 1536000 Bit Clock instability

Luiz Sampaio (1):
      w1: ds2438: fixing bug that would always get page0

Lukas Wunner (1):
      PCI: pciehp: Ignore Link Down/Up caused by DPC

Lv Yunlong (1):
      misc/libmasm/module: Fix two use after free in ibmasm_init_one

Manivannan Sadhasivam (2):
      ARM: dts: qcom: sdx55-t55: Represent secure-regions as 64-bit elements
      ARM: dts: qcom: sdx55-telit: Represent secure-regions as 64-bit elements

Marco Elver (1):
      kcov: add __no_sanitize_coverage to fix noinstr for all architectures

Marek Behún (2):
      firmware: turris-mox-rwtm: fix reply status decoding function
      firmware: turris-mox-rwtm: report failures better

Marek Vasut (1):
      ARM: dts: stm32: Rework LAN8710Ai PHY reset on DHCOM SoM

Martin Blumenstingl (1):
      PCI: intel-gw: Fix INTx enable

Martin Fäcknitz (1):
      MIPS: vdso: Invalid GIC access through VDSO

Masahiro Yamada (1):
      kbuild: remove trailing slashes from $(KBUILD_EXTMOD)

Mathias Nyman (1):
      xhci: handle failed buffer copy to URB sg list and fix a W=1 copiler warning

Matthew Auld (1):
      drm/i915/gtt: drop the page table optimisation

Maurizio Lombardi (1):
      nvme-tcp: can't set sk_user_data without write_lock

Maxim Levitsky (2):
      KVM: SVM: #SMI interception must not skip the instruction
      KVM: SVM: remove INIT intercept handler

Maximilian Luz (2):
      power: supply: surface_battery: Fix battery event handling
      power: supply: surface-charger: Fix type of integer variable

Michael Kelley (1):
      scsi: storvsc: Correctly handle multiple flags in srb_status

Michael S. Tsirkin (1):
      virtio_net: move tx vq operation under tx queue lock

Michael Walle (1):
      serial: fsl_lpuart: disable DMA for console and fix sysrq

Mike Christie (7):
      scsi: iscsi: Add iscsi_cls_conn refcount helpers
      scsi: iscsi: Fix conn use after free during resets
      scsi: iscsi: Fix shost->max_id use
      scsi: qedi: Fix null ref during abort handling
      scsi: qedi: Fix race during abort timeouts
      scsi: qedi: Fix TMF session block/unblock use
      scsi: qedi: Fix cleanup session block/unblock use

Mike Marshall (1):
      orangefs: fix orangefs df output.

Naohiro Aota (1):
      btrfs: properly split extent_map for REQ_OP_ZONE_APPEND

Nathan Chancellor (2):
      hexagon: handle {,SOFT}IRQENTRY_TEXT in linker script
      hexagon: use common DISCARDS macro

Naveen N. Rao (1):
      powerpc/bpf: Fix detecting BPF atomic instructions

NeilBrown (1):
      SUNRPC: prevent port reuse on transports which don't request it.

Nick Desaulniers (1):
      ARM: 9087/1: kprobes: test-thumb: fix for LLVM_IAS=1

Nicolas Ferre (1):
      dt-bindings: i2c: at91: fix example for scl-gpios

Niklas Söderlund (1):
      thermal/drivers/rcar_gen3_thermal: Fix coefficient calculations

Nikolay Aleksandrov (2):
      net: bridge: multicast: fix PIM hello router port marking race
      net: bridge: multicast: fix MRD advertisement router port marking race

Ohad Sharabi (2):
      habanalabs: check if asic secured with asic type
      habanalabs: fix mask to obtain page offset

Pali Rohár (2):
      firmware: turris-mox-rwtm: fail probing when firmware does not support hwrng
      firmware: turris-mox-rwtm: show message about HWRNG registration

Paul E. McKenney (1):
      rcu: Reject RCU_LOCKDEP_WARN() false positives

Paulo Alcantara (1):
      cifs: handle reconnect of tcon when there is no cached dfs referral

Pavel Begunkov (7):
      io_uring: use right task for exiting checks
      io_uring: get rid of files in exit cancel
      io_uring: shuffle rarely used ctx fields
      io_uring: don't bounce submit_state cachelines
      io_uring: move creds from io-wq work to io_kiocb
      io_uring: inline __tctx_task_work()
      io_uring: remove not needed PF_EXITING check

Peter Robinson (1):
      gpio: pca953x: Add support for the On Semi pca9655

Peter Zijlstra (3):
      jump_label: Fix jump_label_text_reserved() vs __init
      static_call: Fix static_call_text_reserved() vs __init
      kprobe/static_call: Restore missing static_call_text_reserved()

Philip Yang (1):
      drm/amdkfd: fix sysfs kobj leak

Philipp Zabel (1):
      reset: bail if try_module_get() fails

Pierre-Louis Bossart (4):
      ASoC: Intel: sof_sdw: add mutual exclusion between PCH DMIC and RT715
      soundwire: bus: only use CLOCK_STOP_MODE0 and fix confusions
      soundwire: bus: handle -ENODATA errors in clock stop/start sequences
      ASoC: Intel: kbl_da7219_max98357a: shrink platform_id below 20 characters

Po-Hsu Lin (1):
      selftests: timers: rtcpie: skip test if default RTC device does not exist

Rafał Miłecki (1):
      ARM: dts: BCM5301X: Fixup SPI binding

Randy Dunlap (3):
      EDAC/igen6: fix core dependency AGAIN
      PCI: ftpci100: Rename macro name collision
      mips: disable branch profiling in boot/decompress.o

Rashmi A (1):
      phy: intel: Fix for warnings due to EMMC clock 175Mhz change in FIP

Raymond Tan (1):
      usb: dwc3: pci: Fix DEFINE for Intel Elkhart Lake

Robin Gong (1):
      dmaengine: fsl-qdma: check dma_set_mask return value

Robin Murphy (1):
      arm64: Avoid premature usercopy failure

Roger Quadros (1):
      arm64: dts: ti: j7200-main: Enable USB2 PHY RX sensitivity workaround

Ronnie Sahlberg (1):
      cifs: Do not use the original cruid when following DFS links for multiuser mounts

Ruslan Bilovol (1):
      usb: gadget: f_hid: fix endianness issue with descriptors

Russell King (1):
      PCI: Dynamically map ECAM regions

Salvatore Bonaccorso (1):
      ARM: dts: sun8i: h3: orangepi-plus: Fix ethernet phy-mode

Sandor Bodo-Merle (2):
      PCI: iproc: Fix multi-MSI base vector number allocation
      PCI: iproc: Support multi-MSI only on uniprocessor kernel

Sanjay Kumar (1):
      iommu/vt-d: Global devTLB flush when present context entry changed

Scott Mayhew (1):
      nfs: update has_sec_mnt_opts after cloning lsm options from parent

Sean Christopherson (4):
      KVM: x86: Use guest MAXPHYADDR from CPUID.0x8000_0008 iff TDP is enabled
      KVM: x86: Use kernel's x86_phys_bits to handle reduced MAXPHYADDR
      KVM: x86/mmu: Do not apply HPA (memory encryption) mask to GPAs
      KVM: SVM: Revert clearing of C-bit on GPA in #NPF handler

Sean Nyekjaer (1):
      iio: imu: st_lsm6dsx: correct ODR in header

Sergey Shtylyov (1):
      scsi: hisi_sas: Propagate errors in interrupt_init_v1_hw()

Sherry Sun (1):
      tty: serial: fsl_lpuart: fix the potential risk of division or modulo by zero

Shruthi Sanil (6):
      watchdog: keembay: Update WDT pre-timeout during the initialization
      watchdog: keembay: Upadate WDT pretimeout for every update in timeout
      watchdog: keembay: Update pretimeout to zero in the TH ISR
      watchdog: keembay: Clear either the TO or TH interrupt bit
      watchdog: keembay: Remove timeout update in the WDT start function
      watchdog: keembay: Removed timeout update in the TO ISR

Shyam Prasad N (1):
      cifs: use the expiry output of dns_query to schedule next resolution

Siddharth Gupta (1):
      remoteproc: core: Fix cdev remove and rproc del

Srinivas Neeli (2):
      gpio: zynq: Check return value of pm_runtime_get_sync
      gpio: zynq: Check return value of irq_get_irq_data

Stefan Eichenberger (1):
      watchdog: imx_sc_wdt: fix pretimeout

Stefan Wahren (1):
      Revert "ARM: dts: bcm283x: increase dwc2's RX FIFO size"

Steffen Maier (1):
      scsi: zfcp: Report port fc_security as unknown early during remote cable pull

Stephan Gerhold (1):
      power: supply: rt5033_battery: Fix device tree enumeration

Stephen Boyd (2):
      arm64: dts: qcom: trogdor: Add no-hpd to DSI bridge node
      arm64: dts: qcom: c630: Add no-hpd to DSI bridge node

Steven Rostedt (VMware) (1):
      tracing: Do not reference char * as a string in histograms

Suganath Prabu S (1):
      scsi: mpt3sas: Fix deadlock while cancelling the running firmware event

Sven Schnelle (1):
      s390/irq: remove HAVE_IRQ_EXIT_ON_IRQ_STACK

Takashi Iwai (3):
      ALSA: usx2y: Avoid camelCase
      ALSA: usx2y: Don't call free_pages_exact() with NULL address
      ALSA: sb: Fix potential double-free of CSP mixer elements

Takashi Sakamoto (3):
      Revert "ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro"
      ALSA: bebob: add support for ToneWeal FW66
      ALSA: firewire-motu: fix detection for S/PDIF source on optical interface in v2 protocol

Tao Ren (1):
      watchdog: aspeed: fix hardware timeout calculation

Thomas Gleixner (3):
      x86/fpu: Return proper error codes from user access functions
      x86/fpu: Fix copy_xstate_to_kernel() gap handling
      x86/fpu: Limit xstate copy size in xstateregs_set()

Tianling Shen (1):
      arm64: dts: rockchip: rename LED label for NanoPi R4S

Tong Zhang (2):
      misc: alcor_pci: fix null-ptr-deref when there is no PCI bridge
      misc: alcor_pci: fix inverted branch condition

Tony Lindgren (1):
      mfd: cpcap: Fix cpcap dmamask not set warnings

Trond Myklebust (10):
      NFSv4: Fix delegation return in cases where we have to retry
      NFS: Fix up inode attribute revalidation timeouts
      NFSv4: Fix handling of non-atomic change attrbute updates
      NFS: nfs_find_open_context() may only select open files
      NFSv4: Initialise connection to the server in nfs4_alloc_client()
      NFSv4: Fix an Oops in pnfs_mark_request_commit() when doing O_DIRECT
      nfsd: Reduce contention for the nfsd_file nf_rwsem
      NFSv4/pnfs: Fix the layout barrier update
      NFSv4/pnfs: Fix layoutget behaviour after invalidation
      NFSv4/pNFS: Don't call _nfs4_pnfs_v3_ds_connect multiple times

Tyrel Datwyler (1):
      scsi: core: Fix bad pointer dereference when ehandler kthread is invalid

Uwe Kleine-König (5):
      backlight: lm3630a: Fix return code of .update_status() callback
      pwm: spear: Don't modify HW state in .remove callback
      pwm: tegra: Don't modify HW state in .remove callback
      pwm: visconti: Fix and simplify period calculation
      pwm: imx1: Don't disable clocks at device remove time

Valentin Vidic (1):
      s390/sclp_vt220: fix console name to match device

Valentine Barshak (1):
      arm64: dts: renesas: v3msk: Fix memory size

Ville Syrjälä (1):
      drm/i915/gt: Fix -EDEADLK handling regression

Viresh Kumar (2):
      arch_topology: Avoid use-after-free for scale_freq_data
      cpufreq: CPPC: Fix potential memleak in cppc_cpufreq_cpu_init

Vitaly Kuznetsov (1):
      KVM: nSVM: Check the value written to MSR_VM_HSAVE_PA

Wayne Lin (2):
      drm/dp_mst: Do not set proposed vcpi directly
      drm/dp_mst: Avoid to mess up payload table by ports in stale topology

Wei Yongjun (1):
      watchdog: jz4740: Fix return value check in jz4740_wdt_probe()

Weiyi Lu (1):
      soc: mtk-pm-domains: Fix the clock prepared issue

Xie Yongji (3):
      virtio-blk: Fix memory leak among suspend/resume procedure
      virtio_net: Fix error handling in virtnet_restore()
      virtio_console: Assure used length from device is limited

Xiyu Yang (2):
      iommu/arm-smmu: Fix arm_smmu_device refcount leak when arm_smmu_rpm_get fails
      iommu/arm-smmu: Fix arm_smmu_device refcount leak in address translation

Xuewen Yan (1):
      sched/uclamp: Ignore max aggregation if rq is idle

Yang Yingliang (5):
      leds: tlc591xx: fix return value check in tlc591xx_probe()
      ALSA: n64: check return value after calling platform_get_resource()
      ALSA: ppc: fix error return code in snd_pmac_probe()
      usb: gadget: hid: fix error return code in hid_bind()
      ASoC: fsl_xcvr: check return value after calling platform_get_resource_byname()

Ye Bin (1):
      ext4: fix WARN_ON_ONCE(!buffer_uptodate) after an error writing the superblock

YiFei Zhu (1):
      um: Fix stack pointer alignment

Yizhuo Zhai (1):
      Input: hideep - fix the uninitialized use in hideep_nvm_unlock()

Yufen Yu (2):
      ALSA: ac97: fix PM reference leak in ac97_bus_remove()
      ASoC: img: Fix PM reference leak in img_i2s_in_probe()

Zhen Lei (8):
      fbmem: Do not delete the mode that is still in use
      ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()
      um: fix error return code in slip_open()
      um: fix error return code in winch_tramp()
      ubifs: journal: Fix error return code in ubifs_jnl_write_inode()
      ALSA: isa: Fix error return code in snd_cmi8330_probe()
      memory: pl353: Fix error return code in pl353_smc_probe()
      firmware: tegra: Fix error return code in tegra210_bpmp_init()

Zhihao Cheng (1):
      ubifs: Set/Clear I_LINKABLE under i_lock for whiteout inode

Zou Wei (16):
      ASoC: intel/boards: add missing MODULE_DEVICE_TABLE
      mfd: da9052/stmpe: Add and modify MODULE_DEVICE_TABLE
      fsi: Add missing MODULE_DEVICE_TABLE
      leds: turris-omnia: add missing MODULE_DEVICE_TABLE
      power: supply: sc27xx: Add missing MODULE_DEVICE_TABLE
      power: supply: sc2731_charger: Add missing MODULE_DEVICE_TABLE
      watchdog: Fix possible use-after-free in wdt_startup()
      watchdog: sc520_wdt: Fix possible use-after-free in wdt_turnoff()
      watchdog: Fix possible use-after-free by calling del_timer_sync()
      PCI: mediatek-gen3: Add missing MODULE_DEVICE_TABLE
      PCI: tegra: Add missing MODULE_DEVICE_TABLE
      power: reset: regulator-poweroff: add missing MODULE_DEVICE_TABLE
      power: supply: charger-manager: add missing MODULE_DEVICE_TABLE
      power: supply: ab8500: add missing MODULE_DEVICE_TABLE
      pwm: img: Fix PM reference leak in img_pwm_enable()
      reset: brcmstb: Add missing MODULE_DEVICE_TABLE

ching Huang (2):
      scsi: arcmsr: Fix the wrong CDB payload report to IOP
      scsi: arcmsr: Fix doorbell status being updated late on ARC-1886

