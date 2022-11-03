Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B52961807B
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 16:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbiKCPEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 11:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbiKCPDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 11:03:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC3B1A380;
        Thu,  3 Nov 2022 08:02:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 387DA61F20;
        Thu,  3 Nov 2022 15:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2720CC433D7;
        Thu,  3 Nov 2022 15:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667487766;
        bh=aWVShLjPV6881F3BAuQ6X3ts28foV5O9JMjvNKlIWP0=;
        h=From:To:Cc:Subject:Date:From;
        b=Wnz3BxnoQeb7i5R0w7gORT96NDEEbibapv9J8+1tuVQXBhL6ELimsG7jFdbFIm8NN
         Hp01FAIURNxUZwPXVigS3nqDXZhHQ+15f6M7eolj276ME6SqGkHR+gUhNflLOg6Li7
         0UCbOtWFaJZMTfQvQk0TUfTh1+QF+6UbDrXHsZnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.0.7
Date:   Fri,  4 Nov 2022 00:03:21 +0900
Message-Id: <16674878014746@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.0.7 kernel.

All users of the 6.0 kernel series must upgrade.

The updated 6.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/pinctrl/xlnx,zynqmp-pinctrl.yaml                    |    4 
 Makefile                                                                              |    2 
 arch/arc/include/asm/io.h                                                             |    2 
 arch/arc/include/asm/pgtable-levels.h                                                 |    2 
 arch/arc/mm/ioremap.c                                                                 |    2 
 arch/arm64/include/asm/cputype.h                                                      |    4 
 arch/arm64/kernel/proton-pack.c                                                       |    6 
 arch/powerpc/kernel/interrupt_64.S                                                    |   13 
 arch/riscv/Kconfig                                                                    |   17 
 arch/riscv/Makefile                                                                   |    6 
 arch/riscv/include/asm/cacheflush.h                                                   |    8 
 arch/riscv/include/asm/jump_label.h                                                   |    8 
 arch/riscv/include/asm/kvm_vcpu_timer.h                                               |    1 
 arch/riscv/include/asm/vdso/processor.h                                               |    2 
 arch/riscv/include/uapi/asm/kvm.h                                                     |    1 
 arch/riscv/kvm/vcpu.c                                                                 |   11 
 arch/riscv/kvm/vcpu_timer.c                                                           |   17 
 arch/riscv/mm/cacheflush.c                                                            |   38 
 arch/riscv/mm/dma-noncoherent.c                                                       |   39 
 arch/riscv/mm/kasan_init.c                                                            |    7 
 arch/s390/boot/vmlinux.lds.S                                                          |   13 
 arch/s390/include/asm/futex.h                                                         |    3 
 arch/s390/lib/uaccess.c                                                               |    6 
 arch/s390/pci/pci_mmio.c                                                              |    8 
 arch/x86/crypto/polyval-clmulni_glue.c                                                |   19 
 arch/x86/events/intel/lbr.c                                                           |    2 
 arch/x86/kernel/fpu/init.c                                                            |    8 
 arch/x86/kernel/fpu/xstate.c                                                          |   42 
 arch/x86/kernel/unwind_orc.c                                                          |    2 
 drivers/acpi/acpi_pcc.c                                                               |    2 
 drivers/base/power/domain.c                                                           |    4 
 drivers/char/random.c                                                                 |    4 
 drivers/counter/104-quad-8.c                                                          |   64 
 drivers/counter/microchip-tcb-capture.c                                               |   18 
 drivers/cpufreq/intel_pstate.c                                                        |  133 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                                      |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c                                               |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                                            |   16 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                                               |   20 
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c                                               |   28 
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c                                                 |  106 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c                               |   50 
 drivers/gpu/drm/bridge/parade-ps8640.c                                                |   25 
 drivers/gpu/drm/i915/display/intel_dp.c                                               |    2 
 drivers/gpu/drm/i915/gt/intel_workarounds.c                                           |    4 
 drivers/gpu/drm/i915/intel_runtime_pm.c                                               |   11 
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c                                           |    7 
 drivers/gpu/drm/msm/adreno/adreno_gpu.c                                               |    7 
 drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c                                   |    5 
 drivers/gpu/drm/msm/dp/dp_ctrl.c                                                      |   13 
 drivers/gpu/drm/msm/dp/dp_display.c                                                   |   23 
 drivers/gpu/drm/msm/dp/dp_drm.c                                                       |   34 
 drivers/gpu/drm/msm/dp/dp_parser.c                                                    |    6 
 drivers/gpu/drm/msm/dp/dp_parser.h                                                    |    5 
 drivers/gpu/drm/msm/dsi/dsi.c                                                         |    6 
 drivers/gpu/drm/msm/hdmi/hdmi.c                                                       |    7 
 drivers/gpu/drm/msm/msm_drv.c                                                         |    1 
 drivers/hwtracing/coresight/coresight-cti-core.c                                      |    5 
 drivers/iio/accel/adxl367.c                                                           |   23 
 drivers/iio/accel/adxl372.c                                                           |   23 
 drivers/iio/light/tsl2583.c                                                           |    2 
 drivers/iio/temperature/ltc2983.c                                                     |   13 
 drivers/media/i2c/ar0521.c                                                            |    8 
 drivers/media/i2c/ov8865.c                                                            |   10 
 drivers/media/platform/amphion/vpu_v4l2.c                                             |   11 
 drivers/media/platform/sunxi/sun4i-csi/Kconfig                                        |    2 
 drivers/media/platform/sunxi/sun6i-csi/Kconfig                                        |    2 
 drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig                                  |    4 
 drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c                        |   20 
 drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/Kconfig                             |    2 
 drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c              |   23 
 drivers/media/platform/sunxi/sun8i-di/Kconfig                                         |    2 
 drivers/media/platform/sunxi/sun8i-rotate/Kconfig                                     |    2 
 drivers/media/test-drivers/vivid/vivid-core.c                                         |   38 
 drivers/media/test-drivers/vivid/vivid-core.h                                         |    2 
 drivers/media/test-drivers/vivid/vivid-vid-cap.c                                      |   27 
 drivers/media/v4l2-core/v4l2-dv-timings.c                                             |   14 
 drivers/mmc/core/block.c                                                              |   44 
 drivers/mmc/core/queue.c                                                              |    8 
 drivers/mmc/core/sdio_bus.c                                                           |    3 
 drivers/mmc/host/Kconfig                                                              |    3 
 drivers/mmc/host/sdhci-esdhc-imx.c                                                    |   14 
 drivers/mmc/host/sdhci-pci-core.c                                                     |   14 
 drivers/mtd/mtdcore.c                                                                 |    2 
 drivers/mtd/nand/raw/intel-nand-controller.c                                          |   35 
 drivers/mtd/nand/raw/marvell_nand.c                                                   |    2 
 drivers/mtd/nand/raw/tegra_nand.c                                                     |    4 
 drivers/mtd/parsers/bcm47xxpart.c                                                     |    4 
 drivers/mtd/spi-nor/core.c                                                            |    4 
 drivers/net/can/mscan/mpc5xxx_can.c                                                   |    8 
 drivers/net/can/rcar/rcar_canfd.c                                                     |   24 
 drivers/net/can/spi/mcp251x.c                                                         |    5 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c                                     |    4 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c                                      |    4 
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c                                              |    5 
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c                                           |   19 
 drivers/net/ethernet/amd/xgbe/xgbe.h                                                  |    1 
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c                                    |   96 
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h                                       |    2 
 drivers/net/ethernet/broadcom/bcm4908_enet.c                                          |   12 
 drivers/net/ethernet/broadcom/bcmsysport.c                                            |    3 
 drivers/net/ethernet/cadence/macb_main.c                                              |    1 
 drivers/net/ethernet/freescale/enetc/enetc.c                                          |    5 
 drivers/net/ethernet/freescale/fec_main.c                                             |   46 
 drivers/net/ethernet/huawei/hinic/hinic_debugfs.c                                     |   18 
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c                                     |    2 
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c                                      |    2 
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c                                       |    1 
 drivers/net/ethernet/ibm/ehea/ehea_main.c                                             |    1 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                                        |  100 
 drivers/net/ethernet/intel/i40e/i40e_type.h                                           |    4 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c                                    |   43 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h                                    |    1 
 drivers/net/ethernet/lantiq_etop.c                                                    |    1 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                                         |   10 
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h                                      |    9 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h                                  |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h                                     |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c                              |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                                       |   74 
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c                                       |    6 
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c                                    |   17 
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c                                     |    7 
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c                                    |    6 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                                        |    4 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c                            |    3 
 drivers/net/ethernet/micrel/ksz884x.c                                                 |    2 
 drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c                              |   10 
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c                                 |   24 
 drivers/net/ethernet/socionext/netsec.c                                               |    2 
 drivers/net/ethernet/socionext/sni_ave.c                                              |    6 
 drivers/net/netdevsim/bus.c                                                           |    9 
 drivers/net/netdevsim/dev.c                                                           |   31 
 drivers/nfc/virtual_ncidev.c                                                          |    3 
 drivers/pinctrl/pinctrl-ingenic.c                                                     |    4 
 drivers/pinctrl/pinctrl-ocelot.c                                                      |   17 
 drivers/pinctrl/pinctrl-zynqmp.c                                                      |    9 
 drivers/pinctrl/qcom/pinctrl-msm.c                                                    |   21 
 drivers/platform/x86/amd/pmc.c                                                        |   12 
 drivers/s390/cio/css.c                                                                |    8 
 drivers/scsi/qla2xxx/qla_attr.c                                                       |   28 
 drivers/spi/spi-aspeed-smc.c                                                          |    2 
 drivers/spi/spi-qup.c                                                                 |    2 
 drivers/staging/media/atomisp/pci/sh_css_params.c                                     |    4 
 drivers/staging/media/sunxi/cedrus/Kconfig                                            |    1 
 drivers/usb/core/quirks.c                                                             |    9 
 drivers/usb/dwc3/core.c                                                               |   49 
 drivers/usb/dwc3/drd.c                                                                |   50 
 drivers/usb/dwc3/dwc3-st.c                                                            |    2 
 drivers/usb/dwc3/gadget.c                                                             |   21 
 drivers/usb/gadget/function/uvc_queue.c                                               |    8 
 drivers/usb/gadget/function/uvc_video.c                                               |   25 
 drivers/usb/gadget/udc/aspeed-vhub/dev.c                                              |    1 
 drivers/usb/gadget/udc/bdc/bdc_udc.c                                                  |    1 
 drivers/usb/host/xhci-mem.c                                                           |   20 
 drivers/usb/host/xhci-pci.c                                                           |   44 
 drivers/usb/host/xhci.c                                                               |   10 
 drivers/usb/host/xhci.h                                                               |    1 
 drivers/usb/typec/ucsi/ucsi.c                                                         |   42 
 drivers/usb/typec/ucsi/ucsi_acpi.c                                                    |   10 
 drivers/video/aperture.c                                                              |    5 
 drivers/video/fbdev/smscufx.c                                                         |   55 
 drivers/video/fbdev/stifb.c                                                           |    3 
 fs/binfmt_elf.c                                                                       |    3 
 fs/erofs/zdata.c                                                                      |    6 
 fs/erofs/zmap.c                                                                       |   17 
 fs/exec.c                                                                             |    4 
 fs/kernfs/dir.c                                                                       |    5 
 fs/squashfs/file.c                                                                    |   23 
 fs/squashfs/page_actor.c                                                              |    3 
 fs/squashfs/page_actor.h                                                              |    6 
 include/linux/mlx5/driver.h                                                           |    2 
 include/linux/perf_event.h                                                            |   19 
 include/linux/userfaultfd_k.h                                                         |    6 
 include/media/v4l2-common.h                                                           |    3 
 include/net/sock.h                                                                    |    2 
 include/sound/control.h                                                               |    1 
 include/sound/soc-acpi-intel-match.h                                                  |    2 
 include/uapi/linux/videodev2.h                                                        |    3 
 kernel/bpf/btf.c                                                                      |    5 
 kernel/events/core.c                                                                  |  151 +
 kernel/events/ring_buffer.c                                                           |    2 
 kernel/power/hibernate.c                                                              |    2 
 kernel/rcu/tree.c                                                                     |   10 
 kernel/sched/sched.h                                                                  |   18 
 mm/huge_memory.c                                                                      |   11 
 mm/kmemleak.c                                                                         |   61 
 mm/madvise.c                                                                          |   12 
 mm/migrate.c                                                                          |    7 
 mm/page_alloc.c                                                                       |    1 
 net/can/j1939/transport.c                                                             |    4 
 net/core/net_namespace.c                                                              |    7 
 net/core/skbuff.c                                                                     |    2 
 net/ethtool/eeprom.c                                                                  |    2 
 net/ieee802154/socket.c                                                               |    4 
 net/ipv4/nexthop.c                                                                    |    2 
 net/ipv4/tcp_input.c                                                                  |    3 
 net/ipv4/tcp_ipv4.c                                                                   |    4 
 net/ipv6/ip6_gre.c                                                                    |   12 
 net/ipv6/ip6_tunnel.c                                                                 |   11 
 net/ipv6/ipv6_sockglue.c                                                              |    7 
 net/ipv6/sit.c                                                                        |    8 
 net/kcm/kcmsock.c                                                                     |   25 
 net/mac802154/rx.c                                                                    |    5 
 net/mptcp/protocol.c                                                                  |    3 
 net/mptcp/protocol.h                                                                  |    1 
 net/mptcp/subflow.c                                                                   |    7 
 net/openvswitch/datapath.c                                                            |    3 
 net/tipc/topsrv.c                                                                     |   16 
 sound/aoa/soundbus/i2sbus/core.c                                                      |    7 
 sound/core/control.c                                                                  |   23 
 sound/pci/ac97/ac97_codec.c                                                           |   33 
 sound/pci/au88x0/au88x0.h                                                             |    6 
 sound/pci/au88x0/au88x0_core.c                                                        |    2 
 sound/pci/ca0106/ca0106_mixer.c                                                       |    2 
 sound/pci/emu10k1/emumixer.c                                                          |    2 
 sound/pci/hda/patch_realtek.c                                                         |    5 
 sound/pci/rme9652/hdsp.c                                                              |   26 
 sound/pci/rme9652/rme9652.c                                                           |   22 
 sound/soc/codecs/Kconfig                                                              |    1 
 sound/soc/codecs/tlv320adc3xxx.c                                                      |    2 
 sound/soc/intel/common/Makefile                                                       |    2 
 sound/soc/intel/common/soc-acpi-intel-rpl-match.c                                     |   51 
 sound/soc/qcom/lpass-cpu.c                                                            |   10 
 sound/soc/sof/intel/pci-mtl.c                                                         |    2 
 sound/soc/sof/intel/pci-tgl.c                                                         |   92 
 sound/synth/emux/emux.c                                                               |    7 
 sound/usb/implicit.c                                                                  |    2 
 sound/usb/mixer.c                                                                     |    2 
 tools/iio/iio_utils.c                                                                 |    4 
 tools/perf/pmu-events/arch/arm64/hisilicon/hip08/metrics.json                         |    6 
 tools/perf/pmu-events/arch/powerpc/power10/nest_metrics.json                          |   72 
 tools/perf/pmu-events/arch/s390/cf_z16/pai.json                                       | 1101 ----------
 tools/perf/pmu-events/arch/s390/cf_z16/pai_crypto.json                                | 1101 ++++++++++
 tools/perf/util/auxtrace.c                                                            |   10 
 tools/testing/selftests/drivers/net/bonding/Makefile                                  |    4 
 tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh                         |    2 
 tools/testing/selftests/drivers/net/bonding/net_forwarding_lib.sh                     |    1 
 tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh                     |    4 
 tools/testing/selftests/drivers/net/team/Makefile                                     |    4 
 tools/testing/selftests/drivers/net/team/dev_addr_lists.sh                            |    6 
 tools/testing/selftests/drivers/net/team/lag_lib.sh                                   |    1 
 tools/testing/selftests/drivers/net/team/net_forwarding_lib.sh                        |    1 
 tools/testing/selftests/ftrace/test.d/dynevent/test_duplicates.tc                     |    2 
 tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic-eprobe.tc |    2 
 tools/testing/selftests/kvm/memslot_modification_stress_test.c                        |    2 
 tools/testing/selftests/lib.mk                                                        |    4 
 247 files changed, 3360 insertions(+), 2158 deletions(-)

