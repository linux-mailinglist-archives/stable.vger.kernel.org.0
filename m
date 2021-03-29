Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9212C34C974
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhC2I3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234236AbhC2I17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:27:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6628B619E9;
        Mon, 29 Mar 2021 08:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006416;
        bh=CufPMHFzj5KYNWIJPRY4CW8cetzhiVmXY27nUbZh93A=;
        h=From:To:Cc:Subject:Date:From;
        b=MpULNss8fNSuP6msOOcJF3688Gbsz+C5FWdiNnt+yDV03KXmVUdkaNkFvVa2YlQQT
         68OV7F1c2sXNYrSCMH9erDGMpfNrureQwq9wVWaE13bfqrrLLKk08mDIneoa5M35Ze
         9mUKs/LNmj6C/sMECVEFPohvpBTbKtlITL+BLM04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.11 000/254] 5.11.11-rc1 review
Date:   Mon, 29 Mar 2021 09:55:16 +0200
Message-Id: <20210329075633.135869143@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.11.11-rc1
X-KernelTest-Deadline: 2021-03-31T07:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.11.11 release.
There are 254 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.11.11-rc1

Alexei Starovoitov <ast@kernel.org>
    selftest/bpf: Add a test to check trampoline freeing logic.

Marc Kleine-Budde <mkl@pengutronix.de>
    can: peak_usb: Revert "can: peak_usb: add forgotten supported devices"

Christoph Hellwig <hch@lst.de>
    nvme: fix the nsid value to print in nvme_validate_or_alloc_ns

Roger Pau Monne <roger.pau@citrix.com>
    Revert "xen: fix p2m size in dom0 for disabled memory hotplug case"

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    fs/ext4: fix integer overflow in s_log_groups_per_flex

Jan Kara <jack@suse.cz>
    ext4: add reclaim checks to xattr code

Markus Theil <markus.theil@tu-ilmenau.de>
    mac80211: fix double free in ibss_leave

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: VLAN filtering is global to all users

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix DMA being used after buffer free if WoL is enabled

Martin Willi <martin@strongswan.org>
    can: dev: Move device back to init netns on owning netns delete

Arnd Bergmann <arnd@arndb.de>
    ch_ktls: fix enum-conversion warning

Matthew Wilcox (Oracle) <willy@infradead.org>
    fs/cachefiles: Remove wait_bit_key layout dependency

Isaku Yamahata <isaku.yamahata@intel.com>
    x86/mem_encrypt: Correct physical address calculation in __set_clr_pte_enc()

Thomas Gleixner <tglx@linutronix.de>
    locking/mutex: Fix non debug version of mutex_lock_io_nested()

Shyam Prasad N <sprasad@microsoft.com>
    cifs: Adjust key sizes and key generation routines for AES256 encryption

Steve French <stfrench@microsoft.com>
    smb3: fix cached file size problems in duplicate extents (reflink)

Jia-Ju Bai <baijiaju1990@gmail.com>
    scsi: mpt3sas: Fix error return code of mpt3sas_base_attach()

Jia-Ju Bai <baijiaju1990@gmail.com>
    scsi: qedi: Fix error return code of qedi_alloc_global_queues()

Bart Van Assche <bvanassche@acm.org>
    scsi: Revert "qla2xxx: Make sure that aborted commands are freed"

David Jeffery <djeffery@redhat.com>
    block: recalculate segment count for multi-segment discards correctly

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix provide_buffers sign extension

Ian Rogers <irogers@google.com>
    perf synthetic events: Avoid write of uninitialized memory when generating PERF_RECORD_MMAP* records

Adrian Hunter <adrian.hunter@intel.com>
    perf auxtrace: Fix auxtrace queue conflict

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ACPI: scan: Use unique number for instance_no

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: scan: Rearrange memory allocation in acpi_device_add()

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    Revert "netfilter: x_tables: Update remaining dereference to RCU"

Sean Christopherson <seanjc@google.com>
    mm/mmu_notifiers: ensure range_end() is paired with range_start()

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    dm table: Fix zoned model check and zone sectors check

Pavel Tatashin <pasha.tatashin@soleen.com>
    arm64: mm: correct the inside linear map range during hotplug check

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: define arch_get_mappable_range()

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-wmi-sysman: Cleanup create_attributes_level_sysfs_files()

Stanislav Fomichev <sdf@google.com>
    bpf: Use NOP_ATOMIC5 instead of emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix fexit trampoline.

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    netfilter: x_tables: Use correct memory barriers.

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    Revert "netfilter: x_tables: Switch synchronization to RCU"

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: broadcom: Fix RGMII delays for BCM50160 and BCM50610M

Robert Hancock <robert.hancock@calian.com>
    net: phy: broadcom: Set proper 1000BaseX/SGMII interface mode for BCM54616S

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: broadcom: Avoid forward for bcm54xx_config_clock_delay()

Michael Walle <michael@walle.cc>
    net: phy: introduce phydev->port

Robert Hancock <robert.hancock@calian.com>
    net: axienet: Fix probe error cleanup

Li RongQing <lirongqing@baidu.com>
    igb: avoid premature Rx buffer reuse

Daniel Borkmann <daniel@iogearbox.net>
    net, bpf: Fix ip6ip6 crash with collect_md populated skbs

Daniel Borkmann <daniel@iogearbox.net>
    net: Consolidate common blackhole dst ops

Sasha Levin <sashal@kernel.org>
    bpf: Don't do bpf_cgroup_storage_set() for kuprobe/tp programs

