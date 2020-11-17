Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE81F2B66C7
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgKQNH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:07:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729071AbgKQNH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:07:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DA0B2464E;
        Tue, 17 Nov 2020 13:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618443;
        bh=F+5iuJebV2v7qes4lqdIkl9lmsJ20oGA+UABAPP0D94=;
        h=From:To:Cc:Subject:Date:From;
        b=ijxDv0XXy+g+56O042/qsljwQxzNtLJLXITWETu+8IcwlZ3UmyIP0eeCjKA/erq19
         FzrgxAWPKVRbybKNH/o/20DfSatNnIS4qrLJemYjpfBZuhwLO9CExQ50eQRtb0cV84
         ptHQDUlo8Td1+Vy8+f9sM4SMOjN4L8dSfeOLL2dE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.4 00/64] 4.4.244-rc1 review
Date:   Tue, 17 Nov 2020 14:04:23 +0100
Message-Id: <20201117122106.144800239@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.244-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.244-rc1
X-KernelTest-Deadline: 2020-11-19T12:21+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.244 release.
There are 64 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.244-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.244-rc1

Boris Protopopov <pboris@amazon.com>
    Convert trailing spaces and periods in path components

Eric Biggers <ebiggers@google.com>
    ext4: fix leaking sysfs kobject after failed mount

Matteo Croce <mcroce@microsoft.com>
    reboot: fix overflow parsing reboot cpu number

Matteo Croce <mcroce@microsoft.com>
    Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"

Jiri Olsa <jolsa@redhat.com>
    perf/core: Fix race in the perf_mmap_close() function

Juergen Gross <jgross@suse.com>
    xen/events: block rogue events for some time

Juergen Gross <jgross@suse.com>
    xen/events: defer eoi in case of excessive number of events

Juergen Gross <jgross@suse.com>
    xen/events: use a common cpu hotplug hook for event channels

Juergen Gross <jgross@suse.com>
    xen/events: switch user event channels to lateeoi model

Juergen Gross <jgross@suse.com>
    xen/pciback: use lateeoi irq binding

Juergen Gross <jgross@suse.com>
    xen/scsiback: use lateeoi irq binding

Juergen Gross <jgross@suse.com>
    xen/netback: use lateeoi irq binding

Juergen Gross <jgross@suse.com>
    xen/blkback: use lateeoi irq binding

Juergen Gross <jgross@suse.com>
    xen/events: add a new "late EOI" evtchn framework

Juergen Gross <jgross@suse.com>
    xen/events: fix race in evtchn_fifo_unmask()

Juergen Gross <jgross@suse.com>
    xen/events: add a proper barrier to 2-level uevent unmasking

Juergen Gross <jgross@suse.com>
    xen/events: avoid removing an event channel while handling it

Anand K Mistry <amistry@google.com>
    x86/speculation: Allow IBPB to be conditionally enabled on CPUs with always-on STIBP

George Spelvin <lkml@sdf.org>
    random32: make prandom_u32() output unpredictable

Mao Wenan <wenan.mao@linux.alibaba.com>
    net: Update window_clamp if SOCK_RCVBUF is set

Martin Schiller <ms@dev.tdt.de>
    net/x25: Fix null-ptr-deref in x25_connect

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

Wengang Wang <wen.gang.wang@oracle.com>
    ocfs2: initialize ip_next_orphan

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: protect mei_cl_mtu from null dereference

Chris Brandt <chris.brandt@renesas.com>
    usb: cdc-acm: Add DISABLE_ECHO for Renesas USB Download mode

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

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Increase interrupt remapping table limit to 512 entries

Ye Bin <yebin10@huawei.com>
    cfg80211: regulatory: Fix inconsistent format argument

Johannes Berg <johannes.berg@intel.com>
    mac80211: always wind down STA state

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix use of skb payload instead of header

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: perform srbm soft reset always on SDMA resume

Bob Peterson <rpeterso@redhat.com>
    gfs2: check for live vs. read-only file system in gfs2_fitrim

Bob Peterson <rpeterso@redhat.com>
    gfs2: Free rd_bits later in gfs2_clear_rgrpd to fix use-after-free

Evgeny Novikov <novikov@ispras.ru>
    usb: gadget: goku_udc: fix potential crashes in probe

Masashi Honma <masashi.honma@gmail.com>
    ath9k_htc: Use appropriate rs_datalen type

Mark Gray <mark.d.gray@redhat.com>
    geneve: add transport ports in route lookup for geneve

Martyna Szapar <martyna.szapar@intel.com>
    i40e: Fix of memory leak and integer truncation in i40e_virtchnl.c

Grzegorz Siwik <grzegorz.siwik@intel.com>
    i40e: Wrong truncation from u16 to u8

Will Deacon <will@kernel.org>
    pinctrl: devicetree: Avoid taking direct reference to device name string

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix missing error return if writeback for extent buffer never started

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

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: hda: prevent undefined shift in snd_hdac_ext_bus_get_link()

