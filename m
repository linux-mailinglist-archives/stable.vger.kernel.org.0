Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3ACD34E94E
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 15:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhC3Nhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 09:37:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232059AbhC3NhT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 09:37:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B368619CB;
        Tue, 30 Mar 2021 13:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617111438;
        bh=6672E0rAz1PZLDWQVdN1ZCFLnQYHs/2a606xC7znypM=;
        h=From:To:Cc:Subject:Date:From;
        b=G17JZXp8N7NeKS0vDcmziqQVooLuJ8lNqdMTMj7B4O12EY5qsX4Qwj7rXIhGTmhhq
         gb/3zQfNPb2GvSLqkwUhwBzQk2kY/skpft1ut8oQsyCr3QMln+P5Gb+ZopG6YW8nRN
         2QuBoQ1r7b4d17czbuVFMTN3/RueFf9gPHpKNk40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.11
Date:   Tue, 30 Mar 2021 15:36:59 +0200
Message-Id: <161711141923769@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.11.11 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/virt/kvm/api.rst                                 |    6 
 Makefile                                                       |    5 
 arch/arm/boot/dts/at91-sam9x60ek.dts                           |    8 
 arch/arm/boot/dts/at91-sama5d27_som1.dtsi                      |    4 
 arch/arm/boot/dts/imx6ull-myir-mys-6ulx-eval.dts               |    1 
 arch/arm/boot/dts/sam9x60.dtsi                                 |    9 
 arch/arm/mach-omap2/sr_device.c                                |   75 ++-
 arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi                 |    1 
 arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi                 |    1 
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi                 |    1 
 arch/arm64/kernel/crash_dump.c                                 |    2 
 arch/arm64/kernel/stacktrace.c                                 |    9 
 arch/ia64/include/asm/syscall.h                                |    2 
 arch/ia64/kernel/ptrace.c                                      |   24 -
 arch/powerpc/include/asm/dcr-native.h                          |    8 
 arch/sparc/kernel/traps_64.c                                   |   13 
 arch/x86/include/asm/kvm_host.h                                |   14 
 arch/x86/include/asm/static_call.h                             |    7 
 arch/x86/include/asm/xen/page.h                                |   12 
 arch/x86/kvm/x86.c                                             |  109 ++---
 arch/x86/mm/mem_encrypt.c                                      |    2 
 arch/x86/net/bpf_jit_comp.c                                    |   27 +
 arch/x86/xen/p2m.c                                             |    7 
 arch/x86/xen/setup.c                                           |   16 
 block/blk-cgroup-rwstat.c                                      |    3 
 block/blk-merge.c                                              |    8 
 block/blk-zoned.c                                              |    2 
 block/genhd.c                                                  |    4 
 drivers/acpi/acpica/nsaccess.c                                 |    3 
 drivers/acpi/internal.h                                        |    6 
 drivers/acpi/scan.c                                            |   88 ++--
 drivers/acpi/video_detect.c                                    |    1 
 drivers/atm/eni.c                                              |    3 
 drivers/atm/idt77105.c                                         |    4 
 drivers/atm/lanai.c                                            |    5 
 drivers/atm/uPD98402.c                                         |    2 
 drivers/base/power/runtime.c                                   |   45 +-
 drivers/block/umem.c                                           |    5 
 drivers/block/xen-blkback/blkback.c                            |    2 
 drivers/bus/omap_l3_noc.c                                      |    4 
 drivers/clk/qcom/gcc-sc7180.c                                  |    4 
 drivers/cpufreq/cpufreq-dt-platdev.c                           |    2 
 drivers/gpio/gpiolib-acpi.c                                    |    2 
 drivers/gpu/drm/Kconfig                                        |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                     |    8 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                        |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c                         |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c              |    1 
 drivers/gpu/drm/amd/display/dc/dc.h                            |    1 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c              |   11 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.h              |    6 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c      |    7 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c              |    1 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c             |    6 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_link_encoder.c      |    3 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c              |    1 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c          |    2 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c              |    1 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c          |   31 +
 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c        |   96 ++++
 drivers/gpu/drm/amd/display/dc/inc/hw/hubp.h                   |    2 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c            |   54 ++
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c          |   74 ++-
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c          |   24 +
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c          |   25 +
 drivers/gpu/drm/etnaviv/etnaviv_gem.c                          |    2 
 drivers/gpu/drm/i915/display/intel_vdsc.c                      |   10 
 drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c                   |   13 
 drivers/gpu/drm/i915/intel_runtime_pm.c                        |   29 +
 drivers/gpu/drm/i915/intel_runtime_pm.h                        |    5 
 drivers/gpu/drm/msm/dsi/pll/dsi_pll.c                          |    2 
 drivers/gpu/drm/msm/dsi/pll/dsi_pll.h                          |    6 
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_7nm.c                      |    5 
 drivers/gpu/drm/msm/msm_drv.c                                  |   12 
 drivers/gpu/drm/nouveau/dispnv50/disp.c                        |   13 
 drivers/infiniband/hw/cxgb4/cm.c                               |    4 
 drivers/irqchip/irq-ingenic-tcu.c                              |    1 
 drivers/irqchip/irq-ingenic.c                                  |    1 
 drivers/md/dm-ioctl.c                                          |    2 
 drivers/md/dm-table.c                                          |   33 +
 drivers/md/dm-verity-target.c                                  |    2 
 drivers/md/dm-zoned-target.c                                   |    2 
 drivers/md/dm.c                                                |    5 
 drivers/mfd/intel_quark_i2c_gpio.c                             |    6 
 drivers/misc/habanalabs/common/device.c                        |   40 +
 drivers/misc/habanalabs/common/habanalabs_ioctl.c              |   12 
 drivers/net/can/c_can/c_can.c                                  |   24 -
 drivers/net/can/c_can/c_can_pci.c                              |    3 
 drivers/net/can/c_can/c_can_platform.c                         |    6 
 drivers/net/can/dev.c                                          |    1 
 drivers/net/can/flexcan.c                                      |    8 
 drivers/net/can/kvaser_pciefd.c                                |    4 
 drivers/net/can/m_can/m_can.c                                  |    5 
 drivers/net/dsa/b53/b53_common.c                               |   14 
 drivers/net/dsa/bcm_sf2.c                                      |    6 
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c |    2 
 drivers/net/ethernet/davicom/dm9000.c                          |    2 
 drivers/net/ethernet/faraday/ftgmac100.c                       |    1 
 drivers/net/ethernet/freescale/enetc/enetc_hw.h                |    2 
 drivers/net/ethernet/freescale/enetc/enetc_pf.c                |    6 
 drivers/net/ethernet/freescale/fec_ptp.c                       |    7 
 drivers/net/ethernet/freescale/gianfar.c                       |   15 
 drivers/net/ethernet/hisilicon/hns/hns_enet.c                  |    4 
 drivers/net/ethernet/intel/e1000e/82571.c                      |    2 
 drivers/net/ethernet/intel/e1000e/netdev.c                     |    6 
 drivers/net/ethernet/intel/iavf/iavf_main.c                    |    3 
 drivers/net/ethernet/intel/ice/ice_base.c                      |    6 
 drivers/net/ethernet/intel/ice/ice_xsk.c                       |   10 
 drivers/net/ethernet/intel/igb/igb.h                           |    4 
 drivers/net/ethernet/intel/igb/igb_main.c                      |   33 -
 drivers/net/ethernet/intel/igb/igb_ptp.c                       |   31 +
 drivers/net/ethernet/intel/igc/igc.h                           |    2 
 drivers/net/ethernet/intel/igc/igc_ethtool.c                   |    7 
 drivers/net/ethernet/intel/igc/igc_main.c                      |    9 
 drivers/net/ethernet/intel/igc/igc_ptp.c                       |   72 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                  |    6 
 drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h        |    2 
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c                |    6 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c        |   48 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c            |    2 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c           |    5 
 drivers/net/ethernet/mellanox/mlx5/core/en.h                   |    7 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c             |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c     |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c           |   11 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c              |   21 
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                |   57 ++
 drivers/net/ethernet/netronome/nfp/flower/metadata.c           |   24 -
 drivers/net/ethernet/netronome/nfp/flower/offload.c            |   18 
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c        |   15 
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c               |   13 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c           |    3 
 drivers/net/ethernet/realtek/r8169_main.c                      |    6 
 drivers/net/ethernet/socionext/netsec.c                        |    9 
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c              |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c             |   50 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c                 |    9 
 drivers/net/ethernet/stmicro/stmmac/hwif.h                     |    3 
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c                |    9 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c              |   57 +-
 drivers/net/ethernet/sun/niu.c                                 |    2 
 drivers/net/ethernet/tehuti/tehuti.c                           |    1 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c              |   35 +
 drivers/net/ipa/ipa_qmi.c                                      |    2 
 drivers/net/phy/broadcom.c                                     |  147 ++++--
 drivers/net/phy/dp83822.c                                      |    3 
 drivers/net/phy/dp83869.c                                      |    4 
 drivers/net/phy/lxt.c                                          |    1 
 drivers/net/phy/marvell.c                                      |    1 
 drivers/net/phy/marvell10g.c                                   |    2 
 drivers/net/phy/micrel.c                                       |   14 
 drivers/net/phy/phy.c                                          |    2 
 drivers/net/phy/phy_device.c                                   |    9 
 drivers/net/phy/phylink.c                                      |    2 
 drivers/net/usb/cdc-phonet.c                                   |    2 
 drivers/net/usb/r8152.c                                        |   40 -
 drivers/net/veth.c                                             |    3 
 drivers/net/wan/fsl_ucc_hdlc.c                                 |    8 
 drivers/net/wan/hdlc_x25.c                                     |   42 +
 drivers/net/wireless/mediatek/mt76/dma.c                       |   15 
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c                |   10 
 drivers/nvme/host/core.c                                       |   15 
 drivers/nvme/host/fc.c                                         |    3 
 drivers/nvme/host/pci.c                                        |    1 
 drivers/nvme/target/rdma.c                                     |    5 
 drivers/platform/x86/dell-wmi-sysman/enum-attributes.c         |    3 
 drivers/platform/x86/dell-wmi-sysman/int-attributes.c          |    3 
 drivers/platform/x86/dell-wmi-sysman/passobj-attributes.c      |    3 
 drivers/platform/x86/dell-wmi-sysman/string-attributes.c       |    3 
 drivers/platform/x86/dell-wmi-sysman/sysman.c                  |   84 +--
 drivers/platform/x86/intel-vbtn.c                              |   12 
 drivers/platform/x86/intel_pmt_crashlog.c                      |   13 
 drivers/regulator/qcom-rpmh-regulator.c                        |    6 
 drivers/scsi/mpt3sas/mpt3sas_base.c                            |    8 
 drivers/scsi/qedi/qedi_main.c                                  |    1 
 drivers/scsi/qla2xxx/qla_target.c                              |   13 
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                             |    4 
 drivers/scsi/ufs/ufs-qcom.c                                    |   10 
 drivers/soc/ti/omap_prm.c                                      |    8 
 drivers/staging/rtl8192e/Kconfig                               |    1 
 drivers/xen/Kconfig                                            |    4 
 fs/btrfs/dev-replace.c                                         |    3 
 fs/btrfs/disk-io.c                                             |   19 
 fs/btrfs/inode.c                                               |   14 
 fs/btrfs/qgroup.c                                              |   12 
 fs/btrfs/volumes.c                                             |    3 
 fs/cachefiles/rdwr.c                                           |    7 
 fs/cifs/cifsglob.h                                             |    4 
 fs/cifs/cifspdu.h                                              |    5 
 fs/cifs/smb2glob.h                                             |    1 
 fs/cifs/smb2ops.c                                              |   27 -
 fs/cifs/smb2pdu.c                                              |    6 
 fs/cifs/smb2transport.c                                        |   37 +
 fs/cifs/transport.c                                            |    2 
 fs/ext4/mballoc.c                                              |   11 
 fs/ext4/xattr.c                                                |    4 
 fs/gfs2/log.c                                                  |    4 
 fs/gfs2/trans.c                                                |    2 
 fs/io_uring.c                                                  |   14 
 fs/nfs/Kconfig                                                 |    2 
 fs/nfs/nfs3xdr.c                                               |    3 
 fs/nfs/nfs4proc.c                                              |    3 
 fs/squashfs/export.c                                           |    8 
 fs/squashfs/id.c                                               |    6 
 fs/squashfs/squashfs_fs.h                                      |    1 
 fs/squashfs/xattr_id.c                                         |    6 
 include/acpi/acpi_bus.h                                        |    1 
 include/asm-generic/vmlinux.lds.h                              |    5 
 include/linux/bpf.h                                            |   33 +
 include/linux/brcmphy.h                                        |    4 
 include/linux/device-mapper.h                                  |   15 
 include/linux/hugetlb_cgroup.h                                 |   15 
 include/linux/if_macvlan.h                                     |    3 
 include/linux/memblock.h                                       |    4 
 include/linux/mm.h                                             |   18 
 include/linux/mm_types.h                                       |    1 
 include/linux/mmu_notifier.h                                   |   10 
 include/linux/mutex.h                                          |    2 
 include/linux/netfilter/x_tables.h                             |    7 
 include/linux/pagemap.h                                        |    1 
 include/linux/phy.h                                            |    2 
 include/linux/static_call.h                                    |   43 -
 include/linux/static_call_types.h                              |   50 ++
 include/linux/u64_stats_sync.h                                 |    7 
 include/linux/usermode_driver.h                                |    1 
 include/net/dst.h                                              |   11 
 include/net/inet_connection_sock.h                             |    2 
 include/net/netfilter/nf_tables.h                              |    3 
 include/net/nexthop.h                                          |   24 +
 include/net/red.h                                              |   10 
 include/net/rtnetlink.h                                        |    2 
 include/uapi/linux/psample.h                                   |    5 
 kernel/bpf/bpf_inode_storage.c                                 |    2 
 kernel/bpf/bpf_struct_ops.c                                    |    2 
 kernel/bpf/core.c                                              |    4 
 kernel/bpf/preload/bpf_preload_kern.c                          |   19 
 kernel/bpf/syscall.c                                           |    5 
 kernel/bpf/trampoline.c                                        |  218 +++++++---
 kernel/bpf/verifier.c                                          |    4 
 kernel/fork.c                                                  |    8 
 kernel/gcov/clang.c                                            |   69 +++
 kernel/power/energy_model.c                                    |    2 
 kernel/static_call.c                                           |   71 ++-
 kernel/trace/ftrace.c                                          |   43 +
 kernel/usermode_driver.c                                       |   21 
 mm/highmem.c                                                   |    4 
 mm/hugetlb.c                                                   |   41 +
 mm/hugetlb_cgroup.c                                            |   10 
 mm/mmu_notifier.c                                              |   23 +
 mm/z3fold.c                                                    |   16 
 net/bridge/br_switchdev.c                                      |    2 
 net/can/isotp.c                                                |   18 
 net/core/dev.c                                                 |   14 
 net/core/drop_monitor.c                                        |   23 +
 net/core/dst.c                                                 |   59 +-
 net/core/flow_dissector.c                                      |    2 
 net/dccp/ipv6.c                                                |    5 
 net/ipv4/inet_connection_sock.c                                |    7 
 net/ipv4/netfilter/arp_tables.c                                |   16 
 net/ipv4/netfilter/ip_tables.c                                 |   16 
 net/ipv4/route.c                                               |   45 --
 net/ipv4/tcp_minisocks.c                                       |    7 
 net/ipv6/ip6_fib.c                                             |    2 
 net/ipv6/ip6_input.c                                           |   10 
 net/ipv6/netfilter/ip6_tables.c                                |   16 
 net/ipv6/route.c                                               |   36 -
 net/ipv6/tcp_ipv6.c                                            |    5 
 net/mac80211/cfg.c                                             |    4 
 net/mac80211/ibss.c                                            |    2 
 net/mac80211/mlme.c                                            |    2 
 net/mac80211/util.c                                            |    2 
 net/mptcp/options.c                                            |   24 -
 net/mptcp/subflow.c                                            |    5 
 net/netfilter/nf_conntrack_netlink.c                           |    1 
 net/netfilter/nf_flow_table_core.c                             |    2 
 net/netfilter/nf_tables_api.c                                  |   19 
 net/netfilter/x_tables.c                                       |   49 +-
 net/qrtr/qrtr.c                                                |    5 
 net/sched/cls_flower.c                                         |    2 
 net/sched/sch_choke.c                                          |    7 
 net/sched/sch_gred.c                                           |    2 
 net/sched/sch_red.c                                            |    7 
 net/sched/sch_sfq.c                                            |    2 
 net/sctp/output.c                                              |    7 
 net/sctp/outqueue.c                                            |    7 
 net/tipc/node.c                                                |   11 
 net/vmw_vsock/af_vsock.c                                       |    1 
 scripts/dummy-tools/gcc                                        |    5 
 security/integrity/iint.c                                      |    8 
 security/selinux/include/security.h                            |   15 
 security/selinux/selinuxfs.c                                   |   13 
 security/selinux/ss/services.c                                 |   63 +-
 sound/hda/intel-nhlt.c                                         |    5 
 tools/include/linux/static_call_types.h                        |   50 ++
 tools/lib/bpf/Makefile                                         |    2 
 tools/lib/bpf/btf_dump.c                                       |    2 
 tools/lib/bpf/libbpf.c                                         |    3 
 tools/lib/bpf/netlink.c                                        |    2 
 tools/objtool/check.c                                          |   17 
 tools/perf/util/auxtrace.c                                     |    4 
 tools/perf/util/synthetic-events.c                             |    9 
 tools/testing/kunit/configs/broken_on_uml.config               |    2 
 tools/testing/selftests/arm64/fp/sve-ptrace.c                  |    2 
 tools/testing/selftests/bpf/prog_tests/fexit_sleep.c           |   82 +++
 tools/testing/selftests/bpf/progs/fexit_sleep.c                |   31 +
 tools/testing/selftests/bpf/progs/test_tunnel_kern.c           |    6 
 tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh      |    2 
 tools/testing/selftests/net/reuseaddr_ports_exhausted.c        |   32 -
 309 files changed, 3092 insertions(+), 1105 deletions(-)

