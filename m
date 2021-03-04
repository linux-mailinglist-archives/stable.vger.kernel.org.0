Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2C732D174
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 12:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbhCDLCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 06:02:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239181AbhCDLB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 06:01:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99D6B64F31;
        Thu,  4 Mar 2021 11:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614855676;
        bh=3kgBsbsML4TtC+BAN9Kn3hOYkinObBFmE2q0zqtg1SY=;
        h=From:To:Cc:Subject:Date:From;
        b=kkipjmFjf0pRZRGdb32xkT6jeZvbPINeUH6D1mHSBzof7O3E7G+P6uyml9cz28iar
         gwsGbxmvC5qJTxfUrSbxvBHFvSighGGFGK/NmxHxT7fEYnexfaOFMuuAW0hi4pFB+2
         0OxcGq2YcFl6v6ri0T/yJK3DBQsXEhNxZlPZxAVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.20
Date:   Thu,  4 Mar 2021 12:01:12 +0100
Message-Id: <1614855672230162@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.20 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/perf/arm-cmn.rst                                                         |    2 
 Documentation/admin-guide/sysctl/vm.rst                                                            |   10 
 Documentation/filesystems/seq_file.rst                                                             |    6 
 Documentation/scsi/libsas.rst                                                                      |    1 
 Documentation/security/keys/core.rst                                                               |    4 
 Makefile                                                                                           |    2 
 arch/arm/boot/compressed/head.S                                                                    |    4 
 arch/arm/boot/dts/armada-388-helios4.dts                                                           |   28 
 arch/arm/boot/dts/aspeed-g4.dtsi                                                                   |    1 
 arch/arm/boot/dts/aspeed-g5.dtsi                                                                   |    1 
 arch/arm/boot/dts/aspeed-g6.dtsi                                                                   |    1 
 arch/arm/boot/dts/exynos3250-artik5.dtsi                                                           |    2 
 arch/arm/boot/dts/exynos3250-monk.dts                                                              |    2 
 arch/arm/boot/dts/exynos3250-rinato.dts                                                            |    2 
 arch/arm/boot/dts/exynos5250-spring.dts                                                            |    2 
 arch/arm/boot/dts/exynos5420-arndale-octa.dts                                                      |    2 
 arch/arm/boot/dts/exynos5422-odroid-core.dtsi                                                      |    2 
 arch/arm/boot/dts/omap443x.dtsi                                                                    |    2 
 arch/arm/kernel/sys_oabi-compat.c                                                                  |   15 
 arch/arm/mach-at91/pm_suspend.S                                                                    |    2 
 arch/arm/mach-ixp4xx/Kconfig                                                                       |    1 
 arch/arm/mach-s3c/irq-s3c24xx-fiq.S                                                                |    9 
 arch/arm64/Kconfig                                                                                 |    2 
 arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts                                              |    5 
 arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi                                               |    1 
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi                                                      |    6 
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi                                                       |    7 
 arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts                                             |    7 
 arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi                                              |    2 
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts                                                    |    2 
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi                                                      |    4 
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts                                             |    2 
 arch/arm64/boot/dts/mediatek/mt7622.dtsi                                                           |    2 
 arch/arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi                                         |    6 
 arch/arm64/boot/dts/qcom/msm8916-samsung-a5u-eur.dts                                               |    2 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                                                              |    4 
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts                                                           |    9 
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts                                                         |    4 
 arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi                                          |    2 
 arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi                                                |    4 
 arch/arm64/boot/dts/rockchip/rk3328.dtsi                                                           |    1 
 arch/arm64/crypto/aes-glue.c                                                                       |    4 
 arch/arm64/crypto/sha1-ce-glue.c                                                                   |    1 
 arch/arm64/crypto/sha2-ce-glue.c                                                                   |    2 
 arch/arm64/crypto/sha3-ce-glue.c                                                                   |    4 
 arch/arm64/crypto/sha512-ce-glue.c                                                                 |    2 
 arch/arm64/include/asm/module.lds.h                                                                |    6 
 arch/arm64/kernel/cpufeature.c                                                                     |    2 
 arch/arm64/kernel/head.S                                                                           |    1 
 arch/arm64/kernel/machine_kexec_file.c                                                             |    4 
 arch/arm64/kernel/probes/uprobes.c                                                                 |    2 
 arch/arm64/kernel/ptrace.c                                                                         |    2 
 arch/arm64/kernel/suspend.c                                                                        |    2 
 arch/csky/kernel/ptrace.c                                                                          |    2 
 arch/mips/Makefile                                                                                 |   19 
 arch/mips/cavium-octeon/setup.c                                                                    |    9 
 arch/mips/include/asm/asm.h                                                                        |   18 
 arch/mips/include/asm/atomic.h                                                                     |    2 
 arch/mips/include/asm/cmpxchg.h                                                                    |    6 
 arch/mips/kernel/cpu-probe.c                                                                       |   15 
 arch/mips/kernel/vmlinux.lds.S                                                                     |    2 
 arch/mips/lantiq/irq.c                                                                             |    2 
 arch/mips/loongson64/Platform                                                                      |   22 
 arch/mips/mm/c-r4k.c                                                                               |    2 
 arch/mips/vdso/Makefile                                                                            |    5 
 arch/nios2/kernel/entry.S                                                                          |    3 
 arch/nios2/kernel/sys_nios2.c                                                                      |   11 
 arch/powerpc/Kconfig                                                                               |    2 
 arch/powerpc/include/asm/kexec.h                                                                   |    1 
 arch/powerpc/include/asm/uaccess.h                                                                 |   13 
 arch/powerpc/kernel/entry_32.S                                                                     |    3 
 arch/powerpc/kernel/head_32.h                                                                      |    2 
 arch/powerpc/kernel/head_8xx.S                                                                     |    2 
 arch/powerpc/kernel/head_book3s_32.S                                                               |    6 
 arch/powerpc/kernel/irq.c                                                                          |   27 
 arch/powerpc/kernel/prom_init.c                                                                    |   12 
 arch/powerpc/kernel/time.c                                                                         |    2 
 arch/powerpc/kexec/elf_64.c                                                                        |    2 
 arch/powerpc/kexec/file_load_64.c                                                                  |   35 
 arch/powerpc/kvm/powerpc.c                                                                         |    8 
 arch/powerpc/platforms/pseries/dlpar.c                                                             |    7 
 arch/riscv/kernel/vdso/Makefile                                                                    |    3 
 arch/s390/kernel/vtime.c                                                                           |    3 
 arch/sparc/Kconfig                                                                                 |    2 
 arch/sparc/kernel/led.c                                                                            |    2 
 arch/sparc/lib/memset.S                                                                            |    1 
 arch/um/include/shared/skas/mm_id.h                                                                |    1 
 arch/um/kernel/tlb.c                                                                               |   19 
 arch/um/os-Linux/skas/process.c                                                                    |    4 
 arch/x86/crypto/aesni-intel_glue.c                                                                 |   28 
 arch/x86/entry/common.c                                                                            |    2 
 arch/x86/include/asm/virtext.h                                                                     |   17 
 arch/x86/kernel/msr.c                                                                              |    7 
 arch/x86/kernel/reboot.c                                                                           |   30 
 arch/x86/kvm/emulate.c                                                                             |    4 
 arch/x86/kvm/mmu/tdp_mmu.c                                                                         |    3 
 arch/x86/kvm/svm/nested.c                                                                          |   22 
 arch/x86/kvm/svm/svm.c                                                                             |    8 
 arch/x86/mm/fault.c                                                                                |   27 
 arch/x86/mm/pat/memtype.c                                                                          |    4 
 block/bfq-iosched.c                                                                                |    1 
 block/blk-settings.c                                                                               |   12 
 block/bsg.c                                                                                        |    4 
 block/ioctl.c                                                                                      |   21 
 certs/blacklist.c                                                                                  |    2 
 crypto/ecdh_helper.c                                                                               |    3 
 crypto/michael_mic.c                                                                               |   31 
 drivers/acpi/acpi_configfs.c                                                                       |    7 
 drivers/acpi/property.c                                                                            |   44 
 drivers/amba/bus.c                                                                                 |   20 
 drivers/ata/ahci_brcm.c                                                                            |   14 
 drivers/auxdisplay/ht16k33.c                                                                       |    3 
 drivers/base/regmap/regmap-sdw.c                                                                   |    4 
 drivers/base/swnode.c                                                                              |    8 
 drivers/block/floppy.c                                                                             |   30 
 drivers/bluetooth/btqcomsmd.c                                                                      |   27 
 drivers/bluetooth/btusb.c                                                                          |   20 
 drivers/bluetooth/hci_ldisc.c                                                                      |   41 
 drivers/bluetooth/hci_qca.c                                                                        |    2 
 drivers/bluetooth/hci_serdev.c                                                                     |    4 
 drivers/char/hw_random/ingenic-trng.c                                                              |    6 
 drivers/char/hw_random/timeriomem-rng.c                                                            |    2 
 drivers/char/random.c                                                                              |    2 
 drivers/char/tpm/tpm.h                                                                             |    4 
 drivers/char/tpm/tpm_tis_core.c                                                                    |   50 
 drivers/clk/clk-ast2600.c                                                                          |   37 
 drivers/clk/clk-divider.c                                                                          |    9 
 drivers/clk/meson/clk-pll.c                                                                        |   10 
 drivers/clk/qcom/gcc-msm8998.c                                                                     |  100 -
 drivers/clk/renesas/r8a779a0-cpg-mssr.c                                                            |    3 
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c                                                               |   10 
 drivers/clocksource/Kconfig                                                                        |    1 
 drivers/clocksource/mxs_timer.c                                                                    |    5 
 drivers/cpufreq/acpi-cpufreq.c                                                                     |   62 
 drivers/cpufreq/brcmstb-avs-cpufreq.c                                                              |   24 
 drivers/cpufreq/freq_table.c                                                                       |    8 
 drivers/cpufreq/intel_pstate.c                                                                     |   21 
 drivers/cpufreq/qcom-cpufreq-hw.c                                                                  |   40 
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c                                                |  173 +-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h                                                       |    2 
 drivers/crypto/bcm/cipher.c                                                                        |    2 
 drivers/crypto/bcm/cipher.h                                                                        |    4 
 drivers/crypto/bcm/util.c                                                                          |    2 
 drivers/crypto/talitos.c                                                                           |   50 
 drivers/crypto/talitos.h                                                                           |    1 
 drivers/dax/bus.c                                                                                  |    2 
 drivers/dma/fsldma.c                                                                               |    6 
 drivers/dma/hsu/pci.c                                                                              |   21 
 drivers/dma/idxd/dma.c                                                                             |    1 
 drivers/dma/owl-dma.c                                                                              |    1 
 drivers/firmware/arm_scmi/driver.c                                                                 |    4 
 drivers/gpio/gpio-pcf857x.c                                                                        |    2 
 drivers/gpu/drm/Kconfig                                                                            |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c                                                            |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h                                                          |    2 
 drivers/gpu/drm/amd/amdgpu/soc15.c                                                                 |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h                                              |    4 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                                                  |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c                                             |    3 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h                                             |    2 
 drivers/gpu/drm/amd/display/dc/bios/command_table.c                                                |   61 
 drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c                                              |   14 
 drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c                                            |    1 
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.c                                                 |    8 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_link_encoder.c                                          |    1 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c                                              |    6 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c                                              |   20 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c                                                 |    2 
 drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.c                                       |   22 
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                                                                 |    6 
 drivers/gpu/drm/drm_dp_mst_topology.c                                                              |    3 
 drivers/gpu/drm/drm_fb_helper.c                                                                    |   15 
 drivers/gpu/drm/drm_modes.c                                                                        |    4 
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c                                                         |   22 
 drivers/gpu/drm/gma500/psb_drv.c                                                                   |    2 
 drivers/gpu/drm/i915/display/intel_hdmi.c                                                          |    6 
 drivers/gpu/drm/i915/gt/gen7_renderclear.c                                                         |   12 
 drivers/gpu/drm/lima/lima_sched.c                                                                  |    2 
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c                                                            |    2 
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c                                                              |   25 
 drivers/gpu/drm/msm/adreno/a6xx_gmu.h                                                              |    8 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                                                              |    8 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c                                                          |    2 
 drivers/gpu/drm/msm/dp/dp_display.c                                                                |    5 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_20nm.c                                                         |    2 
 drivers/gpu/drm/msm/msm_drv.c                                                                      |    3 
 drivers/gpu/drm/nouveau/include/nvkm/subdev/bios/conn.h                                            |    1 
 drivers/gpu/drm/nouveau/nouveau_chan.c                                                             |    1 
 drivers/gpu/drm/nouveau/nouveau_connector.c                                                        |    1 
 drivers/gpu/drm/panel/panel-elida-kd35t133.c                                                       |    3 
 drivers/gpu/drm/panel/panel-mantix-mlaf057we51.c                                                   |    5 
 drivers/gpu/drm/rcar-du/rcar_cmm.c                                                                 |    2 
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c                                                             |   10 
 drivers/gpu/drm/rcar-du/rcar_du_drv.h                                                              |    6 
 drivers/gpu/drm/rcar-du/rcar_du_encoder.c                                                          |    5 
 drivers/gpu/drm/rcar-du/rcar_du_kms.c                                                              |    8 
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h                                                        |   11 
 drivers/gpu/drm/scheduler/sched_main.c                                                             |    3 
 drivers/gpu/drm/sun4i/sun4i_tcon.c                                                                 |   21 
 drivers/gpu/drm/sun4i/sun4i_tcon.h                                                                 |    1 
 drivers/gpu/drm/tegra/dc.c                                                                         |    2 
 drivers/gpu/drm/tegra/dsi.c                                                                        |    2 
 drivers/gpu/drm/tegra/hdmi.c                                                                       |    2 
 drivers/gpu/drm/tegra/hub.c                                                                        |    2 
 drivers/gpu/drm/tegra/sor.c                                                                        |    2 
 drivers/gpu/drm/tegra/vic.c                                                                        |    2 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                                                     |   87 -
 drivers/gpu/drm/vc4/vc4_hdmi_regs.h                                                                |    4 
 drivers/gpu/drm/virtio/virtgpu_gem.c                                                               |    8 
 drivers/hid/hid-core.c                                                                             |    3 
 drivers/hid/hid-logitech-dj.c                                                                      |    1 
 drivers/hid/wacom_wac.c                                                                            |    7 
 drivers/hsi/controllers/omap_ssi_core.c                                                            |    2 
 drivers/hv/channel_mgmt.c                                                                          |    3 
 drivers/hwtracing/coresight/coresight-etm4x-core.c                                                 |   21 
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c                                                |    2 
 drivers/i2c/busses/i2c-bcm-iproc.c                                                                 |  231 ++-
 drivers/i2c/busses/i2c-brcmstb.c                                                                   |    2 
 drivers/i2c/busses/i2c-exynos5.c                                                                   |    8 
 drivers/i2c/busses/i2c-qcom-geni.c                                                                 |   59 
 drivers/ide/falconide.c                                                                            |    3 
 drivers/infiniband/core/cm.c                                                                       |    8 
 drivers/infiniband/core/cma.c                                                                      |   70 
 drivers/infiniband/core/user_mad.c                                                                 |   17 
 drivers/infiniband/hw/hns/hns_roce_device.h                                                        |    2 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                                                         |    8 
 drivers/infiniband/hw/hns/hns_roce_main.c                                                          |    3 
 drivers/infiniband/hw/mlx5/devx.c                                                                  |    4 
 drivers/infiniband/hw/mlx5/main.c                                                                  |   14 
 drivers/infiniband/sw/rxe/rxe_net.c                                                                |    5 
 drivers/infiniband/sw/rxe/rxe_recv.c                                                               |   27 
 drivers/infiniband/sw/siw/siw.h                                                                    |    2 
 drivers/infiniband/sw/siw/siw_main.c                                                               |    2 
 drivers/infiniband/sw/siw/siw_qp.c                                                                 |  271 +--
 drivers/infiniband/sw/siw/siw_qp_rx.c                                                              |   26 
 drivers/infiniband/sw/siw/siw_qp_tx.c                                                              |    4 
 drivers/infiniband/sw/siw/siw_verbs.c                                                              |   20 
 drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c                                                       |    2 
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                                                             |   51 
 drivers/infiniband/ulp/rtrs/rtrs-clt.h                                                             |    1 
 drivers/infiniband/ulp/rtrs/rtrs-pri.h                                                             |    9 
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c                                                       |    9 
 drivers/infiniband/ulp/rtrs/rtrs-srv.c                                                             |  117 -
 drivers/infiniband/ulp/rtrs/rtrs.c                                                                 |   14 
 drivers/input/joydev.c                                                                             |    7 
 drivers/input/joystick/xpad.c                                                                      |    1 
 drivers/input/serio/i8042-x86ia64io.h                                                              |    4 
 drivers/input/serio/serport.c                                                                      |    4 
 drivers/input/touchscreen/elo.c                                                                    |    4 
 drivers/input/touchscreen/raydium_i2c_ts.c                                                         |    3 
 drivers/input/touchscreen/sur40.c                                                                  |    1 
 drivers/input/touchscreen/zinitix.c                                                                |    2 
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c                                                        |    2 
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c                                                         |    2 
 drivers/iommu/iommu.c                                                                              |   23 
 drivers/iommu/mtk_iommu.c                                                                          |    2 
 drivers/irqchip/Kconfig                                                                            |    3 
 drivers/irqchip/irq-loongson-pch-msi.c                                                             |    2 
 drivers/macintosh/adb-iop.c                                                                        |    6 
 drivers/mailbox/sprd-mailbox.c                                                                     |    2 
 drivers/md/bcache/bcache.h                                                                         |    3 
 drivers/md/bcache/btree.c                                                                          |   21 
 drivers/md/bcache/journal.c                                                                        |    4 
 drivers/md/bcache/super.c                                                                          |   20 
 drivers/md/dm-core.h                                                                               |    4 
 drivers/md/dm-crypt.c                                                                              |    1 
 drivers/md/dm-era-target.c                                                                         |   93 -
 drivers/md/dm-table.c                                                                              |  168 --
 drivers/md/dm-writecache.c                                                                         |   74 
 drivers/md/dm.c                                                                                    |   62 
 drivers/md/dm.h                                                                                    |    2 
 drivers/media/i2c/max9286.c                                                                        |    2 
 drivers/media/i2c/ov5670.c                                                                         |    3 
 drivers/media/pci/cx25821/cx25821-core.c                                                           |    4 
 drivers/media/pci/intel/ipu3/Kconfig                                                               |    3 
 drivers/media/pci/intel/ipu3/ipu3-cio2.c                                                           |    2 
 drivers/media/pci/saa7134/saa7134-empress.c                                                        |    5 
 drivers/media/pci/smipcie/smipcie-ir.c                                                             |   46 
 drivers/media/platform/aspeed-video.c                                                              |    6 
 drivers/media/platform/marvell-ccic/mcam-core.c                                                    |    2 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c                                             |    4 
 drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c                                               |    3 
 drivers/media/platform/pxa_camera.c                                                                |    3 
 drivers/media/platform/qcom/camss/camss-video.c                                                    |    1 
 drivers/media/platform/ti-vpe/cal.c                                                                |    4 
 drivers/media/platform/vsp1/vsp1_drv.c                                                             |    4 
 drivers/media/rc/ir_toy.c                                                                          |    1 
 drivers/media/rc/mceusb.c                                                                          |    2 
 drivers/media/test-drivers/vidtv/vidtv_psi.c                                                       |    5 
 drivers/media/tuners/qm1d1c0042.c                                                                  |    4 
 drivers/media/usb/dvb-usb-v2/lmedm04.c                                                             |    2 
 drivers/media/usb/em28xx/em28xx-core.c                                                             |    6 
 drivers/media/usb/tm6000/tm6000-dvb.c                                                              |    4 
 drivers/media/usb/uvc/uvc_v4l2.c                                                                   |   18 
 drivers/memory/mtk-smi.c                                                                           |    4 
 drivers/memory/ti-aemif.c                                                                          |    8 
 drivers/mfd/altera-sysmgr.c                                                                        |    3 
 drivers/mfd/bd9571mwv.c                                                                            |    6 
 drivers/mfd/gateworks-gsc.c                                                                        |    2 
 drivers/mfd/wm831x-auxadc.c                                                                        |    3 
 drivers/misc/cardreader/rts5227.c                                                                  |    5 
 drivers/misc/eeprom/eeprom_93xx46.c                                                                |    1 
 drivers/misc/fastrpc.c                                                                             |    7 
 drivers/misc/mei/hbm.c                                                                             |    2 
 drivers/misc/mei/hw-me-regs.h                                                                      |    5 
 drivers/misc/mei/interrupt.c                                                                       |   33 
 drivers/misc/mei/pci-me.c                                                                          |    5 
 drivers/misc/vmw_vmci/vmci_queue_pair.c                                                            |    5 
 drivers/mmc/host/owl-mmc.c                                                                         |    9 
 drivers/mmc/host/renesas_sdhi_internal_dmac.c                                                      |    4 
 drivers/mmc/host/sdhci-esdhc-imx.c                                                                 |    3 
 drivers/mmc/host/sdhci-pci-o2micro.c                                                               |   20 
 drivers/mmc/host/sdhci-sprd.c                                                                      |    6 
 drivers/mmc/host/usdhi6rol0.c                                                                      |    4 
 drivers/mtd/parsers/afs.c                                                                          |    4 
 drivers/mtd/parsers/parser_imagetag.c                                                              |    4 
 drivers/mtd/spi-nor/controllers/hisi-sfc.c                                                         |    4 
 drivers/mtd/spi-nor/core.c                                                                         |   10 
 drivers/mtd/spi-nor/sfdp.c                                                                         |    5 
 drivers/net/Kconfig                                                                                |    2 
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c                                                     |    2 
 drivers/net/dsa/ocelot/felix.c                                                                     |   16 
 drivers/net/ethernet/amd/xgbe/xgbe-common.h                                                        |   14 
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                                                           |    1 
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c                                                          |    3 
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c                                                        |   39 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                                                          |    3 
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c                                                  |    4 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h                                                     |    3 
 drivers/net/ethernet/chelsio/cxgb4/sge.c                                                           |   11 
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h                                        |    3 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c                                                   |   14 
 drivers/net/ethernet/freescale/enetc/enetc_pf.c                                                    |    5 
 drivers/net/ethernet/ibm/ibmvnic.c                                                                 |   16 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                                                     |   16 
 drivers/net/ethernet/intel/i40e/i40e_main.c                                                        |   50 
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                                                        |    9 
 drivers/net/ethernet/intel/ice/ice.h                                                               |    2 
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c                                                        |    6 
 drivers/net/ethernet/intel/ice/ice_ethtool.c                                                       |   34 
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c                                                   |   33 
 drivers/net/ethernet/marvell/mvneta.c                                                              |    9 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c                                            |    2 
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c                                              |    1 
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c                                                  |    9 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c                                                 |  259 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h                                                   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c                                             |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h                                        |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c                                         |   66 
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c                                               |   39 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                                                  |    8 
 drivers/net/ethernet/mellanox/mlx5/core/health.c                                                   |   22 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                                                     |    3 
 drivers/net/ethernet/realtek/r8169_main.c                                                          |    4 
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c                                                |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c                                                    |   30 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c                                                  |   26 
 drivers/net/gtp.c                                                                                  |    1 
 drivers/net/phy/mscc/mscc.h                                                                        |    8 
 drivers/net/phy/mscc/mscc_main.c                                                                   |  350 +++-
 drivers/net/phy/phy_device.c                                                                       |   53 
 drivers/net/ppp/ppp_async.c                                                                        |    3 
 drivers/net/ppp/ppp_synctty.c                                                                      |    3 
 drivers/net/vxlan.c                                                                                |   11 
 drivers/net/wireguard/device.c                                                                     |   19 
 drivers/net/wireguard/device.h                                                                     |   15 
 drivers/net/wireguard/peer.c                                                                       |   28 
 drivers/net/wireguard/peer.h                                                                       |    4 
 drivers/net/wireguard/queueing.c                                                                   |   86 -
 drivers/net/wireguard/queueing.h                                                                   |   45 
 drivers/net/wireguard/receive.c                                                                    |   16 
 drivers/net/wireguard/send.c                                                                       |   31 
 drivers/net/wireless/ath/ath10k/mac.c                                                              |    2 
 drivers/net/wireless/ath/ath10k/snoc.c                                                             |    5 
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                                                          |    3 
 drivers/net/wireless/ath/ath11k/mac.c                                                              |   11 
 drivers/net/wireless/ath/ath9k/debug.c                                                             |    5 
 drivers/net/wireless/broadcom/b43/phy_n.c                                                          |    2 
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c                                                       |   13 
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                                                        |   43 
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c                                                |    3 
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c                                           |   21 
 drivers/net/xen-netback/interface.c                                                                |    8 
 drivers/nvme/host/multipath.c                                                                      |    4 
 drivers/nvme/target/admin-cmd.c                                                                    |   33 
 drivers/nvme/target/tcp.c                                                                          |   59 
 drivers/nvmem/core.c                                                                               |    5 
 drivers/nvmem/qcom-spmi-sdam.c                                                                     |    7 
 drivers/of/fdt.c                                                                                   |   12 
 drivers/opp/of.c                                                                                   |    4 
 drivers/pci/controller/cadence/pcie-cadence-host.c                                                 |    5 
 drivers/pci/controller/dwc/pcie-qcom.c                                                             |    4 
 drivers/pci/controller/pcie-rcar-host.c                                                            |    2 
 drivers/pci/controller/pcie-rockchip.c                                                             |   12 
 drivers/pci/controller/pcie-xilinx-cpm.c                                                           |    1 
 drivers/pci/pci-bridge-emul.c                                                                      |   11 
 drivers/pci/setup-res.c                                                                            |    6 
 drivers/pci/syscall.c                                                                              |   10 
 drivers/perf/arm-cmn.c                                                                             |   17 
 drivers/phy/Kconfig                                                                                |    1 
 drivers/phy/cadence/phy-cadence-torrent.c                                                          |    1 
 drivers/phy/lantiq/phy-lantiq-rcu-usb2.c                                                           |   10 
 drivers/phy/rockchip/phy-rockchip-emmc.c                                                           |    8 
 drivers/platform/chrome/cros_ec_proto.c                                                            |   12 
 drivers/power/reset/at91-sama5d2_shdwc.c                                                           |    2 
 drivers/power/supply/Kconfig                                                                       |    1 
 drivers/power/supply/axp20x_usb_power.c                                                            |    2 
 drivers/power/supply/cpcap-battery.c                                                               |   12 
 drivers/power/supply/cpcap-charger.c                                                               |    4 
 drivers/power/supply/smb347-charger.c                                                              |   12 
 drivers/pwm/pwm-iqs620a.c                                                                          |    8 
 drivers/pwm/pwm-rockchip.c                                                                         |   18 
 drivers/regulator/axp20x-regulator.c                                                               |    7 
 drivers/regulator/core.c                                                                           |    6 
 drivers/regulator/qcom-rpmh-regulator.c                                                            |   26 
 drivers/regulator/rohm-regulator.c                                                                 |    9 
 drivers/regulator/s5m8767.c                                                                        |   15 
 drivers/remoteproc/mtk_common.h                                                                    |    1 
 drivers/remoteproc/mtk_scp.c                                                                       |   20 
 drivers/rtc/Kconfig                                                                                |    3 
 drivers/s390/crypto/zcrypt_api.c                                                                   |   14 
 drivers/s390/virtio/virtio_ccw.c                                                                   |    4 
 drivers/scsi/bnx2fc/Kconfig                                                                        |    1 
 drivers/scsi/lpfc/lpfc_hbadisc.c                                                                   |   15 
 drivers/scsi/qla2xxx/qla_dbg.c                                                                     |    1 
 drivers/scsi/qla2xxx/qla_mbx.c                                                                     |    3 
 drivers/scsi/sd.c                                                                                  |    6 
 drivers/scsi/sd_zbc.c                                                                              |    6 
 drivers/soc/aspeed/aspeed-lpc-snoop.c                                                              |   30 
 drivers/soc/qcom/ocmem.c                                                                           |    8 
 drivers/soc/qcom/socinfo.c                                                                         |    2 
 drivers/soc/samsung/exynos-asv.c                                                                   |   18 
 drivers/soc/ti/pm33xx.c                                                                            |    5 
 drivers/soundwire/bus.c                                                                            |   47 
 drivers/soundwire/cadence_master.c                                                                 |    8 
 drivers/soundwire/intel_init.c                                                                     |    3 
 drivers/spi/spi-atmel.c                                                                            |    2 
 drivers/spi/spi-cadence-quadspi.c                                                                  |    2 
 drivers/spi/spi-dw-bt1.c                                                                           |    2 
 drivers/spi/spi-fsl-spi.c                                                                          |    2 
 drivers/spi/spi-imx.c                                                                              |    2 
 drivers/spi/spi-pxa2xx-pci.c                                                                       |   27 
 drivers/spi/spi-stm32.c                                                                            |    4 
 drivers/spi/spi-synquacer.c                                                                        |    4 
 drivers/spi/spi.c                                                                                  |    2 
 drivers/spmi/spmi-pmic-arb.c                                                                       |    5 
 drivers/staging/gdm724x/gdm_usb.c                                                                  |   10 
 drivers/staging/media/allegro-dvt/allegro-core.c                                                   |    3 
 drivers/staging/media/atomisp/pci/atomisp_subdev.c                                                 |   24 
 drivers/staging/media/atomisp/pci/hmm/hmm.c                                                        |    2 
 drivers/staging/media/imx/imx-media-csc-scaler.c                                                   |    4 
 drivers/staging/media/imx/imx-media-dev.c                                                          |    7 
 drivers/staging/media/imx/imx7-media-csi.c                                                         |   27 
 drivers/staging/mt7621-dma/Makefile                                                                |    2 
 drivers/staging/mt7621-dma/hsdma-mt7621.c                                                          |  760 ++++++++++
 drivers/staging/mt7621-dma/mtk-hsdma.c                                                             |  760 ----------
 drivers/staging/rtl8188eu/os_dep/usb_intf.c                                                        |    1 
 drivers/staging/rtl8723bs/os_dep/wifi_regd.c                                                       |    2 
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c                                      |    6 
 drivers/staging/wfx/data_tx.c                                                                      |   10 
 drivers/staging/wfx/data_tx.h                                                                      |    1 
 drivers/target/iscsi/cxgbit/cxgbit_target.c                                                        |    3 
 drivers/tee/optee/rpc.c                                                                            |   31 
 drivers/thermal/cpufreq_cooling.c                                                                  |    2 
 drivers/tty/n_gsm.c                                                                                |    3 
 drivers/tty/n_hdlc.c                                                                               |   60 
 drivers/tty/n_null.c                                                                               |    3 
 drivers/tty/n_r3964.c                                                                              |   10 
 drivers/tty/n_tracerouter.c                                                                        |    4 
 drivers/tty/n_tracesink.c                                                                          |    4 
 drivers/tty/n_tty.c                                                                                |   82 -
 drivers/tty/tty_io.c                                                                               |   82 -
 drivers/usb/dwc2/hcd.c                                                                             |   15 
 drivers/usb/dwc2/hcd_intr.c                                                                        |   14 
 drivers/usb/dwc3/gadget.c                                                                          |   19 
 drivers/usb/gadget/function/u_audio.c                                                              |   17 
 drivers/usb/musb/musb_core.c                                                                       |   31 
 drivers/usb/serial/ftdi_sio.c                                                                      |    5 
 drivers/usb/serial/mos7720.c                                                                       |    4 
 drivers/usb/serial/mos7840.c                                                                       |    4 
 drivers/usb/serial/option.c                                                                        |    3 
 drivers/usb/serial/pl2303.c                                                                        |    8 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                                                                  |    2 
 drivers/vfio/pci/vfio_pci_zdev.c                                                                   |    4 
 drivers/vfio/vfio_iommu_type1.c                                                                    |   63 
 drivers/video/fbdev/Kconfig                                                                        |    2 
 drivers/virt/vboxguest/vboxguest_utils.c                                                           |   18 
 drivers/w1/slaves/w1_therm.c                                                                       |   22 
 drivers/watchdog/intel-mid_wdt.c                                                                   |    8 
 drivers/watchdog/mei_wdt.c                                                                         |    1 
 drivers/watchdog/qcom-wdt.c                                                                        |   13 
 fs/affs/namei.c                                                                                    |    4 
 fs/btrfs/backref.c                                                                                 |    9 
 fs/btrfs/backref.h                                                                                 |    9 
 fs/btrfs/block-group.c                                                                             |   29 
 fs/btrfs/ctree.c                                                                                   |    7 
 fs/btrfs/delayed-ref.c                                                                             |   56 
 fs/btrfs/delayed-ref.h                                                                             |   16 
 fs/btrfs/extent-tree.c                                                                             |  128 -
 fs/btrfs/free-space-cache.c                                                                        |    6 
 fs/btrfs/inode.c                                                                                   |    3 
 fs/btrfs/relocation.c                                                                              |    4 
 fs/btrfs/space-info.h                                                                              |   17 
 fs/ceph/caps.c                                                                                     |   10 
 fs/debugfs/inode.c                                                                                 |    5 
 fs/erofs/xattr.c                                                                                   |   10 
 fs/erofs/zmap.c                                                                                    |   10 
 fs/eventpoll.c                                                                                     |    4 
 fs/exfat/exfat_raw.h                                                                               |    4 
 fs/exfat/super.c                                                                                   |   31 
 fs/ext4/Kconfig                                                                                    |    3 
 fs/ext4/namei.c                                                                                    |    7 
 fs/f2fs/compress.c                                                                                 |    5 
 fs/f2fs/data.c                                                                                     |   12 
 fs/f2fs/f2fs.h                                                                                     |    2 
 fs/f2fs/file.c                                                                                     |   24 
 fs/f2fs/inline.c                                                                                   |    4 
 fs/f2fs/super.c                                                                                    |    3 
 fs/gfs2/bmap.c                                                                                     |    6 
 fs/gfs2/lock_dlm.c                                                                                 |    8 
 fs/gfs2/recovery.c                                                                                 |    4 
 fs/gfs2/util.c                                                                                     |   16 
 fs/io_uring.c                                                                                      |   17 
 fs/isofs/dir.c                                                                                     |    1 
 fs/isofs/namei.c                                                                                   |    1 
 fs/jffs2/summary.c                                                                                 |    3 
 fs/jfs/jfs_dmap.c                                                                                  |    2 
 fs/nfs/nfs4proc.c                                                                                  |   15 
 fs/nfsd/nfsctl.c                                                                                   |   14 
 fs/ocfs2/cluster/heartbeat.c                                                                       |    8 
 fs/proc/proc_sysctl.c                                                                              |    4 
 fs/proc/self.c                                                                                     |    2 
 fs/proc/task_mmu.c                                                                                 |    9 
 fs/proc/thread_self.c                                                                              |    7 
 fs/pstore/platform.c                                                                               |    4 
 fs/quota/quota_v2.c                                                                                |   11 
 fs/ubifs/auth.c                                                                                    |    2 
 fs/ubifs/replay.c                                                                                  |    4 
 fs/ubifs/super.c                                                                                   |    4 
 fs/zonefs/super.c                                                                                  |    3 
 include/acpi/acexcep.h                                                                             |   10 
 include/asm-generic/vmlinux.lds.h                                                                  |   16 
 include/linux/bpf.h                                                                                |    3 
 include/linux/device-mapper.h                                                                      |    5 
 include/linux/eventpoll.h                                                                          |    2 
 include/linux/filter.h                                                                             |    2 
 include/linux/icmpv6.h                                                                             |   28 
 include/linux/iommu.h                                                                              |    4 
 include/linux/ipv6.h                                                                               |    1 
 include/linux/kexec.h                                                                              |    5 
 include/linux/key.h                                                                                |    1 
 include/linux/kgdb.h                                                                               |    2 
 include/linux/khugepaged.h                                                                         |    2 
 include/linux/memremap.h                                                                           |    6 
 include/linux/mfd/rohm-generic.h                                                                   |   14 
 include/linux/rcupdate.h                                                                           |    2 
 include/linux/rmap.h                                                                               |    3 
 include/linux/soundwire/sdw.h                                                                      |    2 
 include/linux/tpm.h                                                                                |    5 
 include/linux/tty_ldisc.h                                                                          |    3 
 include/net/act_api.h                                                                              |    6 
 include/net/icmp.h                                                                                 |    6 
 include/net/tcp.h                                                                                  |    9 
 include/uapi/drm/drm_fourcc.h                                                                      |    4 
 init/Kconfig                                                                                       |   11 
 init/main.c                                                                                        |    1 
 kernel/Makefile                                                                                    |    2 
 kernel/bpf/bpf_iter.c                                                                              |    2 
 kernel/bpf/bpf_lru_list.c                                                                          |    7 
 kernel/bpf/devmap.c                                                                                |    4 
 kernel/bpf/verifier.c                                                                              |    3 
 kernel/debug/debug_core.c                                                                          |   11 
 kernel/debug/kdb/kdb_private.h                                                                     |    2 
 kernel/kcsan/core.c                                                                                |   26 
 kernel/kexec_file.c                                                                                |    5 
 kernel/kprobes.c                                                                                   |   31 
 kernel/locking/lockdep.c                                                                           |    3 
 kernel/module.c                                                                                    |   21 
 kernel/printk/printk.c                                                                             |   28 
 kernel/printk/printk_safe.c                                                                        |   16 
 kernel/rcu/tree.c                                                                                  |    8 
 kernel/rcu/tree_plugin.h                                                                           |    5 
 kernel/sched/fair.c                                                                                |   45 
 kernel/sched/idle.c                                                                                |    1 
 kernel/seccomp.c                                                                                   |    2 
 kernel/smp.c                                                                                       |    4 
 kernel/tracepoint.c                                                                                |   80 -
 mm/compaction.c                                                                                    |   43 
 mm/hugetlb.c                                                                                       |   14 
 mm/khugepaged.c                                                                                    |   22 
 mm/memcontrol.c                                                                                    |   30 
 mm/memory-failure.c                                                                                |    6 
 mm/memory.c                                                                                        |   16 
 mm/memremap.c                                                                                      |   15 
 mm/slab_common.c                                                                                   |    4 
 mm/slub.c                                                                                          |    8 
 mm/vmscan.c                                                                                        |    9 
 net/bluetooth/a2mp.c                                                                               |    3 
 net/bluetooth/hci_core.c                                                                           |    6 
 net/core/filter.c                                                                                  |   13 
 net/ipv4/icmp.c                                                                                    |    5 
 net/ipv6/icmp.c                                                                                    |   18 
 net/ipv6/ip6_icmp.c                                                                                |   12 
 net/mac80211/mesh_hwmp.c                                                                           |    2 
 net/nfc/nci/uart.c                                                                                 |    3 
 net/qrtr/tun.c                                                                                     |   12 
 net/sched/act_api.c                                                                                |  106 -
 net/sched/cls_api.c                                                                                |   12 
 net/sunrpc/xprtrdma/svc_rdma_transport.c                                                           |    6 
 samples/Kconfig                                                                                    |    2 
 samples/watch_queue/watch_test.c                                                                   |    2 
 security/commoncap.c                                                                               |   12 
 security/integrity/evm/evm_crypto.c                                                                |    7 
 security/integrity/ima/ima_kexec.c                                                                 |    3 
 security/integrity/ima/ima_mok.c                                                                   |    5 
 security/keys/Kconfig                                                                              |    8 
 security/keys/key.c                                                                                |    2 
 security/keys/trusted-keys/trusted_tpm1.c                                                          |   22 
 security/keys/trusted-keys/trusted_tpm2.c                                                          |   22 
 security/selinux/hooks.c                                                                           |    4 
 sound/core/init.c                                                                                  |    4 
 sound/core/pcm.c                                                                                   |    4 
 sound/core/pcm_local.h                                                                             |    1 
 sound/core/pcm_native.c                                                                            |   27 
 sound/firewire/fireface/ff-protocol-latter.c                                                       |  118 +
 sound/pci/hda/hda_intel.c                                                                          |    2 
 sound/pci/hda/patch_hdmi.c                                                                         |    1 
 sound/pci/hda/patch_realtek.c                                                                      |   40 
 sound/soc/codecs/cpcap.c                                                                           |   12 
 sound/soc/codecs/cs42l56.c                                                                         |    3 
 sound/soc/codecs/rt5682-i2c.c                                                                      |    3 
 sound/soc/codecs/wsa881x.c                                                                         |    1 
 sound/soc/generic/simple-card-utils.c                                                              |   13 
 sound/soc/intel/boards/sof_sdw.c                                                                   |    6 
 sound/soc/qcom/lpass-apq8016.c                                                                     |    2 
 sound/soc/qcom/lpass-cpu.c                                                                         |   30 
 sound/soc/qcom/lpass-lpaif-reg.h                                                                   |    3 
 sound/soc/qcom/lpass.h                                                                             |    1 
 sound/soc/qcom/qdsp6/q6asm-dai.c                                                                   |   21 
 sound/soc/qcom/qdsp6/q6routing.c                                                                   |   18 
 sound/soc/sh/siu.h                                                                                 |    2 
 sound/soc/sh/siu_pcm.c                                                                             |    2 
 sound/soc/sof/debug.c                                                                              |    2 
 sound/soc/sof/intel/hda-dsp.c                                                                      |    4 
 sound/soc/sof/sof-pci-dev.c                                                                        |    7 
 sound/usb/pcm.c                                                                                    |    2 
 tools/lib/bpf/libbpf.c                                                                             |   22 
 tools/objtool/arch/x86/special.c                                                                   |    2 
 tools/objtool/check.c                                                                              |   15 
 tools/objtool/check.h                                                                              |   11 
 tools/perf/builtin-record.c                                                                        |    2 
 tools/perf/pmu-events/arch/arm64/ampere/emag/cache.json                                            |    2 
 tools/perf/tests/sample-parsing.c                                                                  |    2 
 tools/perf/util/event.c                                                                            |    2 
 tools/perf/util/evlist.c                                                                           |    8 
 tools/perf/util/evlist.h                                                                           |    4 
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c                                                |   41 
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.h                                                |    2 
 tools/perf/util/intel-pt.c                                                                         |   29 
 tools/perf/util/symbol.c                                                                           |    7 
 tools/testing/kunit/kunit_tool_test.py                                                             |   14 
 tools/testing/selftests/bpf/test_xdp_redirect.sh                                                   |   10 
 tools/testing/selftests/dmabuf-heaps/Makefile                                                      |    2 
 tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc |   35 
 tools/testing/selftests/net/mptcp/mptcp_connect.sh                                                 |    2 
 tools/testing/selftests/powerpc/eeh/eeh-basic.sh                                                   |    2 
 tools/testing/selftests/seccomp/seccomp_bpf.c                                                      |    2 
 tools/testing/selftests/wireguard/netns.sh                                                         |   15 
 669 files changed, 6490 insertions(+), 3770 deletions(-)

