Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B319147CEAA
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 10:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243661AbhLVJDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 04:03:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35068 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243678AbhLVJDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 04:03:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A2CA61949;
        Wed, 22 Dec 2021 09:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E99C36AE5;
        Wed, 22 Dec 2021 09:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640163800;
        bh=De7Yxwa/PndDN/MoAXC2fK73vLYoA8j+qRzB2joMCTo=;
        h=From:To:Cc:Subject:Date:From;
        b=RP3Wk3hwyscMqjcfrKMARRay/5I87y9Ptf3Wd9igA8IiT24gQh15p1EwRoktud0zJ
         vAOahb9hj7RRPNZjrZOfJRvTCc0D9M9H6yuKvpR73JGsw0rowyb1SdbCMrF7GSKyIL
         VKnmm0IeCk3vRPBBMOFlA3CxirhYmoHTdKDdzhpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.88
Date:   Wed, 22 Dec 2021 10:03:08 +0100
Message-Id: <1640163789391@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.88 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst |   16 +
 Makefile                                                         |    2 
 arch/arm/boot/dts/imx6ull-pinfunc.h                              |    2 
 arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dts                 |    2 
 arch/arm/boot/dts/socfpga_arria5_socdk.dts                       |    2 
 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts                     |    2 
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts                    |    2 
 arch/arm/boot/dts/socfpga_cyclone5_socrates.dts                  |    2 
 arch/arm/boot/dts/socfpga_cyclone5_sodia.dts                     |    2 
 arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts               |    4 
 arch/arm64/boot/dts/freescale/imx8mm.dtsi                        |    7 
 arch/arm64/boot/dts/freescale/imx8mn.dtsi                        |    7 
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts                     |    2 
 arch/arm64/boot/dts/freescale/imx8mp.dtsi                        |    7 
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts                   |    2 
 arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi             |    1 
 arch/arm64/boot/dts/rockchip/rk3399-leez-p710.dts                |    2 
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi               |    2 
 arch/powerpc/platforms/85xx/smp.c                                |    4 
 arch/s390/kernel/machine_kexec_file.c                            |    7 
 arch/x86/kvm/x86.c                                               |    2 
 block/blk-iocost.c                                               |    9 
 drivers/ata/libata-scsi.c                                        |   15 +
 drivers/block/xen-blkfront.c                                     |   15 -
 drivers/bus/ti-sysc.c                                            |    3 
 drivers/clk/clk.c                                                |   15 -
 drivers/dma/st_fdma.c                                            |    2 
 drivers/firmware/scpi_pm_domain.c                                |   10 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                            |    4 
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c                   |    3 
 drivers/gpu/drm/ast/ast_mode.c                                   |    5 
 drivers/input/touchscreen/of_touchscreen.c                       |   42 +--
 drivers/md/persistent-data/dm-btree-remove.c                     |    2 
 drivers/media/usb/dvb-usb-v2/mxl111sf.c                          |   16 +
 drivers/net/ethernet/broadcom/bcmsysport.c                       |    5 
 drivers/net/ethernet/broadcom/bcmsysport.h                       |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c         |    3 
 drivers/net/ethernet/intel/igb/igb_main.c                        |   28 +-
 drivers/net/ethernet/intel/igbvf/netdev.c                        |    1 
 drivers/net/ethernet/intel/igc/igc_i225.c                        |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                    |    4 
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c                    |    3 
 drivers/net/ethernet/sfc/ef100_nic.c                             |    3 
 drivers/net/netdevsim/bpf.c                                      |    1 
 drivers/net/xen-netback/common.h                                 |    1 
 drivers/net/xen-netback/rx.c                                     |   77 +++---
 drivers/net/xen-netfront.c                                       |  125 +++++++---
 drivers/pci/msi.c                                                |   15 -
 drivers/scsi/scsi_debug.c                                        |   42 ++-
 drivers/soc/imx/soc-imx.c                                        |    4 
 drivers/soc/tegra/fuse/fuse-tegra.c                              |    2 
 drivers/soc/tegra/fuse/fuse.h                                    |    2 
 drivers/tee/amdtee/core.c                                        |    5 
 drivers/tty/hvc/hvc_xen.c                                        |   30 ++
 drivers/tty/n_hdlc.c                                             |   23 +
 drivers/tty/serial/8250/8250_fintek.c                            |   20 -
 drivers/usb/core/quirks.c                                        |    3 
 drivers/usb/dwc2/platform.c                                      |    3 
 drivers/usb/early/xhci-dbc.c                                     |   15 -
 drivers/usb/gadget/composite.c                                   |    6 
 drivers/usb/gadget/legacy/dbgp.c                                 |    6 
 drivers/usb/gadget/legacy/inode.c                                |    6 
 drivers/usb/host/xhci-pci.c                                      |    6 
 drivers/usb/serial/cp210x.c                                      |    6 
 drivers/usb/serial/option.c                                      |    8 
 drivers/vhost/vdpa.c                                             |    2 
 drivers/virtio/virtio_ring.c                                     |    2 
 fs/btrfs/disk-io.c                                               |    8 
 fs/btrfs/tree-log.c                                              |    1 
 fs/ceph/caps.c                                                   |   16 -
 fs/ceph/mds_client.c                                             |    3 
 fs/fuse/dir.c                                                    |    2 
 fs/overlayfs/dir.c                                               |    3 
 fs/overlayfs/overlayfs.h                                         |    1 
 fs/overlayfs/super.c                                             |   12 
 fs/zonefs/super.c                                                |    1 
 kernel/audit.c                                                   |   21 -
 kernel/bpf/verifier.c                                            |   28 +-
 kernel/rcu/tree.c                                                |   10 
 kernel/time/timekeeping.c                                        |    3 
 net/core/skbuff.c                                                |    2 
 net/ipv4/inet_diag.c                                             |    4 
 net/ipv6/sit.c                                                   |    1 
 net/mac80211/agg-rx.c                                            |    5 
 net/mac80211/agg-tx.c                                            |   16 -
 net/mac80211/driver-ops.h                                        |    5 
 net/mac80211/mlme.c                                              |   13 -
 net/mac80211/sta_info.h                                          |    1 
 net/mac80211/util.c                                              |    7 
 net/mptcp/protocol.c                                             |    4 
 net/packet/af_packet.c                                           |    5 
 net/rds/connection.c                                             |    1 
 net/sched/cls_api.c                                              |    1 
 net/sched/sch_cake.c                                             |    6 
 net/sched/sch_ets.c                                              |    4 
 net/smc/af_smc.c                                                 |    4 
 net/vmw_vsock/virtio_transport_common.c                          |    3 
 scripts/recordmcount.pl                                          |    2 
 tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c     |   16 +
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c           |   23 +
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c               |   30 ++
 tools/testing/selftests/net/fcnal-test.sh                        |   49 ++-
 tools/testing/selftests/net/forwarding/forwarding.config.sample  |    2 
 virt/kvm/kvm_main.c                                              |    6 
 104 files changed, 695 insertions(+), 304 deletions(-)

