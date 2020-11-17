Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12802B64F4
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731506AbgKQNbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:31:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731998AbgKQNbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:31:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C0CF2078E;
        Tue, 17 Nov 2020 13:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619867;
        bh=oXjGVyy1MVOA1JLVVx+IQSb34ynZl4QVs5a+8uZZcTo=;
        h=From:To:Cc:Subject:Date:From;
        b=HQfcpr0lm1JaYMcYLxxWjMnNjl5NmPfE0n+qVr50nLqBkVVU74pPP4tp+JomzBzLO
         ysHuH8ud3Tlz5axm05CU6y7VzKfmsCxn1FmQR5nbs8JOjCxbcP0z5j/YkzvLWoVZq3
         SUAv4+As+kzlHqzmEeuX6RzXewr6PHms45rn8ZeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.9 000/255] 5.9.9-rc1 review
Date:   Tue, 17 Nov 2020 14:02:20 +0100
Message-Id: <20201117122138.925150709@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.9.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.9.9-rc1
X-KernelTest-Deadline: 2020-11-19T12:21+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.9.9 release.
There are 255 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.9.9-rc1

Boris Protopopov <pboris@amazon.com>
    Convert trailing spaces and periods in path components

Mike Leach <mike.leach@linaro.org>
    coresight: Fix uninitialised pointer bug in etm_setup_aux()

Linu Cherian <lcherian@marvell.com>
    coresight: etm: perf: Sink selection using sysfs is deprecated

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf scripting python: Avoid declaring function pointers with a visibility attribute

Damien Le Moal <damien.lemoal@wdc.com>
    null_blk: Fix scheduling in atomic with zoned mode

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/603: Always fault when _PAGE_ACCESSED is not set

Stefano Brivio <sbrivio@redhat.com>
    tunnels: Fix off-by-one in lower MTU bounds for ICMP/ICMPv6 replies

Paolo Abeni <pabeni@redhat.com>
    mptcp: provide rmem[0] limit

Parav Pandit <parav@nvidia.com>
    devlink: Avoid overwriting port attributes of registered port

Wang Hai <wanghai38@huawei.com>
    tipc: fix memory leak in tipc_topsrv_start()

Martin Schiller <ms@dev.tdt.de>
    net/x25: Fix null-ptr-deref in x25_connect

Mao Wenan <wenan.mao@linux.alibaba.com>
    net: Update window_clamp if SOCK_RCVBUF is set

Alexander Lobakin <alobakin@pm.me>
    net: udp: fix UDP header access on Fast/frag0 UDP GRO

Alexander Lobakin <alobakin@pm.me>
    net: udp: fix IP header access and skb lookup on Fast/frag0 UDP GRO

Ursula Braun <ubraun@linux.ibm.com>
    net/af_iucv: fix null pointer dereference on shutdown

Oliver Herms <oliver.peter.herms@gmail.com>
    IPv6: Set SIT tunnel hard_header_len to zero

Alexander Lobakin <alobakin@pm.me>
    ethtool: netlink: add missing netdev_features_change() call

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Take CPUFREQ_GOV_STRICT_TARGET into account

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Add strict_target to struct cpufreq_policy

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Introduce CPUFREQ_GOV_STRICT_TARGET

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Introduce governor flags

Stefano Stabellini <stefano.stabellini@xilinx.com>
    swiotlb: fix "x86: Don't panic if can not alloc buffer for swiotlb"

Coiby Xu <coiby.xu@gmail.com>
    pinctrl: amd: fix incorrect way to disable debounce filter

Coiby Xu <coiby.xu@gmail.com>
    pinctrl: amd: use higher precision for 512 RtcClk

J. Bruce Fields <bfields@redhat.com>
    NFSv4.2: fix failure to unregister shrinker

Thomas Zimmermann <tzimmermann@suse.de>
    drm/gma500: Fix out-of-bounds access to struct drm_device.vblank[]

Venkata Sandeep Dhanalakota <venkata.s.dhanalakota@intel.com>
    drm/i915: Correctly set SFC capability for video engines

Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
    drm/amd/display: Add missing pflip irq

Al Viro <viro@zeniv.linux.org.uk>
    don't dump the threads that had been already exiting when zapped.

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    mmc: renesas_sdhi_core: Add missing tmio_mmc_host_free() at remove

Yangbo Lu <yangbo.lu@nxp.com>
    mmc: sdhci-of-esdhc: Handle pulse width detection erratum for more SoCs

Arnaud de Turckheim <quarium@gmail.com>
    gpio: pcie-idio-24: Enable PEX8311 interrupts

Arnaud de Turckheim <quarium@gmail.com>
    gpio: pcie-idio-24: Fix IRQ Enable Register value

Arnaud de Turckheim <quarium@gmail.com>
    gpio: pcie-idio-24: Fix irq mask when masking

Damien Le Moal <damien.lemoal@wdc.com>
    gpio: sifive: Fix SiFive gpio probe

Jens Axboe <axboe@kernel.dk>
    io_uring: round-up cq size before comparing with rounded sq size

Chen Zhou <chenzhou10@huawei.com>
    selinux: Fix error return code in sel_ib_pkey_sid_slow()

Naveen Krishna Chatradhi <nchatrad@amd.com>
    hwmon: (amd_energy) modify the visibility of the counters

Wengang Wang <wen.gang.wang@oracle.com>
    ocfs2: initialize ip_next_orphan

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: fix anon huge page migration race

Matteo Croce <mcroce@microsoft.com>
    reboot: fix overflow parsing reboot cpu number

Matteo Croce <mcroce@microsoft.com>
    Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"

