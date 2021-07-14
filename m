Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BAE3C87A6
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 17:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239981AbhGNPfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 11:35:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239971AbhGNPfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 11:35:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 469FB613D2;
        Wed, 14 Jul 2021 15:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626276741;
        bh=7alD1JwQukskCkrLUprlPmw8bQHQVQb8py1ExdzSdDA=;
        h=From:To:Cc:Subject:Date:From;
        b=gSb/Xg+wetVkIWOF5o8VyleAacFzcL7N2zbIGTmmxEo9KYr7u2zyNvEP4WcTnIhnq
         /Qy3TdhBuO4sIZas2Zq1KUz9yuNNoShCJt6y0g8IIqNVTa3cOb16y2HgU/mPm9DEn+
         WtSQNwhxgE5RCWOriMvouGPTpfM/oCXnHQY17/QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.50
Date:   Wed, 14 Jul 2021 17:32:14 +0200
Message-Id: <16262767348841@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.50 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/evm                                  |   26 +
 Documentation/ABI/testing/sysfs-bus-papr-pmem                  |    8 
 Documentation/admin-guide/kernel-parameters.txt                |    6 
 Documentation/hwmon/max31790.rst                               |    5 
 Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst      |    5 
 Documentation/vm/arch_pgtable_helpers.rst                      |    8 
 Makefile                                                       |    4 
 arch/alpha/kernel/smp.c                                        |    1 
 arch/arc/kernel/smp.c                                          |    1 
 arch/arm/boot/dts/sama5d4.dtsi                                 |    2 
 arch/arm/boot/dts/ste-href.dtsi                                |    7 
 arch/arm/kernel/perf_event_v7.c                                |    4 
 arch/arm/kernel/smp.c                                          |    1 
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi                   |    2 
 arch/arm64/include/asm/asm-uaccess.h                           |    4 
 arch/arm64/include/asm/kernel-pgtable.h                        |    6 
 arch/arm64/include/asm/mmu_context.h                           |    8 
 arch/arm64/include/asm/pgtable.h                               |    1 
 arch/arm64/include/asm/preempt.h                               |    2 
 arch/arm64/include/asm/uaccess.h                               |    4 
 arch/arm64/kernel/entry.S                                      |    6 
 arch/arm64/kernel/perf_event.c                                 |    2 
 arch/arm64/kernel/setup.c                                      |    2 
 arch/arm64/kernel/smp.c                                        |    1 
 arch/arm64/kernel/vmlinux.lds.S                                |    8 
 arch/arm64/kvm/pmu-emul.c                                      |    1 
 arch/arm64/mm/proc.S                                           |    2 
 arch/csky/kernel/smp.c                                         |    1 
 arch/csky/mm/syscache.c                                        |   11 
 arch/ia64/kernel/mca_drv.c                                     |    2 
 arch/ia64/kernel/smpboot.c                                     |    1 
 arch/m68k/Kconfig.machine                                      |    3 
 arch/mips/include/asm/highmem.h                                |    2 
 arch/mips/kernel/smp.c                                         |    1 
 arch/openrisc/kernel/smp.c                                     |    2 
 arch/parisc/kernel/smp.c                                       |    1 
 arch/powerpc/include/asm/cputhreads.h                          |   30 +
 arch/powerpc/kernel/mce_power.c                                |   48 ++
 arch/powerpc/kernel/process.c                                  |   48 +-
 arch/powerpc/kernel/smp.c                                      |   12 
 arch/powerpc/kernel/stacktrace.c                               |   27 +
 arch/powerpc/kvm/book3s_hv.c                                   |   13 
 arch/powerpc/kvm/book3s_hv_builtin.c                           |    2 
 arch/powerpc/kvm/book3s_hv_nested.c                            |    3 
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                            |    2 
 arch/powerpc/platforms/cell/smp.c                              |    3 
 arch/powerpc/platforms/pseries/papr_scm.c                      |   62 ++-
 arch/powerpc/platforms/pseries/smp.c                           |    3 
 arch/riscv/kernel/smpboot.c                                    |    1 
 arch/s390/Kconfig                                              |    4 
 arch/s390/boot/uv.c                                            |    1 
 arch/s390/include/asm/pgtable.h                                |   19 +
 arch/s390/include/asm/preempt.h                                |   16 
 arch/s390/include/asm/uv.h                                     |    8 
 arch/s390/kernel/setup.c                                       |    1 
 arch/s390/kernel/smp.c                                         |    2 
 arch/s390/kernel/uv.c                                          |   10 
 arch/s390/kvm/kvm-s390.c                                       |   18 
 arch/s390/mm/fault.c                                           |   26 +
 arch/sh/kernel/smp.c                                           |    2 
 arch/sparc/kernel/smp_32.c                                     |    1 
 arch/sparc/kernel/smp_64.c                                     |    3 
 arch/x86/crypto/curve25519-x86_64.c                            |    2 
 arch/x86/entry/entry_64.S                                      |    4 
 arch/x86/include/asm/idtentry.h                                |   29 -
 arch/x86/include/asm/kvm_host.h                                |    2 
 arch/x86/include/asm/preempt.h                                 |    2 
 arch/x86/include/uapi/asm/hwcap2.h                             |    6 
 arch/x86/kernel/sev-es.c                                       |  182 +++++-----
 arch/x86/kernel/smpboot.c                                      |    1 
 arch/x86/kernel/tsc.c                                          |    3 
 arch/x86/kvm/hyperv.c                                          |    2 
 arch/x86/kvm/mmu/mmu.c                                         |   10 
 arch/x86/kvm/mmu/paging_tmpl.h                                 |    3 
 arch/x86/kvm/mmu/tdp_mmu.c                                     |    2 
 arch/x86/kvm/vmx/nested.c                                      |   29 -
 arch/x86/kvm/vmx/vmcs.h                                        |    5 
 arch/x86/kvm/vmx/vmx.c                                         |    4 
 arch/x86/kvm/vmx/vmx.h                                         |    1 
 arch/x86/kvm/x86.c                                             |    2 
 arch/xtensa/kernel/smp.c                                       |    1 
 block/blk-flush.c                                              |    3 
 block/blk-merge.c                                              |    8 
 block/blk-mq-tag.c                                             |   49 ++
 block/blk-mq-tag.h                                             |    6 
 block/blk-mq.c                                                 |   63 ++-
 block/blk-mq.h                                                 |    1 
 block/blk-rq-qos.h                                             |   24 +
 block/blk-wbt.c                                                |   11 
 block/blk-wbt.h                                                |    1 
 crypto/shash.c                                                 |   18 
 crypto/sm2.c                                                   |   99 ++---
 drivers/acpi/Makefile                                          |    5 
 drivers/acpi/acpi_pad.c                                        |   24 -
 drivers/acpi/acpi_tad.c                                        |   14 
 drivers/acpi/acpica/nsrepair2.c                                |    7 
 drivers/acpi/apei/ghes.c                                       |   81 +++-
 drivers/acpi/bgrt.c                                            |   57 ---
 drivers/acpi/bus.c                                             |    1 
 drivers/acpi/device_pm.c                                       |    6 
 drivers/acpi/device_sysfs.c                                    |   46 +-
 drivers/acpi/dock.c                                            |   26 -
 drivers/acpi/ec.c                                              |   37 +-
 drivers/acpi/fan.c                                             |    7 
 drivers/acpi/fan.h                                             |   13 
 drivers/acpi/power.c                                           |    9 
 drivers/acpi/processor_idle.c                                  |   40 ++
 drivers/acpi/resource.c                                        |    9 
 drivers/acpi/video_detect.c                                    |   24 +
 drivers/ata/pata_ep93xx.c                                      |    2 
 drivers/ata/pata_octeon_cf.c                                   |    5 
 drivers/ata/pata_rb532_cf.c                                    |    6 
 drivers/ata/sata_highbank.c                                    |    6 
 drivers/block/loop.c                                           |    1 
 drivers/bluetooth/btqca.c                                      |   27 +
 drivers/bluetooth/hci_qca.c                                    |    4 
 drivers/bus/mhi/core/pm.c                                      |    1 
 drivers/char/hw_random/exynos-trng.c                           |    4 
 drivers/char/pcmcia/cm4000_cs.c                                |    4 
 drivers/char/tpm/tpm_tis_core.c                                |   25 -
 drivers/char/tpm/tpm_tis_core.h                                |    3 
 drivers/char/tpm/tpm_tis_spi_main.c                            |    2 
 drivers/clk/actions/owl-s500.c                                 |   75 ++--
 drivers/clk/clk-si5341.c                                       |   77 ++++
 drivers/clk/clk-versaclock5.c                                  |   27 +
 drivers/clk/imx/clk-imx8mq.c                                   |   56 ---
 drivers/clk/meson/g12a.c                                       |    2 
 drivers/clk/qcom/clk-alpha-pll.c                               |    2 
 drivers/clk/socfpga/clk-agilex.c                               |   89 +++-
 drivers/clk/socfpga/clk-periph-s10.c                           |   11 
 drivers/clk/socfpga/clk-s10.c                                  |   87 +++-
 drivers/clk/tegra/clk-tegra30.c                                |    2 
 drivers/clocksource/timer-ti-dm.c                              |    6 
 drivers/cpufreq/cpufreq.c                                      |   11 
 drivers/crypto/cavium/nitrox/nitrox_isr.c                      |    4 
 drivers/crypto/ccp/sev-dev.c                                   |    4 
 drivers/crypto/ccp/sp-pci.c                                    |    6 
 drivers/crypto/hisilicon/sec2/sec_crypto.c                     |    4 
 drivers/crypto/ixp4xx_crypto.c                                 |   24 +
 drivers/crypto/nx/nx-842-pseries.c                             |    9 
 drivers/crypto/nx/nx-aes-ctr.c                                 |    2 
 drivers/crypto/omap-sham.c                                     |    4 
 drivers/crypto/qat/qat_common/qat_hal.c                        |    6 
 drivers/crypto/qat/qat_common/qat_uclo.c                       |    1 
 drivers/crypto/qce/skcipher.c                                  |   19 -
 drivers/crypto/sa2ul.c                                         |   22 -
 drivers/crypto/ux500/hash/hash_core.c                          |    1 
 drivers/devfreq/devfreq.c                                      |    1 
 drivers/edac/i10nm_base.c                                      |    3 
 drivers/edac/pnd2_edac.c                                       |    3 
 drivers/edac/sb_edac.c                                         |    3 
 drivers/edac/skx_base.c                                        |    3 
 drivers/edac/ti_edac.c                                         |    1 
 drivers/extcon/extcon-max8997.c                                |    3 
 drivers/extcon/extcon-sm5502.c                                 |    1 
 drivers/firmware/stratix10-svc.c                               |   22 -
 drivers/fsi/fsi-core.c                                         |    4 
 drivers/fsi/fsi-occ.c                                          |    1 
 drivers/fsi/fsi-sbefifo.c                                      |   10 
 drivers/fsi/fsi-scom.c                                         |   16 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |    3 
 drivers/gpu/drm/ast/ast_main.c                                 |    4 
 drivers/gpu/drm/bridge/Kconfig                                 |    2 
 drivers/gpu/drm/drm_bridge.c                                   |    3 
 drivers/gpu/drm/msm/disp/dpu1/dpu_mdss.c                       |    8 
 drivers/gpu/drm/msm/msm_drv.c                                  |    1 
 drivers/gpu/drm/pl111/Kconfig                                  |    1 
 drivers/gpu/drm/qxl/qxl_dumb.c                                 |    2 
 drivers/gpu/drm/rockchip/cdn-dp-core.c                         |    1 
 drivers/gpu/drm/rockchip/cdn-dp-reg.c                          |    2 
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c                |   36 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c                    |    1 
 drivers/gpu/drm/rockchip/rockchip_lvds.c                       |    4 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                 |    4 
 drivers/gpu/drm/vmwgfx/device_include/svga3d_surfacedefs.h     |    8 
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c                        |   20 -
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c                        |   13 
 drivers/hid/hid-core.c                                         |   10 
 drivers/hid/wacom_wac.h                                        |    2 
 drivers/hv/connection.c                                        |    4 
 drivers/hv/hv_util.c                                           |    4 
 drivers/hwmon/lm70.c                                           |   48 --
 drivers/hwmon/max31722.c                                       |    9 
 drivers/hwmon/max31790.c                                       |   49 +-
 drivers/hwtracing/coresight/coresight-core.c                   |    2 
 drivers/iio/accel/bma180.c                                     |   19 -
 drivers/iio/accel/bma220_spi.c                                 |   10 
 drivers/iio/accel/hid-sensor-accel-3d.c                        |   13 
 drivers/iio/accel/kxcjk-1013.c                                 |   24 -
 drivers/iio/accel/mxc4005.c                                    |   10 
 drivers/iio/accel/stk8312.c                                    |   12 
 drivers/iio/accel/stk8ba50.c                                   |   17 
 drivers/iio/adc/at91-sama5d2_adc.c                             |    3 
 drivers/iio/adc/hx711.c                                        |    4 
 drivers/iio/adc/mxs-lradc-adc.c                                |    3 
 drivers/iio/adc/ti-ads1015.c                                   |   12 
 drivers/iio/adc/ti-ads8688.c                                   |    3 
 drivers/iio/adc/vf610_adc.c                                    |   10 
 drivers/iio/chemical/atlas-sensor.c                            |    4 
 drivers/iio/frequency/adf4350.c                                |    6 
 drivers/iio/gyro/bmg160_core.c                                 |   10 
 drivers/iio/humidity/am2315.c                                  |   16 
 drivers/iio/imu/adis16400.c                                    |    3 
 drivers/iio/imu/adis16475.c                                    |    2 
 drivers/iio/imu/adis_buffer.c                                  |    3 
 drivers/iio/light/isl29125.c                                   |   10 
 drivers/iio/light/ltr501.c                                     |   15 
 drivers/iio/light/tcs3414.c                                    |   10 
 drivers/iio/light/tcs3472.c                                    |   16 
 drivers/iio/light/vcnl4000.c                                   |    2 
 drivers/iio/light/vcnl4035.c                                   |    3 
 drivers/iio/magnetometer/bmc150_magn.c                         |   11 
 drivers/iio/magnetometer/hmc5843.h                             |    8 
 drivers/iio/magnetometer/hmc5843_core.c                        |    4 
 drivers/iio/magnetometer/rm3100-core.c                         |    3 
 drivers/iio/potentiostat/lmp91000.c                            |    4 
 drivers/iio/proximity/as3935.c                                 |   10 
 drivers/iio/proximity/isl29501.c                               |    2 
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c              |   10 
 drivers/iio/proximity/srf08.c                                  |   14 
 drivers/infiniband/core/cma.c                                  |   26 +
 drivers/infiniband/core/uverbs_cmd.c                           |   21 +
 drivers/infiniband/hw/mlx4/qp.c                                |    9 
 drivers/infiniband/hw/mlx5/main.c                              |    4 
 drivers/infiniband/hw/mlx5/qp.c                                |    6 
 drivers/infiniband/sw/rxe/rxe_net.c                            |   10 
 drivers/infiniband/sw/rxe/rxe_qp.c                             |    1 
 drivers/infiniband/sw/rxe/rxe_resp.c                           |    2 
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                         |   28 +
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c                   |    1 
 drivers/infiniband/ulp/rtrs/rtrs-srv.c                         |   39 +-
 drivers/infiniband/ulp/rtrs/rtrs.c                             |    1 
 drivers/infiniband/ulp/srp/ib_srp.c                            |   13 
 drivers/input/joydev.c                                         |    2 
 drivers/input/keyboard/Kconfig                                 |    3 
 drivers/input/keyboard/hil_kbd.c                               |    1 
 drivers/input/touchscreen/goodix.c                             |   52 --
 drivers/input/touchscreen/usbtouchscreen.c                     |    8 
 drivers/iommu/amd/init.c                                       |    4 
 drivers/iommu/dma-iommu.c                                      |    6 
 drivers/leds/Kconfig                                           |    1 
 drivers/leds/led-class.c                                       |    4 
 drivers/leds/leds-as3645a.c                                    |    1 
 drivers/leds/leds-ktd2692.c                                    |   27 -
 drivers/leds/leds-lm36274.c                                    |    1 
 drivers/leds/leds-lm3692x.c                                    |    8 
 drivers/leds/leds-lm3697.c                                     |    8 
 drivers/leds/leds-lp50xx.c                                     |    2 
 drivers/mailbox/qcom-apcs-ipc-mailbox.c                        |    2 
 drivers/mailbox/qcom-ipcc.c                                    |    6 
 drivers/media/cec/platform/s5p/s5p_cec.c                       |    7 
 drivers/media/common/siano/smscoreapi.c                        |   22 -
 drivers/media/common/siano/smscoreapi.h                        |    4 
 drivers/media/common/siano/smsdvb-main.c                       |    4 
 drivers/media/dvb-core/dvb_net.c                               |   25 +
 drivers/media/i2c/ir-kbd-i2c.c                                 |    4 
 drivers/media/i2c/ov2659.c                                     |   24 -
 drivers/media/i2c/s5c73m3/s5c73m3-core.c                       |    6 
 drivers/media/i2c/s5c73m3/s5c73m3.h                            |    2 
 drivers/media/i2c/s5k4ecgx.c                                   |   10 
 drivers/media/i2c/s5k5baf.c                                    |    6 
 drivers/media/i2c/s5k6aa.c                                     |   10 
 drivers/media/i2c/tc358743.c                                   |    1 
 drivers/media/mc/Makefile                                      |    2 
 drivers/media/pci/bt8xx/bt878.c                                |    6 
 drivers/media/pci/cobalt/cobalt-driver.c                       |    1 
 drivers/media/pci/cobalt/cobalt-driver.h                       |    7 
 drivers/media/pci/intel/ipu3/ipu3-cio2.c                       |   17 
 drivers/media/platform/am437x/am437x-vpfe.c                    |   15 
 drivers/media/platform/exynos-gsc/gsc-m2m.c                    |    4 
 drivers/media/platform/exynos4-is/fimc-capture.c               |    6 
 drivers/media/platform/exynos4-is/fimc-is.c                    |    4 
 drivers/media/platform/exynos4-is/fimc-isp-video.c             |   10 
 drivers/media/platform/exynos4-is/fimc-isp.c                   |    7 
 drivers/media/platform/exynos4-is/fimc-lite.c                  |    5 
 drivers/media/platform/exynos4-is/fimc-m2m.c                   |    5 
 drivers/media/platform/exynos4-is/media-dev.c                  |   10 
 drivers/media/platform/exynos4-is/mipi-csis.c                  |   10 
 drivers/media/platform/marvell-ccic/mcam-core.c                |    9 
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c                   |    6 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c         |    4 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c          |    8 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h          |    2 
 drivers/media/platform/omap3isp/isp.c                          |   79 +---
 drivers/media/platform/qcom/venus/core.c                       |   60 ++-
 drivers/media/platform/s5p-g2d/g2d.c                           |    3 
 drivers/media/platform/s5p-jpeg/jpeg-core.c                    |    5 
 drivers/media/platform/sh_vou.c                                |    6 
 drivers/media/platform/sti/bdisp/Makefile                      |    2 
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c                  |    7 
 drivers/media/platform/sti/delta/Makefile                      |    2 
 drivers/media/platform/sti/hva/Makefile                        |    2 
 drivers/media/platform/sti/hva/hva-hw.c                        |    3 
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c             |    9 
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.h             |    1 
 drivers/media/platform/sunxi/sun8i-rotate/sun8i_rotate.c       |    2 
 drivers/media/platform/video-mux.c                             |   18 
 drivers/media/usb/au0828/au0828-core.c                         |    4 
 drivers/media/usb/cpia2/cpia2.h                                |    1 
 drivers/media/usb/cpia2/cpia2_core.c                           |   12 
 drivers/media/usb/cpia2/cpia2_usb.c                            |   13 
 drivers/media/usb/dvb-usb/cinergyT2-core.c                     |    2 
 drivers/media/usb/dvb-usb/cxusb.c                              |    2 
 drivers/media/usb/em28xx/em28xx-input.c                        |    8 
 drivers/media/usb/gspca/gl860/gl860.c                          |    4 
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                        |    4 
 drivers/media/v4l2-core/v4l2-async.c                           |   24 -
 drivers/media/v4l2-core/v4l2-fh.c                              |    1 
 drivers/media/v4l2-core/v4l2-subdev.c                          |   24 -
 drivers/memstick/host/rtsx_usb_ms.c                            |   10 
 drivers/mfd/Kconfig                                            |    1 
 drivers/mfd/rn5t618.c                                          |    2 
 drivers/misc/eeprom/idt_89hpesx.c                              |    8 
 drivers/misc/habanalabs/common/habanalabs_drv.c                |    1 
 drivers/mmc/core/block.c                                       |    8 
 drivers/mmc/host/sdhci-sprd.c                                  |    1 
 drivers/mmc/host/usdhi6rol0.c                                  |    1 
 drivers/mmc/host/via-sdmmc.c                                   |    3 
 drivers/mmc/host/vub300.c                                      |    2 
 drivers/mtd/nand/raw/arasan-nand-controller.c                  |   90 +++-
 drivers/mtd/nand/raw/marvell_nand.c                            |    4 
 drivers/mtd/parsers/redboot.c                                  |    7 
 drivers/net/can/peak_canfd/peak_canfd.c                        |    4 
 drivers/net/can/usb/ems_usb.c                                  |    3 
 drivers/net/dsa/sja1105/sja1105_main.c                         |    6 
 drivers/net/ethernet/aeroflex/greth.c                          |    3 
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.h             |    4 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                 |    1 
 drivers/net/ethernet/emulex/benet/be_cmds.c                    |    6 
 drivers/net/ethernet/emulex/benet/be_main.c                    |    2 
 drivers/net/ethernet/ezchip/nps_enet.c                         |    4 
 drivers/net/ethernet/faraday/ftgmac100.c                       |    6 
 drivers/net/ethernet/google/gve/gve_main.c                     |    4 
 drivers/net/ethernet/ibm/ehea/ehea_main.c                      |    9 
 drivers/net/ethernet/ibm/ibmvnic.c                             |   36 +
 drivers/net/ethernet/intel/e1000e/netdev.c                     |   24 -
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                 |    3 
 drivers/net/ethernet/intel/i40e/i40e_main.c                    |   17 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                |    2 
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c           |   10 
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                       |   18 
 drivers/net/ieee802154/mac802154_hwsim.c                       |   11 
 drivers/net/macsec.c                                           |    4 
 drivers/net/phy/mscc/mscc_macsec.c                             |    2 
 drivers/net/phy/mscc/mscc_macsec.h                             |    2 
 drivers/net/vrf.c                                              |   14 
 drivers/net/vxlan.c                                            |    2 
 drivers/net/wireless/ath/ath10k/mac.c                          |    1 
 drivers/net/wireless/ath/ath10k/pci.c                          |   14 
 drivers/net/wireless/ath/ath11k/core.c                         |    3 
 drivers/net/wireless/ath/ath11k/mac.c                          |   10 
 drivers/net/wireless/ath/ath9k/main.c                          |    5 
 drivers/net/wireless/ath/carl9170/Kconfig                      |    8 
 drivers/net/wireless/ath/wcn36xx/main.c                        |   21 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    |   37 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c        |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c |    8 
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h                   |    4 
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                    |    3 
 drivers/net/wireless/marvell/mwifiex/pcie.c                    |   10 
 drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c            |    5 
 drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c           |    5 
 drivers/net/wireless/mediatek/mt76/tx.c                        |    2 
 drivers/net/wireless/realtek/rtw88/rtw8822c.c                  |   22 -
 drivers/net/wireless/rsi/rsi_91x_hal.c                         |    6 
 drivers/net/wireless/rsi/rsi_91x_mac80211.c                    |    3 
 drivers/net/wireless/rsi/rsi_91x_mgmt.c                        |    3 
 drivers/net/wireless/rsi/rsi_main.h                            |    1 
 drivers/net/wireless/st/cw1200/scan.c                          |   17 
 drivers/nvme/host/pci.c                                        |   26 -
 drivers/nvme/target/fc.c                                       |   10 
 drivers/of/fdt.c                                               |    8 
 drivers/of/of_reserved_mem.c                                   |    8 
 drivers/pci/controller/pci-hyperv.c                            |    3 
 drivers/perf/arm-cmn.c                                         |    2 
 drivers/perf/arm_smmuv3_pmu.c                                  |   18 
 drivers/perf/fsl_imx8_ddr_perf.c                               |    6 
 drivers/phy/socionext/phy-uniphier-pcie.c                      |   11 
 drivers/phy/ti/phy-dm816x-usb.c                                |   17 
 drivers/pinctrl/renesas/pfc-r8a7796.c                          |    3 
 drivers/pinctrl/renesas/pfc-r8a77990.c                         |    8 
 drivers/platform/x86/asus-nb-wmi.c                             |   77 ----
 drivers/platform/x86/toshiba_acpi.c                            |    1 
 drivers/platform/x86/touchscreen_dmi.c                         |   85 ++++
 drivers/regulator/da9052-regulator.c                           |    3 
 drivers/regulator/fan53880.c                                   |    2 
 drivers/regulator/hi655x-regulator.c                           |   16 
 drivers/regulator/mt6358-regulator.c                           |    2 
 drivers/regulator/uniphier-regulator.c                         |    1 
 drivers/rtc/rtc-stm32.c                                        |    6 
 drivers/s390/cio/chp.c                                         |    3 
 drivers/s390/cio/chsc.c                                        |    2 
 drivers/scsi/FlashPoint.c                                      |   32 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                           |    4 
 drivers/scsi/scsi_lib.c                                        |    1 
 drivers/scsi/scsi_transport_iscsi.c                            |    2 
 drivers/soundwire/stream.c                                     |   13 
 drivers/spi/spi-loopback-test.c                                |    2 
 drivers/spi/spi-meson-spicc.c                                  |    8 
 drivers/spi/spi-omap-100k.c                                    |    2 
 drivers/spi/spi-sun6i.c                                        |    6 
 drivers/spi/spi-topcliff-pch.c                                 |    4 
 drivers/spi/spi.c                                              |    8 
 drivers/ssb/scan.c                                             |    1 
 drivers/ssb/sdio.c                                             |    1 
 drivers/staging/fbtft/fb_agm1264k-fl.c                         |   20 -
 drivers/staging/fbtft/fb_bd663474.c                            |    4 
 drivers/staging/fbtft/fb_ili9163.c                             |    4 
 drivers/staging/fbtft/fb_ili9320.c                             |    1 
 drivers/staging/fbtft/fb_ili9325.c                             |    4 
 drivers/staging/fbtft/fb_ili9340.c                             |    1 
 drivers/staging/fbtft/fb_s6d1121.c                             |    4 
 drivers/staging/fbtft/fb_sh1106.c                              |    1 
 drivers/staging/fbtft/fb_ssd1289.c                             |    4 
 drivers/staging/fbtft/fb_ssd1325.c                             |    2 
 drivers/staging/fbtft/fb_ssd1331.c                             |    6 
 drivers/staging/fbtft/fb_ssd1351.c                             |    1 
 drivers/staging/fbtft/fb_upd161704.c                           |    4 
 drivers/staging/fbtft/fb_watterott.c                           |    1 
 drivers/staging/fbtft/fbtft-bus.c                              |    3 
 drivers/staging/fbtft/fbtft-core.c                             |   25 -
 drivers/staging/fbtft/fbtft-io.c                               |   12 
 drivers/staging/gdm724x/gdm_lte.c                              |   20 -
 drivers/staging/media/hantro/hantro_drv.c                      |   33 +
 drivers/staging/media/hantro/hantro_v4l2.c                     |    9 
 drivers/staging/media/imx/imx-media-csi.c                      |   28 -
 drivers/staging/media/imx/imx6-mipi-csi2.c                     |   19 -
 drivers/staging/media/imx/imx7-media-csi.c                     |   16 
 drivers/staging/media/imx/imx7-mipi-csis.c                     |   21 -
 drivers/staging/media/rkisp1/rkisp1-dev.c                      |   15 
 drivers/staging/media/rkvdec/rkvdec.c                          |   12 
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c               |    4 
 drivers/staging/media/sunxi/cedrus/cedrus_video.c              |    8 
 drivers/staging/mt7621-dts/mt7621.dtsi                         |    2 
 drivers/staging/rtl8712/hal_init.c                             |    3 
 drivers/staging/rtl8712/os_intfs.c                             |    4 
 drivers/staging/rtl8712/usb_intf.c                             |   24 -
 drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c          |    2 
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c                       |   19 -
 drivers/target/iscsi/cxgbit/cxgbit_target.c                    |   21 -
 drivers/thermal/cpufreq_cooling.c                              |    2 
 drivers/thunderbolt/test.c                                     |   14 
 drivers/tty/nozomi.c                                           |    9 
 drivers/tty/serial/8250/8250_omap.c                            |   62 +++
 drivers/tty/serial/8250/8250_port.c                            |   19 -
 drivers/tty/serial/8250/serial_cs.c                            |    2 
 drivers/tty/serial/fsl_lpuart.c                                |   14 
 drivers/tty/serial/mvebu-uart.c                                |   18 
 drivers/tty/serial/sh-sci.c                                    |    8 
 drivers/usb/class/cdc-acm.c                                    |    5 
 drivers/usb/dwc2/core.c                                        |   30 +
 drivers/usb/dwc3/core.c                                        |    3 
 drivers/usb/gadget/function/f_eem.c                            |   43 ++
 drivers/usb/gadget/function/f_fs.c                             |   65 +--
 drivers/usb/host/xhci-mem.c                                    |    1 
 drivers/usb/host/xhci-pci-renesas.c                            |   16 
 drivers/usb/typec/class.c                                      |    4 
 drivers/vfio/pci/vfio_pci.c                                    |   29 +
 drivers/video/backlight/lm3630a_bl.c                           |    4 
 drivers/video/fbdev/imxfb.c                                    |    2 
 drivers/visorbus/visorchipset.c                                |    6 
 fs/btrfs/Kconfig                                               |    2 
 fs/btrfs/delayed-inode.c                                       |   18 
 fs/btrfs/inode.c                                               |   16 
 fs/btrfs/send.c                                                |   11 
 fs/btrfs/sysfs.c                                               |    4 
 fs/btrfs/transaction.c                                         |    6 
 fs/btrfs/tree-log.c                                            |    1 
 fs/cifs/cifsglob.h                                             |    3 
 fs/cifs/connect.c                                              |    5 
 fs/cifs/smb2ops.c                                              |  133 +++++++
 fs/configfs/file.c                                             |   10 
 fs/crypto/fname.c                                              |   10 
 fs/crypto/keysetup.c                                           |   40 +-
 fs/dax.c                                                       |    3 
 fs/dlm/config.c                                                |    9 
 fs/dlm/lowcomms.c                                              |    2 
 fs/erofs/super.c                                               |    1 
 fs/exec.c                                                      |    4 
 fs/exfat/dir.c                                                 |    8 
 fs/ext4/extents.c                                              |    3 
 fs/ext4/extents_status.c                                       |    4 
 fs/ext4/ialloc.c                                               |   11 
 fs/ext4/inode.c                                                |    2 
 fs/ext4/mballoc.c                                              |    9 
 fs/ext4/super.c                                                |   10 
 fs/f2fs/data.c                                                 |    6 
 fs/fs-writeback.c                                              |   39 --
 fs/fuse/dev.c                                                  |   12 
 fs/fuse/dir.c                                                  |   25 +
 fs/gfs2/file.c                                                 |    4 
 fs/gfs2/ops_fstype.c                                           |    1 
 fs/io_uring.c                                                  |    2 
 fs/ntfs/inode.c                                                |    2 
 fs/ocfs2/filecheck.c                                           |    6 
 fs/ocfs2/stackglue.c                                           |    8 
 fs/open.c                                                      |   14 
 fs/proc/task_mmu.c                                             |    2 
 fs/pstore/Kconfig                                              |    1 
 include/asm-generic/preempt.h                                  |    2 
 include/clocksource/timer-ti-dm.h                              |    1 
 include/crypto/internal/hash.h                                 |    8 
 include/dt-bindings/clock/imx8mq-clock.h                       |   19 -
 include/linux/bio.h                                            |   12 
 include/linux/clocksource.h                                    |    2 
 include/linux/cred.h                                           |    2 
 include/linux/huge_mm.h                                        |  165 ++++-----
 include/linux/iio/common/cros_ec_sensors_core.h                |    2 
 include/linux/prandom.h                                        |    2 
 include/linux/swap.h                                           |    9 
 include/linux/tracepoint.h                                     |   10 
 include/linux/user_namespace.h                                 |    4 
 include/media/hevc-ctrls.h                                     |    3 
 include/media/media-dev-allocator.h                            |    2 
 include/media/v4l2-async.h                                     |   15 
 include/net/bluetooth/hci.h                                    |    6 
 include/net/bluetooth/hci_core.h                               |    8 
 include/net/ip.h                                               |   12 
 include/net/ip6_route.h                                        |   16 
 include/net/macsec.h                                           |    2 
 include/net/sch_generic.h                                      |   12 
 include/net/tc_act/tc_vlan.h                                   |    1 
 include/net/xfrm.h                                             |    1 
 include/net/xsk_buff_pool.h                                    |    9 
 include/scsi/fc/fc_ms.h                                        |    4 
 init/main.c                                                    |    6 
 kernel/bpf/verifier.c                                          |    6 
 kernel/cred.c                                                  |   41 ++
 kernel/fork.c                                                  |    8 
 kernel/kthread.c                                               |   19 -
 kernel/locking/lockdep.c                                       |  122 ++++++
 kernel/rcu/tree.c                                              |    2 
 kernel/sched/core.c                                            |   45 +-
 kernel/sched/deadline.c                                        |    2 
 kernel/sched/fair.c                                            |    8 
 kernel/sched/psi.c                                             |   12 
 kernel/sched/rt.c                                              |   17 
 kernel/smpboot.c                                               |    1 
 kernel/sys.c                                                   |   12 
 kernel/time/clocksource.c                                      |  113 +++++-
 kernel/trace/bpf_trace.c                                       |    3 
 kernel/trace/trace_events_hist.c                               |    7 
 kernel/tracepoint.c                                            |   33 +
 kernel/ucount.c                                                |   40 ++
 kernel/user_namespace.c                                        |    3 
 lib/Kconfig.debug                                              |    1 
 lib/iov_iter.c                                                 |    9 
 lib/kstrtox.c                                                  |   13 
 lib/kstrtox.h                                                  |    2 
 lib/locking-selftest.c                                         |    1 
 lib/math/rational.c                                            |   16 
 lib/seq_buf.c                                                  |    4 
 lib/vsprintf.c                                                 |   82 ++--
 mm/debug_vm_pgtable.c                                          |  149 ++++++--
 mm/gup.c                                                       |   58 ++-
 mm/huge_memory.c                                               |   19 -
 mm/hugetlb.c                                                   |   36 -
 mm/khugepaged.c                                                |    4 
 mm/memcontrol.c                                                |    8 
 mm/memory.c                                                    |   11 
 mm/page_alloc.c                                                |   33 -
 mm/shmem.c                                                     |   17 
 mm/slab.h                                                      |    1 
 mm/z3fold.c                                                    |    3 
 net/bluetooth/hci_event.c                                      |   27 -
 net/bluetooth/hci_request.c                                    |   63 +--
 net/bluetooth/mgmt.c                                           |    3 
 net/bpfilter/main.c                                            |    2 
 net/can/bcm.c                                                  |    7 
 net/can/gw.c                                                   |    3 
 net/can/isotp.c                                                |    7 
 net/can/j1939/main.c                                           |    4 
 net/can/j1939/socket.c                                         |    5 
 net/core/filter.c                                              |    4 
 net/ipv4/esp4.c                                                |    2 
 net/ipv4/fib_frontend.c                                        |    2 
 net/ipv4/route.c                                               |    3 
 net/ipv6/esp6.c                                                |    2 
 net/ipv6/exthdrs.c                                             |   31 -
 net/ipv6/ip6_tunnel.c                                          |    4 
 net/mac80211/mlme.c                                            |    9 
 net/mac80211/sta_info.c                                        |    5 
 net/mptcp/subflow.c                                            |    6 
 net/mptcp/token.c                                              |    6 
 net/netfilter/nf_tables_offload.c                              |   17 
 net/netfilter/nft_exthdr.c                                     |    3 
 net/netfilter/nft_osf.c                                        |    5 
 net/netfilter/nft_tproxy.c                                     |    9 
 net/netlabel/netlabel_mgmt.c                                   |   19 -
 net/qrtr/ns.c                                                  |    4 
 net/sched/act_vlan.c                                           |    7 
 net/sched/cls_tcindex.c                                        |    2 
 net/sched/sch_qfq.c                                            |    8 
 net/sunrpc/sched.c                                             |   12 
 net/tipc/bcast.c                                               |    2 
 net/tipc/msg.c                                                 |   17 
 net/tipc/msg.h                                                 |    3 
 net/tls/tls_sw.c                                               |    2 
 net/xdp/xsk_queue.h                                            |   11 
 net/xfrm/xfrm_device.c                                         |    1 
 net/xfrm/xfrm_output.c                                         |    7 
 net/xfrm/xfrm_state.c                                          |   14 
 samples/bpf/xdp_redirect_user.c                                |    4 
 scripts/Makefile.build                                         |    5 
 scripts/tools-support-relr.sh                                  |    3 
 security/integrity/evm/evm_main.c                              |    5 
 security/integrity/evm/evm_secfs.c                             |   13 
 sound/firewire/amdtp-stream.c                                  |    7 
 sound/firewire/motu/motu-protocol-v2.c                         |    5 
 sound/pci/hda/patch_realtek.c                                  |   49 ++
 sound/pci/intel8x0.c                                           |    2 
 sound/soc/atmel/atmel-i2s.c                                    |   34 +
 sound/soc/codecs/cs42l42.h                                     |    2 
 sound/soc/codecs/max98373-sdw.c                                |   12 
 sound/soc/codecs/max98373.h                                    |    2 
 sound/soc/codecs/rk3328_codec.c                                |   28 +
 sound/soc/codecs/rt1308-sdw.c                                  |    2 
 sound/soc/codecs/rt5682-i2c.c                                  |    1 
 sound/soc/codecs/rt5682-sdw.c                                  |   23 -
 sound/soc/codecs/rt700-sdw.c                                   |    2 
 sound/soc/codecs/rt711-sdw.c                                   |    2 
 sound/soc/codecs/rt715-sdw.c                                   |    2 
 sound/soc/fsl/fsl_spdif.c                                      |   23 +
 sound/soc/hisilicon/hi6210-i2s.c                               |   14 
 sound/soc/intel/boards/sof_sdw.c                               |    1 
 sound/soc/mediatek/common/mtk-btcvsd.c                         |   24 -
 sound/soc/sh/rcar/adg.c                                        |    4 
 sound/usb/format.c                                             |    2 
 sound/usb/mixer.c                                              |    8 
 sound/usb/mixer.h                                              |    1 
 sound/usb/mixer_scarlett_gen2.c                                |    7 
 tools/bpf/bpftool/main.c                                       |    4 
 tools/bpf/resolve_btfids/main.c                                |    3 
 tools/perf/util/llvm-utils.c                                   |    2 
 tools/perf/util/scripting-engines/trace-event-python.c         |  146 ++++----
 tools/testing/selftests/bpf/.gitignore                         |    1 
 tools/testing/selftests/ftrace/test.d/event/event-no-pid.tc    |    7 
 tools/testing/selftests/lkdtm/run.sh                           |   12 
 tools/testing/selftests/splice/short_splice_read.sh            |  119 +++++-
 tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py   |    2 
 tools/testing/selftests/vm/protection_keys.c                   |   12 
 641 files changed, 5138 insertions(+), 2789 deletions(-)

