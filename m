Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1D6E596FCF
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 15:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbiHQNY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 09:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236994AbiHQNY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 09:24:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E2E6CF5B;
        Wed, 17 Aug 2022 06:24:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D49BBB81DCD;
        Wed, 17 Aug 2022 13:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A3DC433D6;
        Wed, 17 Aug 2022 13:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660742691;
        bh=aycftrf+4fns5qsvsikEURhQ/P3pPpU1Rj1MKtPgdrk=;
        h=From:To:Cc:Subject:Date:From;
        b=W8974epjL5wnLlGIElGJb8jSpN1yYoI62zRiTwUUCVZyZp6p2fZ9CF2Phu03Dxnp1
         iQCK5eryc92+XER/Dpf79U2KR5cjqWYHJquusw11hO38Cx9nFFmOKVH/TUwt4RmQ5N
         Z+xrSfAaz/wLvOOIum2faDL2rAZzwVYtFbGi3PkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.61
Date:   Wed, 17 Aug 2022 15:24:47 +0200
Message-Id: <1660742687133105@kroah.com>
X-Mailer: git-send-email 2.37.2
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

I'm announcing the release of the 5.15.61 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-driver-xen-blkback             |    2 
 Documentation/ABI/testing/sysfs-driver-xen-blkfront            |    2 
 Documentation/admin-guide/device-mapper/writecache.rst         |   16 
 Documentation/admin-guide/kernel-parameters.txt                |   29 
 Documentation/admin-guide/pm/cpuidle.rst                       |   15 
 Documentation/devicetree/bindings/iio/accel/adi,adxl355.yaml   |   88 
 Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml   |    6 
 Documentation/tty/device_drivers/oxsemi-tornado.rst            |  129 +
 Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst      |    6 
 Makefile                                                       |    7 
 arch/Kconfig                                                   |    3 
 arch/arm/boot/dts/Makefile                                     |    1 
 arch/arm/boot/dts/aspeed-ast2500-evb.dts                       |    2 
 arch/arm/boot/dts/aspeed-ast2600-evb-a1.dts                    |    1 
 arch/arm/boot/dts/aspeed-ast2600-evb.dts                       |    2 
 arch/arm/boot/dts/bcm53015-meraki-mr26.dts                     |  166 +
 arch/arm/boot/dts/imx6ul.dtsi                                  |   33 
 arch/arm/boot/dts/imx7d-colibri-emmc.dtsi                      |    4 
 arch/arm/boot/dts/qcom-mdm9615.dtsi                            |    1 
 arch/arm/boot/dts/qcom-msm8974.dtsi                            |    2 
 arch/arm/boot/dts/qcom-pm8841.dtsi                             |    1 
 arch/arm/boot/dts/qcom-sdx55.dtsi                              |    2 
 arch/arm/boot/dts/ste-ux500-samsung-codina.dts                 |    4 
 arch/arm/boot/dts/ste-ux500-samsung-gavini.dts                 |    4 
 arch/arm/boot/dts/uniphier-pxs2.dtsi                           |    8 
 arch/arm/crypto/Kconfig                                        |    2 
 arch/arm/crypto/Makefile                                       |    4 
 arch/arm/crypto/blake2s-shash.c                                |   75 
 arch/arm/include/asm/entry-macro-multi.S                       |   24 
 arch/arm/include/asm/smp.h                                     |    5 
 arch/arm/kernel/smp.c                                          |    5 
 arch/arm/lib/findbit.S                                         |   16 
 arch/arm/mach-bcm/bcm_kona_smc.c                               |    1 
 arch/arm/mach-omap2/display.c                                  |    3 
 arch/arm/mach-omap2/pdata-quirks.c                             |    2 
 arch/arm/mach-omap2/prm3xxx.c                                  |    1 
 arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c             |    5 
 arch/arm/mach-zynq/common.c                                    |    1 
 arch/arm64/Kconfig                                             |    1 
 arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts      |    2 
 arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts       |    2 
 arch/arm64/boot/dts/mediatek/mt8192.dtsi                       |   26 
 arch/arm64/boot/dts/nvidia/tegra186.dtsi                       |    3 
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi                 |    2 
 arch/arm64/boot/dts/nvidia/tegra194.dtsi                       |    3 
 arch/arm64/boot/dts/nvidia/tegra234.dtsi                       |   17 
 arch/arm64/boot/dts/qcom/ipq8074.dtsi                          |    2 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                          |    4 
 arch/arm64/boot/dts/qcom/qcs404.dtsi                           |    4 
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi                   |    1 
 arch/arm64/boot/dts/qcom/sdm630.dtsi                           |    7 
 arch/arm64/boot/dts/qcom/sdm636-sony-xperia-ganges-mermaid.dts |    2 
 arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts   |   36 
 arch/arm64/boot/dts/qcom/sm6125.dtsi                           |   30 
 arch/arm64/boot/dts/qcom/sm8250.dtsi                           |    6 
 arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi      |    6 
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi                      |    2 
 arch/arm64/boot/dts/renesas/r8a77990.dtsi                      |    2 
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi               |    8 
 arch/arm64/crypto/Kconfig                                      |    1 
 arch/arm64/include/asm/processor.h                             |    3 
 arch/arm64/kernel/armv8_deprecated.c                           |    9 
 arch/arm64/kernel/cpufeature.c                                 |    2 
 arch/arm64/kernel/hibernate.c                                  |    5 
 arch/arm64/kernel/mte.c                                        |    9 
 arch/arm64/kvm/hyp/nvhe/switch.c                               |    2 
 arch/arm64/kvm/hyp/vhe/switch.c                                |    2 
 arch/arm64/mm/copypage.c                                       |    9 
 arch/arm64/mm/mteswap.c                                        |    9 
 arch/ia64/include/asm/processor.h                              |    2 
 arch/mips/kernel/proc.c                                        |    2 
 arch/mips/kernel/vdso.c                                        |    2 
 arch/mips/mm/physaddr.c                                        |   14 
 arch/parisc/kernel/cache.c                                     |    3 
 arch/parisc/kernel/drivers.c                                   |    9 
 arch/parisc/kernel/syscalls/syscall.tbl                        |    2 
 arch/powerpc/include/asm/archrandom.h                          |    5 
 arch/powerpc/include/asm/simple_spinlock.h                     |   15 
 arch/powerpc/kernel/Makefile                                   |    1 
 arch/powerpc/kernel/iommu.c                                    |    5 
 arch/powerpc/kernel/pci-common.c                               |   29 
 arch/powerpc/kvm/book3s_hv_builtin.c                           |    7 
 arch/powerpc/mm/nohash/8xx.c                                   |    4 
 arch/powerpc/mm/pgtable_32.c                                   |    6 
 arch/powerpc/mm/ptdump/shared.c                                |    6 
 arch/powerpc/perf/core-book3s.c                                |   35 
 arch/powerpc/platforms/Kconfig.cputype                         |    4 
 arch/powerpc/platforms/cell/axon_msi.c                         |    1 
 arch/powerpc/platforms/cell/spufs/inode.c                      |    1 
 arch/powerpc/platforms/powernv/rng.c                           |   34 
 arch/powerpc/sysdev/fsl_pci.c                                  |    8 
 arch/powerpc/sysdev/fsl_pci.h                                  |    1 
 arch/powerpc/sysdev/xive/spapr.c                               |    1 
 arch/riscv/kernel/crash_save_regs.S                            |    2 
 arch/riscv/kernel/machine_kexec.c                              |   28 
 arch/riscv/kernel/probes/uprobes.c                             |    6 
 arch/riscv/kernel/reset.c                                      |   12 
 arch/riscv/mm/init.c                                           |    4 
 arch/s390/include/asm/ctl_reg.h                                |   16 
 arch/s390/include/asm/gmap.h                                   |    2 
 arch/s390/include/asm/os_info.h                                |    2 
 arch/s390/include/asm/processor.h                              |   19 
 arch/s390/include/asm/uaccess.h                                |    2 
 arch/s390/kernel/asm-offsets.c                                 |    2 
 arch/s390/kernel/crash_dump.c                                  |   58 
 arch/s390/kernel/ipl.c                                         |    4 
 arch/s390/kernel/machine_kexec.c                               |    2 
 arch/s390/kernel/machine_kexec_file.c                          |   18 
 arch/s390/kernel/os_info.c                                     |   12 
 arch/s390/kernel/setup.c                                       |   19 
 arch/s390/kernel/smp.c                                         |   57 
 arch/s390/kvm/intercept.c                                      |   15 
 arch/s390/kvm/pv.c                                             |    9 
 arch/s390/kvm/sigp.c                                           |    4 
 arch/s390/mm/gmap.c                                            |   86 
 arch/s390/mm/maccess.c                                         |    4 
 arch/um/drivers/random.c                                       |    2 
 arch/um/include/asm/archrandom.h                               |   30 
 arch/um/include/asm/xor.h                                      |    2 
 arch/um/include/shared/os.h                                    |    7 
 arch/um/kernel/um_arch.c                                       |    8 
 arch/um/os-Linux/util.c                                        |    6 
 arch/x86/Kconfig                                               |    1 
 arch/x86/Kconfig.debug                                         |    3 
 arch/x86/boot/Makefile                                         |    2 
 arch/x86/boot/compressed/Makefile                              |    4 
 arch/x86/crypto/Makefile                                       |    4 
 arch/x86/crypto/blake2s-glue.c                                 |    3 
 arch/x86/crypto/blake2s-shash.c                                |   77 
 arch/x86/entry/Makefile                                        |    3 
 arch/x86/entry/thunk_32.S                                      |    2 
 arch/x86/entry/thunk_64.S                                      |    4 
 arch/x86/entry/vdso/Makefile                                   |    2 
 arch/x86/include/asm/kvm_host.h                                |    3 
 arch/x86/kernel/cpu/bugs.c                                     |   10 
 arch/x86/kernel/cpu/intel.c                                    |   27 
 arch/x86/kernel/ftrace.c                                       |    1 
 arch/x86/kernel/kprobes/core.c                                 |   18 
 arch/x86/kernel/pmem.c                                         |    7 
 arch/x86/kernel/process.c                                      |    9 
 arch/x86/kvm/emulate.c                                         |   23 
 arch/x86/kvm/mmu/mmu.c                                         |    2 
 arch/x86/kvm/svm/nested.c                                      |    3 
 arch/x86/kvm/svm/svm.c                                         |   29 
 arch/x86/kvm/vmx/nested.c                                      |  107 -
 arch/x86/kvm/vmx/nested.h                                      |    3 
 arch/x86/kvm/vmx/pmu_intel.c                                   |   13 
 arch/x86/kvm/vmx/vmx.c                                         |    4 
 arch/x86/kvm/vmx/vmx.h                                         |   12 
 arch/x86/kvm/x86.c                                             |   31 
 arch/x86/kvm/x86.h                                             |    2 
 arch/x86/mm/extable.c                                          |   16 
 arch/x86/mm/numa.c                                             |    4 
 arch/x86/platform/olpc/olpc-xo1-sci.c                          |    2 
 arch/x86/um/Makefile                                           |    3 
 arch/xtensa/platforms/iss/network.c                            |   42 
 block/bio.c                                                    |   99 
 block/blk-iocost.c                                             |   20 
 block/blk-iolatency.c                                          |   18 
 block/blk-mq-debugfs.c                                         |    3 
 block/blk-rq-qos.h                                             |   11 
 block/blk-wbt.c                                                |   12 
 crypto/Kconfig                                                 |   20 
 crypto/Makefile                                                |    1 
 crypto/asymmetric_keys/public_key.c                            |    7 
 crypto/blake2s_generic.c                                       |   75 
 crypto/tcrypt.c                                                |   12 
 crypto/testmgr.c                                               |   24 
 crypto/testmgr.h                                               |  217 --
 drivers/acpi/acpi_lpss.c                                       |    3 
 drivers/acpi/apei/einj.c                                       |    2 
 drivers/acpi/apei/ghes.c                                       |   19 
 drivers/acpi/bus.c                                             |    3 
 drivers/acpi/cppc_acpi.c                                       |   54 
 drivers/acpi/ec.c                                              |   82 
 drivers/acpi/pci_root.c                                        |    3 
 drivers/acpi/processor_idle.c                                  |    6 
 drivers/acpi/sleep.c                                           |    8 
 drivers/acpi/viot.c                                            |   26 
 drivers/android/binder.c                                       |  114 -
 drivers/android/binder_alloc.c                                 |   30 
 drivers/android/binder_alloc.h                                 |    2 
 drivers/android/binder_alloc_selftest.c                        |    2 
 drivers/android/binder_internal.h                              |   46 
 drivers/android/binderfs.c                                     |   47 
 drivers/base/dd.c                                              |    5 
 drivers/base/power/domain.c                                    |    3 
 drivers/block/null_blk/main.c                                  |   14 
 drivers/block/rnbd/rnbd-srv.c                                  |   15 
 drivers/block/xen-blkback/xenbus.c                             |   20 
 drivers/block/xen-blkfront.c                                   |    4 
 drivers/bluetooth/hci_intel.c                                  |    6 
 drivers/bus/hisi_lpc.c                                         |   10 
 drivers/clk/mediatek/reset.c                                   |    4 
 drivers/clk/qcom/camcc-sdm845.c                                |    4 
 drivers/clk/qcom/camcc-sm8250.c                                |   16 
 drivers/clk/qcom/clk-krait.c                                   |    7 
 drivers/clk/qcom/clk-rcg2.c                                    |   16 
 drivers/clk/qcom/gcc-ipq8074.c                                 |   60 
 drivers/clk/qcom/gcc-msm8939.c                                 |   33 
 drivers/clk/renesas/r9a06g032-clocks.c                         |    8 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c            |    1 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c              |   22 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c              |   15 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h                   |    4 
 drivers/crypto/ccp/sev-dev.c                                   |   12 
 drivers/crypto/hisilicon/hpre/hpre_crypto.c                    |    2 
 drivers/crypto/hisilicon/sec/sec_algs.c                        |   14 
 drivers/crypto/hisilicon/sec/sec_drv.h                         |    2 
 drivers/crypto/hisilicon/sec2/sec.h                            |    2 
 drivers/crypto/hisilicon/sec2/sec_crypto.c                     |   26 
 drivers/crypto/hisilicon/sec2/sec_crypto.h                     |    1 
 drivers/crypto/inside-secure/safexcel.c                        |    2 
 drivers/dma/dw-edma/dw-edma-core.c                             |    2 
 drivers/dma/imx-dma.c                                          |    2 
 drivers/dma/sf-pdma/sf-pdma.c                                  |   44 
 drivers/firmware/Kconfig                                       |    1 
 drivers/firmware/arm_scpi.c                                    |   61 
 drivers/firmware/arm_sdei.c                                    |   13 
 drivers/firmware/tegra/bpmp-debugfs.c                          |   10 
 drivers/fpga/altera-pr-ip-core.c                               |    2 
 drivers/gpio/gpiolib-of.c                                      |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c               |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c                         |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                     |    4 
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c                   |   24 
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c                     |    2 
 drivers/gpu/drm/bridge/panel.c                                 |   37 
 drivers/gpu/drm/bridge/sil-sii8620.c                           |    4 
 drivers/gpu/drm/bridge/tc358767.c                              |   30 
 drivers/gpu/drm/drm_bridge.c                                   |    7 
 drivers/gpu/drm/drm_dp_aux_bus.c                               |    4 
 drivers/gpu/drm/drm_dp_mst_topology.c                          |    7 
 drivers/gpu/drm/drm_gem.c                                      |    4 
 drivers/gpu/drm/drm_gem_shmem_helper.c                         |  132 -
 drivers/gpu/drm/drm_mipi_dbi.c                                 |    7 
 drivers/gpu/drm/drm_of.c                                       |    3 
 drivers/gpu/drm/exynos/exynos7_drm_decon.c                     |   17 
 drivers/gpu/drm/hyperv/hyperv_drm_modeset.c                    |    2 
 drivers/gpu/drm/lima/lima_gem.c                                |   18 
 drivers/gpu/drm/lima/lima_sched.c                              |    4 
 drivers/gpu/drm/mcde/mcde_dsi.c                                |    1 
 drivers/gpu/drm/mediatek/mtk_dpi.c                             |   33 
 drivers/gpu/drm/mediatek/mtk_dsi.c                             |  126 -
 drivers/gpu/drm/meson/Kconfig                                  |    2 
 drivers/gpu/drm/meson/meson_dw_hdmi.c                          |    1 
 drivers/gpu/drm/meson/meson_encoder_hdmi.c                     |   96 
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c                       |   26 
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c                      |    5 
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.h                      |    3 
 drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c                     |   19 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c                      |    8 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.h                       |    5 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c                      |    3 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c                     |   21 
 drivers/gpu/drm/msm/msm_atomic.c                               |   15 
 drivers/gpu/drm/msm/msm_drv.h                                  |    6 
 drivers/gpu/drm/msm/msm_fb.c                                   |   43 
 drivers/gpu/drm/nouveau/nouveau_connector.c                    |    8 
 drivers/gpu/drm/nouveau/nouveau_display.c                      |    4 
 drivers/gpu/drm/nouveau/nouveau_fbcon.c                        |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c                |    2 
 drivers/gpu/drm/panel/Kconfig                                  |    2 
 drivers/gpu/drm/panfrost/panfrost_drv.c                        |    2 
 drivers/gpu/drm/panfrost/panfrost_gem.c                        |   20 
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c               |    2 
 drivers/gpu/drm/panfrost/panfrost_mmu.c                        |    5 
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c                    |    6 
 drivers/gpu/drm/radeon/.gitignore                              |    2 
 drivers/gpu/drm/radeon/Kconfig                                 |    2 
 drivers/gpu/drm/radeon/Makefile                                |    2 
 drivers/gpu/drm/radeon/ni_dpm.c                                |    6 
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c                |   10 
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c                    |    3 
 drivers/gpu/drm/tiny/st7735r.c                                 |    1 
 drivers/gpu/drm/v3d/v3d_bo.c                                   |   22 
 drivers/gpu/drm/vc4/vc4_crtc.c                                 |   10 
 drivers/gpu/drm/vc4/vc4_drv.c                                  |   19 
 drivers/gpu/drm/vc4/vc4_dsi.c                                  |  187 +
 drivers/gpu/drm/vc4/vc4_hdmi.c                                 |   40 
 drivers/gpu/drm/vc4/vc4_hdmi_regs.h                            |    3 
 drivers/gpu/drm/vc4/vc4_plane.c                                |   30 
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                         |    6 
 drivers/gpu/drm/virtio/virtgpu_object.c                        |   31 
 drivers/hid/amd-sfh-hid/amd_sfh_client.c                       |    2 
 drivers/hid/amd-sfh-hid/amd_sfh_hid.c                          |   12 
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c                         |    3 
 drivers/hid/hid-alps.c                                         |    2 
 drivers/hid/hid-cp2112.c                                       |    5 
 drivers/hid/hid-ids.h                                          |    1 
 drivers/hid/hid-input.c                                        |    2 
 drivers/hid/hid-mcp2221.c                                      |    3 
 drivers/hid/wacom_sys.c                                        |    2 
 drivers/hid/wacom_wac.c                                        |   72 
 drivers/hwmon/dell-smm-hwmon.c                                 |    8 
 drivers/hwmon/drivetemp.c                                      |    1 
 drivers/hwmon/sht15.c                                          |   17 
 drivers/hwtracing/coresight/coresight-core.c                   |    1 
 drivers/hwtracing/intel_th/msu-sink.c                          |    3 
 drivers/hwtracing/intel_th/msu.c                               |   14 
 drivers/hwtracing/intel_th/pci.c                               |   25 
 drivers/i2c/busses/i2c-cadence.c                               |   10 
 drivers/i2c/busses/i2c-mxs.c                                   |    2 
 drivers/i2c/busses/i2c-npcm7xx.c                               |   50 
 drivers/i2c/i2c-core-base.c                                    |    3 
 drivers/i2c/muxes/i2c-mux-gpmux.c                              |    1 
 drivers/iio/accel/bma400.h                                     |   23 
 drivers/iio/accel/bma400_core.c                                |    4 
 drivers/iio/accel/cros_ec_accel_legacy.c                       |    4 
 drivers/iio/common/cros_ec_sensors/cros_ec_lid_angle.c         |    4 
 drivers/iio/common/cros_ec_sensors/cros_ec_sensors.c           |    6 
 drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c      |   58 
 drivers/iio/imu/inv_mpu6050/inv_mpu_magn.c                     |   36 
 drivers/iio/industrialio-core.c                                |   18 
 drivers/iio/light/cros_ec_light_prox.c                         |    6 
 drivers/iio/light/isl29028.c                                   |    2 
 drivers/iio/pressure/cros_ec_baro.c                            |    6 
 drivers/infiniband/hw/hfi1/file_ops.c                          |    4 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                     |    4 
 drivers/infiniband/hw/irdma/cm.c                               |   11 
 drivers/infiniband/hw/irdma/hw.c                               |   15 
 drivers/infiniband/hw/irdma/verbs.c                            |    2 
 drivers/infiniband/hw/mlx5/fs.c                                |    6 
 drivers/infiniband/hw/qedr/verbs.c                             |    8 
 drivers/infiniband/sw/rxe/rxe_comp.c                           |   12 
 drivers/infiniband/sw/rxe/rxe_cq.c                             |   25 
 drivers/infiniband/sw/rxe/rxe_loc.h                            |    2 
 drivers/infiniband/sw/rxe/rxe_mr.c                             |   12 
 drivers/infiniband/sw/rxe/rxe_mw.c                             |    7 
 drivers/infiniband/sw/rxe/rxe_qp.c                             |   26 
 drivers/infiniband/sw/rxe/rxe_queue.c                          |   30 
 drivers/infiniband/sw/rxe/rxe_queue.h                          |  292 +-
 drivers/infiniband/sw/rxe/rxe_req.c                            |   45 
 drivers/infiniband/sw/rxe/rxe_resp.c                           |   40 
 drivers/infiniband/sw/rxe/rxe_srq.c                            |    3 
 drivers/infiniband/sw/rxe/rxe_verbs.c                          |   56 
 drivers/infiniband/sw/rxe/rxe_verbs.h                          |    3 
 drivers/infiniband/sw/siw/siw_cm.c                             |    7 
 drivers/infiniband/ulp/iser/iscsi_iser.c                       |    4 
 drivers/infiniband/ulp/rtrs/rtrs-clt-stats.c                   |    8 
 drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c                   |  123 -
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                         | 1062 +++++-----
 drivers/infiniband/ulp/rtrs/rtrs-clt.h                         |   22 
 drivers/infiniband/ulp/rtrs/rtrs-pri.h                         |   39 
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c                   |  121 -
 drivers/infiniband/ulp/rtrs/rtrs-srv.c                         |  659 +++---
 drivers/infiniband/ulp/rtrs/rtrs-srv.h                         |   12 
 drivers/infiniband/ulp/rtrs/rtrs.c                             |  127 -
 drivers/infiniband/ulp/rtrs/rtrs.h                             |    7 
 drivers/infiniband/ulp/srpt/ib_srpt.c                          |  148 -
 drivers/infiniband/ulp/srpt/ib_srpt.h                          |   18 
 drivers/input/serio/gscps2.c                                   |    4 
 drivers/interconnect/imx/imx.c                                 |    8 
 drivers/iommu/arm/arm-smmu/qcom_iommu.c                        |    7 
 drivers/iommu/exynos-iommu.c                                   |    6 
 drivers/iommu/intel/dmar.c                                     |    2 
 drivers/irqchip/Kconfig                                        |    5 
 drivers/irqchip/irq-mips-gic.c                                 |   84 
 drivers/md/dm-raid.c                                           |    4 
 drivers/md/dm-thin-metadata.c                                  |    7 
 drivers/md/dm-thin.c                                           |    4 
 drivers/md/dm-writecache.c                                     |   43 
 drivers/md/dm.c                                                |    5 
 drivers/md/md.c                                                |    2 
 drivers/md/raid10.c                                            |    5 
 drivers/media/pci/tw686x/tw686x-core.c                         |   18 
 drivers/media/pci/tw686x/tw686x-video.c                        |    4 
 drivers/media/platform/atmel/atmel-sama7g5-isc.c               |    2 
 drivers/media/platform/imx-jpeg/mxc-jpeg-hw.c                  |    5 
 drivers/media/platform/imx-jpeg/mxc-jpeg-hw.h                  |    9 
 drivers/media/platform/imx-jpeg/mxc-jpeg.c                     |  523 +++-
 drivers/media/platform/imx-jpeg/mxc-jpeg.h                     |    7 
 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h                   |    2 
 drivers/media/usb/hdpvr/hdpvr-video.c                          |    2 
 drivers/media/v4l2-core/v4l2-mem2mem.c                         |    2 
 drivers/memstick/core/ms_block.c                               |   11 
 drivers/mfd/max77620.c                                         |    2 
 drivers/mfd/t7l66xb.c                                          |    6 
 drivers/misc/cardreader/rtsx_pcr.c                             |    6 
 drivers/misc/eeprom/idt_89hpesx.c                              |    8 
 drivers/mmc/core/block.c                                       |   28 
 drivers/mmc/host/cavium-octeon.c                               |    1 
 drivers/mmc/host/cavium-thunderx.c                             |    4 
 drivers/mmc/host/mxcmmc.c                                      |    2 
 drivers/mmc/host/renesas_sdhi_core.c                           |    8 
 drivers/mmc/host/sdhci-of-at91.c                               |    9 
 drivers/mmc/host/sdhci-of-esdhc.c                              |    1 
 drivers/mtd/devices/mtd_dataflash.c                            |    8 
 drivers/mtd/devices/st_spi_fsm.c                               |    8 
 drivers/mtd/maps/physmap-versatile.c                           |    2 
 drivers/mtd/nand/raw/arasan-nand-controller.c                  |   16 
 drivers/mtd/nand/raw/meson_nand.c                              |    1 
 drivers/mtd/parsers/ofpart_bcm4908.c                           |    3 
 drivers/mtd/parsers/redboot.c                                  |    1 
 drivers/mtd/sm_ftl.c                                           |    2 
 drivers/mtd/spi-nor/core.c                                     |    6 
 drivers/net/can/dev/netlink.c                                  |    6 
 drivers/net/can/pch_can.c                                      |    8 
 drivers/net/can/rcar/rcar_can.c                                |    8 
 drivers/net/can/sja1000/sja1000.c                              |    7 
 drivers/net/can/spi/hi311x.c                                   |    5 
 drivers/net/can/sun4i_can.c                                    |    9 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c              |   12 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c               |    6 
 drivers/net/can/usb/usb_8dev.c                                 |    7 
 drivers/net/ethernet/huawei/hinic/hinic_dev.h                  |    3 
 drivers/net/ethernet/huawei/hinic/hinic_main.c                 |   68 
 drivers/net/ethernet/huawei/hinic/hinic_rx.c                   |    2 
 drivers/net/ethernet/huawei/hinic/hinic_tx.c                   |    2 
 drivers/net/ethernet/intel/iavf/iavf.h                         |    6 
 drivers/net/ethernet/intel/iavf/iavf_main.c                    |   46 
 drivers/net/ethernet/mellanox/mlx5/core/en.h                   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c        |    2 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                 |    2 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                |    2 
 drivers/net/netdevsim/bpf.c                                    |    8 
 drivers/net/netdevsim/fib.c                                    |   27 
 drivers/net/phy/smsc.c                                         |    6 
 drivers/net/usb/Kconfig                                        |    3 
 drivers/net/usb/ax88179_178a.c                                 |   20 
 drivers/net/usb/smsc95xx.c                                     |  157 -
 drivers/net/usb/usbnet.c                                       |    8 
 drivers/net/wireguard/allowedips.c                             |    9 
 drivers/net/wireguard/selftest/allowedips.c                    |    6 
 drivers/net/wireguard/selftest/ratelimiter.c                   |   25 
 drivers/net/wireless/ath/ath10k/snoc.c                         |    5 
 drivers/net/wireless/ath/ath11k/core.c                         |   16 
 drivers/net/wireless/ath/ath11k/debug.h                        |    4 
 drivers/net/wireless/ath/ath11k/mac.c                          |    2 
 drivers/net/wireless/ath/ath9k/htc.h                           |   10 
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                  |    3 
 drivers/net/wireless/ath/wil6210/debugfs.c                     |   18 
 drivers/net/wireless/intel/iwlegacy/4965-rs.c                  |    5 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                   |    4 
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                   |    1 
 drivers/net/wireless/intersil/p54/main.c                       |    2 
 drivers/net/wireless/intersil/p54/p54spi.c                     |    3 
 drivers/net/wireless/mac80211_hwsim.c                          |   14 
 drivers/net/wireless/marvell/libertas/if_usb.c                 |    1 
 drivers/net/wireless/marvell/mwifiex/main.h                    |    2 
 drivers/net/wireless/marvell/mwifiex/pcie.c                    |    3 
 drivers/net/wireless/marvell/mwifiex/sta_event.c               |    3 
 drivers/net/wireless/mediatek/mt76/eeprom.c                    |    5 
 drivers/net/wireless/mediatek/mt76/mac80211.c                  |    1 
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c                |    9 
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c           |    2 
 drivers/net/wireless/mediatek/mt76/mt7915/init.c               |    4 
 drivers/net/wireless/mediatek/mt76/mt7921/init.c               |    6 
 drivers/net/wireless/realtek/rtlwifi/debug.c                   |    8 
 drivers/net/wireless/realtek/rtw88/main.c                      |    4 
 drivers/nvme/host/core.c                                       |   44 
 drivers/nvme/host/multipath.c                                  |    1 
 drivers/nvme/host/trace.h                                      |    2 
 drivers/of/device.c                                            |    5 
 drivers/of/fdt.c                                               |    2 
 drivers/of/kexec.c                                             |   17 
 drivers/opp/core.c                                             |    4 
 drivers/parisc/lba_pci.c                                       |    6 
 drivers/pci/controller/dwc/pcie-designware-ep.c                |   18 
 drivers/pci/controller/dwc/pcie-designware-host.c              |   30 
 drivers/pci/controller/dwc/pcie-designware.c                   |   46 
 drivers/pci/controller/dwc/pcie-qcom.c                         |   58 
 drivers/pci/controller/dwc/pcie-tegra194.c                     |   49 
 drivers/pci/controller/pcie-mediatek-gen3.c                    |    6 
 drivers/pci/controller/pcie-microchip-host.c                   |    2 
 drivers/pci/endpoint/functions/pci-epf-test.c                  |    1 
 drivers/pci/p2pdma.c                                           |    2 
 drivers/pci/pcie/aer.c                                         |    7 
 drivers/pci/pcie/portdrv_core.c                                |    9 
 drivers/perf/arm_spe_pmu.c                                     |   22 
 drivers/phy/samsung/phy-exynosautov9-ufs.c                     |   18 
 drivers/phy/st/phy-stm32-usbphyc.c                             |    4 
 drivers/platform/chrome/cros_ec.c                              |    8 
 drivers/platform/olpc/olpc-ec.c                                |    2 
 drivers/pwm/pwm-lpc18xx-sct.c                                  |   88 
 drivers/pwm/pwm-sifive.c                                       |   61 
 drivers/regulator/of_regulator.c                               |    6 
 drivers/regulator/qcom_smd-regulator.c                         |    4 
 drivers/remoteproc/imx_rproc.c                                 |    7 
 drivers/remoteproc/qcom_q6v5_pas.c                             |    3 
 drivers/remoteproc/qcom_sysmon.c                               |   10 
 drivers/remoteproc/qcom_wcnss.c                                |   10 
 drivers/remoteproc/ti_k3_r5_remoteproc.c                       |    2 
 drivers/rpmsg/mtk_rpmsg.c                                      |    2 
 drivers/rpmsg/qcom_smd.c                                       |    1 
 drivers/rpmsg/rpmsg_char.c                                     |    7 
 drivers/rtc/rtc-rx8025.c                                       |   22 
 drivers/s390/char/zcore.c                                      |   14 
 drivers/s390/cio/vfio_ccw_drv.c                                |   14 
 drivers/s390/scsi/zfcp_fc.c                                    |   29 
 drivers/s390/scsi/zfcp_fc.h                                    |    6 
 drivers/s390/scsi/zfcp_fsf.c                                   |    4 
 drivers/scsi/be2iscsi/be_main.c                                |    2 
 drivers/scsi/bnx2i/bnx2i_iscsi.c                               |    2 
 drivers/scsi/cxgbi/libcxgbi.c                                  |    2 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                         |   20 
 drivers/scsi/iscsi_tcp.c                                       |    4 
 drivers/scsi/libiscsi.c                                        |    9 
 drivers/scsi/lpfc/lpfc.h                                       |   41 
 drivers/scsi/lpfc/lpfc_bsg.c                                   |   50 
 drivers/scsi/lpfc/lpfc_crtn.h                                  |    3 
 drivers/scsi/lpfc/lpfc_ct.c                                    |    8 
 drivers/scsi/lpfc/lpfc_els.c                                   |  139 -
 drivers/scsi/lpfc/lpfc_hbadisc.c                               |    1 
 drivers/scsi/lpfc/lpfc_hw4.h                                   |    7 
 drivers/scsi/lpfc/lpfc_init.c                                  |   44 
 drivers/scsi/lpfc/lpfc_nportdisc.c                             |    4 
 drivers/scsi/lpfc/lpfc_nvme.c                                  |   87 
 drivers/scsi/lpfc/lpfc_nvme.h                                  |    6 
 drivers/scsi/lpfc/lpfc_nvmet.c                                 |   83 
 drivers/scsi/lpfc/lpfc_scsi.c                                  |  501 ++--
 drivers/scsi/lpfc/lpfc_sli.c                                   |  907 +++-----
 drivers/scsi/lpfc/lpfc_sli.h                                   |   26 
 drivers/scsi/lpfc/lpfc_sli4.h                                  |    2 
 drivers/scsi/qedi/qedi_main.c                                  |    9 
 drivers/scsi/qla2xxx/qla_attr.c                                |   31 
 drivers/scsi/qla2xxx/qla_bsg.c                                 |   10 
 drivers/scsi/qla2xxx/qla_def.h                                 |   16 
 drivers/scsi/qla2xxx/qla_edif.c                                |  154 +
 drivers/scsi/qla2xxx/qla_edif.h                                |   13 
 drivers/scsi/qla2xxx/qla_edif_bsg.h                            |    2 
 drivers/scsi/qla2xxx/qla_fw.h                                  |    2 
 drivers/scsi/qla2xxx/qla_gbl.h                                 |    6 
 drivers/scsi/qla2xxx/qla_gs.c                                  |  129 -
 drivers/scsi/qla2xxx/qla_init.c                                |  124 +
 drivers/scsi/qla2xxx/qla_iocb.c                                |    8 
 drivers/scsi/qla2xxx/qla_isr.c                                 |   25 
 drivers/scsi/qla2xxx/qla_mbx.c                                 |   19 
 drivers/scsi/qla2xxx/qla_mid.c                                 |    6 
 drivers/scsi/qla2xxx/qla_nvme.c                                |    5 
 drivers/scsi/qla2xxx/qla_os.c                                  |   93 
 drivers/scsi/qla2xxx/qla_target.c                              |    2 
 drivers/scsi/scsi_transport_iscsi.c                            |   66 
 drivers/scsi/sg.c                                              |   53 
 drivers/scsi/smartpqi/smartpqi_init.c                          |    4 
 drivers/scsi/ufs/ufshcd.c                                      |    6 
 drivers/soc/amlogic/meson-mx-socinfo.c                         |    1 
 drivers/soc/amlogic/meson-secure-pwrc.c                        |    4 
 drivers/soc/fsl/guts.c                                         |    2 
 drivers/soc/qcom/Kconfig                                       |    1 
 drivers/soc/qcom/ocmem.c                                       |    3 
 drivers/soc/qcom/qcom_aoss.c                                   |    4 
 drivers/soc/renesas/r8a779a0-sysc.c                            |   10 
 drivers/soundwire/bus.c                                        |   75 
 drivers/soundwire/bus_type.c                                   |   38 
 drivers/soundwire/qcom.c                                       |    4 
 drivers/soundwire/slave.c                                      |    3 
 drivers/soundwire/stream.c                                     |   53 
 drivers/spi/spi-altera-dfl.c                                   |   14 
 drivers/spi/spi-rspi.c                                         |    4 
 drivers/spi/spi-synquacer.c                                    |    1 
 drivers/spi/spi-tegra20-slink.c                                |    3 
 drivers/spi/spi.c                                              |   19 
 drivers/staging/media/atomisp/pci/atomisp_cmd.c                |   57 
 drivers/staging/media/hantro/hantro.h                          |    2 
 drivers/staging/media/hantro/hantro_g2_hevc_dec.c              |   27 
 drivers/staging/media/hantro/hantro_hevc.c                     |    2 
 drivers/staging/media/hantro/hantro_postproc.c                 |   15 
 drivers/staging/media/hantro/imx8m_vpu_hw.c                    |    1 
 drivers/staging/media/hantro/rockchip_vpu_hw.c                 |    1 
 drivers/staging/media/hantro/sama5d4_vdec_hw.c                 |    1 
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c               |    7 
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h               |    3 
 drivers/staging/rtl8192u/r8192U.h                              |    2 
 drivers/staging/rtl8192u/r8192U_dm.c                           |   38 
 drivers/staging/rtl8192u/r8192U_dm.h                           |    2 
 drivers/thermal/thermal_sysfs.c                                |   10 
 drivers/tty/n_gsm.c                                            |  360 ++-
 drivers/tty/serial/8250/8250.h                                 |   40 
 drivers/tty/serial/8250/8250_bcm7271.c                         |   24 
 drivers/tty/serial/8250/8250_dma.c                             |    4 
 drivers/tty/serial/8250/8250_dw.c                              |    3 
 drivers/tty/serial/8250/8250_fsl.c                             |    2 
 drivers/tty/serial/8250/8250_pci.c                             |  582 ++++-
 drivers/tty/serial/8250/8250_port.c                            |   21 
 drivers/tty/serial/fsl_lpuart.c                                |   12 
 drivers/tty/serial/mvebu-uart.c                                |   11 
 drivers/tty/vt/vt.c                                            |    2 
 drivers/usb/cdns3/cdns3-gadget.c                               |   11 
 drivers/usb/core/hcd.c                                         |   26 
 drivers/usb/dwc3/core.c                                        |    9 
 drivers/usb/dwc3/dwc3-qcom.c                                   |    4 
 drivers/usb/dwc3/gadget.c                                      |   92 
 drivers/usb/gadget/udc/Kconfig                                 |    2 
 drivers/usb/gadget/udc/aspeed-vhub/hub.c                       |    4 
 drivers/usb/gadget/udc/tegra-xudc.c                            |    8 
 drivers/usb/host/ehci-ppc-of.c                                 |    1 
 drivers/usb/host/ohci-nxp.c                                    |    1 
 drivers/usb/host/xhci-tegra.c                                  |    8 
 drivers/usb/host/xhci.h                                        |    2 
 drivers/usb/serial/sierra.c                                    |    3 
 drivers/usb/serial/usb-serial.c                                |    2 
 drivers/usb/serial/usb_wwan.c                                  |    3 
 drivers/usb/typec/ucsi/ucsi.c                                  |    4 
 drivers/video/fbdev/amba-clcd.c                                |   24 
 drivers/video/fbdev/arkfb.c                                    |    9 
 drivers/video/fbdev/core/fbcon.c                               |   12 
 drivers/video/fbdev/s3fb.c                                     |    2 
 drivers/video/fbdev/sis/init.c                                 |    4 
 drivers/video/fbdev/vt8623fb.c                                 |    2 
 drivers/watchdog/armada_37xx_wdt.c                             |    2 
 drivers/watchdog/sp5100_tco.c                                  |    1 
 fs/9p/acl.c                                                    |    1 
 fs/9p/acl.h                                                    |   17 
 fs/9p/cache.c                                                  |    4 
 fs/9p/v9fs.c                                                   |    4 
 fs/9p/v9fs_vfs.h                                               |   11 
 fs/9p/vfs_addr.c                                               |    6 
 fs/9p/vfs_dentry.c                                             |    2 
 fs/9p/vfs_file.c                                               |    1 
 fs/9p/vfs_inode.c                                              |   14 
 fs/9p/vfs_inode_dotl.c                                         |    9 
 fs/9p/vfs_super.c                                              |    7 
 fs/9p/xattr.h                                                  |   19 
 fs/attr.c                                                      |    2 
 fs/btrfs/block-group.c                                         |    1 
 fs/btrfs/disk-io.c                                             |   35 
 fs/btrfs/inode.c                                               |   72 
 fs/cifs/file.c                                                 |   20 
 fs/erofs/decompressor.c                                        |   16 
 fs/eventpoll.c                                                 |   22 
 fs/exec.c                                                      |    3 
 fs/ext2/super.c                                                |   12 
 fs/ext4/inline.c                                               |    3 
 fs/ext4/inode.c                                                |   24 
 fs/ext4/migrate.c                                              |    4 
 fs/ext4/namei.c                                                |   23 
 fs/ext4/resize.c                                               |    1 
 fs/ext4/xattr.c                                                |  169 -
 fs/ext4/xattr.h                                                |   14 
 fs/f2fs/file.c                                                 |   17 
 fs/fuse/control.c                                              |    4 
 fs/fuse/inode.c                                                |    6 
 fs/fuse/ioctl.c                                                |   15 
 fs/io_uring.c                                                  |    3 
 fs/jbd2/commit.c                                               |    2 
 fs/jbd2/transaction.c                                          |   14 
 fs/ksmbd/smb2misc.c                                            |    5 
 fs/ksmbd/smb2pdu.c                                             |    5 
 fs/lockd/svc4proc.c                                            |    8 
 fs/lockd/xdr4.c                                                |   19 
 fs/mbcache.c                                                   |   76 
 fs/namei.c                                                     |    4 
 fs/nfs/flexfilelayout/flexfilelayout.c                         |    4 
 fs/nfs/nfs3client.c                                            |    1 
 fs/nfsd/filecache.c                                            |   22 
 fs/nfsd/filecache.h                                            |    4 
 fs/nfsd/trace.h                                                |    8 
 fs/overlayfs/export.c                                          |    2 
 fs/proc/base.c                                                 |   46 
 fs/splice.c                                                    |   10 
 include/acpi/apei.h                                            |    4 
 include/acpi/cppc_acpi.h                                       |    2 
 include/crypto/internal/blake2s.h                              |  108 -
 include/drm/drm_bridge.h                                       |    2 
 include/drm/drm_gem_shmem_helper.h                             |  168 +
 include/dt-bindings/clock/qcom,gcc-msm8939.h                   |    1 
 include/linux/acpi_viot.h                                      |    2 
 include/linux/arm_sdei.h                                       |    2 
 include/linux/blkdev.h                                         |    2 
 include/linux/buffer_head.h                                    |   25 
 include/linux/ieee80211.h                                      |    6 
 include/linux/iio/common/cros_ec_sensors_core.h                |    7 
 include/linux/kfifo.h                                          |    2 
 include/linux/lockd/xdr.h                                      |    2 
 include/linux/lockdep.h                                        |   30 
 include/linux/mbcache.h                                        |   10 
 include/linux/memremap.h                                       |   18 
 include/linux/mfd/t7l66xb.h                                    |    1 
 include/linux/once_lite.h                                      |   20 
 include/linux/pci_ids.h                                        |    2 
 include/linux/pipe_fs_i.h                                      |    9 
 include/linux/sched.h                                          |    2 
 include/linux/sched/rt.h                                       |    8 
 include/linux/sched/topology.h                                 |    1 
 include/linux/soundwire/sdw.h                                  |    6 
 include/linux/torture.h                                        |    8 
 include/linux/tpm_eventlog.h                                   |    2 
 include/linux/usb/hcd.h                                        |    1 
 include/linux/wait.h                                           |    9 
 include/net/9p/9p.h                                            |   10 
 include/net/9p/client.h                                        |   30 
 include/net/9p/transport.h                                     |   18 
 include/net/inet6_hashtables.h                                 |   27 
 include/net/inet_hashtables.h                                  |   44 
 include/net/inet_sock.h                                        |   11 
 include/net/sock.h                                             |   15 
 include/scsi/libiscsi.h                                        |    2 
 include/scsi/scsi_transport_iscsi.h                            |    1 
 include/trace/bpf_probe.h                                      |   16 
 include/trace/events/spmi.h                                    |   12 
 include/trace/perf.h                                           |   17 
 include/trace/trace_events.h                                   |  131 +
 include/uapi/linux/can/error.h                                 |    5 
 include/uapi/linux/netfilter/xt_IDLETIMER.h                    |   17 
 init/main.c                                                    |    1 
 kernel/bpf/cgroup.c                                            |   70 
 kernel/bpf/verifier.c                                          |    4 
 kernel/cgroup/cpuset.c                                         |    2 
 kernel/dma/swiotlb.c                                           |    2 
 kernel/irq/Kconfig                                             |    1 
 kernel/irq/chip.c                                              |    3 
 kernel/irq/irqdomain.c                                         |    2 
 kernel/kprobes.c                                               |    3 
 kernel/locking/lockdep.c                                       |    7 
 kernel/power/user.c                                            |   13 
 kernel/profile.c                                               |    7 
 kernel/rcu/rcutorture.c                                        |   62 
 kernel/sched/core.c                                            |   59 
 kernel/sched/deadline.c                                        |   52 
 kernel/sched/fair.c                                            |   87 
 kernel/sched/features.h                                        |    3 
 kernel/sched/rt.c                                              |   15 
 kernel/sched/sched.h                                           |    4 
 kernel/smp.c                                                   |    4 
 kernel/time/hrtimer.c                                          |    1 
 kernel/time/timekeeping.c                                      |    7 
 kernel/trace/blktrace.c                                        |    2 
 kernel/trace/trace.h                                           |    3 
 lib/crypto/blake2s-selftest.c                                  |   41 
 lib/crypto/blake2s.c                                           |   37 
 lib/iov_iter.c                                                 |   15 
 lib/livepatch/test_klp_callbacks_busy.c                        |    8 
 lib/smp_processor_id.c                                         |    2 
 lib/test_bpf.c                                                 |    4 
 lib/test_hmm.c                                                 |   10 
 lib/test_kasan.c                                               |   10 
 mm/mempolicy.c                                                 |    2 
 mm/memremap.c                                                  |   59 
 mm/mmap.c                                                      |    1 
 net/9p/client.c                                                |  462 ++--
 net/9p/error.c                                                 |    2 
 net/9p/mod.c                                                   |    9 
 net/9p/protocol.c                                              |   36 
 net/9p/protocol.h                                              |    2 
 net/9p/trans_common.h                                          |    2 
 net/9p/trans_fd.c                                              |   13 
 net/9p/trans_rdma.c                                            |    2 
 net/9p/trans_virtio.c                                          |    4 
 net/9p/trans_xen.c                                             |    2 
 net/bluetooth/l2cap_core.c                                     |   13 
 net/core/skmsg.c                                               |    4 
 net/dccp/proto.c                                               |   10 
 net/ipv4/inet_hashtables.c                                     |   17 
 net/ipv4/tcp_output.c                                          |   30 
 net/ipv4/udp.c                                                 |    3 
 net/ipv6/inet6_hashtables.c                                    |    6 
 net/ipv6/udp.c                                                 |    2 
 net/mac80211/agg-rx.c                                          |    2 
 net/mac80211/sta_info.c                                        |    6 
 net/netfilter/nf_tables_api.c                                  |   18 
 net/rose/af_rose.c                                             |   11 
 net/rose/rose_route.c                                          |    2 
 net/sched/cls_route.c                                          |    2 
 scripts/faddr2line                                             |    4 
 scripts/gdb/linux/dmesg.py                                     |   42 
 scripts/gdb/linux/utils.py                                     |   14 
 security/selinux/ss/policydb.h                                 |    2 
 security/selinux/ss/services.c                                 |    9 
 sound/pci/hda/patch_cirrus.c                                   |    1 
 sound/pci/hda/patch_conexant.c                                 |   11 
 sound/pci/hda/patch_realtek.c                                  |   15 
 sound/soc/atmel/mchp-spdifrx.c                                 |    9 
 sound/soc/codecs/cros_ec_codec.c                               |    1 
 sound/soc/codecs/da7210.c                                      |    2 
 sound/soc/codecs/msm8916-wcd-digital.c                         |   46 
 sound/soc/codecs/mt6359-accdet.c                               |    1 
 sound/soc/codecs/mt6359.c                                      |    1 
 sound/soc/codecs/wcd9335.c                                     |   81 
 sound/soc/fsl/fsl-asoc-card.c                                  |    5 
 sound/soc/fsl/fsl_asrc.c                                       |    6 
 sound/soc/fsl/fsl_easrc.c                                      |    9 
 sound/soc/fsl/fsl_easrc.h                                      |    2 
 sound/soc/fsl/imx-audmux.c                                     |    2 
 sound/soc/fsl/imx-card.c                                       |   22 
 sound/soc/generic/audio-graph-card.c                           |    4 
 sound/soc/mediatek/mt6797/mt6797-mt6351.c                      |    6 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c               |   10 
 sound/soc/mediatek/mt8173/mt8173-rt5650.c                      |    9 
 sound/soc/qcom/lpass-cpu.c                                     |    1 
 sound/soc/qcom/qdsp6/q6adm.c                                   |    2 
 sound/soc/samsung/aries_wm8994.c                               |    6 
 sound/soc/samsung/h1940_uda1380.c                              |    2 
 sound/soc/samsung/rx1950_uda1380.c                             |    4 
 sound/usb/bcd2000/bcd2000.c                                    |    3 
 sound/usb/quirks.c                                             |    2 
 tools/lib/bpf/gen_loader.c                                     |    2 
 tools/lib/bpf/libbpf.c                                         |    9 
 tools/lib/bpf/xsk.c                                            |    9 
 tools/perf/util/dsos.c                                         |   15 
 tools/perf/util/genelf.c                                       |    6 
 tools/perf/util/symbol-elf.c                                   |   27 
 tools/testing/nvdimm/test/iomap.c                              |   43 
 tools/testing/selftests/bpf/prog_tests/btf.c                   |    2 
 tools/testing/selftests/kvm/lib/x86_64/processor.c             |    2 
 tools/testing/selftests/seccomp/seccomp_bpf.c                  |    2 
 tools/testing/selftests/timers/clocksource-switch.c            |    6 
 tools/testing/selftests/timers/valid-adjtimex.c                |    2 
 tools/thermal/tmon/sysfs.c                                     |   24 
 tools/thermal/tmon/tmon.h                                      |    3 
 virt/kvm/kvm_main.c                                            |   16 
 801 files changed, 10564 insertions(+), 7356 deletions(-)

