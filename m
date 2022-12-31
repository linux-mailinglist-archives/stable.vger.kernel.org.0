Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2A365A3ED
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 13:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiLaM1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 07:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiLaM1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 07:27:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E74E266C;
        Sat, 31 Dec 2022 04:27:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8740BB8049B;
        Sat, 31 Dec 2022 12:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCC0C433EF;
        Sat, 31 Dec 2022 12:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672489650;
        bh=RKw3XJ/9ufaFwmOCwjhTSlPhHqjjlzeYcDbirCKpipc=;
        h=From:To:Cc:Subject:Date:From;
        b=nZwjwdwpo7CfFHZ0O6jdBwUS7AVtUtBpZwrqTRhYKTfk432bmeD4isBZdyR+uDQRG
         4m1v/U11VY5z0L7hopjW7kdaKZO12A1+uE93nyg5OSo5xTTOOKN4vrXHtXV02B+JAu
         NOw7z7mCPrSHEkvgUMzoRUHuK8uBLfALeQ1gin7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.86
Date:   Sat, 31 Dec 2022 13:27:26 +0100
Message-Id: <1672489645121187@kroah.com>
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

I'm announcing the release of the 5.15.86 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-spi-devices-spi-nor             |    3 
 Documentation/devicetree/bindings/pci/fsl,imx6q-pcie.yaml           |   46 
 Documentation/devicetree/bindings/pci/toshiba,visconti-pcie.yaml    |    7 
 Documentation/devicetree/bindings/sound/qcom,wcd9335.txt            |    2 
 Documentation/driver-api/spi.rst                                    |    4 
 Documentation/fault-injection/fault-injection.rst                   |   10 
 Documentation/process/deprecated.rst                                |   20 
 MAINTAINERS                                                         |    2 
 Makefile                                                            |    2 
 arch/alpha/include/asm/thread_info.h                                |    2 
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
 arch/arm/boot/dts/nuvoton-npcm730-gbs.dts                           |    2 
 arch/arm/boot/dts/nuvoton-npcm730-gsj.dts                           |    2 
 arch/arm/boot/dts/nuvoton-npcm730-kudo.dts                          |    6 
 arch/arm/boot/dts/nuvoton-npcm750-evb.dts                           |    4 
 arch/arm/boot/dts/nuvoton-npcm750-runbmc-olympus.dts                |    6 
 arch/arm/boot/dts/qcom-apq8064.dtsi                                 |    2 
 arch/arm/boot/dts/spear600.dtsi                                     |    2 
 arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts                   |    1 
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi                  |    2 
 arch/arm/mach-mmp/time.c                                            |   11 
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts              |    3 
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts                         |   12 
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi                           |   22 
 arch/arm64/boot/dts/mediatek/mt6779.dtsi                            |    8 
 arch/arm64/boot/dts/mediatek/mt6797.dtsi                            |    2 
 arch/arm64/boot/dts/mediatek/mt8183.dtsi                            |    2 
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi                    |    6 
 arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dts                        |    2 
 arch/arm64/boot/dts/qcom/ipq6018.dtsi                               |    2 
 arch/arm64/boot/dts/qcom/ipq8074.dtsi                               |    4 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                               |    2 
 arch/arm64/boot/dts/qcom/msm8996.dtsi                               |  122 
 arch/arm64/boot/dts/qcom/msm8996pro.dtsi                            |  266 
 arch/arm64/boot/dts/qcom/msm8998.dtsi                               |    6 
 arch/arm64/boot/dts/qcom/pm660.dtsi                                 |    2 
 arch/arm64/boot/dts/qcom/sdm630.dtsi                                |    2 
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi                          |    4 
 arch/arm64/boot/dts/qcom/sdm845.dtsi                                |   10 
 arch/arm64/boot/dts/qcom/sm6125.dtsi                                |    2 
 arch/arm64/boot/dts/qcom/sm8150.dtsi                                |   16 
 arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi                |    2 
 arch/arm64/boot/dts/qcom/sm8250.dtsi                                |   30 
 arch/arm64/boot/dts/qcom/sm8350.dtsi                                |   12 
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi                            |    1 
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi                           |    1 
 arch/arm64/include/asm/debug-monitors.h                             |    4 
 arch/arm64/include/asm/esr.h                                        |    6 
 arch/arm64/include/asm/exception.h                                  |   28 
 arch/arm64/include/asm/processor.h                                  |    4 
 arch/arm64/include/asm/system_misc.h                                |    4 
 arch/arm64/include/asm/traps.h                                      |   12 
 arch/arm64/kernel/debug-monitors.c                                  |   12 
 arch/arm64/kernel/entry-common.c                                    |    6 
 arch/arm64/kernel/fpsimd.c                                          |    6 
 arch/arm64/kernel/hw_breakpoint.c                                   |    4 
 arch/arm64/kernel/kgdb.c                                            |    6 
 arch/arm64/kernel/probes/kprobes.c                                  |    4 
 arch/arm64/kernel/probes/uprobes.c                                  |    4 
 arch/arm64/kernel/traps.c                                           |   66 
 arch/arm64/mm/fault.c                                               |   78 
 arch/mips/bcm63xx/clk.c                                             |    2 
 arch/mips/cavium-octeon/executive/cvmx-helper-board.c               |    2 
 arch/mips/cavium-octeon/executive/cvmx-helper.c                     |    2 
 arch/mips/include/asm/mach-ralink/mt7621.h                          |    4 
 arch/mips/kernel/vpe-cmp.c                                          |    4 
 arch/mips/kernel/vpe-mt.c                                           |    4 
 arch/mips/ralink/mt7621.c                                           |   97 
 arch/powerpc/perf/callchain.c                                       |    1 
 arch/powerpc/perf/hv-gpci-requests.h                                |    4 
 arch/powerpc/perf/hv-gpci.c                                         |   33 
 arch/powerpc/perf/hv-gpci.h                                         |    1 
 arch/powerpc/perf/req-gen/perf.h                                    |   20 
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c                       |    1 
 arch/powerpc/platforms/83xx/mpc832x_rdb.c                           |    2 
 arch/powerpc/platforms/pseries/eeh_pseries.c                        |   14 
 arch/powerpc/sysdev/xive/spapr.c                                    |    1 
 arch/powerpc/xmon/xmon.c                                            |    7 
 arch/riscv/include/asm/hugetlb.h                                    |    6 
 arch/riscv/kernel/traps.c                                           |    2 
 arch/riscv/net/bpf_jit_comp64.c                                     |   29 
 arch/x86/events/intel/uncore_snb.c                                  |    3 
 arch/x86/events/intel/uncore_snbep.c                                |    5 
 arch/x86/hyperv/hv_init.c                                           |    2 
 arch/x86/kernel/cpu/sgx/encl.c                                      |   23 
 arch/x86/kernel/uprobes.c                                           |    4 
 arch/x86/xen/smp.c                                                  |   24 
 arch/x86/xen/smp_pv.c                                               |   12 
 arch/x86/xen/spinlock.c                                             |    6 
 block/bfq-iosched.c                                                 |   16 
 block/blk-mq-sysfs.c                                                |   11 
 block/genhd.c                                                       |    2 
 crypto/cryptd.c                                                     |   36 
 crypto/tcrypt.c                                                     |    9 
 drivers/acpi/acpica/dsmethod.c                                      |   10 
 drivers/acpi/acpica/utcopy.c                                        |    7 
 drivers/ata/acard-ahci.c                                            |    2 
 drivers/ata/ahci.c                                                  |    4 
 drivers/ata/ahci_qoriq.c                                            |    2 
 drivers/ata/ahci_xgene.c                                            |    2 
 drivers/ata/libahci.c                                               |    4 
 drivers/ata/libata-acpi.c                                           |   52 
 drivers/ata/libata-core.c                                           |   73 
 drivers/ata/libata-eh.c                                             |   42 
 drivers/ata/libata-sata.c                                           |   19 
 drivers/ata/libata-scsi.c                                           |   22 
 drivers/ata/libata-sff.c                                            |    6 
 drivers/ata/pata_ep93xx.c                                           |    4 
 drivers/ata/pata_ixp4xx_cf.c                                        |    6 
 drivers/ata/pata_ns87415.c                                          |    4 
 drivers/ata/pata_octeon_cf.c                                        |    4 
 drivers/ata/pata_samsung_cf.c                                       |    2 
 drivers/ata/sata_highbank.c                                         |    2 
 drivers/ata/sata_inic162x.c                                         |   10 
 drivers/ata/sata_rcar.c                                             |    4 
 drivers/ata/sata_svw.c                                              |   10 
 drivers/ata/sata_vsc.c                                              |   10 
 drivers/base/class.c                                                |    5 
 drivers/base/power/runtime.c                                        |   12 
 drivers/block/drbd/drbd_main.c                                      |    9 
 drivers/block/floppy.c                                              |    4 
 drivers/block/loop.c                                                |   28 
 drivers/bluetooth/btintel.c                                         |    5 
 drivers/bluetooth/btusb.c                                           |    6 
 drivers/bluetooth/hci_bcsp.c                                        |    2 
 drivers/bluetooth/hci_h5.c                                          |    2 
 drivers/bluetooth/hci_ll.c                                          |    2 
 drivers/bluetooth/hci_qca.c                                         |    2 
 drivers/char/hw_random/amd-rng.c                                    |   18 
 drivers/char/hw_random/geode-rng.c                                  |   36 
 drivers/char/ipmi/ipmi_msghandler.c                                 |    8 
 drivers/char/ipmi/kcs_bmc_aspeed.c                                  |   24 
 drivers/char/tpm/tpm_crb.c                                          |    2 
 drivers/char/tpm/tpm_ftpm_tee.c                                     |    8 
 drivers/clk/imx/clk-imx8mn.c                                        |   34 
 drivers/clk/qcom/clk-krait.c                                        |    2 
 drivers/clk/qcom/gcc-sm8250.c                                       |    4 
 drivers/clk/qcom/lpasscorecc-sc7180.c                               |   24 
 drivers/clk/renesas/r9a06g032-clocks.c                              |    3 
 drivers/clk/rockchip/clk-pll.c                                      |    1 
 drivers/clk/samsung/clk-pll.c                                       |    1 
 drivers/clk/socfpga/clk-gate.c                                      |    5 
 drivers/clk/st/clkgen-fsyn.c                                        |    5 
 drivers/clocksource/sh_cmt.c                                        |   88 
 drivers/clocksource/timer-ti-dm-systimer.c                          |    4 
 drivers/counter/stm32-lptimer-cnt.c                                 |    2 
 drivers/cpufreq/amd_freq_sensitivity.c                              |    2 
 drivers/cpufreq/qcom-cpufreq-hw.c                                   |    1 
 drivers/cpuidle/dt_idle_states.c                                    |    2 
 drivers/crypto/Kconfig                                              |    5 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c                 |    2 
 drivers/crypto/amlogic/amlogic-gxl-core.c                           |    1 
 drivers/crypto/amlogic/amlogic-gxl.h                                |    2 
 drivers/crypto/cavium/nitrox/nitrox_mbx.c                           |    1 
 drivers/crypto/ccree/cc_debugfs.c                                   |    2 
 drivers/crypto/ccree/cc_driver.c                                    |   10 
 drivers/crypto/hisilicon/hpre/hpre_main.c                           |   10 
 drivers/crypto/hisilicon/qm.c                                       |    7 
 drivers/crypto/hisilicon/qm.h                                       |    6 
 drivers/crypto/img-hash.c                                           |    8 
 drivers/crypto/omap-sham.c                                          |    2 
 drivers/crypto/rockchip/rk3288_crypto.c                             |  193 
 drivers/crypto/rockchip/rk3288_crypto.h                             |   53 
 drivers/crypto/rockchip/rk3288_crypto_ahash.c                       |  197 
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c                    |  413 
 drivers/dio/dio.c                                                   |    8 
 drivers/edac/i10nm_base.c                                           |    3 
 drivers/extcon/Kconfig                                              |    2 
 drivers/extcon/extcon-usbc-tusb320.c                                |  402 
 drivers/firmware/raspberrypi.c                                      |    1 
 drivers/gpio/gpiolib-cdev.c                                         |  268 
 drivers/gpio/gpiolib.c                                              |   16 
 drivers/gpio/gpiolib.h                                              |   39 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                    |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c                            |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                          |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h                            |    5 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c           |   35 
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c                  |   16 
 drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c               |    3 
 drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c               |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c           |   30 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c                  |   29 
 drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c             |   14 
 drivers/gpu/drm/amd/include/kgd_pp_interface.h                      |    3 
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c                    |    3 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c                     |    2 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c               |    3 
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c                      |    4 
 drivers/gpu/drm/bridge/adv7511/adv7511.h                            |    3 
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c                        |   18 
 drivers/gpu/drm/bridge/adv7511/adv7533.c                            |   25 
 drivers/gpu/drm/drm_fourcc.c                                        |   11 
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c                               |   11 
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c                           |    5 
 drivers/gpu/drm/i915/display/intel_dp.c                             |   59 
 drivers/gpu/drm/mediatek/mtk_dpi.c                                  |   12 
 drivers/gpu/drm/mediatek/mtk_hdmi.c                                 |    7 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                               |   12 
 drivers/gpu/drm/msm/dp/dp_display.c                                 |    2 
 drivers/gpu/drm/msm/hdmi/hdmi.c                                     |   68 
 drivers/gpu/drm/msm/hdmi/hdmi.h                                     |   13 
 drivers/gpu/drm/msm/hdmi/hdmi_hpd.c                                 |   62 
 drivers/gpu/drm/panel/panel-sitronix-st7701.c                       |   10 
 drivers/gpu/drm/radeon/radeon_bios.c                                |   19 
 drivers/gpu/drm/rockchip/cdn-dp-core.c                              |    2 
 drivers/gpu/drm/rockchip/inno_hdmi.c                                |    2 
 drivers/gpu/drm/rockchip/rk3066_hdmi.c                              |    2 
 drivers/gpu/drm/rockchip/rockchip_lvds.c                            |   10 
 drivers/gpu/drm/sti/sti_dvo.c                                       |    7 
 drivers/gpu/drm/sti/sti_hda.c                                       |    7 
 drivers/gpu/drm/sti/sti_hdmi.c                                      |    7 
 drivers/gpu/drm/tegra/dc.c                                          |    4 
 drivers/hid/amd-sfh-hid/amd_sfh_client.c                            |    4 
 drivers/hid/hid-mcp2221.c                                           |   12 
 drivers/hid/hid-sensor-custom.c                                     |    2 
 drivers/hid/wacom_sys.c                                             |    8 
 drivers/hid/wacom_wac.c                                             |    4 
 drivers/hid/wacom_wac.h                                             |    1 
 drivers/hsi/controllers/omap_ssi_core.c                             |   14 
 drivers/hv/ring_buffer.c                                            |   13 
 drivers/hwmon/Kconfig                                               |    1 
 drivers/hwmon/jc42.c                                                |  243 
 drivers/hwtracing/coresight/coresight-trbe.c                        |    1 
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
 drivers/iio/imu/adis16460.c                                         |    1 
 drivers/iio/imu/adis16475.c                                         |    1 
 drivers/iio/imu/adis16480.c                                         |    1 
 drivers/iio/imu/adis_buffer.c                                       |   10 
 drivers/iio/imu/adis_trigger.c                                      |    9 
 drivers/iio/industrialio-event.c                                    |    4 
 drivers/iio/temperature/ltc2983.c                                   |   10 
 drivers/infiniband/core/device.c                                    |    2 
 drivers/infiniband/core/mad.c                                       |    5 
 drivers/infiniband/core/nldev.c                                     |    6 
 drivers/infiniband/core/restrack.c                                  |    2 
 drivers/infiniband/core/sysfs.c                                     |   17 
 drivers/infiniband/hw/hfi1/affinity.c                               |    2 
 drivers/infiniband/hw/hfi1/firmware.c                               |    6 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                          |   52 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h                          |    5 
 drivers/infiniband/hw/hns/hns_roce_mr.c                             |    4 
 drivers/infiniband/hw/irdma/verbs.c                                 |   35 
 drivers/infiniband/sw/rxe/rxe_qp.c                                  |    6 
 drivers/infiniband/sw/siw/siw_cq.c                                  |   24 
 drivers/infiniband/sw/siw/siw_qp_tx.c                               |    2 
 drivers/infiniband/sw/siw/siw_verbs.c                               |   40 
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c                        |    7 
 drivers/infiniband/ulp/srp/ib_srp.c                                 |   96 
 drivers/input/joystick/Kconfig                                      |    1 
 drivers/input/misc/Kconfig                                          |    2 
 drivers/input/touchscreen/elants_i2c.c                              |    9 
 drivers/iommu/amd/iommu_v2.c                                        |    1 
 drivers/iommu/fsl_pamu.c                                            |    2 
 drivers/iommu/rockchip-iommu.c                                      |   10 
 drivers/iommu/sun50i-iommu.c                                        |   16 
 drivers/irqchip/irq-gic-pm.c                                        |    2 
 drivers/irqchip/irq-wpcm450-aic.c                                   |    1 
 drivers/isdn/hardware/mISDN/hfcmulti.c                              |   19 
 drivers/isdn/hardware/mISDN/hfcpci.c                                |   13 
 drivers/isdn/hardware/mISDN/hfcsusb.c                               |   12 
 drivers/macintosh/macio-adb.c                                       |    4 
 drivers/macintosh/macio_asic.c                                      |    2 
 drivers/mailbox/arm_mhuv2.c                                         |    4 
 drivers/mailbox/mailbox-mpfs.c                                      |   31 
 drivers/mailbox/zynqmp-ipi-mailbox.c                                |    4 
 drivers/mcb/mcb-core.c                                              |    4 
 drivers/mcb/mcb-parse.c                                             |    2 
 drivers/md/md-bitmap.c                                              |   27 
 drivers/md/raid1.c                                                  |    1 
 drivers/media/dvb-core/dvb_ca_en50221.c                             |    2 
 drivers/media/dvb-core/dvb_frontend.c                               |   10 
 drivers/media/dvb-core/dvbdev.c                                     |   32 
 drivers/media/dvb-frontends/bcm3510.c                               |    1 
 drivers/media/i2c/ad5820.c                                          |   10 
 drivers/media/i2c/adv748x/adv748x-afe.c                             |    4 
 drivers/media/pci/saa7164/saa7164-core.c                            |    4 
 drivers/media/pci/solo6x10/solo6x10-core.c                          |    1 
 drivers/media/platform/coda/coda-bit.c                              |   14 
 drivers/media/platform/coda/coda-jpeg.c                             |   10 
 drivers/media/platform/exynos4-is/fimc-core.c                       |    2 
 drivers/media/platform/exynos4-is/media-dev.c                       |   12 
 drivers/media/platform/imx-jpeg/mxc-jpeg-hw.c                       |    4 
 drivers/media/platform/qcom/camss/camss-video.c                     |    3 
 drivers/media/platform/qcom/venus/pm_helpers.c                      |    4 
 drivers/media/platform/s5p-mfc/s5p_mfc.c                            |   17 
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c               |    1 
 drivers/media/radio/si470x/radio-si470x-usb.c                       |    4 
 drivers/media/rc/imon.c                                             |    6 
 drivers/media/test-drivers/vidtv/vidtv_bridge.c                     |   22 
 drivers/media/test-drivers/vimc/vimc-core.c                         |    2 
 drivers/media/test-drivers/vivid/vivid-vid-cap.c                    |    1 
 drivers/media/usb/dvb-usb/az6027.c                                  |    4 
 drivers/media/usb/dvb-usb/dvb-usb-init.c                            |    4 
 drivers/media/v4l2-core/v4l2-ctrls-core.c                           |    2 
 drivers/media/v4l2-core/videobuf-dma-contig.c                       |   22 
 drivers/memstick/core/ms_block.c                                    |   13 
 drivers/mfd/Kconfig                                                 |    1 
 drivers/mfd/qcom-pm8008.c                                           |   55 
 drivers/mfd/qcom_rpm.c                                              |   16 
 drivers/misc/cxl/guest.c                                            |   24 
 drivers/misc/cxl/pci.c                                              |   21 
 drivers/misc/ocxl/config.c                                          |   20 
 drivers/misc/ocxl/file.c                                            |    7 
 drivers/misc/sgi-gru/grufault.c                                     |   13 
 drivers/misc/sgi-gru/grumain.c                                      |   22 
 drivers/misc/sgi-gru/grutables.h                                    |    2 
 drivers/misc/tifm_7xx1.c                                            |    2 
 drivers/mmc/core/sd.c                                               |   11 
 drivers/mmc/host/alcor.c                                            |    5 
 drivers/mmc/host/atmel-mci.c                                        |    9 
 drivers/mmc/host/meson-gx-mmc.c                                     |    4 
 drivers/mmc/host/mmci.c                                             |    4 
 drivers/mmc/host/moxart-mmc.c                                       |    4 
 drivers/mmc/host/mxcmmc.c                                           |    4 
 drivers/mmc/host/omap_hsmmc.c                                       |    4 
 drivers/mmc/host/pxamci.c                                           |    7 
 drivers/mmc/host/renesas_sdhi_core.c                                |   14 
 drivers/mmc/host/rtsx_pci_sdmmc.c                                   |    9 
 drivers/mmc/host/rtsx_usb_sdmmc.c                                   |   11 
 drivers/mmc/host/sdhci_f_sdh30.c                                    |    3 
 drivers/mmc/host/toshsd.c                                           |    6 
 drivers/mmc/host/via-sdmmc.c                                        |    4 
 drivers/mmc/host/vub300.c                                           |   11 
 drivers/mmc/host/wbsd.c                                             |   12 
 drivers/mmc/host/wmt-sdmmc.c                                        |    6 
 drivers/mtd/lpddr/lpddr2_nvm.c                                      |    2 
 drivers/mtd/maps/pxa2xx-flash.c                                     |    2 
 drivers/mtd/mtdcore.c                                               |    4 
 drivers/mtd/spi-nor/core.c                                          |    3 
 drivers/mtd/spi-nor/sysfs.c                                         |   14 
 drivers/net/bonding/bond_main.c                                     |   13 
 drivers/net/can/m_can/m_can.c                                       |   32 
 drivers/net/can/m_can/m_can_platform.c                              |    4 
 drivers/net/can/m_can/tcan4x5x-core.c                               |   18 
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h                         |   30 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c                    |  115 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c                   |  174 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c                    |  446 -
 drivers/net/dsa/lan9303-core.c                                      |    4 
 drivers/net/ethernet/amd/atarilance.c                               |    2 
 drivers/net/ethernet/amd/lance.c                                    |    2 
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c                         |   23 
 drivers/net/ethernet/apple/bmac.c                                   |    2 
 drivers/net/ethernet/apple/mace.c                                   |    2 
 drivers/net/ethernet/dnet.c                                         |    4 
 drivers/net/ethernet/freescale/enetc/enetc.c                        |   35 
 drivers/net/ethernet/intel/i40e/i40e_main.c                         |   36 
 drivers/net/ethernet/intel/igb/igb_main.c                           |    8 
 drivers/net/ethernet/intel/igc/igc.h                                |    3 
 drivers/net/ethernet/intel/igc/igc_defines.h                        |    2 
 drivers/net/ethernet/intel/igc/igc_main.c                           |  233 
 drivers/net/ethernet/intel/igc/igc_tsn.c                            |   13 
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c                    |    1 
 drivers/net/ethernet/neterion/s2io.c                                |    2 
 drivers/net/ethernet/qlogic/qed/qed_debug.c                         |    3 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c            |    2 
 drivers/net/ethernet/rdc/r6040.c                                    |    5 
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c               |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                   |    4 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h                    |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c              |    8 
 drivers/net/ethernet/ti/netcp_core.c                                |    2 
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                       |    2 
 drivers/net/fddi/defxx.c                                            |   22 
 drivers/net/hamradio/baycom_epp.c                                   |    2 
 drivers/net/hamradio/scc.c                                          |    6 
 drivers/net/macsec.c                                                |   34 
 drivers/net/ntb_netdev.c                                            |    4 
 drivers/net/ppp/ppp_generic.c                                       |    2 
 drivers/net/wan/farsync.c                                           |    2 
 drivers/net/wireless/ath/ar5523/ar5523.c                            |    6 
 drivers/net/wireless/ath/ath10k/pci.c                               |   20 
 drivers/net/wireless/ath/ath9k/hif_usb.c                            |   46 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c         |    5 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c             |    6 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c             |    1 
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                         |   12 
 drivers/net/wireless/mediatek/mt76/mt76.h                           |    3 
 drivers/net/wireless/mediatek/mt76/mt7615/main.c                    |    3 
 drivers/net/wireless/mediatek/mt76/mt7915/main.c                    |    3 
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c                     |    2 
 drivers/net/wireless/mediatek/mt76/usb.c                            |   11 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h                    |    2 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c               |   26 
 drivers/net/wireless/rsi/rsi_91x_core.c                             |    4 
 drivers/net/wireless/rsi/rsi_91x_hal.c                              |    6 
 drivers/nfc/pn533/pn533.c                                           |    4 
 drivers/nvme/host/core.c                                            |    2 
 drivers/nvme/target/core.c                                          |   22 
 drivers/nvme/target/io-cmd-file.c                                   |   16 
 drivers/nvme/target/nvmet.h                                         |    3 
 drivers/of/overlay.c                                                |    4 
 drivers/pci/controller/dwc/pcie-designware.c                        |    2 
 drivers/pci/controller/vmd.c                                        |    5 
 drivers/pci/endpoint/functions/pci-epf-test.c                       |    2 
 drivers/pci/irq.c                                                   |    2 
 drivers/perf/arm_dmc620_pmu.c                                       |    8 
 drivers/perf/arm_dsu_pmu.c                                          |    6 
 drivers/perf/arm_smmuv3_pmu.c                                       |    8 
 drivers/phy/broadcom/phy-brcm-usb.c                                 |    6 
 drivers/pinctrl/pinconf-generic.c                                   |    4 
 drivers/pinctrl/pinctrl-k210.c                                      |    4 
 drivers/platform/chrome/cros_ec_typec.c                             |    8 
 drivers/platform/chrome/cros_usbpd_notify.c                         |    6 
 drivers/platform/mellanox/mlxbf-pmc.c                               |    2 
 drivers/platform/x86/huawei-wmi.c                                   |   20 
 drivers/platform/x86/intel_scu_ipc.c                                |    2 
 drivers/platform/x86/mxm-wmi.c                                      |    8 
 drivers/pnp/core.c                                                  |    4 
 drivers/power/supply/ab8500_charger.c                               |    9 
 drivers/power/supply/power_supply_core.c                            |    7 
 drivers/power/supply/z2_battery.c                                   |    6 
 drivers/pwm/pwm-mediatek.c                                          |    2 
 drivers/pwm/pwm-mtk-disp.c                                          |    5 
 drivers/pwm/pwm-sifive.c                                            |    5 
 drivers/pwm/pwm-tegra.c                                             |    4 
 drivers/rapidio/devices/rio_mport_cdev.c                            |   15 
 drivers/rapidio/rio-scan.c                                          |    8 
 drivers/rapidio/rio.c                                               |    9 
 drivers/regulator/core.c                                            |   15 
 drivers/regulator/qcom-labibb-regulator.c                           |    1 
 drivers/regulator/qcom-rpmh-regulator.c                             |    2 
 drivers/remoteproc/qcom_q6v5_pas.c                                  |    4 
 drivers/remoteproc/qcom_q6v5_wcss.c                                 |    6 
 drivers/remoteproc/qcom_sysmon.c                                    |    5 
 drivers/rtc/rtc-cmos.c                                              |  366 
 drivers/rtc/rtc-mxc_v2.c                                            |    4 
 drivers/rtc/rtc-pcf85063.c                                          |   10 
 drivers/rtc/rtc-pic32.c                                             |    8 
 drivers/rtc/rtc-snvs.c                                              |   16 
 drivers/rtc/rtc-st-lpc.c                                            |    1 
 drivers/s390/net/ctcm_main.c                                        |   11 
 drivers/s390/net/lcs.c                                              |    8 
 drivers/s390/net/netiucv.c                                          |    9 
 drivers/scsi/elx/efct/efct_driver.c                                 |    1 
 drivers/scsi/elx/libefc/efclib.h                                    |    6 
 drivers/scsi/fcoe/fcoe.c                                            |    1 
 drivers/scsi/fcoe/fcoe_sysfs.c                                      |   19 
 drivers/scsi/hpsa.c                                                 |    9 
 drivers/scsi/ipr.c                                                  |   10 
 drivers/scsi/lpfc/lpfc_sli.c                                        |    6 
 drivers/scsi/mpt3sas/mpt3sas_transport.c                            |    2 
 drivers/scsi/qla2xxx/qla_def.h                                      |   22 
 drivers/scsi/qla2xxx/qla_init.c                                     |   20 
 drivers/scsi/qla2xxx/qla_inline.h                                   |    4 
 drivers/scsi/qla2xxx/qla_os.c                                       |    4 
 drivers/scsi/scsi_debug.c                                           |   11 
 drivers/scsi/scsi_error.c                                           |   14 
 drivers/scsi/snic/snic_disc.c                                       |    3 
 drivers/scsi/ufs/ufshcd.c                                           |    9 
 drivers/soc/mediatek/mtk-pm-domains.c                               |    2 
 drivers/soc/qcom/apr.c                                              |  142 
 drivers/soc/qcom/llcc-qcom.c                                        |    2 
 drivers/soc/ti/knav_qmss_queue.c                                    |    6 
 drivers/soc/ti/smartreflex.c                                        |    1 
 drivers/spi/spi-gpio.c                                              |   16 
 drivers/spi/spidev.c                                                |   21 
 drivers/staging/iio/accel/adis16203.c                               |    1 
 drivers/staging/iio/accel/adis16240.c                               |    1 
 drivers/staging/mt7621-pci/pci-mt7621.c                             |   39 
 drivers/staging/rtl8192e/rtllib_rx.c                                |    2 
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c                   |    4 
 drivers/thermal/imx8mm_thermal.c                                    |    8 
 drivers/thermal/qcom/lmh.c                                          |    2 
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c                         |    3 
 drivers/thermal/thermal_core.c                                      |   18 
 drivers/tty/serial/8250/8250_bcm7271.c                              |   10 
 drivers/tty/serial/altera_uart.c                                    |   21 
 drivers/tty/serial/amba-pl011.c                                     |   14 
 drivers/tty/serial/pch_uart.c                                       |    4 
 drivers/tty/serial/serial-tegra.c                                   |    6 
 drivers/tty/serial/stm32-usart.c                                    |   47 
 drivers/tty/serial/sunsab.c                                         |    8 
 drivers/uio/uio_dmem_genirq.c                                       |   13 
 drivers/usb/cdns3/cdnsp-ring.c                                      |   42 
 drivers/usb/dwc3/core.c                                             |   23 
 drivers/usb/gadget/function/f_hid.c                                 |   53 
 drivers/usb/gadget/udc/fotg210-udc.c                                |   12 
 drivers/usb/host/xhci-mtk.c                                         |    1 
 drivers/usb/host/xhci-ring.c                                        |   14 
 drivers/usb/host/xhci.h                                             |    2 
 drivers/usb/musb/musb_gadget.c                                      |    2 
 drivers/usb/roles/class.c                                           |    5 
 drivers/usb/storage/alauda.c                                        |    2 
 drivers/usb/typec/bus.c                                             |    2 
 drivers/usb/typec/class.c                                           |   43 
 drivers/usb/typec/tcpm/tcpci.c                                      |    5 
 drivers/usb/typec/tcpm/tcpm.c                                       |   24 
 drivers/usb/typec/tipd/core.c                                       |    4 
 drivers/vfio/platform/vfio_platform_common.c                        |    3 
 drivers/video/fbdev/Kconfig                                         |    2 
 drivers/video/fbdev/core/fbcon.c                                    |    3 
 drivers/video/fbdev/ep93xx-fb.c                                     |    4 
 drivers/video/fbdev/geode/Kconfig                                   |    1 
 drivers/video/fbdev/hyperv_fb.c                                     |    8 
 drivers/video/fbdev/pm2fb.c                                         |    9 
 drivers/video/fbdev/uvesafb.c                                       |    1 
 drivers/video/fbdev/vermilion/vermilion.c                           |    4 
 drivers/video/fbdev/via/via-core.c                                  |    9 
 drivers/vme/bridges/vme_fake.c                                      |    2 
 drivers/vme/bridges/vme_tsi148.c                                    |    1 
 drivers/xen/privcmd.c                                               |    2 
 fs/afs/fs_probe.c                                                   |    5 
 fs/binfmt_misc.c                                                    |    8 
 fs/btrfs/file.c                                                     |   10 
 fs/char_dev.c                                                       |    2 
 fs/configfs/dir.c                                                   |    2 
 fs/debugfs/file.c                                                   |   28 
 fs/f2fs/gc.c                                                        |   10 
 fs/f2fs/segment.c                                                   |    6 
 fs/f2fs/super.c                                                     |    2 
 fs/hfs/inode.c                                                      |    2 
 fs/hfs/trans.c                                                      |    2 
 fs/hugetlbfs/inode.c                                                |    6 
 fs/jfs/jfs_dmap.c                                                   |   27 
 fs/jfs/namei.c                                                      |    2 
 fs/ksmbd/mgmt/user_session.c                                        |    8 
 fs/libfs.c                                                          |   22 
 fs/lockd/svcsubs.c                                                  |   17 
 fs/nfs/namespace.c                                                  |    2 
 fs/nfs/nfs4proc.c                                                   |   38 
 fs/nfs/nfs4state.c                                                  |    2 
 fs/nfs/nfs4xdr.c                                                    |   12 
 fs/nfsd/nfs2acl.c                                                   |   32 
 fs/nfsd/nfs4callback.c                                              |    4 
 fs/nfsd/nfs4state.c                                                 |   51 
 fs/nilfs2/the_nilfs.c                                               |   73 
 fs/ntfs3/bitmap.c                                                   |    2 
 fs/ntfs3/super.c                                                    |    2 
 fs/ntfs3/xattr.c                                                    |    2 
 fs/ocfs2/stackglue.c                                                |    8 
 fs/orangefs/orangefs-debugfs.c                                      |   29 
 fs/orangefs/orangefs-mod.c                                          |    8 
 fs/overlayfs/dir.c                                                  |   10 
 fs/overlayfs/file.c                                                 |   43 
 fs/overlayfs/inode.c                                                |   19 
 fs/overlayfs/overlayfs.h                                            |   13 
 fs/overlayfs/ovl_entry.h                                            |    2 
 fs/overlayfs/super.c                                                |   12 
 fs/overlayfs/util.c                                                 |   47 
 fs/pstore/Kconfig                                                   |    1 
 fs/pstore/pmsg.c                                                    |    7 
 fs/pstore/ram.c                                                     |    2 
 fs/pstore/ram_core.c                                                |    6 
 fs/reiserfs/namei.c                                                 |    4 
 fs/reiserfs/xattr_security.c                                        |    2 
 fs/sysv/itree.c                                                     |    2 
 fs/udf/namei.c                                                      |    8 
 fs/xattr.c                                                          |    2 
 include/dt-bindings/clock/imx8mn-clock.h                            |   12 
 include/linux/debugfs.h                                             |   19 
 include/linux/eventfd.h                                             |    2 
 include/linux/fs.h                                                  |   12 
 include/linux/gpio/consumer.h                                       |   35 
 include/linux/hyperv.h                                              |    2 
 include/linux/iio/imu/adis.h                                        |   63 
 include/linux/libata.h                                              |   79 
 include/linux/netdevice.h                                           |   58 
 include/linux/overflow.h                                            |  110 
 include/linux/proc_fs.h                                             |    2 
 include/linux/skmsg.h                                               |    1 
 include/linux/soc/qcom/apr.h                                        |   12 
 include/linux/timerqueue.h                                          |    2 
 include/linux/usb/typec.h                                           |    3 
 include/media/dvbdev.h                                              |   32 
 include/net/dst.h                                                   |    5 
 include/net/mrp.h                                                   |    1 
 include/net/sock_reuseport.h                                        |    2 
 include/net/tcp.h                                                   |    4 
 include/sound/hdaudio.h                                             |    2 
 include/sound/hdaudio_ext.h                                         |    1 
 include/sound/pcm.h                                                 |   36 
 include/trace/events/ib_mad.h                                       |   13 
 include/uapi/drm/drm_fourcc.h                                       |   11 
 include/uapi/linux/idxd.h                                           |    2 
 include/uapi/linux/swab.h                                           |    2 
 include/uapi/sound/asequencer.h                                     |    8 
 kernel/Makefile                                                     |    2 
 kernel/acct.c                                                       |    2 
 kernel/bpf/btf.c                                                    |    5 
 kernel/bpf/verifier.c                                               |  127 
 kernel/cpu.c                                                        |   60 
 kernel/events/core.c                                                |    8 
 kernel/fork.c                                                       |   17 
 kernel/futex.c                                                      | 4272 ---------
 kernel/futex/Makefile                                               |    3 
 kernel/futex/core.c                                                 | 4280 ++++++++++
 kernel/gcov/gcc_4_7.c                                               |    5 
 kernel/irq/internals.h                                              |    2 
 kernel/irq/irqdesc.c                                                |   15 
 kernel/padata.c                                                     |   15 
 kernel/power/snapshot.c                                             |    4 
 kernel/rcu/tree.c                                                   |    2 
 kernel/relay.c                                                      |    4 
 kernel/sched/cpudeadline.c                                          |    2 
 kernel/sched/deadline.c                                             |    4 
 kernel/sched/fair.c                                                 |  190 
 kernel/sched/rt.c                                                   |    4 
 kernel/sched/sched.h                                                |   14 
 kernel/trace/blktrace.c                                             |    3 
 kernel/trace/trace_events_hist.c                                    |    2 
 lib/debugobjects.c                                                  |   10 
 lib/fonts/fonts.c                                                   |    4 
 lib/notifier-error-inject.c                                         |    2 
 lib/test_firmware.c                                                 |    1 
 lib/test_overflow.c                                                 |   98 
 net/802/mrp.c                                                       |   18 
 net/9p/client.c                                                     |    5 
 net/bluetooth/hci_core.c                                            |    2 
 net/bluetooth/mgmt.c                                                |    2 
 net/bluetooth/rfcomm/core.c                                         |    2 
 net/bpf/test_run.c                                                  |    3 
 net/core/dev.c                                                      |   14 
 net/core/filter.c                                                   |   11 
 net/core/skbuff.c                                                   |    3 
 net/core/skmsg.c                                                    |    9 
 net/core/sock.c                                                     |    2 
 net/core/sock_map.c                                                 |    2 
 net/core/sock_reuseport.c                                           |   94 
 net/core/stream.c                                                   |    6 
 net/dsa/tag_8021q.c                                                 |   11 
 net/ethtool/ioctl.c                                                 |    3 
 net/hsr/hsr_device.c                                                |   22 
 net/hsr/hsr_forward.c                                               |    7 
 net/hsr/hsr_framereg.c                                              |   25 
 net/hsr/hsr_framereg.h                                              |    3 
 net/ipv4/inet_connection_sock.c                                     |   12 
 net/ipv4/tcp_bpf.c                                                  |   19 
 net/ipv4/udp_tunnel_core.c                                          |    1 
 net/ipv6/sit.c                                                      |   22 
 net/mac80211/iface.c                                                |    1 
 net/netfilter/nf_conntrack_proto_icmpv6.c                           |   53 
 net/netfilter/nf_flow_table_offload.c                               |    6 
 net/openvswitch/datapath.c                                          |   25 
 net/rxrpc/output.c                                                  |    2 
 net/rxrpc/sendmsg.c                                                 |    2 
 net/sched/ematch.c                                                  |    2 
 net/sctp/sysctl.c                                                   |   73 
 net/sunrpc/clnt.c                                                   |    2 
 net/sunrpc/xprtrdma/verbs.c                                         |    2 
 net/tls/tls_sw.c                                                    |    6 
 net/unix/af_unix.c                                                  |   12 
 net/vmw_vsock/vmci_transport.c                                      |    6 
 net/wireless/reg.c                                                  |    4 
 samples/vfio-mdev/mdpy-fb.c                                         |    8 
 security/Kconfig.hardening                                          |    3 
 security/apparmor/apparmorfs.c                                      |    4 
 security/apparmor/lsm.c                                             |    4 
 security/apparmor/policy.c                                          |    2 
 security/apparmor/policy_ns.c                                       |    2 
 security/apparmor/policy_unpack.c                                   |    2 
 security/integrity/digsig.c                                         |    6 
 security/integrity/ima/ima_policy.c                                 |   51 
 security/integrity/ima/ima_template.c                               |    4 
 security/loadpin/loadpin.c                                          |   30 
 sound/core/pcm_native.c                                             |    4 
 sound/drivers/mts64.c                                               |    3 
 sound/hda/ext/hdac_ext_stream.c                                     |   17 
 sound/hda/hdac_stream.c                                             |   27 
 sound/pci/asihpi/hpioctl.c                                          |    2 
 sound/pci/hda/hda_controller.c                                      |    4 
 sound/pci/hda/patch_hdmi.c                                          |    1 
 sound/pci/hda/patch_realtek.c                                       |   27 
 sound/soc/codecs/pcm512x.c                                          |    8 
 sound/soc/codecs/rt298.c                                            |    7 
 sound/soc/codecs/rt5670.c                                           |    2 
 sound/soc/codecs/wm8994.c                                           |    5 
 sound/soc/generic/audio-graph-card.c                                |    4 
 sound/soc/intel/skylake/skl.c                                       |    7 
 sound/soc/mediatek/common/mtk-btcvsd.c                              |    6 
 sound/soc/mediatek/mt8173/mt8173-afe-pcm.c                          |   71 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c                    |    7 
 sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c          |   14 
 sound/soc/pxa/mmp-pcm.c                                             |    2 
 sound/soc/qcom/lpass-sc7180.c                                       |    3 
 sound/soc/rockchip/rockchip_pdm.c                                   |    1 
 sound/soc/rockchip/rockchip_spdif.c                                 |    1 
 sound/usb/quirks-table.h                                            |    2 
 tools/include/linux/kernel.h                                        |    6 
 tools/lib/bpf/bpf.h                                                 |    7 
 tools/lib/bpf/btf.c                                                 |    8 
 tools/lib/bpf/btf_dump.c                                            |   31 
 tools/lib/bpf/libbpf.c                                              |    3 
 tools/objtool/check.c                                               |   10 
 tools/perf/builtin-stat.c                                           |   46 
 tools/perf/builtin-trace.c                                          |   32 
 tools/perf/util/debug.c                                             |    4 
 tools/perf/util/symbol-elf.c                                        |    2 
 tools/testing/selftests/bpf/config                                  |    4 
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c                     |   48 
 tools/testing/selftests/bpf/progs/test_bpf_nf.c                     |  109 
 tools/testing/selftests/drivers/net/netdevsim/devlink.sh            |    4 
 tools/testing/selftests/efivarfs/efivarfs.sh                        |    5 
 tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc |   15 
 tools/testing/selftests/kvm/memslot_modification_stress_test.c      |    2 
 tools/testing/selftests/netfilter/conntrack_icmp_related.sh         |   36 
 tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c              |    5 
 tools/testing/selftests/proc/proc-uptime-002.c                      |    3 
 718 files changed, 12081 insertions(+), 8110 deletions(-)

