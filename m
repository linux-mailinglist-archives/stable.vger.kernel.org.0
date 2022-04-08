Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6374F964E
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 15:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbiDHNGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 09:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236059AbiDHNGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 09:06:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEB42E910F;
        Fri,  8 Apr 2022 06:04:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EC5660B4D;
        Fri,  8 Apr 2022 13:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C08C385A3;
        Fri,  8 Apr 2022 13:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649423042;
        bh=htuW+04/8rP6/38Y7TVPKxO4qM6jXwL4qQAO1QrCEDE=;
        h=From:To:Cc:Subject:Date:From;
        b=gxHIvzsH3USO5ENP4mcpnclv1icMGtoWSDA0Kg6ZznDNtvEjYUi/KcGX5+WJakfqa
         YP2pcUdIBz34bm2UpicS3LpbaeaP2XZJqOIljzu/VvGrlzG++fYElZF49EgQfydVsh
         xoNUS6SvenX3qlP9WKbLf2TJyamzKUx9Lec6aops=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.110
Date:   Fri,  8 Apr 2022 15:03:55 +0200
Message-Id: <164942303515143@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.110 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/sysctl/kernel.rst                      |    1 
 Documentation/core-api/dma-attributes.rst                        |    8 
 Documentation/devicetree/bindings/mtd/nand-controller.yaml       |    4 
 Documentation/devicetree/bindings/spi/spi-mxic.txt               |    4 
 Documentation/process/stable-kernel-rules.rst                    |   11 
 Documentation/sound/hd-audio/models.rst                          |    4 
 Makefile                                                         |    2 
 arch/arc/kernel/process.c                                        |    2 
 arch/arm/boot/dts/bcm2711.dtsi                                   |   50 ++
 arch/arm/boot/dts/bcm2837.dtsi                                   |   49 ++
 arch/arm/boot/dts/dra7-l4.dtsi                                   |    5 
 arch/arm/boot/dts/dra7.dtsi                                      |    8 
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi                        |    2 
 arch/arm/boot/dts/exynos5250-smdk5250.dts                        |    3 
 arch/arm/boot/dts/exynos5420-smdk5420.dts                        |    3 
 arch/arm/boot/dts/imx53-m53menlo.dts                             |   29 +
 arch/arm/boot/dts/imx7-colibri.dtsi                              |    4 
 arch/arm/boot/dts/imx7-mba7.dtsi                                 |    2 
 arch/arm/boot/dts/imx7d-nitrogen7.dts                            |    2 
 arch/arm/boot/dts/imx7d-pico-hobbit.dts                          |    4 
 arch/arm/boot/dts/imx7d-pico-pi.dts                              |    4 
 arch/arm/boot/dts/imx7d-sdb.dts                                  |    4 
 arch/arm/boot/dts/imx7s-warp.dts                                 |    4 
 arch/arm/boot/dts/qcom-ipq4019.dtsi                              |    3 
 arch/arm/boot/dts/qcom-msm8960.dtsi                              |    8 
 arch/arm/boot/dts/sama5d2.dtsi                                   |    2 
 arch/arm/boot/dts/spear1340.dtsi                                 |    6 
 arch/arm/boot/dts/spear13xx.dtsi                                 |    6 
 arch/arm/boot/dts/sun8i-v3s.dtsi                                 |   22 -
 arch/arm/boot/dts/tegra20-tamonten.dtsi                          |    6 
 arch/arm/configs/multi_v5_defconfig                              |    1 
 arch/arm/crypto/Kconfig                                          |    2 
 arch/arm/kernel/entry-ftrace.S                                   |   51 +-
 arch/arm/kernel/swp_emulate.c                                    |    2 
 arch/arm/kernel/traps.c                                          |    2 
 arch/arm/mach-iop32x/include/mach/entry-macro.S                  |    2 
 arch/arm/mach-iop32x/include/mach/irqs.h                         |    2 
 arch/arm/mach-iop32x/irq.c                                       |    6 
 arch/arm/mach-iop32x/irqs.h                                      |   60 +-
 arch/arm/mach-mmp/sram.c                                         |   22 -
 arch/arm/mach-mstar/Kconfig                                      |    1 
 arch/arm/mach-s3c/mach-jive.c                                    |    6 
 arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts              |    8 
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi                 |    2 
 arch/arm64/boot/dts/qcom/sdm845.dtsi                             |    8 
 arch/arm64/boot/dts/qcom/sm8150.dtsi                             |    6 
 arch/arm64/boot/dts/rockchip/rk3399-firefly.dts                  |    4 
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi                         |    5 
 arch/arm64/boot/dts/ti/k3-am65.dtsi                              |    1 
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi                        |    5 
 arch/arm64/boot/dts/ti/k3-j7200.dtsi                             |    1 
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi                        |    5 
 arch/arm64/boot/dts/ti/k3-j721e.dtsi                             |    1 
 arch/arm64/configs/defconfig                                     |    2 
 arch/arm64/kernel/signal.c                                       |   10 
 arch/arm64/mm/init.c                                             |   36 +
 arch/arm64/mm/mmu.c                                              |   41 +
 arch/arm64/net/bpf_jit_comp.c                                    |   18 
 arch/csky/kernel/perf_callchain.c                                |    2 
 arch/csky/kernel/signal.c                                        |    2 
 arch/m68k/coldfire/device.c                                      |    6 
 arch/microblaze/include/asm/uaccess.h                            |   18 
 arch/mips/dec/int-handler.S                                      |    6 
 arch/mips/dec/prom/Makefile                                      |    2 
 arch/mips/dec/setup.c                                            |    3 
 arch/mips/include/asm/dec/prom.h                                 |   15 
 arch/mips/include/asm/pgalloc.h                                  |    6 
 arch/mips/rb532/devices.c                                        |    6 
 arch/nios2/include/asm/uaccess.h                                 |   26 -
 arch/nios2/kernel/signal.c                                       |   20 
 arch/parisc/include/asm/traps.h                                  |    1 
 arch/parisc/kernel/traps.c                                       |    2 
 arch/parisc/mm/fault.c                                           |   89 ++++
 arch/powerpc/Makefile                                            |    2 
 arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts                     |   30 +
 arch/powerpc/boot/dts/fsl/t1040rdb.dts                           |    8 
 arch/powerpc/include/asm/io.h                                    |   40 +
 arch/powerpc/include/asm/uaccess.h                               |    3 
 arch/powerpc/kernel/kvm.c                                        |    2 
 arch/powerpc/kvm/book3s_hv.c                                     |    5 
 arch/powerpc/kvm/powerpc.c                                       |    4 
 arch/powerpc/lib/sstep.c                                         |   12 
 arch/powerpc/mm/kasan/kasan_init_32.c                            |    3 
 arch/powerpc/mm/numa.c                                           |    4 
 arch/powerpc/perf/imc-pmu.c                                      |    6 
 arch/powerpc/platforms/8xx/pic.c                                 |    1 
 arch/powerpc/platforms/powernv/rng.c                             |    6 
 arch/powerpc/sysdev/fsl_gtm.c                                    |    4 
 arch/riscv/include/asm/module.lds.h                              |    6 
 arch/riscv/include/asm/thread_info.h                             |   10 
 arch/riscv/kernel/perf_callchain.c                               |    6 
 arch/sparc/kernel/signal_32.c                                    |    2 
 arch/um/drivers/mconsole_kern.c                                  |    3 
 arch/x86/events/intel/pt.c                                       |    2 
 arch/x86/kernel/kvm.c                                            |    2 
 arch/x86/kvm/emulate.c                                           |   14 
 arch/x86/kvm/hyperv.c                                            |    9 
 arch/x86/kvm/lapic.c                                             |    5 
 arch/x86/kvm/mmu/paging_tmpl.h                                   |   77 +--
 arch/x86/kvm/mmu/tdp_mmu.c                                       |    3 
 arch/x86/kvm/svm/avic.c                                          |   10 
 arch/x86/xen/pmu.c                                               |   10 
 arch/x86/xen/pmu.h                                               |    3 
 arch/x86/xen/smp_pv.c                                            |    2 
 arch/xtensa/include/asm/processor.h                              |    4 
 arch/xtensa/kernel/jump_label.c                                  |    2 
 block/bfq-cgroup.c                                               |    6 
 block/bfq-iosched.c                                              |   31 +
 block/blk-merge.c                                                |   11 
 block/blk-mq-sched.c                                             |    9 
 block/blk-sysfs.c                                                |    8 
 crypto/authenc.c                                                 |    2 
 crypto/rsa-pkcs1pad.c                                            |   11 
 drivers/acpi/acpica/nswalk.c                                     |    3 
 drivers/acpi/apei/bert.c                                         |   10 
 drivers/acpi/apei/erst.c                                         |    2 
 drivers/acpi/apei/hest.c                                         |    2 
 drivers/acpi/cppc_acpi.c                                         |    5 
 drivers/acpi/property.c                                          |    2 
 drivers/amba/bus.c                                               |    5 
 drivers/base/dd.c                                                |    2 
 drivers/base/power/main.c                                        |    6 
 drivers/block/drbd/drbd_req.c                                    |    3 
 drivers/block/loop.c                                             |   10 
 drivers/block/virtio_blk.c                                       |   12 
 drivers/bluetooth/btmtksdio.c                                    |    4 
 drivers/bluetooth/hci_serdev.c                                   |    3 
 drivers/bus/mips_cdmm.c                                          |    1 
 drivers/char/hw_random/Kconfig                                   |    2 
 drivers/char/hw_random/atmel-rng.c                               |    1 
 drivers/char/hw_random/cavium-rng-vf.c                           |  194 ++++++++-
 drivers/char/hw_random/cavium-rng.c                              |   11 
 drivers/char/hw_random/nomadik-rng.c                             |    7 
 drivers/char/tpm/tpm-chip.c                                      |   46 --
 drivers/char/tpm/tpm.h                                           |    2 
 drivers/char/tpm/tpm2-space.c                                    |   65 +++
 drivers/char/virtio_console.c                                    |    7 
 drivers/clk/actions/owl-s700.c                                   |    1 
 drivers/clk/actions/owl-s900.c                                   |    2 
 drivers/clk/at91/sama7g5.c                                       |    8 
 drivers/clk/clk-clps711x.c                                       |    2 
 drivers/clk/clk.c                                                |   13 
 drivers/clk/imx/clk-imx7d.c                                      |    1 
 drivers/clk/loongson1/clk-loongson1c.c                           |    1 
 drivers/clk/qcom/clk-rcg2.c                                      |   14 
 drivers/clk/qcom/gcc-ipq8074.c                                   |   21 -
 drivers/clk/qcom/gcc-msm8994.c                                   |    1 
 drivers/clk/tegra/clk-tegra124-emc.c                             |    1 
 drivers/clk/uniphier/clk-uniphier-fixed-rate.c                   |    1 
 drivers/clocksource/acpi_pm.c                                    |    6 
 drivers/clocksource/exynos_mct.c                                 |   60 +-
 drivers/clocksource/timer-microchip-pit64b.c                     |    2 
 drivers/clocksource/timer-of.c                                   |    6 
 drivers/clocksource/timer-ti-dm-systimer.c                       |    4 
 drivers/cpufreq/qcom-cpufreq-nvmem.c                             |    2 
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c              |    3 
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c                |    3 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c              |    3 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c                |    2 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c                |    3 
 drivers/crypto/amlogic/amlogic-gxl-cipher.c                      |    2 
 drivers/crypto/ccp/ccp-dmaengine.c                               |   16 
 drivers/crypto/ccree/cc_buffer_mgr.c                             |    7 
 drivers/crypto/ccree/cc_cipher.c                                 |    2 
 drivers/crypto/mxs-dcp.c                                         |    2 
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c                 |    1 
 drivers/crypto/vmx/Kconfig                                       |    4 
 drivers/dax/super.c                                              |    1 
 drivers/dma-buf/udmabuf.c                                        |    4 
 drivers/dma/hisi_dma.c                                           |    2 
 drivers/dma/pl330.c                                              |    3 
 drivers/firmware/efi/efi-pstore.c                                |    2 
 drivers/firmware/google/Kconfig                                  |    2 
 drivers/firmware/qcom_scm.c                                      |    6 
 drivers/firmware/stratix10-svc.c                                 |    2 
 drivers/fsi/fsi-master-aspeed.c                                  |   21 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                |   10 
 drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.c     |   14 
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                               |    4 
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c                        |    2 
 drivers/gpu/drm/bridge/adv7511/adv7511.h                         |    1 
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c                     |   29 +
 drivers/gpu/drm/bridge/cdns-dsi.c                                |    1 
 drivers/gpu/drm/bridge/nwl-dsi.c                                 |    1 
 drivers/gpu/drm/bridge/sil-sii8620.c                             |    2 
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                        |    5 
 drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c                    |    1 
 drivers/gpu/drm/drm_edid.c                                       |   11 
 drivers/gpu/drm/i915/display/intel_opregion.c                    |   15 
 drivers/gpu/drm/i915/gem/i915_gem_mman.c                         |    2 
 drivers/gpu/drm/meson/meson_drv.c                                |    6 
 drivers/gpu/drm/meson/meson_osd_afbcd.c                          |   41 +
 drivers/gpu/drm/meson/meson_osd_afbcd.h                          |    1 
 drivers/gpu/drm/mgag200/mgag200_mode.c                           |    5 
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c                      |    2 
 drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c                           |    8 
 drivers/gpu/drm/msm/dp/dp_display.c                              |    5 
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/hsfw.c                   |    9 
 drivers/gpu/drm/panfrost/panfrost_gpu.c                          |    5 
 drivers/gpu/drm/pl111/pl111_drv.c                                |    4 
 drivers/gpu/drm/tegra/dsi.c                                      |    4 
 drivers/gpu/host1x/dev.c                                         |    1 
 drivers/greybus/svc.c                                            |    8 
 drivers/hid/hid-logitech-dj.c                                    |    1 
 drivers/hid/i2c-hid/i2c-hid-core.c                               |   32 +
 drivers/hid/intel-ish-hid/ishtp-fw-loader.c                      |   29 -
 drivers/hv/Kconfig                                               |    1 
 drivers/hv/hv_balloon.c                                          |    2 
 drivers/hwmon/pmbus/pmbus.h                                      |    1 
 drivers/hwmon/pmbus/pmbus_core.c                                 |   18 
 drivers/hwmon/sch56xx-common.c                                   |    2 
 drivers/hwtracing/coresight/coresight-catu.c                     |    3 
 drivers/hwtracing/coresight/coresight-cpu-debug.c                |    4 
 drivers/hwtracing/coresight/coresight-cti-core.c                 |    4 
 drivers/hwtracing/coresight/coresight-etb10.c                    |    4 
 drivers/hwtracing/coresight/coresight-etm3x-core.c               |    4 
 drivers/hwtracing/coresight/coresight-etm4x-core.c               |    4 
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c              |    8 
 drivers/hwtracing/coresight/coresight-funnel.c                   |    4 
 drivers/hwtracing/coresight/coresight-replicator.c               |    4 
 drivers/hwtracing/coresight/coresight-stm.c                      |    4 
 drivers/hwtracing/coresight/coresight-tmc-core.c                 |    4 
 drivers/hwtracing/coresight/coresight-tpiu.c                     |    4 
 drivers/i2c/busses/i2c-meson.c                                   |   12 
 drivers/i2c/busses/i2c-nomadik.c                                 |    4 
 drivers/i2c/busses/i2c-xiic.c                                    |    3 
 drivers/i2c/muxes/i2c-demux-pinctrl.c                            |    5 
 drivers/iio/accel/mma8452.c                                      |   29 -
 drivers/iio/adc/twl6030-gpadc.c                                  |    2 
 drivers/iio/afe/iio-rescale.c                                    |    8 
 drivers/iio/inkern.c                                             |   40 +
 drivers/infiniband/core/cma.c                                    |    2 
 drivers/infiniband/core/verbs.c                                  |    1 
 drivers/infiniband/hw/hfi1/verbs.c                               |    3 
 drivers/infiniband/hw/mlx5/devx.c                                |    4 
 drivers/infiniband/hw/mlx5/mr.c                                  |    2 
 drivers/input/input.c                                            |    6 
 drivers/input/serio/ambakmi.c                                    |    3 
 drivers/input/touchscreen/zinitix.c                              |   44 +-
 drivers/iommu/iova.c                                             |    5 
 drivers/iommu/ipmmu-vmsa.c                                       |    4 
 drivers/irqchip/irq-nvic.c                                       |    2 
 drivers/irqchip/qcom-pdc.c                                       |    5 
 drivers/mailbox/imx-mailbox.c                                    |    9 
 drivers/mailbox/tegra-hsp.c                                      |    5 
 drivers/md/bcache/btree.c                                        |    6 
 drivers/md/bcache/writeback.c                                    |    6 
 drivers/md/dm-crypt.c                                            |    2 
 drivers/md/dm-integrity.c                                        |    6 
 drivers/media/i2c/adv7511-v4l2.c                                 |    2 
 drivers/media/i2c/adv7604.c                                      |    2 
 drivers/media/i2c/adv7842.c                                      |    2 
 drivers/media/pci/bt8xx/bttv-driver.c                            |    4 
 drivers/media/pci/cx88/cx88-mpeg.c                               |    3 
 drivers/media/pci/ivtv/ivtv-driver.h                             |    1 
 drivers/media/pci/ivtv/ivtv-ioctl.c                              |   10 
 drivers/media/pci/ivtv/ivtv-streams.c                            |   11 
 drivers/media/pci/saa7134/saa7134-alsa.c                         |    8 
 drivers/media/platform/aspeed-video.c                            |    9 
 drivers/media/platform/coda/coda-common.c                        |    1 
 drivers/media/platform/davinci/vpif.c                            |   12 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_vpu.c            |    2 
 drivers/media/rc/gpio-ir-tx.c                                    |   28 +
 drivers/media/rc/ir_toy.c                                        |    2 
 drivers/media/test-drivers/vidtv/vidtv_s302m.c                   |   17 
 drivers/media/usb/em28xx/em28xx-cards.c                          |   13 
 drivers/media/usb/go7007/s2250-board.c                           |   10 
 drivers/media/usb/hdpvr/hdpvr-video.c                            |    4 
 drivers/media/usb/stk1160/stk1160-core.c                         |    2 
 drivers/media/usb/stk1160/stk1160-v4l.c                          |   10 
 drivers/media/usb/stk1160/stk1160.h                              |    2 
 drivers/media/v4l2-core/v4l2-mem2mem.c                           |   53 +-
 drivers/memory/emif.c                                            |    8 
 drivers/memory/pl172.c                                           |    4 
 drivers/memory/pl353-smc.c                                       |    4 
 drivers/mfd/asic3.c                                              |   10 
 drivers/mfd/mc13xxx-core.c                                       |    4 
 drivers/misc/cardreader/alcor_pci.c                              |    9 
 drivers/misc/habanalabs/common/debugfs.c                         |    2 
 drivers/misc/kgdbts.c                                            |    4 
 drivers/misc/mei/hw-me-regs.h                                    |    1 
 drivers/misc/mei/interrupt.c                                     |   35 -
 drivers/misc/mei/pci-me.c                                        |    1 
 drivers/mmc/core/host.c                                          |   15 
 drivers/mmc/host/davinci_mmc.c                                   |    6 
 drivers/mmc/host/mmci.c                                          |    4 
 drivers/mtd/nand/onenand/generic.c                               |    7 
 drivers/mtd/nand/raw/atmel/nand-controller.c                     |   14 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                       |    3 
 drivers/mtd/nand/raw/nand_base.c                                 |   44 --
 drivers/mtd/ubi/build.c                                          |    9 
 drivers/mtd/ubi/fastmap.c                                        |   28 -
 drivers/mtd/ubi/vmt.c                                            |    8 
 drivers/net/bareudp.c                                            |   25 -
 drivers/net/can/m_can/m_can.c                                    |    5 
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c                   |    2 
 drivers/net/can/usb/ems_usb.c                                    |    1 
 drivers/net/can/usb/mcba_usb.c                                   |   27 -
 drivers/net/can/usb/usb_8dev.c                                   |   30 -
 drivers/net/can/vxcan.c                                          |    2 
 drivers/net/dsa/bcm_sf2_cfp.c                                    |    6 
 drivers/net/dsa/microchip/ksz8795_spi.c                          |   11 
 drivers/net/dsa/microchip/ksz9477_spi.c                          |   12 
 drivers/net/dsa/mv88e6xxx/chip.c                                 |    1 
 drivers/net/ethernet/8390/mcf8390.c                              |   10 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                   |    4 
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c             |    5 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c          |   11 
 drivers/net/ethernet/intel/i40e/i40e_xsk.c                       |   16 
 drivers/net/ethernet/pensando/ionic/ionic_main.c                 |    6 
 drivers/net/ethernet/qlogic/qed/qed_sriov.c                      |   29 +
 drivers/net/ethernet/qlogic/qed/qed_sriov.h                      |    1 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h                  |   10 
 drivers/net/ethernet/sun/sunhme.c                                |    6 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c                |   72 ++-
 drivers/net/hamradio/6pack.c                                     |    4 
 drivers/net/phy/broadcom.c                                       |   21 +
 drivers/net/wireguard/queueing.c                                 |    3 
 drivers/net/wireguard/socket.c                                   |    5 
 drivers/net/wireless/ath/ath10k/snoc.c                           |    2 
 drivers/net/wireless/ath/ath10k/wow.c                            |    7 
 drivers/net/wireless/ath/ath9k/htc_hst.c                         |    5 
 drivers/net/wireless/ath/carl9170/main.c                         |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c      |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c          |   66 ---
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c                |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                      |    4 
 drivers/net/wireless/mediatek/mt76/mt7603/main.c                 |    3 
 drivers/net/wireless/mediatek/mt76/mt7615/main.c                 |    3 
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c                  |    9 
 drivers/net/wireless/ray_cs.c                                    |    6 
 drivers/nvdimm/region_devs.c                                     |    3 
 drivers/nvme/host/core.c                                         |    9 
 drivers/nvme/host/tcp.c                                          |   40 +
 drivers/pci/access.c                                             |    9 
 drivers/pci/controller/pci-aardvark.c                            |    4 
 drivers/pci/controller/pci-xgene.c                               |   35 +
 drivers/pci/hotplug/pciehp_hpc.c                                 |    2 
 drivers/pci/quirks.c                                             |   12 
 drivers/phy/phy-core-mipi-dphy.c                                 |    4 
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c                    |    2 
 drivers/pinctrl/mediatek/pinctrl-paris.c                         |   30 -
 drivers/pinctrl/nomadik/pinctrl-nomadik.c                        |    4 
 drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c                        |  185 ++++----
 drivers/pinctrl/pinconf-generic.c                                |    6 
 drivers/pinctrl/pinctrl-rockchip.c                               |    2 
 drivers/pinctrl/renesas/core.c                                   |    5 
 drivers/pinctrl/renesas/pfc-r8a77470.c                           |    4 
 drivers/pinctrl/samsung/pinctrl-samsung.c                        |   30 +
 drivers/platform/chrome/Makefile                                 |    3 
 drivers/platform/chrome/cros_ec_sensorhub_ring.c                 |    3 
 drivers/platform/chrome/cros_ec_sensorhub_trace.h                |  123 +++++
 drivers/platform/chrome/cros_ec_trace.h                          |   95 ----
 drivers/platform/chrome/cros_ec_typec.c                          |    6 
 drivers/platform/x86/huawei-wmi.c                                |   13 
 drivers/power/reset/gemini-poweroff.c                            |    4 
 drivers/power/supply/ab8500_fg.c                                 |    4 
 drivers/power/supply/bq24190_charger.c                           |    7 
 drivers/power/supply/wm8350_power.c                              |   97 +++-
 drivers/pwm/pwm-lpc18xx-sct.c                                    |   20 
 drivers/regulator/qcom_smd-regulator.c                           |    4 
 drivers/regulator/rpi-panel-attiny-regulator.c                   |   56 ++
 drivers/remoteproc/qcom_q6v5_adsp.c                              |    1 
 drivers/remoteproc/qcom_q6v5_mss.c                               |   11 
 drivers/remoteproc/qcom_wcnss.c                                  |    1 
 drivers/remoteproc/remoteproc_debugfs.c                          |    2 
 drivers/rtc/interface.c                                          |    7 
 drivers/rtc/rtc-pl030.c                                          |    4 
 drivers/rtc/rtc-pl031.c                                          |    4 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                           |    2 
 drivers/scsi/libsas/sas_ata.c                                    |    2 
 drivers/scsi/pm8001/pm8001_hwi.c                                 |   23 -
 drivers/scsi/pm8001/pm80xx_hwi.c                                 |  209 +++++-----
 drivers/scsi/qla2xxx/qla_attr.c                                  |    7 
 drivers/scsi/qla2xxx/qla_def.h                                   |   10 
 drivers/scsi/qla2xxx/qla_gs.c                                    |    5 
 drivers/scsi/qla2xxx/qla_init.c                                  |   73 ++-
 drivers/scsi/qla2xxx/qla_iocb.c                                  |    8 
 drivers/scsi/qla2xxx/qla_isr.c                                   |    1 
 drivers/scsi/qla2xxx/qla_mbx.c                                   |   14 
 drivers/scsi/qla2xxx/qla_nvme.c                                  |   22 +
 drivers/scsi/qla2xxx/qla_os.c                                    |    8 
 drivers/scsi/qla2xxx/qla_sup.c                                   |    4 
 drivers/scsi/qla2xxx/qla_target.c                                |    4 
 drivers/soc/qcom/ocmem.c                                         |    1 
 drivers/soc/qcom/qcom_aoss.c                                     |    2 
 drivers/soc/qcom/rpmpd.c                                         |    3 
 drivers/soc/ti/wkup_m3_ipc.c                                     |    4 
 drivers/soundwire/intel.c                                        |    4 
 drivers/spi/spi-mxic.c                                           |   28 -
 drivers/spi/spi-pl022.c                                          |    5 
 drivers/spi/spi-pxa2xx-pci.c                                     |   17 
 drivers/spi/spi-tegra114.c                                       |    4 
 drivers/spi/spi-tegra20-slink.c                                  |    8 
 drivers/spi/spi-zynqmp-gqspi.c                                   |    5 
 drivers/spi/spi.c                                                |    4 
 drivers/staging/iio/adc/ad7280a.c                                |    4 
 drivers/staging/media/atomisp/pci/atomisp_acc.c                  |   28 -
 drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c        |   18 
 drivers/staging/media/atomisp/pci/hmm/hmm.c                      |    7 
 drivers/staging/media/hantro/hantro_h1_jpeg_enc.c                |    2 
 drivers/staging/media/hantro/hantro_h1_regs.h                    |    2 
 drivers/staging/media/meson/vdec/esparser.c                      |    7 
 drivers/staging/media/meson/vdec/vdec_helpers.c                  |    8 
 drivers/staging/media/meson/vdec/vdec_helpers.h                  |    4 
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c                 |    2 
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c                 |    2 
 drivers/staging/media/zoran/zoran.h                              |    2 
 drivers/staging/media/zoran/zoran_card.c                         |   86 ++--
 drivers/staging/media/zoran/zoran_device.c                       |    7 
 drivers/staging/media/zoran/zoran_driver.c                       |   18 
 drivers/staging/mt7621-dts/gbpc1.dts                             |   40 -
 drivers/staging/mt7621-dts/gbpc2.dts                             |  116 +++++
 drivers/staging/mt7621-dts/mt7621.dtsi                           |   26 -
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c          |    7 
 drivers/tty/hvc/hvc_iucv.c                                       |    4 
 drivers/tty/mxser.c                                              |   15 
 drivers/tty/serial/8250/8250_dma.c                               |   11 
 drivers/tty/serial/8250/8250_lpss.c                              |   28 +
 drivers/tty/serial/8250/8250_mid.c                               |   19 
 drivers/tty/serial/8250/8250_port.c                              |   16 
 drivers/tty/serial/amba-pl010.c                                  |    4 
 drivers/tty/serial/amba-pl011.c                                  |    3 
 drivers/tty/serial/kgdboc.c                                      |    6 
 drivers/tty/serial/serial_core.c                                 |   14 
 drivers/usb/host/xhci-hub.c                                      |    5 
 drivers/usb/host/xhci-mem.c                                      |    2 
 drivers/usb/host/xhci.c                                          |   20 
 drivers/usb/host/xhci.h                                          |   14 
 drivers/usb/serial/Kconfig                                       |    1 
 drivers/usb/serial/pl2303.c                                      |    1 
 drivers/usb/serial/pl2303.h                                      |    3 
 drivers/usb/serial/usb-serial-simple.c                           |    7 
 drivers/usb/storage/ene_ub6250.c                                 |  155 +++----
 drivers/usb/storage/realtek_cr.c                                 |    2 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                                |   18 
 drivers/vfio/platform/vfio_amba.c                                |   15 
 drivers/video/fbdev/amba-clcd.c                                  |    4 
 drivers/video/fbdev/atafb.c                                      |   12 
 drivers/video/fbdev/atmel_lcdfb.c                                |   11 
 drivers/video/fbdev/cirrusfb.c                                   |   16 
 drivers/video/fbdev/controlfb.c                                  |    6 
 drivers/video/fbdev/core/fbcvt.c                                 |   53 +-
 drivers/video/fbdev/matrox/matroxfb_base.c                       |    2 
 drivers/video/fbdev/nvidia/nv_i2c.c                              |    2 
 drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c        |    1 
 drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c         |    8 
 drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c |    2 
 drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c |    4 
 drivers/video/fbdev/sm712fb.c                                    |   46 --
 drivers/video/fbdev/smscufx.c                                    |    3 
 drivers/video/fbdev/udlfb.c                                      |    8 
 drivers/video/fbdev/w100fb.c                                     |   15 
 drivers/watchdog/rti_wdt.c                                       |    1 
 drivers/watchdog/sp805_wdt.c                                     |    4 
 fs/binfmt_elf.c                                                  |   90 ++--
 fs/binfmt_elf_fdpic.c                                            |   18 
 fs/btrfs/reflink.c                                               |    7 
 fs/cifs/smb2ops.c                                                |  130 +++---
 fs/coredump.c                                                    |   86 +++-
 fs/exec.c                                                        |   26 +
 fs/ext2/super.c                                                  |    6 
 fs/ext4/inline.c                                                 |    9 
 fs/ext4/inode.c                                                  |   25 +
 fs/ext4/mballoc.c                                                |  126 +++---
 fs/ext4/namei.c                                                  |   10 
 fs/f2fs/checkpoint.c                                             |    8 
 fs/f2fs/compress.c                                               |    5 
 fs/f2fs/data.c                                                   |    9 
 fs/f2fs/file.c                                                   |    5 
 fs/f2fs/gc.c                                                     |    4 
 fs/f2fs/inode.c                                                  |    1 
 fs/f2fs/node.c                                                   |    6 
 fs/f2fs/segment.c                                                |    7 
 fs/f2fs/super.c                                                  |    6 
 fs/f2fs/sysfs.c                                                  |    2 
 fs/file.c                                                        |   31 +
 fs/gfs2/rgrp.c                                                   |    3 
 fs/io_uring.c                                                    |    7 
 fs/jffs2/build.c                                                 |    4 
 fs/jffs2/fs.c                                                    |    2 
 fs/jffs2/scan.c                                                  |    6 
 fs/jfs/jfs_dmap.c                                                |    7 
 fs/nfs/callback_proc.c                                           |   27 -
 fs/nfs/callback_xdr.c                                            |    4 
 fs/nfs/nfs2xdr.c                                                 |    2 
 fs/nfs/nfs3xdr.c                                                 |   21 -
 fs/nfs/nfs4proc.c                                                |    1 
 fs/nfs/pnfs.c                                                    |   11 
 fs/nfs/pnfs.h                                                    |    2 
 fs/nfs/write.c                                                   |    5 
 fs/nfsd/filecache.c                                              |    6 
 fs/nfsd/nfs4state.c                                              |   12 
 fs/nfsd/nfsproc.c                                                |    2 
 fs/nfsd/xdr.h                                                    |    2 
 fs/ntfs/inode.c                                                  |    4 
 fs/proc/bootconfig.c                                             |    2 
 fs/pstore/platform.c                                             |   38 -
 fs/ubifs/dir.c                                                   |   32 -
 fs/ubifs/file.c                                                  |   14 
 fs/ubifs/io.c                                                    |   34 +
 fs/ubifs/ioctl.c                                                 |    2 
 include/linux/amba/bus.h                                         |    2 
 include/linux/binfmts.h                                          |    3 
 include/linux/blk-cgroup.h                                       |   17 
 include/linux/coredump.h                                         |    5 
 include/linux/dma-mapping.h                                      |    8 
 include/linux/mtd/rawnand.h                                      |    2 
 include/linux/netdevice.h                                        |    6 
 include/linux/pci.h                                              |    1 
 include/linux/pstore.h                                           |    6 
 include/linux/serial_core.h                                      |    2 
 include/linux/soc/ti/ti_sci_protocol.h                           |    2 
 include/linux/sunrpc/xdr.h                                       |    2 
 include/net/udp.h                                                |    1 
 include/net/udp_tunnel.h                                         |    3 
 include/sound/pcm.h                                              |    1 
 include/trace/events/ext4.h                                      |   78 ++-
 include/trace/events/rxrpc.h                                     |    8 
 include/uapi/linux/bpf.h                                         |   12 
 include/uapi/linux/rseq.h                                        |   20 
 kernel/audit.h                                                   |    4 
 kernel/auditsc.c                                                 |   87 +++-
 kernel/bpf/stackmap.c                                            |   56 +-
 kernel/debug/kdb/kdb_support.c                                   |    2 
 kernel/dma/debug.c                                               |    4 
 kernel/dma/swiotlb.c                                             |    3 
 kernel/events/core.c                                             |    3 
 kernel/livepatch/core.c                                          |    4 
 kernel/locking/lockdep.c                                         |   38 +
 kernel/locking/lockdep_internals.h                               |    6 
 kernel/locking/lockdep_proc.c                                    |   51 ++
 kernel/power/hibernate.c                                         |    2 
 kernel/power/suspend_test.c                                      |    8 
 kernel/printk/printk.c                                           |    6 
 kernel/ptrace.c                                                  |   47 +-
 kernel/rseq.c                                                    |   13 
 kernel/sched/core.c                                              |    1 
 kernel/sched/debug.c                                             |   10 
 kernel/watch_queue.c                                             |    4 
 lib/kunit/try-catch.c                                            |    2 
 lib/raid6/test/Makefile                                          |    4 
 lib/raid6/test/test.c                                            |    1 
 lib/test_kmod.c                                                  |    1 
 lib/test_lockup.c                                                |   11 
 lib/test_xarray.c                                                |   22 +
 lib/xarray.c                                                     |    4 
 mm/kmemleak.c                                                    |    9 
 mm/madvise.c                                                     |    3 
 mm/memcontrol.c                                                  |    2 
 mm/memory.c                                                      |   17 
 mm/mempolicy.c                                                   |    8 
 mm/mmap.c                                                        |    2 
 mm/page_alloc.c                                                  |    9 
 mm/usercopy.c                                                    |    5 
 net/batman-adv/bridge_loop_avoidance.c                           |    6 
 net/batman-adv/distributed-arp-table.c                           |    3 
 net/batman-adv/gateway_client.c                                  |   12 
 net/batman-adv/gateway_client.h                                  |   16 
 net/batman-adv/hard-interface.h                                  |    3 
 net/batman-adv/network-coding.c                                  |    6 
 net/batman-adv/originator.c                                      |   72 ---
 net/batman-adv/originator.h                                      |   96 ++++
 net/batman-adv/soft-interface.c                                  |   15 
 net/batman-adv/soft-interface.h                                  |   16 
 net/batman-adv/tp_meter.c                                        |    3 
 net/batman-adv/translation-table.c                               |   22 -
 net/batman-adv/translation-table.h                               |   18 
 net/batman-adv/tvlv.c                                            |    6 
 net/bluetooth/hci_conn.c                                         |    2 
 net/can/isotp.c                                                  |   69 +--
 net/core/skmsg.c                                                 |   17 
 net/ipv4/route.c                                                 |   18 
 net/ipv4/tcp_bpf.c                                               |   14 
 net/ipv4/tcp_output.c                                            |    5 
 net/ipv4/udp.c                                                   |    6 
 net/ipv6/udp.c                                                   |    4 
 net/ipv6/xfrm6_output.c                                          |   16 
 net/key/af_key.c                                                 |    2 
 net/netfilter/nf_conntrack_proto_tcp.c                           |   17 
 net/netlink/af_netlink.c                                         |    2 
 net/openvswitch/conntrack.c                                      |  118 ++---
 net/openvswitch/flow_netlink.c                                   |    4 
 net/rxrpc/ar-internal.h                                          |   15 
 net/rxrpc/call_event.c                                           |    2 
 net/rxrpc/call_object.c                                          |   40 +
 net/sunrpc/xprt.c                                                |    7 
 net/tipc/socket.c                                                |    3 
 net/x25/af_x25.c                                                 |   11 
 net/xfrm/xfrm_interface.c                                        |    5 
 samples/bpf/xdpsock_user.c                                       |    5 
 scripts/dtc/Makefile                                             |    2 
 scripts/gcc-plugins/stackleak_plugin.c                           |   25 +
 security/integrity/evm/evm_main.c                                |    2 
 security/keys/keyctl_pkey.c                                      |   14 
 security/security.c                                              |   17 
 security/selinux/hooks.c                                         |   11 
 security/selinux/include/policycap.h                             |    1 
 security/selinux/include/policycap_names.h                       |    3 
 security/selinux/include/security.h                              |    7 
 security/selinux/selinuxfs.c                                     |    2 
 security/selinux/xfrm.c                                          |    2 
 security/smack/smack_lsm.c                                       |    2 
 security/tomoyo/load_policy.c                                    |    4 
 sound/arm/aaci.c                                                 |    4 
 sound/core/pcm.c                                                 |    1 
 sound/core/pcm_lib.c                                             |    9 
 sound/core/pcm_native.c                                          |   39 +
 sound/firewire/fcp.c                                             |    4 
 sound/isa/cs423x/cs4236.c                                        |    8 
 sound/pci/hda/patch_hdmi.c                                       |    8 
 sound/pci/hda/patch_realtek.c                                    |   15 
 sound/soc/atmel/atmel_ssc_dai.c                                  |    5 
 sound/soc/atmel/sam9g20_wm8731.c                                 |    1 
 sound/soc/atmel/sam9x5_wm8731.c                                  |   16 
 sound/soc/codecs/Kconfig                                         |    5 
 sound/soc/codecs/msm8916-wcd-analog.c                            |   22 -
 sound/soc/codecs/msm8916-wcd-digital.c                           |    5 
 sound/soc/codecs/mt6358.c                                        |    4 
 sound/soc/codecs/rt5663.c                                        |    2 
 sound/soc/codecs/wcd934x.c                                       |    6 
 sound/soc/codecs/wm8350.c                                        |   28 +
 sound/soc/dwc/dwc-i2s.c                                          |   17 
 sound/soc/fsl/fsl_spdif.c                                        |    2 
 sound/soc/fsl/imx-es8328.c                                       |    1 
 sound/soc/generic/simple-card-utils.c                            |    2 
 sound/soc/mxs/mxs-saif.c                                         |    5 
 sound/soc/mxs/mxs-sgtl5000.c                                     |    3 
 sound/soc/rockchip/rockchip_i2s.c                                |   18 
 sound/soc/sh/fsi.c                                               |   19 
 sound/soc/soc-compress.c                                         |    5 
 sound/soc/soc-core.c                                             |    2 
 sound/soc/soc-generic-dmaengine-pcm.c                            |    6 
 sound/soc/soc-topology.c                                         |    3 
 sound/soc/sof/imx/imx8m.c                                        |    1 
 sound/soc/sof/intel/hda-loader.c                                 |   11 
 sound/soc/ti/davinci-i2s.c                                       |    5 
 sound/soc/xilinx/xlnx_formatter_pcm.c                            |   25 +
 sound/spi/at73c213.c                                             |   27 +
 tools/include/uapi/linux/bpf.h                                   |    4 
 tools/lib/bpf/btf_dump.c                                         |    5 
 tools/lib/bpf/libbpf.c                                           |    3 
 tools/lib/bpf/xsk.c                                              |   11 
 tools/testing/selftests/bpf/progs/test_sock_fields.c             |    2 
 tools/testing/selftests/bpf/test_lirc_mode2.sh                   |    5 
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh                 |   10 
 tools/testing/selftests/net/test_vxlan_under_vrf.sh              |    8 
 tools/testing/selftests/vm/Makefile                              |    6 
 tools/testing/selftests/x86/Makefile                             |    6 
 tools/testing/selftests/x86/check_cc.sh                          |    2 
 tools/virtio/virtio_test.c                                       |    1 
 virt/kvm/kvm_main.c                                              |   13 
 652 files changed, 5406 insertions(+), 2754 deletions(-)