Aaron Conole (1):
      openvswitch: switch from WARN to pr_warn

Adrian Hunter (1):
      perf auxtrace: Fix address filter symbol name match for modules

Akhil P Oommen (1):
      drm/msm/a6xx: Replace kcalloc() with kvzalloc()

Alexander Stein (1):
      media: v4l2: Fix v4l2_i2c_subdev_set_name function documentation

Andrew Jones (2):
      RISC-V: KVM: Provide UAPI for Zicbom block size
      RISC-V: Fix compilation without RISCV_ISA_ZICBOM

Andrey Smirnov (1):
      usb: dwc3: Don't switch OTG -> peripheral if extcon is present

Ankit Nautiyal (1):
      drm/i915/dp: Reset frl trained flag before restarting FRL training

Anshuman Gupta (1):
      drm/i915/dgfx: Keep PCI autosuspend control 'on' by default on all dGPU

Anssi Hannula (1):
      can: kvaser_usb: Fix possible completions during init_completion

Anup Patel (1):
      RISC-V: KVM: Fix kvm_riscv_vcpu_timer_pending() for Sstc

Ariel Levkovich (1):
      net/mlx5e: TC, Reject forwarding from internal port to internal port

Arunpravin Paneer Selvam (2):
      drm/amdgpu: Fix VRAM BO swap issue
      drm/amdgpu: Fix for BO move issue

