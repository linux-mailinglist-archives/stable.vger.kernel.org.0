Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EF047AF02
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbhLTPHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238809AbhLTPFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:05:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32CFC09B13C;
        Mon, 20 Dec 2021 06:53:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 212D561196;
        Mon, 20 Dec 2021 14:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BC8C36AE7;
        Mon, 20 Dec 2021 14:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011980;
        bh=BAjvcyPuYp9kcJ0dYo7hL+a1WN96zmUu6NnKx1ebqug=;
        h=From:To:Cc:Subject:Date:From;
        b=ybJXnVrTJ1qLJAPyF86yKyauFrz5b6bpeKbjQKsHUPP3MM1GIpaJWybdgYXEDfZvk
         hV/qyCoBCnwtxukKqDZ3/zXWVf66noXj5RsF9jkVIH0XDlL1N0M1Jp4Xm7tBJQ+wwP
         IzNBaV8zbuOPTAK73Z2rCw8khvsNNfVhf/+0HC90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.15 000/177] 5.15.11-rc1 review
Date:   Mon, 20 Dec 2021 15:32:30 +0100
Message-Id: <20211220143040.058287525@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.11-rc1
X-KernelTest-Deadline: 2021-12-22T14:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.11 release.
There are 177 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.11-rc1

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

SeongJae Park <sj@kernel.org>
    selftests/damon: test debugfs file reads/writes with huge count

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix variable set but not used warning for reinit_modules

Jens Axboe <axboe@kernel.dk>
    io-wq: drop wqe lock before creating new worker

Paul E. McKenney <paulmck@kernel.org>
    rcu: Mark accesses to rcu_state.n_force_qs

Jens Axboe <axboe@kernel.dk>
    io-wq: check for wq exit after adding new worker task_work

Jens Axboe <axboe@kernel.dk>
    io-wq: remove spurious bit clear on task_work addition

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

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Make do_proc_control() and do_proc_bulk() killable

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix extable address check.

Jie Meng <jmeng@fb.com>
    bpf, x64: Factor out emission of REX byte in more cases

Matthieu Baerts <matthieu.baerts@tessares.net>
    mptcp: add missing documented NL params

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Do not sleep in poll() when need_wakeup set

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6ull-pinfunc: Fix CSI_DATA07__ESAI_TX0 pad name

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    can: m_can: pci: use custom bit timings for Elkhart Lake

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    can: m_can: make custom bittiming fields const

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    Revert "can: m_can: remove support for custom bit timing"

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/pm: fix reading SMU FW version from amdgpu_firmware_info on YC

Hawking Zhang <Hawking.Zhang@amd.com>
    drm/amdgpu: don't override default ECO_BITs setting

Le Ma <le.ma@amd.com>
    drm/amdgpu: correct register access for RLC_JUMP_TABLE_RESTORE

Russell Currey <ruscur@russell.cc>
    powerpc/module_64: Fix livepatching for RO modules

George Kennedy <george.kennedy@oracle.com>
    libata: if T_LENGTH is zero, dma direction should be DMA_NONE

Adrian Hunter <adrian.hunter@intel.com>
    perf inject: Fix segfault due to perf_data__fd() without open

Adrian Hunter <adrian.hunter@intel.com>
    perf inject: Fix segfault due to close without open

Bin Meng <bin.meng@windriver.com>
    riscv: dts: unmatched: Add gpio card detect to mmc-spi-slot

Bin Meng <bin.meng@windriver.com>
    riscv: dts: unleashed: Add gpio card detect to mmc-spi-slot

Zqiang <qiang1.zhang@intel.com>
    locking/rtmutex: Fix incorrect condition in rtmutex_spin_on_owner()

Thiago Rafael Becker <trbecker@gmail.com>
    cifs: sanitize multiple delimiters in prepath

Yu Liao <liaoyu15@huawei.com>
    timekeeping: Really make sure wall_to_monotonic isn't positive

Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
    serial: 8250_fintek: Fix garbled text for console

Tejun Heo <tj@kernel.org>
    iocost: Fix divide-by-zero on donation from low hweight cgroup