Aaron Conole (1):
      openvswitch: always update flow key after nat

Aashish Sharma (1):
      dm crypt: fix get_key_size compiler warning if !CONFIG_KEYS

Abel Vesa (2):
      clk: imx7d: Remove audio_mclk_root_clk
      ARM: dts: imx7: Use audio_mclk_post_div instead audio_mclk_root_clk

Adrian Hunter (2):
      perf/core: Fix address filter parser for multiple filters
      perf/x86/intel/pt: Fix address filter config for 32-bit kernel

Aharon Landau (1):
      RDMA/mlx5: Fix the flow of a miss in the allocation of a cache ODP MR

Akira Kawata (1):
      fs/binfmt_elf: Fix AT_PHDR for unusual ELF files

Alan Stern (1):
      USB: usb-storage: Fix use of bitfields for hardware data in ene_ub6250.c

Alexander Lobakin (2):
      i40e: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
      i40e: respect metadata on XSK Rx to skb

Alexander Usyskin (2):
      mei: me: add Alder Lake N device id.
      mei: avoid iterator usage outside of list_for_each_entry

Alexey Khoroshilov (1):
      NFS: remove unneeded check in decode_devicenotify_args()

Alistair Delva (1):
      remoteproc: Fix count check in rproc_coredump_write()