Aya Levin (1):
      net/mlx5e: Extend SKB room check to include PTP-SQ

Baolin Wang (1):
      mm: migrate: fix return value if all subpages of THPs are migrated successfully

Benjamin Poirier (2):
      selftests: net: Fix cross-tree inclusion of scripts
      selftests: net: Fix netdev name mismatch in cleanup

Bernd Edlinger (1):
      exec: Copy oldsighand->action under spin-lock

Biju Das (2):
      can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive
      can: rcar_canfd: fix channel specific IRQ handling for RZ/G2L

Brian Norris (1):
      mmc: sdhci_am654: 'select', not 'depends' REGMAP_MMIO

Chang S. Bae (4):
      x86/fpu: Configure init_fpstate attributes orderly
      x86/fpu: Fix the init_fpstate size check with the actual size
      x86/fpu: Exclude dynamic states from init_fpstate
      x86/fpu: Fix copy_xstate_to_uabi() to copy init states correctly

Chen Zhongjin (1):
      x86/unwind/orc: Fix unreliable stack dump with gcov

Chengming Gui (1):
      drm/amdgpu: fix pstate setting issue

Christian A. Ehrhardt (1):
      kernfs: fix use-after-free in __kernfs_remove

Christian Löhle (2):
      mmc: block: Remove error check of hw_reset on reset
      mmc: queue: Cancel recovery work on cleanup