Adrian Hunter (1):
      perf scripting python: Fix tuple_set_u64()

Al Viro (2):
      copy_page_to_iter(): fix ITER_DISCARD case
      iov_iter_fault_in_readable() should do nothing in xarray case

Alex Bee (1):
      drm: rockchip: set alpha_en to 0 if it is not used

Alex Williamson (1):
      vfio/pci: Handle concurrent vma faults

Alexander Aring (2):
      fs: dlm: cancel work sync othercon
      fs: dlm: fix memory leak when fenced

Alexander Larkin (1):
      Input: joydev - prevent use of not validated data in JSIOCSBTNMAP ioctl

Alexander Monakov (1):
      iommu/amd: Fix extended features logging

Alexandru Elisei (1):
      KVM: arm64: Don't zero the cycle count register when PMCR_EL0.P is set

Alexey Gladkov (1):
      Add a reference to ucounts for each cred

Alvin Šipraga (2):
      brcmfmac: fix setting of station info chains bitmask
      brcmfmac: correctly report average RSSI in station info

Andreas Gruenbacher (2):
      gfs2: Fix underflow in gfs2_page_mkwrite
      gfs2: Fix error handling in init_statfs

Andreas Kemnade (1):
      mfd: rn5t618: Fix IRQ trigger by changing it to level mode