Adrian Hunter (1):
      perf auxtrace: Fix auxtrace queue conflict

Alaa Hleihel (1):
      net/mlx5e: Allow to match on MPLS parameters only for MPLS over UDP

Alex Deucher (2):
      drm/amdgpu/display: restore AUX_DPHY_TX_CONTROL for DCN2.x
      drm/amdgpu: Add additional Sienna Cichlid PCI ID

Alex Elder (1):
      net: ipa: terminate message handler arrays

Alex Marginean (1):
      net: enetc: set MAC RX FIFO to recommended value

Alexander Lobakin (1):
      flow_dissector: fix byteorder of dissected ICMP ID

Alexander Ovechkin (1):
      tcp: relookup sock for RST+ACK packets handled by obsolete req sock

Alexei Starovoitov (4):
      bpf: Dont allow vmlinux BTF to be used in map_create and prog_load.
      ftrace: Fix modify_ftrace_direct.
      bpf: Fix fexit trampoline.
      selftest/bpf: Add a test to check trampoline freeing logic.

Andre Guedes (1):
      igc: Fix igc_ptp_rx_pktstamp()

Andrey Konovalov (1):
      kasan: fix per-page tags for non-page_alloc pages

Andy Shevchenko (2):
      mfd: intel_quark_i2c_gpio: Revert "Constify static struct resources"
      ACPI: scan: Use unique number for instance_no

