Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD632AD96F
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 15:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731360AbgKJO4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 09:56:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730819AbgKJO4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 09:56:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 752D820797;
        Tue, 10 Nov 2020 14:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605020182;
        bh=yQM8s+OvjiwiuRMpGvCUaapv1uMl8Od58Ri5s6mw17g=;
        h=From:To:Cc:Subject:Date:From;
        b=K2Vj9SCNEq+d4hsoFlwwJ/KoaQhht06qPyB8aeYpnq3RpC6EA9+iU+vo0YWd4MOB7
         UV+r/1coyGf26O68o7jhs6sV25HxNH0OtFMYb9Y5w0i+lMzztGDZsKkah0VmHh73D5
         GxLZ2+p/DFeVGlPYYR08W+axQ4tTaCTpos8HsXvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.156
Date:   Tue, 10 Nov 2020 15:57:08 +0100
Message-Id: <160502022825548@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.156 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arc/kernel/entry.S                                 |   16 
 arch/arc/kernel/stacktrace.c                            |    7 
 arch/arm/boot/dts/sun4i-a10.dtsi                        |    2 
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts |   12 
 arch/x86/kernel/kexec-bzimage64.c                       |    3 
 block/blk-cgroup.c                                      |   15 
 drivers/acpi/nfit/core.c                                |    2 
 drivers/base/dd.c                                       |    7 
 drivers/crypto/chelsio/chtls/chtls_cm.c                 |    2 
 drivers/crypto/chelsio/chtls/chtls_hw.c                 |    3 
 drivers/gpu/drm/i915/i915_gpu_error.c                   |    3 
 drivers/gpu/drm/vc4/vc4_drv.c                           |    1 
 drivers/net/ethernet/cadence/macb_main.c                |    3 
 drivers/net/ethernet/freescale/gianfar.c                |   14 
 drivers/net/phy/sfp.c                                   |    3 
 drivers/net/usb/qmi_wwan.c                              |    1 
 drivers/of/of_reserved_mem.c                            |   13 
 drivers/scsi/scsi_scan.c                                |    7 
 drivers/tty/serial/8250/8250_mtk.c                      |    2 
 drivers/tty/serial/serial_txx9.c                        |    3 
 drivers/tty/vt/vt.c                                     |   24 -
 drivers/usb/core/quirks.c                               |    3 
 drivers/usb/mtu3/mtu3_gadget.c                          |    1 
 drivers/usb/serial/cyberjack.c                          |    7 
 drivers/usb/serial/option.c                             |   10 
 fs/btrfs/ctree.h                                        |   15 
 fs/btrfs/extent_io.c                                    |  221 ++++++++--
 fs/btrfs/tree-checker.c                                 |  326 ++++++++++++++++
 fs/btrfs/tree-checker.h                                 |    4 
 fs/btrfs/volumes.c                                      |  115 -----
 fs/btrfs/volumes.h                                      |    9 
 fs/gfs2/glock.c                                         |    3 
 include/asm-generic/pgtable.h                           |    4 
 include/linux/mm.h                                      |    9 
 include/net/dsa.h                                       |    1 
 kernel/events/core.c                                    |   12 
 kernel/fork.c                                           |   10 
 kernel/futex.c                                          |   16 
 kernel/kthread.c                                        |    3 
 kernel/signal.c                                         |   19 
 kernel/trace/blktrace.c                                 |   18 
 kernel/trace/ring_buffer.c                              |   58 ++
 kernel/trace/trace.c                                    |    2 
 kernel/trace/trace.h                                    |   26 +
 kernel/trace/trace_selftest.c                           |    9 
 lib/crc32test.c                                         |    4 
 lib/fonts/font_10x18.c                                  |    2 
 lib/fonts/font_6x10.c                                   |    2 
 lib/fonts/font_6x11.c                                   |    2 
 lib/fonts/font_7x14.c                                   |    2 
 lib/fonts/font_8x16.c                                   |    2 
 lib/fonts/font_8x8.c                                    |    2 
 lib/fonts/font_acorn_8x8.c                              |    2 
 lib/fonts/font_mini_4x6.c                               |    2 
 lib/fonts/font_pearl_8x8.c                              |    2 
 lib/fonts/font_sun12x22.c                               |    2 
 lib/fonts/font_sun8x16.c                                |    2 
 mm/mempolicy.c                                          |    6 
 net/dsa/dsa2.c                                          |    1 
 net/dsa/slave.c                                         |    5 
 net/sctp/sm_sideeffect.c                                |    4 
 net/tipc/core.c                                         |    5 
 net/vmw_vsock/af_vsock.c                                |    2 
 sound/usb/pcm.c                                         |    6 
 sound/usb/quirks.c                                      |    1 
 tools/perf/util/util.h                                  |    2 
 67 files changed, 807 insertions(+), 297 deletions(-)

Alan Stern (1):
      USB: Add NO_LPM quirk for Kingston flash drive

Alexander Aring (1):
      gfs2: Wake up when sd_glock_disposal becomes zero

Artem Lapkin (1):
      ALSA: usb-audio: add usb vendor id as DSD-capable for Khadas devices

Ben Hutchings (1):
      Revert "btrfs: flush write bio if we loop in extent_write_cache_pages"

Chris Wilson (1):
      drm/i915: Break up error capture compression loops with cond_resched()

Claire Chang (1):
      serial: 8250_mtk: Fix uart_get_baud_rate warning

Claudiu Manoil (2):
      gianfar: Replace skb_realloc_headroom with skb_cow_head for PTP
      gianfar: Account for Tx PTP timestamp in the skb headroom

