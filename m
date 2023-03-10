Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9F56B393E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 09:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbjCJIue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 03:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjCJItl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 03:49:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2322F20068;
        Fri, 10 Mar 2023 00:49:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FC4161137;
        Fri, 10 Mar 2023 08:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478AEC433D2;
        Fri, 10 Mar 2023 08:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678438153;
        bh=uZ30uUkJM/GM72GeVBueWakgeZhxkyZVJrMNU1+zYdU=;
        h=From:To:Cc:Subject:Date:From;
        b=ReOSZYu8Q42JZoF1FQ+zCfGfqUJAc5DZivEo/gz70YU2agH4suQI7nUwDI17rOjMY
         L8la2x893RC3yEDk47wJ9QVBoeXVqqUxvulO3w1ECnWXTGek9YLWsSP4ghu0ClC71D
         8iyd5/EjHXdIyyrdat5C4wsCaOz5W+Zji8BG9npM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.99
Date:   Fri, 10 Mar 2023 09:48:52 +0100
Message-Id: <167843813216030@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.99 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/cgroup-v1/memory.rst                      |   13 
 Documentation/admin-guide/hw-vuln/spectre.rst                       |   21 
 Documentation/admin-guide/kdump/gdbmacros.txt                       |    2 
 Documentation/dev-tools/gdb-kernel-debugging.rst                    |    4 
 Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml  |    2 
 Documentation/hwmon/ftsteutates.rst                                 |    4 
 Documentation/virt/kvm/api.rst                                      |   18 
 Documentation/virt/kvm/devices/vm.rst                               |    4 
 Makefile                                                            |   15 
 arch/alpha/boot/tools/objstrip.c                                    |    2 
 arch/alpha/kernel/traps.c                                           |   30 
 arch/arm/boot/dts/exynos3250-rinato.dts                             |    2 
 arch/arm/boot/dts/exynos4-cpu-thermal.dtsi                          |    2 
 arch/arm/boot/dts/exynos4.dtsi                                      |    2 
 arch/arm/boot/dts/exynos4210.dtsi                                   |    1 
 arch/arm/boot/dts/exynos5250.dtsi                                   |    2 
 arch/arm/boot/dts/exynos5410-odroidxu.dts                           |    1 
 arch/arm/boot/dts/exynos5420.dtsi                                   |    2 
 arch/arm/boot/dts/exynos5422-odroidhc1.dts                          |   10 
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi                  |   10 
 arch/arm/boot/dts/imx7s.dtsi                                        |    2 
 arch/arm/boot/dts/qcom-sdx55.dtsi                                   |    2 
 arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts                          |    2 
 arch/arm/configs/bcm2835_defconfig                                  |    1 
 arch/arm/mach-imx/mmdc.c                                            |   24 
 arch/arm/mach-omap1/timer.c                                         |    2 
 arch/arm/mach-omap2/timer.c                                         |    1 
 arch/arm/mach-s3c/s3c64xx.c                                         |    3 
 arch/arm/mach-zynq/slcr.c                                           |    1 
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi                          |    4 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi                   |    2 
 arch/arm64/boot/dts/amlogic/meson-g12a.dtsi                         |   20 
 arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi              |    2 
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi                           |    6 
 arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts                  |    2 
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts          |    2 
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts           |    1 
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi                          |    2 
 arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts               |    6 
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts                |   10 
 arch/arm64/boot/dts/freescale/imx8mm.dtsi                           |    2 
 arch/arm64/boot/dts/freescale/imx8mn.dtsi                           |    2 
 arch/arm64/boot/dts/freescale/imx8mp.dtsi                           |    2 
 arch/arm64/boot/dts/freescale/imx8mq.dtsi                           |    2 
 arch/arm64/boot/dts/mediatek/mt7622.dtsi                            |    1 
 arch/arm64/boot/dts/mediatek/mt8183.dtsi                            |   12 
 arch/arm64/boot/dts/mediatek/mt8192.dtsi                            |   11 
 arch/arm64/boot/dts/qcom/ipq8074.dtsi                               |   93 +-
 arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts               |   18 
 arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi              |    5 
 arch/arm64/boot/dts/qcom/pmk8350.dtsi                               |    5 
 arch/arm64/boot/dts/qcom/qcs404.dtsi                                |   12 
 arch/arm64/boot/dts/qcom/sc7180.dtsi                                |    4 
 arch/arm64/boot/dts/qcom/sc7280.dtsi                                |    4 
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts                          |    2 
 arch/arm64/boot/dts/qcom/sm6125.dtsi                                |    6 
 arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi             |    7 
 arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi           |   24 
 arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts               |    2 
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi                     |   29 
 arch/m68k/68000/entry.S                                             |    2 
 arch/m68k/Kconfig.devices                                           |    1 
 arch/m68k/coldfire/entry.S                                          |    2 
 arch/m68k/kernel/entry.S                                            |    3 
 arch/mips/boot/dts/ingenic/ci20.dts                                 |    2 
 arch/mips/include/asm/syscall.h                                     |    2 
 arch/powerpc/Makefile                                               |    2 
 arch/powerpc/mm/book3s64/radix_tlb.c                                |   11 
 arch/riscv/Makefile                                                 |    6 
 arch/riscv/include/asm/ftrace.h                                     |   50 +
 arch/riscv/include/asm/jump_label.h                                 |    2 
 arch/riscv/include/asm/pgtable.h                                    |    2 
 arch/riscv/include/asm/thread_info.h                                |    1 
 arch/riscv/kernel/ftrace.c                                          |   65 -
 arch/riscv/kernel/mcount-dyn.S                                      |   42 -
 arch/riscv/kernel/time.c                                            |    3 
 arch/riscv/mm/fault.c                                               |   10 
 arch/s390/boot/mem_detect.c                                         |    2 
 arch/s390/include/asm/ap.h                                          |   12 
 arch/s390/kernel/idle.c                                             |    2 
 arch/s390/kernel/kprobes.c                                          |    4 
 arch/s390/kernel/vdso32/Makefile                                    |    2 
 arch/s390/kernel/vdso64/Makefile                                    |    4 
 arch/s390/kernel/vmlinux.lds.S                                      |    1 
 arch/s390/kvm/kvm-s390.c                                            |   17 
 arch/s390/mm/extmem.c                                               |   12 
 arch/s390/mm/vmem.c                                                 |    6 
 arch/sparc/Kconfig                                                  |    2 
 arch/x86/Kconfig                                                    |   15 
 arch/x86/crypto/ghash-clmulni-intel_glue.c                          |    6 
 arch/x86/events/zhaoxin/core.c                                      |    8 
 arch/x86/include/asm/microcode.h                                    |    4 
 arch/x86/include/asm/microcode_amd.h                                |    4 
 arch/x86/include/asm/msr-index.h                                    |    4 
 arch/x86/include/asm/processor.h                                    |    5 
 arch/x86/include/asm/reboot.h                                       |    2 
 arch/x86/include/asm/virtext.h                                      |   16 
 arch/x86/kernel/cpu/bugs.c                                          |   35 -
 arch/x86/kernel/cpu/common.c                                        |   47 -
 arch/x86/kernel/cpu/microcode/amd.c                                 |   53 -
 arch/x86/kernel/cpu/microcode/core.c                                |  134 ---
 arch/x86/kernel/crash.c                                             |   17 
 arch/x86/kernel/kprobes/opt.c                                       |    6 
 arch/x86/kernel/process.c                                           |    2 
 arch/x86/kernel/reboot.c                                            |   88 +-
 arch/x86/kernel/smp.c                                               |    6 
 arch/x86/kvm/lapic.c                                                |   10 
 arch/x86/kvm/svm/sev.c                                              |    4 
 arch/x86/kvm/svm/svm_onhyperv.h                                     |    4 
 block/bio-integrity.c                                               |    1 
 block/blk-iocost.c                                                  |   11 
 block/blk-mq-sched.c                                                |    7 
 block/blk-mq.c                                                      |    3 
 block/fops.c                                                        |   21 
 crypto/asymmetric_keys/public_key.c                                 |   24 
 crypto/essiv.c                                                      |    7 
 crypto/rsa-pkcs1pad.c                                               |   34 
 crypto/seqiv.c                                                      |    2 
 crypto/xts.c                                                        |    8 
 drivers/acpi/acpica/Makefile                                        |    2 
 drivers/acpi/acpica/hwvalid.c                                       |    7 
 drivers/acpi/acpica/nsrepair.c                                      |   12 
 drivers/acpi/battery.c                                              |    2 
 drivers/acpi/resource.c                                             |   43 +
 drivers/acpi/video_detect.c                                         |    2 
 drivers/base/core.c                                                 |    3 
 drivers/base/power/domain.c                                         |    5 
 drivers/base/transport_class.c                                      |   17 
 drivers/block/brd.c                                                 |   26 
 drivers/block/rbd.c                                                 |   20 
 drivers/bluetooth/btusb.c                                           |    4 
 drivers/bluetooth/hci_qca.c                                         |    7 
 drivers/char/applicom.c                                             |    5 
 drivers/char/ipmi/ipmi_ssif.c                                       |   74 --
 drivers/char/pcmcia/cm4000_cs.c                                     |    6 
 drivers/crypto/amcc/crypto4xx_core.c                                |   10 
 drivers/crypto/ccp/ccp-dmaengine.c                                  |   21 
 drivers/crypto/ccp/sev-dev.c                                        |   33 
 drivers/crypto/hisilicon/sgl.c                                      |    3 
 drivers/crypto/qat/qat_common/qat_algs.c                            |    2 
 drivers/dax/bus.c                                                   |    2 
 drivers/dax/kmem.c                                                  |    4 
 drivers/dma/Kconfig                                                 |    2 
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c                      |    2 
 drivers/dma/dw-edma/dw-edma-core.c                                  |    4 
 drivers/dma/dw-edma/dw-edma-v0-core.c                               |    2 
 drivers/dma/idxd/device.c                                           |    2 
 drivers/dma/idxd/init.c                                             |    2 
 drivers/dma/idxd/sysfs.c                                            |    4 
 drivers/dma/sf-pdma/sf-pdma.c                                       |    3 
 drivers/dma/sf-pdma/sf-pdma.h                                       |    1 
 drivers/firmware/dmi-sysfs.c                                        |   10 
 drivers/firmware/google/framebuffer-coreboot.c                      |    4 
 drivers/firmware/stratix10-svc.c                                    |   16 
 drivers/gpio/gpio-vf610.c                                           |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                   |    6 
 drivers/gpu/drm/amd/display/dc/core/dc.c                            |    1 
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                       |    6 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c                    |   14 
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h                        |    1 
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c      |    8 
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c    |   10 
 drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c      |   12 
 drivers/gpu/drm/bridge/lontium-lt9611.c                             |   65 +
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c            |    6 
 drivers/gpu/drm/bridge/ti-sn65dsi83.c                               |    2 
 drivers/gpu/drm/drm_edid.c                                          |   21 
 drivers/gpu/drm/drm_fourcc.c                                        |    4 
 drivers/gpu/drm/drm_gem_shmem_helper.c                              |   52 -
 drivers/gpu/drm/drm_mipi_dsi.c                                      |   52 +
 drivers/gpu/drm/drm_mode_config.c                                   |    8 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                      |    6 
 drivers/gpu/drm/exynos/exynos_drm_dsi.c                             |    8 
 drivers/gpu/drm/i915/display/intel_quirks.c                         |    2 
 drivers/gpu/drm/i915/gt/intel_ring.c                                |    4 
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c                             |    2 
 drivers/gpu/drm/mediatek/mtk_drm_drv.c                              |    1 
 drivers/gpu/drm/mediatek/mtk_drm_gem.c                              |    4 
 drivers/gpu/drm/mediatek/mtk_dsi.c                                  |    2 
 drivers/gpu/drm/msm/adreno/adreno_gpu.c                             |    4 
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c                            |    7 
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c                           |   15 
 drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c                              |    5 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c                           |    5 
 drivers/gpu/drm/msm/dsi/dsi_cfg.c                                   |    4 
 drivers/gpu/drm/msm/dsi/dsi_host.c                                  |    3 
 drivers/gpu/drm/msm/hdmi/hdmi.c                                     |    4 
 drivers/gpu/drm/msm/msm_drv.c                                       |    2 
 drivers/gpu/drm/msm/msm_fence.c                                     |    2 
 drivers/gpu/drm/msm/msm_gem_submit.c                                |    4 
 drivers/gpu/drm/mxsfb/Kconfig                                       |    1 
 drivers/gpu/drm/omapdrm/dss/dsi.c                                   |   26 
 drivers/gpu/drm/panel/panel-samsung-s6e3ha2.c                       |    4 
 drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c                    |    3 
 drivers/gpu/drm/panel/panel-samsung-s6e8aa0.c                       |    2 
 drivers/gpu/drm/radeon/atombios_encoders.c                          |    5 
 drivers/gpu/drm/radeon/radeon_device.c                              |    1 
 drivers/gpu/drm/tegra/firewall.c                                    |    3 
 drivers/gpu/drm/tidss/tidss_dispc.c                                 |    4 
 drivers/gpu/drm/tiny/ili9486.c                                      |   13 
 drivers/gpu/drm/vc4/vc4_dpi.c                                       |   66 +
 drivers/gpu/drm/vc4/vc4_hdmi.c                                      |    5 
 drivers/gpu/drm/vc4/vc4_hvs.c                                       |   11 
 drivers/gpu/drm/vc4/vc4_plane.c                                     |    2 
 drivers/gpu/drm/vc4/vc4_regs.h                                      |    6 
 drivers/gpu/drm/vkms/vkms_drv.c                                     |   10 
 drivers/gpu/host1x/hw/syncpt_hw.c                                   |    3 
 drivers/gpu/ipu-v3/ipu-common.c                                     |    1 
 drivers/hid/hid-asus.c                                              |   37 -
 drivers/hid/hid-bigbenff.c                                          |   75 +-
 drivers/hid/hid-debug.c                                             |    1 
 drivers/hid/hid-input.c                                             |    8 
 drivers/hid/hid-logitech-hidpp.c                                    |   32 
 drivers/hid/hid-multitouch.c                                        |   39 +
 drivers/hid/hid-quirks.c                                            |    2 
 drivers/hid/i2c-hid/i2c-hid-core.c                                  |    6 
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c                            |   42 +
 drivers/hid/i2c-hid/i2c-hid.h                                       |    3 
 drivers/hwmon/coretemp.c                                            |  128 +--
 drivers/hwmon/ftsteutates.c                                         |   19 
 drivers/hwmon/ltc2945.c                                             |    2 
 drivers/hwmon/mlxreg-fan.c                                          |    6 
 drivers/hwtracing/coresight/coresight-cti-core.c                    |   11 
 drivers/hwtracing/coresight/coresight-cti-sysfs.c                   |   13 
 drivers/hwtracing/coresight/coresight-etm4x-core.c                  |   18 
 drivers/i2c/busses/i2c-designware-common.c                          |    2 
 drivers/i2c/busses/i2c-designware-core.h                            |    2 
 drivers/iio/light/tsl2563.c                                         |    8 
 drivers/infiniband/hw/cxgb4/cm.c                                    |    7 
 drivers/infiniband/hw/cxgb4/restrack.c                              |    2 
 drivers/infiniband/hw/hfi1/sdma.c                                   |    4 
 drivers/infiniband/hw/hfi1/sdma.h                                   |   15 
 drivers/infiniband/hw/hfi1/user_pages.c                             |   61 +
 drivers/infiniband/hw/irdma/hw.c                                    |    2 
 drivers/infiniband/sw/siw/siw_mem.c                                 |   23 
 drivers/iommu/intel/cap_audit.c                                     |   16 
 drivers/iommu/intel/cap_audit.h                                     |    1 
 drivers/iommu/intel/iommu.c                                         |   50 +
 drivers/iommu/intel/pasid.c                                         |   11 
 drivers/iommu/iommu.c                                               |    8 
 drivers/irqchip/irq-alpine-msi.c                                    |    1 
 drivers/irqchip/irq-bcm7120-l2.c                                    |    3 
 drivers/irqchip/irq-brcmstb-l2.c                                    |    6 
 drivers/irqchip/irq-mvebu-gicp.c                                    |    1 
 drivers/irqchip/irq-ti-sci-intr.c                                   |    1 
 drivers/irqchip/irqchip.c                                           |    8 
 drivers/leds/led-class.c                                            |    6 
 drivers/md/dm-cache-target.c                                        |    4 
 drivers/md/dm-flakey.c                                              |   31 
 drivers/md/dm-ioctl.c                                               |   13 
 drivers/md/dm-thin.c                                                |    2 
 drivers/md/dm.c                                                     |   29 
 drivers/md/dm.h                                                     |    2 
 drivers/media/i2c/imx219.c                                          |  255 +++----
 drivers/media/i2c/max9286.c                                         |    1 
 drivers/media/i2c/ov2740.c                                          |    4 
 drivers/media/i2c/ov5675.c                                          |    4 
 drivers/media/i2c/ov7670.c                                          |    2 
 drivers/media/i2c/ov772x.c                                          |    3 
 drivers/media/pci/intel/ipu3/ipu3-cio2-main.c                       |    3 
 drivers/media/pci/saa7134/saa7134-core.c                            |    2 
 drivers/media/platform/imx-jpeg/mxc-jpeg.c                          |   35 -
 drivers/media/platform/imx-jpeg/mxc-jpeg.h                          |    4 
 drivers/media/platform/omap3isp/isp.c                               |    9 
 drivers/media/platform/ti-vpe/cal.c                                 |    4 
 drivers/media/rc/ene_ir.c                                           |    3 
 drivers/media/usb/siano/smsusb.c                                    |    1 
 drivers/media/usb/uvc/uvc_ctrl.c                                    |  250 +++++--
 drivers/media/usb/uvc/uvc_driver.c                                  |    8 
 drivers/media/usb/uvc/uvc_v4l2.c                                    |   92 --
 drivers/media/usb/uvc/uvcvideo.h                                    |    6 
 drivers/media/v4l2-core/v4l2-jpeg.c                                 |    4 
 drivers/mfd/Kconfig                                                 |    1 
 drivers/mfd/pcf50633-adc.c                                          |    7 
 drivers/misc/eeprom/idt_89hpesx.c                                   |   10 
 drivers/misc/mei/hdcp/mei_hdcp.c                                    |    4 
 drivers/misc/vmw_vmci/vmci_host.c                                   |    2 
 drivers/mtd/spi-nor/core.c                                          |    9 
 drivers/mtd/spi-nor/core.h                                          |    1 
 drivers/mtd/spi-nor/sfdp.c                                          |    6 
 drivers/mtd/spi-nor/spansion.c                                      |    9 
 drivers/net/can/usb/esd_usb2.c                                      |    4 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                      |    8 
 drivers/net/ethernet/broadcom/genet/bcmmii.c                        |   11 
 drivers/net/ethernet/intel/ice/ice_main.c                           |   17 
 drivers/net/ethernet/intel/ice/ice_ptp.c                            |    2 
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c            |    2 
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c                 |    3 
 drivers/net/ethernet/qlogic/qede/qede_main.c                        |   16 
 drivers/net/hyperv/netvsc.c                                         |   18 
 drivers/net/tap.c                                                   |    2 
 drivers/net/tun.c                                                   |    2 
 drivers/net/wireless/ath/ath11k/core.h                              |    1 
 drivers/net/wireless/ath/ath11k/debugfs.c                           |   48 +
 drivers/net/wireless/ath/ath11k/dp_rx.c                             |    1 
 drivers/net/wireless/ath/ath11k/pci.c                               |    2 
 drivers/net/wireless/ath/ath9k/hif_usb.c                            |   62 +
 drivers/net/wireless/ath/ath9k/htc.h                                |   32 
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                       |    2 
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                       |   10 
 drivers/net/wireless/ath/ath9k/htc_hst.c                            |    4 
 drivers/net/wireless/ath/ath9k/wmi.c                                |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c           |    7 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c             |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c           |    5 
 drivers/net/wireless/intel/ipw2x00/ipw2200.c                        |   11 
 drivers/net/wireless/intel/iwlegacy/3945-mac.c                      |   16 
 drivers/net/wireless/intel/iwlegacy/4965-mac.c                      |   12 
 drivers/net/wireless/intel/iwlegacy/common.c                        |    4 
 drivers/net/wireless/intersil/orinoco/hw.c                          |    2 
 drivers/net/wireless/marvell/libertas/cmdresp.c                     |    2 
 drivers/net/wireless/marvell/libertas/if_usb.c                      |    2 
 drivers/net/wireless/marvell/libertas/main.c                        |    3 
 drivers/net/wireless/marvell/libertas_tf/if_usb.c                   |    2 
 drivers/net/wireless/marvell/mwifiex/11n.c                          |    6 
 drivers/net/wireless/mediatek/mt76/dma.c                            |   13 
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c                     |    2 
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h                    |    1 
 drivers/net/wireless/mediatek/mt7601u/dma.c                         |    3 
 drivers/net/wireless/microchip/wilc1000/netdev.c                    |    1 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c              |    5 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c               |   19 
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c                 |    6 
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c                 |    6 
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c                 |    6 
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c                |   52 -
 drivers/net/wireless/rsi/rsi_91x_coex.c                             |    1 
 drivers/net/wireless/wl3501_cs.c                                    |    2 
 drivers/opp/debugfs.c                                               |    2 
 drivers/pci/iov.c                                                   |    2 
 drivers/pci/pci.c                                                   |    2 
 drivers/pci/pci.h                                                   |   43 -
 drivers/pci/quirks.c                                                |    1 
 drivers/pci/switch/switchtec.c                                      |    9 
 drivers/phy/rockchip/phy-rockchip-typec.c                           |    4 
 drivers/pinctrl/bcm/pinctrl-bcm2835.c                               |    2 
 drivers/pinctrl/mediatek/pinctrl-paris.c                            |   12 
 drivers/pinctrl/pinctrl-at91-pio4.c                                 |    4 
 drivers/pinctrl/pinctrl-at91.c                                      |    2 
 drivers/pinctrl/pinctrl-rockchip.c                                  |    1 
 drivers/pinctrl/qcom/pinctrl-msm8976.c                              |    8 
 drivers/pinctrl/stm32/pinctrl-stm32.c                               |    1 
 drivers/power/supply/power_supply_core.c                            |   97 --
 drivers/powercap/powercap_sys.c                                     |   14 
 drivers/regulator/max77802-regulator.c                              |   34 
 drivers/regulator/s5m8767.c                                         |    6 
 drivers/remoteproc/mtk_scp_ipi.c                                    |   11 
 drivers/remoteproc/qcom_q6v5_mss.c                                  |   59 +
 drivers/rpmsg/qcom_glink_native.c                                   |    1 
 drivers/rtc/rtc-pm8xxx.c                                            |   24 
 drivers/s390/block/dasd_eckd.c                                      |    4 
 drivers/scsi/aic94xx/aic94xx_task.c                                 |    3 
 drivers/scsi/lpfc/lpfc_sli.c                                        |   19 
 drivers/scsi/mpt3sas/mpt3sas_base.c                                 |    3 
 drivers/scsi/qla2xxx/qla_bsg.c                                      |    9 
 drivers/scsi/qla2xxx/qla_def.h                                      |    6 
 drivers/scsi/qla2xxx/qla_dfs.c                                      |   10 
 drivers/scsi/qla2xxx/qla_edif.c                                     |    8 
 drivers/scsi/qla2xxx/qla_init.c                                     |   14 
 drivers/scsi/qla2xxx/qla_inline.h                                   |   55 +
 drivers/scsi/qla2xxx/qla_iocb.c                                     |   95 ++
 drivers/scsi/qla2xxx/qla_isr.c                                      |    6 
 drivers/scsi/qla2xxx/qla_nvme.c                                     |   34 
 drivers/scsi/qla2xxx/qla_os.c                                       |    9 
 drivers/scsi/ses.c                                                  |   64 +
 drivers/scsi/snic/snic_debugfs.c                                    |    4 
 drivers/soundwire/cadence_master.c                                  |    3 
 drivers/spi/Kconfig                                                 |    1 
 drivers/spi/spi-bcm63xx-hsspi.c                                     |   12 
 drivers/spi/spi-synquacer.c                                         |    7 
 drivers/thermal/hisi_thermal.c                                      |    4 
 drivers/thermal/intel/intel_pch_thermal.c                           |    8 
 drivers/thermal/intel/intel_powerclamp.c                            |   20 
 drivers/thermal/intel/intel_soc_dts_iosf.c                          |    2 
 drivers/thermal/qcom/tsens-v0_1.c                                   |   28 
 drivers/thermal/qcom/tsens-v1.c                                     |   61 -
 drivers/thermal/qcom/tsens.c                                        |    6 
 drivers/thermal/qcom/tsens.h                                        |    2 
 drivers/tty/serial/fsl_lpuart.c                                     |   19 
 drivers/tty/serial/imx.c                                            |   69 +-
 drivers/tty/serial/serial-tegra.c                                   |    7 
 drivers/usb/early/xhci-dbc.c                                        |    3 
 drivers/usb/gadget/configfs.c                                       |   44 -
 drivers/usb/gadget/udc/fotg210-udc.c                                |   16 
 drivers/usb/gadget/udc/fusb300_udc.c                                |   10 
 drivers/usb/host/max3421-hcd.c                                      |    2 
 drivers/usb/musb/mediatek.c                                         |    3 
 drivers/usb/typec/mux/intel_pmc_mux.c                               |   15 
 drivers/vfio/vfio_iommu_type1.c                                     |   99 +-
 drivers/video/fbdev/core/fbcon.c                                    |   17 
 fs/btrfs/discard.c                                                  |   41 +
 fs/ceph/file.c                                                      |    8 
 fs/cifs/smb2ops.c                                                   |   13 
 fs/cifs/smbdirect.c                                                 |    4 
 fs/coda/upcall.c                                                    |    2 
 fs/dlm/midcomms.c                                                   |   45 -
 fs/exfat/dir.c                                                      |    7 
 fs/exfat/exfat_fs.h                                                 |    2 
 fs/exfat/file.c                                                     |    3 
 fs/exfat/inode.c                                                    |    6 
 fs/exfat/namei.c                                                    |    2 
 fs/exfat/super.c                                                    |    3 
 fs/ext4/xattr.c                                                     |   35 -
 fs/f2fs/data.c                                                      |    6 
 fs/f2fs/inline.c                                                    |   13 
 fs/fuse/ioctl.c                                                     |    6 
 fs/gfs2/aops.c                                                      |    3 
 fs/gfs2/super.c                                                     |    8 
 fs/hfs/bnode.c                                                      |    1 
 fs/hfsplus/super.c                                                  |    4 
 fs/jbd2/transaction.c                                               |   50 -
 fs/ksmbd/smb2misc.c                                                 |   31 
 fs/nfs/file.c                                                       |   15 
 fs/nfs/nfs4_fs.h                                                    |    1 
 fs/nfs/nfs4proc.c                                                   |   22 
 fs/nfs/nfs4state.c                                                  |   40 -
 fs/nfs/nfs4trace.h                                                  |   42 -
 fs/nfsd/nfs4layouts.c                                               |    4 
 fs/nfsd/nfs4proc.c                                                  |    2 
 fs/ocfs2/move_extents.c                                             |   34 
 fs/udf/file.c                                                       |   26 
 fs/udf/inode.c                                                      |   74 +-
 fs/udf/super.c                                                      |    1 
 fs/udf/udf_i.h                                                      |    3 
 fs/udf/udf_sb.h                                                     |    2 
 include/drm/drm_mipi_dsi.h                                          |    4 
 include/linux/acpi.h                                                |    1 
 include/linux/hid.h                                                 |    1 
 include/linux/ima.h                                                 |    6 
 include/linux/intel-iommu.h                                         |    3 
 include/linux/kernel_stat.h                                         |    2 
 include/linux/kobject.h                                             |    2 
 include/linux/kprobes.h                                             |    2 
 include/linux/nfs_xdr.h                                             |    2 
 include/linux/rcupdate.h                                            |   11 
 include/linux/transport_class.h                                     |    8 
 include/linux/uaccess.h                                             |    4 
 include/net/sock.h                                                  |    7 
 include/sound/soc-dapm.h                                            |    1 
 io_uring/io_uring.c                                                 |   41 -
 kernel/bpf/btf.c                                                    |   13 
 kernel/irq/irqdomain.c                                              |  153 ++--
 kernel/kprobes.c                                                    |    6 
 kernel/locking/rwsem.c                                              |   60 +
 kernel/pid_namespace.c                                              |   17 
 kernel/power/energy_model.c                                         |    5 
 kernel/rcu/tasks.h                                                  |   64 +
 kernel/rcu/tree_exp.h                                               |    2 
 kernel/resource.c                                                   |   14 
 kernel/sched/deadline.c                                             |    5 
 kernel/sched/rt.c                                                   |   10 
 kernel/time/clocksource.c                                           |   45 -
 kernel/time/hrtimer.c                                               |    2 
 kernel/time/posix-stubs.c                                           |    2 
 kernel/time/posix-timers.c                                          |    2 
 kernel/time/test_udelay.c                                           |    2 
 kernel/trace/blktrace.c                                             |    4 
 kernel/trace/ring_buffer.c                                          |   42 -
 lib/errname.c                                                       |   22 
 lib/kobject.c                                                       |   20 
 lib/mpi/mpicoder.c                                                  |    3 
 mm/huge_memory.c                                                    |    3 
 mm/memcontrol.c                                                     |    4 
 net/bluetooth/l2cap_core.c                                          |   24 
 net/bluetooth/l2cap_sock.c                                          |    8 
 net/core/scm.c                                                      |    2 
 net/core/sock.c                                                     |   15 
 net/ipv4/inet_hashtables.c                                          |   12 
 net/l2tp/l2tp_ppp.c                                                 |  125 +--
 net/mac80211/sta_info.c                                             |    2 
 net/netfilter/nf_tables_api.c                                       |    3 
 net/rds/message.c                                                   |    2 
 net/sunrpc/clnt.c                                                   |    4 
 net/wireless/nl80211.c                                              |    2 
 net/wireless/sme.c                                                  |   31 
 scripts/package/mkdebian                                            |    2 
 security/integrity/ima/ima_main.c                                   |    7 
 security/security.c                                                 |    7 
 sound/pci/hda/patch_ca0132.c                                        |    2 
 sound/pci/hda/patch_realtek.c                                       |    1 
 sound/pci/ice1712/aureon.c                                          |    2 
 sound/soc/atmel/mchp-spdifrx.c                                      |  342 ++++++----
 sound/soc/codecs/lpass-rx-macro.c                                   |  100 ++
 sound/soc/codecs/lpass-tx-macro.c                                   |  104 ++-
 sound/soc/codecs/lpass-va-macro.c                                   |    2 
 sound/soc/codecs/tlv320adcx140.c                                    |    2 
 sound/soc/fsl/fsl_sai.c                                             |   35 -
 sound/soc/fsl/fsl_sai.h                                             |    2 
 sound/soc/kirkwood/kirkwood-dma.c                                   |    2 
 sound/soc/sh/rcar/rsnd.h                                            |    4 
 sound/soc/soc-compress.c                                            |   11 
 tools/bootconfig/scripts/ftrace2bconf.sh                            |    2 
 tools/bpf/bpftool/prog.c                                            |   38 -
 tools/lib/bpf/btf.c                                                 |   13 
 tools/lib/bpf/nlattr.c                                              |    2 
 tools/objtool/check.c                                               |    3 
 tools/perf/Documentation/perf-intel-pt.txt                          |  229 ++++++
 tools/perf/arch/x86/tests/intel-pt-pkt-decoder-test.c               |    8 
 tools/perf/builtin-inject.c                                         |    6 
 tools/perf/perf-completion.sh                                       |   11 
 tools/perf/util/auxtrace.c                                          |    3 
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c                 |  131 +++
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.h                 |    1 
 tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c            |    1 
 tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.h            |    1 
 tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.c             |   40 +
 tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.h             |    3 
 tools/perf/util/intel-pt.c                                          |   43 +
 tools/perf/util/llvm-utils.c                                        |   25 
 tools/power/x86/intel-speed-select/isst-config.c                    |    2 
 tools/testing/ktest/ktest.pl                                        |   26 
 tools/testing/ktest/sample.conf                                     |    5 
 tools/testing/selftests/bpf/Makefile                                |    2 
 tools/testing/selftests/drivers/net/netdevsim/devlink.sh            |   18 
 tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc |    2 
 tools/testing/selftests/landlock/fs_test.c                          |   47 +
 tools/testing/selftests/landlock/ptrace_test.c                      |  113 ++-
 tools/testing/selftests/net/fib_tests.sh                            |    2 
 tools/testing/selftests/net/udpgso_bench_rx.c                       |    6 
 virt/kvm/coalesced_mmio.c                                           |    8 
 520 files changed, 5257 insertions(+), 2846 deletions(-)