Angelo Dureghello (1):
      can: flexcan: flexcan_chip_freeze(): fix chip freeze for missing bitrate

Arnd Bergmann (1):
      ch_ktls: fix enum-conversion warning

Aurelien Aptel (1):
      cifs: ask for more credit on async read/write code paths

Aya Levin (2):
      net/mlx5e: Set PTP channel pointer explicitly to NULL
      net/mlx5e: Fix error path for ethtool set-priv-flag

Bart Van Assche (1):
      scsi: Revert "qla2xxx: Make sure that aborted commands are freed"

Bob Peterson (1):
      gfs2: fix use-after-free in trans_drain

Brian Norris (1):
      mac80211: Allow HE operation to be longer than expected.

Carlos Llamas (1):
      selftests/net: fix warnings on reuseaddr_ports_exhausted

Chaitanya Kulkarni (1):
      nvme-core: check ctrl css before setting up zns

Chris Chiu (1):
      ACPI: video: Add missing callback back for Sony VPCEH3U1E

Christian König (1):
      drm/radeon: fix AGP dependency

Christoph Hellwig (1):
      nvme: fix the nsid value to print in nvme_validate_or_alloc_ns

Claudiu Beznea (1):
      ARM: dts: at91-sama5d27_som1: fix phy address to 7