Adrian Hunter (1):
      perf tools: Fix dso_id inode generation comparison

Ahmed Zaki (1):
      mac80211: fix a memory leak where sta_info is not freed

Al Viro (2):
      fix short copy handling in copy_mc_pipe_to_iter()
      __follow_mount_rcu(): verify that mount_lock remains unchanged

Alex Deucher (2):
      drm/amdgpu: fix check in fbdev init
      drm/radeon: fix incorrrect SPDX-License-Identifiers

Alexander Gordeev (10):
      s390/dump: fix old lowcore virtual vs physical address confusion
      s390/maccess: fix semantics of memcpy_real() and its callers
      s390/crash: fix incorrect number of bytes to copy to user space
      s390/zcore: fix race when reading from hardware system area
      s390/dump: fix os_info virtual vs physical address confusion
      s390/smp: cleanup target CPU callback starting
      s390/smp: cleanup control register update routines
      s390/maccess: rework absolute lowcore accessors
      s390/smp: enforce lowcore protection on CPU restart
      Revert "s390/smp: enforce lowcore protection on CPU restart"

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

Alexey Kardashevskiy (1):
      powerpc/iommu: Fix iommu_table_in_use for a small default DMA window case

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

AngeloGioacchino Del Regno (2):
      media: platform: mtk-mdp: Fix mdp_ipi_comm structure alignment
      rpmsg: mtk_rpmsg: Fix circular locking dependency

