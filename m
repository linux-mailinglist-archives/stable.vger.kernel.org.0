Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9965D47ADC3
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbhLTOzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237334AbhLTOw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:52:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61207C061376;
        Mon, 20 Dec 2021 06:47:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01B0EB80EE2;
        Mon, 20 Dec 2021 14:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C635C36AE8;
        Mon, 20 Dec 2021 14:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011638;
        bh=JPGcMCExSpJ8O+zYJ08larwwm7dYPlm2kIKoRwCNU1c=;
        h=From:To:Cc:Subject:Date:From;
        b=QmYbqEwZuNktjHG86GiEsrbGXBN1oUWUDF37NDkcLeM0CsySdDE0aSjw9Bmxukm4P
         M2sqqSe/Ctdv9JZoRuo3fQCVci/Xj9cCKJxFGmy3aIry9eIP4FAsuG7/7eZsGG++Kh
         srG2wgyIT7MjTgubnPpFBTwm3c7NMA3J/ck+kkF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/99] 5.10.88-rc1 review
Date:   Mon, 20 Dec 2021 15:33:33 +0100
Message-Id: <20211220143029.352940568@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.88-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.88-rc1
X-KernelTest-Deadline: 2021-12-22T14:30+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.88 release.
There are 99 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.88-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.88-rc1

Juergen Gross <jgross@suse.com>
    xen/netback: don't queue unlimited number of packages

Juergen Gross <jgross@suse.com>
    xen/netback: fix rx queue stall detection

Juergen Gross <jgross@suse.com>
    xen/console: harden hvc_xen against event channel storms

Juergen Gross <jgross@suse.com>
    xen/netfront: harden netfront against event channel storms

Juergen Gross <jgross@suse.com>
    xen/blkfront: harden blkfront against event channel storms

Magnus Karlsson <magnus.karlsson@intel.com>
    Revert "xsk: Do not sleep in poll() when need_wakeup set"

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix variable set but not used warning for reinit_modules

Paul E. McKenney <paulmck@kernel.org>
    rcu: Mark accesses to rcu_state.n_force_qs

George Kennedy <george.kennedy@oracle.com>
    scsi: scsi_debug: Sanity check block descriptor length in resp_mode_select()

George Kennedy <george.kennedy@oracle.com>
    scsi: scsi_debug: Fix type in min_t to avoid stack OOB

George Kennedy <george.kennedy@oracle.com>
    scsi: scsi_debug: Don't call kcalloc() if size arg is zero

Miklos Szeredi <mszeredi@redhat.com>
    ovl: fix warning in ovl_create_real()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: annotate lock in fuse_reverse_inval_entry()

Pavel Skripkin <paskripkin@gmail.com>
    media: mxl111sf: change mutex_init() location

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Do not sleep in poll() when need_wakeup set

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6ull-pinfunc: Fix CSI_DATA07__ESAI_TX0 pad name

Nathan Chancellor <nathan@kernel.org>
    Input: touchscreen - avoid bitwise vs logical OR warning

Le Ma <le.ma@amd.com>
    drm/amdgpu: correct register access for RLC_JUMP_TABLE_RESTORE

George Kennedy <george.kennedy@oracle.com>
    libata: if T_LENGTH is zero, dma direction should be DMA_NONE

Yu Liao <liaoyu15@huawei.com>
    timekeeping: Really make sure wall_to_monotonic isn't positive

Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
    serial: 8250_fintek: Fix garbled text for console

Tejun Heo <tj@kernel.org>
    iocost: Fix divide-by-zero on donation from low hweight cgroup

Naohiro Aota <naohiro.aota@wdc.com>
    zonefs: add MODULE_ALIAS_FS

Filipe Manana <fdmanana@suse.com>
    btrfs: fix double free of anon_dev after failure to create subvolume

Jianglei Nie <niejianglei2021@163.com>
    btrfs: fix memory leak in __add_inode_ref()

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FN990 compositions

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: fix CP2105 GPIO registration

Nehal Bakulchandra Shah <Nehal-Bakulchandra.shah@amd.com>
    usb: xhci: Extend support for runtime power management for AMD's Yellow carp.

Stefan Roese <sr@denx.de>
    PCI/MSI: Mask MSI-X vectors only on success

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Clear PCI_MSIX_FLAGS_MASKALL on error

Amelie Delaunay <amelie.delaunay@foss.st.com>
    usb: dwc2: fix STM ID/VBUS detection startup delay in dwc2_driver_probe