Colin Ian King (1):
      octeontx2-af: Fix memory leak of object buf

Corentin Labbe (1):
      net: stmmac: dwmac-sun8i: Provide TX and RX fifo sizes

Damien Le Moal (1):
      block: Fix REQ_OP_ZONE_RESET_ALL handling

Daniel Borkmann (2):
      net: Consolidate common blackhole dst ops
      net, bpf: Fix ip6ip6 crash with collect_md populated skbs

Daniel Vetter (1):
      drm/etnaviv: Use FOLL_FORCE for userptr

Daniel Wagner (1):
      block: Suppress uevent for hidden device when removed

David Brazdil (1):
      selinux: vsock: Set SID for socket returned by accept()

David E. Box (1):
      platform/x86: intel_pmt_crashlog: Fix incorrect macros

David Gow (1):
      kunit: tool: Disable PAGE_POISONING under --alltests

David Jeffery (1):
      block: recalculate segment count for multi-segment discards correctly

Davide Caratti (1):
      mptcp: fix ADD_ADDR HMAC in case port is specified

Denis Efremov (1):
      sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count

Dillon Varone (1):
      drm/amd/display: Enabled pipe harvesting in dcn30

Dima Chumak (1):
      net/mlx5e: Offload tuple rewrite for non-CT flows

