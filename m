Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9D23483DB
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 22:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhCXVik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 17:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhCXViN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 17:38:13 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B000C06174A
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 14:38:13 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id x207so2147oif.1
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 14:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=AOsDcocTavhzD/eHKo6O25r0zbhqEDSNw6lg0m3pA9w=;
        b=MZHLusS3cowXgjBgEjtf8ebc2qiRFJ5jeeYlUrlD0U/dt+vD+VbrIiNPTXuQ8GBDMs
         iC5WiXHP95qyHmlgJOgh+bJBaRZMucY6gIq94YFWFtrdylKSIpY5+RK85EofsBFidYZ5
         +wIT1QjIszeHa7r2fuvkia4M299n8gWFUeeK5TWHboqZZFa1qiCxY/Y6KrTgvwehpuZa
         A+SDGEfymHiOOSwI3gMrYI74Y1YPQ4GFTeWoq1TIqPbHXI0+tO5rv3itcm4AFhnwXCC2
         8CXL8x8D4kOzdBuzsDExwWlfa7gCuSemntdItUfpiFeQtNus3KdjyI3fa1DZcsUEg1Bl
         kBcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=AOsDcocTavhzD/eHKo6O25r0zbhqEDSNw6lg0m3pA9w=;
        b=B929ILBVVZKgi078ZqgBGWHhiNIJJv31vvgetSVpm9gbTBwb2dFgdzH2T5T2r7X9o5
         D8oZozvprP0XSzkJGTuDdSHdMc2dq8X8vrLfR7iLE5fCdwXeq0rg7Dup61juXaMt+OdT
         37umlcG58P9fP30TTsAt0nJhnPKY1x5R4W5RyMvCvUm+dXepnqf+vHxkV92E0oiKz4P8
         fIGonRPmxk5jCK1znG1WZw4LN5c6daK+l/EBi22ZTmcTjDPwyXUFmEeZlSHm/KfXDha1
         qHW5M1JvbBElKpYCgFMDEZnD1HRTKA2B0ZKhemx+ow9CyK7yb9lEan03JA8wTGBrmlwp
         Xt8w==
X-Gm-Message-State: AOAM5330NajLnzK0zM/7I9daR78On2ER49PHJthznAtdmcjxQWrxGiKy
        /i9z1keM/CLV66kI/ErxlEjkcA==
X-Google-Smtp-Source: ABdhPJx01kjQeq9kd/P2uo1T4tfiMmqMwnlxST4XGU9zcQiF33yv5Jj5YW+d/05L37wjbDdc5APGwg==
X-Received: by 2002:aca:a9c7:: with SMTP id s190mr3794867oie.19.1616621892764;
        Wed, 24 Mar 2021 14:38:12 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id x25sm796053oto.72.2021.03.24.14.38.11
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 24 Mar 2021 14:38:12 -0700 (PDT)
Date:   Wed, 24 Mar 2021 14:37:59 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     gregkh@linuxfoundation.org
cc:     zhouguanghui1@huawei.com, akpm@linux-foundation.org,
        chenweilong@huawei.com, dingtianhong@huawei.com,
        guohanjun@huawei.com, hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@suse.com,
        npiggin@gmail.com, rui.xiang@huawei.com, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com, ziy@nvidia.com, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] mm/memcg: rename mem_cgroup_split_huge_fixup
 to" failed to apply to 5.10-stable tree
In-Reply-To: <1615798405152241@kroah.com>
Message-ID: <alpine.LSU.2.11.2103241424450.8948@eggly.anvils>
References: <1615798405152241@kroah.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Mar 2021, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Fixed-up version below: this should be the first of the two patches (if
the other goes first, as happened for 5.11, I believe its build breaks).

Hugh

------------------ original commit in Linus's tree ------------------

From be6c8982e4ab9a41907555f601b711a7e2a17d4c Mon Sep 17 00:00:00 2001
From: Zhou Guanghui <zhouguanghui1@huawei.com>
Date: Fri, 12 Mar 2021 21:08:30 -0800
Subject: [PATCH 1/2] mm/memcg: rename mem_cgroup_split_huge_fixup to
 split_page_memcg and add nr_pages argument

Rename mem_cgroup_split_huge_fixup to split_page_memcg and explicitly pass
in page number argument.

In this way, the interface name is more common and can be used by
potential users.  In addition, the complete info(memcg and flag) of the
memcg needs to be set to the tail pages.

Link: https://lkml.kernel.org/r/20210304074053.65527-2-zhouguanghui1@huawei.com
Signed-off-by: Zhou Guanghui <zhouguanghui1@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Tianhong Ding <dingtianhong@huawei.com>
Cc: Weilong Chen <chenweilong@huawei.com>
Cc: Rui Xiang <rui.xiang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/memcontrol.h |  6 ++----
 mm/huge_memory.c           |  2 +-
 mm/memcontrol.c            | 15 +++++----------
 3 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 922a7f600465..c691b1ac95f8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -937,9 +937,7 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
 	rcu_read_unlock();
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-void mem_cgroup_split_huge_fixup(struct page *head);
-#endif
+void split_page_memcg(struct page *head, unsigned int nr);
 
 #else /* CONFIG_MEMCG */
 
@@ -1267,7 +1265,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 	return 0;
 }
 
-static inline void mem_cgroup_split_huge_fixup(struct page *head)
+static inline void split_page_memcg(struct page *head, unsigned int nr)
 {
 }
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4a78514830d5..d9ade23ac2b2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2433,7 +2433,7 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 	lruvec = mem_cgroup_page_lruvec(head, pgdat);
 
 	/* complete memcg works before add pages to LRU */
-	mem_cgroup_split_huge_fixup(head);
+	split_page_memcg(head, nr);
 
 	if (PageAnon(head) && PageSwapCache(head)) {
 		swp_entry_t entry = { .val = page_private(head) };
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d6966f1ebc7a..dda4223d3ff9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3268,26 +3268,21 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
 
 #endif /* CONFIG_MEMCG_KMEM */
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-
 /*
- * Because tail pages are not marked as "used", set it. We're under
- * pgdat->lru_lock and migration entries setup in all page mappings.
+ * Because head->mem_cgroup is not set on tails, set it now.
  */
-void mem_cgroup_split_huge_fixup(struct page *head)
+void split_page_memcg(struct page *head, unsigned int nr)
 {
 	struct mem_cgroup *memcg = head->mem_cgroup;
 	int i;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() || !memcg)
 		return;
 
-	for (i = 1; i < HPAGE_PMD_NR; i++) {
-		css_get(&memcg->css);
+	for (i = 1; i < nr; i++)
 		head[i].mem_cgroup = memcg;
-	}
+	css_get_many(&memcg->css, nr - 1);
 }
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_MEMCG_SWAP
 /**
-- 
2.31.0.291.g576ba9dcdaf-goog
