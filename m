Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AB723D50E
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 03:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgHFBYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 21:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbgHFBYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 21:24:09 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACED322D01;
        Thu,  6 Aug 2020 01:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596677048;
        bh=JBZitiTG2/rVmnBNwkdqcqn5+Wm+Pw0pyNRLup2GZSM=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:
         Subject:In-Reply-To:References:From;
        b=M346OR4OW+3Fuk3gHQWd/behnHUmcWNnnUuCUYP5VL1yTgnyDGZKFjEYyRbCyxFXq
         yBpXIOo2+S8U/JbfMfOMiV6NB1jbcjoowisqqKcekYtUVTjpKzstmrBirF5sULUgpG
         aMBn5GkUyFx6NJfJfZJd/aXzboX9miQmk69SBixE=
Date:   Thu, 06 Aug 2020 01:24:08 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Dan Williams <dan.j.williams@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com, vishal.l.verma@intel.com
Cc:     x86@kernel.org, stable@vger.kernel.org
Cc:     x86@kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     Ingo Molnar <mingo@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>
Cc:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Paul Mackerras <paulus@samba.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Peter Zijlstra <peterz@infradead.org>
Cc:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v8 1/2] x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()
In-Reply-To: <159630256183.3143511.1575942237452838622.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159630256183.3143511.1575942237452838622.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-Id: <20200806012408.ACED322D01@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.11, v5.4.54, v4.19.135, v4.14.190, v4.9.231, v4.4.231.

v5.7.11: Failed to apply! Possible dependencies:
    0d00449c7a28 ("x86: Replace ist_enter() with nmi_enter()")
    5567d11c21a1 ("x86/mce: Send #MC singal from task work")
    b052df3da821 ("x86/entry: Get rid of ist_begin/end_non_atomic()")

v5.4.54: Failed to apply! Possible dependencies:
    0d00449c7a28 ("x86: Replace ist_enter() with nmi_enter()")
    2d806d072358 ("x86/mce: Pass MCE message to mce_panic() on failed kernel recovery")
    4b842e4e25b1 ("x86: get rid of small constant size cases in raw_copy_{to,from}_user()")
    5567d11c21a1 ("x86/mce: Send #MC singal from task work")
    55ba18d6ed37 ("x86/mce: Disable tracing and kprobes on do_machine_check()")
    b052df3da821 ("x86/entry: Get rid of ist_begin/end_non_atomic()")

v4.19.135: Failed to apply! Possible dependencies:
    0261a508c9fc ("powerpc/mm: dump segment registers on book3s/32")
    093d7ca22920 ("powerpc/mm: drop unused page flags")
    461cef2a676e ("powerpc/32: activate ARCH_HAS_PMEM_API and ARCH_HAS_UACCESS_FLUSHCACHE")
    7c91efce1608 ("powerpc/mm: dump block address translation on book3s/32")
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
    8c4cdce8b1ab ("mtd: nand: qcom: add command elements in BAM transaction")
    c7780ab56c09 ("ARM: 8738/1: Disable CONFIG_DEBUG_VIRTUAL for NOMMU")
    cbd34da7dc9a ("mm: move the powerpc hugepd code to mm/gup.c")
    cf1b09908a23 ("ARM: 8693/1: discard memblock arrays when possible")
    ea8c64ace866 ("dma-mapping: move swiotlb arch helpers to a new header")
    ee333554fed5 ("ARM: 8749/1: Kconfig: Add ARCH_HAS_FORTIFY_SOURCE")
    fb0b0a73b223 ("powerpc: Enable kcov")

v4.9.231: Failed to apply! Possible dependencies:
    3010a5ea665a ("mm: introduce ARCH_HAS_PTE_SPECIAL")
    8659a0e0efdd ("powerpc/64s: Disable STRICT_KERNEL_RWX")
    c763ea2650df ("x86/kconfig: Sort the 'config X86' selects alphabetically")
    c7780ab56c09 ("ARM: 8738/1: Disable CONFIG_DEBUG_VIRTUAL for NOMMU")
    cf1b09908a23 ("ARM: 8693/1: discard memblock arrays when possible")
    d2852a224050 ("arch: add ARCH_HAS_SET_MEMORY config")
    d94e068573f2 ("x86/kconfig: Move 64-bit only arch Kconfig selects to 'config X86_64'")
    e377cd8221eb ("ARM: 8640/1: Add support for CONFIG_DEBUG_VIRTUAL")
    ee333554fed5 ("ARM: 8749/1: Kconfig: Add ARCH_HAS_FORTIFY_SOURCE")

v4.4.231: Failed to apply! Possible dependencies:
    1d8f51d41fc7 ("arm/arm64: arch_timer: Use archdata to indicate vdso suitability")
    21266be9ed54 ("arch: consolidate CONFIG_STRICT_DEVM in lib/Kconfig.debug")
    27f3d2a3b59f ("ARC: [build] Support gz, lzma compressed uImage")
    3010a5ea665a ("mm: introduce ARCH_HAS_PTE_SPECIAL")
    32ed9a0e0ddc ("ARC: support generic per-device coherent dma mem")
    8659a0e0efdd ("powerpc/64s: Disable STRICT_KERNEL_RWX")
    c1678ffcdea2 ("ARC: Add PCI support")
    c7780ab56c09 ("ARM: 8738/1: Disable CONFIG_DEBUG_VIRTUAL for NOMMU")
    ee333554fed5 ("ARM: 8749/1: Kconfig: Add ARCH_HAS_FORTIFY_SOURCE")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