Dinghao Liu (2):
      ixgbe: Fix memleak in ixgbe_configure_clsu32
      e1000e: Fix error handling in e1000_set_d0_lplu_state_82571

Dmitry Baryshkov (2):
      drm/msm/dsi: fix check-before-set in the 7nm dsi_pll code
      drm/msm: fix shutdown hook in case GPU components failed to bind

Dmitry Monakhov (1):
      nvme-pci: add the DISABLE_WRITE_ZEROES quirk for a Samsung PM1725a

Douglas Anderson (1):
      clk: qcom: gcc-sc7180: Use floor ops for the correct sdcc1 clk

Dylan Hung (1):
      ftgmac100: Restart MAC HW once

Eric Dumazet (4):
      macvlan: macvlan_count_rx() needs to be aware of preemption
      net: sched: validate stab values
      net: qrtr: fix a kernel-infoleak in qrtr_recvmsg()
      tipc: better validate user input in tipc_nl_retrieve_key()

Fabio Estevam (1):
      drm/msm: Fix suspend/resume on i.MX5

Federico Pellegrin (1):
      ARM: dts: at91: sam9x60: fix mux-mask for PA7 so it can be set to A, B and C

Felix Fietkau (2):
      mt76: fix tx skb error handling in mt76_dma_tx_queue_skb
      mt76: mt7915: only modify tx buffer list after allocating tx token id

Fenghua Yu (1):
      mm/fork: clear PASID for new mm

Filipe Manana (2):
      btrfs: fix sleep while in non-sleep context during qgroup removal
      btrfs: fix subvolume/snapshot deletion not triggered on mount

Florian Fainelli (5):
      net: dsa: bcm_sf2: Qualify phydev->dev_flags based on port
      net: phy: broadcom: Add power down exit reset state delay
      net: phy: broadcom: Avoid forward for bcm54xx_config_clock_delay()
      net: phy: broadcom: Fix RGMII delays for BCM50160 and BCM50610M
      net: dsa: b53: VLAN filtering is global to all users

Florian Westphal (1):
      netfilter: ctnetlink: fix dump of the expect mask attribute

Frank Sorenson (1):
      NFS: Correct size calculation for create reply length

Geetha sowjanya (2):
      octeontx2-af: Fix irq free in rvu teardown
      octeontx2-pf: Clear RSS enable flag on interace down

Georgi Valkov (1):
      libbpf: Fix INSTALL flag order

Greg Kroah-Hartman (1):
      Linux 5.11.11

Grygorii Strashko (1):
      bus: omap_l3_noc: mark l3 irqs as IRQF_NO_THREAD

Hangbin Liu (2):
      selftests/bpf: Set gopt opt_class to 0 if get tunnel opt failed
      selftests: forwarding: vxlan_bridge_1d: Fix vxlan ecn decapsulate value

Hannes Reinecke (4):
      nvme: simplify error logic in nvme_validate_ns()
      nvme: add NVME_REQ_CANCELLED flag in nvme_cancel_request()
      nvme-fc: set NVME_REQ_CANCELLED in nvme_fc_terminate_exchange()
      nvme-fc: return NVME_SC_HOST_ABORTED_CMD when a command has been aborted

