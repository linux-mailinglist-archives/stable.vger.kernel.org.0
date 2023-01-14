Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496EE66AA89
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjANJk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjANJk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:40:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6480C1BD;
        Sat, 14 Jan 2023 01:40:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 875AEB80835;
        Sat, 14 Jan 2023 09:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46335C433D2;
        Sat, 14 Jan 2023 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689222;
        bh=htoziShYxk82VyZaGzaydn7Lrecnvk8fWVM652fQ0Jc=;
        h=From:To:Cc:Subject:Date:From;
        b=rxPdtAV/QX76w3r8+BP6gcTXcWNi/cBMfvOZV/OfF+9BL8vrc26PDGubrNNvnbeYS
         mJAlcd/cMRx96+Z5YAx8OeNwQgo0EQ4p8Tm1z+DgQRsYVoJBYO1ls1tgvyDbfYnUK1
         vwgOO9Z4V5dJwsCaOljbOOWAYTLkf4MAgAq7pRXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.163
Date:   Sat, 14 Jan 2023 10:40:17 +0100
Message-Id: <167368921811969@kroah.com>
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

I'm announcing the release of the 5.10.163 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/sound/qcom,wcd9335.txt            |    2 
 Documentation/driver-api/spi.rst                                    |    4 
 Documentation/fault-injection/fault-injection.rst                   |   16 
 MAINTAINERS                                                         |    2 
 Makefile                                                            |  105 
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
 arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts                   |    1 
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi                  |    2 
 arch/arm/include/asm/thread_info.h                                  |   13 
 arch/arm/mach-mmp/time.c                                            |   11 
 arch/arm/nwfpe/Makefile                                             |    6 
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts              |    3 
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts                         |   12 
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi                           |   22 
 arch/arm64/boot/dts/mediatek/mt6797.dtsi                            |    2 
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi                    |    6 
 arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dts                        |    2 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                               |    2 
 arch/arm64/boot/dts/qcom/msm8996.dtsi                               |   10 
 arch/arm64/boot/dts/qcom/sdm630.dtsi                                |    2 
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi                          |    4 
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts                          |    5 
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts                |    6 
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi                            |    1 
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi                           |    1 
 arch/arm64/include/asm/processor.h                                  |    4 
 arch/mips/bcm63xx/clk.c                                             |    2 
 arch/mips/cavium-octeon/executive/cvmx-helper-board.c               |    2 
 arch/mips/cavium-octeon/executive/cvmx-helper.c                     |    2 
 arch/mips/kernel/vpe-cmp.c                                          |    4 
 arch/mips/kernel/vpe-mt.c                                           |    4 
 arch/parisc/include/uapi/asm/mman.h                                 |   23 
 arch/parisc/kernel/sys_parisc.c                                     |   27 
 arch/parisc/kernel/syscalls/syscall.tbl                             |    2 
 arch/powerpc/kernel/rtas.c                                          |   20 
 arch/powerpc/perf/callchain.c                                       |    1 
 arch/powerpc/perf/hv-gpci-requests.h                                |    4 
 arch/powerpc/perf/hv-gpci.c                                         |   33 
 arch/powerpc/perf/hv-gpci.h                                         |    1 
 arch/powerpc/perf/req-gen/perf.h                                    |   20 
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c                       |    1 
 arch/powerpc/platforms/83xx/mpc832x_rdb.c                           |    2 
 arch/powerpc/platforms/pseries/eeh_pseries.c                        |   14 
 arch/powerpc/sysdev/xive/spapr.c                                    |    1 
 arch/powerpc/xmon/xmon.c                                            |   11 
 arch/riscv/include/asm/hugetlb.h                                    |    6 
 arch/riscv/include/asm/uaccess.h                                    |    2 
 arch/riscv/kernel/stacktrace.c                                      |   12 
 arch/x86/events/intel/uncore.h                                      |    1 
 arch/x86/events/intel/uncore_snb.c                                  |    3 
 arch/x86/events/intel/uncore_snbep.c                                |   48 
 arch/x86/hyperv/hv_init.c                                           |    2 
 arch/x86/kernel/cpu/bugs.c                                          |    2 
 arch/x86/kernel/cpu/mce/amd.c                                       |   37 
 arch/x86/kernel/cpu/mce/core.c                                      |   95 
 arch/x86/kernel/cpu/mce/internal.h                                  |   12 
 arch/x86/kernel/cpu/microcode/intel.c                               |    8 
 arch/x86/kernel/ftrace.c                                            |    2 
 arch/x86/kernel/kprobes/core.c                                      |   27 
 arch/x86/kernel/kprobes/opt.c                                       |   35 
 arch/x86/kernel/uprobes.c                                           |    4 
 arch/x86/kvm/vmx/nested.c                                           |   44 
 arch/x86/xen/smp.c                                                  |   24 
 arch/x86/xen/smp_pv.c                                               |   12 
 arch/x86/xen/spinlock.c                                             |    6 
 block/blk-mq-sysfs.c                                                |   11 
 crypto/cryptd.c                                                     |   36 
 crypto/tcrypt.c                                                     |    9 
 drivers/acpi/acpica/dsmethod.c                                      |   10 
 drivers/acpi/acpica/utcopy.c                                        |    7 
 drivers/ata/ahci.c                                                  |   32 
 drivers/ata/pata_ixp4xx_cf.c                                        |    2 
 drivers/base/class.c                                                |    5 
 drivers/base/dd.c                                                   |    6 
 drivers/base/power/runtime.c                                        |   18 
 drivers/block/drbd/drbd_main.c                                      |    4 
 drivers/bluetooth/btusb.c                                           |    6 
 drivers/bluetooth/hci_bcsp.c                                        |    2 
 drivers/bluetooth/hci_h5.c                                          |    2 
 drivers/bluetooth/hci_ll.c                                          |    2 
 drivers/bluetooth/hci_qca.c                                         |    2 
 drivers/char/hw_random/amd-rng.c                                    |   18 
 drivers/char/hw_random/geode-rng.c                                  |   36 
 drivers/char/ipmi/ipmi_msghandler.c                                 |   12 
 drivers/char/ipmi/ipmi_si_intf.c                                    |   27 
 drivers/char/tpm/eventlog/acpi.c                                    |   12 
 drivers/char/tpm/tpm_crb.c                                          |   31 
 drivers/char/tpm/tpm_ftpm_tee.c                                     |    8 
 drivers/char/tpm/tpm_tis.c                                          |    9 
 drivers/clk/imx/clk-imx8mn.c                                        |   12 
 drivers/clk/qcom/clk-krait.c                                        |    2 
 drivers/clk/qcom/gcc-sm8250.c                                       |    4 
 drivers/clk/renesas/r9a06g032-clocks.c                              |    3 
 drivers/clk/rockchip/clk-pll.c                                      |    1 
 drivers/clk/samsung/clk-pll.c                                       |    1 
 drivers/clk/socfpga/clk-gate.c                                      |   16 
 drivers/clk/socfpga/clk-periph.c                                    |    8 
 drivers/clk/socfpga/clk-pll.c                                       |   17 
 drivers/clk/st/clkgen-fsyn.c                                        |    5 
 drivers/clocksource/sh_cmt.c                                        |  102 
 drivers/clocksource/timer-ti-dm-systimer.c                          |    4 
 drivers/counter/stm32-lptimer-cnt.c                                 |    2 
 drivers/cpufreq/amd_freq_sensitivity.c                              |    2 
 drivers/cpufreq/cpufreq.c                                           |    2 
 drivers/cpufreq/qcom-cpufreq-hw.c                                   |    1 
 drivers/cpuidle/dt_idle_states.c                                    |    2 
 drivers/crypto/Kconfig                                              |    5 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c                 |    2 
 drivers/crypto/amlogic/amlogic-gxl-core.c                           |    1 
 drivers/crypto/amlogic/amlogic-gxl.h                                |    2 
 drivers/crypto/cavium/nitrox/nitrox_mbx.c                           |    1 
 drivers/crypto/ccree/cc_debugfs.c                                   |    2 
 drivers/crypto/ccree/cc_driver.c                                    |   10 
 drivers/crypto/hisilicon/qm.h                                       |    6 
 drivers/crypto/img-hash.c                                           |    8 
 drivers/crypto/n2_core.c                                            |    6 
 drivers/crypto/omap-sham.c                                          |    2 
 drivers/crypto/rockchip/rk3288_crypto.c                             |  193 
 drivers/crypto/rockchip/rk3288_crypto.h                             |   53 
 drivers/crypto/rockchip/rk3288_crypto_ahash.c                       |  199 
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c                    |  413 -
 drivers/devfreq/devfreq.c                                           |    6 
 drivers/devfreq/governor_userspace.c                                |   12 
 drivers/dio/dio.c                                                   |    8 
 drivers/edac/i10nm_base.c                                           |    3 
 drivers/firmware/efi/efi.c                                          |    4 
 drivers/firmware/efi/libstub/efistub.h                              |    2 
 drivers/firmware/efi/libstub/random.c                               |   42 
 drivers/firmware/raspberrypi.c                                      |    1 
 drivers/gpio/gpio-sifive.c                                          |    1 
 drivers/gpio/gpiolib-cdev.c                                         |   93 
 drivers/gpio/gpiolib.c                                              |   12 
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c                            |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                          |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                             |   13 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                          |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h                            |    5 
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c                  |   16 
 drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c               |    3 
 drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c               |    2 
 drivers/gpu/drm/amd/include/kgd_pp_interface.h                      |    3 
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c                    |    3 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c               |    3 
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c                      |    4 
 drivers/gpu/drm/bridge/adv7511/adv7511.h                            |    3 
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c                        |   18 
 drivers/gpu/drm/bridge/adv7511/adv7533.c                            |   25 
 drivers/gpu/drm/drm_connector.c                                     |    3 
 drivers/gpu/drm/drm_fourcc.c                                        |   11 
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c                               |   11 
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c                           |    5 
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c                        |    4 
 drivers/gpu/drm/i915/gvt/debugfs.c                                  |   17 
 drivers/gpu/drm/i915/gvt/scheduler.c                                |    1 
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c                           |    6 
 drivers/gpu/drm/mediatek/mtk_dpi.c                                  |   12 
 drivers/gpu/drm/meson/meson_viu.c                                   |    5 
 drivers/gpu/drm/msm/Makefile                                        |    2 
 drivers/gpu/drm/msm/dp/dp_display.c                                 |    2 
 drivers/gpu/drm/msm/hdmi/hdmi.c                                     |   78 
 drivers/gpu/drm/msm/hdmi/hdmi.h                                     |   30 
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c                              |   81 
 drivers/gpu/drm/msm/hdmi/hdmi_connector.c                           |  451 -
 drivers/gpu/drm/msm/hdmi/hdmi_hpd.c                                 |  269 
 drivers/gpu/drm/panel/panel-sitronix-st7701.c                       |   10 
 drivers/gpu/drm/panfrost/panfrost_drv.c                             |   27 
 drivers/gpu/drm/panfrost/panfrost_gem.c                             |   16 
 drivers/gpu/drm/panfrost/panfrost_gem.h                             |    5 
 drivers/gpu/drm/radeon/radeon_bios.c                                |   19 
 drivers/gpu/drm/rockchip/cdn-dp-core.c                              |    2 
 drivers/gpu/drm/rockchip/inno_hdmi.c                                |    2 
 drivers/gpu/drm/rockchip/rk3066_hdmi.c                              |    2 
 drivers/gpu/drm/rockchip/rockchip_lvds.c                            |   10 
 drivers/gpu/drm/sti/sti_dvo.c                                       |    7 
 drivers/gpu/drm/sti/sti_hda.c                                       |    7 
 drivers/gpu/drm/sti/sti_hdmi.c                                      |    7 
 drivers/gpu/drm/tegra/dc.c                                          |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                                 |    3 
 drivers/hid/hid-ids.h                                               |    3 
 drivers/hid/hid-mcp2221.c                                           |   12 
 drivers/hid/hid-multitouch.c                                        |    4 
 drivers/hid/hid-plantronics.c                                       |    9 
 drivers/hid/hid-sensor-custom.c                                     |    2 
 drivers/hid/wacom_sys.c                                             |    8 
 drivers/hid/wacom_wac.c                                             |    4 
 drivers/hid/wacom_wac.h                                             |    1 
 drivers/hsi/controllers/omap_ssi_core.c                             |   14 
 drivers/hv/ring_buffer.c                                            |   13 
 drivers/hwmon/Kconfig                                               |    1 
 drivers/hwmon/jc42.c                                                |  243 
 drivers/i2c/busses/i2c-ismt.c                                       |    3 
 drivers/i2c/busses/i2c-pxa-pci.c                                    |   10 
 drivers/i2c/muxes/i2c-mux-reg.c                                     |    5 
 drivers/iio/accel/adis16201.c                                       |    1 
 drivers/iio/accel/adis16209.c                                       |    1 
 drivers/iio/adc/ad_sigma_delta.c                                    |    8 
 drivers/iio/adc/ti-adc128s052.c                                     |   14 
 drivers/iio/gyro/adis16136.c                                        |    1 
 drivers/iio/gyro/adis16260.c                                        |    1 
 drivers/iio/imu/adis.c                                              |   98 
 drivers/iio/imu/adis16400.c                                         |    1 
 drivers/iio/imu/adis16460.c                                         |    5 
 drivers/iio/imu/adis16475.c                                         |    6 
 drivers/iio/imu/adis16480.c                                         |    1 
 drivers/iio/imu/adis_buffer.c                                       |   10 
 drivers/iio/imu/adis_trigger.c                                      |   20 
 drivers/iio/temperature/ltc2983.c                                   |   10 
 drivers/infiniband/core/device.c                                    |    2 
 drivers/infiniband/core/nldev.c                                     |    6 
 drivers/infiniband/hw/hfi1/affinity.c                               |    2 
 drivers/infiniband/hw/hfi1/firmware.c                               |    6 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                          |   24 
 drivers/infiniband/hw/hns/hns_roce_mr.c                             |    4 
 drivers/infiniband/hw/mlx5/qp.c                                     |   49 
 drivers/infiniband/sw/rxe/rxe_qp.c                                  |    6 
 drivers/infiniband/sw/siw/siw_cq.c                                  |   24 
 drivers/infiniband/sw/siw/siw_qp_tx.c                               |    2 
 drivers/infiniband/sw/siw/siw_verbs.c                               |   40 
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c                        |    7 
 drivers/infiniband/ulp/srp/ib_srp.c                                 |   96 
 drivers/input/joystick/Kconfig                                      |    1 
 drivers/input/touchscreen/elants_i2c.c                              |    9 
 drivers/iommu/amd/init.c                                            |    7 
 drivers/iommu/amd/iommu_v2.c                                        |    1 
 drivers/iommu/fsl_pamu.c                                            |    2 
 drivers/iommu/sun50i-iommu.c                                        |   16 
 drivers/irqchip/irq-gic-pm.c                                        |    2 
 drivers/isdn/hardware/mISDN/hfcmulti.c                              |   19 
 drivers/isdn/hardware/mISDN/hfcpci.c                                |   13 
 drivers/isdn/hardware/mISDN/hfcsusb.c                               |   12 
 drivers/macintosh/macio-adb.c                                       |    4 
 drivers/macintosh/macio_asic.c                                      |    2 
 drivers/mailbox/zynqmp-ipi-mailbox.c                                |    4 
 drivers/mcb/mcb-core.c                                              |    4 
 drivers/mcb/mcb-parse.c                                             |    2 
 drivers/md/dm-cache-metadata.c                                      |   54 
 drivers/md/dm-cache-target.c                                        |   11 
 drivers/md/dm-clone-target.c                                        |    1 
 drivers/md/dm-integrity.c                                           |    2 
 drivers/md/dm-thin-metadata.c                                       |   60 
 drivers/md/dm-thin.c                                                |   18 
 drivers/md/md-bitmap.c                                              |   47 
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
 drivers/media/platform/coda/coda-jpeg.c                             |   10 
 drivers/media/platform/exynos4-is/fimc-core.c                       |    2 
 drivers/media/platform/exynos4-is/media-dev.c                       |   32 
 drivers/media/platform/exynos4-is/media-dev.h                       |    2 
 drivers/media/platform/qcom/camss/camss-video.c                     |    3 
 drivers/media/platform/qcom/venus/pm_helpers.c                      |    4 
 drivers/media/platform/s5p-mfc/s5p_mfc.c                            |   17 
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c                       |    4 
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c                        |   12 
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c                     |   14 
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c               |    1 
 drivers/media/radio/si470x/radio-si470x-usb.c                       |    4 
 drivers/media/rc/imon.c                                             |    6 
 drivers/media/test-drivers/vidtv/vidtv_bridge.c                     |   22 
 drivers/media/test-drivers/vimc/vimc-core.c                         |    2 
 drivers/media/test-drivers/vivid/vivid-vid-cap.c                    |    1 
 drivers/media/usb/dvb-usb/az6027.c                                  |    4 
 drivers/media/usb/dvb-usb/dvb-usb-init.c                            |    4 
 drivers/media/v4l2-core/videobuf-dma-contig.c                       |   22 
 drivers/misc/cxl/guest.c                                            |   24 
 drivers/misc/cxl/pci.c                                              |   21 
 drivers/misc/ocxl/config.c                                          |   20 
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
 drivers/mmc/host/renesas_sdhi_core.c                                |    2 
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
 drivers/mtd/spi-nor/core.c                                          |    2 
 drivers/net/bonding/bond_3ad.c                                      |    1 
 drivers/net/bonding/bond_main.c                                     |   13 
 drivers/net/can/m_can/tcan4x5x.c                                    |    5 
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h                         |   30 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c                    |  115 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c                   |  167 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c                    |  437 -
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
 drivers/net/ethernet/freescale/enetc/enetc.c                        |    8 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c           |    3 
 drivers/net/ethernet/intel/igb/igb_main.c                           |   10 
 drivers/net/ethernet/intel/igc/igc.h                                |    2 
 drivers/net/ethernet/intel/igc/igc_defines.h                        |    2 
 drivers/net/ethernet/intel/igc/igc_main.c                           |  245 
 drivers/net/ethernet/intel/igc/igc_tsn.c                            |   11 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                     |   12 
 drivers/net/ethernet/mellanox/mlx5/core/health.c                    |    6 
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c               |    4 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                      |    2 
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c                    |    1 
 drivers/net/ethernet/neterion/s2io.c                                |    2 
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c                    |    2 
 drivers/net/ethernet/qlogic/qed/qed_debug.c                         |    3 
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
 drivers/net/macsec.c                                                |   34 
 drivers/net/ntb_netdev.c                                            |    4 
 drivers/net/phy/xilinx_gmii2rgmii.c                                 |    1 
 drivers/net/ppp/ppp_generic.c                                       |    2 
 drivers/net/usb/rndis_host.c                                        |    3 
 drivers/net/veth.c                                                  |    5 
 drivers/net/vmxnet3/vmxnet3_drv.c                                   |    8 
 drivers/net/wan/farsync.c                                           |    2 
 drivers/net/wireless/ath/ar5523/ar5523.c                            |    6 
 drivers/net/wireless/ath/ath10k/pci.c                               |   20 
 drivers/net/wireless/ath/ath9k/hif_usb.c                            |   46 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c         |    5 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c             |    6 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c             |    1 
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                         |   12 
 drivers/net/wireless/mediatek/mt76/mt76.h                           |    3 
 drivers/net/wireless/microchip/wilc1000/sdio.c                      |    1 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h                    |    2 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c               |   26 
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c                |   10 
 drivers/net/wireless/rsi/rsi_91x_core.c                             |    4 
 drivers/net/wireless/rsi/rsi_91x_hal.c                              |    6 
 drivers/nfc/pn533/pn533.c                                           |    4 
 drivers/nvme/host/nvme.h                                            |    2 
 drivers/nvme/host/pci.c                                             |   37 
 drivers/nvme/target/passthru.c                                      |   11 
 drivers/of/overlay.c                                                |    4 
 drivers/parisc/led.c                                                |    3 
 drivers/pci/controller/dwc/pcie-designware.c                        |    2 
 drivers/pci/endpoint/functions/pci-epf-test.c                       |    2 
 drivers/pci/irq.c                                                   |    2 
 drivers/pci/pci-sysfs.c                                             |   13 
 drivers/pci/pci.c                                                   |    2 
 drivers/perf/arm_dsu_pmu.c                                          |    6 
 drivers/perf/arm_smmuv3_pmu.c                                       |    8 
 drivers/phy/broadcom/phy-brcm-usb.c                                 |    6 
 drivers/pinctrl/pinconf-generic.c                                   |    4 
 drivers/platform/chrome/cros_usbpd_notify.c                         |    6 
 drivers/platform/x86/huawei-wmi.c                                   |   20 
 drivers/platform/x86/intel_scu_ipc.c                                |    2 
 drivers/platform/x86/mxm-wmi.c                                      |    8 
 drivers/pnp/core.c                                                  |    4 
 drivers/power/supply/power_supply_core.c                            |    7 
 drivers/pwm/pwm-sifive.c                                            |    5 
 drivers/pwm/pwm-tegra.c                                             |    4 
 drivers/rapidio/devices/rio_mport_cdev.c                            |   15 
 drivers/rapidio/rio-scan.c                                          |    8 
 drivers/rapidio/rio.c                                               |    9 
 drivers/regulator/core.c                                            |   15 
 drivers/remoteproc/qcom_q6v5_pas.c                                  |    4 
 drivers/remoteproc/qcom_sysmon.c                                    |    5 
 drivers/remoteproc/remoteproc_core.c                                |    9 
 drivers/rtc/rtc-cmos.c                                              |  366 
 drivers/rtc/rtc-ds1347.c                                            |    2 
 drivers/rtc/rtc-mxc_v2.c                                            |    4 
 drivers/rtc/rtc-pcf85063.c                                          |   10 
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
 drivers/scsi/scsi_debug.c                                           |   11 
 drivers/scsi/scsi_error.c                                           |   14 
 drivers/scsi/snic/snic_disc.c                                       |    3 
 drivers/soc/qcom/Kconfig                                            |    1 
 drivers/soc/qcom/apr.c                                              |  142 
 drivers/soc/qcom/llcc-qcom.c                                        |    2 
 drivers/soc/ti/knav_qmss_queue.c                                    |    6 
 drivers/soc/ti/smartreflex.c                                        |    1 
 drivers/soc/ux500/ux500-soc-id.c                                    |   10 
 drivers/soundwire/intel.c                                           |    8 
 drivers/soundwire/qcom.c                                            |    8 
 drivers/soundwire/stream.c                                          |    4 
 drivers/spi/spi-gpio.c                                              |   16 
 drivers/spi/spidev.c                                                |   21 
 drivers/staging/iio/accel/adis16203.c                               |    1 
 drivers/staging/iio/accel/adis16240.c                               |    1 
 drivers/staging/media/tegra-video/csi.c                             |    4 
 drivers/staging/media/tegra-video/csi.h                             |    2 
 drivers/staging/rtl8192e/rtllib_rx.c                                |    2 
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c                   |    4 
 drivers/thermal/imx8mm_thermal.c                                    |    8 
 drivers/tty/serial/altera_uart.c                                    |   21 
 drivers/tty/serial/amba-pl011.c                                     |   14 
 drivers/tty/serial/fsl_lpuart.c                                     |   18 
 drivers/tty/serial/pch_uart.c                                       |    4 
 drivers/tty/serial/serial-tegra.c                                   |    6 
 drivers/tty/serial/serial_core.c                                    |    3 
 drivers/tty/serial/sunsab.c                                         |    8 
 drivers/uio/uio_dmem_genirq.c                                       |   13 
 drivers/usb/dwc3/core.c                                             |   23 
 drivers/usb/dwc3/dwc3-qcom.c                                        |   13 
 drivers/usb/gadget/function/f_hid.c                                 |  271 
 drivers/usb/gadget/function/u_hid.h                                 |    1 
 drivers/usb/gadget/udc/fotg210-udc.c                                |   12 
 drivers/usb/musb/musb_gadget.c                                      |    2 
 drivers/usb/roles/class.c                                           |    5 
 drivers/usb/storage/alauda.c                                        |    2 
 drivers/usb/typec/bus.c                                             |    2 
 drivers/usb/typec/tcpm/tcpci.c                                      |    5 
 drivers/usb/typec/tps6598x.c                                        |    2 
 drivers/vfio/platform/vfio_platform_common.c                        |    3 
 drivers/vhost/vhost.c                                               |    4 
 drivers/vhost/vringh.c                                              |    5 
 drivers/vhost/vsock.c                                               |    9 
 drivers/video/fbdev/Kconfig                                         |    1 
 drivers/video/fbdev/hyperv_fb.c                                     |    8 
 drivers/video/fbdev/matrox/matroxfb_base.c                          |    4 
 drivers/video/fbdev/pm2fb.c                                         |    9 
 drivers/video/fbdev/uvesafb.c                                       |    1 
 drivers/video/fbdev/vermilion/vermilion.c                           |    4 
 drivers/video/fbdev/via/via-core.c                                  |    9 
 drivers/vme/bridges/vme_fake.c                                      |    2 
 drivers/vme/bridges/vme_tsi148.c                                    |    1 
 drivers/xen/privcmd.c                                               |    2 
 fs/afs/fs_probe.c                                                   |    5 
 fs/binfmt_elf_fdpic.c                                               |    5 
 fs/binfmt_misc.c                                                    |    8 
 fs/btrfs/backref.c                                                  |    4 
 fs/btrfs/ioctl.c                                                    |    9 
 fs/btrfs/rcu-string.h                                               |    6 
 fs/ceph/caps.c                                                      |    2 
 fs/ceph/locks.c                                                     |    4 
 fs/ceph/super.h                                                     |    1 
 fs/char_dev.c                                                       |    2 
 fs/cifs/cifsfs.c                                                    |    8 
 fs/cifs/cifsglob.h                                                  |   69 
 fs/cifs/cifsproto.h                                                 |    4 
 fs/cifs/connect.c                                                   |    4 
 fs/cifs/misc.c                                                      |    4 
 fs/cifs/smb2ops.c                                                   |  143 
 fs/configfs/dir.c                                                   |    2 
 fs/debugfs/file.c                                                   |   28 
 fs/ext4/ext4.h                                                      |    9 
 fs/ext4/extents.c                                                   |    8 
 fs/ext4/extents_status.c                                            |    3 
 fs/ext4/fast_commit.c                                               |   49 
 fs/ext4/fast_commit.h                                               |    1 
 fs/ext4/indirect.c                                                  |   11 
 fs/ext4/inline.c                                                    |    2 
 fs/ext4/inode.c                                                     |   49 
 fs/ext4/ioctl.c                                                     |   13 
 fs/ext4/mballoc.h                                                   |    2 
 fs/ext4/migrate.c                                                   |    6 
 fs/ext4/namei.c                                                     |   49 
 fs/ext4/resize.c                                                    |    6 
 fs/ext4/super.c                                                     |  230 
 fs/ext4/verity.c                                                    |    7 
 fs/ext4/xattr.c                                                     |  184 
 fs/ext4/xattr.h                                                     |    1 
 fs/f2fs/gc.c                                                        |   11 
 fs/f2fs/segment.c                                                   |    2 
 fs/hfs/inode.c                                                      |   13 
 fs/hfs/trans.c                                                      |    2 
 fs/hfsplus/hfsplus_fs.h                                             |    2 
 fs/hfsplus/inode.c                                                  |   16 
 fs/hfsplus/options.c                                                |    4 
 fs/hugetlbfs/inode.c                                                |    6 
 fs/jfs/jfs_dmap.c                                                   |   27 
 fs/libfs.c                                                          |   22 
 fs/locks.c                                                          |   23 
 fs/mbcache.c                                                        |  121 
 fs/nfs/namespace.c                                                  |    2 
 fs/nfs/nfs4proc.c                                                   |   34 
 fs/nfs/nfs4state.c                                                  |    2 
 fs/nfs/nfs4xdr.c                                                    |   12 
 fs/nfsd/nfs4callback.c                                              |    8 
 fs/nfsd/nfs4state.c                                                 |   51 
 fs/nfsd/nfs4xdr.c                                                   |   11 
 fs/nfsd/nfssvc.c                                                    |    2 
 fs/nilfs2/the_nilfs.c                                               |   73 
 fs/ocfs2/journal.c                                                  |    2 
 fs/ocfs2/journal.h                                                  |    1 
 fs/ocfs2/stackglue.c                                                |    8 
 fs/ocfs2/super.c                                                    |  105 
 fs/orangefs/orangefs-debugfs.c                                      |   29 
 fs/orangefs/orangefs-mod.c                                          |    8 
 fs/overlayfs/dir.c                                                  |   46 
 fs/overlayfs/super.c                                                |    7 
 fs/pnode.c                                                          |    2 
 fs/pstore/Kconfig                                                   |    1 
 fs/pstore/pmsg.c                                                    |    7 
 fs/pstore/ram.c                                                     |    2 
 fs/pstore/ram_core.c                                                |    6 
 fs/pstore/zone.c                                                    |    2 
 fs/quota/dquot.c                                                    |    2 
 fs/reiserfs/namei.c                                                 |    4 
 fs/reiserfs/xattr_security.c                                        |    2 
 fs/sysv/itree.c                                                     |    2 
 fs/udf/inode.c                                                      |    2 
 fs/udf/namei.c                                                      |    8 
 fs/xattr.c                                                          |    2 
 include/linux/debugfs.h                                             |   19 
 include/linux/devfreq.h                                             |    7 
 include/linux/efi.h                                                 |    2 
 include/linux/eventfd.h                                             |    2 
 include/linux/fs.h                                                  |   18 
 include/linux/highmem.h                                             |   18 
 include/linux/hyperv.h                                              |    2 
 include/linux/iio/imu/adis.h                                        |   63 
 include/linux/interrupt.h                                           |    4 
 include/linux/mbcache.h                                             |   41 
 include/linux/netdevice.h                                           |   58 
 include/linux/netfilter/ipset/ip_set.h                              |    2 
 include/linux/nvme.h                                                |    3 
 include/linux/proc_fs.h                                             |    2 
 include/linux/skbuff.h                                              |   42 
 include/linux/soc/qcom/apr.h                                        |   12 
 include/linux/sunrpc/rpc_pipe_fs.h                                  |    5 
 include/linux/timerqueue.h                                          |    2 
 include/media/dvbdev.h                                              |   32 
 include/net/dst.h                                                   |    5 
 include/net/mptcp.h                                                 |   12 
 include/net/mrp.h                                                   |    1 
 include/net/pkt_sched.h                                             |    9 
 include/sound/hdaudio.h                                             |    2 
 include/sound/hdaudio_ext.h                                         |    1 
 include/sound/pcm.h                                                 |   36 
 include/sound/soc-dai.h                                             |   32 
 include/trace/events/ext4.h                                         |    7 
 include/trace/events/jbd2.h                                         |   44 
 include/uapi/drm/drm_fourcc.h                                       |   11 
 include/uapi/linux/idxd.h                                           |    2 
 include/uapi/linux/swab.h                                           |    2 
 include/uapi/sound/asequencer.h                                     |    8 
 io_uring/io_uring.c                                                 |    2 
 kernel/Makefile                                                     |    2 
 kernel/acct.c                                                       |    2 
 kernel/bpf/btf.c                                                    |    5 
 kernel/bpf/verifier.c                                               |  123 
 kernel/cpu.c                                                        |    4 
 kernel/events/core.c                                                |   14 
 kernel/futex.c                                                      | 4040 ---------
 kernel/futex/Makefile                                               |    3 
 kernel/futex/core.c                                                 | 4048 ++++++++++
 kernel/gcov/gcc_4_7.c                                               |    5 
 kernel/irq/internals.h                                              |    2 
 kernel/irq/irqdesc.c                                                |   15 
 kernel/irq/manage.c                                                 |   11 
 kernel/kcsan/core.c                                                 |   50 
 kernel/padata.c                                                     |   15 
 kernel/power/snapshot.c                                             |    4 
 kernel/rcu/tree.c                                                   |   23 
 kernel/rcu/tree.h                                                   |    1 
 kernel/relay.c                                                      |    4 
 kernel/sched/fair.c                                                 |  128 
 kernel/trace/blktrace.c                                             |    3 
 kernel/trace/trace.c                                                |   15 
 kernel/trace/trace_events_hist.c                                    |   13 
 lib/Kconfig.debug                                                   |    1 
 lib/debugobjects.c                                                  |   10 
 lib/fonts/fonts.c                                                   |    4 
 lib/iov_iter.c                                                      |   14 
 lib/notifier-error-inject.c                                         |    2 
 lib/test_firmware.c                                                 |    1 
 mm/compaction.c                                                     |   18 
 net/802/mrp.c                                                       |   18 
 net/bluetooth/hci_core.c                                            |    2 
 net/bluetooth/rfcomm/core.c                                         |    2 
 net/bpf/test_run.c                                                  |    3 
 net/caif/cfctrl.c                                                   |    6 
 net/core/dev.c                                                      |   16 
 net/core/filter.c                                                   |   18 
 net/core/skbuff.c                                                   |    9 
 net/core/sock_map.c                                                 |    2 
 net/core/stream.c                                                   |    6 
 net/ethtool/ioctl.c                                                 |    3 
 net/hsr/hsr_device.c                                                |   59 
 net/hsr/hsr_forward.c                                               |   15 
 net/hsr/hsr_framereg.c                                              |    9 
 net/hsr/hsr_framereg.h                                              |    2 
 net/ipv4/inet_connection_sock.c                                     |   28 
 net/ipv4/syncookies.c                                               |    7 
 net/ipv4/tcp_bpf.c                                                  |    8 
 net/ipv4/tcp_ulp.c                                                  |    4 
 net/ipv4/udp_tunnel_core.c                                          |    1 
 net/mac80211/iface.c                                                |    1 
 net/mptcp/subflow.c                                                 |   76 
 net/netfilter/ipset/ip_set_core.c                                   |    7 
 net/netfilter/ipset/ip_set_hash_ip.c                                |   14 
 net/netfilter/ipset/ip_set_hash_ipmark.c                            |   13 
 net/netfilter/ipset/ip_set_hash_ipport.c                            |   13 
 net/netfilter/ipset/ip_set_hash_ipportip.c                          |   13 
 net/netfilter/ipset/ip_set_hash_ipportnet.c                         |   13 
 net/netfilter/ipset/ip_set_hash_net.c                               |   17 
 net/netfilter/ipset/ip_set_hash_netiface.c                          |   15 
 net/netfilter/ipset/ip_set_hash_netnet.c                            |   23 
 net/netfilter/ipset/ip_set_hash_netport.c                           |   19 
 net/netfilter/ipset/ip_set_hash_netportnet.c                        |   40 
 net/netfilter/nf_conntrack_proto_icmpv6.c                           |   53 
 net/netfilter/nf_flow_table_offload.c                               |    6 
 net/nfc/netlink.c                                                   |   52 
 net/openvswitch/datapath.c                                          |   25 
 net/packet/af_packet.c                                              |   20 
 net/rxrpc/output.c                                                  |    2 
 net/rxrpc/sendmsg.c                                                 |    2 
 net/sched/cls_tcindex.c                                             |   12 
 net/sched/ematch.c                                                  |    2 
 net/sched/sch_api.c                                                 |    5 
 net/sched/sch_atm.c                                                 |    5 
 net/sched/sch_cbq.c                                                 |    4 
 net/sctp/sysctl.c                                                   |   73 
 net/sunrpc/auth_gss/auth_gss.c                                      |   19 
 net/sunrpc/auth_gss/svcauth_gss.c                                   |    9 
 net/sunrpc/clnt.c                                                   |    2 
 net/sunrpc/xprtrdma/verbs.c                                         |    2 
 net/vmw_vsock/vmci_transport.c                                      |    6 
 net/wireless/reg.c                                                  |    4 
 samples/vfio-mdev/mdpy-fb.c                                         |    8 
 security/apparmor/apparmorfs.c                                      |    4 
 security/apparmor/lsm.c                                             |    4 
 security/apparmor/policy.c                                          |    2 
 security/apparmor/policy_ns.c                                       |    2 
 security/apparmor/policy_unpack.c                                   |    2 
 security/device_cgroup.c                                            |   33 
 security/integrity/digsig.c                                         |    6 
 security/integrity/ima/ima_main.c                                   |    1 
 security/integrity/ima/ima_policy.c                                 |   53 
 security/integrity/ima/ima_template.c                               |    9 
 security/integrity/platform_certs/load_uefi.c                       |    1 
 security/loadpin/loadpin.c                                          |   30 
 sound/core/control_compat.c                                         |    4 
 sound/core/pcm_native.c                                             |    4 
 sound/drivers/mts64.c                                               |    3 
 sound/hda/ext/hdac_ext_stream.c                                     |   17 
 sound/hda/hdac_stream.c                                             |   27 
 sound/pci/asihpi/hpioctl.c                                          |    2 
 sound/pci/hda/hda_controller.c                                      |    4 
 sound/pci/hda/patch_hdmi.c                                          |    2 
 sound/pci/hda/patch_realtek.c                                       |   78 
 sound/soc/codecs/hdac_hda.c                                         |   22 
 sound/soc/codecs/max98373-sdw.c                                     |    2 
 sound/soc/codecs/pcm512x.c                                          |    8 
 sound/soc/codecs/rt1308-sdw.c                                       |    2 
 sound/soc/codecs/rt298.c                                            |    7 
 sound/soc/codecs/rt5670.c                                           |    2 
 sound/soc/codecs/rt5682-sdw.c                                       |    2 
 sound/soc/codecs/rt700.c                                            |    2 
 sound/soc/codecs/rt711.c                                            |    2 
 sound/soc/codecs/rt715.c                                            |    2 
 sound/soc/codecs/wm8994.c                                           |    5 
 sound/soc/codecs/wsa881x.c                                          |    2 
 sound/soc/generic/audio-graph-card.c                                |    4 
 sound/soc/intel/boards/bytcr_rt5640.c                               |   15 
 sound/soc/intel/boards/sof_sdw.c                                    |    6 
 sound/soc/intel/skylake/skl-pcm.c                                   |    7 
 sound/soc/intel/skylake/skl.c                                       |    7 
 sound/soc/jz4740/jz4740-i2s.c                                       |   39 
 sound/soc/mediatek/common/mtk-btcvsd.c                              |    6 
 sound/soc/mediatek/mt8173/mt8173-afe-pcm.c                          |   71 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c                    |    7 
 sound/soc/pxa/mmp-pcm.c                                             |    2 
 sound/soc/qcom/lpass-sc7180.c                                       |    3 
 sound/soc/qcom/sdm845.c                                             |    4 
 sound/soc/rockchip/rockchip_pdm.c                                   |    1 
 sound/soc/rockchip/rockchip_spdif.c                                 |    1 
 sound/soc/sof/intel/hda-dai.c                                       |    7 
 sound/usb/line6/driver.c                                            |    3 
 sound/usb/line6/midi.c                                              |    6 
 sound/usb/line6/midibuf.c                                           |   25 
 sound/usb/line6/midibuf.h                                           |    5 
 sound/usb/line6/pod.c                                               |    3 
 sound/usb/quirks-table.h                                            |    2 
 tools/arch/parisc/include/uapi/asm/mman.h                           |   12 
 tools/lib/bpf/bpf.h                                                 |    7 
 tools/lib/bpf/btf_dump.c                                            |   29 
 tools/lib/bpf/libbpf.c                                              |    3 
 tools/objtool/check.c                                               |   12 
 tools/perf/bench/bench.h                                            |   12 
 tools/perf/builtin-trace.c                                          |   32 
 tools/perf/util/data.c                                              |    2 
 tools/perf/util/debug.c                                             |    4 
 tools/perf/util/dwarf-aux.c                                         |   23 
 tools/perf/util/symbol-elf.c                                        |    2 
 tools/testing/ktest/ktest.pl                                        |   23 
 tools/testing/selftests/Makefile                                    |   26 
 tools/testing/selftests/drivers/net/netdevsim/devlink.sh            |    4 
 tools/testing/selftests/efivarfs/efivarfs.sh                        |    5 
 tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc |   15 
 tools/testing/selftests/lib.mk                                      |    5 
 tools/testing/selftests/netfilter/conntrack_icmp_related.sh         |   36 
 tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c              |    5 
 tools/testing/selftests/proc/proc-uptime-002.c                      |    3 
 tools/testing/selftests/rcutorture/bin/console-badness.sh           |    3 
 750 files changed, 11991 insertions(+), 8466 deletions(-)

