Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330473096D6
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 17:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhA3Qhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 11:37:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhA3OLz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 09:11:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1558964E1A;
        Sat, 30 Jan 2021 14:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612015848;
        bh=uV4tH91mFvi/noHkc5s8X04RKZrL7Ms6aokmvMEDeVw=;
        h=From:To:Cc:Subject:Date:From;
        b=TY7y/tEGkBEVKQSFjAayMqIegTt1WijosCtvHHZ2RJKaBpQvAg2c3Y19Lga46yUrY
         LvEne4V8nBGF9/OOdFMFe4e0TxDccpcUuX4SATIfrZRahTaCmsapEklkwfiRIIdFLT
         Na6q6vKTzR1e81yZruJpULzgpsJB1j8fFB6nxZEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.12
Date:   Sat, 30 Jan 2021 15:10:38 +0100
Message-Id: <161201583820241@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.12 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 
 drivers/gpio/gpio-mvebu.c                        |   25 +-
 drivers/hid/hid-multitouch.c                     |    3 
 drivers/hid/wacom_sys.c                          |    7 
 drivers/hid/wacom_wac.h                          |    2 
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h        |   14 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c     |    2 
 drivers/media/common/videobuf2/videobuf2-v4l2.c  |    3 
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c |    7 
 fs/file.c                                        |    2 
 fs/io_uring.c                                    |  119 ++++++++----
 include/uapi/linux/v4l2-subdev.h                 |    2 
 include/uapi/rdma/vmw_pvrdma-abi.h               |    7 
 kernel/exit.c                                    |    2 
 kernel/futex.c                                   |  219 ++++++++++-------------
 kernel/locking/rtmutex.c                         |    3 
 kernel/locking/rtmutex_common.h                  |    3 
 kernel/printk/printk.c                           |   36 ++-
 mm/page_alloc.c                                  |   31 +--
 mm/slub.c                                        |    4 
 mm/swapfile.c                                    |   11 -
 tools/bpf/resolve_btfids/Makefile                |    9 
 tools/build/Makefile                             |    4 
 tools/objtool/Makefile                           |    9 
 tools/objtool/elf.c                              |    7 
 tools/perf/Makefile.perf                         |    4 
 tools/power/acpi/Makefile.config                 |    1 
 tools/scripts/Makefile.include                   |   10 +
 28 files changed, 291 insertions(+), 257 deletions(-)

Baruch Siach (1):
      gpio: mvebu: fix pwm .get_state period calculation

Bryan Tan (1):
      RDMA/vmw_pvrdma: Fix network_hdr_type reported in WC

Greg Kroah-Hartman (1):
      Linux 5.10.12

Hailong liu (1):
      mm/page_alloc: add a missing mm_page_alloc_zone_locked() tracepoint

Hans Verkuil (1):
      media: v4l2-subdev.h: BIT() is not available in userspace

Jason Gerecke (1):
      HID: wacom: Correct NULL dereference on AES pen proximity

Jean-Philippe Brucker (1):
      tools: Factor HOSTCC, HOSTLD, HOSTAR definitions

John Ogness (2):
      printk: fix buffer overflow potential for print_text()
      printk: fix string termination for record_print_text()

Josh Poimboeuf (1):
      objtool: Don't fail on missing symbol table

Kai-Heng Feng (1):
      HID: multitouch: Apply MT_QUIRK_CONFIDENCE quirk for multi-input devices

Naushir Patuck (1):
      media: Revert "media: videobuf2: Fix length check for single plane dmabuf queueing"

Pavel Begunkov (11):
      kernel/io_uring: cancel io_uring before task works
      io_uring: inline io_uring_attempt_task_drop()
      io_uring: add warn_once for io_uring_flush()
      io_uring: stop SQPOLL submit on creator's death
      io_uring: fix null-deref in io_disable_sqo_submit
      io_uring: do sqo disable on install_fd error
      io_uring: fix false positive sqo warning on flush
      io_uring: fix uring_flush in exit_files() warning
      io_uring: fix skipping disabling sqo on exec
      io_uring: dont kill fasync under completion_lock
      io_uring: fix sleeping under spin in __io_clean_op

Takashi Iwai (1):
      iwlwifi: dbg: Don't touch the tlv data

Thomas Gleixner (7):
      futex: Ensure the correct return value from futex_lock_pi()
      futex: Replace pointless printk in fixup_owner()
      futex: Provide and use pi_state_update_owner()
      rtmutex: Remove unused argument from rt_mutex_proxy_unlock()
      futex: Use pi_state_update_owner() in put_pi_state()
      futex: Simplify fixup_pi_state_owner()
      futex: Handle faults correctly for PI futexes

Wang Hai (1):
      Revert "mm/slub: fix a memory leak in sysfs_slab_add()"

Zhaoyang Huang (1):
      mm: fix a race on nr_swap_pages