Aakarsh Jain (1):
      media: s5p-mfc: Add variant data for MFC v7 hardware for Exynos 3250 SoC

Abdun Nihaal (1):
      fs/ntfs3: Fix slab-out-of-bounds read in ntfs_trim_fs

Abhinav Kumar (1):
      drm/bridge: adv7533: remove dynamic lane switching from adv7533 bridge

Adrián Herrera Arcila (1):
      perf stat: Refactor __run_perf_stat() common code

Ajay Kaher (1):
      perf symbol: correction while adjusting symbol

Akinobu Mita (3):
      libfs: add DEFINE_SIMPLE_ATTRIBUTE_SIGNED for signed value
      lib/notifier-error-inject: fix error when writing -errno to debugfs file
      debugfs: fix error when writing negative value to atomic_t debugfs file

Al Cooper (1):
      phy: usb: s2 WoL wakeup_count not incremented for USB->Eth devices

Al Viro (2):
      alpha: fix TIF_NOTIFY_SIGNAL handling
      alpha: fix syscall entry in !AUDUT_SYSCALL case

Alan Maguire (1):
      libbpf: Btf dedup identical struct test needs check for nested structs/arrays

Alexander Stein (1):
      rtc: pcf85063: Fix reading alarm

Alexander Sverdlin (1):
      spi: spidev: mask SPI_CS_HIGH in SPI_IOC_RD_MODE

