Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D55A325795
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 21:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhBYU0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 15:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhBYU0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 15:26:07 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2A2C0617A7
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 12:24:56 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id u14so6520080wri.3
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 12:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iwGtlAUuIKR+rZXJDTEFSvuFv/CHTMQw+T4I/d+1wmM=;
        b=XrIYHvPnIcKnH6ULbTwbvSwOiAurGJgu7IOkl+9TcU7HF086Ax9Q+duc6LHcbNmdSV
         qU9bpB8Ls5ebWomPKz5cxA4U0i4zCIimJEC4FNtp5cAVMX5SI/BbjsOcjb7EAwWr+NY2
         6rC1Sl8ckK8iwYENiW5dMxTco6yoQ0NXAw/N6oXoXBwuv7L7Y66TWbqcy9ys/q/V5GL0
         aiWDm2GD/jV2xFGRJJGddT5W/MeQWAQHNeheZVK+fe+XWlQBlAF+LO4qw123iS5WHf/2
         Q7D+cqR7CSZA0cyHtwwzI/QaDEepuk1tnfyM+RqOyzSXQvv98qZ1Ou8fbFiVrI6wyrpa
         Gy4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iwGtlAUuIKR+rZXJDTEFSvuFv/CHTMQw+T4I/d+1wmM=;
        b=KV298/UNWjTOhQr09gVbsbySUNddKBTU3jI2kHG9kUxuYef9k5mmAQ5XbiUMPgyKTu
         yhb7clH9KBQNCJ7OR1348zLY12ZhWxPNekR5/JSlxKS4oNUMVSnegJ7Ty3mzy43mV3tr
         lBCLojlw5cwkzIDESgXbSlTCtcHkksGaxBexsPFEW7ocwrqej4+YB9Iz1xRYmYCB4DDs
         hkKwzOCUI1Mmi+TKArQq/UrLU0mBle2v3vDXb7g5domg2fAjuUcj5mP466IpMUdlq1Kb
         acD7IBpalbHGnDLBzGxrP4AAbFs1DXp1frOYzRwTSaDFVpFX+bPDotjG0nZF1S47HAzc
         chJw==
X-Gm-Message-State: AOAM533ZfQuOUZ3/SKMCfYsZh6DlffyOk5zTieEY7K0DFkwiTLrcZMjU
        HIWxa3fZtDgCnt3Ba/jMm1M=
X-Google-Smtp-Source: ABdhPJwh6Eh4lFqMdlqb+o2Q89UPbw2Nkzgtxe571BCvfV5lUUdvJroTb/RtnFGMNVSOkV/cYfxmKQ==
X-Received: by 2002:a05:6000:1841:: with SMTP id c1mr5075146wri.278.1614284695049;
        Thu, 25 Feb 2021 12:24:55 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id o9sm9028127wmc.8.2021.02.25.12.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 12:24:54 -0800 (PST)
Date:   Thu, 25 Feb 2021 20:24:52 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     songmuchun@bytedance.com, akpm@linux-foundation.org,
        david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        osalvador@suse.de, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm: hugetlb: fix a race between freeing
 and dissolving the" failed to apply to 4.4-stable tree
Message-ID: <YDgHlEEifKxKKPb/@debian>
References: <161278206820815@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="aVGQJ8ZYtiyi9Pq8"
Content-Disposition: inline
In-Reply-To: <161278206820815@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aVGQJ8ZYtiyi9Pq8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Feb 08, 2021 at 12:01:08PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--aVGQJ8ZYtiyi9Pq8
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-mm-hugetlb-fix-a-race-between-freeing-and-dissolving.patch"

From 9585297e3f6ce7aafd72f7625c0eb6f2279558d2 Mon Sep 17 00:00:00 2001
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
index dc877712ef1f..2f1779e37e5b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -66,6 +66,21 @@ DEFINE_SPINLOCK(hugetlb_lock);
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
 
@@ -841,6 +856,7 @@ static void enqueue_huge_page(struct hstate *h, struct page *page)
 	list_move(&page->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
+	SetPageHugeFreed(page);
 }
 
 static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
@@ -858,6 +874,7 @@ static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
 		return NULL;
 	list_move(&page->lru, &h->hugepage_activelist);
 	set_page_refcounted(page);
+	ClearPageHugeFreed(page);
 	h->free_huge_pages--;
 	h->free_huge_pages_node[nid]--;
 	return page;
@@ -1266,6 +1283,7 @@ static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 	set_hugetlb_cgroup(page, NULL);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
+	ClearPageHugeFreed(page);
 	spin_unlock(&hugetlb_lock);
 	put_page(page); /* free it into the hugepage allocator */
 }
@@ -1424,11 +1442,32 @@ static int free_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed,
  */
 static void dissolve_free_huge_page(struct page *page)
 {
+retry:
 	spin_lock(&hugetlb_lock);
 	if (PageHuge(page) && !page_count(page)) {
 		struct page *head = compound_head(page);
 		struct hstate *h = page_hstate(head);
 		int nid = page_to_nid(head);
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
 		list_del(&head->lru);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
-- 
2.30.0


--aVGQJ8ZYtiyi9Pq8--
