Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5585665D102
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 11:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239107AbjADKzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 05:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234876AbjADKyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 05:54:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF53E0A3;
        Wed,  4 Jan 2023 02:54:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15D43616C5;
        Wed,  4 Jan 2023 10:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2F0C433D2;
        Wed,  4 Jan 2023 10:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672829646;
        bh=Av18hcv9mWA2vyGcw9cZhglRmr34xfXsLcHNwPgV72g=;
        h=From:To:Cc:Subject:Date:From;
        b=P9a7mdNfqbFHcs4hI/WuVFHS3xmPG/e5HqzKSNJ0R+eBbkpMLwjbUBLuc4QqgsaV4
         slmt3KbziRntT58AEJRoSzkpc4l7kkd3YXqLGZ9JiqEVp5l/tBfuohxCZPNbOkoe6s
         BOzjct8d//WwLPqMX+S0GTk2Nalwi5bpKJacn7tU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.162
Date:   Wed,  4 Jan 2023 11:53:54 +0100
Message-Id: <167282963420243@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.162 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    4 
 arch/alpha/include/asm/thread_info.h      |    4 
 arch/alpha/kernel/entry.S                 |    2 
 arch/alpha/kernel/process.c               |    2 
 arch/alpha/kernel/signal.c                |    2 
 arch/arc/include/asm/thread_info.h        |    4 
 arch/arc/kernel/entry.S                   |    3 
 arch/arc/kernel/process.c                 |    2 
 arch/arc/kernel/signal.c                  |    2 
 arch/arm/include/asm/thread_info.h        |    7 
 arch/arm/kernel/entry-common.S            |    6 
 arch/arm/kernel/entry-v7m.S               |    2 
 arch/arm/kernel/process.c                 |    2 
 arch/arm/kernel/signal.c                  |    2 
 arch/arm64/include/asm/thread_info.h      |    5 
 arch/arm64/kernel/process.c               |    2 
 arch/arm64/kernel/signal.c                |    2 
 arch/c6x/include/asm/thread_info.h        |    1 
 arch/c6x/kernel/asm-offsets.c             |    1 
 arch/c6x/kernel/signal.c                  |    3 
 arch/csky/include/asm/thread_info.h       |    5 
 arch/csky/kernel/process.c                |    2 
 arch/csky/kernel/signal.c                 |    2 
 arch/h8300/include/asm/thread_info.h      |    4 
 arch/h8300/kernel/process.c               |    2 
 arch/h8300/kernel/signal.c                |    2 
 arch/hexagon/include/asm/thread_info.h    |    2 
 arch/hexagon/kernel/process.c             |    4 
 arch/ia64/include/asm/thread_info.h       |    4 
 arch/ia64/kernel/process.c                |    5 
 arch/ia64/kernel/signal.c                 |    3 
 arch/m68k/include/asm/thread_info.h       |    1 
 arch/m68k/kernel/process.c                |    2 
 arch/m68k/kernel/signal.c                 |    3 
 arch/microblaze/include/asm/thread_info.h |    2 
 arch/microblaze/kernel/process.c          |    2 
 arch/microblaze/kernel/signal.c           |    3 
 arch/mips/include/asm/thread_info.h       |    4 
 arch/mips/kernel/process.c                |    2 
 arch/mips/kernel/signal.c                 |    2 
 arch/nds32/include/asm/thread_info.h      |    2 
 arch/nds32/kernel/ex-exit.S               |    2 
 arch/nds32/kernel/process.c               |    2 
 arch/nds32/kernel/signal.c                |    2 
 arch/nios2/include/asm/thread_info.h      |    2 
 arch/nios2/kernel/process.c               |    2 
 arch/nios2/kernel/signal.c                |    3 
 arch/openrisc/include/asm/thread_info.h   |    2 
 arch/openrisc/kernel/process.c            |    2 
 arch/openrisc/kernel/signal.c             |    2 
 arch/parisc/include/asm/thread_info.h     |    4 
 arch/parisc/kernel/process.c              |    2 
 arch/parisc/kernel/signal.c               |    3 
 arch/powerpc/include/asm/thread_info.h    |    5 
 arch/powerpc/kernel/process.c             |    2 
 arch/powerpc/kernel/signal.c              |    2 
 arch/riscv/include/asm/thread_info.h      |    5 
 arch/riscv/kernel/process.c               |    2 
 arch/riscv/kernel/signal.c                |    2 
 arch/s390/include/asm/thread_info.h       |    2 
 arch/s390/kernel/entry.S                  |   11 
 arch/s390/kernel/process.c                |    2 
 arch/s390/kernel/signal.c                 |    2 
 arch/sh/include/asm/thread_info.h         |    4 
 arch/sh/kernel/process_32.c               |    2 
 arch/sh/kernel/signal_32.c                |    2 
 arch/sparc/include/asm/thread_info_32.h   |    4 
 arch/sparc/include/asm/thread_info_64.h   |    6 
 arch/sparc/kernel/process_32.c            |    2 
 arch/sparc/kernel/process_64.c            |    2 
 arch/sparc/kernel/signal_32.c             |    2 
 arch/sparc/kernel/signal_64.c             |    2 
 arch/um/include/asm/thread_info.h         |    2 
 arch/um/kernel/process.c                  |    5 
 arch/x86/include/asm/thread_info.h        |    2 
 arch/x86/kernel/process.c                 |   17 
 arch/x86/kernel/signal.c                  |    4 
 arch/xtensa/include/asm/thread_info.h     |    5 
 arch/xtensa/kernel/entry.S                |    4 
 arch/xtensa/kernel/process.c              |    2 
 arch/xtensa/kernel/signal.c               |    3 
 drivers/android/binder.c                  |    2 
 fs/Makefile                               |    2 
 fs/coredump.c                             |    2 
 fs/eventfd.c                              |   37 
 fs/eventpoll.c                            |   18 
 fs/file.c                                 |   34 
 fs/internal.h                             |    3 
 fs/io-wq.c                                | 1242 ---
 fs/io-wq.h                                |  157 
 fs/io_uring.c                             | 9971 ---------------------------
 fs/namei.c                                |   84 
 fs/open.c                                 |    6 
 fs/proc/self.c                            |    7 
 fs/proc/thread_self.c                     |    7 
 include/linux/entry-common.h              |    7 
 include/linux/entry-kvm.h                 |    4 
 include/linux/eventfd.h                   |    7 
 include/linux/fcntl.h                     |    2 
 include/linux/fdtable.h                   |    2 
 include/linux/io_uring.h                  |   46 
 include/linux/namei.h                     |    1 
 include/linux/net.h                       |    3 
 include/linux/sched.h                     |    3 
 include/linux/sched/jobctl.h              |    4 
 include/linux/sched/signal.h              |   18 
 include/linux/sched/task.h                |    2 
 include/linux/socket.h                    |    4 
 include/linux/syscalls.h                  |    2 
 include/linux/task_work.h                 |    2 
 include/linux/tracehook.h                 |   23 
 include/linux/uio.h                       |   15 
 include/trace/events/io_uring.h           |  121 
 include/uapi/linux/eventpoll.h            |    6 
 include/uapi/linux/io_uring.h             |  115 
 include/uapi/linux/openat2.h              |    4 
 io_uring/Makefile                         |    6 
 io_uring/io-wq.c                          | 1398 +++
 io_uring/io-wq.h                          |  160 
 io_uring/io_uring.c                       |10958 ++++++++++++++++++++++++++++++
 kernel/entry/common.c                     |   14 
 kernel/entry/kvm.c                        |    2 
 kernel/events/uprobes.c                   |    2 
 kernel/exit.c                             |    2 
 kernel/fork.c                             |   33 
 kernel/sched/core.c                       |    2 
 kernel/signal.c                           |   53 
 kernel/task_work.c                        |   48 
 lib/iov_iter.c                            |   52 
 net/ipv4/af_inet.c                        |    1 
 net/ipv6/af_inet6.c                       |    1 
 net/socket.c                              |   92 
 tools/include/uapi/linux/openat2.h        |    4 
 133 files changed, 13273 insertions(+), 11767 deletions(-)

