Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A95B596FD0
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 15:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbiHQNZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 09:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239751AbiHQNZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 09:25:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D32972B61;
        Wed, 17 Aug 2022 06:25:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95C79B81DBF;
        Wed, 17 Aug 2022 13:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60929C433B5;
        Wed, 17 Aug 2022 13:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660742702;
        bh=vh6Zw95xm2tCqWuepygxzm2raLEmgyAF0BmrkN1fUKY=;
        h=From:To:Cc:Subject:Date:From;
        b=uoime9vKIpBlU504BkpUUBWJO7IRsYMkYdJxeqsK6IM4VL82KHsZFK1KE02BsRLgO
         K8elZJrk4aM1e4I2xcwffrAX7tpDagcqK0KYG/ZwGueVkH7CzRS9hSU54GvhB5l6hB
         w5z2XPV4iWrENEtXM1JDyRJ1mO3tAq6C+W1Y/mwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.18.18
Date:   Wed, 17 Aug 2022 15:24:53 +0200
Message-Id: <16607426939212@kroah.com>
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

I'm announcing the release of the 5.18.18 kernel.

All users of the 5.18 kernel series must upgrade.

The updated 5.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.18.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-driver-xen-blkback              |    2 
 Documentation/ABI/testing/sysfs-driver-xen-blkfront             |    2 
 Documentation/admin-guide/device-mapper/writecache.rst          |   16 
 Documentation/admin-guide/kernel-parameters.txt                 |   29 
 Documentation/admin-guide/pm/cpuidle.rst                        |   15 
 Documentation/arm64/silicon-errata.rst                          |    4 
 Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml    |    6 
 Documentation/tty/device_drivers/oxsemi-tornado.rst             |  129 
 Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst       |    2 
 MAINTAINERS                                                     |    7 
 Makefile                                                        |    8 
 arch/Kconfig                                                    |    3 
 arch/arm/boot/dts/Makefile                                      |    1 
 arch/arm/boot/dts/aspeed-ast2500-evb.dts                        |    2 
 arch/arm/boot/dts/aspeed-ast2600-evb-a1.dts                     |    1 
 arch/arm/boot/dts/aspeed-ast2600-evb.dts                        |    2 
 arch/arm/boot/dts/bcm53015-meraki-mr26.dts                      |  166 
 arch/arm/boot/dts/imx6qdl-apalis.dtsi                           |    4 
 arch/arm/boot/dts/imx6ul.dtsi                                   |   33 
 arch/arm/boot/dts/imx7d-colibri-emmc.dtsi                       |    4 
 arch/arm/boot/dts/qcom-apq8064.dtsi                             |    8 
 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts                  |  609 
 arch/arm/boot/dts/qcom-apq8084.dtsi                             |    2 
 arch/arm/boot/dts/qcom-mdm9615.dtsi                             |    1 
 arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts                |  604 
 arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts        | 1145 
 arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts                 | 1258 -
 arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dts            |  432 
 arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dts           |  996 
 arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts           |  479 
 arch/arm/boot/dts/qcom-msm8974-sony-xperia-rhine.dtsi           |  455 
 arch/arm/boot/dts/qcom-msm8974.dtsi                             | 1587 -
 arch/arm/boot/dts/qcom-pm8841.dtsi                              |    1 
 arch/arm/boot/dts/qcom-pm8941.dtsi                              |    2 
 arch/arm/boot/dts/qcom-sdx55.dtsi                               |    2 
 arch/arm/boot/dts/ste-ux500-samsung-codina.dts                  |    4 
 arch/arm/boot/dts/ste-ux500-samsung-gavini.dts                  |    4 
 arch/arm/boot/dts/ste-ux500-samsung-janice.dts                  |    4 
 arch/arm/boot/dts/uniphier-pxs2.dtsi                            |    8 
 arch/arm/crypto/Kconfig                                         |    2 
 arch/arm/crypto/Makefile                                        |    4 
 arch/arm/crypto/blake2s-shash.c                                 |   75 
 arch/arm/lib/findbit.S                                          |   16 
 arch/arm/mach-bcm/bcm_kona_smc.c                                |    1 
 arch/arm/mach-omap2/display.c                                   |    3 
 arch/arm/mach-omap2/pdata-quirks.c                              |    2 
 arch/arm/mach-omap2/prm3xxx.c                                   |    1 
 arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c              |    5 
 arch/arm/mach-zynq/common.c                                     |    1 
 arch/arm64/Kconfig                                              |   17 
 arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts       |    2 
 arch/arm64/boot/dts/exynos/exynosautov9-pinctrl.dtsi            |    6 
 arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts        |    2 
 arch/arm64/boot/dts/mediatek/mt8192.dtsi                        |   26 
 arch/arm64/boot/dts/nvidia/tegra186.dtsi                        |    1 
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi                  |    2 
 arch/arm64/boot/dts/nvidia/tegra194.dtsi                        |    1 
 arch/arm64/boot/dts/nvidia/tegra234.dtsi                        |    1 
 arch/arm64/boot/dts/qcom/ipq6018.dtsi                           |   22 
 arch/arm64/boot/dts/qcom/ipq8074.dtsi                           |    2 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                           |    4 
 arch/arm64/boot/dts/qcom/msm8996.dtsi                           |    6 
 arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino-poplar.dts |   10 
 arch/arm64/boot/dts/qcom/qcs404.dtsi                            |    4 
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi                    |    1 
 arch/arm64/boot/dts/qcom/sc7180.dtsi                            |   24 
 arch/arm64/boot/dts/qcom/sc7280.dtsi                            |   30 
 arch/arm64/boot/dts/qcom/sdm630.dtsi                            |    7 
 arch/arm64/boot/dts/qcom/sdm636-sony-xperia-ganges-mermaid.dts  |    2 
 arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama-akatsuki.dts   |    5 
 arch/arm64/boot/dts/qcom/sdm845.dtsi                            |   22 
 arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts    |   36 
 arch/arm64/boot/dts/qcom/sm6125.dtsi                            |   30 
 arch/arm64/boot/dts/qcom/sm6350.dtsi                            |   22 
 arch/arm64/boot/dts/qcom/sm8150.dtsi                            |   24 
 arch/arm64/boot/dts/qcom/sm8250.dtsi                            |   30 
 arch/arm64/boot/dts/qcom/sm8350.dtsi                            |   24 
 arch/arm64/boot/dts/qcom/sm8450.dtsi                            |   22 
 arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi       |    6 
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi                       |    2 
 arch/arm64/boot/dts/renesas/r8a77990.dtsi                       |    2 
 arch/arm64/boot/dts/renesas/r8a779m8.dtsi                       |    5 
 arch/arm64/boot/dts/renesas/r9a07g054l2-smarc.dts               |    2 
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi                |    8 
 arch/arm64/crypto/Kconfig                                       |    1 
 arch/arm64/include/asm/esr.h                                    |    6 
 arch/arm64/include/asm/kexec.h                                  |    4 
 arch/arm64/include/asm/processor.h                              |    3 
 arch/arm64/kernel/armv8_deprecated.c                            |    9 
 arch/arm64/kernel/cpu_errata.c                                  |   16 
 arch/arm64/kernel/cpufeature.c                                  |   16 
 arch/arm64/kernel/hibernate.c                                   |    5 
 arch/arm64/kernel/mte.c                                         |    9 
 arch/arm64/kvm/hyp/nvhe/switch.c                                |    2 
 arch/arm64/kvm/hyp/vhe/switch.c                                 |    2 
 arch/arm64/mm/copypage.c                                        |    9 
 arch/arm64/mm/mteswap.c                                         |    9 
 arch/arm64/tools/cpucaps                                        |    1 
 arch/ia64/include/asm/processor.h                               |    2 
 arch/ia64/kernel/palinfo.c                                      |    2 
 arch/ia64/kernel/traps.c                                        |    2 
 arch/ia64/mm/init.c                                             |    2 
 arch/ia64/mm/tlb.c                                              |    4 
 arch/mips/kernel/proc.c                                         |    2 
 arch/mips/kernel/vdso.c                                         |    2 
 arch/mips/loongson64/numa.c                                     |    1 
 arch/mips/mm/physaddr.c                                         |   14 
 arch/parisc/kernel/cache.c                                      |    3 
 arch/parisc/kernel/drivers.c                                    |    9 
 arch/parisc/kernel/syscalls/syscall.tbl                         |    2 
 arch/powerpc/boot/cuboot-hotfoot.c                              |    2 
 arch/powerpc/configs/44x/akebono_defconfig                      |    2 
 arch/powerpc/configs/44x/currituck_defconfig                    |    2 
 arch/powerpc/configs/44x/fsp2_defconfig                         |    2 
 arch/powerpc/configs/44x/iss476-smp_defconfig                   |    2 
 arch/powerpc/configs/44x/warp_defconfig                         |    2 
 arch/powerpc/configs/52xx/lite5200b_defconfig                   |    2 
 arch/powerpc/configs/52xx/motionpro_defconfig                   |    2 
 arch/powerpc/configs/52xx/tqm5200_defconfig                     |    2 
 arch/powerpc/configs/adder875_defconfig                         |    2 
 arch/powerpc/configs/ep8248e_defconfig                          |    2 
 arch/powerpc/configs/ep88xc_defconfig                           |    2 
 arch/powerpc/configs/fsl-emb-nonhw.config                       |    2 
 arch/powerpc/configs/mgcoge_defconfig                           |    2 
 arch/powerpc/configs/mpc5200_defconfig                          |    2 
 arch/powerpc/configs/mpc8272_ads_defconfig                      |    2 
 arch/powerpc/configs/mpc885_ads_defconfig                       |    2 
 arch/powerpc/configs/ppc6xx_defconfig                           |    2 
 arch/powerpc/configs/pq2fads_defconfig                          |    2 
 arch/powerpc/configs/ps3_defconfig                              |    2 
 arch/powerpc/configs/tqm8xx_defconfig                           |    2 
 arch/powerpc/crypto/aes-spe-glue.c                              |    2 
 arch/powerpc/include/asm/archrandom.h                           |    5 
 arch/powerpc/include/asm/kexec.h                                |    9 
 arch/powerpc/include/asm/simple_spinlock.h                      |   15 
 arch/powerpc/kernel/Makefile                                    |    1 
 arch/powerpc/kernel/cputable.c                                  |    2 
 arch/powerpc/kernel/dawr.c                                      |    2 
 arch/powerpc/kernel/eeh.c                                       |    4 
 arch/powerpc/kernel/eeh_event.c                                 |    2 
 arch/powerpc/kernel/fadump.c                                    |    4 
 arch/powerpc/kernel/iommu.c                                     |    5 
 arch/powerpc/kernel/module_32.c                                 |    2 
 arch/powerpc/kernel/module_64.c                                 |    4 
 arch/powerpc/kernel/pci-common.c                                |   31 
 arch/powerpc/kernel/pci_of_scan.c                               |    2 
 arch/powerpc/kernel/process.c                                   |    4 
 arch/powerpc/kernel/prom_init.c                                 |    2 
 arch/powerpc/kernel/ptrace/ptrace-view.c                        |    2 
 arch/powerpc/kernel/rtas_flash.c                                |    2 
 arch/powerpc/kernel/setup-common.c                              |    2 
 arch/powerpc/kernel/signal_64.c                                 |    2 
 arch/powerpc/kernel/smp.c                                       |    2 
 arch/powerpc/kernel/time.c                                      |    4 
 arch/powerpc/kernel/watchdog.c                                  |    2 
 arch/powerpc/kexec/core_64.c                                    |    2 
 arch/powerpc/kexec/file_load_64.c                               |   55 
 arch/powerpc/kvm/book3s_64_mmu_hv.c                             |    2 
 arch/powerpc/kvm/book3s_64_vio_hv.c                             |    2 
 arch/powerpc/kvm/book3s_emulate.c                               |    2 
 arch/powerpc/kvm/book3s_hv_builtin.c                            |    7 
 arch/powerpc/kvm/book3s_hv_p9_entry.c                           |    2 
 arch/powerpc/kvm/book3s_hv_uvmem.c                              |    2 
 arch/powerpc/kvm/book3s_pr.c                                    |    2 
 arch/powerpc/kvm/book3s_xics.c                                  |    2 
 arch/powerpc/kvm/book3s_xive.c                                  |    6 
 arch/powerpc/kvm/e500mc.c                                       |    2 
 arch/powerpc/mm/book3s64/hash_pgtable.c                         |    2 
 arch/powerpc/mm/book3s64/hash_utils.c                           |    4 
 arch/powerpc/mm/book3s64/pgtable.c                              |    2 
 arch/powerpc/mm/book3s64/radix_pgtable.c                        |    2 
 arch/powerpc/mm/book3s64/radix_tlb.c                            |    2 
 arch/powerpc/mm/book3s64/slb.c                                  |    4 
 arch/powerpc/mm/init_64.c                                       |    4 
 arch/powerpc/mm/kasan/kasan_init_32.c                           |    2 
 arch/powerpc/mm/nohash/8xx.c                                    |    4 
 arch/powerpc/mm/nohash/book3e_hugetlbpage.c                     |    2 
 arch/powerpc/mm/nohash/kaslr_booke.c                            |    2 
 arch/powerpc/mm/nohash/tlb_low_64e.S                            |   17 
 arch/powerpc/mm/pgtable-frag.c                                  |    2 
 arch/powerpc/mm/pgtable_32.c                                    |    6 
 arch/powerpc/mm/ptdump/shared.c                                 |    6 
 arch/powerpc/perf/8xx-pmu.c                                     |    2 
 arch/powerpc/perf/core-book3s.c                                 |   41 
 arch/powerpc/perf/imc-pmu.c                                     |    4 
 arch/powerpc/perf/isa207-common.c                               |    6 
 arch/powerpc/platforms/512x/clock-commonclk.c                   |    2 
 arch/powerpc/platforms/512x/mpc512x_shared.c                    |    2 
 arch/powerpc/platforms/52xx/mpc52xx_common.c                    |    2 
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c                       |    2 
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c                   |    2 
 arch/powerpc/platforms/85xx/mpc85xx_cds.c                       |    2 
 arch/powerpc/platforms/86xx/gef_ppc9a.c                         |    2 
 arch/powerpc/platforms/86xx/gef_sbc310.c                        |    2 
 arch/powerpc/platforms/86xx/gef_sbc610.c                        |    2 
 arch/powerpc/platforms/Kconfig.cputype                          |    4 
 arch/powerpc/platforms/book3s/vas-api.c                         |    2 
 arch/powerpc/platforms/cell/axon_msi.c                          |    1 
 arch/powerpc/platforms/cell/cbe_regs.c                          |    2 
 arch/powerpc/platforms/cell/iommu.c                             |    2 
 arch/powerpc/platforms/cell/spider-pci.c                        |    2 
 arch/powerpc/platforms/cell/spu_manage.c                        |    2 
 arch/powerpc/platforms/cell/spufs/inode.c                       |    1 
 arch/powerpc/platforms/powermac/low_i2c.c                       |    2 
 arch/powerpc/platforms/powernv/eeh-powernv.c                    |   10 
 arch/powerpc/platforms/powernv/idle.c                           |    4 
 arch/powerpc/platforms/powernv/ocxl.c                           |    2 
 arch/powerpc/platforms/powernv/opal-fadump.c                    |    2 
 arch/powerpc/platforms/powernv/opal-lpc.c                       |    2 
 arch/powerpc/platforms/powernv/opal-memory-errors.c             |    2 
 arch/powerpc/platforms/powernv/pci-sriov.c                      |    2 
 arch/powerpc/platforms/powernv/rng.c                            |   34 
 arch/powerpc/platforms/ps3/mm.c                                 |    2 
 arch/powerpc/platforms/ps3/system-bus.c                         |    2 
 arch/powerpc/platforms/pseries/eeh_pseries.c                    |    2 
 arch/powerpc/platforms/pseries/iommu.c                          |   89 
 arch/powerpc/platforms/pseries/setup.c                          |    4 
 arch/powerpc/platforms/pseries/vas-sysfs.c                      |    2 
 arch/powerpc/platforms/pseries/vas.c                            |    2 
 arch/powerpc/sysdev/fsl_lbc.c                                   |    2 
 arch/powerpc/sysdev/fsl_pci.c                                   |   10 
 arch/powerpc/sysdev/fsl_pci.h                                   |    1 
 arch/powerpc/sysdev/ge/ge_pic.c                                 |    2 
 arch/powerpc/sysdev/mpic_msgr.c                                 |    2 
 arch/powerpc/sysdev/mpic_msi.c                                  |    2 
 arch/powerpc/sysdev/mpic_timer.c                                |    2 
 arch/powerpc/sysdev/mpic_u3msi.c                                |    2 
 arch/powerpc/sysdev/xive/native.c                               |    2 
 arch/powerpc/sysdev/xive/spapr.c                                |    1 
 arch/powerpc/xmon/ppc-opc.c                                     |    2 
 arch/powerpc/xmon/xmon.c                                        |    2 
 arch/riscv/boot/dts/starfive/jh7100.dtsi                        |    2 
 arch/riscv/include/asm/cpu_ops.h                                |    1 
 arch/riscv/kernel/cpu_ops.c                                     |    4 
 arch/riscv/kernel/cpu_ops_spinwait.c                            |    6 
 arch/riscv/kernel/crash_save_regs.S                             |    2 
 arch/riscv/kernel/machine_kexec.c                               |   28 
 arch/riscv/kernel/probes/uprobes.c                              |    6 
 arch/riscv/lib/uaccess.S                                        |    4 
 arch/riscv/mm/init.c                                            |    4 
 arch/s390/include/asm/gmap.h                                    |    2 
 arch/s390/include/asm/kexec.h                                   |    3 
 arch/s390/include/asm/unwind.h                                  |    2 
 arch/s390/kernel/crash_dump.c                                   |    2 
 arch/s390/kernel/machine_kexec_file.c                           |   18 
 arch/s390/kvm/intercept.c                                       |   15 
 arch/s390/kvm/pv.c                                              |    9 
 arch/s390/kvm/sigp.c                                            |    4 
 arch/s390/mm/gmap.c                                             |   86 
 arch/um/drivers/random.c                                        |    2 
 arch/um/include/asm/archrandom.h                                |   30 
 arch/um/include/asm/xor.h                                       |    2 
 arch/um/include/shared/os.h                                     |    7 
 arch/um/kernel/um_arch.c                                        |    8 
 arch/um/os-Linux/util.c                                         |    6 
 arch/x86/Kconfig                                                |    1 
 arch/x86/Kconfig.debug                                          |    3 
 arch/x86/boot/Makefile                                          |    2 
 arch/x86/boot/compressed/Makefile                               |    4 
 arch/x86/crypto/Makefile                                        |    4 
 arch/x86/crypto/blake2s-glue.c                                  |    3 
 arch/x86/crypto/blake2s-shash.c                                 |   77 
 arch/x86/entry/Makefile                                         |    3 
 arch/x86/entry/thunk_32.S                                       |    2 
 arch/x86/entry/thunk_64.S                                       |    4 
 arch/x86/entry/vdso/Makefile                                    |    2 
 arch/x86/events/intel/lbr.c                                     |   36 
 arch/x86/include/asm/kexec.h                                    |    6 
 arch/x86/include/asm/kvm_host.h                                 |    3 
 arch/x86/kernel/cpu/bugs.c                                      |   10 
 arch/x86/kernel/cpu/intel.c                                     |   27 
 arch/x86/kernel/ftrace.c                                        |    1 
 arch/x86/kernel/kprobes/core.c                                  |   18 
 arch/x86/kernel/pmem.c                                          |    7 
 arch/x86/kernel/process.c                                       |    9 
 arch/x86/kvm/emulate.c                                          |   23 
 arch/x86/kvm/mmu/mmu.c                                          |    2 
 arch/x86/kvm/mmu/paging_tmpl.h                                  |    9 
 arch/x86/kvm/mmu/spte.c                                         |    2 
 arch/x86/kvm/svm/nested.c                                       |    3 
 arch/x86/kvm/svm/svm.c                                          |   29 
 arch/x86/kvm/vmx/nested.c                                       |  107 
 arch/x86/kvm/vmx/nested.h                                       |    3 
 arch/x86/kvm/vmx/pmu_intel.c                                    |   13 
 arch/x86/kvm/vmx/vmx.c                                          |    4 
 arch/x86/kvm/vmx/vmx.h                                          |   12 
 arch/x86/kvm/x86.c                                              |   33 
 arch/x86/kvm/x86.h                                              |    2 
 arch/x86/mm/extable.c                                           |   16 
 arch/x86/mm/numa.c                                              |    4 
 arch/x86/net/bpf_jit_comp.c                                     |   67 
 arch/x86/platform/olpc/olpc-xo1-sci.c                           |    2 
 arch/x86/um/Makefile                                            |    3 
 arch/xtensa/platforms/iss/network.c                             |   42 
 block/bio.c                                                     |   99 
 block/blk-iocost.c                                              |   20 
 block/blk-iolatency.c                                           |   18 
 block/blk-mq-debugfs.c                                          |   28 
 block/blk-mq-debugfs.h                                          |    5 
 block/blk-mq-sched.c                                            |   11 
 block/blk-rq-qos.c                                              |    2 
 block/blk-rq-qos.h                                              |   18 
 block/blk-sysfs.c                                               |   20 
 block/blk-wbt.c                                                 |   12 
 crypto/Kconfig                                                  |   20 
 crypto/Makefile                                                 |    1 
 crypto/asymmetric_keys/public_key.c                             |    7 
 crypto/blake2s_generic.c                                        |   75 
 crypto/tcrypt.c                                                 |   12 
 crypto/testmgr.c                                                |   24 
 crypto/testmgr.h                                                |  217 
 drivers/acpi/acpi_lpss.c                                        |    3 
 drivers/acpi/apei/einj.c                                        |    2 
 drivers/acpi/bus.c                                              |    1 
 drivers/acpi/cppc_acpi.c                                        |   54 
 drivers/acpi/ec.c                                               |   82 
 drivers/acpi/processor_idle.c                                   |    6 
 drivers/acpi/sleep.c                                            |    8 
 drivers/acpi/video_detect.c                                     |    8 
 drivers/acpi/viot.c                                             |   26 
 drivers/android/binder.c                                        |  114 
 drivers/android/binder_alloc.c                                  |   30 
 drivers/android/binder_alloc.h                                  |    2 
 drivers/android/binder_alloc_selftest.c                         |    2 
 drivers/android/binder_internal.h                               |   46 
 drivers/android/binderfs.c                                      |   47 
 drivers/base/dd.c                                               |    5 
 drivers/base/node.c                                             |    4 
 drivers/base/power/domain.c                                     |    3 
 drivers/base/topology.c                                         |   32 
 drivers/block/null_blk/main.c                                   |   14 
 drivers/block/rnbd/rnbd-srv.c                                   |    3 
 drivers/block/xen-blkback/xenbus.c                              |   20 
 drivers/block/xen-blkfront.c                                    |    4 
 drivers/bluetooth/hci_intel.c                                   |    6 
 drivers/bluetooth/hci_serdev.c                                  |   11 
 drivers/bus/hisi_lpc.c                                          |   10 
 drivers/char/tpm/tpm2-cmd.c                                     |    6 
 drivers/clk/imx/clk-fracn-gppll.c                               |   33 
 drivers/clk/imx/clk-imx93.c                                     |    4 
 drivers/clk/mediatek/reset.c                                    |    4 
 drivers/clk/qcom/camcc-sdm845.c                                 |    4 
 drivers/clk/qcom/camcc-sm8250.c                                 |   16 
 drivers/clk/qcom/clk-krait.c                                    |    7 
 drivers/clk/qcom/clk-rcg2.c                                     |   16 
 drivers/clk/qcom/dispcc-sm8250.c                                |    1 
 drivers/clk/qcom/gcc-ipq8074.c                                  |   60 
 drivers/clk/qcom/gcc-msm8939.c                                  |   33 
 drivers/clk/qcom/gdsc.c                                         |    8 
 drivers/clk/qcom/videocc-sm8250.c                               |    4 
 drivers/clk/renesas/r9a06g032-clocks.c                          |    8 
 drivers/clk/renesas/rzg2l-cpg.c                                 |    2 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c             |    1 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c               |   22 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c               |   15 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h                    |    4 
 drivers/crypto/ccp/sev-dev.c                                    |   12 
 drivers/crypto/hisilicon/hpre/hpre_crypto.c                     |    2 
 drivers/crypto/hisilicon/sec/sec_algs.c                         |   14 
 drivers/crypto/hisilicon/sec/sec_drv.h                          |    2 
 drivers/crypto/hisilicon/sec2/sec.h                             |    2 
 drivers/crypto/hisilicon/sec2/sec_crypto.c                      |   26 
 drivers/crypto/hisilicon/sec2/sec_crypto.h                      |    1 
 drivers/crypto/inside-secure/safexcel.c                         |    2 
 drivers/dma/dw-edma/dw-edma-core.c                              |    2 
 drivers/dma/imx-dma.c                                           |    2 
 drivers/dma/sf-pdma/sf-pdma.c                                   |   44 
 drivers/firmware/arm_scpi.c                                     |   61 
 drivers/firmware/tegra/bpmp-debugfs.c                           |   10 
 drivers/fpga/altera-pr-ip-core.c                                |    2 
 drivers/gpio/gpiolib-of.c                                       |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c                          |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c                         |   96 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.h                         |   11 
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c                   |   10 
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c                         |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                      |    4 
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c                          |   21 
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.h                          |    1 
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c                          |   21 
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.h                          |    1 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c       |    2 
 drivers/gpu/drm/bridge/Kconfig                                  |    2 
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c                    |   24 
 drivers/gpu/drm/bridge/analogix/anx7625.c                       |   17 
 drivers/gpu/drm/bridge/lontium-lt9611.c                         |    2 
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c                      |    2 
 drivers/gpu/drm/bridge/sil-sii8620.c                            |    4 
 drivers/gpu/drm/bridge/tc358767.c                               |   62 
 drivers/gpu/drm/dp/drm_dp_aux_bus.c                             |    4 
 drivers/gpu/drm/dp/drm_dp_mst_topology.c                        |    7 
 drivers/gpu/drm/drm_gem.c                                       |    4 
 drivers/gpu/drm/drm_gem_shmem_helper.c                          |    1 
 drivers/gpu/drm/drm_mipi_dbi.c                                  |    7 
 drivers/gpu/drm/exynos/exynos7_drm_decon.c                      |   17 
 drivers/gpu/drm/hyperv/hyperv_drm_modeset.c                     |    2 
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c                       |   10 
 drivers/gpu/drm/ingenic/ingenic-drm.h                           |    3 
 drivers/gpu/drm/mcde/mcde_dsi.c                                 |    1 
 drivers/gpu/drm/mediatek/mtk_dpi.c                              |   33 
 drivers/gpu/drm/mediatek/mtk_dsi.c                              |   93 
 drivers/gpu/drm/meson/meson_encoder_cvbs.c                      |    1 
 drivers/gpu/drm/meson/meson_encoder_hdmi.c                      |   19 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c                           |    8 
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c                           |   13 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                           |   12 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h                           |    3 
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c                        |    6 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c                       |    3 
 drivers/gpu/drm/msm/hdmi/hdmi.c                                 |    3 
 drivers/gpu/drm/msm/msm_gpu.h                                   |   11 
 drivers/gpu/drm/msm/msm_gpu_devfreq.c                           |   39 
 drivers/gpu/drm/nouveau/nouveau_connector.c                     |    8 
 drivers/gpu/drm/nouveau/nouveau_display.c                       |    4 
 drivers/gpu/drm/nouveau/nouveau_fbcon.c                         |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c                 |    2 
 drivers/gpu/drm/panel/Kconfig                                   |    2 
 drivers/gpu/drm/radeon/.gitignore                               |    2 
 drivers/gpu/drm/radeon/Kconfig                                  |    2 
 drivers/gpu/drm/radeon/Makefile                                 |    2 
 drivers/gpu/drm/radeon/ni_dpm.c                                 |    6 
 drivers/gpu/drm/radeon/radeon_device.c                          |    2 
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c                 |   10 
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c                     |    3 
 drivers/gpu/drm/tegra/gem.c                                     |   11 
 drivers/gpu/drm/tiny/st7735r.c                                  |    1 
 drivers/gpu/drm/vc4/vc4_crtc.c                                  |   14 
 drivers/gpu/drm/vc4/vc4_drv.c                                   |   19 
 drivers/gpu/drm/vc4/vc4_dsi.c                                   |  152 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                  |  157 
 drivers/gpu/drm/vc4/vc4_hdmi.h                                  |    8 
 drivers/gpu/drm/vc4/vc4_hdmi_regs.h                             |    7 
 drivers/gpu/drm/vc4/vc4_kms.c                                   |    4 
 drivers/gpu/drm/vc4/vc4_plane.c                                 |   30 
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                          |    6 
 drivers/gpu/drm/virtio/virtgpu_object.c                         |    4 
 drivers/gpu/drm/vkms/vkms_composer.c                            |    2 
 drivers/hid/amd-sfh-hid/amd_sfh_client.c                        |    2 
 drivers/hid/amd-sfh-hid/amd_sfh_hid.c                           |   12 
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c                          |    3 
 drivers/hid/hid-alps.c                                          |    2 
 drivers/hid/hid-cp2112.c                                        |    5 
 drivers/hid/hid-ids.h                                           |    1 
 drivers/hid/hid-input.c                                         |    2 
 drivers/hid/hid-mcp2221.c                                       |    3 
 drivers/hid/hid-nintendo.c                                      |    1 
 drivers/hid/wacom_sys.c                                         |    2 
 drivers/hid/wacom_wac.c                                         |   72 
 drivers/hwmon/dell-smm-hwmon.c                                  |    8 
 drivers/hwmon/drivetemp.c                                       |    1 
 drivers/hwmon/sch56xx-common.c                                  |   44 
 drivers/hwmon/sht15.c                                           |   17 
 drivers/hwtracing/coresight/coresight-config.h                  |    2 
 drivers/hwtracing/coresight/coresight-core.c                    |    1 
 drivers/hwtracing/coresight/coresight-syscfg.c                  |  295 
 drivers/hwtracing/coresight/coresight-syscfg.h                  |   13 
 drivers/hwtracing/intel_th/msu-sink.c                           |    3 
 drivers/hwtracing/intel_th/msu.c                                |   14 
 drivers/hwtracing/intel_th/pci.c                                |   25 
 drivers/i2c/busses/i2c-cadence.c                                |   10 
 drivers/i2c/busses/i2c-mxs.c                                    |    2 
 drivers/i2c/busses/i2c-npcm7xx.c                                |   50 
 drivers/i2c/busses/i2c-qcom-geni.c                              |    2 
 drivers/i2c/i2c-core-base.c                                     |    3 
 drivers/i2c/muxes/i2c-mux-gpmux.c                               |    1 
 drivers/idle/intel_idle.c                                       |  149 
 drivers/iio/accel/adxl313_core.c                                |    2 
 drivers/iio/accel/adxl355_core.c                                |    2 
 drivers/iio/accel/adxl367.c                                     |    2 
 drivers/iio/accel/adxl367_spi.c                                 |    8 
 drivers/iio/accel/bma220_spi.c                                  |    2 
 drivers/iio/accel/bma400.h                                      |   25 
 drivers/iio/accel/bma400_core.c                                 |   81 
 drivers/iio/accel/bma400_i2c.c                                  |    8 
 drivers/iio/accel/bma400_spi.c                                  |    6 
 drivers/iio/accel/cros_ec_accel_legacy.c                        |    4 
 drivers/iio/accel/sca3000.c                                     |    4 
 drivers/iio/accel/sca3300.c                                     |    2 
 drivers/iio/adc/ad7266.c                                        |    4 
 drivers/iio/adc/ad7280a.c                                       |    2 
 drivers/iio/adc/ad7292.c                                        |    2 
 drivers/iio/adc/ad7298.c                                        |    2 
 drivers/iio/adc/ad7476.c                                        |    5 
 drivers/iio/adc/ad7606.h                                        |    4 
 drivers/iio/adc/ad7766.c                                        |    5 
 drivers/iio/adc/ad7768-1.c                                      |    4 
 drivers/iio/adc/ad7887.c                                        |    5 
 drivers/iio/adc/ad7923.c                                        |    4 
 drivers/iio/adc/ad7949.c                                        |    2 
 drivers/iio/adc/adi-axi-adc.c                                   |    7 
 drivers/iio/adc/hi8435.c                                        |    2 
 drivers/iio/adc/ltc2496.c                                       |    4 
 drivers/iio/adc/ltc2497.c                                       |    4 
 drivers/iio/adc/max1027.c                                       |    8 
 drivers/iio/adc/max11100.c                                      |    4 
 drivers/iio/adc/max1118.c                                       |    2 
 drivers/iio/adc/max1241.c                                       |    2 
 drivers/iio/adc/mcp320x.c                                       |    2 
 drivers/iio/adc/ti-adc0832.c                                    |    2 
 drivers/iio/adc/ti-adc084s021.c                                 |    4 
 drivers/iio/adc/ti-adc108s102.c                                 |    4 
 drivers/iio/adc/ti-adc12138.c                                   |    2 
 drivers/iio/adc/ti-adc128s052.c                                 |    2 
 drivers/iio/adc/ti-adc161s626.c                                 |    2 
 drivers/iio/adc/ti-ads124s08.c                                  |    2 
 drivers/iio/adc/ti-ads131e08.c                                  |    2 
 drivers/iio/adc/ti-ads7950.c                                    |    4 
 drivers/iio/adc/ti-ads8344.c                                    |    2 
 drivers/iio/adc/ti-ads8688.c                                    |    2 
 drivers/iio/adc/ti-tlc4541.c                                    |    4 
 drivers/iio/addac/ad74413r.c                                    |    4 
 drivers/iio/amplifiers/ad8366.c                                 |    4 
 drivers/iio/common/cros_ec_sensors/cros_ec_lid_angle.c          |    4 
 drivers/iio/common/cros_ec_sensors/cros_ec_sensors.c            |    6 
 drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c       |   58 
 drivers/iio/common/ssp_sensors/ssp.h                            |    3 
 drivers/iio/dac/ad5064.c                                        |    4 
 drivers/iio/dac/ad5360.c                                        |    4 
 drivers/iio/dac/ad5421.c                                        |    4 
 drivers/iio/dac/ad5449.c                                        |    4 
 drivers/iio/dac/ad5504.c                                        |    2 
 drivers/iio/dac/ad5592r-base.h                                  |    4 
 drivers/iio/dac/ad5686.h                                        |    6 
 drivers/iio/dac/ad5755.c                                        |    4 
 drivers/iio/dac/ad5761.c                                        |    4 
 drivers/iio/dac/ad5764.c                                        |    4 
 drivers/iio/dac/ad5766.c                                        |    2 
 drivers/iio/dac/ad5770r.c                                       |    2 
 drivers/iio/dac/ad5791.c                                        |    2 
 drivers/iio/dac/ad7293.c                                        |    2 
 drivers/iio/dac/ad7303.c                                        |    4 
 drivers/iio/dac/ad8801.c                                        |    2 
 drivers/iio/dac/ltc2688.c                                       |    4 
 drivers/iio/dac/mcp4922.c                                       |    2 
 drivers/iio/dac/ti-dac082s085.c                                 |    2 
 drivers/iio/dac/ti-dac5571.c                                    |    2 
 drivers/iio/dac/ti-dac7311.c                                    |    2 
 drivers/iio/dac/ti-dac7612.c                                    |    4 
 drivers/iio/frequency/ad9523.c                                  |    6 
 drivers/iio/frequency/adf4350.c                                 |    6 
 drivers/iio/frequency/adf4371.c                                 |    2 
 drivers/iio/frequency/admv1013.c                                |    2 
 drivers/iio/frequency/admv1014.c                                |    2 
 drivers/iio/frequency/admv4420.c                                |    2 
 drivers/iio/frequency/adrf6780.c                                |    2 
 drivers/iio/gyro/adis16080.c                                    |    2 
 drivers/iio/gyro/adis16130.c                                    |    2 
 drivers/iio/gyro/adxrs450.c                                     |    2 
 drivers/iio/gyro/fxas21002c_core.c                              |    6 
 drivers/iio/imu/fxos8700_core.c                                 |    2 
 drivers/iio/imu/inv_icm42600/inv_icm42600.h                     |    2 
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.h              |    2 
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h                       |    2 
 drivers/iio/industrialio-buffer.c                               |    4 
 drivers/iio/industrialio-core.c                                 |   25 
 drivers/iio/light/cros_ec_light_prox.c                          |    6 
 drivers/iio/light/isl29028.c                                    |    2 
 drivers/iio/potentiometer/ad5110.c                              |    4 
 drivers/iio/potentiometer/ad5272.c                              |    2 
 drivers/iio/potentiometer/max5481.c                             |    2 
 drivers/iio/potentiometer/mcp41010.c                            |    2 
 drivers/iio/potentiometer/mcp4131.c                             |    2 
 drivers/iio/pressure/cros_ec_baro.c                             |    6 
 drivers/iio/proximity/as3935.c                                  |    2 
 drivers/iio/proximity/sx9324.c                                  |    4 
 drivers/iio/resolver/ad2s1200.c                                 |    2 
 drivers/iio/resolver/ad2s90.c                                   |    2 
 drivers/iio/temperature/ltc2983.c                               |    4 
 drivers/iio/temperature/max31865.c                              |    2 
 drivers/iio/temperature/maxim_thermocouple.c                    |    2 
 drivers/infiniband/hw/hfi1/file_ops.c                           |    4 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                      |    4 
 drivers/infiniband/hw/irdma/cm.c                                |   11 
 drivers/infiniband/hw/irdma/hw.c                                |   15 
 drivers/infiniband/hw/irdma/verbs.c                             |    2 
 drivers/infiniband/hw/mlx5/fs.c                                 |    6 
 drivers/infiniband/hw/qedr/verbs.c                              |    8 
 drivers/infiniband/sw/rxe/rxe_comp.c                            |    8 
 drivers/infiniband/sw/rxe/rxe_loc.h                             |    2 
 drivers/infiniband/sw/rxe/rxe_mr.c                              |   12 
 drivers/infiniband/sw/rxe/rxe_mw.c                              |    7 
 drivers/infiniband/sw/rxe/rxe_pool.c                            |    4 
 drivers/infiniband/sw/rxe/rxe_qp.c                              |   13 
 drivers/infiniband/sw/rxe/rxe_req.c                             |   23 
 drivers/infiniband/sw/rxe/rxe_verbs.h                           |    1 
 drivers/infiniband/sw/siw/siw_cm.c                              |    7 
 drivers/infiniband/ulp/iser/iscsi_iser.c                        |    4 
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                          |   35 
 drivers/infiniband/ulp/rtrs/rtrs-pri.h                          |   21 
 drivers/infiniband/ulp/srpt/ib_srpt.c                           |  148 
 drivers/infiniband/ulp/srpt/ib_srpt.h                           |   18 
 drivers/input/serio/gscps2.c                                    |    4 
 drivers/interconnect/imx/imx.c                                  |    8 
 drivers/iommu/arm/arm-smmu/qcom_iommu.c                         |    7 
 drivers/iommu/exynos-iommu.c                                    |    6 
 drivers/iommu/intel/dmar.c                                      |    2 
 drivers/irqchip/Kconfig                                         |    5 
 drivers/irqchip/irq-mips-gic.c                                  |   84 
 drivers/md/dm-raid.c                                            |    4 
 drivers/md/dm-thin-metadata.c                                   |    7 
 drivers/md/dm-thin.c                                            |    4 
 drivers/md/dm-writecache.c                                      |   43 
 drivers/md/dm.c                                                 |    5 
 drivers/md/md.c                                                 |    2 
 drivers/md/raid10.c                                             |    5 
 drivers/media/i2c/Kconfig                                       |    1 
 drivers/media/pci/sta2x11/Kconfig                               |    2 
 drivers/media/pci/tw686x/tw686x-core.c                          |   18 
 drivers/media/pci/tw686x/tw686x-video.c                         |    4 
 drivers/media/platform/amphion/vdec.c                           |  123 
 drivers/media/platform/amphion/vpu.h                            |    1 
 drivers/media/platform/amphion/vpu_core.c                       |    7 
 drivers/media/platform/amphion/vpu_malone.c                     |    6 
 drivers/media/platform/amphion/vpu_msgs.c                       |    7 
 drivers/media/platform/amphion/vpu_rpc.h                        |    7 
 drivers/media/platform/amphion/vpu_v4l2.c                       |   62 
 drivers/media/platform/amphion/vpu_v4l2.h                       |    3 
 drivers/media/platform/atmel/atmel-sama7g5-isc.c                |    2 
 drivers/media/platform/mediatek/mdp/mtk_mdp_ipi.h               |    2 
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c         |    7 
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c     |    5 
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.c               |    5 
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.h               |    9 
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c                  |  477 
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h                  |    6 
 drivers/media/platform/qcom/camss/camss-csid.c                  |    2 
 drivers/media/platform/renesas/rcar-vin/rcar-core.c             |    2 
 drivers/media/usb/hdpvr/hdpvr-video.c                           |    2 
 drivers/media/v4l2-core/v4l2-mem2mem.c                          |    2 
 drivers/memstick/core/ms_block.c                                |   11 
 drivers/mfd/max77620.c                                          |    2 
 drivers/mfd/t7l66xb.c                                           |    6 
 drivers/misc/cardreader/rtsx_pcr.c                              |    6 
 drivers/misc/eeprom/idt_89hpesx.c                               |    8 
 drivers/mmc/core/block.c                                        |   28 
 drivers/mmc/core/quirks.h                                       |    4 
 drivers/mmc/host/cavium-octeon.c                                |    1 
 drivers/mmc/host/cavium-thunderx.c                              |    4 
 drivers/mmc/host/mxcmmc.c                                       |    2 
 drivers/mmc/host/renesas_sdhi_core.c                            |    8 
 drivers/mmc/host/sdhci-of-at91.c                                |    9 
 drivers/mmc/host/sdhci-of-esdhc.c                               |    1 
 drivers/mtd/devices/mtd_dataflash.c                             |    8 
 drivers/mtd/devices/st_spi_fsm.c                                |    8 
 drivers/mtd/hyperbus/rpc-if.c                                   |    8 
 drivers/mtd/maps/physmap-versatile.c                            |    2 
 drivers/mtd/nand/raw/arasan-nand-controller.c                   |   16 
 drivers/mtd/nand/raw/meson_nand.c                               |    1 
 drivers/mtd/parsers/ofpart_bcm4908.c                            |    3 
 drivers/mtd/parsers/redboot.c                                   |    1 
 drivers/mtd/sm_ftl.c                                            |    2 
 drivers/mtd/spi-nor/core.c                                      |    6 
 drivers/net/can/dev/netlink.c                                   |    6 
 drivers/net/can/pch_can.c                                       |    8 
 drivers/net/can/rcar/rcar_can.c                                 |    8 
 drivers/net/can/sja1000/sja1000.c                               |    7 
 drivers/net/can/spi/hi311x.c                                    |    5 
 drivers/net/can/sun4i_can.c                                     |    9 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c               |   12 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c                |    6 
 drivers/net/can/usb/usb_8dev.c                                  |    7 
 drivers/net/dsa/ocelot/Kconfig                                  |    1 
 drivers/net/dsa/ocelot/felix.c                                  |    9 
 drivers/net/dsa/ocelot/felix.h                                  |    1 
 drivers/net/dsa/ocelot/felix_vsc9959.c                          |  300 
 drivers/net/ethernet/atheros/ag71xx.c                           |    2 
 drivers/net/ethernet/huawei/hinic/hinic_dev.h                   |    3 
 drivers/net/ethernet/huawei/hinic/hinic_main.c                  |   68 
 drivers/net/ethernet/huawei/hinic/hinic_rx.c                    |    2 
 drivers/net/ethernet/huawei/hinic/hinic_tx.c                    |    2 
 drivers/net/ethernet/intel/iavf/iavf.h                          |    6 
 drivers/net/ethernet/intel/iavf/iavf_main.c                     |   46 
 drivers/net/ethernet/intel/ice/ice_main.c                       |    2 
 drivers/net/ethernet/intel/ice/ice_switch.c                     |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en.h                    |   21 
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c             |   12 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c        |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h             |   14 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c         |    2 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c      |   23 
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c              |   11 
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h              |    1 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                  |    4 
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c                 |   65 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c       |   13 
 drivers/net/ethernet/mscc/ocelot.c                              |    1 
 drivers/net/ethernet/mscc/ocelot_ptp.c                          |    8 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                 |    2 
 drivers/net/netdevsim/bpf.c                                     |    8 
 drivers/net/netdevsim/fib.c                                     |   27 
 drivers/net/phy/smsc.c                                          |    6 
 drivers/net/usb/Kconfig                                         |    3 
 drivers/net/usb/ax88179_178a.c                                  |   26 
 drivers/net/usb/smsc95xx.c                                      |  157 
 drivers/net/usb/usbnet.c                                        |    8 
 drivers/net/wireguard/allowedips.c                              |    9 
 drivers/net/wireguard/selftest/allowedips.c                     |    6 
 drivers/net/wireguard/selftest/ratelimiter.c                    |   25 
 drivers/net/wireless/ath/ath10k/snoc.c                          |    5 
 drivers/net/wireless/ath/ath11k/core.c                          |   16 
 drivers/net/wireless/ath/ath11k/debug.h                         |    4 
 drivers/net/wireless/ath/ath11k/dp_rx.c                         |    5 
 drivers/net/wireless/ath/ath11k/htc.c                           |    4 
 drivers/net/wireless/ath/ath11k/pci.c                           |    2 
 drivers/net/wireless/ath/ath9k/htc.h                            |   10 
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                   |    3 
 drivers/net/wireless/ath/wil6210/debugfs.c                      |   18 
 drivers/net/wireless/intel/iwlegacy/4965-rs.c                   |    5 
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                    |    1 
 drivers/net/wireless/intersil/p54/main.c                        |    2 
 drivers/net/wireless/intersil/p54/p54spi.c                      |    3 
 drivers/net/wireless/mac80211_hwsim.c                           |   14 
 drivers/net/wireless/marvell/libertas/if_usb.c                  |    1 
 drivers/net/wireless/mediatek/mt76/eeprom.c                     |    5 
 drivers/net/wireless/mediatek/mt76/mac80211.c                   |    1 
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                 |    7 
 drivers/net/wireless/mediatek/mt76/mt7615/main.c                |   21 
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c                 |   12 
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h              |    1 
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c            |    2 
 drivers/net/wireless/mediatek/mt76/mt7921/init.c                |    6 
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c                 |   15 
 drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c             |    6 
 drivers/net/wireless/mediatek/mt76/mt7921/sdio_mcu.c            |   10 
 drivers/net/wireless/microchip/wilc1000/spi.c                   |    6 
 drivers/net/wireless/realtek/rtlwifi/debug.c                    |    8 
 drivers/net/wireless/realtek/rtw88/main.c                       |    4 
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c               |    4 
 drivers/nvme/host/core.c                                        |   14 
 drivers/nvme/host/fc.c                                          |   18 
 drivers/nvme/host/multipath.c                                   |    1 
 drivers/nvme/host/trace.h                                       |    2 
 drivers/nvme/target/zns.c                                       |    3 
 drivers/of/device.c                                             |    5 
 drivers/of/fdt.c                                                |    2 
 drivers/of/kexec.c                                              |   17 
 drivers/opp/core.c                                              |    4 
 drivers/parisc/lba_pci.c                                        |    6 
 drivers/pci/controller/dwc/pcie-designware-ep.c                 |   18 
 drivers/pci/controller/dwc/pcie-designware-host.c               |   30 
 drivers/pci/controller/dwc/pcie-designware.c                    |   46 
 drivers/pci/controller/dwc/pcie-qcom.c                          |   58 
 drivers/pci/controller/dwc/pcie-tegra194.c                      |   49 
 drivers/pci/controller/pcie-mediatek-gen3.c                     |    7 
 drivers/pci/controller/pcie-microchip-host.c                    |    2 
 drivers/pci/endpoint/functions/pci-epf-test.c                   |    1 
 drivers/pci/pcie/aer.c                                          |    7 
 drivers/pci/pcie/portdrv_core.c                                 |    9 
 drivers/perf/arm_spe_pmu.c                                      |   22 
 drivers/perf/riscv_pmu.c                                        |    1 
 drivers/perf/riscv_pmu_sbi.c                                    |   21 
 drivers/phy/qualcomm/phy-qcom-qmp.h                             |    3 
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c                   |    4 
 drivers/phy/samsung/phy-exynosautov9-ufs.c                      |   18 
 drivers/phy/st/phy-stm32-usbphyc.c                              |    4 
 drivers/phy/ti/phy-tusb1210.c                                   |    5 
 drivers/pinctrl/Kconfig                                         |    2 
 drivers/platform/chrome/cros_ec.c                               |    8 
 drivers/platform/mellanox/mlxreg-lc.c                           |   82 
 drivers/platform/olpc/olpc-ec.c                                 |    2 
 drivers/platform/x86/pmc_atom.c                                 |   19 
 drivers/pwm/pwm-lpc18xx-sct.c                                   |   55 
 drivers/pwm/pwm-sifive.c                                        |   61 
 drivers/regulator/of_regulator.c                                |    6 
 drivers/regulator/qcom_smd-regulator.c                          |    4 
 drivers/remoteproc/imx_rproc.c                                  |    7 
 drivers/remoteproc/qcom_q6v5_pas.c                              |    3 
 drivers/remoteproc/qcom_sysmon.c                                |   10 
 drivers/remoteproc/qcom_wcnss.c                                 |   10 
 drivers/remoteproc/ti_k3_r5_remoteproc.c                        |    2 
 drivers/rpmsg/mtk_rpmsg.c                                       |    2 
 drivers/rpmsg/qcom_smd.c                                        |    1 
 drivers/rpmsg/rpmsg_char.c                                      |    7 
 drivers/rtc/rtc-rx8025.c                                        |   22 
 drivers/s390/char/zcore.c                                       |   11 
 drivers/s390/cio/vfio_ccw_drv.c                                 |   19 
 drivers/s390/cio/vfio_ccw_ops.c                                 |    2 
 drivers/s390/scsi/zfcp_fc.c                                     |   29 
 drivers/s390/scsi/zfcp_fc.h                                     |    6 
 drivers/s390/scsi/zfcp_fsf.c                                    |    4 
 drivers/scsi/be2iscsi/be_main.c                                 |    2 
 drivers/scsi/bnx2i/bnx2i_iscsi.c                                |    2 
 drivers/scsi/cxgbi/libcxgbi.c                                   |    2 
 drivers/scsi/iscsi_tcp.c                                        |    4 
 drivers/scsi/libiscsi.c                                         |    9 
 drivers/scsi/lpfc/lpfc_scsi.c                                   |    1 
 drivers/scsi/qedi/qedi_main.c                                   |    9 
 drivers/scsi/qla2xxx/qla_attr.c                                 |   24 
 drivers/scsi/qla2xxx/qla_bsg.c                                  |   10 
 drivers/scsi/qla2xxx/qla_dbg.h                                  |    2 
 drivers/scsi/qla2xxx/qla_def.h                                  |   18 
 drivers/scsi/qla2xxx/qla_edif.c                                 |  502 
 drivers/scsi/qla2xxx/qla_edif.h                                 |    7 
 drivers/scsi/qla2xxx/qla_edif_bsg.h                             |  106 
 drivers/scsi/qla2xxx/qla_fw.h                                   |    2 
 drivers/scsi/qla2xxx/qla_gbl.h                                  |    6 
 drivers/scsi/qla2xxx/qla_gs.c                                   |  129 
 drivers/scsi/qla2xxx/qla_init.c                                 |   93 
 drivers/scsi/qla2xxx/qla_iocb.c                                 |    5 
 drivers/scsi/qla2xxx/qla_isr.c                                  |   25 
 drivers/scsi/qla2xxx/qla_mbx.c                                  |   19 
 drivers/scsi/qla2xxx/qla_mid.c                                  |    6 
 drivers/scsi/qla2xxx/qla_nvme.c                                 |    5 
 drivers/scsi/qla2xxx/qla_os.c                                   |   93 
 drivers/scsi/qla2xxx/qla_target.c                               |   35 
 drivers/scsi/scsi_transport_iscsi.c                             |   66 
 drivers/scsi/sg.c                                               |   53 
 drivers/scsi/smartpqi/smartpqi_init.c                           |    4 
 drivers/scsi/ufs/ufshcd.c                                       |    6 
 drivers/soc/amlogic/meson-mx-socinfo.c                          |    1 
 drivers/soc/amlogic/meson-secure-pwrc.c                         |    4 
 drivers/soc/fsl/guts.c                                          |    2 
 drivers/soc/qcom/Kconfig                                        |    1 
 drivers/soc/qcom/ocmem.c                                        |    3 
 drivers/soc/qcom/qcom_aoss.c                                    |    4 
 drivers/soc/qcom/socinfo.c                                      |    3 
 drivers/soc/renesas/r8a779a0-sysc.c                             |   10 
 drivers/soundwire/bus.c                                         |   75 
 drivers/soundwire/bus_type.c                                    |   38 
 drivers/soundwire/qcom.c                                        |    4 
 drivers/soundwire/slave.c                                       |    3 
 drivers/soundwire/stream.c                                      |   53 
 drivers/spi/spi-altera-dfl.c                                    |   14 
 drivers/spi/spi-dw.h                                            |    2 
 drivers/spi/spi-rspi.c                                          |    4 
 drivers/spi/spi-s3c64xx.c                                       |    2 
 drivers/spi/spi-synquacer.c                                     |    1 
 drivers/spi/spi-tegra20-slink.c                                 |    3 
 drivers/spi/spi.c                                               |   21 
 drivers/staging/fbtft/fbtft-core.c                              |    2 
 drivers/staging/media/atomisp/pci/atomisp_cmd.c                 |   57 
 drivers/staging/media/hantro/hantro_drv.c                       |    1 
 drivers/staging/media/hantro/hantro_g2_hevc_dec.c               |   32 
 drivers/staging/media/hantro/hantro_g2_regs.h                   |    2 
 drivers/staging/media/hantro/hantro_hevc.c                      |   71 
 drivers/staging/media/hantro/hantro_hw.h                        |   22 
 drivers/staging/media/hantro/hantro_v4l2.c                      |    2 
 drivers/staging/media/hantro/imx8m_vpu_hw.c                     |   80 
 drivers/staging/media/hantro/rockchip_vpu_hw.c                  |  174 
 drivers/staging/media/hantro/sama5d4_vdec_hw.c                  |   40 
 drivers/staging/media/hantro/sunxi_vpu_hw.c                     |   24 
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c                |   36 
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h                |    3 
 drivers/staging/rtl8192u/r8192U.h                               |    2 
 drivers/staging/rtl8192u/r8192U_dm.c                            |   38 
 drivers/staging/rtl8192u/r8192U_dm.h                            |    2 
 drivers/thermal/thermal_sysfs.c                                 |   10 
 drivers/tty/n_gsm.c                                             |  757 
 drivers/tty/serial/8250/8250.h                                  |   22 
 drivers/tty/serial/8250/8250_bcm2835aux.c                       |    6 
 drivers/tty/serial/8250/8250_bcm7271.c                          |   24 
 drivers/tty/serial/8250/8250_fsl.c                              |    2 
 drivers/tty/serial/8250/8250_pci.c                              |  522 
 drivers/tty/serial/8250/8250_port.c                             |   21 
 drivers/tty/serial/fsl_lpuart.c                                 |   12 
 drivers/tty/serial/mvebu-uart.c                                 |   11 
 drivers/tty/serial/pic32_uart.c                                 |   13 
 drivers/tty/vt/vt.c                                             |    2 
 drivers/usb/cdns3/cdns3-gadget.c                                |   11 
 drivers/usb/core/hcd.c                                          |   26 
 drivers/usb/dwc3/core.c                                         |    9 
 drivers/usb/dwc3/dwc3-qcom.c                                    |    4 
 drivers/usb/dwc3/gadget.c                                       |   92 
 drivers/usb/gadget/function/f_mass_storage.c                    |   11 
 drivers/usb/gadget/udc/Kconfig                                  |    2 
 drivers/usb/gadget/udc/aspeed-vhub/hub.c                        |    4 
 drivers/usb/gadget/udc/tegra-xudc.c                             |    8 
 drivers/usb/host/ehci-ppc-of.c                                  |    1 
 drivers/usb/host/ohci-nxp.c                                     |    1 
 drivers/usb/host/xhci-tegra.c                                   |    8 
 drivers/usb/host/xhci.h                                         |    2 
 drivers/usb/serial/sierra.c                                     |    3 
 drivers/usb/serial/usb-serial.c                                 |    2 
 drivers/usb/serial/usb_wwan.c                                   |    3 
 drivers/usb/typec/ucsi/ucsi.c                                   |    4 
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c                  |   15 
 drivers/vfio/pci/mlx5/main.c                                    |   15 
 drivers/vfio/pci/vfio_pci.c                                     |    2 
 drivers/vfio/pci/vfio_pci_core.c                                |    4 
 drivers/video/fbdev/amba-clcd.c                                 |   24 
 drivers/video/fbdev/arkfb.c                                     |    9 
 drivers/video/fbdev/core/fbcon.c                                |   12 
 drivers/video/fbdev/s3fb.c                                      |    2 
 drivers/video/fbdev/sis/init.c                                  |    4 
 drivers/video/fbdev/vt8623fb.c                                  |    2 
 drivers/watchdog/armada_37xx_wdt.c                              |    2 
 drivers/watchdog/f71808e_wdt.c                                  |    4 
 drivers/watchdog/sp5100_tco.c                                   |    1 
 fs/Makefile                                                     |    2 
 fs/attr.c                                                       |    2 
 fs/btrfs/block-group.c                                          |   29 
 fs/btrfs/ctree.h                                                |   34 
 fs/btrfs/delalloc-space.c                                       |    6 
 fs/btrfs/disk-io.c                                              |   38 
 fs/btrfs/extent-tree.c                                          |   74 
 fs/btrfs/extent_io.c                                            |    4 
 fs/btrfs/file.c                                                 |    2 
 fs/btrfs/free-space-cache.c                                     |    7 
 fs/btrfs/inode.c                                                |  177 
 fs/btrfs/space-info.c                                           |  117 
 fs/btrfs/space-info.h                                           |   14 
 fs/btrfs/sysfs.c                                                |   37 
 fs/btrfs/tree-log.c                                             |   27 
 fs/btrfs/tree-log.h                                             |    3 
 fs/btrfs/volumes.c                                              |   28 
 fs/btrfs/zoned.c                                                |  127 
 fs/btrfs/zoned.h                                                |   30 
 fs/cifs/file.c                                                  |   28 
 fs/erofs/decompressor.c                                         |   16 
 fs/erofs/decompressor_lzma.c                                    |    1 
 fs/eventpoll.c                                                  |   22 
 fs/exec.c                                                       |    3 
 fs/ext2/super.c                                                 |   12 
 fs/ext4/inline.c                                                |    3 
 fs/ext4/inode.c                                                 |   24 
 fs/ext4/migrate.c                                               |    4 
 fs/ext4/namei.c                                                 |   23 
 fs/ext4/resize.c                                                |    1 
 fs/ext4/xattr.c                                                 |  169 
 fs/ext4/xattr.h                                                 |   14 
 fs/f2fs/checkpoint.c                                            |    4 
 fs/f2fs/data.c                                                  |  192 
 fs/f2fs/debug.c                                                 |   18 
 fs/f2fs/f2fs.h                                                  |   60 
 fs/f2fs/file.c                                                  |  164 
 fs/f2fs/gc.c                                                    |  134 
 fs/f2fs/inode.c                                                 |    3 
 fs/f2fs/namei.c                                                 |   28 
 fs/f2fs/node.c                                                  |    4 
 fs/f2fs/node.h                                                  |    1 
 fs/f2fs/segment.c                                               |  391 
 fs/f2fs/segment.h                                               |    7 
 fs/f2fs/super.c                                                 |    6 
 fs/f2fs/verity.c                                                |    2 
 fs/fuse/control.c                                               |    4 
 fs/fuse/dir.c                                                   |    7 
 fs/fuse/file.c                                                  |   39 
 fs/fuse/inode.c                                                 |    6 
 fs/fuse/ioctl.c                                                 |   15 
 fs/io-wq.c                                                      | 1424 -
 fs/io-wq.h                                                      |  227 
 fs/io_uring.c                                                   |11915 ----------
 fs/jbd2/commit.c                                                |    2 
 fs/jbd2/transaction.c                                           |   14 
 fs/kernfs/dir.c                                                 |    7 
 fs/ksmbd/connection.c                                           |   20 
 fs/ksmbd/connection.h                                           |   27 
 fs/ksmbd/ksmbd_netlink.h                                        |    3 
 fs/ksmbd/smb2misc.c                                             |   12 
 fs/ksmbd/smb2pdu.c                                              |  151 
 fs/ksmbd/smbacl.c                                               |  130 
 fs/ksmbd/smbacl.h                                               |    2 
 fs/ksmbd/transport_ipc.c                                        |    3 
 fs/ksmbd/transport_rdma.c                                       |  161 
 fs/ksmbd/transport_rdma.h                                       |    8 
 fs/ksmbd/vfs.c                                                  |    5 
 fs/lockd/svc4proc.c                                             |    8 
 fs/lockd/xdr4.c                                                 |   19 
 fs/mbcache.c                                                    |   76 
 fs/namei.c                                                      |    4 
 fs/nfs/flexfilelayout/flexfilelayout.c                          |    4 
 fs/nfs/nfs3client.c                                             |    1 
 fs/nfsd/filecache.c                                             |   22 
 fs/nfsd/filecache.h                                             |    4 
 fs/nfsd/trace.h                                                 |    8 
 fs/overlayfs/export.c                                           |    2 
 fs/proc/base.c                                                  |   46 
 fs/splice.c                                                     |   10 
 fs/zonefs/super.c                                               |    3 
 include/acpi/cppc_acpi.h                                        |    2 
 include/crypto/internal/blake2s.h                               |  108 
 include/dt-bindings/clock/qcom,gcc-msm8939.h                    |    1 
 include/linux/acpi_viot.h                                       |    2 
 include/linux/blkdev.h                                          |   19 
 include/linux/bpf.h                                             |  140 
 include/linux/bpf_types.h                                       |    1 
 include/linux/bpf_verifier.h                                    |    3 
 include/linux/btf.h                                             |   21 
 include/linux/buffer_head.h                                     |   25 
 include/linux/cpumask.h                                         |   18 
 include/linux/filter.h                                          |    9 
 include/linux/highmem.h                                         |   10 
 include/linux/hugetlb.h                                         |    6 
 include/linux/iio/common/cros_ec_sensors_core.h                 |    7 
 include/linux/iio/iio.h                                         |   10 
 include/linux/kexec.h                                           |   45 
 include/linux/kfifo.h                                           |    2 
 include/linux/kvm_types.h                                       |    2 
 include/linux/lockd/xdr.h                                       |    2 
 include/linux/lockdep.h                                         |   30 
 include/linux/mbcache.h                                         |   10 
 include/linux/mfd/t7l66xb.h                                     |    1 
 include/linux/mlx5/driver.h                                     |   12 
 include/linux/nvme-fc-driver.h                                  |   14 
 include/linux/once_lite.h                                       |   20 
 include/linux/perf_event.h                                      |   16 
 include/linux/pipe_fs_i.h                                       |    9 
 include/linux/rmap.h                                            |    4 
 include/linux/sched.h                                           |    2 
 include/linux/sched/rt.h                                        |    8 
 include/linux/sched/topology.h                                  |    1 
 include/linux/soundwire/sdw.h                                   |    6 
 include/linux/swapops.h                                         |   12 
 include/linux/tpm_eventlog.h                                    |    2 
 include/linux/trace_events.h                                    |   18 
 include/linux/usb/hcd.h                                         |    1 
 include/linux/wait.h                                            |    9 
 include/media/hevc-ctrls.h                                      |    4 
 include/net/9p/client.h                                         |    8 
 include/net/ax25.h                                              |    1 
 include/net/bluetooth/hci.h                                     |    1 
 include/net/inet6_hashtables.h                                  |   27 
 include/net/inet_hashtables.h                                   |   44 
 include/net/inet_sock.h                                         |   11 
 include/net/pkt_sched.h                                         |   17 
 include/net/raw.h                                               |   16 
 include/net/rawv6.h                                             |    7 
 include/net/sock.h                                              |   15 
 include/net/xdp_sock_drv.h                                      |   11 
 include/scsi/libiscsi.h                                         |    2 
 include/scsi/scsi_transport_iscsi.h                             |    1 
 include/soc/mscc/ocelot.h                                       |   27 
 include/trace/events/f2fs.h                                     |   22 
 include/trace/events/spmi.h                                     |   12 
 include/trace/stages/stage1_struct_define.h                     |    3 
 include/trace/stages/stage2_data_offsets.h                      |    3 
 include/trace/stages/stage4_event_fields.h                      |   11 
 include/trace/stages/stage5_get_offsets.h                       |    4 
 include/trace/stages/stage6_event_callback.h                    |   12 
 include/uapi/linux/bpf.h                                        |   13 
 include/uapi/linux/can/error.h                                  |    5 
 include/uapi/linux/f2fs.h                                       |    2 
 include/uapi/linux/netfilter/xt_IDLETIMER.h                     |   17 
 init/main.c                                                     |    1 
 io_uring/Makefile                                               |    6 
 io_uring/io-wq.c                                                | 1424 +
 io_uring/io-wq.h                                                |  227 
 io_uring/io_uring.c                                             |11915 ++++++++++
 kernel/bpf/arraymap.c                                           |   36 
 kernel/bpf/bpf_struct_ops.c                                     |   71 
 kernel/bpf/btf.c                                                |  470 
 kernel/bpf/cgroup.c                                             |   70 
 kernel/bpf/core.c                                               |   35 
 kernel/bpf/hashtab.c                                            |   64 
 kernel/bpf/helpers.c                                            |   24 
 kernel/bpf/map_in_map.c                                         |    5 
 kernel/bpf/ringbuf.c                                            |    4 
 kernel/bpf/syscall.c                                            |  257 
 kernel/bpf/trampoline.c                                         |   73 
 kernel/bpf/verifier.c                                           |  418 
 kernel/cgroup/cpuset.c                                          |    2 
 kernel/dma/swiotlb.c                                            |    2 
 kernel/irq/Kconfig                                              |    1 
 kernel/irq/chip.c                                               |    3 
 kernel/irq/irqdomain.c                                          |    2 
 kernel/kexec_file.c                                             |   66 
 kernel/kprobes.c                                                |    3 
 kernel/locking/lockdep.c                                        |    7 
 kernel/power/user.c                                             |   13 
 kernel/profile.c                                                |    7 
 kernel/rcu/rcutorture.c                                         |   28 
 kernel/sched/core.c                                             |   52 
 kernel/sched/fair.c                                             |  141 
 kernel/sched/features.h                                         |    3 
 kernel/sched/rt.c                                               |   15 
 kernel/sched/sched.h                                            |    1 
 kernel/smp.c                                                    |    4 
 kernel/time/hrtimer.c                                           |    1 
 kernel/time/timekeeping.c                                       |    7 
 kernel/trace/blktrace.c                                         |    5 
 lib/crypto/blake2s-selftest.c                                   |   41 
 lib/crypto/blake2s.c                                            |   37 
 lib/iov_iter.c                                                  |   15 
 lib/kunit/executor.c                                            |    4 
 lib/livepatch/test_klp_callbacks_busy.c                         |    8 
 lib/overflow_kunit.c                                            |    6 
 lib/smp_processor_id.c                                          |    2 
 lib/test_bpf.c                                                  |    4 
 lib/test_hmm.c                                                  |   10 
 lib/test_kasan.c                                                |   10 
 mm/damon/reclaim.c                                              |    4 
 mm/gup.c                                                        |    2 
 mm/huge_memory.c                                                |   11 
 mm/hugetlb.c                                                    |   15 
 mm/hugetlb_cgroup.c                                             |    1 
 mm/kasan/hw_tags.c                                              |   32 
 mm/memory-failure.c                                             |    2 
 mm/memory_hotplug.c                                             |    2 
 mm/mempolicy.c                                                  |    4 
 mm/memremap.c                                                   |    2 
 mm/migrate.c                                                    |   30 
 mm/mmap.c                                                       |    1 
 mm/page_alloc.c                                                 |    8 
 mm/vmalloc.c                                                    |   10 
 net/9p/client.c                                                 |   36 
 net/9p/trans_fd.c                                               |   13 
 net/9p/trans_rdma.c                                             |    2 
 net/9p/trans_virtio.c                                           |    4 
 net/9p/trans_xen.c                                              |    2 
 net/ax25/af_ax25.c                                              |    4 
 net/batman-adv/trace.h                                          |    9 
 net/bluetooth/hci_core.c                                        |   10 
 net/bluetooth/hci_event.c                                       |    5 
 net/bluetooth/hci_sync.c                                        |    8 
 net/bluetooth/l2cap_core.c                                      |   13 
 net/bluetooth/mgmt.c                                            |   10 
 net/bpf/bpf_dummy_struct_ops.c                                  |   24 
 net/core/filter.c                                               |    4 
 net/core/skmsg.c                                                |    4 
 net/dccp/proto.c                                                |   10 
 net/ipv4/af_inet.c                                              |    2 
 net/ipv4/inet_hashtables.c                                      |   17 
 net/ipv4/raw.c                                                  |  164 
 net/ipv4/raw_diag.c                                             |   53 
 net/ipv4/tcp.c                                                  |   33 
 net/ipv4/tcp_output.c                                           |   30 
 net/ipv4/udp.c                                                  |    3 
 net/ipv6/af_inet6.c                                             |    3 
 net/ipv6/inet6_hashtables.c                                     |    6 
 net/ipv6/raw.c                                                  |  120 
 net/ipv6/udp.c                                                  |    2 
 net/mptcp/protocol.c                                            |    3 
 net/netfilter/nf_tables_api.c                                   |   18 
 net/netfilter/nft_queue.c                                       |   27 
 net/rose/af_rose.c                                              |   11 
 net/rose/rose_route.c                                           |    2 
 net/sched/cls_route.c                                           |    2 
 scripts/Makefile.modpost                                        |    3 
 scripts/faddr2line                                              |    4 
 scripts/gdb/linux/dmesg.py                                      |    9 
 scripts/gdb/linux/utils.py                                      |   14 
 security/selinux/ss/policydb.h                                  |    2 
 security/selinux/ss/services.c                                  |    9 
 sound/pci/hda/patch_cirrus.c                                    |    1 
 sound/pci/hda/patch_conexant.c                                  |   11 
 sound/pci/hda/patch_realtek.c                                   |  124 
 sound/soc/amd/yc/acp6x-mach.c                                   |   32 
 sound/soc/atmel/mchp-spdifrx.c                                  |    9 
 sound/soc/codecs/cros_ec_codec.c                                |    1 
 sound/soc/codecs/da7210.c                                       |    2 
 sound/soc/codecs/msm8916-wcd-digital.c                          |   46 
 sound/soc/codecs/mt6359-accdet.c                                |    1 
 sound/soc/codecs/mt6359.c                                       |    1 
 sound/soc/codecs/wcd9335.c                                      |   81 
 sound/soc/codecs/wsa881x.c                                      |   10 
 sound/soc/fsl/fsl-asoc-card.c                                   |    5 
 sound/soc/fsl/fsl_asrc.c                                        |    6 
 sound/soc/fsl/fsl_easrc.c                                       |    9 
 sound/soc/fsl/fsl_easrc.h                                       |    2 
 sound/soc/fsl/imx-audmux.c                                      |    2 
 sound/soc/fsl/imx-card.c                                        |   22 
 sound/soc/generic/audio-graph-card.c                            |    4 
 sound/soc/generic/audio-graph-card2.c                           |   44 
 sound/soc/intel/boards/sof_rt5682.c                             |   18 
 sound/soc/mediatek/mt6797/mt6797-mt6351.c                       |    6 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c                |   10 
 sound/soc/mediatek/mt8173/mt8173-rt5650.c                       |    9 
 sound/soc/qcom/lpass-cpu.c                                      |    1 
 sound/soc/qcom/qdsp6/q6adm.c                                    |    2 
 sound/soc/samsung/aries_wm8994.c                                |    6 
 sound/soc/samsung/h1940_uda1380.c                               |    2 
 sound/soc/samsung/rx1950_uda1380.c                              |    4 
 sound/soc/sof/ipc3-topology.c                                   |    1 
 sound/soc/sof/mediatek/mt8195/mt8195-loader.c                   |    2 
 sound/soc/sof/sof-priv.h                                        |    4 
 sound/usb/bcd2000/bcd2000.c                                     |    3 
 sound/usb/quirks.c                                              |    2 
 tools/bpf/bpftool/link.c                                        |    4 
 tools/include/uapi/linux/bpf.h                                  |   13 
 tools/lib/bpf/bpf_tracing.h                                     |    2 
 tools/lib/bpf/gen_loader.c                                      |    2 
 tools/lib/bpf/libbpf.c                                          |    9 
 tools/lib/bpf/xsk.c                                             |    9 
 tools/perf/builtin-stat.c                                       |   30 
 tools/perf/util/dsos.c                                          |   15 
 tools/perf/util/genelf.c                                        |    6 
 tools/perf/util/symbol-elf.c                                    |   27 
 tools/power/x86/intel-speed-select/isst-daemon.c                |    2 
 tools/testing/selftests/bpf/prog_tests/btf.c                    |    2 
 tools/testing/selftests/bpf/prog_tests/fexit_stress.c           |   32 
 tools/testing/selftests/bpf/prog_tests/sock_fields.c            |    1 
 tools/testing/selftests/bpf/prog_tests/tc_redirect.c            |    8 
 tools/testing/selftests/bpf/progs/test_tc_dtime.c               |   53 
 tools/testing/selftests/bpf/verifier/ref_tracking.c             |    2 
 tools/testing/selftests/bpf/verifier/sock.c                     |    6 
 tools/testing/selftests/kvm/lib/x86_64/processor.c              |    2 
 tools/testing/selftests/powerpc/papr_attributes/attr_test.c     |   30 
 tools/testing/selftests/rcutorture/bin/kvm.sh                   |   12 
 tools/testing/selftests/seccomp/seccomp_bpf.c                   |    2 
 tools/testing/selftests/timers/clocksource-switch.c             |    6 
 tools/testing/selftests/timers/valid-adjtimex.c                 |    2 
 tools/testing/selftests/vm/hugepage-mremap.c                    |    2 
 tools/testing/selftests/vm/hugetlb-madvise.c                    |    5 
 tools/testing/selftests/wireguard/qemu/arch/riscv32.config      |    1 
 tools/thermal/tmon/sysfs.c                                      |   24 
 tools/thermal/tmon/tmon.h                                       |    3 
 tools/tracing/rtla/Makefile                                     |    2 
 tools/tracing/rtla/src/trace.c                                  |    9 
 tools/tracing/rtla/src/utils.c                                  |    5 
 virt/kvm/kvm_main.c                                             |   25 
 virt/kvm/pfncache.c                                             |  207 
 1202 files changed, 30883 insertions(+), 25100 deletions(-)