Adam Ford (2):
      arm64: dts: renesas: beacon-renesom: Fix gpio expander reference
      media: i2c: imx219: Split common registers from mode tables

Adam Niederer (1):
      ACPI: resource: Add IRQ overrides for MAINGEAR Vector Pro 2 models

Adam Skladowski (1):
      pinctrl: qcom: pinctrl-msm8976: Correct function names for wcss pins

Adrian Hunter (4):
      perf intel-pt: Add documentation for Event Trace and TNT disable
      perf intel-pt: Add link to the perf wiki's Intel PT page
      perf intel-pt: Add support for emulated ptwrite
      perf intel-pt: pkt-decoder: Add CFE and EVD packets

Akhil P Oommen (1):
      drm/msm/adreno: Fix null ptr access in adreno_gpu_cleanup()

Al Viro (2):
      alpha/boot/tools/objstrip: fix the check for ELF header
      alpha: fix FEN fault handling

Alexander Aring (3):
      fs: dlm: don't set stop rx flag after node reset
      fs: dlm: move sending fin message into state change handling
      fs: dlm: send FIN ack back in right cases

Alexander Mikhalitsyn (1):
      fuse: add inode/permission checks to fileattr_get/fileattr_set

Alexander Wetzel (1):
      wifi: cfg80211: Fix use after free for wext

