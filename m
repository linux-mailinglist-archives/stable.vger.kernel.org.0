Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B002B6149
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbgKQNRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:17:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730579AbgKQNRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:17:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D4C6206D5;
        Tue, 17 Nov 2020 13:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619061;
        bh=8QNo524dJin3XPYbIDGGfEA8Q1lBQsBXpKA6BmBSZMI=;
        h=From:To:Cc:Subject:Date:From;
        b=fAVwyrYE0LHncnsGvW+EVVP1KFeOYbLgjCYLNEr5d80W8QV05o9nbtIfXro4N5b3E
         xQLmKjMeGhsdd0e3BCMFpMHFrxGdvc0XesrcRInaNerVApQv7kMaWnGResX0A2uq/M
         7pUOGOfFmNh03kNyjfH3qNmXUpbl+p3/7npUWMOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 000/101] 4.19.158-rc1 review
Date:   Tue, 17 Nov 2020 14:04:27 +0100
Message-Id: <20201117122113.128215851@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.158-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.158-rc1
X-KernelTest-Deadline: 2020-11-19T12:21+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.158 release.
There are 101 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.158-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.158-rc1

Boris Protopopov <pboris@amazon.com>
    Convert trailing spaces and periods in path components

Yunsheng Lin <linyunsheng@huawei.com>
    net: sch_generic: fix the missing new qdisc assignment bug

Matteo Croce <mcroce@microsoft.com>
    reboot: fix overflow parsing reboot cpu number

Matteo Croce <mcroce@microsoft.com>
    Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"

Jiri Olsa <jolsa@redhat.com>
    perf/core: Fix race in the perf_mmap_close() function

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf scripting python: Avoid declaring function pointers with a visibility attribute

Anand K Mistry <amistry@google.com>
    x86/speculation: Allow IBPB to be conditionally enabled on CPUs with always-on STIBP

George Spelvin <lkml@sdf.org>
    random32: make prandom_u32() output unpredictable

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix potential skb double free in an error path

Martin Willi <martin@strongswan.org>
    vrf: Fix fast path output packet handling with async Netfilter rules

Wang Hai <wanghai38@huawei.com>
    tipc: fix memory leak in tipc_topsrv_start()

Martin Schiller <ms@dev.tdt.de>
    net/x25: Fix null-ptr-deref in x25_connect

Mao Wenan <wenan.mao@linux.alibaba.com>
    net: Update window_clamp if SOCK_RCVBUF is set

Ursula Braun <ubraun@linux.ibm.com>
    net/af_iucv: fix null pointer dereference on shutdown

Oliver Herms <oliver.peter.herms@gmail.com>
    IPv6: Set SIT tunnel hard_header_len to zero

Stefano Stabellini <stefano.stabellini@xilinx.com>
    swiotlb: fix "x86: Don't panic if can not alloc buffer for swiotlb"

Gao Xiang <hsiangkao@redhat.com>
    erofs: derive atime instead of leaving it empty

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

Dan Carpenter <dan.carpenter@oracle.com>
    futex: Don't enable IRQs unconditionally in put_pi_state()

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: protect mei_cl_mtu from null dereference

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

Anand Jain <anand.jain@oracle.com>
    btrfs: dev-replace: fail mount if we don't have replace item with target device

Dinghao Liu <dinghao.liu@zju.edu.cn>
    btrfs: ref-verify: fix memory leak in btrfs_ref_tree_mod

Joseph Qi <joseph.qi@linux.alibaba.com>
    ext4: unlock xattr_sem properly in ext4_inline_data_truncate()

Kaixu Xia <kaixuxia@tencent.com>
    ext4: correctly report "not supported" for {usr,grp}jquota when !CONFIG_QUOTA

Peter Zijlstra <peterz@infradead.org>
    perf: Fix get_recursion_context()

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

Christoph Hellwig <hch@lst.de>
    nbd: fix a block_device refcount leak in nbd_release

Billy Tsai <billy_tsai@aspeedtech.com>
    pinctrl: aspeed: Fix GPI only function problem.

Andrew Jeffery <andrew@aj.id.au>
    ARM: 9019/1: kprobes: Avoid fortify_panic() when copying optprobe template

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Set default bias in case no particular value given

Baolin Wang <baolin.wang7@gmail.com>
    mfd: sprd: Add wakeup capability for PMIC IRQ

Chunyan Zhang <zhang.lyra@gmail.com>
    tick/common: Touch watchdog in tick_unfreeze() on all CPUs

Jerry Snitselaar <jsnitsel@redhat.com>
    tpm_tis: Disable interrupts on ThinkPad T490s

Tommi Rantala <tommi.t.rantala@nokia.com>
    selftests: proc: fix warning: _GNU_SOURCE redefined