Jason Gunthorpe <jgg@ziepe.ca>
    mm/gup: use unpin_user_pages() in __gup_longterm_locked()

Nicholas Piggin <npiggin@gmail.com>
    mm/vmscan: fix NR_ISOLATED_FILE corruption on 64-bit

Laurent Dufour <ldufour@linux.ibm.com>
    mm/slub: fix panic in slab_alloc_node()

Zi Yan <ziy@nvidia.com>
    mm/compaction: stop isolation if too many pages are isolated and we have pages to migrate

Zi Yan <ziy@nvidia.com>
    mm/compaction: count pages and stop correctly during page isolation

Masami Hiramatsu <mhiramat@kernel.org>
    bootconfig: Extend the magic check range to the preceding 3 bytes

Theodore Ts'o <tytso@mit.edu>
    jbd2: fix up sparse warnings in checkpoint code

Dan Carpenter <dan.carpenter@oracle.com>
    futex: Don't enable IRQs unconditionally in put_pi_state()

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: protect mei_cl_mtu from null dereference

Alexander Lobakin <alobakin@pm.me>
    virtio: virtio_console: fix DMA memory allocation for rproc serial

Zhang Qilong <zhangqilong3@huawei.com>
    xhci: hisilicon: fix refercence leak in xhci_histb_probe

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Report power supply changes

Chris Brandt <chris.brandt@renesas.com>
    usb: cdc-acm: Add DISABLE_ECHO for Renesas USB Download mode

Geert Uytterhoeven <geert+renesas@glider.be>
    Revert "usb: musb: convert to devm_platform_ioremap_resource_byname"

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    uio: Fix use-after-free in uio_unregister_device()

Petr Vorel <pvorel@suse.cz>
    loop: Fix occasional uevent drop

Christoph Hellwig <hch@lst.de>
    block: add a return value to set_capacity_revalidate_and_notify

Jing Xiangfeng <jingxiangfeng@huawei.com>
    thunderbolt: Add the missed ida_simple_remove() in ring_request_msix()

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Fix memory leak if ida_simple_get() fails in enumerate_services()

Samuel Thibault <samuel.thibault@ens-lyon.org>
    speakup: Fix clearing selection in safe context

Samuel Thibault <samuel.thibault@ens-lyon.org>
    speakup ttyio: Do not schedule() in ttyio_in_nowait

Samuel Thibault <samuel.thibault@ens-lyon.org>
    speakup: Fix var_id_t values and thus keymap

Andrew Jones <drjones@redhat.com>
    KVM: arm64: Don't hide ID registers from userspace

Anand Jain <anand.jain@oracle.com>
    btrfs: dev-replace: fail mount if we don't have replace item with target device

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix min reserved size calculation in merge_reloc_root

Dinghao Liu <dinghao.liu@zju.edu.cn>
    btrfs: ref-verify: fix memory leak in btrfs_ref_tree_mod

Matthew Wilcox (Oracle) <willy@infradead.org>
    btrfs: fix potential overflow in cluster_pages_for_defrag on 32bit arch

Joseph Qi <joseph.qi@linux.alibaba.com>
    ext4: unlock xattr_sem properly in ext4_inline_data_truncate()

Kaixu Xia <kaixuxia@tencent.com>
    ext4: correctly report "not supported" for {usr,grp}jquota when !CONFIG_QUOTA

Gao Xiang <hsiangkao@redhat.com>
    erofs: derive atime instead of leaving it empty

Gao Xiang <hsiangkao@redhat.com>
    erofs: fix setting up pcluster for temporary pages

Arnd Bergmann <arnd@arndb.de>
    firmware: xilinx: fix out-of-bounds access

Peter Zijlstra <peterz@infradead.org>
    perf: Fix event multiplexing for exclusive groups

Peter Zijlstra <peterz@infradead.org>
    perf: Simplify group_sched_in()

Sagi Grimberg <sagi@grimberg.me>
    nvme: fix incorrect behavior when BLKROSET is called by the user

Sasha Levin <sashal@kernel.org>
    nvme: freeze the queue over ->lba_shift updates

Christoph Hellwig <hch@lst.de>
    nvme: factor out a nvme_configure_metadata helper

Peter Zijlstra <peterz@infradead.org>
    perf: Fix get_recursion_context()