Alistair Popple (1):
      mm/pages_alloc.c: don't create ZONE_MOVABLE beyond the end of a node

Amadeusz Sławiński (1):
      ASoC: topology: Allow TLV control to be either read or write

Amir Goldstein (1):
      nfsd: more robust allocation failure handling in nfsd_file_cache_init

Ammar Faizi (1):
      ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM

Anders Roxell (3):
      powerpc/lib/sstep: Fix 'sthcx' instruction
      powerpc/lib/sstep: Fix build errors with newer binutils
      powerpc: Fix build errors with newer binutils

Andre Przywara (1):
      ARM: configs: multi_v5_defconfig: re-enable CONFIG_V4L_PLATFORM_DRIVERS

Andreas Gruenbacher (1):
      powerpc/kvm: Fix kvm_use_magic_page

Andrew Price (1):
      gfs2: Make sure FITRIM minlen is rounded up to fs block size

Andy Shevchenko (3):
      spi: pxa2xx-pci: Balance reference count for PCI DMA device
      serial: 8250_mid: Balance reference count for PCI DMA device
      serial: 8250_lpss: Balance reference count for PCI DMA device

Ang Tien Sung (1):
      firmware: stratix10-svc: add missing callback parameter on RSU

Anssi Hannula (3):
      xhci: fix garbage USBSTS being logged in some cases
      xhci: fix uninitialized string returned by xhci_decode_ctrl_ctx()
      hv_balloon: rate-limit "Unhandled message" warning