Anquan Wu (1):
      libbpf: Fix the name of a reused map

Anshuman Khandual (1):
      drivers/perf: arm_spe: Fix consistency of SYS_PMSCR_EL1.CX

Ansuel Smith (1):
      clk: qcom: clk-krait: unlock spin after mux completion

Antonio Borneo (3):
      genirq: Don't return error on missing optional irq_request_resources()
      drm: adv7511: override i2c address of cec before accessing it
      scripts/gdb: fix 'lx-dmesg' on 32 bits arch

Ard Biesheuvel (1):
      ARM: remove some dead code

Armin Wolf (1):
      hwmon: (dell-smm) Add Dell XPS 13 7390 to fan control whitelist

Arnaldo Carvalho de Melo (1):
      genelf: Use HAVE_LIBCRYPTO_SUPPORT, not the never defined HAVE_LIBCRYPTO

Artem Borisov (1):
      HID: alps: Declare U1_UNICORN_LEGACY support

Arun Easi (6):
      scsi: qla2xxx: Fix discovery issues in FC-AL topology
      scsi: qla2xxx: Fix crash due to stale SRB access around I/O timeouts
      scsi: qla2xxx: Fix excessive I/O error messages by default
      scsi: qla2xxx: Fix losing FCP-2 targets on long port disable with I/Os
      scsi: qla2xxx: Fix losing target when it reappears during delete
      scsi: qla2xxx: Fix losing FCP-2 targets during port perturbation tests