Aakarsh Jain (1):
      media: s5p-mfc: Add variant data for MFC v7 hardware for Exynos 3250 SoC

Abhinav Kumar (1):
      drm/bridge: adv7533: remove dynamic lane switching from adv7533 bridge

Adam Vodopjan (1):
      ata: ahci: Fix PCS quirk application for suspend

Adham Faris (1):
      net/mlx5e: Fix hw mtu initializing at XDP SQ allocation

Aditya Garg (2):
      hfsplus: fix bug causing custom uid and gid being unable to be assigned with mount
      efi: Add iMac Pro 2017 to uefi skip cert quirk

Adrian Chan (1):
      ALSA: hda/hdmi: Add a HP device 0x8715 to force connect list

Aidan MacDonald (1):
      ASoC: jz4740-i2s: Handle independent FIFO flush bits

Ajay Kaher (1):
      perf symbol: correction while adjusting symbol

Akinobu Mita (3):
      libfs: add DEFINE_SIMPLE_ATTRIBUTE_SIGNED for signed value
      lib/notifier-error-inject: fix error when writing -errno to debugfs file
      debugfs: fix error when writing negative value to atomic_t debugfs file

Al Cooper (1):
      phy: usb: s2 WoL wakeup_count not incremented for USB->Eth devices

Al Viro (1):
      alpha: fix syscall entry in !AUDUT_SYSCALL case

