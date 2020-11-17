Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134A22B658C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731199AbgKQN4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:56:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731175AbgKQNWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:22:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC4842464E;
        Tue, 17 Nov 2020 13:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619358;
        bh=Eep4ezRWY1u6u9OH+XEr43lEUPFZ8XtJ/vxfhd7sOPQ=;
        h=From:To:Cc:Subject:Date:From;
        b=g/x7z45fji2558k8O52uBFiogWzt0BlZbOaRPPQgrw81wKfMyLLcfrPhqR3BZ+pQr
         w2uzKfId6qpvV2gVdBS3nMMroRoveaeZeMDO7Zuyfw/mWrL33Uugvn+9X/ns/4QRbG
         eZlYFG4lKv9Oo14W2yvnP98RBacMIEOxCocezuVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.4 000/151] 5.4.78-rc1 review
Date:   Tue, 17 Nov 2020 14:03:50 +0100
Message-Id: <20201117122121.381905960@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.78-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.78-rc1
X-KernelTest-Deadline: 2020-11-19T12:21+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.78 release.
There are 151 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.78-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.78-rc1

Boris Protopopov <pboris@amazon.com>
    Convert trailing spaces and periods in path components

Yunsheng Lin <linyunsheng@huawei.com>
    net: sch_generic: fix the missing new qdisc assignment bug

Jiri Olsa <jolsa@redhat.com>
    perf/core: Fix race in the perf_mmap_close() function

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf scripting python: Avoid declaring function pointers with a visibility attribute

Anand K Mistry <amistry@google.com>
    x86/speculation: Allow IBPB to be conditionally enabled on CPUs with always-on STIBP

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/603: Always fault when _PAGE_ACCESSED is not set

Venkata Sandeep Dhanalakota <venkata.s.dhanalakota@intel.com>
    drm/i915: Correctly set SFC capability for video engines

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix potential skb double free in an error path

Wang Hai <wanghai38@huawei.com>
    tipc: fix memory leak in tipc_topsrv_start()

Martin Schiller <ms@dev.tdt.de>
    net/x25: Fix null-ptr-deref in x25_connect

Mao Wenan <wenan.mao@linux.alibaba.com>
    net: Update window_clamp if SOCK_RCVBUF is set

Alexander Lobakin <alobakin@pm.me>
    net: udp: fix UDP header access on Fast/frag0 UDP GRO

Ursula Braun <ubraun@linux.ibm.com>
    net/af_iucv: fix null pointer dereference on shutdown

Oliver Herms <oliver.peter.herms@gmail.com>
    IPv6: Set SIT tunnel hard_header_len to zero

Stefano Stabellini <stefano.stabellini@xilinx.com>
    swiotlb: fix "x86: Don't panic if can not alloc buffer for swiotlb"

Coiby Xu <coiby.xu@gmail.com>
    pinctrl: amd: fix incorrect way to disable debounce filter

Coiby Xu <coiby.xu@gmail.com>
    pinctrl: amd: use higher precision for 512 RtcClk

Thomas Zimmermann <tzimmermann@suse.de>
    drm/gma500: Fix out-of-bounds access to struct drm_device.vblank[]

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

Chen Zhou <chenzhou10@huawei.com>
    selinux: Fix error return code in sel_ib_pkey_sid_slow()

Matthew Wilcox (Oracle) <willy@infradead.org>
    btrfs: fix potential overflow in cluster_pages_for_defrag on 32bit arch

Wengang Wang <wen.gang.wang@oracle.com>
    ocfs2: initialize ip_next_orphan

Matteo Croce <mcroce@microsoft.com>
    reboot: fix overflow parsing reboot cpu number

Matteo Croce <mcroce@microsoft.com>
    Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"

Laurent Dufour <ldufour@linux.ibm.com>
    mm/slub: fix panic in slab_alloc_node()

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

Chris Brandt <chris.brandt@renesas.com>
    usb: cdc-acm: Add DISABLE_ECHO for Renesas USB Download mode

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    uio: Fix use-after-free in uio_unregister_device()

Jing Xiangfeng <jingxiangfeng@huawei.com>
    thunderbolt: Add the missed ida_simple_remove() in ring_request_msix()

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Fix memory leak if ida_simple_get() fails in enumerate_services()

Andrew Jones <drjones@redhat.com>
    KVM: arm64: Don't hide ID registers from userspace

