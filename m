Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365CA6765C0
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 11:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjAUKe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Jan 2023 05:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjAUKe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Jan 2023 05:34:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03064ABC2
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 02:34:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DDFDB82B92
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 10:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA9BC433EF;
        Sat, 21 Jan 2023 10:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674297294;
        bh=NGgb5cjxLA8I0rQs6XdJFsvhQEe99Kadz8MM7D71TfE=;
        h=Subject:To:Cc:From:Date:From;
        b=sPXAjjuw9chwkEOW+4UILO9oXL/CRh2+Khr+z9U1VYaRLGaAZwvuh4Ew8PV6DTn0e
         aTBTwUprYG29kbPR46NWqZ8tIVjS4iHd9LAluPFG1aWa2L4KB4lKUE1RvokuzitvjL
         o1NTQlUgfrjfNxui98pLva937+G6rCa5l63Mdecs=
Subject: FAILED: patch "[PATCH] mm/khugepaged: fix collapse_pte_mapped_thp() to allow" failed to apply to 5.4-stable tree
To:     hughd@google.com, akpm@linux-foundation.org, david@redhat.com,
        jannh@google.com, shy828301@gmail.com, songliubraving@fb.com,
        stable@vger.kernel.org, zokeefe@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 21 Jan 2023 11:29:40 +0100
Message-ID: <1674296980139216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ab0c3f1251b4 ("mm/khugepaged: fix collapse_pte_mapped_thp() to allow anon_vma")
8d3c106e19e8 ("mm/khugepaged: take the right locks for page table retraction")
34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
58ac9a8993a1 ("mm/khugepaged: attempt to map file/shmem-backed pte-mapped THPs by pmds")
780a4b6fb865 ("mm/khugepaged: check compound_order() in collapse_pte_mapped_thp()")
b26e27015ec9 ("mm: thp: convert to use common struct mm_slot")
685405020b9f ("mm/khugepaged: stop using vma linked list")
7d2c4385c341 ("mm/khugepaged: rename prefix of shared collapse functions")
7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
507228044236 ("mm/khugepaged: record SCAN_PMD_MAPPED when scan_pmd() finds hugepage")
a7f4e6e4c47c ("mm/thp: add flag to enforce sysfs THP in hugepage_vma_check()")
50ad2f24b3b4 ("mm/khugepaged: propagate enum scan_result codes back to callers")
9710a78ab2ae ("mm/khugepaged: dedup and simplify hugepage alloc and charging")
34d6b470ab9c ("mm/khugepaged: add struct collapse_control")
c6a7f445a272 ("mm: khugepaged: don't carry huge page to the next loop for !CONFIG_NUMA")
1064026bab9f ("mm: khugepaged: reorg some khugepaged helpers")
7da4e2cb8b1f ("mm: thp: kill __transhuge_page_enabled()")
9fec51689ff6 ("mm: thp: kill transparent_hugepage_active()")
f707fa493784 ("mm: khugepaged: better comments for anon vma check in hugepage_vma_revalidate")
4fa6893faeaa ("mm: thp: consolidate vma size check to transhuge_vma_suitable")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ab0c3f1251b4670978fde0bd54161795a139b060 Mon Sep 17 00:00:00 2001
From: Hugh Dickins <hughd@google.com>
Date: Thu, 22 Dec 2022 12:41:50 -0800
Subject: [PATCH] mm/khugepaged: fix collapse_pte_mapped_thp() to allow
 anon_vma

uprobe_write_opcode() uses collapse_pte_mapped_thp() to restore huge pmd,
when removing a breakpoint from hugepage text: vma->anon_vma is always set
in that case, so undo the prohibition.  And MADV_COLLAPSE ought to be able
to collapse some page tables in a vma which happens to have anon_vma set
from CoWing elsewhere.

Is anon_vma lock required?  Almost not: if any page other than expected
subpage of the non-anon huge page is found in the page table, collapse is
aborted without making any change.  However, it is possible that an anon
page was CoWed from this extent in another mm or vma, in which case a
concurrent lookup might look here: so keep it away while clearing pmd (but
perhaps we shall go back to using pmd_lock() there in future).

Note that collapse_pte_mapped_thp() is exceptional in freeing a page table
without having cleared its ptes: I'm uneasy about that, and had thought
pte_clear()ing appropriate; but exclusive i_mmap lock does fix the
problem, and we would have to move the mmu_notification if clearing those
ptes.

What this fixes is not a dangerous instability.  But I suggest Cc stable
because uprobes "healing" has regressed in that way, so this should follow
8d3c106e19e8 into those stable releases where it was backported (and may
want adjustment there - I'll supply backports as needed).

Link: https://lkml.kernel.org/r/b740c9fb-edba-92ba-59fb-7a5592e5dfc@google.com
Fixes: 8d3c106e19e8 ("mm/khugepaged: take the right locks for page table retraction")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: <stable@vger.kernel.org>    [5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5cb401aa2b9d..9a0135b39b19 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1460,14 +1460,6 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	if (!hugepage_vma_check(vma, vma->vm_flags, false, false, false))
 		return SCAN_VMA_CHECK;
 
-	/*
-	 * Symmetry with retract_page_tables(): Exclude MAP_PRIVATE mappings
-	 * that got written to. Without this, we'd have to also lock the
-	 * anon_vma if one exists.
-	 */
-	if (vma->anon_vma)
-		return SCAN_VMA_CHECK;
-
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
 	if (userfaultfd_wp(vma))
 		return SCAN_PTE_UFFD_WP;
@@ -1567,8 +1559,14 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	}
 
 	/* step 4: remove pte entries */
+	/* we make no change to anon, but protect concurrent anon page lookup */
+	if (vma->anon_vma)
+		anon_vma_lock_write(vma->anon_vma);
+
 	collapse_and_free_pmd(mm, vma, haddr, pmd);
 
+	if (vma->anon_vma)
+		anon_vma_unlock_write(vma->anon_vma);
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
 
 maybe_install_pmd:

