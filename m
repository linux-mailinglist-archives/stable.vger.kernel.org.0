Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8A61C0C55
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 04:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgEACzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 22:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728167AbgEACzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 22:55:23 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C6D620857;
        Fri,  1 May 2020 02:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588301722;
        bh=QDHEj3aAQRzsF8uFWyck2IjqVa3cJGjZ0cFD5yxHJ/Y=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:
         In-Reply-To:References:From;
        b=sm97H22CGQDhO4CCp3zByAgZlxdpbjGUW4LlUKz13CswXWLqxQeulvURiBzHYQa6F
         3XfH9G5IN/WZ/phAJPjiRG00eYOX2rovdzRLdNnFtSyPXxWVI03+EYxRHqUeiinfIW
         /U6z8b3+8T4hpN/OjtAHDyUqpwKxJyBgndWKT+Dw=
Date:   Fri, 01 May 2020 02:55:21 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Dan Williams <dan.j.williams@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com
Cc:     x86@kernel.org, stable@vger.kernel.org
Cc:     x86@kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     Ingo Molnar <mingo@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>
Cc:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Peter Zijlstra <peterz@infradead.org>
Cc:     Tony Luck <tony.luck@intel.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86/copy_safe: Introduce copy_safe_fast()
In-Reply-To: <158823510897.2094061.8955960257425244970.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <158823510897.2094061.8955960257425244970.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-Id: <20200501025522.3C6D620857@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 92b0729c34ca ("x86/mm, x86/mce: Add memcpy_mcsafe()").

The bot has tested the following trees: v5.6.7, v5.4.35, v4.19.118, v4.14.177, v4.9.220.

v5.6.7: Failed to apply! Possible dependencies:
    d0ef4c360f7e ("iov_iter: Use generic instrumented.h")
    d28c6860fe9f ("copy_safe: Rename memcpy_mcsafe() to copy_safe()")

v5.4.35: Failed to apply! Possible dependencies:
    30a2441cae7b ("x86/asm: Make more symbols local")
    6dcc5627f6ae ("x86/asm: Change all ENTRY+ENDPROC to SYM_FUNC_*")
    74d8b90a8890 ("x86/asm/crypto: Annotate local functions")
    d28c6860fe9f ("copy_safe: Rename memcpy_mcsafe() to copy_safe()")
    e9b9d020c487 ("x86/asm: Annotate aliases")
    ef1e03152cb0 ("x86/asm: Make some functions local")

v4.19.118: Failed to apply! Possible dependencies:
    02c02bf12c5d ("xarray: Change definition of sibling entries")
    175967318c30 ("mm: introduce ARCH_HAS_PTE_DEVMAP")
    3159f943aafd ("xarray: Replace exceptional entries")
    3a08cd52c37c ("radix tree: Remove multiorder support")
    3d0186bb068e ("Update email address")
    461cef2a676e ("powerpc/32: activate ARCH_HAS_PMEM_API and ARCH_HAS_UACCESS_FLUSHCACHE")
    66ee620f06f9 ("idr: Permit any valid kernel pointer to be stored")
    74d609585d8b ("page cache: Add and replace pages using the XArray")
    d28c6860fe9f ("copy_safe: Rename memcpy_mcsafe() to copy_safe()")

v4.14.177: Failed to apply! Possible dependencies:
    07037db5d479 ("RISC-V: Paging and MMU")
    10dac04c79b1 ("mips: fix an off-by-one in dma_capable")
    175967318c30 ("mm: introduce ARCH_HAS_PTE_DEVMAP")
    3010a5ea665a ("mm: introduce ARCH_HAS_PTE_SPECIAL")
    31cb1bc0dc94 ("sched/core: Rework and clarify prepare_lock_switch()")
    32ce3862af3c ("powerpc/lib: Implement PMEM API")
    3ccfebedd8cf ("powerpc, membarrier: Skip memory barrier in switch_mm()")
    461cef2a676e ("powerpc/32: activate ARCH_HAS_PMEM_API and ARCH_HAS_UACCESS_FLUSHCACHE")
    75387b92635e ("arm64: handle 52-bit physical addresses in page table entries")
    76d2a0493a17 ("RISC-V: Init and Halt Code")
    7db91e57a0ac ("RISC-V: Task implementation")
    8c4cdce8b1ab ("mtd: nand: qcom: add command elements in BAM transaction")
    c7c527dd6e76 ("Revert "Documentation/features/vm: Remove arch support status file for 'pte_special'"")
    cc6c98485f8e ("RISC-V: Move to the new GENERIC_IRQ_MULTI_HANDLER handler")
    d1b069f5febc ("EXPERT Kconfig menu: fix broken EXPERT menu")
    d28c6860fe9f ("copy_safe: Rename memcpy_mcsafe() to copy_safe()")
    e6d588a8e3da ("arm64: head.S: handle 52-bit PAs in PTEs in early page table setup")
    ea8c64ace866 ("dma-mapping: move swiotlb arch helpers to a new header")
    ee333554fed5 ("ARM: 8749/1: Kconfig: Add ARCH_HAS_FORTIFY_SOURCE")
    f1e3a12b6543 ("membarrier/arm64: Provide core serializing command")
    fbe934d69eb7 ("RISC-V: Build Infrastructure")

v4.9.220: Failed to apply! Possible dependencies:
    15accb3cbbcd ("MAINTAINERS: extend mvebu SoC entry with pinctrl drivers")
    1cb0b57fec06 ("MAINTAINERS: add irqchip related drivers to Marvell EBU maintainers")
    21dd0ece34c2 ("ARM: dts: at91: add devicetree for the Axentia TSE-850")
    2e7d1098c00c ("MAINTAINERS: add entry for dma mapping helpers")
    384fe7a4d732 ("drivers: net: xgene-v2: Add DMA descriptor")
    3b3f9a75d931 ("drivers: net: xgene-v2: Add base driver")
    3f0d80b6d228 ("MAINTAINERS: Add bnxt_en maintainer info.")
    413dfbbfca54 ("MAINTAINERS: add entry for Aspeed I2C driver")
    420a3879d694 ("MAINTAINERS: change email address from atmel to microchip")
    461cef2a676e ("powerpc/32: activate ARCH_HAS_PMEM_API and ARCH_HAS_UACCESS_FLUSHCACHE")
    51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
    52c468fb37b6 ("MAINTAINERS: oxnas: Add new files definitions")
    70dbd9b258d5 ("MAINTAINERS: Add entry for APM X-Gene SoC Ethernet (v2) driver")
    7683e9e52925 ("Properly alphabetize MAINTAINERS file")
    81ccd0cab29b ("drivers: net: xgene-v2: Add mac configuration")
    aa43112445f0 ("ASoC: atmel: tse850: add ASoC driver for the Axentia TSE-850")
    b105bcdaaa0e ("drivers: net: xgene-v2: Add transmit and receive")
    c821d30148ca ("ASoC: tse850: document axentia,tse850-pcm5142 bindings")
    d28c6860fe9f ("copy_safe: Rename memcpy_mcsafe() to copy_safe()")
    e7c1572f6565 ("MAINTAINERS: sort F entries for Marvell EBU maintainers")
    ea8c64ace866 ("dma-mapping: move swiotlb arch helpers to a new header")
    fd33f3eca6bf ("MAINTAINERS: Add maintainers for the meson clock driver")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
