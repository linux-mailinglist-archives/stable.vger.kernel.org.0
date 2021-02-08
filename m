Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36B631300D
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 12:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbhBHLF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 06:05:26 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:38457 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232738AbhBHLCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 06:02:37 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 92B2A5CC;
        Mon,  8 Feb 2021 06:01:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 06:01:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/A7EAl
        M0+yNc6622vtBd+MAN40GNaBxvDyBcdJj8IyY=; b=JCUBLzQv+5ldYm5eETXDEN
        /UBIBpBLlYIxuoxpNIv+79pCWD2LYfySOiVvm+L9EYZJAeQhZn1Jsil0UJeOZvNZ
        BYdkE7kyKLMYxG1miW5z3mp7NAkwApJDJQblDMqDtZDXSGrfqnZj3Bsrsplr0eGO
        rRko9q0vKnnU0PQqmbZiXk5kg/N8uylqAbMnS+Ljeb3gZNxoyWUyLKcrFrTTFYu2
        k3wcd6DrFkuTtfTl22d2xF7SJfoLDsZ0NWT6vn0vm0EYVPJvQtCgzp0zoc/+1wV9
        YDGjVSd11ULRKKxUqLluCgDnbKDCit0A3P1bLumyFxa1oL41bKB3PWQzCiexJIwA
        ==
X-ME-Sender: <xms:9xkhYCXwUxyx53Q1ABRlDXlfGAHrkB7ADVS1RKhdGe301y1ckfV_SQ>
    <xme:9xkhYOmZkDkPIjyLf2SMjjJYikHN9t9dznMaBIw6mxJHnEbgz-oxb2jIUpVe0Npqs
    bCd_nxoPJW95g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddvudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:9xkhYGY2BVXqBMyHDK-AftXbe_l8XLQxfMUkusH35Vu0u1PwYiNSxQ>
    <xmx:9xkhYJU5A8FUHePBlUkFP5-9EhZDHYURjutX7HAI8d5Wq5wH5pmo8g>
    <xmx:9xkhYMkmu5udXujPnnGEBZ458WcIJdswzNIYZtMt60qIOefrnJLD9Q>
    <xmx:-BkhYKaoYTUb0LcmJCHykJjAjqcaO3TCsYmlLanYIALs30DSclUrWTqlhTE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 07EFE1080067;
        Mon,  8 Feb 2021 06:01:10 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm: hugetlb: fix a race between freeing and dissolving the" failed to apply to 4.4-stable tree
To:     songmuchun@bytedance.com, akpm@linux-foundation.org,
        david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        osalvador@suse.de, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 12:01:08 +0100
Message-ID: <161278206820815@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

