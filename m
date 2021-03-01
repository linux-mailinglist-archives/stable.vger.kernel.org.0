Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CA1327FDB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbhCANq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:46:26 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:46193 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235856AbhCANq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:46:26 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2880F194214B;
        Mon,  1 Mar 2021 08:45:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:45:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2l1BiC
        d6JfB2vueL9FIgjfhgdm/ngBRaYDxAGoKLbIU=; b=TvpnrD1tNTZxqXdyJ4EvQK
        HRVwHIWQqvP6E0Zi5js0bOPzpYMBAtN+44gYqNRU0boLGQnBVRr3KbIXC9RIswqR
        uB6EJjqDY19D6RS48rtm+Tf9YDHDWgyfbpEqI4qkrpUb+ygh0B9rz6TSlWBapAMq
        /HO0ELDlhYvlFmajqvaZf8O3+TchC+IFxLPpTJtH9Fa3weFAWYmG1yPo4KvhhSO3
        llTR2SK73vqyfp4XqpBVoEE/XXEuhFtDQlW3AaCLfzd/xDLu+eD/8+h9l93t5k8u
        sS1sMvMcgw4kiT2Tb/P2A9vXRdjxAyokeDhLRk656gj9SpSgm/6z1QMwVxNDFArA
        ==
X-ME-Sender: <xms:AvA8YHQxavb5bP0Sc98YlBY_3_IBTYVg6WIGzozndhqBsnScuKidTw>
    <xme:AvA8YIxii8rXHbxsWgYfP8dBGVNn18DSy532sjrT1Jqs4BM9PYaa0NPg_vX2Cpa0A
    ZFZvLr-rMcaUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:AvA8YM0VU7CyaZE9zL8gbq6X3nkT1LcjSLxIWFVy7ldIJQBgfuuTXw>
    <xmx:AvA8YHDi1dzz3PD5_K8tfupwcwBHGoDmHfEpXZkBNONb5q8JqOiNqw>
    <xmx:AvA8YAjOBUzzBgp8jf1EvbZp7kqFUWePJyYcgWJI6wuaDsTDTrNVyw>
    <xmx:A_A8YII_LvfftHqluOqk5yw40XPOh2_Aeg32vanrDTmCmnv1dNLJUA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AD91F108005C;
        Mon,  1 Mar 2021 08:45:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm writecache: return the exact table values that were set" failed to apply to 4.19-stable tree
To:     mpatocka@redhat.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:45:37 +0100
Message-ID: <1614606337101246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 054bee16163df023e2589db09fd27d81f7ad9e72 Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Thu, 4 Feb 2021 05:20:52 -0500
Subject: [PATCH] dm writecache: return the exact table values that were set