Alexandre Belloni (2):
      rtc: cmos: fix build on non-ACPI platforms
      rtc: pcf85063: fix pcf85063_clkout_control

Alexandru Elisei (1):
      arm64: Treat ESR_ELx as a 64-bit register

Alexey Dobriyan (1):
      proc: fixup uptime selftest

Alexey Izbyshev (1):
      futex: Resend potentially swallowed owner death notification

Allen-KH Cheng (1):
      mtd: spi-nor: Fix the number of bytes for the dummy cycles

Amadeusz Sławiński (1):
      ASoC: codecs: rt298: Add quirk for KBL-R RVP platform

Amir Goldstein (3):
      ovl: store lower path in ovl_inode
      ovl: remove privs in ovl_copyfile()
      ovl: remove privs in ovl_fallocate()

Anastasia Belova (1):
      MIPS: BCM63xx: Add check for NULL for clk in clk_enable

Andrew Jeffery (1):
      ipmi: kcs: Poll OBF briefly to reduce OBE latency

Andrii Nakryiko (3):
      bpf: propagate precision in ALU/ALU64 operations
      bpf: propagate precision across all frames, not just the last one
      libbpf: Avoid enum forward-declarations in public API in C++ mode

Andy Shevchenko (2):
      gpiolib: Get rid of redundant 'else'
      fbdev: ssd1307fb: Drop optional dependency

