Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE8B253095
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbgHZNyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730499AbgHZNyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:54:11 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C08622BEA;
        Wed, 26 Aug 2020 13:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598450050;
        bh=rF4YSV6AU33u/6I6Rn4ZWS4KG0uVcHBRxE8z07nY/Bs=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=jSphhp/G0qTYj1YoacBsfmGn4fC8XSgD1ntE+ArEEAa3/R7CYCponyc6Lahzdcxry
         P3p4DgZscfPXxQKij7qxrV+V/Tj2q6E55ogMMQe7faAgJCqBf1kyT34w5AJG4/+uzT
         Jyq2+EMpQ798PKOVIZMQF8Rkvf8ETeFsZOEPae4Q=
Date:   Wed, 26 Aug 2020 13:54:09 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au
Cc:     Nathan Lynch <nathanl@linux.ibm.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] powerpc/drmem: Make lmb_size 64 bit
In-Reply-To: <20200806162329.276534-1-aneesh.kumar@linux.ibm.com>
References: <20200806162329.276534-1-aneesh.kumar@linux.ibm.com>
Message-Id: <20200826135410.2C08622BEA@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.2, v5.7.16, v5.4.59, v4.19.140, v4.14.193, v4.9.232, v4.4.232.

v5.8.2: Build OK!
v5.7.16: Build OK!
v5.4.59: Build OK!
v4.19.140: Build OK!
v4.14.193: Failed to apply! Possible dependencies:
    22508f3dc985 ("powerpc/numa: Look up device node in of_get_usable_memory()")
    2c77721552e5 ("powerpc: Move of_drconf_cell struct to asm/drmem.h")
    35f80debaef0 ("powerpc/numa: Look up device node in of_get_assoc_arrays()")
    514a9cb3316a ("powerpc/numa: Update numa code use walk_drmem_lmbs")
    6195a5001f1d ("powerpc/pseries: Update memory hotplug code to use drmem LMB array")
    6c6ea53725b3 ("powerpc/mm: Separate ibm, dynamic-memory data from DT format")
    b6eca183e23e ("powerpc/kernel: Enables memory hot-remove after reboot on pseries guests")
    b88fc309d6ad ("powerpc/numa: Look up associativity array in of_drconf_to_nid_single")

v4.9.232: Failed to apply! Possible dependencies:
    3a2df3798d4d ("powerpc/mm: Make switch_mm_irqs_off() out of line")
    43ed84a891b7 ("powerpc/mm: Move pgdir setting into a helper")
    5a61ef74f269 ("powerpc/64s: Support new device tree binding for discovering CPU features")
    5d451a87e5eb ("powerpc/64: Retrieve number of L1 cache sets from device-tree")
    6c6ea53725b3 ("powerpc/mm: Separate ibm, dynamic-memory data from DT format")
    70cd4c10b290 ("KVM: PPC: Book3S HV: Fix software walk of guest process page tables")
    9b081e10805c ("powerpc: port 64 bits pgtable_cache to 32 bits")
    a25bd72badfa ("powerpc/mm/radix: Workaround prefetch issue with KVM")
    bd067f83b084 ("powerpc/64: Fix naming of cache block vs. cache line")
    dbcbfee0c81c ("powerpc/64: More definitions for POWER9")
    e2827fe5c156 ("powerpc/64: Clean up ppc64_caches using a struct per cache")
    f4329f2ecb14 ("powerpc/64s: Reduce exception alignment")

v4.4.232: Failed to apply! Possible dependencies:
    11a6f6abd74a ("powerpc/mm: Move radix/hash common data structures to book3s64 headers")
    26b6a3d9bb48 ("powerpc/mm: move pte headers to book3s directory")
    3808a88985b4 ("powerpc: Move FW feature probing out of pseries probe()")
    3dfcb315d81e ("powerpc/mm: make a separate copy for book3s")
    5a61ef74f269 ("powerpc/64s: Support new device tree binding for discovering CPU features")
    5d31a96e6c01 ("powerpc/livepatch: Add livepatch stack to struct thread_info")
    6574ba950bbe ("powerpc/kernel: Convert cpu_has_feature() to returning bool")
    6c6ea53725b3 ("powerpc/mm: Separate ibm, dynamic-memory data from DT format")
    a141cca3892b ("powerpc/mm: Add early_[cpu|mmu]_has_feature()")
    a8ed87c92adf ("powerpc/mm/radix: Add MMU_FTR_RADIX")
    b92a226e5284 ("powerpc: Move cpu_has_feature() to a separate file")
    da6a97bf12d5 ("powerpc: Move epapr_paravirt_early_init() to early_init_devtree()")
    f63e6d898760 ("powerpc/livepatch: Add livepatch header")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