Zhang Qilong <zhangqilong3@huawei.com>
    vfio: platform: fix reference leak in vfio_platform_open

Qian Cai <cai@redhat.com>
    s390/smp: move rcu_cpu_starting() earlier

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Increase interrupt remapping table limit to 512 entries

Hannes Reinecke <hare@suse.de>
    scsi: scsi_dh_alua: Avoid crash during alua_bus_detach()

Ye Bin <yebin10@huawei.com>
    cfg80211: regulatory: Fix inconsistent format argument

Johannes Berg <johannes.berg@intel.com>
    mac80211: always wind down STA state

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

Evgeny Novikov <novikov@ispras.ru>
    usb: gadget: goku_udc: fix potential crashes in probe

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: arm64/aes-modes - get rid of literal load of addend vector

Jason A. Donenfeld <Jason@zx2c4.com>
    netfilter: use actual socket sk rather than skb sk when routing harder

Masashi Honma <masashi.honma@gmail.com>
    ath9k_htc: Use appropriate rs_datalen type

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix missing error return if writeback for extent buffer never started

Tyler Hicks <tyhicks@linux.microsoft.com>
    tpm: efi: Don't create binary_bios_measurements file for an empty log

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix scrub flagging rtinherit even if there is no rt device

Brian Foster <bfoster@redhat.com>
    xfs: flush new eof page on truncate to avoid post-eof corruption

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: remove FLEXCAN_QUIRK_DISABLE_MECR quirk for LS1021A

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_canfd: pucan_handle_can_rx(): fix echo management when loopback is on

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: peak_usb_get_ts_time(): fix timestamp wrapping

Dan Carpenter <dan.carpenter@oracle.com>
    can: peak_usb: add range checking in decode operations

Oleksij Rempel <o.rempel@pengutronix.de>
    can: can_create_echo_skb(): fix echo skb generation: always use skb_clone()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: dev: __can_get_echo_skb(): fix real payload length return value for RTR frames

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: dev: can_get_echo_skb(): prevent call to kfree_skb() in hard IRQ context

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rx-offload: don't call kfree_skb() from IRQ context

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: hda: prevent undefined shift in snd_hdac_ext_bus_get_link()

Jiri Olsa <jolsa@kernel.org>
    perf tools: Add missing swap for ino_generation

Stefano Brivio <sbrivio@redhat.com>
    netfilter: ipset: Update byte and packet counters regardless of whether they match

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: set xefi_discard when creating a deferred agfl free log intent item

zhuoliang zhang <zhuoliang.zhang@mediatek.com>
    net: xfrm: fix a race condition during allocing spi

Olaf Hering <olaf@aepfle.de>
    hv_balloon: disable warning when floor reached

Marc Zyngier <maz@kernel.org>
    genirq: Let GENERIC_IRQ_IPI select IRQ_DOMAIN_HIERARCHY

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: reschedule when cloning lots of extents

Josef Bacik <josef@toxicpanda.com>
    btrfs: sysfs: init devices outside of the chunk_mutex

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Reclaim extra TRBs after request completion

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Continue to process pending requests

Ming Lei <ming.lei@redhat.com>
    nbd: don't update block size after device is started

