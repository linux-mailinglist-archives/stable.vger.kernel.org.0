Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AA14D201C
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 19:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349576AbiCHSXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 13:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349732AbiCHSX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 13:23:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03EE1119;
        Tue,  8 Mar 2022 10:22:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CF20B81C1E;
        Tue,  8 Mar 2022 18:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B00C340EB;
        Tue,  8 Mar 2022 18:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646763745;
        bh=7JVYGNKH9HPhiWVpaDJmjQLhFzHaPMUXJsh9z4VNkx0=;
        h=From:To:Cc:Subject:Date:From;
        b=DvbEpZSHLVwftAMHHJXW8atZWKSDWV1jCG6R0VsdQF/CMC9vOjXteWacJpFwvy/CK
         cW0bUtGQj0jY+57jD8Emz79wltUkz12eiYUsFJ+Qm+kyB+L2kIOi6lhspy9C5pJCM3
         LkGnRh+8gRK94FUVVgeskGm3yzeCIV4fKanMt0SA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.27
Date:   Tue,  8 Mar 2022 19:22:10 +0100
Message-Id: <16467637300120@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.27 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/mm/pagemap.rst                             |    2 
 Documentation/gpu/i915.rst                                           |   14 
 Documentation/trace/events.rst                                       |   19 
 MAINTAINERS                                                          |    2 
 Makefile                                                             |    2 
 arch/arm/boot/dts/omap3-devkit8000-common.dtsi                       |   18 
 arch/arm/boot/dts/omap3-devkit8000.dts                               |   33 
 arch/arm/boot/dts/tegra124-nyan-big.dts                              |   15 
 arch/arm/boot/dts/tegra124-nyan-blaze.dts                            |   15 
 arch/arm/boot/dts/tegra124-venice2.dts                               |   14 
 arch/arm/kernel/kgdb.c                                               |   36 
 arch/arm/mm/mmu.c                                                    |    2 
 arch/arm64/boot/dts/arm/juno-base.dtsi                               |    3 
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi                         |   17 
 arch/arm64/kernel/module.c                                           |    4 
 arch/arm64/kernel/stacktrace.c                                       |    3 
 arch/arm64/kvm/vgic/vgic-mmio.c                                      |    2 
 arch/mips/include/asm/local.h                                        |    9 
 arch/mips/kernel/setup.c                                             |    2 
 arch/mips/ralink/mt7621.c                                            |   36 
 arch/riscv/mm/Makefile                                               |    3 
 arch/riscv/mm/init.c                                                 |    1 
 arch/riscv/mm/kasan_init.c                                           |    3 
 arch/s390/include/asm/extable.h                                      |    9 
 arch/s390/kernel/module.c                                            |    5 
 arch/s390/kvm/kvm-s390.c                                             |    2 
 arch/x86/hyperv/mmu.c                                                |   19 
 arch/x86/kernel/module.c                                             |    7 
 arch/x86/kvm/mmu/mmu.c                                               |    2 
 arch/x86/kvm/vmx/posted_intr.c                                       |    9 
 arch/x86/kvm/x86.c                                                   |   11 
 block/blk-map.c                                                      |    2 
 drivers/ata/pata_hpt37x.c                                            |    4 
 drivers/auxdisplay/lcd2s.c                                           |   24 
 drivers/block/loop.c                                                 |    8 
 drivers/clocksource/timer-ti-dm-systimer.c                           |    3 
 drivers/dma-buf/heaps/cma_heap.c                                     |    6 
 drivers/dma/sh/shdma-base.c                                          |    4 
 drivers/firmware/arm_scmi/driver.c                                   |    2 
 drivers/firmware/efi/libstub/riscv-stub.c                            |   17 
 drivers/firmware/efi/vars.c                                          |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                              |  719 +++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c                             |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                               |   10 
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c                                |    3 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                    |   12 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c           |   16 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c                     |    4 
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c                    |    3 
 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c              |   96 +
 drivers/gpu/drm/amd/display/dc/dml/Makefile                          |    3 
 drivers/gpu/drm/amd/display/dc/dml/dsc/qp_tables.h                   |  704 +++++++++
 drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c                 |  291 ++++
 drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.h                 |   94 +
 drivers/gpu/drm/amd/display/dc/dsc/Makefile                          |   29 
 drivers/gpu/drm/amd/display/dc/dsc/qp_tables.h                       |  704 ---------
 drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c                         |  259 ---
 drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h                         |   50 
 drivers/gpu/drm/amd/display/dc/dsc/rc_calc_dpi.c                     |    1 
 drivers/gpu/drm/amd/display/include/logger_types.h                   |    3 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c              |   26 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.h              |    8 
 drivers/gpu/drm/bridge/ti-sn65dsi86.c                                |    5 
 drivers/gpu/drm/drm_atomic_helper.c                                  |    2 
 drivers/gpu/drm/i915/Makefile                                        |    2 
 drivers/gpu/drm/i915/display/intel_ddi.c                             |    1 
 drivers/gpu/drm/i915/display/intel_display.c                         |  220 ---
 drivers/gpu/drm/i915/display/intel_display_debugfs.c                 |    1 
 drivers/gpu/drm/i915/display/intel_dp.c                              |  467 ------
 drivers/gpu/drm/i915/display/intel_dp.h                              |   11 
 drivers/gpu/drm/i915/display/intel_dpt.c                             |  229 +++
 drivers/gpu/drm/i915/display/intel_dpt.h                             |   19 
 drivers/gpu/drm/i915/display/intel_drrs.c                            |  485 ++++++
 drivers/gpu/drm/i915/display/intel_drrs.h                            |   32 
 drivers/gpu/drm/i915/display/intel_frontbuffer.c                     |    1 
 drivers/gpu/drm/i915/gem/i915_gem_pages.c                            |    1 
 drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c                          |    2 
 drivers/gpu/drm/i915/intel_pch.c                                     |    2 
 drivers/gpu/drm/i915/intel_pch.h                                     |    2 
 drivers/gpu/drm/mediatek/mtk_dsi.c                                   |    5 
 drivers/gpu/drm/mxsfb/mxsfb_kms.c                                    |   12 
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c                               |    4 
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c                               |   69 
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h                               |    2 
 drivers/hid/hid-debug.c                                              |    5 
 drivers/hid/hid-input.c                                              |    3 
 drivers/i2c/busses/Kconfig                                           |    6 
 drivers/i2c/busses/i2c-bcm2835.c                                     |   11 
 drivers/i3c/master.c                                                 |    3 
 drivers/i3c/master/dw-i3c-master.c                                   |    4 
 drivers/i3c/master/mipi-i3c-hci/dat_v1.c                             |    4 
 drivers/input/input.c                                                |    6 
 drivers/input/keyboard/Kconfig                                       |    2 
 drivers/input/mouse/elan_i2c_core.c                                  |   64 
 drivers/input/touchscreen/ti_am335x_tsc.c                            |    8 
 drivers/iommu/amd/amd_iommu.h                                        |    1 
 drivers/iommu/amd/amd_iommu_types.h                                  |    1 
 drivers/iommu/amd/init.c                                             |   10 
 drivers/iommu/amd/io_pgtable.c                                       |   12 
 drivers/iommu/amd/iommu.c                                            |   10 
 drivers/iommu/intel/iommu.c                                          |    2 
 drivers/iommu/tegra-smmu.c                                           |    4 
 drivers/mtd/spi-nor/xilinx.c                                         |    3 
 drivers/net/arcnet/com20020-pci.c                                    |    3 
 drivers/net/can/usb/etas_es58x/es58x_core.c                          |    9 
 drivers/net/can/usb/etas_es58x/es58x_core.h                          |    8 
 drivers/net/can/usb/gs_usb.c                                         |   10 
 drivers/net/dsa/ocelot/seville_vsc9953.c                             |    6 
 drivers/net/ethernet/amd/Kconfig                                     |    2 
 drivers/net/ethernet/arc/Kconfig                                     |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                            |    7 
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                            |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                    |    2 
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c                           |    2 
 drivers/net/ethernet/ezchip/Kconfig                                  |    2 
 drivers/net/ethernet/google/gve/gve_rx.c                             |    1 
 drivers/net/ethernet/ibm/ibmvnic.c                                   |   54 
 drivers/net/ethernet/intel/e1000e/hw.h                               |    1 
 drivers/net/ethernet/intel/e1000e/ich8lan.c                          |    8 
 drivers/net/ethernet/intel/e1000e/ich8lan.h                          |    1 
 drivers/net/ethernet/intel/e1000e/netdev.c                           |   26 
 drivers/net/ethernet/intel/iavf/iavf.h                               |   54 
 drivers/net/ethernet/intel/iavf/iavf_main.c                          |  357 ++--
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c                      |   16 
 drivers/net/ethernet/intel/igc/igc_phy.c                             |    4 
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c                         |    6 
 drivers/net/ethernet/litex/Kconfig                                   |    2 
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c                      |   12 
 drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h              |    8 
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h                     |   61 
 drivers/net/ethernet/marvell/octeontx2/af/npc.h                      |    9 
 drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h              |  595 ++------
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c                      |   56 
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h                      |    7 
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h                      |    7 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c                  |   23 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c                  |   30 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c                  |   96 +
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h        |   29 
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c                      |   20 
 drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c                  |   20 
 drivers/net/ethernet/mscc/Kconfig                                    |    2 
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c                      |    6 
 drivers/net/ethernet/stmicro/stmmac/stmmac.h                         |    4 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                    |  170 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c                     |    4 
 drivers/net/hamradio/mkiss.c                                         |    2 
 drivers/net/ipa/Kconfig                                              |    1 
 drivers/net/usb/cdc_mbim.c                                           |    5 
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c                     |   11 
 drivers/net/wireless/mac80211_hwsim.c                                |   13 
 drivers/net/xen-netfront.c                                           |   39 
 drivers/ntb/hw/intel/ntb_hw_gen4.c                                   |   17 
 drivers/ntb/hw/intel/ntb_hw_gen4.h                                   |   16 
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c                               |   16 
 drivers/of/Kconfig                                                   |    4 
 drivers/of/Makefile                                                  |    1 
 drivers/of/of_net.c                                                  |  145 --
 drivers/pci/controller/dwc/pcie-designware.c                         |    7 
 drivers/pci/controller/pci-aardvark.c                                |    6 
 drivers/pci/controller/pci-mvebu.c                                   |  251 ++-
 drivers/pci/controller/pcie-mediatek-gen3.c                          |    8 
 drivers/pci/controller/pcie-rcar-host.c                              |   10 
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                                |    9 
 drivers/regulator/core.c                                             |   13 
 drivers/soc/fsl/guts.c                                               |   14 
 drivers/soc/fsl/qe/qe_io.c                                           |    2 
 drivers/thermal/thermal_netlink.c                                    |    5 
 drivers/tty/serial/stm32-usart.c                                     |   12 
 drivers/usb/gadget/legacy/inode.c                                    |   10 
 fs/btrfs/ctree.h                                                     |   10 
 fs/btrfs/disk-io.c                                                   |   10 
 fs/btrfs/extent-tree.c                                               |   10 
 fs/btrfs/extent_io.c                                                 |   16 
 fs/btrfs/inode.c                                                     |  142 +
 fs/btrfs/qgroup.c                                                    |    9 
 fs/btrfs/relocation.c                                                |   13 
 fs/btrfs/root-tree.c                                                 |   15 
 fs/btrfs/transaction.c                                               |   77 +
 fs/btrfs/transaction.h                                               |    1 
 fs/btrfs/tree-log.c                                                  |   61 
 fs/cifs/cifs_debug.c                                                 |    2 
 fs/cifs/cifsacl.c                                                    |    9 
 fs/cifs/cifsfs.c                                                     |    1 
 fs/cifs/cifsglob.h                                                   |    5 
 fs/cifs/connect.c                                                    |   25 
 fs/cifs/misc.c                                                       |    1 
 fs/cifs/sess.c                                                       |   41 
 fs/cifs/transport.c                                                  |    3 
 fs/exfat/file.c                                                      |   18 
 fs/exfat/inode.c                                                     |   13 
 fs/exfat/namei.c                                                     |    6 
 fs/exfat/super.c                                                     |   10 
 fs/ext4/ext4.h                                                       |   15 
 fs/ext4/extents.c                                                    |    6 
 fs/ext4/fast_commit.c                                                |  218 +--
 fs/ext4/fast_commit.h                                                |   27 
 fs/ext4/inode.c                                                      |    4 
 fs/ext4/ioctl.c                                                      |    5 
 fs/ext4/namei.c                                                      |    4 
 fs/ext4/super.c                                                      |    3 
 fs/ext4/xattr.c                                                      |    6 
 fs/hugetlbfs/inode.c                                                 |    7 
 fs/io_uring.c                                                        |    3 
 fs/jbd2/commit.c                                                     |    2 
 fs/jbd2/journal.c                                                    |    2 
 fs/nfsd/nfs3proc.c                                                   |    9 
 fs/nfsd/nfs3xdr.c                                                    |   56 
 fs/nfsd/nfs4proc.c                                                   |    3 
 fs/nfsd/nfs4state.c                                                  |    6 
 fs/nfsd/nfsproc.c                                                    |    8 
 fs/nfsd/nfsxdr.c                                                     |    9 
 fs/nfsd/vfs.c                                                        |    4 
 fs/nfsd/xdr.h                                                        |    2 
 fs/nfsd/xdr3.h                                                       |    2 
 fs/proc/task_mmu.c                                                   |    3 
 include/linux/ethtool.h                                              |    2 
 include/linux/filter.h                                               |   10 
 include/linux/jbd2.h                                                 |    2 
 include/linux/kasan.h                                                |    4 
 include/linux/of_net.h                                               |    2 
 include/linux/sched/task.h                                           |    4 
 include/linux/sunrpc/svc.h                                           |    3 
 include/linux/vmalloc.h                                              |    7 
 include/net/ndisc.h                                                  |    4 
 include/net/netfilter/nf_queue.h                                     |    2 
 include/net/xfrm.h                                                   |    1 
 include/trace/events/sunrpc.h                                        |   13 
 include/uapi/linux/input-event-codes.h                               |    4 
 include/uapi/linux/xfrm.h                                            |    6 
 kernel/bpf/syscall.c                                                 |   18 
 kernel/bpf/trampoline.c                                              |   11 
 kernel/fork.c                                                        |   13 
 kernel/sched/core.c                                                  |   23 
 kernel/signal.c                                                      |   20 
 kernel/trace/blktrace.c                                              |   26 
 kernel/trace/trace.c                                                 |    4 
 kernel/trace/trace_events_filter.c                                   |  107 +
 kernel/trace/trace_events_hist.c                                     |    6 
 kernel/trace/trace_events_synth.c                                    |   13 
 kernel/trace/trace_kprobe.c                                          |    2 
 kernel/trace/trace_probe.c                                           |    2 
 kernel/trace/trace_uprobe.c                                          |    5 
 kernel/user_namespace.c                                              |   14 
 mm/kasan/quarantine.c                                                |   11 
 mm/kasan/shadow.c                                                    |    9 
 mm/memfd.c                                                           |   40 
 mm/util.c                                                            |    4 
 mm/vmalloc.c                                                         |    3 
 net/batman-adv/hard-interface.c                                      |   29 
 net/core/Makefile                                                    |    1 
 net/core/net-sysfs.c                                                 |    2 
 net/core/of_net.c                                                    |  145 ++
 net/core/skbuff.c                                                    |    2 
 net/core/skmsg.c                                                     |    2 
 net/dcb/dcbnl.c                                                      |   44 
 net/ipv4/esp4.c                                                      |    2 
 net/ipv6/addrconf.c                                                  |    8 
 net/ipv6/esp6.c                                                      |    2 
 net/ipv6/ip6_output.c                                                |   11 
 net/ipv6/mcast.c                                                     |   32 
 net/mac80211/ieee80211_i.h                                           |    2 
 net/mac80211/mlme.c                                                  |   16 
 net/mac80211/rx.c                                                    |   14 
 net/mptcp/protocol.c                                                 |    7 
 net/netfilter/core.c                                                 |    5 
 net/netfilter/nf_queue.c                                             |   36 
 net/netfilter/nf_tables_api.c                                        |    4 
 net/netfilter/nfnetlink_queue.c                                      |   12 
 net/smc/af_smc.c                                                     |   10 
 net/smc/smc_core.c                                                   |    5 
 net/sunrpc/svc.c                                                     |   11 
 net/sunrpc/svc_xprt.c                                                |    2 
 net/tipc/crypto.c                                                    |    2 
 net/wireless/nl80211.c                                               |   12 
 net/xfrm/xfrm_device.c                                               |    6 
 net/xfrm/xfrm_interface.c                                            |    2 
 net/xfrm/xfrm_state.c                                                |   14 
 sound/soc/codecs/cs4265.c                                            |    3 
 sound/soc/codecs/rt5668.c                                            |   12 
 sound/soc/codecs/rt5682.c                                            |   12 
 sound/soc/soc-ops.c                                                  |    4 
 sound/x86/intel_hdmi_audio.c                                         |    2 
 tools/bpf/resolve_btfids/main.c                                      |    5 
 tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh |    2 
 tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh         |    3 
 tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc |    2 
 tools/testing/selftests/seccomp/Makefile                             |    2 
 tools/testing/selftests/vm/charge_reserved_hugetlb.sh                |   34 
 tools/testing/selftests/vm/hugetlb_reparenting_test.sh               |   21 
 tools/testing/selftests/vm/write_hugetlb_memory.sh                   |    2 
 virt/kvm/kvm_main.c                                                  |    5 
 292 files changed, 5826 insertions(+), 3549 deletions(-)

