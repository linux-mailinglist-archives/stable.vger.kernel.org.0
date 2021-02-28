Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4715132728A
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 14:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhB1N6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 08:58:19 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:35977 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230202AbhB1N6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 08:58:15 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 719E1310;
        Sun, 28 Feb 2021 08:57:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 28 Feb 2021 08:57:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JcrnLI
        xv2bEKY6cwrNWAFEouCBwBfK376OagQpIlxjA=; b=fCKDg4NYdGaBdH9KrrJ7qW
        QzfYTsNj6ydDtNOer7uCTjatGPIl31CSIHDy1JG16yPoVP84Yke3BK2ZVXFDm9y3
        6eTjuvgjbNGZYyJ6iDgjg/u7GzY22nwOumJZCXqRTQM+OfZsjtxEoVNoEeOlk+Bv
        SjTVvl+zTHy3iaxDuGQfF/aUzVRt+76zIniFh0Zs/LgLO3SxyMuTZYdIh1K4ugQM
        nFqZPC0jRmTchap7fya0ge1hYJwjmYXrQJVdNRTds7bNSt2Mq1tk+i5/w9cV5974
        6/Rd8thnMyouk+65tZ1jArf1w0AGjq3iwgAZEhdduF1BAvGgWTxz7peXljI6c6Sw
        ==
X-ME-Sender: <xms:M6E7YO87UekCWLYmYCM9aZqwO1m8hB713ynznDvLJfrav-dm4yEV8g>
    <xme:M6E7YOtauR1rWYyCY0MDDO23SgoQTbapMA175CK9Pu3UOZBJNPV-b2ZuwsvitX9So
    1gUjFPrD5LXPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleeigdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:M6E7YEAwn8HN72VQhMljBphFcUFrDkFWQRfHZ4mnHxbSeH4GTYbX6A>
    <xmx:M6E7YGd3BLYdlV6XrEG9Ie9Lqus6vsL5nfGI-P5bDbdxIts0i8lQZQ>
    <xmx:M6E7YDMlZSSoBgADglaxec0yF282L18KLniyTQWeTstsWWhpklcpiA>
    <xmx:M6E7YMriJYzotjVUZWBu6AjLPPDhDJg5JVrVNGinrxYMj9LxoSHClt76Fj8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E6B3024005E;
        Sun, 28 Feb 2021 08:57:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] zsmalloc: account the number of compacted pages correctly" failed to apply to 5.10-stable tree
To:     wu-yan@tcl.com, akpm@linux-foundation.org, minchan@kernel.org,
        sergey.senozhatsky@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Feb 2021 14:57:04 +0100
Message-ID: <1614520624144188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