Christophe JAILLET (3):
      media: ov8865: Fix an error handling path in ov8865_probe()
      media: sunxi: Fix some error handling path of sun8i_a83t_mipi_csi2_probe()
      media: sunxi: Fix some error handling path of sun6i_mipi_csi2_probe()

Conor Dooley (2):
      riscv: fix detection of toolchain Zicbom support
      riscv: fix detection of toolchain Zihintpause support

Cosmin Tanislav (1):
      iio: temperature: ltc2983: allocate iio channels once

Cédric Le Goater (1):
      spi: aspeed: Fix window offset of CE1

D Scott Phillips (1):
      arm64: Add AMPERE1 to the Spectre-BHB affected list

Dan Carpenter (1):
      media: atomisp: prevent integer overflow in sh_css_set_black_frame()

Dan Vacura (2):
      usb: gadget: uvc: fix dropped frame after missed isoc
      usb: gadget: uvc: fix sg handling in error case

Dongliang Mu (2):
      can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in error path
      can: mcp251x: mcp251x_can_probe(): add missing unregister_candev() in error path

Douglas Anderson (2):
      pinctrl: qcom: Avoid glitching lines when we first mux to output
      drm/bridge: ps8640: Add back the 50 ms mystery delay after HPD

Eric Dumazet (5):
      kcm: annotate data-races around kcm->rx_psock
      kcm: annotate data-races around kcm->rx_wait
      ipv6: ensure sane device mtu in tunnels
      net: do not sense pfmemalloc status in skb_append_pagefrags()
      kcm: do not sense pfmemalloc status in kcm_sendpage()