Alexey Kodanev (1):
      wifi: orinoco: check return value of hermes_write_wordrec()

Alexey V. Vissarionov (2):
      ALSA: hda/ca0132: minor fix for allocation size
      PCI/IOV: Enlarge virtfn sysfs name buffer

Allen Ballway (1):
      HID: multitouch: Add quirks for flipped axes

Alok Tiwari (1):
      netfilter: nf_tables: NULL pointer dereference in nf_tables_updobj()

Alper Nebi Yasak (1):
      firmware: coreboot: framebuffer: Ignore reserved pixel color bits

Anders Roxell (1):
      powerpc/mm: Rearrange if-else block to avoid clang warning

Andreas Gruenbacher (2):
      gfs2: jdata writepage fix
      gfs2: Improve gfs2_make_fs_rw error handling

Andreas Kemnade (1):
      power: supply: remove faulty cooling logic

Andrii Nakryiko (2):
      libbpf: Fix btf__align_of() by taking into account field offsets
      bpf: Fix global subprog context argument resolution logic

Andy Chiu (1):
      riscv: jump_label: Fixup unaligned arch_static_branch function

Andy Shevchenko (3):
      pinctrl: bcm2835: Remove of_node_put() in bcm2835_of_gpio_ranges_fallback()
      usb: typec: intel_pmc_mux: Don't leak the ACPI device reference count
      misc/mei/hdcp: Use correct macros to initialize uuid_le

