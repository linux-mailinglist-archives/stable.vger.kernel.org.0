Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9342AD972
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 15:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732494AbgKJO46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 09:56:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731436AbgKJO4O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 09:56:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FE9420797;
        Tue, 10 Nov 2020 14:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605020173;
        bh=nWJse3tl7mQC9hnSV0fG7gsn6lO2lbZ1mpJXVo1VUx8=;
        h=From:To:Cc:Subject:Date:From;
        b=Un2xaHtt9owUw9xZRWVdtDa7ygf+p/M+xaZ8V8DiGnZ8hpcOumJSdPVsxi2LeFqBE
         QFkYOsye+j67ssOJRnJ5R72jo76EQncsdhu6tG8r6ZKDBp45oeIpmBCT2HPdqe1uxP
         SeahCR6pSM1JOmrMkd2VOlLE2uYuHETFkLg/NgFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.205
Date:   Tue, 10 Nov 2020 15:57:02 +0100
Message-Id: <16050202226887@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.205 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 -
 arch/arc/kernel/entry.S                                 |   16 +++++---
 arch/arc/kernel/stacktrace.c                            |    7 +++
 arch/arm/boot/dts/sun4i-a10.dtsi                        |    2 -
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts |    4 ++
 arch/x86/kernel/kexec-bzimage64.c                       |    3 -
 block/blk-cgroup.c                                      |   15 ++++++-
 drivers/acpi/nfit/core.c                                |    2 -
 drivers/base/dd.c                                       |    7 ++-
 drivers/gpu/drm/i915/i915_gpu_error.c                   |    3 +
 drivers/gpu/drm/vc4/vc4_drv.c                           |    1 
 drivers/net/ethernet/freescale/gianfar.c                |   14 +------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c      |   32 +++++++++++++---
 drivers/net/phy/sfp.c                                   |    3 +
 drivers/net/usb/qmi_wwan.c                              |    1 
 drivers/of/of_reserved_mem.c                            |   13 +++++-
 drivers/scsi/scsi_scan.c                                |    7 ++-
 drivers/tty/serial/8250/8250_mtk.c                      |    2 -
 drivers/tty/serial/serial_txx9.c                        |    3 +
 drivers/tty/vt/vt.c                                     |   24 +-----------
 drivers/usb/core/quirks.c                               |    3 +
 drivers/usb/mtu3/mtu3_gadget.c                          |    1 
 drivers/usb/serial/cyberjack.c                          |    7 +++
 drivers/usb/serial/option.c                             |   10 +++++
 drivers/xen/events/events_base.c                        |   29 ++++++++++----
 fs/gfs2/glock.c                                         |    3 +
 include/asm-generic/pgtable.h                           |    4 --
 include/linux/mm.h                                      |    9 ++++
 kernel/fork.c                                           |   10 ++---
 kernel/futex.c                                          |   16 +++++++-
 kernel/kthread.c                                        |    3 +
 kernel/trace/blktrace.c                                 |   24 +++++++-----
 kernel/trace/trace.c                                    |    2 -
 kernel/trace/trace.h                                    |   26 +++++++++++--
 kernel/trace/trace_selftest.c                           |    9 +++-
 lib/crc32test.c                                         |    4 --
 lib/fonts/font_10x18.c                                  |    2 -
 lib/fonts/font_6x10.c                                   |    2 -
 lib/fonts/font_6x11.c                                   |    2 -
 lib/fonts/font_7x14.c                                   |    2 -
 lib/fonts/font_8x16.c                                   |    2 -
 lib/fonts/font_8x8.c                                    |    2 -
 lib/fonts/font_acorn_8x8.c                              |    2 -
 lib/fonts/font_mini_4x6.c                               |    2 -
 lib/fonts/font_pearl_8x8.c                              |    2 -
 lib/fonts/font_sun12x22.c                               |    2 -
 lib/fonts/font_sun8x16.c                                |    2 -
 net/sctp/sm_sideeffect.c                                |    4 +-
 net/tipc/core.c                                         |    5 ++
 net/vmw_vsock/af_vsock.c                                |    2 -
 sound/usb/pcm.c                                         |    1 
 51 files changed, 239 insertions(+), 116 deletions(-)

Alan Stern (1):
      USB: Add NO_LPM quirk for Kingston flash drive

Alexander Aring (1):
      gfs2: Wake up when sd_glock_disposal becomes zero

Chris Wilson (1):
      drm/i915: Break up error capture compression loops with cond_resched()

Christophe JAILLET (1):
      i40e: Fix a potential NULL pointer dereference

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

Gabriel Krisman Bertazi (2):
      blk-cgroup: Fix memleak on error path
      blk-cgroup: Pre-allocate tree node on blkg_conf_prep

Geoffrey D. Bennett (1):
      ALSA: usb-audio: Add implicit feedback quirk for Qu-16

Greg Kroah-Hartman (1):
      Linux 4.14.205

Grzegorz Siwik (1):
      i40e: Wrong truncation from u16 to u8

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

Juergen Gross (1):
      xen/events: don't use chip_data for legacy IRQs

Kairui Song (1):
      x86/kexec: Use up-to-dated screen_info copy to fill boot params

Lee Jones (1):
      Fonts: Replace discarded const qualifier

Liu Bo (1):
      Blktrace: bail out early if block debugfs is not configured

Luis Chamberlain (1):
      blktrace: fix debugfs use after free

Macpaul Lin (1):
      usb: mtu3: fix panic in mtu3_gadget_stop()

Martyna Szapar (2):
      i40e: Fix of memory leak and integer truncation in i40e_virtchnl.c
      i40e: Memory leak in i40e_config_iwarp_qvlist

Mike Galbraith (1):
      futex: Handle transient "ownerless" rtmutex state correctly

Ming Lei (1):
      scsi: core: Don't start concurrent async scan on same host

Petr Malat (1):
      sctp: Fix COMM_LOST/CANT_STR_ASSOC err reporting on big-endian platforms

Qinglang Miao (1):
      serial: txx9: add missing platform_driver_unregister() on error in serial_txx9_init

Qiujun Huang (1):
      tracing: Fix out of bounds write in get_trace_buf

Rafael J. Wysocki (1):
      PM: runtime: Resume the device earlier in __device_release_driver()

Sergey Nemov (1):
      i40e: add num_vectors checker in iwarp handler

Steven Rostedt (VMware) (2):
      ftrace: Fix recursion check for NMI test
      ftrace: Handle tracing when switching between context

Tomasz Maciej Nowak (1):
      arm64: dts: marvell: espressobin: add ethernet alias

Vasily Gorbik (1):
      lib/crc32test: remove extra local_irq_disable/enable

Vincent Whitchurch (1):
      of: Fix reserved-memory overlap detection

Vineet Gupta (2):
      ARC: stack unwinding: avoid indefinite looping
      Revert "ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE"

YueHaibing (1):
      sfp: Fix error handing in sfp_probe()

Zhang Qilong (1):
      ACPI: NFIT: Fix comparison to '-ENXIO'

Ziyi Cao (1):
      USB: serial: option: add Quectel EC200T module support

Zqiang (1):
      kthread_worker: prevent queuing delayed work from timer_fn when it is being canceled