Naohiro Aota <naohiro.aota@wdc.com>
    zonefs: add MODULE_ALIAS_FS

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    btrfs: fix missing blkdev_put() call in btrfs_scan_one_device()

Josef Bacik <josef@toxicpanda.com>
    btrfs: check WRITE_ERR when trying to read an extent buffer

Filipe Manana <fdmanana@suse.com>
    btrfs: fix double free of anon_dev after failure to create subvolume

Jianglei Nie <niejianglei2021@163.com>
    btrfs: fix memory leak in __add_inode_ref()

Scott Mayhew <smayhew@redhat.com>
    selinux: fix sleeping function called from invalid context

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FN990 compositions

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: fix CP2105 GPIO registration

Marian Postevca <posteuca@mutex.one>
    usb: gadget: u_ether: fix race in setting MAC address in setup phase

Xu Yang <xu.yang_2@nxp.com>
    usb: typec: tcpm: fix tcpm unregister port but leave a pending timer

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix lack of spin_lock_irqsave/spin_lock_restore

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix issue in cdnsp_log_ep trace event

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix incorrect calling of cdnsp_died function

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix incorrect status for control request

Nehal Bakulchandra Shah <Nehal-Bakulchandra.shah@amd.com>
    usb: xhci: Extend support for runtime power management for AMD's Yellow carp.

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix list_del warning when enable list debug

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

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix extable fixup offset.

Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
    arm64: kexec: Fix missing error code 'ret' warning in load_other_segments()

David Howells <dhowells@redhat.com>
    afs: Fix mmap

Eric Dumazet <edumazet@google.com>
    sit: do not call ipip6_dev_free() from sit_init_net()

Florian Fainelli <f.fainelli@gmail.com>
    net: systemport: Add global locking for descriptor lifecycle

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: Prevent smc_release() from long blocking

Gal Pressman <gal@nvidia.com>
    net: Fix double 0x prefix print in SKB dump

Andrey Eremeev <Axtone4all@yandex.ru>
    dsa: mv88e6xxx: fix debug print for SPEED_UNFORCED

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    sfc_ef100: potential dereference of null pointer

John Keeping <john@metanate.com>
    net: stmmac: dwmac-rk: fix oob read in rk_gmac_setup

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

Maxim Galaganov <max@internet.ru>
    mptcp: fix deadlock in __mptcp_push_pending()

Florian Westphal <fw@strlen.de>
    mptcp: clear 'kern' flag from fallback sockets

Florian Westphal <fw@strlen.de>
    mptcp: remove tcp ulp setsockopt support

Lang Yu <lang.yu@amd.com>
    drm/amd/pm: fix a potential gpu_metrics_table memory leak

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Set exit_optimized_pwr_state for DCN31

Karol Kolacinski <karol.kolacinski@intel.com>
    ice: Don't put stale timestamps in the skb

Karol Kolacinski <karol.kolacinski@intel.com>
    ice: Use div64_u64 instead of div_u64 in adjfine

Hangyu Hua <hbh25y@gmail.com>
    rds: memory leak in __rds_conn_create()

Baowen Zheng <baowen.zheng@corigine.com>
    flow_offload: return EOPNOTSUPP for the unsupported mpls action type

Ong Boon Leong <boon.leong.ong@intel.com>
    net: stmmac: fix tc flower deletion for VLAN priority Rx steering

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix lookup when adding AddBA extension element

Ilan Peer <ilan.peer@intel.com>
    cfg80211: Acquire wiphy mutex on regulatory work

Johannes Berg <johannes.berg@intel.com>
    mac80211: agg-tx: don't schedule_and_wake_txq() under sta->lock

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    drm/i915/display: Fix an unsigned subtraction which can never be negative.

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/ast: potential dereference of null pointer

Paolo Abeni <pabeni@redhat.com>
    mptcp: never allow the PM to close a listener subflow

Hangbin Liu <liuhangbin@gmail.com>
    selftest/net/forwarding: declare NETIFS p9 p10

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: Unforce speed & duplex in mac_link_down()

Willem de Bruijn <willemb@google.com>
    selftests/net: toeplitz: fix udp option

Davide Caratti <dcaratti@redhat.com>
    net/sched: sch_ets: don't remove idle classes from the round-robin list