Abel Vesa (1):
      clk: qcom: Drop mmcx gdsc supply for dispcc and videocc

Adrian Hunter (1):
      perf tools: Fix dso_id inode generation comparison

Ajay Singh (1):
      wifi: wilc1000: use correct sequence of RESET for chip Power-UP/Down

Al Viro (2):
      fix short copy handling in copy_mc_pipe_to_iter()
      __follow_mount_rcu(): verify that mount_lock remains unchanged

Alex Deucher (4):
      drm/radeon: fix incorrrect SPDX-License-Identifiers
      drm/amdgpu: use the same HDP flush registers for all nbio 7.4.x
      drm/amdgpu: use the same HDP flush registers for all nbio 2.3.x
      drm/amdgpu: restore original stable pstate on ctx fini

Alexander Gordeev (4):
      s390/crash: fix incorrect number of bytes to copy to user space
      s390/zcore: fix race when reading from hardware system area
      s390/smp: enforce lowcore protection on CPU restart
      Revert "s390/smp: enforce lowcore protection on CPU restart"

Alexander Lobakin (4):
      ia64, processor: fix -Wincompatible-pointer-types in ia64_get_irr()
      net/ice: fix initializing the bitmap in the switch code
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

Alexander Vorwerk (1):
      iio: core: fix a few code style issues

