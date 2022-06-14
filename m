Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16B354B6B6
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 18:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbiFNQtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 12:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351313AbiFNQtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 12:49:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F794477B;
        Tue, 14 Jun 2022 09:49:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0284B81A00;
        Tue, 14 Jun 2022 16:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CB7C3411B;
        Tue, 14 Jun 2022 16:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655225357;
        bh=N2yQ6xzGg0jsKpCs2La07t7OQxx05rPoe46DI1L4eLI=;
        h=From:To:Cc:Subject:Date:From;
        b=c5g0WzbnSNhWdH6RiW4oIu+nOKVGjOFHf1bJa6Tu/LjPbvfa/WqZKjR1SoiK9i0xs
         APJghgN4uiXNX+TludFpsf5T18kHasQmkETgzGgJzwVNxcJEk6tQlwTGfe+95KC8Mi
         trvBA635HeJpq/KvzcooHWixid0Awhjvwkef3BUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.198
Date:   Tue, 14 Jun 2022 18:49:13 +0200
Message-Id: <1655225353204227@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.198 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-ata                           |   11 
 Documentation/conf.py                                         |    2 
 Documentation/devicetree/bindings/gpio/gpio-altera.txt        |    5 
 Documentation/hwmon/hwmon-kernel-api.rst                      |    2 
 Makefile                                                      |    2 
 arch/arm/boot/dts/bcm2835-rpi-b.dts                           |   13 
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts                      |   22 -
 arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts                    |    2 
 arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts                     |    4 
 arch/arm/boot/dts/exynos5250-smdk5250.dts                     |    4 
 arch/arm/boot/dts/ox820.dtsi                                  |    2 
 arch/arm/boot/dts/suniv-f1c100s.dtsi                          |    4 
 arch/arm/mach-hisi/platsmp.c                                  |    4 
 arch/arm/mach-mediatek/Kconfig                                |    1 
 arch/arm/mach-omap1/clock.c                                   |    2 
 arch/arm/mach-pxa/cm-x300.c                                   |    8 
 arch/arm/mach-pxa/magician.c                                  |    2 
 arch/arm/mach-pxa/tosa.c                                      |    4 
 arch/arm/mach-vexpress/dcscb.c                                |    1 
 arch/arm64/Kconfig.platforms                                  |    1 
 arch/arm64/boot/dts/qcom/ipq8074.dtsi                         |    2 
 arch/arm64/boot/dts/rockchip/rk3399.dtsi                      |    2 
 arch/arm64/kernel/sys_compat.c                                |    2 
 arch/arm64/net/bpf_jit_comp.c                                 |    1 
 arch/m68k/Kconfig.cpu                                         |    2 
 arch/m68k/Kconfig.machine                                     |    1 
 arch/m68k/include/asm/pgtable_no.h                            |    3 
 arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h       |    1 
 arch/mips/kernel/mips-cpc.c                                   |    1 
 arch/openrisc/include/asm/timex.h                             |    1 
 arch/openrisc/kernel/head.S                                   |    9 
 arch/powerpc/include/asm/page.h                               |    7 
 arch/powerpc/kernel/fadump.c                                  |    8 
 arch/powerpc/kernel/idle.c                                    |    2 
 arch/powerpc/kernel/ptrace.c                                  |   21 +
 arch/powerpc/perf/isa207-common.c                             |    3 
 arch/powerpc/platforms/4xx/cpm.c                              |    2 
 arch/powerpc/platforms/8xx/cpm1.c                             |    1 
 arch/powerpc/platforms/powernv/opal-fadump.c                  |   94 +++---
 arch/powerpc/platforms/powernv/opal-fadump.h                  |   10 
 arch/powerpc/platforms/powernv/ultravisor.c                   |    1 
 arch/powerpc/sysdev/dart_iommu.c                              |    6 
 arch/powerpc/sysdev/fsl_rio.c                                 |    2 
 arch/powerpc/sysdev/xics/icp-opal.c                           |    1 
 arch/s390/crypto/aes_s390.c                                   |    4 
 arch/s390/include/asm/preempt.h                               |   15 -
 arch/s390/mm/gmap.c                                           |   14 
 arch/um/drivers/chan_user.c                                   |    9 
 arch/um/include/asm/thread_info.h                             |    2 
 arch/um/kernel/exec.c                                         |    2 
 arch/um/kernel/process.c                                      |    2 
 arch/um/kernel/ptrace.c                                       |    8 
 arch/um/kernel/signal.c                                       |    4 
 arch/x86/entry/vdso/vma.c                                     |    2 
 arch/x86/events/amd/ibs.c                                     |   18 +
 arch/x86/events/intel/core.c                                  |    2 
 arch/x86/include/asm/acenv.h                                  |   14 
 arch/x86/include/asm/cpufeature.h                             |    2 
 arch/x86/include/asm/suspend_32.h                             |    2 
 arch/x86/include/asm/suspend_64.h                             |   12 
 arch/x86/kernel/apic/apic.c                                   |    2 
 arch/x86/kernel/cpu/intel.c                                   |    2 
 arch/x86/kernel/step.c                                        |    3 
 arch/x86/kernel/sys_x86_64.c                                  |    7 
 arch/x86/kvm/vmx/nested.c                                     |   15 -
 arch/x86/lib/delay.c                                          |    4 
 arch/x86/mm/pat.c                                             |    2 
 arch/x86/um/ldt.c                                             |    6 
 arch/xtensa/kernel/ptrace.c                                   |    4 
 arch/xtensa/kernel/signal.c                                   |    4 
 block/bfq-cgroup.c                                            |  111 ++++---
 block/bfq-iosched.c                                           |   46 +--
 block/bfq-iosched.h                                           |    6 
 block/bio.c                                                   |    2 
 block/blk-iolatency.c                                         |  122 ++++----
 crypto/cryptd.c                                               |   23 -
 drivers/acpi/property.c                                       |   18 -
 drivers/acpi/sleep.c                                          |   12 
 drivers/ata/libata-transport.c                                |    2 
 drivers/ata/pata_octeon_cf.c                                  |    3 
 drivers/base/bus.c                                            |    4 
 drivers/base/dd.c                                             |    5 
 drivers/base/node.c                                           |    1 
 drivers/block/drbd/drbd_main.c                                |   11 
 drivers/block/nbd.c                                           |   50 ++-
 drivers/block/virtio_blk.c                                    |    7 
 drivers/bus/ti-sysc.c                                         |    4 
 drivers/char/ipmi/ipmi_msghandler.c                           |    4 
 drivers/char/ipmi/ipmi_ssif.c                                 |   23 +
 drivers/clocksource/timer-oxnas-rps.c                         |    2 
 drivers/clocksource/timer-riscv.c                             |    2 
 drivers/clocksource/timer-sp804.c                             |   10 
 drivers/crypto/marvell/cipher.c                               |    1 
 drivers/devfreq/rk3399_dmc.c                                  |    2 
 drivers/dma/stm32-mdma.c                                      |   21 -
 drivers/dma/xilinx/zynqmp_dma.c                               |    5 
 drivers/extcon/extcon.c                                       |   29 +
 drivers/firmware/arm_scmi/base.c                              |    2 
 drivers/firmware/dmi-sysfs.c                                  |    2 
 drivers/firmware/stratix10-svc.c                              |   12 
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c                        |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c                     |    3 
 drivers/gpu/drm/amd/amdgpu/kv_dpm.c                           |   14 
 drivers/gpu/drm/amd/amdgpu/si_dpm.c                           |    8 
 drivers/gpu/drm/arm/display/komeda/komeda_plane.c             |   10 
 drivers/gpu/drm/arm/malidp_crtc.c                             |    5 
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c                  |    1 
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c            |   31 +-
 drivers/gpu/drm/drm_edid.c                                    |    6 
 drivers/gpu/drm/drm_plane.c                                   |   14 
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c                         |    6 
 drivers/gpu/drm/gma500/psb_intel_display.c                    |    7 
 drivers/gpu/drm/imx/ipuv3-crtc.c                              |    2 
 drivers/gpu/drm/mediatek/mtk_cec.c                            |    2 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                         |    1 
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c                       |    4 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c                     |   14 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c                      |    6 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.c                    |   15 -
 drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.h                    |    4 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c                     |   15 -
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.h                     |    2 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c                    |   20 +
 drivers/gpu/drm/msm/dsi/dsi_host.c                            |   21 -
 drivers/gpu/drm/msm/hdmi/hdmi.c                               |   10 
 drivers/gpu/drm/msm/msm_gem_prime.c                           |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c                |    6 
 drivers/gpu/drm/radeon/radeon_connectors.c                    |    4 
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c                   |    2 
 drivers/gpu/drm/tilcdc/tilcdc_external.c                      |    8 
 drivers/gpu/drm/vc4/vc4_txp.c                                 |    8 
 drivers/gpu/drm/virtio/virtgpu_display.c                      |    2 
 drivers/hid/hid-bigbenff.c                                    |    6 
 drivers/hid/hid-elan.c                                        |    2 
 drivers/hid/hid-led.c                                         |    2 
 drivers/hwmon/hwmon.c                                         |   16 -
 drivers/hwtracing/coresight/coresight-cpu-debug.c             |    7 
 drivers/i2c/busses/i2c-at91-master.c                          |   11 
 drivers/i2c/busses/i2c-cadence.c                              |   12 
 drivers/iio/adc/ad7124.c                                      |    1 
 drivers/iio/adc/sc27xx_adc.c                                  |   20 -
 drivers/iio/adc/stmpe-adc.c                                   |    8 
 drivers/iio/common/st_sensors/st_sensors_core.c               |   24 +
 drivers/iio/dummy/iio_simple_dummy.c                          |   20 -
 drivers/infiniband/hw/hfi1/file_ops.c                         |    2 
 drivers/infiniband/hw/hfi1/init.c                             |    2 
 drivers/infiniband/hw/hfi1/sdma.c                             |   12 
 drivers/infiniband/sw/rdmavt/qp.c                             |    6 
 drivers/infiniband/sw/rxe/rxe_req.c                           |    2 
 drivers/input/misc/sparcspkr.c                                |    1 
 drivers/input/mouse/bcm5974.c                                 |    7 
 drivers/input/touchscreen/stmfts.c                            |   16 -
 drivers/iommu/amd_iommu_init.c                                |    2 
 drivers/iommu/msm_iommu.c                                     |   11 
 drivers/iommu/mtk_iommu.c                                     |    3 
 drivers/irqchip/irq-armada-370-xp.c                           |   11 
 drivers/irqchip/irq-aspeed-i2c-ic.c                           |    4 
 drivers/irqchip/irq-sni-exiu.c                                |   25 +
 drivers/irqchip/irq-xtensa-mx.c                               |   18 -
 drivers/macintosh/Kconfig                                     |    6 
 drivers/macintosh/Makefile                                    |    3 
 drivers/macintosh/via-pmu.c                                   |    2 
 drivers/mailbox/mailbox.c                                     |   19 -
 drivers/md/bcache/request.c                                   |    6 
 drivers/md/md-bitmap.c                                        |   44 +-
 drivers/md/md.c                                               |   33 +-
 drivers/md/raid0.c                                            |   31 +-
 drivers/media/cec/cec-adap.c                                  |    6 
 drivers/media/i2c/ov7670.c                                    |    1 
 drivers/media/pci/cx23885/cx23885-core.c                      |    6 
 drivers/media/pci/cx25821/cx25821-core.c                      |    2 
 drivers/media/platform/aspeed-video.c                         |    4 
 drivers/media/platform/coda/coda-common.c                     |   35 +-
 drivers/media/platform/exynos4-is/fimc-is.c                   |    2 
 drivers/media/platform/exynos4-is/fimc-isp-video.h            |    2 
 drivers/media/platform/qcom/venus/hfi.c                       |    3 
 drivers/media/platform/sti/delta/delta-v4l2.c                 |    6 
 drivers/media/platform/vsp1/vsp1_rpf.c                        |    6 
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                       |    7 
 drivers/media/usb/uvc/uvc_v4l2.c                              |   20 -
 drivers/mfd/davinci_voicecodec.c                              |    6 
 drivers/mfd/ipaq-micro.c                                      |    2 
 drivers/misc/cardreader/rtsx_usb.c                            |    1 
 drivers/misc/lkdtm/usercopy.c                                 |   17 -
 drivers/misc/ocxl/file.c                                      |    2 
 drivers/mmc/core/block.c                                      |    3 
 drivers/mmc/host/jz4740_mmc.c                                 |   20 +
 drivers/mtd/chips/cfi_cmdset_0002.c                           |  103 +++---
 drivers/mtd/ubi/vmt.c                                         |    1 
 drivers/net/can/xilinx_can.c                                  |    4 
 drivers/net/dsa/lantiq_gswip.c                                |    4 
 drivers/net/dsa/mv88e6xxx/chip.c                              |    1 
 drivers/net/ethernet/altera/altera_tse_main.c                 |    6 
 drivers/net/ethernet/broadcom/Makefile                        |    5 
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c                |    8 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                   |    3 
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c               |    2 
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c      |    7 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c             |    5 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c             |   45 ++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c      |    9 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c            |   13 
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c          |    4 
 drivers/net/phy/mdio_bus.c                                    |    1 
 drivers/net/phy/micrel.c                                      |   11 
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                |    2 
 drivers/net/wireless/ath/ath9k/ar9003_phy.h                   |    2 
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                 |    8 
 drivers/net/wireless/ath/carl9170/tx.c                        |    3 
 drivers/net/wireless/broadcom/b43/phy_n.c                     |    2 
 drivers/net/wireless/broadcom/b43legacy/phy.c                 |    2 
 drivers/net/wireless/intel/ipw2x00/libipw_tx.c                |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/power.c                |    3 
 drivers/net/wireless/marvell/mwifiex/11h.c                    |    2 
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c            |    8 
 drivers/net/wireless/realtek/rtlwifi/usb.c                    |    2 
 drivers/nfc/st21nfca/se.c                                     |   32 +-
 drivers/nfc/st21nfca/st21nfca.h                               |    1 
 drivers/nvdimm/security.c                                     |    5 
 drivers/nvme/host/pci.c                                       |    1 
 drivers/of/overlay.c                                          |    4 
 drivers/pci/controller/dwc/pci-imx6.c                         |   23 -
 drivers/pci/controller/dwc/pcie-qcom.c                        |    9 
 drivers/pci/controller/pcie-cadence-ep.c                      |    3 
 drivers/pci/controller/pcie-rockchip-ep.c                     |    3 
 drivers/pci/pci.c                                             |   12 
 drivers/pcmcia/Kconfig                                        |    2 
 drivers/phy/qualcomm/phy-qcom-qmp.c                           |   13 
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c                   |    2 
 drivers/pwm/pwm-lp3943.c                                      |    1 
 drivers/regulator/core.c                                      |    7 
 drivers/regulator/pfuze100-regulator.c                        |    2 
 drivers/rpmsg/qcom_smd.c                                      |    4 
 drivers/rtc/rtc-mt6397.c                                      |    2 
 drivers/scsi/dc395x.c                                         |   15 -
 drivers/scsi/fcoe/fcoe_ctlr.c                                 |    2 
 drivers/scsi/megaraid.c                                       |    2 
 drivers/scsi/myrb.c                                           |   11 
 drivers/scsi/ufs/ufs-qcom.c                                   |    7 
 drivers/scsi/ufs/ufshcd.c                                     |    7 
 drivers/soc/qcom/smp2p.c                                      |    1 
 drivers/soc/qcom/smsm.c                                       |    1 
 drivers/soc/rockchip/grf.c                                    |    2 
 drivers/spi/spi-img-spfi.c                                    |    2 
 drivers/spi/spi-rspi.c                                        |   15 -
 drivers/spi/spi-stm32-qspi.c                                  |    3 
 drivers/spi/spi-ti-qspi.c                                     |    5 
 drivers/staging/fieldbus/anybuss/host.c                       |    2 
 drivers/staging/greybus/audio_codec.c                         |    4 
 drivers/staging/rtl8192e/rtllib_softmac.c                     |    2 
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c        |    2 
 drivers/staging/rtl8712/usb_intf.c                            |    6 
 drivers/staging/rtl8712/usb_ops.c                             |   27 +
 drivers/thermal/broadcom/sr-thermal.c                         |    3 
 drivers/tty/goldfish.c                                        |    2 
 drivers/tty/serial/8250/8250_fintek.c                         |    8 
 drivers/tty/serial/digicolor-usart.c                          |    2 
 drivers/tty/serial/fsl_lpuart.c                               |   24 -
 drivers/tty/serial/icom.c                                     |    2 
 drivers/tty/serial/meson_uart.c                               |   13 
 drivers/tty/serial/msm_serial.c                               |    5 
 drivers/tty/serial/owl-uart.c                                 |    1 
 drivers/tty/serial/pch_uart.c                                 |   27 -
 drivers/tty/serial/rda-uart.c                                 |    2 
 drivers/tty/serial/sa1100.c                                   |    4 
 drivers/tty/serial/serial_txx9.c                              |    2 
 drivers/tty/serial/sh-sci.c                                   |    6 
 drivers/tty/serial/sifive.c                                   |    8 
 drivers/tty/serial/st-asc.c                                   |    4 
 drivers/tty/serial/stm32-usart.c                              |   15 -
 drivers/tty/synclink_gt.c                                     |    2 
 drivers/tty/tty_buffer.c                                      |    3 
 drivers/usb/core/hcd-pci.c                                    |    4 
 drivers/usb/core/hcd.c                                        |   29 +
 drivers/usb/core/quirks.c                                     |    3 
 drivers/usb/dwc2/gadget.c                                     |    1 
 drivers/usb/dwc3/dwc3-pci.c                                   |    2 
 drivers/usb/host/isp116x-hcd.c                                |    6 
 drivers/usb/host/oxu210hp-hcd.c                               |    2 
 drivers/usb/musb/omap2430.c                                   |    1 
 drivers/usb/serial/option.c                                   |    2 
 drivers/usb/storage/karma.c                                   |   15 -
 drivers/usb/usbip/stub_dev.c                                  |    2 
 drivers/usb/usbip/stub_rx.c                                   |    2 
 drivers/vhost/vringh.c                                        |   10 
 drivers/video/fbdev/amba-clcd.c                               |    5 
 drivers/video/fbdev/core/fbcon.c                              |    5 
 drivers/video/fbdev/pxa3xx-gcu.c                              |   12 
 drivers/watchdog/ts4800_wdt.c                                 |    5 
 drivers/watchdog/wdat_wdt.c                                   |    1 
 drivers/xen/xlate_mmu.c                                       |    1 
 fs/afs/dir.c                                                  |    5 
 fs/binfmt_flat.c                                              |   27 +
 fs/btrfs/disk-io.c                                            |    4 
 fs/btrfs/volumes.c                                            |    8 
 fs/ceph/xattr.c                                               |   10 
 fs/cifs/cifsglob.h                                            |    4 
 fs/cifs/smb2ops.c                                             |    7 
 fs/cifs/smb2pdu.c                                             |    3 
 fs/dax.c                                                      |    3 
 fs/dlm/lock.c                                                 |   11 
 fs/dlm/plock.c                                                |   12 
 fs/ext4/inline.c                                              |   12 
 fs/ext4/inode.c                                               |    4 
 fs/ext4/namei.c                                               |   84 ++++-
 fs/ext4/super.c                                               |    1 
 fs/f2fs/checkpoint.c                                          |    4 
 fs/f2fs/f2fs.h                                                |   14 
 fs/f2fs/file.c                                                |   20 +
 fs/f2fs/inode.c                                               |   16 +
 fs/f2fs/segment.c                                             |    9 
 fs/f2fs/segment.h                                             |   32 +-
 fs/f2fs/super.c                                               |    6 
 fs/fat/fatent.c                                               |    7 
 fs/fs-writeback.c                                             |   13 
 fs/iomap/buffered-io.c                                        |    3 
 fs/jffs2/fs.c                                                 |    1 
 fs/jfs/jfs_dmap.c                                             |    3 
 fs/kernfs/dir.c                                               |   31 +-
 fs/nfs/file.c                                                 |    7 
 fs/nfs/nfs4proc.c                                             |    4 
 fs/nfs/pnfs.c                                                 |    2 
 fs/nfs/write.c                                                |   11 
 fs/notify/fdinfo.c                                            |   11 
 fs/notify/inotify/inotify.h                                   |   12 
 fs/notify/inotify/inotify_user.c                              |    2 
 fs/notify/mark.c                                              |    6 
 fs/ocfs2/dlmfs/userdlm.c                                      |   16 +
 fs/proc/generic.c                                             |    3 
 fs/proc/proc_net.c                                            |    3 
 include/drm/drm_edid.h                                        |    6 
 include/linux/bpf.h                                           |    2 
 include/linux/efi.h                                           |    2 
 include/linux/iio/common/st_sensors.h                         |    3 
 include/linux/mailbox_controller.h                            |    1 
 include/linux/mtd/cfi.h                                       |    1 
 include/linux/nodemask.h                                      |   51 +--
 include/linux/ptrace.h                                        |    7 
 include/linux/usb/hcd.h                                       |    2 
 include/net/if_inet6.h                                        |    8 
 include/net/sch_generic.h                                     |   42 --
 include/scsi/libfcoe.h                                        |    3 
 include/sound/jack.h                                          |    1 
 include/trace/events/rxrpc.h                                  |    2 
 include/trace/events/vmscan.h                                 |    4 
 init/Kconfig                                                  |    9 
 ipc/mqueue.c                                                  |   14 
 kernel/bpf/stackmap.c                                         |    1 
 kernel/dma/debug.c                                            |    2 
 kernel/ptrace.c                                               |    5 
 kernel/sched/fair.c                                           |    8 
 kernel/sched/pelt.h                                           |    4 
 kernel/sched/sched.h                                          |    4 
 kernel/trace/trace.c                                          |   13 
 kernel/trace/trace_events_hist.c                              |    3 
 lib/nodemask.c                                                |    4 
 mm/compaction.c                                               |    2 
 mm/hugetlb.c                                                  |    9 
 net/bluetooth/sco.c                                           |   21 -
 net/ipv4/ip_gre.c                                             |   11 
 net/ipv4/tcp_input.c                                          |   11 
 net/ipv4/tcp_output.c                                         |    4 
 net/ipv4/xfrm4_protocol.c                                     |    1 
 net/ipv6/addrconf.c                                           |   33 +-
 net/ipv6/seg6_hmac.c                                          |    1 
 net/key/af_key.c                                              |   10 
 net/mac80211/chan.c                                           |    7 
 net/mac80211/ieee80211_i.h                                    |    5 
 net/mac80211/scan.c                                           |   20 +
 net/netfilter/nf_tables_api.c                                 |   22 +
 net/netfilter/nft_dynset.c                                    |    3 
 net/netfilter/nft_nat.c                                       |    3 
 net/nfc/core.c                                                |    1 
 net/rxrpc/ar-internal.h                                       |   13 
 net/rxrpc/call_event.c                                        |    3 
 net/rxrpc/input.c                                             |   31 +-
 net/rxrpc/output.c                                            |   20 -
 net/rxrpc/recvmsg.c                                           |    8 
 net/rxrpc/sendmsg.c                                           |    6 
 net/rxrpc/sysctl.c                                            |    4 
 net/sctp/input.c                                              |    4 
 net/smc/af_smc.c                                              |    2 
 net/sunrpc/xdr.c                                              |    6 
 net/sunrpc/xprtrdma/rpc_rdma.c                                |    5 
 net/tipc/bearer.c                                             |    3 
 net/unix/af_unix.c                                            |    2 
 net/wireless/nl80211.c                                        |    1 
 scripts/faddr2line                                            |  150 ++++++----
 scripts/gdb/linux/config.py                                   |    6 
 scripts/mod/modpost.c                                         |    5 
 security/integrity/platform_certs/keyring_handler.h           |    8 
 security/integrity/platform_certs/load_uefi.c                 |   33 ++
 sound/core/jack.c                                             |   34 +-
 sound/pci/hda/patch_conexant.c                                |    7 
 sound/pci/hda/patch_realtek.c                                 |   10 
 sound/soc/codecs/Kconfig                                      |    1 
 sound/soc/codecs/rk3328_codec.c                               |    2 
 sound/soc/codecs/rt5514.c                                     |    2 
 sound/soc/codecs/rt5645.c                                     |    7 
 sound/soc/codecs/tscs454.c                                    |   12 
 sound/soc/codecs/wm2000.c                                     |    6 
 sound/soc/fsl/fsl_sai.h                                       |    4 
 sound/soc/fsl/imx-sgtl5000.c                                  |   14 
 sound/soc/mediatek/mt2701/mt2701-wm8960.c                     |    9 
 sound/soc/mediatek/mt8173/mt8173-max98090.c                   |    5 
 sound/soc/mxs/mxs-saif.c                                      |    1 
 sound/soc/soc-dapm.c                                          |    2 
 tools/perf/builtin-c2c.c                                      |   10 
 tools/perf/pmu-events/jevents.c                               |    2 
 tools/perf/util/data.h                                        |    1 
 tools/power/x86/turbostat/turbostat.c                         |    1 
 tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c |    2 
 tools/testing/selftests/netfilter/nft_nat.sh                  |   43 ++
 413 files changed, 2500 insertions(+), 1316 deletions(-)

