Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 767B014A719
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 16:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgA0PW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 10:22:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729321AbgA0PW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 10:22:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED0892071E;
        Mon, 27 Jan 2020 15:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580138576;
        bh=/sOeVtzHeAyOTRrlt31B/5q0LVJ3+OCKwytBFCX6PaE=;
        h=Date:From:To:Cc:Subject:From;
        b=Wr1EBpyNIEA2UYDlUX4GFfaE0A8zdmqhGWQjXF+j5GGS3zwamTwGa0Xi+DOPe/O/u
         2RPvmHNNpdhk12dSqhLRvC4vSdCSYOKrhiSt/vJi2RuBdwusmEtEmi1Ci5/30ioNe3
         KXvTIZrd4HiXUSYsHOZjqDx1+G20zE6gpBb4ZVj4=
Date:   Mon, 27 Jan 2020 16:22:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.99
Message-ID: <20200127152254.GA667965@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.99 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-iio                       |    2=20
 Documentation/devicetree/bindings/bus/ti-sysc.txt             |    1=20
 Documentation/devicetree/bindings/rng/omap3_rom_rng.txt       |   27=20
 Makefile                                                      |    6=20
 arch/arm/boot/dts/aspeed-g5.dtsi                              |    2=20
 arch/arm/boot/dts/at91-nattis-2-natte-2.dts                   |    7=20
 arch/arm/boot/dts/bcm2835-rpi.dtsi                            |    2=20
 arch/arm/boot/dts/iwg20d-q7-common.dtsi                       |    2=20
 arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi               |    2=20
 arch/arm/boot/dts/logicpd-som-lv.dtsi                         |   26=20
 arch/arm/boot/dts/lpc3250-phy3250.dts                         |    4=20
 arch/arm/boot/dts/lpc32xx.dtsi                                |   10=20
 arch/arm/boot/dts/ls1021a-twr.dts                             |    9=20
 arch/arm/boot/dts/ls1021a.dtsi                                |   11=20
 arch/arm/boot/dts/omap3-n900.dts                              |    6=20
 arch/arm/boot/dts/r8a7743.dtsi                                |    4=20
 arch/arm/boot/dts/stm32h743i-eval.dts                         |    1=20
 arch/arm/boot/dts/sun8i-a23-a33.dtsi                          |   30=20
 arch/arm/boot/dts/sun8i-h3-beelink-x2.dts                     |    4=20
 arch/arm/boot/dts/sun9i-a80-optimus.dts                       |    4=20
 arch/arm/common/mcpm_entry.c                                  |    2=20
 arch/arm/configs/qcom_defconfig                               |    1=20
 arch/arm/include/asm/suspend.h                                |    1=20
 arch/arm/kernel/head-nommu.S                                  |    4=20
 arch/arm/kernel/hyp-stub.S                                    |    4=20
 arch/arm/kernel/sleep.S                                       |   12=20
 arch/arm/kernel/vdso.c                                        |    1=20
 arch/arm/mach-omap2/omap_hwmod.c                              |    2=20
 arch/arm/mach-omap2/pdata-quirks.c                            |   12=20
 arch/arm/mach-rpc/irq.c                                       |    3=20
 arch/arm/mach-stm32/Kconfig                                   |    3=20
 arch/arm/plat-pxa/ssp.c                                       |    6=20
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi                 |    3=20
 arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64.dts          |    2=20
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi                  |   22=20
 arch/arm64/boot/dts/amlogic/meson-gx-p23x-q20x.dtsi           |    1=20
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts    |    1=20
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts  |    2=20
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-p212.dts          |    1=20
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts         |   17=20
 arch/arm64/boot/dts/arm/juno-clocks.dtsi                      |    4=20
 arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi                     |    2=20
 arch/arm64/boot/dts/qcom/msm8916.dtsi                         |    8=20
 arch/arm64/boot/dts/renesas/r8a7795-es1.dtsi                  |    2=20
 arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts                |    1=20
 arch/arm64/boot/dts/renesas/r8a77995.dtsi                     |    2=20
 arch/arm64/configs/defconfig                                  |    1=20
 arch/arm64/kernel/hibernate.c                                 |    9=20
 arch/arm64/kernel/vdso.c                                      |    2=20
 arch/ia64/kernel/signal.c                                     |   60 -
 arch/m68k/amiga/cia.c                                         |    9=20
 arch/m68k/atari/ataints.c                                     |    4=20
 arch/m68k/atari/time.c                                        |   15=20
 arch/m68k/bvme6000/config.c                                   |   20=20
 arch/m68k/hp300/time.c                                        |   10=20
 arch/m68k/mac/via.c                                           |  119 +-
 arch/m68k/mvme147/config.c                                    |   18=20
 arch/m68k/mvme16x/config.c                                    |   21=20
 arch/m68k/q40/q40ints.c                                       |   19=20
 arch/m68k/sun3/sun3ints.c                                     |    3=20
 arch/m68k/sun3x/time.c                                        |   16=20
 arch/mips/bcm63xx/Makefile                                    |    6=20
 arch/mips/bcm63xx/boards/board_bcm963xx.c                     |   20=20
 arch/mips/bcm63xx/dev-dsp.c                                   |   56 -
 arch/mips/include/asm/io.h                                    |   14=20
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_dev_dsp.h          |   14=20
 arch/mips/include/asm/mach-bcm63xx/board_bcm963xx.h           |    5=20
 arch/mips/kernel/setup.c                                      |    2=20
 arch/nios2/kernel/nios2_ksyms.c                               |   12=20
 arch/powerpc/Makefile                                         |    2=20
 arch/powerpc/include/asm/archrandom.h                         |    2=20
 arch/powerpc/include/asm/kgdb.h                               |    5=20
 arch/powerpc/kernel/cacheinfo.c                               |   21=20
 arch/powerpc/kernel/cacheinfo.h                               |    4=20
 arch/powerpc/kernel/dt_cpu_ftrs.c                             |   17=20
 arch/powerpc/kernel/kgdb.c                                    |   43 -
 arch/powerpc/kernel/mce_power.c                               |   20=20
 arch/powerpc/kernel/prom_init.c                               |    2=20
 arch/powerpc/kvm/book3s_64_vio.c                              |    1=20
 arch/powerpc/kvm/book3s_hv.c                                  |   15=20
 arch/powerpc/mm/dump_hashpagetable.c                          |    2=20
 arch/powerpc/mm/pgtable-radix.c                               |    4=20
 arch/powerpc/platforms/pseries/hotplug-memory.c               |   61 -
 arch/powerpc/platforms/pseries/mobility.c                     |   10=20
 arch/s390/kernel/kexec_elf.c                                  |    2=20
 arch/sh/boards/mach-migor/setup.c                             |    1=20
 arch/um/drivers/chan_kern.c                                   |   52 +
 arch/um/include/asm/irq.h                                     |    2=20
 arch/um/kernel/irq.c                                          |    4=20
 arch/x86/Kconfig.debug                                        |    2=20
 arch/x86/events/intel/pt.c                                    |    9=20
 arch/x86/include/asm/pgtable_32.h                             |    2=20
 arch/x86/kernel/kgdb.c                                        |    2=20
 arch/x86/mm/tlb.c                                             |    3=20
 block/blk-merge.c                                             |    8=20
 crypto/pcrypt.c                                               |    2=20
 crypto/tgr192.c                                               |    6=20
 drivers/acpi/acpi_lpss.c                                      |  111 ++
 drivers/acpi/button.c                                         |    5=20
 drivers/acpi/device_pm.c                                      |   94 +-
 drivers/ata/libahci.c                                         |    1=20
 drivers/base/core.c                                           |   88 +-
 drivers/base/power/runtime.c                                  |   40=20
 drivers/base/power/wakeup.c                                   |    2=20
 drivers/bcma/driver_pci.c                                     |    4=20
 drivers/block/drbd/drbd_main.c                                |    2=20
 drivers/block/rbd.c                                           |    1=20
 drivers/bus/ti-sysc.c                                         |   18=20
 drivers/char/hw_random/bcm2835-rng.c                          |   18=20
 drivers/char/hw_random/omap3-rom-rng.c                        |   17=20
 drivers/char/ipmi/ipmi_msghandler.c                           |    5=20
 drivers/char/ipmi/kcs_bmc.c                                   |    5=20
 drivers/clk/actions/owl-factor.c                              |    7=20
 drivers/clk/clk-highbank.c                                    |    1=20
 drivers/clk/clk-qoriq.c                                       |    1=20
 drivers/clk/imx/clk-imx6q.c                                   |    1=20
 drivers/clk/imx/clk-imx6sx.c                                  |    1=20
 drivers/clk/imx/clk-imx7d.c                                   |    1=20
 drivers/clk/imx/clk-vf610.c                                   |    1=20
 drivers/clk/ingenic/jz4740-cgu.c                              |    2=20
 drivers/clk/meson/axg.c                                       |   10=20
 drivers/clk/meson/gxbb.c                                      |    5=20
 drivers/clk/mvebu/armada-370.c                                |    4=20
 drivers/clk/mvebu/armada-xp.c                                 |    4=20
 drivers/clk/mvebu/dove.c                                      |    8=20
 drivers/clk/mvebu/kirkwood.c                                  |    2=20
 drivers/clk/mvebu/mv98dx3236.c                                |    4=20
 drivers/clk/qcom/gcc-msm8996.c                                |   36=20
 drivers/clk/qcom/gcc-msm8998.c                                |    2=20
 drivers/clk/samsung/clk-exynos4.c                             |    1=20
 drivers/clk/socfpga/clk-pll-a10.c                             |    1=20
 drivers/clk/socfpga/clk-pll.c                                 |    1=20
 drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c                        |    2=20
 drivers/clk/sunxi-ng/ccu-sun8i-a23.c                          |    2=20
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c                          |   19=20
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.h                          |    6=20
 drivers/clk/ti/clk.c                                          |    8=20
 drivers/clocksource/exynos_mct.c                              |   14=20
 drivers/clocksource/timer-sun5i.c                             |   10=20
 drivers/clocksource/timer-ti-dm.c                             |    1=20
 drivers/cpufreq/brcmstb-avs-cpufreq.c                         |   12=20
 drivers/crypto/amcc/crypto4xx_trng.h                          |    4=20
 drivers/crypto/bcm/cipher.c                                   |    6=20
 drivers/crypto/caam/caamrng.c                                 |    5=20
 drivers/crypto/caam/error.c                                   |    2=20
 drivers/crypto/ccp/ccp-crypto-aes.c                           |    8=20
 drivers/crypto/ccp/ccp-ops.c                                  |   67 -
 drivers/crypto/ccree/cc_cipher.c                              |    2=20
 drivers/crypto/hisilicon/sec/sec_algs.c                       |   44 -
 drivers/crypto/inside-secure/safexcel_hash.c                  |   10=20
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c                       |   21=20
 drivers/crypto/talitos.c                                      |  158 +--
 drivers/crypto/talitos.h                                      |    2=20
 drivers/dma/dma-axi-dmac.c                                    |    2=20
 drivers/dma/dw/platform.c                                     |   14=20
 drivers/dma/hsu/hsu.c                                         |    4=20
 drivers/dma/imx-sdma.c                                        |    8=20
 drivers/dma/mv_xor.c                                          |    2=20
 drivers/dma/tegra210-adma.c                                   |   72 +
 drivers/dma/ti/edma.c                                         |    6=20
 drivers/edac/edac_mc.c                                        |   12=20
 drivers/firmware/arm_scmi/clock.c                             |    2=20
 drivers/firmware/arm_scmi/driver.c                            |    4=20
 drivers/firmware/arm_scmi/sensors.c                           |    4=20
 drivers/firmware/dmi_scan.c                                   |    2=20
 drivers/firmware/efi/runtime-wrappers.c                       |    2=20
 drivers/firmware/google/coreboot_table-of.c                   |   28=20
 drivers/fsi/fsi-core.c                                        |   32=20
 drivers/fsi/fsi-sbefifo.c                                     |    4=20
 drivers/gpio/gpio-aspeed.c                                    |    2=20
 drivers/gpu/drm/drm_context.c                                 |   15=20
 drivers/gpu/drm/drm_dp_mst_topology.c                         |   15=20
 drivers/gpu/drm/drm_fb_helper.c                               |  102 +-
 drivers/gpu/drm/etnaviv/etnaviv_dump.c                        |    2=20
 drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c                   |    2=20
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c                     |    6=20
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_fbdev.c             |    1=20
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c                         |   24=20
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c                    |    2=20
 drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c                      |    2=20
 drivers/gpu/drm/msm/dsi/dsi_host.c                            |    6=20
 drivers/gpu/drm/nouveau/nouveau_abi16.c                       |    1=20
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gddr3.c                |    2=20
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/memx.c                |    4=20
 drivers/gpu/drm/panel/panel-lvds.c                            |   21=20
 drivers/gpu/drm/radeon/cik.c                                  |    4=20
 drivers/gpu/drm/radeon/r600.c                                 |    4=20
 drivers/gpu/drm/radeon/si.c                                   |    4=20
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c                        |    2=20
 drivers/gpu/drm/rcar-du/rcar_du_kms.c                         |    2=20
 drivers/gpu/drm/rcar-du/rcar_lvds.c                           |    8=20
 drivers/gpu/drm/shmobile/shmob_drm_drv.c                      |    4=20
 drivers/gpu/drm/sti/sti_hda.c                                 |    1=20
 drivers/gpu/drm/sti/sti_hdmi.c                                |    1=20
 drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c                   |    2=20
 drivers/gpu/drm/virtio/virtgpu_vq.c                           |    5=20
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c                        |    6=20
 drivers/gpu/drm/xen/xen_drm_front_gem.c                       |   13=20
 drivers/hwmon/lm75.c                                          |    2=20
 drivers/hwmon/pmbus/tps53679.c                                |    9=20
 drivers/hwmon/shtc1.c                                         |    2=20
 drivers/hwmon/w83627hf.c                                      |   42 -
 drivers/hwtracing/coresight/coresight-catu.h                  |    5=20
 drivers/hwtracing/coresight/coresight-etm-perf.c              |    7=20
 drivers/hwtracing/coresight/coresight-tmc-etr.c               |    5=20
 drivers/i2c/busses/i2c-stm32.c                                |   16=20
 drivers/i2c/busses/i2c-stm32f7.c                              |   13=20
 drivers/iio/dac/ad5380.c                                      |    2=20
 drivers/iio/light/tsl2772.c                                   |   16=20
 drivers/infiniband/core/cma.c                                 |    2=20
 drivers/infiniband/core/uverbs_uapi.c                         |    2=20
 drivers/infiniband/hw/bnxt_re/ib_verbs.c                      |    1=20
 drivers/infiniband/hw/bnxt_re/qplib_fp.c                      |    1=20
 drivers/infiniband/hw/cxgb4/cm.c                              |   24=20
 drivers/infiniband/hw/hfi1/chip.c                             |   26=20
 drivers/infiniband/hw/hfi1/driver.c                           |   70 +
 drivers/infiniband/hw/hfi1/hfi.h                              |   35=20
 drivers/infiniband/hw/hfi1/pio.c                              |    5=20
 drivers/infiniband/hw/hfi1/rc.c                               |   32=20
 drivers/infiniband/hw/hfi1/uc.c                               |    2=20
 drivers/infiniband/hw/hfi1/ud.c                               |   33=20
 drivers/infiniband/hw/hfi1/verbs.c                            |    4=20
 drivers/infiniband/hw/hns/hns_roce_hem.c                      |   19=20
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                    |    6=20
 drivers/infiniband/hw/hns/hns_roce_qp.c                       |    1=20
 drivers/infiniband/hw/mlx5/ib_rep.c                           |    4=20
 drivers/infiniband/hw/mlx5/main.c                             |   53 -
 drivers/infiniband/hw/mlx5/qp.c                               |   21=20
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c                   |    2=20
 drivers/infiniband/hw/qedr/verbs.c                            |   27=20
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c                  |    2=20
 drivers/infiniband/sw/rxe/rxe_cq.c                            |    4=20
 drivers/infiniband/sw/rxe/rxe_net.c                           |    3=20
 drivers/infiniband/sw/rxe/rxe_pool.c                          |   26=20
 drivers/infiniband/sw/rxe/rxe_qp.c                            |    5=20
 drivers/infiniband/ulp/iser/iscsi_iser.h                      |    2=20
 drivers/infiniband/ulp/iser/iser_memory.c                     |   10=20
 drivers/input/keyboard/nomadik-ske-keypad.c                   |    2=20
 drivers/iommu/amd_iommu.c                                     |    2=20
 drivers/iommu/amd_iommu_init.c                                |    3=20
 drivers/iommu/intel-iommu.c                                   |   39=20
 drivers/iommu/intel-svm.c                                     |    2=20
 drivers/iommu/iommu-debugfs.c                                 |   23=20
 drivers/iommu/iommu.c                                         |    8=20
 drivers/iommu/mtk_iommu.c                                     |   26=20
 drivers/leds/led-triggers.c                                   |    4=20
 drivers/lightnvm/pblk-rb.c                                    |    2=20
 drivers/mailbox/mtk-cmdq-mailbox.c                            |    3=20
 drivers/mailbox/qcom-apcs-ipc-mailbox.c                       |    2=20
 drivers/mailbox/ti-msgmgr.c                                   |    2=20
 drivers/md/bcache/debug.c                                     |    5=20
 drivers/media/i2c/ov2659.c                                    |    2=20
 drivers/media/i2c/tw9910.c                                    |    2=20
 drivers/media/pci/cx18/cx18-fileops.c                         |    2=20
 drivers/media/pci/cx23885/cx23885-dvb.c                       |    5=20
 drivers/media/pci/ivtv/ivtv-fileops.c                         |    2=20
 drivers/media/pci/pt1/pt1.c                                   |   54 +
 drivers/media/pci/tw5864/tw5864-video.c                       |    4=20
 drivers/media/platform/atmel/atmel-isi.c                      |    2=20
 drivers/media/platform/davinci/isif.c                         |    9=20
 drivers/media/platform/davinci/vpbe.c                         |    2=20
 drivers/media/platform/omap/omap_vout.c                       |   15=20
 drivers/media/platform/rcar-vin/rcar-core.c                   |    2=20
 drivers/media/platform/s5p-jpeg/jpeg-core.c                   |    2=20
 drivers/media/platform/vivid/vivid-osd.c                      |    2=20
 drivers/media/radio/wl128x/fmdrv_common.c                     |    5=20
 drivers/media/usb/em28xx/em28xx-core.c                        |    2=20
 drivers/memory/tegra/mc.c                                     |   11=20
 drivers/mfd/intel-lpss-pci.c                                  |   28=20
 drivers/mfd/intel-lpss.c                                      |    1=20
 drivers/misc/aspeed-lpc-snoop.c                               |    4=20
 drivers/misc/mei/main.c                                       |    4=20
 drivers/misc/mic/card/mic_x100.c                              |   28=20
 drivers/misc/sgi-xp/xpc_partition.c                           |    2=20
 drivers/mmc/core/host.c                                       |    2=20
 drivers/mmc/core/quirks.h                                     |    7=20
 drivers/mmc/host/sdhci-brcmstb.c                              |    4=20
 drivers/net/dsa/b53/b53_common.c                              |   90 +-
 drivers/net/dsa/b53/b53_priv.h                                |    3=20
 drivers/net/dsa/qca8k.c                                       |   12=20
 drivers/net/dsa/qca8k.h                                       |    1=20
 drivers/net/ethernet/amazon/ena/ena_com.c                     |    3=20
 drivers/net/ethernet/amazon/ena/ena_ethtool.c                 |    4=20
 drivers/net/ethernet/amazon/ena/ena_netdev.c                  |    1=20
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c               |   15=20
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c     |    4=20
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c     |    4=20
 drivers/net/ethernet/broadcom/bcmsysport.c                    |    2=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                     |    1=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c                 |    2=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c             |   20=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c               |    2=20
 drivers/net/ethernet/chelsio/cxgb4/smt.c                      |    4=20
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c                |   47 -
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c                 |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c               |   17=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c       |   21=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h       |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c        |    4=20
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c     |    5=20
 drivers/net/ethernet/ibm/ehea/ehea_main.c                     |    2=20
 drivers/net/ethernet/intel/i40e/i40e_common.c                 |   91 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c                |    4=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                 |   16=20
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c               |   11=20
 drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c           |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c             |    6=20
 drivers/net/ethernet/mellanox/mlx5/core/qp.c                  |    5=20
 drivers/net/ethernet/mellanox/mlxsw/reg.h                     |   22=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c                |   25=20
 drivers/net/ethernet/natsemi/sonic.c                          |    6=20
 drivers/net/ethernet/netronome/nfp/bpf/jit.c                  |   13=20
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h             |    2=20
 drivers/net/ethernet/ni/nixge.c                               |    2=20
 drivers/net/ethernet/pasemi/pasemi_mac.c                      |    2=20
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c                   |   17=20
 drivers/net/ethernet/qlogic/qed/qed_l2.c                      |   34=20
 drivers/net/ethernet/qualcomm/qca_spi.c                       |    9=20
 drivers/net/ethernet/qualcomm/qca_spi.h                       |    1=20
 drivers/net/ethernet/renesas/sh_eth.c                         |    6=20
 drivers/net/ethernet/socionext/netsec.c                       |   20=20
 drivers/net/ethernet/socionext/sni_ave.c                      |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c           |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c           |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c             |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c                  |    1=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c              |    2=20
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c             |    2=20
 drivers/net/hyperv/hyperv_net.h                               |    3=20
 drivers/net/hyperv/netvsc.c                                   |   38=20
 drivers/net/hyperv/netvsc_drv.c                               |   13=20
 drivers/net/phy/fixed_phy.c                                   |    6=20
 drivers/net/phy/mdio_bus.c                                    |   11=20
 drivers/net/phy/micrel.c                                      |    1=20
 drivers/net/phy/phy_device.c                                  |   13=20
 drivers/net/vxlan.c                                           |    7=20
 drivers/net/wireless/ath/ath10k/mac.c                         |    4=20
 drivers/net/wireless/ath/ath10k/sdio.c                        |   29=20
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                     |    2=20
 drivers/net/wireless/ath/ath10k/wmi.c                         |    4=20
 drivers/net/wireless/ath/ath9k/dynack.c                       |    8=20
 drivers/net/wireless/ath/wcn36xx/smd.c                        |  186 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c     |    8=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h        |   10=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c       |    1=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c       |   12=20
 drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h           |   14=20
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c            |   10=20
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                   |   12=20
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c                 |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                  |   19=20
 drivers/net/wireless/marvell/libertas_tf/cmd.c                |    2=20
 drivers/net/wireless/mediatek/mt76/usb.c                      |   14=20
 drivers/net/wireless/mediatek/mt7601u/phy.c                   |    2=20
 drivers/net/wireless/realtek/rtlwifi/debug.c                  |    2=20
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c           |   71 -
 drivers/ntb/hw/idt/ntb_hw_idt.c                               |    8=20
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c                        |    4=20
 drivers/nvme/host/pci.c                                       |    2=20
 drivers/nvmem/imx-ocotp.c                                     |   39=20
 drivers/of/of_mdio.c                                          |    2=20
 drivers/opp/core.c                                            |   12=20
 drivers/opp/of.c                                              |   20=20
 drivers/opp/opp.h                                             |    6=20
 drivers/pci/controller/dwc/pcie-designware-ep.c               |   10=20
 drivers/pci/controller/pcie-iproc.c                           |   10=20
 drivers/pci/controller/pcie-mobiveil.c                        |    8=20
 drivers/pci/controller/pcie-rockchip-ep.c                     |    2=20
 drivers/pci/endpoint/functions/pci-epf-test.c                 |    4=20
 drivers/pci/pci-driver.c                                      |   16=20
 drivers/pci/pci.c                                             |   54 -
 drivers/pci/switch/switchtec.c                                |    4=20
 drivers/phy/broadcom/phy-brcm-usb.c                           |    8=20
 drivers/phy/qualcomm/phy-qcom-qusb2.c                         |    2=20
 drivers/pinctrl/bcm/pinctrl-iproc-gpio.c                      |   96 +-
 drivers/pinctrl/meson/pinctrl-meson-gxl.c                     |   12=20
 drivers/pinctrl/sh-pfc/pfc-emev2.c                            |   20=20
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c                          |    3=20
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c                          |    8=20
 drivers/pinctrl/sh-pfc/pfc-r8a7792.c                          |    1=20
 drivers/pinctrl/sh-pfc/pfc-r8a7794.c                          |    2=20
 drivers/pinctrl/sh-pfc/pfc-r8a77970.c                         |    2=20
 drivers/pinctrl/sh-pfc/pfc-r8a77980.c                         |    2=20
 drivers/pinctrl/sh-pfc/pfc-r8a77995.c                         |    8=20
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                           |    2=20
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c                           |    4=20
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                           |    4=20
 drivers/platform/mips/cpu_hwmon.c                             |    2=20
 drivers/platform/x86/alienware-wmi.c                          |   19=20
 drivers/platform/x86/wmi.c                                    |    3=20
 drivers/power/supply/power_supply_core.c                      |   10=20
 drivers/pwm/pwm-lpss.c                                        |    6=20
 drivers/pwm/pwm-meson.c                                       |    9=20
 drivers/rapidio/rio_cm.c                                      |    4=20
 drivers/regulator/lp87565-regulator.c                         |    2=20
 drivers/regulator/pv88060-regulator.c                         |    2=20
 drivers/regulator/pv88080-regulator.c                         |    2=20
 drivers/regulator/pv88090-regulator.c                         |    2=20
 drivers/regulator/tps65086-regulator.c                        |    4=20
 drivers/regulator/wm831x-dcdc.c                               |    4=20
 drivers/remoteproc/qcom_q6v5_pil.c                            |   12=20
 drivers/rtc/rtc-88pm80x.c                                     |   21=20
 drivers/rtc/rtc-88pm860x.c                                    |   21=20
 drivers/rtc/rtc-ds1307.c                                      |    7=20
 drivers/rtc/rtc-ds1672.c                                      |    3=20
 drivers/rtc/rtc-mc146818-lib.c                                |    2=20
 drivers/rtc/rtc-mt6397.c                                      |    9=20
 drivers/rtc/rtc-pcf2127.c                                     |   32=20
 drivers/rtc/rtc-pcf8563.c                                     |   13=20
 drivers/rtc/rtc-pm8xxx.c                                      |    6=20
 drivers/rtc/rtc-rv3029c2.c                                    |   16=20
 drivers/s390/net/qeth_l2_main.c                               |   23=20
 drivers/scsi/fnic/fnic_isr.c                                  |    4=20
 drivers/scsi/libfc/fc_exch.c                                  |    2=20
 drivers/scsi/megaraid/megaraid_sas_base.c                     |    4=20
 drivers/scsi/qla2xxx/qla_os.c                                 |   34=20
 drivers/scsi/qla2xxx/qla_target.c                             |   21=20
 drivers/soc/amlogic/meson-gx-pwrc-vpu.c                       |    8=20
 drivers/soc/amlogic/meson-gx-socinfo.c                        |   32=20
 drivers/soc/fsl/qe/gpio.c                                     |    4=20
 drivers/soc/qcom/cmd-db.c                                     |    4=20
 drivers/spi/spi-bcm-qspi.c                                    |    4=20
 drivers/spi/spi-bcm2835aux.c                                  |   13=20
 drivers/spi/spi-cadence.c                                     |   11=20
 drivers/spi/spi-fsl-spi.c                                     |    2=20
 drivers/spi/spi-tegra114.c                                    |  145 ++-
 drivers/spi/spi-topcliff-pch.c                                |    6=20
 drivers/staging/android/vsoc.c                                |    3=20
 drivers/staging/comedi/drivers/ni_mio_common.c                |   24=20
 drivers/staging/greybus/light.c                               |   12=20
 drivers/staging/most/cdev/cdev.c                              |    5=20
 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c |    5=20
 drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c |   10=20
 drivers/target/target_core_device.c                           |    4=20
 drivers/thermal/cpu_cooling.c                                 |    2=20
 drivers/thermal/mtk_thermal.c                                 |    6=20
 drivers/thermal/rcar_gen3_thermal.c                           |   38=20
 drivers/tty/ipwireless/hardware.c                             |    2=20
 drivers/tty/serial/fsl_lpuart.c                               |   28=20
 drivers/tty/serial/stm32-usart.c                              |  194 +++-
 drivers/tty/serial/stm32-usart.h                              |   14=20
 drivers/uio/uio.c                                             |   10=20
 drivers/usb/class/cdc-wdm.c                                   |    2=20
 drivers/usb/dwc2/gadget.c                                     |    1=20
 drivers/usb/dwc3/Kconfig                                      |    4=20
 drivers/usb/gadget/udc/fsl_udc_core.c                         |   30=20
 drivers/usb/host/xhci-hub.c                                   |    2=20
 drivers/usb/phy/Kconfig                                       |    2=20
 drivers/usb/phy/phy-twl6030-usb.c                             |    2=20
 drivers/usb/typec/Kconfig                                     |    1=20
 drivers/usb/typec/fusb302/fusb302.c                           |   10=20
 drivers/usb/typec/tcpci.c                                     |   10=20
 drivers/usb/typec/tcpm.c                                      |   32=20
 drivers/usb/typec/typec_wcove.c                               |   10=20
 drivers/vfio/mdev/mdev_core.c                                 |   11=20
 drivers/vfio/mdev/mdev_sysfs.c                                |    2=20
 drivers/vfio/pci/vfio_pci.c                                   |   19=20
 drivers/vhost/test.c                                          |    2=20
 drivers/video/backlight/lm3630a_bl.c                          |    4=20
 drivers/video/backlight/pwm_bl.c                              |   24=20
 drivers/video/fbdev/chipsfb.c                                 |    3=20
 drivers/watchdog/rtd119x_wdt.c                                |    2=20
 drivers/watchdog/sprd_wdt.c                                   |    6=20
 drivers/xen/cpu_hotplug.c                                     |    2=20
 drivers/xen/pvcalls-back.c                                    |    2=20
 fs/affs/super.c                                               |    6=20
 fs/afs/callback.c                                             |    8=20
 fs/afs/dir_edit.c                                             |   12=20
 fs/afs/file.c                                                 |    7=20
 fs/afs/flock.c                                                |  412 ++++-=