Alejandro Concepcion-Rodriguez <asconcepcion@acoro.eu>
    drm: simpledrm: fix wrong unit with pixel clock

Alyssa Ross <hi@alyssa.is>
    dmaengine: st_fdma: fix MODULE_ALIAS

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix missed completion on abort path

David Ahern <dsahern@kernel.org>
    selftests: Fix IPv6 address bind tests

David Ahern <dsahern@kernel.org>
    selftests: Fix raw socket bind tests with VRF

David Ahern <dsahern@kernel.org>
    selftests: Add duplicate config only for MD5 VRF tests

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: fix race condition in debugfs

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix use-after-free bug in hclgevf_send_mbx_msg

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: icmp_redirect: pass xfail=0 to log_test()

Filip Pokryvka <fpokryvk@redhat.com>
    netdevsim: don't overwrite read only ethtool parms

Eric Dumazet <edumazet@google.com>
    inet_diag: fix kernel-infoleak for UDP sockets

Eric Dumazet <edumazet@google.com>
    sch_cake: do not call cake_destroy() from cake_init()

Philipp Rudo <prudo@redhat.com>
    s390/kexec_file: fix error handling when applying relocations

Jie2x Zhou <jie2x.zhou@intel.com>
    selftests: net: Correct ping6 expected rc from 2 to 1

Javier Martinez Canillas <javierm@redhat.com>
    Revert "drm/fb-helper: improve DRM fbdev emulation device names"

Parav Pandit <parav@nvidia.com>
    vdpa: Consider device id larger than 31

Wei Wang <wei.w.wang@intel.com>
    virtio/vsock: fix the transport to work with VMADDR_CID_ANY

Arnd Bergmann <arnd@arndb.de>
    virtio: always enter drivers/virtio/

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: don't crash on invalid rate w/o STA

Stephan Gerhold <stephan@gerhold.net>
    soc: imx: Register SoC device only on i.MX boards

Mike Tipton <quic_mdtipton@quicinc.com>
    clk: Don't parent clks until the parent is fully registered

Martin Kepplinger <martink@posteo.de>
    arm64: dts: imx8mq: remove interconnect property from lcdif

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

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix calling wq quiesce inside spinlock

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: add halt interrupt support

Florian Klink <flokli@flokli.de>
    arm64: dts: rockchip: fix poweroff on helios64

Alex Bee <knaerzche@gmail.com>
    arm64: dts: rockchip: fix audio-supply for Rock Pi 4

John Keeping <john@metanate.com>
    arm64: dts: rockchip: fix rk3399-leez-p710 vcc3v3-lan supply

John Keeping <john@metanate.com>
    arm64: dts: rockchip: fix rk3308-roc-cc vcc-sd supply

Artem Lapkin <email2tema@gmail.com>
    arm64: dts: rockchip: remove mmc-hs400-enhanced-strobe from rk3399-khadas-edge

Mario Limonciello <mario.limonciello@amd.com>
    pinctrl: amd: Fix wakeups when IRQ is shared with SCI

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/hdmi: Turn DP++ TMDS output buffers back on in encoder->shutdown()

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdmi: convert intel_hdmi_to_dev to intel_hdmi_to_i915

Jaegeuk Kim <jaegeuk@kernel.org>
    scsi: ufs: core: Retry START_STOP on UNIT_ATTENTION

Anand Jain <anand.jain@oracle.com>
    btrfs: remove stale comment about the btrfs_show_devname

Anand Jain <anand.jain@oracle.com>
    btrfs: update latest_dev when we create a sprout device

Anand Jain <anand.jain@oracle.com>
    btrfs: use latest_dev in btrfs_show_devname

Anand Jain <anand.jain@oracle.com>
    btrfs: convert latest_bdev type to btrfs_device and rename

Paul Moore <paul@paul-moore.com>
    audit: improve robustness of the audit queue handling

Joe Thornber <ejt@redhat.com>
    dm btree remove: fix use after free in rebalance_children()

Christian Brauner <christian.brauner@ubuntu.com>
    ceph: fix up non-directory creation in SGID directories

Mathew McBride <matt@traverse.com.au>
    arm64: dts: ten64: remove redundant interrupt declaration for gpio-keys