Alex Bee (1):
      arm64: dts: rockchip: fix audio-supply for Rock Pi 4

Alyssa Ross (1):
      dmaengine: st_fdma: fix MODULE_ALIAS

Amelie Delaunay (1):
      usb: dwc2: fix STM ID/VBUS detection startup delay in dwc2_driver_probe

Artem Lapkin (1):
      arm64: dts: rockchip: remove mmc-hs400-enhanced-strobe from rk3399-khadas-edge

Baowen Zheng (1):
      flow_offload: return EOPNOTSUPP for the unsupported mpls action type

Cyril Novikov (1):
      ixgbe: set X550 MDIO speed before talking to PHY

D. Wythe (1):
      net/smc: Prevent smc_release() from long blocking

Dan Carpenter (2):
      vdpa: check that offsets are within bounds
      tee: amdtee: fix an IS_ERR() vs NULL bug

Daniel Borkmann (3):
      bpf: Fix signed bounds propagation after mov32
      bpf: Make 32->64 bounds propagation slightly more robust
      bpf, selftests: Add test case trying to taint map value pointer

Daniele Palmas (1):
      USB: serial: option: add Telit FN990 compositions

David Ahern (3):
      selftests: Add duplicate config only for MD5 VRF tests
      selftests: Fix raw socket bind tests with VRF
      selftests: Fix IPv6 address bind tests