Al Viro (4):
      saner calling conventions for unlazy_child()
      fix handling of nd->depth on LOOKUP_CACHED failures in try_to_unlazy*
      Make sure nd->path.mnt and nd->path.dentry are always valid pointers
      alpha: fix TIF_NOTIFY_SIGNAL handling

Arnaldo Carvalho de Melo (1):
      tools headers UAPI: Sync openat2.h with the kernel sources

Eric W. Biederman (2):
      file: Rename __close_fd_get_file close_fd_get_file
      coredump: Limit what can interrupt coredumps

Greg Kroah-Hartman (1):
      Linux 5.10.162

Jens Axboe (52):
      kernel: provide create_io_thread() helper
      iov_iter: add helper to save iov_iter state
      fs: add support for LOOKUP_CACHED
      fs: expose LOOKUP_CACHED through openat2() RESOLVE_CACHED
      net: provide __sys_shutdown_sock() that takes a socket
      signal: Add task_sigpending() helper
      fs: make do_renameat2() take struct filename
      fs: provide locked helper variant of close_fd_get_file()
      entry: Add support for TIF_NOTIFY_SIGNAL
      task_work: Use TIF_NOTIFY_SIGNAL if available
      x86: Wire up TIF_NOTIFY_SIGNAL
      arc: add support for TIF_NOTIFY_SIGNAL
      arm64: add support for TIF_NOTIFY_SIGNAL
      m68k: add support for TIF_NOTIFY_SIGNAL
      nios32: add support for TIF_NOTIFY_SIGNAL
      parisc: add support for TIF_NOTIFY_SIGNAL
      powerpc: add support for TIF_NOTIFY_SIGNAL
      mips: add support for TIF_NOTIFY_SIGNAL
      s390: add support for TIF_NOTIFY_SIGNAL
      um: add support for TIF_NOTIFY_SIGNAL
      sh: add support for TIF_NOTIFY_SIGNAL
      openrisc: add support for TIF_NOTIFY_SIGNAL
      csky: add support for TIF_NOTIFY_SIGNAL
      hexagon: add support for TIF_NOTIFY_SIGNAL
      microblaze: add support for TIF_NOTIFY_SIGNAL
      arm: add support for TIF_NOTIFY_SIGNAL
      xtensa: add support for TIF_NOTIFY_SIGNAL
      alpha: add support for TIF_NOTIFY_SIGNAL
      c6x: add support for TIF_NOTIFY_SIGNAL
      h8300: add support for TIF_NOTIFY_SIGNAL
      ia64: add support for TIF_NOTIFY_SIGNAL
      nds32: add support for TIF_NOTIFY_SIGNAL
      riscv: add support for TIF_NOTIFY_SIGNAL
      sparc: add support for TIF_NOTIFY_SIGNAL
      ia64: don't call handle_signal() unless there's actually a signal queued
      task_work: remove legacy TWA_SIGNAL path
      kernel: remove checking for TIF_NOTIFY_SIGNAL
      kernel: allow fork with TIF_NOTIFY_SIGNAL pending
      arch: setup PF_IO_WORKER threads like PF_KTHREAD
      arch: ensure parisc/powerpc handle PF_IO_WORKER in copy_thread()
      kernel: stop masking signals in create_io_thread()
      kernel: don't call do_exit() for PF_IO_WORKER threads
      task_work: add helper for more targeted task_work canceling
      io_uring: import 5.15-stable io_uring
      signal: kill JOBCTL_TASK_WORK
      task_work: unconditionally run task_work from get_signal()
      net: remove cmsg restriction from io_uring based send/recvmsg calls
      Revert "proc: don't allow async path resolution of /proc/thread-self components"
      Revert "proc: don't allow async path resolution of /proc/self components"
      eventpoll: add EPOLL_URING_WAKE poll wakeup flag
      eventfd: provide a eventfd_signal_mask() helper
      io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and wakeups

Pavel Begunkov (1):
      net: add accept helper not installing fd

Seth Forshee (1):
      entry/kvm: Exit to user mode when TIF_NOTIFY_SIGNAL is set

Stefan Metzmacher (1):
      x86/process: setup io_threads more like normal user space threads

Vineet Gupta (1):
      ARC: unbork 5.11 bootup: fix snafu in _TIF_NOTIFY_SIGNAL handling