Alexandru Elisei (1):
      arm64: cpufeature: Allow different PMU versions in ID_DFR0_EL1

Alexei Starovoitov (1):
      bpf: Fix subprog names in stack traces.

Alexey Kardashevskiy (2):
      pseries/iommu/ddw: Fix kdump to work in absence of ibm,dma-window
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

Andreas Schwab (1):
      rtla: Fix double free

Andrei Vagin (1):
      selftests: kvm: set rax before vmcall

Andrey Konovalov (2):
      kasan: fix zeroing vmalloc memory with HW_TAGS
      mm: introduce clear_highpage_kasan_tagged

Andrey Strachuk (1):
      usb: cdns3: change place of 'priv_ep' assignment in cdns3_gadget_ep_dequeue(), cdns3_gadget_ep_enable()

Andrii Nakryiko (1):
      bpf: fix potential 32-bit overflow when accessing ARRAY map element

Andy Shevchenko (2):
      spi: Return deferred probe error when controller isn't yet available
      phy: ti: tusb1210: Don't check for write errors when powering on

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

Armin Wolf (2):
      hwmon: (dell-smm) Add Dell XPS 13 7390 to fan control whitelist
      hwmon: (sch56xx-common) Add DMI override table

Arnaldo Carvalho de Melo (1):
      genelf: Use HAVE_LIBCRYPTO_SUPPORT, not the never defined HAVE_LIBCRYPTO

