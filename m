Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49011CC144
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 14:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgEIMat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 08:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbgEIMat (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 May 2020 08:30:49 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0610521775;
        Sat,  9 May 2020 12:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589027448;
        bh=y/iu5sTHaRKQS+/7XC4HQd45Hj9tgLxCJS4jcMvp0C4=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=YYsgdSn+G1AtsWdV23KNXe+f3jX/yvqbZPxeCBddSYzvZoSv1l1DbFi1cVnuvIfLR
         ms4JVEJQY9hcywHAObGgeAzihw/UYKPgLnv9f2j5MDzh/S35xryUyH9BytVXTBu7MN
         bayPGZDg32lYUlhOZZ1H9bd2o2uTePy+ThMqW6lk=
Date:   Sat, 09 May 2020 12:30:46 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Max Kellermann <mk@cm4all.com>
To:     axboe@kernel.dk, linux-fsdevel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Max Kellermann <mk@cm4all.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] fs/io_uring: fix O_PATH fds in openat, openat2, statx
In-Reply-To: <20200508063846.21067-1-mk@cm4all.com>
References: <20200508063846.21067-1-mk@cm4all.com>
Message-Id: <20200509123048.0610521775@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.11, v5.4.39, v4.19.121, v4.14.179, v4.9.222, v4.4.222.

v5.6.11: Build OK!
v5.4.39: Failed to apply! Possible dependencies:
    0463b6c58e55 ("io_uring: use labeled array init in io_op_defs")
    561fb04a6a22 ("io_uring: replace workqueue usage with io-wq")
    771b53d033e8 ("io-wq: small threadpool implementation for io_uring")
    ba5290ccb6b5 ("io_uring: replace s->needs_lock with s->in_async")
    ba816ad61fdf ("io_uring: run dependent links inline if possible")
    c826bd7a743f ("io_uring: add set of tracing events")
    cf6fd4bd559e ("io_uring: inline struct sqe_submit")
    d3656344fea0 ("io_uring: add lookup table for various opcode needs")
    d625c6ee4975 ("io_uring: read opcode and user_data from SQE exactly once")
    fcb323cc53e2 ("io_uring: io_uring: add support for async work inheriting files")

v4.19.121: Failed to apply! Possible dependencies:
    0463b6c58e55 ("io_uring: use labeled array init in io_op_defs")
    2b188cc1bb85 ("Add io_uring IO interface")
    4e21565b7fd4 ("asm-generic: add kexec_file_load system call to unistd.h")
    561fb04a6a22 ("io_uring: replace workqueue usage with io-wq")
    6b06314c47e1 ("io_uring: add file set registration")
    6c271ce2f1d5 ("io_uring: add submission polling")
    9a56a2323dbb ("io_uring: use fget/fput_many() for file references")
    c992fe2925d7 ("io_uring: add fsync support")
    d3656344fea0 ("io_uring: add lookup table for various opcode needs")
    def596e9557c ("io_uring: support for IO polling")

v4.14.179: Failed to apply! Possible dependencies:
    0463b6c58e55 ("io_uring: use labeled array init in io_op_defs")
    05c17cedf85b ("x86: Wire up restartable sequence system call")
    1bd21c6c21e8 ("syscalls/core: Introduce CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y")
    2b188cc1bb85 ("Add io_uring IO interface")
    3c1c456f9b96 ("syscalls: sort syscall prototypes in include/linux/syscalls.h")
    4ddb45db3085 ("x86/syscalls: Use COMPAT_SYSCALL_DEFINEx() macros for x86-only compat syscalls")
    5ac9efa3c50d ("syscalls/core, syscalls/x86: Clean up compat syscall stub naming convention")
    66f4e88cc69d ("x86/ioport: add ksys_ioperm() helper; remove in-kernel calls to sys_ioperm()")
    7a074e96dee6 ("aio: implement io_pgetevents")
    7c2178c1ff48 ("x86/syscalls: Use proper syscall definition for sys_ioperm()")
    9a56a2323dbb ("io_uring: use fget/fput_many() for file references")
    ab0d1e85bfd0 ("fs/quota: use COMPAT_SYSCALL_DEFINE for sys32_quotactl()")
    af52201d9916 ("x86/entry: Do not special-case clone(2) in compat entry")
    b411991e0ca8 ("x86/syscalls/32: Simplify $entry == $compat entries")
    b51d3cdf44d5 ("x86: remove compat_sys_x86_waitpid()")
    d3656344fea0 ("io_uring: add lookup table for various opcode needs")
    d53238cd51a8 ("kernel: open-code sys_rt_sigpending() in sys_sigpending()")
    dfe64506c01e ("x86/syscalls: Don't pointlessly reload the system call number")
    e145242ea0df ("syscalls/core, syscalls/x86: Clean up syscall stub naming convention")
    ebeb8c82ffaf ("syscalls/x86: Use 'struct pt_regs' based syscall calling for IA32_EMULATION and x32")
    fa697140f9a2 ("syscalls/x86: Use 'struct pt_regs' based syscall calling convention for 64-bit syscalls")