AngeloGioacchino Del Regno (2):
      arm64: dts: mt8192: Fix CPU map for single-cluster SoC
      arm64: dts: mediatek: mt7622: Add missing pwm-cells to pwm node

Angus Chen (1):
      ARM: imx: Call ida_simple_remove() for ida_simple_get

Antonio Alvarez Feijoo (1):
      tools/bootconfig: fix single & used for logical condition

Armin Wolf (2):
      ACPI: battery: Fix missing NUL-termination with large strings
      hwmon: (ftsteutates) Fix scaling of measurements

Arnd Bergmann (6):
      ARM: s3c: fix s3c64xx_set_timer_source prototype
      spi: dw_bt1: fix MUX_MMIO dependencies
      drm/amdgpu: fix enum odm_combine_mode mismatch
      printf: fix errname.c list
      objtool: add UACCESS exceptions for __tsan_volatile_read/write
      wifi: ath9k: use proper statements in conditionals

Arun Easi (1):
      scsi: qla2xxx: Fix DMA-API call trace on NVMe LS requests

Asahi Lina (2):
      drm/shmem-helper: Fix locking for drm_gem_shmem_get_pages_sgt()
      drm/shmem-helper: Revert accidental non-GPL export

Ashok Raj (4):
      x86/microcode: Print previous version of microcode after reload
      x86/microcode: Add a parameter to microcode_check() to store CPU capabilities
      x86/microcode: Check CPU capabilities after late microcode update correctly
      x86/microcode: Adjust late loading result reporting message

Bastian Germann (1):
      builddeb: clean generated package content

Bastien Nocera (1):
      HID: logitech-hidpp: Don't restart communication if not necessary

Benjamin Coddington (2):
      nfs4trace: fix state manager flag printing
      nfsd: fix race to check ls_layouts

Bernard Metzler (1):
      RDMA/siw: Fix user page pinning accounting

Bitterblue Smith (2):
      wifi: rtl8xxxu: Fix memory leaks with RTL8723BU, RTL8192EU
      wifi: rtl8xxxu: Use a longer retry limit of 48

Bjorn Andersson (1):
      rpmsg: glink: Avoid infinite loop on intent for missing channel

Bjorn Helgaas (1):
      PCI: switchtec: Return -EFAULT for copy_to_user() errors

Björn Töpel (1):
      riscv, mm: Perform BPF exhandler fixup on page fault

Boris Burkov (1):
      btrfs: hold block group refcount during async discard

Borislav Petkov (2):
      x86/microcode: Rip out the OLD_INTERFACE
      x86/microcode: Default-disable late loading

Borislav Petkov (AMD) (3):
      x86/microcode/amd: Remove load_microcode_amd()'s bsp parameter
      x86/microcode/AMD: Add a @cpu parameter to the reloading functions
      x86/microcode/AMD: Fix mixed steppings support

Breno Leitao (1):
      x86/bugs: Reset speculation control settings on init

Carlo Caione (1):
      drm/tiny: ili9486: Do not assume 8-bit only SPI controllers

Chen Hui (1):
      ARM: OMAP2+: Fix memory leak in realtime_counter_init()

Chen Zhongjin (1):
      firmware: dmi-sysfs: Fix null-ptr-deref in dmi_sysfs_register_handle

Chen-Yu Tsai (2):
      arm64: dts: mediatek: mt8183: Fix systimer 13 MHz clock description
      remoteproc/mtk_scp: Move clk ops outside send_lock

Christian Hewitt (2):
      arm64: dts: meson: remove CPU opps below 1GHz for G12A boards
      arm64: dts: meson: bananapi-m5: switch VDDIO_C pin to OPEN_DRAIN

Christophe JAILLET (3):
      spi: synquacer: Fix timeout handling in synquacer_spi_transfer_one()
      usb: early: xhci-dbc: Fix a potential out-of-bound memory access
      iommu/vt-d: Fix an unbalanced rcu_read_lock/rcu_read_unlock()

Claudiu Beznea (5):
      ASoC: mchp-spdifrx: fix controls which rely on rsr register
      ASoC: mchp-spdifrx: fix return value in case completion times out
      ASoC: mchp-spdifrx: fix controls that works with completion mechanism
      ASoC: mchp-spdifrx: disable all interrupts in mchp_spdifrx_dai_remove()
      pinctrl: at91: use devm_kasprintf() to avoid potential leaks