Anton Ivanov (1):
      um: Fix uml_mconsole stop/go

Ard Biesheuvel (1):
      ARM: ftrace: avoid redundant loads or clobbering IP

Armin Wolf (1):
      hwmon: (sch56xx-common) Replace WDOG_ACTIVE with WDOG_HW_RUNNING

Arnd Bergmann (4):
      uaccess: fix nios2 and microblaze get_user_8()
      uaccess: fix type mismatch warnings from access_ok()
      lib/test_lockup: fix kernel pointer check for separate address spaces
      ARM: iop32x: offset IRQ numbers by 1

Arun Easi (2):
      scsi: qla2xxx: Fix device reconnect in loop topology
      scsi: qla2xxx: Fix missed DMA unmap for NVMe ls requests

Arınç ÜNAL (5):
      staging: mt7621-dts: fix LEDs and pinctrl on GB-PC1 devicetree
      staging: mt7621-dts: fix formatting
      staging: mt7621-dts: fix pinctrl properties for ethernet
      staging: mt7621-dts: fix GB-PC2 devicetree
      staging: mt7621-dts: fix pinctrl-0 items to be size-1 items on ethernet

Athira Rajeev (1):
      powerpc/perf: Don't use perf_hw_context for trace IMC PMU

Bagas Sanjaya (2):
      Documentation: add link to stable release candidate tree
      Documentation: update stable tree link

