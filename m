Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A387659B3F3
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 15:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiHUNfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 09:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiHUNfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 09:35:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AB821E31;
        Sun, 21 Aug 2022 06:35:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 721EDB80D57;
        Sun, 21 Aug 2022 13:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57136C433C1;
        Sun, 21 Aug 2022 13:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661088936;
        bh=PKy2U2MKwmqFXi40gy/hhm8f1/g/ah2y65ExLsLt2ug=;
        h=From:To:Cc:Subject:Date:From;
        b=OxvfAf8QtENMaubvb8WTf0xNhgcWosqpWiKD3ezuuN822H1nceuSkDx/Jyu8PzTHI
         2mV4v9n3dhWlpV/OUgj2YrPoegJwZI1iW/s+g/WieAcqQ9vds6qUPGogT1j4r4S34i
         T1CfZotLXhPs4SZg6jSNqzNKZZQtelfasSu0vyEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.137
Date:   Sun, 21 Aug 2022 15:35:31 +0200
Message-Id: <166108893121762@kroah.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.137 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-driver-xen-blkback        |    2 
 Documentation/ABI/testing/sysfs-driver-xen-blkfront       |    2 
 Documentation/admin-guide/kernel-parameters.txt           |   29 -
 Documentation/admin-guide/pm/cpuidle.rst                  |   15 
 Documentation/driver-api/vfio.rst                         |   31 -
 Makefile                                                  |    5 
 arch/arm/boot/dts/Makefile                                |    1 
 arch/arm/boot/dts/aspeed-ast2500-evb.dts                  |    2 
 arch/arm/boot/dts/aspeed-ast2600-evb.dts                  |    2 
 arch/arm/boot/dts/bcm53015-meraki-mr26.dts                |  166 +++++++
 arch/arm/boot/dts/imx53-ppd.dts                           |    2 
 arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts              |    2 
 arch/arm/boot/dts/imx6q-apalis-eval.dts                   |    2 
 arch/arm/boot/dts/imx6q-apalis-ixora-v1.1.dts             |    2 
 arch/arm/boot/dts/imx6q-apalis-ixora.dts                  |    2 
 arch/arm/boot/dts/imx6ul.dtsi                             |   33 -
 arch/arm/boot/dts/imx7-colibri-aster.dtsi                 |    2 
 arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi               |    2 
 arch/arm/boot/dts/imx7d-colibri-emmc.dtsi                 |    4 
 arch/arm/boot/dts/motorola-mapphone-common.dtsi           |    2 
 arch/arm/boot/dts/qcom-mdm9615.dtsi                       |    1 
 arch/arm/boot/dts/qcom-pm8841.dtsi                        |    1 
 arch/arm/boot/dts/s5pv210-aries.dtsi                      |    2 
 arch/arm/boot/dts/tegra20-acer-a500-picasso.dts           |    2 
 arch/arm/boot/dts/uniphier-pxs2.dtsi                      |    8 
 arch/arm/lib/findbit.S                                    |   16 
 arch/arm/mach-bcm/bcm_kona_smc.c                          |    1 
 arch/arm/mach-omap2/display.c                             |    3 
 arch/arm/mach-omap2/prm3xxx.c                             |    1 
 arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c        |    5 
 arch/arm/mach-zynq/common.c                               |    1 
 arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts |    2 
 arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts  |    2 
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi            |    2 
 arch/arm64/boot/dts/qcom/ipq8074.dtsi                     |    2 
 arch/arm64/boot/dts/qcom/qcs404.dtsi                      |    4 
 arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi |    6 
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi                 |    2 
 arch/arm64/boot/dts/renesas/r8a77990.dtsi                 |    2 
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi          |    8 
 arch/arm64/crypto/Kconfig                                 |    1 
 arch/arm64/include/asm/processor.h                        |    3 
 arch/arm64/kernel/armv8_deprecated.c                      |    9 
 arch/arm64/kernel/cpufeature.c                            |    2 
 arch/arm64/kvm/hyp/nvhe/switch.c                          |    2 
 arch/arm64/kvm/hyp/vhe/switch.c                           |    2 
 arch/hexagon/Kconfig                                      |    1 
 arch/ia64/include/asm/processor.h                         |    2 
 arch/mips/kernel/proc.c                                   |    2 
 arch/parisc/kernel/drivers.c                              |    9 
 arch/parisc/kernel/syscalls/syscall.tbl                   |    2 
 arch/powerpc/kernel/Makefile                              |    1 
 arch/powerpc/kernel/pci-common.c                          |   29 -
 arch/powerpc/mm/ptdump/shared.c                           |    6 
 arch/powerpc/perf/core-book3s.c                           |   35 -
 arch/powerpc/platforms/Kconfig.cputype                    |    4 
 arch/powerpc/platforms/cell/axon_msi.c                    |    1 
 arch/powerpc/platforms/cell/spufs/inode.c                 |    1 
 arch/powerpc/platforms/powernv/rng.c                      |    2 
 arch/powerpc/sysdev/fsl_pci.c                             |    8 
 arch/powerpc/sysdev/fsl_pci.h                             |    1 
 arch/powerpc/sysdev/xive/spapr.c                          |    1 
 arch/riscv/kernel/reset.c                                 |   12 
 arch/s390/include/asm/gmap.h                              |    2 
 arch/s390/kernel/asm-offsets.c                            |    2 
 arch/s390/kernel/crash_dump.c                             |    2 
 arch/s390/kernel/machine_kexec_file.c                     |   18 
 arch/s390/kernel/os_info.c                                |    3 
 arch/s390/kvm/intercept.c                                 |   15 
 arch/s390/kvm/pv.c                                        |    9 
 arch/s390/kvm/sigp.c                                      |    4 
 arch/s390/mm/gmap.c                                       |   86 +++
 arch/um/Kconfig                                           |    5 
 arch/um/drivers/random.c                                  |    2 
 arch/um/include/shared/kern_util.h                        |    2 
 arch/um/include/shared/os.h                               |    1 
 arch/um/kernel/um_arch.c                                  |   25 +
 arch/um/os-Linux/signal.c                                 |   14 
 arch/x86/boot/Makefile                                    |    2 
 arch/x86/boot/compressed/Makefile                         |    2 
 arch/x86/entry/Makefile                                   |    3 
 arch/x86/entry/thunk_32.S                                 |    2 
 arch/x86/entry/thunk_64.S                                 |    4 
 arch/x86/entry/vdso/Makefile                              |    2 
 arch/x86/include/asm/kvm_host.h                           |    7 
 arch/x86/kernel/cpu/bugs.c                                |   10 
 arch/x86/kernel/ftrace.c                                  |    1 
 arch/x86/kernel/pmem.c                                    |    7 
 arch/x86/kernel/process.c                                 |    9 
 arch/x86/kvm/emulate.c                                    |   23 -
 arch/x86/kvm/hyperv.c                                     |    3 
 arch/x86/kvm/lapic.c                                      |    4 
 arch/x86/kvm/mmu/mmu.c                                    |    2 
 arch/x86/kvm/pmu.c                                        |   36 +
 arch/x86/kvm/svm/pmu.c                                    |    1 
 arch/x86/kvm/svm/svm.c                                    |   14 
 arch/x86/kvm/svm/svm.h                                    |    2 
 arch/x86/kvm/vmx/nested.c                                 |   99 ++--
 arch/x86/kvm/vmx/pmu_intel.c                              |   28 -
 arch/x86/kvm/vmx/vmx.c                                    |   35 -
 arch/x86/kvm/vmx/vmx.h                                    |    2 
 arch/x86/kvm/x86.c                                        |   17 
 arch/x86/mm/numa.c                                        |    4 
 arch/x86/platform/olpc/olpc-xo1-sci.c                     |    2 
 arch/x86/um/Makefile                                      |    3 
 arch/xtensa/platforms/iss/network.c                       |   42 +
 block/bio.c                                               |    3 
 block/blk-merge.c                                         |    2 
 block/blk-mq-debugfs.c                                    |    3 
 block/blk-mq-sched.c                                      |    2 
 block/blk-mq.c                                            |    8 
 crypto/asymmetric_keys/public_key.c                       |    7 
 drivers/acpi/acpi_lpss.c                                  |    3 
 drivers/acpi/apei/einj.c                                  |    2 
 drivers/acpi/cppc_acpi.c                                  |   54 +-
 drivers/acpi/ec.c                                         |   82 ---
 drivers/acpi/processor_idle.c                             |    6 
 drivers/acpi/sleep.c                                      |    8 
 drivers/base/dd.c                                         |    5 
 drivers/block/null_blk_main.c                             |   14 
 drivers/block/xen-blkback/xenbus.c                        |   20 
 drivers/block/xen-blkfront.c                              |    4 
 drivers/bluetooth/hci_intel.c                             |    6 
 drivers/bus/hisi_lpc.c                                    |   10 
 drivers/clk/mediatek/reset.c                              |    4 
 drivers/clk/qcom/camcc-sdm845.c                           |    4 
 drivers/clk/qcom/clk-krait.c                              |    7 
 drivers/clk/qcom/gcc-ipq8074.c                            |   60 ++
 drivers/clk/renesas/r9a06g032-clocks.c                    |    8 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c       |    1 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c         |   22 -
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c         |   15 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h              |    4 
 drivers/crypto/ccp/sev-dev.c                              |    2 
 drivers/crypto/hisilicon/hpre/hpre_crypto.c               |    2 
 drivers/crypto/hisilicon/sec/sec_algs.c                   |   14 
 drivers/crypto/hisilicon/sec/sec_drv.h                    |    2 
 drivers/crypto/hisilicon/sec2/sec.h                       |    7 
 drivers/crypto/hisilicon/sec2/sec_crypto.c                |   97 ++--
 drivers/crypto/hisilicon/sec2/sec_crypto.h                |    3 
 drivers/crypto/inside-secure/safexcel.c                   |    2 
 drivers/dma/dw-edma/dw-edma-core.c                        |    2 
 drivers/dma/sf-pdma/sf-pdma.c                             |   49 +-
 drivers/firmware/arm_scpi.c                               |   61 +-
 drivers/firmware/tegra/bpmp-debugfs.c                     |   10 
 drivers/fpga/altera-pr-ip-core.c                          |    2 
 drivers/gpio/gpiolib-of.c                                 |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                |    4 
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c              |   24 -
 drivers/gpu/drm/bridge/sil-sii8620.c                      |    4 
 drivers/gpu/drm/bridge/tc358767.c                         |   62 ++
 drivers/gpu/drm/drm_gem.c                                 |    4 
 drivers/gpu/drm/drm_mipi_dbi.c                            |    7 
 drivers/gpu/drm/exynos/exynos7_drm_decon.c                |   17 
 drivers/gpu/drm/i915/display/intel_display_debugfs.c      |    4 
 drivers/gpu/drm/i915/i915_reg.h                           |    3 
 drivers/gpu/drm/mcde/mcde_dsi.c                           |    1 
 drivers/gpu/drm/mediatek/mtk_dpi.c                        |   33 -
 drivers/gpu/drm/mediatek/mtk_dsi.c                        |  126 +++--
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c                 |    3 
 drivers/gpu/drm/nouveau/nouveau_display.c                 |    4 
 drivers/gpu/drm/nouveau/nouveau_fbcon.c                   |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c           |    2 
 drivers/gpu/drm/radeon/.gitignore                         |    2 
 drivers/gpu/drm/radeon/Kconfig                            |    2 
 drivers/gpu/drm/radeon/Makefile                           |    2 
 drivers/gpu/drm/radeon/ni_dpm.c                           |    6 
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c           |   10 
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c               |    3 
 drivers/gpu/drm/tiny/st7735r.c                            |    1 
 drivers/gpu/drm/vc4/vc4_crtc.c                            |   10 
 drivers/gpu/drm/vc4/vc4_drv.c                             |   19 
 drivers/gpu/drm/vc4/vc4_drv.h                             |    1 
 drivers/gpu/drm/vc4/vc4_dsi.c                             |  208 ++++++---
 drivers/gpu/drm/vc4/vc4_hdmi.c                            |   50 +-
 drivers/gpu/drm/vc4/vc4_plane.c                           |   30 -
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                    |    6 
 drivers/hid/hid-alps.c                                    |    2 
 drivers/hid/hid-cp2112.c                                  |    5 
 drivers/hid/hid-ids.h                                     |    2 
 drivers/hid/hid-input.c                                   |    4 
 drivers/hid/hid-mcp2221.c                                 |    3 
 drivers/hid/wacom_sys.c                                   |    2 
 drivers/hid/wacom_wac.c                                   |   72 ++-
 drivers/hwmon/drivetemp.c                                 |    1 
 drivers/hwtracing/coresight/coresight-core.c              |    1 
 drivers/hwtracing/intel_th/msu-sink.c                     |    3 
 drivers/hwtracing/intel_th/msu.c                          |   14 
 drivers/hwtracing/intel_th/pci.c                          |   25 +
 drivers/i2c/busses/i2c-cadence.c                          |   10 
 drivers/i2c/busses/i2c-npcm7xx.c                          |   50 +-
 drivers/i2c/i2c-core-base.c                               |    3 
 drivers/i2c/muxes/i2c-mux-gpmux.c                         |    1 
 drivers/iio/accel/bma400.h                                |   23 -
 drivers/iio/accel/bma400_core.c                           |    4 
 drivers/iio/light/isl29028.c                              |    2 
 drivers/infiniband/hw/hfi1/file_ops.c                     |    4 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                |    4 
 drivers/infiniband/hw/mlx5/fs.c                           |    6 
 drivers/infiniband/hw/qedr/verbs.c                        |   26 -
 drivers/infiniband/sw/rxe/rxe_qp.c                        |   12 
 drivers/infiniband/sw/siw/siw_cm.c                        |    7 
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                    |    5 
 drivers/infiniband/ulp/rtrs/rtrs-pri.h                    |   22 -
 drivers/infiniband/ulp/rtrs/rtrs-srv.c                    |    4 
 drivers/infiniband/ulp/srpt/ib_srpt.c                     |  148 ++++--
 drivers/infiniband/ulp/srpt/ib_srpt.h                     |   18 
 drivers/input/serio/gscps2.c                              |    4 
 drivers/input/touchscreen/atmel_mxt_ts.c                  |    6 
 drivers/interconnect/imx/imx.c                            |    8 
 drivers/iommu/arm/arm-smmu/qcom_iommu.c                   |    7 
 drivers/iommu/exynos-iommu.c                              |    6 
 drivers/iommu/intel/dmar.c                                |    2 
 drivers/irqchip/Kconfig                                   |    5 
 drivers/irqchip/irq-mips-gic.c                            |   84 ++-
 drivers/md/dm-raid.c                                      |    4 
 drivers/md/dm-rq.c                                        |    2 
 drivers/md/dm-thin-metadata.c                             |    7 
 drivers/md/dm-thin.c                                      |    4 
 drivers/md/dm-writecache.c                                |    2 
 drivers/md/dm.c                                           |    5 
 drivers/md/md.c                                           |    2 
 drivers/md/raid10.c                                       |    5 
 drivers/media/pci/tw686x/tw686x-core.c                    |   18 
 drivers/media/pci/tw686x/tw686x-video.c                   |    4 
 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h              |    2 
 drivers/media/usb/hdpvr/hdpvr-video.c                     |    2 
 drivers/media/v4l2-core/v4l2-mem2mem.c                    |    2 
 drivers/memstick/core/ms_block.c                          |   11 
 drivers/mfd/max77620.c                                    |    2 
 drivers/mfd/t7l66xb.c                                     |    6 
 drivers/misc/cardreader/rtsx_pcr.c                        |    6 
 drivers/misc/eeprom/idt_89hpesx.c                         |    8 
 drivers/mmc/core/block.c                                  |   28 -
 drivers/mmc/host/cavium-octeon.c                          |    1 
 drivers/mmc/host/cavium-thunderx.c                        |    4 
 drivers/mmc/host/sdhci-of-at91.c                          |    9 
 drivers/mmc/host/sdhci-of-esdhc.c                         |    1 
 drivers/mtd/devices/st_spi_fsm.c                          |    8 
 drivers/mtd/maps/physmap-versatile.c                      |    2 
 drivers/mtd/nand/raw/arasan-nand-controller.c             |   57 ++
 drivers/mtd/nand/raw/atmel/nand-controller.c              |    2 
 drivers/mtd/nand/raw/meson_nand.c                         |    1 
 drivers/mtd/nand/raw/nand_timings.c                       |  255 +++++++++++
 drivers/mtd/parsers/redboot.c                             |    1 
 drivers/mtd/sm_ftl.c                                      |    2 
 drivers/net/can/pch_can.c                                 |    8 
 drivers/net/can/rcar/rcar_can.c                           |    8 
 drivers/net/can/sja1000/sja1000.c                         |    7 
 drivers/net/can/spi/hi311x.c                              |    5 
 drivers/net/can/sun4i_can.c                               |    9 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c         |   12 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c          |    6 
 drivers/net/can/usb/usb_8dev.c                            |    7 
 drivers/net/ethernet/huawei/hinic/hinic_dev.h             |    3 
 drivers/net/ethernet/huawei/hinic/hinic_main.c            |   68 ---
 drivers/net/ethernet/huawei/hinic/hinic_rx.c              |    2 
 drivers/net/ethernet/huawei/hinic/hinic_tx.c              |    2 
 drivers/net/ethernet/intel/iavf/iavf.h                    |    1 
 drivers/net/ethernet/intel/iavf/iavf_main.c               |   25 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h              |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c   |    2 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c           |    2 
 drivers/net/netdevsim/bpf.c                               |    8 
 drivers/net/usb/ax88179_178a.c                            |   20 
 drivers/net/usb/smsc95xx.c                                |   20 
 drivers/net/usb/usbnet.c                                  |    8 
 drivers/net/wireguard/allowedips.c                        |    9 
 drivers/net/wireguard/selftest/allowedips.c               |    6 
 drivers/net/wireguard/selftest/ratelimiter.c              |   25 -
 drivers/net/wireless/ath/ath10k/snoc.c                    |    5 
 drivers/net/wireless/ath/ath11k/core.c                    |   16 
 drivers/net/wireless/ath/ath11k/debug.h                   |    4 
 drivers/net/wireless/ath/ath9k/htc.h                      |   10 
 drivers/net/wireless/ath/ath9k/htc_drv_init.c             |    3 
 drivers/net/wireless/ath/wil6210/debugfs.c                |   18 
 drivers/net/wireless/intel/iwlegacy/4965-rs.c             |    5 
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c              |    1 
 drivers/net/wireless/intersil/p54/main.c                  |    2 
 drivers/net/wireless/intersil/p54/p54spi.c                |    3 
 drivers/net/wireless/mac80211_hwsim.c                     |   14 
 drivers/net/wireless/marvell/libertas/if_usb.c            |    1 
 drivers/net/wireless/marvell/mwifiex/main.h               |    2 
 drivers/net/wireless/marvell/mwifiex/pcie.c               |    3 
 drivers/net/wireless/marvell/mwifiex/sta_event.c          |    3 
 drivers/net/wireless/mediatek/mt76/mac80211.c             |    1 
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c      |    2 
 drivers/net/wireless/realtek/rtlwifi/debug.c              |    8 
 drivers/nvme/host/trace.h                                 |    2 
 drivers/opp/core.c                                        |    4 
 drivers/parisc/lba_pci.c                                  |    6 
 drivers/pci/controller/dwc/pcie-designware-ep.c           |   18 
 drivers/pci/controller/dwc/pcie-designware.c              |   30 -
 drivers/pci/controller/dwc/pcie-qcom.c                    |   10 
 drivers/pci/controller/dwc/pcie-tegra194.c                |   49 +-
 drivers/pci/endpoint/functions/pci-epf-test.c             |    1 
 drivers/pci/pci.h                                         |    4 
 drivers/pci/pcie/aer.c                                    |   79 ++-
 drivers/pci/pcie/err.c                                    |   85 ++-
 drivers/pci/pcie/portdrv_core.c                           |    9 
 drivers/pci/pcie/portdrv_pci.c                            |   10 
 drivers/perf/arm_spe_pmu.c                                |   22 -
 drivers/platform/chrome/cros_ec.c                         |    8 
 drivers/platform/olpc/olpc-ec.c                           |    2 
 drivers/pwm/pwm-lpc18xx-sct.c                             |    4 
 drivers/pwm/pwm-sifive.c                                  |   65 ++
 drivers/regulator/of_regulator.c                          |    6 
 drivers/regulator/qcom_smd-regulator.c                    |    4 
 drivers/remoteproc/qcom_sysmon.c                          |   10 
 drivers/remoteproc/qcom_wcnss.c                           |   10 
 drivers/remoteproc/ti_k3_r5_remoteproc.c                  |    2 
 drivers/rpmsg/mtk_rpmsg.c                                 |    2 
 drivers/rpmsg/qcom_smd.c                                  |    1 
 drivers/s390/char/zcore.c                                 |   11 
 drivers/s390/cio/vfio_ccw_drv.c                           |   14 
 drivers/s390/scsi/zfcp_fc.c                               |   29 -
 drivers/s390/scsi/zfcp_fc.h                               |    6 
 drivers/s390/scsi/zfcp_fsf.c                              |    7 
 drivers/scsi/qla2xxx/qla_def.h                            |    5 
 drivers/scsi/qla2xxx/qla_gbl.h                            |    3 
 drivers/scsi/qla2xxx/qla_gs.c                             |   11 
 drivers/scsi/qla2xxx/qla_init.c                           |   48 +-
 drivers/scsi/qla2xxx/qla_isr.c                            |   20 
 drivers/scsi/qla2xxx/qla_mbx.c                            |   19 
 drivers/scsi/qla2xxx/qla_nvme.c                           |    5 
 drivers/scsi/sg.c                                         |   53 +-
 drivers/scsi/smartpqi/smartpqi_init.c                     |    4 
 drivers/soc/amlogic/meson-mx-socinfo.c                    |    1 
 drivers/soc/amlogic/meson-secure-pwrc.c                   |    4 
 drivers/soc/fsl/guts.c                                    |    2 
 drivers/soc/qcom/Kconfig                                  |    1 
 drivers/soc/qcom/ocmem.c                                  |    3 
 drivers/soc/qcom/qcom_aoss.c                              |    4 
 drivers/soc/renesas/r8a779a0-sysc.c                       |   10 
 drivers/soundwire/bus_type.c                              |    8 
 drivers/spi/spi-rspi.c                                    |    4 
 drivers/spi/spi-synquacer.c                               |    1 
 drivers/staging/media/atomisp/pci/atomisp_cmd.c           |   57 +-
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c          |    3 
 drivers/staging/rtl8192u/r8192U.h                         |    2 
 drivers/staging/rtl8192u/r8192U_dm.c                      |   38 -
 drivers/staging/rtl8192u/r8192U_dm.h                      |    2 
 drivers/tee/tee_shm.c                                     |    3 
 drivers/thermal/thermal_sysfs.c                           |   10 
 drivers/tty/n_gsm.c                                       |  199 ++++++---
 drivers/tty/serial/8250/8250.h                            |   22 +
 drivers/tty/serial/8250/8250_dw.c                         |    3 
 drivers/tty/serial/8250/8250_pci.c                        |  308 ++++++--------
 drivers/tty/serial/8250/8250_port.c                       |   21 
 drivers/tty/serial/mvebu-uart.c                           |   11 
 drivers/tty/vt/vt.c                                       |    2 
 drivers/usb/cdns3/gadget.c                                |   11 
 drivers/usb/core/hcd.c                                    |   26 -
 drivers/usb/dwc3/core.c                                   |    9 
 drivers/usb/dwc3/dwc3-qcom.c                              |    4 
 drivers/usb/dwc3/gadget.c                                 |   92 +---
 drivers/usb/gadget/udc/Kconfig                            |    2 
 drivers/usb/gadget/udc/aspeed-vhub/hub.c                  |    4 
 drivers/usb/gadget/udc/tegra-xudc.c                       |    8 
 drivers/usb/host/ehci-ppc-of.c                            |    1 
 drivers/usb/host/ohci-nxp.c                               |    1 
 drivers/usb/host/xhci-tegra.c                             |    8 
 drivers/usb/host/xhci.h                                   |    2 
 drivers/usb/serial/sierra.c                               |    3 
 drivers/usb/serial/usb-serial.c                           |    2 
 drivers/usb/serial/usb_wwan.c                             |    3 
 drivers/usb/typec/ucsi/ucsi.c                             |    4 
 drivers/vfio/mdev/mdev_private.h                          |    5 
 drivers/vfio/vfio.c                                       |  207 +++------
 drivers/video/fbdev/amba-clcd.c                           |   24 -
 drivers/video/fbdev/arkfb.c                               |    9 
 drivers/video/fbdev/core/fbcon.c                          |   12 
 drivers/video/fbdev/s3fb.c                                |    2 
 drivers/video/fbdev/sis/init.c                            |    4 
 drivers/video/fbdev/vt8623fb.c                            |    2 
 drivers/watchdog/armada_37xx_wdt.c                        |    2 
 fs/attr.c                                                 |    2 
 fs/btrfs/block-group.c                                    |    1 
 fs/btrfs/disk-io.c                                        |   14 
 fs/btrfs/raid56.c                                         |   74 ++-
 fs/erofs/decompressor.c                                   |   16 
 fs/eventpoll.c                                            |   22 +
 fs/exec.c                                                 |    3 
 fs/ext2/super.c                                           |   12 
 fs/ext4/inline.c                                          |    3 
 fs/ext4/inode.c                                           |   22 -
 fs/ext4/migrate.c                                         |    4 
 fs/ext4/namei.c                                           |   23 +
 fs/ext4/resize.c                                          |    1 
 fs/ext4/xattr.c                                           |    6 
 fs/ext4/xattr.h                                           |   13 
 fs/f2fs/file.c                                            |    9 
 fs/f2fs/gc.c                                              |   41 +
 fs/fuse/control.c                                         |    4 
 fs/fuse/inode.c                                           |    6 
 fs/jbd2/commit.c                                          |    2 
 fs/jbd2/transaction.c                                     |   14 
 fs/namei.c                                                |    4 
 fs/nfs/nfs3client.c                                       |    1 
 fs/overlayfs/export.c                                     |    2 
 fs/splice.c                                               |   10 
 fs/xfs/xfs_icache.c                                       |    3 
 fs/xfs/xfs_iomap.c                                        |    8 
 fs/xfs/xfs_iops.c                                         |    2 
 fs/xfs/xfs_log_recover.c                                  |    4 
 include/acpi/cppc_acpi.h                                  |    2 
 include/linux/bitmap.h                                    |   12 
 include/linux/blktrace_api.h                              |    5 
 include/linux/buffer_head.h                               |   25 +
 include/linux/kfifo.h                                     |    2 
 include/linux/kvm_host.h                                  |   28 +
 include/linux/lockdep.h                                   |   30 -
 include/linux/mfd/t7l66xb.h                               |    1 
 include/linux/mm.h                                        |    2 
 include/linux/mtd/rawnand.h                               |  123 +++++
 include/linux/pci_ids.h                                   |    3 
 include/linux/sched.h                                     |    2 
 include/linux/tpm_eventlog.h                              |    2 
 include/linux/usb/hcd.h                                   |    1 
 include/linux/vfio.h                                      |   16 
 include/linux/wait.h                                      |    9 
 include/net/inet6_hashtables.h                            |   27 -
 include/net/inet_hashtables.h                             |   44 --
 include/net/inet_sock.h                                   |   18 
 include/net/sock.h                                        |   15 
 include/trace/events/block.h                              |   30 -
 include/trace/events/spmi.h                               |   12 
 include/trace/trace_events.h                              |    8 
 include/uapi/linux/can/error.h                            |    5 
 include/uapi/linux/netfilter/xt_IDLETIMER.h               |   17 
 include/uapi/linux/pci_regs.h                             |    7 
 kernel/bpf/verifier.c                                     |    4 
 kernel/cgroup/cpuset.c                                    |    2 
 kernel/irq/Kconfig                                        |    1 
 kernel/irq/chip.c                                         |    3 
 kernel/kprobes.c                                          |    3 
 kernel/locking/lockdep.c                                  |    9 
 kernel/locking/lockdep_internals.h                        |    8 
 kernel/power/user.c                                       |   13 
 kernel/profile.c                                          |    7 
 kernel/sched/core.c                                       |   34 +
 kernel/sched/deadline.c                                   |   52 --
 kernel/sched/rt.c                                         |   15 
 kernel/sched/sched.h                                      |    3 
 kernel/time/hrtimer.c                                     |    1 
 kernel/time/timekeeping.c                                 |    7 
 kernel/trace/blktrace.c                                   |   46 --
 lib/Kconfig.debug                                         |   40 +
 lib/bitmap.c                                              |   42 +
 lib/livepatch/test_klp_callbacks_busy.c                   |    8 
 lib/smp_processor_id.c                                    |    2 
 lib/test_bpf.c                                            |    4 
 mm/mmap.c                                                 |    1 
 mm/mremap.c                                               |    6 
 mm/util.c                                                 |   15 
 net/9p/client.c                                           |    5 
 net/bluetooth/l2cap_core.c                                |   13 
 net/dccp/proto.c                                          |   10 
 net/ipv4/inet_hashtables.c                                |   17 
 net/ipv4/tcp_output.c                                     |   30 -
 net/ipv4/udp.c                                            |    3 
 net/ipv6/inet6_hashtables.c                               |    6 
 net/ipv6/udp.c                                            |    2 
 net/mac80211/sta_info.c                                   |    6 
 net/netfilter/nf_tables_api.c                             |   18 
 net/rose/af_rose.c                                        |   11 
 net/rose/rose_route.c                                     |    2 
 net/sched/cls_route.c                                     |   12 
 scripts/faddr2line                                        |    4 
 security/selinux/ss/policydb.h                            |    2 
 sound/pci/hda/patch_cirrus.c                              |    1 
 sound/pci/hda/patch_conexant.c                            |   11 
 sound/pci/hda/patch_realtek.c                             |   15 
 sound/soc/atmel/mchp-spdifrx.c                            |    9 
 sound/soc/codecs/cros_ec_codec.c                          |    1 
 sound/soc/codecs/da7210.c                                 |    2 
 sound/soc/codecs/msm8916-wcd-digital.c                    |   46 +-
 sound/soc/codecs/wcd9335.c                                |   81 +--
 sound/soc/fsl/fsl_easrc.c                                 |    9 
 sound/soc/fsl/fsl_easrc.h                                 |    2 
 sound/soc/generic/audio-graph-card.c                      |    4 
 sound/soc/mediatek/mt6797/mt6797-mt6351.c                 |    6 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c          |   10 
 sound/soc/mediatek/mt8173/mt8173-rt5650.c                 |    9 
 sound/soc/qcom/lpass-cpu.c                                |    1 
 sound/soc/qcom/qdsp6/q6adm.c                              |    2 
 sound/soc/samsung/aries_wm8994.c                          |    6 
 sound/soc/samsung/h1940_uda1380.c                         |    2 
 sound/soc/samsung/rx1950_uda1380.c                        |    4 
 sound/usb/bcd2000/bcd2000.c                               |    3 
 tools/lib/bpf/libbpf.c                                    |    9 
 tools/lib/bpf/xsk.c                                       |    9 
 tools/perf/util/dsos.c                                    |   15 
 tools/perf/util/genelf.c                                  |    6 
 tools/perf/util/symbol-elf.c                              |   27 -
 tools/testing/selftests/bpf/prog_tests/btf.c              |    2 
 tools/testing/selftests/kvm/lib/x86_64/processor.c        |    2 
 tools/testing/selftests/seccomp/seccomp_bpf.c             |    2 
 tools/testing/selftests/timers/clocksource-switch.c       |    6 
 tools/testing/selftests/timers/valid-adjtimex.c           |    2 
 tools/thermal/tmon/sysfs.c                                |   24 -
 tools/thermal/tmon/tmon.h                                 |    3 
 virt/kvm/kvm_main.c                                       |   26 -
 503 files changed, 4719 insertions(+), 2497 deletions(-)