Adrian Huang (1):
      iommu/vt-d: Fix double list_add when enabling VMD in scalable mode

Agustin Gutierrez (1):
      drm/amd/display: Update watermark values for DCN301

Alex Deucher (2):
      drm/amdgpu: filter out radeon PCI device IDs
      drm/amdgpu: filter out radeon secondary ids as well

Alex Elder (1):
      net: ipa: add an interconnect dependency

Alexander Stein (1):
      drm: mxsfb: Fix NULL pointer dereference

Alexandre Ghiti (2):
      riscv: Fix config KASAN && SPARSEMEM && !SPARSE_VMEMMAP
      riscv: Fix config KASAN && DEBUG_VIRTUAL

Alyssa Ross (1):
      firmware: arm_scmi: Remove space in MODULE_ALIAS name

Amit Cohen (2):
      selftests: mlxsw: tc_police_scale: Make test more robust
      selftests: mlxsw: resource_scale: Fix return value

Andrey Konovalov (1):
      kasan: fix quarantine conflicting with init_on_free

Andrii Nakryiko (1):
      tools/resolve_btf_ids: Close ELF file on error

Andy Shevchenko (3):
      auxdisplay: lcd2s: Fix lcd2s_redefine_char() feature
      auxdisplay: lcd2s: Fix memory leak in ->remove()
      auxdisplay: lcd2s: Use proper API to free the instance of charlcd object