Aditya Garg (1):
      efi: Do not import certificates from UEFI Secure Boot for T2 Macs

Adrian Hunter (1):
      mmc: block: Fix CQE recovery reset success

Aidan MacDonald (1):
      mmc: jz4740: Apply DMA engine limits to maximum segment size

Akira Yokosawa (1):
      docs/conf.py: Cope with removal of language=None in Sphinx 5.0.0

Alexander Aring (2):
      dlm: fix plock invalid read
      dlm: fix missing lkb refcount handling

Alexander Lobakin (1):
      modpost: fix removing numeric suffixes

Alexander Wetzel (1):
      rtl818x: Prevent using not initialized queues

Alexandru Elisei (1):
      arm64: compat: Do not treat syscall number as ESR_ELx for a bad syscall

Alexandru Tachici (1):
      iio: adc: ad7124: Remove shift from scan_type

Alexey Dobriyan (1):
      proc: fix dentry/inode overinstantiating under /proc/${pid}/net

Alice Wong (1):
      drm/amdgpu/ucode: Remove firmware load type check in amdgpu_ucode_free_bo

Amadeusz Sławiński (1):
      ALSA: jack: Access input_dev under mutex

Amelie Delaunay (1):
      dmaengine: stm32-mdma: remove GISR1 register

Amir Goldstein (2):
      inotify: show inotify mask flags in proc fdinfo
      fsnotify: fix wrong lockdep annotations