Jerome Marchand <jmarchan@redhat.com>
    recordmcount.pl: look for jgnop instruction as well as bcrl on s390

Sven Schnelle <svens@linux.ibm.com>
    s390/entry: fix duplicate tracking of irq nesting level

Dan Carpenter <dan.carpenter@oracle.com>
    vdpa: check that offsets are within bounds

Will Deacon <will@kernel.org>
    virtio_ring: Fix querying of maximum DMA mapping size for virtio device

Dan Carpenter <dan.carpenter@oracle.com>
    vduse: check that offset is within bounds in get_config()

Dan Carpenter <dan.carpenter@oracle.com>
    vduse: fix memory corruption in vduse_dev_ioctl()

Daniel Borkmann <daniel@iogearbox.net>
    bpf, selftests: Update test case for atomic cmpxchg on r0 with pointer

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix kernel address leakage in atomic cmpxchg's r0 aux reg

Daniel Borkmann <daniel@iogearbox.net>
    bpf, selftests: Add test case trying to taint map value pointer

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Make 32->64 bounds propagation slightly more robust

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix signed bounds propagation after mov32

Daniel Borkmann <daniel@iogearbox.net>
    bpf, selftests: Add test case for atomic fetch on spilled pointer

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix kernel address leakage in atomic fetch

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

Felix Fietkau <nbd@nbd.name>
    mac80211: fix rate control for retransmitted frames

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM: X86: Fix tlb flush for tdp in kvm_invalidate_pcid()

Juergen Gross <jgross@suse.com>
    x86/kvm: remove unused ack_notifier callbacks

Paolo Bonzini <pbonzini@redhat.com>
    KVM: downgrade two BUG_ONs to WARN_ON_ONCE

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: selftests: Make sure kvm_create_max_vcpus test won't hit RLIMIT_NOFILE

Paolo Bonzini <pbonzini@redhat.com>
    KVM: VMX: clear vmx_x86_ops.sync_pir_to_irr if APICv is disabled

