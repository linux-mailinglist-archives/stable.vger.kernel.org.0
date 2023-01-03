Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DFB65BBC0
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236844AbjACIPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237001AbjACIPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:15:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B29BDFAF;
        Tue,  3 Jan 2023 00:15:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9546611CF;
        Tue,  3 Jan 2023 08:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B76CC433D2;
        Tue,  3 Jan 2023 08:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733718;
        bh=hnWNEt1fjmS6d0+9acw0WbwhRzl9X1Q7/qGg0fQCLuc=;
        h=From:To:Cc:Subject:Date:From;
        b=Jw6lADNwQiwlfw6yUGZmMd8/ujjx0WN/+Pgr7lZuW5WNbbXgi7VICezaU6+mdW0UU
         MMlOgL6gkT9s41BCEUEWoT/08kdSXHBSjdKSwzFQzoNXoQ5ohqe+BOuu03EXOzJOwN
         lqclPZFvYA+W4ueqssrUQjCjjT/+PGQEpuWApeJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 00/63] 5.10.162-rc1 review
Date:   Tue,  3 Jan 2023 09:13:30 +0100
Message-Id: <20230103081308.548338576@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.162-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.162-rc1
X-KernelTest-Deadline: 2023-01-05T08:13+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.162 release.
There are 63 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 05 Jan 2023 08:12:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.162-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.162-rc1

Jens Axboe <axboe@kernel.dk>
    io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and wakeups

Jens Axboe <axboe@kernel.dk>
    eventfd: provide a eventfd_signal_mask() helper

Jens Axboe <axboe@kernel.dk>
    eventpoll: add EPOLL_URING_WAKE poll wakeup flag

Jens Axboe <axboe@kernel.dk>
    Revert "proc: don't allow async path resolution of /proc/self components"

Jens Axboe <axboe@kernel.dk>
    Revert "proc: don't allow async path resolution of /proc/thread-self components"

Jens Axboe <axboe@kernel.dk>
    net: remove cmsg restriction from io_uring based send/recvmsg calls

Jens Axboe <axboe@kernel.dk>
    task_work: unconditionally run task_work from get_signal()

Jens Axboe <axboe@kernel.dk>
    signal: kill JOBCTL_TASK_WORK

Jens Axboe <axboe@kernel.dk>
    io_uring: import 5.15-stable io_uring

Jens Axboe <axboe@kernel.dk>
    task_work: add helper for more targeted task_work canceling

Jens Axboe <axboe@kernel.dk>
    kernel: don't call do_exit() for PF_IO_WORKER threads

Jens Axboe <axboe@kernel.dk>
    kernel: stop masking signals in create_io_thread()

Stefan Metzmacher <metze@samba.org>
    x86/process: setup io_threads more like normal user space threads

Jens Axboe <axboe@kernel.dk>
    arch: ensure parisc/powerpc handle PF_IO_WORKER in copy_thread()

Jens Axboe <axboe@kernel.dk>
    arch: setup PF_IO_WORKER threads like PF_KTHREAD

Seth Forshee <sforshee@digitalocean.com>
    entry/kvm: Exit to user mode when TIF_NOTIFY_SIGNAL is set

Jens Axboe <axboe@kernel.dk>
    kernel: allow fork with TIF_NOTIFY_SIGNAL pending

Eric W. Biederman <ebiederm@xmission.com>
    coredump: Limit what can interrupt coredumps

Jens Axboe <axboe@kernel.dk>
    kernel: remove checking for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    task_work: remove legacy TWA_SIGNAL path

Al Viro <viro@zeniv.linux.org.uk>
    alpha: fix TIF_NOTIFY_SIGNAL handling

Vineet Gupta <vgupta@synopsys.com>
    ARC: unbork 5.11 bootup: fix snafu in _TIF_NOTIFY_SIGNAL handling

Jens Axboe <axboe@kernel.dk>
    ia64: don't call handle_signal() unless there's actually a signal queued

Jens Axboe <axboe@kernel.dk>
    sparc: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    riscv: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    nds32: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    ia64: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    h8300: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    c6x: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    alpha: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    xtensa: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    arm: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    microblaze: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    hexagon: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    csky: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    openrisc: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    sh: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    um: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    s390: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    mips: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    powerpc: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    parisc: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    nios32: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    m68k: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    arm64: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    arc: add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    x86: Wire up TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    task_work: Use TIF_NOTIFY_SIGNAL if available

Jens Axboe <axboe@kernel.dk>
    entry: Add support for TIF_NOTIFY_SIGNAL

