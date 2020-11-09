Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E0C2ABBCF
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731739AbgKINbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:31:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbgKINJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:09:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8BB120663;
        Mon,  9 Nov 2020 13:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927373;
        bh=BKorcAGqX55/91goDWq+43kiwJM+p0b+sLL4b8lXBn0=;
        h=From:To:Cc:Subject:Date:From;
        b=nNqHsLyBqbOVvvK4jETd3e9/i50zs9KNGsEawGHBlB3Cxnu0WYhcp01jH6oqO1flZ
         Ox0ZiIYvZta7w5hwe5IjOjffTLxLPZzY/+u3j2ghMyH1kVFWEnB4XIGvQwBhU5FcPi
         h3OePFGna7WQRFJeotCwptUlxdrsv1JG4MuDHECs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 00/71] 4.19.156-rc1 review
Date:   Mon,  9 Nov 2020 13:54:54 +0100
Message-Id: <20201109125019.906191744@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.156-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.156-rc1
X-KernelTest-Deadline: 2020-11-11T12:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.156 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.156-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.156-rc1

Pali Rohár <pali@kernel.org>
    arm64: dts: marvell: espressobin: Add ethernet switch aliases

Xiaofei Shen <xiaofeis@codeaurora.org>
    net: dsa: read mac address from DT for slave device

Guenter Roeck <linux@roeck-us.net>
    tools: perf: Fix build error in v4.19.y

kiyin(尹亮) <kiyin@tencent.com>
    perf/core: Fix a memory leak in perf_event_parse_addr_filter()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Resume the device earlier in __device_release_driver()

Vineet Gupta <Vineet.Gupta1@synopsys.com>
    Revert "ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE"

Vineet Gupta <vgupta@synopsys.com>
    ARC: stack unwinding: avoid indefinite looping

Macpaul Lin <macpaul.lin@mediatek.com>
    usb: mtu3: fix panic in mtu3_gadget_stop()

Alan Stern <stern@rowland.harvard.edu>
    USB: Add NO_LPM quirk for Kingston flash drive

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FN980 composition 0x1055

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add LE910Cx compositions 0x1203, 0x1230, 0x1231

Ziyi Cao <kernel@septs.pw>
    USB: serial: option: add Quectel EC200T module support

Johan Hovold <johan@kernel.org>
    USB: serial: cyberjack: fix write-URB completion race

Qinglang Miao <miaoqinglang@huawei.com>
    serial: txx9: add missing platform_driver_unregister() on error in serial_txx9_init

Claire Chang <tientzu@chromium.org>
    serial: 8250_mtk: Fix uart_get_baud_rate warning

Eddy Wu <itseddy0402@gmail.com>
    fork: fix copy_process(CLONE_PARENT) race with the exiting ->real_parent

Daniel Vetter <daniel.vetter@ffwll.ch>
    vt: Disable KD_FONT_OP_COPY

Zhang Qilong <zhangqilong3@huawei.com>
    ACPI: NFIT: Fix comparison to '-ENXIO'

Hoegeun Kwon <hoegeun.kwon@samsung.com>
    drm/vc4: drv: Add error handding for bind

Jeff Vander Stoep <jeffv@google.com>
    vsock: use ns_capable_noaudit() on socket create

Ming Lei <ming.lei@redhat.com>
    scsi: core: Don't start concurrent async scan on same host

Gabriel Krisman Bertazi <krisman@collabora.com>
    blk-cgroup: Pre-allocate tree node on blkg_conf_prep

Gabriel Krisman Bertazi <krisman@collabora.com>
    blk-cgroup: Fix memleak on error path

Vincent Whitchurch <vincent.whitchurch@axis.com>
    of: Fix reserved-memory overlap detection

Kairui Song <kasong@redhat.com>
    x86/kexec: Use up-to-dated screen_info copy to fill boot params

Clément Péron <peron.clem@gmail.com>
    ARM: dts: sun4i-a10: fix cpu_alert temperature

Mike Galbraith <efault@gmx.de>
    futex: Handle transient "ownerless" rtmutex state correctly