Jon Hunter <jonathanh@nvidia.com>
    reset: tegra-bpmp: Revert Handle errors in BPMP response


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
 .../arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts |   2 -
 arch/arm64/boot/dts/freescale/imx8mq.dtsi          |   2 -
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts     |   2 +-
 .../boot/dts/rockchip/rk3399-khadas-edge.dtsi      |   1 -
 .../boot/dts/rockchip/rk3399-kobol-helios64.dts    |   1 +
 arch/arm64/boot/dts/rockchip/rk3399-leez-p710.dts  |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi |   2 +-
 arch/arm64/kernel/machine_kexec_file.c             |   1 +
 arch/powerpc/kernel/module_64.c                    |  42 ++++--
 arch/powerpc/platforms/85xx/smp.c                  |   4 +-
 .../riscv/boot/dts/sifive/hifive-unleashed-a00.dts |   1 +
 .../riscv/boot/dts/sifive/hifive-unmatched-a00.dts |   2 +
 arch/s390/kernel/irq.c                             |   9 +-
 arch/s390/kernel/machine_kexec_file.c              |   7 +-
 arch/x86/kvm/ioapic.h                              |   1 -
 arch/x86/kvm/irq.h                                 |   1 -
 arch/x86/kvm/vmx/vmx.c                             |   4 +-
 arch/x86/kvm/x86.c                                 |  14 +-
 arch/x86/net/bpf_jit_comp.c                        | 101 ++++++++++-----
 block/blk-iocost.c                                 |   9 +-
 drivers/Makefile                                   |   3 +-
 drivers/ata/libata-scsi.c                          |  15 ++-
 drivers/block/xen-blkfront.c                       |  15 ++-
 drivers/bus/ti-sysc.c                              |   3 +-
 drivers/clk/clk.c                                  |  15 ++-
 drivers/dma/idxd/irq.c                             |   7 +-
 drivers/dma/idxd/registers.h                       |   1 +
 drivers/dma/idxd/submit.c                          |  18 ++-
 drivers/dma/st_fdma.c                              |   2 +-
 drivers/firmware/scpi_pm_domain.c                  |  10 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c           |   1 -
 drivers/gpu/drm/amd/amdgpu/gfxhub_v2_0.c           |   1 -
 drivers/gpu/drm/amd/amdgpu/gfxhub_v2_1.c           |   1 -
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c            |   1 -
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_7.c            |   1 -
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c            |   1 -
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c            |   1 -
 drivers/gpu/drm/amd/amdgpu/mmhub_v9_4.c            |   2 -
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c  |   1 +
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c     |   3 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   3 +
 drivers/gpu/drm/ast/ast_mode.c                     |   5 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   8 +-
 drivers/gpu/drm/i915/display/g4x_hdmi.c            |   1 +
 drivers/gpu/drm/i915/display/intel_ddi.c           |   1 +
 drivers/gpu/drm/i915/display/intel_dmc.c           |   2 +-
 drivers/gpu/drm/i915/display/intel_hdmi.c          |  32 +++--
 drivers/gpu/drm/i915/display/intel_hdmi.h          |   1 +
 drivers/gpu/drm/tiny/simpledrm.c                   |   2 +-
 drivers/hv/Kconfig                                 |   1 +
 drivers/md/persistent-data/dm-btree-remove.c       |   2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |  16 ++-
 drivers/net/can/m_can/m_can.c                      |  24 +++-
 drivers/net/can/m_can/m_can.h                      |   3 +
 drivers/net/can/m_can/m_can_pci.c                  |  48 ++++++-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   4 +
 drivers/net/dsa/mv88e6xxx/port.c                   |   4 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   5 +-
 drivers/net/ethernet/broadcom/bcmsysport.h         |   1 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  20 ++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |   3 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |  13 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h           |   6 +
 drivers/net/ethernet/intel/igb/igb_main.c          |  28 ++--
 drivers/net/ethernet/intel/igbvf/netdev.c          |   1 +
 drivers/net/ethernet/intel/igc/igc_i225.c          |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   4 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c      |   3 +
 drivers/net/ethernet/sfc/ef100_nic.c               |   3 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  17 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  86 ++++++++++--
 drivers/net/netdevsim/bpf.c                        |   1 +
 drivers/net/netdevsim/ethtool.c                    |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   5 +-
 drivers/net/xen-netback/common.h                   |   1 +
 drivers/net/xen-netback/rx.c                       |  77 +++++++----
 drivers/net/xen-netfront.c                         | 125 +++++++++++++-----
 drivers/pci/msi.c                                  |  15 ++-
 drivers/pinctrl/pinctrl-amd.c                      |  29 ++++-
 drivers/reset/tegra/reset-bpmp.c                   |   9 +-
 drivers/scsi/scsi_debug.c                          |  42 +++---
 drivers/scsi/ufs/ufshcd.c                          |  12 +-
 drivers/soc/imx/soc-imx.c                          |   4 +
 drivers/soc/tegra/fuse/fuse-tegra.c                |   2 +-
 drivers/soc/tegra/fuse/fuse.h                      |   2 +-
 drivers/tee/amdtee/core.c                          |   5 +-
 drivers/tty/hvc/hvc_xen.c                          |  30 ++++-
 drivers/tty/n_hdlc.c                               |  23 +++-
 drivers/tty/serial/8250/8250_fintek.c              |  20 ---
 drivers/usb/cdns3/cdnsp-gadget.c                   |  12 ++
 drivers/usb/cdns3/cdnsp-ring.c                     |  11 +-
 drivers/usb/cdns3/cdnsp-trace.h                    |   4 +-
 drivers/usb/core/devio.c                           | 144 ++++++++++++++++-----
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc2/platform.c                        |   3 +
 drivers/usb/early/xhci-dbc.c                       |  15 ++-
 drivers/usb/gadget/composite.c                     |   6 +-
 drivers/usb/gadget/function/u_ether.c              |  16 +--
 drivers/usb/gadget/legacy/dbgp.c                   |   6 +-
 drivers/usb/gadget/legacy/inode.c                  |   6 +-
 drivers/usb/host/xhci-mtk-sch.c                    |   2 +-
 drivers/usb/host/xhci-pci.c                        |   6 +-
 drivers/usb/serial/cp210x.c                        |   6 +-
 drivers/usb/serial/option.c                        |   8 ++
 drivers/usb/typec/tcpm/tcpm.c                      |  18 ++-
 drivers/vdpa/vdpa.c                                |   3 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |   6 +-
 drivers/vhost/vdpa.c                               |   2 +-
 drivers/virtio/virtio_ring.c                       |   2 +-
 drivers/xen/events/events_base.c                   |   6 +
 fs/afs/file.c                                      |   5 +-
 fs/afs/super.c                                     |   1 +
 fs/btrfs/disk-io.c                                 |  14 +-
 fs/btrfs/extent_io.c                               |  10 +-
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/super.c                                   |  26 +---
 fs/btrfs/tree-log.c                                |   1 +
 fs/btrfs/volumes.c                                 |  25 ++--
 fs/btrfs/volumes.h                                 |   6 +-
 fs/ceph/caps.c                                     |  16 +--
 fs/ceph/file.c                                     |  18 ++-
 fs/ceph/mds_client.c                               |   3 +-
 fs/cifs/fs_context.c                               |  38 +++++-
 fs/fuse/dir.c                                      |   2 +-
 fs/io-wq.c                                         |  31 ++++-
 fs/overlayfs/dir.c                                 |   3 +-
 fs/overlayfs/overlayfs.h                           |   1 +
 fs/overlayfs/super.c                               |  12 +-
 fs/zonefs/super.c                                  |   1 +
 include/uapi/linux/mptcp.h                         |  18 +--
 include/xen/events.h                               |   1 +
 kernel/audit.c                                     |  21 ++-
 kernel/bpf/verifier.c                              |  49 +++++--
 kernel/locking/rtmutex.c                           |   2 +-
 kernel/rcu/tree.c                                  |  10 +-
 kernel/time/timekeeping.c                          |   3 +-
 net/core/skbuff.c                                  |   2 +-
 net/ipv4/inet_diag.c                               |   4 +-
 net/ipv6/sit.c                                     |   1 -
 net/mac80211/agg-rx.c                              |   5 +-
 net/mac80211/agg-tx.c                              |  16 ++-
 net/mac80211/driver-ops.h                          |   5 +-
 net/mac80211/mlme.c                                |  13 +-
 net/mac80211/sta_info.h                            |   1 +
 net/mac80211/tx.c                                  |   6 +-
 net/mac80211/util.c                                |   7 +-
 net/mptcp/pm_netlink.c                             |   3 +
 net/mptcp/protocol.c                               |   6 +-
 net/mptcp/sockopt.c                                |   1 -
 net/packet/af_packet.c                             |   5 +-
 net/rds/connection.c                               |   1 +
 net/sched/cls_api.c                                |   1 +
 net/sched/sch_cake.c                               |   6 +-
 net/sched/sch_ets.c                                |   4 +-
 net/smc/af_smc.c                                   |   4 +-
 net/vmw_vsock/virtio_transport_common.c            |   3 +-
 net/wireless/reg.c                                 |   7 +-
 scripts/recordmcount.pl                            |   2 +-
 security/selinux/hooks.c                           |  33 +++--
 tools/perf/builtin-inject.c                        |  13 +-
 .../selftests/bpf/prog_tests/btf_skc_cls_ingress.c |  16 ++-
 .../selftests/bpf/verifier/atomic_cmpxchg.c        |  86 ++++++++++++
 .../selftests/bpf/verifier/value_ptr_arith.c       |  23 ++++
 tools/testing/selftests/damon/.gitignore           |   2 +
 tools/testing/selftests/damon/Makefile             |   2 +
 tools/testing/selftests/damon/debugfs_attrs.sh     |  18 +++
 .../selftests/damon/huge_count_read_write.c        |  39 ++++++
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c |  30 +++++
 tools/testing/selftests/net/fcnal-test.sh          |  45 +++++--
 .../net/forwarding/forwarding.config.sample        |   2 +
 tools/testing/selftests/net/icmp_redirect.sh       |   2 +-
 tools/testing/selftests/net/toeplitz.c             |   2 +-
 virt/kvm/kvm_main.c                                |   6 +-
 186 files changed, 1585 insertions(+), 555 deletions(-)