Jens Axboe <axboe@kernel.dk>
    fs: provide locked helper variant of close_fd_get_file()

Eric W. Biederman <ebiederm@xmission.com>
    file: Rename __close_fd_get_file close_fd_get_file

Jens Axboe <axboe@kernel.dk>
    fs: make do_renameat2() take struct filename

Jens Axboe <axboe@kernel.dk>
    signal: Add task_sigpending() helper

Pavel Begunkov <asml.silence@gmail.com>
    net: add accept helper not installing fd

Jens Axboe <axboe@kernel.dk>
    net: provide __sys_shutdown_sock() that takes a socket

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools headers UAPI: Sync openat2.h with the kernel sources

Jens Axboe <axboe@kernel.dk>
    fs: expose LOOKUP_CACHED through openat2() RESOLVE_CACHED

Al Viro <viro@zeniv.linux.org.uk>
    Make sure nd->path.mnt and nd->path.dentry are always valid pointers

Al Viro <viro@zeniv.linux.org.uk>
    fix handling of nd->depth on LOOKUP_CACHED failures in try_to_unlazy*

Jens Axboe <axboe@kernel.dk>
    fs: add support for LOOKUP_CACHED

Al Viro <viro@zeniv.linux.org.uk>
    saner calling conventions for unlazy_child()

Jens Axboe <axboe@kernel.dk>
    iov_iter: add helper to save iov_iter state

Jens Axboe <axboe@kernel.dk>
    kernel: provide create_io_thread() helper


-------------

