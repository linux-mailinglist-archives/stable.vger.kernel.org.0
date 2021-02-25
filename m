Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21091325783
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 21:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbhBYUXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 15:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhBYUXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 15:23:06 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81411C061574
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 12:22:25 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id r3so6492852wro.9
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 12:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=343zU7zgzW4aPTIm37/REsq7KUjUeHfRCYvFibL2PIc=;
        b=VZbzmJxELQHnfwQQhtpDFOiQ6pGFTp1fhYhVnIGV9oO6+OW2UrUQSJdbaP7XSSSRr+
         lxP9K4AbAhsfmzsndoV7U+wb/hFGAG9CmdRwECSGvB642kJxiSuR3y5gWHA3oL+T4t80
         SnL/J4Vm6RsTbDhr3mj9SNdD02kP3JuR+l54aiQSKX5Nc7Gp5ZFy8eCfgrFB/drYyBw0
         llppfoxiU6sKQ1KId2RxAy0MP/Irn9jZpYHGtLy5jFb5iaMHbONSZnWPcXQulEtCHvHU
         nnwyPGhV6Gv1k+JQ23x08+z2kqNAnQMDUO/fifQSj9gcEEw91FQIFvJgcsSjs2VB+NzU
         EYyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=343zU7zgzW4aPTIm37/REsq7KUjUeHfRCYvFibL2PIc=;
        b=ijA0ZfQWxLjFHxVWOr3TexLtojVzt6ZEq0v9V7LYLnrjgfC0aMkpaSndoLFkDnqpod
         vWTY0VBOU+u8NHB/KgbaiQzUR+wZEPHwbRwOV85aK2MKUEbXh0CPOeVHpJ3O86KKXh0g
         VdQga4/90ZZxEivY6OGGq0Ve4fGb8mPxr4ONBiLJt0cAq8GwMbgWITNZCYFoAvjwYpD7
         vRYShSEJOA/igIE1KWexFav2jchdcMm1NyZD3DBCiNCe5dF63z4IB4OdYKHydJbAJYvn
         prD0MEX/94CQD412+It8BVJ0qdpMtBVOAYlRJp3mlSBgQfvWZpyN+eSRxltKp7swxrC0
         9Jsw==
X-Gm-Message-State: AOAM530Fl8gnCATUcecsxfWmjWFs6H0j+Px3x/0Mn7Ey+gUtDWSqpV+q
        6mQiUw9YK0j0Gr/xEzbeR4s=
X-Google-Smtp-Source: ABdhPJw7sCPKKSynVz+0NeCkiIqy90SfpCRdpRJRGDf4NFlrm16UrD1sfuSIO/ZRQHqEBl6awTg4Og==
X-Received: by 2002:a05:6000:118c:: with SMTP id g12mr4449789wrx.353.1614284544229;
        Thu, 25 Feb 2021 12:22:24 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id v9sm10403355wrn.86.2021.02.25.12.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 12:22:23 -0800 (PST)
Date:   Thu, 25 Feb 2021 20:22:22 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     songmuchun@bytedance.com, akpm@linux-foundation.org,
        david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        osalvador@suse.de, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm: hugetlb: fix a race between freeing
 and dissolving the" failed to apply to 4.14-stable tree
Message-ID: <YDgG/n57mAWsUT+Z@debian>
References: <161278207013991@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MUjlgFyOwtqTwo/3"
Content-Disposition: inline
In-Reply-To: <161278207013991@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MUjlgFyOwtqTwo/3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Feb 08, 2021 at 12:01:10PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--MUjlgFyOwtqTwo/3
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-mm-hugetlb-fix-a-race-between-freeing-and-dissolving.patch"

From c4bff68da0c6312208254f1e7591ab587da260a4 Mon Sep 17 00:00:00 2001
From: Muchun Song <songmuchun@bytedance.com>
Date: Thu, 4 Feb 2021 18:32:06 -0800
Subject: [PATCH] mm: hugetlb: fix a race between freeing and dissolving the
 page

commit 7ffddd499ba6122b1a07828f023d1d67629aa017 upstream

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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 mm/hugetlb.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5f0d0f92adbf..b25a813e0ec2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -69,6 +69,21 @@ DEFINE_SPINLOCK(hugetlb_lock);
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
 
@@ -866,6 +881,7 @@ static void enqueue_huge_page(struct hstate *h, struct page *page)
 	list_move(&page->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
+	SetPageHugeFreed(page);
 }
 
 static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
@@ -883,6 +899,7 @@ static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
 		return NULL;
 	list_move(&page->lru, &h->hugepage_activelist);
 	set_page_refcounted(page);
+	ClearPageHugeFreed(page);
 	h->free_huge_pages--;
 	h->free_huge_pages_node[nid]--;
 	return page;
@@ -1315,6 +1332,7 @@ static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 	set_hugetlb_cgroup(page, NULL);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
+	ClearPageHugeFreed(page);
 	spin_unlock(&hugetlb_lock);
 	put_page(page); /* free it into the hugepage allocator */
 }
@@ -1478,6 +1496,7 @@ int dissolve_free_huge_page(struct page *page)
 {
 	int rc = 0;
 
+retry:
 	spin_lock(&hugetlb_lock);
 	if (PageHuge(page) && !page_count(page)) {
 		struct page *head = compound_head(page);
@@ -1487,6 +1506,26 @@ int dissolve_free_huge_page(struct page *page)
 			rc = -EBUSY;
 			goto out;
 		}
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
-- 
2.30.0


--MUjlgFyOwtqTwo/3--