Anand Jain <anand.jain@oracle.com>
    btrfs: dev-replace: fail mount if we don't have replace item with target device

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix min reserved size calculation in merge_reloc_root

Dinghao Liu <dinghao.liu@zju.edu.cn>
    btrfs: ref-verify: fix memory leak in btrfs_ref_tree_mod

Joseph Qi <joseph.qi@linux.alibaba.com>
    ext4: unlock xattr_sem properly in ext4_inline_data_truncate()

Kaixu Xia <kaixuxia@tencent.com>
    ext4: correctly report "not supported" for {usr,grp}jquota when !CONFIG_QUOTA

Gao Xiang <hsiangkao@redhat.com>
    erofs: derive atime instead of leaving it empty

Peter Zijlstra <peterz@infradead.org>
    perf: Fix get_recursion_context()

Martin Willi <martin@strongswan.org>
    vrf: Fix fast path output packet handling with async Netfilter rules

Wang Hai <wanghai38@huawei.com>
    cosa: Add missing kfree in error path of cosa_write

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

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igc: Fix returning wrong statistics

Christoph Hellwig <hch@lst.de>
    nbd: fix a block_device refcount leak in nbd_release

David Verbeiren <david.verbeiren@tessares.net>
    bpf: Zero-fill re-used per-cpu map element

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix general protection fault in trace_rpc_xdr_overflow()

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Fix deletion of duplicate rules

Billy Tsai <billy_tsai@aspeedtech.com>
    pinctrl: aspeed: Fix GPI only function problem.

Ard Biesheuvel <ardb@kernel.org>
    bpf: Don't rely on GCC __attribute__((optimize)) to disable GCSE

Andrew Jeffery <andrew@aj.id.au>
    ARM: 9019/1: kprobes: Avoid fortify_panic() when copying optprobe template

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Set default bias in case no particular value given

Baolin Wang <baolin.wang7@gmail.com>
    mfd: sprd: Add wakeup capability for PMIC IRQ

Chunyan Zhang <zhang.lyra@gmail.com>
    tick/common: Touch watchdog in tick_unfreeze() on all CPUs

Martin Hundebøll <martin@geanix.com>
    spi: bcm2835: remove use of uninitialized gpio flags variable

Jerry Snitselaar <jsnitsel@redhat.com>
    tpm_tis: Disable interrupts on ThinkPad T490s

Ulrich Hecht <uli+renesas@fpond.eu>
    i2c: sh_mobile: implement atomic transfers

Sean Anderson <seanga2@gmail.com>
    riscv: Set text_offset correctly for M-Mode

Tommi Rantala <tommi.t.rantala@nokia.com>
    selftests: proc: fix warning: _GNU_SOURCE redefined

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

Qiujun Huang <hqjagain@gmail.com>
    tracing: Fix the checking of stackidx in __ftrace_trace_stack

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
    drm/amdgpu: perform srbm soft reset always on SDMA resume

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    scsi: hpsa: Fix memory leak in hpsa_init_one()

Bob Peterson <rpeterso@redhat.com>
    gfs2: check for live vs. read-only file system in gfs2_fitrim

Bob Peterson <rpeterso@redhat.com>
    gfs2: Add missing truncate_inode_pages_final for sd_aspace

Bob Peterson <rpeterso@redhat.com>
    gfs2: Free rd_bits later in gfs2_clear_rgrpd to fix use-after-free

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda: Reinstate runtime_allow() for all hda controllers

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda: Separate runtime and system suspend

Tommi Rantala <tommi.t.rantala@nokia.com>
    selftests: pidfd: fix compilation errors due to wait.h

Colin Ian King <colin.king@canonical.com>
    selftests/ftrace: check for do_sys_openat2 in user-memory test

Evgeny Novikov <novikov@ispras.ru>
    usb: gadget: goku_udc: fix potential crashes in probe

Viresh Kumar <viresh.kumar@linaro.org>
    opp: Reduce the size of critical section in _opp_table_kref_release()

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Alder Lake-S

Olivier Moysan <olivier.moysan@st.com>
    ASoC: cs42l51: manage mclk shutdown delay

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qcom: sdm845: set driver name correctly

Masashi Honma <masashi.honma@gmail.com>
    ath9k_htc: Use appropriate rs_datalen type

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: don't expose MSR_IA32_UMWAIT_CONTROL unconditionally

Stephen Boyd <swboyd@chromium.org>
    KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return SMCCC_RET_NOT_REQUIRED

