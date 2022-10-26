Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7698960E41B
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 17:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbiJZPHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 11:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbiJZPHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 11:07:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8FA10DE43
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 08:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F124BB822F6
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 15:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B438C433C1;
        Wed, 26 Oct 2022 15:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666796851;
        bh=l5PU7melUPcMBCaA155EedTJ/JmZqeERraujJhbYNmQ=;
        h=Subject:To:Cc:From:Date:From;
        b=pilLS8urFSuIqlZoIEBBzxBtyAzRoTborPqbwY9/Jqh+FAn2tREWTWDSjSOss6eRd
         8MD9nSSnnURB94gKwcQn3aJ2Nk38iiKtTo96MIK7oGhVcna7/kDJEatlGs6GhYT2kK
         j1Y/U65lBverTTIfggm6lZ09vhii1I0EVek6hIqY=
Subject: FAILED: patch "[PATCH] mm,hugetlb: take hugetlb_lock before decrementing" failed to apply to 4.19-stable tree
To:     riel@surriel.com, akpm@linux-foundation.org, gkmccready@meta.com,
        mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com,
        songmuchun@bytedance.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Oct 2022 17:07:24 +0200
Message-ID: <16667968441813@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

12df140f0bdf ("mm,hugetlb: take hugetlb_lock before decrementing h->resv_huge_pages")
db71ef79b59b ("hugetlb: make free_huge_page irq safe")
10c6ec49802b ("hugetlb: change free_pool_huge_page to remove_pool_huge_page")
1121828a0c21 ("hugetlb: call update_and_free_page without hugetlb_lock")
6eb4e88a6d27 ("hugetlb: create remove_hugetlb_page() to separate functionality")
2938396771c8 ("hugetlb: add per-hstate mutex to synchronize user adjustments")
5c8ecb131a65 ("mm/hugetlb_cgroup: remove unnecessary VM_BUG_ON_PAGE in hugetlb_cgroup_migrate()")
5af1ab1d24e0 ("mm/hugetlb: optimize the surplus state transfer code in move_hugetlb_state()")
6c0371490140 ("hugetlb: convert PageHugeFreed to HPageFreed flag")
9157c31186c3 ("hugetlb: convert PageHugeTemporary() to HPageTemporary flag")
8f251a3d5ce3 ("hugetlb: convert page_huge_active() HPageMigratable flag")
d6995da31122 ("hugetlb: use page.private for hugetlb specific page flags")
dbfee5aee7e5 ("hugetlb: fix update_and_free_page contig page struct assumption")
3f1b0162f6f6 ("mm/hugetlb: remove unnecessary VM_BUG_ON_PAGE on putback_active_hugepage()")
1d88433bb008 ("mm/hugetlb: fix use after free when subpool max_hpages accounting is not enabled")
0aa7f3544aaa ("mm/hugetlb: avoid unnecessary hugetlb_acct_memory() call")
ecbf4724e606 ("mm: hugetlb: remove VM_BUG_ON_PAGE from page_huge_active")
0eb2df2b5629 ("mm: hugetlb: fix a race between isolating and freeing page")
7ffddd499ba6 ("mm: hugetlb: fix a race between freeing and dissolving the page")
585fc0d2871c ("mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 12df140f0bdfae5dcfc81800970dd7f6f632e00c Mon Sep 17 00:00:00 2001
From: Rik van Riel <riel@surriel.com>
Date: Mon, 17 Oct 2022 20:25:05 -0400
Subject: [PATCH] mm,hugetlb: take hugetlb_lock before decrementing
 h->resv_huge_pages

The h->*_huge_pages counters are protected by the hugetlb_lock, but
alloc_huge_page has a corner case where it can decrement the counter
outside of the lock.

This could lead to a corrupted value of h->resv_huge_pages, which we have
observed on our systems.

Take the hugetlb_lock before decrementing h->resv_huge_pages to avoid a
potential race.

Link: https://lkml.kernel.org/r/20221017202505.0e6a4fcd@imladris.surriel.com
Fixes: a88c76954804 ("mm: hugetlb: fix hugepage memory leak caused by wrong reserve count")
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Glen McCready <gkmccready@meta.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b586cdd75930..dede0337c07c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2924,11 +2924,11 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
 		if (!page)
 			goto out_uncharge_cgroup;
+		spin_lock_irq(&hugetlb_lock);
 		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
 			SetHPageRestoreReserve(page);
 			h->resv_huge_pages--;
 		}
-		spin_lock_irq(&hugetlb_lock);
 		list_add(&page->lru, &h->hugepage_activelist);
 		set_page_refcounted(page);
 		/* Fall through */