Florian Fainelli (1):
      net: bcmsysport: Indicate MAC is in charge of PHY PM

Gao Xiang (1):
      erofs: fix up inplace decompression success rate

Gavin Shan (1):
      KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test

Geert Uytterhoeven (1):
      ASoC: codecs: tlv320adc3xxx: Wrap adc3xxx_i2c_remove() in __exit_p()

Greg Kroah-Hartman (2):
      Revert "usb: gadget: uvc: limit isoc_sg to super speed gadgets"
      Linux 6.0.7

Hannu Hartikainen (1):
      USB: add RESET_RESUME quirk for NVIDIA Jetson devices in RCM

Hans Verkuil (5):
      media: vivid: s_fbuf: add more sanity checks
      media: vivid: dev->bitmap_cap wasn't freed in all cases
      media: v4l2-dv-timings: add sanity checks for blanking values
      media: videodev2.h: V4L2_DV_BT_BLANKING_HEIGHT should check 'interlaced'
      media: vivid: set num_in/outputs to 0 if not supported

Heikki Krogerus (2):
      usb: typec: ucsi: Check the connection on resume
      usb: typec: ucsi: acpi: Implement resume callback

Heiko Carstens (3):
      s390/uaccess: add missing EX_TABLE entries to __clear_user()
      s390/futex: add missing EX_TABLE entry to __futex_atomic_op()
      s390/pci: add missing EX_TABLE entries to __pcistg_mio_inuser()/__pcilg_mio_inuser()

Helge Deller (1):
      fbdev: stifb: Fall back to cfb_fillrect() on 32-bit HCRX cards

Horatiu Vultur (3):
      pinctrl: ocelot: Fix incorrect trigger of the interrupt.
      net: lan966x: Fix the rx drop counter
      net: lan966x: Stop replacing tx dcbs and dcbs_buf when changing MTU

Hugh Dickins (1):
      mm: prep_compound_tail() clear page->private

Hyong Youb Kim (1):
      net/mlx5e: Do not increment ESN when updating IPsec ESN state

Hyunwoo Kim (1):
      fbdev: smscufx: Fix several use-after-free bugs

Jakub Kicinski (1):
      net-memcg: avoid stalls when under memory pressure

James Clark (1):
      coresight: cti: Fix hang in cti_disable_hw()

Jason A. Donenfeld (2):
      ALSA: au88x0: use explicitly signed char
      ALSA: rme9652: use explicitly signed char

Jean-Philippe Brucker (1):
      random: use arch_get_random*_early() in random_init()

Jeff Vanhoof (1):
      usb: gadget: uvc: fix sg handling during video encode