Adam Ford (2):
      arm64: dts: renesas: beacon kit: Fix choppy Bluetooth Audio
      arm64: dts: renesas: beacon: Fix audio-1.8V pin enable

Adrian Hunter (3):
      perf intel-pt: Fix missing CYC processing in PSB
      perf intel-pt: Fix premature IPC
      perf intel-pt: Fix IPC with CYC threshold

Ahmad Fatoum (1):
      nvmem: core: skip child nodes not matching binding

Ahmed S. Darwish (1):
      scsi: libsas: docs: Remove notify_ha_event()

Al Viro (1):
      sparc32: fix a user-triggerable oops in clear_user()

Alain Volmat (1):
      spi: stm32: properly handle 0 byte transfer

Alex Deucher (2):
      Revert "drm/amd/display: Update NV1x SR latency values"
      drm/amdgpu: Set reference clock to 100Mhz on Renoir (v2)

Alex Williamson (1):
      vfio/type1: Use follow_pte()

Alexander Lobakin (2):
      MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section
      MIPS: properly stop .eh_frame generation

Alexander Usyskin (5):
      mei: hbm: call mei_set_devstate() on hbm stop response
      watchdog: mei_wdt: request stop on unregister
      mei: fix transfer over dma with extended header
      mei: me: add adler lake point S DID
      mei: me: add adler lake point LP DID

