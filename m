Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0555ADB8AE
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 22:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437716AbfJQUwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 16:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728420AbfJQUwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 16:52:45 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1647521A4C;
        Thu, 17 Oct 2019 20:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571345564;
        bh=VVTtYjO4vtlWfWH/sK7IXK3trboSDkbsz0awpPKXjsg=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=gEaaPRvtENNhfYDrTxYYjOONVbsyuYcQxbghu8jh7LKE7LMbnEXUj2Wox7Pfo/J9+
         Eb4RN1D8nJ+fmsfElkP/mV1m+V9Hqx9TEdgFQ8+H2Bn+SW1956mYcZkWb4NggbOGif
         VY1XPi5TrljoOfdsuXy60MWoy94r2qvgyFQiXytc=
Date:   Thu, 17 Oct 2019 20:52:43 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc:     Hrvoje Zeba <zeba.hrvoje@gmail.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] io_uring: fix up O_NONBLOCK handling for sockets
In-Reply-To: <f999615b-205c-49b7-b272-c4e42e45e09d@kernel.dk>
References: <f999615b-205c-49b7-b272-c4e42e45e09d@kernel.dk>
Message-Id: <20191017205244.1647521A4C@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.3.6, v4.19.79, v4.14.149, v4.9.196, v4.4.196.

v5.3.6: Failed to apply! Possible dependencies:
    18d9be1a970c3 ("io_uring: add io_queue_async_work() helper")
    4fe2c963154c3 ("io_uring: add support for link with drain")
    5262f567987d3 ("io_uring: IORING_OP_TIMEOUT support")
    75b28affdd6ae ("io_uring: allocate the two rings together")
    c576666863b78 ("io_uring: optimize submit_and_wait API")

v4.19.79: Failed to apply! Possible dependencies:
    2b188cc1bb857 ("Add io_uring IO interface")
    31b515106428b ("io_uring: allow workqueue item to handle multiple buffered requests")
    4e21565b7fd4d ("asm-generic: add kexec_file_load system call to unistd.h")
    5262f567987d3 ("io_uring: IORING_OP_TIMEOUT support")
    6b06314c47e14 ("io_uring: add file set registration")
    9a56a2323dbbd ("io_uring: use fget/fput_many() for file references")
    c992fe2925d77 ("io_uring: add fsync support")
    d530a402a114e ("io_uring: add prepped flag")
    de0617e467171 ("io_uring: add support for marking commands as draining")
    def596e9557c9 ("io_uring: support for IO polling")
    edafccee56ff3 ("io_uring: add support for pre-mapped user IO buffers")

v4.14.149: Failed to apply! Possible dependencies:
    05c17cedf85ba ("x86: Wire up restartable sequence system call")
    1bd21c6c21e84 ("syscalls/core: Introduce CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y")
    2b188cc1bb857 ("Add io_uring IO interface")
    3c1c456f9b96c ("syscalls: sort syscall prototypes in include/linux/syscalls.h")
    4ddb45db30851 ("x86/syscalls: Use COMPAT_SYSCALL_DEFINEx() macros for x86-only compat syscalls")
    5262f567987d3 ("io_uring: IORING_OP_TIMEOUT support")
    5ac9efa3c50d7 ("syscalls/core, syscalls/x86: Clean up compat syscall stub naming convention")
    66f4e88cc69da ("x86/ioport: add ksys_ioperm() helper; remove in-kernel calls to sys_ioperm()")
    7a074e96dee62 ("aio: implement io_pgetevents")
    7c2178c1ff482 ("x86/syscalls: Use proper syscall definition for sys_ioperm()")
    ab0d1e85bfd0c ("fs/quota: use COMPAT_SYSCALL_DEFINE for sys32_quotactl()")
    af52201d99162 ("x86/entry: Do not special-case clone(2) in compat entry")
    b411991e0ca88 ("x86/syscalls/32: Simplify $entry == $compat entries")
    b51d3cdf44d5c ("x86: remove compat_sys_x86_waitpid()")
    d53238cd51a80 ("kernel: open-code sys_rt_sigpending() in sys_sigpending()")
    de0617e467171 ("io_uring: add support for marking commands as draining")
    dfe64506c01e5 ("x86/syscalls: Don't pointlessly reload the system call number")
    e145242ea0df6 ("syscalls/core, syscalls/x86: Clean up syscall stub naming convention")
    ebeb8c82ffaf9 ("syscalls/x86: Use 'struct pt_regs' based syscall calling for IA32_EMULATION and x32")
    fa697140f9a20 ("syscalls/x86: Use 'struct pt_regs' based syscall calling convention for 64-bit syscalls")