Anthoine Bourgeois (2):
      ARM: dts: switch timer config to common devkit8000 devicetree
      ARM: dts: Use 32KiHz oscillator on devkit8000

Antony Antony (1):
      xfrm: fix the if_id check in changelink

Arnd Bergmann (1):
      net: of: fix stub of_net helpers for CONFIG_NET=n

Basavaraj Natikar (3):
      HID: amd_sfh: Handle amd_sfh work buffer in PM ops
      HID: amd_sfh: Add functionality to clear interrupts
      HID: amd_sfh: Add interrupt handler to process interrupts

Beau Belgrave (1):
      tracing: Do not let synth_events block other dyn_event systems during create

Benjamin Beichler (1):
      mac80211_hwsim: report NOACK frames in tx_status

Brian Norris (1):
      arm64: dts: rockchip: Switch RK3399-Gru DP to SPDIF output

Cai Huoqing (1):
      net: ethernet: litex: Add the dependency on HAS_IOMEM

Casper Andersson (1):
      net: sparx5: Fix add vlan when invalid operation

Christophe JAILLET (3):
      i3c/master/mipi-i3c-hci: Fix a potentially infinite loop in 'hci_dat_v1_get_index()'
      soc: fsl: guts: Revert commit 3c0d64e867ed
      soc: fsl: guts: Add a missing memory allocation failure check