Alexey Kardashevskiy (2):
      powerpc/uaccess: Avoid might_fault() when user access is enabled
      powerpc/kuap: Restore AMR after replaying soft interrupts

Alyssa Rosenzweig (1):
      drm/rockchip: Require the YTR modifier for AFBC

Amey Narkhede (1):
      staging: gdm724x: Fix DMA from stack

Amir Goldstein (1):
      selinux: fix inconsistency between inode_getxattr and inode_listsecurity

Anand K Mistry (2):
      ath10k: Fix suspicious RCU usage warning in ath10k_wmi_tlv_parse_peer_stats_info()
      ath10k: Fix lockdep assertion warning in ath10k_sta_statistics

Andre Przywara (7):
      arm64: dts: allwinner: A64: properly connect USB PHY to port 0
      arm64: dts: allwinner: H6: properly connect USB PHY to port 0
      arm64: dts: allwinner: Drop non-removable from SoPine/LTS SD card
      arm64: dts: allwinner: H6: Allow up to 150 MHz MMC bus frequency
      arm64: dts: allwinner: A64: Limit MMC2 bus frequency to 150 MHz
      clk: sunxi-ng: h6: Fix CEC clock
      clk: sunxi-ng: h6: Fix clock divider range on some clocks

Andrea Parri (Microsoft) (1):
      Drivers: hv: vmbus: Avoid use-after-free in vmbus_onoffer_rescind()