v4.9.196: Failed to apply! Possible dependencies:
    05c17cedf85ba ("x86: Wire up restartable sequence system call")
    2611dc1939569 ("Remove compat_sys_getdents64()")
    2b188cc1bb857 ("Add io_uring IO interface")
    3a404842547c9 ("x86/entry: define _TIF_ALLWORK_MASK flags explicitly")
    499934898fcd1 ("x86/entry/64: Use ENTRY() instead of ALIGN+GLOBAL for stub32_clone()")
    4ddb45db30851 ("x86/syscalls: Use COMPAT_SYSCALL_DEFINEx() macros for x86-only compat syscalls")
    5262f567987d3 ("io_uring: IORING_OP_TIMEOUT support")
    5ac9efa3c50d7 ("syscalls/core, syscalls/x86: Clean up compat syscall stub naming convention")
    5ea0727b163cb ("x86/syscalls: Check address limit on user-mode return")
    66f4e88cc69da ("x86/ioport: add ksys_ioperm() helper; remove in-kernel calls to sys_ioperm()")
    7a074e96dee62 ("aio: implement io_pgetevents")
    7c2178c1ff482 ("x86/syscalls: Use proper syscall definition for sys_ioperm()")
    a528d35e8bfcc ("statx: Add a system call to make enhanced file info available")
    ab0d1e85bfd0c ("fs/quota: use COMPAT_SYSCALL_DEFINE for sys32_quotactl()")
    af52201d99162 ("x86/entry: Do not special-case clone(2) in compat entry")
    afb94c9e0b413 ("livepatch/x86: add TIF_PATCH_PENDING thread flag")
    b411991e0ca88 ("x86/syscalls/32: Simplify $entry == $compat entries")
    b51d3cdf44d5c ("x86: remove compat_sys_x86_waitpid()")
    de0617e467171 ("io_uring: add support for marking commands as draining")
    dfe64506c01e5 ("x86/syscalls: Don't pointlessly reload the system call number")
    e145242ea0df6 ("syscalls/core, syscalls/x86: Clean up syscall stub naming convention")
    ebeb8c82ffaf9 ("syscalls/x86: Use 'struct pt_regs' based syscall calling for IA32_EMULATION and x32")
    fa697140f9a20 ("syscalls/x86: Use 'struct pt_regs' based syscall calling convention for 64-bit syscalls")

v4.4.196: Failed to apply! Possible dependencies:
    05c17cedf85ba ("x86: Wire up restartable sequence system call")
    1e423bff959e4 ("x86/entry/64: Migrate the 64-bit syscall slow path to C")
    2b188cc1bb857 ("Add io_uring IO interface")
    302f5b260c322 ("x86/entry/64: Always run ptregs-using syscalls on the slow path")
    3e65654e3db6d ("x86/syscalls: Move compat syscall entry handling into syscalltbl.sh")
    46eabf06c04a6 ("x86/entry/64: Call all native slow-path syscalls with full pt-regs")
    5262f567987d3 ("io_uring: IORING_OP_TIMEOUT support")
    5ac9efa3c50d7 ("syscalls/core, syscalls/x86: Clean up compat syscall stub naming convention")
    7a074e96dee62 ("aio: implement io_pgetevents")
    95d97adb2bb85 ("x86/signal: Cleanup get_nr_restart_syscall()")
    97245d00585d8 ("x86/entry: Get rid of pt_regs_to_thread_info()")
    abfb9498ee132 ("x86/entry: Rename is_{ia32,x32}_task() to in_{ia32,x32}_syscall()")
    c87a85177e7a7 ("x86/entry: Get rid of two-phase syscall entry work")
    cfcbadb49dabb ("x86/syscalls: Add syscall entry qualifiers")
    de0617e467171 ("io_uring: add support for marking commands as draining")
    dfe64506c01e5 ("x86/syscalls: Don't pointlessly reload the system call number")
    e145242ea0df6 ("syscalls/core, syscalls/x86: Clean up syscall stub naming convention")
    ebeb8c82ffaf9 ("syscalls/x86: Use 'struct pt_regs' based syscall calling for IA32_EMULATION and x32")
    fa697140f9a20 ("syscalls/x86: Use 'struct pt_regs' based syscall calling convention for 64-bit syscalls")
    fba324744bfd2 ("x86/syscalls: Refactor syscalltbl.sh")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks,
Sasha