Baokun Li (5):
      jffs2: fix use-after-free in jffs2_clear_xattr_subsystem
      jffs2: fix memory leak in jffs2_do_mount_fs
      jffs2: fix memory leak in jffs2_scan_medium
      ubifs: rename_whiteout: correct old_dir size computing
      ubi: Fix race condition between ctrl_cdev_ioctl and ubi_cdev_ioctl

Bartosz Golaszewski (1):
      Revert "gpio: Revert regression in sysfs-gpio (gpiolib.c)"

Bharata B Rao (1):
      sched/debug: Remove mpol_get/put and task_lock/unlock from sched_show_numa

Biju Das (2):
      spi: Fix invalid sgs value
      spi: Fix erroneous sgs value with min_t()

Bikash Hazarika (1):
      scsi: qla2xxx: Fix wrong FDMI data for 64G adapter

Bjorn Helgaas (1):
      PCI: Avoid broken MSI on SB600 USB devices

Brandon Wyman (1):
      hwmon: (pmbus) Add Vin unit off handling

Casey Schaufler (2):
      LSM: general protection fault in legacy_parse_param
      Fix incorrect type in assignment of ipv6 port for audit

Chaitanya Kulkarni (1):
      loop: use sysfs_emit() in the sysfs xxx show()

Chao Yu (6):
      f2fs: fix to unlock page correctly in error path of is_alive()
      f2fs: fix to do sanity check on .cp_pack_total_block_count
      f2fs: fix to enable ATGC correctly via gc_idle sysfs interface
      f2fs: fix to avoid potential deadlock
      f2fs: fix to do sanity check on curseg->alloc_type
      f2fs: compress: fix to print raw data size in error path of lz4 decompression

Charan Teja Kalla (3):
      mm: madvise: skip unmapped vma holes passed to process_madvise
      mm: madvise: return correct bytes advised with process_madvise
      Revert "mm: madvise: skip unmapped vma holes passed to process_madvise"

Charles Keepax (1):
      ASoC: madera: Add dependencies on MFD

Chen Jingwen (1):
      powerpc/kasan: Fix early region not updated correctly

Chen-Yu Tsai (7):
      media: v4l2-mem2mem: Apply DST_QUEUE_OFF_BASE on MMAP buffers across ioctls
      media: hantro: Fix overfill bottom register field name
      pinctrl: mediatek: paris: Fix PIN_CONFIG_BIAS_* readback
      pinctrl: mediatek: paris: Fix "argument" argument type for mtk_pinconf_get()
      pinctrl: mediatek: paris: Fix pingroup pin config state readback
      pinctrl: mediatek: paris: Skip custom extra pin config dump for virtual GPIOs
      pinctrl: pinconf-generic: Print arguments for bias-pull-*

Chris Leech (1):
      nvme-tcp: lockdep: annotate in-kernel sockets

Christian Göttsche (2):
      selinux: check return value of sel_make_avc_files
      selinux: use correct type for context length

Christoph Hellwig (1):
      nvme: cleanup __nvme_check_ids

Christophe JAILLET (4):
      firmware: ti_sci: Fix compilation failure when CONFIG_TI_SCI_PROTOCOL is not defined
      gpu: host1x: Fix a memory leak in 'host1x_remove()'
      fsi: Aspeed: Fix a potential double free
      misc: alcor_pci: Fix an error handling path

Christophe Leroy (1):
      livepatch: Fix build failure on 32 bits processors

Chuck Lever (1):
      NFSD: Fix nfsd_breaker_owns_lease() return values

Claudiu Beznea (3):
      net: dsa: microchip: add spi_device_id tables
      hwrng: atmel - disable trng on failure path
      clocksource/drivers/timer-microchip-pit64b: Use notrace

Codrin Ciubotariu (2):
      ASoC: dmaengine: do not use a NULL prepare_slave_config() callback
      clk: at91: sama7g5: fix parents of PDMCs' GCLK

Colin Ian King (2):
      carl9170: fix missing bit-wise or operator for tx_params
      iwlwifi: Fix -EIO error code that is never returned

Cooper Chiou (1):
      drm/edid: check basic audio support on CEA extension block

Corentin Labbe (8):
      crypto: sun8i-ss - really disable hash on A80
      crypto: rockchip - ECB does not need IV
      crypto: sun8i-ss - call finalize with bh disabled
      crypto: sun8i-ce - call finalize with bh disabled
      crypto: amlogic - call finalize with bh disabled
      media: staging: media: zoran: fix usage of vb2_dma_contig_set_max_seg_size
      media: staging: media: zoran: move videodev alloc
      media: staging: media: zoran: calculate the right buffer number for zoran_reap_stat_com

Dafna Hirschfeld (1):
      media: stk1160: If start stream fails, return buffers with VB2_BUF_STATE_QUEUED

Damien Le Moal (11):
      scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands
      scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
      scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
      scsi: pm8001: Fix payload initialization in pm80xx_set_thermal_config()
      scsi: pm8001: Fix le32 values handling in pm80xx_set_sas_protocol_timer_config()
      scsi: pm8001: Fix payload initialization in pm80xx_encrypt_update()
      scsi: pm8001: Fix le32 values handling in pm80xx_chip_ssp_io_req()
      scsi: pm8001: Fix le32 values handling in pm80xx_chip_sata_req()
      scsi: pm8001: Fix NCQ NON DATA command task initialization
      scsi: pm8001: Fix NCQ NON DATA command completion handling
      scsi: pm8001: Fix abort all task initialization

Dan Carpenter (9):
      greybus: svc: fix an error handling bug in gb_svc_hello()
      NFSD: prevent underflow in nfssvc_decode_writeargs()
      NFSD: prevent integer overflow on 32 bit systems
      video: fbdev: atmel_lcdfb: fix an error code in atmel_lcdfb_probe()
      video: fbdev: fbcvt.c: fix printing in fb_cvt_print_name()
      media: usb: go7007: s2250-board: fix leak in probe()
      iwlwifi: mvm: Fix an error code in iwl_mvm_up()
      USB: storage: ums-realtek: fix error code in rts51x_read_mem()
      lib/test: use after free in register_test_dev_kmod()

Dan Williams (1):
      nvdimm/region: Fix default alignment for small regions

Daniel González Cabanelas (1):
      media: cx88-mpeg: clear interrupt status register before streaming video

Daniel Henrique Barboza (1):
      powerpc/mm/numa: skip NUMA_NO_NODE onlining in parse_numa_properties()

Daniel Palmer (1):
      ARM: mstar: Select HAVE_ARM_ARCH_TIMER

Daniel Thompson (2):
      soc: qcom: aoss: remove spurious IRQF_ONESHOT flags
      kdb: Fix the putarea helper function

Dario Binacchi (1):
      mtd: rawnand: gpmi: fix controller timings setting

Darren Hart (1):
      ACPI/APEI: Limit printable size of BERT table data

Dave Stevenson (1):
      regulator: rpi-panel: Handle I2C errors/timing to the Atmel

David Engraf (1):
      arm64: signal: nofpsimd: Do not allocate fp/simd context when not available

David Gow (1):
      firmware: google: Properly state IOMEM dependency

David Heidelberg (2):
      arm64: dts: qcom: sdm845: fix microphone bias properties and values
      ARM: dts: qcom: fix gic_irq_domain_translate warnings for msm8960

David Howells (3):
      watch_queue: Fix NULL dereference in error cleanup
      watch_queue: Actually free the watch
      rxrpc: Fix call timer start racing with call destruction

David Matlack (1):
      KVM: Prevent module exit until all VMs are freed

Dirk Buchwalder (1):
      clk: qcom: ipq8074: Use floor ops for SDCC1 clock

Dirk Müller (1):
      lib/raid6/test: fix multiple definition linking error

Dmitry Baryshkov (3):
      drm/msm/dpu: add DSPP blocks teardown
      drm/msm/dpu: fix dp audio condition
      PM: core: keep irq flags in device_pm_check_callbacks()

Dmitry Torokhov (1):
      HID: i2c-hid: fix GET/SET_REPORT for unnumbered reports

Dmitry Vyukov (1):
      riscv: Increase stack size under KASAN

Dongliang Mu (3):
      media: em28xx: initialize refcount before kref_get
      ntfs: add sanity check on allocation size
      media: hdpvr: initialize dev->worker at hdpvr_register_videodev

Drew Fustini (1):
      clocksource/drivers/timer-ti-dm: Fix regression from errata i940 fix

Duoming Zhou (2):
      drivers: hamradio: 6pack: fix UAF bug caused by mod_timer()
      net/x25: Fix null-ptr-deref caused by x25_disconnect

Dāvis Mosāns (1):
      crypto: ccp - ccp_dmaengine_unregister release dma channels

Eddie James (1):
      USB: serial: pl2303: add IBM device IDs

Eric Biggers (6):
      KEYS: fix length validation in keyctl_pkey_params_get_2()
      crypto: rsa-pkcs1pad - only allow with rsa
      crypto: rsa-pkcs1pad - correctly get hash from source scatterlist
      crypto: rsa-pkcs1pad - restore signature length check
      crypto: rsa-pkcs1pad - fix buffer overread in pkcs1pad_verify_complete()
      block: don't delete queue kobject before its children

Eric Dumazet (2):
      rseq: Optimise rseq_get_rseq_cs() and clear_rseq_cs()
      watch_queue: Free the page array when watch_queue is dismantled

Eric W. Biederman (4):
      coredump: Snapshot the vmas in do_coredump
      coredump: Remove the WARN_ON in dump_vma_snapshot
      coredump/elf: Pass coredump_params into fill_note_info
      coredump: Use the vma snapshot in fill_files_note

Evgeny Novikov (1):
      video: fbdev: w100fb: Reset global state

Fabiano Rosas (2):
      KVM: PPC: Fix vmx/vsx mixup in mmio emulation
      KVM: PPC: Book3S HV: Check return value of kvmppc_radix_init

Fangrui Song (1):
      riscv module: remove (NOLOAD)

Felix Maurer (1):
      selftests/bpf: Make test_lwt_ip_encap more stable and faster

Fengnan Chang (2):
      f2fs: compress: remove unneeded read when rewrite whole cluster
      f2fs: fix compressed file start atomic write may cause data corruption

Filipe Manana (1):
      btrfs: fix unexpected error path when reflinking an inline extent

Florian Fainelli (1):
      net: phy: broadcom: Fix brcm_fet_config_init()

Frank Wunderlich (1):
      arm64: dts: broadcom: Fix sata nodename

Geert Uytterhoeven (3):
      hwrng: cavium - HW_RANDOM_CAVIUM should depend on ARCH_THUNDER
      pinctrl: renesas: r8a77470: Reduce size for narrow VIN1 channel
      pinctrl: renesas: checker: Fix miscalculation of number of states

George Kennedy (1):
      video: fbdev: cirrusfb: check pixclock to avoid divide by zero

Gilad Ben-Yossef (1):
      crypto: ccree - don't attempt 0 len DMA mappings

Greg Kroah-Hartman (1):
      Linux 5.10.110

Guangbin Huang (1):
      net: hns3: fix software vlan talbe of vlan 0 inconsistent with hardware

Guilherme G. Piccoli (1):
      docs: sysctl/kernel: add missing bit to panic_print

Guillaume Nault (1):
      ipv4: Fix route lookups when handling ICMP redirects and PMTU updates