David Howells <dhowells@redhat.com>
    afs: Fix afs_write_end() when called with copied == 0 [ver #3]

Muchun Song <songmuchun@bytedance.com>
    mm: memcontrol: fix missing wakeup polling thread

Santosh Sivaraj <santosh@fossix.org>
    kernel/watchdog: fix watchdog_allowed_mask not used warning

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: Validate hotplug range before creating linear mapping

Sven Van Asbroeck <thesven73@gmail.com>
    lan743x: fix use of uninitialized variable

Martin Willi <martin@strongswan.org>
    vrf: Fix fast path output packet handling with async Netfilter rules

Chuck Lever <chuck.lever@oracle.com>
    NFS: Fix listxattr receive buffer size

Brad Campbell <brad@fnarfbargle.com>
    hwmon: (applesmc) Re-work SMC comms

Wang Hai <wanghai38@huawei.com>
    cosa: Add missing kfree in error path of cosa_write

Rohit Maheshwari <rohitm@chelsio.com>
    ch_ktls: tcb update fails sometimes

Rohit Maheshwari <rohitm@chelsio.com>
    ch_ktls: Update cheksum information

Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>
    of/address: Fix of_node memory leak in of_dma_is_coherent

Christoph Hellwig <hch@lst.de>
    xfs: fix a missing unlock on error in xfs_fs_map_blocks

Sven Van Asbroeck <thesven73@gmail.com>
    lan743x: fix "BUG: invalid wait context" when setting rx mode

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix brainos in the refcount scrubber's rmap fragment processor

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix rmap key and record comparison functions

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: set the unwritten bit in rmap lookup flags in xchk_bmap_get_rmapextents

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix flags argument to rmap lookup when converting shared file rmaps

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: realtek: support paged operations on RTL8201CP

Sven Van Asbroeck <thesven73@gmail.com>
    lan743x: correctly handle chips with internal PHY

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igc: Fix returning wrong statistics

Slawomir Laba <slawomirx.laba@intel.com>
    i40e: Fix MAC address setting for a VF via Host/VM

Vlad Buslov <vlad@buslov.dev>
    selftest: fix flower terse dump tests

Christoph Hellwig <hch@lst.de>
    nbd: fix a block_device refcount leak in nbd_release

Bjorn Andersson <bjorn.andersson@linaro.org>
    pinctrl: qcom: sm8250: Specify PDC map

Maulik Shah <mkshah@codeaurora.org>
    pinctrl: qcom: Move clearing pending IRQ to .irq_request_resources callback

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: disable hw csum for short packets on all chip versions

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix potential skb double free in an error path

David Verbeiren <david.verbeiren@tessares.net>
    bpf: Zero-fill re-used per-cpu map element

Lorenz Bauer <lmb@cloudflare.com>
    tools/bpftool: Fix attaching flow dissector

Dai Ngo <dai.ngo@oracle.com>
    NFSD: fix missing refcount in nfsd4_copy by nfsd4_do_async_copy

Dai Ngo <dai.ngo@oracle.com>
    NFSD: Fix use-after-free warning when doing inter-server copy

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix general protection fault in trace_rpc_xdr_overflow()

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Fix incorrect access of RCU-protected xdp_prog

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix VXLAN synchronization after function reload

Parav Pandit <parav@nvidia.com>
    net/mlx5: E-switch, Avoid extack error log for disabled vport

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Fix deletion of duplicate rules

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Use spin_lock_bh for async_icosq_lock

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Protect encap route dev from concurrent release

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Fix modify header actions memory leak

Billy Tsai <billy_tsai@aspeedtech.com>
    pinctrl: aspeed: Fix GPI only function problem.

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: mcp23s08: Use full chunk of memory for regmap configuration

Ian Rogers <irogers@google.com>
    libbpf, hashmap: Fix undefined behavior in hash_bits

Ard Biesheuvel <ardb@kernel.org>
    bpf: Don't rely on GCC __attribute__((optimize)) to disable GCSE

Andrew Jeffery <andrew@aj.id.au>
    ARM: 9019/1: kprobes: Avoid fortify_panic() when copying optprobe template

Billy Tsai <billy_tsai@aspeedtech.com>
    gpio: aspeed: fix ast2600 bank properties

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Set default bias in case no particular value given

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Fix 2 kOhm bias which is 833 Ohm

Baolin Wang <baolin.wang7@gmail.com>
    mfd: sprd: Add wakeup capability for PMIC IRQ

Martin Hundebøll <martin@geanix.com>
    spi: bcm2835: remove use of uninitialized gpio flags variable

Jerry Snitselaar <jsnitsel@redhat.com>
    tpm_tis: Disable interrupts on ThinkPad T490s

Michael Wu <michael.wu@vatics.com>
    i2c: designware: slave should do WRITE_REQUESTED before WRITE_RECEIVED

Michael Wu <michael.wu@vatics.com>
    i2c: designware: call i2c_dw_read_clear_intrbits_slave() once

Ulrich Hecht <uli+renesas@fpond.eu>
    i2c: sh_mobile: implement atomic transfers

Sean Anderson <seanga2@gmail.com>
    riscv: Set text_offset correctly for M-Mode

Benjamin Gwin <bgwin@google.com>
    arm64: kexec_file: try more regions if loading segments fails

Tommi Rantala <tommi.t.rantala@nokia.com>
    selftests: proc: fix warning: _GNU_SOURCE redefined

Brian Foster <bfoster@redhat.com>
    iomap: clean up writeback state logic on writepage error

Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>
    amd/amdgpu: Disable VCN DPG mode for Picasso

Qii Wang <qii.wang@mediatek.com>
    i2c: mediatek: move dma reset before i2c reset

Fred Gao <fred.gao@intel.com>
    vfio/pci: Bypass IGD init in case of -ENODEV

Zhang Qilong <zhangqilong3@huawei.com>
    vfio: platform: fix reference leak in vfio_platform_open

Qian Cai <cai@redhat.com>
    s390/smp: move rcu_cpu_starting() earlier

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Increase interrupt remapping table limit to 512 entries

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: avoid repeated request completion

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: avoid repeated request completion

Chao Leng <lengchao@huawei.com>
    nvme-tcp: avoid race between time out and tear down

Chao Leng <lengchao@huawei.com>
    nvme-rdma: avoid race between time out and tear down

Chao Leng <lengchao@huawei.com>
    nvme: introduce nvme_sync_io_queues

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix timeouts observed while reenabling IRQ

Hannes Reinecke <hare@suse.de>
    scsi: scsi_dh_alua: Avoid crash during alua_bus_detach()

Vineet Gupta <vgupta@synopsys.com>
    ARC: [plat-hsdk] Remap CCMs super early in asm boot trampoline

Keith Busch <kbusch@kernel.org>
    Revert "nvme-pci: remove last_sq_tail"

Qiujun Huang <hqjagain@gmail.com>
    tracing: Fix the checking of stackidx in __ftrace_trace_stack

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: selftests: check that route_me_harder packets use the right sk

Ye Bin <yebin10@huawei.com>
    cfg80211: regulatory: Fix inconsistent format argument

Johannes Berg <johannes.berg@intel.com>
    mac80211: always wind down STA state

Johannes Berg <johannes.berg@intel.com>
    cfg80211: initialize wdev data earlier

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix use of skb payload instead of header

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: do not use ixFEATURE_STATUS for checking smc running

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: perform SMC reset on suspend/hibernation

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: correct the baco reset sequence for CI ASICs

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: perform srbm soft reset always on SDMA resume

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    scsi: hpsa: Fix memory leak in hpsa_init_one()

Bob Peterson <rpeterso@redhat.com>
    gfs2: check for live vs. read-only file system in gfs2_fitrim

Bob Peterson <rpeterso@redhat.com>
    gfs2: Add missing truncate_inode_pages_final for sd_aspace

Bob Peterson <rpeterso@redhat.com>
    gfs2: Free rd_bits later in gfs2_clear_rgrpd to fix use-after-free

Joerg Roedel <jroedel@suse.de>
    x86/boot/compressed/64: Introduce sev_status

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda: Reinstate runtime_allow() for all hda controllers

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda: Separate runtime and system suspend

Tommi Rantala <tommi.t.rantala@nokia.com>
    selftests: pidfd: fix compilation errors due to wait.h

Colin Ian King <colin.king@canonical.com>
    selftests/ftrace: check for do_sys_openat2 in user-memory test

Zqiang <qiang.zhang@windriver.com>
    usb: raw-gadget: fix memory leak in gadget_setup

Evgeny Novikov <novikov@ispras.ru>
    usb: gadget: goku_udc: fix potential crashes in probe

Viresh Kumar <viresh.kumar@linaro.org>
    opp: Reduce the size of critical section in _opp_table_kref_release()

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Alder Lake-S

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: SOF: loader: handle all SOF_IPC_EXT types

Olivier Moysan <olivier.moysan@st.com>
    ASoC: cs42l51: manage mclk shutdown delay

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qcom: sdm845: set driver name correctly

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: mediatek: mt8183-da7219: fix DAPM paths for rt1015

Pujin Shi <shipujin.t@gmail.com>
    scsi: ufs: Fix missing brace warning for old compilers

Masashi Honma <masashi.honma@gmail.com>
    ath9k_htc: Use appropriate rs_datalen type

Stephen Boyd <swboyd@chromium.org>
    KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return SMCCC_RET_NOT_REQUIRED

Tyler Hicks <tyhicks@linux.microsoft.com>
    tpm: efi: Don't create binary_bios_measurements file for an empty log

Zhang Qilong <zhangqilong3@huawei.com>
    USB: apple-mfi-fastcharge: fix reference leak in apple_mfi_fc_set_property

Palmer Dabbelt <palmerdabbelt@google.com>
    RISC-V: Fix the VDSO symbol generaton for binutils-2.35+

Bill Wendling <morbo@google.com>
    kbuild: explicitly specify the build id style

Anand K Mistry <amistry@google.com>
    x86/speculation: Allow IBPB to be conditionally enabled on CPUs with always-on STIBP

Tommi Rantala <tommi.t.rantala@nokia.com>
    selftests: binderfs: use SKIP instead of XFAIL

Tommi Rantala <tommi.t.rantala@nokia.com>
    selftests: clone3: use SKIP instead of XFAIL

Tommi Rantala <tommi.t.rantala@nokia.com>
    selftests: core: use SKIP instead of XFAIL in close_range_test.c

Jeff Layton <jlayton@kernel.org>
    ceph: check session state after bumping session->s_seq

Rob Herring <robh@kernel.org>
    PCI: mvebu: Fix duplicate resource requests

Zhao Qiang <qiang.zhao@nxp.com>
    spi: fsl-dspi: fix wrong pointer in suspend/resume

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure consistent view of original task ->mm from SQPOLL

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix scrub flagging rtinherit even if there is no rt device

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix missing CoW blocks writeback conversion retry

Brian Foster <bfoster@redhat.com>
    xfs: flush new eof page on truncate to avoid post-eof corruption

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: flexcan_remove(): disable wakeup completely

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: remove FLEXCAN_QUIRK_DISABLE_MECR quirk for LS1021A

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_canfd: pucan_handle_can_rx(): fix echo management when loopback is on

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: peak_usb_get_ts_time(): fix timestamp wrapping

Dan Carpenter <dan.carpenter@oracle.com>
    can: peak_usb: add range checking in decode operations

Navid Emamdoost <navid.emamdoost@gmail.com>
    can: xilinx_can: handle failure cases of pm_runtime_get_sync

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: ti_hecc: ti_hecc_probe(): add missed clk_disable_unprepare() in error path

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: j1939_sk_bind(): return failure if netdev is down

Yegor Yefremov <yegorslists@googlemail.com>
    can: j1939: swap addr and pgn in the send example

Oleksij Rempel <linux@rempel-privat.de>
    can: can_create_echo_skb(): fix echo skb generation: always use skb_clone()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: dev: __can_get_echo_skb(): fix real payload length return value for RTR frames

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: dev: can_get_echo_skb(): prevent call to kfree_skb() in hard IRQ context

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rx-offload: don't call kfree_skb() from IRQ context

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Implement ioeventfd thread handler for contended memory lock

David Howells <dhowells@redhat.com>
    afs: Fix incorrect freeing of the ACL passed to the YFS ACL store op

David Howells <dhowells@redhat.com>
    afs: Fix warning due to unadvanced marshalling pointer

Liu, Yi L <yi.l.liu@intel.com>
    iommu/vt-d: Fix a bug for PDP check in prq_event_thread

Liu Yi L <yi.l.liu@intel.com>
    iommu/vt-d: Fix sid not set issue in intel_svm_bind_gpasid()

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: hda: prevent undefined shift in snd_hdac_ext_bus_get_link()

Namhyung Kim <namhyung@kernel.org>
    perf tools: Add missing swap for cgroup events

Jiri Olsa <jolsa@kernel.org>
    perf tools: Add missing swap for ino_generation

Stanislav Ivanichkin <sivanichkin@yandex-team.ru>
    perf trace: Fix segfault when trying to trace events by cgroup

Steven Price <steven.price@arm.com>
    drm/panfrost: Fix module unload

Clément Péron <peron.clem@gmail.com>
    drm/panfrost: move devfreq_init()/fini() in device

Clément Péron <peron.clem@gmail.com>
    drm/panfrost: rename error labels in device_init

zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
    mm: memcontrol: correct the NR_ANON_THPS counter of hierarchical memcg

Maor Gottlieb <maorg@nvidia.com>
    IB/srpt: Fix memory leak in srpt_add_one

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: bo: Add a managed action to cleanup the cache

Qian Cai <cai@redhat.com>
    powerpc/eeh_cache: Fix a possible debugfs deadlock

Greentime Hu <greentime.hu@sifive.com>
    irqchip/sifive-plic: Fix chip_data access within a hierarchy

Stefano Brivio <sbrivio@redhat.com>
    netfilter: ipset: Update byte and packet counters regardless of whether they match

Rajat Jain <rajatja@google.com>
    PCI: Always enable ACS even if no ACS Capability

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: missing validation from the abort path

Jason A. Donenfeld <Jason@zx2c4.com>
    netfilter: use actual socket sk rather than skb sk when routing harder

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables: fix netlink report logic in flowtable and genid

Johannes Berg <johannes.berg@intel.com>
    mac80211: don't require VHT elements for HE on 2.4 GHz

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: set xefi_discard when creating a deferred agfl free log intent item

Bert Vermeulen <bert@biot.com>
    mtd: spi-nor: Fix address width on flash chips > 16MB

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd9335: Set digital gain range correctly

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd934x: Set digital gain range correctly

Tommi Rantala <tommi.t.rantala@nokia.com>
    selftests: filter kselftest headers from command in lib.mk

Ran Wang <ran.wang_1@nxp.com>
    usb: gadget: fsl: fix null pointer checking

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    kunit: Don't fail test suites if one of them is empty

David Gow <davidgow@google.com>
    kunit: Fix kunit.py --raw_output option

Greentime Hu <greentime.hu@sifive.com>
    irqchip/sifive-plic: Fix broken irq_set_affinity() callback

Sascha Hauer <s.hauer@pengutronix.de>
    spi: imx: fix runtime pm support for !CONFIG_PM

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wsa881x: add missing stream rates and format

zhuoliang zhang <zhuoliang.zhang@mediatek.com>
    net: xfrm: fix a race condition during allocing spi

Olaf Hering <olaf@aepfle.de>
    hv_balloon: disable warning when floor reached

Marc Zyngier <maz@kernel.org>
    genirq: Let GENERIC_IRQ_IPI select IRQ_DOMAIN_HIERARCHY

Tomasz Figa <tfiga@chromium.org>
    ASoC: Intel: kbl_rt5663_max98927: Fix kabylake_ssp_fixup function

Xin Long <lucien.xin@gmail.com>
    xfrm: interface: fix the priorities for ipip and ipv6 tunnels

Santosh Shukla <sashukla@nvidia.com>
    KVM: arm64: Force PTE mapping on fault resulting in a device mapping

Ming Lei <ming.lei@redhat.com>
    nbd: don't update block size after device is started

Roman Gushchin <guro@fb.com>
    mm: memcg: link page counters to root if use_hierarchy is false

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gem: Flush coherency domains on first set-domain-ioctl

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Hold onto an explicit ref to i915_vma_work.pinned


-------------

Diffstat:

 Documentation/networking/j1939.rst                 |   4 +-
 Makefile                                           |   8 +-
 arch/arc/kernel/head.S                             |  17 +-
 arch/arc/plat-hsdk/platform.c                      |  17 --
 arch/arm/include/asm/kprobes.h                     |  22 +--
 arch/arm/probes/kprobes/opt-arm.c                  |  18 +-
 arch/arm/vdso/Makefile                             |   2 +-
 arch/arm64/kernel/kexec_image.c                    |  41 +++-
 arch/arm64/kernel/machine_kexec_file.c             |   9 +-
 arch/arm64/kernel/vdso/Makefile                    |   2 +-
 arch/arm64/kernel/vdso32/Makefile                  |   2 +-
 arch/arm64/kvm/hypercalls.c                        |   2 +-
 arch/arm64/kvm/mmu.c                               |   1 +
 arch/arm64/kvm/sys_regs.c                          |  18 +-
 arch/arm64/mm/mmu.c                                |  17 ++
 arch/mips/vdso/Makefile                            |   2 +-
 arch/powerpc/kernel/eeh_cache.c                    |   5 +-
 arch/powerpc/kernel/head_32.S                      |  12 --
 arch/riscv/kernel/head.S                           |   5 +
 arch/riscv/kernel/vdso/.gitignore                  |   1 +
 arch/riscv/kernel/vdso/Makefile                    |  18 +-
 arch/riscv/kernel/vdso/so2s.sh                     |   6 +
 arch/s390/kernel/smp.c                             |   3 +-
 arch/s390/kernel/vdso64/Makefile                   |   2 +-
 arch/sparc/vdso/Makefile                           |   2 +-
 arch/x86/boot/compressed/mem_encrypt.S             |  16 +-
 arch/x86/entry/vdso/Makefile                       |   2 +-
 arch/x86/kernel/cpu/bugs.c                         |  51 +++--
 block/genhd.c                                      |   5 +-
 drivers/accessibility/speakup/main.c               |   1 -
 drivers/accessibility/speakup/selection.c          |  11 +-
 drivers/accessibility/speakup/speakup.h            |   1 -
 drivers/accessibility/speakup/spk_ttyio.c          |  10 +-
 drivers/accessibility/speakup/spk_types.h          |   8 +-
 drivers/block/loop.c                               |   3 +-
 drivers/block/nbd.c                                |  10 +-
 drivers/block/null_blk.h                           |   1 +
 drivers/block/null_blk_zoned.c                     |  31 ++-
 drivers/char/tpm/eventlog/efi.c                    |   5 +
 drivers/char/tpm/tpm_tis.c                         |  29 ++-
 drivers/char/virtio_console.c                      |   8 +-
 drivers/cpufreq/cpufreq.c                          |   4 +-
 drivers/cpufreq/cpufreq_governor.h                 |   2 +-
 drivers/cpufreq/cpufreq_performance.c              |   1 +
 drivers/cpufreq/cpufreq_powersave.c                |   1 +
 drivers/cpufreq/intel_pstate.c                     |  16 +-
 drivers/crypto/chelsio/chcr_ktls.c                 |  27 ++-
 drivers/firmware/xilinx/zynqmp.c                   |   3 +
 drivers/gpio/gpio-aspeed.c                         |   1 +
 drivers/gpio/gpio-pcie-idio-24.c                   |  62 +++++-
 drivers/gpio/gpio-sifive.c                         |   2 +-
 drivers/gpu/drm/amd/amdgpu/cik_sdma.c              |  27 ++-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   3 +-
 .../amd/display/dc/irq/dcn30/irq_service_dcn30.c   |   4 +-
 drivers/gpu/drm/amd/powerplay/hwmgr/ci_baco.c      |   7 +-
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c   |   4 +
 drivers/gpu/drm/amd/powerplay/inc/hwmgr.h          |   1 +
 drivers/gpu/drm/amd/powerplay/inc/smumgr.h         |   2 +
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c   |  29 ++-
 drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c      |   8 +
 drivers/gpu/drm/gma500/psb_irq.c                   |  34 ++--
 drivers/gpu/drm/i915/gem/i915_gem_domain.c         |  28 ++-
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |   3 +-
 drivers/gpu/drm/i915/i915_vma.c                    |   6 +-
 drivers/gpu/drm/panfrost/panfrost_device.c         |  40 ++--
 drivers/gpu/drm/panfrost/panfrost_drv.c            |  20 +-
 drivers/gpu/drm/vc4/vc4_bo.c                       |   5 +-
 drivers/gpu/drm/vc4/vc4_drv.c                      |   1 -
 drivers/gpu/drm/vc4/vc4_drv.h                      |   2 +-
 drivers/hv/hv_balloon.c                            |   2 +-
 drivers/hwmon/amd_energy.c                         |   2 +-
 drivers/hwmon/applesmc.c                           | 130 ++++++++-----
 drivers/hwtracing/coresight/coresight-etm-perf.c   |   4 +-
 drivers/i2c/busses/i2c-designware-slave.c          |  52 ++---
 drivers/i2c/busses/i2c-mt65xx.c                    |   8 +-
 drivers/i2c/busses/i2c-sh_mobile.c                 |  86 +++++++--
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  13 +-
 drivers/iommu/amd/amd_iommu_types.h                |   6 +-
 drivers/iommu/intel/svm.c                          |   8 +-
 drivers/irqchip/irq-sifive-plic.c                  |  10 +-
 drivers/mfd/sprd-sc27xx-spi.c                      |  28 ++-
 drivers/misc/mei/client.h                          |   4 +-
 drivers/mmc/host/renesas_sdhi_core.c               |   1 +
 drivers/mmc/host/sdhci-of-esdhc.c                  |   2 +
 drivers/mtd/spi-nor/core.c                         |   8 +-
 drivers/net/can/dev.c                              |  14 +-
 drivers/net/can/flexcan.c                          |   5 +-
 drivers/net/can/peak_canfd/peak_canfd.c            |  11 +-
 drivers/net/can/rx-offload.c                       |   4 +-
 drivers/net/can/ti_hecc.c                          |   8 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  51 ++++-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  48 +++--
 drivers/net/can/xilinx_can.c                       |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  26 ++-
 drivers/net/ethernet/intel/igc/igc_main.c          |  14 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  72 ++++---
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   2 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   7 +-
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.c    |  23 ++-
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.h    |   2 +
 drivers/net/ethernet/microchip/lan743x_main.c      |  24 +--
 drivers/net/ethernet/microchip/lan743x_main.h      |   3 -
 drivers/net/ethernet/realtek/r8169_main.c          |  18 +-
 drivers/net/phy/realtek.c                          |   2 +
 drivers/net/vrf.c                                  |  92 ++++++---
 drivers/net/wan/cosa.c                             |   1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   2 +-
 drivers/nvme/host/core.c                           | 106 ++++++----
 drivers/nvme/host/nvme.h                           |   1 +
 drivers/nvme/host/pci.c                            |  23 ++-
 drivers/nvme/host/rdma.c                           |  14 +-
 drivers/nvme/host/tcp.c                            |  16 +-
 drivers/of/address.c                               |   4 +-
 drivers/opp/core.c                                 |   7 +-
 drivers/pci/controller/pci-mvebu.c                 |  23 +--
 drivers/pci/pci.c                                  |   9 +-
 drivers/pinctrl/aspeed/pinctrl-aspeed.c            |   7 +-
 drivers/pinctrl/intel/pinctrl-intel.c              |  40 +++-
 drivers/pinctrl/pinctrl-amd.c                      |   6 +-
 drivers/pinctrl/pinctrl-mcp23s08_spi.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  32 +--
 drivers/pinctrl/qcom/pinctrl-sm8250.c              |  18 ++
 drivers/scsi/device_handler/scsi_dh_alua.c         |   9 +-
 drivers/scsi/hpsa.c                                |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   7 +
 drivers/scsi/ufs/ufshcd-crypto.c                   |   4 +-
 drivers/spi/spi-bcm2835.c                          |   3 +-
 drivers/spi/spi-fsl-dspi.c                         |  10 +-
 drivers/spi/spi-imx.c                              |  23 ++-
 drivers/thunderbolt/nhi.c                          |  19 +-
 drivers/thunderbolt/xdomain.c                      |   1 +
 drivers/uio/uio.c                                  |  10 +-
 drivers/usb/class/cdc-acm.c                        |   9 +
 drivers/usb/dwc3/dwc3-pci.c                        |   4 +
 drivers/usb/gadget/legacy/raw_gadget.c             |   5 +-
 drivers/usb/gadget/udc/fsl_udc_core.c              |   2 +-
 drivers/usb/gadget/udc/goku_udc.c                  |   2 +-
 drivers/usb/host/xhci-histb.c                      |   2 +-
 drivers/usb/misc/apple-mfi-fastcharge.c            |   4 +-
 drivers/usb/musb/musb_dsps.c                       |   4 +-
 drivers/usb/typec/ucsi/psy.c                       |   9 +
 drivers/usb/typec/ucsi/ucsi.c                      |   7 +-
 drivers/usb/typec/ucsi/ucsi.h                      |   2 +
 drivers/vfio/pci/vfio_pci.c                        |   2 +-
 drivers/vfio/pci/vfio_pci_rdwr.c                   |  43 ++++-
 drivers/vfio/platform/vfio_platform_common.c       |   3 +-
 fs/afs/write.c                                     |   5 +-
 fs/afs/xattr.c                                     |   7 +-
 fs/afs/yfsclient.c                                 |   1 +
 fs/btrfs/dev-replace.c                             |  26 ++-
 fs/btrfs/ioctl.c                                   |  10 +-
 fs/btrfs/ref-verify.c                              |   1 +
 fs/btrfs/relocation.c                              |   4 +-
 fs/btrfs/volumes.c                                 |  26 +--
 fs/ceph/caps.c                                     |   2 +-
 fs/ceph/mds_client.c                               |  50 +++--
 fs/ceph/mds_client.h                               |   1 +
 fs/ceph/quota.c                                    |   2 +-
 fs/ceph/snap.c                                     |   2 +-
 fs/cifs/cifs_unicode.c                             |   8 +-
 fs/erofs/inode.c                                   |  21 +-
 fs/erofs/zdata.c                                   |   7 +-
 fs/ext4/inline.c                                   |   1 +
 fs/ext4/super.c                                    |   4 +-
 fs/gfs2/rgrp.c                                     |   5 +-
 fs/gfs2/super.c                                    |   1 +
 fs/io_uring.c                                      |  29 ++-
 fs/iomap/buffered-io.c                             |  15 +-
 fs/jbd2/checkpoint.c                               |   2 +
 fs/jbd2/transaction.c                              |   4 +-
 fs/nfs/nfs42xattr.c                                |   2 +
 fs/nfs/nfs42xdr.c                                  |   4 +-
 fs/nfsd/nfs4proc.c                                 |   3 +-
 fs/ocfs2/super.c                                   |   1 +
 fs/xfs/libxfs/xfs_alloc.c                          |   1 +
 fs/xfs/libxfs/xfs_bmap.h                           |   2 +-
 fs/xfs/libxfs/xfs_rmap.c                           |   2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c                     |  16 +-
 fs/xfs/scrub/bmap.c                                |   2 +
 fs/xfs/scrub/inode.c                               |   3 +-
 fs/xfs/scrub/refcount.c                            |   8 +-
 fs/xfs/xfs_aops.c                                  |   6 +-
 fs/xfs/xfs_iops.c                                  |  10 +
 fs/xfs/xfs_pnfs.c                                  |   2 +-
 include/linux/arm-smccc.h                          |   2 +
 include/linux/can/skb.h                            |  20 +-
 include/linux/compiler-gcc.h                       |   2 -
 include/linux/compiler_types.h                     |   4 -
 include/linux/cpufreq.h                            |  18 +-
 include/linux/genhd.h                              |   2 +-
 include/linux/memcontrol.h                         |  11 +-
 include/linux/netfilter/nfnetlink.h                |   9 +-
 include/linux/netfilter_ipv4.h                     |   2 +-
 include/linux/netfilter_ipv6.h                     |  10 +-
 include/trace/events/sunrpc.h                      |   8 +-
 init/main.c                                        |  14 +-
 kernel/bpf/Makefile                                |   6 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/bpf/hashtab.c                               |  30 ++-
 kernel/dma/swiotlb.c                               |   6 +-
 kernel/events/core.c                               |  12 +-
 kernel/events/internal.h                           |   2 +-
 kernel/exit.c                                      |   5 +-
 kernel/futex.c                                     |   5 +-
 kernel/irq/Kconfig                                 |   1 +
 kernel/reboot.c                                    |  28 +--
 kernel/sched/cpufreq_schedutil.c                   |   2 +-
 kernel/trace/trace.c                               |   4 +-
 kernel/watchdog.c                                  |   4 +-
 mm/compaction.c                                    |  12 +-
 mm/gup.c                                           |  14 +-
 mm/hugetlb.c                                       |  90 +--------
 mm/memcontrol.c                                    |  28 ++-
 mm/memory-failure.c                                |  36 ++--
 mm/migrate.c                                       |  44 +++--
 mm/rmap.c                                          |   5 +-
 mm/slub.c                                          |   2 +-
 mm/vmscan.c                                        |   5 +-
 net/can/j1939/socket.c                             |   6 +
 net/core/devlink.c                                 |   8 +-
 net/ethtool/features.c                             |   2 +-
 net/ipv4/ip_tunnel_core.c                          |   4 +-
 net/ipv4/netfilter.c                               |   8 +-
 net/ipv4/netfilter/iptable_mangle.c                |   2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   2 +-
 net/ipv4/syncookies.c                              |   9 +-
 net/ipv4/udp_offload.c                             |  19 +-
 net/ipv4/xfrm4_tunnel.c                            |   4 +-
 net/ipv6/netfilter.c                               |   6 +-
 net/ipv6/netfilter/ip6table_mangle.c               |   2 +-
 net/ipv6/sit.c                                     |   2 -
 net/ipv6/syncookies.c                              |  10 +-
 net/ipv6/udp_offload.c                             |  17 +-
 net/ipv6/xfrm6_tunnel.c                            |   4 +-
 net/iucv/af_iucv.c                                 |   3 +-
 net/mac80211/mlme.c                                |   3 +-
 net/mac80211/sta_info.c                            |  18 ++
 net/mac80211/tx.c                                  |  37 ++--
 net/mptcp/protocol.c                               |   1 +
 net/netfilter/ipset/ip_set_core.c                  |   3 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   4 +-
 net/netfilter/nf_nat_proto.c                       |   4 +-
 net/netfilter/nf_synproxy_core.c                   |   2 +-
 net/netfilter/nf_tables_api.c                      |  19 +-
 net/netfilter/nfnetlink.c                          |  22 ++-
 net/netfilter/nft_chain_route.c                    |   4 +-
 net/netfilter/utils.c                              |   4 +-
 net/tipc/topsrv.c                                  |  10 +-
 net/wireless/core.c                                |  57 +++---
 net/wireless/core.h                                |   5 +-
 net/wireless/nl80211.c                             |   3 +-
 net/wireless/reg.c                                 |   2 +-
 net/x25/af_x25.c                                   |   2 +-
 net/xfrm/xfrm_interface.c                          |   8 +-
 net/xfrm/xfrm_state.c                              |   8 +-
 security/selinux/ibpkey.c                          |   4 +-
 sound/hda/ext/hdac_ext_controller.c                |   2 +
 sound/pci/hda/hda_controller.h                     |   3 +-
 sound/pci/hda/hda_intel.c                          |  63 +++---
 sound/soc/codecs/cs42l51.c                         |  22 ++-
 sound/soc/codecs/wcd9335.c                         |   2 +-
 sound/soc/codecs/wcd934x.c                         |   2 +-
 sound/soc/codecs/wsa881x.c                         |   2 +
 sound/soc/intel/boards/kbl_rt5663_max98927.c       |  39 +++-
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c |  31 ++-
 sound/soc/qcom/sdm845.c                            |   2 +
 sound/soc/sof/loader.c                             |   5 +
 tools/bpf/bpftool/prog.c                           |   2 +-
 tools/lib/bpf/hashmap.h                            |  15 +-
 tools/perf/builtin-trace.c                         |  15 +-
 .../util/scripting-engines/trace-event-python.c    |   7 +-
 tools/perf/util/session.c                          |  14 ++
 tools/testing/kunit/kunit_parser.py                |   3 +-
 tools/testing/selftests/bpf/Makefile               |   2 +-
 tools/testing/selftests/bpf/prog_tests/map_init.c  | 214 +++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_map_init.c  |  33 ++++
 .../clone3/clone3_cap_checkpoint_restore.c         |   2 +-
 tools/testing/selftests/core/close_range_test.c    |   8 +-
 .../selftests/filesystems/binderfs/binderfs_test.c |   8 +-
 .../ftrace/test.d/kprobe/kprobe_args_user.tc       |   4 +
 tools/testing/selftests/lib.mk                     |   2 +-
 tools/testing/selftests/pidfd/pidfd_open_test.c    |   1 -
 tools/testing/selftests/pidfd/pidfd_poll_test.c    |   1 -
 tools/testing/selftests/proc/proc-loadavg-001.c    |   1 -
 tools/testing/selftests/proc/proc-self-syscall.c   |   1 -
 tools/testing/selftests/proc/proc-uptime-002.c     |   1 -
 .../tc-testing/tc-tests/filters/tests.json         |   4 +-
 tools/testing/selftests/wireguard/netns.sh         |   8 +
 .../testing/selftests/wireguard/qemu/kernel.config |   2 +
 297 files changed, 2450 insertions(+), 1241 deletions(-)