Qiujun Huang <hqjagain@gmail.com>
    tracing: Fix out of bounds write in get_trace_buf

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Handle tracing when switching between context

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Fix recursion check for NMI test

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ring-buffer: Fix recursion protection transitions between interrupt context

Alexander Aring <aahringo@redhat.com>
    gfs2: Wake up when sd_glock_disposal becomes zero

Jason Gunthorpe <jgg@nvidia.com>
    mm: always have io_remap_pfn_range() set pgprot_decrypted()

Zqiang <qiang.zhang@windriver.com>
    kthread_worker: prevent queuing delayed work from timer_fn when it is being canceled

Vasily Gorbik <gor@linux.ibm.com>
    lib/crc32test: remove extra local_irq_disable/enable

Shijie Luo <luoshijie1@huawei.com>
    mm: mempolicy: fix potential pte_unmap_unlock pte error

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Add implicit feedback quirk for MODX

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Add implicit feedback quirk for Qu-16

Artem Lapkin <art@khadas.com>
    ALSA: usb-audio: add usb vendor id as DSD-capable for Khadas devices

Keith Winstein <keithw@cs.stanford.edu>
    ALSA: usb-audio: Add implicit feedback quirk for Zoom UAC-2

Lee Jones <lee.jones@linaro.org>
    Fonts: Replace discarded const qualifier

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: fix the error message for transid error

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: Verify inode item

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: Enhance chunk checker to validate chunk profile

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: Fix wrong check on max devid

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: Verify dev item

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: Check chunk item at tree block read time

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: Make btrfs_check_chunk_valid() return EUCLEAN instead of EIO

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: Make chunk item checker messages more readable

Qu Wenruo <wqu@suse.com>
    btrfs: Move btrfs_check_chunk_valid() to tree-check.[ch] and export it

Qu Wenruo <wqu@suse.com>
    btrfs: Don't submit any btree write bio if the fs has errors

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix unwritten extent buffers and hangs on future writeback attempts

Qu Wenruo <wqu@suse.com>
    btrfs: extent_io: add proper error handling to lock_extent_buffer_for_io()

Qu Wenruo <wqu@suse.com>
    btrfs: extent_io: Handle errors better in btree_write_cache_pages()

Qu Wenruo <wqu@suse.com>
    btrfs: extent_io: Handle errors better in extent_write_full_page()

Josef Bacik <josef@toxicpanda.com>
    btrfs: flush write bio if we loop in extent_write_cache_pages

Ben Hutchings <ben.hutchings@codethink.co.uk>
    Revert "btrfs: flush write bio if we loop in extent_write_cache_pages"

Qu Wenruo <wqu@suse.com>
    btrfs: extent_io: Move the BUG_ON() in flush_write_bio() one level up

Qu Wenruo <wqu@suse.com>
    btrfs: extent_io: Kill the forward declaration of flush_write_bio

Luis Chamberlain <mcgrof@kernel.org>
    blktrace: fix debugfs use after free

YueHaibing <yuehaibing@huawei.com>
    sfp: Fix error handing in sfp_probe()

Petr Malat <oss@malat.biz>
    sctp: Fix COMM_LOST/CANT_STR_ASSOC err reporting on big-endian platforms

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit LE910Cx 0x1230 composition

Claudiu Manoil <claudiu.manoil@nxp.com>
    gianfar: Account for Tx PTP timestamp in the skb headroom

Claudiu Manoil <claudiu.manoil@nxp.com>
    gianfar: Replace skb_realloc_headroom with skb_cow_head for PTP

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix always leaking ctrl_skb

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix memory leaks caused by a race

Mark Deneen <mdeneen@saucontech.com>
    cadence: force nonlinear buffers to be cloned

Oleg Nesterov <oleg@redhat.com>
    ptrace: fix task_join_group_stop() for the case when current is traced