Hans de Goede (8):
      platform/x86: intel-vbtn: Stop reporting SW_DOCK events
      platform/x86: dell-wmi-sysman: Fix crash caused by calling kset_unregister twice
      platform/x86: dell-wmi-sysman: Fix possible NULL pointer deref on exit
      platform/x86: dell-wmi-sysman: Make it safe to call exit_foo_attributes() multiple times
      platform/x86: dell-wmi-sysman: Fix release_attributes_data() getting called twice on init_bios_attributes() failure
      platform/x86: dell-wmi-sysman: Cleanup sysman_init() error-exit handling
      platform/x86: dell-wmi-sysman: Make sysman_init() return -ENODEV of the interfaces are not found
      platform/x86: dell-wmi-sysman: Cleanup create_attributes_level_sysfs_files()

Hariprasad Kelam (1):
      octeontx2-af: fix infinite loop in unmapping NPC counter

Hayes Wang (2):
      Revert "r8152: adjust the settings about MAC clock speed down for RTL8153"
      r8152: limit the RX buffer size of RTL8153A for USB 2.0

Heiko Thiery (1):
      net: fec: ptp: avoid register access when ipg clock is disabled

Heiner Kallweit (1):
      r8169: fix DMA being used after buffer free if WoL is enabled

Horia Geantă (3):
      arm64: dts: ls1046a: mark crypto engine dma coherent
      arm64: dts: ls1012a: mark crypto engine dma coherent
      arm64: dts: ls1043a: mark crypto engine dma coherent

Huy Nguyen (1):
      net/mlx5: Add back multicast stats for uplink representor

Ian Rogers (1):
      perf synthetic events: Avoid write of uninitialized memory when generating PERF_RECORD_MMAP* records

Ido Schimmel (2):
      psample: Fix user API breakage
      drop_monitor: Perform cleanup upon probe registration failure

Imre Deak (1):
      drm/i915: Fix the GT fence revocation runtime PM logic

Ira Weiny (1):
      mm/highmem: fix CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP

Isaku Yamahata (1):
      x86/mem_encrypt: Correct physical address calculation in __set_clr_pte_enc()

J. Bruce Fields (1):
      nfs: we don't support removing system.nfs4_acl

Jakub Kicinski (1):
      ipv6: weaken the v4mapped source check

Jan Beulich (1):
      xen-blkback: don't leak persistent grants from xen_blkbk_map()

Jan Kara (1):
      ext4: add reclaim checks to xattr code

Jani Nikula (1):
      drm/i915/dsc: fix DSS CTL register usage for ICL DSI transcoders

Jean-Philippe Brucker (1):
      libbpf: Fix BTF dump of pointer-to-array-of-struct

JeongHyeon Lee (1):
      dm verity: fix DM_VERITY_OPTS_MAX value

Jesse Brandeburg (1):
      igb: check timestamp validity

Jia-Ju Bai (6):
      net: tehuti: fix error return code in bdx_probe()
      net: intel: iavf: fix error return code of iavf_init_get_resources()
      net: hisilicon: hns: fix error return code of hns_nic_clear_all_rx_fetch()
      net: wan: fix error return code of uhdlc_init()
      scsi: qedi: Fix error return code of qedi_alloc_global_queues()
      scsi: mpt3sas: Fix error return code of mpt3sas_base_attach()

Jimmy Assarsson (1):
      can: kvaser_pciefd: Always disable bus load reporting

Jiri Bohac (1):
      net: check all name nodes in __dev_alloc_name

Jiri Slaby (1):
      kbuild: dummy-tools: fix inverted tests for gcc

Joakim Zhang (1):
      net: stmmac: fix dma physical address of descriptor when display ring

Johan Hovold (1):
      net: cdc-phonet: fix data-interface release on probe failure

Johannes Berg (1):
      mac80211: fix rate mask reset

Josef Bacik (3):
      btrfs: do not initialize dev stats if we have no dev_root
      btrfs: do not initialize dev replace for bad dev root
      btrfs: initialize device::fs_info always

Josh Poimboeuf (1):
      static_call: Allow module use without exposing static_call_key

Julian Braha (1):
      staging: rtl8192e: fix kconfig dependency on CRYPTO

Kenneth Feng (1):
      drm/amd/pm: workaround for audio noise issue

Kumar Kartikeya Dwivedi (1):
      libbpf: Use SOCK_CLOEXEC when opening the netlink socket

Li RongQing (1):
      igb: avoid premature Rx buffer reuse

Louis Peens (3):
      nfp: flower: fix unsupported pre_tunnel flows
      nfp: flower: add ipv6 bit to pre_tunnel control message
      nfp: flower: fix pre_tun mask id allocation

Lukasz Luba (1):
      PM: EM: postpone creating the debugfs dir till fs_initcall

Lv Yunlong (2):
      nvme-rdma: Fix a use after free in nvmet_rdma_write_data_done
      net/qlcnic: Fix a use after free in qlcnic_83xx_get_minidump_template