Ammar Faizi (1):
      x86/delay: Fix the wrong asm constraint in delay_loop()

Andre Przywara (2):
      ARM: dts: suniv: F1C100: fix watchdog compatible
      clocksource/drivers/sp804: Avoid error on multiple instances

Andreas Gruenbacher (1):
      iomap: iomap_write_failed fix

Arnd Bergmann (2):
      drbd: fix duplicate array initializer
      ARM: pxa: maybe fix gpio lookup tables

Baokun Li (1):
      jffs2: fix memory leak in jffs2_do_fill_super

Biju Das (1):
      spi: spi-rspi: Remove setting {src,dst}_{addr,addr_width} based on DMA direction

Bjorn Helgaas (1):
      PCI/PM: Fix bridge_d3_blacklist[] Elo i2 overwrite of Gigabyte X299

Björn Ardö (1):
      mailbox: forward the hrtimer if not queued and under a lock

Brian Norris (2):
      PM / devfreq: rk3399_dmc: Disable edev on remove()
      drm/bridge: analogix_dp: Grab runtime PM reference for DP-AUX

Carl Yin(殷张成) (1):
      USB: serial: option: add Quectel BG95 modem

Chao Yu (5):
      f2fs: fix to avoid f2fs_bug_on() in dec_valid_node_count()
      f2fs: fix to do sanity check on block address in f2fs_do_zero_range()
      f2fs: fix to clear dirty inode in f2fs_evict_inode()
      f2fs: fix deadloop in foreground GC
      f2fs: fix fallocate to use file_modified to update permissions consistently