Andreas Gruenbacher (2):
      gfs2: Lock imbalance on error path in gfs2_recover_one
      gfs2: Recursive gfs2_quota_hold in gfs2_iomap_end

Andreas Oetken (1):
      nios2: fixed broken sys_clone syscall

Andrey Grodzovsky (1):
      drm/sched: Cancel and flush all outstanding jobs before finish.

Andrii Nakryiko (2):
      bpf: Add bpf_patch_call_args prototype to include/linux/bpf.h
      bpf: Avoid warning when re-casting __bpf_call_base into __bpf_call_base_args

Andy Lutomirski (1):
      x86/fault: Fix AMD erratum #91 errata fixup for user code

Andy Shevchenko (3):
      media: ipu3-cio2: Build only for x86
      watchdog: intel-mid_wdt: Postpone IRQ handler registration till SCU is ready
      spi: pxa2xx: Fix the controller numbering for Wildcat Point

AngeloGioacchino Del Regno (1):
      clk: qcom: gcc-msm8998: Fix Alpha PLL type for all GPLLs

Ansuel Smith (1):
      PCI: qcom: Use PHY_REFCLK_USE_PAD only for ipq8064

Ard Biesheuvel (5):
      PCI: Decline to resize resources if boot config must be preserved
      crypto: arm64/aes-ce - really hide slower algos when faster ones are enabled
      crypto: arm64/sha - add missing module aliases
      crypto: aesni - prevent misaligned buffers on the stack
      crypto: michael_mic - fix broken misalignment handling

Arnaldo Carvalho de Melo (1):
      perf tools: Fix DSO filtering when not finding a map for a sampled address

Arnd Bergmann (6):
      ARM: s3c: fix fiq for clang IAS
      optee: simplify i2c access
      ARM: at91: use proper asm syntax in pm_suspend
      ubifs: replay: Fix high stack usage, again
      clocksource/drivers/ixp4xx: Select TIMER_OF when needed
      mfd: altera-sysmgr: Fix physical address storing more

Artem Lapkin (1):
      arm64: dts: meson: fix broken wifi node for Khadas VIM3L

Aswath Govindraju (2):
      misc: eeprom_93xx46: Fix module alias to enable module autoprobe
      misc: eeprom_93xx46: Add module alias to avoid breaking support for non device tree users

Aurelien Jarno (1):
      MIPS: Support binutils configured with --enable-mips-fix-loongson3-llsc=yes

Avihai Horon (1):
      RDMA/ucma: Fix use-after-free bug in ucma_create_uevent

Ayush Sawal (1):
      cxgb4/chtls/cxgbit: Keeping the max ofld immediate data size same in cxgb4 and ulds