Lyude Paul (1):
      drm/nouveau/kms/nve4-nv108: Limit cursors to 128x128

Maciej Fijalkowski (1):
      veth: Store queue_mapping independently of XDP prog presence

Magnus Karlsson (1):
      ice: fix napi work done reporting in xsk path

Maor Dickman (1):
      net/mlx5e: Don't match on Geneve options in case option masks are all zero

Marc Kleine-Budde (3):
      can: isotp: isotp_setsockopt(): only allow to set low level TX flags for CAN-FD
      can: isotp: TX-path: ensure that CAN frame flags are initialized
      can: peak_usb: Revert "can: peak_usb: add forgotten supported devices"

Mark Brown (1):
      kselftest: arm64: Fix exit code of sve-ptrace

Mark Pearson (1):
      ALSA: hda: ignore invalid NHLT table

Mark Rutland (1):
      arm64: stacktrace: don't trace arch_stack_walk()

Mark Tomlinson (3):
      Revert "netfilter: x_tables: Switch synchronization to RCU"
      netfilter: x_tables: Use correct memory barriers.
      Revert "netfilter: x_tables: Update remaining dereference to RCU"

Markus Theil (1):
      mac80211: fix double free in ibss_leave

Martin Willi (1):
      can: dev: Move device back to init netns on owning netns delete

Masahiro Yamada (1):
      kbuild: add image_name to no-sync-config-targets

Matthew Wilcox (Oracle) (1):
      fs/cachefiles: Remove wait_bit_key layout dependency

Maxim Mikityanskiy (2):
      net/mlx5e: When changing XDP program without reset, take refs for XSK RQs
      net/mlx5e: Revert parameters on errors when changing PTP state without reset

Mian Yousaf Kaukab (1):
      netsec: restore phy power state after controller reset

Miaohe Lin (1):
      hugetlb_cgroup: fix imbalanced css_get and css_put pair for shared mappings

Michael Braun (1):
      gianfar: fix jumbo packets+napi+rx overrun crash

Michael Ellerman (1):
      powerpc/4xx: Fix build errors from mfdcr()

Michael Walle (1):
      net: phy: introduce phydev->port

Mike Rapoport (1):
      mm: memblock: fix section mismatch warning again

Mikulas Patocka (2):
      dm: don't report "detected capacity change" on device creation
      dm ioctl: fix out of bounds array access when no devices

Mimi Zohar (1):
      integrity: double check iint_cache was initialized

Muhammad Husaini Zulkifli (2):
      igc: Fix Pause Frame Advertising
      igc: Fix Supported Pause Frame Link Setting

Namhyung Kim (1):
      libbpf: Fix error path in bpf_object__elf_init()

Nick Desaulniers (1):
      gcov: fix clang-11+ support

Nicolas Ferre (1):
      ARM: dts: at91: sam9x60: fix mux-mask to match product's datasheet

Nirmoy Das (1):
      drm/amdgpu: fb BO should be ttm_bo_type_device

Nitin Rawat (1):
      scsi: ufs: ufs-qcom: Disable interrupt in reset path

Oliver Hartkopp (1):
      can: isotp: tx-path: zero initialize outgoing CAN frames

Omar Sandoval (1):
      btrfs: fix check_data_csum() error message for direct I/O

Ondrej Mosnacek (2):
      selinux: don't log MAC_POLICY_LOAD record on failed policy load
      selinux: fix variable scope issue in live sidtab conversion

Ong Boon Leong (1):
      net: phylink: Fix phylink_err() function name error in phylink_major_config

Pablo Neira Ayuso (2):
      netfilter: nftables: report EOPNOTSUPP on unsupported flowtable flags
      netfilter: nftables: allow to update flowtable flags

Parav Pandit (1):
      net/mlx5e: E-switch, Fix rate calculation division

Paul Cercueil (2):
      net: davicom: Use platform_get_irq_optional()
      irqchip/ingenic: Add support for the JZ4760

Paulo Alcantara (1):
      cifs: change noisy error message to FYI

Pavel Begunkov (2):
      io_uring: cancel deferred requests in try_cancel
      io_uring: fix provide_buffers sign extension

Pavel Tatashin (1):
      arm64: kdump: update ppos when reading elfcorehdr

Peter Zijlstra (4):
      u64_stats,lockdep: Fix u64_stats_init() vs lockdep
      static_call: Pull some static_call declarations to the type headers
      static_call: Fix the module key fixup
      static_call: Fix static_call_set_init()

Phillip Lougher (1):
      squashfs: fix xattr id and id lookup sanity checks

Potnuri Bharat Teja (1):
      RDMA/cxgb4: Fix adapter LE hash errors while destroying ipv6 listening server

Prike Liang (1):
      drm/amdgpu: fix the hibernation suspend with s0ix

Qingqing Zhuo (1):
      drm/amd/display: Enable pflip interrupt upon pipe enable

Rafael J. Wysocki (2):
      PM: runtime: Defer suspending suppliers
      ACPI: scan: Rearrange memory allocation in acpi_device_add()

Rakesh Babu (1):
      octeontx2-af: Formatting debugfs entry rsrc_alloc.

Rob Gardner (1):
      sparc64: Fix opcode filtering in handling of no fault loads