Athira Rajeev (1):
      powerpc/perf: Optimize clearing the pending PMI and remove WARN_ON for PMI check in power_pmu_disable

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

Basavaraj Natikar (2):
      HID: amd_sfh: Add NULL check for hid device
      HID: amd_sfh: Handle condition of "no sensors"

Bean Huo (1):
      nvme: use command_id instead of req->tag in trace_nvme_complete_rq()

Bedant Patnaik (1):
      ALSA: hda/realtek: Add a quirk for HP OMEN 15 (8786) mute LED

Benjamin Beichler (1):
      um: Remove straying parenthesis

Benjamin Gaignard (1):
      media: hevc: Embedded indexes in RPS

Benjamin Segall (1):
      epoll: autoremove wakers even more aggressively

Bharath SM (1):
      SMB3: fix lease break timeout when multiple deferred close handles for the same file.

Biju Das (1):
      spi: spi-rspi: Fix PIO fallback on RZ platforms

Bikash Hazarika (2):
      scsi: qla2xxx: Fix incorrect display of max frame size
      scsi: qla2xxx: Zero undefined mailbox IN registers

Bjorn Andersson (1):
      drm/bridge: lt9611uxc: Cancel only driver's work

Bo-Chen Chen (1):
      drm/mediatek: dpi: Remove output format of YUV