Bard Liao (2):
      soundwire: export sdw_write/read_no_pm functions
      regmap: sdw: use _no_pm functions in regmap_read/write

Bart Van Assche (1):
      scsi: sd: Fix Opal support

Bartosz Golaszewski (1):
      rtc: s5m: select REGMAP_I2C

Bernard Metzler (1):
      RDMA/siw: Fix handling of zero-sized Read and Receive Queues.

Bjarni Jonasson (1):
      net: phy: mscc: adding LCPLL reset to VSC8514

Björn Töpel (1):
      selftests/bpf: Convert test_xdp_redirect.sh to bash

Bob Pearson (3):
      RDMA/rxe: Fix coding error in rxe_recv.c
      RDMA/rxe: Fix coding error in rxe_rcv_mcast_pkt
      RDMA/rxe: Correct skb on loopback path

Bob Peterson (2):
      gfs2: fix glock confusion in function signal_our_withdraw
      gfs2: Don't skip dlm unlock if glock has an lvb

Borislav Petkov (1):
      staging: media: atomisp: Fix size_t format specifier in hmm_alloc() debug statemenet

Brett Creeley (1):
      ice: Account for port VLAN in VF max packet size calculation

Chaitanya Kulkarni (2):
      nvmet: remove extra variable in identify ns
      nvmet: set status to 0 in case for invalid nsid

Chao Yu (3):
      f2fs: compress: fix potential deadlock
      f2fs: fix out-of-repair __setattr_copy()
      f2fs: enforce the immutable flag on open files

Chen Wandun (1):
      mm/hugetlb: suppress wrong warning info when alloc gigantic page

Chen Yu (1):
      cpufreq: intel_pstate: Get per-CPU max freq via MSR_HWP_CAPABILITIES if available

Chen-Yu Tsai (3):
      arm64: dts: rockchip: rk3328: Add clock_in_out property to gmac2phy node
      staging: rtl8723bs: wifi_regd.c: Fix incorrect number of regulatory rules
      PCI: rockchip: Make 'ep-gpios' DT property optional

Chenyang Li (1):
      drm/amdgpu: Fix macro name _AMDGPU_TRACE_H_ in preprocessor if condition

Chia-I Wu (1):
      drm/virtio: make sure context is created in gem open

Chris Ruehl (1):
      phy: rockchip-emmc: emmc_phy_init() always return 0

Chris Wilson (4):
      drm/i915/gt: One more flush for Baytrail clear residuals
      drm/i915/gt: Flush before changing register state
      drm/i915/gt: Correct surface base address for renderclear
      kcmp: Support selection of SYS_kcmp without CHECKPOINT_RESTORE

Christoph Hellwig (1):
      block: reopen the device in blkdev_reread_part

Christophe JAILLET (13):
      Bluetooth: btqcomsmd: Fix a resource leak in error handling paths in the probe function
      cpufreq: brcmstb-avs-cpufreq: Free resources in error path
      cpufreq: brcmstb-avs-cpufreq: Fix resource leaks in ->remove()
      soc: ti: pm33xx: Fix some resource leak in the error handling paths of the probe function
      hwrng: ingenic - Fix a resource leak in an error handling path
      media: vsp1: Fix an error handling path in the probe function
      media: cx25821: Fix a bug when reallocating some dma memory
      dmaengine: fsldma: Fix a resource leak in the remove function
      dmaengine: fsldma: Fix a resource leak in an error handling path of the probe function
      dmaengine: owl-dma: Fix a resource leak in the remove function
      mmc: owl-mmc: Fix a resource leak in an error handling path and in the remove function
      mmc: sdhci-sprd: Fix some resource leaks in the remove function
      mmc: usdhi6rol0: Fix a resource leak in the error handling path of the probe

Christophe Leroy (6):
      crypto: talitos - Work around SEC6 ERRATA (AES-CTR mode data size error)
      crypto: talitos - Fix ctr(aes) on SEC1
      powerpc/47x: Disable 256k page size
      powerpc/8xx: Fix software emulation interrupt
      powerpc/32: Preserve cr1 in exception prolog stack check to fix build error
      powerpc/32s: Add missing call to kuep_lock on syscall entry

Christopher William Snowhill (1):
      Bluetooth: Fix initializing response id after clearing struct

Chuck Lever (1):
      svcrdma: Hold private mutex while invoking rdma_accept()

Chuhong Yuan (2):
      drm/fb-helper: Add missed unlocks in setcmap_legacy()
      net/mlx4_core: Add missed mlx4_free_cmd_mailbox()

Claire Chang (1):
      Bluetooth: hci_uart: Fix a race for write_work scheduling

Claudiu Beznea (1):
      power: reset: at91-sama5d2_shdwc: fix wkupdbc mask

Colin Ian King (4):
      mac80211: fix potential overflow when multiplying to u32 integers
      b43: N-PHY: Fix the update of coef for the PHY revision >= 3case
      fs/jfs: fix potential integer overflow on shift of a int
      power: supply: cpcap-charger: Fix power_supply_put on null battery pointer

Cong Wang (1):
      net_sched: fix RTNL deadlock again caused by request_module()

Corentin Labbe (6):
      crypto: sun4i-ss - linearize buffers content must be kept
      crypto: sun4i-ss - fix kmap usage
      crypto: sun4i-ss - checking sg length is not sufficient
      crypto: sun4i-ss - IV register does not work on A10 and A13
      crypto: sun4i-ss - handle BigEndian for cipher
      crypto: sun4i-ss - initialize need_fallback

Cornelia Huck (1):
      virtio/s390: implement virtio-ccw revision 2 correctly

Cristian Marussi (1):
      firmware: arm_scmi: Fix call site of scmi_notification_exit

Cédric Le Goater (2):
      KVM: PPC: Make the VMX instruction emulation routines static
      powerpc/prom: Fix "ibm,arch-vec-5-platform-support" scan

Dan Carpenter (20):
      soc: qcom: socinfo: Fix an off by one in qcom_show_pmic_model()
      ath11k: fix a locking bug in ath11k_mac_op_start()
      gma500: clean up error handling in init
      media: allegro: Fix use after free on error
      media: camss: missing error code in msm_video_register()
      ASoC: cs42l56: fix up error handling in probe
      media: atomisp: Fix a buffer overflow in debug code
      mtd: parser: imagetag: fix error codes in bcm963xx_parse_imagetag_partitions()
      drm/amdgpu: Prevent shift wrapping in amdgpu_read_mask()
      scsi: lpfc: Fix ancient double free
      mfd: wm831x-auxadc: Prevent use after free in wm831x_auxadc_read_irq()
      Input: sur40 - fix an error code in sur40_probe()
      Input: elo - fix an error code in elo_connect()
      phy: cadence-torrent: Fix error code in cdns_torrent_phy_probe()
      nvmem: core: Fix a resource leak on error in nvmem_add_cells_from_of()
      octeontx2-af: Fix an off by one in rvu_dbg_qsize_write()
      ocfs2: fix a use after free on error
      Input: joydev - prevent potential read overflow in ioctl
      USB: serial: mos7840: fix error code in mos7840_write()
      USB: serial: mos7720: fix error code in mos7720_write()

Dan Williams (1):
      mm: fix memory_failure() handling of dax-namespace metadata

Daniel Latypov (1):
      kunit: tool: fix unit test cleanup handling

Daniel Scally (1):
      media: software_node: Fix refcounts in software_node_get_next_child()

Daniel W. S. Almeida (1):
      media: vidtv: psi: fix missing crc for PMT

Daniele Alessandrelli (1):
      crypto: ecdh_helper - Ensure 'len >= secret.len' in decode_key()

Dave Ertman (2):
      ice: report correct max number of TCs
      ice: Fix state bits on LLDP mode switch

Dave Hansen (1):
      mm/vmscan: restore zone_reclaim_mode ABI

Dave Jiang (1):
      dmaengine: idxd: set DMA channel to be private

David Gow (1):
      rtc: zynqmp: depend on HAS_IOMEM

David Howells (1):
      certs: Fix blacklist flag type confusion

Dehe Gu (1):
      f2fs: fix a wrong condition in __submit_bio

Dinghao Liu (6):
      Bluetooth: hci_qca: Fix memleak in qca_controller_memdump
      media: em28xx: Fix use-after-free in em28xx_alloc_urbs
      media: media/pci: Fix memleak in empress_init
      media: tm6000: Fix memleak in tm6000_start_stream
      evm: Fix memleak in init_desc
      ubifs: Fix memleak in ubifs_init_authentication

Dinh Nguyen (1):
      arm64: dts: agilex: fix phy interface bit shift for gmac1 and gmac2

Dmitry Baryshkov (2):
      regulator: qcom-rpmh-regulator: add pm8009-1 chip revision
      arm64: dts: qcom: qrb5165-rb5: fix pm8009 regulators

Dmitry Osipenko (2):
      opp: Correct debug message in _opp_add_static_v2()
      power: supply: smb347-charger: Fix interrupt usage if interrupt is unavailable

Dmitry Safonov (1):
      perf symbols: Use (long) for iterator for bfd symbols

Dmitry Torokhov (1):
      Input: zinitix - fix return type of zinitix_init_touch()

Dom Cobley (4):
      drm/vc4: hdmi: Move hdmi reset to bind
      drm/vc4: hdmi: Fix register offset with longer CEC messages
      drm/vc4: hdmi: Fix up CEC registers
      drm/vc4: hdmi: Restore cec physical address on reconnect

Douglas Anderson (1):
      iommu: Properly pass gfp_t in _iommu_map() to avoid atomic sleeping

Edwin Peer (1):
      bnxt_en: reverse order of TX disable and carrier off

Eric Anholt (2):
      drm/msm: Fix race of GPU init vs timestamp power management.
      drm/msm: Fix races managing the OOB state for timestamp vs timestamps.

Eric Bernstein (1):
      drm/amd/display: Remove Assert from dcn10_get_dig_frontend

Eric Biggers (1):
      random: fix the RNDRESEEDCRNG ioctl

Eric Dumazet (1):
      tcp: fix SO_RCVLOWAT related hangs under mem pressure

Eric W. Biederman (1):
      capabilities: Don't allow writing ambiguous v3 file capabilities

Evan Benn (2):
      platform/chrome: cros_ec_proto: Use EC_HOST_EVENT_MASK not BIT
      platform/chrome: cros_ec_proto: Add LID and BATTERY to default mask

Ezequiel Garcia (2):
      media: imx: Unregister csc/scaler only if registered
      media: imx: Fix csc/scaler unregister

Fabio Estevam (1):
      media: imx7: csi: Fix regression for parallel cameras on i.MX6UL

Fangrui Song (1):
      module: Ignore _GLOBAL_OFFSET_TABLE_ when warning for undefined symbols

Felix Kuehling (1):
      drm/amdkfd: Fix recursive lock warnings

Ferry Toth (1):
      dmaengine: hsu: disable spurious interrupt

Filipe Laíns (1):
      HID: logitech-dj: add support for keyboard events in eQUAD step 4 Gaming

Filipe Manana (1):
      btrfs: fix extent buffer leak on failure to copy root

Finn Thain (2):
      macintosh/adb-iop: Use big-endian autopoll mask
      ide/falconide: Fix module unload

Florian Fainelli (1):
      ata: ahci_brcm: Add back regulators management

Frank Li (1):
      mmc: sdhci-esdhc-imx: fix kernel panic when remove module

Frank Wunderlich (1):
      dts64: mt7622: fix slow sd card access

Frantisek Hrbata (1):
      drm/nouveau: bail out of nouveau_channel_new if channel init fails

Frederic Weisbecker (2):
      rcu: Pull deferred rcuog wake up to rcu_eqs_enter() callers
      rcu/nocb: Perform deferred wake up before last idle's need_resched() check

Gabriel Krisman Bertazi (1):
      watch_queue: Drop references to /dev/watch_queue

Gao Xiang (1):
      erofs: initialized fields can only be observed after bit is set