Alex Deucher (2):
      drm/amdgpu: handle polaris10/11 overlap asics (v2)
      drm/amdgpu: make display pinning more flexible (v2)

Alexander Antonov (2):
      perf/x86/intel/uncore: Generalize I/O stacks to PMON mapping procedure
      perf/x86/intel/uncore: Clear attr_update properly

Alexander Potapenko (1):
      fs: ext4: initialize fsdata in pagecache_write()

Alexander Stein (1):
      rtc: pcf85063: Fix reading alarm

Alexander Sverdlin (2):
      spi: spidev: mask SPI_CS_HIGH in SPI_IOC_RD_MODE
      mtd: spi-nor: Check for zero erase size in spi_nor_find_best_erase_type()

Alexandre Belloni (2):
      rtc: cmos: fix build on non-ACPI platforms
      rtc: pcf85063: fix pcf85063_clkout_control

Alexey Dobriyan (1):
      proc: fixup uptime selftest

Alexey Izbyshev (1):
      futex: Resend potentially swallowed owner death notification

Amadeusz Sławiński (1):
      ASoC: codecs: rt298: Add quirk for KBL-R RVP platform

Anastasia Belova (1):
      MIPS: BCM63xx: Add check for NULL for clk in clk_enable

Andrii Nakryiko (3):
      bpf: propagate precision in ALU/ALU64 operations
      bpf: propagate precision across all frames, not just the last one
      libbpf: Avoid enum forward-declarations in public API in C++ mode