Bob Pearson (3):
      RDMA/rxe: Fix deadlock in rxe_do_local_ops()
      RDMA/rxe: Fix mw bind to allow any consumer key portion
      RDMA/rxe: Add memory barriers to kernel queues

Brian Norris (1):
      drm/rockchip: vop: Don't crash for invalid duplicate_state()

Bryan O'Donoghue (5):
      clk: qcom: gcc-msm8939: Add missing SYSTEM_MM_NOC_BFDCD_CLK_SRC
      clk: qcom: gcc-msm8939: Fix bimc_ddr_clk_src rcgr base address
      clk: qcom: gcc-msm8939: Add missing system_mm_noc_bfdcd_clk_src
      clk: qcom: gcc-msm8939: Point MM peripherals to system_mm_noc clock
      clk: qcom: gcc-msm8939: Fix weird field spacing in ftbl_gcc_camss_cci_clk

Cameron Williams (1):
      tty: 8250: Add support for Brainboxes PX cards.

Carlos Llamas (1):
      binder: fix redefinition of seq_file attributes

Catalin Marinas (1):
      arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags"

Chanho Park (1):
      phy: samsung: exynosautov9-ufs: correct TSRV register configurations

Chao Liu (1):
      f2fs: fix to remove F2FS_COMPR_FL and tag F2FS_NOCOMP_FL at the same time

Chen Yu (1):
      sched/fair: Introduce SIS_UTIL to search idle CPU based on sum of util_avg

Chen Zhongjin (3):
      profiling: fix shift too large makes kernel panic
      kprobes: Forbid probing on trampoline and BPF code areas
      locking/csd_lock: Change csdlock_debug from early_param to __setup

Cheng Xu (1):
      RDMA/siw: Fix duplicated reported IW_CM_EVENT_CONNECT_REPLY event

Chenyi Qiang (1):
      x86/bus_lock: Don't assume the init value of DEBUGCTLMSR.BUS_LOCK_DETECT to be zero

Christian Lamparter (1):
      ARM: dts: BCM5301X: Add DT for Meraki MR26

Christian Loehle (1):
      mmc: block: Add single read for 4k sector cards

Christian Marangi (1):
      PCI: qcom: Set up rev 2.1.0 PARF_PHY before enabling clocks

Christoph Hellwig (4):
      memremap: remove support for external pgmap refcounts
      nvme: don't return an error from nvme_configure_metadata
      nvme: catch -ENODEV from nvme_revalidate_zones again
      block: remove the struct blk_queue_ctx forward declaration

Christophe JAILLET (10):
      spi: spi-altera-dfl: Fix an error handling path
      drm/rockchip: Fix an error handling path rockchip_dp_probe()
      hinic: Use the bitmap API when applicable
      wifi: p54: Fix an error handling path in p54spi_probe()
      mtd: rawnand: meson: Fix a potential double free issue
      misc: rtsx: Fix an error handling path in rtsx_pci_probe()
      intel_th: Fix a resource leak in an error handling path
      memstick/ms_block: Fix some incorrect memory allocation
      memstick/ms_block: Fix a memory leak
      ASoC: qcom: q6dsp: Fix an off-by-one in q6adm_alloc_copp()

Christophe Leroy (4):
      powerpc/ptdump: Fix display of RW pages on FSL_BOOK3E
      powerpc/32: Call mmu_mark_initmem_nx() regardless of data block mapping.
      powerpc/32: Do not allow selection of e5500 or e6500 CPUs on PPC32
      powerpc: Fix eh field when calling lwarx on PPC32

Christopher Obbard (1):
      um: random: Don't initialise hwrng struct with zero

Chuck Lever (1):
      NFSD: Clean up the show_nf_flags() macro

Claudio Imbrenda (1):
      KVM: s390: pv: leak the topmost page table when destroy fails

Claudiu Beznea (1):
      ASoC: mchp-spdifrx: disable end of block interrupt on failures

Conor Dooley (1):
      dt-bindings: riscv: fix SiFive l2-cache's cache-sets

Corentin Labbe (1):
      crypto: sun8i-ss - do not allocate memory when handling hash requests

Dan Carpenter (10):
      wifi: rtlwifi: fix error codes in rtl_debugfs_set_write_h2c()
      crypto: sun8i-ss - fix error codes in allocate_flows()
      wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()
      selftests/bpf: fix a test for snprintf() overflow
      libbpf: fix an snprintf() overflow check
      scsi: qla2xxx: Check correct variable in qla24xx_async_gffid()
      eeprom: idt_89hpesx: uninitialized data in idt_dbgfs_csr_write()
      platform/olpc: Fix uninitialized data in debugfs write
      null_blk: fix ida error handling in null_add_dev()
      kfifo: fix kfifo_to_user() return type

Dan Williams (1):
      ACPI: APEI: Fix _EINJ vs EFI_MEMORY_SP

Daniel Starke (11):
      tty: n_gsm: fix user open not possible at responder until initiator open
      tty: n_gsm: fix tty registration before control channel open
      tty: n_gsm: fix wrong queuing behavior in gsm_dlci_data_output()
      tty: n_gsm: fix missing timer to handle stalled links
      tty: n_gsm: fix non flow control frames during mux flow off
      tty: n_gsm: fix packet re-transmission without open control channel
      tty: n_gsm: fix race condition in gsmld_write()
      tty: n_gsm: fix resource allocation order in gsm_activate_mux()
      tty: n_gsm: fix wrong T1 retry count handling
      tty: n_gsm: fix DM command
      tty: n_gsm: fix missing corner cases in gsmld_poll()

Dave Stevenson (10):
      drm/vc4: plane: Fix margin calculations for the right/bottom edges
      drm/vc4: dsi: Release workaround buffer and DMA
      drm/vc4: dsi: Correct DSI divider calculations
      drm/vc4: dsi: Correct pixel order for DSI0
      drm/vc4: dsi: Register dsi0 as the correct vc4 encoder type
      drm/vc4: dsi: Fix dsi0 interrupt support
      drm/vc4: dsi: Add correct stop condition to vc4_dsi_encoder_disable iteration
      drm/vc4: hdmi: Reset HDMI MISC_CONTROL register
      drm/vc4: hdmi: Correct HDMI timing registers for interlaced modes
      drm/vc4: drv: Adopt the dma configuration from the HVS or V3D component

David Collins (1):
      spmi: trace: fix stack-out-of-bound access in SPMI tracing functions

David Howells (1):
      vfs: Check the truncate maximum size in inode_newsize_ok()

Deren Wu (2):
      mt76: mt7921: fix aggregation subframes setting to HE max
      mt76: mt7921: enlarge maximum VHT MPDU length to 11454

Dietmar Eggemann (1):
      sched/deadline: Merge dl_task_can_attach() and dl_cpu_busy()

Dimitri John Ledkov (1):
      riscv: set default pm_power_off to NULL

Dmitry Baryshkov (4):
      arm64: dts: qcom: sdm630: disable GPU by default
      arm64: dts: qcom: sdm630: fix the qusb2phy ref clock
      arm64: dts: qcom: sdm630: fix gpu's interconnect path
      arm64: dts: qcom: sdm636-sony-xperia-ganges-mermaid: correct sdc2 pinconf

Dmitry Osipenko (2):
      drm/gem: Properly annotate WW context on drm_gem_lock_reservations() error
      drm/shmem-helper: Add missing vunmap on error

Dom Cobley (2):
      drm/vc4: plane: Remove subpixel positioning check
      drm/vc4: hdmi: Avoid full hdmi audio fifo writes

Dominique Martinet (1):
      9p: fix a bunch of checkpatch warnings

Doug Berger (1):
      serial: 8250_bcm7271: Save/restore RTS in suspend/resume

Douglas Anderson (1):
      drm/dp: Export symbol / kerneldoc fixes for DP AUX bus

Duoming Zhou (3):
      mtd: sm_ftl: Fix deadlock caused by cancel_work_sync in sm_release
      mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv
      staging: rtl8192u: Fix sleep in atomic context bug in dm_fsync_timer_callback

Eric Auger (1):
      ACPI: VIOT: Fix ACS setup

Eric Dumazet (5):
      net: fix sk_wmem_schedule() and sk_rmem_schedule() errors
      inet: add READ_ONCE(sk->sk_bound_dev_if) in INET_MATCH()
      ipv6: add READ_ONCE(sk->sk_bound_dev_if) in INET6_MATCH()
      net: rose: fix netdev reference changes
      tcp: fix over estimation in sk_forced_mem_schedule()

Eric Farman (1):
      vfio/ccw: Do not change FSM state in subchannel event

Eric Whitney (1):
      ext4: fix extent status tree race in writeback error recovery path

Eugen Hristev (2):
      media: atmel: atmel-sama7g5-isc: fix warning in configs without OF
      mmc: sdhci-of-at91: fix set_uhs_signaling rewriting of MC1R

Ezequiel Garcia (2):
      media: hantro: postproc: Fix motion vector space size
      media: hantro: Simplify postprocessor

Fabio Estevam (4):
      i2c: mxs: Silence a clang warning
      mmc: mxcmmc: Silence a clang warning
      dmaengine: imx-dma: Cast of_device_get_match_data() with (uintptr_t)
      ASoC: imx-audmux: Silence a clang warning

Fabrice Gasnier (1):
      phy: stm32: fix error return in stm32_usbphyc_phy_init

Fawzi Khaber (1):
      iio: fix iio_format_avail_range() printing for none IIO_VAL_INT

Florian Fainelli (3):
      MIPS: vdso: Utilize __pa() for gic_pfn
      MIPS: Fixed __debug_virt_addr_valid()
      tools/thermal: Fix possible path truncations

Florian Westphal (1):
      netfilter: nf_tables: fix null deref due to zeroed list head

Francis Laniel (1):
      arm64: Do not forget syscall when starting a new thread.

Frederic Weisbecker (1):
      rcutorture: Fix ksoftirqd boosting timing and iteration

GONG, Ruiqi (1):
      stack: Declare {randomize_,}kstack_offset to fix Sparse warnings

Gal Pressman (1):
      net/mlx5e: Remove WARN_ON when trying to offload an unsupported TLS cipher/version

Gao Chao (1):
      drm/panel: Fix build error when CONFIG_DRM_PANEL_SAMSUNG_ATNA33XC20=y && CONFIG_DRM_DISPLAY_HELPER=m

Gao Xiang (1):
      erofs: avoid consecutive detection for Highmem memory

Geert Uytterhoeven (3):
      arm64: dts: renesas: beacon: Fix regulator node names
      soc: renesas: r8a779a0-sysc: Fix A2DP1 and A2CV[2357] PDR values
      arm64: dts: renesas: Fix thermal-sensors on single-zone sensors

Greg Kroah-Hartman (2):
      Revert "mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv"
      Linux 5.15.61

Guilherme G. Piccoli (1):
      ACPI: processor/idle: Annotate more functions to live in cpuidle section

Guillaume Ranquet (1):
      drm/mediatek: dpi: Only enable dpi after the bridge is enabled

Guo Mengqi (1):
      spi: synquacer: Add missing clk_disable_unprepare()