-----
 fs/afs/inode.c                                                |    8=20
 fs/afs/rxrpc.c                                                |    1=20
 fs/afs/security.c                                             |    4=20
 fs/afs/super.c                                                |    1=20
 fs/afs/xattr.c                                                |    4=20
 fs/btrfs/file.c                                               |    3=20
 fs/btrfs/inode-map.c                                          |   28=20
 fs/ceph/xattr.c                                               |    2=20
 fs/cifs/connect.c                                             |    3=20
 fs/exportfs/expfs.c                                           |    1=20
 fs/ext4/inline.c                                              |    2=20
 fs/f2fs/dir.c                                                 |    5=20
 fs/f2fs/f2fs.h                                                |    3=20
 fs/f2fs/inline.c                                              |    6=20
 fs/jfs/jfs_txnmgr.c                                           |    3=20
 fs/nfs/delegation.c                                           |   20=20
 fs/nfs/delegation.h                                           |    1=20
 fs/nfs/flexfilelayout/flexfilelayout.h                        |   32=20
 fs/nfs/nfs42xdr.c                                             |   10=20
 fs/nfs/pnfs.c                                                 |   33=20
 fs/nfs/pnfs.h                                                 |    1=20
 fs/nfs/super.c                                                |    2=20
 fs/nfs/write.c                                                |    2=20
 fs/xfs/xfs_quotaops.c                                         |    3=20
 include/drm/drm_panel.h                                       |    1=20
 include/linux/acpi.h                                          |   12=20
 include/linux/device.h                                        |    6=20
 include/linux/irqchip/arm-gic-v3.h                            |   12=20
 include/linux/mlx5/mlx5_ifc.h                                 |    2=20
 include/linux/mmc/sdio_ids.h                                  |    2=20
 include/linux/of.h                                            |    5=20
 include/linux/perf_event.h                                    |    7=20
 include/linux/platform_data/dma-imx-sdma.h                    |    3=20
 include/linux/rtc.h                                           |    2=20
 include/linux/signal.h                                        |   15=20
 include/linux/switchtec.h                                     |    4=20
 include/linux/usb/tcpm.h                                      |   13=20
 include/media/davinci/vpbe.h                                  |    2=20
 include/net/request_sock.h                                    |    4=20
 include/net/sctp/sctp.h                                       |    5=20
 include/net/tcp.h                                             |    2=20
 include/net/xfrm.h                                            |    1=20
 include/sound/soc.h                                           |    2=20
 include/trace/events/rxrpc.h                                  |    6=20
 include/uapi/linux/btf.h                                      |    4=20
 include/uapi/linux/netfilter/nf_tables.h                      |    2=20
 kernel/bpf/offload.c                                          |    4=20
 kernel/bpf/verifier.c                                         |    2=20
 kernel/debug/kdb/kdb_main.c                                   |    2=20
 kernel/events/core.c                                          |  126 +--
 kernel/fork.c                                                 |   16=20
 kernel/irq/irqdomain.c                                        |    3=20
 kernel/signal.c                                               |    5=20
 lib/devres.c                                                  |    3=20
 lib/kfifo.c                                                   |    3=20
 net/6lowpan/nhc.c                                             |    2=20
 net/bpfilter/bpfilter_kern.c                                  |    2=20
 net/bridge/br_arp_nd_proxy.c                                  |    2=20
 net/bridge/netfilter/ebtables.c                               |    4=20
 net/core/dev.c                                                |   73 -
 net/core/filter.c                                             |    2=20
 net/core/neighbour.c                                          |    4=20
 net/core/sock.c                                               |    4=20
 net/dsa/port.c                                                |    7=20
 net/dsa/slave.c                                               |    8=20
 net/ieee802154/6lowpan/reassembly.c                           |    2=20
 net/ipv4/af_inet.c                                            |    2=20
 net/ipv4/inet_connection_sock.c                               |    2=20
 net/ipv4/ip_output.c                                          |    3=20
 net/ipv4/ip_tunnel.c                                          |    5=20
 net/ipv4/tcp.c                                                |    4=20
 net/ipv4/udp_offload.c                                        |    5=20
 net/ipv6/ip6_fib.c                                            |    3=20
 net/ipv6/ip6_gre.c                                            |    1=20
 net/ipv6/ip6_output.c                                         |    3=20
 net/ipv6/raw.c                                                |    2=20
 net/ipv6/reassembly.c                                         |    2=20
 net/iucv/af_iucv.c                                            |   40=20
 net/l2tp/l2tp_core.c                                          |    3=20
 net/llc/af_llc.c                                              |   34=20
 net/llc/llc_conn.c                                            |   35=20
 net/llc/llc_if.c                                              |   12=20
 net/mac80211/rc80211_minstrel_ht.c                            |    2=20
 net/mac80211/rx.c                                             |   11=20
 net/mpls/mpls_iptunnel.c                                      |    2=20
 net/netfilter/nf_conntrack_netlink.c                          |    7=20
 net/netfilter/nf_flow_table_core.c                            |    9=20
 net/netfilter/nft_flow_offload.c                              |    3=20
 net/netfilter/nft_osf.c                                       |   10=20
 net/netfilter/nft_set_hash.c                                  |   25=20
 net/packet/af_packet.c                                        |   25=20
 net/rds/ib_stats.c                                            |    2=20
 net/rds/stats.c                                               |    2=20
 net/rxrpc/af_rxrpc.c                                          |    3=20
 net/rxrpc/ar-internal.h                                       |    2=20
 net/rxrpc/call_accept.c                                       |    2=20
 net/rxrpc/conn_client.c                                       |   50 +
 net/rxrpc/conn_object.c                                       |   15=20
 net/rxrpc/conn_service.c                                      |    2=20
 net/rxrpc/input.c                                             |   18=20
 net/rxrpc/local_object.c                                      |    5=20
 net/rxrpc/output.c                                            |    3=20
 net/sched/act_csum.c                                          |   31=20
 net/sched/act_mirred.c                                        |    6=20
 net/sched/sch_cbs.c                                           |  108 ++
 net/sched/sch_netem.c                                         |   18=20
 net/sctp/input.c                                              |   12=20
 net/smc/smc_diag.c                                            |    3=20
 net/smc/smc_rx.c                                              |   29=20
 net/sunrpc/auth_gss/svcauth_gss.c                             |   84 +-
 net/sunrpc/xprtrdma/verbs.c                                   |    3=20
 net/tipc/link.c                                               |   29=20
 net/tipc/monitor.c                                            |   15=20
 net/tipc/monitor.h                                            |    1=20
 net/tipc/name_distr.c                                         |   18=20
 net/tipc/name_table.c                                         |    1=20
 net/tipc/name_table.h                                         |    1=20
 net/tipc/net.c                                                |    2=20
 net/tipc/node.c                                               |    7=20
 net/tipc/socket.c                                             |    2=20
 net/tipc/sysctl.c                                             |    8=20
 net/tls/tls_device_fallback.c                                 |    4=20
 net/wireless/reg.c                                            |    9=20
 net/xdp/xdp_umem.c                                            |    6=20
 net/xdp/xsk.c                                                 |   21=20
 net/xfrm/xfrm_interface.c                                     |   10=20
 samples/bpf/xdp_rxq_info_user.c                               |    6=20
 security/apparmor/include/cred.h                              |    2=20
 security/apparmor/lsm.c                                       |    4=20
 security/apparmor/net.c                                       |   15=20
 security/keys/key.c                                           |    1=20
 sound/aoa/codecs/onyx.c                                       |    4=20
 sound/pci/hda/hda_controller.h                                |    9=20
 sound/sh/aica.c                                               |   14=20
 sound/soc/codecs/cs4349.c                                     |    1=20
 sound/soc/codecs/es8328.c                                     |    2=20
 sound/soc/codecs/wm8737.c                                     |    2=20
 sound/soc/codecs/wm9705.c                                     |   10=20
 sound/soc/codecs/wm9712.c                                     |   13=20
 sound/soc/codecs/wm9713.c                                     |   10=20
 sound/soc/davinci/davinci-mcasp.c                             |   13=20
 sound/soc/fsl/imx-sgtl5000.c                                  |    3=20
 sound/soc/meson/axg-tdmin.c                                   |    1=20
 sound/soc/meson/axg-tdmout.c                                  |    1=20
 sound/soc/qcom/apq8016_sbc.c                                  |   21=20
 sound/soc/soc-pcm.c                                           |    4=20
 sound/soc/sunxi/sun4i-i2s.c                                   |    4=20
 sound/soc/sunxi/sun8i-codec.c                                 |    6=20
 sound/usb/mixer.c                                             |    4=20
 sound/usb/quirks-table.h                                      |    9=20
 tools/bpf/bpftool/btf_dumper.c                                |    8=20
 tools/bpf/bpftool/cgroup.c                                    |    6=20
 tools/bpf/bpftool/map_perf_ring.c                             |    4=20
 tools/perf/util/machine.c                                     |   27=20
 tools/testing/selftests/ipc/msgque.c                          |   11=20
 625 files changed, 4661 insertions(+), 3140 deletions(-)

