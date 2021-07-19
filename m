Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33A13CDB03
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244406AbhGSOkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:40:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20549 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343695AbhGSOji (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 10:39:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626708017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k1yE9CLSEN1yVz7OMtChbYmnMsmH9w79NcAk1nIAD8s=;
        b=deE7AXhxMUw3laN4Nd9AXAUvV5mnInphV2v00GA2PTBH37tNHywMvH+uqAX94S8A290Buk
        RBBmzwCrB6bP9Rlpgl/TqmgfBDNfX/GwysllmGZf4Sue3Aj6SRxIosnyu3bdBCk0nlaShS
        Jy8eOIciJEUfXeAzg8bjaYiOW9OBMso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-cUXKQBaENn-cHciDw7FeNw-1; Mon, 19 Jul 2021 11:20:16 -0400
X-MC-Unique: cUXKQBaENn-cHciDw7FeNw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DEEE8018A7;
        Mon, 19 Jul 2021 15:20:15 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 089305C1C5;
        Mon, 19 Jul 2021 15:20:10 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 16JFKAwq018025;
        Mon, 19 Jul 2021 11:20:10 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 16JFKAuE018021;
        Mon, 19 Jul 2021 11:20:10 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Mon, 19 Jul 2021 11:20:10 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     gregkh@linuxfoundation.org
cc:     snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm writecache: return the exact table
 values that were set" failed to apply to 4.19-stable tree
In-Reply-To: <1614606337101246@kroah.com>
Message-ID: <alpine.LRH.2.02.2107191118460.17791@file01.intranet.prod.int.rdu2.redhat.com>
References: <1614606337101246@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Mon, 1 Mar 2021, gregkh@linuxfoundation.org wrote:

> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Hi

This is backport of the patch 054bee16163df023e2589db09fd27d81f7ad9e72 for
the stable branches 4.19 and 5.4.

Mikulas




commit 054bee16163df023e2589db09fd27d81f7ad9e72
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Thu Feb 4 05:20:52 2021 -0500

    dm writecache: return the exact table values that were set
    
    LVM doesn't like it when the target returns different values from what
    was set in the constructor. Fix dm-writecache so that the returned
    table values are exactly the same as requested values.
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Cc: stable@vger.kernel.org # v4.18+
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

---
 drivers/md/dm-writecache.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

Index: linux-stable/drivers/md/dm-writecache.c
===================================================================
--- linux-stable.orig/drivers/md/dm-writecache.c	2021-07-18 20:54:39.000000000 +0200
+++ linux-stable/drivers/md/dm-writecache.c	2021-07-18 20:59:05.000000000 +0200
@@ -154,6 +154,7 @@ struct dm_writecache {
 	bool overwrote_committed:1;
 	bool memory_vmapped:1;
 
+	bool start_sector_set:1;
 	bool high_wm_percent_set:1;
 	bool low_wm_percent_set:1;
 	bool max_writeback_jobs_set:1;
@@ -162,6 +163,10 @@ struct dm_writecache {
 	bool writeback_fua_set:1;
 	bool flush_on_suspend:1;
 
+	unsigned high_wm_percent_value;
+	unsigned low_wm_percent_value;
+	unsigned autocommit_time_value;
+
 	unsigned writeback_all;
 	struct workqueue_struct *writeback_wq;
 	struct work_struct writeback_work;
@@ -2069,6 +2074,7 @@ static int writecache_ctr(struct dm_targ
 			if (sscanf(string, "%llu%c", &start_sector, &dummy) != 1)
 				goto invalid_optional;
 			wc->start_sector = start_sector;
+			wc->start_sector_set = true;
 			if (wc->start_sector != start_sector ||
 			    wc->start_sector >= wc->memory_map_size >> SECTOR_SHIFT)
 				goto invalid_optional;
@@ -2078,6 +2084,7 @@ static int writecache_ctr(struct dm_targ
 				goto invalid_optional;
 			if (high_wm_percent < 0 || high_wm_percent > 100)
 				goto invalid_optional;
+			wc->high_wm_percent_value = high_wm_percent;
 			wc->high_wm_percent_set = true;
 		} else if (!strcasecmp(string, "low_watermark") && opt_params >= 1) {
 			string = dm_shift_arg(&as), opt_params--;
@@ -2085,6 +2092,7 @@ static int writecache_ctr(struct dm_targ
 				goto invalid_optional;
 			if (low_wm_percent < 0 || low_wm_percent > 100)
 				goto invalid_optional;
+			wc->low_wm_percent_value = low_wm_percent;
 			wc->low_wm_percent_set = true;
 		} else if (!strcasecmp(string, "writeback_jobs") && opt_params >= 1) {
 			string = dm_shift_arg(&as), opt_params--;
@@ -2104,6 +2112,7 @@ static int writecache_ctr(struct dm_targ
 			if (autocommit_msecs > 3600000)
 				goto invalid_optional;
 			wc->autocommit_jiffies = msecs_to_jiffies(autocommit_msecs);
+			wc->autocommit_time_value = autocommit_msecs;
 			wc->autocommit_time_set = true;
 		} else if (!strcasecmp(string, "fua")) {
 			if (WC_MODE_PMEM(wc)) {
@@ -2305,7 +2314,6 @@ static void writecache_status(struct dm_
 	struct dm_writecache *wc = ti->private;
 	unsigned extra_args;
 	unsigned sz = 0;
-	uint64_t x;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -2317,7 +2325,7 @@ static void writecache_status(struct dm_
 		DMEMIT("%c %s %s %u ", WC_MODE_PMEM(wc) ? 'p' : 's',
 				wc->dev->name, wc->ssd_dev->name, wc->block_size);
 		extra_args = 0;
-		if (wc->start_sector)
+		if (wc->start_sector_set)
 			extra_args += 2;
 		if (wc->high_wm_percent_set)
 			extra_args += 2;
@@ -2333,26 +2341,18 @@ static void writecache_status(struct dm_
 			extra_args++;
 
 		DMEMIT("%u", extra_args);
-		if (wc->start_sector)
+		if (wc->start_sector_set)
 			DMEMIT(" start_sector %llu", (unsigned long long)wc->start_sector);
-		if (wc->high_wm_percent_set) {
-			x = (uint64_t)wc->freelist_high_watermark * 100;
-			x += wc->n_blocks / 2;
-			do_div(x, (size_t)wc->n_blocks);
-			DMEMIT(" high_watermark %u", 100 - (unsigned)x);
-		}
-		if (wc->low_wm_percent_set) {
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
+			DMEMIT(" autocommit_time %u", wc->autocommit_time_value);
 		if (wc->writeback_fua_set)
 			DMEMIT(" %sfua", wc->writeback_fua ? "" : "no");
 		break;