Gwendal Grignou (1):
      iio: cros: Register FIFO callback after sensor is registered

Hangyu Hua (4):
      drm: bridge: sii8620: fix possible off-by-one
      wifi: libertas: Fix possible refcount leak in if_usb_probe()
      dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in the same lock
      net: 9p: fix refcount leak in p9_read_work() error handling

Hans de Goede (2):
      ACPI: EC: Remove duplicate ThinkPad X1 Carbon 6th entry from DMI quirks
      ACPI: EC: Drop the EC_FLAGS_IGNORE_DSDT_GPE quirk

Haoyue Xu (1):
      RDMA/hns: Fix incorrect clearing of interrupt status register

Harshit Mogalapalli (2):
      HID: cp2112: prevent a buffer overflow in cp2112_xfer()
      HID: mcp2221: prevent a buffer overflow in mcp_smbus_write()

Helge Deller (5):
      fbcon: Fix boundary checks for fbcon=vc:n1-n2 parameters
      fbcon: Fix accelerated fbdev scrolling while logo is still shown
      parisc: Fix device names in /proc/iomem
      parisc: Drop pa_swapper_pg_lock spinlock
      parisc: io_pgetevents_time64() needs compat syscall in 32-bit compat mode

Hsin-Yi Wang (1):
      PM: domains: Ensure genpd_debugfs_dir exists before remove

Huacai Chen (2):
      MIPS: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
      tpm: eventlog: Fix section mismatch for DEBUG_SECTION_MISMATCH

Hyunchul Lee (1):
      ksmbd: prevent out of bound read for SMB2_TREE_CONNNECT

Ian Rogers (1):
      perf symbol: Fail to read phdr workaround

Ido Schimmel (1):
      netdevsim: fib: Fix reference count leak on route deletion failure

Ilpo Järvinen (1):
      serial: 8250_dw: Store LSR into lsr_saved_flags in dw8250_tx_wait_empty()

Imre Deak (1):
      drm/dp/mst: Read the extended DPCD capabilities during system resume

Ivan Hasenkampf (1):
      ALSA: hda/realtek: Add quirk for HP Spectre x360 15-eb0xxx

Jack Wang (3):
      RDMA/rtrs-srv: Fix modinfo output for stringify
      RDMA/rtrs: Fix warning when use poll mode on client side.
      RDMA/rtrs: Replace duplicate check with is_pollqueue helper

Jaewook Kim (1):
      f2fs: do not allow to decompress files have FI_COMPRESS_RELEASED

Jagath Jog J (2):
      iio: accel: bma400: Fix the scale min and max macro values
      iio: accel: bma400: Reordering of header files

Jakub Kicinski (1):
      netdevsim: Avoid allocation warnings triggered from user space

James Smart (8):
      scsi: lpfc: Fix EEH support for NVMe I/O
      scsi: lpfc: SLI path split: Refactor lpfc_iocbq
      scsi: lpfc: SLI path split: Refactor fast and slow paths to native SLI4
      scsi: lpfc: SLI path split: Refactor SCSI paths
      scsi: lpfc: Remove extra atomic_inc on cmd_pending in queuecommand after VMID
      scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()
      scsi: lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()
      scsi: lpfc: Resolve some cleanup issues following SLI path refactoring

Jan Kara (6):
      mbcache: don't reclaim used entries
      mbcache: add functions to delete entry if unused
      ext2: Add more validity checks for inode counts
      ext4: remove EA inode entry from mbcache on inode eviction
      ext4: unindent codeblock in ext4_xattr_block_set()
      ext4: fix race when reusing xattr blocks

Jason A. Donenfeld (8):
      um: seed rng using host OS rng
      fs: check FMODE_LSEEK to control internal pipe splicing
      wireguard: ratelimiter: use hrtimer in selftest
      wireguard: allowedips: don't corrupt stack when detecting overflow
      crypto: blake2s - remove shash module
      timekeeping: contribute wall clock to rng on time change
      powerpc/powernv/kvm: Use darn for H_RANDOM on Power9
      crypto: lib/blake2s - reduce stack frame usage in self test

Javier Martinez Canillas (1):
      drm/st7735r: Fix module autoloading for Okaya RH128128T

Jean Delvare (1):
      watchdog: sp5100_tco: Fix a memory leak of EFCH MMIO resource

Jeff Layton (2):
      nfsd: eliminate the NFSD_FILE_BREAK_* flags
      lockd: detect and reject lock arguments that overflow

Jeongik Cha (1):
      wifi: mac80211_hwsim: fix race condition in pending packet

Jernej Skrabec (2):
      media: cedrus: h265: Fix flag name
      media: cedrus: hevc: Add check for invalid timestamp

Jiachen Zhang (1):
      ovl: drop WARN_ON() dentry is NULL in ovl_encode_fh()

Jian Shen (2):
      test_bpf: fix incorrect netdev features
      net: ionic: fix error check for vlan flags in ionic_set_nic_features()

Jian Zhang (2):
      media: driver/nxp/imx-jpeg: fix a unexpected return value problem
      drm/exynos/exynos7_drm_decon: free resources when clk_set_parent() failed.

Jianglei Nie (2):
      RDMA/qedr: Fix potential memory leak in __qedr_alloc_mr()
      RDMA/hfi1: fix potential memory leak in setup_base_ctxt()

Jiasheng Jiang (4):
      drm: bridge: adv7511: Add check for mipi_dsi_driver_register
      Bluetooth: hci_intel: Add check for platform_driver_register
      intel_th: msu-sink: Potential dereference of null pointer
      ASoC: codecs: da7210: add check for i2c_add_driver

Jinke Han (1):
      block: don't allow the same type rq_qos add more than once

Jitao Shi (2):
      drm/mediatek: Separate poweron/poweroff from enable/disable and define new funcs
      drm/mediatek: Keep dsi as LP00 before dcs cmds transfer

Joe Lawrence (1):
      selftests/livepatch: better synchronize test_klp_callbacks_busy

Johan Hovold (5):
      x86/pmem: Fix platform-device leak in error path
      arm64: dts: qcom: sm8250: add missing PCIe PHY clock-cells
      ath11k: fix netdev open race
      usb: dwc3: qcom: fix missing optional irq warnings
      USB: serial: fix tty-port initialized comments

Johannes Berg (2):
      wifi: mac80211_hwsim: add back erroneously removed cast
      wifi: mac80211_hwsim: use 32-bit skb cookie

John Allen (1):
      crypto: ccp - Use kzalloc for sev ioctl interfaces to prevent kernel memory leak

John Keeping (1):
      sched/core: Always flush pending blk_plug

John Ogness (1):
      scripts/gdb: lx-dmesg: read records individually

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

Kees Cook (2):
      kasan: test: Silence GCC 12 warnings
      tracing/perf: Avoid -Warray-bounds warning for __rel_loc macro

Keith Busch (4):
      block: fix infinite loop for invalid zone append
      nvme: disable namespace access for unsupported metadata
      block/bio: remove duplicate append pages code
      block: ensure iov_iter advances for added pages

Kent Overstreet (2):
      9p: Drop kref usage
      9p: Add client parameter to p9_req_put()

Kim Phillips (1):
      x86/bugs: Enable STIBP for IBPB mitigated RETBleed

Konrad Dybcio (1):
      soc: qcom: Make QCOM_RPMPD depend on PM

Krzysztof Kozlowski (7):
      ARM: dts: ast2500-evb: fix board compatible
      ARM: dts: ast2600-evb: fix board compatible
      ARM: dts: ast2600-evb-a1: fix board compatible
      ARM: dts: qcom: mdm9615: add missing PMIC GPIO reg
      ARM: dts: qcom: pm8841: add required thermal-sensor-cells
      ath10k: do not enforce interrupt trigger type
      ASoC: samsung: h1940_uda1380: include proepr GPIO consumer header

Kunihiko Hayashi (2):
      ARM: dts: uniphier: Fix USB interrupts for PXs2 SoC
      arm64: dts: uniphier: Fix USB interrupts for PXs3 SoC

Lad Prabhakar (1):
      mmc: renesas_sdhi: Get the reset handle early in the probe

Lars-Peter Clausen (1):
      i2c: cadence: Support PEC for SMBus block read

Len Baker (1):
      drivers/iio: Remove all strcpy() uses

Leo Li (1):
      drm/amdgpu: Check BO's requested pinning domains against its preferred_domains

Lev Kujawski (1):
      KVM: set_msr_mce: Permit guests to ignore single-bit ECC errors

Li Lingfeng (1):
      ext4: recover csum seed of tmp_inode after migrating to extents

Liam R. Howlett (1):
      android: binder: stop saving a pointer to the VMA

Liang He (18):
      ARM: OMAP2+: display: Fix refcount leak bug
      ARM: OMAP2+: pdata-quirks: Fix refcount leak bug
      ARM: shmobile: rcar-gen2: Increase refcount for new reference
      soc: amlogic: Fix refcount leak in meson-secure-pwrc.c
      regulator: of: Fix refcount leak bug in of_get_regulation_constraints()
      mediatek: mt76: mac80211: Fix missing of_node_put() in mt76_led_init()
      mediatek: mt76: eeprom: fix missing of_node_put() in mt76_find_power_limits_node()
      i2c: mux-gpmux: Add of_node_put() when breaking out of loop
      of: device: Fix missing of_node_put() in of_dma_set_restricted_buffer
      usb: aspeed-vhub: Fix refcount leak bug in ast_vhub_init_desc()
      gpio: gpiolib-of: Fix refcount bugs in of_mm_gpiochip_add_data()
      mmc: cavium-octeon: Add of_node_put() when breaking out of loop
      mmc: cavium-thunderx: Add of_node_put() when breaking out of loop
      ASoC: qcom: Fix missing of_node_put() in asoc_qcom_lpass_cpu_platform_probe()
      ASoC: mt6359: Fix refcount leak bug
      iommu/arm-smmu: qcom_iommu: Add of_node_put() when breaking out of loop
      ASoC: audio-graph-card: Add of_node_put() in fail path
      video: fbdev: amba-clcd: Fix refcount leak bugs

Like Xu (2):
      KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
      KVM: x86/pmu: Ignore pmu->global_ctrl check if vPMU doesn't support global_ctrl

Linus Walleij (3):
      ARM: dts: ux500: Fix Codina accelerometer mounting matrix
      ARM: dts: ux500: Fix Gavini accelerometer mounting matrix
      hwmon: (drivetemp) Add module alias

Linyu Yuan (1):
      usb: typec: ucsi: Acknowledge the GET_ERROR_STATUS command completion

Liu Jian (1):
      skmsg: Fix invalid last sg check in sk_msg_recvmsg()

Lorenzo Bianconi (2):
      mt76: mt76x02u: fix possible memory leak in __mt76x02u_mcu_send_msg
      mt76: mt7615: do not update pm stats in case of error

Luca Weiss (1):
      ARM: dts: qcom-msm8974: fix irq type on blsp2_uart1

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression

Lukas Czerner (2):
      ext4: check if directory block is within i_size
      ext4: make sure ext4_append() always allocates new block

Lukas Wunner (6):
      usbnet: Fix linkwatch use-after-free on disconnect
      usbnet: smsc95xx: Don't clear read-only PHY interrupt
      usbnet: smsc95xx: Avoid link settings race on interrupt reception
      usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling
      usbnet: smsc95xx: Fix deadlock on runtime resume
      net: phy: smsc: Disable Energy Detect Power-Down in interrupt mode

Luo Meng (1):
      dm thin: fix use-after-free crash in dm_sm_register_threshold_callback

Lv Ruyi (1):
      firmware: tegra: Fix error check return value of debugfs_create_file()

Lyude Paul (3):
      drm/nouveau: Don't pm_runtime_put_sync(), only pm_runtime_put_autosuspend()
      drm/nouveau/acpi: Don't print error when we get -EINPROGRESS from pm_runtime
      drm/nouveau/kms: Fix failure path for creating DP connectors

Maciej Fijalkowski (1):
      selftests/xsk: Destroy BPF resources only when ctx refcount drops to 0

Maciej S. Szmigiero (1):
      KVM: SVM: Don't BUG if userspace injects an interrupt with GIF=0

Maciej W. Rozycki (3):
      serial: 8250: Export ICR access helpers for internal use
      serial: 8250: Fold EndRun device support into OxSemi Tornado code
      serial: 8250: Add proper clock handling for OxSemi PCIe devices

Maciej Żenczykowski (1):
      net: usb: make USB_RTL8153_ECM non user configurable

Maher Sanalla (1):
      net/mlx5: Adjust log_max_qp to be 18 at most

Mahesh Rajashekhara (1):
      scsi: smartpqi: Fix DMA direction for RAID requests

Manikanta Pubbisetty (1):
      ath11k: Fix incorrect debug_mask mappings

Manivannan Sadhasivam (1):
      ARM: dts: qcom: sdx55: Fix the IRQ trigger type for UART

Manyi Li (1):
      ACPI: PM: save NVS memory for Lenovo G40-45

Maor Gottlieb (1):
      RDMA/mlx5: Add missing check for return value in get namespace flow

Marc Kleine-Budde (2):
      can: netlink: allow configuring of fixed bit rates without need for do_set_bittiming callback
      can: netlink: allow configuring of fixed data bit rates without need for do_set_data_bittiming callback

Marcel Ziswiler (1):
      ARM: dts: imx7d-colibri-emmc: add cpu1 supply