AngeloGioacchino Del Regno (8):
      arm64: dts: mt6779: Fix devicetree build warnings
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

Arnd Bergmann (1):
      RDMA/siw: Fix pointer cast warning

Artem Chernyshev (1):
      net: vmw_vsock: vmci: Check memcpy_from_msg()

Arun Easi (1):
      scsi: qla2xxx: Fix crash when I/O abort times out

Aurabindo Pillai (1):
      drm/amd/display: fix array index out of bound error in bios parser

Baisong Zhong (3):
      ALSA: pcm: fix undefined behavior in bit shift for SNDRV_PCM_RATE_KNOT
      ALSA: seq: fix undefined behavior in bit shift for SNDRV_SEQ_FILTER_USE_EVENT
      media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()

Barnabás Pőcze (2):
      platform/x86: huawei-wmi: fix return value calculation
      timerqueue: Use rb_entry_safe() in timerqueue_getnext()

Bart Van Assche (3):
      scsi: core: Fix a race between scsi_done() and scsi_timeout()
      scsi: qla2xxx: Fix set-but-not-used variable warnings
      scsi: ufs: Reduce the START STOP UNIT timeout

Bartosz Golaszewski (3):
      gpiolib: cdev: fix NULL-pointer dereferences
      gpiolib: make struct comments into real kernel docs
      gpiolib: protect the GPIO device against being dropped while in use by user-space