Andy Shevchenko (2):
      gpiolib: Get rid of redundant 'else'
      fbdev: ssd1307fb: Drop optional dependency

AngeloGioacchino Del Regno (7):
      arm64: dts: mt2712e: Fix unit_address_vs_reg warning for oscillators
      arm64: dts: mt2712e: Fix unit address for pinctrl node
      arm64: dts: mt2712-evb: Fix vproc fixed regulators unit names
      arm64: dts: mt2712-evb: Fix usb vbus regulators unit names
      arm64: dts: mediatek: pumpkin-common: Fix devicetree warnings
      arm64: dts: mediatek: mt6797: Fix 26M oscillator unit name
      ASoC: mediatek: mt8173: Fix debugfs registration for components

Anssi Hannula (4):
      can: kvaser_usb_leaf: Set Warning state even without bus errors
      can: kvaser_usb_leaf: Fix improved state not being reported
      can: kvaser_usb_leaf: Fix wrong CAN state after stopping
      can: kvaser_usb_leaf: Fix bogus restart events

Ard Biesheuvel (1):
      efi: random: combine bootloader provided RNG seed with RNG protocol output

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

Aurabindo Pillai (1):
      drm/amd/display: fix array index out of bound error in bios parser

Baisong Zhong (3):
      ALSA: pcm: fix undefined behavior in bit shift for SNDRV_PCM_RATE_KNOT
      ALSA: seq: fix undefined behavior in bit shift for SNDRV_SEQ_FILTER_USE_EVENT
      media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()

Baokun Li (8):
      ext4: add inode table check in __ext4_get_inode_loc to aovid possible infinite loop
      ext4: fix use-after-free in ext4_orphan_cleanup
      ext4: add EXT4_IGET_BAD flag to prevent unexpected bad inode
      ext4: add helper to check quota inums
      ext4: fix bug_on in __es_tree_search caused by bad quota inode
      ext4: fix bug_on in __es_tree_search caused by bad boot loader inode
      ext4: fix corruption when online resizing a 1K bigalloc fs
      ext4: correct inconsistent error msg in nojournal mode

Barnabás Pőcze (2):
      platform/x86: huawei-wmi: fix return value calculation
      timerqueue: Use rb_entry_safe() in timerqueue_getnext()

Barry Song (1):
      genirq: Add IRQF_NO_AUTOEN for request_irq/nmi()

Bart Van Assche (1):
      scsi: core: Fix a race between scsi_done() and scsi_timeout()

Bartosz Golaszewski (1):
      gpiolib: cdev: fix NULL-pointer dereferences

Ben Dooks (1):
      riscv: uaccess: fix type of 0 variable on error in get_user()

Ben Greear (1):
      wifi: iwlwifi: mvm: fix double free on tx path.

Bernard Metzler (2):
      RDMA/siw: Fix immediate work request flush to completion queue
      RDMA/siw: Set defined status for work completion with undefined status

Bhaskar Chowdhury (1):
      ext4: fix various seppling typos

Biju Das (1):
      ravb: Fix "failed to switch device to config mode" message during unbind

Bitterblue Smith (3):
      wifi: rtl8xxxu: Fix reading the vendor of combo chips
      wifi: rtl8xxxu: Add __packed to struct rtl8723bu_c2h
      wifi: rtl8xxxu: Fix the channel width reporting