Guillaume Ranquet (1):
      clocksource/drivers/timer-of: Check return value of of_iomap in timer_of_base_init()

Guillaume Tucker (1):
      selftests, x86: fix how check_cc.sh is being invoked

Gwendal Grignou (2):
      HID: intel-ish-hid: Use dma_alloc_coherent for firmware update
      platform: chrome: Split trace include file

Haimin Zhang (1):
      af_key: add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register

Halil Pasic (1):
      swiotlb: fix info leak with DMA_FROM_DEVICE

Hangbin Liu (2):
      bareudp: use ipv6_mod_enabled to check if IPv6 enabled
      selftests/bpf/test_lirc_mode2.sh: Exit with proper code

Hangyu Hua (4):
      can: ems_usb: ems_usb_start_xmit(): fix double dev_kfree_skb() in error path
      powerpc: 8xx: fix a return value error in mpc8xx_pic_init
      can: mcba_usb: mcba_usb_start_xmit(): fix double dev_kfree_skb in error path
      can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in error path

Hans Verkuil (2):
      ivtv: fix incorrect device_caps for ivtvfb
      media: staging: media: zoran: fix various V4L2 compliance errors

Hans de Goede (3):
      power: supply: bq24190_charger: Fix bq24190_vbus_is_enabled() wrong false return
      iio: mma8452: Fix probe failing when an i2c_device_id is used
      media: atomisp_gmin_platform: Add DMI quirk to not turn AXP ELDO2 regulator off on some boards

Hector Martin (4):
      brcmfmac: firmware: Allocate space for default boardrev in nvram
      brcmfmac: pcie: Release firmwares in the brcmf_pcie_setup error path
      brcmfmac: pcie: Replace brcmf_pcie_copy_mem_todev with memcpy_toio
      brcmfmac: pcie: Fix crashes due to early IRQs

Helge Deller (1):
      video: fbdev: sm712fb: Fix crash in smtcfb_read()

Hengqi Chen (1):
      bpf: Fix comment for helper bpf_current_task_under_cgroup()

Henry Lin (1):
      xhci: fix runtime PM imbalance in USB2 resume

Herbert Xu (2):
      crypto: authenc - Fix sleep in atomic context in decrypt_tail
      crypto: arm/aes-neonbs-cbc - Select generic cbc and aes

Hoang Le (1):
      tipc: fix the timer expires after interval 100ms

Hou Tao (2):
      bpf, arm64: Call build_prologue() first in first JIT pass
      bpf, arm64: Feed byte-offset into bpf line info

Hou Wenlong (1):
      KVM: x86/emulator: Defer not-present segment check in __load_segment_descriptor()

Hugh Dickins (1):
      mempolicy: mbind_range() set_policy() after vma_merge()

Håkon Bugge (1):
      IB/cma: Allow XRC INI QPs to set their local ACK timeout

Ido Schimmel (1):
      selftests: test_vxlan_under_vrf: Fix broken test case

Ilpo Järvinen (1):
      serial: 8250: fix XOFF/XON sending when DMA is used

Jaegeuk Kim (1):
      f2fs: fix missing free nid in f2fs_handle_failed_inode

Jagan Teki (1):
      drm: bridge: adv7511: Fix ADV7535 HPD enablement

Jakob Koschel (2):
      media: saa7134: fix incorrect use to determine if list is empty
      powerpc/sysdev: fix incorrect use to determine if list is empty

Jakub Kicinski (1):
      tcp: ensure PMTU updates are processed during fastopen

Jakub Sitnicki (1):
      selftests/bpf: Fix error reporting from sock_fields programs

James Clark (1):
      coresight: Fix TRCCONFIGR.QE sysfs interface

Jammy Huang (1):
      media: aspeed: Correct value for h-total-pixels

Jani Nikula (1):
      drm/i915/opregion: check port number bounds for SWSCI display power state

Jann Horn (3):
      ptrace: Check PTRACE_O_SUSPEND_SECCOMP permission on PTRACE_SEIZE
      coredump: Also dump first pages of non-executable ELF libraries
      pstore: Don't use semaphores in always-atomic-context code

Jason A. Donenfeld (2):
      wireguard: queueing: use CFI-safe ptr_ring cleanup function
      wireguard: socket: ignore v6 endpoints when ipv6 is disabled

Jens Axboe (1):
      io_uring: terminate manual loop iterator loop correctly for non-vecs

Jeremy Linton (1):
      net: bcmgenet: Use stronger register read/writes to assure ordering

Jernej Skrabec (2):
      media: cedrus: H265: Fix neighbour info buffer size
      media: cedrus: h264: Fix neighbour info buffer size

Jia-Ju Bai (3):
      ASoC: rt5663: check the return value of devm_kzalloc() in rt5663_parse_dp()
      memory: emif: check the pointer temp in get_device_details()
      platform/x86: huawei-wmi: check the return value of device_create_file()

Jian Shen (1):
      net: hns3: fix bug when PF set the duplicate MAC address for VFs

Jianglei Nie (1):
      crypto: ccree - Fix use after free in cc_cipher_exit()

Jianyong Wu (1):
      arm64/mm: avoid fixmap race condition when create pud mapping

Jiasheng Jiang (26):
      thermal: int340x: Check for NULL after calling kmemdup()
      spi: spi-zynqmp-gqspi: Handle error for dma_set_mask
      media: mtk-vcodec: potential dereference of null pointer
      media: meson: vdec: potential dereference of null pointer
      soc: qcom: rpmpd: Check for null return of devm_kcalloc
      ASoC: ti: davinci-i2s: Add check for clk_enable()
      ALSA: spi: Add check for clk_enable()
      ASoC: mxs-saif: Handle errors for clk_enable
      ASoC: atmel_ssc_dai: Handle errors for clk_enable
      ASoC: dwc-i2s: Handle errors for clk_enable
      ASoC: soc-compress: prevent the potentially use of null pointer
      memory: emif: Add check for setup_interrupts
      media: vidtv: Check for null return of vzalloc
      ASoC: wm8350: Handle error for wm8350_register_irq
      ASoC: fsi: Add check for clk_enable
      mmc: davinci_mmc: Handle error for clk_enable
      drm/panfrost: Check for error num after setting mask
      mtd: onenand: Check for error irq
      ray_cs: Check ioremap return value
      iommu/ipmmu-vmsa: Check for error num after setting mask
      power: supply: wm8350-power: Handle error for wm8350_register_irq
      power: supply: wm8350-power: Add missing free in free_charger_irq
      mfd: mc13xxx: Add check for mc13xxx_irq_request
      iio: adc: Add check for devm_request_threaded_irq
      habanalabs: Add check for pci_enable_device
      ASoC: soc-compress: Change the check for codec_dai

Jiaxin Yu (1):
      ASoC: mediatek: mt6358: add missing EXPORT_SYMBOLs

Jie Hai (1):
      dmaengine: hisi_dma: fix MSI allocate fail when reload hisi_dma

Jing Yao (3):
      video: fbdev: omapfb: panel-dsi-cm: Use sysfs_emit() instead of snprintf()
      video: fbdev: omapfb: panel-tpo-td043mtea1: Use sysfs_emit() instead of snprintf()
      video: fbdev: udlfb: replace snprintf in show functions with sysfs_emit

Jiri Slaby (1):
      mxser: fix xmit_buf leak in activate when LSR == 0xff

Jocelyn Falempe (1):
      mgag200 fix memmapsl configuration in GCTL6 register

Joe Carnuccio (2):
      scsi: qla2xxx: Add devids and conditionals for 28xx
      scsi: qla2xxx: Check for firmware dump already collected

Johan Hovold (3):
      USB: serial: simple: add Nokia phone driver
      media: davinci: vpif: fix unbalanced runtime PM get
      media: davinci: vpif: fix unbalanced runtime PM enable

John David Anglin (1):
      parisc: Fix handling off probe non-access faults

Jonathan Cameron (1):
      staging:iio:adc:ad7280a: Fix handing of device address bit reversing.

Jonathan Neuschäfer (5):
      clk: actions: Terminate clk_div_table with sentinel element
      clk: loongson1: Terminate clk_div_table with sentinel element
      clk: clps711x: Terminate clk_div_table with sentinel element
      pinctrl: nuvoton: npcm7xx: Rename DS() macro to DSTR()
      pinctrl: nuvoton: npcm7xx: Use %zu printk format for ARRAY_SIZE()

José Expósito (1):
      Revert "Input: clear BTN_RIGHT/MIDDLE on buttonpads"

Juergen Gross (1):
      xen: fix is_xen_pmu()

Juhyung Park (1):
      f2fs: quota: fix loop condition at f2fs_quota_sync()

Kai-Heng Feng (1):
      ALSA: hda/realtek: Fix audio regression on Mi Notebook Pro 2020

Kees Cook (2):
      exec: Force single empty string when argv is empty
      gcc-plugins/stackleak: Exactly match strings instead of prefixes

Konrad Dybcio (1):
      clk: qcom: gcc-msm8994: Fix gpll4 width

Krzysztof Kozlowski (5):
      pinctrl: samsung: drop pin banks references on error paths
      ARM: dts: exynos: fix UART3 pins configuration in Exynos5250
      ARM: dts: exynos: add missing HDMI supplies on SMDK5250
      ARM: dts: exynos: add missing HDMI supplies on SMDK5420
      clocksource/drivers/exynos_mct: Handle DTS with higher number of interrupts

Kuan-Ying Lee (1):
      mm/kmemleak: reset tag when compare object pointer

Kuldeep Singh (3):
      arm64: dts: ns2: Fix spi-cpol and spi-cpha property
      ARM: dts: spear1340: Update serial node properties
      ARM: dts: spear13xx: Update SPI dma properties

Kunihiko Hayashi (1):
      clk: uniphier: Fix fixed-rate initialization

Kuogee Hsieh (1):
      drm/msm/dp: populate connector of struct dp_panel

Lars Ellenberg (1):
      drbd: fix potential silent data corruption

Li RongQing (1):
      KVM: x86: fix sending PV IPI

Liam Beguin (4):
      iio: afe: rescale: use s64 for temporary scale calculations
      iio: inkern: apply consumer scale on IIO_VAL_INT cases
      iio: inkern: apply consumer scale when no channel scale is available
      iio: inkern: make a best effort on offset calculation

Libin Yang (1):
      soundwire: intel: fix wrong register name in intel_shim_wake

Liguang Zhang (1):
      PCI: pciehp: Clear cmd_busy bit in polling mode

Lina Wang (1):
      xfrm: fix tunnel model fragmentation behavior

Lino Sanfilippo (1):
      tpm: fix reference counting for struct tpm_chip

Linus Torvalds (2):
      fs: fd tables have to be multiples of BITS_PER_LONG
      fs: fix fd table size alignment properly

Linus Walleij (1):
      Input: zinitix - do not report shadow fingers

Liu Ying (1):
      phy: dphy: Correct lpx parameter and its derivatives(ta_{get,go,sure})

Lorenzo Bianconi (4):
      mt76: mt7915: use proper aid value in mt7915_mcu_wtbl_generic_tlv in sta mode
      mt76: mt7915: use proper aid value in mt7915_mcu_sta_basic_tlv
      mt76: mt7603: check sta_rates pointer in mt7603_sta_rate_tbl_update
      mt76: mt7615: check sta_rates pointer in mt7615_sta_rate_tbl_update