Aaron Lewis (1):
      kvm: x86/pmu: Fix the compare function used by the pmu event filter

Adrian Hunter (1):
      perf tools: Fix dso_id inode generation comparison

Ahmed Zaki (1):
      mac80211: fix a memory leak where sta_info is not freed

Al Viro (1):
      __follow_mount_rcu(): verify that mount_lock remains unchanged

Alex Deucher (1):
      drm/radeon: fix incorrrect SPDX-License-Identifiers

Alexander Gordeev (2):
      s390/dump: fix old lowcore virtual vs physical address confusion
      s390/zcore: fix race when reading from hardware system area

Alexander Lobakin (3):
      ia64, processor: fix -Wincompatible-pointer-types in ia64_get_irr()
      x86/olpc: fix 'logical not is only applied to the left hand side'
      iommu/vt-d: avoid invalid memory access via node_online(NUMA_NO_NODE)

Alexander Shishkin (4):
      intel_th: msu: Fix vmalloced buffers
      intel_th: pci: Add Meteor Lake-P support
      intel_th: pci: Add Raptor Lake-S PCH support
      intel_th: pci: Add Raptor Lake-S CPU support

Alexander Stein (6):
      ARM: dts: imx6ul: add missing properties for sram
      ARM: dts: imx6ul: change operating-points to uint32-matrix
      ARM: dts: imx6ul: fix keypad compatible
      ARM: dts: imx6ul: fix csi node compatible
      ARM: dts: imx6ul: fix lcdif node compatible
      ARM: dts: imx6ul: fix qspi node compatible