Mike Rapoport <rppt@kernel.org>
    mm: memblock: fix section mismatch warning again

Potnuri Bharat Teja <bharat@chelsio.com>
    RDMA/cxgb4: Fix adapter LE hash errors while destroying ipv6 listening server

Roger Pau Monne <roger.pau@citrix.com>
    xen/x86: make XEN_BALLOON_MEMORY_HOTPLUG_LIMIT depend on MEMORY_HOTPLUG

Colin Ian King <colin.king@canonical.com>
    octeontx2-af: Fix memory leak of object buf

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: bridge: don't notify switchdev for local FDB addresses

David E. Box <david.e.box@linux.intel.com>
    platform/x86: intel_pmt_crashlog: Fix incorrect macros

Lukasz Luba <lukasz.luba@arm.com>
    PM: EM: postpone creating the debugfs dir till fs_initcall

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_quark_i2c_gpio: Revert "Constify static struct resources"

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix error path for ethtool set-priv-flag

Dima Chumak <dchumak@nvidia.com>
    net/mlx5e: Offload tuple rewrite for non-CT flows

Alaa Hleihel <alaa@nvidia.com>
    net/mlx5e: Allow to match on MPLS parameters only for MPLS over UDP

Huy Nguyen <huyn@nvidia.com>
    net/mlx5: Add back multicast stats for uplink representor

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Defer suspending suppliers

Pavel Tatashin <pasha.tatashin@soleen.com>
    arm64: kdump: update ppos when reading elfcorehdr

Fabio Estevam <festevam@gmail.com>
    drm/msm: Fix suspend/resume on i.MX5

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: fix shutdown hook in case GPU components failed to bind

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-wmi-sysman: Make sysman_init() return -ENODEV of the interfaces are not found

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-wmi-sysman: Cleanup sysman_init() error-exit handling

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-wmi-sysman: Fix release_attributes_data() getting called twice on init_bios_attributes() failure

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-wmi-sysman: Make it safe to call exit_foo_attributes() multiple times

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-wmi-sysman: Fix possible NULL pointer deref on exit

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-wmi-sysman: Fix crash caused by calling kset_unregister twice

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: tx-path: zero initialize outgoing CAN frames

Zqiang <qiang.zhang@windriver.com>
    bpf: Fix umd memory leak in copy_process()

Jean-Philippe Brucker <jean-philippe@linaro.org>
    libbpf: Fix BTF dump of pointer-to-array-of-struct

Hangbin Liu <liuhangbin@gmail.com>
    selftests: forwarding: vxlan_bridge_1d: Fix vxlan ecn decapsulate value

David Brazdil <dbrazdil@google.com>
    selinux: vsock: Set SID for socket returned by accept()

Corentin Labbe <clabbe@baylibre.com>
    net: stmmac: dwmac-sun8i: Provide TX and RX fifo sizes

Hayes Wang <hayeswang@realtek.com>
    r8152: limit the RX buffer size of RTL8153A for USB 2.0

Xin Long <lucien.xin@gmail.com>
    sctp: move sk_route_caps check and set into sctp_outq_flush_transports

Jesse Brandeburg <jesse.brandeburg@intel.com>
    igb: check timestamp validity

Johan Hovold <johan@kernel.org>
    net: cdc-phonet: fix data-interface release on probe failure

Jiri Bohac <jbohac@suse.cz>
    net: check all name nodes in __dev_alloc_name

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: fix infinite loop in unmapping NPC counter

Geetha sowjanya <gakula@marvell.com>
    octeontx2-pf: Clear RSS enable flag on interace down

Geetha sowjanya <gakula@marvell.com>
    octeontx2-af: Fix irq free in rvu teardown

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Remove TOS field from MKEX TX

Rakesh Babu <rsaladi2@marvell.com>
    octeontx2-af: Formatting debugfs entry rsrc_alloc.

Jakub Kicinski <kuba@kernel.org>
    ipv6: weaken the v4mapped source check

dillon min <dillon.minfei@gmail.com>
    ARM: dts: imx6ull: fix ubi filesystem mount failed

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    libbpf: Use SOCK_CLOEXEC when opening the netlink socket

Namhyung Kim <namhyung@kernel.org>
    libbpf: Fix error path in bpf_object__elf_init()

Yinjun Zhang <yinjun.zhang@corigine.com>
    netfilter: flowtable: Make sure GC works periodically in idle system

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables: allow to update flowtable flags

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables: report EOPNOTSUPP on unsupported flowtable flags

wenxu <wenxu@ucloud.cn>
    net/sched: cls_flower: fix only mask bit check in the validate_ct_state

Shannon Nelson <snelson@pensando.io>
    ionic: linearize tso skb with too many frags

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dsi: fix check-before-set in the 7nm dsi_pll code

Alexei Starovoitov <ast@kernel.org>
    ftrace: Fix modify_ftrace_direct.

Louis Peens <louis.peens@corigine.com>
    nfp: flower: fix pre_tun mask id allocation

Louis Peens <louis.peens@corigine.com>
    nfp: flower: add ipv6 bit to pre_tunnel control message

Louis Peens <louis.peens@corigine.com>
    nfp: flower: fix unsupported pre_tunnel flows

Carlos Llamas <cmllamas@google.com>
    selftests/net: fix warnings on reuseaddr_ports_exhausted

Brian Norris <briannorris@chromium.org>
    mac80211: Allow HE operation to be longer than expected.

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix rate mask reset