Andrew Gabbasov (1):
      usb: gadget: f_fs: Fix setting of device and driver data cross-references

Andrzej Pietrasiewicz (2):
      media: hantro: Fix .buf_prepare
      media: cedrus: Fix .buf_prepare

Andy Chi (3):
      ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 450 G8
      ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 445 G8
      ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 630 G8

Andy Shevchenko (16):
      spi: Allow to have all native CSs in use along with GPIOs
      spi: Avoid undefined behaviour when counting unused native CSs
      net: mvpp2: Put fwnode in error case during ->probe()
      net: pch_gbe: Propagate error from devm_gpio_request_one()
      staging: fbtft: Rectify GPIO handling
      staging: fbtft: Don't spam logs when probe is deferred
      backlight: lm3630a_bl: Put fwnode in error case during ->probe()
      leds: class: The -ENOTSUPP should never be seen by user space
      leds: lm3532: select regmap I2C API
      leds: lm36274: Put fwnode in error case during ->probe()
      leds: lm3692x: Put fwnode in any case during ->probe()
      leds: lm3697: Don't spam logs when probe is deferred
      leds: lp50xx: Put fwnode in error case during ->probe()
      eeprom: idt_89hpesx: Put fwnode in matching case during ->probe()
      eeprom: idt_89hpesx: Restore printing the unsupported fwnode name
      powerpc/papr_scm: Properly handle UUID types and API