Colin Ian King (1):
      media: uvcvideo: Fix memory leak of object map on error exit path

Conor Dooley (2):
      RISC-V: time: initialize hrtimer based broadcast clock event device
      RISC-V: add a spin_shadow_stack declaration

Corey Minyard (2):
      ipmi:ssif: resend_msg() cannot fail
      ipmi_ssif: Rename idle state and check

Damien Le Moal (1):
      PCI: Avoid FLR for AMD FCH AHCI adapters

Dan Carpenter (3):
      wifi: mwifiex: fix loop iterator in mwifiex_update_ampdu_txwinsize()
      usb: musb: mediatek: don't unregister something that wasn't registered
      iw_cxgb4: Fix potential NULL dereference in c4iw_fill_res_cm_id_entry()

Dan Williams (1):
      dax/kmem: Fix leak of memory-hotplug resources

Daniel Mentz (1):
      drm/mipi-dsi: Fix byte order of 16-bit DCS set/get brightness

Daniil Tatianin (1):
      ACPICA: nsrepair: handle cases without a return value correctly

Darrell Kavanagh (1):
      drm: panel-orientation-quirks: Add quirk for Lenovo IdeaPad Duet 3 10IGL5

Dave Stevenson (5):
      drm/vc4: dpi: Add option for inverting pixel clock and output enable
      drm/vc4: dpi: Fix format mapping for RGB565
      drm/vc4: hvs: Set AXI panic modes
      drm/vc4: hvs: Fix colour order for xRGB1555 on HVS5
      drm/vc4: hdmi: Correct interlaced timings again

David Lamparter (1):
      io_uring: remove MSG_NOSIGNAL from recvmsg

David Rientjes (1):
      crypto: ccp - Avoid page allocation failure warning for SEV_GET_ID2

Denis Kenzior (1):
      KEYS: asymmetric: Fix ECDSA use via keyctl uapi

Dietmar Eggemann (1):
      sched/deadline,rt: Remove unused parameter from pick_next_[rt|dl]_entity()

Dmitry Baryshkov (15):
      arm64: dts: qcom: qcs404: use symbol names for PCIe resets
      thermal/drivers/tsens: Drop msm8976-specific defines
      thermal/drivers/tsens: Add compat string for the qcom,msm8960
      thermal/drivers/tsens: Sort out msm8976 vs msm8956 data
      thermal/drivers/tsens: fix slope values for msm8939
      thermal/drivers/tsens: limit num_sensors to 9 for msm8939
      drm/msm: clean event_thread->worker in case of an error
      drm/bridge: lt9611: fix sleep mode setup
      drm/bridge: lt9611: fix HPD reenablement
      drm/bridge: lt9611: fix polarity programming
      drm/bridge: lt9611: fix programming of video modes
      drm/bridge: lt9611: fix clock calculation
      drm/bridge: lt9611: pass a pointer to the of node
      drm/msm: use strscpy instead of strncpy
      drm/msm/dpu: set pdpu->is_rt_pipe early in dpu_plane_sspp_atomic_update()

Dmitry Fomin (1):
      ALSA: ice1712: Do not left ice->gpio_mutex locked in aureon_add_controls()

Dmitry Goncharov (1):
      kbuild: Port silent mode detection to future gnu make.

Dmitry Torokhov (1):
      HID: retain initial quirks set up when creating HID devices

Dominik Kobinski (1):
      arm64: dts: msm8992-bullhead: add memory hole region

Dongliang Mu (1):
      fs: hfsplus: fix UAF issue in hfsplus_put_super

Doug Berger (1):
      net: bcmgenet: fix MoCA LED control

Duoming Zhou (3):
      Revert "char: pcmcia: cm4000_cs: Replace mdelay with usleep_range in set_protocol"
      media: rc: Fix use-after-free bugs caused by ene_tx_irqsim()
      media: usb: siano: Fix use after free bugs caused by do_submit_urb

Elvira Khabirova (1):
      mips: fix syscall_get_nr

Eric Biggers (3):
      crypto: x86/ghash - fix unaligned access in ghash_setkey()
      f2fs: fix information leak in f2fs_move_inline_dirents()
      f2fs: fix cgroup writeback accounting with fs-layer encryption

Eric Dumazet (1):
      scm: add user copy checks to put_cmsg()

Fabian Vogt (1):
      fotg210-udc: Add missing completion handler

Fedor Pchelkin (2):
      wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is no callback function
      wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails

Felix Fietkau (1):
      mt76: mt7915: fix polling firmware-own status

Feng Tang (1):
      clocksource: Suspend the watchdog temporarily when high read latency detected

Fenghua Yu (1):
      dmaengine: idxd: Set traffic class values in GRPCFG on DSA 2.0

Ferry Toth (1):
      iio: light: tsl2563: Do not hardcode interrupt trigger type

Florian Fainelli (3):
      irqchip/irq-brcmstb-l2: Set IRQ_LEVEL for level triggered interrupts
      irqchip/irq-bcm7120-l2: Set IRQ_LEVEL for level triggered interrupts
      net: bcmgenet: Add a check for oversized packets

Frank Jungclaus (1):
      can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error

Frederic Weisbecker (3):
      rcu-tasks: Improve comments explaining tasks_rcu_exit_srcu purpose
      rcu-tasks: Remove preemption disablement around srcu_read_[un]lock() calls
      rcu-tasks: Fix synchronize_rcu_tasks() VS zap_pid_ns_processes()

Frieder Schrempf (1):
      drm/bridge: ti-sn65dsi83: Fix delay after reset deassert to match spec

Gaosheng Cui (2):
      usb: gadget: fusb300_udc: free irq on the error path in fusb300_probe()
      media: ti: cal: fix possible memory leak in cal_ctx_create()

Geert Uytterhoeven (3):
      drm/fourcc: Add missing big-endian XRGB1555 and RGB565 formats
      drm: mxsfb: DRM_MXSFB should depend on ARCH_MXS || ARCH_MXC
      dmaengine: HISI_DMA should depend on ARCH_HISI

George Kennedy (1):
      VMCI: check context->notify_page after call to get_user_pages_fast() to avoid GPF

Gerald Schaefer (1):
      s390/extmem: return correct segment type in __segment_load()

Giovanni Cabiddu (1):
      crypto: qat - fix out-of-bounds read

Greg Kroah-Hartman (7):
      kobject: modify kobject_get_path() to take a const *
      trace/blktrace: fix memory leak with using debugfs_lookup()
      time/debug: Fix memory leak with using debugfs_lookup()
      PM: domains: fix memory leak with using debugfs_lookup()
      PM: EM: fix memory leak with using debugfs_lookup()
      scsi: snic: Fix memory leak with using debugfs_lookup()
      Linux 5.15.99

Guo Ren (2):
      riscv: ftrace: Remove wasted nops for !RISCV_ISA_C
      riscv: ftrace: Reduce the detour code size to half

Guodong Liu (2):
      pinctrl: mediatek: Initialize variable pullen and pullup to zero
      pinctrl: mediatek: Initialize variable *buf to zero

H. Nikolaus Schaller (1):
      MIPS: DTS: CI20: fix otg power gpio

Haibo Chen (1):
      gpio: vf610: connect GPIO label to dev name

Halil Pasic (2):
      s390/ap: fix status returned by ap_aqic()
      s390/ap: fix status returned by ap_qact()

Hanna Hawa (1):
      i2c: designware: fix i2c_dw_clk_rate() return size to be u32

Hans Verkuil (2):
      media: uvcvideo: Check for INACTIVE in uvc_ctrl_is_accessible()
      media: i2c: ov7670: 0 instead of -EINVAL was returned

Hans de Goede (2):
      leds: led-class: Add missing put_device() to led_put()
      ACPI: video: Fix Lenovo Ideapad Z570 DMI match

Heikki Krogerus (2):
      ACPI: resource: Add helper function acpi_dev_get_memory_resources()
      usb: typec: intel_pmc_mux: Use the helper acpi_dev_get_memory_resources()

Heiko Carstens (1):
      s390/idle: mark arch_cpu_idle() noinstr

Heming Zhao via Ocfs2-devel (2):
      ocfs2: fix defrag path triggering jbd2 ASSERT
      ocfs2: fix non-auto defrag path not working issue

Herbert Xu (6):
      lib/mpi: Fix buffer overrun when SG is too long
      crypto: essiv - Handle EBUSY correctly
      crypto: seqiv - Handle EBUSY correctly
      crypto: xts - Handle EBUSY correctly
      crypto: rsa-pkcs1pad - Use akcipher_request_complete
      crypto: crypto4xx - Call dma_unmap_page when done

Ian Chen (1):
      drm/amd/display: Revert Reduce delay when sink device not able to ACK 00340h write

Ian Rogers (1):
      perf llvm: Fix inadvertent file creation

Ilya Dryomov (1):
      rbd: avoid use-after-free in do_rbd_add() when rbd_dev_create() fails

Ilya Leoshkevich (3):
      libbpf: Fix alen calculation in libbpf_nla_dump_errormsg()
      selftests/bpf: Fix out-of-srctree build
      s390: discard .interp section

Jack Morgenstein (1):
      net/mlx5: Enhance debug print in page allocation failure

Jacob Pan (1):
      iommu/vt-d: Avoid superfluous IOTLB tracking in lazy mode

Jagan Teki (1):
      drm: exynos: dsi: Fix MIPI_DSI*_NO_* mode flags

Jai Luthra (1):
      media: i2c: imx219: Fix binning for RAW8 capture

Jakob Koschel (2):
      usb: gadget: configfs: remove using list iterator after loop body as a ptr
      docs/scripts/gdb: add necessary make scripts_gdb step

Jakub Sitnicki (1):
      selftests/net: Interpret UDP_GRO cmsg data as an int value

James Bottomley (1):
      scsi: ses: Don't attach if enclosure has no components

James Clark (1):
      coresight: cti: Prevent negative values of enable count