Alexandru Elisei (1):
      arm64: cpufeature: Allow different PMU versions in ID_DFR0_EL1

Alexei Starovoitov (1):
      bpf: Fix subprog names in stack traces.

Alexey Khoroshilov (1):
      crypto: sun8i-ss - fix infinite loop in sun8i_ss_setup_ivs()

Alexey Kodanev (2):
      drm/radeon: fix potential buffer overflow in ni_set_mc_special_registers()
      wifi: iwlegacy: 4965: fix potential off-by-one overflow in il4965_rs_fill_link_cmd()

Allen Ballway (1):
      ALSA: hda/cirrus - support for iMac 12,1 model

Amit Kumar Mahapatra (1):
      mtd: rawnand: arasan: Update NAND bus clock instead of system clock

Ammar Faizi (1):
      wifi: wil6210: debugfs: fix uninitialized variable use in `wil_write_file_wmi()`

Andrea Righi (1):
      x86/entry: Build thunk_$(BITS) only if CONFIG_PREEMPTION=y

Andrei Vagin (1):
      selftests: kvm: set rax before vmcall

Andrey Strachuk (1):
      usb: cdns3: change place of 'priv_ep' assignment in cdns3_gadget_ep_dequeue(), cdns3_gadget_ep_enable()

Andy Shevchenko (2):
      serial: 8250_pci: Refactor the loop in pci_ite887x_init()
      serial: 8250_pci: Replace dev_*() by pci_*() macros

