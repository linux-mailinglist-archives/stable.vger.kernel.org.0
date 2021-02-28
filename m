Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D7E327284
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 14:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhB1N54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 08:57:56 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:54189 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229715AbhB1N5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 08:57:55 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 3C2CB6A7;
        Sun, 28 Feb 2021 08:57:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 28 Feb 2021 08:57:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rK3MG9
        LRW8WJQze3jxUr+qUFItBO3LwG/s8xf0cBhss=; b=PVH/HgFKn5jPuXbDx63+os
        a1TLx6tn4uAr/KdQjd6vKeozAY1YB7EN/c8HX0YR/nriNk/ZBKMDsetSwWMC5qIt
        yZrZNoirRqO2cImaK+ka0QJwLKCLnOCfDZzXXU0f0rSdr82Ta9aleike6pyNg9N2
        8G8Gf5nL7Y+CK1DmJoBvl9XnyfPf4Sk0WQlqvs/YkWrGEQcnJWvmdYg/nP/lwpnI
        p9Sw6/2nWSud80F9egiR55QPDIk4+11V7j57Xp0PU4SFj2PUtQJe9nXDSnAKjBw5
        yqjYOw2XCGhDLFO1sMDCOZIoZ55OFQTIC07oUEGb0BhUjf3u4h+2p3EPaX0NGx2g
        ==
X-ME-Sender: <xms:NKE7YNqbMdY5FX6bfJCVHtkXKy_dZrxjJM-iL96T3oWTvacsUswyHQ>
    <xme:NKE7YPpTE8btHRTfq5eDLPG2Nqu4e1YEmOAxCMKZm5lifeJygS9D9hgnoxrDkvoNA
    0c_2V1iawHVyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleeigdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:NKE7YKO1heHpW7lb4yGFAmx0DM5t6tgwcSizFwRhtosCp85PP0nN9Q>
    <xmx:NKE7YI40RjhqlnHw7NQCRya3AGWUMtUpyhNHcVvypHxiWCgDt6y00g>
    <xmx:NKE7YM64R9yRe-lPumTWlKqYEllxCsihKKUu8OQjnX3vS59VBDQN9g>
    <xmx:NKE7YKm-AqMi0Z53xGTZQW6O5qb5HnAAbVism6r6HSFBMLMeFVeG-4G7GBc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8183F1080054;
        Sun, 28 Feb 2021 08:57:08 -0500 (EST)
Subject: FAILED: patch "[PATCH] zsmalloc: account the number of compacted pages correctly" failed to apply to 5.4-stable tree
To:     wu-yan@tcl.com, akpm@linux-foundation.org, minchan@kernel.org,
        sergey.senozhatsky@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Feb 2021 14:57:05 +0100
Message-ID: <161452062538200@kroah.com>
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

From 2395928158059b8f9858365fce7713ce7fef62e4 Mon Sep 17 00:00:00 2001
From: Rokudo Yan <wu-yan@tcl.com>
Date: Thu, 25 Feb 2021 17:18:31 -0800
Subject: [PATCH] zsmalloc: account the number of compacted pages correctly

There exists multiple path may do zram compaction concurrently.
1. auto-compaction triggered during memory reclaim
2. userspace utils write zram<id>/compaction node

So, multiple threads may call zs_shrinker_scan/zs_compact concurrently.
But pages_compacted is a per zsmalloc pool variable and modification
of the variable is not serialized(through under class->lock).
There are two issues here:
1. the pages_compacted may not equal to total number of pages
freed(due to concurrently add).
2. zs_shrinker_scan may not return the correct number of pages
freed(issued by current shrinker).

The fix is simple:
1. account the number of pages freed in zs_compact locally.
2. use actomic variable pages_compacted to accumulate total number.

Link: https://lkml.kernel.org/r/20210202122235.26885-1-wu-yan@tcl.com
Fixes: 860c707dca155a56 ("zsmalloc: account the number of compacted pages")
Signed-off-by: Rokudo Yan <wu-yan@tcl.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d7018543842e..a711a2e2a794 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1081,7 +1081,7 @@ static ssize_t mm_stat_show(struct device *dev,
 			zram->limit_pages << PAGE_SHIFT,
 			max_used << PAGE_SHIFT,
 			(u64)atomic64_read(&zram->stats.same_pages),
-			pool_stats.pages_compacted,
+			atomic_long_read(&pool_stats.pages_compacted),
 			(u64)atomic64_read(&zram->stats.huge_pages),
 			(u64)atomic64_read(&zram->stats.huge_pages_since));
 	up_read(&zram->init_lock);
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 4807ca4d52e0..2a430e713ce5 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -35,7 +35,7 @@ enum zs_mapmode {
 
 struct zs_pool_stats {
 	/* How many pages were migrated (freed) */
-	unsigned long pages_compacted;
+	atomic_long_t pages_compacted;
 };
 
 struct zs_pool;
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index cf0ed0e4e911..1518732f95c3 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -2212,11 +2212,13 @@ static unsigned long zs_can_compact(struct size_class *class)
 	return obj_wasted * class->pages_per_zspage;
 }
 
-static void __zs_compact(struct zs_pool *pool, struct size_class *class)
+static unsigned long __zs_compact(struct zs_pool *pool,
+				  struct size_class *class)
 {
 	struct zs_compact_control cc;
 	struct zspage *src_zspage;
 	struct zspage *dst_zspage = NULL;
+	unsigned long pages_freed = 0;
 
 	spin_lock(&class->lock);
 	while ((src_zspage = isolate_zspage(class, true))) {
@@ -2246,7 +2248,7 @@ static void __zs_compact(struct zs_pool *pool, struct size_class *class)
 		putback_zspage(class, dst_zspage);
 		if (putback_zspage(class, src_zspage) == ZS_EMPTY) {
 			free_zspage(pool, class, src_zspage);
-			pool->stats.pages_compacted += class->pages_per_zspage;
+			pages_freed += class->pages_per_zspage;
 		}
 		spin_unlock(&class->lock);
 		cond_resched();
@@ -2257,12 +2259,15 @@ static void __zs_compact(struct zs_pool *pool, struct size_class *class)
 		putback_zspage(class, src_zspage);
 
 	spin_unlock(&class->lock);
+
+	return pages_freed;
 }
 
 unsigned long zs_compact(struct zs_pool *pool)
 {
 	int i;
 	struct size_class *class;
+	unsigned long pages_freed = 0;
 
 	for (i = ZS_SIZE_CLASSES - 1; i >= 0; i--) {
 		class = pool->size_class[i];
@@ -2270,10 +2275,11 @@ unsigned long zs_compact(struct zs_pool *pool)
 			continue;
 		if (class->index != i)
 			continue;
-		__zs_compact(pool, class);
+		pages_freed += __zs_compact(pool, class);
 	}
+	atomic_long_add(pages_freed, &pool->stats.pages_compacted);
 
-	return pool->stats.pages_compacted;
+	return pages_freed;
 }
 EXPORT_SYMBOL_GPL(zs_compact);
 
@@ -2290,13 +2296,12 @@ static unsigned long zs_shrinker_scan(struct shrinker *shrinker,
 	struct zs_pool *pool = container_of(shrinker, struct zs_pool,
 			shrinker);
 
-	pages_freed = pool->stats.pages_compacted;
 	/*
 	 * Compact classes and calculate compaction delta.
 	 * Can run concurrently with a manually triggered
 	 * (by user) compaction.
 	 */
-	pages_freed = zs_compact(pool) - pages_freed;
+	pages_freed = zs_compact(pool);
 
 	return pages_freed ? pages_freed : SHRINK_STOP;
 }