Bixuan Cui (1):
      jbd2: use the correct print format

Boris Burkov (1):
      btrfs: fix resolving backrefs for inline extent followed by prealloc

Borislav Petkov (2):
      x86/mce: Get rid of msr_ops
      x86/kprobes: Convert to insn_decode()

Brian Starkey (1):
      drm/fourcc: Fix vsub/hsub for Q410 and Q401

Cai Xinchen (1):
      rapidio: devices: fix missing put_device in mport_cdev_open

Carlo Caione (1):
      drm/meson: Reduce the FIFO lines held when AFBC is not used

Cezary Rojewski (1):
      ASoC: Intel: Skylake: Fix driver hang during shutdown

Chaitanya Kulkarni (1):
      ext4: use memcpy_to_page() in pagecache_write()

Chen Huang (1):
      riscv/stacktrace: Fix stack output without ra on the stack top

Chen Hui (1):
      cpufreq: qcom-hw: Fix memory leak in qcom_cpufreq_hw_read_lut()

Chen Jiahao (1):
      drivers: soc: ti: knav_qmss_queue: Mark knav_acc_firmwares as static

Chen Zhongjin (10):
      perf: Fix possible memleak in pmu_dev_alloc()
      fs: sysv: Fix sysv_nblocks() returns wrong value
      media: vidtv: Fix use-after-free in vidtv_bridge_dvb_init()
      media: vimc: Fix wrong function called when vimc_init() fails
      media: dvb-core: Fix ignored return value in dvb_register_frontend()
      wifi: cfg80211: Fix not unregister reg_pdev when load_builtin_regdb_keys() fails
      configfs: fix possible memory leak in configfs_create_dir()
      scsi: fcoe: Fix transport not deattached when fcoe_if_init() fails
      vme: Fix error not catched in fake_init()
      ovl: fix use inode directly in rcu-walk mode

Chengchang Tang (2):
      RDMA/hns: Fix PBL page MTR find
      RDMA/hns: Fix page size cap from firmware

Chris Chiu (2):
      ALSA: hda/realtek: Apply dual codec fixup for Dell Latitude laptops
      ALSA: hda - Enable headset mic on another Dell laptop with ALC3254

Christian Brauner (1):
      pnode: terminate at peers of source

Christian Marangi (1):
      clk: qcom: clk-krait: fix wrong div2 functions

Christoph Hellwig (3):
      media: videobuf-dma-contig: use dma_mmap_coherent
      nvme: fix the NVME_CMD_EFFECTS_CSE_MASK definition
      nvmet: don't defer passthrough commands with trivial effects to the workqueue

Christophe JAILLET (4):
      crypto: amlogic - Remove kcalloc without check
      fbdev: uvesafb: Fixes an error handling path in uvesafb_probe()
      powerpc/52xx: Fix a resource leak in an error handling path
      myri10ge: Fix an error handling path in myri10ge_probe()

Christophe Leroy (2):
      powerpc/xmon: Enable breakpoints on 8xx
      objtool: Fix SEGFAULT

Chuck Lever (2):
      NFSD: Remove spurious cb_setup_err tracepoint
      SUNRPC: Don't leak netobj memory when gss_read_proxy_verf() fails

Clement Lecigne (1):
      ALSA: pcm: Move rwsem lock inside snd_ctl_elem_read to prevent UAF

Cong Wang (1):
      net_sched: reject TCF_EM_SIMPLE case for complex ematch module

Corentin Labbe (9):
      crypto: sun8i-ss - use dma_addr instead u32
      crypto: rockchip - do not do custom power management
      crypto: rockchip - do not store mode globally
      crypto: rockchip - add fallback for cipher
      crypto: rockchip - add fallback for ahash
      crypto: rockchip - better handle cipher key
      crypto: rockchip - remove non-aligned handling
      crypto: rockchip - rework by using crypto_engine
      crypto: n2 - add missing hash statesize

Cosmin Tanislav (1):
      iio: temperature: ltc2983: make bulk write buffer DMA-safe

Dan Aloni (1):
      nfsd: under NFSv4.1, fix double svc_xprt_put on rpc_create failure

Dan Carpenter (5):
      amdgpu/pm: prevent array underflow in vega20_odn_edit_dpm_table()
      bonding: uninitialized variable in bond_miimon_inspect()
      staging: rtl8192u: Fix use after free in ieee80211_rx()
      ipmi: fix use after free in _ipmi_destroy_user()
      drm/i915: unpin on error in intel_vgpu_shadow_mm_pin()

Daniel Jordan (2):
      padata: Always leave BHs disabled when running ->parallel()
      padata: Fix list iterator in padata_do_serial()

Daniil Tatianin (2):
      qlcnic: prevent ->dcb use-after-free on qlcnic_dcb_enable() failure
      drivers/net/bonding/bond_3ad: return when there's no aggregator

Dario Binacchi (1):
      clk: imx: replace osc_hdmi with dummy

Dave Stevenson (1):
      drm/fourcc: Add packed 10bit YUV 4:2:0 format

David Howells (4):
      net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
      rxrpc: Fix ack.bufferSize to be 0 when generating an ack
      rxrpc: Fix missing unlock in rxrpc_do_sendmsg()
      afs: Fix lost servers_outstanding count

Deren Wu (2):
      wifi: mt76: fix coverity overrun-call in mt76_get_txpower()
      mmc: vub300: fix warning - do not call blocking ops when !TASK_RUNNING

Dima Chumak (1):
      net/mlx5e: Fix nullptr in mlx5e_tc_add_fdb_flow()

Dinh Nguyen (1):
      clk: socfpga: use clk_hw_register for a5/c5

Dmitry Baryshkov (3):
      arm64: dts: qcom: msm8996: fix GPU OPP table
      drm/msm/hdmi: switch to drm_bridge_connector
      drm/msm/hdmi: drop unused GPIO support

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

Dragos Tatulea (2):
      IB/IPoIB: Fix queue count inconsistency for PKEY child interfaces
      net/mlx5e: IPoIB, Don't allow CQE compression to be turned on by default

Edward Pacman (1):
      ALSA: hda/realtek: Add quirk for Lenovo TianYi510Pro-14IOB

Eelco Chaudron (1):
      openvswitch: Fix flow lookup to use unmasked key

Emeel Hakim (1):
      net: macsec: fix net device access prior to holding a lock

Enrik Berkhan (1):
      HID: mcp2221: don't connect hidraw

Eric Biggers (4):
      ext4: fix leaking uninitialized memory in fast-commit journal
      ext4: don't allow journal inode to have encrypt flag
      ext4: disable fast-commit of encrypted dir operations
      ext4: don't set up encryption key during jbd2 transaction

Eric Dumazet (5):
      inet: add READ_ONCE(sk->sk_bound_dev_if) in inet_csk_bind_conflict()
      bpf, sockmap: fix race in sock_map_free()
      net: stream: purge sk_error_queue in sk_stream_kill_queues()
      net: add atomic_long_t to net_device_stats fields
      net/af_packet: make sure to pull mac header

Eric Pilmore (1):
      ntb_netdev: Use dev_kfree_skb_any() in interrupt context

Eric Whitney (1):
      ext4: fix delayed allocation bug in ext4_clu_mapped for bigalloc + inline

Ezequiel Garcia (1):
      media: exynos4-is: Use v4l2_async_notifier_add_fwnode_remote_subdev

Fabrice Gasnier (1):
      counter: stm32-lptimer-cnt: fix the check on arr and cmp registers update

Fedor Pchelkin (3):
      wifi: ath9k: hif_usb: fix memory leak of urbs in ath9k_hif_usb_dealloc_tx_urbs()
      wifi: ath9k: hif_usb: Fix use-after-free in ath9k_hif_usb_reg_in_cb()
      wifi: ath9k: verify the expected usb_endpoints are present

Fenghua Yu (1):
      dmaengine: idxd: Fix crc_val field for completion record

Ferry Toth (1):
      usb: dwc3: core: defer probe on ulpi_read_id timeout

Firo Yang (1):
      sctp: sysctl: make extra pointers netns aware

Florian Westphal (1):
      netfilter: conntrack: set icmpv6 redirects as RELATED

Florian-Ewald Mueller (1):
      md/bitmap: Fix bitmap chunk size overflow issues

Frederick Lawler (1):
      net: sched: disallow noqueue for qdisc classes

GUO Zihua (4):
      ima: Handle -ESTALE returned by ima_filter_rule_match()
      integrity: Fix memory leakage in keyring allocation error path
      rtc: mxc_v2: Add missing clk_disable_unprepare()
      ima: Simplify ima_lsm_copy_rule

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

Gaurav Kohli (1):
      x86/hyperv: Remove unregister syscore call from Hyper-V cleanup

Gautam Menghani (1):
      media: imon: fix a race condition in send_packet()

Gavrilov Ilia (1):
      relay: fix type mismatch when allocating memory in relay_create_buf()

Geert Uytterhoeven (1):
      clocksource/drivers/sh_cmt: Make sure channel clock supply is enabled

George McCollister (1):
      net: hsr: generate supervision frame without HSR/PRP tag

Greg Kroah-Hartman (1):
      Linux 5.10.163

Guchun Chen (1):
      drm/amd/pm/smu11: BACO is supported when it's in BACO state

Guilherme G. Piccoli (1):
      video: hyperv_fb: Avoid taking busy spinlock on panic path

Guo Ren (1):
      riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument

Gustavo A. R. Silva (2):
      ima: Fix fall-through warnings for Clang
      powerpc/xmon: Fix -Wswitch-unreachable warning in bpt_cmds

Hangbin Liu (2):
      net/tunnel: wait until all sk_user_data reader finish before releasing the sock
      net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO

Hanjun Guo (4):
      drm/radeon: Add the missed acpi_put_table() to fix memory leak
      tpm: acpi: Call acpi_put_table() to fix memory leak
      tpm: tpm_crb: Add the missed acpi_put_table() to fix memory leak
      tpm: tpm_tis: Add the missed acpi_put_table() to fix memory leak

Hans de Goede (2):
      ASoC: rt5670: Remove unbalanced pm_runtime_put()
      ASoC: Intel: bytcr_rt5640: Add quirk for the Advantech MICA-071 tablet

Haowen Bai (1):
      powerpc/eeh: Drop redundant spinlock initialization

Harshit Mogalapalli (5):
      xen/privcmd: Fix a possible warning in privcmd_ioctl_mmap_resource()
      scsi: scsi_debug: Fix a warning in resp_write_scat()
      scsi: scsi_debug: Fix a warning in resp_verify()
      scsi: scsi_debug: Fix a warning in resp_report_zones()
      io_uring: Fix unsigned 'res' comparison with zero in io_fixup_rw_res()

Hawkins Jiawei (2):
      hugetlbfs: fix null-ptr-deref in hugetlbfs_parse_param()
      net: sched: fix memory leak in tcindex_set_parms

Helge Deller (1):
      parisc: Align parisc MADV_XXX constants with all other architectures

Heming Zhao via Ocfs2-devel (2):
      ocfs2: ocfs2_mount_volume does cleanup job before return error
      ocfs2: rewrite error handling of ocfs2_fill_super

Herbert Xu (1):
      crypto: cryptd - Use request context instead of stack for sub-request

Hoi Pok Wu (1):
      fs: jfs: fix shift-out-of-bounds in dbDiscardAG

Huaxin Lu (1):
      ima: Fix a potential NULL pointer access in ima_restore_measurement_list

Hui Tang (2):
      mtd: lpddr2_nvm: Fix possible null-ptr-deref
      i2c: pxa-pci: fix missing pci_disable_device() on error in ce4100_i2c_probe

Ian Abbott (1):
      rtc: ds1347: fix value written to century register