Aneesh Kumar K.V (1):
      mm/pmem: avoid inserting hugepage PTE entry with fsdax if hugepage support is disabled

Anirudh Rayabharam (2):
      ext4: fix kernel infoleak via ext4_extent_header
      media: pvrusb2: fix warning in pvr2_i2c_core_done

Anshuman Khandual (4):
      arm64/mm: Fix ttbr0 values stored in struct thread_info for software-pan
      mm/debug_vm_pgtable/basic: add validation for dirtiness after write protect
      mm/debug_vm_pgtable/basic: iterate over entire protection_map[]
      mm/debug_vm_pgtable: ensure THP availability via has_transparent_hugepage()

Antoine Tenart (4):
      vrf: do not push non-ND strict packets with a source LLA through packet taps again
      net: macsec: fix the length used to copy the key for offloading
      net: phy: mscc: fix macsec key length
      net: atlantic: fix the macsec key length

Ard Biesheuvel (1):
      crypto: shash - avoid comparing pointers to exported functions under CFI

Arnaldo Carvalho de Melo (1):
      perf llvm: Return -ENOMEM when asprintf() fails

Arnd Bergmann (3):
      ia64: mca_drv: fix incorrect array size calculation
      media: subdev: remove VIDIOC_DQEVENT_TIME32 handling
      mwifiex: re-fix for unaligned accesses