Jens Glathe (1):
      usb: xhci: add XHCI_SPURIOUS_SUCCESS to ASM1042 despite being a V0.96 controller

Jesse Zhang (1):
      drm/amdkfd: correct the cache info for gfx1036

Jisheng Zhang (1):
      riscv: jump_label: mark arguments as const to satisfy asm constraints

Joaquín Ignacio Aramendía (1):
      drm/amd/display: Revert logic for plane modifiers

Joel Stanley (1):
      usb: gadget: aspeed: Fix probe regression

Johan Hovold (8):
      drm/msm: fix use-after-free on probe deferral
      drm/msm/dsi: fix memory corruption with too many bridges
      drm/msm/hdmi: fix memory corruption with too many bridges
      drm/msm/hdmi: fix IRQ lifetime
      drm/msm/dp: fix memory corruption with too many bridges
      drm/msm/dp: fix aux-bus EP lifetime
      drm/msm/dp: fix IRQ lifetime
      drm/msm/dp: fix bridge lifetime

José Roberto de Souza (1):
      drm/i915: Extend Wa_1607297627 to Alderlake-P

Juergen Borleis (1):
      net: fec: limit register access on i.MX6UL

Justin Chen (1):
      usb: bdc: change state when port disconnected

Kai Vehmanen (2):
      ASoC: Intel: common: add ACPI matching tables for Raptor Lake
      ASoC: SOF: Intel: pci-tgl: use RPL specific firmware definitions

Kajol Jain (1):
      perf vendor events power10: Fix hv-24x7 metric events

Kunihiko Hayashi (1):
      net: ethernet: ave: Fix MAC to be in charge of PHY PM

Kuniyuki Iwashima (1):
      tcp/udp: Fix memory leak in ipv6_renew_options().

Kuogee Hsieh (2):
      drm/msm/dp: add atomic_check to bridge ops
      drm/msm/dp: cleared DP_DOWNSPREAD_CTRL register before start link training

Li Zetao (1):
      fs/binfmt_elf: Fix memory leak in load_elf_binary()

Lijo Lazar (1):
      drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x

Lin Shengwang (1):
      sched/core: Fix comparison in sched_group_cookie_match()

Linus Walleij (1):
      mtd: parsers: bcm47xxpart: Fix halfblock reads

Lu Wei (1):
      tcp: fix a signed-integer-overflow bug in tcp_add_backlog()

Maciej S. Szmigiero (6):
      ALSA: control: add snd_ctl_rename()
      ALSA: hda/realtek: Use snd_ctl_rename() to rename a control
      ALSA: emu10k1: Use snd_ctl_rename() to rename a control
      ALSA: ac97: Use snd_ctl_rename() to rename a control
      ALSA: usb-audio: Use snd_ctl_rename() to rename a control
      ALSA: ca0106: Use snd_ctl_rename() to rename a control

Manank Patel (1):
      ACPI: PCC: Fix unintentional integer overflow

Manish Rangankar (1):
      scsi: qla2xxx: Use transport-defined speed mask for supported_speeds

Mario Limonciello (2):
      xhci-pci: Set runtime PM as default policy on all xHC 1.2 or later devices
      PM: hibernate: Allow hybrid sleep to work with s2idle

Martin Blumenstingl (2):
      mtd: rawnand: intel: Remove unused nand_pa member from ebu_nand_cs
      mtd: rawnand: intel: Use devm_platform_ioremap_resource_byname()

Mathias Nyman (2):
      xhci: Add quirk to reset host back to default state at shutdown
      xhci: Remove device endpoints from bandwidth list when freeing the device

Matthew Ma (1):
      mmc: core: Fix kernel panic when remove non-standard SDIO card

Matti Vaittinen (3):
      tools: iio: iio_utils: fix digit calculation
      iio: adxl372: Fix unsafe buffer attributes
      iio: adxl367: Fix unsafe buffer attributes

Maxim Levitsky (1):
      perf/x86/intel/lbr: Use setup_clear_cpu_cap() instead of clear_cpu_cap()

Mel Gorman (1):
      mm/huge_memory: do not clobber swp_entry_t during THP split

Michael Grzeschik (1):
      usb: gadget: uvc: limit isoc_sg to super speed gadgets

Michał Mirosław (1):
      fbdev/core: Avoid uninitialized read in aperture_remove_conflicting_pci_device()

Mika Westerberg (1):
      mtd: spi-nor: core: Ignore -ENOTSUPP in spi_nor_init()

Ming Qian (1):
      media: amphion: release m2m ctx when releasing vpu instance

Miquel Raynal (1):
      mac802154: Fix LQI recording

Moshe Shemesh (1):
      net/mlx5: Wait for firmware to enable CRS before pci_restore_state

Nathan Huckleberry (2):
      crypto: x86/polyval - Fix crashes when keys are not 16-byte aligned
      drm/msm: Fix return type of mdp4_lvds_connector_mode_valid

