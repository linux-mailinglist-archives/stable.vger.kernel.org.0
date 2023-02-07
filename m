Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FD768D25B
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 10:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbjBGJQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 04:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjBGJQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 04:16:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B84A18B15
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 01:16:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8204B8184D
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E8DC433EF;
        Tue,  7 Feb 2023 09:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675761368;
        bh=2D9ipv8hnteIpKKvHbFciJZb76anMPTak7KVRTDJcNI=;
        h=Subject:To:Cc:From:Date:From;
        b=a+FafCj1MqSlAYLLU7nFSK7MoIDxpRXVbO1m5/fz+PG+3zgBT9FdPmZTOmEm/FAeg
         1CbSnQdSP83rcmn5SzZaJNE1sqw3M9IAfgq+SQSrfC4Fpa9K8qeSJ6bb7JRMpC8Rj2
         7KlgVdk4n0/gIx7fWZk4lCMWZm/HC7VcLN9bik0k=
Subject: FAILED: patch "[PATCH] migrate: hugetlb: check for hugetlb shared PMD in node" failed to apply to 5.10-stable tree
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        david@redhat.com, jthoughton@google.com, mhocko@suse.com,
        naoya.horiguchi@linux.dev, peterx@redhat.com, shy828301@gmail.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        vishal.moola@gmail.com, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 10:16:03 +0100
Message-ID: <167576136311391@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

73bdf65ea748 ("migrate: hugetlb: check for hugetlb shared PMD in node migration")
7ce82f4c3f3e ("mm/migration: return errno when isolate_huge_page failed")
1b7f7e58decc ("mm/gup: Convert check_and_migrate_movable_pages() to use a folio")
f9f38f78c5d5 ("mm: refactor check_and_migrate_movable_pages")
5ac95884a784 ("mm/migrate: enable returning precise migrate_pages() success count")
c5b5a3dd2c1f ("mm: thp: refactor NUMA fault handling")
5db4f15c4fd7 ("mm: memory: add orig_pmd to struct vm_fault")
8f34f1eac382 ("mm/userfaultfd: fix uffd-wp special cases for fork()")
25182f05ffed ("mm,hwpoison: fix race with hugetlb page allocation")
f68749ec342b ("mm/gup: longterm pin migration cleanup")
d1e153fea2a8 ("mm/gup: migrate pinned pages out of movable zone")
1a08ae36cf8b ("mm cma: rename PF_MEMALLOC_NOCMA to PF_MEMALLOC_PIN")
6e7f34ebb8d2 ("mm/gup: check for isolation errors")
f0f4463837da ("mm/gup: return an error on migration failure")
83c02c23d074 ("mm/gup: check every subpage of a compound page during isolation")
c991ffef7bce ("mm/gup: don't pin migrated cma pages in movable zone")
7ee820ee7238 ("Revert "mm: migrate: skip shared exec THP for NUMA balancing"")
ae37c7ff79f1 ("mm: make alloc_contig_range handle in-use hugetlb pages")
369fa227c219 ("mm: make alloc_contig_range handle free hugetlb pages")
c2ad7a1ffeaf ("mm,compaction: let isolate_migratepages_{range,block} return error codes")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 73bdf65ea74857d7fb2ec3067a3cec0e261b1462 Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Thu, 26 Jan 2023 14:27:21 -0800
Subject: [PATCH] migrate: hugetlb: check for hugetlb shared PMD in node
 migration

migrate_pages/mempolicy semantics state that CAP_SYS_NICE is required to
move pages shared with another process to a different node.  page_mapcount
> 1 is being used to determine if a hugetlb page is shared.  However, a
hugetlb page will have a mapcount of 1 if mapped by multiple processes via
a shared PMD.  As a result, hugetlb pages shared by multiple processes and
mapped with a shared PMD can be moved by a process without CAP_SYS_NICE.

To fix, check for a shared PMD if mapcount is 1.  If a shared PMD is found
consider the page shared.

Link: https://lkml.kernel.org/r/20230126222721.222195-3-mike.kravetz@oracle.com
Fixes: e2d8cf405525 ("migrate: add hugepage migration code to migrate_pages()")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 02c8a712282f..f940395667c8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -600,7 +600,8 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
 
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
-	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1)) {
+	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1 &&
+	     !hugetlb_pmd_shared(pte))) {
 		if (isolate_hugetlb(page, qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*