Indan Zupancic (1):
      fsl_lpuart: Don't enable interrupts too early

Ira Weiny (1):
      mm/highmem: Lift memcpy_[to|from]_page to core

Isaac J. Manjarres (1):
      driver core: Fix bus_type.match() error handling in __driver_attach()

Ivaylo Dimitrov (1):
      usb: musb: remove extra check in musb_gadget_vbus_draw

Jakub Kicinski (3):
      selftests: devlink: fix the fd redirect in dummy_reporter_test
      wifi: rtlwifi: remove always-true condition pointed out by GCC 12
      bpf: pull before calling skb_postpull_rcsum()

Jamal Hadi Salim (2):
      net: sched: atm: dont intepret cls results when asked to drop
      net: sched: cbq: dont intepret cls results when asked to drop

Jan Kara (14):
      ext4: avoid BUG_ON when creating xattrs
      ext4: initialize quota before expanding inode in setproject ioctl
      ext4: avoid unaccounted block allocation when expanding inode
      ext4: move functions in super.c
      ext4: simplify ext4 error translation
      mbcache: don't reclaim used entries
      mbcache: add functions to delete entry if unused
      ext4: remove EA inode entry from mbcache on inode eviction
      ext4: unindent codeblock in ext4_xattr_block_set()
      ext4: fix race when reusing xattr blocks
      mbcache: automatically delete entries from cache on freeing
      ext4: fix deadlock due to mbcache entry corruption
      udf: Fix extension of the last extent in the file
      mbcache: Avoid nesting of cache->c_list_lock under bit locks

Jason A. Donenfeld (2):
      media: stv0288: use explicitly signed char
      ARM: ux500: do not directly dereference __iomem

Jason Gerecke (1):
      HID: wacom: Ensure bootloader PID is usable in hidraw mode

Jason Gunthorpe (1):
      iommu/sun50i: Remove IOMMU_DOMAIN_IDENTITY

Jason Yan (1):
      ext4: goto right label 'failed_mount3a'

Jayesh Choudhary (2):
      arm64: dts: ti: k3-am65-main: Drop dma-coherent in crypto node
      arm64: dts: ti: k3-j721e-main: Drop dma-coherent in crypto node

Jeff Layton (4):
      nfsd: don't call nfsd_file_put from client states seqfile display
      nfsd: shut down the NFSv4 state objects before the filecache
      filelock: new helper: vfs_inode_has_locks
      nfsd: fix handling of readdir in v4root vs. mount upcall timeout

Jens Axboe (1):
      ARM: renumber bits related to _TIF_WORK_MASK

Jernej Skrabec (4):
      iommu/sun50i: Fix reset release
      iommu/sun50i: Consider all fault sources for reset
      iommu/sun50i: Fix R/W permission check
      iommu/sun50i: Fix flush size

Jerry Ray (1):
      net: lan9303: Fix read error execution path

Jiamei Xie (1):
      serial: amba-pl011: avoid SBSA UART accessing DMACR register

Jiang Li (1):
      md/raid1: stop mdx_raid1 thread when raid1 array run failed

Jiao Zhou (1):
      ALSA: hda/hdmi: Add HP Device 0x8711 to force connect list

Jiasheng Jiang (6):
      soc: qcom: apr: Add check for idr_alloc and of_property_read_string_index
      media: coda: jpeg: Add check for kmalloc
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

Jiri Pirko (1):
      net/mlx5: Add forgotten cleanup calls into mlx5_init_once() error path

Jiri Slaby (2):
      tty: serial: clean up stop-tx part in altera_uart_tx_chars()
      tty: serial: altera_uart_{r,t}x_chars() need only uart_port

Jiri Slaby (SUSE) (1):
      qed (gcc13): use u16 for fid to be big enough

Johan Hovold (1):
      regulator: core: fix deadlock on regulator enable

John Johansen (2):
      apparmor: fix lockdep warning when removing a namespace
      apparmor: Fix abi check to include v8 abi

John Keeping (2):
      usb: gadget: f_hid: fix f_hidg lifetime vs cdev
      usb: gadget: f_hid: fix refcount leak on error path

John Stultz (2):
      pstore: Switch pmsg_lock to an rt_mutex to avoid priority inversion
      pstore: Make sure CONFIG_PSTORE_PMSG selects CONFIG_RT_MUTEXES

Jon Hunter (1):
      pwm: tegra: Improve required rate calculation

Jonathan Cameron (2):
      iio:imu:adis: Use IRQF_NO_AUTOEN instead of irq request then disable
      iio:imu:adis: Move exports into IIO_ADISLIB namespace

Jonathan Neuschäfer (1):
      spi: Update reference to struct spi_controller

Jonathan Toppins (1):
      bonding: fix link recovery in mode 2 when updelay is nonzero

José Expósito (1):
      HID: multitouch: fix Asus ExpertBook P2 P2451FA trackpoint

Jozsef Kadlecsik (2):
      netfilter: ipset: fix hash:net,port,net hang with /0 subnet
      netfilter: ipset: Rework long task execution when adding/deleting entries

Junlin Yang (1):
      pata_ipx4xx_cf: Fix unsigned comparison with less than zero

Kai Ye (1):
      crypto: rockchip - delete unneeded variable initialization

Kajol Jain (1):
      powerpc/hv-gpci: Fix hv_gpci event list

Kant Fan (1):
      PM/devfreq: governor: Add a private governor_data for governor

Kartik (1):
      serial: tegra: Read DMA status before terminating

Kees Cook (2):
      igb: Do not free q_vector unless new one was allocated
      LoadPin: Ignore the "contents" argument of the LSM hooks

Keita Suzuki (1):
      media: dvb-core: Fix double free in dvb_register_device()

Keith Busch (2):
      nvme-pci: fix mempool alloc size
      nvme-pci: fix page size checks

Kim Phillips (1):
      iommu/amd: Fix ivrs_acpihid cmdline parsing code

Klaus Jensen (1):
      nvme-pci: fix doorbell buffer value endianness

Kory Maincent (1):
      arm: dts: spear600: Fix clcd interrupt

Kris Bahnsen (1):
      spi: spi-gpio: Don't set MOSI as an input if not 3WIRE mode

Krzysztof Kozlowski (5):
      arm64: dts: qcom: ipq6018-cp01-c1: use BLSPI1 pins
      arm64: dts: qcom: sdm630: fix UART1 pin bias
      arm64: dts: qcom: sdm845-cheza: fix AP suspend pin bias
      arm64: dts: qcom: sdm845-db845c: correct SPI2 pins drive strength
      arm64: dts: qcom: sdm850-lenovo-yoga-c630: correct I2C12 pins drive strength

Kumar Kartikeya Dwivedi (1):
      bpf: Fix slot type check in check_stack_write_var_off

Kunihiko Hayashi (2):
      PCI: pci-epf-test: Register notifier if only core_init_notifier is enabled
      mmc: f-sdh30: Add quirks for broken timeout clock capability

Kurt Kanzenbach (1):
      igc: Lift TAPRIO schedule restriction

Ladislav Michl (1):
      MIPS: OCTEON: warn only once if deprecated link status is being used

Lee Jones (1):
      clk: socfpga: clk-pll: Remove unused variable 'rc'

Leo Yan (3):
      perf trace: Return error if a system call doesn't exist
      perf trace: Use macro RAW_SYSCALL_ARGS_NUM to replace number
      perf trace: Handle failure when trace point folder is missed

Leon Romanovsky (1):
      RDMA/core: Fix order of nldev_exit call

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

Luca Ceresoli (2):
      staging: media: tegra-video: fix chan->mipi value on error
      staging: media: tegra-video: fix device_node use after free

Luca Weiss (4):
      ARM: dts: qcom: apq8064: fix coresight compatible
      soc: qcom: llcc: make irq truly optional
      remoteproc: qcom_q6v5_pas: disable wakeup on probe fail or remove
      remoteproc: qcom_q6v5_pas: detach power domains on remove

Luo Meng (5):
      dm thin: resume even if in FAIL mode
      dm thin: Fix UAF in run_timer_softirq()
      dm integrity: Fix UAF in dm_integrity_dtr()
      dm clone: Fix UAF in clone_dtr()
      dm cache: Fix UAF in destroy()

Luoyouming (2):
      RDMA/hns: Repacing 'dseg_len' by macros in fill_ext_sge_inl_data()
      RDMA/hns: Fix ext_sge num error when post send

Luís Henriques (1):
      ext4: fix error code return to user-space in ext4_get_branch()

Manivannan Sadhasivam (2):
      clk: qcom: gcc-sm8250: Use retention mode for USB GDSCs
      soc: qcom: Select REMAP_MMIO for LLCC driver

Maor Gottlieb (1):
      RDMA/mlx5: Fix validation of max_rd_atomic caps for DC

Marco Elver (3):
      objtool, kcsan: Add volatile read/write instrumentation to whitelist
      net: switch to storing KCOV handle directly in sk_buff
      kcsan: Instrument memcpy/memset/memmove with newer Clang

Marcus Folkesson (2):
      HID: hid-sensor-custom: set fixed size for custom attributes
      thermal/drivers/imx8mm_thermal: Validate temperature range

Marek Szyprowski (2):
      media: exynos4-is: don't rely on the v4l2_async_subdev internals
      ASoC: wm8994: Fix potential deadlock

Marek Vasut (5):
      ARM: dts: stm32: Drop stm32mp15xc.dtsi from Avenger96
      ARM: dts: stm32: Fix AV96 WLAN regulator gpio property
      clk: renesas: r9a06g032: Repair grave increment error
      drm/panel/panel-sitronix-st7701: Remove panel on DSI attach failure
      wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port

Maria Yu (1):
      remoteproc: core: Do pm_relax when in RPROC_OFFLINE state

Mark Rutland (1):
      arm64: make is_ttbrX_addr() noinstr-safe

Mark Zhang (2):
      RDMA/nldev: Return "-EAGAIN" if the cm_id isn't from expected port
      RDMA/nldev: Fix failure to send large messages

Markus Schneider-Pargmann (1):
      can: tcan4x5x: Remove invalid write in clear_interrupts

Martin Blumenstingl (2):
      hwmon: (jc42) Convert register access and caching to regmap/regcache
      hwmon: (jc42) Restore the min/max/critical temperatures on resume

Martin KaFai Lau (1):
      bpf: Check the other end of slot_type for STACK_SPILL

Masahiro Yamada (3):
      kbuild: remove unneeded mkdir for external modules_install
      kbuild: unify modules(_install) for in-tree and external modules
      kbuild: refactor single builds of *.ko

Masami Hiramatsu (Google) (4):
      x86/kprobes: Fix kprobes instruction boudary check with CONFIG_RETHUNK
      perf probe: Use dwarf_attr_integrate as generic DWARF attr accessor
      perf probe: Fix to get the DW_AT_decl_file and DW_AT_call_file as unsinged data
      x86/kprobes: Fix optprobe optimization check with CONFIG_RETHUNK

Mat Martineau (4):
      mptcp: mark ops structures as ro_after_init
      mptcp: remove MPTCP 'ifdef' in TCP SYN cookies
      mptcp: dedicated request sock for subflow in v6
      mptcp: use proper req destructor for IPv6

Matt Redfearn (1):
      include/uapi/linux/swab: Fix potentially missing __always_inline

Maxim Devaev (1):
      usb: gadget: f_hid: optional SETUP/SET_REPORT mode

Maxim Korotkov (1):
      ethtool: avoiding integer overflow in ethtool_phys_id()

Mazin Al Haddad (1):
      media: dvb-usb: fix memory leak in dvb_usb_adapter_init()