Geert Uytterhoeven (7):
      arm64: dts: renesas: beacon: Fix EEPROM compatible value
      irqchip/imx: IMX_INTMUX should not default to y, unconditionally
      clk: renesas: r8a779a0: Remove non-existent S2 clock
      clk: renesas: r8a779a0: Fix parent of CBFUSA clock
      auxdisplay: ht16k33: Fix refresh rate handling
      phy: USB_LGM_PHY should depend on X86
      ext: EXT4_KUNIT_TESTS should depend on EXT4_FS instead of selecting it

Gioh Kim (2):
      RDMA/rtrs-srv: fix memory leak by missing kobject free
      RDMA/rtrs-srv-sysfs: fix missing put_device

Giulio Benetti (1):
      drm/sun4i: tcon: fix inverted DCLK polarity

Greg Kroah-Hartman (3):
      debugfs: be more robust at handling improper input in debugfs_lookup()
      debugfs: do not attempt to create a new file before the filesystem is initalized
      Linux 5.10.20

Guchun Chen (1):
      drm/amdgpu: toggle on DF Cstate after finishing xgmi injection

Guenter Roeck (3):
      usb: dwc2: Do not update data length if it is 0 on inbound transfers
      usb: dwc2: Abort transaction after errors with unknown reason
      usb: dwc2: Make "trimming xfer length" a debug message

Guido Günther (2):
      drm/panel: mantix: Tweak init sequence
      spi: imx: Don't print error on -EPROBEDEFER

Guoqing Jiang (2):
      RDMA/rtrs: Call kobject_put in the failure path
      RDMA/rtrs-clt: Refactor the failure cases in alloc_clt

Hans de Goede (2):
      virt: vbox: Do not use wait_event_interruptible when called from kernel context
      regulator: core: Avoid debugfs: Directory ... already present! error

Hao Xu (1):
      io_uring: fix possible deadlock in io_uring_poll

Harald Freudenberger (1):
      s390/zcrypt: return EIO when msg retry limit reached

Hari Bathini (1):
      powerpc/kexec_file: fix FDT size estimation for kdump kernel

He Zhe (1):
      arm64: uprobe: Return EOPNOTSUPP for AARCH32 instruction probing

Heiko Carstens (1):
      s390/vtime: fix inline assembly clobber list

Heiko Stuebner (1):
      drm/panel: kd35t133: allow using non-continuous dsi clock

Heiner Kallweit (3):
      net: phy: consider that suspend2ram may cut off PHY power
      PCI: Align checking of syscall user config accessors
      r8169: fix jumbo packet handling on RTL8168e

Henry Tieman (1):
      ice: update the number of available RSS queues

Huacai Chen (1):
      irqchip/loongson-pch-msi: Use bitmap_zalloc() to allocate bitmap

Hui Wang (1):
      ASoC: SOF: debug: Fix a potential issue on string buffer termination

Ilya Leoshkevich (1):
      bpf: Clear subreg_def for global function return values

Ilya Lipnitskiy (1):
      staging/mt7621-dma: mtk-hsdma.c->hsdma-mt7621.c

Imre Deak (1):
      drm/dp_mst: Don't cache EDIDs for physical ports

Ioana Ciornei (1):
      dpaa2-eth: fix memory leak in XDP_REDIRECT

Isaac J. Manjarres (1):
      iommu/arm-smmu-qcom: Fix mask extraction for bootloader programmed SMRs

Iskren Chernev (2):
      drm/msm: Fix MSM_INFO_GET_IOVA with carveout
      drm/msm/mdp5: Fix wait-for-commit for cmd panels

Ivan Zaentsev (1):
      w1: w1_therm: Fix conversion result for negative temperatures

J. Bruce Fields (1):
      nfsd: register pernet ops last, unregister first

Jack Pham (1):
      usb: gadget: u_audio: Free requests only after callback

Jack Wang (8):
      RDMA/rtrs: Extend ibtrs_cq_qp_create
      RDMA/rtrs-srv: Release lock before call into close_sess
      RDMA/rtrs-srv: Use sysfs_remove_file_self for disconnect
      RDMA/rtrs-clt: Set mininum limit when create QP
      RDMA/rtrs-srv: Fix missing wr_cqe
      RDMA/rtrs-srv: Init wr_cnt as 1
      RDMA/rtrs-srv: Fix stack-out-of-bounds
      RDMA/rtrs-srv: Do not pass a valid pointer to PTR_ERR()

Jacopo Mondi (1):
      media: i2c: ov5670: Fix PIXEL_RATE minimum value

Jae Hyun Yoo (1):
      soc: aspeed: snoop: Add clock control logic

Jaegeuk Kim (1):
      f2fs: flush data when enabling checkpoint back

James Bottomley (2):
      tpm_tis: Fix check_locality for correct locality acquisition
      tpm_tis: Clean up locality release

James Reynolds (1):
      media: mceusb: Fix potential out-of-bounds shift

Jan Henrik Weinstock (1):
      hwrng: timeriomem - Fix cooldown period calculation

Jan Kara (2):
      bfq: Avoid false bfq queue merging
      quota: Fix memory leak when handling corrupted quota file

Jan Kokemüller (1):
      drm/amd/display: Add FPU wrappers to dcn21_validate_bandwidth()

Jann Horn (1):
      Take mmap lock in cacheflush syscall

Jarkko Sakkinen (3):
      KEYS: trusted: Fix incorrect handling of tpm_get_random()
      KEYS: trusted: Fix migratable=1 failing
      KEYS: trusted: Reserve TPM for seal and unseal operations

Jason A. Donenfeld (5):
      wireguard: device: do not generate ICMP for non-IP packets
      wireguard: kconfig: use arm chacha even with no neon
      net: icmp: pass zeroed opts from icmp{,v6}_ndo_send before sending
      wireguard: selftests: test multiple parallel streams
      wireguard: queueing: get rid of per-peer ring buffers

Jason Gerecke (1):
      HID: wacom: Ignore attempts to overwrite the touch_max value from HID

Jeff Layton (1):
      ceph: fix flush_snap logic after putting caps

Jeffle Xu (3):
      dm table: fix iterate_devices based device capability checks
      dm table: fix DAX iterate_devices based device capability checks
      dm table: fix zoned iterate_devices based device capability checks

Jens Axboe (1):
      proc: don't allow async path resolution of /proc/thread-self components

Jesper Dangaard Brouer (1):
      bpf: Fix bpf_fib_lookup helper MTU check for SKB ctx

Jialin Zhang (1):
      drm/gma500: Fix error return code in psb_driver_load()

Jiri Bohac (1):
      pstore: Fix typo in compression option name

Jiri Kosina (1):
      floppy: reintroduce O_NDELAY fix

Jiri Olsa (1):
      crypto: bcm - Rename struct device_private to bcm_device_private

Joe Perches (1):
      media: lmedm04: Fix misuse of comma

Johan Hovold (2):
      USB: serial: ftdi_sio: fix FTX sub-integer prescaler
      USB: serial: pl2303: fix line-speed handling on newer chips

Johannes Berg (2):
      um: mm: check more comprehensively for stub changes
      um: defer killing userspace on page table update failures

Johannes Thumshirn (1):
      scsi: sd: sd_zbc: Don't pass GFP_NOIO to kvcalloc

John Garry (1):
      perf vendor events arm64: Fix Ampere eMag event typo

John Ogness (1):
      printk: avoid prb_first_valid_seq() where possible

John Stultz (1):
      kselftests: dmabuf-heaps: Fix Makefile's inclusion of the kernel's usr/include dir

John Wang (1):
      ARM: dts: aspeed: Add LCLK to lpc-snoop

Jonathan Marek (2):
      regulator: qcom-rpmh: fix pm8009 ldo7
      misc: fastrpc: fix incorrect usage of dma_map_sgtable

Jorgen Hansen (1):
      VMCI: Use set_page_dirty_lock() when unregistering guest memory

Josef Bacik (9):
      proc: use kvzalloc for our kernel buffer
      btrfs: do not cleanup upper nodes in btrfs_backref_cleanup_node
      btrfs: do not warn if we can't find the reloc root when looking up backref
      btrfs: add asserts for deleting backref cache nodes
      btrfs: abort the transaction if we fail to inc ref in btrfs_copy_root
      btrfs: fix reloc root leak with 0 ref reloc roots on recovery
      btrfs: splice remaining dirty_bg's onto the transaction dirty bg list
      btrfs: handle space_info::total_bytes_pinned inside the delayed ref itself
      btrfs: account for new extents being deleted in total_bytes_pinned

Josh Poimboeuf (3):
      objtool: Fix error handling for STD/CLD warnings
      objtool: Fix retpoline detection in asm code
      objtool: Fix ".cold" section suffix check for newer versions of GCC

Judy Hsiao (1):
      drm/msm/dp: trigger unplug event in msm_dp_display_disable

Juergen Gross (1):
      xen/netback: fix spurious event detection for common event case

Jun Nie (1):
      ASoC: qcom: lpass: Fix i2s ctl register bit map

Jun'ichi Nomura (1):
      bpf, devmap: Use GFP_KERNEL for xdp bulk queue allocation

Jupeng Zhong (1):
      Bluetooth: btusb: Fix memory leak in btusb_mtk_wmt_recv

Jérôme Pouiller (1):
      staging: wfx: fix possible panic with re-queued frames

Kai Krakow (3):
      Revert "bcache: Kill btree_io_wq"
      bcache: Give btree_io_wq correct semantics again
      bcache: Move journal work to new flush wq

Kai Vehmanen (1):
      ALSA: hda: Add another CometLake-H PCI ID

Kamal Heib (1):
      RDMA/siw: Fix calculation of tx_valid_cpus size

KarimAllah Ahmed (1):
      fdt: Properly handle "no-map" field in the memory region

Karol Herbst (1):
      drm/nouveau/kms: handle mDP connectors

Kees Cook (1):
      spi: dw: Avoid stack content exposure

Keith Busch (1):
      nvme-multipath: set nr_zones for zoned namespaces

Keqian Zhu (2):
      vfio/iommu_type1: Populate full dirty when detach non-pinned group
      vfio/iommu_type1: Fix some sanity checks in detach group

Kevin Hao (1):
      Revert "MIPS: Octeon: Remove special handling of CONFIG_MIPS_ELF_APPENDED_DTB=y"

Konrad Dybcio (1):
      drm/msm/dsi: Correct io_start for MSM8994 (20nm PHY)

Krzysztof Kozlowski (10):
      ARM: dts: exynos: correct PMIC interrupt trigger level on Artik 5
      ARM: dts: exynos: correct PMIC interrupt trigger level on Monk
      ARM: dts: exynos: correct PMIC interrupt trigger level on Rinato
      ARM: dts: exynos: correct PMIC interrupt trigger level on Spring
      ARM: dts: exynos: correct PMIC interrupt trigger level on Arndale Octa
      ARM: dts: exynos: correct PMIC interrupt trigger level on Odroid XU3 family
      arm64: dts: exynos: correct PMIC interrupt trigger level on TM2
      arm64: dts: exynos: correct PMIC interrupt trigger level on Espresso
      regulator: s5m8767: Drop regulators OF node reference
      soc: samsung: exynos-asv: handle reading revision register error

Krzysztof Wilczyński (1):
      PCI: cadence: Fix DMA range mapping early return error

Lakshmi Ramasubramanian (2):
      ima: Free IMA measurement buffer on error
      ima: Free IMA measurement buffer after kexec syscall

Lang Cheng (1):
      RDMA/hns: Fixes missing error code of CMDQ

Laurent Pinchart (2):
      drm: rcar-du: Fix crash when using LVDS1 clock for CRTC
      media: uvcvideo: Accept invalid bFormatIndex and bFrameIndex values

Lech Perczak (1):
      USB: serial: option: update interface mapping for ZTE P685M

Leon Romanovsky (1):
      ipv6: silence compilation warning for non-IPV6 builds

Lijun Ou (1):
      RDMA/hns: Disable RQ inline by default

Lijun Pan (2):
      ibmvnic: add memory barrier to protect long term buffer
      ibmvnic: skip send_request_unmap for timeout reset

Linus Lüssing (1):
      ath9k: fix data bus crash when setting nf_override via debugfs

Linus Torvalds (2):
      tty: convert tty_ldisc_ops 'read()' function to take a kernel pointer
      tty: implement read_iter

Lubomir Rintel (1):
      media: marvell-ccic: power up the device on mclk enable