Neal Cardwell (1):
      tcp: fix indefinite deferral of RTO with SACK reneging

Nicholas Piggin (1):
      powerpc/64s/interrupt: Fix clear of PACA_IRQS_HARD_DIS when returning to soft-masked context

Nicolas Dichtel (1):
      nh: fix scope used to find saddr when adding non gw nh

Paolo Abeni (1):
      mptcp: set msk local address earlier

Patrice Chotard (1):
      usb: dwc3: st: Rely on child's compatible instead of name

Patrick Thompson (1):
      mmc: sdhci-pci-core: Disable ES for ASUS BIOS on Jasper Lake

Paul Blakey (1):
      net/mlx5e: Update restore chain id for slow path packets

Paul E. McKenney (1):
      rcu: Keep synchronize_rcu() from enabling irqs in early boot

Paul Kocialkowski (7):
      media: sun6i-mipi-csi2: Add a Kconfig dependency on RESET_CONTROLLER
      media: sun8i-a83t-mipi-csi2: Add a Kconfig dependency on RESET_CONTROLLER
      media: sun6i-csi: Add a Kconfig dependency on RESET_CONTROLLER
      media: sun4i-csi: Add a Kconfig dependency on RESET_CONTROLLER
      media: sun8i-di: Add a Kconfig dependency on RESET_CONTROLLER
      media: sun8i-rotate: Add a Kconfig dependency on RESET_CONTROLLER
      media: cedrus: Add a Kconfig dependency on RESET_CONTROLLER

Pavel Kozlov (1):
      ARC: mm: fix leakage of memory allocated for PTE

Peter Oberparleiter (2):
      s390/boot: add secure boot trailer
      s390/cio: fix out-of-bounds access on cio_ignore free

Peter Xu (1):
      mm/uffd: fix vma check on userfault for wp

Peter Zijlstra (1):
      perf: Fix missing SIGTRAPs

Phillip Lougher (3):
      squashfs: fix read regression introduced in readahead code
      squashfs: fix extending readahead beyond end of file
      squashfs: fix buffer release race condition in readahead code

Pierre-Louis Bossart (2):
      ASoC: SOF: Intel: pci-mtl: fix firmware name
      ASoC: SOF: Intel: pci-tgl: fix ADL-N descriptor

Prike Liang (2):
      drm/amdgpu: disallow gfxoff until GC IP blocks complete s2idle resume
      drm/amdkfd: update gfx1037 Lx cache setting

Qinglin Pan (1):
      riscv: mm: add missing memcpy in kasan_init

Rafael J. Wysocki (2):
      cpufreq: intel_pstate: Read all MSRs on the target CPU
      cpufreq: intel_pstate: hybrid: Use known scaling factor for P-cores

Rafael Mendonca (1):
      drm/amdkfd: Fix memory leak in kfd_mem_dmamap_userptr()

Rafał Miłecki (2):
      mtd: core: add missing of_node_get() in dynamic partitions code
      net: broadcom: bcm4908_enet: update TX stats after actual transmission

Raju Rangoju (3):
      amd-xgbe: Yellow carp devices do not need rrc
      amd-xgbe: fix the SFP compliance codes check for DAC cables
      amd-xgbe: add the bit rate quirk for Molex cables

Randy Dunlap (2):
      ASoC: codec: tlv320adc3xxx: add GPIOLIB dependency
      arc: iounmap() arg is volatile

Rik van Riel (1):
      mm,madvise,hugetlb: fix unexpected data loss with MADV_DONTNEED on hugetlbfs

Rob Clark (1):
      drm/msm/a6xx: Fix kvzalloc vs state_kcalloc usage

Robert Marko (1):
      spi: qup: support using GPIO as chip select line

Rongwei Liu (1):
      net/mlx5: DR, Fix matcher disconnect error flow

Roy Novich (1):
      net/mlx5: Update fw fatal reporter state on PCI handlers successful recover

Saeed Mahameed (1):
      net/mlx5: ASO, Create the ASO SQ with the correct timestamp format

Sai Krishna Potthuri (2):
      Revert "dt-bindings: pinctrl-zynqmp: Add output-enable configuration"
      Revert "pinctrl: pinctrl-zynqmp: Add support for output-enable and bias-high-impedance"

Sakari Ailus (2):
      media: ar0521: Fix return value check in writing initial registers
      media: sun6i-mipi-csi2: Depend on PHY_SUN6I_MIPI_DPHY

Sascha Hauer (1):
      mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on 8bit bus

Sergiu Moga (1):
      net: macb: Specify PHY PM management done by MAC

Shang XiaoJing (2):
      nfc: virtual_ncidev: Fix memory leak in virtual_nci_send()
      perf vendor events arm64: Fix incorrect Hisi hip08 L3 metrics