Marco Pagani (1):
      fpga: altera-pr-ip: fix unsigned comparison with less than zero

Marek Vasut (2):
      drm/bridge: tc358767: Move (e)DP bridge endpoint parsing into dedicated function
      drm/bridge: tc358767: Fix (e)DP bridge endpoint parsing in dedicated function

Marijn Suijten (2):
      arm64: dts: qcom: sm6125: Move sdc2 pinctrl from seine-pdx201 to sm6125
      arm64: dts: qcom: sm6125: Append -state suffix to pinctrl nodes

Mario Limonciello (1):
      HID: amd_sfh: Don't show client init failed as error when discovery fails

Mark Brown (1):
      mtd: dataflash: Add SPI ID table

Mark Rutland (2):
      arch: make TRACE_IRQFLAGS_NMI_SUPPORT generic
      arm64: select TRACE_IRQFLAGS_NMI_SUPPORT

Markus Mayer (1):
      thermal/tools/tmon: Include pthread and time headers in tmon.h

Masami Hiramatsu (2):
      tracing: Add '__rel_loc' using trace event macros
      tracing: Avoid -Warray-bounds warning for __rel_loc macro

Masami Hiramatsu (Google) (1):
      x86/kprobes: Update kcb status flag after singlestepping

Mateusz Kwiatkowski (1):
      drm/vc4: hdmi: Fix timings for interlaced modes

Mathew McBride (1):
      rtc: rx8025: fix 12/24 hour mode detection on RX-8035

Max Filippov (1):
      xtensa: iss/network: provide release() callback

Maxim Mikityanskiy (1):
      net/mlx5e: Fix the value of MLX5E_MAX_RQ_NUM_MTTS

Maxime Ripard (4):
      drm/bridge: Add a function to abstract away panels
      drm/vc4: dsi: Switch to devm_drm_of_get_bridge
      drm/vc4: hdmi: Fix HPD GPIO detection
      drm/bridge: Move devm_drm_of_get_bridge to bridge/panel.c

Maximilian Heyne (1):
      xen-blkback: Apply 'feature_persistent' parameter when connect

Maximilian Luz (1):
      HID: hid-input: add Surface Go battery quirk

Md Haris Iqbal (5):
      RDMA/rtrs: Introduce destroy_cq helper
      RDMA/rtrs: Do not allow sessname to contain special symbols / and .
      RDMA/rtrs-clt: Replace list_next_or_null_rr_rcu with an inline function
      RDMA/rxe: For invalidate compare according to set keys in mr
      block/rnbd-srv: Set keep_id to true after mutex_trylock

Mel Gorman (1):
      sched/core: Do not requeue task on CPU excluded from cpus_mask

Meng Tang (2):
      ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model
      ALSA: hda/realtek: Add quirk for another Asus K42JZ model

Miaohe Lin (3):
      lib/test_hmm: avoid accessing uninitialized pages
      mm/memremap: fix memunmap_pages() race with get_dev_pagemap()
      mm/mmap.c: fix missing call to vm_unacct_memory in mmap_region

Miaoqian Lin (34):
      meson-mx-socinfo: Fix refcount leak in meson_mx_socinfo_init
      ARM: bcm: Fix refcount leak in bcm_kona_smc_init
      ARM: OMAP2+: Fix refcount leak in omapdss_init_of
      ARM: OMAP2+: Fix refcount leak in omap3xxx_prm_late_init
      cpufreq: zynq: Fix refcount leak in zynq_get_revision
      soc: qcom: ocmem: Fix refcount leak in of_get_ocmem
      soc: qcom: aoss: Fix refcount leak in qmp_cooling_devices_register
      drm/meson: encoder_hdmi: Fix refcount leak in meson_encoder_hdmi_init
      drm/virtio: Fix NULL vs IS_ERR checking in virtio_gpu_object_shmem_init
      drm/mcde: Fix refcount leak in mcde_dsi_bind
      media: tw686x: Fix memory leak in tw686x_video_init
      mtd: maps: Fix refcount leak in of_flash_probe_versatile
      mtd: maps: Fix refcount leak in ap_flash_init
      PCI: microchip: Fix refcount leak in mc_pcie_init_irq_domains()
      PCI: tegra194: Fix PM error handling in tegra_pcie_config_ep()
      mtd: partitions: Fix refcount leak in parse_redboot_of
      mtd: parsers: ofpart: Fix refcount leak in bcm4908_partitions_fw_offset
      PCI: mediatek-gen3: Fix refcount leak in mtk_pcie_init_irq_domains()
      usb: host: Fix refcount leak in ehci_hcd_ppc_of_probe
      usb: ohci-nxp: Fix refcount leak in ohci_hcd_nxp_probe
      mmc: sdhci-of-esdhc: Fix refcount leak in esdhc_signal_voltage_switch
      ASoC: cros_ec_codec: Fix refcount leak in cros_ec_codec_platform_probe
      ASoC: samsung: Fix error handling in aries_audio_probe
      ASoC: mediatek: mt8173: Fix refcount leak in mt8173_rt5650_rt5676_dev_probe
      ASoC: mt6797-mt6351: Fix refcount leak in mt6797_mt6351_dev_probe
      ASoC: mediatek: mt8173-rt5650: Fix refcount leak in mt8173_rt5650_dev_probe
      remoteproc: k3-r5: Fix refcount leak in k3_r5_cluster_of_init
      remoteproc: imx_rproc: Fix refcount leak in imx_rproc_addr_init
      rpmsg: qcom_smd: Fix refcount leak in qcom_smd_parse_edge
      mfd: max77620: Fix refcount leak in max77620_initialise_fps
      powerpc/spufs: Fix refcount leak in spufs_init_isolated_loader
      powerpc/xive: Fix refcount leak in xive_get_max_prio
      powerpc/cell/axon_msi: Fix refcount leak in setup_msi_msg_address
      drm/meson: Fix refcount leak in meson_encoder_hdmi_init

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

Mike Christie (3):
      scsi: iscsi: Allow iscsi_if_stop_conn() to be called from kernel
      scsi: iscsi: Add helper to remove a session from the kernel
      scsi: iscsi: Fix session removal on shutdown

Mike Manning (1):
      net: allow unbound socket for packets in VRF when tcp_l3mdev_accept set

Mike Snitzer (1):
      dm: return early from dm_pr_call() if DM device is suspended

Mikko Perttunen (2):
      arm64: tegra: Update Tegra234 BPMP channel addresses
      arm64: tegra: Mark BPMP channels as no-memory-wc

Miklos Szeredi (2):
      fuse: limit nsec
      fuse: ioctl: translate ENOSYS

Mikulas Patocka (10):
      add barriers to buffer_uptodate and set_buffer_uptodate
      md-raid: destroy the bitmap after destroying the thread
      md-raid10: fix KASAN warning
      dm writecache: return void from functions
      dm writecache: count number of blocks read, not number of read bios
      dm writecache: count number of blocks written, not number of write bios
      dm writecache: count number of blocks discarded, not number of discard bios
      dm writecache: set a default MAX_WRITEBACK_JOBS
      dm raid: fix address sanitizer warning in raid_status
      dm raid: fix address sanitizer warning in raid_resume

Ming Lei (1):
      blk-mq: don't create hctx debugfs dir until q->debugfs_dir is created

Ming Qian (12):
      media: imx-jpeg: Correct some definition according specification
      media: imx-jpeg: Leave a blank space before the configuration data
      media: imx-jpeg: use NV12M to represent non contiguous NV12
      media: imx-jpeg: Set V4L2_BUF_FLAG_LAST at eos
      media: imx-jpeg: Refactor function mxc_jpeg_parse
      media: imx-jpeg: Identify and handle precision correctly
      media: imx-jpeg: Handle source change in a function
      media: imx-jpeg: Support dynamic resolution change
      media: imx-jpeg: Align upwards buffer size
      media: imx-jpeg: Implement drain using v4l2-mem2mem helpers
      media: imx-jpeg: Disable slot interrupt when frame done
      media: v4l2-mem2mem: prevent pollerr when last_buffer_dequeued is set

Minghao Chi (CGEL ZTE) (1):
      drm/vc4: Use of_device_get_match_data()

Miquel Raynal (1):
      serial: 8250: dma: Allow driver operations before starting DMA transfers

Mirela Rabulea (1):
      media: imx-jpeg: Add pm-runtime support for imx-jpeg

Mohamed Khalfella (1):
      PCI/AER: Iterate over error counters instead of error strings

Mordechay Goodstein (1):
      ieee80211: add EHT 1K aggregation definitions

Mustafa Ismail (3):
      RDMA/irdma: Fix a window for use-after-free
      RDMA/irdma: Fix VLAN connection with wildcard address
      RDMA/irdma: Fix setting of QP context err_rq_idx_valid field

Namjae Jeon (2):
      ksmbd: fix memory leak in smb2_handle_negotiate
      ksmbd: fix use-after-free bug in smb2_tree_disconect

Naohiro Aota (1):
      btrfs: ensure pages are unlocked on cow_file_range() failure

Narendra Hadke (1):
      serial: mvebu-uart: uart2 error bits clearing

Nathan Chancellor (1):
      usb: cdns3: Don't use priv_dev uninitialized in cdns3_gadget_ep_enable()

Neil Armstrong (1):
      drm/meson: encoder_hdmi: switch to bridge DRM_BRIDGE_ATTACH_NO_CONNECTOR

Nick Bowler (1):
      nvme: define compat_ioctl again to unbreak 32-bit userspace.

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

Nikita Travkin (2):
      clk: qcom: clk-rcg2: Fail Duty-Cycle configuration if MND divider is not enabled.
      clk: qcom: clk-rcg2: Make sure to not write d=0 to the NMD register

Nikolay Borisov (1):
      btrfs: properly flag filesystem with BTRFS_FEATURE_INCOMPAT_BIG_METADATA

Nilesh Javali (1):
      scsi: Revert "scsi: qla2xxx: Fix disk failure to rediscover"

Nícolas F. R. A. Prado (2):
      arm64: dts: mt8192: Fix idle-states nodes naming scheme
      arm64: dts: mt8192: Fix idle-states entry-method

Olga Kitaina (1):
      mtd: rawnand: arasan: Fix clock rate in NV-DDR

Pali Rohár (4):
      PCI: Add defines for normal and subtractive PCI bridges
      powerpc/fsl-pci: Fix Class Code of PCIe Root Port
      crypto: inside-secure - Add missing MODULE_DEVICE_TABLE for of
      powerpc/pci: Prefer PCI domain assignment via DT 'linux,pci-domain' and alias

Paolo Bonzini (2):
      KVM: x86: do not report preemption if the steal time cache is stale
      KVM: x86: revalidate steal time cache if MSR value changes

Patrice Chotard (1):
      mtd: spi-nor: fix spi_nor_spimem_setup_op() call in spi_nor_erase_{sector,chip}()

Paul E. McKenney (2):
      rcutorture: Warn on individual rcu_torture_init() error conditions
      rcutorture: Don't cpuhp_remove_state() if cpuhp_setup_state() failed

Pavel Begunkov (1):
      io_uring: mem-account pbuf buckets

Pavel Skripkin (1):
      ath9k: fix use-after-free in ath9k_hif_usb_rx_cb

Peng Fan (1):
      interconnect: imx: fix max_node_id

Peter Wang (1):
      scsi: ufs: core: Correct ufshcd_shutdown() flow

Peter Zijlstra (2):
      locking/lockdep: Fix lockdep_init_map_*() confusion
      x86/extable: Fix ex_handler_msr() print condition

Phil Elwell (1):
      drm/vc4: hdmi: Disable audio if dmas property is present but empty

Pierre-Louis Bossart (2):
      soundwire: bus_type: fix remove and shutdown support
      soundwire: revisit driver bind/unbind and callbacks

Ping Cheng (2):
      HID: wacom: Only report rotation for art pen
      HID: wacom: Don't register pad_input for touch switch

Przemyslaw Patynowski (2):
      iavf: Fix max_rate limiting
      iavf: Fix 'tc qdisc show' listing too many queues

Puranjay Mohan (1):
      dt-bindings: iio: accel: Add DT binding doc for ADXL355

Qian Cai (1):
      crypto: arm64/gcm - Select AEAD for GHASH_ARM64_CE

Qiao Ma (2):
      net: hinic: fix bug that ethtool get wrong stats
      net: hinic: avoid kernel hung in hinic_get_stats64()

Qu Wenruo (1):
      btrfs: reject log replay if there is unsupported RO compat flag

Quentin Perret (1):
      KVM: arm64: Don't return from void function

Quinn Tran (18):
      scsi: qla2xxx: edif: Reduce Initiator-Initiator thrashing
      scsi: qla2xxx: edif: Fix potential stuck session in sa update
      scsi: qla2xxx: edif: Reduce connection thrash
      scsi: qla2xxx: edif: Fix inconsistent check of db_flags
      scsi: qla2xxx: edif: Synchronize NPIV deletion with authentication application
      scsi: qla2xxx: edif: Add retry for ELS passthrough
      scsi: qla2xxx: edif: Fix n2n discovery issue with secure target
      scsi: qla2xxx: edif: Fix n2n login retry for secure device
      scsi: qla2xxx: edif: Send LOGO for unexpected IKE message
      scsi: qla2xxx: edif: Reduce disruption due to multiple app start
      scsi: qla2xxx: edif: Fix no login after app start
      scsi: qla2xxx: edif: Tear down session if keys have been removed
      scsi: qla2xxx: edif: Fix session thrash
      scsi: qla2xxx: edif: Fix no logout on delete for N2N
      scsi: qla2xxx: Fix imbalance vha->vref_count
      scsi: qla2xxx: Turn off multi-queue for 8G adapters
      scsi: qla2xxx: Fix erroneous mailbox timeout after PCI error injection
      scsi: qla2xxx: Wind down adapter after PCIe error