Adam Ford (2):
      ARM: dts: logicpd-som-lv: Fix MMC1 card detect
      ARM: dts: logicpd-som-lv: Fix i2c2 and i2c3 Pin mux

Akihiro Tsukada (1):
      media: dvb/earth-pt1: fix wrong initialization for demod blocks

Akinobu Mita (1):
      media: ov2659: fix unbalanced mutex_lock/unlock

Alain Volmat (3):
      i2c: stm32f7: rework slave_id allocation
      i2c: i2c-stm32f7: fix 10-bits check in slave free id search loop
      i2c: stm32f7: report dma error during probe

Alex Estrin (1):
      IB/hfi1: Add mtu check for operational data VLs

Alex Williamson (1):
      PCI: Fix "try" semantics of bus and slot reset

Alexander Shishkin (3):
      perf: Copy parent's address filter offsets on clone
      perf, pt, coresight: Fix address filters for vmas with non-zero offset
      perf/core: Fix the address filtering fix

Alexandra Winter (2):
      s390/qeth: Fix error handling during VNICC initialization
      s390/qeth: Fix initialization of vnicc cmd masks during set online

Alexandre Kroupski (1):
      media: atmel: atmel-isi: fix timeout value for stop streaming

Alexandru Ardelean (1):
      dmaengine: axi-dmac: Don't check the number of frames for alignment

