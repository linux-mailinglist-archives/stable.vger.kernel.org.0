Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A88147ACC2
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237348AbhLTOqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:46:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37786 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236353AbhLTOoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:44:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 344706119E;
        Mon, 20 Dec 2021 14:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7E1C36AE7;
        Mon, 20 Dec 2021 14:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011473;
        bh=wFu+4dZFxiVTpoxTpNPvmhQN3UyWY8RFnIkXWJi5Y8Q=;
        h=From:To:Cc:Subject:Date:From;
        b=IKiI+4piVJjONYzSclMJyxY3CfGR7s5KC6gzDqq9lFnVex0wfTFiIKNmDVXjWjOdX
         MJE8Ww/LCLDHSIhLW58e4LKHzsiGKPz5GftAF8UHd0jVG/desPThXF9HI/7xANsY0F
         y47GQO3WB5zB+zlHR9QS62V/VDsroURj6pJwkEsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/71] 5.4.168-rc1 review
Date:   Mon, 20 Dec 2021 15:33:49 +0100
Message-Id: <20211220143025.683747691@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.168-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.168-rc1
X-KernelTest-Deadline: 2021-12-22T14:30+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.168 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.168-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.168-rc1

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

Leon Romanovsky <leonro@nvidia.com>
    net: sched: Fix suspicious RCU usage while accessing tcf_tunnel_info

Felix Fietkau <nbd@nbd.name>
    mac80211: fix regression in SSN handling of addba tx

Paul E. McKenney <paulmck@kernel.org>
    rcu: Mark accesses to rcu_state.n_force_qs

George Kennedy <george.kennedy@oracle.com>
    scsi: scsi_debug: Sanity check block descriptor length in resp_mode_select()

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

Nathan Chancellor <natechancellor@gmail.com>
    mwifiex: Remove unnecessary braces from HostCmd_SET_SEQ_NO_BSS_INFO

Johannes Berg <johannes.berg@intel.com>
    mac80211: validate extended element ID is present

Le Ma <le.ma@amd.com>
    drm/amdgpu: correct register access for RLC_JUMP_TABLE_RESTORE

George Kennedy <george.kennedy@oracle.com>
    libata: if T_LENGTH is zero, dma direction should be DMA_NONE

Yu Liao <liaoyu15@huawei.com>
    timekeeping: Really make sure wall_to_monotonic isn't positive

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

Jimmy Wang <wangjm221@gmail.com>
    USB: NO_LPM quirk Lenovo USB-C to Ethernet Adapher(RTL8153-04)

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: bRequestType is a bitfield, not a enum

Eric Dumazet <edumazet@google.com>
    sit: do not call ipip6_dev_free() from sit_init_net()

Florian Fainelli <f.fainelli@gmail.com>
    net: systemport: Add global locking for descriptor lifecycle

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: Prevent smc_release() from long blocking

Gal Pressman <gal@nvidia.com>
    net: Fix double 0x prefix print in SKB dump

Willem de Bruijn <willemb@google.com>
    net/packet: rx_owner_map depends on pg_vec

Haimin Zhang <tcs.kernel@gmail.com>
    netdevsim: Zero-initialize memory for new map's value in function nsim_bpf_map_alloc

Cyril Novikov <cnovikov@lynx.com>
    ixgbe: set X550 MDIO speed before talking to PHY

Letu Ren <fantasquex@gmail.com>
    igbvf: fix double free in `igbvf_probe`

Karen Sornek <karen.sornek@intel.com>
    igb: Fix removal of unicast MAC filters of VFs

Nathan Chancellor <nathan@kernel.org>
    soc/tegra: fuse: Fix bitwise vs. logical OR warning

Hangyu Hua <hbh25y@gmail.com>
    rds: memory leak in __rds_conn_create()

Baowen Zheng <baowen.zheng@corigine.com>
    flow_offload: return EOPNOTSUPP for the unsupported mpls action type

Vlad Buslov <vladbu@mellanox.com>
    net: sched: lock action when translating it to flow_action infra

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix lookup when adding AddBA extension element

Johannes Berg <johannes.berg@intel.com>
    mac80211: accept aggregation sessions on 6 GHz

Johannes Berg <johannes.berg@intel.com>
    mac80211: agg-tx: don't schedule_and_wake_txq() under sta->lock

Mordechay Goodstein <mordechay.goodstein@intel.com>
    mac80211: agg-tx: refactor sending addba

Hangbin Liu <liuhangbin@gmail.com>
    selftest/net/forwarding: declare NETIFS p9 p10

Alyssa Ross <hi@alyssa.is>
    dmaengine: st_fdma: fix MODULE_ALIAS

David Ahern <dsahern@kernel.org>
    selftests: Fix IPv6 address bind tests

David Ahern <dsahern@kernel.org>
    selftests: Fix raw socket bind tests with VRF

Eric Dumazet <edumazet@google.com>
    inet_diag: fix kernel-infoleak for UDP sockets

Eric Dumazet <edumazet@google.com>
    inet_diag: use jiffies_delta_to_msecs()

Eric Dumazet <edumazet@google.com>
    sch_cake: do not call cake_destroy() from cake_init()

Philipp Rudo <prudo@redhat.com>
    s390/kexec_file: fix error handling when applying relocations

Jie2x Zhou <jie2x.zhou@intel.com>
    selftests: net: Correct ping6 expected rc from 2 to 1

Mike Tipton <quic_mdtipton@quicinc.com>
    clk: Don't parent clks until the parent is fully registered

Dinh Nguyen <dinguyen@kernel.org>
    ARM: socfpga: dts: fix qspi node compatible

Randy Dunlap <rdunlap@infradead.org>
    hv: utils: add PTP_1588_CLOCK to Kconfig to fix build