Arnd Bergmann (1):
      media: sta2x11: remove VIRT_TO_BUS dependency

Artem Bityutskiy (1):
      intel_idle: make SPR C1 and C1E be independent

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

Atish Patra (3):
      RISC-V: Fix counter restart during overflow for RV32
      RISC-V: Fix SBI PMU calls for RV32
      RISC-V: Update user page mapping only once during start

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

Ben Dooks (2):
      RISC-V: cpu_ops_spinwait.c should include head.h
      RISC-V: Declare cpu_ops_spinwait in <asm/cpu_ops.h>

Ben Gardon (1):
      KVM: x86: Fix errant brace in KVM capability handling

Benjamin Beichler (1):
      um: Remove straying parenthesis

Benjamin Gaignard (5):
      media: Hantro: Correct G2 init qp field
      media: hantro: HEVC: Fix output frame chroma offset
      media: hantro: HEVC: Fix reference frames management
      media: hantro: Be more accurate on pixel formats step_width constraints
      media: uapi: HEVC: Change pic_order_cnt definition in v4l2_hevc_dpb_entry

Benjamin Segall (1):
      epoll: autoremove wakers even more aggressively

Bharath SM (1):
      SMB3: fix lease break timeout when multiple deferred close handles for the same file.

Biju Das (2):
      spi: spi-rspi: Fix PIO fallback on RZ platforms
      clk: renesas: rzg2l: Fix reset status function

