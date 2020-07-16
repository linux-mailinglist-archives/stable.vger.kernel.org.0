Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB2D2218DB
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 02:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgGPA1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 20:27:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727866AbgGPA1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 20:27:40 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 760B42071B;
        Thu, 16 Jul 2020 00:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594859259;
        bh=Eh7RVuoAa8kyQTnMllH7xwP+NP/2xXU4MIOO3tOULac=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=W96QVxm75PaI3sRWdm/Y6nx7QruvXrMQYXQgYSytSzO8IBebJQb6v1FdLB/qJovaC
         MfYv8YZxdJpcHVcixX0vBbxAQvdadV1md6MbfH3lnI2aVaAx1f1Nd0ENKgyNeLJM6x
         Ig7HXn/y9JtItbhIStz00SfCRbjNFiPwLt0iXucY=
Date:   Thu, 16 Jul 2020 00:27:38 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     catalin.marinas@arm.com, Will Deacon <will@kernel.org>
Cc:     <stable@vger.kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>
Cc:     Luis Machado <luis.machado@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 1/7] arm64: ptrace: Consistently use pseudo-singlestep exceptions
In-Reply-To: <20200710130702.30658-2-will@kernel.org>
References: <20200710130702.30658-2-will@kernel.org>
Message-Id: <20200716002739.760B42071B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.8, v5.4.51, v4.19.132, v4.14.188, v4.9.230, v4.4.230.

v5.7.8: Build OK!
v5.4.51: Build OK!
v4.19.132: Build OK!
v4.14.188: Failed to apply! Possible dependencies:
    0013aceb30748 ("xtensa: clean up fixups in assembly code")
    1af1e8a39dc0f ("xtensa: move fixmap and kmap just above the KSEG")
    2a61f4747eeaa ("stack-protector: test compiler capability in Kconfig and drop AUTO mode")
    2b8383927525d ("Makefile: move stack-protector compiler breakage test earlier")
    2bc2f688fdf88 ("Makefile: move stack-protector availability out of Kconfig")
    409d5db49867c ("arm64: rseq: Implement backend rseq calls and select HAVE_RSEQ")
    40d1a07b333ef ("xtensa: enable stack protector")
    44c6dc940b190 ("Makefile: introduce CONFIG_CC_STACKPROTECTOR_AUTO")
    5cf97ebd8b40e ("xtensa: clean up functions in assembly code")
    8d66772e869e7 ("arm64: Mask all exceptions during kernel_exit")
    9800b9dc13cdf ("arm: Add restartable sequences support")
    a92d4d1454ab8 ("arm64: entry.S: move SError handling into a C function for future expansion")
    c2edb35ae342f ("xtensa: extract init_kio")
    c633544a61541 ("xtensa: add support for KASAN")
    d148eac0e70f0 ("Kbuild: rename HAVE_CC_STACKPROTECTOR config variable")
    f37099b6992a0 ("arm64: convert syscall trace logic to C")
    f4431396be5b2 ("xtensa: consolidate kernel stack size related definitions")

v4.9.230: Failed to apply! Possible dependencies:
    096683724cb2e ("arm64: unwind: avoid percpu indirection for irq stack")
    12964443e8d19 ("arm64: add on_accessible_stack()")
    17c2895860092 ("arm64: Abstract syscallno manipulation")
    34be98f4944f9 ("arm64: kernel: remove {THREAD,IRQ_STACK}_START_SP")
    35d0e6fb4d219 ("arm64: syscallno is secretly an int, make it official")
    8018ba4edfd3a ("arm64: move SEGMENT_ALIGN to <asm/memory.h>")
    872d8327ce898 ("arm64: add VMAP_STACK overflow detection")
    9842ceae9fa8d ("arm64: Add uprobe support")
    a92d4d1454ab8 ("arm64: entry.S: move SError handling into a C function for future expansion")
    a9ea0017ebe88 ("arm64: factor out current_stack_pointer")
    c02433dd6de32 ("arm64: split thread_info from task stack")
    c7365330753c5 ("arm64: unwind: disregard frame.sp when validating frame pointer")
    cf7de27ab3517 ("arm64/syscalls: Check address limit on user-mode return")
    dbc9344a68e50 ("arm64: clean up THREAD_* definitions")
    f37099b6992a0 ("arm64: convert syscall trace logic to C")
    f60ad4edcf072 ("arm64: clean up irq stack definitions")

v4.4.230: Failed to apply! Possible dependencies:
    0a28714c53fd4 ("arm64: Use PoU cache instr for I/D coherency")
    0a8ea52c3eb15 ("arm64: Add HAVE_REGS_AND_STACK_ACCESS_API feature")
    17c2895860092 ("arm64: Abstract syscallno manipulation")
    2dd0e8d2d2a15 ("arm64: Kprobes with single stepping support")
    35d0e6fb4d219 ("arm64: syscallno is secretly an int, make it official")
    39a67d49ba353 ("arm64: kprobes instruction simulation support")
    421dd6fa6709e ("arm64: factor work_pending state machine to C")
    57f4959bad0a1 ("arm64: kernel: Add support for User Access Override")
    872d8327ce898 ("arm64: add VMAP_STACK overflow detection")
    9842ceae9fa8d ("arm64: Add uprobe support")
    a92d4d1454ab8 ("arm64: entry.S: move SError handling into a C function for future expansion")
    b11e5759bfac0 ("arm64: factor out entry stack manipulation")
    cf7de27ab3517 ("arm64/syscalls: Check address limit on user-mode return")
    d5370f7548754 ("arm64: prefetch: add alternative pattern for CPUs without a prefetcher")
    d59bee8872311 ("arm64: Add more test functions to insn.c")
    e04a28d45ff34 ("arm64: debug: re-enable irqs before sending breakpoint SIGTRAP")
    f37099b6992a0 ("arm64: convert syscall trace logic to C")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