Miaoqian Lin (7):
      cxl: Fix refcount leak in cxl_calc_capp_routing
      selftests/powerpc: Fix resource leaks
      usb: dwc3: qcom: Fix memory leak in dwc3_qcom_interconnect_init
      nfc: Fix potential resource leaks
      net: phy: xgmiitorgmii: Fix refcount leak in xgmiitorgmii_probe
      gpio: sifive: Fix refcount leak in sifive_gpio_probe
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

Mikko Kovanen (1):
      drm/i915/dsi: fix VBT send packet port selection for dual link DSI

Mikulas Patocka (1):
      md: fix a crash in mempool_free

Minghao Chi (1):
      soc: ti: knav_qmss_queue: Use pm_runtime_resume_and_get instead of pm_runtime_get_sync

Minsuk Kang (2):
      nfc: pn533: Clear nfc_target before being used
      wifi: brcmfmac: Fix potential shift-out-of-bounds in brcmf_fw_alloc_request()

Muhammad Husaini Zulkifli (1):
      igc: Add checking for basetime less than zero

Muhammad Usama Anjum (1):
      selftests: set the BUILD variable to absolute path

NARIBAYASHI Akira (1):
      mm, compaction: fix fast_isolate_around() to stay within boundaries

Namhyung Kim (1):
      perf/core: Call LSM hook after copying perf_event_attr

Natalia Petrova (1):
      crypto: nitrox - avoid double free on error path in nitrox_sriov_init()

Nathan Chancellor (9):
      net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
      hamradio: baycom_epp: Fix return type of baycom_send_packet()
      drm/amdgpu: Fix type of second parameter in trans_msg() callback
      drm/amdgpu: Fix type of second parameter in odn_edit_dpm_table() callback
      s390/ctcm: Fix return type of ctc{mp,}m_tx()
      s390/netiucv: Fix return type of netiucv_tx()
      s390/lcs: Fix return type of lcs_start_xmit()
      drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()
      drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()

Nathan Lynch (3):
      powerpc/pseries/eeh: use correct API for error log size
      powerpc/rtas: avoid device tree lookups in rtas_os_term()
      powerpc/rtas: avoid scheduling in rtas_os_term()

Nicholas Piggin (1):
      powerpc/perf: callchain validate kernel stack pointer bounds

Nick Desaulniers (1):
      ARM: 9256/1: NWFPE: avoid compiler-generated __aeabi_uldivmod

Nuno Sá (3):
      iio: adis: handle devices that cannot unmask the drdy pin
      iio: adis: stylistic changes
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

Paul E. McKenney (2):
      torture: Exclude "NOHZ tick-stop error" from fatal errors
      rcu: Prevent lockdep-RCU splats on lock acquisition/release

Paul Menzel (1):
      fbdev: matroxfb: G200eW: Increase max memory from 1 MB to 16 MB

Paulo Alcantara (2):
      cifs: fix oops during encryption
      cifs: fix confusing debug message

Pavel Machek (1):
      f2fs: should put a page when checking the summary info

Pengcheng Yang (2):
      bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data
      bpf, sockmap: Fix data loss caused by using apply_bytes on ingress redirect

Peter Zijlstra (1):
      futex: Move to kernel/futex/

Phil Auld (1):
      cpu/hotplug: Make target_store() a nop when target == state

Philipp Jungkamp (1):
      ALSA: patch_realtek: Fix Dell Inspiron Plus 16

Piergiorgio Beruto (1):
      stmmac: fix potential division by 0

Pierre-Louis Bossart (4):
      ALSA/ASoC: hda: move/rename snd_hdac_ext_stop_streams to hdac_stream.c
      ALSA: hda: add snd_hdac_stop_streams() helper
      ASoC: Intel/SOF: use set_stream() instead of set_tdm_slots() for HDAudio
      ASoC/SoundWire: dai: expand 'stream' concept beyond SoundWire

Ping-Ke Shih (1):
      wifi: rtlwifi: 8192de: correct checking of IQK reload

Qais Yousef (1):
      sched/uclamp: Fix relationship between uclamp and migration margin

Qingfang DENG (1):
      netfilter: flowtable: really fix NAT IPv6 offload

Qiujun Huang (1):
      pstore/zone: Use GFP_ATOMIC to allocate zone buffer

Rafael J. Wysocki (10):
      PM: runtime: Do not call __rpm_callback() from rpm_idle()
      rtc: rtc-cmos: Do not check ACPI_FADT_LOW_POWER_S0
      rtc: cmos: Fix event handler registration ordering issue
      rtc: cmos: Fix wake alarm breakage
      rtc: cmos: Call cmos_wake_setup() from cmos_do_probe()
      rtc: cmos: Call rtc_wake_setup() from cmos_do_probe()
      rtc: cmos: Eliminate forward declarations of some functions
      rtc: cmos: Rename ACPI-related functions
      rtc: cmos: Disable ACPI RTC event on removal
      ACPICA: Fix error code path in acpi_ds_call_control_method()

Rafael Mendonca (3):
      vfio: platform: Do not pass return buffer to ACPI _RST method
      uio: uio_dmem_genirq: Fix missing unlock in irq configuration
      uio: uio_dmem_genirq: Fix deadlock between irq config and handling

Ramona Bolboaca (1):
      iio: adis: add '__adis_enable_irq()' implementation

Randy Dunlap (1):
      Input: joystick - fix Kconfig warning for JOYSTICK_ADC

Rasmus Villemoes (2):
      iio: adc128s052: add proper .data members in adc128_of_match table
      serial: fixup backport of "serial: Deassert Transmit Enable on probe in driver-specific way"

Ricardo Ribalda (2):
      media: i2c: ad5820: Fix error path
      ASoC: mediatek: mt8173: Enable IRQ when pdata is ready

Rickard x Andersson (1):
      gcov: add support for checksum field

Roberto Sassu (1):
      reiserfs: Add missing calls to reiserfs_security_free()

Rodrigo Branco (1):
      x86/bugs: Flush IBP in ib_prctl_set()

Ronak Doshi (1):
      vmxnet3: correctly report csum_level for encapsulated packet

Rui Zhang (1):
      regulator: core: fix use_count leakage when handling boot-on

Ryusuke Konishi (2):
      nilfs2: fix shift-out-of-bounds/overflow in nilfs_sb2_bad_offset()
      nilfs2: fix shift-out-of-bounds due to too large exponent of block size

Sascha Hauer (1):
      PCI/sysfs: Fix double free in error path

Sasha Levin (1):
      btrfs: replace strncpy() with strscpy()

Schspa Shi (1):
      mrp: introduce active flags to prevent UAF when applicant uninit

Sean Christopherson (1):
      KVM: nVMX: Inject #GP, not #UD, if "generic" VMXON CR0/CR4 check fails

Sebastian Andrzej Siewior (4):
      hsr: Add a rcu-read lock to hsr_forward_skb().
      hsr: Disable netpoll.
      hsr: Synchronize sending frames to have always incremented outgoing seq nr.
      hsr: Synchronize sequence number updates.

Shang XiaoJing (8):
      perf/smmuv3: Fix hotplug callback leak in arm_smmu_pmu_init()
      ocfs2: fix memory leak in ocfs2_stack_glue_init()
      irqchip: gic-pm: Use pm_runtime_resume_and_get() in gic_probe()
      scsi: ipr: Fix WARNING in ipr_init()
      crypto: omap-sham - Use pm_runtime_resume_and_get() in omap_sham_probe()
      samples: vfio-mdev: Fix missing pci_disable_device() in mdpy_fb_probe()
      fbdev: via: Fix error in via_core_init()
      parisc: led: Fix potential null-ptr-deref in start_task()

Shawn Bohrer (1):
      veth: Fix race with AF_XDP exposing old or uninitialized descriptors

Shay Drory (1):
      net/mlx5: Avoid recovery in probe flows

Shigeru Yoshida (3):
      udf: Avoid double brelse() in udf_rename()
      wifi: ar5523: Fix use-after-free on ar5523_cmd() timed out
      media: si470x: Fix use-after-free in si470x_int_in_callback()

Shung-Hsi Yu (1):
      libbpf: Fix null-pointer dereference in find_prog_by_sec_insn()

Shuqi Zhang (1):
      ext4: use kmemdup() to replace kmalloc + memcpy

Simon Ser (1):
      drm/connector: send hotplug uevent on connector cleanup

Smitha T Murthy (3):
      media: s5p-mfc: Fix to handle reference queue during finishing
      media: s5p-mfc: Clear workbit to handle error condition
      media: s5p-mfc: Fix in register read and write for H264

Srinivas Kandagatla (1):
      soc: qcom: apr: make code more reuseable

Stanislav Fomichev (4):
      bpf: Move skb->len == 0 checks into __bpf_redirect
      bpf: make sure skb->len != 0 when redirecting to a tunneling device
      ppp: associate skb with a device at tx
      bpf: Prevent decl_tag from being referenced in func_proto arg

Stefan Eichenberger (1):
      rtc: snvs: Allow a time difference on clock register read

Stefano Garzarella (2):
      vringh: fix range used in iotlb_translate()
      vhost: fix range used in translate_desc()

Stephan Gerhold (1):
      arm64: dts: qcom: msm8916: Drop MSS fallback compatible

Stephen Boyd (1):
      pstore: Avoid kcore oops by vmap()ing with VM_IOREMAP

Steve French (1):
      cifs: fix missing display of three mount options

Steven Price (2):
      pwm: tegra: Fix 32 bit build
      drm/panfrost: Fix GEM handle creation ref-counting

Steven Rostedt (2):
      kest.pl: Fix grub2 menu handling for rebooting
      ktest.pl minconfig: Unset configs instead of just removing them

Steven Rostedt (Google) (1):
      ftrace/x86: Add back ftrace_expected for ftrace bug reports

Subash Abhinov Kasiviswanathan (1):
      skbuff: Account for tail adjustment during pull operations

Sven Peter (3):
      usb: typec: Check for ops->exit instead of ops->enter in altmode_exit
      usb: typec: tipd: Fix spurious fwnode_handle_put in error path
      usb: dwc3: Fix race between dwc3_set_mode and __dwc3_set_mode

Szymon Heidrich (1):
      usb: rndis_host: Secure rndis_query check against int overflow

Takashi Iwai (2):
      ALSA: pcm: Set missing stop_operating flag at undoing trigger start
      media: dvb-core: Fix UAF due to refcount races at releasing

Tan Tee Min (2):
      igc: recalculate Qbv end_time by considering cycle time
      igc: Set Qbv start_time and end_time to end_time if not being configured in GCL

Tang Bin (1):
      venus: pm_helpers: Fix error check in vcodec_domains_get()

Terry Junge (1):
      HID: plantronics: Additional PIDs for double volume key presses quirk

Tom Lendacky (2):
      net: amd-xgbe: Fix logic around active and passive cables
      net: amd-xgbe: Check only the minimum speed for active/passive cables

Tong Tiangen (1):
      riscv/mm: add arch hook arch_clear_hugepage_flags

Trond Myklebust (6):
      NFSv4.2: Clear FATTR4_WORD2_SECURITY_LABEL when done decoding
      NFSv4.2: Fix a memory stomp in decode_attr_security_label
      NFSv4.2: Fix initialisation of struct nfs4_label
      NFSv4: Fix a deadlock between nfs4_open_recover_helper() and delegreturn
      NFS: Fix an Oops in nfs_d_automount()
      NFSv4.x: Fail client initialisation if state manager thread can't run

Ulf Hansson (2):
      cpuidle: dt: Return the correct numbers of parsed idle states
      PM: runtime: Improve path in rpm_idle() when no callback

Uwe Kleine-König (2):
      crypto: ccree - Make cc_debugfs_global_fini() available for module init function
      pwm: sifive: Call pwm_sifive_update_clock() while mutex is held

Vidya Sagar (1):
      PCI: dwc: Fix n_fts[] array overrun