Clément Péron (1):
      ARM: dts: sun4i-a10: fix cpu_alert temperature

Daniel Vetter (1):
      vt: Disable KD_FONT_OP_COPY

Daniele Palmas (3):
      net: usb: qmi_wwan: add Telit LE910Cx 0x1230 composition
      USB: serial: option: add LE910Cx compositions 0x1203, 0x1230, 0x1231
      USB: serial: option: add Telit FN980 composition 0x1055

Eddy Wu (1):
      fork: fix copy_process(CLONE_PARENT) race with the exiting ->real_parent

Filipe Manana (1):
      Btrfs: fix unwritten extent buffers and hangs on future writeback attempts

Gabriel Krisman Bertazi (2):
      blk-cgroup: Fix memleak on error path
      blk-cgroup: Pre-allocate tree node on blkg_conf_prep

Geoffrey D. Bennett (2):
      ALSA: usb-audio: Add implicit feedback quirk for Qu-16
      ALSA: usb-audio: Add implicit feedback quirk for MODX

Greg Kroah-Hartman (1):
      Linux 4.19.156

Guenter Roeck (1):
      tools: perf: Fix build error in v4.19.y

Hoang Huu Le (1):
      tipc: fix use-after-free in tipc_bcast_get_mode

Hoegeun Kwon (1):
      drm/vc4: drv: Add error handding for bind

Jason Gunthorpe (1):
      mm: always have io_remap_pfn_range() set pgprot_decrypted()

Jeff Vander Stoep (1):
      vsock: use ns_capable_noaudit() on socket create

Johan Hovold (1):
      USB: serial: cyberjack: fix write-URB completion race

Josef Bacik (1):
      btrfs: flush write bio if we loop in extent_write_cache_pages

Kairui Song (1):
      x86/kexec: Use up-to-dated screen_info copy to fill boot params

Keith Winstein (1):
      ALSA: usb-audio: Add implicit feedback quirk for Zoom UAC-2

Lee Jones (1):
      Fonts: Replace discarded const qualifier

Luis Chamberlain (1):
      blktrace: fix debugfs use after free

Macpaul Lin (1):
      usb: mtu3: fix panic in mtu3_gadget_stop()

Mark Deneen (1):
      cadence: force nonlinear buffers to be cloned

Mike Galbraith (1):
      futex: Handle transient "ownerless" rtmutex state correctly

Ming Lei (1):
      scsi: core: Don't start concurrent async scan on same host

Oleg Nesterov (1):
      ptrace: fix task_join_group_stop() for the case when current is traced

Pali Rohár (1):
      arm64: dts: marvell: espressobin: Add ethernet switch aliases

Petr Malat (1):
      sctp: Fix COMM_LOST/CANT_STR_ASSOC err reporting on big-endian platforms

Qinglang Miao (1):
      serial: txx9: add missing platform_driver_unregister() on error in serial_txx9_init

Qiujun Huang (1):
      tracing: Fix out of bounds write in get_trace_buf

Qu Wenruo (15):
      btrfs: extent_io: Kill the forward declaration of flush_write_bio
      btrfs: extent_io: Move the BUG_ON() in flush_write_bio() one level up
      btrfs: extent_io: Handle errors better in extent_write_full_page()
      btrfs: extent_io: Handle errors better in btree_write_cache_pages()
      btrfs: extent_io: add proper error handling to lock_extent_buffer_for_io()
      btrfs: Don't submit any btree write bio if the fs has errors
      btrfs: Move btrfs_check_chunk_valid() to tree-check.[ch] and export it
      btrfs: tree-checker: Make chunk item checker messages more readable
      btrfs: tree-checker: Make btrfs_check_chunk_valid() return EUCLEAN instead of EIO
      btrfs: tree-checker: Check chunk item at tree block read time
      btrfs: tree-checker: Verify dev item
      btrfs: tree-checker: Fix wrong check on max devid
      btrfs: tree-checker: Enhance chunk checker to validate chunk profile
      btrfs: tree-checker: Verify inode item
      btrfs: tree-checker: fix the error message for transid error

Rafael J. Wysocki (1):
      PM: runtime: Resume the device earlier in __device_release_driver()

Shijie Luo (1):
      mm: mempolicy: fix potential pte_unmap_unlock pte error

Steven Rostedt (VMware) (3):
      ring-buffer: Fix recursion protection transitions between interrupt context
      ftrace: Fix recursion check for NMI test
      ftrace: Handle tracing when switching between context

Vasily Gorbik (1):
      lib/crc32test: remove extra local_irq_disable/enable

Vinay Kumar Yadav (2):
      chelsio/chtls: fix memory leaks caused by a race
      chelsio/chtls: fix always leaking ctrl_skb

Vincent Whitchurch (1):
      of: Fix reserved-memory overlap detection

Vineet Gupta (2):
      ARC: stack unwinding: avoid indefinite looping
      Revert "ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE"

Xiaofei Shen (1):
      net: dsa: read mac address from DT for slave device

YueHaibing (1):
      sfp: Fix error handing in sfp_probe()

Zhang Qilong (1):
      ACPI: NFIT: Fix comparison to '-ENXIO'

Ziyi Cao (1):
      USB: serial: option: add Quectel EC200T module support

Zqiang (1):
      kthread_worker: prevent queuing delayed work from timer_fn when it is being canceled

kiyin(尹亮) (1):
      perf/core: Fix a memory leak in perf_event_parse_addr_filter()