Hoang Huu Le <hoang.h.le@dektech.com.au>
    tipc: fix use-after-free in tipc_bcast_get_mode

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Break up error capture compression loops with cond_resched()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/kernel/entry.S                            |  16 +-
 arch/arc/kernel/stacktrace.c                       |   7 +-
 arch/arm/boot/dts/sun4i-a10.dtsi                   |   2 +-
 .../boot/dts/marvell/armada-3720-espressobin.dts   |  12 +-
 arch/x86/kernel/kexec-bzimage64.c                  |   3 +-
 block/blk-cgroup.c                                 |  15 +-
 drivers/acpi/nfit/core.c                           |   2 +-
 drivers/base/dd.c                                  |   7 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c            |   2 +-
 drivers/crypto/chelsio/chtls/chtls_hw.c            |   3 +
 drivers/gpu/drm/i915/i915_gpu_error.c              |   3 +
 drivers/gpu/drm/vc4/vc4_drv.c                      |   1 +
 drivers/net/ethernet/cadence/macb_main.c           |   3 +-
 drivers/net/ethernet/freescale/gianfar.c           |  14 +-
 drivers/net/phy/sfp.c                              |   3 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/of/of_reserved_mem.c                       |  13 +-
 drivers/scsi/scsi_scan.c                           |   7 +-
 drivers/tty/serial/8250/8250_mtk.c                 |   2 +-
 drivers/tty/serial/serial_txx9.c                   |   3 +
 drivers/tty/vt/vt.c                                |  24 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/mtu3/mtu3_gadget.c                     |   1 +
 drivers/usb/serial/cyberjack.c                     |   7 +-
 drivers/usb/serial/option.c                        |  10 +
 fs/btrfs/ctree.h                                   |  15 +
 fs/btrfs/extent_io.c                               | 221 ++++++++++----
 fs/btrfs/tree-checker.c                            | 326 +++++++++++++++++++++
 fs/btrfs/tree-checker.h                            |   4 +
 fs/btrfs/volumes.c                                 | 115 +-------
 fs/btrfs/volumes.h                                 |   9 +
 fs/gfs2/glock.c                                    |   3 +-
 include/asm-generic/pgtable.h                      |   4 -
 include/linux/mm.h                                 |   9 +
 include/net/dsa.h                                  |   1 +
 kernel/events/core.c                               |  12 +-
 kernel/fork.c                                      |  10 +-
 kernel/futex.c                                     |  16 +-
 kernel/kthread.c                                   |   3 +-
 kernel/signal.c                                    |  19 +-
 kernel/trace/blktrace.c                            |  18 +-
 kernel/trace/ring_buffer.c                         |  58 +++-
 kernel/trace/trace.c                               |   2 +-
 kernel/trace/trace.h                               |  26 +-
 kernel/trace/trace_selftest.c                      |   9 +-
 lib/crc32test.c                                    |   4 -
 lib/fonts/font_10x18.c                             |   2 +-
 lib/fonts/font_6x10.c                              |   2 +-
 lib/fonts/font_6x11.c                              |   2 +-
 lib/fonts/font_7x14.c                              |   2 +-
 lib/fonts/font_8x16.c                              |   2 +-
 lib/fonts/font_8x8.c                               |   2 +-
 lib/fonts/font_acorn_8x8.c                         |   2 +-
 lib/fonts/font_mini_4x6.c                          |   2 +-
 lib/fonts/font_pearl_8x8.c                         |   2 +-
 lib/fonts/font_sun12x22.c                          |   2 +-
 lib/fonts/font_sun8x16.c                           |   2 +-
 mm/mempolicy.c                                     |   6 +-
 net/dsa/dsa2.c                                     |   1 +
 net/dsa/slave.c                                    |   5 +-
 net/sctp/sm_sideeffect.c                           |   4 +-
 net/tipc/core.c                                    |   5 +
 net/vmw_vsock/af_vsock.c                           |   2 +-
 sound/usb/pcm.c                                    |   6 +
 sound/usb/quirks.c                                 |   1 +
 tools/perf/util/util.h                             |   2 +-
 67 files changed, 808 insertions(+), 298 deletions(-)