George Spelvin <lkml@sdf.org>
    random32: make prandom_u32() output unpredictable

Tyler Hicks <tyhicks@linux.microsoft.com>
    tpm: efi: Don't create binary_bios_measurements file for an empty log

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix scrub flagging rtinherit even if there is no rt device

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

David Howells <dhowells@redhat.com>
    afs: Fix warning due to unadvanced marshalling pointer

Liu, Yi L <yi.l.liu@intel.com>
    iommu/vt-d: Fix a bug for PDP check in prq_event_thread

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: hda: prevent undefined shift in snd_hdac_ext_bus_get_link()

Jiri Olsa <jolsa@kernel.org>
    perf tools: Add missing swap for ino_generation

Stanislav Ivanichkin <sivanichkin@yandex-team.ru>
    perf trace: Fix segfault when trying to trace events by cgroup

Qian Cai <cai@redhat.com>
    powerpc/eeh_cache: Fix a possible debugfs deadlock

Stefano Brivio <sbrivio@redhat.com>
    netfilter: ipset: Update byte and packet counters regardless of whether they match

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: missing validation from the abort path

Jason A. Donenfeld <Jason@zx2c4.com>
    netfilter: use actual socket sk rather than skb sk when routing harder

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: set xefi_discard when creating a deferred agfl free log intent item

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd9335: Set digital gain range correctly

zhuoliang zhang <zhuoliang.zhang@mediatek.com>
    net: xfrm: fix a race condition during allocing spi

Olaf Hering <olaf@aepfle.de>
    hv_balloon: disable warning when floor reached

Marc Zyngier <maz@kernel.org>
    genirq: Let GENERIC_IRQ_IPI select IRQ_DOMAIN_HIERARCHY

Tomasz Figa <tfiga@chromium.org>
    ASoC: Intel: kbl_rt5663_max98927: Fix kabylake_ssp_fixup function

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: reschedule when cloning lots of extents

Josef Bacik <josef@toxicpanda.com>
    btrfs: sysfs: init devices outside of the chunk_mutex

Qu Wenruo <wqu@suse.com>
    btrfs: tracepoints: output proper root owner for trace_find_free_extent()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Reclaim extra TRBs after request completion

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Continue to process pending requests

Ansuel Smith <ansuelsmth@gmail.com>
    PCI: qcom: Make sure PCIe is reset before init for rev 2.1.0

Santosh Shukla <sashukla@nvidia.com>
    KVM: arm64: Force PTE mapping on fault resulting in a device mapping

Ming Lei <ming.lei@redhat.com>
    nbd: don't update block size after device is started

Zeng Tao <prime.zeng@hisilicon.com>
    time: Prevent undefined behaviour in timespec64_to_ns()

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gem: Flush coherency domains on first set-domain-ioctl


-------------