Jimmy Wang <wangjm221@gmail.com>
    USB: NO_LPM quirk Lenovo USB-C to Ethernet Adapher(RTL8153-04)

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    tty: n_hdlc: make n_hdlc_tty_wakeup() asynchronous

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Drop guest CPUID check for host initiated writes to MSR_IA32_PERF_CAPABILITIES

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: early: convert to readl_poll_timeout_atomic()"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: bRequestType is a bitfield, not a enum

Xiaoming Ni <nixiaoming@huawei.com>
    powerpc/85xx: Fix oops when CONFIG_FSL_PMC=n

Martin KaFai Lau <kafai@fb.com>
    bpf, selftests: Fix racing issue in btf_skc_cls_ingress test

Eric Dumazet <edumazet@google.com>
    sit: do not call ipip6_dev_free() from sit_init_net()

Florian Fainelli <f.fainelli@gmail.com>
    net: systemport: Add global locking for descriptor lifecycle

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: Prevent smc_release() from long blocking

Gal Pressman <gal@nvidia.com>
    net: Fix double 0x prefix print in SKB dump

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    sfc_ef100: potential dereference of null pointer

Willem de Bruijn <willemb@google.com>
    net/packet: rx_owner_map depends on pg_vec

Haimin Zhang <tcs.kernel@gmail.com>
    netdevsim: Zero-initialize memory for new map's value in function nsim_bpf_map_alloc

Cyril Novikov <cnovikov@lynx.com>
    ixgbe: set X550 MDIO speed before talking to PHY

Robert Schlabbach <robert_s@gmx.net>
    ixgbe: Document how to enable NBASE-T support

Sasha Neftin <sasha.neftin@intel.com>
    igc: Fix typo in i225 LTR functions

Letu Ren <fantasquex@gmail.com>
    igbvf: fix double free in `igbvf_probe`

Karen Sornek <karen.sornek@intel.com>
    igb: Fix removal of unicast MAC filters of VFs

Nathan Chancellor <nathan@kernel.org>
    soc/tegra: fuse: Fix bitwise vs. logical OR warning

Florian Westphal <fw@strlen.de>
    mptcp: clear 'kern' flag from fallback sockets

Lang Yu <lang.yu@amd.com>
    drm/amd/pm: fix a potential gpu_metrics_table memory leak

Hangyu Hua <hbh25y@gmail.com>
    rds: memory leak in __rds_conn_create()

Baowen Zheng <baowen.zheng@corigine.com>
    flow_offload: return EOPNOTSUPP for the unsupported mpls action type

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix lookup when adding AddBA extension element

Johannes Berg <johannes.berg@intel.com>
    mac80211: agg-tx: don't schedule_and_wake_txq() under sta->lock

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/ast: potential dereference of null pointer

Hangbin Liu <liuhangbin@gmail.com>
    selftest/net/forwarding: declare NETIFS p9 p10

Davide Caratti <dcaratti@redhat.com>
    net/sched: sch_ets: don't remove idle classes from the round-robin list

Alyssa Ross <hi@alyssa.is>
    dmaengine: st_fdma: fix MODULE_ALIAS

David Ahern <dsahern@kernel.org>
    selftests: Fix IPv6 address bind tests

David Ahern <dsahern@kernel.org>
    selftests: Fix raw socket bind tests with VRF

David Ahern <dsahern@kernel.org>
    selftests: Add duplicate config only for MD5 VRF tests

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix use-after-free bug in hclgevf_send_mbx_msg

Eric Dumazet <edumazet@google.com>
    inet_diag: fix kernel-infoleak for UDP sockets

Eric Dumazet <edumazet@google.com>
    sch_cake: do not call cake_destroy() from cake_init()

Philipp Rudo <prudo@redhat.com>
    s390/kexec_file: fix error handling when applying relocations

Jie2x Zhou <jie2x.zhou@intel.com>
    selftests: net: Correct ping6 expected rc from 2 to 1

Wei Wang <wei.w.wang@intel.com>
    virtio/vsock: fix the transport to work with VMADDR_CID_ANY

Stephan Gerhold <stephan@gerhold.net>
    soc: imx: Register SoC device only on i.MX boards

Mike Tipton <quic_mdtipton@quicinc.com>
    clk: Don't parent clks until the parent is fully registered

Dinh Nguyen <dinguyen@kernel.org>
    ARM: socfpga: dts: fix qspi node compatible