Torin Cooper-Bennun <torin@maxiluxsystems.com>
    can: m_can: m_can_rx_peripheral(): fix RX being blocked by errors

Torin Cooper-Bennun <torin@maxiluxsystems.com>
    can: m_can: m_can_do_rx_poll(): fix extraneous msg loss warning

Tong Zhang <ztong0001@gmail.com>
    can: c_can: move runtime PM enable/disable to c_can_platform

Tong Zhang <ztong0001@gmail.com>
    can: c_can_pci: c_can_pci_remove(): fix use-after-free

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_pciefd: Always disable bus load reporting

Angelo Dureghello <angelo@kernel-space.org>
    can: flexcan: flexcan_chip_freeze(): fix chip freeze for missing bitrate

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: add forgotten supported devices

Marc Kleine-Budde <mkl@pengutronix.de>
    can: isotp: TX-path: ensure that CAN frame flags are initialized

Marc Kleine-Budde <mkl@pengutronix.de>
    can: isotp: isotp_setsockopt(): only allow to set low level TX flags for CAN-FD

Davide Caratti <dcaratti@redhat.com>
    mptcp: fix ADD_ADDR HMAC in case port is specified

Alexander Ovechkin <ovov@yandex-team.ru>
    tcp: relookup sock for RST+ACK packets handled by obsolete req sock

Eric Dumazet <edumazet@google.com>
    tipc: better validate user input in tipc_nl_retrieve_key()

Ong Boon Leong <boon.leong.ong@intel.com>
    net: phylink: Fix phylink_err() function name error in phylink_major_config

Xie He <xie.he.0141@gmail.com>
    net: hdlc_x25: Prevent racing between "x25_close" and "x25_xmit"/"x25_rx"

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: fix dump of the expect mask attribute

Hangbin Liu <liuhangbin@gmail.com>
    selftests/bpf: Set gopt opt_class to 0 if get tunnel opt failed

Alexander Lobakin <alobakin@pm.me>
    flow_dissector: fix byteorder of dissected ICMP ID

Eric Dumazet <edumazet@google.com>
    net: qrtr: fix a kernel-infoleak in qrtr_recvmsg()

Alex Elder <elder@linaro.org>
    net: ipa: terminate message handler arrays

Douglas Anderson <dianders@chromium.org>
    clk: qcom: gcc-sc7180: Use floor ops for the correct sdcc1 clk

Dylan Hung <dylan_hung@aspeedtech.com>
    ftgmac100: Restart MAC HW once

Magnus Karlsson <magnus.karlsson@intel.com>
    ice: fix napi work done reporting in xsk path

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: broadcom: Add power down exit reset state delay

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net/qlcnic: Fix a use after free in qlcnic_83xx_get_minidump_template

David Gow <davidgow@google.com>
    kunit: tool: Disable PAGE_POISONING under --alltests

Dinghao Liu <dinghao.liu@zju.edu.cn>
    e1000e: Fix error handling in e1000_set_d0_lplu_state_82571

Vitaly Lifshits <vitaly.lifshits@intel.com>
    e1000e: add rtnl_lock() to e1000_reset_task

Andre Guedes <andre.guedes@intel.com>
    igc: Fix igc_ptp_rx_pktstamp()

Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
    igc: Fix Supported Pause Frame Link Setting

Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
    igc: Fix Pause Frame Advertising

Sasha Neftin <sasha.neftin@intel.com>
    igc: reinit_locked() should be called with rtnl_lock

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Qualify phydev->dev_flags based on port

Eric Dumazet <edumazet@google.com>
    net: sched: validate stab values

Eric Dumazet <edumazet@google.com>
    macvlan: macvlan_count_rx() needs to be aware of preemption

Ido Schimmel <idosch@nvidia.com>
    drop_monitor: Perform cleanup upon probe registration failure

Wei Wang <weiwan@google.com>
    ipv6: fix suspecious RCU usage warning

Parav Pandit <parav@nvidia.com>
    net/mlx5e: E-switch, Fix rate calculation division

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Don't match on Geneve options in case option masks are all zero

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Revert parameters on errors when changing PTP state without reset

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: When changing XDP program without reset, take refs for XSK RQs

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Set PTP channel pointer explicitly to NULL

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5e: RX, Mind the MPWQE gaps when calculating offsets

Georgi Valkov <gvalkov@abv.bg>
    libbpf: Fix INSTALL flag order

Tal Lossos <tallossos@gmail.com>
    bpf: Change inode_storage's lookup_elem return value from NULL to -EBADF

Alexei Starovoitov <ast@kernel.org>
    bpf: Dont allow vmlinux BTF to be used in map_create and prog_load.

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    veth: Store queue_mapping independently of XDP prog presence

Tony Lindgren <tony@atomide.com>
    soc: ti: omap-prm: Fix occasional abort on reset deassert for dra7 iva

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix smartreflex init regression after dropping legacy data

Tony Lindgren <tony@atomide.com>
    soc: ti: omap-prm: Fix reboot issue with invalid pcie reset map for dra7

Grygorii Strashko <grygorii.strashko@ti.com>
    bus: omap_l3_noc: mark l3 irqs as IRQF_NO_THREAD

Mikulas Patocka <mpatocka@redhat.com>
    dm ioctl: fix out of bounds array access when no devices

Mikulas Patocka <mpatocka@redhat.com>
    dm: don't report "detected capacity change" on device creation