Axel Lin (3):
      regulator: da9052: Ensure enough delay time for .set_voltage_time_sel
      regulator: fan53880: Fix vsel_mask setting for FAN53880_BUCK
      regulator: hi655x: Fix pass wrong pointer to config.driver_data

Ayush Sawal (1):
      xfrm: Fix xfrm offload fallback fail case

Bailey Forrest (1):
      gve: Fix swapped vars when fetching max queues

Baochen Qiang (1):
      bus: mhi: Wait for M2 state during system resume

Bard Liao (1):
      ASoC: rt5682-sdw: set regcache_cache_only false before reading RT5682_DEVICE_ID

Bart Van Assche (1):
      RDMA/srp: Fix a recently introduced memory leak

Bean Huo (1):
      mmc: block: Disable CMDQ on the ioctl path

Bixuan Cui (2):
      crypto: nx - add missing MODULE_DEVICE_TABLE
      EDAC/ti: Add missing MODULE_DEVICE_TABLE

Bob Pearson (1):
      RDMA/rxe: Fix qp reference counting for atomic ops

Boqun Feng (2):
      locking/lockdep: Fix the dep path printing for backwards BFS
      lockding/lockdep: Avoid to find wrong lock dep path in check_irq_usage()

Boris Sukholitko (1):
      net/sched: act_vlan: Fix modify to allow 0

Bryan O'Donoghue (1):
      wcn36xx: Move hal_buf allocation to devm_kmalloc in probe

Charles Keepax (1):
      spi: Make of_register_spi_device also set the fwnode

Chris Chiu (1):
      ACPI: EC: Make more Asus laptops use ECDT _GPE

Christian Brauner (1):
      open: don't silently ignore unknown O-flags in openat2()

Christoph Hellwig (1):
      mark pstore-blk as broken

Christophe JAILLET (14):
      crypto: ccp - Fix a resource leak in an error handling path
      media: rc: i2c: Fix an error message
      video: fbdev: imxfb: Fix an error message
      drm/rockchip: lvds: Fix an error handling path
      brcmsmac: mac80211_if: Fix a resource leak in an error handling path
      ath11k: Fix an error handling path in ath11k_core_fetch_board_data_api_n()
      tty: nozomi: Fix a resource leak in an error handling function
      firmware: stratix10-svc: Fix a resource leak in an error handling path
      tty: nozomi: Fix the error handling path of 'nozomi_card_init()'
      ASoC: mediatek: mtk-btcvsd: Fix an error handling path in 'mtk_btcvsd_snd_probe()'
      habanalabs: Fix an error handling path in 'hl_pci_probe()'
      phy: ti: dm816x: Fix the error handling path in 'dm816x_usb_phy_probe()
      leds: ktd2692: Fix an error handling path
      ALSA: firewire-lib: Fix 'amdtp_domain_start()' when no AMDTP_OUT_STREAM stream is found

Christophe Leroy (1):
      btrfs: disable build on platforms having page size 256K

Chung-Chiang Cheng (1):
      configfs: fix memleak in configfs_release_bin_file

Clément Lassieur (1):
      usb: dwc2: Don't reset the core after setting turnaround time

Codrin Ciubotariu (1):
      ASoC: atmel-i2s: Fix usage of capture and playback at the same time

Colin Ian King (3):
      drm/rockchip: cdn-dp: fix sign extension on an int multiply for a u64 result
      drm: qxl: ensure surf.data is ininitialized
      fsi: core: Fix return of error values on failures

Connor Abbott (1):
      Bluetooth: btqca: Don't modify firmware contents in-place

Corentin Labbe (3):
      crypto: ixp4xx - dma_unmap the correct address
      crypto: ixp4xx - update IV after requests
      mtd: partitions: redboot: seek fis-index-block in the right node

Cristian Ciocaltea (4):
      clk: actions: Fix UART clock dividers on Owl S500 SoC
      clk: actions: Fix SD clocks factor table on Owl S500 SoC
      clk: actions: Fix bisp_factor_table based clocks on Owl S500 SoC
      clk: actions: Fix AHPPREDIV-H-AHB clock chain on Owl S500 SoC

Daehwan Jung (1):
      ALSA: usb-audio: fix rate on Ozone Z90 USB headset

Dan Carpenter (5):
      media: au0828: fix a NULL vs IS_ERR() check
      ocfs2: fix snprintf() checking
      serial: 8250_omap: fix a timeout loop condition
      staging: gdm724x: check for buffer overflow in gdm_lte_multi_sdu_pkt()
      staging: gdm724x: check for overflow in gdm_lte_netif_rx()

Daniel Xu (1):
      selftests/bpf: Whitelist test_progs.h from .gitignore

Dany Madden (1):
      Revert "ibmvnic: remove duplicate napi_schedule call in open function"

Dave Hansen (3):
      selftests/vm/pkeys: fix alloc_random_pkey() to make it really, really random
      selftests/vm/pkeys: handle negative sys_pkey_alloc() return code
      selftests/vm/pkeys: refill shadow register after implicit kernel write

Dave Stevenson (1):
      staging: mmal-vchiq: Fix incorrect static vchiq_instance.

David Sterba (4):
      btrfs: compression: don't try to compress if we don't have enough pages
      btrfs: clear defrag status of a root if starting transaction fails
      btrfs: sysfs: fix format string for some discard stats
      btrfs: clear log tree recovering status if starting transaction fails

Desmond Cheong Zhi Xi (1):
      ntfs: fix validity check for file name attribute

Dillon Min (2):
      media: i2c: ov2659: Use clk_{prepare_enable,disable_unprepare}() to set xvclk on/off
      media: s5p-g2d: Fix a memory leak on ctx->fh.m2m_ctx

Dinghao Liu (1):
      i40e: Fix error handling in i40e_vsi_open

Dinh Nguyen (3):
      clk: agilex/stratix10/n5x: fix how the bypass_reg is handled
      clk: agilex/stratix10: remove noc_clk
      clk: agilex/stratix10: fix bypass representation

Dmitry Osipenko (1):
      clk: tegra30: Use 300MHz for video decoder by default

Dmitry Torokhov (1):
      HID: do not use down_interruptible() when unbinding devices

Dongliang Mu (3):
      media: dvd_usb: memory leak in cinergyt2_fe_attach
      ieee802154: hwsim: Fix possible memory leak in hwsim_subscribe_all_others
      ieee802154: hwsim: Fix memory leak in hwsim_add_one

Douglas Anderson (1):
      drm/bridge: Fix the stop condition of drm_bridge_chain_pre_enable()

Dwaipayan Ray (1):
      ACPI: Use DEVICE_ATTR_<RW|RO|WO> macros

Eddie James (2):
      fsi: scom: Reset the FSI2PIB engine for any error
      fsi: occ: Don't accept response from un-initialized OCC

Elia Devito (1):
      ALSA: hda/realtek: Improve fixup for HP Spectre x360 15-df0xxx

Eric Biggers (2):
      fscrypt: don't ignore minor_hash when hash is 0
      fscrypt: fix derivation of SipHash keys on big endian CPUs

Eric Dumazet (5):
      pkt_sched: sch_qfq: fix qfq_change_class() error path
      vxlan: add missing rcu_read_lock() in neigh_reduce()
      ieee802154: hwsim: avoid possible crash in hwsim_del_edge_nl()
      ipv6: exthdrs: do not blindly use init_net
      ipv6: fix out-of-bound access in ip6_parse_tlv()

Erik Kaneda (1):
      ACPICA: Fix memory leak caused by _CID repair function

Evgeny Novikov (1):
      media: st-hva: Fix potential NULL pointer dereferences

Ezequiel Garcia (2):
      media: rkvdec: Fix .buf_prepare
      media: v4l2-async: Clean v4l2_async_notifier_add_fwnode_remote_subdev

Felix Fietkau (1):
      mac80211: remove iwlwifi specific workaround that broke sta NDP tx

Filipe Manana (1):
      btrfs: send: fix invalid path for unlink operations after parent orphanization

Gary Lin (1):
      bpfilter: Specify the log level for the kmsg message

Geert Uytterhoeven (3):
      pinctrl: renesas: r8a7796: Add missing bias for PRESET# pin
      pinctrl: renesas: r8a77990: JTAG pins do not have pull-down capabilities
      of: Fix truncation of memory sizes on 32-bit platforms

Gioh Kim (3):
      RDMA/rtrs: Do not reset hb_missed_max after re-connection
      RDMA/rtrs-srv: Fix memory leak of unfreed rtrs_srv_stats object
      RDMA/rtrs-clt: Fix memory leak of not-freed sess->stats and stats->pcpu_stats

Greg Kroah-Hartman (1):
      Linux 5.10.50

Greg Kurz (3):
      fuse: Fix crash in fuse_dentry_automount() error path
      fuse: Fix crash if superblock of submount gets killed early
      fuse: Fix infinite loop in sget_fc()

Guenter Roeck (5):
      hwmon: (max31790) Report correct current pwm duty cycles
      hwmon: (max31790) Fix pwmX_enable attributes
      hwmon: (lm70) Revert "hwmon: (lm70) Add support for ACPI"
      hwmon: (max31722) Remove non-standard ACPI device IDs
      hwmon: (max31790) Fix fan speed reporting for fan7..12

Guo Ren (1):
      csky: syscache: Fixup duplicate cache flush

Gustavo A. R. Silva (1):
      media: siano: Fix out-of-bounds warnings in smscore_load_firmware_family2()

Haiyang Zhang (1):
      PCI: hv: Add check for hyperv_initialized in init_hv_pci_drv()

Hang Zhang (1):
      cw1200: Revert unnecessary patches that fix unreal use-after-free bugs

Hangbin Liu (1):
      crypto: x86/curve25519 - fix cpu feature checking logic in mod_exit

Hanjun Guo (1):
      ACPI: bus: Call kobject_put() in acpi_init() error path

Hannes Reinecke (1):
      nvmet-fc: do not check for invalid target port in nvmet_fc_handle_fcp_rqst()

Hannu Hartikainen (1):
      USB: cdc-acm: blacklist Heimann USB Appset device

Hans Verkuil (1):
      media: cobalt: fix race condition in setting HPD

Hans de Goede (3):
      Input: goodix - platform/x86: touchscreen_dmi - Move upside down quirks to touchscreen_dmi.c
      platform/x86: touchscreen_dmi: Add an extra entry for the upside down Goodix touchscreen on Teclast X89 tablets
      platform/x86: touchscreen_dmi: Add info for the Goodix GT912 panel of TM800A550L tablets

Heiko Carstens (2):
      KVM: s390: get rid of register asm usage
      s390/irq: select HAVE_IRQ_EXIT_ON_IRQ_STACK

Herbert Xu (1):
      crypto: nx - Fix RCU warning in nx842_OF_upd_status

Hongbo Li (1):
      crypto: sm2 - fix a memory leak in sm2

Hsin-Hsiung Wang (1):
      regulator: mt6358: Fix vdram2 .vsel_mask