Luca Weiss (1):
      cpufreq: qcom-cpufreq-nvmem: fix reading of PVS Valid fuse

Lucas Tanure (1):
      i2c: meson: Fix wrong speed use from probe

Lucas Zampieri (1):
      HID: logitech-dj: add new lightspeed receiver id

Lv Ruyi (1):
      proc: bootconfig: Add null pointer check

Maciej W. Rozycki (1):
      DEC: Limit PMAX memory probing to R3k systems

Manish Chopra (2):
      qed: display VF trust config
      qed: validate and restrict untrusted VFs vlan promisc mode

Manish Rangankar (1):
      scsi: qla2xxx: Use correct feature type field during RFF_ID processing

Maor Gottlieb (1):
      RDMA/core: Set MR type in ib_reg_user_mr

Marc Kleine-Budde (1):
      can: m_can: m_can_tx_handler(): fix use after free of skb

Marc Zyngier (4):
      PCI: xgene: Revert "PCI: xgene: Fix IB window setup"
      pinctrl: npcm: Fix broken references to chip->parent_device
      irqchip/qcom-pdc: Fix broken locking
      PCI: xgene: Revert "PCI: xgene: Use inbound resources for setup"

Marcel Ziswiler (1):
      arm64: defconfig: build imx-sdma as a module

Marcelo Roberto Jimenez (1):
      gpio: Revert regression in sysfs-gpio (gpiolib.c)

Marek Szyprowski (1):
      clocksource/drivers/exynos_mct: Refactor resources allocation

Marek Vasut (1):
      ARM: dts: imx: Add missing LVDS decoder on M53Menlo

Marijn Suijten (1):
      firmware: qcom: scm: Remove reassignment to desc following initializer

Mark Tomlinson (1):
      PCI: Reduce warnings on possible RW1C corruption

Martin Blumenstingl (1):
      drm/meson: osd_afbcd: Add an exit callback to struct meson_afbcd_ops

Martin Varghese (1):
      openvswitch: Fixed nd target mask field in the flow dump.

Mastan Katragadda (1):
      drm/i915/gem: add missing boundary check in vm_access

Mathias Nyman (1):
      xhci: make xhci_handshake timeout for xhci_reset() adjustable

Mathieu Desnoyers (1):
      rseq: Remove broken uapi field layout on 32-bit little endian

Matt Kramer (1):
      ALSA: hda/realtek: Add alc256-samsung-headphone fixup

Matthew Wilcox (Oracle) (2):
      XArray: Fix xas_create_range() when multi-order entry present
      XArray: Update the LRU list in xas_split()

Maulik Shah (1):
      arm64: dts: qcom: sm8150: Correct TCS configuration for apps rsc

Mauro Carvalho Chehab (1):
      media: atomisp: fix bad usage at error handling logic

Max Filippov (2):
      xtensa: fix stop_machine_cpuslocked call in patch_text
      xtensa: fix xtensa_wsr always writing 0

Maxim Kiselev (1):
      powerpc: dts: t1040rdb: fix ports names for Seville Ethernet switch

Maxime Ripard (2):
      drm/edid: Don't clear formats if using deep color
      clk: Initialize orphan req_rate

Maíra Canal (1):
      drm/amd/display: Remove vupdate_int_entry definition

Miaoqian Lin (31):
      spi: tegra114: Add missing IRQ check in tegra_spi_probe
      hwrng: nomadik - Change clk_disable to clk_disable_unprepare
      media: coda: Fix missing put_device() call in coda_get_vdoa_data
      soc: qcom: ocmem: Fix missing put_device() call in of_get_ocmem
      soc: ti: wkup_m3_ipc: Fix IRQ check in wkup_m3_ipc_probe
      ASoC: atmel: Add missing of_node_put() in at91sam9g20ek_audio_probe
      video: fbdev: omapfb: Add missing of_node_put() in dvic_probe_of
      ASoC: rockchip: i2s: Fix missing clk_disable_unprepare() in rockchip_i2s_probe
      ASoC: SOF: Add missing of_node_put() in imx8m_probe
      ASoC: mxs: Fix error handling in mxs_sgtl5000_probe
      ASoC: msm8916-wcd-digital: Fix missing clk_disable_unprepare() in msm8916_wcd_digital_probe
      ASoC: atmel: Fix error handling in sam9x5_wm8731_driver_probe
      ASoC: msm8916-wcd-analog: Fix error handling in pm8916_wcd_analog_spmi_probe
      ASoC: codecs: wcd934x: Add missing of_node_put() in wcd934x_codec_parse_data
      drm/bridge: Fix free wrong object in sii8620_init_rcp_input_dev
      drm/bridge: Add missing pm_runtime_disable() in __dw_mipi_dsi_probe
      drm/bridge: nwl-dsi: Fix PM disable depth imbalance in nwl_dsi_probe
      power: reset: gemini-poweroff: Fix IRQ check in gemini_poweroff_probe
      power: supply: ab8500: Fix memory leak in ab8500_fg_sysfs_init
      drm/tegra: Fix reference leak in tegra_dsi_ganged_probe
      ath10k: Fix error handling in ath10k_setup_msa_resources
      mips: cdmm: Fix refcount leak in mips_cdmm_phys_base
      mfd: asic3: Add missing iounmap() on error asic3_mfd_probe
      remoteproc: qcom: Fix missing of_node_put in adsp_alloc_memory_region
      remoteproc: qcom_wcnss: Add missing of_node_put() in wcnss_alloc_memory_region
      remoteproc: qcom_q6v5_mss: Fix some leaks in q6v5_alloc_memory_region
      clk: tegra: tegra124-emc: Fix missing put_device() call in emc_ensure_emc_driver
      pinctrl: mediatek: Fix missing of_node_put() in mtk_pctrl_init
      pinctrl: nomadik: Add missing of_node_put() in nmk_pinctrl_probe
      pinctrl/rockchip: Add missing of_node_put() in rockchip_pinctrl_probe
      watchdog: rti-wdt: Add missing pm_runtime_disable() in probe function

Michael Ellerman (1):
      powerpc/Makefile: Don't pass -mcpu=powerpc64 when building 32-bit

Michael S. Tsirkin (1):
      virtio_console: break out of buf poll on remove

Michael Schmitz (1):
      video: fbdev: atari: Atari 2 bpp (STe) palette bugfix

Mike Marciniszyn (1):
      IB/hfi1: Allow larger MTU without AIP

Mikulas Patocka (1):
      dm integrity: set journal entry unused when shrinking device

Minghao Chi (1):
      spi: tegra20: Use of_device_get_match_data()

Minghao Chi (CGEL ZTE) (1):
      net:mcf8390: Use platform_get_irq() to get the interrupt

Mingzhe Zou (1):
      bcache: fixup multiple threads crash

Miquel Raynal (4):
      spi: mxic: Fix the transmit path
      dt-bindings: mtd: nand-controller: Fix the reg property description
      dt-bindings: mtd: nand-controller: Fix a comment in the examples
      dt-bindings: spi: mxic: The interrupt property is not mandatory

Mohan Kumar (1):
      ALSA: hda: Avoid unsol event during RPM suspending

Muhammad Usama Anjum (1):
      selftests/x86: Add validity check and allow field splitting

Namhyung Kim (1):
      bpf: Adjust BPF stack helper functions to accommodate skip > 0

Neil Armstrong (1):
      drm/bridge: dw-hdmi: use safe format when first in bridge chain

NeilBrown (1):
      SUNRPC: avoid race between mod_timer() and del_timer_sync()

Niels Dossche (1):
      Bluetooth: call hci_le_conn_failed with hdev lock in hci_le_conn_failed

Nikita Shubin (1):
      riscv: Fix fill_callchain return value

Niklas Söderlund (1):
      samples/bpf, xdpsock: Fix race when running for fix duration of time

Nilesh Javali (1):
      scsi: qla2xxx: Fix warning for missing error code

Nishanth Menon (4):
      arm64: dts: ti: k3-am65: Fix gic-v3 compatible regs
      arm64: dts: ti: k3-j721e: Fix gic-v3 compatible regs
      arm64: dts: ti: k3-j7200: Fix gic-v3 compatible regs
      drm/bridge: cdns-dsi: Make sure to to create proper aliases for dt

Olga Kornievskaia (1):
      NFSv4.1: don't retry BIND_CONN_TO_SESSION on session error

Oliver Hartkopp (5):
      can: isotp: sanitize CAN ID checks in isotp_bind()
      vxcan: enable local echo for sent CAN frames
      can: isotp: return -EADDRNOTAVAIL when reading from unbound socket
      can: isotp: support MSG_TRUNC flag when reading from socket
      can: isotp: restore accidentally removed MSG_PEEK feature

Ondrej Zary (1):
      media: bttv: fix WARNING regression on tunerless devices

Pablo Neira Ayuso (1):
      netfilter: nf_conntrack_tcp: preserve liberal flag in tcp options

Pali Rohár (1):
      PCI: aardvark: Fix reading PCI_EXP_RTSTA_PME bit on emulated bridge

Paolo Bonzini (1):
      KVM: x86/mmu: do compare-and-exchange of gPTE via the user address

Paolo Valente (1):
      Revert "Revert "block, bfq: honor already-setup queue merges""

Patrick Rudolph (1):
      hwmon: (pmbus) Add mutex to regulator ops

Paul Kocialkowski (1):
      ARM: dts: sun8i: v3s: Move the csi1 block to follow address order

Paul Menzel (1):
      lib/raid6/test/Makefile: Use $(pound) instead of \# for Make 4.3

Paulo Alcantara (2):
      cifs: prevent bad output lengths in smb2_ioctl_query_info()
      cifs: fix NULL ptr dereference in smb2_ioctl_query_info()

Pavel Begunkov (1):
      io_uring: fix memory leak of uid in files registration

Pavel Kubelun (1):
      ARM: dts: qcom: ipq4019: fix sleep clock

Pavel Skripkin (6):
      udmabuf: validate ubuf->pagecount
      Bluetooth: hci_serdev: call init_rwsem() before p->open()
      ath9k_htc: fix uninit value bugs
      jfs: fix divide error in dbNextAG
      media: Revert "media: em28xx: add missing em28xx_close_extension"
      can: mcba_usb: properly check endpoint type

Peiwei Hu (1):
      media: ir_toy: free before error exiting

Pekka Pessi (1):
      mailbox: tegra-hsp: Flush whole channel

Peng Liu (1):
      kunit: make kunit_test_timeout compatible with comment

Peter Rosin (1):
      i2c: mux: demux-pinctrl: do not deactivate a master that is not active

Petr Machata (1):
      af_netlink: Fix shift out of bounds in group mask calculation

Petr Vorel (1):
      crypto: vmx - add missing dependencies

Pierre-Louis Bossart (1):
      ASoC: generic: simple-card-utils: remove useless assignment

Prashant Malani (1):
      platform/chrome: cros_ec_typec: Check for EC device

Qais Yousef (1):
      sched/core: Export pelt_thermal_tp

Quinn Tran (7):
      scsi: qla2xxx: Fix stuck session in gpdb
      scsi: qla2xxx: Fix scheduling while atomic
      scsi: qla2xxx: Fix disk failure to rediscover
      scsi: qla2xxx: Fix incorrect reporting of task management failure
      scsi: qla2xxx: Fix hang due to session stuck
      scsi: qla2xxx: Fix N2N inconsistent PLOGI
      scsi: qla2xxx: Reduce false trigger to login