Bartosz Staszewski (1):
      i40e: Fix the inability to attach XDP program on downed interface

Ben Greear (1):
      wifi: iwlwifi: mvm: fix double free on tx path.

Bernard Metzler (2):
      RDMA/siw: Fix immediate work request flush to completion queue
      RDMA/siw: Set defined status for work completion with undefined status

Bitterblue Smith (3):
      wifi: rtl8xxxu: Fix reading the vendor of combo chips
      wifi: rtl8xxxu: Add __packed to struct rtl8723bu_c2h
      wifi: rtl8xxxu: Fix the channel width reporting

Bjorn Andersson (1):
      thermal/drivers/qcom/lmh: Fix irq handler return value

Bjorn Helgaas (1):
      PCI: mt7621: Rename mt7621_pci_ to mt7621_pcie_

Björn Töpel (1):
      bpf: Do not zero-extend kfunc return values

Brian Starkey (1):
      drm/fourcc: Fix vsub/hsub for Q410 and Q401

Cai Xinchen (1):
      rapidio: devices: fix missing put_device in mport_cdev_open

Cezary Rojewski (1):
      ASoC: Intel: Skylake: Fix driver hang during shutdown

Chao Yu (2):
      f2fs: fix to invalidate dcc->f2fs_issue_discard in error path
      f2fs: fix to destroy sbi->post_read_wq in error path of f2fs_fill_super()

Chen Hui (1):
      cpufreq: qcom-hw: Fix memory leak in qcom_cpufreq_hw_read_lut()

Chen Jiahao (1):
      drivers: soc: ti: knav_qmss_queue: Mark knav_acc_firmwares as static

Chen Zhongjin (11):
      perf: Fix possible memleak in pmu_dev_alloc()
      fs: sysv: Fix sysv_nblocks() returns wrong value
      media: vidtv: Fix use-after-free in vidtv_bridge_dvb_init()
      media: vimc: Fix wrong function called when vimc_init() fails
      media: dvb-core: Fix ignored return value in dvb_register_frontend()
      wifi: cfg80211: Fix not unregister reg_pdev when load_builtin_regdb_keys() fails
      configfs: fix possible memory leak in configfs_create_dir()
      scsi: efct: Fix possible memleak in efct_device_init()
      scsi: fcoe: Fix transport not deattached when fcoe_if_init() fails
      vme: Fix error not catched in fake_init()
      ovl: fix use inode directly in rcu-walk mode

Chen-Yu Tsai (1):
      arm64: dts: mt8183: Fix Mali GPU clock

Chengchang Tang (4):
      RDMA/hns: Fix AH attr queried by query_qp
      RDMA/hns: Fix PBL page MTR find
      RDMA/hns: Fix page size cap from firmware
      RDMA/hns: Fix error code of CMD

Christian Brauner (1):
      ovl: use ovl_copy_{real,upper}attr() wrappers

Christian Marangi (1):
      clk: qcom: clk-krait: fix wrong div2 functions

Christoph Hellwig (3):
      nvmet: only allocate a single slab for bvecs
      block: clear ->slave_dir when dropping the main slave_dir reference
      media: videobuf-dma-contig: use dma_mmap_coherent

Christophe JAILLET (6):
      crypto: amlogic - Remove kcalloc without check
      fbdev: uvesafb: Fixes an error handling path in uvesafb_probe()
      powerpc/52xx: Fix a resource leak in an error handling path
      mfd: qcom_rpm: Fix an error handling path in qcom_rpm_probe()
      myri10ge: Fix an error handling path in myri10ge_probe()
      mfd: qcom_rpm: Use devm_of_platform_populate() to simplify code

Chuck Lever (1):
      NFSD: Finish converting the NFSv2 GETACL result encoder

Chun-Jie Chen (1):
      soc: mediatek: pm-domains: Fix the power glitch issue

Chunfeng Yun (1):
      usb: xhci-mtk: fix leakage of shared hcd when fail to set wakeup irq

Cong Wang (1):
      net_sched: reject TCF_EM_SIMPLE case for complex ematch module

Conor Dooley (1):
      mailbox: mpfs: read the system controller's status

Corentin Labbe (8):
      crypto: sun8i-ss - use dma_addr instead u32
      crypto: rockchip - do not do custom power management
      crypto: rockchip - do not store mode globally
      crypto: rockchip - add fallback for cipher
      crypto: rockchip - add fallback for ahash
      crypto: rockchip - better handle cipher key
      crypto: rockchip - remove non-aligned handling
      crypto: rockchip - rework by using crypto_engine

Cosmin Tanislav (1):
      iio: temperature: ltc2983: make bulk write buffer DMA-safe

Dan Aloni (1):
      nfsd: under NFSv4.1, fix double svc_xprt_put on rpc_create failure

Dan Carpenter (4):
      amdgpu/pm: prevent array underflow in vega20_odn_edit_dpm_table()
      bonding: uninitialized variable in bond_miimon_inspect()
      staging: rtl8192u: Fix use after free in ieee80211_rx()
      fs/ntfs3: Harden against integer overflows

Daniel Golle (1):
      pwm: mediatek: always use bus clock for PWM on MT7622

Daniel Jordan (2):
      padata: Always leave BHs disabled when running ->parallel()
      padata: Fix list iterator in padata_do_serial()

Dario Binacchi (4):
      clk: imx8mn: rename vpu_pll to m7_alt_pll
      clk: imx: replace osc_hdmi with dummy
      clk: imx8mn: fix imx8mn_sai2_sels clocks list
      clk: imx8mn: fix imx8mn_enet_phy_sels clocks list

Dave Stevenson (1):
      drm/fourcc: Add packed 10bit YUV 4:2:0 format

David Howells (4):
      net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
      rxrpc: Fix ack.bufferSize to be 0 when generating an ack
      rxrpc: Fix missing unlock in rxrpc_do_sendmsg()
      afs: Fix lost servers_outstanding count

David Michael (1):
      libbpf: Fix uninitialized warning in btf_dump_dump_type_data

Deren Wu (1):
      wifi: mt76: fix coverity overrun-call in mt76_get_txpower()

Dietmar Eggemann (1):
      sched/core: Introduce sched_asym_cpucap_active()

Dmitry Baryshkov (4):
      arm64: dts: qcom: msm8996: fix supported-hw in cpufreq OPP tables
      arm64: dts: qcom: msm8996: fix GPU OPP table
      drm/msm/hdmi: drop unused GPIO support
      drm/msm/hdmi: use devres helper for runtime PM management

Dmitry Torokhov (1):
      ASoC: dt-bindings: wcd9335: fix reset line polarity in example

Dongdong Zhang (1):
      f2fs: fix normal discard process

Dongliang Mu (1):
      fs: jfs: fix shift-out-of-bounds in dbAllocAG

Doug Brown (2):
      ARM: mmp: fix timer_read delay
      drm/etnaviv: add missing quirks for GC300

Douglas Anderson (2):
      Input: elants_i2c - properly handle the reset GPIO when power is off
      clk: qcom: lpass-sc7180: Fix pm_runtime usage

Dr. David Alan Gilbert (1):
      jfs: Fix fortify moan in symlink

Dragos Tatulea (1):
      IB/IPoIB: Fix queue count inconsistency for PKEY child interfaces

Edward Pacman (1):
      ALSA: hda/realtek: Add quirk for Lenovo TianYi510Pro-14IOB

Eelco Chaudron (1):
      openvswitch: Fix flow lookup to use unmasked key

Emeel Hakim (1):
      net: macsec: fix net device access prior to holding a lock

Enrik Berkhan (1):
      HID: mcp2221: don't connect hidraw

Eric Dumazet (5):
      inet: add READ_ONCE(sk->sk_bound_dev_if) in inet_csk_bind_conflict()
      bpf, sockmap: fix race in sock_map_free()
      net: stream: purge sk_error_queue in sk_stream_kill_queues()
      net: add atomic_long_t to net_device_stats fields
      ipv6/sit: use DEV_STATS_INC() to avoid data-races

Eric Pilmore (1):
      ntb_netdev: Use dev_kfree_skb_any() in interrupt context

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

Filipe Manana (1):
      btrfs: do not BUG_ON() on ENOMEM when dropping extent items for a range

Firo Yang (1):
      sctp: sysctl: make extra pointers netns aware

Florian Westphal (1):
      netfilter: conntrack: set icmpv6 redirects as RELATED

GUO Zihua (4):
      ima: Handle -ESTALE returned by ima_filter_rule_match()
      integrity: Fix memory leakage in keyring allocation error path
      rtc: mxc_v2: Add missing clk_disable_unprepare()
      ima: Simplify ima_lsm_copy_rule

Gabriel Somlo (1):
      serial: altera_uart: fix locking in polling mode

Gaosheng Cui (13):
      lib/fonts: fix undefined behavior in bit shift for get_default_font
      ALSA: mts64: fix possible null-ptr-defer in snd_mts64_interrupt
      net: stmmac: fix possible memory leak in stmmac_dvr_probe()
      apparmor: fix a memleak in multi_transaction_new()
      crypto: ccree - Remove debugfs when platform_driver_register failed
      scsi: snic: Fix possible UAF in snic_tgt_create()
      crypto: img-hash - Fix variable dereferenced before check 'hdev->req'
      staging: vme_user: Fix possible UAF in tsi148_dma_list_add
      fbdev: ep93xx-fb: Add missing clk_disable_unprepare in ep93xxfb_probe()
      remoteproc: sysmon: fix memory leak in qcom_add_sysmon_subdev()
      rtc: st-lpc: Add missing clk_disable_unprepare in st_rtc_probe()
      rtc: pic32: Move devm_rtc_allocate_device earlier in pic32_rtc_probe()
      net: stmmac: fix errno when create_singlethread_workqueue() fails

Gaurav Kohli (1):
      x86/hyperv: Remove unregister syscore call from Hyper-V cleanup

