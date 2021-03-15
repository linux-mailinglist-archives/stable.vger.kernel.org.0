Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2A533ADF6
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhCOIxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:53:50 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:43465 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229685AbhCOIx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:53:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6BD7619407BA;
        Mon, 15 Mar 2021 04:53:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 04:53:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rVLAjR
        94PGyaeQh4wRKzHSWkCqyI3778VHntXLr2bME=; b=e92gNIaVs2kmMCX9P6IGC9
        6ubWXMmyLrOPOyGkU7frwi4kTWM1W0S0R9rBeytP/2ZYcQZh+xFitIZxXMEGr8mC
        ToHpnP/Gns0l1yyd639Kx4SHrwL0MYn0QKVoISGEtvmYE480EdlTSl9G+BaiYuaQ
        VVTa9VPZmBi1JItxOybXQVsBlocljaG3PZa9JWhVmypix+SyvDTk+NM3UBGK6zhn
        fO2/CK+XJafGJ+ZUfZsm0+9zDcuRDU0Y2f43mov9yclFEKLKX2+1zwkzgrF0+2Uw
        BmjwgV205Wk1PY60sEcngOyGjN2hdpoCpG709/hQABoLbksRIwmg0Hxdk527hi7Q
        ==
X-ME-Sender: <xms:hiBPYImzPGKiXb6KdNf84cC7ULFlI8hsxT9myuxa8LqXDo6oEbkB7A>
    <xme:hiBPYH2jZ_WthrB_SNTQXqfZuxQZ2uZYj8RzrmhwCfNUDW9UNtUMdmQhOyBt4XPmp
    cUXnTJnkMQnQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvkedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:hiBPYGpCn6647ZTzb0RZjt0UEWJZdwvSxKPzNJbCaoo2mU-rsudk-w>
    <xmx:hiBPYEnvFdqmXy9AjIzaxtwFBAhS68kKGTRXK2ivr_MrzJ2aHOYJLA>
    <xmx:hiBPYG084rHhwUsf6x2lbMqvm38GLFUaSjJAGkIomPyrghqvRx981g>
    <xmx:hyBPYJ2iPvEwG9KlN4d1XHZMHx73tWEb7ZAFKdeMciIykIr2bONhd9qUE2I>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 473E2240066;
        Mon, 15 Mar 2021 04:53:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/memcg: rename mem_cgroup_split_huge_fixup to" failed to apply to 5.4-stable tree
To:     zhouguanghui1@huawei.com, akpm@linux-foundation.org,
        chenweilong@huawei.com, dingtianhong@huawei.com,
        guohanjun@huawei.com, hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@suse.com,
        npiggin@gmail.com, rui.xiang@huawei.com, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com, ziy@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 09:53:25 +0100
Message-ID: <161579840515012@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From be6c8982e4ab9a41907555f601b711a7e2a17d4c Mon Sep 17 00:00:00 2001
From: Zhou Guanghui <zhouguanghui1@huawei.com>
Date: Fri, 12 Mar 2021 21:08:30 -0800
Subject: [PATCH] mm/memcg: rename mem_cgroup_split_huge_fixup to
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

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e6dc793d587d..0c04d39a7967 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1061,9 +1061,7 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
 	rcu_read_unlock();
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-void mem_cgroup_split_huge_fixup(struct page *head);
-#endif
+void split_page_memcg(struct page *head, unsigned int nr);
 
 #else /* CONFIG_MEMCG */
 
@@ -1400,7 +1398,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 	return 0;
 }
 
-static inline void mem_cgroup_split_huge_fixup(struct page *head)
+static inline void split_page_memcg(struct page *head, unsigned int nr)
 {
 }
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index da1d63a41aec..ae907a9c2050 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2467,7 +2467,7 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 	int i;
 
 	/* complete memcg works before add pages to LRU */
-	mem_cgroup_split_huge_fixup(head);
+	split_page_memcg(head, nr);
 
 	if (PageAnon(head) && PageSwapCache(head)) {
 		swp_entry_t entry = { .val = page_private(head) };
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 845eec01ef9d..e064ac0d850a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3287,24 +3287,21 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
 
 #endif /* CONFIG_MEMCG_KMEM */
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
- * Because page_memcg(head) is not set on compound tails, set it now.
+ * Because page_memcg(head) is not set on tails, set it now.
  */
-void mem_cgroup_split_huge_fixup(struct page *head)
+void split_page_memcg(struct page *head, unsigned int nr)
 {
 	struct mem_cgroup *memcg = page_memcg(head);
 	int i;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() || !memcg)
 		return;
 
-	for (i = 1; i < HPAGE_PMD_NR; i++) {
-		css_get(&memcg->css);
-		head[i].memcg_data = (unsigned long)memcg;
-	}
+	for (i = 1; i < nr; i++)
+		head[i].memcg_data = head->memcg_data;
+	css_get_many(&memcg->css, nr - 1);
 }
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_MEMCG_SWAP
 /**