Jamie Douglass (1):
      arm64: dts: qcom: msm8992-lg-bullhead: Correct memory overlaps with the SMEM and MPSS memory regions

Jan Kara (7):
      udf: Define EFSCORRUPTED error code
      udf: Truncate added extents on failed expansion
      udf: Do not bother merging very long extents
      udf: Do not update file length for failed writes to inline files
      udf: Preserve link count of system files
      udf: Detect system inodes linked into directory hierarchy
      udf: Fix file corruption when appending just after end of preallocated extent

Jani Nikula (1):
      drm/edid: fix AVI infoframe aspect ratio handling

Jann Horn (1):
      timers: Prevent union confusion from unexpected restart_syscall()

Jason Gunthorpe (1):
      iommu: Fix error unwind in iommu_group_alloc()

Jeff Layton (1):
      nfsd: zero out pointers after putting nfsd_files on COPY setup error

Jeff Xu (2):
      selftests/landlock: Skip overlayfs tests when not supported
      selftests/landlock: Test ptrace as much as possible with Yama

Jens Axboe (6):
      block: don't allow multiple bios for IOCB_NOWAIT issue
      brd: return 0/-error from brd_insert_page()
      io_uring: handle TIF_NOTIFY_RESUME when checking for task_work
      io_uring: mark task TASK_RUNNING before handling resume/task work
      io_uring: add a conditional reschedule to the IOPOLL cancelation loop
      io_uring/poll: allow some retries for poll triggering spuriously

Jerome Brunet (1):
      ASoC: dt-bindings: meson: fix gx-card codec node regex

Jesse Brandeburg (1):
      ice: add missing checks for PF vsi type

Jiasheng Jiang (10):
      wifi: iwl3945: Add missing check for create_singlethread_workqueue
      wifi: iwl4965: Add missing check for create_singlethread_workqueue()
      drm/msm/hdmi: Add missing check for alloc_ordered_workqueue
      drm/msm/gem: Add check for kmalloc
      drm/msm/dpu: Add check for cstate
      drm/msm/dpu: Add check for pstates
      drm/msm/mdp5: Add check for kzalloc
      scsi: aic94xx: Add missing check for dma_map_single()
      media: platform: ti: Add missing check for devm_regulator_get
      drm/msm/dsi: Add missing check for alloc_ordered_workqueue

Jingyuan Liang (1):
      HID: Add Mapping for System Microphone Mute

Jiri Pirko (1):
      sefltests: netdevsim: wait for devlink instance after netns removal

Jisoo Jang (3):
      wifi: brcmfmac: Fix potential stack-out-of-bounds in brcmf_c_preinit_dcmds()
      wifi: brcmfmac: ensure CLM version is null-terminated to prevent stack-out-of-bounds
      wifi: mt7601u: fix an integer underflow

Johan Hovold (6):
      arm64: dts: qcom: ipq8074: fix PCIe PHY serdes size
      rtc: pm8xxx: fix set-alarm race
      irqdomain: Fix association race
      irqdomain: Fix disassociation race
      irqdomain: Look for existing mapping only once
      irqdomain: Drop bogus fwspec-mapping error handling

Johannes Weiner (1):
      mm: memcontrol: deprecate charge moving

John Harrison (1):
      drm/i915: Don't use BAR mappings for ring buffers with LLC

John Ogness (1):
      docs: gdbmacros: print newest record

Jonathan Cormier (1):
      hwmon: (ltc2945) Handle error case in ltc2945_value_store

Jun ASAKA (1):
      wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu

Jun Nie (2):
      ext4: optimize ea_inode block expansion
      ext4: refuse to create ea block when umounted

Junhao He (1):
      coresight: etm4x: Fix accesses to TRCSEQRSTEVR and TRCSEQSTR

Justin Tee (1):
      scsi: lpfc: Fix use-after-free KFENCE violation during sysfs firmware write

KP Singh (2):
      x86/speculation: Allow enabling STIBP with legacy IBRS
      Documentation/hw-vuln: Document the interaction between IBRS and STIBP

Kalle Valo (1):
      wifi: ath11k: debugfs: fix to work with multiple PCI devices

Kees Cook (7):
      dmaengine: dw-axi-dmac: Do not dereference NULL structure
      crypto: hisilicon: Wipe entire pool on error
      coda: Avoid partial allocation of sig_inputArgs
      uaccess: Add minimum bounds check on kernel buffer size
      ASoC: kirkwood: Iterate over array indexes instead of using pointer math
      regulator: max77802: Bounds check regulator id against opmode
      regulator: s5m8767: Bounds check id indexing into arrays

Kemeng Shi (3):
      blk-mq: avoid sleep in blk_mq_alloc_request_hctx
      blk-mq: remove stale comment for blk_mq_sched_mark_restart_hctx
      blk-mq: correct stale comment of .get_budget

Koba Ko (1):
      crypto: ccp - Failure on re-initialization due to duplicate sysfs filename

Konrad Dybcio (4):
      arm64: dts: qcom: msm8996-tone: Fix USB taking 6 minutes to wake up
      arm64: dts: qcom: pmk8350: Specify PBS register for PON
      arm64: dts: qcom: pmk8350: Use the correct PON compatible
      drm/msm/dsi: Allow 2 CTRLs on v2.5.0

Konstantin Meskhidze (1):
      drm: amd: display: Fix memory leakage

Krzysztof Kozlowski (11):
      arm64: dts: qcom: sdm845-db845c: fix audio codec interrupt pin name
      arm64: dts: qcom: sc7180: correct SPMI bus address cells
      arm64: dts: qcom: sc7280: correct SPMI bus address cells
      ARM: dts: exynos: correct wr-active property in Exynos3250 Rinato
      ARM: dts: exynos: correct HDMI phy compatible in Exynos4
      ARM: dts: exynos: correct TMU phandle in Exynos4210
      ARM: dts: exynos: correct TMU phandle in Exynos4
      ARM: dts: exynos: correct TMU phandle in Odroid XU3 family
      ARM: dts: exynos: correct TMU phandle in Exynos5250
      ARM: dts: exynos: correct TMU phandle in Odroid XU
      ARM: dts: exynos: correct TMU phandle in Odroid HC1

Kuninori Morimoto (2):
      ASoC: soc-compress.c: fixup private_data on snd_soc_new_compress()
      ASoC: rsnd: fixup #endif position

Len Brown (1):
      wifi: ath11k: allow system suspend to survive ath11k

Li Nan (1):
      blk-iocost: fix divide by 0 error in calc_lcoefs()

Li Zetao (1):
      wifi: rtlwifi: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()

Liang He (1):
      gpu: ipu-v3: common: Add of_node_put() for reference returned by of_graph_get_port_by_id()

Linyu Yuan (2):
      usb: gadget: configfs: use to_config_usb_cfg() in os_desc_link()
      usb: gadget: configfs: use to_usb_function_instance() in cfg (un)link func

Liu Shixin (1):
      hfs: fix missing hfs_bnode_get() in __hfs_bnode_create

Liwei Song (1):
      drm/radeon: free iio for atombios when driver shutdown

Lorenzo Bianconi (1):
      wifi: mt76: dma: free rx_head in mt76_dma_rx_cleanup

Louis Rannou (1):
      mtd: spi-nor: Fix shift-out-of-bounds in spi_nor_set_erase_type

Lu Baolu (5):
      iommu/vt-d: Set No Execute Enable bit in PASID table entry
      iommu/vt-d: Fix error handling in sva enable/disable paths
      iommu/vt-d: Remove duplicate identity domain flag
      iommu/vt-d: Check FL and SL capability sanity in scalable mode
      iommu/vt-d: Use second level for GPA->HPA translation

Lucas Tanure (1):
      ASoC: soc-dapm.h: fixup warning struct snd_pcm_substream not declared

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix potential user-after-free

Lukas Wunner (2):
      PCI/PM: Observe reset delay irrespective of bridge_d3
      PCI: hotplug: Allow marking devices as disconnected during bind/unbind

Manish Chopra (1):
      qede: fix interrupt coalescing configuration

Manivannan Sadhasivam (1):
      ARM: dts: qcom: sdx55: Add Qcom SMMU-500 as the fallback for IOMMU node

Mao Jinlong (1):
      coresight: cti: Add PM runtime call in enable_store

Marc Zyngier (1):
      irqdomain: Fix domain registration race

Marek Vasut (2):
      arm64: dts: imx8m: Align SoC unique ID node unit address
      tty: serial: imx: Handle RS485 DE signal active high

Marijn Suijten (3):
      arm64: dts: qcom: sm8150-kumano: Panel framebuffer is 2.5k instead of 4k
      arm64: dts: qcom: sm6125: Reorder HSUSB PHY clocks to match bindings
      drm/msm/dpu: Disallow unallocated resources to be returned

Mario Limonciello (1):
      ACPICA: Drop port I/O validation for some regions

Mark Brown (1):
      ASoC: fsl_sai: Update to modern clocking terminology

Mark Hawrylak (1):
      drm/radeon: Fix eDP for single-display iMac11,2

Mark Rutland (1):
      ACPI: Don't build ACPICA with '-Os'

Mark Tomlinson (1):
      usb: max-3421: Fix setting of I/O pins

Markuss Broks (1):
      ARM: dts: exynos: Use Exynos5420 compatible for the MIPI video phy

Martin Blumenstingl (3):
      arm64: dts: meson-gx: Fix Ethernet MAC address unit name
      arm64: dts: meson-g12a: Fix internal Ethernet PHY unit name
      arm64: dts: meson-gx: Fix the SCPI DVFS node name and unit address

Martin K. Petersen (1):
      block: bio-integrity: Copy flags when bio_integrity_payload is cloned

Masahiro Yamada (1):
      s390/vdso: remove -nostdlib compiler flag

Masami Hiramatsu (Google) (1):
      selftests/ftrace: Fix bash specific "==" operator

Mavroudis Chatzilaridis (1):
      drm/i915/quirks: Add inverted backlight quirk for HP 14-r206nv

