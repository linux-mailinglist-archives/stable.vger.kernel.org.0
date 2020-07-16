Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C122218E8
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 02:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgGPA1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 20:27:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgGPA1g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 20:27:36 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D2C12071B;
        Thu, 16 Jul 2020 00:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594859255;
        bh=x/uIkq3gdeTElq8c36eX80RkDlRLt4d873hFSTWT39I=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=eEp4n1+uDwCeW1mtguuEi1VhThFTY4pUeISgTzdQvIhVuB7Bjm0zcAQHul/60xQrd
         D47qUEJkd6Amn6wU7sRcsBAGtj+6tQdHs93Am9+S3r5aWCAu7Neu7pWKE5S7eVz2c2
         veJ6p9TV0vOe1AZovqYeCwqFoB6kPDDoG97KvMt8=
Date:   Thu, 16 Jul 2020 00:27:34 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     catalin.marinas@arm.com, Will Deacon <will@kernel.org>
Cc:     <stable@vger.kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>
Cc:     Keno Fischer <keno@juliacomputing.com>
Cc:     Luis Machado <luis.machado@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 3/7] arm64: compat: Ensure upper 32 bits of x0 are zero on syscall return
In-Reply-To: <20200710130702.30658-4-will@kernel.org>
References: <20200710130702.30658-4-will@kernel.org>
Message-Id: <20200716002735.4D2C12071B@mail.kernel.org>
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
    4141c857fd09d ("arm64: convert raw syscall invocation to C")
    44c6dc940b190 ("Makefile: introduce CONFIG_CC_STACKPROTECTOR_AUTO")
    5cf97ebd8b40e ("xtensa: clean up functions in assembly code")
    8d66772e869e7 ("arm64: Mask all exceptions during kernel_exit")
    9800b9dc13cdf ("arm: Add restartable sequences support")
    c2edb35ae342f ("xtensa: extract init_kio")
    c633544a61541 ("xtensa: add support for KASAN")
    d148eac0e70f0 ("Kbuild: rename HAVE_CC_STACKPROTECTOR config variable")
    f4431396be5b2 ("xtensa: consolidate kernel stack size related definitions")

v4.9.230: Failed to apply! Possible dependencies:
    12597988319c8 ("MIPS: Sort MIPS Kconfig Alphabetically.")
    2a61f4747eeaa ("stack-protector: test compiler capability in Kconfig and drop AUTO mode")
    2b8383927525d ("Makefile: move stack-protector compiler breakage test earlier")
    2bc2f688fdf88 ("Makefile: move stack-protector availability out of Kconfig")
    313dd1b629219 ("gcc-plugins: Add the randstruct plugin")
    39c13c204bb11 ("arm: eBPF JIT compiler")
    409d5db49867c ("arm64: rseq: Implement backend rseq calls and select HAVE_RSEQ")
    4141c857fd09d ("arm64: convert raw syscall invocation to C")
    44c6dc940b190 ("Makefile: introduce CONFIG_CC_STACKPROTECTOR_AUTO")
    74d86a70636a0 ("arm: use set_memory.h header")
    8d66772e869e7 ("arm64: Mask all exceptions during kernel_exit")
    9800b9dc13cdf ("arm: Add restartable sequences support")
    c02433dd6de32 ("arm64: split thread_info from task stack")
    c61f13eaa1ee1 ("gcc-plugins: Add structleak for more stack initialization")
    c763ea2650dfa ("x86/kconfig: Sort the 'config X86' selects alphabetically")
    d148eac0e70f0 ("Kbuild: rename HAVE_CC_STACKPROTECTOR config variable")
    f381bf6d82f03 ("MIPS: Add support for eBPF JIT.")

v4.4.230: Failed to apply! Possible dependencies:
    218cfe4ed8885 ("perf/x86: Move perf_event_amd_ibs.c ....... => x86/events/amd/ibs.c")
    25a77b55e74c4 ("xtensa/perf: Convert the hotplug notifier to state machine callbacks")
    2a803c4db615d ("arm64: head.S: use memset to clear BSS")
    2bf31a4a05f5b ("arm64: avoid dynamic relocations in early boot code")
    3600c2fdc09a4 ("arm64: Add macros to read/write system registers")
    39b0332a21583 ("perf/x86: Move perf_event_amd.c ........... => x86/events/amd/core.c")
    4141c857fd09d ("arm64: convert raw syscall invocation to C")
    499c81507f599 ("arm64/debug: Remove superfluous SMP function call")
    49de0493e5f67 ("x86/perf/intel/cstate: Make cstate hotplug handling actually work")
    4b6e2571bf000 ("x86/perf/intel/rapl: Make the Intel RAPL PMU driver modular")
    5b26547dd7faa ("perf/x86: Move perf_event_amd_iommu.[ch] .. => x86/events/amd/iommu.[ch]")
    609116d202a8c ("arm64: add function to install the idmap")
    6cdf9c7ca687e ("arm64: Store struct thread_info in sp_el0")
    77c34ef1c3194 ("perf/x86/intel/cstate: Convert Intel CSTATE to hotplug state machine")
    8d66772e869e7 ("arm64: Mask all exceptions during kernel_exit")
    9e8e865bbe294 ("arm64: unify idmap removal")
    a563f7598198b ("arm64: Reuse TCR field definitions for EL1 and EL2")
    adf7589997927 ("arm64: simplify sysreg manipulation")
    ae7e27fe6834d ("arm64: hw_breakpoint: Allow EL2 breakpoints if running in HYP")
    bb9052744f4b7 ("arm64: Handle early CPU boot failures")
    c02433dd6de32 ("arm64: split thread_info from task stack")
    c4bc34d20273d ("arm64: Add a helper for parking CPUs in a loop")
    c7afba320e91c ("x86/perf/intel/cstate: Modularize driver")
    e5b61bafe7047 ("arm: Convert VFP hotplug notifiers to state machine")
    e633c65a1d585 ("x86/perf/intel/uncore: Make the Intel uncore PMU driver modular")
    e937dd5782688 ("arm64: debug: convert OS lock CPU hotplug notifier to new infrastructure")
    ee02a15919cf8 ("arm64: Introduce cpu_die_early")
    fa9cbf320e996 ("perf/x86: Move perf_event.c ............... => x86/events/core.c")
    fce6361fe9b0c ("arm64: Move cpu_die_early to smp.c")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