Luca Coelho (7):
      iwlwifi: mvm: set enabled in the PPAG command properly
      iwlwifi: mvm: fix the type we use in the PPAG table validity checks
      iwlwifi: mvm: store PPAG enabled/disabled flag properly
      iwlwifi: mvm: send stored PPAG command instead of local
      iwlwifi: mvm: assign SAR table revision to the command later
      iwlwifi: pnvm: set the PNVM again if it was already loaded
      iwlwifi: pnvm: increment the pointer before checking the TLV

Luca Weiss (1):
      soc: qcom: ocmem: don't return NULL in of_get_ocmem

Luo Meng (1):
      media: qm1d1c0042: fix error return code in qm1d1c0042_init()

Magnum Shan (1):
      mailbox: sprd: correct definition of SPRD_OUTBOX_FIFO_FULL

Manivannan Sadhasivam (1):
      mtd: parsers: afs: Fix freeing the part name memory in failure

Marc Kleine-Budde (1):
      can: mcp251xfd: mcp251xfd_probe(): fix errata reference

Marc Zyngier (1):
      arm64: Add missing ISB after invalidating TLB in __primary_switch

Marcin Ślusarz (1):
      soundwire: intel: fix possible crash when no device is detected

Marco Elver (2):
      bpf_lru_list: Read double-checked variable once without lock
      kcsan: Rewrite kcsan_prandom_u32_max() without prandom_u32_state()

Marcos Paulo de Souza (1):
      Input: i8042 - add ASUS Zenbook Flip to noselftest list

Marek Behún (1):
      arm64: dts: armada-3720-turris-mox: rename u-boot mtd partition to a53-firmware

Marek Szyprowski (1):
      soc: samsung: exynos-asv: don't defer early on not-supported SoCs

Marek Vasut (1):
      PCI: rcar: Always allocate MSI addresses in 32bit space

Mario Kleiner (2):
      drm/amd/display: Fix 10/12 bpc setup in DCE output bit depth reduction.
      drm/amd/display: Fix HDMI deep color output for DCE 6-11.

Martin Blumenstingl (4):
      net: stmmac: dwmac-meson8b: fix enabling the timing-adjustment clock
      clk: meson: clk-pll: fix initializing the old rate (fallback) for a PLL
      clk: meson: clk-pll: make "ret" a signed integer
      clk: meson: clk-pll: propagate the error from meson_clk_pll_set_rate()

Martin KaFai Lau (1):
      libbpf: Ignore non function pointer member in struct_ops

Martin Kaiser (1):
      staging: rtl8188eu: Add Edimax EW-7811UN V2 to device table

Masahisa Kojima (1):
      spi: spi-synquacer: fix set_cs handling

Masami Hiramatsu (1):
      kprobes: Fix to delay the kprobes jump optimization

Mateusz Palczewski (4):
      i40e: Add zero-initialization of AQ command structures
      i40e: Fix overwriting flow control settings during driver loading
      i40e: Fix addition of RX filters after enabling FW LLDP agent
      i40e: Fix add TC filter for IPv6

Mathias Kresin (1):
      phy: lantiq: rcu-usb2: wait after clock enable

Matthieu Baerts (1):
      selftests: mptcp: fix ACKRX debug message

Matti Vaittinen (1):
      regulator: bd718x7, bd71828, Fix dvs voltage levels

Max Gurtovoy (1):
      vfio-pci/zdev: fix possible segmentation fault issue

Maxim Kiselev (1):
      gpio: pcf857x: Fix missing first interrupt

Maxim Mikityanskiy (4):
      net/mlx5e: Don't change interrupt moderation params when DIM is enabled
      net/mlx5e: Change interrupt moderation channel params also when channels are closed
      net/mlx5e: Replace synchronize_rcu with synchronize_net
      net/mlx5e: kTLS, Use refcounts to free kTLS RX priv context

Maxime Chevallier (1):
      net: mvneta: Remove per-cpu queue mapping for Armada 3700

Maxime Ripard (4):
      drm/vc4: hdmi: Take into account the clock doubling flag in atomic_check
      drm/vc4: hdmi: Compute the CEC clock divider from the clock rate
      drm/vc4: hdmi: Update the CEC clock divider on HSM rate change
      i2c: brcmstb: Fix brcmstd_send_i2c_cmd condition

Maximilian Luz (1):
      ACPICA: Fix exception code class checks

Md Haris Iqbal (1):
      RDMA/rtrs: Only allow addition of path to an already established session

Miaohe Lin (3):
      mm/memory.c: fix potential pte_unmap_unlock pte error
      mm/hugetlb: fix potential double free in hugetlb_register_node() error path
      mm/rmap: fix potential pte_unmap on an not mapped pte

Michael Tretter (1):
      clk: divider: fix initialization with parent_hw

Mike Kravetz (2):
      hugetlb: fix update_and_free_page contig page struct assumption
      hugetlb: fix copy_huge_page_from_user contig page struct assumption

Mikulas Patocka (5):
      blk-settings: align max_sectors on "logical_block_size" boundary
      dm: fix deadlock when swapping to encrypted device
      dm writecache: fix performance degradation in ssd mode
      dm writecache: return the exact table values that were set
      dm writecache: fix writing beyond end of underlying device when shrinking

Misono Tomohiro (1):
      x86/MSR: Filter MSR writes through X86_IOC_WRMSR_REGS ioctl too

Moshe Shemesh (1):
      net/mlx5e: Check tunnel offload is required before setting SWP

Muchun Song (5):
      mm: memcontrol: fix NR_ANON_THPS accounting in charge moving
      mm: memcontrol: fix slub memory accounting
      mm: memcontrol: fix swap undercounting in cgroup2
      mm: memcontrol: fix get_active_memcg return value
      printk: fix deadlock when kernel panic

Mårten Lindahl (1):
      i2c: exynos5: Preserve high speed master code

Namhyung Kim (1):
      perf test: Fix unaligned access in sample parsing test

Namjae Jeon (1):
      exfat: fix shift-out-of-bounds in exfat_fill_super()

Nathan Chancellor (5):
      vmlinux.lds.h: Define SANTIZER_DISCARDS with CONFIG_GCOV_KERNEL=y
      MIPS: c-r4k: Fix section mismatch for loongson2_sc_init
      MIPS: lantiq: Explicitly compare LTQ_EBU_PCC_ISTAT against 0
      MIPS: Compare __SYNC_loongson3_war against 0
      MIPS: VDSO: Use CLANG_FLAGS instead of filtering out '--target='

Nathan Lynch (1):
      powerpc/pseries/dlpar: handle ibm, configure-connector delay status

NeilBrown (2):
      seq_file: document how per-entry resources are managed.
      x86: fix seq_file iteration for pat/memtype.c

Nicholas Fraser (1):
      perf symbols: Fix return value when loading PE DSO

Nick Desaulniers (1):
      vmlinux.lds.h: add DWARF v5 sections

Nicolas Boichat (1):
      of/fdt: Make sure no-map does not remove already reserved regions

Nicolas Saenz Julienne (1):
      spi: Skip zero-length transfers in spi_transfer_one_message()

Nikos Tsironis (7):
      dm era: Recover committed writeset after crash
      dm era: Update in-core bitset after committing the metadata
      dm era: Verify the data block size hasn't changed
      dm era: Fix bitset memory leaks
      dm era: Use correct value size in equality function of writeset tree
      dm era: Reinitialize bitset cache before digesting a new writeset
      dm era: only resize metadata in preresume

Nirmoy Das (1):
      drm/amdgpu/display: remove hdcp_srm sysfs on device removal

Olivier Crête (1):
      Input: xpad - add support for PowerA Enhanced Wired Controller for Xbox Series X|S

Oz Shlomo (1):
      net/mlx5e: CT: manage the lifetime of the ct entry object

Pan Bian (11):
      Bluetooth: drop HCI device reference before return
      Bluetooth: Put HCI device if inquiry procedure interrupts
      memory: ti-aemif: Drop child node when jumping out loop
      bsg: free the request before return error code
      regulator: axp20x: Fix reference cout leak
      regulator: s5m8767: Fix reference count leak
      spi: atmel: Put allocated master before return
      isofs: release buffer head before return
      PCI: xilinx-cpm: Fix reference count leak on error path
      mtd: spi-nor: hisi-sfc: Put child node np on error path
      fs/affs: release old buffer head on error path

Paolo Bonzini (1):
      KVM: nSVM: fix running nested guests when npt=0

Parav Pandit (3):
      IB/mlx5: Add mutex destroy call to cap_mask_mutex mutex
      IB/mlx5: Return appropriate error code instead of ENOMEM
      IB/cm: Avoid a loop when device has 255 ports

Paul Cercueil (3):
      usb: musb: Fix runtime PM race in musb_queue_resume_work
      MIPS: Ingenic: Disable HPTLB for D0 XBurst CPUs too
      seccomp: Add missing return in non-void function

Pavel Machek (1):
      media: ipu3-cio2: Fix mbus_code processing in cio2_subdev_set_fmt()

PeiSen Hou (1):
      ALSA: hda/realtek: modify EAPD in the ALC886

Peter Zijlstra (1):
      locking/lockdep: Avoid unmatched unlock

Phil Elwell (2):
      staging: vchiq: Fix bulk userdata handling
      staging: vchiq: Fix bulk transfers on 64-bit builds

Pierre-Louis Bossart (7):
      ASoC: Intel: sof_sdw: add missing TGL_HDMI quirk for Dell SKU 0A5E
      ASoC: Intel: sof_sdw: add missing TGL_HDMI quirk for Dell SKU 0A3E
      ASoC: SOF: sof-pci-dev: add missing Up-Extreme quirk
      soundwire: cadence: fix ACK/NAK handling
      soundwire: bus: use sdw_update_no_pm when initializing a device
      soundwire: bus: use sdw_write_no_pm when setting the bus scale registers
      soundwire: bus: fix confusion on device used by pm_runtime

Pingfan Liu (1):
      powerpc/time: Enable sched clock for irqtime

Po-Hsu Lin (1):
      selftests/powerpc: Make the test check in eeh-basic.sh posix compliant

Pratyush Yadav (1):
      spi: cadence-quadspi: Abort read if dummy cycles required are too many

Qais Yousef (1):
      sched/eas: Don't update misfit status if the task is pinned

Qinglang Miao (4):
      drm: rcar-du: Fix PM reference leak in rcar_cmm_enable()
      drm/tegra: Fix reference leak when pm_runtime_get_sync() fails
      drm/lima: fix reference leak in lima_pm_busy
      ACPI: configfs: add missing check after configfs_register_default_group()

Qu Wenruo (1):
      btrfs: fix double accounting of ordered extent for subpage case in btrfs_invalidapge

Quinn Tran (1):
      scsi: qla2xxx: Fix mailbox Ch erroneous error

Rafael J. Wysocki (3):
      ACPI: property: Fix fwnode string properties matching
      cpufreq: ACPI: Set cpuinfo.max_freq directly if max boost is known
      cpufreq: intel_pstate: Change intel_pstate_get_hwp_max() argument

Rakesh Pillai (1):
      ath10k: Fix error handling in case of CE pipe init failure

Randy Dunlap (7):
      fbdev: aty: SPARC64 requires FB_ATY_CT
      HID: core: detect and skip invalid inputs to snto32()
      power: supply: fix sbs-charger build, needs REGMAP_I2C
      sparc64: only select COMPAT_BINFMT_ELF if BINFMT_ELF is set
      sparc: fix led.c driver when PROC_FS is not enabled
      ARM: 9065/1: OABI compat: fix build when EPOLL is not enabled
      scsi: bnx2fc: Fix Kconfig warning & CNIC build errors

Ranjani Sridharan (1):
      ASoC: SOF: Intel: hda: cancel D0i3 work during runtime suspend

Rasmus Villemoes (1):
      spi: fsl: invert spisel_boot signal on MPC8309

Rayagonda Kokatanur (3):
      i2c: iproc: handle only slave interrupts which are enabled
      i2c: iproc: update slave isr mask (ISR_MASK_SLAVE)
      i2c: iproc: handle master read request

Ricky Wu (1):
      misc: rtsx: init of rts522a add OCP power off when no card is present

Rik van Riel (1):
      mm,thp,shmem: make khugepaged obey tmpfs mount flags