Miaoqian Lin (8):
      wifi: ath11k: Fix memory leak in ath11k_peer_rx_frag_setup
      irqchip: Fix refcount leak in platform_irqchip_probe
      irqchip/alpine-msi: Fix refcount leak in alpine_msix_init_domains
      irqchip/irq-mvebu-gicp: Fix refcount leak in mvebu_gicp_probe
      irqchip/ti-sci: Fix refcount leak in ti_sci_intr_irq_domain_probe
      pinctrl: stm32: Fix refcount leak in stm32_pctrl_get_irq_domain
      pinctrl: rockchip: Fix refcount leak in rockchip_pinctrl_parse_groups
      leds: led-core: Fix refcount leak in of_led_get()

Michael Kelley (1):
      hv_netvsc: Check status in SEND_RNDIS_PKT completion message

Michael Schmitz (1):
      m68k: Check syscall_trace_enter() return code

Michal Schmidt (1):
      qede: avoid uninitialized entries in coal_entry array

Mike Snitzer (3):
      dm: remove flush_scheduled_work() during local_exit()
      dm thin: add cond_resched() to various workqueue loops
      dm cache: add cond_resched() to various workqueue loops

Mikko Perttunen (2):
      gpu: host1x: Don't skip assigning syncpoints to channels
      drm/tegra: firewall: Check for is_addr_reg existence in IMM check

Mikulas Patocka (4):
      dm: send just one event on resize, not two
      dm flakey: fix logic when corrupting a bio
      dm flakey: don't corrupt the zero page
      dm flakey: fix a bug with 32-bit highmem systems

Miles Chen (1):
      drm/mediatek: Use NULL instead of 0 for NULL pointer

Ming Qian (3):
      media: v4l2-jpeg: correct the skip count in jpeg_parse_app14_data
      media: v4l2-jpeg: ignore the unknown APP14 marker
      media: imx-jpeg: Apply clk_bulk api instead of operating specific clk

Minsuk Kang (2):
      wifi: ath9k: Fix potential stack-out-of-bounds write in ath9k_wmi_rsp_callback()
      wifi: ath9k: Fix use-after-free in ath9k_hif_usb_disconnect()

Moises Cardona (1):
      Bluetooth: btusb: Add VID:PID 13d3:3529 for Realtek RTL8821CE

Muchun Song (1):
      locking/rwsem: Optimize down_read_trylock() under highly contended case

Mukesh Ojha (1):
      ring-buffer: Handle race between rb_move_tail and rb_check_pages

Mustafa Ismail (1):
      RDMA/irdma: Cap MSIX used to online CPUs + 1

Namhyung Kim (2):
      perf inject: Use perf_data__read() for auxtrace
      perf intel-pt: Do not try to queue auxtrace data on pipe

Namjae Jeon (2):
      ksmbd: fix wrong data area length for smb2 lock request
      ksmbd: do not allow the actual frame length to be smaller than the rfc1002 length

Nathan Chancellor (3):
      ASoC: mchp-spdifrx: Fix uninitialized use of mr in mchp_spdifrx_hw_params()
      powerpc: Remove linker flag from KBUILD_AFLAGS
      s390/vdso: Drop '-shared' from KBUILD_CFLAGS_64

Neil Armstrong (11):
      arm64: dts: amlogic: meson-gx: fix SCPI clock dvfs node name
      arm64: dts: amlogic: meson-axg: fix SCPI clock dvfs node name
      arm64: dts: amlogic: meson-gx: add missing SCPI sensors compatible
      arm64: dts: amlogic: meson-gxl-s905d-sml5442tw: drop invalid clock-names property
      arm64: dts: amlogic: meson-gx: add missing unit address to rng node name
      arm64: dts: amlogic: meson-gxl: add missing unit address to eth-phy-mux node name
      arm64: dts: amlogic: meson-gx-libretech-pc: fix update button name
      arm64: dts: amlogic: meson-sm1-bananapi-m5: fix adc keys node names
      arm64: dts: amlogic: meson-gxl-s905d-phicomm-n1: fix led node name
      arm64: dts: amlogic: meson-gxbb-kii-pro: fix led node name
      arm64: dts: amlogic: meson-sm1-odroid-hc4: fix active fan thermal trip

NeilBrown (2):
      NFSv4: keep state manager thread active if swap is enabled
      NFS: fix disabling of swap

Neill Kapron (1):
      phy: rockchip-typec: fix tcphy_get_mode error case

Nico Boehr (1):
      KVM: s390: disable migration mode when dirty tracking is disabled

Nikita Zhandarovich (2):
      RDMA/cxgb4: add null-ptr-check after ip_dev_find()
      RDMA/cxgb4: Fix potential null-ptr-deref in pass_establish()

Nícolas F. R. A. Prado (1):
      drm/mediatek: Clean dangling pointer on bind error path

Patrick Kelsey (2):
      IB/hfi1: Fix math bugs in hfi1_can_pin_pages()
      IB/hfi1: Fix sdma.h tx->num_descs off-by-one errors

Paul E. McKenney (2):
      rcu: Make RCU_LOCKDEP_WARN() avoid early lockdep checks
      rcu: Suppress smp_processor_id() complaint in synchronize_rcu_expedited_wait()

Pavel Begunkov (1):
      io_uring/rsrc: disallow multi-source reg buffers

Pavel Skripkin (1):
      ath9k: htc: clean up statistics macros

Peng Fan (2):
      ARM: dts: imx7s: correct iomuxc gpr mux controller cells
      tty: serial: imx: disable Ageing Timer interrupt request irq

Peter Gonda (2):
      crypto: ccp - Refactor out sev_fw_alloc()
      KVM: SVM: Fix potential overflow in SEV's send|receive_update_data()

Peter Zijlstra (1):
      x86: Mark stop_this_cpu() __noreturn

Petr Vorel (2):
      arm64: dts: qcom: msm8992-bullhead: Fix cont_splash_mem size
      arm64: dts: qcom: msm8992-bullhead: Disable dfps_data_mem

Pietro Borrello (12):
      HID: asus: use spinlock to protect concurrent accesses
      HID: asus: use spinlock to safely schedule workers
      sched/rt: pick_next_rt_entity(): check list_entry
      net: add sock_init_data_uid()
      tun: tun_chr_open(): correctly initialize socket uid
      tap: tap_open(): correctly initialize socket uid
      rds: rds_rm_zerocopy_callback() correct order for list_add_tail()
      HID: bigben: use spinlock to protect concurrent accesses
      HID: bigben_worker() remove unneeded check on report_field
      HID: bigben: use spinlock to safely schedule workers
      hid: bigben_probe(): validate report count
      inet: fix fast path in __inet_hash_connect()

Pingfan Liu (1):
      dm: add cond_resched() to dm_wq_work()

Qi Zheng (1):
      OPP: fix error checking in opp_migrate_dentry()

Qiheng Lin (3):
      ARM: zynq: Fix refcount leak in zynq_early_slcr_init
      s390/dasd: Fix potential memleak in dasd_eckd_init()
      mfd: pcf50633-adc: Fix potential memleak in pcf50633_adc_async_read()

Quinn Tran (6):
      scsi: qla2xxx: edif: Fix I/O timeout due to over-subscription
      scsi: qla2xxx: Fix exchange oversubscription
      scsi: qla2xxx: Fix exchange oversubscription for management commands
      scsi: qla2xxx: Fix link failure in NPIV environment
      scsi: qla2xxx: Remove unintended flag clearing
      scsi: qla2xxx: Fix erroneous link down

Randolph Sapp (1):
      drm: tidss: Fix pixel format definition

Randy Dunlap (4):
      m68k: /proc/hardware should depend on PROC_FS
      sparc: allow PM configs for sparc32 COMPILE_TEST
      mfd: cs5535: Don't build on UML
      KVM: SVM: hyper-v: placate modpost section mismatch error

Ricardo Ribalda (6):
      media: uvcvideo: Do not check for V4L2_CTRL_WHICH_DEF_VAL
      media: uvcvideo: Remove s_ctrl and g_ctrl
      media: uvcvideo: refactor __uvc_ctrl_add_mapping
      media: uvcvideo: Add support for V4L2_CTRL_TYPE_CTRL_CLASS
      media: uvcvideo: Use control names from framework
      media: uvcvideo: Check controls flags before accessing them

Richard Fitzgerald (1):
      soundwire: cadence: Don't overflow the command FIFOs

Rob Clark (1):
      drm/mediatek: Drop unbalanced obj unref

Robert Marko (6):
      arm64: dts: qcom: ipq8074: correct USB3 QMP PHY-s clock output names
      arm64: dts: qcom: ipq8074: fix Gen3 PCIe QMP PHY
      arm64: dts: qcom: ipq8074: correct Gen2 PCIe ranges
      arm64: dts: qcom: ipq8074: fix Gen3 PCIe node
      arm64: dts: qcom: ipq8074: correct PCIe QMP PHY output clock names
      arm64: dts: qcom: ipq8074: fix Gen2 PCIe QMP PHY

Roberto Sassu (1):
      ima: Align ima_file_mmap() parameters with mmap_file LSM hook

Robin Murphy (1):
      hwmon: (coretemp) Simplify platform device handling

Roman Li (1):
      drm/amd/display: Fix potential null-deref in dm_resume

Roxana Nicolescu (1):
      selftest: fib_tests: Always cleanup before exit

Sakari Ailus (1):
      media: ipu3-cio2: Fix PM runtime usage_count in driver unbind

Samuel Holland (1):
      ARM: dts: sun8i: nanopi-duo2: Fix regulator GPIO reference

Saurav Kashyap (1):
      scsi: qla2xxx: Remove increment of interface err cnt

Sean Christopherson (6):
      KVM: Destroy target device if coalesced MMIO unregistration fails
      KVM: x86: Inject #GP if WRMSR sets reserved bits in APIC Self-IPI
      x86/virt: Force GIF=1 prior to disabling SVM (for reboot flows)
      x86/crash: Disable virt in core NMI crash handler to avoid double shootdown
      x86/reboot: Disable virtualization in an emergency if SVM is supported
      x86/reboot: Disable SVM, not just VMX, when stopping CPUs

