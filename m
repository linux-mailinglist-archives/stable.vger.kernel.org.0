Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A78DDC9D7E
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 13:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbfJCLjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 07:39:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60781 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725827AbfJCLjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 07:39:23 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id EF71B21B7C;
        Thu,  3 Oct 2019 07:39:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 07:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GUKkTd
        0tHziMttnzjgZetoVnqaOl6cX4pgaeC8SGDi8=; b=P1sKmA6Sr2YQn0dqPlfCJh
        rtip8143buO7CjF63tftCF061dEUx6X2Yb1C8Fxg9UCqo68fGILJUfZPqO1XRkzr
        TkmA3MdNDfMEv7tOpcXiPLKGnYR4AM4ihb/dAnnyAoqatp17HgyTH1QP9kao9WSX
        26oFgcLB4J2my7Kd8bJWA5DTwysI4+w7XYGWmrJKkYT1WwYsNby5ccbKxlGgT2wy
        wBgibpf18veWKAJ15do0/cnEh08GlgV+VvNGAB65fXj8j5Xt87ddAY3ZNtQqxAi2
        845FdN76kzIoPcDaR5dtF+WX3bS4fSz7jJKada0C78LG0OeQT6SC564C62gpYX6Q
        ==
X-ME-Sender: <xms:6d2VXSbAlOPOges6TC56FQI6pvHwR6YJO8bwPm83e712m9WKdMcF7w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:6d2VXQ_MnGpypDFmSdAgMtScvzKuVLEiFBIRLhLDQBk8wMlxBvkWDA>
    <xmx:6d2VXT8B_puYsi2I-Ob6hu8M0oM1KbtcudczfB7c3gmkJfcvTytR-Q>
    <xmx:6d2VXWRFtrlTxSoAJPENMBUE6JM5Czwh_LlKcB1q20alyDfMTKUDWg>
    <xmx:6d2VXXtc010cAMkDwEl5T3UMunY5UuKOqRDM4mcb4-jFL61xwBnz1A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6A6D680059;
        Thu,  3 Oct 2019 07:39:21 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/compaction.c: clear total_{migrate,free}_scanned before" failed to apply to 4.19-stable tree
To:     laoar.shao@gmail.com, akpm@linux-foundation.org,
        mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com,
        shaoyafang@didiglobal.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 13:38:46 +0200
Message-ID: <157010272680112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a94b525241c0fff3598809131d7cfcfe1d572d8c Mon Sep 17 00:00:00 2001
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 23 Sep 2019 15:36:54 -0700
Subject: [PATCH] mm/compaction.c: clear total_{migrate,free}_scanned before
 scanning a new zone

total_{migrate,free}_scanned will be added to COMPACTMIGRATE_SCANNED and
COMPACTFREE_SCANNED in compact_zone().  We should clear them before
scanning a new zone.  In the proc triggered compaction, we forgot clearing
them.

[laoar.shao@gmail.com: introduce a helper compact_zone_counters_init()]
  Link: http://lkml.kernel.org/r/1563869295-25748-1-git-send-email-laoar.shao@gmail.com
[akpm@linux-foundation.org: expand compact_zone_counters_init() into its single callsite, per mhocko]
[vbabka@suse.cz: squash compact_zone() list_head init as well]
  Link: http://lkml.kernel.org/r/1fb6f7da-f776-9e42-22f8-bbb79b030b98@suse.cz
[akpm@linux-foundation.org: kcompactd_do_work(): avoid unnecessary initialization of cc.zone]
Link: http://lkml.kernel.org/r/1563789275-9639-1-git-send-email-laoar.shao@gmail.com
Fixes: 7f354a548d1c ("mm, compaction: add vmstats for kcompactd work")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Yafang Shao <shaoyafang@didiglobal.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/compaction.c b/mm/compaction.c
index 777c088e9113..d99d59412c75 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2078,6 +2078,17 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 	const bool sync = cc->mode != MIGRATE_ASYNC;
 	bool update_cached;
 
+	/*
+	 * These counters track activities during zone compaction.  Initialize
+	 * them before compacting a new zone.
+	 */
+	cc->total_migrate_scanned = 0;
+	cc->total_free_scanned = 0;
+	cc->nr_migratepages = 0;
+	cc->nr_freepages = 0;
+	INIT_LIST_HEAD(&cc->freepages);
+	INIT_LIST_HEAD(&cc->migratepages);
+
 	cc->migratetype = gfpflags_to_migratetype(cc->gfp_mask);
 	ret = compaction_suitable(cc->zone, cc->order, cc->alloc_flags,
 							cc->classzone_idx);
@@ -2281,10 +2292,6 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
 {
 	enum compact_result ret;
 	struct compact_control cc = {
-		.nr_freepages = 0,
-		.nr_migratepages = 0,
-		.total_migrate_scanned = 0,
-		.total_free_scanned = 0,
 		.order = order,
 		.search_order = order,
 		.gfp_mask = gfp_mask,
@@ -2305,8 +2312,6 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
 
 	if (capture)
 		current->capture_control = &capc;
-	INIT_LIST_HEAD(&cc.freepages);
-	INIT_LIST_HEAD(&cc.migratepages);
 
 	ret = compact_zone(&cc, &capc);
 
@@ -2408,8 +2413,6 @@ static void compact_node(int nid)
 	struct zone *zone;
 	struct compact_control cc = {
 		.order = -1,
-		.total_migrate_scanned = 0,
-		.total_free_scanned = 0,
 		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
 		.whole_zone = true,
@@ -2423,11 +2426,7 @@ static void compact_node(int nid)
 		if (!populated_zone(zone))
 			continue;
 
-		cc.nr_freepages = 0;
-		cc.nr_migratepages = 0;
 		cc.zone = zone;
-		INIT_LIST_HEAD(&cc.freepages);
-		INIT_LIST_HEAD(&cc.migratepages);
 
 		compact_zone(&cc, NULL);
 
@@ -2529,8 +2528,6 @@ static void kcompactd_do_work(pg_data_t *pgdat)
 	struct compact_control cc = {
 		.order = pgdat->kcompactd_max_order,
 		.search_order = pgdat->kcompactd_max_order,
-		.total_migrate_scanned = 0,
-		.total_free_scanned = 0,
 		.classzone_idx = pgdat->kcompactd_classzone_idx,
 		.mode = MIGRATE_SYNC_LIGHT,
 		.ignore_skip_hint = false,
@@ -2554,16 +2551,10 @@ static void kcompactd_do_work(pg_data_t *pgdat)
 							COMPACT_CONTINUE)
 			continue;
 
-		cc.nr_freepages = 0;
-		cc.nr_migratepages = 0;
-		cc.total_migrate_scanned = 0;
-		cc.total_free_scanned = 0;
-		cc.zone = zone;
-		INIT_LIST_HEAD(&cc.freepages);
-		INIT_LIST_HEAD(&cc.migratepages);
-
 		if (kthread_should_stop())
 			return;
+
+		cc.zone = zone;
 		status = compact_zone(&cc, NULL);
 
 		if (status == COMPACT_SUCCESS) {