Rafael J. Wysocki (2):
      ACPICA: Avoid walking the ACPI Namespace if it is not there
      ACPI: CPPC: Avoid out of bounds access when parsing _CPC data

Randy Dunlap (20):
      hv: utils: add PTP_1588_CLOCK to Kconfig to fix build
      EVM: fix the evm= __setup handler return value
      PM: hibernate: fix __setup handler error handling
      PM: suspend: fix return value of __setup handler
      ACPI: APEI: fix return value of __setup handlers
      clocksource: acpi_pm: fix return value of __setup handler
      printk: fix return value of printk.devkmsg __setup handler
      m68k: coldfire/device.c: only build for MCF_EDMA when h/w macros are defined
      TOMOYO: fix __setup handlers return values
      mips: DEC: honor CONFIG_MIPS_FP_SUPPORT=n
      MIPS: RB532: fix return value of __setup handler
      dma-debug: fix return value of __setup handlers
      tty: hvc: fix return value of __setup handler
      kgdboc: fix return value of __setup handler
      kgdbts: fix return value of __setup handler
      driver core: dd: fix return value of __setup handler
      mm/mmap: return 1 from stack_guard_gap __setup() handler
      ARM: 9187/1: JIVE: fix return value of __setup handler
      mm/memcontrol: return 1 from cgroup.memory __setup() handler
      mm/usercopy: return 1 from hardened_usercopy __setup() handler

Richard Guy Briggs (1):
      audit: log AUDIT_TIME_* records only from rules

Richard Haines (1):
      selinux: allow FIOCLEX and FIONCLEX with policy capability

Richard Leitner (1):
      ARM: tegra: tamonten: Fix I2C3 pad setting

Richard Schleich (2):
      ARM: dts: bcm2837: Add the missing L1/L2 cache information
      ARM: dts: bcm2711: Add the missing L1/L2 cache information

Rik van Riel (2):
      mm: invalidate hwpoison page cache page in fault path
      mm,hwpoison: unmap poisoned page before invalidation

Ritesh Harjani (3):
      ext4: fix ext4_fc_stats trace point
      ext4: correct cluster len and clusters changed accounting in ext4_mb_mark_bb
      ext4: fix ext4_mb_mark_bb() with flex_bg with fast_commit

Rob Herring (1):
      arm64: dts: rockchip: Fix SDIO regulator supply properties on rk3399-firefly

Robert Hancock (3):
      ASoC: xilinx: xlnx_formatter_pcm: Handle sysclk setting
      i2c: xiic: Make bus names unique
      net: axienet: fix RX ring refill allocation failure handling

Robert Marko (1):
      clk: qcom: ipq8074: fix PCI-E clock oops

Robin Gong (1):
      mailbox: imx: fix wakeup failure from freeze mode

Robin Murphy (1):
      iommu/iova: Improve 32-bit free space estimate

Roman Li (1):
      drm/amd/display: Add affected crtcs to atomic state for dsc mst unplug

Sakari Ailus (1):
      ACPI: properties: Consistently return -ENOENT if there are no more references

Sam Ravnborg (1):
      video: fbdev: controlfb: Fix set but not used warnings

Saurav Kashyap (1):
      scsi: qla2xxx: Suppress a kernel complaint in qla_create_qpair()

Sean Christopherson (1):
      KVM: x86/mmu: Check for present SPTE when clearing dirty bit in TDP MMU

Sean Nyekjaer (1):
      mtd: rawnand: protect access to rawnand devices while in suspend

Sean Young (1):
      media: gpio-ir-tx: fix transmit with long spaces on Orange Pi PC

Shannon Nelson (1):
      ionic: fix type complaint in ionic_dev_cmd_clean()

Shengjiu Wang (2):
      ASoC: fsl_spdif: Disable TX clock when stop
      ASoC: soc-core: skip zero num_dai component in searching dai name

Shin'ichiro Kawasaki (1):
      block: limit request dispatch loop duration

Si-Wei Liu (1):
      vdpa/mlx5: should verify CTRL_VQ feature exists for MQ

Souptick Joarder (HPE) (1):
      irqchip/nvic: Release nvic_base upon failure

Srinivas Kandagatla (1):
      ASoC: codecs: wcd934x: fix return value of wcd934x_rx_hph_mode_put

Srinivas Pandruvada (1):
      thermal: int340x: Increase bitmap size

Stefano Garzarella (1):
      tools/virtio: fix virtio_test execution

Sunil Goutham (1):
      hwrng: cavium - Check health status while reading random data

Sven Eckelmann (1):
      batman-adv: Check ptr for NULL before reducing its refcnt

Takashi Iwai (1):
      ALSA: pcm: Fix potential AB/BA lock with buffer_mutex and mmap_lock

Takashi Sakamoto (1):
      ALSA: firewire-lib: fix uninitialized flag for AV/C deferred transaction

Taniya Das (2):
      clk: qcom: clk-rcg2: Update logic to calculate D value for RCG
      clk: qcom: clk-rcg2: Update the frac table for pixel clock

Tejun Heo (1):
      block: don't merge across cgroup boundaries if blkcg is enabled

Theodore Ts'o (1):
      ext4: don't BUG if someone dirty pages without asking ext4 first

Thomas Bracht Laumann Jespersen (1):
      scripts/dtc: Call pkg-config POSIXly correct

Tim Gardner (1):
      video: fbdev: nvidiafb: Use strscpy() to prevent buffer overflow

Tobias Waldekranz (1):
      net: dsa: mv88e6xxx: Enable port policy support on 6097

Tom Rix (5):
      media: video/hdmi: handle short reads of hdmi info frame.
      drm/amd/pm: return -ENOTSUPP if there is no get_dpm_ultimate_freq function
      qlcnic: dcb: default to returning -EOPNOTSUPP
      can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix return of error value
      rtc: check if __rtc_read_time was successful

Tomas Paukrt (1):
      crypto: mxs-dcp - Fix scatterlist processing

Tong Zhang (1):
      dax: make sure inodes are flushed before destroy cache

Trond Myklebust (3):
      NFS: Use of mapping_set_error() results in spurious errors
      NFS: Return valid errors from nfs2/3_decode_dirent()
      NFSv4/pNFS: Fix another issue with a list iterator pointing to the head

Tsuchiya Yuto (1):
      media: atomisp: fix dummy_ptr check to avoid duplicate active_bo

Tudor Ambarus (1):
      ARM: dts: at91: sama5d2: Fix PMERRLOC resource size

Ulf Hansson (1):
      mmc: host: Return an error when ->enable_sdio_irq() ops is missing

Uwe Kleine-König (5):
      vfio: platform: simplify device removal
      amba: Make the remove callback return void
      pwm: lpc18xx-sct: Initialize driver data and hardware before pwmchip_add()
      serial: 8250: Fix race condition in RTS-after-send handling
      ARM: mmp: Fix failure to remove sram device

Vijay Balakrishna (1):
      arm64: Do not defer reserve_crashkernel() for platforms with no DMA memory zones

Vitaly Kuznetsov (1):
      KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs when SynIC wasn't activated

Vladimir Oltean (1):
      net: enetc: report software timestamping via SO_TIMESTAMPING

Waiman Long (2):
      locking/lockdep: Avoid potential access of invalid memory in lock_class
      locking/lockdep: Iterate lock_classes directly when reading lockdep files

Wang Hai (2):
      video: fbdev: smscufx: Fix null-ptr-deref in ufx_usb_probe()
      wireguard: socket: free skb in send6 when ipv6 is disabled

Wang Wensheng (1):
      ASoC: imx-es8328: Fix error return code in imx_es8328_probe()

Wang Yufen (3):
      bpf, sockmap: Fix memleak in tcp_bpf_sendmsg while sk msg is full
      bpf, sockmap: Fix more uncharged while msg has more_data
      bpf, sockmap: Fix double uncharge the mem of sk_msg

Wen Gong (1):
      ath10k: fix memory overwrite of the WoWLAN wakeup packet pattern

Xiang Chen (1):
      scsi: hisi_sas: Change permission of parameter prot_mask

Xiaomeng Tong (2):
      ALSA: cs4236: fix an incorrect NULL check on list iterator
      net: dsa: bcm_sf2_cfp: fix an incorrect NULL check on list iterator

Xie Yongji (1):
      virtio-blk: Use blk_validate_block_size() to validate block size

Xin Long (1):
      udp: call udp_encap_enable for v6 sockets when enabling encap

Xin Xiong (1):
      mtd: rawnand: atmel: fix refcount issue in atmel_nand_controller_init

Xu Kuohai (1):
      libbpf: Skip forward declaration when counting duplicated type names

Yafang Shao (1):
      libbpf: Fix possible NULL pointer dereference when destroying skeleton

Yajun Deng (1):
      netdevice: add the case if dev is NULL

Yake Yang (1):
      Bluetooth: btmtksdio: Fix kernel oops in btmtksdio_interrupt

Yaliang Wang (1):
      MIPS: pgalloc: fix memory leak caused by pgd_free()

Yang Guang (1):
      video: fbdev: omapfb: acx565akm: replace snprintf with sysfs_emit

Yang Yingliang (3):
      media: saa7134: convert list_for_each to entry variant
      ASoC: rockchip: i2s: Use devm_platform_get_and_ioremap_resource()
      ASoC: atmel: sam9x5_wm8731: use devm_snd_soc_register_card()

Yangtao Li (1):
      fsi: aspeed: convert to devm_platform_ioremap_resource

Ye Bin (1):
      ext4: fix fs corruption when tring to remove a non-empty directory with IO error

Yi Wang (1):
      KVM: SVM: fix panic on out-of-bounds guest IRQ

Yiqing Yao (1):
      drm/amd/pm: enable pm sysfs write for one VF mode

Yongzhi Liu (1):
      RDMA/mlx5: Fix memory leak in error flow for subscribe event routine

Yu Kuai (1):
      block, bfq: don't move oom_bfqq

YueHaibing (1):
      video: fbdev: controlfb: Fix COMPILE_TEST build

Z. Liu (1):
      video: fbdev: matroxfb: set maxvram of vbG200eW to the same as vbG200 to avoid black screen

Zhang Wensheng (1):
      bfq: fix use-after-free in bfq_dispatch_request

Zhang Yi (1):
      ext2: correct max file size computing

Zhenzhong Duan (1):
      KVM: x86: Fix emulation in writing cr8

Zheyu Ma (2):
      ethernet: sun: Free the coherent when failing in probing
      video: fbdev: sm712fb: Fix crash in smtcfb_write()

Zhihao Cheng (7):
      ubifs: rename_whiteout: Fix double free for whiteout_ui->data
      ubifs: Fix deadlock in concurrent rename whiteout and inode writeback
      ubifs: Add missing iput if do_tmpfile() failed in rename whiteout
      ubifs: setflags: Make dirtied_ino_d 8 bytes aligned
      ubifs: Fix read out-of-bounds in ubifs_wbuf_write_nolock()
      ubifs: Fix to add refcount once page is set private
      ubi: fastmap: Return error code if memory allocation fails in add_aeb()

Zhou Qingyang (2):
      drm/nouveau/acr: Fix undefined behavior in nvkm_acr_hsfw_load_bl()
      drm/amd/display: Fix a NULL pointer dereference in amdgpu_dm_connector_add_common_modes()

kernel test robot (1):
      regulator: qcom_smd: fix for_each_child.cocci warnings

lic121 (1):
      libbpf: Unmap rings when umem deleted