Davide Caratti (1):
      net/sched: sch_ets: don't remove idle classes from the round-robin list

Dinh Nguyen (1):
      ARM: socfpga: dts: fix qspi node compatible

Eric Dumazet (3):
      sch_cake: do not call cake_destroy() from cake_init()
      inet_diag: fix kernel-infoleak for UDP sockets
      sit: do not call ipip6_dev_free() from sit_init_net()

Fabio Estevam (2):
      arm64: dts: imx8mp-evk: Improve the Ethernet PHY description
      ARM: dts: imx6ull-pinfunc: Fix CSI_DATA07__ESAI_TX0 pad name

Felix Fietkau (2):
      mac80211: fix regression in SSN handling of addba tx
      mac80211: send ADDBA requests using the tid/queue of the aggregation session

Filipe Manana (1):
      btrfs: fix double free of anon_dev after failure to create subvolume

Florian Fainelli (1):
      net: systemport: Add global locking for descriptor lifecycle

Florian Westphal (1):
      mptcp: clear 'kern' flag from fallback sockets

Gal Pressman (1):
      net: Fix double 0x prefix print in SKB dump

George Kennedy (4):
      libata: if T_LENGTH is zero, dma direction should be DMA_NONE
      scsi: scsi_debug: Don't call kcalloc() if size arg is zero
      scsi: scsi_debug: Fix type in min_t to avoid stack OOB
      scsi: scsi_debug: Sanity check block descriptor length in resp_mode_select()

Greg Kroah-Hartman (3):
      USB: gadget: bRequestType is a bitfield, not a enum
      Revert "usb: early: convert to readl_poll_timeout_atomic()"
      Linux 5.10.88

Haimin Zhang (1):
      netdevsim: Zero-initialize memory for new map's value in function nsim_bpf_map_alloc

Hangbin Liu (1):
      selftest/net/forwarding: declare NETIFS p9 p10

Hangyu Hua (1):
      rds: memory leak in __rds_conn_create()

Hu Weiwen (1):
      ceph: fix duplicate increment of opened_inodes metric

Jerome Marchand (1):
      recordmcount.pl: look for jgnop instruction as well as bcrl on s390

Ji-Ze Hong (Peter Hong) (1):
      serial: 8250_fintek: Fix garbled text for console

Jianglei Nie (1):
      btrfs: fix memory leak in __add_inode_ref()

Jiasheng Jiang (2):
      drm/ast: potential dereference of null pointer
      sfc_ef100: potential dereference of null pointer

Jie Wang (1):
      net: hns3: fix use-after-free bug in hclgevf_send_mbx_msg

Jie2x Zhou (1):
      selftests: net: Correct ping6 expected rc from 2 to 1

Jimmy Wang (1):
      USB: NO_LPM quirk Lenovo USB-C to Ethernet Adapher(RTL8153-04)

Joakim Zhang (1):
      arm64: dts: imx8m: correct assigned clocks for FEC

Joe Thornber (1):
      dm btree remove: fix use after free in rebalance_children()

Johan Hovold (1):
      USB: serial: cp210x: fix CP2105 GPIO registration

Johannes Berg (5):
      mac80211: mark TX-during-stop for TX in in_reconfig
      mac80211: validate extended element ID is present
      mac80211: track only QoS data frames for admission control
      mac80211: agg-tx: don't schedule_and_wake_txq() under sta->lock
      mac80211: fix lookup when adding AddBA extension element

