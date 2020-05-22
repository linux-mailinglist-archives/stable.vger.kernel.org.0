Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6F61DDBEE
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 02:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbgEVAMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 20:12:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730686AbgEVAMn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 20:12:43 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C6902078B;
        Fri, 22 May 2020 00:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590106362;
        bh=Qa8lR6mixZMgTYbshzCUQFzpe1kWscmYCwvAvpk3SnI=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:
         Cc:Cc:Subject:In-Reply-To:References:From;
        b=Z9ZH9Sg20OqBK5JvDZb5mLtCSXDylmZjm8f2IzLz3KQDUBiQ5+MdxW5/HjDKMDQ6T
         xCrKcJDUsqY0CG+aK5q+/lAcTHTQ0FiB23qt0TpkNxEx2gAI7ajK/4Fe+9MFuOYpIF
         7QGFXkEBEVkZTTg8EdWAbFtmKvZC7DIRyQPUQDR8=
Date:   Fri, 22 May 2020 00:12:41 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Dan Williams <dan.j.williams@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com
Cc:     x86@kernel.org, stable@vger.kernel.org
Cc:     x86@kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     Ingo Molnar <mingo@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>
Cc:     Tony Luck <tony.luck@intel.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Paul Mackerras <paulus@samba.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Peter Zijlstra <peterz@infradead.org>
Cc:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()
In-Reply-To: <158992635697.403910.6957168747147028694.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <158992635697.403910.6957168747147028694.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-Id: <20200522001242.2C6902078B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.13, v5.4.41, v4.19.123, v4.14.180, v4.9.223, v4.4.223.

v5.6.13: Failed to apply! Possible dependencies:
    d0ef4c360f7e ("iov_iter: Use generic instrumented.h")

v5.4.41: Failed to apply! Possible dependencies:
    30a2441cae7b ("x86/asm: Make more symbols local")
    6dcc5627f6ae ("x86/asm: Change all ENTRY+ENDPROC to SYM_FUNC_*")
    74d8b90a8890 ("x86/asm/crypto: Annotate local functions")
    e9b9d020c487 ("x86/asm: Annotate aliases")
    ef1e03152cb0 ("x86/asm: Make some functions local")

v4.19.123: Failed to apply! Possible dependencies:
    02c02bf12c5d ("xarray: Change definition of sibling entries")
    175967318c30 ("mm: introduce ARCH_HAS_PTE_DEVMAP")
    3159f943aafd ("xarray: Replace exceptional entries")
    3a08cd52c37c ("radix tree: Remove multiorder support")
    3d0186bb068e ("Update email address")
    461cef2a676e ("powerpc/32: activate ARCH_HAS_PMEM_API and ARCH_HAS_UACCESS_FLUSHCACHE")
    66ee620f06f9 ("idr: Permit any valid kernel pointer to be stored")
    74d609585d8b ("page cache: Add and replace pages using the XArray")

v4.14.180: Failed to apply! Possible dependencies:
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
    e6d588a8e3da ("arm64: head.S: handle 52-bit PAs in PTEs in early page table setup")
    ea8c64ace866 ("dma-mapping: move swiotlb arch helpers to a new header")
    ee333554fed5 ("ARM: 8749/1: Kconfig: Add ARCH_HAS_FORTIFY_SOURCE")
    f1e3a12b6543 ("membarrier/arm64: Provide core serializing command")
    fbe934d69eb7 ("RISC-V: Build Infrastructure")

v4.9.223: Failed to apply! Possible dependencies:
    15accb3cbbcd ("MAINTAINERS: extend mvebu SoC entry with pinctrl drivers")
    1cb0b57fec06 ("MAINTAINERS: add irqchip related drivers to Marvell EBU maintainers")
    20bb5505e96f ("MAINTAINERS: cpufreq: add bmips-cpufreq.c")
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
    e7c1572f6565 ("MAINTAINERS: sort F entries for Marvell EBU maintainers")
    ea8c64ace866 ("dma-mapping: move swiotlb arch helpers to a new header")
    fd33f3eca6bf ("MAINTAINERS: Add maintainers for the meson clock driver")

v4.4.223: Failed to apply! Possible dependencies:
    1f664ab7d9d4 ("MAINTAINERS: update entry for Marvell ARM platform maintainers")
    27eb6622ab67 ("config: add android config fragments")
    384fe7a4d732 ("drivers: net: xgene-v2: Add DMA descriptor")
    3b3f9a75d931 ("drivers: net: xgene-v2: Add base driver")
    413dfbbfca54 ("MAINTAINERS: add entry for Aspeed I2C driver")
    461cef2a676e ("powerpc/32: activate ARCH_HAS_PMEM_API and ARCH_HAS_UACCESS_FLUSHCACHE")
    51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
    5255034d1701 ("ARM: mach-artpec: add entry to MAINTAINERS")
    54176cc68038 ("maintainers: update rmk's email address(es)")
    5b7551db8688 ("ARM: dts: keystone: Add minimum support for K2G evm")
    5edafc29829b ("ARM: dts: k2*: Rename the k2* files to keystone-k2* files")
    6683d91cde25 ("MAINTAINERS: ARM/Amlogic: add co-maintainer, misc. updates")
    70dbd9b258d5 ("MAINTAINERS: Add entry for APM X-Gene SoC Ethernet (v2) driver")
    7683e9e52925 ("Properly alphabetize MAINTAINERS file")
    79318452cb36 ("MAINTAINERS: Extend info, add wiki and ml for meson arch")
    81ccd0cab29b ("drivers: net: xgene-v2: Add mac configuration")
    8bb0bce92ec9 ("MAINTAINERS: add maintainer and reviewers for the etnaviv DRM driver")
    8c2ed9bcfbeb ("arm: Add Aspeed machine")
    8cb555b603f3 ("MAINTAINERS: add Chanho Min as ARM/LG1K maintainer")
    b105bcdaaa0e ("drivers: net: xgene-v2: Add transmit and receive")
    dcc3068a757e ("MAINTAINERS: Extend dts entry for ARM64 mvebu files")
    e68d7c143a62 ("MAINTAINERS: Add missing platform maintainers for dts files")
    e7c1572f6565 ("MAINTAINERS: sort F entries for Marvell EBU maintainers")
    ea8c64ace866 ("dma-mapping: move swiotlb arch helpers to a new header")
    fd33f3eca6bf ("MAINTAINERS: Add maintainers for the meson clock driver")
    fd3a628e3f2a ("MAINTAINERS: Add entry for APM X-Gene SoC PMU driver")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