Serge Semin (2):
      dmaengine: dw-edma: Fix missing src/dst address of interleaved xfers
      dmaengine: dw-edma: Fix readq_ch() return value truncation

Sergey Matyukevich (1):
      riscv: mm: fix regression due to update_mmu_cache change

Shang XiaoJing (4):
      drm: Fix potential null-ptr-deref due to drmm_mode_config_init()
      media: max9286: Fix memleak in max9286_v4l2_register()
      media: ov2740: Fix memleak in ov2740_init_controls()
      media: ov5675: Fix memleak in ov5675_init_controls()

Shawn Guo (1):
      arm64: dts: qcom: Fix IPQ8074 PCIe PHY nodes

Shay Drory (1):
      net/mlx5: fw_tracer: Fix debug print

Shayne Chen (1):
      wifi: mac80211: make rate u32 in sta_set_rate_info_rx()

Shengjiu Wang (1):
      ASoC: fsl_sai: initialize is_dsp_mode flag

Shenwei Wang (1):
      serial: fsl_lpuart: fix RS485 RTS polariy inverse issue

Sherry Sun (3):
      tty: serial: fsl_lpuart: disable Rx/Tx DMA in lpuart32_shutdown()
      tty: serial: fsl_lpuart: clear LPUART Status Register in lpuart32_shutdown()
      tty: serial: fsl_lpuart: Fix the wrong RXWATER setting for rx dma case

Shigeru Yoshida (1):
      l2tp: Avoid possible recursive deadlock in l2tp_tunnel_register()

Shivani Baranwal (1):
      wifi: cfg80211: Fix extended KCK key length check in nl80211_set_rekey_data()

Shravan Chippa (1):
      dmaengine: sf-pdma: pdma_desc memory leak fix

Shreyas Deodhar (1):
      scsi: qla2xxx: Check if port is online before sending ELS

Sibi Sankar (1):
      remoteproc: qcom_q6v5_mss: Use a carveout to authenticate modem headers

Siddaraju DH (1):
      ice: restrict PTP HW clock freq adjustments to 100, 000, 000 PPB

Srinivas Kandagatla (5):
      ASoC: codecs: rx-macro: move clk provider to managed variants
      ASoC: codecs: tx-macro: move clk provider to managed variants
      ASoC: codecs: rx-macro: move to individual clks from bulk
      ASoC: codecs: tx-macro: move to individual clks from bulk
      ASoC: codecs: lpass: fix incorrect mclk rate

Srinivas Pandruvada (1):
      thermal: intel: powerclamp: Fix cur_state for multi package system

Srinivasa Rao Mandadapu (1):
      ASoC: codecs: Change bulk clock voting to optional voting in digital codecs

Stefan Wahren (1):
      ARM: bcm2835_defconfig: Enable the framebuffer

Steffen Aschbacher (1):
      ASoC: tlv320adcx140: fix 'ti,gpio-config' DT property init

Steve Sistare (3):
      vfio/type1: prevent underflow of locked_vm via exec()
      vfio/type1: track locked_vm per dma
      vfio/type1: restore locked_vm

Steven Rostedt (3):
      ktest.pl: Give back console on Ctrt^C on monitor
      ktest.pl: Fix missing "end_monitor" when machine check fails
      ktest.pl: Add RUN_TIMEOUT option with default unlimited

Sungjong Seo (1):
      exfat: redefine DIR_DELETED as the bad cluster number

Takahiro Kuwano (1):
      mtd: spi-nor: sfdp: Fix index value for SCCR dwords

Tasos Sahanidis (1):
      media: saa7134: Use video_unregister_device for radio_dev

Thomas Zimmermann (1):
      Revert "fbcon: don't lose the console font across generic->chip driver switch"

Tim Zimmermann (1):
      thermal: intel: intel_pch: Add support for Wellsburg PCH

Tina Zhang (1):
      iommu/vt-d: Allow to use flush-queue when first level is default

Tom Lendacky (1):
      crypto: ccp - Flush the SEV-ES TMR memory before giving it to firmware

Tomas Henzl (5):
      scsi: mpt3sas: Fix a memory leak
      scsi: ses: Fix slab-out-of-bounds in ses_enclosure_data_process()
      scsi: ses: Fix possible addl_desc_ptr out-of-bounds accesses
      scsi: ses: Fix possible desc_ptr out-of-bounds accesses
      scsi: ses: Fix slab-out-of-bounds in ses_intf_remove()

Tomi Valkeinen (1):
      drm/omap: dsi: Fix excessive stack usage

Tonghao Zhang (1):
      bpftool: profile online CPUs instead of possible

Tudor Ambarus (1):
      mtd: spi-nor: spansion: Consider reserved bits in CFR5 register

Udipto Goswami (1):
      usb: gadget: configfs: Restrict symlink creation is UDC already binded

Vadim Pasternak (1):
      hwmon: (mlxreg-fan) Return zero speed for broken fan

Vaishnav Achath (1):
      arm64: dts: ti: k3-j7200: Fix wakeup pinmux range

Vasily Gorbik (4):
      s390/mem_detect: fix detect_memory() error handling
      s390/vmem: fix empty page tables cleanup under KASAN
      s390/kprobes: fix irq mask clobbering on kprobe reenter from post_handler
      s390/kprobes: fix current_kprobe never cleared after kprobes reenter

Volker Lendecke (1):
      cifs: Fix uninitialized memory read in smb3_qfs_tcon()

Waiman Long (2):
      locking/rwsem: Disable preemption in all down_read*() and up_read() code paths
      locking/rwsem: Prevent non-first waiter from spinning in down_write() slowpath

Wan Jiabing (1):
      ath9k: hif_usb: simplify if-if to if-else

Wang Hai (1):
      kobject: Fix slab-out-of-bounds in fill_kobj_path()

Werner Sembach (1):
      ACPI: resource: Do IRQ override on all TongFang GMxRGxx

William Zhang (1):
      spi: bcm63xx-hsspi: Fix multi-bit mode setting

Xinlei Lee (1):
      drm/mediatek: dsi: Reduce the time of dsi from LP11 to sending cmd

Xiongfeng Wang (1):
      applicom: Fix PCI device refcount leak in applicom_init()

Xiubo Li (1):
      ceph: update the time stamps and try to drop the suid/sgid

Yang Jihong (2):
      x86/kprobes: Fix __recover_optprobed_insn check optimizing logic
      x86/kprobes: Fix arch_check_optimized_kprobe check within optimized_kprobe range

Yang Li (1):
      thermal: intel: Fix unsigned comparison with less than zero

Yang Yingliang (17):
      ARM: OMAP1: call platform_device_put() in error case in omap1_dm_timer_init()
      wifi: rtlwifi: rtl8821ae: don't call kfree_skb() under spin_lock_irqsave()
      wifi: rtlwifi: rtl8188ee: don't call kfree_skb() under spin_lock_irqsave()
      wifi: rtlwifi: rtl8723be: don't call kfree_skb() under spin_lock_irqsave()
      wifi: iwlegacy: common: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: rtl8xxxu: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: ipw2x00: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: libertas_tf: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: if_usb: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: main: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: cmdresp: don't call kfree_skb() under spin_lock_irqsave()
      wifi: wl3501_cs: don't call kfree_skb() under spin_lock_irqsave()
      powercap: fix possible name leak in powercap_register_zone()
      driver core: fix potential null-ptr-deref in device_add()
      firmware: stratix10-svc: add missing gen_pool_destroy() in stratix10_svc_drv_probe()
      drivers: base: transport_class: fix possible memory leak
      drivers: base: transport_class: fix resource leak when transport_add_device() fails

Yi Yang (1):
      serial: tegra: Add missing clk_disable_unprepare() in tegra_uart_hw_init()

Yicong Yang (1):
      perf tools: Fix auto-complete on aarch64

Yin Fengwei (1):
      mm/thp: check and bail out if page in deferred queue already

Yongqin Liu (1):
      thermal/drivers/hisi: Drop second sensor hi3660

Yuan Can (6):
      wifi: rsi: Fix memory leak in rsi_coex_attach()
      drm/bridge: megachips: Fix error handling in i2c_register_driver()
      drm/vkms: Fix memory leak in vkms_init()
      drm/vkms: Fix null-ptr-deref in vkms_release()
      eeprom: idt_89hpesx: Fix error handling in idt_init()
      media: i2c: ov772x: Fix memleak in ov772x_probe()

Yuezhang Mo (3):
      exfat: fix reporting fs error when reading dir beyond EOF
      exfat: fix unexpected EOF while reading dir
      exfat: fix inode->i_blocks for non-512 byte sector size device

Zhang Changzhong (2):
      wifi: wilc1000: fix potential memory leak in wilc_mac_xmit()
      wifi: brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()

Zhang Rui (1):
      tools/power/x86/intel-speed-select: Add Emerald Rapid quirk

Zhang Xiaoxu (2):
      cifs: Fix lost destroy smbd connection when MR allocate failed
      cifs: Fix warning and UAF when destroy the MR list

Zhen Lei (1):
      genirq: Fix the return type of kstat_cpu_irqs_sum()

Zhengchao Shao (4):
      wifi: libertas: fix memory leak in lbs_init_adapter()
      wifi: ipw2200: fix memory leak in ipw_wdev_init()
      wifi: brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()
      driver core: fix resource leak in device_add()

Zhengping Jiang (1):
      Bluetooth: hci_qca: get wakeup status from serdev device handle

Zhihao Cheng (1):
      jbd2: fix data missing when reusing bh which is ready to be checkpointed

Zhiyong Tao (1):
      pinctrl: mediatek: fix coding style

Zqiang (1):
      rcu-tasks: Make rude RCU-Tasks work well with CPU hotplug

ruanjinjie (1):
      drm/mediatek: mtk_drm_crtc: Add checks for devm_kcalloc

silviazhao (1):
      x86/perf/zhaoxin: Add stepping check for ZXC

Łukasz Stelmach (1):
      ALSA: hda/realtek: Add quirk for HP EliteDesk 800 G6 Tower PC

강신형 (1):
      ASoC: soc-compress: Reposition and add pcm_mutex