Christophe Vu-Brugier (2):
      exfat: reuse exfat_inode_info variable instead of calling EXFAT_I()
      exfat: fix i_blocks for files truncated over 4 GiB

Chuanhong Guo (1):
      MIPS: ralink: mt7621: do memory detection on KSEG1

Chuck Lever (6):
      NFSD: Have legacy NFSD WRITE decoders use xdr_stream_subsegment()
      NFSD: Fix zero-length NFSv3 WRITEs
      NFSD: Fix verifier returned in stable WRITEs
      Revert "nfsd: skip some unnecessary stats in the v4 case"
      SUNRPC: Fix sockaddr handling in the svc_xprt_create_error trace point
      SUNRPC: Fix sockaddr handling in svcsock_accept_class trace points

Colin Foster (1):
      net: dsa: ocelot: seville: utilize of_mdiobus_register

Corinna Vinschen (1):
      igc: igc_read_phy_reg_gpy: drop premature return

D. Wythe (3):
      net/smc: fix connection leak
      net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error generated by client
      net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server

Dan Carpenter (1):
      iavf: missing unlocks in iavf_watchdog_task()

Daniel Borkmann (1):
      mm: Consider __GFP_NOWARN flag for oversized kvmalloc() calls

Daniele Palmas (1):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit FN990

