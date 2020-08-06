Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781AC23D506
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 03:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgHFBYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 21:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgHFBYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 21:24:03 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B8762068F;
        Thu,  6 Aug 2020 01:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596677042;
        bh=wmFVgku3CG7Eozqyv6ssLwmG6Kq6g10GeXI05FIvbI0=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:
         In-Reply-To:References:From;
        b=zB2NZwSp4eWymf1m1F3s9D6IGlZLKjZ9TwR1Jc57Q/5ChP94QuI/Jb7tQ+9sf6W4B
         SWMwbXnxxnGcs4ydSft7ZtIQUhYabN3L6mwLmQx6b5mLgb9TNViUmTakSPPHQU+7H9
         5Q3oSI9KD/NHzgrRubcbD1YK8P/GuxwvQPAo9kyc=
Date:   Thu, 06 Aug 2020 01:24:01 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Dan Williams <dan.j.williams@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com, vishal.l.verma@intel.com
Cc:     x86@kernel.org, stable@vger.kernel.org
Cc:     x86@kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     Ingo Molnar <mingo@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>
Cc:     Vivek Goyal <vgoyal@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Andy Lutomirski <luto@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Peter Zijlstra <peterz@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v8 2/2] x86/copy_mc: Introduce copy_mc_generic()
In-Reply-To: <159630256804.3143511.8894023468833792004.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159630256804.3143511.8894023468833792004.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-Id: <20200806012402.1B8762068F@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 92b0729c34ca ("x86/mm, x86/mce: Add memcpy_mcsafe()").

The bot has tested the following trees: v5.7.11, v5.4.54, v4.19.135, v4.14.190, v4.9.231.

v5.7.11: Failed to apply! Possible dependencies:
    0d00449c7a28 ("x86: Replace ist_enter() with nmi_enter()")
    5567d11c21a1 ("x86/mce: Send #MC singal from task work")
    7e75f7fdad4b ("x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()")
    b052df3da821 ("x86/entry: Get rid of ist_begin/end_non_atomic()")

v5.4.54: Failed to apply! Possible dependencies:
    0d00449c7a28 ("x86: Replace ist_enter() with nmi_enter()")
    2d806d072358 ("x86/mce: Pass MCE message to mce_panic() on failed kernel recovery")
    4b842e4e25b1 ("x86: get rid of small constant size cases in raw_copy_{to,from}_user()")
    5567d11c21a1 ("x86/mce: Send #MC singal from task work")
    55ba18d6ed37 ("x86/mce: Disable tracing and kprobes on do_machine_check()")
    7e75f7fdad4b ("x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()")
    b052df3da821 ("x86/entry: Get rid of ist_begin/end_non_atomic()")

v4.19.135: Failed to apply! Possible dependencies:
    0261a508c9fc ("powerpc/mm: dump segment registers on book3s/32")
    093d7ca22920 ("powerpc/mm: drop unused page flags")
    461cef2a676e ("powerpc/32: activate ARCH_HAS_PMEM_API and ARCH_HAS_UACCESS_FLUSHCACHE")
    7c91efce1608 ("powerpc/mm: dump block address translation on book3s/32")
    7e75f7fdad4b ("x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()")
    97026b5a5ac2 ("powerpc/mm: Split dump_pagelinuxtables flag_array table")
    a0da4bc166f2 ("powerpc/mm: Allow platforms to redefine some helpers")
    aa9cd505e39d ("powerpc/mm: move some nohash pte helpers in nohash/[32:64]/pgtable.h")
    b2133bd7a553 ("powerpc/book3s/32: do not include pte-common.h")
    cbcbbf4afd6d ("powerpc/mm: Define platform default caches related flags")
    cbd34da7dc9a ("mm: move the powerpc hugepd code to mm/gup.c")
    d81e6f8b7c66 ("powerpc/mm: don't use _PAGE_EXEC in book3s/32")
    d82fd29c5a8c ("powerpc/mm: Distribute platform specific PAGE and PMD flags and definitions")
    daba790242df ("powerpc/mm: add pte helpers to query and change pte flags")
    e66c3209c7fd ("powerpc: Move page table dump files in a dedicated subdirectory")
    fb0b0a73b223 ("powerpc: Enable kcov")
    ff00552578ba ("powerpc/8xx: change name of a few page flags to avoid confusion")

v4.14.190: Failed to apply! Possible dependencies:
    10dac04c79b1 ("mips: fix an off-by-one in dma_capable")
    3010a5ea665a ("mm: introduce ARCH_HAS_PTE_SPECIAL")
    32ce3862af3c ("powerpc/lib: Implement PMEM API")
    461cef2a676e ("powerpc/32: activate ARCH_HAS_PMEM_API and ARCH_HAS_UACCESS_FLUSHCACHE")
    7e75f7fdad4b ("x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()")
    8c4cdce8b1ab ("mtd: nand: qcom: add command elements in BAM transaction")
    c7780ab56c09 ("ARM: 8738/1: Disable CONFIG_DEBUG_VIRTUAL for NOMMU")
    cbd34da7dc9a ("mm: move the powerpc hugepd code to mm/gup.c")
    cf1b09908a23 ("ARM: 8693/1: discard memblock arrays when possible")
    ea8c64ace866 ("dma-mapping: move swiotlb arch helpers to a new header")
    ee333554fed5 ("ARM: 8749/1: Kconfig: Add ARCH_HAS_FORTIFY_SOURCE")
    fb0b0a73b223 ("powerpc: Enable kcov")

v4.9.231: Failed to apply! Possible dependencies:
    3010a5ea665a ("mm: introduce ARCH_HAS_PTE_SPECIAL")
    7e75f7fdad4b ("x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()")
    8659a0e0efdd ("powerpc/64s: Disable STRICT_KERNEL_RWX")
    c763ea2650df ("x86/kconfig: Sort the 'config X86' selects alphabetically")
    c7780ab56c09 ("ARM: 8738/1: Disable CONFIG_DEBUG_VIRTUAL for NOMMU")
    cf1b09908a23 ("ARM: 8693/1: discard memblock arrays when possible")
    d2852a224050 ("arch: add ARCH_HAS_SET_MEMORY config")
    d94e068573f2 ("x86/kconfig: Move 64-bit only arch Kconfig selects to 'config X86_64'")
    e377cd8221eb ("ARM: 8640/1: Add support for CONFIG_DEBUG_VIRTUAL")
    ee333554fed5 ("ARM: 8749/1: Kconfig: Add ARCH_HAS_FORTIFY_SOURCE")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