Bikash Hazarika (2):
      scsi: qla2xxx: Fix incorrect display of max frame size
      scsi: qla2xxx: Zero undefined mailbox IN registers

Bjorn Andersson (3):
      drm/bridge: lt9611uxc: Cancel only driver's work
      i2c: qcom-geni: Use the correct return value
      clk: qcom: gdsc: Bump parent usage count when GDSC is found enabled

Bo-Chen Chen (1):
      drm/mediatek: dpi: Remove output format of YUV

Bob Pearson (3):
      RDMA/rxe: Fix deadlock in rxe_do_local_ops()
      RDMA/rxe: Fix mw bind to allow any consumer key portion
      RDMA/rxe: Fix rnr retry behavior

Brian Norris (1):
      drm/rockchip: vop: Don't crash for invalid duplicate_state()

Bryan O'Donoghue (5):
      clk: qcom: gcc-msm8939: Add missing SYSTEM_MM_NOC_BFDCD_CLK_SRC
      clk: qcom: gcc-msm8939: Fix bimc_ddr_clk_src rcgr base address
      clk: qcom: gcc-msm8939: Add missing system_mm_noc_bfdcd_clk_src
      clk: qcom: gcc-msm8939: Point MM peripherals to system_mm_noc clock
      clk: qcom: gcc-msm8939: Fix weird field spacing in ftbl_gcc_camss_cci_clk

Byungki Lee (1):
      f2fs: write checkpoint during FG_GC

Cameron Williams (1):
      tty: 8250: Add support for Brainboxes PX cards.

Carlos Llamas (1):
      binder: fix redefinition of seq_file attributes

Catalin Marinas (1):
      arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags"

Chanho Park (2):
      arm64: dts: exynosautov9: correct spi11 pin names
      phy: samsung: exynosautov9-ufs: correct TSRV register configurations

Chao Liu (1):
      f2fs: fix to remove F2FS_COMPR_FL and tag F2FS_NOCOMP_FL at the same time

Chao Yu (5):
      f2fs: fix to invalidate META_MAPPING before DIO write
      f2fs: check pinfile in gc_data_segment() in advance
      f2fs: don't set GC_FAILURE_PIN for background GC
      f2fs: give priority to select unpinned section for foreground GC
      f2fs: fix to check inline_data during compressed inode conversion

Chen Lifu (1):
      riscv: lib: uaccess: fix CSR_STATUS SR_SUM bit

Chen Yu (1):
      sched/fair: Introduce SIS_UTIL to search idle CPU based on sum of util_avg

Chen Zhongjin (3):
      profiling: fix shift too large makes kernel panic
      kprobes: Forbid probing on trampoline and BPF code areas
      locking/csd_lock: Change csdlock_debug from early_param to __setup

Chen-Yu Tsai (2):
      media: mediatek: vcodec: Skip SOURCE_CHANGE & EOS events for stateless
      media: mediatek: vcodec: Initialize decoder parameters for each instance

Cheng Xu (1):
      RDMA/siw: Fix duplicated reported IW_CM_EVENT_CONNECT_REPLY event

Chenyi Qiang (1):
      x86/bus_lock: Don't assume the init value of DEBUGCTLMSR.BUS_LOCK_DETECT to be zero

Chris Paterson (1):
      arm64: dts: renesas: r9a07g054l2-smarc: Correct SoC name in comment

Christian 'Ansuel' Marangi (1):
      ath11k: fix missing skb drop on htc_tx_completion error

Christian König (1):
      drm/amdgpu: cleanup ctx implementation

Christian Lamparter (1):
      ARM: dts: BCM5301X: Add DT for Meraki MR26

Christian Loehle (1):
      mmc: block: Add single read for 4k sector cards

Christian Marangi (1):
      PCI: qcom: Set up rev 2.1.0 PARF_PHY before enabling clocks

Christoph Hellwig (3):
      nvme: catch -ENODEV from nvme_revalidate_zones again
      block: serialize all debugfs operations using q->debugfs_mutex
      block: add a bdev_max_zone_append_sectors helper

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

Christophe Leroy (7):
      powerpc: Restore CONFIG_DEBUG_INFO in defconfigs
      powerpc/64e: Fix early TLB miss with KUAP
      powerpc/ptdump: Fix display of RW pages on FSL_BOOK3E
      powerpc/32: Call mmu_mark_initmem_nx() regardless of data block mapping.
      powerpc/32s: Fix boot failure with KASAN + SMP + JUMP_LABEL_FEATURE_CHECK_DEBUG
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

Coiby Xu (1):
      kexec: clean up arch_kexec_kernel_verify_sig

Conor Dooley (1):
      dt-bindings: riscv: fix SiFive l2-cache's cache-sets

Corentin Labbe (1):
      crypto: sun8i-ss - do not allocate memory when handling hash requests

Daeho Jeong (2):
      f2fs: change the current atomic write way
      f2fs: revive F2FS_IOC_ABORT_VOLATILE_WRITE

Dan Carpenter (15):
      wifi: rtlwifi: fix error codes in rtl_debugfs_set_write_h2c()
      crypto: sun8i-ss - fix error codes in allocate_flows()
      wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()
      selftests/bpf: fix a test for snprintf() overflow
      libbpf: fix an snprintf() overflow check
      drm/amd/display: fix signedness bug in execute_synaptics_rc_command()
      scsi: qla2xxx: Check correct variable in qla24xx_async_gffid()
      eeprom: idt_89hpesx: uninitialized data in idt_dbgfs_csr_write()
      iio: adc: max1027: unlock on error path in max1027_read_single_value()
      tools/power/x86/intel-speed-select: Fix off by one check
      platform/olpc: Fix uninitialized data in debugfs write
      tools/testing/selftests/vm/hugetlb-madvise.c: silence uninitialized variable warning
      selftest/vm: uninitialized variable in main()
      null_blk: fix ida error handling in null_add_dev()
      kfifo: fix kfifo_to_user() return type

Dan Williams (1):
      ACPI: APEI: Fix _EINJ vs EFI_MEMORY_SP

Daniel Bristot de Oliveira (1):
      rtla: Fix Makefile when called from -C tools/

Daniel Starke (13):
      tty: n_gsm: fix user open not possible at responder until initiator open
      tty: n_gsm: fix tty registration before control channel open
      tty: n_gsm: fix wrong queuing behavior in gsm_dlci_data_output()
      tty: n_gsm: fix missing timer to handle stalled links
      tty: n_gsm: fix non flow control frames during mux flow off
      tty: n_gsm: fix packet re-transmission without open control channel
      tty: n_gsm: fix race condition in gsmld_write()
      tty: n_gsm: fix deadlock and link starvation in outgoing data path
      tty: n_gsm: fix resource allocation order in gsm_activate_mux()
      tty: n_gsm: fix wrong T1 retry count handling
      tty: n_gsm: fix DM command
      tty: n_gsm: fix flow control handling in tx path
      tty: n_gsm: fix missing corner cases in gsmld_poll()

Dave Stevenson (14):
      drm/vc4: plane: Fix margin calculations for the right/bottom edges
      drm/vc4: dsi: Release workaround buffer and DMA
      drm/vc4: dsi: Correct DSI divider calculations
      drm/vc4: dsi: Correct pixel order for DSI0
      drm/vc4: dsi: Register dsi0 as the correct vc4 encoder type
      drm/vc4: dsi: Fix dsi0 interrupt support
      drm/vc4: dsi: Add correct stop condition to vc4_dsi_encoder_disable iteration
      drm/vc4: hdmi: Add all the vc5 HDMI registers into the debugfs dumps
      drm/vc4: hdmi: Reset HDMI MISC_CONTROL register
      drm/vc4: hdmi: Switch to pm_runtime_status_suspended
      drm/vc4: hdmi: Move HDMI reset to pm_resume
      drm/vc4: hdmi: Correct HDMI timing registers for interlaced modes
      drm/vc4: hdmi: Move pixel doubling from Pixelvalve to HDMI block
      drm/vc4: drv: Adopt the dma configuration from the HVS or V3D component

David Collins (1):
      spmi: trace: fix stack-out-of-bound access in SPMI tracing functions

David Gow (1):
      kunit: executor: Fix a memory leak on failure in kunit_filter_tests

David Heidelberg (1):
      arm64: dts: qcom: timer should use only 32-bit size

David Howells (1):
      vfs: Check the truncate maximum size in inode_newsize_ok()

Deren Wu (3):
      mt76: mt7921s: fix possible sdio deadlock in command fail
      mt76: mt7921: fix aggregation subframes setting to HE max
      mt76: mt7921: enlarge maximum VHT MPDU length to 11454

Dmitry Baryshkov (7):
      arm64: dts: qcom: sdm630: disable GPU by default
      arm64: dts: qcom: sdm630: fix the qusb2phy ref clock
      arm64: dts: qcom: sdm630: fix gpu's interconnect path
      arm64: dts: qcom: sdm636-sony-xperia-ganges-mermaid: correct sdc2 pinconf
      arm64: dts: qcom: msm8996: correct #clock-cells for QMP PHY nodes
      drm/msm/hdmi: fill the pwr_regs bulk regulators
      phy: qcom-qmp: fix the QSERDES_V5_COM_CMN_MODE register