Aneesh Kumar K.V (1):
      mm/mremap: hold the rmap lock in write mode when moving page table entries.

AngeloGioacchino Del Regno (2):
      media: platform: mtk-mdp: Fix mdp_ipi_comm structure alignment
      rpmsg: mtk_rpmsg: Fix circular locking dependency

Anquan Wu (1):
      libbpf: Fix the name of a reused map

Anshuman Khandual (1):
      drivers/perf: arm_spe: Fix consistency of SYS_PMSCR_EL1.CX

Ansuel Smith (1):
      clk: qcom: clk-krait: unlock spin after mux completion

Antonio Borneo (2):
      genirq: Don't return error on missing optional irq_request_resources()
      drm: adv7511: override i2c address of cec before accessing it

Arnaldo Carvalho de Melo (1):
      genelf: Use HAVE_LIBCRYPTO_SUPPORT, not the never defined HAVE_LIBCRYPTO

Artem Borisov (1):
      HID: alps: Declare U1_UNICORN_LEGACY support

Arun Easi (3):
      scsi: qla2xxx: Fix discovery issues in FC-AL topology
      scsi: qla2xxx: Fix losing FCP-2 targets on long port disable with I/Os
      scsi: qla2xxx: Fix losing FCP-2 targets during port perturbation tests

Athira Rajeev (1):
      powerpc/perf: Optimize clearing the pending PMI and remove WARN_ON for PMI check in power_pmu_disable

Austin Kim (1):
      dmaengine: sf-pdma: apply proper spinlock flags in sf_pdma_prep_dma_memcpy()

Baokun Li (4):
      ext4: add EXT4_INODE_HAS_XATTR_SPACE macro in xattr.h
      ext4: fix use-after-free in ext4_xattr_set_entry
      ext4: correct max_inline_xattr_value_size computing
      ext4: correct the misjudgment in ext4_iget_extra_inode

Bart Van Assche (4):
      blktrace: Trace remapped requests correctly
      RDMA/srpt: Duplicate port name members
      RDMA/srpt: Introduce a reference count in struct srpt_device
      RDMA/srpt: Fix a use-after-free

Bartosz Golaszewski (2):
      lib: bitmap: order includes alphabetically
      lib: bitmap: provide devm_bitmap_alloc() and devm_bitmap_zalloc()

Bean Huo (1):
      nvme: use command_id instead of req->tag in trace_nvme_complete_rq()

Bedant Patnaik (1):
      ALSA: hda/realtek: Add a quirk for HP OMEN 15 (8786) mute LED

Benjamin Segall (1):
      epoll: autoremove wakers even more aggressively

Biju Das (1):
      spi: spi-rspi: Fix PIO fallback on RZ platforms

Bikash Hazarika (2):
      scsi: qla2xxx: Fix incorrect display of max frame size
      scsi: qla2xxx: Zero undefined mailbox IN registers

Bo-Chen Chen (1):
      drm/mediatek: dpi: Remove output format of YUV

Brian Norris (1):
      drm/rockchip: vop: Don't crash for invalid duplicate_state()

Byungki Lee (1):
      f2fs: write checkpoint during FG_GC

Chao Liu (1):
      f2fs: fix to remove F2FS_COMPR_FL and tag F2FS_NOCOMP_FL at the same time

Chao Yu (1):
      f2fs: don't set GC_FAILURE_PIN for background GC

Chen Zhongjin (2):
      profiling: fix shift too large makes kernel panic
      kprobes: Forbid probing on trampoline and BPF code areas

Cheng Xu (1):
      RDMA/siw: Fix duplicated reported IW_CM_EVENT_CONNECT_REPLY event

Christian Lamparter (1):
      ARM: dts: BCM5301X: Add DT for Meraki MR26

Christian Loehle (1):
      mmc: block: Add single read for 4k sector cards

Christian Marangi (1):
      PCI: qcom: Set up rev 2.1.0 PARF_PHY before enabling clocks