LVM doesn't like it when the target returns different values from what
was set in the constructor. Fix dm-writecache so that the returned
table values are exactly the same as requested values.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org # v4.18+
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index fd531d5a39c2..e8382d73c73c 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -159,14 +159,22 @@ struct dm_writecache {
 	bool overwrote_committed:1;
 	bool memory_vmapped:1;
 
+	bool start_sector_set:1;
 	bool high_wm_percent_set:1;
 	bool low_wm_percent_set:1;
 	bool max_writeback_jobs_set:1;
 	bool autocommit_blocks_set:1;
 	bool autocommit_time_set:1;
+	bool max_age_set:1;
 	bool writeback_fua_set:1;
 	bool flush_on_suspend:1;
 	bool cleaner:1;
+	bool cleaner_set:1;
+
+	unsigned high_wm_percent_value;
+	unsigned low_wm_percent_value;
+	unsigned autocommit_time_value;
+	unsigned max_age_value;
 
 	unsigned writeback_all;
 	struct workqueue_struct *writeback_wq;
@@ -2203,6 +2211,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			if (sscanf(string, "%llu%c", &start_sector, &dummy) != 1)
 				goto invalid_optional;
 			wc->start_sector = start_sector;
+			wc->start_sector_set = true;
 			if (wc->start_sector != start_sector ||
 			    wc->start_sector >= wc->memory_map_size >> SECTOR_SHIFT)
 				goto invalid_optional;
@@ -2212,6 +2221,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 				goto invalid_optional;
 			if (high_wm_percent < 0 || high_wm_percent > 100)
 				goto invalid_optional;
+			wc->high_wm_percent_value = high_wm_percent;
 			wc->high_wm_percent_set = true;
 		} else if (!strcasecmp(string, "low_watermark") && opt_params >= 1) {
 			string = dm_shift_arg(&as), opt_params--;
@@ -2219,6 +2229,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 				goto invalid_optional;
 			if (low_wm_percent < 0 || low_wm_percent > 100)
 				goto invalid_optional;
+			wc->low_wm_percent_value = low_wm_percent;
 			wc->low_wm_percent_set = true;
 		} else if (!strcasecmp(string, "writeback_jobs") && opt_params >= 1) {
 			string = dm_shift_arg(&as), opt_params--;
@@ -2238,6 +2249,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			if (autocommit_msecs > 3600000)
 				goto invalid_optional;
 			wc->autocommit_jiffies = msecs_to_jiffies(autocommit_msecs);
+			wc->autocommit_time_value = autocommit_msecs;
 			wc->autocommit_time_set = true;
 		} else if (!strcasecmp(string, "max_age") && opt_params >= 1) {
 			unsigned max_age_msecs;
@@ -2247,7 +2259,10 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			if (max_age_msecs > 86400000)
 				goto invalid_optional;
 			wc->max_age = msecs_to_jiffies(max_age_msecs);
+			wc->max_age_set = true;
+			wc->max_age_value = max_age_msecs;
 		} else if (!strcasecmp(string, "cleaner")) {
+			wc->cleaner_set = true;
 			wc->cleaner = true;
 		} else if (!strcasecmp(string, "fua")) {
 			if (WC_MODE_PMEM(wc)) {
@@ -2453,7 +2468,6 @@ static void writecache_status(struct dm_target *ti, status_type_t type,
 	struct dm_writecache *wc = ti->private;
 	unsigned extra_args;
 	unsigned sz = 0;
-	uint64_t x;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -2465,11 +2479,11 @@ static void writecache_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("%c %s %s %u ", WC_MODE_PMEM(wc) ? 'p' : 's',
 				wc->dev->name, wc->ssd_dev->name, wc->block_size);
 		extra_args = 0;
-		if (wc->start_sector)
+		if (wc->start_sector_set)
 			extra_args += 2;
-		if (wc->high_wm_percent_set && !wc->cleaner)
+		if (wc->high_wm_percent_set)
 			extra_args += 2;
-		if (wc->low_wm_percent_set && !wc->cleaner)
+		if (wc->low_wm_percent_set)
 			extra_args += 2;
 		if (wc->max_writeback_jobs_set)
 			extra_args += 2;
@@ -2477,37 +2491,29 @@ static void writecache_status(struct dm_target *ti, status_type_t type,
 			extra_args += 2;
 		if (wc->autocommit_time_set)
 			extra_args += 2;
-		if (wc->max_age != MAX_AGE_UNSPECIFIED)
+		if (wc->max_age_set)
 			extra_args += 2;
-		if (wc->cleaner)
+		if (wc->cleaner_set)
 			extra_args++;
 		if (wc->writeback_fua_set)
 			extra_args++;
 
 		DMEMIT("%u", extra_args);
-		if (wc->start_sector)
+		if (wc->start_sector_set)
 			DMEMIT(" start_sector %llu", (unsigned long long)wc->start_sector);
-		if (wc->high_wm_percent_set && !wc->cleaner) {
-			x = (uint64_t)wc->freelist_high_watermark * 100;
-			x += wc->n_blocks / 2;
-			do_div(x, (size_t)wc->n_blocks);
-			DMEMIT(" high_watermark %u", 100 - (unsigned)x);
-		}
-		if (wc->low_wm_percent_set && !wc->cleaner) {
-			x = (uint64_t)wc->freelist_low_watermark * 100;
-			x += wc->n_blocks / 2;
-			do_div(x, (size_t)wc->n_blocks);
-			DMEMIT(" low_watermark %u", 100 - (unsigned)x);
-		}
+		if (wc->high_wm_percent_set)
+			DMEMIT(" high_watermark %u", wc->high_wm_percent_value);
+		if (wc->low_wm_percent_set)
+			DMEMIT(" low_watermark %u", wc->low_wm_percent_value);
 		if (wc->max_writeback_jobs_set)
 			DMEMIT(" writeback_jobs %u", wc->max_writeback_jobs);
 		if (wc->autocommit_blocks_set)
 			DMEMIT(" autocommit_blocks %u", wc->autocommit_blocks);
 		if (wc->autocommit_time_set)
-			DMEMIT(" autocommit_time %u", jiffies_to_msecs(wc->autocommit_jiffies));
-		if (wc->max_age != MAX_AGE_UNSPECIFIED)
-			DMEMIT(" max_age %u", jiffies_to_msecs(wc->max_age));
-		if (wc->cleaner)
+			DMEMIT(" autocommit_time %u", wc->autocommit_time_value);
+		if (wc->max_age_set)
+			DMEMIT(" max_age %u", wc->max_age_value);
+		if (wc->cleaner_set)
 			DMEMIT(" cleaner");
 		if (wc->writeback_fua_set)
 			DMEMIT(" %sfua", wc->writeback_fua ? "" : "no");
@@ -2517,7 +2523,7 @@ static void writecache_status(struct dm_target *ti, status_type_t type,
 
 static struct target_type writecache_target = {
 	.name			= "writecache",
-	.version		= {1, 3, 0},
+	.version		= {1, 4, 0},
 	.module			= THIS_MODULE,
 	.ctr			= writecache_ctr,
 	.dtr			= writecache_dtr,