Charles Keepax (1):
      ASoC: tscs454: Add endianness flag in snd_soc_component_driver

Chengming Zhou (1):
      sched/fair: Fix cfs_rq_clock_pelt() for throttled cfs_rq

Christian Borntraeger (1):
      s390/gmap: voluntarily schedule during key setting

Christoph Hellwig (1):
      virtio_blk: fix the discard_granularity and discard_alignment queue limits

Christophe JAILLET (2):
      media: aspeed: Fix an error handling path in aspeed_video_probe()
      staging: fieldbus: Fix the error handling path in anybuss_host_common_probe()

Christophe de Dinechin (1):
      nodemask.h: fix compilation error with GCC12

Chuanhong Guo (1):
      arm: mediatek: select arch timer for mt7629

Chuck Lever (1):
      SUNRPC: Fix the calculation of xdr->end in xdr_get_next_encode_buffer()

Cixi Geng (2):
      iio: adc: sc27xx: fix read big scale voltage not right
      iio: adc: sc27xx: Fine tune the scale calibration values

Corentin Labbe (1):
      crypto: marvell/cesa - ECB does not IV

Corey Minyard (2):
      ipmi:ssif: Check for NULL msg when handling events and messages
      ipmi: Fix pr_fmt to avoid compilation issues

Cristian Marussi (1):
      firmware: arm_scmi: Fix list protocols enumeration in the base protocol

Dan Carpenter (5):
      ath9k_htc: fix potential out of bounds access with invalid rxstatus->rs_keyix
      drm/msm: return an error pointer in msm_gem_prime_get_sg_table()
      PCI: cadence: Fix find_first_zero_bit() limit
      PCI: rockchip: Fix find_first_zero_bit() limit
      net: ethernet: mtk_eth_soc: out of bounds read in mtk_hwlro_get_fdir_entry()

Dan Williams (1):
      nvdimm: Allow overwrite in the presence of disabled dimms