JeongHyeon Lee <jhs2.lee@samsung.com>
    dm verity: fix DM_VERITY_OPTS_MAX value

Imre Deak <imre.deak@intel.com>
    drm/i915: Fix the GT fence revocation runtime PM logic

Jani Nikula <jani.nikula@intel.com>
    drm/i915/dsc: fix DSS CTL register usage for ICL DSI transcoders

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Add additional Sienna Cichlid PCI ID

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: fix the hibernation suspend with s0ix

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: restore AUX_DPHY_TX_CONTROL for DCN2.x

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/pm: workaround for audio noise issue

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/etnaviv: Use FOLL_FORCE for userptr

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms/nve4-nv108: Limit cursors to 128x128

Mimi Zohar <zohar@linux.ibm.com>
    integrity: double check iint_cache was initialized

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91-sama5d27_som1: fix phy address to 7

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: dts: at91: sam9x60: fix mux-mask to match product's datasheet

Federico Pellegrin <fede@evolware.org>
    ARM: dts: at91: sam9x60: fix mux-mask for PA7 so it can be set to A, B and C

Horia Geantă <horia.geanta@nxp.com>
    arm64: dts: ls1043a: mark crypto engine dma coherent

Horia Geantă <horia.geanta@nxp.com>
    arm64: dts: ls1012a: mark crypto engine dma coherent

Horia Geantă <horia.geanta@nxp.com>
    arm64: dts: ls1046a: mark crypto engine dma coherent

Mark Rutland <mark.rutland@arm.com>
    arm64: stacktrace: don't trace arch_stack_walk()

Vegard Nossum <vegard.nossum@oracle.com>
    ACPICA: Always create namespace nodes using acpi_ns_create_node()

Chris Chiu <chris.chiu@canonical.com>
    ACPI: video: Add missing callback back for Sony VPCEH3U1E

Ira Weiny <ira.weiny@intel.com>
    mm/highmem: fix CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP

Nick Desaulniers <ndesaulniers@google.com>
    gcov: fix clang-11+ support

Andrey Konovalov <andreyknvl@google.com>
    kasan: fix per-page tags for non-page_alloc pages

Miaohe Lin <linmiaohe@huawei.com>
    hugetlb_cgroup: fix imbalanced css_get and css_put pair for shared mappings

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: fix xattr id and id lookup sanity checks

Sean Nyekjaer <sean@geanix.com>
    squashfs: fix inode lookup sanity checks

Thomas Hebb <tommyhebb@gmail.com>
    z3fold: prevent reclaim/free race for headless pages

Ido Schimmel <idosch@nvidia.com>
    psample: Fix user API breakage

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel-vbtn: Stop reporting SW_DOCK events

Mian Yousaf Kaukab <ykaukab@suse.de>
    netsec: restore phy power state after controller reset

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix variable scope issue in live sidtab conversion

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: don't log MAC_POLICY_LOAD record on failed policy load

Filipe Manana <fdmanana@suse.com>
    btrfs: fix subvolume/snapshot deletion not triggered on mount

Filipe Manana <fdmanana@suse.com>
    btrfs: fix sleep while in non-sleep context during qgroup removal

Josef Bacik <josef@toxicpanda.com>
    btrfs: initialize device::fs_info always

Omar Sandoval <osandov@fb.com>
    btrfs: fix check_data_csum() error message for direct I/O

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not initialize dev replace for bad dev root

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not initialize dev stats if we have no dev_root

Sean Christopherson <seanjc@google.com>
    KVM: x86: Protect userspace MSR filter with SRCU, and set atomically-ish

Peter Zijlstra <peterz@infradead.org>
    static_call: Fix static_call_set_init()

Peter Zijlstra <peterz@infradead.org>
    static_call: Fix the module key fixup

Josh Poimboeuf <jpoimboe@redhat.com>
    static_call: Allow module use without exposing static_call_key

Peter Zijlstra <peterz@infradead.org>
    static_call: Pull some static_call declarations to the type headers

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: fix ptrace(PTRACE_SYSCALL_INFO_EXIT) sign

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: fix ia64_syscall_get_set_arguments() for break-based syscalls

Fenghua Yu <fenghua.yu@intel.com>
    mm/fork: clear PASID for new mm

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: cancel deferred requests in try_cancel

Daniel Wagner <dwagner@suse.de>
    block: Suppress uevent for hidden device when removed

J. Bruce Fields <bfields@redhat.com>
    nfs: we don't support removing system.nfs4_acl

Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
    nvme-pci: add the DISABLE_WRITE_ZEROES quirk for a Samsung PM1725a

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    nvme-rdma: Fix a use after free in nvmet_rdma_write_data_done

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvme-core: check ctrl css before setting up zns

Hannes Reinecke <hare@suse.de>
    nvme-fc: return NVME_SC_HOST_ABORTED_CMD when a command has been aborted

Hannes Reinecke <hare@suse.de>
    nvme-fc: set NVME_REQ_CANCELLED in nvme_fc_terminate_exchange()

Hannes Reinecke <hare@suse.de>
    nvme: add NVME_REQ_CANCELLED flag in nvme_cancel_request()

Hannes Reinecke <hare@suse.de>
    nvme: simplify error logic in nvme_validate_ns()

Christian König <christian.koenig@amd.com>
    drm/radeon: fix AGP dependency

Nirmoy Das <nirmoy.das@amd.com>
    drm/amdgpu: fb BO should be ttm_bo_type_device