Christoph Hellwig (1):
      block: remove the request_queue to argument request based tracepoints

Christophe JAILLET (9):
      drm/rockchip: Fix an error handling path rockchip_dp_probe()
      hinic: Use the bitmap API when applicable
      wifi: p54: Fix an error handling path in p54spi_probe()
      mtd: rawnand: meson: Fix a potential double free issue
      misc: rtsx: Fix an error handling path in rtsx_pci_probe()
      intel_th: Fix a resource leak in an error handling path
      memstick/ms_block: Fix some incorrect memory allocation
      memstick/ms_block: Fix a memory leak
      ASoC: qcom: q6dsp: Fix an off-by-one in q6adm_alloc_copp()

Christophe Leroy (2):
      powerpc/ptdump: Fix display of RW pages on FSL_BOOK3E
      powerpc/32: Do not allow selection of e5500 or e6500 CPUs on PPC32

Christopher Obbard (1):
      um: random: Don't initialise hwrng struct with zero

Chuansheng Liu (1):
      drm/i915/dg1: Update DMC_DEBUG3 register

Claudio Imbrenda (1):
      KVM: s390: pv: leak the topmost page table when destroy fails

Claudiu Beznea (1):
      ASoC: mchp-spdifrx: disable end of block interrupt on failures

Corentin Labbe (1):
      crypto: sun8i-ss - do not allocate memory when handling hash requests

Dan Carpenter (8):
      wifi: rtlwifi: fix error codes in rtl_debugfs_set_write_h2c()
      crypto: sun8i-ss - fix error codes in allocate_flows()
      wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()
      selftests/bpf: fix a test for snprintf() overflow
      eeprom: idt_89hpesx: uninitialized data in idt_dbgfs_csr_write()
      platform/olpc: Fix uninitialized data in debugfs write
      null_blk: fix ida error handling in null_add_dev()
      kfifo: fix kfifo_to_user() return type

Dan Williams (1):
      ACPI: APEI: Fix _EINJ vs EFI_MEMORY_SP

Daniel Starke (8):
      tty: n_gsm: fix user open not possible at responder until initiator open
      tty: n_gsm: fix wrong queuing behavior in gsm_dlci_data_output()
      tty: n_gsm: fix non flow control frames during mux flow off
      tty: n_gsm: fix packet re-transmission without open control channel
      tty: n_gsm: fix race condition in gsmld_write()
      tty: n_gsm: fix wrong T1 retry count handling
      tty: n_gsm: fix DM command
      tty: n_gsm: fix missing corner cases in gsmld_poll()

Darrick J. Wong (1):
      xfs: only set IOMAP_F_SHARED when providing a srcmap to a write

Dave Chinner (2):
      mm: Add kvrealloc()
      xfs: fix I_DONTCACHE

Dave Stevenson (8):
      drm/vc4: plane: Fix margin calculations for the right/bottom edges
      drm/vc4: dsi: Correct DSI divider calculations
      drm/vc4: dsi: Correct pixel order for DSI0
      drm/vc4: dsi: Register dsi0 as the correct vc4 encoder type
      drm/vc4: dsi: Fix dsi0 interrupt support
      drm/vc4: dsi: Add correct stop condition to vc4_dsi_encoder_disable iteration
      drm/vc4: hdmi: Correct HDMI timing registers for interlaced modes
      drm/vc4: drv: Adopt the dma configuration from the HVS or V3D component

David Collins (1):
      spmi: trace: fix stack-out-of-bound access in SPMI tracing functions

David Howells (1):
      vfs: Check the truncate maximum size in inode_newsize_ok()

Dietmar Eggemann (1):
      sched/deadline: Merge dl_task_can_attach() and dl_cpu_busy()

Dimitri John Ledkov (1):
      riscv: set default pm_power_off to NULL

Dmitry Osipenko (1):
      drm/gem: Properly annotate WW context on drm_gem_lock_reservations() error

Dom Cobley (3):
      drm/vc4: plane: Remove subpixel positioning check
      drm/vc4: hdmi: Remove firmware logic for MAI threshold setting
      drm/vc4: hdmi: Avoid full hdmi audio fifo writes

Duoming Zhou (3):
      mtd: sm_ftl: Fix deadlock caused by cancel_work_sync in sm_release
      mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv
      staging: rtl8192u: Fix sleep in atomic context bug in dm_fsync_timer_callback

Elia Devito (1):
      HID: Ignore battery for Elan touchscreen on HP Spectre X360 15-df0xxx

Eric Dumazet (6):
      net: fix sk_wmem_schedule() and sk_rmem_schedule() errors
      inet: add READ_ONCE(sk->sk_bound_dev_if) in INET_MATCH()
      tcp: sk->sk_bound_dev_if once in inet_request_bound_dev_if()
      ipv6: add READ_ONCE(sk->sk_bound_dev_if) in INET6_MATCH()
      net: rose: fix netdev reference changes
      tcp: fix over estimation in sk_forced_mem_schedule()

Eric Farman (1):
      vfio/ccw: Do not change FSM state in subchannel event

Eric Whitney (1):
      ext4: fix extent status tree race in writeback error recovery path

Eugen Hristev (1):
      mmc: sdhci-of-at91: fix set_uhs_signaling rewriting of MC1R

Florian Fainelli (1):
      tools/thermal: Fix possible path truncations

Florian Westphal (1):
      netfilter: nf_tables: fix null deref due to zeroed list head

Francis Laniel (1):
      arm64: Do not forget syscall when starting a new thread.

Gal Pressman (1):
      net/mlx5e: Remove WARN_ON when trying to offload an unsupported TLS cipher/version

Gao Xiang (1):
      erofs: avoid consecutive detection for Highmem memory

Geert Uytterhoeven (3):
      arm64: dts: renesas: beacon: Fix regulator node names
      soc: renesas: r8a779a0-sysc: Fix A2DP1 and A2CV[2357] PDR values
      arm64: dts: renesas: Fix thermal-sensors on single-zone sensors

Gioh Kim (1):
      RDMA/rtrs: Define MIN_CHUNK_SIZE

Greg Kroah-Hartman (2):
      Revert "mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv"
      Linux 5.10.137

Guilherme G. Piccoli (1):
      ACPI: processor/idle: Annotate more functions to live in cpuidle section

Guillaume Ranquet (1):
      drm/mediatek: dpi: Only enable dpi after the bridge is enabled

Guo Mengqi (1):
      spi: synquacer: Add missing clk_disable_unprepare()

Hangyu Hua (3):
      drm: bridge: sii8620: fix possible off-by-one
      wifi: libertas: Fix possible refcount leak in if_usb_probe()
      dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in the same lock

Hans de Goede (2):
      ACPI: EC: Remove duplicate ThinkPad X1 Carbon 6th entry from DMI quirks
      ACPI: EC: Drop the EC_FLAGS_IGNORE_DSDT_GPE quirk

Haoyue Xu (1):
      RDMA/hns: Fix incorrect clearing of interrupt status register

Harshit Mogalapalli (2):
      HID: cp2112: prevent a buffer overflow in cp2112_xfer()
      HID: mcp2221: prevent a buffer overflow in mcp_smbus_write()

Helge Deller (4):
      fbcon: Fix boundary checks for fbcon=vc:n1-n2 parameters
      fbcon: Fix accelerated fbdev scrolling while logo is still shown
      parisc: Fix device names in /proc/iomem
      parisc: io_pgetevents_time64() needs compat syscall in 32-bit compat mode

Huacai Chen (2):
      MIPS: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
      tpm: eventlog: Fix section mismatch for DEBUG_SECTION_MISMATCH

Ian Rogers (1):
      perf symbol: Fail to read phdr workaround

Ilpo Järvinen (1):
      serial: 8250_dw: Store LSR into lsr_saved_flags in dw8250_tx_wait_empty()

Ivan Hasenkampf (1):
      ALSA: hda/realtek: Add quirk for HP Spectre x360 15-eb0xxx

Jack Wang (2):
      RDMA/rtrs: Avoid Wtautological-constant-out-of-range-compare
      RDMA/rtrs-srv: Fix modinfo output for stringify

Jagath Jog J (2):
      iio: accel: bma400: Fix the scale min and max macro values
      iio: accel: bma400: Reordering of header files

Jakub Kicinski (1):
      netdevsim: Avoid allocation warnings triggered from user space

Jamal Hadi Salim (1):
      net_sched: cls_route: disallow handle of 0

Jan Kara (1):
      ext2: Add more validity checks for inode counts

Jason A. Donenfeld (4):
      fs: check FMODE_LSEEK to control internal pipe splicing
      wireguard: ratelimiter: use hrtimer in selftest
      wireguard: allowedips: don't corrupt stack when detecting overflow
      timekeeping: contribute wall clock to rng on time change

Jason Gunthorpe (4):
      vfio: Remove extra put/gets around vfio_device->group
      vfio: Simplify the lifetime logic for vfio_device
      vfio: Split creation of a vfio_device into init and register ops
      vfio/mdev: Make to_mdev_device() into a static inline

Javier Martinez Canillas (1):
      drm/st7735r: Fix module autoloading for Okaya RH128128T

Jens Wiklander (1):
      tee: add overflow check in register_shm_helper()

Jeongik Cha (1):
      wifi: mac80211_hwsim: fix race condition in pending packet

Jernej Skrabec (1):
      media: cedrus: hevc: Add check for invalid timestamp

Jiachen Zhang (1):
      ovl: drop WARN_ON() dentry is NULL in ovl_encode_fh()

Jian Shen (2):
      test_bpf: fix incorrect netdev features
      net: ionic: fix error check for vlan flags in ionic_set_nic_features()

Jian Zhang (1):
      drm/exynos/exynos7_drm_decon: free resources when clk_set_parent() failed.

Jianglei Nie (2):
      RDMA/qedr: Fix potential memory leak in __qedr_alloc_mr()
      RDMA/hfi1: fix potential memory leak in setup_base_ctxt()