Dario Binacchi (2):
      Input: ti_am335x_tsc - set ADCREFM for X configuration
      Input: ti_am335x_tsc - fix STEPCONFIG setup for Z2

Dave Jiang (1):
      ntb: intel: fix port config status offset for SPR

David Gow (1):
      Input: samsung-keypad - properly state IOMEM dependency

Deren Wu (1):
      mac80211: fix EAPoL rekey fail in 802.3 rx path

Douglas Anderson (1):
      drm/bridge: ti-sn65dsi86: Properly undo autosuspend

Enric Balletbo i Serra (1):
      drm/mediatek: mtk_dsi: Reset the dsi0 hardware

Eric Anholt (1):
      i2c: bcm2835: Avoid clock stretching timeouts

Eric Dumazet (5):
      ipv6: fix skb drops in igmp6_event_query() and igmp6_event_report()
      bpf: Use u64_stats_t in struct bpf_prog_stats
      netfilter: fix use-after-free in __nf_register_net_hook()
      bpf, sockmap: Do not ignore orig_len parameter
      netfilter: nf_tables: prefer kfree_rcu(ptr, rcu) variant

Eric W. Biederman (2):
      signal: In get_signal test for signal_group_exit every time through the loop
      ucounts: Fix systemd LimitNPROC with private users regression

Evan Quan (1):
      drm/amd/pm: correct UMD pstate clocks for Dimgrey Cavefish and Beige Goby

Fabio Estevam (1):
      ASoC: cs4265: Fix the duplicated control name

Filipe Manana (4):
      btrfs: get rid of warning on transaction commit when using flushoncommit
      btrfs: fix ENOSPC failure when attempting direct IO write into NOCOW range
      btrfs: fix lost prealloc extents beyond eof after full fsync
      btrfs: add missing run of delayed items after unlink during log replay

Florian Westphal (3):
      netfilter: nf_queue: don't assume sk is full socket
      netfilter: nf_queue: fix possible use-after-free
      netfilter: nf_queue: handle socket prefetch

Geetha sowjanya (1):
      octeontx2-af: cn10k: Use appropriate register for LMAC enable

Greg Kroah-Hartman (1):
      Linux 5.15.27

Guchun Chen (1):
      drm/amdgpu: use spin_lock_irqsave to avoid deadlock by local interrupt

Guido Günther (1):
      drm: mxsfb: Set fallback bus format when the bridge doesn't provide one

Haimin Zhang (1):
      block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern

Hangyu Hua (3):
      tipc: fix a bit overflow in tipc_crypto_key_rcv()
      usb: gadget: don't release an existing dev->buf
      usb: gadget: clear related members when goto fail

Hans de Goede (2):
      Input: elan_i2c - move regulator_[en|dis]able() out of elan_[en|dis]able_power()
      Input: elan_i2c - fix regulator enable count imbalance after suspend/resume