Zhan Liu <zhan.liu@amd.com>
    drm/amdgpu/display: Use wm_table.entries for dcn301 calculate_wm

Dillon Varone <dillon.varone@amd.com>
    drm/amd/display: Enabled pipe harvesting in dcn30

Sung Lee <sung.lee@amd.com>
    drm/amd/display: Revert dram_clock_change_latency for DCN2.1

Qingqing Zhuo <qingqing.zhuo@amd.com>
    drm/amd/display: Enable pflip interrupt upon pipe enable

Damien Le Moal <damien.lemoal@wdc.com>
    block: Fix REQ_OP_ZONE_RESET_ALL handling

satya priya <skakit@codeaurora.org>
    regulator: qcom-rpmh: Use correct buck for S1C regulator

satya priya <skakit@codeaurora.org>
    regulator: qcom-rpmh: Correct the pmic5_hfsmps515 buck

Mark Brown <broonie@kernel.org>
    kselftest: arm64: Fix exit code of sve-ptrace

Peter Zijlstra <peterz@infradead.org>
    u64_stats,lockdep: Fix u64_stats_init() vs lockdep

Julian Braha <julianbraha@gmail.com>
    staging: rtl8192e: fix kconfig dependency on CRYPTO

Tomer Tayar <ttayar@habana.ai>
    habanalabs: Disable file operations after device is removed

Tomer Tayar <ttayar@habana.ai>
    habanalabs: Call put_pid() when releasing control device

Rob Gardner <rob.gardner@oracle.com>
    sparc64: Fix opcode filtering in handling of no fault loads

Wei Yongjun <weiyongjun1@huawei.com>
    umem: fix error return code in mm_pci_probe()

Jiri Slaby <jirislaby@kernel.org>
    kbuild: dummy-tools: fix inverted tests for gcc

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: add image_name to no-sync-config-targets

Paul Cercueil <paul@crapouillou.net>
    irqchip/ingenic: Add support for the JZ4760

Paulo Alcantara <pc@cjr.nz>
    cifs: change noisy error message to FYI

Tong Zhang <ztong0001@gmail.com>
    atm: idt77252: fix null-ptr-dereference

Tong Zhang <ztong0001@gmail.com>
    atm: uPD98402: fix incorrect allocation

Alex Marginean <alexandru.marginean@nxp.com>
    net: enetc: set MAC RX FIFO to recommended value

Paul Cercueil <paul@crapouillou.net>
    net: davicom: Use platform_get_irq_optional()

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: wan: fix error return code of uhdlc_init()

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: hisilicon: hns: fix error return code of hns_nic_clear_all_rx_fetch()

Frank Sorenson <sorenson@redhat.com>
    NFS: Correct size calculation for create reply length

Timo Rothenpieler <timo@rothenpieler.org>
    nfs: fix PNFS_FLEXFILE_LAYOUT Kconfig default

Yang Li <yang.lee@linux.alibaba.com>
    gpiolib: acpi: Add missing IRQF_ONESHOT

Sudeep Holla <sudeep.holla@arm.com>
    cpufreq: blacklist Arm Vexpress platforms in cpufreq-dt-platdev

Bob Peterson <rpeterso@redhat.com>
    gfs2: fix use-after-free in trans_drain

Aurelien Aptel <aaptel@suse.com>
    cifs: ask for more credit on async read/write code paths

Michael Braun <michael-dev@fami-braun.de>
    gianfar: fix jumbo packets+napi+rx overrun crash

Denis Efremov <efremov@linux.com>
    sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: intel: iavf: fix error return code of iavf_init_get_resources()

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: tehuti: fix error return code in bdx_probe()

Xunlei Pang <xlpang@linux.alibaba.com>
    blk-cgroup: Fix the recursive blkg rwstat

Nitin Rawat <nitirawa@codeaurora.org>
    scsi: ufs: ufs-qcom: Disable interrupt in reset path

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ixgbe: Fix memleak in ixgbe_configure_clsu32

Mark Pearson <markpearson@lenovo.com>
    ALSA: hda: ignore invalid NHLT table

Hayes Wang <hayeswang@realtek.com>
    Revert "r8152: adjust the settings about MAC clock speed down for RTL8153"

Tong Zhang <ztong0001@gmail.com>
    atm: lanai: dont run lanai_dev_close if not open

Tong Zhang <ztong0001@gmail.com>
    atm: eni: dont release is never initialized

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/4xx: Fix build errors from mfdcr()

Heiko Thiery <heiko.thiery@gmail.com>
    net: fec: ptp: avoid register access when ipg clock is disabled

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: fix dma physical address of descriptor when display ring

Felix Fietkau <nbd@nbd.name>
    mt76: mt7915: only modify tx buffer list after allocating tx token id

Felix Fietkau <nbd@nbd.name>
    mt76: fix tx skb error handling in mt76_dma_tx_queue_skb


-------------