Gautam Menghani (1):
      media: imon: fix a race condition in send_packet()

Gavrilov Ilia (1):
      relay: fix type mismatch when allocating memory in relay_create_buf()

Greg Kroah-Hartman (1):
      Linux 5.15.86

Guchun Chen (1):
      drm/amd/pm/smu11: BACO is supported when it's in BACO state

Guilherme G. Piccoli (1):
      video: hyperv_fb: Avoid taking busy spinlock on panic path

Gustavo A. R. Silva (1):
      powerpc/xmon: Fix -Wswitch-unreachable warning in bpt_cmds

Hamza Mahfooz (1):
      Revert "drm/amd/display: Limit max DSC target bpp for specific monitors"

Hangbin Liu (1):
      net/tunnel: wait until all sk_user_data reader finish before releasing the sock

Hanjun Guo (1):
      drm/radeon: Add the missed acpi_put_table() to fix memory leak

Hannes Reinecke (1):
      ata: libata: move ata_{port,link,dev}_dbg to standard pr_XXX() macros

Hans de Goede (1):
      ASoC: rt5670: Remove unbalanced pm_runtime_put()

Haowen Bai (2):
      SUNRPC: Return true/false (not 1/0) from bool functions
      powerpc/eeh: Drop redundant spinlock initialization

Harshit Mogalapalli (4):
      xen/privcmd: Fix a possible warning in privcmd_ioctl_mmap_resource()
      scsi: scsi_debug: Fix a warning in resp_write_scat()
      scsi: scsi_debug: Fix a warning in resp_verify()
      scsi: scsi_debug: Fix a warning in resp_report_zones()

Hawkins Jiawei (1):
      hugetlbfs: fix null-ptr-deref in hugetlbfs_parse_param()

Herbert Xu (1):
      crypto: cryptd - Use request context instead of stack for sub-request

Hoi Pok Wu (1):
      fs: jfs: fix shift-out-of-bounds in dbDiscardAG

Hui Tang (2):
      mtd: lpddr2_nvm: Fix possible null-ptr-deref
      i2c: pxa-pci: fix missing pci_disable_device() on error in ce4100_i2c_probe

Inga Stotland (1):
      Bluetooth: MGMT: Fix error report for ADD_EXT_ADV_PARAMS

Isaac J. Manjarres (1):
      loop: Fix the max_loop commandline argument treatment when it is set to 0

Ivaylo Dimitrov (1):
      usb: musb: remove extra check in musb_gadget_vbus_draw

Jakub Kicinski (1):
      selftests: devlink: fix the fd redirect in dummy_reporter_test

James Hurley (1):
      platform/mellanox: mlxbf-pmc: Fix event typo

Jason Gerecke (1):
      HID: wacom: Ensure bootloader PID is usable in hidraw mode

Jason Gunthorpe (1):
      iommu/sun50i: Remove IOMMU_DOMAIN_IDENTITY

Jayesh Choudhary (2):
      arm64: dts: ti: k3-am65-main: Drop dma-coherent in crypto node
      arm64: dts: ti: k3-j721e-main: Drop dma-coherent in crypto node

Jeff Layton (1):
      nfsd: don't call nfsd_file_put from client states seqfile display

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

Jiasheng Jiang (8):
      soc: qcom: apr: Add check for idr_alloc and of_property_read_string_index
      media: coda: jpeg: Add check for kmalloc
      ASoC: mediatek: mtk-btcvsd: Add checks for write and read of mtk_btcvsd_snd
      memstick/ms_block: Add check for alloc_ordered_workqueue
      media: coda: Add check for dcoda_iram_alloc
      media: coda: Add check for kmalloc
      usb: storage: Add check for kcalloc
      HID: amd_sfh: Add missing check for dma_alloc_coherent

Jimmy Assarsson (6):
      can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device
      can: kvaser_usb: kvaser_usb_leaf: Rename {leaf,usbcan}_cmd_error_event to {leaf,usbcan}_cmd_can_error_event
      can: kvaser_usb: kvaser_usb_leaf: Handle CMD_ERROR_EVENT
      can: kvaser_usb: make use of units.h in assignment of frequency
      can: kvaser_usb: Add struct kvaser_usb_busparams
      can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming

Jiri Slaby (2):
      tty: serial: clean up stop-tx part in altera_uart_tx_chars()
      tty: serial: altera_uart_{r,t}x_chars() need only uart_port

Jiri Slaby (SUSE) (1):
      qed (gcc13): use u16 for fid to be big enough

Joel Granados (1):
      nvme: return err on nvme_init_non_mdts_limits fail

Johan Hovold (6):
      arm64: dts: qcom: sm8150: fix UFS PHY registers
      arm64: dts: qcom: sm8250: fix UFS PHY registers
      arm64: dts: qcom: sm8350: fix UFS PHY registers
      arm64: dts: qcom: sm8250: drop bogus DP PHY clock
      arm64: dts: qcom: sm8250: fix USB-DP PHY registers
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

John Thomson (4):
      mips: ralink: mt7621: define MT7621_SYSC_BASE with __iomem
      mips: ralink: mt7621: soc queries and tests as functions
      mips: ralink: mt7621: do not use kzalloc too early
      PCI: mt7621: Add sentinel to quirks table

Jon Hunter (1):
      pwm: tegra: Improve required rate calculation

Jonathan Cameron (1):
      iio:imu:adis: Move exports into IIO_ADISLIB namespace

Jonathan Neuschäfer (2):
      ARM: dts: nuvoton: Remove bogus unit addresses from fixed-partition nodes
      spi: Update reference to struct spi_controller

Jonathan Toppins (1):
      bonding: fix link recovery in mode 2 when updelay is nonzero

Justin Tee (1):
      scsi: lpfc: Fix hard lockup when reading the rx_monitor from debugfs

Kajol Jain (1):
      powerpc/hv-gpci: Fix hv_gpci event list

Karolina Drobnik (1):
      tools/include: Add _RET_IP_ and math definitions to kernel.h

Kartik (1):
      serial: tegra: Read DMA status before terminating

Kees Cook (3):
      overflow: Implement size_t saturating arithmetic helpers
      igb: Do not free q_vector unless new one was allocated
      LoadPin: Ignore the "contents" argument of the LSM hooks

Khaled Almahallawy (1):
      drm/i915/display: Don't disable DDI/Transcoder when setting phy test pattern

Khazhismel Kumykov (1):
      bfq: fix waker_bfqq inconsistency crash

Kirill Tkhai (1):
      unix: Fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()

Konrad Dybcio (1):
      regulator: qcom-rpmh: Fix PMR735a S3 regulator spec

Konstantin Meskhidze (1):
      drm/amdkfd: Fix memory leakage

Kory Maincent (1):
      arm: dts: spear600: Fix clcd interrupt

Kris Bahnsen (1):
      spi: spi-gpio: Don't set MOSI as an input if not 3WIRE mode

Krzysztof Kozlowski (6):
      arm64: dts: qcom: ipq6018-cp01-c1: use BLSPI1 pins
      arm64: dts: qcom: sm8250-sony-xperia-edo: fix touchscreen bias-disable
      arm64: dts: qcom: sdm630: fix UART1 pin bias
      arm64: dts: qcom: sdm845-cheza: fix AP suspend pin bias
      arm64: dts: qcom: sm8250: correct LPASS pin pull down
      arm64: dts: qcom: sm6125: fix SDHCI CQE reg names

Kumar Kartikeya Dwivedi (2):
      bpf: Fix slot type check in check_stack_write_var_off
      selftests/bpf: Add test for unstable CT lookup API

Kunihiko Hayashi (2):
      PCI: pci-epf-test: Register notifier if only core_init_notifier is enabled
      mmc: f-sdh30: Add quirks for broken timeout clock capability

Kuniyuki Iwashima (2):
      seccomp: Move copy_seccomp() to no failure path.
      soreuseport: Fix socket selection for SO_INCOMING_CPU.

Kurt Kanzenbach (1):
      igc: Lift TAPRIO schedule restriction

Ladislav Michl (1):
      MIPS: OCTEON: warn only once if deprecated link status is being used

Laurent Pinchart (1):
      media: v4l2-ctrls: Fix off-by-one error in integer menu control check

Lee Jones (1):
      mfd: pm8008: Remove driver data structure pm8008_data

Leo Yan (3):
      perf trace: Return error if a system call doesn't exist
      perf trace: Use macro RAW_SYSCALL_ARGS_NUM to replace number
      perf trace: Handle failure when trace point folder is missed

Leon Romanovsky (1):
      RDMA/core: Fix order of nldev_exit call

Leonid Ravich (1):
      IB/mad: Don't call to function that might sleep while in atomic context

Li Zetao (3):
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

Linus Walleij (1):
      usb: fotg210-udc: Fix ages old endianness issues

Liu Shixin (4):
      media: vivid: fix compose size exceed boundary
      ALSA: asihpi: fix missing pci_disable_device()
      media: saa7164: fix missing pci_disable_device()
      binfmt_misc: fix shift-out-of-bounds in check_special_flags

Lorenzo Bianconi (2):
      wifi: mt76: mt7921: fix reporting of TX AGGR histogram
      wifi: mt76: do not run mt76u_status_worker if the device is not running

Luca Weiss (5):
      ARM: dts: qcom: apq8064: fix coresight compatible
      soc: qcom: llcc: make irq truly optional
      thermal/drivers/qcom/temp-alarm: Fix inaccurate warning for gen2
      remoteproc: qcom_q6v5_pas: disable wakeup on probe fail or remove
      remoteproc: qcom_q6v5_pas: detach power domains on remove

Luis Chamberlain (1):
      memstick: ms_block: Add error handling support for add_disk()

Luoyouming (2):
      RDMA/hns: Repacing 'dseg_len' by macros in fill_ext_sge_inl_data()
      RDMA/hns: Fix ext_sge num error when post send

Manivannan Sadhasivam (1):
      clk: qcom: gcc-sm8250: Use retention mode for USB GDSCs

Marco Elver (1):
      objtool, kcsan: Add volatile read/write instrumentation to whitelist

Marcus Folkesson (2):
      HID: hid-sensor-custom: set fixed size for custom attributes
      thermal/drivers/imx8mm_thermal: Validate temperature range

Marek Szyprowski (2):
      media: exynos4-is: don't rely on the v4l2_async_subdev internals
      ASoC: wm8994: Fix potential deadlock

Marek Vasut (8):
      ARM: dts: stm32: Drop stm32mp15xc.dtsi from Avenger96
      ARM: dts: stm32: Fix AV96 WLAN regulator gpio property
      clk: renesas: r9a06g032: Repair grave increment error
      drm/panel/panel-sitronix-st7701: Remove panel on DSI attach failure
      wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port
      extcon: usbc-tusb320: Factor out extcon into dedicated functions
      extcon: usbc-tusb320: Add USB TYPE-C support
      extcon: usbc-tusb320: Update state on probe even if no IRQ pending

Marijn Suijten (1):
      arm64: dts: qcom: pm660: Use unique ADC5_VCOIN address in node name

Mark Rutland (2):
      arm64: mm: kfence: only handle translation faults
      arm64: make is_ttbrX_addr() noinstr-safe

Mark Zhang (4):
      RDMA/restrack: Release MR restrack when delete
      RDMA/core: Make sure "ib_port" is valid when access sysfs node
      RDMA/nldev: Return "-EAGAIN" if the cm_id isn't from expected port
      RDMA/nldev: Fix failure to send large messages

Markus Schneider-Pargmann (2):
      can: tcan4x5x: Remove invalid write in clear_interrupts
      can: tcan4x5x: Fix use of register error status mask