Hao Xu (1):
      io_uring: fix no lock protection for ctx->cq_extra

Hariprasad Kelam (1):
      octeontx2-af: cn10k: RPM hardware timestamp configuration

Harman Kalra (1):
      octeontx2-af: Reset PTP config in FLR handler

Harshad Shirwadkar (2):
      ext4: drop ineligible txn start stop APIs
      ext4: simplify updating of fast commit stats

He Fengqing (1):
      bpf: Fix possible race in inc_misses_counter

Heiko Carstens (1):
      s390/extable: fix exception table sorting

Hou Wenlong (1):
      KVM: x86: Exit to userspace if emulation prepared a completion callback

Huang Pei (2):
      MIPS: fix local_{add,sub}_return on MIPS64
      hamradio: fix macro redefine warning

Hugh Dickins (1):
      memfd: fix F_SEAL_WRITE after shmem huge page allocated

Ilya Lipnitskiy (1):
      MIPS: ralink: mt7621: use bitwise NOT instead of logical

J. Bruce Fields (1):
      nfsd: fix crash on COPY_NOTIFY with special stateid

JaeMan Park (1):
      mac80211_hwsim: initialize ieee80211_tx_info at hw_scan_work

Jakub Kicinski (1):
      of: net: move of_net under net/

Jamie Iles (1):
      i3c: fix incorrect address slot lookup on 64-bit

Jani Nikula (1):
      drm/i915/display: split out dpt out of intel_display.c

Jann Horn (1):
      efivars: Respect "block" flag in efivar_entry_set_safe()

Jedrzej Jagielski (1):
      iavf: Add trace while removing device

Jeremy Pallotta (1):
      ntb_hw_switchtec: Fix pff ioread to read into mmio_part_cfg_all

Jia-Ju Bai (1):
      net: chelsio: cxgb3: check the return value of pci_find_capability()

Jianjun Wang (1):
      PCI: mediatek-gen3: Disable DVFSRC voltage request

Jiasheng Jiang (3):
      drm/amdkfd: Check for null pointer after calling kmemdup
      soc: fsl: qe: Check of ioremap return value
      nl80211: Handle nla_memdup failures in handle_nan_filter

Jiri Bohac (2):
      xfrm: fix MTU regression
      Revert "xfrm: xfrm_state_mtu should return at least 1280 for ipv6"

Johannes Berg (1):
      mac80211: treat some SAE auth steps as final

Josef Bacik (2):
      btrfs: do not WARN_ON() if we have PageError set
      btrfs: do not start relocation until in progress drops are done

José Expósito (1):
      Input: clear BTN_RIGHT/MIDDLE on buttonpads

José Roberto de Souza (1):
      drm/i915/display: Move DRRS code its own file

Kai Vehmanen (2):
      ASoC: rt5668: do not block workqueue if card is unbound
      ASoC: rt5682: do not block workqueue if card is unbound

Karen Sornek (1):
      iavf: Add helper function to go from pci_dev to adapter

Kefeng Wang (1):
      mm: defer kmemleak object creation of module_alloc()

Kiran Kumar K (3):
      octeontx2-af: Optimize KPU1 processing for variable-length headers
      octeontx2-af: Adjust LA pointer for cpt parse header
      octeontx2-af: Add KPU changes to parse NGIO as separate layer

Krzysztof Kozlowski (1):
      selftests/ftrace: Do not trace do_softirq because of PREEMPT_RT

Lai Jiangshan (1):
      KVM: X86: Ensure that dirty PDPTRs are loaded

Lennert Buytenhek (1):
      iommu/amd: Recover from event log overflow

Leo (Hanghong) Ma (1):
      drm/amd/display: Reduce dmesg error to a debug print

Leon Romanovsky (1):
      xfrm: enforce validity of offload input flags

Like Xu (1):
      KVM: x86/mmu: Passing up the error state of mmu_alloc_shadow_roots()

Liu Ying (1):
      drm/atomic: Check new_crtc_state->active to determine if CRTC needs disable in self refresh mode

Lukas Bulwahn (1):
      MAINTAINERS: adjust file entry for of_net.c after movement

Maciej Fijalkowski (1):
      ixgbe: xsk: change !netif_carrier_ok() handling in ixgbe_xmit_zc()

Marc Zyngier (1):
      KVM: arm64: vgic: Read HW interrupt pending state from the HW

Marek Marczykowski-Górecki (1):
      xen/netfront: destroy queues before real_num_tx_queues is zeroed

Marek Vasut (2):
      PCI: rcar: Check if device is runtime suspended instead of __clk_is_enabled()
      ASoC: ops: Shift tested values in snd_soc_put_volsw() by +min

Masami Hiramatsu (1):
      arm64: Mark start_backtrace() notrace and NOKPROBE_SYMBOL

Mat Martineau (1):
      mptcp: Correctly set DATA_FIN timeout when number of retransmits is large

