Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7C125EC44
	for <lists+stable@lfdr.de>; Sun,  6 Sep 2020 05:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgIFDQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 23:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728257AbgIFDQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Sep 2020 23:16:08 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06BBD20760;
        Sun,  6 Sep 2020 03:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599362167;
        bh=R2JmAvLL2xMjaqGqyoChd71ba6z4Q73x8XUK4i4hDMw=;
        h=Date:From:To:To:To:CC:Cc:Subject:In-Reply-To:References:From;
        b=UFo3szIJeMIVWx3o578UqnYveQKwMPVam9muT3xe3Vxz/j4UYAgTpgXsxWYg5muZv
         MzDG9GbeVvipjPWD8ZqIVIBDLaZmDnRMa7DAFWongxJp5QUxgXTQHQaB8ku1Xq7/cu
         HXAekEoaMR1vkDOA4SlCXAiM+F8ZNtOuYhs7XCvk=
Date:   Sun, 06 Sep 2020 03:16:06 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Ralph Campbell <rcampbell@nvidia.com>
To:     <linux-mm@kvack.org>, <nouveau@lists.freedesktop.org>
CC:     Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/thp: fix __split_huge_pmd_locked() for migration PMD
In-Reply-To: <20200903183140.19055-1-rcampbell@nvidia.com>
References: <20200903183140.19055-1-rcampbell@nvidia.com>
Message-Id: <20200906031607.06BBD20760@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 84c3fc4e9c56 ("mm: thp: check pmd migration entry in common path").

The bot has tested the following trees: v5.8.6, v5.4.62, v4.19.143, v4.14.196.

v5.8.6: Build OK!
v5.4.62: Failed to apply! Possible dependencies:
    0d1c20722ab3 ("mm: memcontrol: switch to native NR_FILE_PAGES and NR_SHMEM counters")
    3fba69a56e16 ("mm: memcontrol: drop @compound parameter from memcg charging API")
    468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
    72981e0e7b60 ("userfaultfd: wp: add UFFDIO_COPY_MODE_WP")
    83d116c53058 ("mm: fix double page fault on arm64 if PTE_AF is cleared")
    85b9f46e8ea4 ("mm, thp: track fallbacks due to failed memcg charges separately")
    92855270ff08 ("mm/memcontrol.c: cleanup some useless code")
    be5d0a74c62d ("mm: memcontrol: switch to native NR_ANON_MAPPED counter")
    c23a0c99793f ("mm/migrate: clean up some minor coding style")
    dcdf11ee1441 ("mm, shmem: add vmstat for hugepage fallback")
    f4129ea3591a ("mm: fix NUMA node file count error in replace_page_cache()")
    ffe945e633b5 ("khugepaged: do not stop collapse if less than half PTEs are referenced")

v4.19.143: Failed to apply! Possible dependencies:
    0ac261042084 ("x86/irq/64: Init hardirq_stack_ptr during CPU hotplug")
    0d1c20722ab3 ("mm: memcontrol: switch to native NR_FILE_PAGES and NR_SHMEM counters")
    117ed4548541 ("x86/irq/64: Remove stack overflow debug code")
    231c4846b106 ("x86/irq/32: Make irq stack a character array")
    30842211506e ("x86/exceptions: Remove unused stack defines on 32bit")
    39656e83dab9 ("mm: lift the x86_32 PAE version of gup_get_pte to common code")
    468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
    4f44b8f0b33b ("x86/irq/64: Remove a hardcoded irq_stack_union access")
    66c7ceb47f62 ("x86/irq/32: Handle irq stack allocation failure proper")
    758a2e312228 ("x86/irq/64: Rename irq_stack_ptr to hardirq_stack_ptr")
    7ac870747988 ("x86/vdso: Switch to generic vDSO implementation")
    99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
    a754fe2b76d1 ("x86/irq/32: Rename hard/softirq_stack to hard/softirq_stack_ptr")
    aa641c287b2f ("x86/irq/32: Define IRQ_STACK_SIZE")
    be5d0a74c62d ("mm: memcontrol: switch to native NR_ANON_MAPPED counter")
    df835e7083be ("x86/irq/64: Sanitize the top/bottom confusion")
    e6401c130931 ("x86/irq/64: Split the IRQ stack into its own pages")

v4.14.196: Failed to apply! Possible dependencies:
    050e9baa9dc9 ("Kbuild: rename CC_STACKPROTECTOR[_STRONG] config variables")
    0d1c20722ab3 ("mm: memcontrol: switch to native NR_FILE_PAGES and NR_SHMEM counters")
    117ed4548541 ("x86/irq/64: Remove stack overflow debug code")
    152e93af3cfe ("mm, thp: Do not make pmd/pud dirty without a reason")
    2a61f4747eea ("stack-protector: test compiler capability in Kconfig and drop AUTO mode")
    2b8383927525 ("Makefile: move stack-protector compiler breakage test earlier")
    2bc2f688fdf8 ("Makefile: move stack-protector availability out of Kconfig")
    39656e83dab9 ("mm: lift the x86_32 PAE version of gup_get_pte to common code")
    44c6dc940b19 ("Makefile: introduce CONFIG_CC_STACKPROTECTOR_AUTO")
    4645b9fe84bf ("mm/mmu_notifier: avoid call to invalidate_range() in range_end()")
    468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
    59c66c5f8c4f ("mm: factor out page cache page freeing into a separate function")
    5ecc4d852c03 ("mm: factor out checks and accounting from __delete_from_page_cache()")
    76253fbc8fbf ("mm: move accounting updates before page_cache_tree_delete()")
    7ac870747988 ("x86/vdso: Switch to generic vDSO implementation")
    8373b7d9d174 ("Documentation: kconfig: add recommended way to describe compiler support")
    99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
    be5d0a74c62d ("mm: memcontrol: switch to native NR_ANON_MAPPED counter")
    e6401c130931 ("x86/irq/64: Split the IRQ stack into its own pages")
    fadae2953072 ("thp: use mm_file_counter to determine update which rss counter")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