Jiri Olsa <jolsa@kernel.org>
    perf tools: Add missing swap for ino_generation

zhuoliang zhang <zhuoliang.zhang@mediatek.com>
    net: xfrm: fix a race condition during allocing spi

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: reschedule when cloning lots of extents

Zeng Tao <prime.zeng@hisilicon.com>
    time: Prevent undefined behaviour in timespec64_to_ns()

Shijie Luo <luoshijie1@huawei.com>
    mm: mempolicy: fix potential pte_unmap_unlock pte error

Alexander Aring <aahringo@redhat.com>
    gfs2: Wake up when sd_glock_disposal becomes zero

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ring-buffer: Fix recursion protection transitions between interrupt context


-------------

Diffstat:

 Documentation/kernel-parameters.txt                |   8 +
 Makefile                                           |   4 +-
 arch/x86/kernel/cpu/bugs.c                         |  52 ++-
 drivers/block/xen-blkback/blkback.c                |  22 +-
 drivers/block/xen-blkback/xenbus.c                 |   5 +-
 drivers/char/random.c                              |   2 -
 drivers/gpu/drm/amd/amdgpu/cik_sdma.c              |  27 +-
 drivers/gpu/drm/gma500/psb_irq.c                   |  34 +-
 drivers/iommu/amd_iommu_types.h                    |   6 +-
 drivers/misc/mei/client.h                          |   4 +-
 drivers/net/can/dev.c                              |  14 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  51 ++-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  48 ++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   4 +-
 drivers/net/geneve.c                               |  36 +-
 drivers/net/wan/cosa.c                             |   1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   2 +-
 drivers/net/xen-netback/common.h                   |  39 ++
 drivers/net/xen-netback/interface.c                |  59 ++-
 drivers/net/xen-netback/netback.c                  |  17 +-
 drivers/of/address.c                               |   4 +-
 drivers/pinctrl/devicetree.c                       |  26 +-
 drivers/pinctrl/pinctrl-amd.c                      |   6 +-
 drivers/usb/class/cdc-acm.c                        |   9 +
 drivers/usb/gadget/udc/goku_udc.c                  |   2 +-
 drivers/xen/events/events_2l.c                     |   9 +-
 drivers/xen/events/events_base.c                   | 444 ++++++++++++++++++--
 drivers/xen/events/events_fifo.c                   | 102 ++---
 drivers/xen/events/events_internal.h               |  20 +-
 drivers/xen/evtchn.c                               |   7 +-
 drivers/xen/xen-pciback/pci_stub.c                 |  14 +-
 drivers/xen/xen-pciback/pciback.h                  |  12 +-
 drivers/xen/xen-pciback/pciback_ops.c              |  48 ++-
 drivers/xen/xen-pciback/xenbus.c                   |   2 +-
 drivers/xen/xen-scsiback.c                         |  23 +-
 fs/btrfs/extent_io.c                               |   4 +
 fs/btrfs/ioctl.c                                   |   2 +
 fs/cifs/cifs_unicode.c                             |   8 +-
 fs/ext4/inline.c                                   |   1 +
 fs/ext4/super.c                                    |   5 +-
 fs/gfs2/glock.c                                    |   3 +-
 fs/gfs2/rgrp.c                                     |   5 +-
 fs/ocfs2/super.c                                   |   1 +
 fs/xfs/xfs_pnfs.c                                  |   2 +-
 include/linux/can/skb.h                            |  20 +-
 include/linux/prandom.h                            |  36 +-
 include/linux/time64.h                             |   4 +
 include/xen/events.h                               |  29 +-
 kernel/events/core.c                               |   7 +-
 kernel/events/internal.h                           |   2 +-
 kernel/exit.c                                      |   5 +-
 kernel/reboot.c                                    |  28 +-
 kernel/time/timer.c                                |   7 -
 kernel/trace/ring_buffer.c                         |  54 ++-
 lib/random32.c                                     | 463 +++++++++++++--------
 lib/swiotlb.c                                      |   6 +-
 mm/mempolicy.c                                     |   6 +-
 net/ipv4/syncookies.c                              |   9 +-
 net/ipv6/sit.c                                     |   2 -
 net/ipv6/syncookies.c                              |  10 +-
 net/iucv/af_iucv.c                                 |   3 +-
 net/mac80211/sta_info.c                            |  18 +
 net/mac80211/tx.c                                  |  35 +-
 net/wireless/reg.c                                 |   2 +-
 net/x25/af_x25.c                                   |   2 +-
 net/xfrm/xfrm_state.c                              |   8 +-
 sound/hda/ext/hdac_ext_controller.c                |   2 +
 tools/perf/util/session.c                          |   1 +
 68 files changed, 1431 insertions(+), 522 deletions(-)