Mateusz Palczewski (3):
      iavf: Refactor iavf state machine tracking
      iavf: Add __IAVF_INIT_FAILED state
      iavf: Combine init and watchdog state machines

Matthew Auld (1):
      drm/i915: don't call free_mmap_offset when purging

Miaoqian Lin (2):
      drm/sun4i: dw-hdmi: Fix missing put_device() call in sun8i_hdmi_phy_get
      iommu/tegra-smmu: Fix missing put_device() call in tegra_smmu_find

Michael Chan (1):
      bnxt_en: Fix occasional ethtool -t loopback test failures

Michel Dänzer (1):
      drm/amd/display: For vblank_disable_immediate, check PSR is really used

Ming Lei (1):
      block: loop:use kstatfs.f_bsize of backing file to set discard granularity

Moshe Tal (1):
      ethtool: Fix link extended state for big endian

Nicholas Kazlauskas (2):
      drm/amdgpu/display: Only set vblank_disable_immediate when PSR is not enabled
      drm/amd/display: Fix stream->link_enc unassigned during stream removal

Nicolas Cavallari (1):
      thermal: core: Fix TZ_GET_TRIP NULL pointer dereference

Nicolas Escande (1):
      mac80211: fix forwarded mesh frames AC & queue selection

Nikola Cornij (1):
      drm/amd/display: Use adjusted DCN301 watermarks

Oliver Barta (1):
      regulator: core: fix false positive in regulator_late_cleanup()

Omar Sandoval (1):
      btrfs: fix relocation crash due to premature return from btrfs_commit_transaction()

Ong Boon Leong (2):
      net: stmmac: enhance XDP ZC driver level switching performance
      net: stmmac: perserve TX and RX coalesce value during XDP setup

Pali Rohár (11):
      PCI: aardvark: Fix checking for MEM resource type
      PCI: mvebu: Check for errors from pci_bridge_emul_init() call
      PCI: mvebu: Do not modify PCI IO type bits in conf_write
      PCI: mvebu: Fix support for bus mastering and PCI_COMMAND on emulated bridge
      PCI: mvebu: Fix configuring secondary bus of PCIe Root Port via emulated bridge
      PCI: mvebu: Setup PCIe controller to Root Complex mode
      PCI: mvebu: Fix support for PCI_BRIDGE_CTL_BUS_RESET on emulated bridge
      PCI: mvebu: Fix support for PCI_EXP_DEVCTL on emulated bridge
      PCI: mvebu: Fix support for PCI_EXP_RTSTA on emulated bridge
      PCI: mvebu: Fix support for DEVCAP2, DEVCTL2 and LNKCTL2 registers on emulated bridge
      PCI: mvebu: Fix device enumeration regression

Palmer Dabbelt (1):
      riscv/mm: Add XIP_FIXUP for phys_ram_base

Paolo Bonzini (1):
      KVM: VMX: Don't unblock vCPU w/ Posted IRQ if IRQs are disabled in guest

Peter Zijlstra (1):
      sched: Fix yet more sched_fork() races

Przemyslaw Patynowski (1):
      iavf: Fix kernel BUG in free_msi_irqs

Qiang Yu (2):
      drm/amdgpu: check vm ready by amdgpu_vm->evicting flag
      drm/amdgpu: fix suspend/resume hang regression

Qingqing Zhuo (1):
      drm/amd/display: move FPU associated DSC code to DML folder

Raed Salem (2):
      net/mlx5e: IPsec: Refactor checksum code in tx data path
      net/mlx5e: IPsec: Fix crypto offload for non TCP/UDP encapsulated traffic

Randy Dunlap (6):
      iwlwifi: mvm: check debugfs_dir ptr before use
      net: stmmac: fix return value of __setup handler
      net: sxgbe: fix return value of __setup handler
      mips: setup: fix setnocoherentio() boolean setting
      ARM: 9182/1: mmu: fix returns from early_param() and __setup() functions
      tracing: Fix return value of __setup handlers

Robin Murphy (1):
      arm64: dts: juno: Remove GICv2m dma-range

Ronnie Sahlberg (3):
      cifs: do not use uninitialized data in the owner/group sid
      cifs: fix double free race when mount fails in cifs_get_root()
      cifs: modefromsids must add an ACE for authenticated users

Russell King (Oracle) (1):
      ARM: Fix kgdb breakpoint for Thumb2

Samuel Holland (1):
      pinctrl: sunxi: Use unique lockdep classes for IRQs

Sasha Neftin (3):
      e1000e: Correct NVM checksum verification flow
      igc: igc_write_phy_reg_gpy: drop premature return
      e1000e: Fix possible HW unit hang after an s0ix exit

Sean Christopherson (4):
      KVM: s390: Ensure kvm_arch_no_poll() is read once when blocking vCPU
      KVM: VMX: Read Posted Interrupt "control" exactly once per loop iteration
      KVM: x86: Handle 32-bit wrap of EIP for EMULTYPE_SKIP with flat code seg
      hugetlbfs: fix off-by-one error in hugetlb_vmdelete_list()