Jiasheng Jiang (4):
      drm: bridge: adv7511: Add check for mipi_dsi_driver_register
      Bluetooth: hci_intel: Add check for platform_driver_register
      intel_th: msu-sink: Potential dereference of null pointer
      ASoC: codecs: da7210: add check for i2c_add_driver

Jim Mattson (2):
      KVM: x86/pmu: Use binary search to check filtered events
      KVM: x86/pmu: Use different raw event masks for AMD and Intel

Jitao Shi (2):
      drm/mediatek: Separate poweron/poweroff from enable/disable and define new funcs
      drm/mediatek: Keep dsi as LP00 before dcs cmds transfer

Joe Lawrence (1):
      selftests/livepatch: better synchronize test_klp_callbacks_busy

Johan Hovold (4):
      x86/pmem: Fix platform-device leak in error path
      ath11k: fix netdev open race
      usb: dwc3: qcom: fix missing optional irq warnings
      USB: serial: fix tty-port initialized comments

Johannes Berg (3):
      wifi: mac80211_hwsim: add back erroneously removed cast
      wifi: mac80211_hwsim: use 32-bit skb cookie
      um: Allow PM with suspend-to-idle

Jonas Dreßler (1):
      mwifiex: Ignore BTCOEX events from the 88W8897 firmware

Jose Alonso (1):
      Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"

Jose Ignacio Tornos Martinez (1):
      wifi: iwlwifi: mvm: fix double list_add at iwl_mvm_mac_wake_tx_queue

Josef Bacik (1):
      btrfs: reset block group chunk force if we have to wait

Josh Poimboeuf (1):
      scripts/faddr2line: Fix vmlinux detection on arm64

Julien STEPHAN (1):
      drm/mediatek: Allow commands to be sent during video mode

Juri Lelli (1):
      wait: Fix __wait_event_hrtimeout for RT/DL tasks

Kai Ye (1):
      crypto: hisilicon/sec - fix auth key size error

Keith Busch (1):
      block: fix infinite loop for invalid zone append

Kim Phillips (1):
      x86/bugs: Enable STIBP for IBPB mitigated RETBleed

Konrad Dybcio (1):
      soc: qcom: Make QCOM_RPMPD depend on PM

Krzysztof Kozlowski (6):
      ARM: dts: ast2500-evb: fix board compatible
      ARM: dts: ast2600-evb: fix board compatible
      ARM: dts: qcom: mdm9615: add missing PMIC GPIO reg
      ARM: dts: qcom: pm8841: add required thermal-sensor-cells
      ath10k: do not enforce interrupt trigger type
      ASoC: samsung: h1940_uda1380: include proepr GPIO consumer header

Kunihiko Hayashi (2):
      ARM: dts: uniphier: Fix USB interrupts for PXs2 SoC
      arm64: dts: uniphier: Fix USB interrupts for PXs3 SoC

Kuniyuki Iwashima (1):
      tcp: Fix data-races around sysctl_tcp_l3mdev_accept.

Lars-Peter Clausen (1):
      i2c: cadence: Support PEC for SMBus block read

Leo Li (1):
      drm/amdgpu: Check BO's requested pinning domains against its preferred_domains

Lev Kujawski (1):
      KVM: set_msr_mce: Permit guests to ignore single-bit ECC errors

Li Lingfeng (1):
      ext4: recover csum seed of tmp_inode after migrating to extents

Liang He (14):
      ARM: OMAP2+: display: Fix refcount leak bug
      ARM: shmobile: rcar-gen2: Increase refcount for new reference
      soc: amlogic: Fix refcount leak in meson-secure-pwrc.c
      regulator: of: Fix refcount leak bug in of_get_regulation_constraints()
      mediatek: mt76: mac80211: Fix missing of_node_put() in mt76_led_init()
      i2c: mux-gpmux: Add of_node_put() when breaking out of loop
      usb: aspeed-vhub: Fix refcount leak bug in ast_vhub_init_desc()
      gpio: gpiolib-of: Fix refcount bugs in of_mm_gpiochip_add_data()
      mmc: cavium-octeon: Add of_node_put() when breaking out of loop
      mmc: cavium-thunderx: Add of_node_put() when breaking out of loop
      ASoC: qcom: Fix missing of_node_put() in asoc_qcom_lpass_cpu_platform_probe()
      iommu/arm-smmu: qcom_iommu: Add of_node_put() when breaking out of loop
      ASoC: audio-graph-card: Add of_node_put() in fail path
      video: fbdev: amba-clcd: Fix refcount leak bugs

Like Xu (2):
      KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
      KVM: x86/pmu: Ignore pmu->global_ctrl check if vPMU doesn't support global_ctrl

Linus Walleij (2):
      Input: atmel_mxt_ts - fix up inverted RESET handler
      hwmon: (drivetemp) Add module alias

Linyu Yuan (1):
      usb: typec: ucsi: Acknowledge the GET_ERROR_STATUS command completion

Longfang Liu (1):
      crypto: hisilicon/sec - fixes some coding style

Lorenzo Bianconi (1):
      mt76: mt76x02u: fix possible memory leak in __mt76x02u_mcu_send_msg

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression

Lukas Czerner (2):
      ext4: check if directory block is within i_size
      ext4: make sure ext4_append() always allocates new block

Lukas Wunner (3):
      usbnet: Fix linkwatch use-after-free on disconnect
      usbnet: smsc95xx: Don't clear read-only PHY interrupt
      usbnet: smsc95xx: Avoid link settings race on interrupt reception

Luo Meng (1):
      dm thin: fix use-after-free crash in dm_sm_register_threshold_callback

Lv Ruyi (1):
      firmware: tegra: Fix error check return value of debugfs_create_file()

Lyude Paul (2):
      drm/nouveau: Don't pm_runtime_put_sync(), only pm_runtime_put_autosuspend()
      drm/nouveau/acpi: Don't print error when we get -EINPROGRESS from pm_runtime

Maciej Fijalkowski (1):
      selftests/xsk: Destroy BPF resources only when ctx refcount drops to 0

Maciej S. Szmigiero (1):
      KVM: SVM: Don't BUG if userspace injects an interrupt with GIF=0

Maciej W. Rozycki (4):
      serial: 8250: Export ICR access helpers for internal use
      serial: 8250: Dissociate 4MHz Titan ports from Oxford ports
      serial: 8250: Correct the clock for OxSemi PCIe devices
      serial: 8250: Fold EndRun device support into OxSemi Tornado code

Mahesh Rajashekhara (1):
      scsi: smartpqi: Fix DMA direction for RAID requests

Manikanta Pubbisetty (1):
      ath11k: Fix incorrect debug_mask mappings

Manyi Li (1):
      ACPI: PM: save NVS memory for Lenovo G40-45

Maor Gottlieb (1):
      RDMA/mlx5: Add missing check for return value in get namespace flow

Marcel Ziswiler (1):
      ARM: dts: imx7d-colibri-emmc: add cpu1 supply

Marco Pagani (1):
      fpga: altera-pr-ip: fix unsigned comparison with less than zero

Marek Vasut (3):
      drm/bridge: tc358767: Move (e)DP bridge endpoint parsing into dedicated function
      drm/bridge: tc358767: Make sure Refclk clock are enabled
      drm/bridge: tc358767: Fix (e)DP bridge endpoint parsing in dedicated function

Markus Mayer (1):
      thermal/tools/tmon: Include pthread and time headers in tmon.h

Mateusz Kwiatkowski (1):
      drm/vc4: hdmi: Fix timings for interlaced modes

Max Filippov (1):
      xtensa: iss/network: provide release() callback

Maxim Mikityanskiy (1):
      net/mlx5e: Fix the value of MLX5E_MAX_RQ_NUM_MTTS

Maxime Ripard (5):
      drm/vc4: drv: Remove the DSI pointer in vc4_drv
      drm/vc4: dsi: Use snprintf for the PHY clocks instead of an array
      drm/vc4: dsi: Introduce a variant structure
      drm/vc4: hdmi: Don't access the connector state in reset if kmalloc fails
      drm/vc4: hdmi: Limit the BCM2711 to the max without scrambling

Maximilian Heyne (1):
      xen-blkback: Apply 'feature_persistent' parameter when connect

Meng Tang (2):
      ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model
      ALSA: hda/realtek: Add quirk for another Asus K42JZ model

Miaohe Lin (1):
      mm/mmap.c: fix missing call to vm_unacct_memory in mmap_region

Miaoqian Lin (27):
      meson-mx-socinfo: Fix refcount leak in meson_mx_socinfo_init
      ARM: bcm: Fix refcount leak in bcm_kona_smc_init
      ARM: OMAP2+: Fix refcount leak in omapdss_init_of
      ARM: OMAP2+: Fix refcount leak in omap3xxx_prm_late_init
      cpufreq: zynq: Fix refcount leak in zynq_get_revision
      soc: qcom: ocmem: Fix refcount leak in of_get_ocmem
      soc: qcom: aoss: Fix refcount leak in qmp_cooling_devices_register
      drm/mcde: Fix refcount leak in mcde_dsi_bind
      media: tw686x: Fix memory leak in tw686x_video_init
      mtd: maps: Fix refcount leak in of_flash_probe_versatile
      mtd: maps: Fix refcount leak in ap_flash_init
      PCI: tegra194: Fix PM error handling in tegra_pcie_config_ep()
      mtd: partitions: Fix refcount leak in parse_redboot_of
      usb: host: Fix refcount leak in ehci_hcd_ppc_of_probe
      usb: ohci-nxp: Fix refcount leak in ohci_hcd_nxp_probe
      mmc: sdhci-of-esdhc: Fix refcount leak in esdhc_signal_voltage_switch
      ASoC: cros_ec_codec: Fix refcount leak in cros_ec_codec_platform_probe
      ASoC: samsung: Fix error handling in aries_audio_probe
      ASoC: mediatek: mt8173: Fix refcount leak in mt8173_rt5650_rt5676_dev_probe
      ASoC: mt6797-mt6351: Fix refcount leak in mt6797_mt6351_dev_probe
      ASoC: mediatek: mt8173-rt5650: Fix refcount leak in mt8173_rt5650_dev_probe
      remoteproc: k3-r5: Fix refcount leak in k3_r5_cluster_of_init
      rpmsg: qcom_smd: Fix refcount leak in qcom_smd_parse_edge
      mfd: max77620: Fix refcount leak in max77620_initialise_fps
      powerpc/spufs: Fix refcount leak in spufs_init_isolated_loader
      powerpc/xive: Fix refcount leak in xive_get_max_prio
      powerpc/cell/axon_msi: Fix refcount leak in setup_msi_msg_address