Alexei Starovoitov (1):
      bpf: fix BTF limits

Alexey Kardashevskiy (2):
      KVM: PPC: Release all hardware TCE tables attached to a group
      KVM: PPC: Book3S HV: Fix lockdep warning when entering the guest

Anders Roxell (1):
      ALSA: hda: fix unused variable warning

Andre Przywara (1):
      arm64: dts: juno: Fix UART frequency

Andrea Arcangeli (1):
      fork,memcg: alloc_thread_stack_node needs to set tsk->stack

Andrey Ignatov (1):
      bpf: Add missed newline in verifier verbose log

Andrey Smirnov (1):
      tty: serial: fsl_lpuart: Use appropriate lpuart32_* I/O funcs

Andy Shevchenko (4):
      dmaengine: hsu: Revert "set HSU_CH_MTSR to memory width"
      mfd: intel-lpss: Release IDA resources
      dmaengine: dw: platform: Switch to acpi_dma_controller_register()
      ahci: Do not export local variable ahci_em_messages

Aneesh Kumar K.V (1):
      powerpc/mm/mce: Keep irqs disabled during lockless page table walk

Anna Schumaker (1):
      NFS: Add missing encode / decode sequence_maxsz to v4.2 operations

Antoine Tenart (2):
      crypto: inside-secure - fix zeroing of the request in ahash_exit_inv
      crypto: inside-secure - fix queued len computation

Anton Ivanov (1):
      um: Fix off by one error in IRQ enumeration

Anton Protopopov (1):
      bpf: fix the check that forwarding is enabled in bpf_ipv6_fib_lookup

Antonio Borneo (2):
      net: stmmac: fix length of PTP clock's name string
      net: stmmac: fix disabling flexible PPS output

Ard Biesheuvel (2):
      powerpc/archrandom: fix arch_get_random_seed_int()
      nvme: retain split access workaround for capability reads

Arend van Spriel (1):
      brcmfmac: create debugfs files for bus-specific layer

Arnaldo Carvalho de Melo (1):
      perf map: No need to adjust the long name of modules

Arnd Bergmann (15):
      ASoC: wm9712: fix unused variable warning
      usb: dwc3: add EXTCON dependency for qcom
      ASoC: wm97xx: fix uninitialized regmap pointer problem
      crypto: ccree - reduce kernel stack usage with clang
      jfs: fix bogus variable self-initialization
      media: davinci-isif: avoid uninitialized variable use
      coresight: catu: fix clang build warning
      usb: gadget: fsl: fix link error against usb-gadget module
      devres: allow const resource arguments
      x86/pgtable/32: Fix LOWMEM_PAGES constant
      qed: reduce maximum stack frame size
      mic: avoid statically declaring a 'struct device'.
      crypto: ccp - Reduce maximum stack usage
      i40e: reduce stack usage in i40e_set_fc
      wcn36xx: use dynamic allocation for large variables

Axel Lin (6):
      regulator: pv88060: Fix array out-of-bounds access
      regulator: pv88080: Fix array out-of-bounds access
      regulator: pv88090: Fix array out-of-bounds access
      regulator: wm831x-dcdc: Fix list of wm831x_dcdc_ilim from mA to uA
      regulator: lp87565: Fix missing register for LP87565_BUCK_0
      regulator: tps65086: Fix tps65086_ldoa1_ranges for selector 0xB

Bart Van Assche (5):
      scsi: qla2xxx: Unregister chrdev if module initialization fails
      scsi: target/core: Fix a race condition in the LUN lookup code
      scsi: qla2xxx: Fix a format specifier
      scsi: qla2xxx: Fix error handling in qlt_alloc_qfull_cmd()
      scsi: qla2xxx: Avoid that qlt_send_resp_ctio() corrupts memory

Ben Hutchings (1):
      powerpc: vdso: Make vdso32 installation conditional in vdso_install

Bichao Zheng (1):
      pwm: meson: Don't disable PWM when setting duty repeatedly

Biju Das (1):
      ARM: dts: r8a7743: Remove generic compatible string from iic3

Bj=F6rn T=F6pel (2):
      xsk: avoid store-tearing when assigning queues
      xsk: avoid store-tearing when assigning umem

Borut Seljak (1):
      serial: stm32: fix a recursive locking in stm32_config_rs485

Brian Masney (1):
      backlight: lm3630a: Return 0 on success in update_status functions

Bruno Thomsen (1):
      rtc: pcf2127: bugfix: read rtc disables watchdog

Bryan O'Donoghue (2):
      nvmem: imx-ocotp: Ensure WAIT bits are preserved when setting timing
      nvmem: imx-ocotp: Change TIMING calculation to u-boot algorithm

Chao Yu (3):
      f2fs: fix wrong error injection path in inc_valid_block_count()
      f2fs: fix error path of f2fs_convert_inline_page()
      f2fs: fix to avoid accessing uninitialized field of inode page in is_=
alive()

Charles Keepax (1):
      spi: cadence: Correct initialisation of runtime PM

Chen-Yu Tsai (7):
      ARM: dts: sun8i-a23-a33: Move NAND controller device node to sort by =
address
      clk: sunxi-ng: sun8i-a23: Enable PLL-MIPI LDOs when ungating it
      arm64: dts: allwinner: h6: Move GIC device node fix base address orde=
ring
      clocksource/drivers/sun5i: Fail gracefully when clock rate is unavail=
able
      rtc: pcf8563: Fix interrupt trigger method
      rtc: pcf8563: Clear event flags and disable interrupts before request=