Dmitry Osipenko (3):
      drm/gem: Properly annotate WW context on drm_gem_lock_reservations() error
      drm/shmem-helper: Add missing vunmap on error
      drm/tegra: Fix vmapping of prime buffers

Dom Cobley (3):
      drm/vc4: plane: Remove subpixel positioning check
      drm/vc4: hdmi: Clear unused infoframe packet RAM registers
      drm/vc4: hdmi: Avoid full hdmi audio fifo writes

Dongliang Mu (1):
      RDMA/rxe: fix xa_alloc_cycle() error return value check again

Doug Berger (1):
      serial: 8250_bcm7271: Save/restore RTS in suspend/resume

Douglas Anderson (2):
      drm/dp: Export symbol / kerneldoc fixes for DP AUX bus
      drm/msm: Avoid unclocked GMU register access in 6xx gpu_busy

Duoming Zhou (3):
      mtd: sm_ftl: Fix deadlock caused by cancel_work_sync in sm_release
      mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv
      staging: rtl8192u: Fix sleep in atomic context bug in dm_fsync_timer_callback

Eric Auger (1):
      ACPI: VIOT: Fix ACS setup

Eric Dumazet (11):
      net: fix sk_wmem_schedule() and sk_rmem_schedule() errors
      tcp: fix possible freeze in tx path under memory pressure
      raw: use more conventional iterators
      raw: convert raw sockets to RCU
      ax25: fix incorrect dev_tracker usage
      inet: add READ_ONCE(sk->sk_bound_dev_if) in INET_MATCH()
      ipv6: add READ_ONCE(sk->sk_bound_dev_if) in INET6_MATCH()
      net: rose: fix netdev reference changes
      tcp: fix over estimation in sk_forced_mem_schedule()
      raw: remove unused variables from raw6_icmp_error()
      raw: fix a typo in raw_icmp_error()

Eric Farman (2):
      vfio/ccw: Fix FSM state if mdev probe fails
      vfio/ccw: Do not change FSM state in subchannel event

Eric Whitney (1):
      ext4: fix extent status tree race in writeback error recovery path

Eugen Hristev (2):
      media: atmel: atmel-sama7g5-isc: fix warning in configs without OF
      mmc: sdhci-of-at91: fix set_uhs_signaling rewriting of MC1R

Ezequiel Garcia (2):
      media: hantro: Fix RK3399 H.264 format advertising
      hantro: Remove incorrect HEVC SPS validation

Fabio Estevam (4):
      i2c: mxs: Silence a clang warning
      mmc: mxcmmc: Silence a clang warning
      dmaengine: imx-dma: Cast of_device_get_match_data() with (uintptr_t)
      ASoC: imx-audmux: Silence a clang warning

Fabrice Gasnier (1):
      phy: stm32: fix error return in stm32_usbphyc_phy_init

Fawzi Khaber (1):
      iio: fix iio_format_avail_range() printing for none IIO_VAL_INT

Felix Fietkau (1):
      mt76: mt7615: fix throughput regression on DFS channels

Filipe Manana (1):
      btrfs: join running log transaction when logging new name

Florian Fainelli (3):
      MIPS: vdso: Utilize __pa() for gic_pfn
      MIPS: Fixed __debug_virt_addr_valid()
      tools/thermal: Fix possible path truncations

Florian Westphal (2):
      netfilter: nf_tables: fix null deref due to zeroed list head
      netfilter: nft_queue: only allow supported familes and hooks

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

Geert Uytterhoeven (5):
      arm64: dts: renesas: beacon: Fix regulator node names
      soc: renesas: r8a779a0-sysc: Fix A2DP1 and A2CV[2357] PDR values
      arm64: dts: renesas: Fix thermal-sensors on single-zone sensors
      arm64: dts: renesas: r8a779m8: Drop operating points above 1.5 GHz
      mtd: hyperbus: rpc-if: Fix RPM imbalance in probe error path

Greg Kroah-Hartman (2):
      Revert "mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv"
      Linux 5.18.18

Guenter Roeck (1):
      HID: nintendo: Add missing array termination

Guilherme G. Piccoli (1):
      ACPI: processor/idle: Annotate more functions to live in cpuidle section

Guillaume Ranquet (1):
      drm/mediatek: dpi: Only enable dpi after the bridge is enabled

Guo Mengqi (2):
      spi: synquacer: Add missing clk_disable_unprepare()
      serial: 8250_bcm2835aux: Add missing clk_disable_unprepare()

Gwendal Grignou (2):
      iio: sx9324: Fix register field spelling
      iio: cros: Register FIFO callback after sensor is registered

Haibo Chen (1):
      clk: imx93: use adc_root as the parent clock of adc1

Hangyu Hua (4):
      drm: bridge: sii8620: fix possible off-by-one
      wifi: libertas: Fix possible refcount leak in if_usb_probe()
      dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in the same lock
      net: 9p: fix refcount leak in p9_read_work() error handling

Hans de Goede (4):
      ACPI: EC: Remove duplicate ThinkPad X1 Carbon 6th entry from DMI quirks
      ACPI: EC: Drop the EC_FLAGS_IGNORE_DSDT_GPE quirk
      ACPI: video: Use native backlight on Dell Inspiron N4010
      platform/x86: pmc_atom: Match all Lex BayTrail boards with critclk_systems DMI table

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

Hsin-Yi Wang (2):
      PM: domains: Ensure genpd_debugfs_dir exists before remove
      drm/bridge: anx7625: Fix NULL pointer crash when using edp-panel

Huacai Chen (2):
      MIPS: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
      tpm: eventlog: Fix section mismatch for DEBUG_SECTION_MISMATCH

Hyunchul Lee (4):
      ksmbd: prevent out of bound read for SMB2_TREE_CONNNECT
      ksmbd: smbd: change prototypes of RDMA read/write related functions
      ksmbd: smbd: introduce read/write credits for RDMA read/write
      ksmbd: prevent out of bound read for SMB2_WRITE

Ian Rogers (1):
      perf symbol: Fail to read phdr workaround

Ido Schimmel (1):
      netdevsim: fib: Fix reference count leak on route deletion failure

Imre Deak (1):
      drm/dp/mst: Read the extended DPCD capabilities during system resume

Ivan Hasenkampf (1):
      ALSA: hda/realtek: Add quirk for HP Spectre x360 15-eb0xxx

Jack Wang (1):
      RDMA/rtrs-srv: Fix modinfo output for stringify

Jaegeuk Kim (1):
      f2fs: kill volatile write support

Jaewook Kim (1):
      f2fs: do not allow to decompress files have FI_COMPRESS_RELEASED

Jagath Jog J (3):
      iio: accel: bma400: Fix the scale min and max macro values
      iio: accel: bma400: Reordering of header files
      iio: accel: bma400: conversion to device-managed function

Jakub Kicinski (1):
      netdevsim: Avoid allocation warnings triggered from user space

James Morse (1):
      arm64: errata: Remove AES hwcap for COMPAT tasks

James Smart (1):
      scsi: lpfc: Remove extra atomic_inc on cmd_pending in queuecommand after VMID

Jan Kara (6):
      mbcache: don't reclaim used entries
      mbcache: add functions to delete entry if unused
      ext2: Add more validity checks for inode counts
      ext4: remove EA inode entry from mbcache on inode eviction
      ext4: unindent codeblock in ext4_xattr_block_set()
      ext4: fix race when reusing xattr blocks

Jason A. Donenfeld (9):
      wireguard: selftests: set CONFIG_NONPORTABLE on riscv32
      um: seed rng using host OS rng
      fs: check FMODE_LSEEK to control internal pipe splicing
      wireguard: ratelimiter: use hrtimer in selftest
      wireguard: allowedips: don't corrupt stack when detecting overflow
      crypto: blake2s - remove shash module
      timekeeping: contribute wall clock to rng on time change
      powerpc/powernv/kvm: Use darn for H_RANDOM on Power9
      crypto: lib/blake2s - reduce stack frame usage in self test

Jason Gunthorpe (1):
      vfio/pci: Have all VFIO PCI drivers store the vfio_pci_core_device in drvdata

Javier Martinez Canillas (1):
      drm/st7735r: Fix module autoloading for Okaya RH128128T

Jean Delvare (1):
      watchdog: sp5100_tco: Fix a memory leak of EFCH MMIO resource

Jeff Layton (2):
      nfsd: eliminate the NFSD_FILE_BREAK_* flags
      lockd: detect and reject lock arguments that overflow

Jens Axboe (1):
      io_uring: move to separate directory

Jeongik Cha (1):
      wifi: mac80211_hwsim: fix race condition in pending packet

Jernej Skrabec (3):
      media: cedrus: h265: Fix flag name
      media: cedrus: h265: Fix logic for not low delay flag
      media: cedrus: hevc: Add check for invalid timestamp

Jiachen Zhang (1):
      ovl: drop WARN_ON() dentry is NULL in ovl_encode_fh()

Jian Shen (3):
      test_bpf: fix incorrect netdev features
      net: ice: fix error NETIF_F_HW_VLAN_CTAG_FILTER check in ice_vsi_sync_fltr()
      net: ionic: fix error check for vlan flags in ionic_set_nic_features()

Jian Zhang (2):
      media: driver/nxp/imx-jpeg: fix a unexpected return value problem
      drm/exynos/exynos7_drm_decon: free resources when clk_set_parent() failed.

Jianglei Nie (3):
      RDMA/qedr: Fix potential memory leak in __qedr_alloc_mr()
      RDMA/hfi1: fix potential memory leak in setup_base_ctxt()
      mm/damon/reclaim: fix potential memory leak in damon_reclaim_init()

Jiasheng Jiang (5):
      drm: bridge: adv7511: Add check for mipi_dsi_driver_register
      Bluetooth: hci_intel: Add check for platform_driver_register
      intel_th: msu-sink: Potential dereference of null pointer
      ASoC: codecs: da7210: add check for i2c_add_driver
      watchdog: f71808e_wdt: Add check for platform_driver_register

Jing Leng (1):
      kbuild: Fix include path in scripts/Makefile.modpost

Jinke Han (1):
      block: don't allow the same type rq_qos add more than once

Jiri Slaby (1):
      serial: pic32: free up irq names correctly

Jitao Shi (2):
      drm/mediatek: Separate poweron/poweroff from enable/disable and define new funcs
      drm/mediatek: Keep dsi as LP00 before dcs cmds transfer

Joanne Koong (1):
      bpf: Fix bpf_xdp_pointer return pointer

Joe Lawrence (1):
      selftests/livepatch: better synchronize test_klp_callbacks_busy

Johan Hovold (8):
      x86/pmem: Fix platform-device leak in error path
      arm64: dts: qcom: sc7280: drop PCIe PHY clock index
      arm64: dts: qcom: sm8250: add missing PCIe PHY clock-cells
      arm64: dts: qcom: sc7280: fix PCIe clock reference
      ath11k: fix netdev open race
      ath11k: fix IRQ affinity warning on shutdown
      usb: dwc3: qcom: fix missing optional irq warnings
      USB: serial: fix tty-port initialized comments

Johannes Berg (2):
      wifi: mac80211_hwsim: add back erroneously removed cast
      wifi: mac80211_hwsim: use 32-bit skb cookie

John Allen (1):
      crypto: ccp - Use kzalloc for sev ioctl interfaces to prevent kernel memory leak

John Keeping (1):
      sched/core: Always flush pending blk_plug

John Stultz (1):
      drm/bridge: lt9611: Use both bits for HDMI sensing

Jonathan Cameron (89):
      iio: core: Fix IIO_ALIGN and rename as it was not sufficiently large
      iio: accel: adxl313: Fix alignment for DMA safety
      iio: accel: adxl355: Fix alignment for DMA safety
      iio: accel: adxl367: Fix alignment for DMA safety
      iio: accel: bma220: Fix alignment for DMA safety
      iio: accel: sca3000: Fix alignment for DMA safety
      iio: accel: sca3300: Fix alignment for DMA safety
      iio: adc: ad7266: Fix alignment for DMA safety
      iio: adc: ad7280a: Fix alignment for DMA safety
      iio: adc: ad7292: Fix alignment for DMA safety
      iio: adc: ad7298: Fix alignment for DMA safety
      iio: adc: ad7476: Fix alignment for DMA safety
      iio: adc: ad7606: Fix alignment for DMA safety
      iio: adc: ad7766: Fix alignment for DMA safety
      iio: adc: ad7768-1: Fix alignment for DMA safety
      iio: adc: ad7887: Fix alignment for DMA safety
      iio: adc: ad7923: Fix alignment for DMA safety
      iio: adc: ad7949: Fix alignment for DMA safety
      iio: adc: hi8435: Fix alignment for DMA safety
      iio: adc: ltc2496: Fix alignment for DMA safety
      iio: adc: ltc2497: Fix alignment for DMA safety
      iio: adc: max1027: Fix alignment for DMA safety
      iio: adc: max11100: Fix alignment for DMA safety
      iio: adc: max1118: Fix alignment for DMA safety
      iio: adc: max1241: Fix alignment for DMA safety
      iio: adc: mcp320x: Fix alignment for DMA safety
      iio: adc: ti-adc0832: Fix alignment for DMA safety
      iio: adc: ti-adc084s021: Fix alignment for DMA safety
      iio: adc: ti-adc108s102: Fix alignment for DMA safety
      iio: adc: ti-adc12138: Fix alignment for DMA safety
      iio: adc: ti-adc128s052: Fix alignment for DMA safety
      iio: adc: ti-adc161s626: Fix alignment for DMA safety
      iio: adc: ti-ads124s08: Fix alignment for DMA safety
      iio: adc: ti-ads131e08: Fix alignment for DMA safety
      iio: adc: ti-ads7950: Fix alignment for DMA safety
      iio: adc: ti-ads8344: Fix alignment for DMA safety
      iio: adc: ti-ads8688: Fix alignment for DMA safety
      iio: adc: ti-tlc4541: Fix alignment for DMA safety
      iio: addac: ad74413r: Fix alignment for DMA safety
      iio: amplifiers: ad8366: Fix alignment for DMA safety
      iio: common: ssp: Fix alignment for DMA safety
      iio: dac: ad5064: Fix alignment for DMA safety
      iio: dac: ad5360: Fix alignment for DMA safety
      iio: dac: ad5421: Fix alignment for DMA safety
      iio: dac: ad5449: Fix alignment for DMA safety
      iio: dac: ad5504: Fix alignment for DMA safety
      iio: dac: ad5592r: Fix alignment for DMA safety
      iio: dac: ad5686: Fix alignment for DMA safety
      iio: dac: ad5755: Fix alignment for DMA safety
      iio: dac: ad5761: Fix alignment for DMA safety
      iio: dac: ad5764: Fix alignment for DMA safety
      iio: dac: ad5766: Fix alignment for DMA safety
      iio: dac: ad5770r: Fix alignment for DMA safety
      iio: dac: ad5791: Fix alignment for DMA saftey
      iio: dac: ad7293: Fix alignment for DMA safety
      iio: dac: ad7303: Fix alignment for DMA safety
      iio: dac: ad8801: Fix alignment for DMA safety
      iio: dac: ltc2688: Fix alignment for DMA safety
      iio: dac: mcp4922: Fix alignment for DMA safety
      iio: dac: ti-dac082s085: Fix alignment for DMA safety
      iio: dac: ti-dac5571: Fix alignment for DMA safety
      iio: dac: ti-dac7311: Fix alignment for DMA safety
      iio: dac: ti-dac7612: Fix alignment for DMA safety
      iio: frequency: ad9523: Fix alignment for DMA safety
      iio: frequency: adf4350: Fix alignment for DMA safety
      iio: frequency: adf4371: Fix alignment for DMA safety
      iio: frequency: admv1013: Fix alignment for DMA safety
      iio: frequency: admv1014: Fix alignment for DMA safety
      iio: frequency: admv4420: Fix alignment for DMA safety
      iio: frequency: adrf6780: Fix alignment for DMA safety
      iio: gyro: adis16080: Fix alignment for DMA safety
      iio: gyro: adis16130: Fix alignment for DMA safety
      iio: gyro: adxrs450: Fix alignment for DMA safety
      iio: gyro: fxas210002c: Fix alignment for DMA safety
      iio: imu: fxos8700: Fix alignment for DMA safety
      iio: imu: inv_icm42600: Fix alignment for DMA safety
      iio: imu: inv_icm42600: Fix alignment for DMA safety in buffer code.
      iio: imu: mpu6050: Fix alignment for DMA safety
      iio: potentiometer: ad5110: Fix alignment for DMA safety
      iio: potentiometer: ad5272: Fix alignment for DMA safety
      iio: potentiometer: max5481: Fix alignment for DMA safety
      iio: potentiometer: mcp41010: Fix alignment for DMA safety
      iio: potentiometer: mcp4131: Fix alignment for DMA safety
      iio: proximity: as3935: Fix alignment for DMA safety
      iio: resolver: ad2s1200: Fix alignment for DMA safety
      iio: resolver: ad2s90: Fix alignment for DMA safety
      iio: temp: ltc2983: Fix alignment for DMA safety
      iio: temp: max31865: Fix alignment for DMA safety
      iio: temp: maxim_thermocouple: Fix alignment for DMA safety

Jose Alonso (1):
      Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"

Jose Ignacio Tornos Martinez (1):
      wifi: iwlwifi: mvm: fix double list_add at iwl_mvm_mac_wake_tx_queue

Josef Bacik (3):
      btrfs: tree-log: make the return value for log syncing consistent
      btrfs: reset block group chunk force if we have to wait
      btrfs: make the bg_reclaim_threshold per-space info

Josh Poimboeuf (1):
      scripts/faddr2line: Fix vmlinux detection on arm64

Julia Lawall (2):
      ia64: fix typos in comments
      powerpc: fix typos in comments

Juri Lelli (1):
      wait: Fix __wait_event_hrtimeout for RT/DL tasks

Jörn-Thorben Hinz (1):
      selftests/bpf: Fix rare segfault in sock_fields prog test