John Keeping (2):
      arm64: dts: rockchip: fix rk3308-roc-cc vcc-sd supply
      arm64: dts: rockchip: fix rk3399-leez-p710 vcc3v3-lan supply

Juergen Gross (5):
      xen/blkfront: harden blkfront against event channel storms
      xen/netfront: harden netfront against event channel storms
      xen/console: harden hvc_xen against event channel storms
      xen/netback: fix rx queue stall detection
      xen/netback: don't queue unlimited number of packages

Karen Sornek (1):
      igb: Fix removal of unicast MAC filters of VFs

Lang Yu (1):
      drm/amd/pm: fix a potential gpu_metrics_table memory leak

Le Ma (1):
      drm/amdgpu: correct register access for RLC_JUMP_TABLE_RESTORE

Letu Ren (1):
      igbvf: fix double free in `igbvf_probe`

Magnus Karlsson (2):
      xsk: Do not sleep in poll() when need_wakeup set
      Revert "xsk: Do not sleep in poll() when need_wakeup set"

Martin KaFai Lau (1):
      bpf, selftests: Fix racing issue in btf_skc_cls_ingress test

Mike Tipton (1):
      clk: Don't parent clks until the parent is fully registered

Miklos Szeredi (2):
      fuse: annotate lock in fuse_reverse_inval_entry()
      ovl: fix warning in ovl_create_real()

Naohiro Aota (1):
      zonefs: add MODULE_ALIAS_FS

Nathan Chancellor (2):
      soc/tegra: fuse: Fix bitwise vs. logical OR warning
      Input: touchscreen - avoid bitwise vs logical OR warning

Nehal Bakulchandra Shah (1):
      usb: xhci: Extend support for runtime power management for AMD's Yellow carp.

Paolo Bonzini (1):
      KVM: downgrade two BUG_ONs to WARN_ON_ONCE

Paul E. McKenney (1):
      rcu: Mark accesses to rcu_state.n_force_qs

Paul Moore (1):
      audit: improve robustness of the audit queue handling

Pavel Skripkin (1):
      media: mxl111sf: change mutex_init() location

Philipp Rudo (1):
      s390/kexec_file: fix error handling when applying relocations

Robert Schlabbach (1):
      ixgbe: Document how to enable NBASE-T support

Sasha Neftin (1):
      igc: Fix typo in i225 LTR functions

Stefan Roese (1):
      PCI/MSI: Mask MSI-X vectors only on success

Stephan Gerhold (1):
      soc: imx: Register SoC device only on i.MX boards

Sudeep Holla (1):
      firmware: arm_scpi: Fix string overflow in SCPI genpd driver

Tejun Heo (1):
      iocost: Fix divide-by-zero on donation from low hweight cgroup

Tetsuo Handa (1):
      tty: n_hdlc: make n_hdlc_tty_wakeup() asynchronous

Thomas Gleixner (1):
      PCI/MSI: Clear PCI_MSIX_FLAGS_MASKALL on error

Tony Lindgren (1):
      bus: ti-sysc: Fix variable set but not used warning for reinit_modules

Vitaly Kuznetsov (2):
      KVM: selftests: Make sure kvm_create_max_vcpus test won't hit RLIMIT_NOFILE
      KVM: x86: Drop guest CPUID check for host initiated writes to MSR_IA32_PERF_CAPABILITIES

Wei Wang (1):
      virtio/vsock: fix the transport to work with VMADDR_CID_ANY

Will Deacon (1):
      virtio_ring: Fix querying of maximum DMA mapping size for virtio device

Willem de Bruijn (1):
      net/packet: rx_owner_map depends on pg_vec

Xiaoming Ni (1):
      powerpc/85xx: Fix oops when CONFIG_FSL_PMC=n

Xiubo Li (1):
      ceph: initialize pathlen variable in reconnect_caps_cb

Yu Liao (1):
      timekeeping: Really make sure wall_to_monotonic isn't positive