Zeng Tao <prime.zeng@hisilicon.com>
    time: Prevent undefined behaviour in timespec64_to_ns()

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: defer probe when trying to get voltage from unresolved supply


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/include/asm/kprobes.h                     |  22 +-
 arch/arm/probes/kprobes/opt-arm.c                  |  18 +-
 arch/arm64/crypto/aes-modes.S                      |  16 +-
 arch/s390/kernel/smp.c                             |   3 +-
 arch/x86/kernel/cpu/bugs.c                         |  52 ++-
 drivers/block/nbd.c                                |  10 +-
 drivers/char/random.c                              |   1 -
 drivers/char/tpm/eventlog/efi.c                    |   5 +
 drivers/char/tpm/tpm_tis.c                         |  29 +-
 drivers/gpio/gpio-pcie-idio-24.c                   |  62 ++-
 drivers/gpu/drm/amd/amdgpu/cik_sdma.c              |  27 +-
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c   |   4 +
 drivers/gpu/drm/amd/powerplay/inc/hwmgr.h          |   1 +
 drivers/gpu/drm/amd/powerplay/inc/smumgr.h         |   2 +
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c   |  29 +-
 drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c      |   8 +
 drivers/gpu/drm/gma500/psb_irq.c                   |  34 +-
 drivers/hv/hv_balloon.c                            |   2 +-
 drivers/iommu/amd_iommu_types.h                    |   6 +-
 drivers/mfd/sprd-sc27xx-spi.c                      |  28 +-
 drivers/misc/mei/client.h                          |   4 +-
 drivers/mmc/host/renesas_sdhi_core.c               |   1 +
 drivers/net/can/dev.c                              |  14 +-
 drivers/net/can/flexcan.c                          |   3 +-
 drivers/net/can/peak_canfd/peak_canfd.c            |  11 +-
 drivers/net/can/rx-offload.c                       |   4 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  51 ++-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  48 ++-
 drivers/net/ethernet/microchip/lan743x_main.c      |  12 +-
 drivers/net/ethernet/microchip/lan743x_main.h      |   3 -
 drivers/net/ethernet/realtek/r8169.c               |   3 +-
 drivers/net/vrf.c                                  |  92 +++-
 drivers/net/wan/cosa.c                             |   1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   2 +-
 drivers/of/address.c                               |   4 +-
 drivers/pinctrl/aspeed/pinctrl-aspeed.c            |   7 +-
 drivers/pinctrl/intel/pinctrl-intel.c              |   8 +
 drivers/pinctrl/pinctrl-amd.c                      |   6 +-
 drivers/regulator/core.c                           |   2 +
 drivers/scsi/device_handler/scsi_dh_alua.c         |   9 +-
 drivers/scsi/hpsa.c                                |   4 +-
 drivers/staging/erofs/inode.c                      |  21 +-
 drivers/thunderbolt/nhi.c                          |  19 +-
 drivers/thunderbolt/xdomain.c                      |   1 +
 drivers/uio/uio.c                                  |  10 +-
 drivers/usb/class/cdc-acm.c                        |   9 +
 drivers/usb/dwc3/gadget.c                          |  32 +-
 drivers/usb/gadget/udc/goku_udc.c                  |   2 +-
 drivers/usb/host/xhci-histb.c                      |   2 +-
 drivers/vfio/platform/vfio_platform_common.c       |   3 +-
 fs/btrfs/dev-replace.c                             |  26 +-
 fs/btrfs/extent_io.c                               |   4 +
 fs/btrfs/ioctl.c                                   |  12 +-
 fs/btrfs/ref-verify.c                              |   1 +
 fs/btrfs/volumes.c                                 |  33 +-
 fs/cifs/cifs_unicode.c                             |   8 +-
 fs/ext4/inline.c                                   |   1 +
 fs/ext4/super.c                                    |   4 +-
 fs/gfs2/rgrp.c                                     |   5 +-
 fs/gfs2/super.c                                    |   1 +
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
 include/linux/can/skb.h                            |  20 +-
 include/linux/netfilter_ipv4.h                     |   2 +-
 include/linux/netfilter_ipv6.h                     |   2 +-
 include/linux/prandom.h                            |  36 +-
 include/linux/time64.h                             |   4 +
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
 lib/random32.c                                     | 462 +++++++++++++--------
 net/ipv4/netfilter.c                               |  12 +-
 net/ipv4/netfilter/ipt_SYNPROXY.c                  |   2 +-
 net/ipv4/netfilter/iptable_mangle.c                |   2 +-
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c           |   2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   2 +-
 net/ipv4/netfilter/nft_chain_route_ipv4.c          |   2 +-
 net/ipv4/syncookies.c                              |   9 +-
 net/ipv6/netfilter.c                               |   6 +-
 net/ipv6/netfilter/ip6table_mangle.c               |   2 +-
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c           |   2 +-
 net/ipv6/netfilter/nft_chain_route_ipv6.c          |   2 +-
 net/ipv6/sit.c                                     |   2 -
 net/ipv6/syncookies.c                              |  10 +-
 net/iucv/af_iucv.c                                 |   3 +-
 net/mac80211/sta_info.c                            |  18 +
 net/mac80211/tx.c                                  |  37 +-
 net/netfilter/ipset/ip_set_core.c                  |   3 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   4 +-
 net/sched/sch_generic.c                            |   3 +
 net/tipc/topsrv.c                                  |  10 +-
 net/wireless/reg.c                                 |   2 +-
 net/x25/af_x25.c                                   |   2 +-
 net/xfrm/xfrm_state.c                              |   8 +-
 security/selinux/ibpkey.c                          |   4 +-
 sound/hda/ext/hdac_ext_controller.c                |   2 +
 sound/pci/hda/hda_intel.c                          |   1 +
 .../util/scripting-engines/trace-event-python.c    |   7 +-
 tools/perf/util/session.c                          |   1 +
 tools/testing/selftests/proc/proc-loadavg-001.c    |   1 -
 tools/testing/selftests/proc/proc-self-syscall.c   |   1 -
 tools/testing/selftests/proc/proc-uptime-002.c     |   1 -
 118 files changed, 1102 insertions(+), 547 deletions(-)