Martin Blumenstingl (2):
      hwmon: (jc42) Convert register access and caching to regmap/regcache
      hwmon: (jc42) Restore the min/max/critical temperatures on resume

Martin KaFai Lau (1):
      bpf: Check the other end of slot_type for STACK_SPILL

Martin Leung (1):
      drm/amd/display: Manually adjust strobe for DCN303

Mathias Nyman (1):
      xhci: Prevent infinite loop in transaction errors recovery for streams

Matt Redfearn (1):
      include/uapi/linux/swab: Fix potentially missing __always_inline

Matti Vaittinen (1):
      mfd: bd957x: Fix Kconfig dependency on REGMAP_IRQ

Maxim Korotkov (1):
      ethtool: avoiding integer overflow in ethtool_phys_id()

Mazin Al Haddad (1):
      media: dvb-usb: fix memory leak in dvb_usb_adapter_init()

Miaoqian Lin (2):
      cxl: Fix refcount leak in cxl_calc_capp_routing
      selftests/powerpc: Fix resource leaks

Michael Kelley (1):
      tpm/tpm_crb: Fix error message in __crb_relinquish_locality()

Michael Riesch (1):
      iommu/rockchip: fix permission bits in page table entries v2

Michael Walle (1):
      mtd: spi-nor: hide jedec_id sysfs attribute if not present

Ming Qian (1):
      media: imx-jpeg: Disable useless interrupt to avoid kernel panic

Minghao Chi (1):
      soc: ti: knav_qmss_queue: Use pm_runtime_resume_and_get instead of pm_runtime_get_sync

Minsuk Kang (2):
      nfc: pn533: Clear nfc_target before being used
      wifi: brcmfmac: Fix potential shift-out-of-bounds in brcmf_fw_alloc_request()

Muhammad Husaini Zulkifli (1):
      igc: Add checking for basetime less than zero

Namhyung Kim (1):
      perf stat: Do not delay the workload with --delay

Natalia Petrova (1):
      crypto: nitrox - avoid double free on error path in nitrox_sriov_init()

Nathan Chancellor (12):
      net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
      hamradio: baycom_epp: Fix return type of baycom_send_packet()
      drm/amdgpu: Fix type of second parameter in trans_msg() callback
      drm/amdgpu: Fix type of second parameter in odn_edit_dpm_table() callback
      s390/ctcm: Fix return type of ctc{mp,}m_tx()
      s390/netiucv: Fix return type of netiucv_tx()
      s390/lcs: Fix return type of lcs_start_xmit()
      drm/mediatek: Fix return type of mtk_hdmi_bridge_mode_valid()
      scsi: elx: libefc: Fix second parameter type in state callbacks
      drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()
      drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()
      security: Restrict CONFIG_ZERO_CALL_USED_REGS to gcc or clang > 15.0.6

Nathan Lynch (1):
      powerpc/pseries/eeh: use correct API for error log size

Nicholas Piggin (1):
      powerpc/perf: callchain validate kernel stack pointer bounds

Niklas Cassel (1):
      ata: libata: fix NCQ autosense logic

Niklas Söderlund (1):
      media: adv748x: afe: Select input port when initializing AFE

Nirmal Patel (1):
      PCI: vmd: Disable MSI remapping after suspend

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

Palmer Dabbelt (1):
      RISC-V: Align the shadow stack

Pawel Laszczak (1):
      usb: cdnsp: fix lack of ZLP for ep0

Pengcheng Yang (3):
      bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data
      bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes
      bpf, sockmap: Fix data loss caused by using apply_bytes on ingress redirect

Peter Zijlstra (1):
      futex: Move to kernel/futex/

Phil Auld (1):
      cpu/hotplug: Make target_store() a nop when target == state

Piergiorgio Beruto (1):
      stmmac: fix potential division by 0

Pierre-Louis Bossart (2):
      ALSA/ASoC: hda: move/rename snd_hdac_ext_stop_streams to hdac_stream.c
      ALSA: hda: add snd_hdac_stop_streams() helper

Prashant Malani (1):
      platform/chrome: cros_ec_typec: Cleanup switch handle return paths

Pu Lehui (1):
      riscv, bpf: Emit fixed-length instructions for BPF_PSEUDO_FUNC

Qais Yousef (4):
      sched/uclamp: Fix relationship between uclamp and migration margin
      sched/uclamp: Make task_fits_capacity() use util_fits_cpu()
      sched/uclamp: Make select_idle_capacity() use util_fits_cpu()
      sched/uclamp: Make asym_fits_capacity() use util_fits_cpu()

Qingfang DENG (1):
      netfilter: flowtable: really fix NAT IPv6 offload

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

Rafael Mendonca (4):
      drm/amdgpu/powerplay/psm: Fix memory leak in power state init
      vfio: platform: Do not pass return buffer to ACPI _RST method
      uio: uio_dmem_genirq: Fix missing unlock in irq configuration
      uio: uio_dmem_genirq: Fix deadlock between irq config and handling

Ramona Bolboaca (1):
      iio: adis: add '__adis_enable_irq()' implementation

Randy Dunlap (4):
      Input: joystick - fix Kconfig warning for JOYSTICK_ADC
      Input: wistron_btns - disable on UML
      fbdev: geode: don't build on UML
      fbdev: uvesafb: don't build on UML

Rasmus Villemoes (1):
      iio: adc128s052: add proper .data members in adc128_of_match table

Reinette Chatre (1):
      x86/sgx: Reduce delay and interference of enclave release

Ricardo Ribalda (2):
      media: i2c: ad5820: Fix error path
      ASoC: mediatek: mt8173: Enable IRQ when pdata is ready

Rickard x Andersson (1):
      gcov: add support for checksum field

Rob Clark (1):
      drm/msm/a6xx: Fix speed-bin detection vs probe-defer

Roberto Sassu (1):
      reiserfs: Add missing calls to reiserfs_security_free()

Rui Zhang (1):
      regulator: core: fix use_count leakage when handling boot-on

Ryusuke Konishi (2):
      nilfs2: fix shift-out-of-bounds/overflow in nilfs_sb2_bad_offset()
      nilfs2: fix shift-out-of-bounds due to too large exponent of block size

Samuel Holland (1):
      usb: typec: Factor out non-PD fwnode properties

Schspa Shi (2):
      mrp: introduce active flags to prevent UAF when applicant uninit
      9p: set req refcount to zero to avoid uninitialized usage

Sebastian Andrzej Siewior (5):
      hsr: Add a rcu-read lock to hsr_forward_skb().
      hsr: Avoid double remove of a node.
      hsr: Disable netpoll.
      hsr: Synchronize sending frames to have always incremented outgoing seq nr.
      hsr: Synchronize sequence number updates.

Serge Semin (2):
      dt-bindings: imx6q-pcie: Fix clock names for imx6sx and imx8mq
      dt-bindings: visconti-pcie: Fix interrupts array max constraints

Sergey Shtylyov (1):
      ata: add/use ata_taskfile::{error|status} fields

Shang XiaoJing (10):
      perf/arm_dmc620: Fix hotplug callback leak in dmc620_pmu_init()
      perf/smmuv3: Fix hotplug callback leak in arm_smmu_pmu_init()
      ocfs2: fix memory leak in ocfs2_stack_glue_init()
      irqchip: gic-pm: Use pm_runtime_resume_and_get() in gic_probe()
      scsi: ipr: Fix WARNING in ipr_init()
      crypto: omap-sham - Use pm_runtime_resume_and_get() in omap_sham_probe()
      samples: vfio-mdev: Fix missing pci_disable_device() in mdpy_fb_probe()
      fbdev: via: Fix error in via_core_init()
      remoteproc: qcom: q6v5: Fix potential null-ptr-deref in q6v5_wcss_init_mmio()
      remoteproc: qcom: q6v5: Fix missing clk_disable_unprepare() in q6v5_wcss_qcs404_power_on()

Shawn Guo (1):
      arm64: dts: qcom: Correct QMP PHY child node name

Shigeru Yoshida (4):
      fs/ntfs3: Avoid UBSAN error on true_sectors_per_clst()
      udf: Avoid double brelse() in udf_rename()
      wifi: ar5523: Fix use-after-free on ar5523_cmd() timed out
      media: si470x: Fix use-after-free in si470x_int_in_callback()

Shiraz Saleem (1):
      RDMA/irdma: Report the correct link speed

Shung-Hsi Yu (1):
      libbpf: Fix null-pointer dereference in find_prog_by_sec_insn()

Srinivas Kandagatla (1):
      soc: qcom: apr: make code more reuseable

Stanislav Fomichev (4):
      bpf: Move skb->len == 0 checks into __bpf_redirect
      bpf: make sure skb->len != 0 when redirecting to a tunneling device
      ppp: associate skb with a device at tx
      bpf: Prevent decl_tag from being referenced in func_proto arg

Stefan Eichenberger (1):
      rtc: snvs: Allow a time difference on clock register read

Stephan Gerhold (1):
      arm64: dts: qcom: msm8916: Drop MSS fallback compatible

Stephen Boyd (1):
      pstore: Avoid kcore oops by vmap()ing with VM_IOREMAP

Steven Price (1):
      pwm: tegra: Fix 32 bit build

Subash Abhinov Kasiviswanathan (1):
      skbuff: Account for tail adjustment during pull operations

Sven Peter (4):
      usb: typec: Check for ops->exit instead of ops->enter in altmode_exit
      usb: typec: tipd: Cleanup resources if devm_tps6598_psy_register fails
      usb: typec: tipd: Fix spurious fwnode_handle_put in error path
      usb: dwc3: Fix race between dwc3_set_mode and __dwc3_set_mode

Takashi Iwai (1):
      ALSA: pcm: Set missing stop_operating flag at undoing trigger start

Tan Tee Min (3):
      igc: allow BaseTime 0 enrollment for Qbv
      igc: recalculate Qbv end_time by considering cycle time
      igc: Set Qbv start_time and end_time to end_time if not being configured in GCL

Tang Bin (1):
      venus: pm_helpers: Fix error check in vcodec_domains_get()

Tetsuo Handa (1):
      fbdev: fbcon: release buffer when fbcon_do_set_font() failed

Tom Lendacky (2):
      net: amd-xgbe: Fix logic around active and passive cables
      net: amd-xgbe: Check only the minimum speed for active/passive cables

Tong Tiangen (1):
      riscv/mm: add arch hook arch_clear_hugepage_flags

Trond Myklebust (8):
      lockd: set other missing fields when unlocking files
      NFSv4.2: Clear FATTR4_WORD2_SECURITY_LABEL when done decoding
      NFSv4.2: Fix a memory stomp in decode_attr_security_label
      NFSv4.2: Fix initialisation of struct nfs4_label
      NFSv4: Fix a credential leak in _nfs4_discover_trunking()
      NFSv4: Fix a deadlock between nfs4_open_recover_helper() and delegreturn
      NFS: Fix an Oops in nfs_d_automount()
      NFSv4.x: Fail client initialisation if state manager thread can't run

Tyler Hicks (1):
      KVM: selftests: Fix build regression by using accessor function

Ulf Hansson (1):
      cpuidle: dt: Return the correct numbers of parsed idle states

Uwe Kleine-König (2):
      crypto: ccree - Make cc_debugfs_global_fini() available for module init function
      pwm: sifive: Call pwm_sifive_update_clock() while mutex is held

Valentin Caron (1):
      serial: stm32: move dma_request_chan() before clk_prepare_enable()

Victor Ding (1):
      platform/chrome: cros_ec_typec: zero out stale pointers