Xiubo Li <xiubli@redhat.com>
    ceph: initialize pathlen variable in reconnect_caps_cb

Hu Weiwen <sehuww@mail.scut.edu.cn>
    ceph: fix duplicate increment of opened_inodes metric

Dan Carpenter <dan.carpenter@oracle.com>
    tee: amdtee: fix an IS_ERR() vs NULL bug

Randy Dunlap <rdunlap@infradead.org>
    hv: utils: add PTP_1588_CLOCK to Kconfig to fix build

Johannes Berg <johannes.berg@intel.com>
    mac80211: track only QoS data frames for admission control

Alex Bee <knaerzche@gmail.com>
    arm64: dts: rockchip: fix audio-supply for Rock Pi 4

John Keeping <john@metanate.com>
    arm64: dts: rockchip: fix rk3399-leez-p710 vcc3v3-lan supply

John Keeping <john@metanate.com>
    arm64: dts: rockchip: fix rk3308-roc-cc vcc-sd supply

Artem Lapkin <email2tema@gmail.com>
    arm64: dts: rockchip: remove mmc-hs400-enhanced-strobe from rk3399-khadas-edge

Fabio Estevam <festevam@gmail.com>
    arm64: dts: imx8mp-evk: Improve the Ethernet PHY description

Joakim Zhang <qiangqing.zhang@nxp.com>
    arm64: dts: imx8m: correct assigned clocks for FEC

Paul Moore <paul@paul-moore.com>
    audit: improve robustness of the audit queue handling

Joe Thornber <ejt@redhat.com>
    dm btree remove: fix use after free in rebalance_children()

Jerome Marchand <jmarchan@redhat.com>
    recordmcount.pl: look for jgnop instruction as well as bcrl on s390

Dan Carpenter <dan.carpenter@oracle.com>
    vdpa: check that offsets are within bounds

Will Deacon <will@kernel.org>
    virtio_ring: Fix querying of maximum DMA mapping size for virtio device

Daniel Borkmann <daniel@iogearbox.net>
    bpf, selftests: Add test case trying to taint map value pointer

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Make 32->64 bounds propagation slightly more robust

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix signed bounds propagation after mov32

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scpi: Fix string overflow in SCPI genpd driver

Johannes Berg <johannes.berg@intel.com>
    mac80211: validate extended element ID is present

Felix Fietkau <nbd@nbd.name>
    mac80211: send ADDBA requests using the tid/queue of the aggregation session

Johannes Berg <johannes.berg@intel.com>
    mac80211: mark TX-during-stop for TX in in_reconfig

Felix Fietkau <nbd@nbd.name>
    mac80211: fix regression in SSN handling of addba tx

Paolo Bonzini <pbonzini@redhat.com>
    KVM: downgrade two BUG_ONs to WARN_ON_ONCE

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: selftests: Make sure kvm_create_max_vcpus test won't hit RLIMIT_NOFILE


-------------