Diffstat:

 Documentation/networking/j1939.rst                 |   4 +-
 Makefile                                           |   4 +-
 arch/arm/include/asm/kprobes.h                     |  22 +-
 arch/arm/probes/kprobes/opt-arm.c                  |  18 +-
 arch/arm64/kvm/sys_regs.c                          |  18 +-
 arch/powerpc/kernel/eeh_cache.c                    |   5 +-
 arch/powerpc/kernel/head_32.S                      |  12 -
 arch/riscv/kernel/head.S                           |   5 +
 arch/s390/kernel/smp.c                             |   3 +-
 arch/x86/kernel/cpu/bugs.c                         |  52 ++-
 arch/x86/kvm/x86.c                                 |   4 +
 drivers/block/nbd.c                                |  10 +-
 drivers/char/random.c                              |   1 -
 drivers/char/tpm/eventlog/efi.c                    |   5 +
 drivers/char/tpm/tpm_tis.c                         |  29 +-
 drivers/char/virtio_console.c                      |   8 +-
 drivers/gpio/gpio-pcie-idio-24.c                   |  62 ++-
 drivers/gpu/drm/amd/amdgpu/cik_sdma.c              |  27 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   3 +-
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c   |   4 +
 drivers/gpu/drm/amd/powerplay/inc/hwmgr.h          |   1 +
 drivers/gpu/drm/amd/powerplay/inc/smumgr.h         |   2 +
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c   |  29 +-
 drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c      |   8 +
 drivers/gpu/drm/gma500/psb_irq.c                   |  34 +-
 drivers/gpu/drm/i915/gem/i915_gem_domain.c         |  28 +-
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |   3 +-
 drivers/hv/hv_balloon.c                            |   2 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |   8 +-
 drivers/i2c/busses/i2c-sh_mobile.c                 |  86 +++-
 drivers/iommu/amd_iommu_types.h                    |   6 +-
 drivers/iommu/intel-svm.c                          |   2 +-
 drivers/mfd/sprd-sc27xx-spi.c                      |  28 +-
 drivers/misc/mei/client.h                          |   4 +-
 drivers/mmc/host/renesas_sdhi_core.c               |   1 +
 drivers/mmc/host/sdhci-of-esdhc.c                  |   2 +
 drivers/net/can/dev.c                              |  14 +-
 drivers/net/can/flexcan.c                          |   5 +-
 drivers/net/can/peak_canfd/peak_canfd.c            |  11 +-
 drivers/net/can/rx-offload.c                       |   4 +-
 drivers/net/can/ti_hecc.c                          |   8 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  51 ++-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  48 ++-
 drivers/net/can/xilinx_can.c                       |   6 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   7 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |  12 +-
 drivers/net/ethernet/microchip/lan743x_main.h      |   3 -
 drivers/net/ethernet/realtek/r8169_main.c          |   3 +-
 drivers/net/vrf.c                                  |  92 +++-
 drivers/net/wan/cosa.c                             |   1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   2 +-
 drivers/nvme/host/core.c                           |   8 +-
 drivers/nvme/host/nvme.h                           |   1 +
 drivers/nvme/host/rdma.c                           |  14 +-
 drivers/nvme/host/tcp.c                            |  16 +-
 drivers/of/address.c                               |   4 +-
 drivers/opp/core.c                                 |   7 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |  13 +
 drivers/pinctrl/aspeed/pinctrl-aspeed.c            |   7 +-
 drivers/pinctrl/intel/pinctrl-intel.c              |   8 +
 drivers/pinctrl/pinctrl-amd.c                      |   6 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |   9 +-
 drivers/scsi/hpsa.c                                |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   7 +
 drivers/spi/spi-bcm2835.c                          |   3 +-
 drivers/thunderbolt/nhi.c                          |  19 +-
 drivers/thunderbolt/xdomain.c                      |   1 +
 drivers/uio/uio.c                                  |  10 +-
 drivers/usb/class/cdc-acm.c                        |   9 +
 drivers/usb/dwc3/dwc3-pci.c                        |   4 +
 drivers/usb/dwc3/gadget.c                          |  32 +-
 drivers/usb/gadget/udc/goku_udc.c                  |   2 +-
 drivers/usb/host/xhci-histb.c                      |   2 +-
 drivers/vfio/pci/vfio_pci.c                        |   2 +-
 drivers/vfio/platform/vfio_platform_common.c       |   3 +-
 fs/afs/yfsclient.c                                 |   1 +
 fs/btrfs/dev-replace.c                             |  26 +-
 fs/btrfs/extent-tree.c                             |   7 +-
 fs/btrfs/ioctl.c                                   |  12 +-
 fs/btrfs/ref-verify.c                              |   1 +
 fs/btrfs/relocation.c                              |   4 +-
 fs/btrfs/volumes.c                                 |  33 +-
 fs/cifs/cifs_unicode.c                             |   8 +-
 fs/erofs/inode.c                                   |  21 +-
 fs/ext4/inline.c                                   |   1 +
 fs/ext4/super.c                                    |   4 +-
 fs/gfs2/rgrp.c                                     |   5 +-
 fs/gfs2/super.c                                    |   1 +
 fs/jbd2/checkpoint.c                               |   2 +
 fs/jbd2/transaction.c                              |   4 +-
 fs/ocfs2/super.c                                   |   1 +
 fs/xfs/libxfs/xfs_alloc.c                          |   1 +
 fs/xfs/libxfs/xfs_bmap.h                           |   2 +-
 fs/xfs/libxfs/xfs_rmap.c                           |   2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c                     |  16 +-
 fs/xfs/scrub/bmap.c                                |   2 +
 fs/xfs/scrub/inode.c                               |   3 +-
 fs/xfs/scrub/refcount.c                            |   8 +-
 fs/xfs/xfs_iops.c                                  |  10 +
 fs/xfs/xfs_pnfs.c                                  |   2 +-
 include/linux/arm-smccc.h                          |   2 +
 include/linux/can/skb.h                            |  20 +-
 include/linux/compiler-gcc.h                       |   2 -
 include/linux/compiler_types.h                     |   4 -
 include/linux/netfilter/nfnetlink.h                |   9 +-
 include/linux/netfilter_ipv4.h                     |   2 +-
 include/linux/netfilter_ipv6.h                     |  10 +-
 include/linux/prandom.h                            |  36 +-
 include/linux/time64.h                             |   4 +
 include/trace/events/btrfs.h                       |  10 +-
 include/trace/events/sunrpc.h                      |   8 +-
 kernel/bpf/Makefile                                |   6 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/bpf/hashtab.c                               |  30 +-
 kernel/dma/swiotlb.c                               |   6 +-
 kernel/events/core.c                               |   7 +-
 kernel/events/internal.h                           |   2 +-
 kernel/exit.c                                      |   5 +-
 kernel/futex.c                                     |   5 +-
 kernel/irq/Kconfig                                 |   1 +
 kernel/reboot.c                                    |  28 +-
 kernel/time/itimer.c                               |   4 -
 kernel/time/tick-common.c                          |   2 +
 kernel/time/timer.c                                |   7 -
 kernel/trace/trace.c                               |   4 +-
 lib/random32.c                                     | 462 +++++++++++++--------
 mm/slub.c                                          |   2 +-
 net/can/j1939/socket.c                             |   6 +
 net/ipv4/netfilter.c                               |   8 +-
 net/ipv4/netfilter/iptable_mangle.c                |   2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   2 +-
 net/ipv4/syncookies.c                              |   9 +-
 net/ipv4/udp_offload.c                             |   2 +-
 net/ipv6/netfilter.c                               |   6 +-
 net/ipv6/netfilter/ip6table_mangle.c               |   2 +-
 net/ipv6/sit.c                                     |   2 -
 net/ipv6/syncookies.c                              |  10 +-
 net/iucv/af_iucv.c                                 |   3 +-
 net/mac80211/sta_info.c                            |  18 +
 net/mac80211/tx.c                                  |  37 +-
 net/netfilter/ipset/ip_set_core.c                  |   3 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   4 +-
 net/netfilter/nf_nat_proto.c                       |   4 +-
 net/netfilter/nf_synproxy_core.c                   |   2 +-
 net/netfilter/nf_tables_api.c                      |  15 +-
 net/netfilter/nfnetlink.c                          |  22 +-
 net/netfilter/nft_chain_route.c                    |   4 +-
 net/netfilter/utils.c                              |   4 +-
 net/sched/sch_generic.c                            |   3 +
 net/tipc/topsrv.c                                  |  10 +-
 net/wireless/core.c                                |  57 +--
 net/wireless/core.h                                |   5 +-
 net/wireless/nl80211.c                             |   3 +-
 net/wireless/reg.c                                 |   2 +-
 net/x25/af_x25.c                                   |   2 +-
 net/xfrm/xfrm_state.c                              |   8 +-
 security/selinux/ibpkey.c                          |   4 +-
 sound/hda/ext/hdac_ext_controller.c                |   2 +
 sound/pci/hda/hda_controller.h                     |   3 +-
 sound/pci/hda/hda_intel.c                          |  63 +--
 sound/soc/codecs/cs42l51.c                         |  22 +-
 sound/soc/codecs/wcd9335.c                         |   2 +-
 sound/soc/intel/boards/kbl_rt5663_max98927.c       |  39 +-
 sound/soc/qcom/sdm845.c                            |   2 +
 tools/perf/builtin-trace.c                         |  15 +-
 .../util/scripting-engines/trace-event-python.c    |   7 +-
 tools/perf/util/session.c                          |   1 +
 tools/testing/selftests/bpf/prog_tests/map_init.c  | 214 ++++++++++
 tools/testing/selftests/bpf/progs/test_map_init.c  |  33 ++
 .../ftrace/test.d/kprobe/kprobe_args_user.tc       |   4 +
 tools/testing/selftests/pidfd/pidfd_open_test.c    |   1 -
 tools/testing/selftests/pidfd/pidfd_poll_test.c    |   1 -
 tools/testing/selftests/proc/proc-loadavg-001.c    |   1 -
 tools/testing/selftests/proc/proc-self-syscall.c   |   1 -
 tools/testing/selftests/proc/proc-uptime-002.c     |   1 -
 virt/kvm/arm/mmu.c                                 |   1 +
 virt/kvm/arm/psci.c                                |   2 +-
 178 files changed, 1759 insertions(+), 784 deletions(-)