Daniel Thompson (1):
      irqchip/exiu: Fix acknowledgment of edge triggered interrupts

Daniel Vetter (1):
      fbcon: Consistently protect deferred_takeover with console_lock()

Dave Airlie (1):
      drm/amdgpu/cs: make commands with 0 chunks illegal behaviour.

David Howells (7):
      rxrpc: Return an error to sendmsg if call failed
      rxrpc: Fix listen() setting the bar too high for the prealloc rings
      rxrpc: Don't try to resend the request if we're receiving the reply
      rxrpc: Fix overlapping ACK accounting
      rxrpc: Don't let ack.previousPacket regress
      rxrpc: Fix decision on when to generate an IDLE ACK
      afs: Fix infinite loop found by xfstest generic/676

Dennis Dalessandro (1):
      RDMA/hfi1: Fix potential integer multiplication overflow errors

Dinh Nguyen (1):
      dt-bindings: gpio: altera: correct interrupt-cells

Dmitry Baryshkov (1):
      drm/msm/dsi: fix error checks and return values for DSI xmit functions

Dmitry Torokhov (1):
      Input: stmfts - do not leave device disabled in stmfts_input_open

Dongliang Mu (4):
      HID: bigben: fix slab-out-of-bounds Write in bigben_probe
      rtlwifi: Use pr_warn instead of WARN_ONCE
      media: ov7670: remove ov7670_power_off from ov7670_remove
      f2fs: remove WARN_ON in f2fs_is_valid_blkaddr

Douglas Miller (2):
      RDMA/hfi1: Prevent panic when SDMA is disabled
      RDMA/hfi1: Prevent use of lock before it is initialized

Duoming Zhou (5):
      NFC: hci: fix sleep in atomic context bugs in nfc_hci_hcp_message_tx
      drivers: staging: rtl8192u: Fix deadlock in ieee80211_beacons_stop()
      drivers: staging: rtl8192e: Fix deadlock in rtllib_beacons_stop()
      drivers: tty: serial: Fix deadlock in sa1100_set_termios()
      drivers: usb: host: Fix deadlock in oxu_bus_suspend()

Emmanuel Grumbach (1):
      iwlwifi: mvm: fix assert 1F04 upon reconfig

Eric Biggers (1):
      ext4: reject the 'commit' option on ext2 filesystems

Eric Dumazet (4):
      sctp: read sk->sk_bound_dev_if once in sctp_rcv()
      tcp: tcp_rtx_synack() can be called from process context
      bpf, arm64: Clear prog->jited_len along prog->jited
      tcp: fix tcp_mtup_probe_success vs wrong snd_cwnd

Eric W. Biederman (3):
      ptrace/um: Replace PT_DTRACE with TIF_SINGLESTEP
      ptrace/xtensa: Replace PT_SINGLESTEP with TIF_SINGLESTEP
      ptrace: Reimplement PTRACE_KILL by always sending SIGKILL

Evan Green (1):
      USB: hcd-pci: Fully suspend across freeze/thaw cycle

Evan Quan (1):
      drm/amd/pm: fix the compile warning

Fabio Estevam (1):
      net: phy: micrel: Allow probing without .driver_data

Felix Fietkau (1):
      mac80211: upgrade passive scan to active scan on DFS channels after beacon rx

Feras Daoud (1):
      net/mlx5: Rearm the FW tracer after each tracer event

Finn Thain (1):
      macintosh/via-pmu: Fix build failure when CONFIG_INPUT is disabled

Florian Westphal (1):
      netfilter: nat: really support inet nat without l3 address

Francesco Dolcini (1):
      PCI: imx6: Fix PERST# start-up sequence

Gal Pressman (1):
      net/mlx4_en: Fix wrong return value on ioctl EEPROM query failure

Geert Uytterhoeven (1):
      m68k: math-emu: Fix dependencies of math emulation support

Gong Yuanjun (2):
      mips: cpc: Fix refcount leak in mips_cpc_default_phys_base
      drm/radeon: fix a possible null pointer dereference

Greg Kroah-Hartman (1):
      Linux 5.4.198