Sergey Shtylyov (1):
      ata: pata_hpt37x: fix PCI clock detection

Sherry Yang (1):
      selftests/seccomp: Fix seccomp failure by adding missing headers

Shyam Prasad N (1):
      cifs: protect session channel fields with chan_lock

Sidong Yang (1):
      btrfs: qgroup: fix deadlock between rescan worker and remove qgroup

Slawomir Laba (8):
      iavf: Fix missing check for running netdev
      iavf: Fix deadlock in iavf_reset_task
      iavf: Rework mutexes for better synchronisation
      iavf: Add waiting so the port is initialized in remove
      iavf: Fix init state closure on remove
      iavf: Fix locking for VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS
      iavf: Fix race in init state
      iavf: Fix __IAVF_RESETTING state usage

Stefan Assmann (1):
      iavf: do not override the adapter state in the watchdog task (again)

Steve French (1):
      cifs: fix confusing unneeded warning message on smb2.1 and earlier

Steven Rostedt (2):
      tracing: Add test for user space strings when filtering on string pointers
      tracing: Add ustring operation to filtering string pointers

Steven Rostedt (Google) (1):
      tracing/histogram: Fix sorting on old "cpu" value

Sukadev Bhattiprolu (6):
      ibmvnic: don't release napi in __ibmvnic_open()
      ibmvnic: register netdev after init of adapter
      ibmvnic: free reset-work-item when flushing
      ibmvnic: initialize rc before completing wait
      ibmvnic: define flush_reset_queue helper
      ibmvnic: complete init_done on transport events

Sunil V L (1):
      riscv/efi_stub: Fix get_boot_hartid_from_fdt() return value

Suravee Suthikulpanit (1):
      iommu/amd: Fix I/O page table memory leak

Sven Eckelmann (3):
      batman-adv: Request iflink once in batadv-on-batadv check
      batman-adv: Request iflink once in batadv_get_real_netdevice
      batman-adv: Don't expect inter-netns unique iflink indices

Tadeusz Struk (1):
      sched/fair: Fix fault in reweight_entity

Tao Liu (1):
      gve: Recording rx queue before sending to napi

Thierry Reding (1):
      ARM: tegra: Move panels to AUX bus

Tim Harvey (1):
      PCI: dwc: Do not remap invalid res

Tom Rix (1):
      i3c: master: dw: check return of dw_i3c_master_get_free_pos()

Tudor Ambarus (1):
      mtd: spi-nor: Fix mtd size for s3an flashes

Valentin Caron (1):
      serial: stm32: prevent TDR register overwrite when sending x_char

Ville Syrjälä (2):
      drm/i915: Disable DRRS on IVB/HSW port != A
      drm/i915: s/JSP2/ICP2/ PCH

Vinay Belgaumkar (1):
      drm/i915/guc/slpc: Correct the param count for unset param

Vincent Mailhol (2):
      can: gs_usb: change active_channels's type from atomic_t to u8
      can: etas_es58x: change opened_channel_cnt's type from atomic_t to u8

Vincent Whitchurch (1):
      net: stmmac: only enable DMA interrupts when ready

Vitaly Kuznetsov (1):
      x86/hyperv: Properly deal with empty cpumasks in hyperv_flush_tlb_multi()

Vladimir Oltean (3):
      net: dsa: seville: register the mdiobus under devres
      net: dcb: flush lingering app table entries for unregistered devices
      net: dcb: disable softirqs in dcbnl_flush_dev()

Waiman Long (1):
      selftests/vm: make charge_reserved_hugetlb.sh work with existing cgroup setting

Weizhao Ouyang (1):
      dma-buf: cma_heap: Fix mutex locking section

Wesley Sheng (1):
      ntb_hw_switchtec: Fix bug with more than 32 partitions

William Mahon (2):
      HID: add mapping for KEY_DICTATE
      HID: add mapping for KEY_ALL_APPLICATIONS

Wolfram Sang (3):
      i2c: cadence: allow COMPILE_TEST
      i2c: imx: allow COMPILE_TEST
      i2c: qup: allow COMPILE_TEST

Xiaoke Wang (2):
      tracing/uprobes: Check the return value of kstrdup() for tu->filename
      tracing/probes: check the return value of kstrndup() for pbuf

Xin Yin (2):
      ext4: fast commit may not fallback for ineligible commit
      ext4: fast commit may miss file actions

Yongzhi Liu (1):
      dmaengine: shdma: Fix runtime PM imbalance on error

Yu Kuai (1):
      blktrace: fix use after free for struct blk_trace

Yun Zhou (1):
      proc: fix documentation and description of pagemap

Zhen Ni (1):
      ALSA: intel_hdmi: Fix reference to PCM buffer address

Zheyu Ma (1):
      net: arcnet: com20020: Fix null-ptr-deref in com20020pci_probe()

j.nixdorf@avm.de (1):
      net: ipv6: ensure we call ipv6_mc_down() at most once

lena wang (1):
      net: fix up skbs delta_truesize in UDP GRO frag_list