Robert Hancock (2):
      net: axienet: Fix probe error cleanup
      net: phy: broadcom: Set proper 1000BaseX/SGMII interface mode for BCM54616S

Roger Pau Monne (2):
      xen/x86: make XEN_BALLOON_MEMORY_HOTPLUG_LIMIT depend on MEMORY_HOTPLUG
      Revert "xen: fix p2m size in dom0 for disabled memory hotplug case"

Sabyrzhan Tasbolatov (1):
      fs/ext4: fix integer overflow in s_log_groups_per_flex

Sasha Levin (1):
      bpf: Don't do bpf_cgroup_storage_set() for kuprobe/tp programs

Sasha Neftin (1):
      igc: reinit_locked() should be called with rtnl_lock

Sean Christopherson (2):
      KVM: x86: Protect userspace MSR filter with SRCU, and set atomically-ish
      mm/mmu_notifiers: ensure range_end() is paired with range_start()

Sean Nyekjaer (1):
      squashfs: fix inode lookup sanity checks

Sergei Trofimovich (2):
      ia64: fix ia64_syscall_get_set_arguments() for break-based syscalls
      ia64: fix ptrace(PTRACE_SYSCALL_INFO_EXIT) sign

Shannon Nelson (1):
      ionic: linearize tso skb with too many frags

Shin'ichiro Kawasaki (1):
      dm table: Fix zoned model check and zone sectors check

Shyam Prasad N (1):
      cifs: Adjust key sizes and key generation routines for AES256 encryption

Stanislav Fomichev (1):
      bpf: Use NOP_ATOMIC5 instead of emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG

Stephane Grosjean (1):
      can: peak_usb: add forgotten supported devices

Steve French (1):
      smb3: fix cached file size problems in duplicate extents (reflink)

Subbaraya Sundeep (1):
      octeontx2-af: Remove TOS field from MKEX TX

Sudeep Holla (1):
      cpufreq: blacklist Arm Vexpress platforms in cpufreq-dt-platdev

Sung Lee (1):
      drm/amd/display: Revert dram_clock_change_latency for DCN2.1

Tal Lossos (1):
      bpf: Change inode_storage's lookup_elem return value from NULL to -EBADF

Tariq Toukan (1):
      net/mlx5e: RX, Mind the MPWQE gaps when calculating offsets

Thomas Gleixner (1):
      locking/mutex: Fix non debug version of mutex_lock_io_nested()

Thomas Hebb (1):
      z3fold: prevent reclaim/free race for headless pages

Timo Rothenpieler (1):
      nfs: fix PNFS_FLEXFILE_LAYOUT Kconfig default

Tomer Tayar (2):
      habanalabs: Call put_pid() when releasing control device
      habanalabs: Disable file operations after device is removed

Tong Zhang (6):
      atm: eni: dont release is never initialized
      atm: lanai: dont run lanai_dev_close if not open
      atm: uPD98402: fix incorrect allocation
      atm: idt77252: fix null-ptr-dereference
      can: c_can_pci: c_can_pci_remove(): fix use-after-free
      can: c_can: move runtime PM enable/disable to c_can_platform

Tony Lindgren (3):
      soc: ti: omap-prm: Fix reboot issue with invalid pcie reset map for dra7
      ARM: OMAP2+: Fix smartreflex init regression after dropping legacy data
      soc: ti: omap-prm: Fix occasional abort on reset deassert for dra7 iva

Torin Cooper-Bennun (2):
      can: m_can: m_can_do_rx_poll(): fix extraneous msg loss warning
      can: m_can: m_can_rx_peripheral(): fix RX being blocked by errors

Vegard Nossum (1):
      ACPICA: Always create namespace nodes using acpi_ns_create_node()

Vitaly Lifshits (1):
      e1000e: add rtnl_lock() to e1000_reset_task

Vladimir Oltean (1):
      net: bridge: don't notify switchdev for local FDB addresses

Wei Wang (1):
      ipv6: fix suspecious RCU usage warning

Wei Yongjun (1):
      umem: fix error return code in mm_pci_probe()

Xie He (1):
      net: hdlc_x25: Prevent racing between "x25_close" and "x25_xmit"/"x25_rx"

Xin Long (1):
      sctp: move sk_route_caps check and set into sctp_outq_flush_transports

Xunlei Pang (1):
      blk-cgroup: Fix the recursive blkg rwstat

Yang Li (1):
      gpiolib: acpi: Add missing IRQF_ONESHOT

Yinjun Zhang (1):
      netfilter: flowtable: Make sure GC works periodically in idle system

Zhan Liu (1):
      drm/amdgpu/display: Use wm_table.entries for dcn301 calculate_wm

Zqiang (1):
      bpf: Fix umd memory leak in copy_process()

dillon min (1):
      ARM: dts: imx6ull: fix ubi filesystem mount failed

satya priya (2):
      regulator: qcom-rpmh: Correct the pmic5_hfsmps515 buck
      regulator: qcom-rpmh: Use correct buck for S1C regulator

wenxu (1):
      net/sched: cls_flower: fix only mask bit check in the validate_ct_state