Hui Wang (1):
      ACPI: resources: Add checks for ACPI IRQ override

Håkon Bugge (2):
      RDMA/cma: Protect RMW with qp_mutex
      RDMA/cma: Fix incorrect Packet Lifetime calculation

Igor Matheus Andrade Torrente (1):
      media: em28xx: Fix possible memory leak of em28xx struct

JK Kim (1):
      nvme-pci: fix var. type for increasing cq_head

Jack Wang (2):
      RDMA/rtrs-srv: Fix memory leak when having multiple sessions
      RDMA/rtrs-srv: Set minimal max_send_wr and max_recv_wr

Jack Xu (2):
      crypto: qat - check return code of qat_hal_rd_rel_reg()
      crypto: qat - remove unused macro in FW loader

Jakub Kicinski (2):
      tls: prevent oversized sendfile() hangs by ignoring MSG_MORE
      ip6_tunnel: fix GRE6 segmentation

Jan Kara (2):
      ext4: fix overflow in ext4_iomap_alloc()
      dax: fix ENOMEM handling in grab_mapping_entry()

Jan Sokolowski (1):
      i40e: Fix missing rtnl locking when setting up pf switch

Jann Horn (1):
      mm/gup: fix try_grab_compound_head() race with split_huge_page()

Janosch Frank (1):
      s390: mm: Fix secure storage access exception handling

Jarkko Sakkinen (1):
      tpm: Replace WARN_ONCE() with dev_err_once() in tpm_tis_status()

Jason Gerecke (1):
      HID: wacom: Correct base usage for capacitive ExpressKey status bits

Javed Hasan (1):
      scsi: fc: Correct RHBA attributes length

Javier Martinez Canillas (1):
      tpm_tis_spi: add missing SPI device ID entries

Jay Fang (2):
      spi: spi-loopback-test: Fix 'tx_buf' might be 'rx_buf'
      spi: spi-topcliff-pch: Fix potential double free in pch_spi_process_messages()

Jeremy Szu (2):
      ALSA: hda/realtek: fix mute/micmute LEDs for HP EliteBook x360 830 G8
      ALSA: hda/realtek: fix mute/micmute LEDs for HP EliteBook 830 G8 Notebook PC

Jernej Skrabec (1):
      media: hevc: Fix dependent slice segment flags

Jerome Brunet (1):
      clk: meson: g12a: fix gp0 and hifi ranges

Jian-Hong Pan (1):
      net: bcmgenet: Fix attaching to PYH failed on RPi 4B

Jianguo Wu (2):
      mptcp: fix pr_debug in mptcp_token_new_connect
      mptcp: generate subflow hmac after mptcp_finish_join()

Jiapeng Chong (2):
      drivers: hv: Fix missing error code in vmbus_connect()
      platform/x86: toshiba_acpi: Fix missing error code in toshiba_acpi_setup_keyboard()

Jing Xiangfeng (2):
      usb: typec: Add the missed altmode_id_remove() in typec_register_altmode()
      drivers/perf: fix the missed ida_simple_remove() in ddr_perf_probe()

Joachim Fenkes (2):
      fsi/sbefifo: Clean up correct FIFO when receiving reset request from SBE
      fsi/sbefifo: Fix reset timeout

Joe Richey (1):
      x86/elf: Use _BITUL() macro in UAPI headers

Joerg Roedel (4):
      crypto: ccp - Annotate SEV Firmware file names
      x86/sev: Make sure IRQs are disabled while GHCB is active
      x86/sev: Split up runtime #VC handler for correct state tracking
      iommu/dma: Fix compile warning in 32-bit builds

Johan Hovold (3):
      Input: usbtouchscreen - fix control-request directions
      media: gspca/gl860: fix zero-length control requests
      mmc: vub3000: fix control-request direction

John Fastabend (1):
      bpf: Fix null ptr deref with mixed tail calls and subprogs

Jonathan Cameron (30):
      iio: accel: bma180: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: accel: bma220: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: accel: hid: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: accel: kxcjk-1013: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: accel: mxc4005: Fix overread of data and alignment issue.
      iio: accel: stk8312: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: accel: stk8ba50: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: adc: ti-ads1015: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: adc: vf610: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: gyro: bmg160: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: humidity: am2315: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: prox: srf08: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: prox: pulsed-light: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: prox: as3935: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: magn: hmc5843: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: magn: bmc150: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: light: isl29125: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: light: tcs3414: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: light: tcs3472: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: chemical: atlas: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: cros_ec_sensors: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
      iio: potentiostat: lmp91000: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
      iio: adc: at91-sama5d2: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: adc: hx711: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: adc: mxs-lradc: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: adc: ti-ads8688: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
      iio: magn: rm3100: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
      iio: light: vcnl4000: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: light: vcnl4035: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
      iio: prox: isl29501: Fix buffer alignment in iio_push_to_buffers_with_timestamp()

Jonathan Marek (1):
      clk: qcom: clk-alpha-pll: fix CAL_L write in alpha_pll_fabia_prepare

Josef Bacik (2):
      btrfs: fix error handling in __btrfs_update_delayed_inode
      btrfs: abort transaction if we fail to update the delayed inode

Josh Poimboeuf (1):
      kbuild: Fix objtool dependency for 'OBJECT_FILES_NON_STANDARD_<obj> := n'

Junhao He (1):
      coresight: core: Fix use of uninitialized pointer

Kai Huang (1):
      KVM: x86/mmu: Fix return value in tdp_mmu_map_handle_target_level()

Kai Ye (1):
      crypto: hisilicon/sec - fixup 3des minimum key size declaration

Kamal Heib (1):
      RDMA/rxe: Fix failure during driver load

Kees Cook (5):
      selftests/lkdtm: Avoid needing explicit sub-shell
      crypto: nx - Fix memcpy() over-reading in nonce
      drm/pl111: depend on CONFIG_VEXPRESS_CONFIG
      drm/pl111: Actually fix CONFIG_VEXPRESS_CONFIG depends
      selftests: splice: Adjust for handler fallback removal

Kristian Klausen (1):
      loop: Fix missing discard support when using LOOP_CONFIGURE

Krzysztof Kozlowski (2):
      mmc: sdhci-sprd: use sdhci_sprd_writew
      selftests/ftrace: fix event-no-pid on 1-core machine

Krzysztof Wilczyński (1):
      ACPI: sysfs: Fix a buffer overrun problem with description_show()

Kunihiko Hayashi (1):
      phy: uniphier-pcie: Fix updating phy parameters

Kuninori Morimoto (1):
      ASoC: rsnd: tidyup loop on rsnd_adg_clk_query()

Laurent Pinchart (1):
      media: imx: imx7_mipi_csis: Fix logging of only error event counters

Leon Romanovsky (4):
      RDMA/core: Sanitize WQ state received from the userspace
      RDMA/mlx5: Don't add slave port to unaffiliated list
      RDMA/mlx5: Don't access NULL-cleared mpi pointer
      RDMA/core: Always release restrack object

Libin Yang (1):
      ASoC: Intel: sof_sdw: add SOF_RT715_DAI_ID_FIX for AlderLake

Linus Walleij (1):
      ARM: dts: ux500: Fix LED probing

Linyu Yuan (1):
      usb: gadget: eem: fix echo command packet response issue

Liu Shixin (2):
      mm/page_alloc: fix counting of managed_pages
      netlabel: Fix memory leak in netlbl_mgmt_add_common

Long Li (1):
      block: return the correct bvec when checking for gaps

Lorenzo Bianconi (2):
      mt76: fix possible NULL pointer dereference in mt76_tx
      mt76: mt7615: fix NULL pointer dereference in tx_prepare_skb()

Lorenzo Stoakes (1):
      mm: page_alloc: refactor setup_per_zone_lowmem_reserve()

Luca Ceresoli (1):
      clk: vc5: fix output disabling when enabling a FOD

Luca Coelho (1):
      iwlwifi: increase PNVM load timeout

Lucas Stach (1):
      clk: imx8mq: remove SYS PLL 1/2 clock gates

Ludovic Desroches (1):
      ARM: dts: at91: sama5d4: fix pinctrl muxing

Luiz Augusto von Dentz (4):
      Bluetooth: mgmt: Fix slab-out-of-bounds in tlv_data_is_valid
      Bluetooth: Fix not sending Set Extended Scan Response
      Bluetooth: Fix Set Extended (Scan Response) Data
      Bluetooth: Fix handling of HCI_LE_Advertising_Set_Terminated event

Lukasz Luba (1):
      thermal/cpufreq_cooling: Update offline CPUs per-cpu thermal_pressure

Luke D Jones (1):
      ACPI: video: use native backlight for GA401/GA502/GA503

Luke D. Jones (2):
      platform/x86: asus-nb-wmi: Revert "Drop duplicate DMI quirk structures"
      platform/x86: asus-nb-wmi: Revert "add support for ASUS ROG Zephyrus G14 and G15"

Lv Yunlong (2):
      media: v4l2-core: Avoid the dangling pointer in v4l2_fh_release
      media: exynos4-is: Fix a use after free in isp_video_release

Maciej W. Rozycki (1):
      serial: 8250: Actually allow UPF_MAGIC_MULTIPLIER baud rates

Maciej Żenczykowski (1):
      bpf: Do not change gso_size during bpf_skb_change_proto()

Magnus Karlsson (2):
      xsk: Fix missing validation for skb and unaligned mode
      xsk: Fix broken Tx ring validation

Marc Kleine-Budde (1):
      iio: ltr501: mark register holding upper 8 bits of ALS_DATA{0,1} and PS_DATA as volatile, too

Marcelo Ricardo Leitner (1):
      tc-testing: fix list handling

Marek Szyprowski (1):
      extcon: max8997: Add missing modalias string

Marek Vasut (1):
      rsi: Assign beacon rate settings to the correct rate_info descriptor field

Mario Limonciello (2):
      ACPI: processor idle: Fix up C-state latency if not ordered
      nvme-pci: look for StorageD3Enable on companion ACPI device instead

Mark Rutland (1):
      arm64: consistently use reserved_pg_dir

Martin Fuzzey (2):
      rtc: stm32: Fix unbalanced clk_disable_unprepare() on probe error path
      rsi: fix AP mode with WPA failure due to encrypted EAPOL

Mateusz Palczewski (1):
      i40e: Fix autoneg disabling for non-10GBaseT links

Matti Vaittinen (1):
      extcon: extcon-max8997: Fix IRQ freeing at error path

Mauro Carvalho Chehab (19):
      staging: media: rkvdec: fix pm_runtime_get_sync() usage count
      media: marvel-ccic: fix some issues when getting pm_runtime
      media: mdk-mdp: fix pm_runtime_get_sync() usage count
      media: s5p: fix pm_runtime_get_sync() usage count
      media: am437x: fix pm_runtime_get_sync() usage count
      media: sh_vou: fix pm_runtime_get_sync() usage count
      media: mtk-vcodec: fix PM runtime get logic
      media: s5p-jpeg: fix pm_runtime_get_sync() usage count
      media: sunxi: fix pm_runtime_get_sync() usage count
      media: sti/bdisp: fix pm_runtime_get_sync() usage count
      media: exynos4-is: fix pm_runtime_get_sync() usage count
      media: exynos-gsc: fix pm_runtime_get_sync() usage count
      media: sti: fix obj-$(config) targets
      media: dvb_net: avoid speculation from net slot
      media: siano: fix device register error path
      media: venus: Rework error fail recover logic
      media: s5p_cec: decrement usage count if disabled
      media: hantro: do a PM resume earlier
      media: exynos4-is: remove a now unused integer