Michael Ellerman (3):
      powerpc/powernv: Avoid crashing if rng is NULL
      powerpc/64s: Disable stack variable initialisation for prom_init
      powerpc/pci: Fix PHB numbering when using opal-phbid

Michael Grzeschik (2):
      usb: dwc3: gadget: refactor dwc3_repare_one_trb
      usb: dwc3: gadget: fix high speed multiplier setting

Michael Walle (1):
      soc: fsl: guts: machine variable might be unset

Michal Suchanek (1):
      kexec, KEYS, s390: Make use of built-in and secondary keyring for signature verification

Mike Manning (1):
      net: allow unbound socket for packets in VRF when tcp_l3mdev_accept set

Mike Snitzer (1):
      dm: return early from dm_pr_call() if DM device is suspended

Miklos Szeredi (1):
      fuse: limit nsec

Mikulas Patocka (6):
      add barriers to buffer_uptodate and set_buffer_uptodate
      md-raid: destroy the bitmap after destroying the thread
      md-raid10: fix KASAN warning
      dm writecache: set a default MAX_WRITEBACK_JOBS
      dm raid: fix address sanitizer warning in raid_resume
      dm raid: fix address sanitizer warning in raid_status

Ming Lei (1):
      blk-mq: don't create hctx debugfs dir until q->debugfs_dir is created

Ming Qian (1):
      media: v4l2-mem2mem: prevent pollerr when last_buffer_dequeued is set

Miquel Raynal (6):
      mtd: rawnand: Add a helper to clarify the interface configuration
      mtd: rawnand: arasan: Check the proposed data interface is supported
      mtd: rawnand: Add NV-DDR timings
      mtd: rawnand: arasan: Fix a macro parameter
      mtd: rawnand: arasan: Support NV-DDR interface
      mtd: rawnand: arasan: Prevent an unsupported configuration

Mohamed Khalfella (1):
      PCI/AER: Iterate over error counters instead of error strings

Narendra Hadke (1):
      serial: mvebu-uart: uart2 error bits clearing

Nathan Chancellor (2):
      hexagon: select ARCH_WANT_LD_ORPHAN_WARN
      usb: cdns3: Don't use priv_dev uninitialized in cdns3_gadget_ep_enable()

Nick Desaulniers (2):
      Makefile: link with -z noexecstack --no-warn-rwx-segments
      x86: link vdso and boot with -z noexecstack --no-warn-rwx-segments

Nick Hainke (1):
      arm64: dts: mt7622: fix BPI-R64 WPS button

Nico Boehr (1):
      KVM: s390: pv: don't present the ecall interrupt twice

Nicolas Saenz Julienne (1):
      nohz/full, sched/rt: Fix missed tick-reenabling bug in dequeue_task_rt()

Niels Dossche (1):
      media: hdpvr: fix error value returns in hdpvr_read

Nilesh Javali (1):
      scsi: Revert "scsi: qla2xxx: Fix disk failure to rediscover"

Olga Kitaina (1):
      mtd: rawnand: arasan: Fix clock rate in NV-DDR

Pali Rohár (4):
      PCI: Add defines for normal and subtractive PCI bridges
      powerpc/fsl-pci: Fix Class Code of PCIe Root Port
      crypto: inside-secure - Add missing MODULE_DEVICE_TABLE for of
      powerpc/pci: Prefer PCI domain assignment via DT 'linux,pci-domain' and alias

Paolo Bonzini (1):
      KVM: x86/pmu: preserve IA32_PERF_CAPABILITIES across CPUID refresh

Pavel Skripkin (1):
      ath9k: fix use-after-free in ath9k_hif_usb_rx_cb

Peng Fan (1):
      interconnect: imx: fix max_node_id

Peter Zijlstra (1):
      locking/lockdep: Fix lockdep_init_map_*() confusion

Phil Elwell (1):
      drm/vc4: hdmi: Disable audio if dmas property is present but empty

Pierre-Louis Bossart (1):
      soundwire: bus_type: fix remove and shutdown support

Ping Cheng (2):
      HID: wacom: Only report rotation for art pen
      HID: wacom: Don't register pad_input for touch switch

Prabhakar Kushwaha (1):
      RDMA/qedr: Improve error logs for rdma_alloc_tid error return

Przemyslaw Patynowski (1):
      iavf: Fix max_rate limiting

Qian Cai (1):
      crypto: arm64/gcm - Select AEAD for GHASH_ARM64_CE

Qiao Ma (2):
      net: hinic: fix bug that ethtool get wrong stats
      net: hinic: avoid kernel hung in hinic_get_stats64()

Qiuxu Zhuo (1):
      PCI/ERR: Bind RCEC devices to the Root Port driver

Qu Wenruo (3):
      btrfs: reject log replay if there is unsupported RO compat flag
      btrfs: only write the sectors in the vertical stripe which has data stripes
      btrfs: raid56: don't trust any cached sector in __raid56_parity_recover()

Quentin Perret (1):
      KVM: arm64: Don't return from void function

Quinn Tran (2):
      scsi: qla2xxx: Turn off multi-queue for 8G adapters
      scsi: qla2xxx: Fix erroneous mailbox timeout after PCI error injection

Rafael J. Wysocki (2):
      thermal: sysfs: Fix cooling_device_stats_setup() error code path
      ACPI: CPPC: Do not prevent CPPC from working in the future

Ralph Siemsen (1):
      clk: renesas: r9a06g032: Fix UART clkgrp bitsel

Randy Dunlap (1):
      usb: gadget: udc: amd5536 depends on HAS_DMA

Rex-BC Chen (1):
      clk: mediatek: reset: Fix written reset bit offset

Rob Clark (1):
      drm/msm/mdp5: Fix global state lock backoff

Robert Marko (5):
      arm64: dts: qcom: ipq8074: fix NAND node name
      clk: qcom: ipq8074: fix NSS core PLL-s
      clk: qcom: ipq8074: SW workaround for UBI32 PLL lock
      clk: qcom: ipq8074: fix NSS port frequency tables
      clk: qcom: ipq8074: set BRANCH_HALT_DELAY flag for UBI clocks

Rohith Kollalsi (1):
      usb: dwc3: core: Do not perform GCTL_CORE_SOFTRESET during bootup

Russell King (Oracle) (1):
      ARM: findbit: fix overflowing offset

Rustam Subkhankulov (2):
      wifi: p54: add missing parentheses in p54_flush()
      video: fbdev: sis: fix typos in SiS_GetModeID()

Sam Protsenko (1):
      iommu/exynos: Handle failed IOMMU device registration properly

Samuel Holland (3):
      irqchip/mips-gic: Only register IPI domain when SMP is enabled
      genirq: GENERIC_IRQ_IPI depends on SMP
      arm64: dts: allwinner: a64: orangepi-win: Fix LED node name

Sean Christopherson (15):
      KVM: nVMX: Snapshot pre-VM-Enter BNDCFGS for !nested_run_pending case
      KVM: nVMX: Snapshot pre-VM-Enter DEBUGCTL for !nested_run_pending case
      KVM: nVMX: Let userspace set nVMX MSR to any _host_ supported value
      KVM: x86: Mark TSS busy during LTR emulation _after_ all fault checks
      KVM: x86: Set error code to segment selector on LLDT/LTR non-canonical #GP
      KVM: x86: Tag kvm_mmu_x86_module_init() with __init
      KVM: Don't set Accessed/Dirty bits for ZERO_PAGE
      KVM: x86: Signal #GP, not -EPERM, on bad WRMSR(MCi_CTL/STATUS)
      KVM: VMX: Drop guest CPUID check for VMXE in vmx_set_cr4()
      KVM: VMX: Drop explicit 'nested' check from vmx_set_cr4()
      KVM: SVM: Drop VMXE check from svm_set_cr4()
      KVM: x86: Move vendor CR4 validity check to dedicated kvm_x86_ops hook
      KVM: nVMX: Inject #UD if VMXON is attempted with incompatible CR0/CR4
      KVM: VMX: Mark all PERF_GLOBAL_(OVF)_CTRL bits reserved if there's no vPMU
      KVM: Add infrastructure and macro to mark VM as bugged

Sean V Kelley (8):
      PCI/AER: Write AER Capability only when we control it
      PCI/ERR: Rename reset_link() to reset_subordinates()
      PCI/ERR: Simplify by using pci_upstream_bridge()
      PCI/ERR: Simplify by computing pci_pcie_type() once
      PCI/ERR: Use "bridge" for clarity in pcie_do_recovery()
      PCI/ERR: Avoid negated conditional for clarity
      PCI/ERR: Add pci_walk_bridge() to pcie_do_recovery()
      PCI/ERR: Recover from RCEC AER errors

SeongJae Park (2):
      xen-blkback: fix persistent grants negotiation
      xen-blkfront: Apply 'feature_persistent' parameter when connect