Greg Ungerer (2):
      m68knommu: set ZERO_PAGE() to the allocated zeroed page
      m68knommu: fix undefined reference to `_init_sp'

Guenter Roeck (1):
      hwmon: Make chip parameter for with_info API mandatory

Guilherme G. Piccoli (1):
      coresight: cpu-debug: Replace mutex with mutex_trylock on panic notifier

Guoju Fang (1):
      net: sched: add barrier to fix packet stuck problem for lockless qdisc

Guoqing Jiang (1):
      md: protect md_unregister_thread from reentrancy

Gustavo A. R. Silva (1):
      scsi: fcoe: Fix Wstringop-overflow warnings in fcoe_wwn_from_mac()

Hangyu Hua (3):
      drm: msm: fix possible memory leak in mdp5_crtc_cursor_set()
      misc: ocxl: fix possible double free in ocxl_file_register_afu
      usb: usbip: fix a refcount leak in stub_probe()

Hannes Reinecke (1):
      scsi: myrb: Fix up null pointer access on myrb_cleanup()

Hans Verkuil (1):
      media: cec-adap.c: fix is_configuring state

Hao Luo (1):
      kernfs: Separate kernfs_pr_cont_buf and rename_lock.

Haowen Bai (3):
      b43legacy: Fix assigning negative value to unsigned variable
      b43: Fix assigning negative value to unsigned variable
      ipw2x00: Fix potential NULL dereference in libipw_xmit()

Hari Bathini (2):
      powerpc/fadump: Fix fadump to work with a different endian capture kernel
      powerpc/fadump: fix PT_LOAD segment for boot memory area

Heiko Carstens (1):
      s390/preempt: disable __preempt_count_add() optimization for PROFILE_ALL_BRANCHES

Heming Zhao (1):
      md/bitmap: don't set sb values if can't pass sanity check

Hoang Le (1):
      tipc: check attribute length for bearer name

Huang Guobin (1):
      tty: Fix a possible resource leak in icom_probe

Ilpo Järvinen (8):
      serial: 8250_fintek: Check SER_RS485_RTS_* only with RS485
      serial: digicolor-usart: Don't allow CS5-6
      serial: rda-uart: Don't allow CS5-6
      serial: txx9: Don't allow CS5-6
      serial: sh-sci: Don't allow CS5-6
      serial: sifive: Sanitize CSIZE and c_iflag
      serial: st-asc: Sanitize CSIZE and correct PARENB for CS7
      serial: stm32-usart: Correct CSIZE, bits, and parity

Jaegeuk Kim (1):
      f2fs: don't need inode lock for system hidden quota

Jakob Koschel (2):
      f2fs: fix dereference of stale list iterator after loop body
      staging: greybus: codecs: fix type confusion of list iterator variable

Jakub Kicinski (1):
      eth: tg3: silence the GCC 12 array-bounds warning

Jan Kara (11):
      bfq: Split shared queues on move between cgroups
      bfq: Update cgroup information before merging bio
      bfq: Track whether bfq_group is still online
      ext4: verify dir block before splitting it
      ext4: avoid cycles in directory h-tree
      bfq: Avoid merging queues with different parents
      bfq: Drop pointless unlock-lock pair
      bfq: Remove pointless bfq_init_rq() calls
      bfq: Get rid of __bio_blkcg() usage
      bfq: Make sure bfqg for which we are queueing requests is online
      block: fix bio_clone_blkg_association() to associate with proper blkcg_gq

Jan Kiszka (1):
      efi: Add missing prototype for efi_capsule_setup_info

Jani Nikula (1):
      drm/edid: fix invalid EDID extension block filtering

Jann Horn (1):
      s390/crypto: fix scatterwalk_unmap() callers in AES-GCM

Janusz Krzysztofik (1):
      ARM: OMAP1: clock: Fix UART rate reporting algorithm

Jason A. Donenfeld (1):
      openrisc: start CPU timer early in boot

Jessica Zhang (2):
      drm/msm/mdp5: Return error code in mdp5_pipe_release when deadlock is detected
      drm/msm/mdp5: Return error code in mdp5_mixer_release when deadlock is detected

Jia-Ju Bai (1):
      md: bcache: check the return value of kzalloc() in detached_dev_do_request()

Jiasheng Jiang (1):
      drm: mali-dp: potential dereference of null pointer

Jiri Slaby (1):
      serial: pch: don't overwrite xmit->buf[0] by x_char

Joerg Roedel (1):
      iommu/amd: Increase timeout waiting for GA log enablement

Johan Hovold (5):
      PCI: qcom: Fix runtime PM imbalance on probe errors
      PCI: qcom: Fix unbalanced PHY init on probe errors
      phy: qcom-qmp: fix struct clk leak on probe errors
      phy: qcom-qmp: fix reset-controller leak on probe errors
      phy: qcom-qmp: fix pipe-clock imbalance on power-on failure

Johannes Berg (3):
      nl80211: show SSID for P2P_GO interfaces
      wifi: mac80211: fix use-after-free in chanctx code
      um: chan_user: Fix winch_tramp() return value

John Ogness (2):
      serial: meson: acquire port->lock in startup()
      serial: msm_serial: disable interrupts in __msm_console_write()

Jonathan Teh (1):
      HID: hid-led: fix maximum brightness for Dream Cheeky

Josh Poimboeuf (2):
      x86/speculation: Add missing prototype for unpriv_ebpf_notify()
      scripts/faddr2line: Fix overlapping text section failures

Jun Miao (1):
      tracing: Fix sleeping function called from invalid context on RT kernel

Junxiao Bi via Ocfs2-devel (1):
      ocfs2: dlmfs: fix error handling of user_dlm_destroy_lock

Kajol Jain (1):
      powerpc/perf: Fix the threshold compare group constraint for power9

Kan Liang (1):
      perf/x86/intel: Fix event constraints for ICL

Kathiravan T (1):
      arm64: dts: qcom: ipq8074: fix the sleep clock frequency

Kees Cook (2):
      lkdtm/usercopy: Expand size of "out of frame" object
      nodemask: Fix return values to be unsigned

Keita Suzuki (2):
      drm/amd/pm: fix double free in si_parse_power_table()
      tracing: Fix potential double free in create_var_ref()

Kinglong Mee (1):
      xprtrdma: treat all calls not a bcall when bc_serv is NULL

Kirill A. Shutemov (1):
      ACPICA: Avoid cache flush inside virtual machines

Kishon Vijay Abraham I (1):
      usb: core: hcd: Add support for deferring roothub registration

Kiwoong Kim (1):
      scsi: ufs: core: Exclude UECxx from SFR dump list

Krzysztof Kozlowski (7):
      ARM: dts: ox820: align interrupt controller node name with dtschema
      ARM: dts: exynos: add atmel,24c128 fallback to Samsung EEPROM
      irqchip/aspeed-i2c-ic: Fix irq_of_parse_and_map() return value
      pinctrl: mvebu: Fix irq_of_parse_and_map() return value
      rpmsg: qcom_smd: Fix irq_of_parse_and_map() return value
      rpmsg: qcom_smd: Fix returning 0 if irq_of_parse_and_map() fails
      clocksource/drivers/oxnas-rps: Fix irq_of_parse_and_map() return value

Kuan-Ying Lee (1):
      scripts/gdb: change kernel config dumping method

Kuniyuki Iwashima (1):
      af_unix: Fix a data-race in unix_dgram_peer_wake_me().

Kwanghoon Son (1):
      media: exynos4-is: Fix compile warning

Len Brown (1):
      tools/power turbostat: fix ICX DRAM power numbers

Leo Yan (2):
      perf c2c: Use stdio interface if slang is not supported
      perf c2c: Fix sorting in percent_rmt_hitm_cmp()

Leon Romanovsky (1):
      net/mlx5: Don't use already freed action pointer

Lin Ma (3):
      ASoC: rt5645: Fix errorenous cleanup order
      NFC: NULL out the dev->rfkill to prevent UAF
      USB: storage: karma: fix rio_karma_init return

Linus Torvalds (2):
      drm: fix EDID struct for old ARM OABI format
      drm: imx: fix compiler warning with gcc-12

Liu Xinpeng (1):
      watchdog: wdat_wdt: Stop watchdog when rebooting the system

Liu Zixian (1):
      drm/virtio: fix NULL pointer dereference in virtio_gpu_conn_get_modes

Liviu Dudau (1):
      drm/komeda: return early if drm_universal_plane_init() fails.

Luca Weiss (1):
      media: venus: hfi: avoid null dereference in deinit

Lucas Stach (2):
      drm/bridge: adv7511: clean up CEC adapter when probe fails
      drm/etnaviv: check for reaped mapping in etnaviv_iommu_unmap_gem

Lucas Tanure (1):
      i2c: cadence: Increase timeout per message if necessary

Lv Ruyi (6):
      scsi: megaraid: Fix error check return value of register_chrdev()
      drm: msm: fix error check return value of irq_of_parse_and_map()
      powerpc/xics: fix refcount leak in icp_opal_init()
      powerpc/powernv: fix missing of_node_put in uv_init()
      drm/msm/hdmi: fix error check return value of irq_of_parse_and_map()
      mfd: ipaq-micro: Fix error check return value of platform_get_irq()

Maciej W. Rozycki (2):
      MIPS: IP27: Remove incorrect `cpu_has_fpu' override
      serial: sifive: Report actual baud base rather than fixed 115200

Manivannan Sadhasivam (1):
      scsi: ufs: qcom: Add a readl() to make sure ref_clk gets enabled

Marc Kleine-Budde (1):
      can: xilinx_can: mark bit timing constants as const

Marek Szyprowski (1):
      usb: dwc2: gadget: don't reset gadget's driver->bus

Mario Limonciello (1):
      ACPI: PM: Block ASUS B1400CEAE from suspend to idle by default

Marios Levogiannis (1):
      ALSA: hda/realtek - Fix microphone noise on ASUS TUF B550M-PLUS

Mark Bloch (2):
      net/mlx5: fs, delete the FTE when there are no rules attached to it
      net/mlx5: fs, fail conflicting actions

Mark Brown (2):
      ASoC: dapm: Don't fold register value changes into notifications
      ASoC: rt5514: Fix event generation for "DSP Voice Wake Up" control

Mark-PK Tsai (1):
      tracing: Avoid adding tracer option before update_tracer_options

Martin Faltesek (2):
      nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION
      nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling

Masahiro Yamada (5):
      xen: unexport __init-annotated xen_xlate_map_ballooned_pages()
      net: mdio: unexport __init-annotated mdio_bus_init()
      net: xfrm: unexport __init-annotated xfrm4_protocol_init()
      net: ipv6: unexport __init-annotated seg6_hmac_init()
      modpost: fix undefined behavior of is_arm_mapping_symbol()

Mathias Nyman (1):
      Input: bcm5974 - set missing URB_NO_TRANSFER_DMA_MAP urb flag

Matthieu Baerts (1):
      x86/pm: Fix false positive kmemleak report in msr_build_context()

Max Filippov (1):
      irqchip: irq-xtensa-mx: fix initial IRQ affinity

Maxim Mikityanskiy (1):
      net/mlx5e: Update netdev features after changing XDP state