Robert Foss (1):
      arm64: dts: qcom: sdm845-db845c: Fix reset-pin of ov8856 node

Robert Hancock (1):
      net: axienet: Handle deferred probe on clock properly

Robin Murphy (2):
      perf/arm-cmn: Fix PMU instance naming
      perf/arm-cmn: Move IRQs when migrating context

Rodrigo Siqueira (1):
      drm/amd/display: Add vupdate_no_lock interrupts for DCN2.1

Roja Rani Yarubandi (1):
      i2c: qcom-geni: Store DMA mapping data in geni_i2c_dev struct

Rosen Penev (2):
      ARM: dts: armada388-helios4: assign pinctrl to LEDs
      ARM: dts: armada388-helios4: assign pinctrl to each fan

Rui Miguel Silva (1):
      media: imx7: csi: Fix pad link validation

Russell King (1):
      PCI: pci-bridge-emul: Fix array overruns, improve safety

Ryan Chen (1):
      clk: aspeed: Fix APLL calculate formula from ast2600-A2

Sabyrzhan Tasbolatov (1):
      drivers/misc/vmw_vmci: restrict too big queue size in qp_host_alloc_queue

Sagi Grimberg (2):
      nvmet-tcp: fix receive data digest calculation for multiple h2cdata PDUs
      nvmet-tcp: fix potential race of tcp socket closing accept_work

Sai Prakash Ranjan (1):
      watchdog: qcom: Remove incorrect usage of QCOM_WDT_ENABLE_IRQ

Sameer Pujar (1):
      ASoC: simple-card-utils: Fix device module clock

Samuel Holland (1):
      power: supply: axp20x_usb_power: Init work before enabling IRQs

Sara Sharon (1):
      iwlwifi: mvm: don't check if CSA event is running before removing

Sathyanarayana Nujella (1):
      ASoC: rt5682: Fix panic in rt5682_jack_detect_handler happening during system shutdown

Sean Christopherson (6):
      KVM: nSVM: Don't strip host's C-bit from guest's CR3 when reading PDPTRs
      KVM: x86: Restore all 64 bits of DR6 and DR7 during RSM on x86-64
      KVM: SVM: Intercept INVPCID when it's disabled to inject #UD
      KVM: x86/mmu: Expand collapsible SPTE zap for TDP MMU to ZONE_DEVICE and HugeTLB pages
      x86/virt: Eat faults on VMXOFF in reboot flows
      x86/reboot: Force all cpus to exit VMX root if VMX is supported

Sean Young (2):
      media: ir_toy: add another IR Droid device
      media: smipcie: fix interrupt handling and IR timeout

Sebastian Andrzej Siewior (1):
      smp: Process pending softirqs in flush_smp_call_function_from_idle()

Sebastian Reichel (1):
      ASoC: cpcap: fix microphone timeslot mask

Shaoying Xu (1):
      arm64 module: set plt* section addresses to 0x0

Shawn Guo (1):
      cpufreq: qcom-hw: drop devm_xxx() calls from init/exit hooks

Shay Drory (7):
      net/mlx5: Fix health error state handling
      net/mlx5: Disable devlink reload for multi port slave device
      net/mlx5: Disallow RoCE on multi port slave device
      net/mlx5: Disallow RoCE on lag device
      net/mlx5: Disable devlink reload for lag devices
      IB/umad: Return EIO in case of when device disassociated
      IB/umad: Return EPOLLERR in case of when device disassociated

Shin'ichiro Kawasaki (1):
      zonefs: Fix file size of zones in full condition

Shirley Her (1):
      mmc: sdhci-pci-o2micro: Bug fix for SDR104 HW tuning failure

Shiyang Ruan (1):
      device-dax: Fix default return code of range_parse()

Shyam Sundar S K (4):
      net: amd-xgbe: Reset the PHY rx data path when mailbox command timeout
      net: amd-xgbe: Fix NETDEV WATCHDOG transmit queue timeout warning
      net: amd-xgbe: Reset link when the link never comes back
      net: amd-xgbe: Fix network fluctuations when using 1G BELFUSE SFP

Simon Ser (1):
      drm/fourcc: fix Amlogic format modifier masks

Simon South (3):
      pwm: rockchip: Enable APB clock during register access while probing
      pwm: rockchip: rockchip_pwm_probe(): Remove superfluous clk_unprepare()
      pwm: rockchip: Eliminate potential race condition when probing

Slawomir Laba (1):
      i40e: Fix flow for IPv6 next header (extension header)

Song, Yoong Siang (1):
      net: stmmac: fix CBS idleslope and sendslope calculation

Srinivas Kandagatla (1):
      ASoC: codecs: add missing max_register in regmap config

Srinivasa Rao Mandadapu (2):
      ASoC: qcom: lpass-cpu: Remove bit clock state check
      ASoC: qcom: Fix typo error in HDMI regmap config callbacks

Stefano Garzarella (1):
      vdpa/mlx5: fix param validation in mlx5_vdpa_get_config()

Stephan Gerhold (3):
      arm64: dts: qcom: msm8916-samsung-a5u: Fix iris compatible
      arm64: dts: qcom: msm8916-samsung-a2015: Fix sensors
      ASoC: qcom: qdsp6: Move frontend AIFs to q6asm-dai

Steven Rostedt (VMware) (1):
      tracepoint: Do not fail unregistering a probe due to memory failure

Subbaraman Narayanamurthy (2):
      nvmem: qcom-spmi-sdam: Fix uninitialized pdev pointer
      spmi: spmi-pmic-arb: Fix hw_irq overflow

Sukadev Bhattiprolu (1):
      ibmvnic: Set to CLOSED state even on error

Sumit Garg (2):
      kdb: Make memory allocations more robust
      kgdb: fix to kill breakpoints on initmem after boot

Suzuki K Poulose (3):
      coresight: etm4x: Skip accessing TRCPDCR in save/restore
      arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55
      coresight: etm4x: Handle accesses to TRCSTALLCTLR

Sylwester Dziedziuch (1):
      i40e: Fix VFs not created

Taehee Yoo (1):
      vxlan: move debug check after netdev unregister

Takahiro Kuwano (4):
      mtd: spi-nor: sfdp: Fix last erase region marking
      mtd: spi-nor: sfdp: Fix wrong erase type bitmask for overlaid region
      mtd: spi-nor: core: Fix erase type discovery for overlaid region
      mtd: spi-nor: core: Add erase size check for erase command initialization

Takashi Iwai (7):
      ALSA: usb-audio: Fix PCM buffer allocation in non-vmalloc mode
      ALSA: pcm: Call sync_stop at disconnection
      ALSA: pcm: Assure sync with the pending stop operation at suspend
      ALSA: pcm: Don't call sync_stop if it hasn't been stopped
      ALSA: hda/hdmi: Drop bogus check at closing a stream
      ALSA: hda/realtek: Quirk for HP Spectre x360 14 amp setup
      ASoC: siu: Fix build error by a wrong const prefix

Takashi Sakamoto (1):
      ALSA: fireface: fix to parse sync status register of latter protocol

Takeshi Misawa (1):
      net: qrtr: Fix memory leak in qrtr_tun_open

Takeshi Saito (1):
      mmc: renesas_sdhi_internal_dmac: Fix DMA buffer alignment from 8 to 128-bytes

Theodore Ts'o (1):
      ext4: fix potential htree index checksum corruption

Thinh Nguyen (2):
      usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1
      usb: dwc3: gadget: Fix dep->interval for fullspeed interrupt

Thomas Gleixner (1):
      x86/entry: Fix instrumentation annotation

Tim Harvey (1):
      mfd: gateworks-gsc: Fix interrupt type

Timothy E Baldwin (1):
      arm64: ptrace: Fix seccomp of traced syscall -1 (NO_SYSCALL)

Tobias Klauser (1):
      riscv: Disable KSAN_SANITIZE for vDSO

Tom Rix (4):
      media: mtk-vcodec: fix argument used when DEBUG is defined
      media: pxa_camera: declare variable when DEBUG is defined
      jffs2: fix use after free in jffs2_sum_write_data()
      clocksource/drivers/mxs_timer: Add missing semicolon when DEBUG is defined

Tom Zanussi (1):
      selftests/ftrace: Update synthetic event syntax errors

Tomas Winkler (1):
      mei: me: emmitsburg workstation DID

Tomi Valkeinen (2):
      media: ti-vpe: cal: fix write to unallocated memory
      media: i2c: max9286: fix access to unallocated memory

Tony Lindgren (4):
      ARM: dts: Configure missing thermal interrupt for 4430
      power: supply: cpcap: Add missing IRQF_ONESHOT to fix regression
      power: supply: cpcap-charger: Fix missing power_supply_put()
      power: supply: cpcap-battery: Fix missing power_supply_put()

Trond Myklebust (1):
      NFSv4: Fixes for nfs4_bitmask_adjust()

Tzung-Bi Shih (1):
      remoteproc/mediatek: acknowledge watchdog IRQ after handled

Uwe Kleine-König (2):
      amba: Fix resource leak for drivers without .remove
      pwm: iqs620a: Fix overflow and optimize calculations

Vasundhara Volam (1):
      bnxt_en: Fix devlink info's stored fw.psid version format.

Ville Syrjälä (2):
      drm/modes: Switch to 64bit maths to avoid integer overflow
      drm/i915: Reject 446-480MHz HDMI clock on GLK

Vincent Knecht (1):
      arm64: dts: msm8916: Fix reserved and rfsa nodes unit address

Viresh Kumar (1):
      thermal: cpufreq_cooling: freq_qos_update_request() returns < 0 on error

Vlad Buslov (1):
      net: sched: fix police ext initialization

Vladimir Murzin (1):
      ARM: 9046/1: decompressor: Do not clear SCTLR.nTLSMD for ARMv7+ cores

Vladimir Oltean (3):
      net: dsa: felix: perform teardown in reverse order of setup
      net: dsa: felix: don't deinitialize unused ports
      net: enetc: fix destroyed phylink dereference during unbind

Vlastimil Babka (1):
      mm, compaction: make fast_isolate_freepages() stay within zone

Wang ShaoBo (1):
      ubifs: Fix error return code in alloc_wbufs()

Wang Xiaojun (1):
      drm: rcar-du: Fix the return check of of_parse_phandle and of_find_device_by_node

Weihang Li (1):
      RDMA/hns: Fix type of sq_signal_bits

Wenpeng Liang (1):
      RDMA/hns: Fixed wrong judgments in the goto branch

Will Deacon (2):
      mm: proc: Invalidate TLB after clearing soft-dirty page state
      arm64: spectre: Prevent lockdep splat on v4 mitigation enable path

Wonhyuk Yang (1):
      mm/compaction: fix misbehaviors of fast_find_migrateblock()

Xuewen Yan (1):
      sched/fair: Avoid stale CPU util_est value for schedutil in task dequeue

Yang Jihong (1):
      perf record: Fix continue profiling after draining the buffer

Yi Chen (1):
      f2fs: fix to avoid inconsistent quota data

Yishai Hadas (1):
      RDMA/mlx5: Use the correct obj_id upon DEVX TIR creation

Yong Wu (2):
      iommu: Switch gather->end to the inclusive end
      iommu: Move iotlb_sync_map out from __iommu_map

Yonghong Song (1):
      bpf: Fix an unitialized value in bpf_iter

Yongqiang Niu (1):
      drm/mediatek: Check if fb is null

Yoshihiro Shimoda (1):
      mfd: bd9571mwv: Use devm_mfd_add_devices()

Zhang Changzhong (2):
      media: mtk-vcodec: fix error return code in vdec_vp9_decode()
      media: aspeed: fix error return code in aspeed_video_setup_video()

Zhang Qilong (2):
      memory: mtk-smi: Fix PM usage counter unbalance in mtk_smi ops
      HSI: Fix PM usage counter unbalance in ssi_hw_init

Zhenzhong Duan (1):
      csky: Fix a size determination in gpr_get()

Zhihao Cheng (1):
      btrfs: clarify error returns values in __load_free_space_cache

jeffrey.lin (1):
      Input: raydium_ts_i2c - do not send zero length

qiuguorui1 (1):
      arm64: kexec_file: fix memory leakage in create_dtb() when fdt_open_into() fails