Shreeya Patel (1):
      iio: light: tsl2583: Fix module unloading

Shyam Sundar S K (1):
      platform/x86/amd: pmc: remove CONFIG_DEBUG_FS checks

Siarhei Volkau (1):
      pinctrl: Ingenic: JZ4755 bug fixes

Slawomir Laba (2):
      i40e: Fix ethtool rx-flow-hash setting for X722
      i40e: Fix flow-type by setting GL_HASH_INSET registers

Srinivasa Rao Mandadapu (2):
      ASoC: qcom: lpass-cpu: mark HDMI TX registers as volatile
      ASoC: qcom: lpass-cpu: Mark HDMI TX parity register as volatile

Stanislav Fomichev (1):
      bpf: prevent decl_tag from being referenced in func_proto

Stefan Binding (1):
      ALSA: hda/realtek: Add quirk for ASUS Zenbook using CS35L41

Steven Rostedt (Google) (1):
      ALSA: Use del_timer_sync() before freeing timer

Sudeep Holla (1):
      PM: domains: Fix handling of unavailable/disabled idle states

Suresh Devarakonda (1):
      net/mlx5: Fix crash during sync firmware reset

Sven Schnelle (1):
      selftests/ftrace: fix dynamic_events dependency check

Sylwester Dziedziuch (1):
      i40e: Fix VF hang when reset is triggered on another VF

Takashi Iwai (3):
      ALSA: usb-audio: Add quirks for M-Audio Fast Track C400/600
      ALSA: hda/realtek: Add another HP ZBook G9 model quirks
      ALSA: aoa: Fix I2S device accounting

Tariq Toukan (1):
      net/mlx5: Fix possible use-after-free in async command interface

Thinh Nguyen (3):
      usb: dwc3: gadget: Stop processing more requests on IMI
      usb: dwc3: gadget: Don't set IMI for no_interrupt
      usb: dwc3: gadget: Don't delay End Transfer on delayed_status

Thomas Richter (1):
      perf list: Fix PMU name pai_crypto in perf list on s390

Tony O'Brien (1):
      mtd: rawnand: marvell: Use correct logic for nand-keep-config

Vincent Whitchurch (1):
      mmc: core: Fix WRITE_ZEROES CQE handling

Vladimir Oltean (1):
      net: enetc: survive memory pressure without crashing

Waiman Long (1):
      mm/kmemleak: prevent soft lockup in kmemleak_scan()'s object iteration loops

Wei Yongjun (1):
      net: ieee802154: fix error return code in dgram_bind()

Wesley Cheng (1):
      usb: dwc3: gadget: Force sending delayed status during soft disconnect

William Breathitt Gray (2):
      counter: microchip-tcb-capture: Handle Signal1 read and Synapse
      counter: 104-quad-8: Fix race getting function mode and direction

Xin Long (2):
      ethtool: eeprom: fix null-deref on genl_info in dump
      tipc: fix a null-ptr-deref in tipc_topsrv_accept

Yang Yingliang (8):
      can: j1939: transport: j1939_session_skb_drop_old(): spin_unlock_irqrestore() before kfree_skb()
      media: ar0521: fix error return code in ar0521_power_on()
      mtd: rawnand: intel: Add missing of_node_put() in ebu_nand_probe()
      ALSA: ac97: fix possible memory leak in snd_ac97_dev_register()
      net: netsec: fix error handling in netsec_register_mdio()
      net: ksz884x: fix missing pci_disable_device() on error in pcidev_init()
      ALSA: aoa: i2sbus: fix possible memory leak in i2sbus_add_dev()
      net: ehea: fix possible memory leak in ehea_register_port()

Yue Hu (1):
      erofs: fix illegal unmapped accesses in z_erofs_fill_inode_lazy()

Zhang Changzhong (1):
      net: lantiq_etop: don't free skb when returning NETDEV_TX_BUSY

Zhang Qilong (1):
      mtd: rawnand: tegra: Fix PM disable depth imbalance in probe

Zhengchao Shao (8):
      net: hinic: fix incorrect assignment issue in hinic_set_interrupt_cfg()
      net: hinic: fix memory leak when reading function table
      net: hinic: fix the issue of CMDQ memory leaks
      net: hinic: fix the issue of double release MBOX callback of VF
      net: fix UAF issue in nfqnl_nf_hook_drop() when ops_init() failed
      netdevsim: fix memory leak in nsim_bus_dev_new()
      netdevsim: fix memory leak in nsim_drv_probe() when nsim_dev_resources_register() failed
      netdevsim: remove dir in nsim_dev_debugfs_init() when creating ports dir failed

Íñigo Huguet (1):
      atlantic: fix deadlock at aq_nic_stop

