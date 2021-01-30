Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3613095CB
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 15:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhA3OMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 09:12:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229636AbhA3OLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 09:11:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCF0764E17;
        Sat, 30 Jan 2021 14:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612015839;
        bh=LJj7p5D6t24+49F0ai07PL2phYIHToRJ1JdyUwx/wyY=;
        h=From:To:Cc:Subject:Date:From;
        b=cM8F6BYEoolv1QA7lDFpdn6RTjSHpPY9UfsdyEW6w4NTGa1/43hhyPZ3kUzuKcjH0
         fmdH7Jq+KbvSrHMg89ZvU0O+CAeoDBD48oTjH8FyvAzdQukSFtAS2/ZXMtWAm3tfuM
         dkQcxTItQnCt2xL4rFvVCWOH4EwjQTpCpBBcha0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.94
Date:   Sat, 30 Jan 2021 15:10:30 +0100
Message-Id: <16120158304478@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.94 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/device-mapper/dm-integrity.rst |    6 
 Makefile                                                 |    2 
 arch/arm64/include/asm/memory.h                          |    5 
 arch/arm64/include/asm/pgtable.h                         |    4 
 arch/arm64/mm/init.c                                     |   30 --
 drivers/gpio/gpio-mvebu.c                                |   25 -
 drivers/hid/wacom_sys.c                                  |    7 
 drivers/hid/wacom_wac.h                                  |    2 
 drivers/md/dm-integrity.c                                |   24 +
 fs/cifs/smb2pdu.c                                        |    7 
 fs/cifs/smb2pdu.h                                        |   14 
 fs/ext4/inode.c                                          |    2 
 fs/fs-writeback.c                                        |   36 +-
 fs/io_uring.c                                            |    5 
 fs/xfs/libxfs/xfs_trans_inode.c                          |    4 
 include/linux/fs.h                                       |    1 
 include/trace/events/writeback.h                         |    1 
 kernel/futex.c                                           |  219 ++++++---------
 kernel/locking/rtmutex.c                                 |    3 
 kernel/locking/rtmutex_common.h                          |    3 
 kernel/trace/ring_buffer.c                               |    4 
 mm/slub.c                                                |    4 
 tools/build/Makefile                                     |    4 
 tools/objtool/Makefile                                   |    9 
 tools/perf/Makefile.perf                                 |    4 
 tools/power/acpi/Makefile.config                         |    1 
 tools/scripts/Makefile.include                           |   10 
 27 files changed, 210 insertions(+), 226 deletions(-)

Ard Biesheuvel (1):
      arm64: mm: use single quantity to represent the PA to VA translation

Baruch Siach (1):
      gpio: mvebu: fix pwm .get_state period calculation

Eric Biggers (1):
      fs: fix lazytime expiration handling in __writeback_single_inode()

Gaurav Kohli (1):
      tracing: Fix race in trace_open and buffer resize call

Greg Kroah-Hartman (1):
      Linux 5.4.94

Jan Kara (1):
      writeback: Drop I_DIRTY_TIME_EXPIRE

Jason Gerecke (1):
      HID: wacom: Correct NULL dereference on AES pen proximity

Jean-Philippe Brucker (1):
      tools: Factor HOSTCC, HOSTLD, HOSTAR definitions

Mikulas Patocka (1):
      dm integrity: conditionally disable "recalculate" feature

Nicolai Stange (1):
      io_uring: Fix current->fs handling in io_sq_wq_submit_work()

Steve French (1):
      SMB3.1.1: do not log warning message if server doesn't populate salt

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