Diffstat:

 Makefile                                  |    6 +-
 arch/alpha/include/asm/thread_info.h      |    4 +-
 arch/alpha/kernel/entry.S                 |    2 +-
 arch/alpha/kernel/process.c               |    2 +-
 arch/alpha/kernel/signal.c                |    2 +-
 arch/arc/include/asm/thread_info.h        |    4 +-
 arch/arc/kernel/entry.S                   |    3 +-
 arch/arc/kernel/process.c                 |    2 +-
 arch/arc/kernel/signal.c                  |    2 +-
 arch/arm/include/asm/thread_info.h        |    7 +-
 arch/arm/kernel/entry-common.S            |    6 +-
 arch/arm/kernel/entry-v7m.S               |    2 +-
 arch/arm/kernel/process.c                 |    2 +-
 arch/arm/kernel/signal.c                  |    2 +-
 arch/arm64/include/asm/thread_info.h      |    5 +-
 arch/arm64/kernel/process.c               |    2 +-
 arch/arm64/kernel/signal.c                |    2 +-
 arch/c6x/include/asm/thread_info.h        |    1 +
 arch/c6x/kernel/asm-offsets.c             |    1 +
 arch/c6x/kernel/signal.c                  |    3 +-
 arch/csky/include/asm/thread_info.h       |    5 +-
 arch/csky/kernel/process.c                |    2 +-
 arch/csky/kernel/signal.c                 |    2 +-
 arch/h8300/include/asm/thread_info.h      |    4 +-
 arch/h8300/kernel/process.c               |    2 +-
 arch/h8300/kernel/signal.c                |    2 +-
 arch/hexagon/include/asm/thread_info.h    |    2 +
 arch/hexagon/kernel/process.c             |    4 +-
 arch/ia64/include/asm/thread_info.h       |    4 +-
 arch/ia64/kernel/process.c                |    5 +-
 arch/ia64/kernel/signal.c                 |    3 +-
 arch/m68k/include/asm/thread_info.h       |    1 +
 arch/m68k/kernel/process.c                |    2 +-
 arch/m68k/kernel/signal.c                 |    3 +-
 arch/microblaze/include/asm/thread_info.h |    2 +
 arch/microblaze/kernel/process.c          |    2 +-
 arch/microblaze/kernel/signal.c           |    3 +-
 arch/mips/include/asm/thread_info.h       |    4 +-
 arch/mips/kernel/process.c                |    2 +-
 arch/mips/kernel/signal.c                 |    2 +-
 arch/nds32/include/asm/thread_info.h      |    2 +
 arch/nds32/kernel/ex-exit.S               |    2 +-
 arch/nds32/kernel/process.c               |    2 +-
 arch/nds32/kernel/signal.c                |    2 +-
 arch/nios2/include/asm/thread_info.h      |    2 +
 arch/nios2/kernel/process.c               |    2 +-
 arch/nios2/kernel/signal.c                |    3 +-
 arch/openrisc/include/asm/thread_info.h   |    2 +
 arch/openrisc/kernel/process.c            |    2 +-
 arch/openrisc/kernel/signal.c             |    2 +-
 arch/parisc/include/asm/thread_info.h     |    4 +-
 arch/parisc/kernel/process.c              |    2 +-
 arch/parisc/kernel/signal.c               |    3 +-
 arch/powerpc/include/asm/thread_info.h    |    5 +-
 arch/powerpc/kernel/process.c             |    2 +-
 arch/powerpc/kernel/signal.c              |    2 +-
 arch/riscv/include/asm/thread_info.h      |    5 +-
 arch/riscv/kernel/process.c               |    2 +-
 arch/riscv/kernel/signal.c                |    2 +-
 arch/s390/include/asm/thread_info.h       |    2 +
 arch/s390/kernel/entry.S                  |   11 +-
 arch/s390/kernel/process.c                |    2 +-
 arch/s390/kernel/signal.c                 |    2 +-
 arch/sh/include/asm/thread_info.h         |    4 +-
 arch/sh/kernel/process_32.c               |    2 +-
 arch/sh/kernel/signal_32.c                |    2 +-
 arch/sparc/include/asm/thread_info_32.h   |    4 +-
 arch/sparc/include/asm/thread_info_64.h   |    6 +-
 arch/sparc/kernel/process_32.c            |    2 +-
 arch/sparc/kernel/process_64.c            |    2 +-
 arch/sparc/kernel/signal_32.c             |    2 +-
 arch/sparc/kernel/signal_64.c             |    2 +-
 arch/um/include/asm/thread_info.h         |    2 +
 arch/um/kernel/process.c                  |    5 +-
 arch/x86/include/asm/thread_info.h        |    2 +
 arch/x86/kernel/process.c                 |   17 +
 arch/x86/kernel/signal.c                  |    4 +-
 arch/xtensa/include/asm/thread_info.h     |    5 +-
 arch/xtensa/kernel/entry.S                |    4 +-
 arch/xtensa/kernel/process.c              |    2 +-
 arch/xtensa/kernel/signal.c               |    3 +-
 drivers/android/binder.c                  |    2 +-
 fs/Makefile                               |    2 -
 fs/coredump.c                             |    2 +-
 fs/eventfd.c                              |   37 +-
 fs/eventpoll.c                            |   18 +-
 fs/file.c                                 |   34 +-
 fs/internal.h                             |    3 +
 fs/io-wq.c                                | 1242 ----
 fs/namei.c                                |   84 +-
 fs/open.c                                 |    6 +
 fs/proc/self.c                            |    7 -
 fs/proc/thread_self.c                     |    7 -
 include/linux/entry-common.h              |    7 +-
 include/linux/entry-kvm.h                 |    4 +-
 include/linux/eventfd.h                   |    7 +
 include/linux/fcntl.h                     |    2 +-
 include/linux/fdtable.h                   |    2 +-
 include/linux/io_uring.h                  |   46 +-
 include/linux/namei.h                     |    1 +
 include/linux/net.h                       |    3 -
 include/linux/sched.h                     |    3 +
 include/linux/sched/jobctl.h              |    4 +-
 include/linux/sched/signal.h              |   18 +-
 include/linux/sched/task.h                |    2 +
 include/linux/socket.h                    |    4 +
 include/linux/syscalls.h                  |    2 +-
 include/linux/task_work.h                 |    2 +
 include/linux/tracehook.h                 |   23 +
 include/linux/uio.h                       |   15 +
 include/trace/events/io_uring.h           |  121 +-
 include/uapi/linux/eventpoll.h            |    6 +
 include/uapi/linux/io_uring.h             |  115 +-
 include/uapi/linux/openat2.h              |    4 +
 io_uring/Makefile                         |    6 +
 io_uring/io-wq.c                          | 1398 +++++
 {fs => io_uring}/io-wq.h                  |   47 +-
 {fs => io_uring}/io_uring.c               | 9209 ++++++++++++++++-------------
 kernel/entry/common.c                     |   14 +-
 kernel/entry/kvm.c                        |    2 +-
 kernel/events/uprobes.c                   |    2 +-
 kernel/exit.c                             |    2 +-
 kernel/fork.c                             |   33 +-
 kernel/sched/core.c                       |    2 +-
 kernel/signal.c                           |   53 +-
 kernel/task_work.c                        |   48 +-
 lib/iov_iter.c                            |   52 +-
 net/ipv4/af_inet.c                        |    1 -
 net/ipv6/af_inet6.c                       |    1 -
 net/socket.c                              |   92 +-
 tools/include/uapi/linux/openat2.h        |    4 +
 131 files changed, 7279 insertions(+), 5773 deletions(-)