Kai Ye (1):
      crypto: hisilicon/sec - fix auth key size error

Kan Liang (1):
      perf stat: Revert "perf stat: Add default hybrid events"

Kees Cook (2):
      kasan: test: Silence GCC 12 warnings
      lib: overflow: Do not define 64-bit tests on 32-bit

Keith Busch (3):
      block: fix infinite loop for invalid zone append
      block/bio: remove duplicate append pages code
      block: ensure iov_iter advances for added pages

Kent Overstreet (2):
      9p: Drop kref usage
      9p: Add client parameter to p9_req_put()

Kim Phillips (1):
      x86/bugs: Enable STIBP for IBPB mitigated RETBleed

Konrad Dybcio (14):
      ARM: dts: qcom-msm8974*: Fix UART naming
      ARM: dts: qcom-msm8974*: Fix I2C labels
      ARM: dts: qcom-msm8974: Fix up mdss nodes
      ARM: dts: qcom-msm8974: Fix up SDHCI nodes
      ARM: dts: qcom-msm8974*: Rename msmgpio to tlmm
      ARM: dts: qcom-apq8074-dragonboard: Use &labels
      ARM: dts: qcom-msm8974-fp2: Use &labels
      ARM: dts: qcom-msm8974-lge-nexus5: Use &labels
      ARM: dts: qcom-msm8974-klte: Use &labels
      ARM: dts: qcom-msm8974-{"hon","am"}ami: Commonize and modernize the DTs
      ARM: dts: qcom-msm8974-castor: Use &labels
      ARM: dts: qcom-msm8974: Convert ADSP to a MMIO device
      ARM: dts: qcom-msm8974: Sort and clean up nodes
      soc: qcom: Make QCOM_RPMPD depend on PM

Krzysztof Kozlowski (13):
      arm64: dts: qcom: add missing AOSS QMP compatible fallback
      ARM: dts: ast2500-evb: fix board compatible
      ARM: dts: ast2600-evb: fix board compatible
      ARM: dts: ast2600-evb-a1: fix board compatible
      spi: s3c64xx: constify fsd_spi_port_config
      ARM: dts: qcom: mdm9615: add missing PMIC GPIO reg
      ARM: dts: qcom: msm8974-lge-nexus5: move gpio-keys out of soc
      ARM: dts: qcom: msm8974-samsung-klte: move gpio-keys out of soc
      ARM: dts: qcom: do not use underscore in node name
      ARM: dts: qcom: msm8974: add required ranges to OCMEM
      ARM: dts: qcom: pm8841: add required thermal-sensor-cells
      ath10k: do not enforce interrupt trigger type
      ASoC: samsung: h1940_uda1380: include proepr GPIO consumer header

Kui-Feng Lee (1):
      bpf, x86: Generate trampolines from bpf_tramp_links

Kumar Kartikeya Dwivedi (10):
      bpf: Make btf_find_field more generic
      bpf: Move check_ptr_off_reg before check_map_access
      bpf: Allow storing unreferenced kptr in map
      bpf: Tag argument to be released in bpf_func_proto
      bpf: Allow storing referenced kptr in map
      bpf: Adapt copy_map_value for multiple offset case
      bpf: Populate pairs of btf_id and destructor kfunc in btf
      bpf: Wire up freeing of referenced kptr
      bpf: Fix sparse warning for bpf_kptr_xchg_proto
      bpf: Suppress 'passing zero to PTR_ERR' warning

Kunihiko Hayashi (2):
      ARM: dts: uniphier: Fix USB interrupts for PXs2 SoC
      arm64: dts: uniphier: Fix USB interrupts for PXs3 SoC

Kuninori Morimoto (1):
      ASoC: audio-graph-card2.c: use of_property_read_u32() for rate

Kuniyuki Iwashima (1):
      raw: Fix mixed declarations error in raw_icmp_error().

Lad Prabhakar (1):
      mmc: renesas_sdhi: Get the reset handle early in the probe

Lars-Peter Clausen (1):
      i2c: cadence: Support PEC for SMBus block read

Leo Li (1):
      drm/amdgpu: Check BO's requested pinning domains against its preferred_domains

Lev Kujawski (1):
      KVM: set_msr_mce: Permit guests to ignore single-bit ECC errors

Li Lingfeng (1):
      ext4: recover csum seed of tmp_inode after migrating to extents

Liam R. Howlett (1):
      android: binder: stop saving a pointer to the VMA

Liang He (22):
      ARM: OMAP2+: display: Fix refcount leak bug
      ARM: OMAP2+: pdata-quirks: Fix refcount leak bug
      ARM: shmobile: rcar-gen2: Increase refcount for new reference
      soc: amlogic: Fix refcount leak in meson-secure-pwrc.c
      regulator: of: Fix refcount leak bug in of_get_regulation_constraints()
      perf: RISC-V: Add of_node_put() when breaking out of for_each_of_cpu_node()
      mediatek: mt76: mac80211: Fix missing of_node_put() in mt76_led_init()
      mediatek: mt76: eeprom: fix missing of_node_put() in mt76_find_power_limits_node()
      i2c: mux-gpmux: Add of_node_put() when breaking out of loop
      of: device: Fix missing of_node_put() in of_dma_set_restricted_buffer
      usb: aspeed-vhub: Fix refcount leak bug in ast_vhub_init_desc()
      gpio: gpiolib-of: Fix refcount bugs in of_mm_gpiochip_add_data()
      mmc: core: quirks: Add of_node_put() when breaking out of loop
      mmc: cavium-octeon: Add of_node_put() when breaking out of loop
      mmc: cavium-thunderx: Add of_node_put() when breaking out of loop
      ASoC: qcom: Fix missing of_node_put() in asoc_qcom_lpass_cpu_platform_probe()
      ASoc: audio-graph-card2: Fix refcount leak bug in __graph_get_type()
      ASoC: mt6359: Fix refcount leak bug
      iommu/arm-smmu: qcom_iommu: Add of_node_put() when breaking out of loop
      ASoC: audio-graph-card: Add of_node_put() in fail path
      ASoC: audio-graph-card2: Add of_node_put() in fail path
      video: fbdev: amba-clcd: Fix refcount leak bugs

Like Xu (2):
      KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
      KVM: x86/pmu: Ignore pmu->global_ctrl check if vPMU doesn't support global_ctrl

Linus Walleij (4):
      ARM: dts: ux500: Fix Janice accelerometer mounting matrix
      ARM: dts: ux500: Fix Codina accelerometer mounting matrix
      ARM: dts: ux500: Fix Gavini accelerometer mounting matrix
      hwmon: (drivetemp) Add module alias

Linyu Yuan (1):
      usb: typec: ucsi: Acknowledge the GET_ERROR_STATUS command completion

Liu Jian (1):
      skmsg: Fix invalid last sg check in sk_msg_recvmsg()

Liu Ying (1):
      clk: imx: clk-fracn-gppll: Return rate in rate table properly in ->recalc_rate()

Lorenzo Bianconi (3):
      mt76: mt76x02u: fix possible memory leak in __mt76x02u_mcu_send_msg
      mt76: mt7615: do not update pm stats in case of error
      mt76: mt7921: do not update pm states in case of error

Luca Weiss (2):
      ARM: dts: qcom-msm8974: fix irq type on blsp2_uart1
      ARM: dts: qcom: msm8974-FP2: Add supplies for remoteprocs

Luiz Augusto von Dentz (2):
      Bluetooth: hci_sync: Fix not updating privacy_mode
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

Manikanta Pubbisetty (2):
      ath11k: Fix incorrect debug_mask mappings
      ath11k: Avoid REO CMD failed prints during firmware recovery

Manivannan Sadhasivam (1):
      ARM: dts: qcom: sdx55: Fix the IRQ trigger type for UART

Manyi Li (1):
      ACPI: PM: save NVS memory for Lenovo G40-45

Maor Dickman (1):
      net/mlx5e: TC, Fix post_act to not match on in_port metadata

Maor Gottlieb (1):
      RDMA/mlx5: Add missing check for return value in get namespace flow

Marc Kleine-Budde (2):
      can: netlink: allow configuring of fixed bit rates without need for do_set_bittiming callback
      can: netlink: allow configuring of fixed data bit rates without need for do_set_data_bittiming callback

Marc Zyngier (1):
      arm64: Expand ESR_ELx_WFx_ISS_TI to match its ARMv8.7 definition

Marcel Ziswiler (1):
      ARM: dts: imx7d-colibri-emmc: add cpu1 supply

Marco Pagani (1):
      fpga: altera-pr-ip: fix unsigned comparison with less than zero

Marek Vasut (3):
      drm/bridge: tc358767: Move (e)DP bridge endpoint parsing into dedicated function
      drm/bridge: tc358767: Make sure Refclk clock are enabled
      drm/bridge: tc358767: Fix (e)DP bridge endpoint parsing in dedicated function

Marijn Suijten (4):
      arm64: dts: qcom: sdm845-akatsuki: Round down l22a regulator voltage
      arm64: dts: qcom: sm6125: Move sdc2 pinctrl from seine-pdx201 to sm6125
      arm64: dts: qcom: sm6125: Append -state suffix to pinctrl nodes
      arm64: dts: qcom: msm8998: Make regulator voltages multiple of step-size

Mario Limonciello (2):
      pinctrl: Don't allow PINCTRL_AMD to be a module
      HID: amd_sfh: Don't show client init failed as error when discovery fails

Marios Makassikis (1):
      ksmbd: validate length in smb2_write()

Mark Brown (1):
      mtd: dataflash: Add SPI ID table

Mark Kettenis (1):
      riscv: dts: starfive: correct number of external interrupts

Mark Rutland (2):
      arch: make TRACE_IRQFLAGS_NMI_SUPPORT generic
      arm64: select TRACE_IRQFLAGS_NMI_SUPPORT

Markus Mayer (1):
      thermal/tools/tmon: Include pthread and time headers in tmon.h

Martin KaFai Lau (1):
      selftests/bpf: Fix tc_redirect_dtime

Masami Hiramatsu (Google) (1):
      x86/kprobes: Update kcb status flag after singlestepping

Mateusz Jończyk (1):
      drm/radeon: avoid bogus "vram limit (0) must be a power of 2" warning

Mateusz Kwiatkowski (1):
      drm/vc4: hdmi: Fix timings for interlaced modes

Mathew McBride (1):
      rtc: rx8025: fix 12/24 hour mode detection on RX-8035

Matthew Wilcox (Oracle) (2):
      mm: Account dirty folios properly during splits
      cifs: Fix memory leak when using fscache

Max Filippov (1):
      xtensa: iss/network: provide release() callback

Max Krummenacher (1):
      Revert "ARM: dts: imx6qdl-apalis: Avoid underscore in node name"

Maxim Mikityanskiy (4):
      net/mlx5e: Fix the value of MLX5E_MAX_RQ_NUM_MTTS
      net/mlx5e: xsk: Account for XSK RQ UMRs when calculating ICOSQ size
      net/mlx5e: Fix calculations related to max MPWQE size
      net/mlx5e: xsk: Discard unaligned XSK frames on striding RQ

Maxime Ripard (1):
      drm/vc4: kms: Use maximum FIFO load for the HVS clock rate

Maximilian Heyne (1):
      xen-blkback: Apply 'feature_persistent' parameter when connect

Maximilian Luz (1):
      HID: hid-input: add Surface Go battery quirk

Md Haris Iqbal (3):
      RDMA/rtrs-clt: Replace list_next_or_null_rr_rcu with an inline function
      RDMA/rxe: For invalidate compare according to set keys in mr
      block/rnbd-srv: Set keep_id to true after mutex_trylock

Mel Gorman (1):
      sched/core: Do not requeue task on CPU excluded from cpus_mask

Meng Tang (2):
      ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model
      ALSA: hda/realtek: Add quirk for another Asus K42JZ model

Miaohe Lin (6):
      lib/test_hmm: avoid accessing uninitialized pages
      mm/memremap: fix memunmap_pages() race with get_dev_pagemap()
      mm/migration: return errno when isolate_huge_page failed
      mm/migration: fix potential pte_unmap on an not mapped pte
      mm/mmap.c: fix missing call to vm_unacct_memory in mmap_region
      hugetlb_cgroup: fix wrong hugetlb cgroup numa stat

Miaoqian Lin (35):
      meson-mx-socinfo: Fix refcount leak in meson_mx_socinfo_init
      ARM: bcm: Fix refcount leak in bcm_kona_smc_init
      ARM: OMAP2+: Fix refcount leak in omapdss_init_of
      ARM: OMAP2+: Fix refcount leak in omap3xxx_prm_late_init
      cpufreq: zynq: Fix refcount leak in zynq_get_revision
      soc: qcom: ocmem: Fix refcount leak in of_get_ocmem
      soc: qcom: aoss: Fix refcount leak in qmp_cooling_devices_register
      drm/meson: Fix refcount leak in meson_encoder_hdmi_init
      drm/meson: encoder_cvbs: Fix refcount leak in meson_encoder_cvbs_init
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

Michael Ellerman (5):
      powerpc/powernv: Avoid crashing if rng is NULL
      powerpc/64s: Disable stack variable initialisation for prom_init
      selftests/powerpc: Skip energy_scale_info test on older firmware
      powerpc/pci: Fix PHB numbering when using opal-phbid
      powerpc/64e: Fix kexec build error

Michael Grzeschik (2):
      usb: dwc3: gadget: refactor dwc3_repare_one_trb
      usb: dwc3: gadget: fix high speed multiplier setting

Michael Walle (1):
      soc: fsl: guts: machine variable might be unset

Michal Koutný (1):
      io_uring: Don't require reinitable percpu_ref

Michal Suchanek (1):
      kexec, KEYS, s390: Make use of built-in and secondary keyring for signature verification

Mike Christie (3):
      scsi: iscsi: Allow iscsi_if_stop_conn() to be called from kernel
      scsi: iscsi: Add helper to remove a session from the kernel
      scsi: iscsi: Fix session removal on shutdown

Mike Leach (2):
      coresight: configfs: Fix unload of configurations on module exit
      coresight: syscfg: Update load and unload operations

Mike Manning (1):
      net: allow unbound socket for packets in VRF when tcp_l3mdev_accept set

Mike Snitzer (1):
      dm: return early from dm_pr_call() if DM device is suspended

Mikko Perttunen (1):
      arm64: tegra: Mark BPMP channels as no-memory-wc

Miklos Szeredi (4):
      fuse: limit nsec
      fuse: ioctl: translate ENOSYS
      fuse: write inode in fuse_release()
      fuse: fix deadlock between atomic O_TRUNC and page invalidation

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

Milan Landaverde (1):
      bpftool: Add missing link types

Ming Lei (1):
      blk-mq: don't create hctx debugfs dir until q->debugfs_dir is created

Ming Qian (17):
      media: amphion: return error if format is unsupported by vpu
      media: imx-jpeg: Correct some definition according specification
      media: imx-jpeg: Leave a blank space before the configuration data
      media: imx-jpeg: Refactor function mxc_jpeg_parse
      media: imx-jpeg: Identify and handle precision correctly
      media: imx-jpeg: Handle source change in a function
      media: imx-jpeg: Support dynamic resolution change
      media: imx-jpeg: Align upwards buffer size
      media: imx-jpeg: Implement drain using v4l2-mem2mem helpers
      media: imx-jpeg: Disable slot interrupt when frame done
      media: amphion: output firmware error message
      media: v4l2-mem2mem: prevent pollerr when last_buffer_dequeued is set
      media: amphion: release core lock before reset vpu core
      media: amphion: defer setting last_buffer_dequeued until resolution changes are processed
      media: amphion: decoder copy timestamp from output to capture
      media: amphion: sync buffer status with firmware during abort
      media: amphion: only insert the first sequence startcode for vc1l format

Mohamed Khalfella (1):
      PCI/AER: Iterate over error counters instead of error strings

Muneendra Kumar (1):
      scsi: nvme-fc: Add new routine nvme_fc_io_getuuid()

Mustafa Ismail (3):
      RDMA/irdma: Fix a window for use-after-free
      RDMA/irdma: Fix VLAN connection with wildcard address
      RDMA/irdma: Fix setting of QP context err_rq_idx_valid field

Mårten Lindahl (1):
      tpm: Add check for Failure mode for TPM2 modules

Namjae Jeon (5):
      ksmbd: fix memory leak in smb2_handle_negotiate
      ksmbd: fix use-after-free bug in smb2_tree_disconect
      ksmbd: fix heap-based overflow in set_ntacl_dacl()
      ksmbd: add smbd max io size parameter
      ksmbd: fix wrong smbd max read/write size check

Nandhini Srikandan (1):
      spi: dw: Fix IP-core versions macro

Naohiro Aota (15):
      btrfs: ensure pages are unlocked on cow_file_range() failure
      btrfs: fix error handling of fallback uncompress write
      block: add bdev_max_segments() helper
      btrfs: zoned: revive max_zone_append_bytes
      btrfs: replace BTRFS_MAX_EXTENT_SIZE with fs_info->max_extent_size
      btrfs: let can_allocate_chunk return error
      btrfs: zoned: finish least available block group on data bg allocation
      btrfs: zoned: disable metadata overcommit for zoned
      btrfs: zoned: introduce btrfs_zoned_bg_is_full
      btrfs: zoned: introduce space_info->active_total_bytes
      btrfs: zoned: activate metadata block group on flush_space
      btrfs: zoned: activate necessary block group
      btrfs: zoned: write out partially allocated region
      btrfs: zoned: wait until zone is finished when allocation didn't progress
      btrfs: convert count_max_extents() to use fs_info->max_extent_size

Narendra Hadke (1):
      serial: mvebu-uart: uart2 error bits clearing

Nathan Chancellor (1):
      usb: cdns3: Don't use priv_dev uninitialized in cdns3_gadget_ep_enable()

Naveen N. Rao (1):
      kexec_file: drop weak attribute from functions