ing irq
      arm64: dts: allwinner: h6: Pine H64: Add interrupt line for RTC

Chris Packham (1):
      of: use correct function prototype for of_overlay_fdt_apply()

Christian Hewitt (3):
      arm64: dts: meson-gxm-khadas-vim2: fix gpio-keys-polled node
      arm64: dts: meson-gxm-khadas-vim2: fix Bluetooth support
      arm64: dts: meson-gxm-khadas-vim2: fix uart_A bluetooth node

Christophe JAILLET (1):
      drm: rcar-du: Fix the return value in case of error in 'rcar_du_crtc_=
set_crc_source()'

Christophe Leroy (3):
      powerpc/kgdb: add kgdb_arch_set/remove_breakpoint()
      spi: spi-fsl-spi: call spi_finalize_current_message() at the end
      crypto: talitos - fix AEAD processing.

Chuck Lever (2):
      SUNRPC: Fix svcauth_gss_proxy_init()
      xprtrdma: Fix use-after-free in rpcrdma_post_recvs

Chuhong Yuan (3):
      iio: tsl2772: Use devm_add_action_or_reset for tsl2772_chip_off
      cxgb4: smt: Add lock for atomic_dec_and_test
      dmaengine: ti: edma: fix missed failure handling

Colin Ian King (20):
      drm/msm: fix unsigned comparison with less than zero
      rtlwifi: rtl8821ae: replace _rtl8821ae_mrate_idx_to_arfr_id with gene=
ric version
      pcrypt: use format specifier in kobject_add
      staging: most: cdev: add missing check for cdev_add failure
      rtc: ds1672: fix unintended sign extension
      rtc: 88pm860x: fix unintended sign extension
      rtc: 88pm80x: fix unintended sign extension
      rtc: pm8xxx: fix unintended sign extension
      drm/nouveau/bios/ramcfg: fix missing parentheses when calculating RON
      drm/nouveau/pmu: don't print reply values if exec is false
      drm/nouveau: fix missing break in switch statement
      brcmfmac: fix leak of mypkt on error return path
      PCI: rockchip: Fix rockchip_pcie_ep_assert_intx() bitwise operations
      platform/x86: alienware-wmi: fix kfree on potentially uninitialized p=
ointer
      phy: qcom-qusb2: fix missing assignment of ret when calling clk_prepa=
re_enable
      media: vivid: fix incorrect assignment operation when setting video m=
ode
      scsi: libfc: fix null pointer dereference on a null lport
      ext4: set error return correctly when ext4_htree_store_dirent fails
      bcma: fix incorrect update of BCMA_CORE_PCI_MDIO_DATA
      iio: dac: ad5380: fix incorrect assignment to val

Corentin Labbe (2):
      crypto: sun4i-ss - fix big endian issues
      crypto: crypto4xx - Fix wrong ppc4xx_trng_probe()/ppc4xx_trng_remove(=
) arguments

Dan Carpenter (36):
      drm/virtio: fix bounds check in virtio_gpu_cmd_get_capset()
      mailbox: ti-msgmgr: Off by one in ti_msgmgr_of_xlate()
      Input: nomadik-ske-keypad - fix a loop timeout test
      drm/etnaviv: fix some off by one bugs
      drm/etnaviv: NULL vs IS_ERR() buf in etnaviv_core_dump()
      drm/etnaviv: potential NULL dereference
      drivers/rapidio/rio_cm.c: fix potential oops in riocm_ch_listen()
      xen, cpu_hotplug: Prevent an out of bounds access
      media: ivtv: update *pos correctly in ivtv_read_pos()
      media: cx18: update *pos correctly in cx18_read_pos()
      media: wl128x: Fix an error code in fm_download_firmware()
      soc: qcom: cmd-db: Fix an error code in cmd_db_dev_probe()
      soc/fsl/qe: Fix an error code in qe_pin_request()
      6lowpan: Off by one handling ->nexthdr
      media: omap_vout: potential buffer overflow in vidioc_dqbuf()
      media: davinci/vpbe: array underflow in vpbe_enum_outputs()
      platform/x86: alienware-wmi: printing the wrong error code
      kdb: do a sanity check on the cpu in kdb_per_cpu()
      RDMA/uverbs: check for allocation failure in uapi_add_elm()
      ntb_hw_switchtec: potential shift wrapping bug in switchtec_ntb_init_=
sndev()
      rtc: rv3029: revert error handling patch to rv3029_eeprom_write()
      staging: greybus: light: fix a couple double frees
      bcache: Fix an error code in bch_dump_read()
      net: aquantia: Fix aq_vec_isr_legacy() return value
      cxgb4: Signedness bug in init_one()
      net: hisilicon: Fix signedness bug in hix5hd2_dev_probe()
      net: broadcom/bcmsysport: Fix signedness in bcm_sysport_probe()
      net: netsec: Fix signedness bug in netsec_probe()
      net: socionext: Fix a signedness bug in ave_probe()
      net: stmmac: dwmac-meson8b: Fix signedness bug in probe
      net: axienet: fix a signedness bug in probe
      of: mdio: Fix a signedness bug in of_phy_get_and_connect()
      net: nixge: Fix a signedness bug in nixge_probe()
      net: ethernet: stmmac: Fix signedness bug in ipq806x_gmac_of_parse()
      bpf, offload: Unlock on error in bpf_offload_dev_create()
      drm: panel-lvds: Potential Oops in probe error handling

Dan Robertson (1):
      hwmon: (shtc1) fix shtc1 and shtw1 id mask

David Disseldorp (1):
      ceph: fix "ceph.dir.rctime" vxattr value

