Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F4B325784
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 21:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhBYUYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 15:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhBYUYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 15:24:12 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041C5C061574
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 12:23:32 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id i7so5559382wmb.0
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 12:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AhXr7DjjdaI+jwKpkEi5+BHuksjY5Ycgj9e0a94OAjU=;
        b=tVRznXNV1rLldBKlILLol5f4FsVdmBu4k7jeKRsrznpE7QQDUqowpe0GBx+XJDLr6L
         gt12mk/pbUJzlmTn53ovtg82zhYYsDDEVnKNKGRER93G2WmzZS/vgKWKogng4wgjkaSt
         ALJnnn6T3vHK79cyaKZgnXR55ufivrGifXvfLbvjyR8VkDqbFXh/nLoPFLjA6VtrR9ep
         P1nBd8uDFZK8GQ1HNKz166qv+AY/xsSq8PRSALeTgJrlHCDTOa2+zuxLMetNA+ilnNYH
         jLD6wD88fWeZ4kXkiw8OLnCLGpKXeTmT/Qz/fFK4ieU3+gRbJ+9TboFVxZpOLJ3FUvlI
         L+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AhXr7DjjdaI+jwKpkEi5+BHuksjY5Ycgj9e0a94OAjU=;
        b=Ay+NKdF/k9KrXUkmr7mHuiAIo1woAxzTBngqxNnNkbvqI5gsXZm4i0opTHzI35FxQ6
         cjBWN9CskNmxmOt90cwIjmqBP3O8Yw7irhMYEA3ReepFisnLDCSfnM1ISdfoOMWIAt2S
         iQVt6V/XhqBvSzxJZ9bRHF0TV81bWApEaTyZx4V3L0PMt04q6WQNNe6aWebbBJ9xdmHA
         O9wXucqkjJjwJ+UsNv87gXsyW9G1Qi5AjNrhYthnhoYYa70fZrofgh0dXdP+KFS5vrUl
         Ahmr8k/AyTsVu7SC1ttNjEin/6bmy3umAKiRNwydd2kn/wiX2AfaAmJCoL4T4jnxmw7P
         LWDA==
X-Gm-Message-State: AOAM532ix/Is2nyB405CtHjSF+pCCeK6C27AsCnsUvr2O6mJlonzQ4ZP
        I8DQsmRvS1V262q689lsY9A=
X-Google-Smtp-Source: ABdhPJyVilyrKadMoVQ0zKNHmRhk03kQxVrDSTd/ZnzAA40SGHMgTc6LKIxTaYFKf16BivSO6f2a9w==
X-Received: by 2002:a7b:cd98:: with SMTP id y24mr121541wmj.23.1614284610786;
        Thu, 25 Feb 2021 12:23:30 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id h22sm9881179wmb.36.2021.02.25.12.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 12:23:30 -0800 (PST)
Date:   Thu, 25 Feb 2021 20:23:28 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     songmuchun@bytedance.com, akpm@linux-foundation.org,
        david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        osalvador@suse.de, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm: hugetlb: fix a race between freeing
 and dissolving the" failed to apply to 4.9-stable tree
Message-ID: <YDgHQK+hu+24vDwM@debian>
References: <161278206919633@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+7lpLZCDCYXjztLb"
Content-Disposition: inline
In-Reply-To: <161278206919633@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+7lpLZCDCYXjztLb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Feb 08, 2021 at 12:01:09PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--+7lpLZCDCYXjztLb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-mm-hugetlb-fix-a-race-between-freeing-and-dissolving.patch"

From f881ad15d3564df36863ebbbc408dd814efffd25 Mon Sep 17 00:00:00 2001
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
index 5a16d892c891..98b6c91dab9d 100644
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
 
@@ -863,6 +878,7 @@ static void enqueue_huge_page(struct hstate *h, struct page *page)
 	list_move(&page->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
+	SetPageHugeFreed(page);
 }
 
 static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
@@ -880,6 +896,7 @@ static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
 		return NULL;
 	list_move(&page->lru, &h->hugepage_activelist);
 	set_page_refcounted(page);
+	ClearPageHugeFreed(page);
 	h->free_huge_pages--;
 	h->free_huge_pages_node[nid]--;
 	return page;
@@ -1292,6 +1309,7 @@ static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 	set_hugetlb_cgroup(page, NULL);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
+	ClearPageHugeFreed(page);
 	spin_unlock(&hugetlb_lock);
 	put_page(page); /* free it into the hugepage allocator */
 }
@@ -1455,6 +1473,7 @@ static int dissolve_free_huge_page(struct page *page)
 {
 	int rc = 0;
 
+retry:
 	spin_lock(&hugetlb_lock);
 	if (PageHuge(page) && !page_count(page)) {
 		struct page *head = compound_head(page);
@@ -1464,6 +1483,26 @@ static int dissolve_free_huge_page(struct page *page)
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
 		list_del(&head->lru);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
-- 
2.30.0


--+7lpLZCDCYXjztLb--