v4.9.222: Failed to apply! Possible dependencies:
    0463b6c58e55 ("io_uring: use labeled array init in io_op_defs")
    05c17cedf85b ("x86: Wire up restartable sequence system call")
    2611dc193956 ("Remove compat_sys_getdents64()")
    2b188cc1bb85 ("Add io_uring IO interface")
    3a404842547c ("x86/entry: define _TIF_ALLWORK_MASK flags explicitly")
    499934898fcd ("x86/entry/64: Use ENTRY() instead of ALIGN+GLOBAL for stub32_clone()")
    4ddb45db3085 ("x86/syscalls: Use COMPAT_SYSCALL_DEFINEx() macros for x86-only compat syscalls")
    5ac9efa3c50d ("syscalls/core, syscalls/x86: Clean up compat syscall stub naming convention")
    5ea0727b163c ("x86/syscalls: Check address limit on user-mode return")
    66f4e88cc69d ("x86/ioport: add ksys_ioperm() helper; remove in-kernel calls to sys_ioperm()")
    7a074e96dee6 ("aio: implement io_pgetevents")
    7c2178c1ff48 ("x86/syscalls: Use proper syscall definition for sys_ioperm()")
    9a56a2323dbb ("io_uring: use fget/fput_many() for file references")
    ab0d1e85bfd0 ("fs/quota: use COMPAT_SYSCALL_DEFINE for sys32_quotactl()")
    af52201d9916 ("x86/entry: Do not special-case clone(2) in compat entry")
    afb94c9e0b41 ("livepatch/x86: add TIF_PATCH_PENDING thread flag")
    b411991e0ca8 ("x86/syscalls/32: Simplify $entry == $compat entries")
    b51d3cdf44d5 ("x86: remove compat_sys_x86_waitpid()")
    d3656344fea0 ("io_uring: add lookup table for various opcode needs")
    dfe64506c01e ("x86/syscalls: Don't pointlessly reload the system call number")
    e145242ea0df ("syscalls/core, syscalls/x86: Clean up syscall stub naming convention")
    ebeb8c82ffaf ("syscalls/x86: Use 'struct pt_regs' based syscall calling for IA32_EMULATION and x32")
    fa697140f9a2 ("syscalls/x86: Use 'struct pt_regs' based syscall calling convention for 64-bit syscalls")

v4.4.222: Failed to apply! Possible dependencies:
    0463b6c58e55 ("io_uring: use labeled array init in io_op_defs")
    05c17cedf85b ("x86: Wire up restartable sequence system call")
    1e423bff959e ("x86/entry/64: Migrate the 64-bit syscall slow path to C")
    2b188cc1bb85 ("Add io_uring IO interface")
    302f5b260c32 ("x86/entry/64: Always run ptregs-using syscalls on the slow path")
    3e65654e3db6 ("x86/syscalls: Move compat syscall entry handling into syscalltbl.sh")
    46eabf06c04a ("x86/entry/64: Call all native slow-path syscalls with full pt-regs")
    5ac9efa3c50d ("syscalls/core, syscalls/x86: Clean up compat syscall stub naming convention")
    7a074e96dee6 ("aio: implement io_pgetevents")
    95d97adb2bb8 ("x86/signal: Cleanup get_nr_restart_syscall()")
    97245d00585d ("x86/entry: Get rid of pt_regs_to_thread_info()")
    9a56a2323dbb ("io_uring: use fget/fput_many() for file references")
    abfb9498ee13 ("x86/entry: Rename is_{ia32,x32}_task() to in_{ia32,x32}_syscall()")
    c87a85177e7a ("x86/entry: Get rid of two-phase syscall entry work")
    cfcbadb49dab ("x86/syscalls: Add syscall entry qualifiers")
    d3656344fea0 ("io_uring: add lookup table for various opcode needs")
    dfe64506c01e ("x86/syscalls: Don't pointlessly reload the system call number")
    e145242ea0df ("syscalls/core, syscalls/x86: Clean up syscall stub naming convention")
    ebeb8c82ffaf ("syscalls/x86: Use 'struct pt_regs' based syscall calling for IA32_EMULATION and x32")
    fa697140f9a2 ("syscalls/x86: Use 'struct pt_regs' based syscall calling convention for 64-bit syscalls")
    fba324744bfd ("x86/syscalls: Refactor syscalltbl.sh")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