Rafael J. Wysocki (2):
      thermal: sysfs: Fix cooling_device_stats_setup() error code path
      ACPI: CPPC: Do not prevent CPPC from working in the future

Ralph Siemsen (1):
      clk: renesas: r9a06g032: Fix UART clkgrp bitsel

Randy Dunlap (1):
      usb: gadget: udc: amd5536 depends on HAS_DMA

Rex-BC Chen (1):
      clk: mediatek: reset: Fix written reset bit offset

Rob Clark (4):
      drm/msm/mdp5: Fix global state lock backoff
      drm/msm: Avoid dirtyfb stalls on video mode displays (v2)
      drm/msm/dpu: Fix for non-visible planes
      drm/msm: Fix dirtyfb refcounting

Robert Marko (6):
      arm64: dts: qcom: ipq8074: fix NAND node name
      clk: qcom: ipq8074: fix NSS core PLL-s
      clk: qcom: ipq8074: SW workaround for UBI32 PLL lock
      clk: qcom: ipq8074: fix NSS port frequency tables
      clk: qcom: ipq8074: set BRANCH_HALT_DELAY flag for UBI clocks
      PCI: qcom: Power on PHY before IPQ8074 DBI register accesses

Robin Murphy (1):
      swiotlb: fail map correctly with failed io_tlb_default_mem

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

Sean Christopherson (17):
      KVM: nVMX: Snapshot pre-VM-Enter BNDCFGS for !nested_run_pending case
      KVM: nVMX: Snapshot pre-VM-Enter DEBUGCTL for !nested_run_pending case
      KVM: x86: Split kvm_is_valid_cr4() and export only the non-vendor bits
      KVM: nVMX: Let userspace set nVMX MSR to any _host_ supported value
      KVM: nVMX: Account for KVM reserved CR4 bits in consistency checks
      KVM: nVMX: Inject #UD if VMXON is attempted with incompatible CR0/CR4
      KVM: x86: Mark TSS busy during LTR emulation _after_ all fault checks
      KVM: x86: Set error code to segment selector on LLDT/LTR non-canonical #GP
      KVM: x86: Tag kvm_mmu_x86_module_init() with __init
      KVM: SVM: Unwind "speculative" RIP advancement if INTn injection "fails"
      KVM: SVM: Stuff next_rip on emulated INT3 injection if NRIPS is supported
      KVM: Don't set Accessed/Dirty bits for ZERO_PAGE
      KVM: nVMX: Set UMIP bit CR4_FIXED1 MSR when emulating UMIP
      KVM: x86: Signal #GP, not -EPERM, on bad WRMSR(MCi_CTL/STATUS)
      KVM: VMX: Mark all PERF_GLOBAL_(OVF)_CTRL bits reserved if there's no vPMU
      KVM: VMX: Add helper to check if the guest PMU has PERF_GLOBAL_CTRL
      KVM: nVMX: Attempt to load PERF_GLOBAL_CTRL on nVMX xfer iff it exists

Sebastian Fricke (1):
      media: staging: media: hantro: Fix typos

SeongJae Park (2):
      xen-blkback: fix persistent grants negotiation
      xen-blkfront: Apply 'feature_persistent' parameter when connect

Serge Semin (7):
      dmaengine: dw-edma: Fix eDMA Rd/Wr-channels and DMA-direction semantics
      PCI: dwc: Stop link on host_init errors and de-initialization
      PCI: dwc: Add unroll iATU space support to dw_pcie_disable_atu()
      PCI: dwc: Disable outbound windows only for controllers using iATU
      PCI: dwc: Set INCREASE_REGION_SIZE flag based on limit address
      PCI: dwc: Deallocate EPC memory on dw_pcie_ep_init() errors
      PCI: dwc: Always enable CDM check if "snps,enable-cdm-check" exists

Sergey Shtylyov (1):
      usb: host: xhci: use snprintf() in xhci_decode_trb()

Shengjiu Wang (6):
      rpmsg: char: Add mutex protection for rpmsg_eptdev_open()
      ASoC: imx-card: Fix DSD/PDM mclk frequency
      ASoC: fsl_asrc: force cast the asrc_format type
      ASoC: fsl-asoc-card: force cast the asrc_format type
      ASoC: fsl_easrc: use snd_pcm_format_t type for sample_format
      ASoC: imx-card: use snd_pcm_format_t type for asrc_format

Sherry Sun (1):
      tty: serial: fsl_lpuart: correct the count of break characters

Shuai Xue (1):
      ACPI: APEI: explicit init of HEST and GHES in apci_init()

Shunsuke Mie (1):
      PCI: endpoint: Don't stop controller when unbinding endpoint function

Shuqi Zhang (1):
      ext4: use kmemdup() to replace kmalloc + memcpy

Sibi Sankar (1):
      remoteproc: sysmon: Wait for SSCTL service to come up

Siddh Raman Pant (1):
      x86/numa: Use cpumask_available instead of hardcoded NULL check

Siddharth Gupta (1):
      remoteproc: qcom: pas: Check if coredump is enabled

Sireesh Kodali (2):
      arm64: dts: qcom: msm8916: Fix typo in pronto remoteproc node
      remoteproc: qcom: wcnss: Fix handling of IRQs

Srinivas Kandagatla (3):
      soundwire: qcom: Check device status before reading devid
      ASoC: codecs: msm8916-wcd-digital: move gains from SX_TLV to S8_TLV
      ASoC: codecs: wcd9335: move gains from SX_TLV to S8_TLV

Stefan Roese (1):
      PCI/portdrv: Don't disable AER reporting in get_port_device_capability()

Steffen Maier (1):
      scsi: zfcp: Fix missing auto port scan and thus missing target ports

Stephan Gerhold (1):
      regulator: qcom_smd: Fix pm8916_pldo range

Stephen Boyd (2):
      arm64: dts: qcom: sc7180: Remove ipa_fw_mem node on trogdor
      platform/chrome: cros_ec: Always expose last resume result

Steven Rostedt (Google) (2):
      ftrace/x86: Add back ftrace_expected assignment
      tracing: Use a struct alignof to determine trace event field alignment

Sudeep Holla (1):
      firmware: arm_scpi: Ensure scpi_info is not assigned if the probe fails

Sumit Garg (1):
      arm64: dts: qcom: qcs404: Fix incorrect USB2 PHYs assignment

Sungjong Seo (1):
      f2fs: allow compression for mmap files in compress_mode=user

Suzuki K Poulose (1):
      coresight: Clear the connection field properly

Tadeusz Struk (1):
      bpf: Fix KASAN use-after-free Read in compute_effective_progs

Takashi Iwai (1):
      ALSA: usb-audio: Add quirk for Behringer UMC202HD

Tali Perry (2):
      i2c: npcm: Remove own slave addresses 2:10
      i2c: npcm: Correct slave role behavior

Tamás Szűcs (1):
      arm64: tegra: Fix SDMMC1 CD on P2888

Tang Bin (3):
      usb: gadget: tegra-xudc: Fix error check in tegra_xudc_powerdomain_init()
      usb: xhci: tegra: Fix error check
      opp: Fix error check in dev_pm_opp_attach_genpd()

Tetsuo Handa (3):
      tty: vt: initialize unicode screen buffer
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

Thierry Reding (1):
      arm64: tegra: Fixup SYSRAM references

Thinh Nguyen (1):
      usb: dwc3: core: Deprecate GCTL.CORESOFTRESET

Thomas Gleixner (1):
      netfilter: xtables: Bring SPDX identifier back

Thomas Zimmermann (4):
      drm/hyperv-drm: Include framebuffer and EDID headers
      drm/shmem-helper: Unexport drm_gem_shmem_create_with_handle()
      drm/shmem-helper: Export dedicated wrappers for GEM object functions
      drm/shmem-helper: Pass GEM shmem object in public interfaces

Tianchen Ding (2):
      sched: Fix the check of nr_running at queue wakelist
      sched: Remove the limitation of WF_ON_CPU on wakelist if wakee cpu is idle

Tianjia Zhang (1):
      KEYS: asymmetric: enforce SM2 signature use pkey algo

Tianyu Li (1):
      mm/mempolicy: fix get_nodes out of bound access

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

Trond Myklebust (2):
      Revert "pNFS: nfs3_set_ds_client should set NFS_CS_NOPING"
      pNFS/flexfiles: Report RDMA connection errors to the server

Tyler Hicks (1):
      net/9p: Initialize the iounit field during fid creation

Uwe Kleine-König (10):
      hwmon: (sht15) Fix wrong assumptions in device remove callback
      pwm: sifive: Simplify offset calculation for PWMCMP registers
      pwm: sifive: Ensure the clk is enabled exactly once per running PWM
      pwm: sifive: Shut down hardware only after pwmchip_remove() completed
      pwm: lpc18xx-sct: Reduce number of devm memory allocations
      pwm: lpc18xx-sct: Simplify driver by not using pwm_[gs]et_chip_data()
      pwm: lpc18xx: Fix period handling
      mtd: st_spi_fsm: Add a clk_disable_unprepare() in .probe()'s error path
      serial: 8250_fsl: Don't report FE, PE and OE twice
      mfd: t7l66xb: Drop platform disable callback

Vaibhav Jain (1):
      of: check previous kernel's ima-kexec-buffer against memory bounds

Vaishali Thakkar (3):
      RDMA/rtrs: Rename rtrs_sess to rtrs_path
      RDMA/rtrs-srv: Rename rtrs_srv_sess to rtrs_srv_path
      RDMA/rtrs-clt: Rename rtrs_clt_sess to rtrs_clt_path

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

Vitaly Kuznetsov (1):
      KVM: nVMX: Always enable TSC scaling for L2 when it was enabled for L1

Vladimir Zapolskiy (3):
      clk: qcom: camcc-sm8250: Fix halt on boot by reducing driver's init level
      clk: qcom: camcc-sdm845: Fix topology around titan_top power domain
      clk: qcom: camcc-sm8250: Fix topology around titan_top power domain

Waiman Long (1):
      sched, cpuset: Fix dl_cpu_busy() panic due to empty cs->cpus_allowed

Weitao Wang (1):
      USB: HCD: Fix URB giveback issue in tasklet function

William Dean (4):
      parisc: Check the return value of ioremap() in lba_driver_probe()
      irqchip/mips-gic: Check the return value of ioremap() in gic_of_init()
      wifi: rtw88: check the return value of alloc_workqueue()
      watchdog: armada_37xx_wdt: check the return value of devm_ioremap() in armada_37xx_wdt_probe()

Wolfram Sang (2):
      selftests: timers: valid-adjtimex: build fix for newer toolchains
      selftests: timers: clocksource-switch: fix passing errors from child

Wyes Karny (1):
      x86: Handle idle=nomwait cmdline properly for x86_idle

Xiang Chen (1):
      scsi: hisi_sas: Use managed PCI functions

Xianting Tian (4):
      RISC-V: kexec: Fixup use of smp_processor_id() in preemptible context
      RISC-V: Fixup get incorrect user mode PC for kernel mode regs
      RISC-V: Fixup schedule out issue in machine_crash_shutdown()
      RISC-V: Add modules to virtual kernel memory layout dump

Xiao Yang (1):
      RDMA/rxe: Remove the is_user members of struct rxe_sq/rxe_rq/rxe_srq

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

Xiu Jianfeng (2):
      selinux: fix memleak in security_read_state_kernel()
      selinux: Add boundary check in put_entry()

Xu Qiang (2):
      irqdomain: Report irq number for NOMAP domains
      of/fdt: declared return type does not match actual return type

Xu Wang (1):
      i2c: Fix a potential use after free

Yang Xu (1):
      fs: Add missing umask strip in vfs_tmpfile

Yang Yingliang (4):
      bus: hisi_lpc: fix missing platform_device_put() in hisi_lpc_acpi_probe()
      spi: Fix simplification of devm_spi_register_controller
      spi: tegra20-slink: fix UAF in tegra_slink_remove()
      xtensa: iss: fix handling error cases in iss_net_configure()

Ye Bin (1):
      ext4: fix warning in ext4_iomap_begin as race between bmap and write

YiFei Zhu (1):
      selftests/seccomp: Fix compile warning when CC=clang

Yipeng Zou (1):
      riscv:uprobe fix SR_SPIE set/clear handling

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

Zhihao Cheng (2):
      jbd2: fix assertion 'jh->b_frozen_data == NULL' failure when journal aborted
      proc: fix a dentry lock race between release_task and lookup

Zhu Yanjun (1):
      RDMA/rxe: Fix error unwind in rxe_create_qp()

haibinzhang (张海斌) (1):
      arm64: fix oops in concurrently setting insn_emulation sysctls

huhai (1):
      ACPI: LPSS: Fix missing check in register_device_clock()

xinhui pan (1):
      drm/amdgpu: Remove one duplicated ef removal