Vidya Sagar (1):
      PCI: dwc: Fix n_fts[] array overrun

Ville Syrjälä (3):
      drm/msm: Use drm_mode_copy()
      drm/rockchip: Use drm_mode_copy()
      drm/sti: Use drm_mode_copy()

Vincent Donnefort (2):
      sched/fair: Cleanup task_util and capacity type
      cpu/hotplug: Do not bail-out in DYING/STARTING sections

Vincent Guittot (1):
      sched/fair: Removed useless update of p->recent_used_cpu

Vincent Mailhol (1):
      can: kvaser_usb: do not increase tx statistics when sending error message frames

Vinicius Costa Gomes (2):
      igc: Enhance Qbv scheduling by using first flag bit
      igc: Use strict cycles for Qbv scheduling

Vivek Yadav (1):
      can: m_can: Call the RAM init directly from m_can_chip_config

Vladimir Oltean (2):
      net: dsa: tag_8021q: avoid leaking ctx on dsa_tag_8021q_register() error path
      net: enetc: avoid buffer leaks on xdp_do_redirect() failure

Vladimir Zapolskiy (1):
      media: camss: Clean up received buffers on failed start of streaming

Wang Jingjin (2):
      ASoC: rockchip: pdm: Add missing clk_disable_unprepare() in rockchip_pdm_runtime_resume()
      ASoC: rockchip: spdif: Add missing clk_disable_unprepare() in rk_spdif_runtime_resume()

Wang ShaoBo (5):
      regulator: core: use kfree_const() to free space conditionally
      drbd: remove call to memset before free device/resource/connection
      drbd: destroy workqueue when drbd device was freed
      SUNRPC: Fix missing release socket in rpc_sockname()
      Bluetooth: btintel: Fix missing free skb in btintel_setup_combined()

Wang Weiyang (1):
      rapidio: fix possible UAF when kfifo_alloc() fails

Wang Yufen (7):
      pstore/ram: Fix error return code in ramoops_probe()
      wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()
      RDMA/hfi1: Fix error return code in parse_platform_config()
      RDMA/srp: Fix error return code in srp_parse_options()
      ASoC: mediatek: mt8173-rt5650-rt5514: fix refcount leak in mt8173_rt5650_rt5514_dev_probe()
      ASoC: audio-graph-card: fix refcount leak of cpu_ep in __graph_for_each_link()
      ASoC: mediatek: mt8183: fix refcount leak in mt8183_mt6358_ts3a227_max98357_dev_probe()

Wei Yongjun (1):
      irqchip/wpcm450: Fix memory leak in wpcm450_aic_of_init()

Weili Qian (1):
      crypto: hisilicon/qm - fix missing destroy qp_idr

Wesley Chalmers (1):
      drm/amd/display: Use the largest vready_offset in pipe group

Wolfram Sang (3):
      clocksource/drivers/sh_cmt: Access registers according to spec
      mmc: renesas_sdhi: alway populate SCC pointer
      mmc: renesas_sdhi: better reset from HS400 mode

Wright Feng (1):
      brcmfmac: return error when getting invalid max_flowrings from dongle

Xie Shaowen (1):
      macintosh/macio-adb: check the return value of ioremap()

Xing Song (1):
      mt76: stop the radar detector after leaving dfs channel

Xinlei Lee (1):
      drm/mediatek: Modify dpi power on/off sequence.

Xiongfeng Wang (13):
      perf/x86/intel/uncore: Fix reference count leak in sad_cfg_iio_topology()
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

Xiu Jianfeng (11):
      x86/xen: Fix memory leak in xen_smp_intr_init{_pv}()
      x86/xen: Fix memory leak in xen_init_lock_cpu()
      ima: Fix misuse of dereference of pointer in template_desc_init_fields()
      wifi: ath10k: Fix return value in ath10k_pci_init()
      clk: rockchip: Fix memory leak in rockchip_clk_register_pll()
      clk: samsung: Fix memory leak in _samsung_clk_register_pll()
      clk: socfpga: Fix memory leak in socfpga_gate_init()
      apparmor: Use pointer to struct aa_label for lbs_cred
      apparmor: Fix memleak in alloc_ns()
      ksmbd: Fix resource leak in ksmbd_session_rpc_open()
      clk: st: Fix memory leak in st_of_quadfs_setup()

Xu Kuohai (1):
      libbpf: Fix use-after-free in btf_dump_name_dups

Yan Lei (1):
      media: dvb-frontends: fix leak of memory fw

Yang Jihong (2):
      blktrace: Fix output non-blktrace event when blk_classic option enabled
      perf debug: Set debug_peo_args and redirect_to_stderr variable to correct values in perf_quiet_option()

Yang Shen (1):
      coresight: trbe: remove cpuhp instance node before remove cpuhp state

Yang Yingliang (77):
      MIPS: vpe-mt: fix possible memory leak while module exiting
      MIPS: vpe-cmp: fix possible memory leak while module exiting
      PNP: fix name memory leak in pnp_alloc_dev()
      thermal: core: fix some possible name leaks in error paths
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
      mmc: rtsx_pci: fix return value check of mmc_add_host()
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
      af_unix: call proto_unregister() in the error path in af_unix_init()
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
      mfd: pm8008: Fix return value check in pm8008_probe()
      mISDN: hfcsusb: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
      mISDN: hfcpci: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
      mISDN: hfcmulti: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
      mailbox: arm_mhuv2: Fix return value check in mhuv2_probe()
      mailbox: zynq-ipi: fix error handling while device_register() fails
      hwmon: (jc42) Fix missing unlock on error in jc42_write()

Yassine Oudjana (4):
      arm64: dts: qcom: msm8996: Add MSM8996 Pro support
      extcon: usbc-tusb320: Add support for mode setting and reset
      extcon: usbc-tusb320: Add support for TUSB320L
      extcon: usbc-tusb320: Call the Type-C IRQ handler only if a port is registered

Ye Bin (1):
      blk-mq: fix possible memleak when register 'hctx' failed

Yipeng Zou (1):
      selftests/ftrace: event_triggers: wait longer for test_event_enable

Yonggil Song (1):
      f2fs: avoid victim selection from previous victim section

Yongqiang Liu (1):
      net: defxx: Fix missing err handling in dfx_init()

Yu Kuai (1):
      block, bfq: fix possible uaf for 'bfqq->bic'

Yu Liao (1):
      platform/x86: mxm-wmi: fix memleak in mxm_wmi_call_mx[ds|mx]()

Yuan Can (16):
      perf: arm_dsu: Fix hotplug callback leak in dsu_pmu_init()
      tpm/tpm_ftpm_tee: Fix error handling in ftpm_mod_init()
      platform/chrome: cros_usbpd_notify: Fix error handling in cros_usbpd_notify_init()
      media: platform: exynos4-is: Fix error handling in fimc_md_init()
      ASoC: qcom: Add checks for devm_kcalloc
      regulator: qcom-labibb: Fix missing of_node_put() in qcom_labibb_regulator_probe()
      drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()
      scsi: hpsa: Fix possible memory leak in hpsa_init_one()
      RDMA/nldev: Add checks for nla_nest_start() in fill_stat_counter_qps()
      serial: 8250_bcm7271: Fix error handling in brcmuart_init()
      serial: sunsab: Fix error handling in sunsab_init()
      HSI: omap_ssi_core: Fix error handling in ssi_init()
      power: supply: ab8500: Fix error handling in ab8500_charger_init()
      iommu/fsl_pamu: Fix resource leak in fsl_pamu_probe()
      remoteproc: qcom_q6v5_pas: Fix missing of_node_put() in adsp_alloc_memory_region()
      floppy: Fix memory leak in do_floppy_init()

YueHaibing (1):
      staging: rtl8192e: Fix potential use-after-free in rtllib_rx_Monitor()

Zeng Heng (4):
      ASoC: pxa: fix null-pointer dereference in filter()
      PCI: Check for alloc failure in pci_request_irq()
      power: supply: fix residue sysfs file in error handle route of __power_supply_register()
      iio: fix memory leak in iio_device_register_eventset()

Zhang Changzhong (1):
      net: stmmac: selftests: fix potential memleak in stmmac_test_arpoffload()

Zhang Qilong (7):
      soc: ti: knav_qmss_queue: Fix PM disable depth imbalance in knav_queue_probe
      soc: ti: smartreflex: Fix PM disable depth imbalance in omap_sr_probe
      eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD
      drm/rockchip: lvds: fix PM usage counter unbalance in poweron
      ASoC: pcm512x: Fix PM disable depth imbalance in pcm512x_probe
      f2fs: Fix the race condition of resize flag between resizefs
      power: supply: z2_battery: Fix possible memleak in z2_batt_probe()

Zhang Xiaoxu (6):
      mtd: Fix device name leak when register device failed in add_mtd_device()
      xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()
      RDMA/rxe: Fix NULL-ptr-deref in rxe_qp_do_cleanup() when socket create failed
      orangefs: Fix sysfs not cleanup when dev init failed
      orangefs: Fix kmemleak in orangefs_prepare_debugfs_help_string()
      orangefs: Fix kmemleak in orangefs_{kernel,client}_debug_init()

Zhang Yiqun (1):
      crypto: tcrypt - Fix multibuffer skcipher speed test mem leak

Zhang Yuchen (1):
      ipmi: fix memleak when unload ipmi driver

Zhang Zekun (1):
      drm/tegra: Add missing clk_disable_unprepare() in tegra_dc_probe()

ZhangPeng (4):
      hfs: Fix OOB Write in hfs_asc2mac
      pinctrl: k210: call of_node_put()
      pinctrl: pinconf-generic: add missing of_node_put()
      hfs: fix OOB Read in __hfs_brec_find

Zhao Gongyi (1):
      selftests/efivarfs: Add checking of the test return value

Zhen Lei (1):
      mmc: core: Normalize the error handling branch in sd_read_ext_regs()

Zheng Wang (1):
      misc: sgi-gru: fix use-after-free error in gru_set_context_option, gru_fault and gru_handle_user_call_os

Zheng Yejian (2):
      tracing/hist: Fix issue of losting command info in error_log
      acct: fix potential integer overflow in encode_comp_t()

Zheng Yongjun (1):
      mtd: maps: pxa2xx-flash: fix memory leak in probe

Zhengchao Shao (4):
      wifi: mac80211: fix memory leak in ieee80211_if_add()
      RDMA/hns: fix memory leak in hns_roce_alloc_mr()
      test_firmware: fix memory leak in test_firmware_init()
      drivers: mcb: fix resource leak in mcb_probe()

Zheyu Ma (1):
      i2c: ismt: Fix an out-of-bounds bug in ismt_access()

Zhiqi Song (1):
      crypto: hisilicon/hpre - fix resource leak in remove process

Zqiang (1):
      rcu: Fix __this_cpu_read() lockdep warning in rcu_force_quiescent_state()

delisun (1):
      serial: pl011: Do not clear RX FIFO & RX interrupt in unthrottle.

gehao (1):
      drm/amd/display: prevent memory leak

ruanjinjie (3):
      of: overlay: fix null pointer dereferencing in find_dup_cset_node_entry() and find_dup_cset_prop()
      misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()
      power: supply: fix null pointer dereferencing in power_supply_get_battery_info

wangdicheng (1):
      ALSA: usb-audio: add the quirk for KT0206 device

wuchi (1):
      lib/debugobjects: fix stat count and optimize debug_objects_mem_init

xinlei lee (1):
      pwm: mtk-disp: Fix the parameters calculated by the enabled flag of disp_pwm

xiongxin (1):
      PM: hibernate: Fix mistake in kerneldoc comment