Neal Liu (1):
      usb: gadget: f_mass_storage: Make CD-ROM emulation works with Windows OS

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

Niklas Söderlund (1):
      media: rcar-vin: Fix channel routing for Ebisu

Nikolay Borisov (1):
      btrfs: properly flag filesystem with BTRFS_FEATURE_INCOMPAT_BIG_METADATA

Nilesh Javali (1):
      scsi: Revert "scsi: qla2xxx: Fix disk failure to rediscover"

Nícolas F. R. A. Prado (2):
      arm64: dts: mt8192: Fix idle-states nodes naming scheme
      arm64: dts: mt8192: Fix idle-states entry-method

Oleksij Rempel (1):
      net: ag71xx: fix discards 'const' qualifier warning

Olga Kitaina (1):
      mtd: rawnand: arasan: Fix clock rate in NV-DDR

Pali Rohár (3):
      powerpc/fsl-pci: Fix Class Code of PCIe Root Port
      crypto: inside-secure - Add missing MODULE_DEVICE_TABLE for of
      powerpc/pci: Prefer PCI domain assignment via DT 'linux,pci-domain' and alias

Paolo Abeni (1):
      mptcp: refine memory scheduling

Paolo Bonzini (2):
      KVM: x86: do not report preemption if the steal time cache is stale
      KVM: x86: revalidate steal time cache if MSR value changes

Parikshit Pareek (1):
      soc: qcom: socinfo: Fix the id of SA8540P SoC

Patrice Chotard (1):
      mtd: spi-nor: fix spi_nor_spimem_setup_op() call in spi_nor_erase_{sector,chip}()

Paul Cercueil (1):
      drm/ingenic: Use the highest possible DMA burst size

Paul E. McKenney (2):
      rcutorture: Make kvm.sh allow more memory for --kasan runs
      torture: Adjust to again produce debugging information

Pavel Begunkov (1):
      io_uring: mem-account pbuf buckets

Pavel Skripkin (1):
      ath9k: fix use-after-free in ath9k_hif_usb_rx_cb

Peng Fan (4):
      clk: imx93: correct nic_media parent
      clk: imx: clk-fracn-gppll: fix mfd value
      clk: imx: clk-fracn-gppll: correct rdiv
      interconnect: imx: fix max_node_id

Peter Suti (1):
      staging: fbtft: core: set smem_len before fb_deferred_io_init call

Peter Ujfalusi (2):
      ASoC: SOF: make ctx_store and ctx_restore as optional
      ASoC: SOF: ipc3-topology: Prevent double freeing of ipc_control_data via load_bytes

Peter Wang (1):
      scsi: ufs: core: Correct ufshcd_shutdown() flow

Peter Zijlstra (2):
      locking/lockdep: Fix lockdep_init_map_*() confusion
      x86/extable: Fix ex_handler_msr() print condition

Phil Auld (1):
      drivers/base: fix userspace break from using bin_attributes for cpumap and cpulist

Phil Elwell (1):
      drm/vc4: hdmi: Disable audio if dmas property is present but empty

Philipp Jungkamp (1):
      ALSA: hda/realtek: Add quirk for Lenovo Yoga9 14IAP7

Pierre-Louis Bossart (2):
      soundwire: bus_type: fix remove and shutdown support
      soundwire: revisit driver bind/unbind and callbacks

Ping Cheng (2):
      HID: wacom: Only report rotation for art pen
      HID: wacom: Don't register pad_input for touch switch

Ping-Ke Shih (1):
      wifi: rtw89: 8852a: rfk: fix div 0 exception

Piotr Oniszczuk (1):
      media: hantro: Add support for Hantro G1 on RK356x

Przemyslaw Patynowski (2):
      iavf: Fix max_rate limiting
      iavf: Fix 'tc qdisc show' listing too many queues

Qian Cai (1):
      crypto: arm64/gcm - Select AEAD for GHASH_ARM64_CE

Qiao Ma (2):
      net: hinic: fix bug that ethtool get wrong stats
      net: hinic: avoid kernel hung in hinic_get_stats64()

Qu Wenruo (1):
      btrfs: reject log replay if there is unsupported RO compat flag

Quentin Perret (1):
      KVM: arm64: Don't return from void function

Quinn Tran (20):
      scsi: qla2xxx: edif: Reduce Initiator-Initiator thrashing
      scsi: qla2xxx: edif: bsg refactor
      scsi: qla2xxx: edif: Wait for app to ack on sess down
      scsi: qla2xxx: edif: Add bsg interface to read doorbell events
      scsi: qla2xxx: edif: Fix potential stuck session in sa update
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
      scsi: qla2xxx: edif: Reduce N2N thrashing at app_start time
      scsi: qla2xxx: Fix imbalance vha->vref_count
      scsi: qla2xxx: Turn off multi-queue for 8G adapters
      scsi: qla2xxx: Fix erroneous mailbox timeout after PCI error injection
      scsi: qla2xxx: Wind down adapter after PCIe error

Rafael J. Wysocki (2):
      thermal: sysfs: Fix cooling_device_stats_setup() error code path
      ACPI: CPPC: Do not prevent CPPC from working in the future

Ralph Siemsen (1):
      clk: renesas: r9a06g032: Fix UART clkgrp bitsel

Randy Dunlap (2):
      media: isl7998x: select V4L2_FWNODE to fix build error
      usb: gadget: udc: amd5536 depends on HAS_DMA

Rex-BC Chen (1):
      clk: mediatek: reset: Fix written reset bit offset

Rob Clark (2):
      drm/msm/mdp5: Fix global state lock backoff
      drm/msm/dpu: Fix for non-visible planes

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

Russell Currey (1):
      powerpc/kexec: Fix build failure from uninitialised variable

Russell King (Oracle) (1):
      ARM: findbit: fix overflowing offset

Rustam Subkhankulov (2):
      wifi: p54: add missing parentheses in p54_flush()
      video: fbdev: sis: fix typos in SiS_GetModeID()

Sam Protsenko (1):
      iommu/exynos: Handle failed IOMMU device registration properly

Samuel Holland (4):
      irqchip/mips-gic: Only register IPI domain when SMP is enabled
      genirq: GENERIC_IRQ_IPI depends on SMP
      arm64: dts: allwinner: a64: orangepi-win: Fix LED node name
      phy: rockchip-inno-usb2: Ignore OTG IRQs in host mode

Schspa Shi (1):
      Bluetooth: When HCI work queue is drained, only queue chained work

Sean Christopherson (23):
      KVM: nVMX: Snapshot pre-VM-Enter BNDCFGS for !nested_run_pending case
      KVM: nVMX: Snapshot pre-VM-Enter DEBUGCTL for !nested_run_pending case
      KVM: Drop unused @gpa param from gfn=>pfn cache's __release_gpc() helper
      KVM: Put the extra pfn reference when reusing a pfn in the gpc cache
      KVM: Fully serialize gfn=>pfn cache refresh via mutex
      KVM: Fix multiple races in gfn=>pfn cache refresh
      KVM: Do not incorporate page offset into gfn=>pfn cache user address
      KVM: x86: Split kvm_is_valid_cr4() and export only the non-vendor bits
      KVM: nVMX: Let userspace set nVMX MSR to any _host_ supported value
      KVM: nVMX: Account for KVM reserved CR4 bits in consistency checks
      KVM: nVMX: Inject #UD if VMXON is attempted with incompatible CR0/CR4
      KVM: x86: Mark TSS busy during LTR emulation _after_ all fault checks
      KVM: x86: Set error code to segment selector on LLDT/LTR non-canonical #GP
      KVM: x86: Tag kvm_mmu_x86_module_init() with __init
      KVM: SVM: Unwind "speculative" RIP advancement if INTn injection "fails"
      KVM: SVM: Stuff next_rip on emulated INT3 injection if NRIPS is supported
      KVM: x86/mmu: Drop RWX=0 SPTEs during ept_sync_page()
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

Shay Drory (1):
      net/mlx5: Fix driver use of uninitialized timeout

Shengjiu Wang (6):
      rpmsg: char: Add mutex protection for rpmsg_eptdev_open()
      ASoC: imx-card: Fix DSD/PDM mclk frequency
      ASoC: fsl_asrc: force cast the asrc_format type
      ASoC: fsl-asoc-card: force cast the asrc_format type
      ASoC: fsl_easrc: use snd_pcm_format_t type for sample_format
      ASoC: imx-card: use snd_pcm_format_t type for asrc_format

Sherry Sun (1):
      tty: serial: fsl_lpuart: correct the count of break characters

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

Song Liu (1):
      bpf, x86: fix freeing of not-finalized bpf_prog_pack

Srinivas Kandagatla (4):
      soundwire: qcom: Check device status before reading devid
      ASoC: codecs: msm8916-wcd-digital: move gains from SX_TLV to S8_TLV
      ASoC: codecs: wcd9335: move gains from SX_TLV to S8_TLV
      ASoC: codecs: wsa881x: handle timeouts in resume path

Stefan Roesch (1):
      btrfs: store chunk size in space-info struct

Stefan Roese (1):
      PCI/portdrv: Don't disable AER reporting in get_port_device_capability()

Steffen Maier (1):
      scsi: zfcp: Fix missing auto port scan and thus missing target ports

Stephan Gerhold (2):
      regulator: qcom_smd: Fix pm8916_pldo range
      ARM: dts: qcom: msm8974: Disable remoteprocs by default

Stephane Eranian (1):
      perf/core: Add perf_clear_branch_entry_bitfields() helper

Stephen Boyd (2):
      arm64: dts: qcom: sc7180: Remove ipa_fw_mem node on trogdor
      platform/chrome: cros_ec: Always expose last resume result

Steven Rostedt (Google) (5):
      ftrace/x86: Add back ftrace_expected assignment
      tracing/events: Add __vstring() and __assign_vstr() helper macros
      batman-adv: tracing: Use the new __vstring() helper
      tracing: Use a struct alignof to determine trace event field alignment
      tracing: Use a copy of the va_list for __assign_vstr()

Sudeep Holla (1):
      firmware: arm_scpi: Ensure scpi_info is not assigned if the probe fails

Sumanth Korikkar (1):
      s390/unwind: fix fgraph return address recovery

Sumit Garg (1):
      arm64: dts: qcom: qcs404: Fix incorrect USB2 PHYs assignment

Sungjong Seo (1):
      f2fs: allow compression for mmap files in compress_mode=user

Sunil V L (1):
      riscv: spinwait: Fix hartid variable type

Suzuki K Poulose (1):
      coresight: Clear the connection field properly

Tadeusz Struk (1):
      bpf: Fix KASAN use-after-free Read in compute_effective_progs

Takashi Iwai (1):
      ALSA: usb-audio: Add quirk for Behringer UMC202HD

Tales Lelo da Aparecida (1):
      drm/vkms: check plane_composer->map[0] before using it

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

Thinh Nguyen (1):
      usb: dwc3: core: Deprecate GCTL.CORESOFTRESET

Thomas Gleixner (1):
      netfilter: xtables: Bring SPDX identifier back

Thomas Zimmermann (1):
      drm/hyperv-drm: Include framebuffer and EDID headers

Tianchen Ding (2):
      sched: Fix the check of nr_running at queue wakelist
      sched: Remove the limitation of WF_ON_CPU on wakelist if wakee cpu is idle

Tianjia Zhang (1):
      KEYS: asymmetric: enforce SM2 signature use pkey algo

Tianyu Li (1):
      mm/mempolicy: fix get_nodes out of bound access

Tiezhu Yang (1):
      MIPS: Loongson64: Fix section mismatch warning

Tim Crawford (1):
      ALSA: hda/realtek: Add quirk for Clevo NV45PZ

Timur Tabi (1):
      drm/nouveau: fix another off-by-one in nvbios_addr

Tom Lendacky (1):
      crypto: ccp - During shutdown, check SEV data pointer before using

Tom Rix (2):
      ASoC: samsung: change gpiod_speaker_power and rx1950_audio from global to static variables
      drm/vc4: change vc4_dma_range_matches from a global to static

Tony Ambardar (1):
      bpf, x64: Add predicate for bpf2bpf with tailcalls support in JIT

Tony Battersby (1):
      scsi: sg: Allow waiting for commands to complete on removed device

Trond Myklebust (2):
      Revert "pNFS: nfs3_set_ds_client should set NFS_CS_NOPING"
      pNFS/flexfiles: Report RDMA connection errors to the server

Tyler Hicks (1):
      net/9p: Initialize the iounit field during fid creation

Uwe Kleine-König (8):
      hwmon: (sht15) Fix wrong assumptions in device remove callback
      pwm: sifive: Simplify offset calculation for PWMCMP registers
      pwm: sifive: Ensure the clk is enabled exactly once per running PWM
      pwm: sifive: Shut down hardware only after pwmchip_remove() completed
      pwm: lpc18xx: Fix period handling
      mtd: st_spi_fsm: Add a clk_disable_unprepare() in .probe()'s error path
      serial: 8250_fsl: Don't report FE, PE and OE twice
      mfd: t7l66xb: Drop platform disable callback

Vadim Pasternak (1):
      platform/mellanox: mlxreg-lc: Fix error flow and extend verbosity

Vaibhav Jain (1):
      of: check previous kernel's ima-kexec-buffer against memory bounds

Viacheslav Mitrofanov (1):
      dmaengine: sf-pdma: Add multithread support for a DMA channel

Vidya Sagar (2):
      PCI: tegra194: Fix Root Port interrupt handling
      PCI: tegra194: Fix link up retry sequence

Vincent Guittot (1):
      sched/fair: fix case with reduced capacity CPU

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

Vlad Buslov (1):
      net/mlx5e: Modify slow path rules to go to slow fdb

Vladimir Oltean (7):
      net: mscc: ocelot: delete ocelot_port :: xmit_template
      net: mscc: ocelot: minimize holes in struct ocelot_port
      net: dsa: felix: keep reference on entire tc-taprio config
      net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port
      net: sched: provide shim definitions for taprio_offload_{get,free}
      net: dsa: felix: build as module when tc-taprio is module
      net: dsa: felix: fix min gate len calculation for tc when its first gate is closed

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

Xianting Tian (4):
      RISC-V: kexec: Fixup use of smp_processor_id() in preemptible context
      RISC-V: Fixup get incorrect user mode PC for kernel mode regs
      RISC-V: Fixup schedule out issue in machine_crash_shutdown()
      RISC-V: Add modules to virtual kernel memory layout dump

Xiaoliang Yang (1):
      net: dsa: felix: update base time of time-aware shaper when adjusting PTP time

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

YC Hung (1):
      ASoC: SOF: mediatek: fix mt8195 StatvectorSel wrong setting

YN Chen (1):
      mt76: mt7921s: fix firmware download random fail

Yang Shi (1):
      mm: rmap: use the correct parameter name for DEFINE_PAGE_VMA_WALK

Yang Xu (1):
      fs: Add missing umask strip in vfs_tmpfile

Yang Yingliang (6):
      bus: hisi_lpc: fix missing platform_device_put() in hisi_lpc_acpi_probe()
      spi: Fix simplification of devm_spi_register_controller
      spi: tegra20-slink: fix UAF in tegra_slink_remove()
      media: camss: csid: fix wrong size passed to devm_kmalloc_array()
      xtensa: iss: fix handling error cases in iss_net_configure()
      serial: pic32: fix missing clk_disable_unprepare() on error in pic32_uart_startup()

Ye Bin (2):
      ext4: fix warning in ext4_iomap_begin as race between bmap and write
      f2fs: fix null-ptr-deref in f2fs_get_dnode_of_data

Yevgeny Kliteynik (1):
      net/mlx5: DR, Fix SMFS steering info dump format

YiFei Zhu (1):
      selftests/seccomp: Fix compile warning when CC=clang

Ying Hsu (1):
      Bluetooth: Add default wakeup callback for HCI UART driver

Yipeng Zou (1):
      riscv:uprobe fix SR_SPIE set/clear handling

Yishai Hadas (1):
      net/mlx5: Expose mlx5_sriov_blocking_notifier_register / unregister APIs

Yixun Lan (1):
      libbpf, riscv: Use a0 for RC register

Yong Zhi (1):
      ASoC: Intel: sof_rt5682: Perform quirk check first in card late probe

Yonglong Li (1):
      tcp: make retransmitted SKB fit into the send window

Yunfei Dong (2):
      media: mediatek: vcodec: Initialize decoder parameters after getting dec_capability
      media: mediatek: vcodec: Fix non subdev architecture open power fail

Yunhao Tian (1):
      drm/mipi-dbi: align max_chunk to 2 in spi_transfer

Yuntao Wang (1):
      selftests/bpf: Fix test_run logic in fexit_stress.c

Yushan Zhou (1):
      kernfs: fix potential NULL dereference in __kernfs_remove

Yuwen Chen (1):
      erofs: wake up all waiters after z_erofs_lzma_head ready

Zhang Rui (1):
      intel_idle: Add AlderLake support

Zhang Wensheng (1):
      driver core: fix potential deadlock in __driver_attach

Zhang Yi (1):
      jbd2: fix outstanding credits assert in jbd2_journal_commit_transaction()

Zheng Bin (1):
      drm/bridge: it6505: Add missing CRYPTO_HASH dependency

Zhengchao Shao (3):
      crypto: hisilicon/sec - don't sleep when in softirq
      crypto: hisilicon - Kunpeng916 crypto driver don't sleep when in softirq
      crypto: hisilicon/hpre - don't use GFP_KERNEL to alloc mem during softirq

Zhengping Jiang (2):
      Bluetooth: mgmt: Fix refresh cached connection info
      Bluetooth: hci_sync: Fix resuming scan after suspend resume

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

jianchunfu (1):
      rtla/utils: Use calloc and check the potential memory allocation failure

syed sabakareem (1):
      ASoC: amd: yc: Update DMI table entries

xinhui pan (1):
      drm/amdgpu: Remove one duplicated ef removal