Maxime Ripard (1):
      drm/vc4: hdmi: Fix error path of hpd-gpios

Md Haris Iqbal (2):
      RDMA/rtrs-clt: Check state of the rtrs_clt_sess before reading its stats
      RDMA/rtrs-clt: Check if the queue_depth has changed during a reconnection

Menglong Dong (1):
      net: tipc: fix FB_MTU eat two pages

Miao Wang (1):
      net/ipv4: swap flow ports when validating source

Miaohe Lin (8):
      swap: fix do_swap_page() race with swapoff
      mm/shmem: fix shmem_swapin() race with swapoff
      mm/huge_memory.c: remove dedicated macro HPAGE_CACHE_INDEX_MASK
      mm/huge_memory.c: add missing read-only THP checking in transparent_hugepage_enabled()
      mm/huge_memory.c: don't discard hugepage if other processes are mapping it
      mm/hugetlb: use helper huge_page_order and pages_per_huge_page
      mm/z3fold: fix potential memory leak in z3fold_destroy_pool()
      mm/z3fold: use release_z3fold_page_locked() to release locked z3fold page

Michael Buesch (1):
      ssb: sdio: Don't overwrite const buffer if block_write fails

Michael Ellerman (1):
      powerpc/stacktrace: Fix spurious "stale" traces in raise_backtrace_ipi()

Michael Walle (2):
      serial: fsl_lpuart: don't modify arbitrary data on lpuart32
      serial: fsl_lpuart: remove RTSCTS handling from get_mctrl()

Mika Westerberg (1):
      thunderbolt: Bond lanes only when dual_link_port != NULL in alloc_dev_default()

Mike Christie (1):
      scsi: iscsi: Flush block work before unblock

Mike Kravetz (1):
      hugetlb: remove prep_compound_huge_page cleanup

Miklos Szeredi (3):
      fuse: ignore PG_workingset after stealing
      fuse: check connected before queueing on fpq->io
      fuse: reject internal errno

Mimi Zohar (1):
      evm: fix writing <securityfs>/evm overflow

Minas Harutyunyan (1):
      usb: dwc3: Fix debugfs creation flow

Ming Lei (6):
      blk-mq: grab rq->refcount before calling ->fn in blk_mq_tagset_busy_iter
      blk-mq: clear stale request in tags->rq[] before freeing one request pool
      block: fix race between adding/removing rq qos and normal IO
      block: fix discard request merge
      block: avoid double io accounting for flush request
      blk-mq: update hctx->dispatch_busy in case of real scheduler

Miquel Raynal (1):
      mtd: rawnand: arasan: Ensure proper configuration for the asserted target

Mirko Vogt (1):
      spi: spi-sun6i: Fix chipselect/clock bug

Moritz Fischer (1):
      usb: renesas-xhci: Fix handling of unknown ROM state

Muchun Song (1):
      writeback: fix obtain a reference to a freeing memcg css

Namjae Jeon (1):
      exfat: handle wrong stream entry size in exfat_readdir()

Nathan Chancellor (2):
      KVM: PPC: Book3S HV: Workaround high stack usage with clang
      ACPI: bgrt: Fix CFI violation

Nicholas Piggin (3):
      powerpc/powernv: Fix machine check reporting of async store errors
      powerpc: Offline CPU in stop_this_cpu()
      powerpc/64s: Fix copy-paste data exposure into newly created tasks

Nick Desaulniers (1):
      Makefile: fix GDB warning with CONFIG_RELR

Niklas Schnelle (1):
      s390: enable HAVE_IOREMAP_PROT

Norbert Slusarek (1):
      can: j1939: j1939_sk_setsockopt(): prevent allocation of j1939 filter for optlen == 0

Nuno Sa (3):
      iio: adis_buffer: do not return ints in irq handlers
      iio: adis16400: do not return ints in irq handlers
      iio: adis16475: do not return ints in irq handlers

Odin Ugedal (1):
      sched/fair: Fix ascii art by relpacing tabs

Oleksij Rempel (1):
      can: j1939: j1939_sk_init(): set SOCK_RCU_FREE to call sk_destruct() after RCU is done

Oliver Hartkopp (2):
      can: gw: synchronize rcu operations before removing gw job entry
      can: isotp: isotp_release(): omit unintended hrtimer restart on socket release

Oliver Lang (2):
      iio: ltr501: ltr559: fix initialization of LTR501_ALS_CONTR
      iio: ltr501: ltr501_read_ps(): add missing endianness conversion

Ondrej Zary (2):
      serial_cs: Add Option International GSM-Ready 56K/ISDN modem
      serial_cs: remove wrong GLOBETROTTER.cis entry

Pablo Neira Ayuso (4):
      netfilter: nft_exthdr: check for IPv6 packet before further processing
      netfilter: nft_osf: check for TCP packet before further processing
      netfilter: nft_tproxy: restrict support to TCP and UDP transport protocols
      netfilter: nf_tables_offload: check FLOW_DISSECTOR_KEY_BASIC in VLAN transfer logic

Pali Rohár (5):
      serial: mvebu-uart: fix calculation of clock divisor
      ath9k: Fix kernel NULL pointer dereference during ath_reset_internal()
      serial: mvebu-uart: do not allow changing baudrate when uartclk is not available
      serial: mvebu-uart: correctly calculate minimal possible baudrate
      arm64: dts: marvell: armada-37xx: Fix reg for standard variant of UART

Pan Dong (1):
      ext4: fix avefreec in find_group_orlov

Paul E. McKenney (3):
      clocksource: Retry clock read if long delays detected
      clocksource: Check per-CPU clock synchronization when marked unstable
      rcu: Invoke rcu_spawn_core_kthreads() from rcu_spawn_gp_kthread()

Pavel Begunkov (1):
      io_uring: fix blocking inline submission

Pavel Skripkin (10):
      Bluetooth: hci_qca: fix potential GPF
      media: dvb-usb: fix wrong definition
      net: can: ems_usb: fix use-after-free in ems_usb_disconnect()
      media: cpia2: fix memory leak in cpia2_usb_probe
      net: ethernet: aeroflex: fix UAF in greth_of_remove
      net: ethernet: ezchip: fix UAF in nps_enet_remove
      net: ethernet: ezchip: fix error handling
      net: sched: fix warning in tcindex_alloc_perfect_hash
      staging: rtl8712: fix error handling in r871xu_drv_init
      staging: rtl8712: fix memory leak in rtl871x_load_fw_cb

Peter Zijlstra (2):
      lockdep: Fix wait-type for empty stack
      lockdep/selftests: Fix selftests vs PROVE_RAW_LOCK_NESTING

Petr Mladek (1):
      kthread_worker: fix return value when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()

Petr Oros (1):
      Revert "be2net: disable bh with spin_lock in be_process_mcc"

Philipp Zabel (1):
      media: video-mux: Skip dangling endpoints

Pierre-Louis Bossart (6):
      ASoC: max98373-sdw: use first_hw_init flag on resume
      ASoC: rt1308-sdw: use first_hw_init flag on resume
      ASoC: rt5682-sdw: use first_hw_init flag on resume
      ASoC: rt700-sdw: use first_hw_init flag on resume
      ASoC: rt711-sdw: use first_hw_init flag on resume
      ASoC: rt715-sdw: use first_hw_init flag on resume

Ping-Ke Shih (1):
      mac80211: remove iwlwifi specific workaround NDPs of null_response

Po-Hao Huang (1):
      rtw88: 8822c: fix lc calibration timing

Qais Yousef (3):
      sched/uclamp: Fix wrong implementation of cpu.uclamp.min
      sched/uclamp: Fix locking around cpu_util_update_eff()
      sched/uclamp: Fix uclamp_tg_restrict()

Qu Wenruo (1):
      btrfs: don't clear page extent mapped if we're not invalidating the full page

Quat Le (1):
      scsi: core: Retry I/O for Notify (Enable Spinup) Required error

Rafael J. Wysocki (2):
      ACPI: PM / fan: Put fan device IDs into separate header file
      cpufreq: Make cpufreq_online() call driver->offline() on errors

Ralph Campbell (1):
      include/linux/huge_mm.h: remove extern keyword

Randy Dunlap (8):
      media: I2C: change 'RST' to "RSET" to fix multiple build errors
      locking/lockdep: Reduce LOCKDEP dependency list
      m68k: atari: Fix ATARI_KBD_CORE kconfig unmet dependency warning
      wireless: carl9170: fix LEDS build errors & warnings
      scsi: FlashPoint: Rename si_flags field
      mfd: mp2629: Select MFD_CORE to fix build error
      s390: appldata depends on PROC_SYSCTL
      csky: fix syscache.c fallthrough warning

Richard Fitzgerald (5):
      lib: vsprintf: Fix handling of number field widths in vsscanf
      random32: Fix implicit truncation warning in prandom_seed_state()
      ACPI: tables: Add custom DSDT file as makefile prerequisite
      ASoC: cs42l42: Correct definition of CS42L42_ADC_PDN_MASK
      soundwire: stream: Fix test for DP prepare complete

Robert Foss (1):
      drm/bridge/sii8620: fix dependency on extcon

Robert Hancock (4):
      clk: si5341: Wait for DEVICE_READY on startup
      clk: si5341: Avoid divide errors due to bogus register contents
      clk: si5341: Check for input clock presence and PLL lock on startup
      clk: si5341: Update initialization magic

Roberto Sassu (2):
      evm: Execute evm_inode_init_security() only when an HMAC key is loaded
      evm: Refuse EVM_ALLOW_METADATA_WRITES only if an HMAC key is loaded

Robin Murphy (1):
      perf/smmuv3: Don't trample existing events with global filter

Roman Gushchin (1):
      writeback, cgroup: increment isw_nr_in_flight before grabbing an inode

Ronnie Sahlberg (1):
      cifs: improve fallocate emulation

Sabrina Dubroca (1):
      xfrm: xfrm_state_mtu should return at least 1280 for ipv6

Sasha Neftin (1):
      e1000e: Check the PCIm state

Sean Christopherson (6):
      KVM: nVMX: Handle split-lock #AC exceptions that happen in L2
      KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP shadow MMUs
      KVM: x86/mmu: Use MMU's role to detect CR4.SMEP value in nested NPT walk
      KVM: nVMX: Sync all PGDs on nested transition with shadow paging
      KVM: nVMX: Ensure 64-bit shift when checking VMFUNC bitmap
      KVM: nVMX: Don't clobber nested MMU's A/D status on EPTP switch

