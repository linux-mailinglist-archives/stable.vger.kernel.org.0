Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CED677654
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 09:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjAWIcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 03:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjAWIcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 03:32:09 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5771A96E
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 00:32:07 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id t7so8617351qvv.3
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 00:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tHsue/35xEq5MlFbfXCVOVIdXrqZytD2uaTeK+p02ns=;
        b=jvj8Zxsh1cCr9emwCigBouqqeZ06gLVa2xYVWiRpvJFHaHlSadzjLY1yeXgvKyw3HM
         psIDTx5BLlDvG9MJRqMk6ZaF3x4hI2nBED8WQ5pFANzN4/eQ8uaBa6tF8IJ672zEhfbQ
         WxaA4lVPJNcJeVWST+PZKDdZqOBt89+VdHOkl0OZzHJfmQEpNkkDDV2sl2zosJL8KX2Z
         q1AJpTHwEngdGYDld0zx01YkbcPIfzd70lOYr/67hOPXCmArT5t3YqrXD8JQWkg45gcj
         h+QYgRjYaCF8a2uuWiXJUwwhYS1DKioDLG/YR6IUMRTRDkq8wLBHTLFtPekUlSbqeLeW
         r03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tHsue/35xEq5MlFbfXCVOVIdXrqZytD2uaTeK+p02ns=;
        b=EakQMSKu2r0EMZBS8oJedgm4soUyXP4wPMirctyKJCJRnbNy9QhsQ8+qNlMF50faG5
         yIKQIlGOgitWaIUCCEskJS7//ZZE1KUXwGnkvmpeNLQR/k48MotQvoYwgO0jrk/xEkKZ
         IdmbdccRolxWrnLbdHzAcBAaQ8Prfz0oKojWNmQWZ6cQGEvr9oIIg8dS0krPiZ2DAfoV
         FYNdxAWq3xkzV3nPoqEHeaf3MuyP/m47LlhMPt4zR9CTagaROwcq1hR38V2WmFEu3GHH
         QaKPhMLJ1LCnhZIqDg4xIX9ZGOPI5GJU7OOf3st6ag3Tnb5dpE4PFLKiZfark9I5jgGb
         qcCA==
X-Gm-Message-State: AFqh2ko/5cAPyYwWQQ9yoKYj+b9EPjmcKwU/T9vLWewDmGb1884hdONx
        JIuzqp/wcsemWziG+xSOaJab/Q==
X-Google-Smtp-Source: AMrXdXvjJ6K6amNlUMN8TfJJTQmt+b9EaqR/LY3VECbCzJvKK1lL/9IB2rGeldFmAhNiDIrlxuvahw==
X-Received: by 2002:a0c:cb92:0:b0:531:cd71:c4d0 with SMTP id p18-20020a0ccb92000000b00531cd71c4d0mr38725769qvk.23.1674462726280;
        Mon, 23 Jan 2023 00:32:06 -0800 (PST)
Received: from [192.168.1.200] (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id q15-20020a05620a038f00b00704a2a40cf2sm5932173qkm.38.2023.01.23.00.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 00:32:05 -0800 (PST)
Date:   Mon, 23 Jan 2023 00:31:52 -0800 (PST)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.anvils
To:     gregkh@linuxfoundation.org
cc:     hughd@google.com, akpm@linux-foundation.org, david@redhat.com,
        jannh@google.com, shy828301@gmail.com, songliubraving@fb.com,
        stable@vger.kernel.org, zokeefe@google.com
Subject: Re: FAILED: patch "[PATCH] mm/khugepaged: fix collapse_pte_mapped_thp()
 to allow" failed to apply to 5.15-stable tree
In-Reply-To: <1674296977196124@kroah.com>
Message-ID: <c6665dff-d48a-7dac-c845-fe41cb67b31@google.com>
References: <1674296977196124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 21 Jan 2023, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Thanks Greg: the backport below is suitable for 5.15-stable and
5.10-stable and 5.4-stable.

Hugh

From ab0c3f1251b4670978fde0bd54161795a139b060 Mon Sep 17 00:00:00 2001
From: Hugh Dickins <hughd@google.com>
Date: Thu, 22 Dec 2022 12:41:50 -0800
Subject: [PATCH] mm/khugepaged: fix collapse_pte_mapped_thp() to allow anon_vma

commit ab0c3f1251b4670978fde0bd54161795a139b060 upstream.

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
---
 mm/khugepaged.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fd25d12e85b3..3afcb1466ec5 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1458,14 +1458,6 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE))
 		return;
 
-	/*
-	 * Symmetry with retract_page_tables(): Exclude MAP_PRIVATE mappings
-	 * that got written to. Without this, we'd have to also lock the
-	 * anon_vma if one exists.
-	 */
-	if (vma->anon_vma)
-		return;
-
 	hpage = find_lock_page(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
 	if (!hpage)
@@ -1537,6 +1529,10 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	}
 
 	/* step 4: collapse pmd */
+	/* we make no change to anon, but protect concurrent anon page lookup */
+	if (vma->anon_vma)
+		anon_vma_lock_write(vma->anon_vma);
+
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm, haddr,
 				haddr + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
@@ -1546,6 +1542,8 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	mmu_notifier_invalidate_range_end(&range);
 	pte_free(mm, pmd_pgtable(_pmd));
 
+	if (vma->anon_vma)
+		anon_vma_unlock_write(vma->anon_vma);
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
 
 drop_hpage:
-- 
2.39.0.246.g2a6d74b583-goog