Johannes Berg <johannes.berg@intel.com>
    mac80211: track only QoS data frames for admission control

Alex Bee <knaerzche@gmail.com>
    arm64: dts: rockchip: fix audio-supply for Rock Pi 4

John Keeping <john@metanate.com>
    arm64: dts: rockchip: fix rk3399-leez-p710 vcc3v3-lan supply

Artem Lapkin <email2tema@gmail.com>
    arm64: dts: rockchip: remove mmc-hs400-enhanced-strobe from rk3399-khadas-edge

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix use-after-free due to delegation race

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    iio: adc: stm32: fix a current leak by resetting pcsel before disabling vdda

Paul Moore <paul@paul-moore.com>
    audit: improve robustness of the audit queue handling

Joe Thornber <ejt@redhat.com>
    dm btree remove: fix use after free in rebalance_children()

Jerome Marchand <jmarchan@redhat.com>
    recordmcount.pl: look for jgnop instruction as well as bcrl on s390

Will Deacon <will@kernel.org>
    virtio_ring: Fix querying of maximum DMA mapping size for virtio device

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scpi: Fix string overflow in SCPI genpd driver

Felix Fietkau <nbd@nbd.name>
    mac80211: send ADDBA requests using the tid/queue of the aggregation session

Johannes Berg <johannes.berg@intel.com>
    mac80211: mark TX-during-stop for TX in in_reconfig

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: selftests: Make sure kvm_create_max_vcpus test won't hit RLIMIT_NOFILE


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6ull-pinfunc.h                |   2 +-
 arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dts   |   2 +-
 arch/arm/boot/dts/socfpga_arria5_socdk.dts         |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts       |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts      |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_socrates.dts    |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_sodia.dts       |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts |   4 +-
 .../boot/dts/rockchip/rk3399-khadas-edge.dtsi      |   1 -
 arch/arm64/boot/dts/rockchip/rk3399-leez-p710.dts  |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts  |   2 +-
 arch/s390/kernel/machine_kexec_file.c              |   7 +-
 drivers/ata/libata-scsi.c                          |  15 ++-
 drivers/block/xen-blkfront.c                       |  15 ++-
 drivers/clk/clk.c                                  |  15 ++-
 drivers/dma/st_fdma.c                              |   2 +-
 drivers/firmware/scpi_pm_domain.c                  |  10 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   4 +-
 drivers/hv/Kconfig                                 |   1 +
 drivers/iio/adc/stm32-adc.c                        |   1 +
 drivers/input/touchscreen/of_touchscreen.c         |  18 +--
 drivers/md/persistent-data/dm-btree-remove.c       |   2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |  16 ++-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   5 +-
 drivers/net/ethernet/broadcom/bcmsysport.h         |   1 +
 drivers/net/ethernet/intel/igb/igb_main.c          |  28 ++---
 drivers/net/ethernet/intel/igbvf/netdev.c          |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c      |   3 +
 drivers/net/netdevsim/bpf.c                        |   1 +
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |   4 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |   8 +-
 drivers/net/xen-netback/common.h                   |   1 +
 drivers/net/xen-netback/rx.c                       |  77 ++++++++-----
 drivers/net/xen-netfront.c                         | 125 ++++++++++++++++-----
 drivers/pci/msi.c                                  |  15 ++-
 drivers/scsi/scsi_debug.c                          |   4 +-
 drivers/soc/tegra/fuse/fuse-tegra.c                |   2 +-
 drivers/soc/tegra/fuse/fuse.h                      |   2 +-
 drivers/tty/hvc/hvc_xen.c                          |  30 ++++-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/gadget/composite.c                     |   6 +-
 drivers/usb/gadget/legacy/dbgp.c                   |   6 +-
 drivers/usb/gadget/legacy/inode.c                  |   6 +-
 drivers/usb/host/xhci-pci.c                        |   6 +-
 drivers/usb/serial/cp210x.c                        |   6 +-
 drivers/usb/serial/option.c                        |   8 ++
 drivers/virtio/virtio_ring.c                       |   2 +-
 fs/fuse/dir.c                                      |   2 +-
 fs/nfsd/nfs4state.c                                |   9 +-
 fs/overlayfs/dir.c                                 |   3 +-
 fs/overlayfs/overlayfs.h                           |   1 +
 fs/overlayfs/super.c                               |  12 +-
 include/net/tc_act/tc_tunnel_key.h                 |   7 +-
 kernel/audit.c                                     |  21 ++--
 kernel/rcu/tree.c                                  |  10 +-
 kernel/time/timekeeping.c                          |   3 +-
 net/core/skbuff.c                                  |   2 +-
 net/ipv4/inet_diag.c                               |  19 ++--
 net/ipv6/sit.c                                     |   1 -
 net/mac80211/agg-rx.c                              |   8 +-
 net/mac80211/agg-tx.c                              |  80 ++++++++-----
 net/mac80211/driver-ops.h                          |   5 +-
 net/mac80211/mlme.c                                |  13 ++-
 net/mac80211/sta_info.h                            |   1 +
 net/mac80211/util.c                                |   2 +
 net/packet/af_packet.c                             |   5 +-
 net/rds/connection.c                               |   1 +
 net/sched/act_sample.c                             |   2 -
 net/sched/cls_api.c                                |  18 ++-
 net/sched/sch_cake.c                               |   6 +-
 net/smc/af_smc.c                                   |   4 +-
 scripts/recordmcount.pl                            |   2 +-
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c |  30 +++++
 tools/testing/selftests/net/fcnal-test.sh          |  23 ++--
 .../net/forwarding/forwarding.config.sample        |   2 +
 76 files changed, 525 insertions(+), 250 deletions(-)