Ville Syrjälä (3):
      drm/msm: Use drm_mode_copy()
      drm/rockchip: Use drm_mode_copy()
      drm/sti: Use drm_mode_copy()

Vincent Donnefort (1):
      sched/fair: Cleanup task_util and capacity type

Vincent Mailhol (1):
      can: kvaser_usb: do not increase tx statistics when sending error message frames

Vinicius Costa Gomes (2):
      igc: Enhance Qbv scheduling by using first flag bit
      igc: Use strict cycles for Qbv scheduling

Vladimir Oltean (1):
      net: add a helper to avoid issues with HW TX timestamping and SO_TXTIME

Vladimir Zapolskiy (1):
      media: camss: Clean up received buffers on failed start of streaming

Wang Jingjin (2):
      ASoC: rockchip: pdm: Add missing clk_disable_unprepare() in rockchip_pdm_runtime_resume()
      ASoC: rockchip: spdif: Add missing clk_disable_unprepare() in rk_spdif_runtime_resume()

Wang ShaoBo (2):
      regulator: core: use kfree_const() to free space conditionally
      SUNRPC: Fix missing release socket in rpc_sockname()

Wang Weiyang (2):
      rapidio: fix possible UAF when kfifo_alloc() fails
      device_cgroup: Roll back to original exceptions after copy failure

Wang Yufen (7):
      pstore/ram: Fix error return code in ramoops_probe()
      wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()
      RDMA/hfi1: Fix error return code in parse_platform_config()
      RDMA/srp: Fix error return code in srp_parse_options()
      ASoC: mediatek: mt8173-rt5650-rt5514: fix refcount leak in mt8173_rt5650_rt5514_dev_probe()
      ASoC: audio-graph-card: fix refcount leak of cpu_ep in __graph_for_each_link()
      binfmt: Fix error return code in load_elf_fdpic_binary()

Wenchao Chen (1):
      mmc: sdhci-sprd: Disable CLK_AUTO when the clock is less than 400K

Wolfram Sang (3):
      docs: fault-injection: fix non-working usage of negative values
      clocksource/drivers/sh_cmt: Access registers according to spec
      mmc: renesas_sdhi: better reset from HS400 mode

Wright Feng (1):
      brcmfmac: return error when getting invalid max_flowrings from dongle

Xiaomeng Tong (1):
      drbd: fix an invalid memory access caused by incorrect use of list iterator

Xie Shaowen (1):
      macintosh/macio-adb: check the return value of ioremap()

Xin Long (2):
      net: add inline function skb_csum_is_sctp
      net: igc: use skb_csum_is_sctp instead of protocol check

Xinlei Lee (1):
      drm/mediatek: Modify dpi power on/off sequence.

Xiongfeng Wang (12):
      perf/x86/intel/uncore: Fix reference count leak in hswep_has_limit_sbox()
      perf/x86/intel/uncore: Fix reference count leak in snr_uncore_mmio_map()
      perf/x86/intel/uncore: Fix reference count leak in __uncore_imc_init_box()
      cpufreq: amd_freq_sensitivity: Add missing pci_dev_put()
      drm/radeon: Fix PCI device refcount leak in radeon_atrm_get_bios()
      drm/amdgpu: Fix PCI device refcount leak in amdgpu_atrm_get_bios()
      crypto: hisilicon/qm - add missing pci_dev_put() in q_num_set()
      RDMA/hfi: Decrease PCI device reference count in error path
      hwrng: amd - Fix PCI device refcount leak
      hwrng: geode - Fix PCI device refcount leak
      serial: pch: Fix PCI device refcount leak in pch_request_dma()
      fbdev: vermilion: decrease reference count in error path

Xiu Jianfeng (10):
      x86/xen: Fix memory leak in xen_smp_intr_init{_pv}()
      x86/xen: Fix memory leak in xen_init_lock_cpu()
      ima: Fix misuse of dereference of pointer in template_desc_init_fields()
      wifi: ath10k: Fix return value in ath10k_pci_init()
      clk: rockchip: Fix memory leak in rockchip_clk_register_pll()
      clk: samsung: Fix memory leak in _samsung_clk_register_pll()
      clk: socfpga: Fix memory leak in socfpga_gate_init()
      apparmor: Use pointer to struct aa_label for lbs_cred
      apparmor: Fix memleak in alloc_ns()
      clk: st: Fix memory leak in st_of_quadfs_setup()

Xiubo Li (1):
      ceph: switch to vfs_inode_has_locks() to fix file lock bug

Xu Kuohai (1):
      libbpf: Fix use-after-free in btf_dump_name_dups

Yan Lei (1):
      media: dvb-frontends: fix leak of memory fw

Yang Jihong (3):
      blktrace: Fix output non-blktrace event when blk_classic option enabled
      perf debug: Set debug_peo_args and redirect_to_stderr variable to correct values in perf_quiet_option()
      tracing: Fix infinite loop in tracing_read_pipe on overflowed print_trace_line

Yang Yingliang (72):
      MIPS: vpe-mt: fix possible memory leak while module exiting
      MIPS: vpe-cmp: fix possible memory leak while module exiting
      PNP: fix name memory leak in pnp_alloc_dev()
      EDAC/i10nm: fix refcount leak in pci_get_dev_wrapper()
      genirq/irqdesc: Don't try to remove non-existing sysfs files
      rapidio: fix possible name leaks when rio_add_device() fails
      rapidio: rio: fix possible name leak in rio_register_mport()
      clocksource/drivers/timer-ti-dm: Fix missing clk_disable_unprepare in dmtimer_systimer_init_clock()
      platform/x86: intel_scu_ipc: fix possible name leak in __intel_scu_ipc_register()
      media: platform: exynos4-is: fix return value check in fimc_md_probe()
      regulator: core: fix unbalanced of node refcount in regulator_dev_lookup()
      media: solo6x10: fix possible memory leak in solo_sysfs_init()
      drm/amdgpu: fix pci device refcount leak
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
      scsi: scsi_debug: Fix possible name leak in sdebug_add_host_helper()
      drivers: dio: fix possible memory leak in dio_init()
      class: fix possible memory leak in __class_register()
      usb: typec: tcpci: fix of node refcount leak in tcpci_register_port()
      misc: ocxl: fix possible name leak in ocxl_file_register_afu()
      ocxl: fix pci device refcount leak when calling get_function_0()
      firmware: raspberrypi: fix possible memory leak in rpi_firmware_probe()
      cxl: fix possible null-ptr-deref in cxl_guest_init_afu|adapter()
      cxl: fix possible null-ptr-deref in cxl_pci_init_afu|adapter()
      usb: roles: fix of node refcount leak in usb_role_switch_is_parent()
      mcb: mcb-parse: fix error handing in chameleon_parse_gdd()
      chardev: fix error handling in cdev_device_add()
      i2c: mux: reg: check return value after calling platform_get_resource()
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
      hwmon: (jc42) Fix missing unlock on error in jc42_write()

Yanjun Zhang (1):
      nvme: fix multipath crash caused by flush request when blktrace is enabled

Yazen Ghannam (1):
      x86/MCE/AMD: Clear DFR errors found in THR handler

Ye Bin (5):
      blk-mq: fix possible memleak when register 'hctx' failed
      ext4: fix reserved cluster accounting in __es_remove_extent()
      ext4: init quota for 'old.inode' in 'ext4_rename'
      ext4: fix inode leak in ext4_xattr_inode_create() on an error path
      ext4: allocate extended attribute value in vmalloc area

Yipeng Zou (1):
      selftests/ftrace: event_triggers: wait longer for test_event_enable

Yonggil Song (1):
      f2fs: avoid victim selection from previous victim section

Yongqiang Liu (2):
      net: defxx: Fix missing err handling in dfx_init()
      cpufreq: Init completion before kobject_init_and_add()

Yu Liao (1):
      platform/x86: mxm-wmi: fix memleak in mxm_wmi_call_mx[ds|mx]()

Yuan Can (14):
      perf: arm_dsu: Fix hotplug callback leak in dsu_pmu_init()
      tpm/tpm_ftpm_tee: Fix error handling in ftpm_mod_init()
      platform/chrome: cros_usbpd_notify: Fix error handling in cros_usbpd_notify_init()
      media: platform: exynos4-is: Fix error handling in fimc_md_init()
      ASoC: qcom: Add checks for devm_kcalloc
      drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()
      scsi: hpsa: Fix possible memory leak in hpsa_init_one()
      RDMA/nldev: Add checks for nla_nest_start() in fill_stat_counter_qps()
      serial: sunsab: Fix error handling in sunsab_init()
      HSI: omap_ssi_core: Fix error handling in ssi_init()
      iommu/fsl_pamu: Fix resource leak in fsl_pamu_probe()
      remoteproc: qcom_q6v5_pas: Fix missing of_node_put() in adsp_alloc_memory_region()
      drm/ingenic: Fix missing platform_driver_unregister() call in ingenic_drm_init()
      vhost/vsock: Fix error handling in vhost_vsock_init()

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

Zhang Qilong (6):
      soc: ti: knav_qmss_queue: Fix PM disable depth imbalance in knav_queue_probe
      soc: ti: smartreflex: Fix PM disable depth imbalance in omap_sr_probe
      eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD
      drm/rockchip: lvds: fix PM usage counter unbalance in poweron
      ASoC: pcm512x: Fix PM disable depth imbalance in pcm512x_probe
      f2fs: Fix the race condition of resize flag between resizefs

Zhang Tianci (1):
      ovl: Use ovl mounter's fsuid and fsgid in ovl_link()

Zhang Xiaoxu (6):
      mtd: Fix device name leak when register device failed in add_mtd_device()
      xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()
      RDMA/rxe: Fix NULL-ptr-deref in rxe_qp_do_cleanup() when socket create failed
      orangefs: Fix sysfs not cleanup when dev init failed
      orangefs: Fix kmemleak in orangefs_prepare_debugfs_help_string()
      orangefs: Fix kmemleak in orangefs_{kernel,client}_debug_init()

Zhang Yi (2):
      ext4: silence the warning when evicting inode with dioread_nolock
      ext4: check and assert if marking an no_delete evicting inode dirty

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

Zhengchao Shao (5):
      wifi: mac80211: fix memory leak in ieee80211_if_add()
      RDMA/hns: fix memory leak in hns_roce_alloc_mr()
      test_firmware: fix memory leak in test_firmware_init()
      drivers: mcb: fix resource leak in mcb_probe()
      caif: fix memory leak in cfctrl_linkup_request()

Zhenyu Wang (2):
      drm/i915/gvt: fix gvt debugfs destroy
      drm/i915/gvt: fix vgpu debugfs clean in remove

Zheyu Ma (1):
      i2c: ismt: Fix an out-of-bounds bug in ismt_access()

Zhihao Cheng (2):
      dm thin: Fix ABBA deadlock between shrink_slab and dm_pool_abort_metadata
      dm thin: Use last transaction's pmd->root when commit failed

Zqiang (1):
      rcu: Fix __this_cpu_read() lockdep warning in rcu_force_quiescent_state()

delisun (1):
      serial: pl011: Do not clear RX FIFO & RX interrupt in unthrottle.

gehao (1):
      drm/amd/display: prevent memory leak

minoura makoto (1):
      SUNRPC: ensure the matching upcall is in-flight upon downcall

ruanjinjie (3):
      of: overlay: fix null pointer dereferencing in find_dup_cset_node_entry() and find_dup_cset_prop()
      misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()
      power: supply: fix null pointer dereferencing in power_supply_get_battery_info

wangdicheng (1):
      ALSA: usb-audio: add the quirk for KT0206 device

wuchi (1):
      lib/debugobjects: fix stat count and optimize debug_objects_mem_init

xiongxin (1):
      PM: hibernate: Fix mistake in kerneldoc comment

