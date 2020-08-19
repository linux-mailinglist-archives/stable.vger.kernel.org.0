Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF0524AA49
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgHSX5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgHSX4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:56:50 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5009320FC3;
        Wed, 19 Aug 2020 23:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881409;
        bh=5WEvpbNUegRa3M08IE92CZsJKXR0z7FkPwFG1repnIk=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=EvckwcYN1ee/8rcSHlzccNLjc8rXU6B9Y49cH3yziGhL85oZiXjxsoY+oh/L1NjN8
         NhRnvG/p/u6JkPppn21VtuFd7mmo/5i7poe1JUi9PHc00TwiGB+djDcXCOEg8rA3oK
         cHFdFabi/aQS0JdwVvCnZc71G5yQhAKXvO+u+HkE=
Date:   Wed, 19 Aug 2020 23:56:48 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Kees Cook <keescook@chromium.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v5 13/36] vmlinux.lds.h: add PGO and AutoFDO input sections
In-Reply-To: <20200731230820.1742553-14-keescook@chromium.org>
References: <20200731230820.1742553-14-keescook@chromium.org>
Message-Id: <20200819235649.5009320FC3@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58, v4.19.139, v4.14.193, v4.9.232, v4.4.232.

v5.8.1: Build OK!
v5.7.15: Failed to apply! Possible dependencies:
    655389666643 ("vmlinux.lds.h: Create section for protection against instrumentation")

v5.4.58: Failed to apply! Possible dependencies:
    441110a547f8 ("vmlinux.lds.h: Provide EMIT_PT_NOTE to indicate export of .notes")
    6434efbd9aef ("s390: Move RO_DATA into "text" PT_LOAD Program Header")
    655389666643 ("vmlinux.lds.h: Create section for protection against instrumentation")
    6fc4000656a1 ("powerpc: Remove PT_NOTE workaround")
    7a42d41d9dc2 ("x86/vmlinux: Restore "text" Program Header with dummy section")
    eaf937075c9a ("vmlinux.lds.h: Move NOTES into RO_DATA")
    fbe6a8e618a2 ("vmlinux.lds.h: Move Program Header restoration into NOTES macro")

v4.19.139: Failed to apply! Possible dependencies:
    15426ca43d88 ("s390: rescue initrd as early as possible")
    369f91c37451 ("s390/decompressor: rework uncompressed image info collection")
    3bad719b4954 ("powerpc/prom_init: Make of_workarounds static")
    441110a547f8 ("vmlinux.lds.h: Provide EMIT_PT_NOTE to indicate export of .notes")
    4e62d4588500 ("s390: clean up stacks setup")
    5f69e38885c3 ("powerpc/prom_init: Move __prombss to it's own section and store it in .bss")
    655389666643 ("vmlinux.lds.h: Create section for protection against instrumentation")
    67361cf80712 ("powerpc/ftrace: Handle large kernel configs")
    8f75582a2fb6 ("s390: remove decompressor's head.S")
    d1b52a4388ff ("s390: introduce .boot.data section")
    e63334e556d9 ("powerpc/prom_init: Replace __initdata with __prombss when applicable")
    eaf937075c9a ("vmlinux.lds.h: Move NOTES into RO_DATA")
    fbe6a8e618a2 ("vmlinux.lds.h: Move Program Header restoration into NOTES macro")

v4.14.193: Failed to apply! Possible dependencies:
    01417c6cc7dc ("powerpc/64: Change soft_enabled from flag to bitmask")
    0b63acf4a0eb ("powerpc/64: Move set_soft_enabled() and rename")
    1696d0fb7fcd ("powerpc/64: Set DSCR default initially from SPR")
    4e26bc4a4ed6 ("powerpc/64: Rename soft_enabled to irq_soft_mask")
    5080332c2c89 ("powerpc/64s: Add workaround for P9 vector CI load issue")
    5633e85b2c31 ("powerpc64: Add .opd based function descriptor dereference")
    655389666643 ("vmlinux.lds.h: Create section for protection against instrumentation")
    67361cf80712 ("powerpc/ftrace: Handle large kernel configs")
    9f83e00f4cc1 ("powerpc/64: Improve inline asm in arch_local_irq_disable")
    ae30cc05bed2 ("powerpc64/ftrace: Implement support for ftrace_regs_caller()")
    b5c1bd62c054 ("powerpc/64: Fix arch_local_irq_disable() prototype")
    c2e480ba8227 ("powerpc/64: Add #defines for paca->soft_enabled flags")
    ea678ac627e0 ("powerpc64/ftrace: Add a field in paca to disable ftrace in unsafe code paths")
    ff967900c9d4 ("powerpc/64: Fix latency tracing for lazy irq replay")

v4.9.232: Failed to apply! Possible dependencies:
    096ff2ddba83 ("powerpc/ftrace/64: Split further based on -mprofile-kernel")
    2f59be5b970b ("powerpc/ftrace: Restore LR from pt_regs")
    454656155110 ("powerpc/asm: Use OFFSET macro in asm-offsets.c")
    5633e85b2c31 ("powerpc64: Add .opd based function descriptor dereference")
    655389666643 ("vmlinux.lds.h: Create section for protection against instrumentation")
    67361cf80712 ("powerpc/ftrace: Handle large kernel configs")
    700e64377c2c ("powerpc/ftrace: Move stack setup and teardown code into ftrace_graph_caller()")
    7853f9c029ac ("powerpc: Split ftrace bits into a separate file")
    99ad503287da ("powerpc: Add a prototype for mcount() so it can be versioned")
    a97a65d53d9f ("KVM: PPC: Book3S: 64-bit CONFIG_RELOCATABLE support for interrupts")
    ae30cc05bed2 ("powerpc64/ftrace: Implement support for ftrace_regs_caller()")
    b3a7864c6feb ("powerpc/ftrace: Add prototype for prepare_ftrace_return()")
    c02e0349d7e9 ("powerpc/ftrace: Fix the comments for ftrace_modify_code")
    c4f3b52ce7b1 ("powerpc/64s: Disallow system reset vs system reset reentrancy")
    d3918e7fd4a2 ("KVM: PPC: Book3S: Change interrupt call to reduce scratch space use on HV")
    ea678ac627e0 ("powerpc64/ftrace: Add a field in paca to disable ftrace in unsafe code paths")

v4.4.232: Failed to apply! Possible dependencies:
    0f4c4af06eec ("kbuild: -ffunction-sections fix for archs with conflicting sections")
    2aedcd098a94 ("kbuild: suppress annoying "... is up to date." message")
    9895c03d4811 ("kbuild: record needed exported symbols for modules")
    a5967db9af51 ("kbuild: allow architectures to use thin archives instead of ld -r")
    b67067f1176d ("kbuild: allow archs to select link dead code/data elimination")
    b9ab5ebb14ec ("objtool: Add CONFIG_STACK_VALIDATION option")
    c1a95fda2a40 ("kbuild: add fine grained build dependencies for exported symbols")
    cb87481ee89d ("kbuild: linker script do not match C names unless LD_DEAD_CODE_DATA_ELIMINATION is configured")
    cf4f21938e13 ("kbuild: Allow to specify composite modules with modname-m")
    e4aca4595005 ("kbuild: de-duplicate fixdep usage")
    f235541699bc ("export.h: allow for per-symbol configurable EXPORT_SYMBOL()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
