Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F21421B79C
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 16:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgGJOCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 10:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728382AbgGJOCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 10:02:49 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 861902082E;
        Fri, 10 Jul 2020 14:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594389768;
        bh=VHy3Qnh/ip7TCmR8hEM3laox1nHcsBpekT7Ga5Hggac=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=vBXS0h/SxL5Pu12TXzkYyUe8PIpoHM3wkCbZncTaeAXAfucPwKpE3XBMnLW9Oe/uF
         uk6KTrRFGjn7WOd8PbB7r9d5KLfGdi2E36bRmHO/dmEQNSF245wYVspnbWf1Ujb8zz
         qgwB894bACZhdQnePYyAZgMNjHnmmOnjIxPYzD40=
Date:   Fri, 10 Jul 2020 14:02:47 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Andrew Donnellan <ajd@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     leobras.c@gmail.com, nathanl@linux.ibm.com
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/rtas: Restrict RTAS requests from userspace
In-Reply-To: <20200702161932.18176-1-ajd@linux.ibm.com>
References: <20200702161932.18176-1-ajd@linux.ibm.com>
Message-Id: <20200710140248.861902082E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.7, v5.4.50, v4.19.131, v4.14.187, v4.9.229, v4.4.229.

v5.7.7: Build OK!
v5.4.50: Failed to apply! Possible dependencies:
    1a8916ee3ac29 ("powerpc: Detect the secure boot mode of the system")
    4238fad366a66 ("powerpc/ima: Add support to initialize ima policy rules")
    9155e2341aa8b ("powerpc/powernv: Add OPAL API interface to access secure variable")
    bd5d9c743d38f ("powerpc: expose secure variables to userspace via sysfs")

v4.19.131: Failed to apply! Possible dependencies:
    1a8916ee3ac29 ("powerpc: Detect the secure boot mode of the system")
    4238fad366a66 ("powerpc/ima: Add support to initialize ima policy rules")
    6f5f193e84d3d ("powerpc/opal: add MPIPL interface definitions")
    75d9fc7fd94eb ("powerpc/powernv: move OPAL call wrapper tracing and interrupt handling to C")
    8139046a5a347 ("powerpc/powernv: Make possible for user to force a full ipl cec reboot")
    88ec6b93c8e7d ("powerpc/xive: add OPAL extensions for the XIVE native exploitation support")
    9155e2341aa8b ("powerpc/powernv: Add OPAL API interface to access secure variable")
    bd5d9c743d38f ("powerpc: expose secure variables to userspace via sysfs")
    fb0b0a73b223f ("powerpc: Enable kcov")

v4.14.187: Failed to apply! Possible dependencies:
    04baaf28f40c6 ("powerpc/powernv: Add support to enable sensor groups")
    10dac04c79b18 ("mips: fix an off-by-one in dma_capable")
    1a8916ee3ac29 ("powerpc: Detect the secure boot mode of the system")
    32ce3862af3c4 ("powerpc/lib: Implement PMEM API")
    5cdcb01e0af5a ("powernv: opal-sensor: Add support to read 64bit sensor values")
    656ecc16e8fc2 ("crypto/nx: Initialize 842 high and normal RxFIFO control registers")
    6f5f193e84d3d ("powerpc/opal: add MPIPL interface definitions")
    74d656d219b98 ("powerpc/powernv: Add opal calls for opencapi")
    77adbd2207e85 ("powerpc/powernv: Add OPAL_BUSY to opal_error_code()")
    88ec6b93c8e7d ("powerpc/xive: add OPAL extensions for the XIVE native exploitation support")
    8c4cdce8b1ab0 ("mtd: nand: qcom: add command elements in BAM transaction")
    9155e2341aa8b ("powerpc/powernv: Add OPAL API interface to access secure variable")
    92e3da3cf193f ("powerpc: initial pkey plumbing")
    bd5d9c743d38f ("powerpc: expose secure variables to userspace via sysfs")
    d6a90bb83b508 ("powerpc/powernv: Enable tunneled operations")
    e36d0a2ed5019 ("powerpc/powernv: Implement NMI IPI with OPAL_SIGNAL_SYSTEM_RESET")
    ea8c64ace8664 ("dma-mapping: move swiotlb arch helpers to a new header")
    fb0b0a73b223f ("powerpc: Enable kcov")

v4.9.229: Failed to apply! Possible dependencies:
    1515ab9321562 ("powerpc/mm: Dump hash table")
    1a8916ee3ac29 ("powerpc: Detect the secure boot mode of the system")
    40565b5aedd6d ("sched/cputime, powerpc, s390: Make scaled cputime arch specific")
    4ad8622dc5489 ("powerpc/8xx: Implement hw_breakpoint")
    51c9c08439935 ("powerpc/kprobes: Implement Optprobes")
    5b9ff02785986 ("powerpc: Build-time sort the exception table")
    6533b7c16ee57 ("powerpc: Initial stack protector (-fstack-protector) support")
    65c059bcaa731 ("powerpc: Enable support for GCC plugins")
    8eb07b187000d ("powerpc/mm: Dump linux pagetables")
    92e3da3cf193f ("powerpc: initial pkey plumbing")
    981ee2d444408 ("sched/cputime, powerpc: Remove cputime_to_scaled()")
    a7d2475af7aed ("powerpc: Sort the selects under CONFIG_PPC")
    bd5d9c743d38f ("powerpc: expose secure variables to userspace via sysfs")
    d6c569b99558b ("powerpc/64: Move HAVE_CONTEXT_TRACKING from pseries to common Kconfig")
    dd5ac03e09554 ("powerpc/mm: Fix page table dump build on non-Book3S")
    ea8c64ace8664 ("dma-mapping: move swiotlb arch helpers to a new header")
    ebfa50df435ee ("powerpc: Add helper to check if offset is within relative branch range")
    fa769d3f58e6b ("powerpc/32: Enable HW_BREAKPOINT on BOOK3S")
    fb0b0a73b223f ("powerpc: Enable kcov")

v4.4.229: Failed to apply! Possible dependencies:
    019132ff3daf3 ("x86/mm/pkeys: Fill in pkey field in siginfo")
    01c8f1c44b83a ("mm, dax, gpu: convert vm_insert_mixed to pfn_t")
    0e749e54244ee ("dax: increase granularity of dax_clear_blocks() operations")
    1874f6895c92d ("x86/mm/gup: Simplify get_user_pages() PTE bit handling")
    1a8916ee3ac29 ("powerpc: Detect the secure boot mode of the system")
    33a709b25a760 ("mm/gup, x86/mm/pkeys: Check VMAs and PTEs for protection keys")
    34c0fd540e79f ("mm, dax, pmem: introduce pfn_t")
    3565fce3a6597 ("mm, x86: get_user_pages() for dax mappings")
    52db400fcd502 ("pmem, dax: clean up clear_pmem()")
    7b2d0dbac4890 ("x86/mm/pkeys: Pass VMA down in to fault signal generation code")
    8f62c883222c9 ("x86/mm/pkeys: Add arch-specific VMA protection bits")
    92e3da3cf193f ("powerpc: initial pkey plumbing")
    b2e0d1625e193 ("dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()")
    bd5d9c743d38f ("powerpc: expose secure variables to userspace via sysfs")
    f25748e3c34eb ("mm, dax: convert vmf_insert_pfn_pmd() to pfn_t")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