Maxime Ripard (2):
      drm/vc4: txp: Don't set TXP_VSTART_AT_EOF
      drm/vc4: txp: Force alpha to be 0xff if it's disabled

Miaohe Lin (1):
      drivers/base/node.c: fix compaction sysfs file leak

Miaoqian Lin (26):
      ASoC: mediatek: Fix error handling in mt8173_max98090_dev_probe
      ASoC: mediatek: Fix missing of_node_put in mt2701_wm8960_machine_probe
      spi: spi-ti-qspi: Fix return value handling of wait_for_completion_timeout
      HID: elan: Fix potential double free in elan_input_configured
      drm/bridge: Fix error handling in analogix_dp_probe
      ASoC: fsl: Fix refcount leak in imx_sgtl5000_probe
      ASoC: mxs-saif: Fix refcount leak in mxs_saif_probe
      regulator: pfuze100: Fix refcount leak in pfuze_parse_regulators_dt
      media: st-delta: Fix PM disable depth imbalance in delta_probe
      media: exynos4-is: Change clk_disable to clk_disable_unprepare
      drm/msm/a6xx: Fix refcount leak in a6xx_gpu_init
      soc: qcom: smp2p: Fix missing of_node_put() in smp2p_parse_ipc
      soc: qcom: smsm: Fix missing of_node_put() in smsm_parse_ipc
      Input: sparcspkr - fix refcount leak in bbc_beep_probe
      powerpc/fsl_rio: Fix refcount leak in fsl_rio_setup
      video: fbdev: clcdfb: Fix refcount leak in clcdfb_of_vram_setup
      tty: serial: owl: Fix missing clk_disable_unprepare() in owl_uart_probe
      usb: musb: Fix missing of_node_put() in omap2430_probe
      iio: adc: stmpe-adc: Fix wait_for_completion_timeout return value check
      soc: rockchip: Fix refcount leak in rockchip_grf_init
      firmware: dmi-sysfs: Fix memory leak in dmi_sysfs_register_handle
      watchdog: ts4800_wdt: Fix refcount leak in ts4800_wdt_probe
      net: dsa: mv88e6xxx: Fix refcount leak in mv88e6xxx_mdios_register
      ata: pata_octeon_cf: Fix refcount leak in octeon_cf_probe
      net: dsa: lantiq_gswip: Fix refcount leak in gswip_gphy_fw_list
      net: altera: Fix refcount leak in altera_tse_mdio_create

Michael Ellerman (2):
      powerpc/64: Only WARN if __pa()/__va() called with bad addresses
      powerpc/32: Fix overread/overwrite of thread_struct via ptrace

Michael Rodin (1):
      media: vsp1: Fix offset calculation for plane cropping

Michael Walle (1):
      i2c: at91: use dma safe buffers

Michal Kubecek (1):
      Revert "net: af_key: add check for pfkey_broadcast in function pfkey_process"

Mike Kravetz (1):
      hugetlb: fix huge_pmd_unshare address update

Mikulas Patocka (1):
      dma-debug: change allocation mode from GFP_NOWAIT to GFP_ATIOMIC

Miles Chen (1):
      drm/mediatek: Fix mtk_cec_mask()

Miquel Raynal (1):
      iio: st_sensors: Add a local lock for protecting odr

Monish Kumar R (1):
      USB: new quirk for Dell Gen 2 devices

Muchun Song (1):
      dax: fix cache flush on PMD-mapped pages

Nathan Chancellor (1):
      i2c: at91: Initialize dma_buf in at91_twi_xfer()

Nick Desaulniers (1):
      Kconfig: add config option for asm goto w/ outputs

Nicolas Dufresne (2):
      media: coda: Fix reported H264 profile
      media: coda: Add more H264 levels for CODA960

Nicolas Frattaroli (1):
      ASoC: rk3328: fix disabling mclk on pclk probe failure

Niels Dossche (4):
      mwifiex: add mutex lock for call in mwifiex_dfs_chan_sw_work_queue
      ipv6: fix locking issues with loops over idev->addr_list
      IB/rdmavt: add missing locks in rvt_ruc_loopback
      usb: usbip: add missing device lock on tweak configuration cmd

Niklas Cassel (1):
      binfmt_flat: do not stop relocating GOT entries prematurely on riscv

Nuno Sá (1):
      of: overlay: do not break notify on NOTIFY_{OK|STOP}

OGAWA Hirofumi (1):
      fat: add ratelimit to fat*_ent_bread()

Olivier Matz (2):
      ixgbe: fix bcast packets Rx on VF after promisc removal
      ixgbe: fix unexpected VLAN Rx in promisc mode on VF

Pablo Neira Ayuso (2):
      netfilter: nf_tables: disallow non-stateful expression in sets earlier
      netfilter: nf_tables: memleak flow rule from commit path

Pali Rohár (1):
      irqchip/armada-370-xp: Do not touch Performance Counter Overflow on A375, A38x, A39x

Pascal Hambourg (1):
      md/raid0: Ignore RAID0 layout if the second zone has only one device

Patrice Chotard (1):
      spi: stm32-qspi: Fix wait_cmd timeout in APM mode

Pavel Skripkin (1):
      media: pvrusb2: fix array-index-out-of-bounds in pvr2_i2c_core_init

Peng Wu (3):
      ARM: versatile: Add missing of_node_put in dcscb_init
      ARM: hisi: Add missing of_node_put after of_find_compatible_node
      powerpc/iommu: Add missing of_node_put in iommu_init_early_dart

Peter Zijlstra (1):
      x86/cpu: Elide KCSAN for cpu_has() and friends

Petr Machata (1):
      mlxsw: spectrum_dcb: Do not warn about priority changes

Phil Elwell (3):
      ARM: dts: bcm2835-rpi-zero-w: Fix GPIO line name for Wifi/BT
      ARM: dts: bcm2837-rpi-cm3-io3: Fix GPIO line names for SMPS I2C
      ARM: dts: bcm2837-rpi-3-b-plus: Fix GPIO line name of power LED

Philipp Zabel (1):
      media: coda: limit frame interval enumeration to supported encoder frame sizes

Pierre-Louis Bossart (1):
      ASoC: max98357a: remove dependency on GPIOLIB

Qi Zheng (1):
      tty: fix deadlock caused by calling printk() under tty_port->lock

Qu Wenruo (2):
      btrfs: add "0x" prefix for unsupported optional features
      btrfs: repair super block num_devices automatically

Radhey Shyam Pandey (1):
      dmaengine: zynqmp_dma: In struct zynqmp_dma_chan fix desc_size data type

Randy Dunlap (7):
      x86: Fix return value of __setup handlers
      x86/mm: Cleanup the control_va_addr_alignment() __setup handler
      powerpc/8xx: export 'cpm_setbrg' for modules
      powerpc/idle: Fix return value of __setup() handler
      powerpc/4xx/cpm: Fix return value of __setup() handler
      macintosh: via-pmu and via-cuda need RTC_LIB
      pcmcia: db1xxx_ss: restrict to MIPS_DB1XXX boards

Ravi Bangoria (1):
      perf/amd/ibs: Use interrupt regs ip for stack unwinding

Rei Yamamoto (1):
      mm, compaction: fast_find_migrateblock() should return pfn in the target zone

Sakari Ailus (1):
      ACPI: property: Release subnode properties with data nodes

Samuel Holland (1):
      clocksource/drivers/riscv: Events are stopped during CPU suspend

Schspa Shi (2):
      cpufreq: Fix possible race in cpufreq online error path
      driver: base: fix UAF when driver_attach failed

Sean Christopherson (2):
      KVM: nVMX: Leave most VM-Exit info fields unmodified on failed VM-Entry
      Kconfig: Add option for asm goto w/ tied outputs to workaround clang-13 bug