David Howells (12):
      keys: Timestamp new keys
      afs: Fix AFS file locking to allow fine grained locks
      afs: Further fix file locking
      afs: Fix the afs.cell and afs.volume xattr handlers
      afs: Fix key leak in afs_release() and afs_evict_inode()
      afs: Don't invalidate callback if AFS_VNODE_DIR_VALID not set
      afs: Fix lock-wait/callback-break double locking
      afs: Fix double inc of vnode->cb_break
      rxrpc: Fix uninitialized error code in rxrpc_send_data_packet()
      rxrpc: Fix lack of conn cleanup when local endpoint is cleaned up [ve=
r #2]
      rxrpc: Fix trace-after-put looking at the put connection record
      afs: Fix missing timeout reset

Dexuan Cui (1):
      irqdomain: Add the missing assignment of domain->fwnode for named fwn=
ode

Dirk van der Merwe (1):
      nfp: fix simple vNIC mailbox length

Dmitry Osipenko (1):
      memory: tegra: Don't invoke Tegra30+ specific memory timing setup on =
Tegra20

Eddie James (1):
      fsi: sbefifo: Don't fail operations when in SBE IPL state

Eli Britstein (2):
      net: sched: act_csum: Fix csum calc for tagged packets
      net/mlx5: Fix multiple updates of steering rules in parallel

Eric Auger (2):
      vfio_pci: Enable memory accesses before calling pci_map_rom
      iommu/vt-d: Duplicate iommu_resv_region objects per device list

Eric Biggers (3):
      crypto: tgr192 - fix unaligned memory access
      llc: fix another potential sk_buff leak in llc_ui_sendmsg()
      llc: fix sk_buff refcounting in llc_conn_state_process()

Eric Dumazet (6):
      inet: frags: call inet_frags_fini() after unregister_pernet_subsys()
      net: avoid possible false sharing in sk_leave_memory_pressure()
      net: add {READ|WRITE}_ONCE() annotations on ->rskq_accept_head
      tcp: annotate lockless access to tcp_memory_pressure
      net: neigh: use long type to store jiffies delta
      packet: fix data-race in fanout_flow_is_huge()

Eric W. Biederman (6):
      signal/ia64: Use the generic force_sigsegv in setup_frame
      signal/ia64: Use the force_sig(SIGSEGV,...) in ia64_rt_sigreturn
      fs/nfs: Fix nfs_parse_devname to not modify it's argument
      signal/bpfilter: Fix bpfilter_kernl to use send_sig not force_sig
      signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of for=
ce_sig
      signal: Allow cifs and drbd to receive their terminating signals

Eric Wong (1):
      rtc: cmos: ignore bogus century byte

Erwan Le Ray (6):
      serial: stm32: fix word length configuration
      serial: stm32: fix rx error handling
      serial: stm32: fix rx data length when parity enabled
      serial: stm32: fix transmit_chars when tx is stopped
      serial: stm32: Add support of TC bit status check
      serial: stm32: fix wakeup source initialization

Eugen Hristev (1):
      iio: fix position relative kernel version

Fabrice Gasnier (2):
      ARM: dts: stm32: add missing vdda-supply to adc on stm32h743i-eval
      serial: stm32: fix clearing interrupt error flags

Fabrizio Castro (2):
      ARM: dts: iwg20d-q7-common: Fix SDHI1 VccQ regularor
      drm: rcar-du: lvds: Fix bridge_to_rcar_lvds

Felix Fietkau (1):
      mac80211: minstrel_ht: fix per-group max throughput rate initializati=
on

Feras Daoud (1):
      net/mlx5e: IPoIB, Fix RX checksum statistics update

Fernando Fernandez Mancera (1):
      netfilter: nft_osf: usage from output path is not valid

Filipe Manana (3):
      Btrfs: fix hang when loading existing inode cache off disk
      Btrfs: fix inode cache waiters hanging on failure to start caching th=
read
      Btrfs: fix inode cache waiters hanging on path allocation failure

Filippo Sironi (1):
      iommu/amd: Wait for completion of IOTLB flush in attach_device

Finn Thain (2):
      m68k: mac: Fix VIA timer counter accesses
      m68k: Call timer_interrupt() with interrupts disabled

Firo Yang (1):
      ixgbe: sync the first fragment unconditionally

Florian Fainelli (6):
      net: dsa: b53: Fix default VLAN ID
      net: dsa: b53: Properly account for VLAN filtering
      net: dsa: b53: Do not program CPU port's PVID
      cpufreq: brcmstb-avs-cpufreq: Fix initial command check
      cpufreq: brcmstb-avs-cpufreq: Fix types for voltage/frequency
      phy: usb: phy-brcm-usb: Remove sysfs attributes upon driver removal

Florian Westphal (2):
      netfilter: ebtables: CONFIG_COMPAT: reject trailing data after last r=
ule
      netfilter: nf_tables: correct NFT_LOGLEVEL_MAX value

Frank Rowand (1):
      ARM: qcom_defconfig: Enable MAILBOX

Fred Klassen (1):
      net/udp_gso: Allow TX timestamp with UDP GSO

Gal Pressman (3):
      IB/usnic: Fix out of bounds index check in query pkey
      RDMA/ocrdma: Fix out of bounds index check in query pkey
      RDMA/qedr: Fix out of bounds index check in query pkey

Geert Uytterhoeven (20):
      arm64: dts: renesas: r8a7795-es1: Add missing power domains to IPMMU =
nodes
      pinctrl: sh-pfc: r8a7740: Add missing REF125CK pin to gether_gmii gro=
up
      pinctrl: sh-pfc: r8a7740: Add missing LCD0 marks to lcd0_data24_1 gro=
up
      pinctrl: sh-pfc: r8a7791: Remove bogus ctrl marks from qspi_data4_b g=
roup
      pinctrl: sh-pfc: r8a7791: Remove bogus marks from vin1_b_data18 group
      pinctrl: sh-pfc: sh73a0: Add missing TO pin to tpu4_to3 group
      pinctrl: sh-pfc: r8a7794: Remove bogus IPSR9 field
      pinctrl: sh-pfc: r8a77970: Add missing MOD_SEL0 field
      pinctrl: sh-pfc: r8a77980: Add missing MOD_SEL0 field
      pinctrl: sh-pfc: sh7734: Add missing IPSR11 field
      pinctrl: sh-pfc: r8a77995: Remove bogus SEL_PWM[0-3]_3 configurations
      pinctrl: sh-pfc: sh7269: Add missing PCIOR0 field
      pinctrl: sh-pfc: sh7734: Remove bogus IPSR10 value
      pinctrl: sh-pfc: emev2: Add missing pinmux functions
      pinctrl: sh-pfc: r8a7791: Fix scifb2_data_c pin group
      pinctrl: sh-pfc: r8a7792: Fix vin1_data18_b pin group
      pinctrl: sh-pfc: sh73a0: Fix fsic_spdif pin groups
      iommu: Fix IOMMU debugfs fallout
      rtc: Fix timestamp value for RTC_TIMESTAMP_BEGIN_1900
      ARM: 8896/1: VDSO: Don't leak kernel addresses

George Wilkie (1):
      mpls: fix warning with multi-label encap

Gerd Rausch (2):
      net/rds: Add a few missing rds_stat_names entries
      net/rds: Fix 'ib_evt_handler_call' element in 'rds_ib_stat_names'

Govindarajulu Varadarajan (1):
      scsi: fnic: fix msix interrupt allocation

Greg Kroah-Hartman (2):
      Revert "efi: Fix debugobjects warning on 'efi_rts_work'"
      Linux 4.19.99

Guenter Roeck (4):
      nios2: ksyms: Add missing symbol exports
      hwmon: (w83627hf) Use request_muxed_region for Super-IO accesses
      watchdog: rtd119x_wdt: Fix remove function
      hwmon: (lm75) Fix write operations for negative temperatures

Gustavo A. R. Silva (1):
      NTB: ntb_hw_idt: replace IS_ERR_OR_NULL with regular NULL checks

H. Nikolaus Schaller (2):
      mmc: sdio: fix wl1251 vendor id
      mmc: core: fix wl1251 sdio quirks

Haishuang Yan (1):
      ip6erspan: remove the incorrect mtu limit for ip6erspan

Haiyang Zhang (2):
      hv_netvsc: Fix offset usage in netvsc_send_table()
      hv_netvsc: Fix send_table offset in case of a host bug

Hans de Goede (2):
      pwm: lpss: Release runtime-pm reference from the driver's remove call=
back
      usb: typec: tcpm: Notify the tcpc to start connection-detection for S=
RPs

Heiner Kallweit (2):
      net: phy: micrel: set soft_reset callback to genphy_soft_reset for KS=
Z9031
      net: phy: don't clear BMCR in genphy_soft_reset

Hoang Le (1):
      tipc: update mon's self addr when node addr generated

Hongbo Yao (1):
      irqchip/gic-v3-its: fix some definitions of inner cacheability attrib=
utes

Hook, Gary (2):
      crypto: ccp - fix AES CFB error exposed by new test vectors
      crypto: ccp - Fix 3DES complaint from ccp-crypto module

Hou Zhiqiang (3):
      PCI: mobiveil: Remove the flag MSI_FLAG_MULTI_PCI_MSI
      PCI: mobiveil: Fix devfn check in mobiveil_pcie_valid_device()
      PCI: mobiveil: Fix the valid check for inbound and outbound windows

Houlong Wei (1):
      mailbox: mediatek: Add check for possible failure of kzalloc

Huazhong Tan (5):
      net: hns3: add error handler for hns3_nic_init_vector_data()
      net: hns3: fix error handling int the hns3_get_vector_ring_chain
      net: hns3: fix wrong combined count returned by ethtool -l
      net: hns3: fix bug of ethtool_ops.get_channels for VF
      net: hns3: fix a memory leak issue for hclge_map_unmap_ring_to_vf_vec=
tor

H=E5kon Bugge (1):
      RDMA/cma: Fix false error message

Icenowy Zheng (1):
      clk: sunxi-ng: v3s: add the missing PLL_DDR1

Igor Konopko (1):
      lightnvm: pblk: fix lock order in pblk_rb_tear_down_check

Igor Russkikh (1):
      net: aquantia: fixed instack structure overflow

Ilya Dryomov (1):
      rbd: clear ->xferred on error from rbd_obj_issue_copyup()

Ilya Maximets (1):
      xdp: fix possible cq entry leak

Israel Rukshin (1):
      IB/iser: Pass the correct number of entries for dma mapped SGL

Iuliana Prodan (2):
      crypto: caam - fix caam_dump_sg that iterates through scatterlist
      crypto: caam - free resources in case caam_rng registration failed

Jack Morgenstein (1):
      IB/mlx5: Add missing XRC options to QP optional params mask

Jacopo Mondi (2):
      media: tw9910: Unregister subdevice with v4l2-async
      media: sh: migor: Include missing dma-mapping header

Jakub Kicinski (6):
      net: don't clear sock->sk early to avoid trouble in strparser
      net: netem: fix backlog accounting for corrupted GSO frames
      tools: bpftool: use correct argument in cgroup errors
      net/tls: fix socket wmem accounting on fallback with netem
      net: netem: fix error path for corrupted GSO frames
      net: netem: correct the parent's backlog when corrupted packet was dr=
opped

Jan Kara (1):
      xfs: Sanity check flags of Q_XQUOTARM call

Jani Nikula (1):
      drm/panel: make drm_panel.h self-contained

Jann Horn (1):
      apparmor: don't try to replace stale label in ptrace access check

Jarkko Nikula (1):
      mfd: intel-lpss: Add default I2C device properties for Gemini Lake

Jean Delvare (1):
      firmware: dmi: Fix unlikely out-of-bounds read in save_mem_devices

Jeffrey Altman (1):
      rxrpc: Fix detection of out of order acks

Jeffrey Hugo (2):
      drm/msm/mdp5: Fix mdp5_cfg_init error return
      drm/msm/dsi: Implement reset correctly

Jeremy Kerr (1):
      fsi/core: Fix error paths on CFAM init

Jernej Skrabec (1):
      ARM: dts: sun8i-h3: Fix wifi in Beelink X2 DT

Jerome Brunet (6):
      ASoC: fix valid stream condition
      clk: meson: gxbb: no spread spectrum on mpll0
      clk: meson: axg: spread spectrum is on mpll2
      arm64: dts: meson: libretech-cc: set eMMC as removable
      ASoC: meson: axg-tdmin: right_j is not supported
      ASoC: meson: axg-tdmout: right_j is not supported

Jesper Dangaard Brouer (2):
      net: fix bpf_xdp_adjust_head regression for generic-XDP
      samples/bpf: Fix broken xdp_rxq_info due to map order assumptions

Jiada Wang (1):
      thermal: rcar_gen3_thermal: fix interrupt type

Jian Shen (2):
      net: hns3: fix loop condition of hns3_get_tx_timeo_queue_info()
      net: hns3: fix error VF index when setting VLAN offload

Jie Liu (1):
      tipc: set sysctl_tipc_rmem and named_timeout right range

Jiong Wang (1):
      nfp: bpf: fix static check error through tightening shift amount adju=
stment

Jitendra Bhivare (1):
      PCI: iproc: Remove PAXC slot check to allow VF support

Johannes Berg (4):
      cfg80211: regulatory: make initialization more robust
      iwlwifi: mvm: fix A-MPDU reference assignment
      ALSA: aoa: onyx: always initialize register read value
      mac80211: accept deauth frames in IBSS mode

John Garry (1):
      drm/hisilicon: hibmc: Don't overwrite fb helper surface depth

Jon Hunter (1):
      dmaengine: tegra210-adma: Fix crash during probe

Jon Maloy (3):
      tipc: eliminate message disordering during binding table update
      tipc: tipc clang warning
      tipc: reduce risk of wakeup queue starvation

Jonas Gorski (2):
      MIPS: BCM63XX: drop unused and broken DSP platform device
      hwrng: bcm2835 - fix probe as platform device

Jorge Ramirez-Ortiz (1):
      mailbox: qcom-apcs: fix max_register value

Jose Abreu (1):
      net: stmmac: gmac4+: Not all Unicast addresses may be available

Jouni Malinen (1):
      um: Fix IRQ controller regression on console read

Julian Wiedmann (2):
      net/af_iucv: build proper skbs for HiperTransport
      net/af_iucv: always register net_device notifier

Kangjie Lu (1):
      net: sh_eth: fix a missing check of of_get_phy_mode

Karsten Graul (3):
      net/smc: original socket family in inet_sock_diag
      net/smc: receive returns without data
      net/smc: receive pending data after RCV_SHUTDOWN

Kees Cook (1):
      selftests/ipc: Fix msgque compiler warnings

Kelvin Cao (1):
      switchtec: Remove immediate status check after submitting MRPC command

Kevin Mitchell (1):
      iommu/amd: Make iommu_disable safer

Kishon Vijay Abraham I (1):
      PCI: dwc: Fix dw_pcie_ep_find_capability() to return correct capabili=
ty offset

Laurent Pinchart (1):
      drm: rcar-du: Fix vblank initialization

Leandro Dorileo (1):
      net/sched: cbs: fix port_rate miscalculation

Leon Romanovsky (1):
      net/mlx5: Delete unused FPGA QPN variable

Li Jin (1):
      pinctrl: iproc-gpio: Fix incorrect pinconf configurations

Linus Torvalds (1):
      Partially revert "kfifo: fix kfifo_alloc() and kfifo_init()"

Liu Jian (2):
      driver: uio: fix possible memory leak in __uio_register_device
      driver: uio: fix possible use-after-free in __uio_register_device

Loic Poulain (1):
      arm64: dts: apq8016-sbc: Increase load on l11 for SDCARD

Lorenzo Bianconi (3):
      mt7601u: fix bbp version check in mt7601u_wait_bbp_ready
      mt76: usb: fix possible memory leak in mt76u_buf_free
      ath9k: dynack: fix possible deadlock in ath_dynack_node_{de}init

Lu Baolu (4):
      iommu/vt-d: Fix NULL pointer reference in intel_svm_bind_mm()
      iommu/vt-d: Make kernel parameter igfx_off work with vIOMMU
      iommu: Add missing new line for dma type
      iommu: Use right function to get group for device

Luc Van Oostenryck (1):
      soc: aspeed: Fix snoop_file_poll()'s return type

Lyude Paul (1):
      drm/dp_mst: Skip validating ports during destruction, just ref

Madalin Bucur (2):
      dpaa_eth: perform DMA unmapping before read
      dpaa_eth: avoid timestamp read on error paths

Magnus Karlsson (2):
      xsk: add missing smp_rmb() in xsk_mmap
      xsk: Fix registration of Rx-only sockets

Manivannan Sadhasivam (1):
      clk: actions: Fix factor clk struct member access

Mao Wenan (2):
      net: sonic: return NETDEV_TX_OK if failed to map buffer
      net: sonic: replace dev_kfree_skb in sonic_send_packet

Maor Gottlieb (1):
      IB/mlx5: Don't override existing ip_protocol

Marc Dionne (1):
      afs: Fix large file support

Marc Gonzalez (2):
      clk: qcom: Skip halt checks on gcc_pcie_0_pipe_clk for 8998
      usb: dwc3: Allow building USB_DWC3_QCOM without EXTCON

Marc Zyngier (1):
      genirq/debugfs: Reinstate full OF path for domain name

Marek Szyprowski (2):
      clocksource/drivers/exynos_mct: Fix error path in timer resources ini=
tialization
      ARM: 8847/1: pm: fix HYP/SVC mode mismatch when MCPM is used

Mark Bloch (1):
      RDMA/mlx5: Fix memory leak in case we fail to add an IB device

Mark Zhang (1):
      net/mlx5: Fix mlx5_ifc_query_lag_out_bits

Markus Elfring (1):
      media: em28xx: Fix exception handling in em28xx_alloc_urbs()

Martin Blumenstingl (1):
      pwm: meson: Consider 128 a valid pre-divider

Martin Sperl (1):
      spi: bcm2835aux: fix driver to not allow 65535 (=3D-1) cs-gpios

Masahiro Yamada (2):
      kbuild: mark prepare0 as PHONY to fix external module build
      ARM: stm32: use "depends on" instead of "if" after prompt

Masahisa Kojima (1):
      net: socionext: Add dummy PHY register read in phy_write()

Masami Hiramatsu (1):
      x86, perf: Fix the dependency of the x86 insn decoder selftest

Matteo Croce (1):
      arm64/vdso: don't leak kernel addresses

Matthias Kaehlcke (2):
      thermal: cpu_cooling: Actually trace CPU load in thermal_power_cpu_ge=
t_power
      backlight: pwm_bl: Fix heuristic to determine number of brightness le=
vels

Mattias Jacobsson (1):
      platform/x86: wmi: fix potential null pointer dereference

Max Gurtovoy (1):
      IB/iser: Fix dma_nents type definition

Maxime Ripard (5):
      drm/sun4i: hdmi: Fix double flag assignation
      ARM: dts: sun8i: a33: Reintroduce default pinctrl muxing
      arm64: dts: allwinner: a64: Add missing PIO clocks
      ARM: dts: sun9i: optimus: Fix fixed-regulators
      ASoC: sun4i-i2s: RX and TX counter registers are swapped

Michael Chan (2):
      bnxt_en: Fix ethtool selftest crash under error conditions.
      bnxt_en: Suppress error messages when querying DSCP DCB capabilities.

Michael Ellerman (1):
      powerpc/64s: Fix logic when handling unknown CPU features

Michael Kao (1):
      thermal: mediatek: fix register index error

Michael S. Tsirkin (1):
      vhost/test: stop device before reset

Michal Kalderon (2):
      qed: iWARP - Use READ_ONCE and smp_store_release to access ep->state
      qed: iWARP - fix uninitialized callback

Mike Marciniszyn (1):
      IB/hfi1: Handle port down properly in pio

Minas Harutyunyan (1):
      dwc2: gadget: Fix completed transfer size calculation in DDMA

Ming Lei (1):
      block: don't use bio->bi_vcnt to figure out segment number

Mitko Haralanov (1):
      IB/hfi1: Correctly process FECN and BECN in packets

Moni Shoua (1):
      net/mlx5: Take lock with IRQs disabled to avoid deadlock

Mordechay Goodstein (1):
      iwlwifi: mvm: avoid possible access out of array.

Moritz Fischer (1):
      net: phy: fixed_phy: Fix fixed_phy not checking GPIO

Naftali Goldstein (1):
      iwlwifi: nvm: get num of hw addresses from firmware

Nathan Chancellor (2):
      staging: rtlwifi: Use proper enum for return in halmac_parse_psd_data=
_88xx
      misc: sgi-xp: Properly initialize buf in xpc_get_rsvd_page_pa

Nathan Huckleberry (1):
      clk: qcom: Fix -Wunused-const-variable

Nathan Lynch (2):
      powerpc/cacheinfo: add cacheinfo_teardown, cacheinfo_rebuild
      powerpc/pseries/mobility: rebuild cacheinfo hierarchy post-migration

Navid Emamdoost (2):
      ipmi: Fix memory leak in __ipmi_bmc_register
      affs: fix a memory leak in affs_remount

Neil Armstrong (4):
      pinctrl: meson-gxl: remove invalid GPIOX tsin_a pins
      arm64: dts: meson-gx: Add hdmi_5v regulator as hdmi tx supply
      soc: amlogic: gx-socinfo: Add mask for each SoC packages
      soc: amlogic: meson-gx-pwrc-vpu: Fix power on/off register bitmask

Nicholas Mc Guire (4):
      usb: gadget: fsl_udc_core: check allocation return value and cleanup =
on failure
      ipmi: kcs_bmc: handle devm_kasprintf() failure case
      staging: r8822be: check kzalloc return or bail
      media: cx23885: check allocation return

Nicholas Piggin (1):
      powerpc/64s/radix: Fix memory hot-unplug page table split

Nick Desaulniers (1):
      mips: avoid explicit UB in assignment of mips_io_port_base

Nicolas Boichat (1):
      ath10k: adjust skb length in ath10k_sdio_mbox_rx_packet

Nicolas Dichtel (1):
      xfrm interface: ifname may be wrong in logs

Nicolas Huaman (1):
      ALSA: usb-audio: update quirk for B&W PX to remove microphone

Niklas Cassel (1):
      arm64: dts: msm8916: remove bogus argument to the cpu clock

Niklas S=F6derlund (1):
      media: rcar-vin: Clean up correct notifier in error path

Noralf Tr=F8nnes (2):
      drm/fb-helper: generic: Fix setup error path
      drm/fb-helper: generic: Call drm_client_add() after setup is done

Oleh Kravchenko (1):
      led: triggers: Fix dereferencing of null pointer

Oleksandr Andrushchenko (1):
      drm/xen-front: Fix mmap attributes for display buffers

Omar Sandoval (1):
      btrfs: use correct count in btrfs_file_write_iter()

Ondrej Jirman (1):
      clk: sunxi-ng: sun50i-h6-r: Fix incorrect W1 clock gate register

Oscar A Perez (1):
      ARM: dts: aspeed-g5: Fixe gpio-ranges upper limit

Pablo Neira Ayuso (4):
      netfilter: nft_set_hash: fix lookups with fixed size hash on big endi=
an
      netfilter: nft_set_hash: bogus element self comparison from deactivat=
ion path
      netfilter: nft_flow_offload: add entry to flowtable after confirmation
      netfilter: ctnetlink: honor IPS_OFFLOAD flag

Pan Bian (1):
      mmc: core: fix possible use after free of host

Parav Pandit (4):
      RDMA/rxe: Consider skb reserve space based on netdev of GID
      vfio/mdev: Avoid release parent reference during error path
      vfio/mdev: Follow correct remove sequence
      vfio/mdev: Fix aborting mdev child device removal if one fails

Paul Cercueil (1):
      clk: ingenic: jz4740: Fix gating of UDC clock

Paul Selles (1):
      ntb_hw_switchtec: debug print 64bit aligned crosslink BAR Numbers

Pavel Tatashin (1):
      arm64: hibernate: check pgd table allocation

Pawe? Chmiel (1):
      media: s5p-jpeg: Correct step and max values for V4L2_CID_JPEG_RESTAR=
T_INTERVAL

Peng Fan (1):
      firmware: arm_scmi: update rate_discrete in clock_describe_rates_get

Peter Rosin (3):
      drm/sti: do not remove the drm_bridge that was never added
      ARM: dts: at91: nattis: set the PRLUD and HIPOW signals low
      ARM: dts: at91: nattis: make the SD-card slot work

Peter Ujfalusi (1):
      ASoC: ti: davinci-mcasp: Fix slot mask settings when using multiple A=
XRs

Petr Machata (3):
      mlxsw: reg: QEEC: Add minimum shaper fields
      mlxsw: spectrum: Set minimum shaper on MC TCs
      vxlan: changelink: Fix handling of default remotes

Phil Elwell (1):
      ARM: dts: bcm283x: Correct mailbox register sizes

Philipp Rudo (1):
      s390/kexec_file: Fix potential segment overlap in ELF loader

Pi-Hsun Shih (1):
      rtc: mt6397: Don't call irq_dispose_mapping.

Qian Cai (1):
      x86/mm: Remove unused variable 'cpu'

Quentin Monnet (2):
      tools: bpftool: fix arguments for p_err() in do_event_pipe()
      tools: bpftool: fix format strings and arguments for jsonw_printf()

Rafael J. Wysocki (11):
      driver core: Fix DL_FLAG_AUTOREMOVE_SUPPLIER device link flag handling
      driver core: Avoid careless re-use of existing device links
      driver core: Do not resume suppliers under device_links_write_lock()
      driver core: Fix handling of runtime PM flags in device_link_add()
      driver core: Do not call rpm_put_suppliers() in pm_runtime_drop_link()
      driver core: Fix possible supplier PM-usage counter imbalance
      driver core: Fix PM-runtime for links added during consumer probe
      PM: ACPI/PCI: Resume all devices during hibernation
      ACPI: PM: Simplify and fix PM domain hibernation callbacks
      ACPI: PM: Introduce "poweroff" callbacks for ACPI PM domain and LPSS
      PM: sleep: Fix possible overflow in pm_system_cancel_wakeup()

Raju Rangoju (1):
      RDMA/iw_cxgb4: Fix the unchecked ep dereference

Rakesh Pillai (2):
      ath10k: fix dma unmap direction for management frames
      ath10k: Fix encoding for protected management frames

Rashmica Gupta (2):
      powerpc/mm: Check secondary hash page table
      gpio/aspeed: Fix incorrect number of banks

Ravi Bangoria (1):
      perf/ioctl: Add check for the sample_period value

Rayagonda Kokatanur (1):
      spi: bcm-qspi: Fix BSPI QUAD and DUAL mode support when using flex mo=
de

Rik van Riel (1):
      fork,memcg: fix crash in free_thread_stack on memcg charge fail

Rob Clark (1):
      drm/msm/a3xx: remove TPL1 regs from snapshot

Rob Herring (1):
      of: Fix property name in of_node_get_device_type

Robert Richter (1):
      EDAC/mc: Fix edac_mc_find() in case no device is found

Robin Gong (1):
      dmaengine: imx-sdma: fix size check for sdma script_number

Robin Murphy (1):
      dmaengine: mv_xor: Use correct device for DMA API

Roopa Prabhu (1):
      bridge: br_arp_nd_proxy: set icmp6_router if neigh has NTF_ROUTER

Ruslan Bilovol (1):
      usb: host: xhci-hub: fix extra endianness conversion

Russell King (2):
      net: dsa: fix unintended change of bridge interface STP state
      ARM: riscpc: fix lack of keyboard interrupts after irq conversion

Sagiv Ozeri (1):
      RDMA/qedr: Fix incorrect device rate.

Sam Bobroff (1):
      drm/radeon: fix bad DMA from INTERRUPT_CNTL2

Sameeh Jubran (4):
      net: ena: fix swapped parameters when calling ena_com_indirect_table_=
fill_entry
      net: ena: fix: Free napi resources when ena_up() fails
      net: ena: fix incorrect test of supported hash function
      net: ena: fix ena_com_fill_hash_function() implementation

Sameer Pujar (1):
      dmaengine: tegra210-adma: restore channel status

Sara Sharon (1):
      iwlwifi: mvm: fix RSS config command

Selvin Xavier (1):
      RDMA/bnxt_re: Add missing spin lock initialization

Shakeel Butt (1):
      fork, memcg: fix cached_stacks case

Shannon Nelson (1):
      ixgbe: don't clear IPsec sa counters on HW clearing

Shuiqing Li (1):
      watchdog: sprd: Fix the incorrect pointer getting from driver data

Sibi Sankar (2):
      remoteproc: qcom: q6v5-mss: Add missing clocks for MSM8996
      remoteproc: qcom: q6v5-mss: Add missing regulator for MSM8996

Sowjanya Komatineni (5):
      spi: tegra114: clear packed bit for unpacked mode
      spi: tegra114: fix for unpacked mode transfers
      spi: tegra114: terminate dma and reset on transfer timeout
      spi: tegra114: flush fifos
      spi: tegra114: configure dma burst size to fifo trig level

Spencer E. Olson (1):
      staging: comedi: ni_mio_common: protect register write overflow

Srinath Mannam (1):
      PCI: iproc: Enable iProc config read for PAXBv2

Stefan Agner (1):
      ASoC: imx-sgtl5000: put of nodes if finding codec fails

Stefan Wahren (5):
      staging: bcm2835-camera: Abort probe if there is no camera
      staging: bcm2835-camera: fix module autoloading
      arm64: defconfig: Re-enable bcm2835-thermal driver
      mmc: sdhci-brcmstb: handle mmc_of_parse() errors during probe
      net: qca_spi: Move reset_count to struct qcaspi

Stefano Brivio (1):
      ip6_fib: Don't discard nodes with valid routing information in fib6_l=
ocate_1()

Stephen Boyd (2):
      firmware: coreboot: Let OF core populate platform device
      power: supply: Init device wakeup after device_add()

Stephen Hemminger (3):
      netvsc: unshare skb in VF rx handler
      net: core: support XDP generic on stacked devices.
      hv_netvsc: flag software created hash value

Steve French (1):
      cifs: fix rmmod regression in cifs.ko caused by force_sig changes

Steve Sistare (1):
      scsi: megaraid_sas: reduce module load time

Steve Wise (2):
      iw_cxgb4: use tos when importing the endpoint
      iw_cxgb4: use tos when finding ipv6 routes

Steven Price (1):
      firmware: arm_scmi: fix of_node leak in scmi_mailbox_check

Sudeep Holla (1):
      firmware: arm_scmi: fix bitfield definitions for SENSOR_DESC attribut=
es

Surabhi Vishnoi (1):
      ath10k: Fix length of wmi tlv command for protected mgmt frames

Sven Van Asbroeck (1):
      usb: phy: twl6030-usb: fix possible use-after-free on remove

Taehee Yoo (1):
      netfilter: nf_flow_table: do not remove offload when other netns's in=
terface is down

Takashi Iwai (3):
      ASoC: qcom: Fix of-node refcount unbalance in apq8016_sbc_parse_of()
      ALSA: usb-audio: Handle the error from snd_usb_mixer_apply_create_qui=
rk()
      ALSA: aica: Fix a long-time build breakage

Takeshi Kihara (1):
      arm64: dts: renesas: ebisu: Remove renesas, no-ether-link property

Thomas Gleixner (1):
      x86/kgbd: Use NMI_VECTOR not APIC_DM_NMI

Tiezhu Yang (1):
      MIPS: Loongson: Fix return value of loongson_hwmon_init

Tomas Winkler (1):
      mei: replace POLL* with EPOLL* for write queues.

Tony Jones (1):
      apparmor: Fix network performance issue in aa_label_sk_perm

Tony Lindgren (5):
      bus: ti-sysc: Add mcasp optional clocks flag
      bus: ti-sysc: Fix timer handling with drop pm_runtime_irq_safe()
      ARM: OMAP2+: Fix potentially uninitialized return value for _setup_re=
set()
      bus: ti-sysc: Fix sysc_unprepare() when no clocks have been allocated
      hwrng: omap3-rom - Fix missing clock by probing with device tree

Trond Myklebust (4):
      NFS: Fix a soft lockup in the delegation recovery code
      NFS/pnfs: Bulk destroy of layouts needs to be safe w.r.t. umount
      NFSv4/flexfiles: Fix invalid deref in FF_LAYOUT_DEVID_NODE()
      NFS: Don't interrupt file writeout due to fatal errors

Tung Nguyen (1):
      tipc: fix wrong timeout input for tipc_wait_for_cond()

Tyrel Datwyler (1):
      powerpc/pseries: Enable support for ibm,drc-info property

Uwe Kleine-K=F6nig (1):
      rtc: ds1307: rx8130: Fix alarm handling

Vadim Pasternak (1):
      hwmon: (pmbus/tps53679) Fix driver info initialization in probe routi=
ne

Vasily Khoruzhick (1):
      ASoC: sun8i-codec: add missing route for ADC

Vasundhara Volam (2):
      bnxt_en: Fix handling FRAG_ERR when NVM_INSTALL_UPDATE cmd fails
      bnxt_en: Increase timeout for HWRM_DBG_COREDUMP_XX commands

Vincent Stehl=E9 (1):
      staging: android: vsoc: fix copy_from_user overrun

Vinod Koul (1):
      net: dsa: qca8k: Enable delay for RGMII_ID mode

Viresh Kumar (1):
      OPP: Fix missing debugfs supply directory for OPPs

Vladimir Murzin (2):
      ARM: 8848/1: virt: Align GIC version check with arm64 counterpart
      ARM: 8849/1: NOMMU: Fix encodings for PMSAv8's PRBAR4/PRLAR4

Vladimir Oltean (4):
      net: dsa: Avoid null pointer when failing to connect to PHY
      ARM: dts: ls1021: Fix SGMII PCS link remaining down after PHY disconn=
ect
      net/sched: cbs: Set default link speed to 10 Mbps in cbs_set_port_rate
      net: sched: cbs: Avoid division by zero when calculating the port rate

Vladimir Zapolskiy (5):
      ARM: dts: lpc32xx: add required clocks property to keypad device node
      ARM: dts: lpc32xx: reparent keypad controller to SIC1
      ARM: dts: lpc32xx: fix ARM PrimeCell LCD controller variant
      ARM: dts: lpc32xx: fix ARM PrimeCell LCD controller clocks property
      ARM: dts: lpc32xx: phy3250: fix SD card regulator voltage

Wei Yongjun (1):
      rtlwifi: Fix file release memory leak

Wen Yang (2):
      PCI: endpoint: functions: Use memcpy_fromio()/memcpy_toio()
      net: pasemi: fix an use-after-free in pasemi_mac_phy_init()

Wesley Sheng (1):
      ntb_hw_switchtec: NT req id mapping table register entry number shoul=
d be 512

Willem de Bruijn (3):
      net: always initialize pagedlen
      ipv6: add missing tx timestamping on IPPROTO_RAW
      packet: in recvmsg msg_name return at least sizeof sockaddr_ll

Xi Wang (3):
      RDMA/hns: Fixs hw access invalid dma memory error
      RDMA/hns: Bugfix for slab-out-of-bounds when unloading hip08 driver
      RDMA/hns: bugfix for slab-out-of-bounds when loading hip08 driver

Xin Long (1):
      sctp: add chunks to sk_backlog when the newsk sk_socket is not set

Yangtao Li (14):
      clk: highbank: fix refcount leak in hb_clk_init()
      clk: qoriq: fix refcount leak in clockgen_init()
      clk: ti: fix refcount leak in ti_dt_clocks_register()
      clk: socfpga: fix refcount leak
      clk: samsung: exynos4: fix refcount leak in exynos4_get_xom()
      clk: imx6q: fix refcount leak in imx6q_clocks_init()
      clk: imx6sx: fix refcount leak in imx6sx_clocks_init()
      clk: imx7d: fix refcount leak in imx7d_clocks_init()
      clk: vf610: fix refcount leak in vf610_clocks_init()
      clk: armada-370: fix refcount leak in a370_clk_init()
      clk: kirkwood: fix refcount leak in kirkwood_clk_init()
      clk: armada-xp: fix refcount leak in axp_clk_init()
      clk: mv98dx3236: fix refcount leak in mv98dx3236_clk_init()
      clk: dove: fix refcount leak in dove_clk_init()

Yong Wu (1):
      iommu/mediatek: Fix iova_to_phys PA start for 4GB mode

Yoshihiro Kaneko (1):
      arm64: dts: renesas: r8a77995: Fix register range of display node

Yoshihiro Shimoda (1):
      net: phy: Fix not to call phy_resume() if PHY is not attached

YueHaibing (22):
      powerpc/pseries/memory-hotplug: Fix return value type of find_aa_index
      exportfs: fix 'passing zero to ERR_PTR()' warning
      drm: Fix error handling in drm_legacy_addctx
      drm/shmob: Fix return value check in shmob_drm_probe
      crypto: brcm - Fix some set-but-not-used warning
      spi/topcliff_pch: Fix potential NULL dereference on allocation error
      tty: ipwireless: Fix potential NULL pointer dereference
      fbdev: chipsfb: remove set but not used variable 'size'
      mdio_bus: Fix PTR_ERR() usage after initialization to constant
      cdc-wdm: pass return value of recover_from_urb_loss
      media: tw5864: Fix possible NULL pointer dereference in tw5864_handle=
_frame
      ehea: Fix a copy-paste err in ehea_init_port_res
      drm/vmwgfx: Remove set but not used variable 'restart'
      ARM: pxa: ssp: Fix "WARNING: invalid free of devm_ allocated data"
      l2tp: Fix possible NULL pointer dereference
      net/sched: cbs: Fix error path of cbs_module_init
      libertas_tf: Use correct channel range in lbtf_geo_init
      ASoC: es8328: Fix copy-paste error in es8328_right_line_controls
      ASoC: cs4349: Use PM ops 'cs4349_runtime_pm'
      ASoC: wm8737: Fix copy-paste error in wm8737_snd_controls
      usb: typec: tps6598x: Fix build error without CONFIG_REGMAP_I2C
      act_mirred: Fix mirred_init_module error handling

Yunfeng Ye (1):
      crypto: hisilicon - Matching the dma address for dma_pool_free()

Yunsheng Lin (1):
      net: hns3: fix for vport->bw_limit overflow problem

Yuval Shaia (1):
      IB/rxe: Fix incorrect cache cleanup in error flow

Zhang Rui (1):
      ACPI: button: reinitialize button state upon resume

Zhu Yanjun (1):
      IB/rxe: replace kvfree with vfree

wenxu (1):
      ip_tunnel: Fix route fl4 init in ip_md_tunnel_xmit

zhengbin (1):
      afs: Remove set but not used variables 'before', 'after'


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4vAE4ACgkQONu9yGCS
aT4XTA//WOzj21xMAuM9im886jkvgEbVQgpw8qcVcz9ctDCSSlWsGqBSecsqYqKZ
5pLFvDux8nya0b9kMKLezPwJc3pXe0BdX4ExqOG2mlAX5XXKgodjXo81Zw1Ftx4c
VC5MRRZZ9BctUeYIyv6znSBEtd3+TQdYq84VwiUIUt6j2OatUb6q8BkTVqTLH1/K
1RH1XE2KXGMo2jSAJNcx3rZTvZDGKCaw/WC17sK5/FB58BNVD5C4HuEVZcsSdQu3
Uyw0y0fX10Qa40QqHaIx1pwyQ70GvGBqcNJMizYXJsx/839jhBmHLTV5Q6W1qObV
SSP1dpiAKtvbhpW/Pfwf27Q62hk7WIY39PtWTKnR2ksqX9IWxb76nG7cf1yMwC4h
cxilLXHWh54TnInmdvwYCldHgwAC2BY6AI1/UXWb1AMxTTlIacZc2LTaG+jQfpJv
PRFo5m54ABw6xuZSsyGuj/cka3NLnW8gG68YUnx74CZRwRWmvj6xd/+UorldLMWm
iAd2MGHbSyRNduDveRuDNe5HfNGOKlOmJTc1sH1VN8nwoF3DVgK1P6vfbtOaY6Qn
cf0dubEHFSrPoRJKj/cCny7JN6K5GV405M5zIuwCuk6W8HtocZnJqg8LVdEWXmKW
Ee58ZBdA+L0si9OS7VUnrQha+G3laD4CySrv8dD7oq5Hd/68/vE=
=xvC8
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