Diffstat:

 Documentation/virt/kvm/api.rst                     |   6 +-
 Makefile                                           |   7 +-
 arch/arm/boot/dts/at91-sam9x60ek.dts               |   8 -
 arch/arm/boot/dts/at91-sama5d27_som1.dtsi          |   4 +-
 arch/arm/boot/dts/imx6ull-myir-mys-6ulx-eval.dts   |   1 +
 arch/arm/boot/dts/sam9x60.dtsi                     |   9 +
 arch/arm/mach-omap2/sr_device.c                    |  75 +++++--
 arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi     |   1 +
 arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi     |   1 +
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi     |   1 +
 arch/arm64/kernel/crash_dump.c                     |   2 +
 arch/arm64/kernel/stacktrace.c                     |   9 +-
 arch/arm64/mm/mmu.c                                |  32 ++-
 arch/ia64/include/asm/syscall.h                    |   2 +-
 arch/ia64/kernel/ptrace.c                          |  24 ++-
 arch/powerpc/include/asm/dcr-native.h              |   8 +-
 arch/sparc/kernel/traps_64.c                       |  13 +-
 arch/x86/include/asm/kvm_host.h                    |  14 +-
 arch/x86/include/asm/static_call.h                 |   7 +
 arch/x86/include/asm/xen/page.h                    |  12 --
 arch/x86/kvm/x86.c                                 | 109 ++++++-----
 arch/x86/mm/mem_encrypt.c                          |   2 +-
 arch/x86/net/bpf_jit_comp.c                        |  27 ++-
 arch/x86/xen/p2m.c                                 |   7 +-
 arch/x86/xen/setup.c                               |  16 +-
 block/blk-cgroup-rwstat.c                          |   3 +-
 block/blk-merge.c                                  |   8 +
 block/blk-zoned.c                                  |   2 +-
 block/genhd.c                                      |   4 +-
 drivers/acpi/acpica/nsaccess.c                     |   3 +-
 drivers/acpi/internal.h                            |   6 +-
 drivers/acpi/scan.c                                |  88 +++++----
 drivers/acpi/video_detect.c                        |   1 +
 drivers/atm/eni.c                                  |   3 +-
 drivers/atm/idt77105.c                             |   4 +-
 drivers/atm/lanai.c                                |   5 +-
 drivers/atm/uPD98402.c                             |   2 +-
 drivers/base/power/runtime.c                       |  45 ++++-
 drivers/block/umem.c                               |   5 +-
 drivers/bus/omap_l3_noc.c                          |   4 +-
 drivers/clk/qcom/gcc-sc7180.c                      |   4 +-
 drivers/cpufreq/cpufreq-dt-platdev.c               |   2 +
 drivers/gpio/gpiolib-acpi.c                        |   2 +-
 drivers/gpu/drm/Kconfig                            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c             |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   1 +
 drivers/gpu/drm/amd/display/dc/dc.h                |   1 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c  |  11 ++
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.h  |   6 +
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |   7 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c  |   1 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   6 +
 .../drm/amd/display/dc/dcn20/dcn20_link_encoder.c  |   3 +-
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c  |   1 +
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |   2 +-
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c  |   1 +
 .../gpu/drm/amd/display/dc/dcn30/dcn30_resource.c  |  31 +++
 .../drm/amd/display/dc/dcn301/dcn301_resource.c    |  96 ++++++++-
 drivers/gpu/drm/amd/display/dc/inc/hw/hubp.h       |   2 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |  54 +++++
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |  74 +++++--
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c  |  24 +++
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c  |  25 +++
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |   2 +-
 drivers/gpu/drm/i915/display/intel_vdsc.c          |  10 +-
 drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c       |  13 +-
 drivers/gpu/drm/i915/intel_runtime_pm.c            |  29 ++-
 drivers/gpu/drm/i915/intel_runtime_pm.h            |   5 +
 drivers/gpu/drm/msm/dsi/pll/dsi_pll.c              |   2 +-
 drivers/gpu/drm/msm/dsi/pll/dsi_pll.h              |   6 +-
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_7nm.c          |   5 +-
 drivers/gpu/drm/msm/msm_drv.c                      |  12 ++
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |  13 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   4 +-
 drivers/irqchip/irq-ingenic-tcu.c                  |   1 +
 drivers/irqchip/irq-ingenic.c                      |   1 +
 drivers/md/dm-ioctl.c                              |   2 +-
 drivers/md/dm-table.c                              |  33 +++-
 drivers/md/dm-verity-target.c                      |   2 +-
 drivers/md/dm-zoned-target.c                       |   2 +-
 drivers/md/dm.c                                    |   5 +-
 drivers/mfd/intel_quark_i2c_gpio.c                 |   6 +-
 drivers/misc/habanalabs/common/device.c            |  40 +++-
 drivers/misc/habanalabs/common/habanalabs_ioctl.c  |  12 ++
 drivers/net/can/c_can/c_can.c                      |  24 +--
 drivers/net/can/c_can/c_can_pci.c                  |   3 +-
 drivers/net/can/c_can/c_can_platform.c             |   6 +-
 drivers/net/can/dev.c                              |   1 +
 drivers/net/can/flexcan.c                          |   8 +-
 drivers/net/can/kvaser_pciefd.c                    |   4 +
 drivers/net/can/m_can/m_can.c                      |   5 +-
 drivers/net/dsa/b53/b53_common.c                   |  14 +-
 drivers/net/dsa/bcm_sf2.c                          |   6 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |   2 +-
 drivers/net/ethernet/davicom/dm9000.c              |   2 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |   1 +
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |   2 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |   6 +
 drivers/net/ethernet/freescale/fec_ptp.c           |   7 +
 drivers/net/ethernet/freescale/gianfar.c           |  15 ++
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |   4 +-
 drivers/net/ethernet/intel/e1000e/82571.c          |   2 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |   6 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   3 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |   6 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  10 +-
 drivers/net/ethernet/intel/igb/igb.h               |   4 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  33 ++--
 drivers/net/ethernet/intel/igb/igb_ptp.c           |  31 ++-
 drivers/net/ethernet/intel/igc/igc.h               |   2 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |   7 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   9 +
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  72 ++++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   6 +-
 .../ethernet/marvell/octeontx2/af/npc_profile.h    |   2 -
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   6 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  48 +++--
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   3 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c |   4 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  57 ++++--
 .../net/ethernet/netronome/nfp/flower/metadata.c   |  24 ++-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  18 ++
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |  15 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |  13 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_minidump.c   |   3 +
 drivers/net/ethernet/realtek/r8169_main.c          |   6 +-
 drivers/net/ethernet/socionext/netsec.c            |   9 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   2 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |  50 ++++-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |   9 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   3 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    |   9 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  57 ++++--
 drivers/net/ethernet/sun/niu.c                     |   2 -
 drivers/net/ethernet/tehuti/tehuti.c               |   1 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  35 ++--
 drivers/net/ipa/ipa_qmi.c                          |   2 +
 drivers/net/phy/broadcom.c                         | 147 ++++++++++----
 drivers/net/phy/dp83822.c                          |   3 +
 drivers/net/phy/dp83869.c                          |   4 +
 drivers/net/phy/lxt.c                              |   1 +
 drivers/net/phy/marvell.c                          |   1 +
 drivers/net/phy/marvell10g.c                       |   2 +
 drivers/net/phy/micrel.c                           |  14 +-
 drivers/net/phy/phy.c                              |   2 +-
 drivers/net/phy/phy_device.c                       |   9 +
 drivers/net/phy/phylink.c                          |   2 +-
 drivers/net/usb/cdc-phonet.c                       |   2 +
 drivers/net/usb/r8152.c                            |  40 +---
 drivers/net/veth.c                                 |   3 +-
 drivers/net/wan/fsl_ucc_hdlc.c                     |   8 +-
 drivers/net/wan/hdlc_x25.c                         |  42 +++-
 drivers/net/wireless/mediatek/mt76/dma.c           |  15 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  10 +-
 drivers/nvme/host/core.c                           |  15 +-
 drivers/nvme/host/fc.c                             |   3 +-
 drivers/nvme/host/pci.c                            |   1 +
 drivers/nvme/target/rdma.c                         |   5 +-
 .../platform/x86/dell-wmi-sysman/enum-attributes.c |   3 +
 .../platform/x86/dell-wmi-sysman/int-attributes.c  |   3 +
 .../x86/dell-wmi-sysman/passobj-attributes.c       |   3 +
 .../x86/dell-wmi-sysman/string-attributes.c        |   3 +
 drivers/platform/x86/dell-wmi-sysman/sysman.c      |  84 +++-----
 drivers/platform/x86/intel-vbtn.c                  |  12 +-
 drivers/platform/x86/intel_pmt_crashlog.c          |  13 +-
 drivers/regulator/qcom-rpmh-regulator.c            |   6 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   8 +-
 drivers/scsi/qedi/qedi_main.c                      |   1 +
 drivers/scsi/qla2xxx/qla_target.c                  |  13 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   4 -
 drivers/scsi/ufs/ufs-qcom.c                        |  10 +
 drivers/soc/ti/omap_prm.c                          |   8 +-
 drivers/staging/rtl8192e/Kconfig                   |   1 +
 drivers/xen/Kconfig                                |   4 +-
 fs/btrfs/dev-replace.c                             |   3 +
 fs/btrfs/disk-io.c                                 |  19 +-
 fs/btrfs/inode.c                                   |  14 +-
 fs/btrfs/qgroup.c                                  |  12 +-
 fs/btrfs/volumes.c                                 |   3 +
 fs/cachefiles/rdwr.c                               |   7 +-
 fs/cifs/cifsglob.h                                 |   4 +-
 fs/cifs/cifspdu.h                                  |   5 +
 fs/cifs/smb2glob.h                                 |   1 +
 fs/cifs/smb2ops.c                                  |  27 ++-
 fs/cifs/smb2pdu.c                                  |   6 +-
 fs/cifs/smb2transport.c                            |  37 +++-
 fs/cifs/transport.c                                |   2 +-
 fs/ext4/mballoc.c                                  |  11 +-
 fs/ext4/xattr.c                                    |   4 +
 fs/gfs2/log.c                                      |   4 +
 fs/gfs2/trans.c                                    |   2 +
 fs/io_uring.c                                      |  14 +-
 fs/nfs/Kconfig                                     |   2 +-
 fs/nfs/nfs3xdr.c                                   |   3 +-
 fs/nfs/nfs4proc.c                                  |   3 +
 fs/squashfs/export.c                               |   8 +-
 fs/squashfs/id.c                                   |   6 +-
 fs/squashfs/squashfs_fs.h                          |   1 +
 fs/squashfs/xattr_id.c                             |   6 +-
 include/acpi/acpi_bus.h                            |   1 +
 include/asm-generic/vmlinux.lds.h                  |   5 +-
 include/linux/bpf.h                                |  33 +++-
 include/linux/brcmphy.h                            |   4 +
 include/linux/device-mapper.h                      |  15 +-
 include/linux/hugetlb_cgroup.h                     |  15 +-
 include/linux/if_macvlan.h                         |   3 +-
 include/linux/memblock.h                           |   4 +-
 include/linux/mm.h                                 |  18 +-
 include/linux/mm_types.h                           |   1 +
 include/linux/mmu_notifier.h                       |  10 +-
 include/linux/mutex.h                              |   2 +-
 include/linux/netfilter/x_tables.h                 |   7 +-
 include/linux/pagemap.h                            |   1 -
 include/linux/phy.h                                |   2 +
 include/linux/static_call.h                        |  43 ++--
 include/linux/static_call_types.h                  |  50 +++++
 include/linux/u64_stats_sync.h                     |   7 +-
 include/linux/usermode_driver.h                    |   1 +
 include/net/dst.h                                  |  11 ++
 include/net/inet_connection_sock.h                 |   2 +-
 include/net/netfilter/nf_tables.h                  |   3 +
 include/net/nexthop.h                              |  24 +++
 include/net/red.h                                  |  10 +-
 include/net/rtnetlink.h                            |   2 +
 include/uapi/linux/psample.h                       |   5 +-
 kernel/bpf/bpf_inode_storage.c                     |   2 +-
 kernel/bpf/bpf_struct_ops.c                        |   2 +-
 kernel/bpf/core.c                                  |   4 +-
 kernel/bpf/preload/bpf_preload_kern.c              |  19 +-
 kernel/bpf/syscall.c                               |   5 +
 kernel/bpf/trampoline.c                            | 218 ++++++++++++++++-----
 kernel/bpf/verifier.c                              |   4 +
 kernel/fork.c                                      |   8 +
 kernel/gcov/clang.c                                |  69 +++++++
 kernel/power/energy_model.c                        |   2 +-
 kernel/static_call.c                               |  71 ++++++-
 kernel/trace/ftrace.c                              |  43 +++-
 kernel/usermode_driver.c                           |  21 +-
 mm/highmem.c                                       |   4 +-
 mm/hugetlb.c                                       |  41 +++-
 mm/hugetlb_cgroup.c                                |  10 +-
 mm/mmu_notifier.c                                  |  23 +++
 mm/z3fold.c                                        |  16 +-
 net/bridge/br_switchdev.c                          |   2 +
 net/can/isotp.c                                    |  18 +-
 net/core/dev.c                                     |  14 +-
 net/core/drop_monitor.c                            |  23 +++
 net/core/dst.c                                     |  59 ++++--
 net/core/flow_dissector.c                          |   2 +-
 net/dccp/ipv6.c                                    |   5 +
 net/ipv4/inet_connection_sock.c                    |   7 +-
 net/ipv4/netfilter/arp_tables.c                    |  16 +-
 net/ipv4/netfilter/ip_tables.c                     |  16 +-
 net/ipv4/route.c                                   |  45 +----
 net/ipv4/tcp_minisocks.c                           |   7 +-
 net/ipv6/ip6_fib.c                                 |   2 +-
 net/ipv6/ip6_input.c                               |  10 -
 net/ipv6/netfilter/ip6_tables.c                    |  16 +-
 net/ipv6/route.c                                   |  36 +---
 net/ipv6/tcp_ipv6.c                                |   5 +
 net/mac80211/cfg.c                                 |   4 +-
 net/mac80211/ibss.c                                |   2 +
 net/mac80211/mlme.c                                |   2 +-
 net/mac80211/util.c                                |   2 +-
 net/mptcp/options.c                                |  24 ++-
 net/mptcp/subflow.c                                |   5 +
 net/netfilter/nf_conntrack_netlink.c               |   1 +
 net/netfilter/nf_flow_table_core.c                 |   2 +-
 net/netfilter/nf_tables_api.c                      |  19 +-
 net/netfilter/x_tables.c                           |  49 +++--
 net/qrtr/qrtr.c                                    |   5 +
 net/sched/cls_flower.c                             |   2 +-
 net/sched/sch_choke.c                              |   7 +-
 net/sched/sch_gred.c                               |   2 +-
 net/sched/sch_red.c                                |   7 +-
 net/sched/sch_sfq.c                                |   2 +-
 net/sctp/output.c                                  |   7 -
 net/sctp/outqueue.c                                |   7 +
 net/tipc/node.c                                    |  11 +-
 net/vmw_vsock/af_vsock.c                           |   1 +
 scripts/dummy-tools/gcc                            |   5 +
 security/integrity/iint.c                          |   8 +
 security/selinux/include/security.h                |  15 +-
 security/selinux/selinuxfs.c                       |  13 +-
 security/selinux/ss/services.c                     |  63 +++---
 sound/hda/intel-nhlt.c                             |   5 +
 tools/include/linux/static_call_types.h            |  50 +++++
 tools/lib/bpf/Makefile                             |   2 +-
 tools/lib/bpf/btf_dump.c                           |   2 +-
 tools/lib/bpf/libbpf.c                             |   3 +-
 tools/lib/bpf/netlink.c                            |   2 +-
 tools/objtool/check.c                              |  17 +-
 tools/perf/util/auxtrace.c                         |   4 -
 tools/perf/util/synthetic-events.c                 |   9 +-
 tools/testing/kunit/configs/broken_on_uml.config   |   2 +
 tools/testing/selftests/arm64/fp/sve-ptrace.c      |   2 +-
 .../testing/selftests/bpf/prog_tests/fexit_sleep.c |  82 ++++++++
 tools/testing/selftests/bpf/progs/fexit_sleep.c    |  31 +++
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |   6 +-
 .../selftests/net/forwarding/vxlan_bridge_1d.sh    |   2 +-
 .../selftests/net/reuseaddr_ports_exhausted.c      |  32 +--
 309 files changed, 3116 insertions(+), 1113 deletions(-)