Sebastian Andrzej Siewior (1):
      crypto: cryptd - Protect per-CPU resource by disabling BH.

Sergey Shtylyov (1):
      ata: libata-transport: fix {dma|pio|xfer}_mode sysfs files

Shawn Lin (1):
      arm64: dts: rockchip: Move drive-impedance-ohm to emmc phy on rk3399

Shengjiu Wang (1):
      ASoC: fsl_sai: Fix FSL_SAI_xDR/xFR definition

Sherry Sun (1):
      tty: serial: fsl_lpuart: fix potential bug when using both of_alias_get_id and ida_simple_get

Shuah Khan (1):
      misc: rtsx: set NULL intfdata when probe fails

Shyam Prasad N (1):
      cifs: return errors during session setup during reconnects

Smith, Kyle Miller (Nimble Kernel) (1):
      nvme-pci: fix a NULL pointer dereference in nvme_alloc_admin_tags

Stefan Wahren (1):
      ARM: dts: bcm2835-rpi-b: Fix GPIO line names

Steve French (1):
      cifs: version operations for smb20 unneeded when legacy support disabled

Steven Price (1):
      drm/plane: Move range check for format_count earlier

Tejun Heo (1):
      blk-iolatency: Fix inflight count imbalances and IO hangs on offline

Thibaut VARÈNE (1):
      ath9k: fix QCA9561 PA bias level

Tokunori Ikegami (2):
      mtd: cfi_cmdset_0002: Move and rename chip_check/chip_ready/chip_good_for_write
      mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N

Tony Lindgren (1):
      bus: ti-sysc: Fix warnings for unbind for serial

Trond Myklebust (5):
      NFS: Do not report EINTR/ERESTARTSYS as mapping errors
      NFS: Do not report flush errors in nfs_write_end()
      NFS: Don't report errors from nfs_pageio_complete() more than once
      NFSv4/pNFS: Do not fail I/O when we fail to allocate the pNFS layout
      NFSv4: Don't hold the layoutget locks across multiple RPC calls

Uwe Kleine-König (1):
      pwm: lp3943: Fix duty calculation in case period was clamped

Vasily Averin (1):
      tracing: incorrect isolate_mote_t cast in mm_vmscan_lru_isolate

Venky Shankar (1):
      ceph: allow ceph.dir.rctime xattr to be updatable

Vincent Ray (1):
      net: sched: fixed barrier to prevent skbuff sticking in qdisc backlog

Vincent Whitchurch (1):
      um: Fix out-of-bounds read in LDT setup

Vinod Polimera (1):
      drm/msm/disp/dpu1: set vbif hw config to NULL to avoid use after memory free during pm runtime resume

Viresh Kumar (1):
      Revert "cpufreq: Fix possible race in cpufreq online error path"

Waiman Long (1):
      ipc/mqueue: use get_tree_nodev() in mqueue_get_tree()

Wang Cheng (2):
      staging: rtl8712: fix uninit-value in usb_read8() and friends
      staging: rtl8712: fix uninit-value in r871xu_drv_init()

Wang Weiyang (1):
      tty: goldfish: Use tty_port_destroy() to destroy port

Wenli Looi (1):
      ath9k: fix ar9003_get_eepmisc

Willem de Bruijn (1):
      ip_gre: test csum_start instead of transport header

Xiao Yang (1):
      RDMA/rxe: Generate a completion for unsupported/invalid opcode

Xiaoke Wang (1):
      iio: dummy: iio_simple_dummy: check the return value of kstrdup()

Xiaomeng Tong (10):
      media: uvcvideo: Fix missing check to determine if element is found in list
      scsi: dc395x: Fix a missing check on list iterator
      drm/nouveau/clk: Fix an incorrect NULL check on list iterator
      md: fix an incorrect NULL check in does_sb_need_changing
      md: fix an incorrect NULL check in md_reload_sb
      iommu/msm: Fix an incorrect NULL check on list iterator
      carl9170: tx: fix an incorrect use of list iterator
      tilcdc: tilcdc_external: fix an incorrect NULL check on list iterator
      gma500: fix an incorrect NULL check on list iterator
      firmware: stratix10-svc: fix a missing check on list iterator

Xie Yongji (2):
      nbd: Fix hung on disconnect request if socket is closed before
      vringh: Fix loop descriptors check in the indirect cases

Yang Jihong (1):
      perf tools: Add missing headers needed by util/data.h

Yang Yingliang (6):
      drm/msm/hdmi: check return value after calling platform_get_resource_byname()
      drm/rockchip: vop: fix possible null-ptr-deref in vop_bind()
      ASoC: wm2000: fix missing clk_disable_unprepare() on error in wm2000_anc_transition()
      mfd: davinci_voicecodec: Fix possible null-ptr-deref davinci_vc_probe()
      rtc: mt6397: check return value after calling platform_get_resource()
      video: fbdev: pxa3xx-gcu: release the resources correctly in pxa3xx_gcu_probe/remove()

Ye Bin (3):
      ext4: fix use-after-free in ext4_rename_dir_prepare
      ext4: fix warning in ext4_handle_inode_extension
      ext4: fix bug_on in ext4_writepages

Yicong Yang (1):
      PCI: Avoid pci_dev_lock() AB/BA deadlock with sriov_numvfs_store()

Ying Hsu (1):
      Bluetooth: fix dangling sco_conn and use-after-free in sco_sock_timeout

Yong Wu (1):
      iommu/mediatek: Add list_del in mtk_iommu_remove

Yonghong Song (1):
      selftests/bpf: fix btf_dump/btf_dump due to recent clang change

Yu Kuai (3):
      nbd: call genl_unregister_family() first in nbd_cleanup()
      nbd: fix race between nbd_alloc_config() and module removal
      nbd: fix io hung while disconnecting device

Yu Xiao (1):
      nfp: only report pause frame configuration for physical device

Yuntao Wang (1):
      bpf: Fix excessive memory allocation in stack_map_alloc()

Zev Weiss (1):
      regulator: core: Fix enable_count imbalance with EXCLUSIVE_GET

Zhang Wensheng (1):
      driver core: fix deadlock in __device_attach

Zhen Ni (1):
      USB: host: isp116x: check return value after calling platform_get_resource()

Zheng Yongjun (3):
      spi: img-spfi: Fix pm_runtime_get_sync() error checking
      thermal/drivers/broadcom: Fix potential NULL dereference in sr_thermal_probe
      usb: dwc3: pci: Fix pm_runtime_get_sync() error checking

Zhengjun Xing (1):
      perf jevents: Fix event syntax error caused by ExtSel

Zheyu Ma (3):
      media: pci: cx23885: Fix the error handling in cx23885_initdev()
      media: cx25821: Fix the warning when removing the module
      tty: synclink_gt: Fix null-pointer-dereference in slgt_clean()

Zhihao Cheng (2):
      fs-writeback: writeback_sb_inodes：Recalculate 'wrote' according skipped pages
      ubi: ubi_create_volume: Fix use-after-free when volume creation failed

Zhou Qingyang (1):
      drm/komeda: Fix an undefined behavior bug in komeda_plane_add()

Zixuan Fu (1):
      fs: jfs: fix possible NULL pointer dereference in dbFree()

bumwoo lee (1):
      extcon: Modify extcon device to be created after driver data is set

huangwenhui (1):
      ALSA: hda/conexant - Fix loopback issue with CX20632

jianghaoran (1):
      ipv6: Don't send rs packets to the interface of ARPHRD_TUNNEL

liuyacan (1):
      net/smc: postpone sk_refcnt increment in connect()