Diffstat:

 .../device_drivers/ethernet/intel/ixgbe.rst        |  16 +++
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6ull-pinfunc.h                |   2 +-
 arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dts   |   2 +-
 arch/arm/boot/dts/socfpga_arria5_socdk.dts         |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts       |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts      |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_socrates.dts    |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_sodia.dts       |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts |   4 +-
 arch/arm64/boot/dts/freescale/imx8mm.dtsi          |   7 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi          |   7 +-
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts       |   2 +
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |   7 +-
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts     |   2 +-
 .../boot/dts/rockchip/rk3399-khadas-edge.dtsi      |   1 -
 arch/arm64/boot/dts/rockchip/rk3399-leez-p710.dts  |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi |   2 +-
 arch/powerpc/platforms/85xx/smp.c                  |   4 +-
 arch/s390/kernel/machine_kexec_file.c              |   7 +-
 arch/x86/kvm/x86.c                                 |   2 +-
 block/blk-iocost.c                                 |   9 +-
 drivers/ata/libata-scsi.c                          |  15 ++-
 drivers/block/xen-blkfront.c                       |  15 ++-
 drivers/bus/ti-sysc.c                              |   3 +-
 drivers/clk/clk.c                                  |  15 ++-
 drivers/dma/st_fdma.c                              |   2 +-
 drivers/firmware/scpi_pm_domain.c                  |  10 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   4 +-
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c     |   3 +
 drivers/gpu/drm/ast/ast_mode.c                     |   5 +-
 drivers/hv/Kconfig                                 |   1 +
 drivers/input/touchscreen/of_touchscreen.c         |  42 +++----
 drivers/md/persistent-data/dm-btree-remove.c       |   2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |  16 ++-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   5 +-
 drivers/net/ethernet/broadcom/bcmsysport.h         |   1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |   3 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  28 ++---
 drivers/net/ethernet/intel/igbvf/netdev.c          |   1 +
 drivers/net/ethernet/intel/igc/igc_i225.c          |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   4 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c      |   3 +
 drivers/net/ethernet/sfc/ef100_nic.c               |   3 +
 drivers/net/netdevsim/bpf.c                        |   1 +
 drivers/net/xen-netback/common.h                   |   1 +
 drivers/net/xen-netback/rx.c                       |  77 ++++++++-----
 drivers/net/xen-netfront.c                         | 125 ++++++++++++++++-----
 drivers/pci/msi.c                                  |  15 ++-
 drivers/scsi/scsi_debug.c                          |  42 ++++---
 drivers/soc/imx/soc-imx.c                          |   4 +
 drivers/soc/tegra/fuse/fuse-tegra.c                |   2 +-
 drivers/soc/tegra/fuse/fuse.h                      |   2 +-
 drivers/tee/amdtee/core.c                          |   5 +-
 drivers/tty/hvc/hvc_xen.c                          |  30 ++++-
 drivers/tty/n_hdlc.c                               |  23 +++-
 drivers/tty/serial/8250/8250_fintek.c              |  20 ----
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc2/platform.c                        |   3 +
 drivers/usb/early/xhci-dbc.c                       |  15 ++-
 drivers/usb/gadget/composite.c                     |   6 +-
 drivers/usb/gadget/legacy/dbgp.c                   |   6 +-
 drivers/usb/gadget/legacy/inode.c                  |   6 +-
 drivers/usb/host/xhci-pci.c                        |   6 +-
 drivers/usb/serial/cp210x.c                        |   6 +-
 drivers/usb/serial/option.c                        |   8 ++
 drivers/vhost/vdpa.c                               |   2 +-
 drivers/virtio/virtio_ring.c                       |   2 +-
 fs/btrfs/disk-io.c                                 |   8 ++
 fs/btrfs/tree-log.c                                |   1 +
 fs/ceph/caps.c                                     |  16 +--
 fs/ceph/mds_client.c                               |   3 +-
 fs/fuse/dir.c                                      |   2 +-
 fs/overlayfs/dir.c                                 |   3 +-
 fs/overlayfs/overlayfs.h                           |   1 +
 fs/overlayfs/super.c                               |  12 +-
 fs/zonefs/super.c                                  |   1 +
 kernel/audit.c                                     |  21 ++--
 kernel/bpf/verifier.c                              |  28 +++--
 kernel/rcu/tree.c                                  |  10 +-
 kernel/time/timekeeping.c                          |   3 +-
 net/core/skbuff.c                                  |   2 +-
 net/ipv4/inet_diag.c                               |   4 +-
 net/ipv6/sit.c                                     |   1 -
 net/mac80211/agg-rx.c                              |   5 +-
 net/mac80211/agg-tx.c                              |  16 ++-
 net/mac80211/driver-ops.h                          |   5 +-
 net/mac80211/mlme.c                                |  13 ++-
 net/mac80211/sta_info.h                            |   1 +
 net/mac80211/util.c                                |   7 +-
 net/mptcp/protocol.c                               |   4 +-
 net/packet/af_packet.c                             |   5 +-
 net/rds/connection.c                               |   1 +
 net/sched/cls_api.c                                |   1 +
 net/sched/sch_cake.c                               |   6 +-
 net/sched/sch_ets.c                                |   4 +-
 net/smc/af_smc.c                                   |   4 +-
 net/vmw_vsock/virtio_transport_common.c            |   3 +-
 scripts/recordmcount.pl                            |   2 +-
 .../selftests/bpf/prog_tests/btf_skc_cls_ingress.c |  16 ++-
 .../selftests/bpf/verifier/value_ptr_arith.c       |  23 ++++
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c |  30 +++++
 tools/testing/selftests/net/fcnal-test.sh          |  49 +++++---
 .../net/forwarding/forwarding.config.sample        |   2 +
 virt/kvm/kvm_main.c                                |   6 +-
 105 files changed, 697 insertions(+), 305 deletions(-)