Serge Semin (4):
      dmaengine: dw-edma: Fix eDMA Rd/Wr-channels and DMA-direction semantics
      PCI: dwc: Add unroll iATU space support to dw_pcie_disable_atu()
      PCI: dwc: Deallocate EPC memory on dw_pcie_ep_init() errors
      PCI: dwc: Always enable CDM check if "snps,enable-cdm-check" exists

Sergey Shtylyov (1):
      usb: host: xhci: use snprintf() in xhci_decode_trb()

Shengjiu Wang (1):
      ASoC: fsl_easrc: use snd_pcm_format_t type for sample_format

Shunsuke Mie (1):
      PCI: endpoint: Don't stop controller when unbinding endpoint function

Sibi Sankar (1):
      remoteproc: sysmon: Wait for SSCTL service to come up

Siddh Raman Pant (1):
      x86/numa: Use cpumask_available instead of hardcoded NULL check

Sireesh Kodali (1):
      remoteproc: qcom: wcnss: Fix handling of IRQs

Srinivas Kandagatla (2):
      ASoC: codecs: msm8916-wcd-digital: move gains from SX_TLV to S8_TLV
      ASoC: codecs: wcd9335: move gains from SX_TLV to S8_TLV

Stefan Roese (1):
      PCI/portdrv: Don't disable AER reporting in get_port_device_capability()

Steffen Maier (1):
      scsi: zfcp: Fix missing auto port scan and thus missing target ports

Stephan Gerhold (1):
      regulator: qcom_smd: Fix pm8916_pldo range

Stephen Boyd (1):
      platform/chrome: cros_ec: Always expose last resume result

Steven Rostedt (Google) (2):
      ftrace/x86: Add back ftrace_expected assignment
      tracing: Use a struct alignof to determine trace event field alignment

Sudeep Holla (1):
      firmware: arm_scpi: Ensure scpi_info is not assigned if the probe fails

Sumit Garg (1):
      arm64: dts: qcom: qcs404: Fix incorrect USB2 PHYs assignment

Suzuki K Poulose (1):
      coresight: Clear the connection field properly

Tadeusz Struk (1):
      sched/fair: Fix fault in reweight_entity

Tali Perry (2):
      i2c: npcm: Remove own slave addresses 2:10
      i2c: npcm: Correct slave role behavior

Tamás Szűcs (1):
      arm64: tegra: Fix SDMMC1 CD on P2888

Tang Bin (3):
      usb: gadget: tegra-xudc: Fix error check in tegra_xudc_powerdomain_init()
      usb: xhci: tegra: Fix error check
      opp: Fix error check in dev_pm_opp_attach_genpd()

Tetsuo Handa (4):
      tty: vt: initialize unicode screen buffer
      lockdep: Allow tuning tracing capacity constants.
      PM: hibernate: defer device probing when resuming from hibernation
      lib/smp_processor_id: fix imbalanced instrumentation_end() call

Thadeu Lima de Souza Cascardo (5):
      netfilter: nf_tables: do not allow SET_ID to refer to another table
      netfilter: nf_tables: do not allow CHAIN_ID to refer to another table
      netfilter: nf_tables: do not allow RULE_ID to refer to another chain
      posix-cpu-timers: Cleanup CPU timers before freeing them during exec
      net_sched: cls_route: remove from list when handle is 0

Theodore Ts'o (1):
      ext4: update s_overhead_clusters in the superblock during an on-line resize

Thinh Nguyen (1):
      usb: dwc3: core: Deprecate GCTL.CORESOFTRESET

Thomas Gleixner (1):
      netfilter: xtables: Bring SPDX identifier back

Tianchen Ding (1):
      sched: Fix the check of nr_running at queue wakelist

Tianjia Zhang (1):
      KEYS: asymmetric: enforce SM2 signature use pkey algo

Tim Crawford (1):
      ALSA: hda/realtek: Add quirk for Clevo NV45PZ

Timur Tabi (1):
      drm/nouveau: fix another off-by-one in nvbios_addr

Tom Lendacky (1):
      crypto: ccp - During shutdown, check SEV data pointer before using

Tom Rix (2):
      ASoC: samsung: change gpiod_speaker_power and rx1950_audio from global to static variables
      drm/vc4: change vc4_dma_range_matches from a global to static

Tony Battersby (1):
      scsi: sg: Allow waiting for commands to complete on removed device

Trond Myklebust (1):
      Revert "pNFS: nfs3_set_ds_client should set NFS_CS_NOPING"

Tyler Hicks (1):
      net/9p: Initialize the iounit field during fid creation

Uwe Kleine-König (6):
      pwm: sifive: Don't check the return code of pwmchip_remove()
      pwm: sifive: Simplify offset calculation for PWMCMP registers
      pwm: sifive: Ensure the clk is enabled exactly once per running PWM
      pwm: sifive: Shut down hardware only after pwmchip_remove() completed
      mtd: st_spi_fsm: Add a clk_disable_unprepare() in .probe()'s error path
      mfd: t7l66xb: Drop platform disable callback

Viacheslav Mitrofanov (1):
      dmaengine: sf-pdma: Add multithread support for a DMA channel

Vidya Sagar (2):
      PCI: tegra194: Fix Root Port interrupt handling
      PCI: tegra194: Fix link up retry sequence

Vincent Mailhol (10):
      can: pch_can: do not report txerr and rxerr during bus-off
      can: rcar_can: do not report txerr and rxerr during bus-off
      can: sja1000: do not report txerr and rxerr during bus-off
      can: hi311x: do not report txerr and rxerr during bus-off
      can: sun4i_can: do not report txerr and rxerr during bus-off
      can: kvaser_usb_hydra: do not report txerr and rxerr during bus-off
      can: kvaser_usb_leaf: do not report txerr and rxerr during bus-off
      can: usb_8dev: do not report txerr and rxerr during bus-off
      can: error: specify the values of data[5..7] of CAN error frames
      can: pch_can: pch_can_error(): initialize errc before using it

Vitaly Kuznetsov (2):
      KVM: x86: Check lapic_in_kernel() before attempting to set a SynIC irq
      KVM: x86: Avoid theoretical NULL pointer dereference in kvm_irq_delivery_to_apic_fast()

Vladimir Zapolskiy (1):
      clk: qcom: camcc-sdm845: Fix topology around titan_top power domain

Waiman Long (1):
      sched, cpuset: Fix dl_cpu_busy() panic due to empty cs->cpus_allowed

Weitao Wang (1):
      USB: HCD: Fix URB giveback issue in tasklet function

William Dean (3):
      parisc: Check the return value of ioremap() in lba_driver_probe()
      irqchip/mips-gic: Check the return value of ioremap() in gic_of_init()
      watchdog: armada_37xx_wdt: check the return value of devm_ioremap() in armada_37xx_wdt_probe()

Wolfram Sang (2):
      selftests: timers: valid-adjtimex: build fix for newer toolchains
      selftests: timers: clocksource-switch: fix passing errors from child

Wyes Karny (1):
      x86: Handle idle=nomwait cmdline properly for x86_idle

Xiaomeng Tong (2):
      media: [PATCH] pci: atomisp_cmd: fix three missing checks on list iterator
      virtio-gpu: fix a missing check to avoid NULL dereference

Xie Shaowen (1):
      Input: gscps2 - check return value of ioremap() in gscps2_probe()

Xie Yongji (1):
      fuse: Remove the control interface for virtio-fs

Xinlei Lee (2):
      drm/mediatek: Modify dsi funcs to atomic operations
      drm/mediatek: Add pull-down MIPI operation in mtk_dsi_poweroff function

Xiu Jianfeng (1):
      selinux: Add boundary check in put_entry()

Xu Wang (1):
      i2c: Fix a potential use after free

Yang Xu (1):
      fs: Add missing umask strip in vfs_tmpfile

Yang Yingliang (2):
      bus: hisi_lpc: fix missing platform_device_put() in hisi_lpc_acpi_probe()
      xtensa: iss: fix handling error cases in iss_net_configure()

Yangtao Li (1):
      pwm: lpc18xx-sct: Convert to devm_platform_ioremap_resource()

Ye Bin (1):
      ext4: fix warning in ext4_iomap_begin as race between bmap and write

YiFei Zhu (1):
      selftests/seccomp: Fix compile warning when CC=clang

Yonglong Li (1):
      tcp: make retransmitted SKB fit into the send window

Yunhao Tian (1):
      drm/mipi-dbi: align max_chunk to 2 in spi_transfer

Zhang Wensheng (1):
      driver core: fix potential deadlock in __driver_attach

Zhang Yi (1):
      jbd2: fix outstanding credits assert in jbd2_journal_commit_transaction()

Zhengchao Shao (3):
      crypto: hisilicon/sec - don't sleep when in softirq
      crypto: hisilicon - Kunpeng916 crypto driver don't sleep when in softirq
      crypto: hisilicon/hpre - don't use GFP_KERNEL to alloc mem during softirq

Zhenguo Zhao (1):
      tty: n_gsm: Delete gsmtty open SABM frame when config requester

Zheyu Ma (7):
      ALSA: bcd2000: Fix a UAF bug on the error path of probing
      iio: light: isl29028: Fix the warning in isl29028_remove()
      media: tw686x: Register the irq at the end of probe
      video: fbdev: arkfb: Fix a divide-by-zero bug in ark_set_pixclock()
      video: fbdev: vt8623fb: Check the size of screen before memset_io()
      video: fbdev: arkfb: Check the size of screen before memset_io()
      video: fbdev: s3fb: Check the size of screen before memset_io()

Zhihao Cheng (1):
      jbd2: fix assertion 'jh->b_frozen_data == NULL' failure when journal aborted

Zhu Yanjun (1):
      RDMA/rxe: Fix error unwind in rxe_create_qp()

Zoltan Tamas Vajda (1):
      HID: hid-input: add Surface Go battery quirk

haibinzhang (张海斌) (1):
      arm64: fix oops in concurrently setting insn_emulation sysctls

huhai (1):
      ACPI: LPSS: Fix missing check in register_device_clock()