Seevalamuthu Mariappan (1):
      ath11k: send beacon template after vdev_start/restart during csa

Sergey Shtylyov (4):
      sata_highbank: fix deferred probing
      pata_rb532_cf: fix deferred probing
      pata_octeon_cf: avoid WARN_ON() in ata_host_activate()
      pata_ep93xx: fix deferred probing

Sergio Paracuellos (1):
      staging: mt7621-dts: fix pci address for PCI memory range

Shawn Guo (1):
      mailbox: qcom: Use PLATFORM_DEVID_AUTO to register platform device

Shengjiu Wang (2):
      ASoC: fsl_spdif: Fix error handler with pm_runtime_enable
      ASoC: fsl_spdif: Fix unexpected interrupt after suspend

Shin'ichiro Kawasaki (1):
      f2fs: Prevent swap file in LFS mode

Shuah Khan (1):
      media: Fix Media Controller API config checks

Shuming Fan (1):
      ASoC: rt5682: fix getting the wrong device id when the suspend_stress_test

Sibi Sankar (1):
      mailbox: qcom-ipcc: Fix IPCC mbox channel exhaustion

Srinath Mannam (1):
      iommu/dma: Fix IOVA reserve dma ranges

Stephan Gerhold (2):
      iio: accel: bma180: Fix BMA25x bandwidth register values
      extcon: sm5502: Drop invalid register write in sm5502_reg_data

Stephane Grosjean (1):
      can: peak_pciefd: pucan_handle_status(): fix a potential starvation issue in TX path

Stephen Boyd (2):
      hwmon: (lm70) Use device_get_match_data()
      ASoC: rt5682: Disable irq on shutdown

Stephen Brennan (1):
      ext4: use ext4_grp_locked_error in mb_find_extent

Steve French (1):
      cifs: fix missing spinlock around update to ses->status

Steve Longerbeam (1):
      media: imx-csi: Skip first few frames from a BT.656 source

Steven Rostedt (VMware) (2):
      tracing/histograms: Fix parsing of "sym-offset" modifier
      tracepoint: Add tracepoint_probe_register_may_exist() for BPF tracing

Sukadev Bhattiprolu (2):
      ibmvnic: set ltb->buff to NULL after freeing
      ibmvnic: free tx_pool if tso_pool alloc fails

Suman Anna (2):
      crypto: sa2ul - Fix leaks on failure paths with sa_dma_init()
      crypto: sa2ul - Fix pm_runtime enable in sa_ul_probe()

Suraj Jitindar Singh (1):
      KVM: PPC: Book3S HV: Fix TLB management on SMT8 POWER9 and POWER10 processors

Szymon Janc (1):
      Bluetooth: Remove spurious error message

Takashi Iwai (7):
      ALSA: usb-audio: Fix OOB access at proc output
      ALSA: usb-audio: scarlett2: Fix wrong resume call
      ALSA: intel8x0: Fix breakage at ac97 clock measurement
      ALSA: hda/realtek: Add another ALC236 variant support
      ALSA: hda/realtek: Fix bass speaker DAC mapping for Asus UM431D
      ALSA: hda/realtek: Apply LED fixup for HP Dragonfly G1, too
      drm/ast: Fix missing conversions to managed API

Takashi Sakamoto (1):
      ALSA: firewire-motu: fix stream format for MOTU 8pre FireWire

Thadeu Lima de Souza Cascardo (1):
      can: bcm: delay release of struct bcm_op after synchronize_rcu()

Thara Gopinath (1):
      crypto: qce: skcipher: Fix incorrect sg count for dma transfers

Thomas Hebb (1):
      drm/rockchip: dsi: move all lane config except LCDC mux to bind()

Thomas Hellstrom (2):
      drm/vmwgfx: Mark a surface gpu-dirty after the SVGA3dCmdDXGenMips command
      drm/vmwgfx: Fix cpu updates of coherent multisample surfaces

Tian Tao (2):
      spi: omap-100k: Fix the length judgment problem
      arm64: perf: Convert snprintf to sysfs_emit

Tianjia Zhang (1):
      crypto: sm2 - remove unnecessary reset operations

Tong Tiangen (2):
      crypto: nitrox - fix unchecked variable in nitrox_register_interrupts
      brcmfmac: Fix a double-free in brcmf_sdio_bus_reset

Tong Zhang (2):
      media: bt878: do not schedule tasklet when it is not setup
      memstick: rtsx_usb_ms: fix UAF

Tony Ambardar (1):
      bpf: Fix libelf endian handling in resolv_btfids

Tony Lindgren (1):
      clocksource/drivers/timer-ti-dm: Save and restore timer TIOCP_CFG

Tony Luck (1):
      EDAC/Intel: Do not load EDAC driver when running as a guest

Trent Piepho (1):
      lib/math/rational.c: fix divide by zero

Tuan Phan (1):
      perf/arm-cmn: Fix invalid pointer when access dtc object sharing the same IRQ number

Vadim Fedorenko (1):
      net: lwtunnel: handle MTU calculation in forwading

Vaibhav Jain (1):
      powerpc/papr_scm: Make 'perf_stats' invisible if perf-stats unavailable

Valentin Schneider (3):
      sched/core: Initialize the idle task with preemption disabled
      s390: preempt: Fix preempt_count initialization
      powerpc/preempt: Don't touch the idle task's preempt_count during hotplug

Varun Prakash (1):
      scsi: target: cxgbit: Unmap DMA buffer before calling target_execute_cmd()

Vignesh Raghavendra (3):
      net: ti: am65-cpsw-nuss: Fix crash when changing number of TX queues
      serial: 8250: 8250_omap: Disable RX interrupt after DMA enable
      serial: 8250: 8250_omap: Fix possible interrupt storm on K3 SoCs

Vincent Donnefort (2):
      sched/rt: Fix RT utilization tracking during policy change
      sched/rt: Fix Deadline utilization tracking during policy change

Vineeth Vijayan (1):
      s390/cio: dont call css_wait_for_slow_path() inside a lock

Vladimir Oltean (1):
      net: dsa: sja1105: fix NULL pointer dereference in sja1105_reload_cbs()

Waiman Long (1):
      mm: memcg/slab: properly set up gfp flags for objcg pointer array

Wang Hai (2):
      samples/bpf: Fix Segmentation fault for xdp_redirect command
      samples/bpf: Fix the error return code of xdp_redirect's main()

Wei Li (1):
      MIPS: Fix PKMAP with 32-bit MIPS huge page support

Wei Yongjun (3):
      net: qrtr: ns: Fix error return code in qrtr_ns_init()
      erofs: fix error return code in erofs_read_superblock()
      crypto: qce - fix error return code in qce_skcipher_async_req_handle()

Xiaofei Tan (1):
      ACPI: APEI: fix synchronous external aborts in user-mode

Xin Long (1):
      xfrm: remove the fragment check for ipv6 beet mode

Yanfei Xu (1):
      mm/hugetlb: remove redundant check in preparing and destroying gigantic page

Yang Jihong (1):
      arm_pmu: Fix write counter incorrect in ARMv7 big-endian mode

Yang Li (1):
      ath10k: Fix an error code in ath10k_add_interface()

Yang Yingliang (10):
      ext4: return error code when ext4_fill_flex_info() fails
      iio: frequency: adf4350: disable reg and clk on error in adf4350_probe()
      net: ftgmac100: add missing error return code in ftgmac100_probe()
      drm/rockchip: cdn-dp-core: add missing clk_disable_unprepare() on error in cdn_dp_grf_write()
      ath10k: go to path err_unsupported when chip id is not supported
      ath10k: add missing error return code in ath10k_pci_probe()
      ASoC: rk3328: fix missing clk_disable_unprepare() on error in rk3328_platform_probe()
      ASoC: hisilicon: fix missing clk_disable_unprepare() on error in hi6210_i2s_startup()
      mtd: rawnand: marvell: add missing clk_disable_unprepare() on error in marvell_nfc_resume()
      cred: add missing return error code when set_cred_ucounts() failed

Yingjie Wang (1):
      drm/amd/dc: Fix a missing check bug in dm_dp_mst_detect()

Yoshihiro Shimoda (1):
      serial: sh-sci: Stop dmaengine transfer in sci_stop_tx()

Yu Kuai (1):
      char: pcmcia: error out if 'num_bytes_read' is greater than 4 in set_protocol()

YueHaibing (2):
      hv_utils: Fix passing zero to 'PTR_ERR' warning
      PM / devfreq: Add missing error code in devfreq_add_device()

Yun Zhou (1):
      seq_buf: Make trace_seq_putmem_hex() support data longer than 8

Yunsheng Lin (1):
      net: sched: add barrier to ensure correct ordering for lockless qdisc

Zhang Qilong (1):
      crypto: omap-sham - Fix PM reference leak in omap sham ops

Zhang Rui (1):
      ACPI: EC: trust DSDT GPE for certain HP laptop

Zhang Xiaoxu (2):
      SUNRPC: Fix the batch tasks count wraparound.
      SUNRPC: Should wake up the privileged task firstly.

Zhang Yi (5):
      ext4: cleanup in-core orphan list if ext4_truncate() failed to get a transaction handle
      ext4: correct the cache_nr in tracepoint ext4_es_shrink_exit
      ext4: remove check for zero nr_to_scan in ext4_es_scan()
      blk-wbt: introduce a new disable state to prevent false positive by rwb_enabled()
      blk-wbt: make sure throttle is enabled properly

Zhangjiantao (Kirin, nanjing) (1):
      xhci: solve a double free problem while doing s4

Zhaoyang Huang (1):
      psi: Fix race between psi_trigger_create/destroy

Zhen Lei (11):
      crypto: ux500 - Fix error return code in hash_hw_final()
      media: tc358743: Fix error return code in tc358743_probe_of()
      mmc: usdhi6rol0: fix error return code in usdhi6_probe()
      ehea: fix error return code in ehea_restart_qps()
      ssb: Fix error return code in ssb_bus_scan()
      drm/msm: Fix error return code in msm_drm_init()
      drm/msm/dpu: Fix error return code in dpu_mdss_init()
      Input: hil_kbd - fix error return code in hil_dev_connect()
      visorbus: fix error return code in visorchipset_init()
      scsi: mpt3sas: Fix error return value in _scsih_expander_add()
      leds: as3645a: Fix error return code in as3645a_parse_node()

Zheyu Ma (2):
      media: bt8xx: Fix a missing check bug in bt878_probe
      mmc: via-sdmmc: add a check against NULL pointer dereference

Zhihao Cheng (1):
      tools/bpftool: Fix error return code in do_batch()

Zou Wei (1):
      regulator: uniphier: Add missing MODULE_DEVICE_TABLE

frank zago (1):
      iio: light: tcs3472: do not free unallocated IRQ

zhangyi (F) (1):
      block_dump: remove block_dump feature in mark_inode_dirty()

zpershuai (2):
      spi: meson-spicc: fix a wrong goto jump for avoiding memory leak.
      spi: meson-spicc: fix memory leak in meson_spicc_probe

Łukasz Stelmach (1):
      hwrng: exynos - Fix runtime PM imbalance on error

