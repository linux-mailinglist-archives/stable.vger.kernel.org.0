Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B49F313015
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 12:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbhBHLFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 06:05:42 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:45525 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232781AbhBHLDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 06:03:20 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6E6EAA5D;
        Mon,  8 Feb 2021 06:01:20 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 06:01:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=GR9QLv
        uIxByDFRU/eL/OHYlkUqml5Fdr6br8viIQHW8=; b=GUchkr6pRqnfjRapqncTAb
        /JjBeeJX7yISdlALCBiS8I1TtNkHaHndHeFsz3e5lLtrcg4QL23Wso7LDHpy2yCy
        cQnZc7iLLqSyzLbOY/uQHJIvL9lzLrN7FinIaoIPkilv3YbmkAex0YPuSpa3j4h3
        AisIES1j4DZ71MoV4jqHiMjh+tPBjKvvfo57ZLRDYscWSS8BxhnofH/WhMjAwznb
        C85N/+h6Eqtv1tYNwKZmdzscImJNohBnHq3gwkKDDTFR3pbOrsVtRaqLdIA773yC
        1aNUEkitmFMQQw4/HF+FgxBbCk5Nhv0hUSxOqwhWeCBaU7mTBbZAA3jpZtflKzQQ
        ==
X-ME-Sender: <xms:_xkhYA9w_q6SC_b5As8TuzastLzPFauAAwr7y-lsYKyxsaUxDdG5yA>
    <xme:_xkhYItMzbKZtFHZu1fxukzk14aH9jjjRdedS0-MDwa9lUue3XWkJQxURkGRJ5GUs
    uannCEvbMpTWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddvudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:_xkhYGDRsqUNx0bRVv8elS0rzcnXyuMvMxqtBWqk4dwQegM5625L2w>
    <xmx:_xkhYAfSor7nsQUTk0UUM0qeFvdhjBK-KI-HMDb0GYNJ8eggpfpgtA>
    <xmx:_xkhYFN7vWA3VqHKuEORzb43DteVQlNuQYX1gSYiRzbFUTWxwj2lHQ>
    <xmx:ABohYBD3s30AwN-3OfH4xpz0Up69uXR0Af2kigkZkPqAwuDXhAPF8Cixf6I>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 999C024005A;
        Mon,  8 Feb 2021 06:01:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm: hugetlb: fix a race between freeing and dissolving the" failed to apply to 4.9-stable tree
To:     songmuchun@bytedance.com, akpm@linux-foundation.org,
        david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        osalvador@suse.de, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 12:01:09 +0100
Message-ID: <161278206919633@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7ffddd499ba6122b1a07828f023d1d67629aa017 Mon Sep 17 00:00:00 2001
From: Muchun Song <songmuchun@bytedance.com>
Date: Thu, 4 Feb 2021 18:32:06 -0800
Subject: [PATCH] mm: hugetlb: fix a race between freeing and dissolving the
 page

There is a race condition between __free_huge_page()
and dissolve_free_huge_page().

  CPU0:                         CPU1:

  // page_count(page) == 1
  put_page(page)
    __free_huge_page(page)
                                dissolve_free_huge_page(page)
                                  spin_lock(&hugetlb_lock)
                                  // PageHuge(page) && !page_count(page)
                                  update_and_free_page(page)
                                  // page is freed to the buddy
                                  spin_unlock(&hugetlb_lock)
      spin_lock(&hugetlb_lock)
      clear_page_huge_active(page)
      enqueue_huge_page(page)
      // It is wrong, the page is already freed
      spin_unlock(&hugetlb_lock)

The race window is between put_page() and dissolve_free_huge_page().

We should make sure that the page is already on the free list when it is
dissolved.

As a result __free_huge_page would corrupt page(s) already in the buddy
allocator.

Link: https://lkml.kernel.org/r/20210115124942.46403-4-songmuchun@bytedance.com
Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6f0e242d38ca..c6ee3c28a04e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -79,6 +79,21 @@ DEFINE_SPINLOCK(hugetlb_lock);
 static int num_fault_mutexes;
 struct mutex *hugetlb_fault_mutex_table ____cacheline_aligned_in_smp;
 
+static inline bool PageHugeFreed(struct page *head)
+{
+	return page_private(head + 4) == -1UL;
+}
+
+static inline void SetPageHugeFreed(struct page *head)
+{
+	set_page_private(head + 4, -1UL);
+}
+
+static inline void ClearPageHugeFreed(struct page *head)
+{
+	set_page_private(head + 4, 0);
+}
+
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
 
@@ -1028,6 +1043,7 @@ static void enqueue_huge_page(struct hstate *h, struct page *page)
 	list_move(&page->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
+	SetPageHugeFreed(page);
 }
 
 static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
@@ -1044,6 +1060,7 @@ static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
 
 		list_move(&page->lru, &h->hugepage_activelist);
 		set_page_refcounted(page);
+		ClearPageHugeFreed(page);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
 		return page;
@@ -1505,6 +1522,7 @@ static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 	spin_lock(&hugetlb_lock);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
+	ClearPageHugeFreed(page);
 	spin_unlock(&hugetlb_lock);
 }
 
@@ -1755,6 +1773,7 @@ int dissolve_free_huge_page(struct page *page)
 {
 	int rc = -EBUSY;
 
+retry:
 	/* Not to disrupt normal path by vainly holding hugetlb_lock */
 	if (!PageHuge(page))
 		return 0;
@@ -1771,6 +1790,26 @@ int dissolve_free_huge_page(struct page *page)
 		int nid = page_to_nid(head);
 		if (h->free_huge_pages - h->resv_huge_pages == 0)
 			goto out;
+
+		/*
+		 * We should make sure that the page is already on the free list
+		 * when it is dissolved.
+		 */
+		if (unlikely(!PageHugeFreed(head))) {
+			spin_unlock(&hugetlb_lock);
+			cond_resched();
+
+			/*
+			 * Theoretically, we should return -EBUSY when we
+			 * encounter this race. In fact, we have a chance
+			 * to successfully dissolve the page if we do a
+			 * retry. Because the race window is quite small.
+			 * If we seize this opportunity, it is an optimization
+			 * for increasing the success rate of dissolving page.
+			 */
+			goto retry;
+		}
+
 		/*
 		 * Move PageHWPoison flag from head page to the raw error page,
 		 * which makes any subpages rather than the error page reusable.

