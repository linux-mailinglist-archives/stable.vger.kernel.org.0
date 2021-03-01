Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77843328270
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 16:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbhCAP2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 10:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237055AbhCAP2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 10:28:10 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D80C061756
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 07:27:30 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id jt13so28980796ejb.0
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 07:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arrikto-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=qR57te9HOz8RQAqqNS7jd/j1PdDncDFVkKv9qjQxrQA=;
        b=U8XvDbVRAoEvASlF677vY6xXfzSS9o1E8mULNjq6rXirf1Dp4Txmi/K3T5dCCSwlxR
         4+61LOkTW2VU//DpGQafxa/AQGUuR0+JbSO7vHTWMAIO18X3TB8PGkkkD6zswrnE/Yl7
         mpXAiRHzWdisBS5sghM3gBMKQMpVPGGf7gEIN743aZbqxff3zokQHVuMUg36DsORYrKC
         vdWl0YTD3tDMVlWZTZxZEM68jDIrePn3XHQhCckPx12NrXlm6Jw0G1yC9n65so9mqZd2
         6eKD9/CxETPfA2taAJ30pZSn4nD0s16bp7wU8syzbyHCXOGRFoZPA2vwSn5IrPq7UvVH
         l8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=qR57te9HOz8RQAqqNS7jd/j1PdDncDFVkKv9qjQxrQA=;
        b=IcG63piqi3C4t622Ui9cznjbFPCi1DR82t1/cNy3FRDm+QYT/hgAzfH3q9BcVquezK
         gsuev/nrxOQWFDH+N6TNX4bHlX9RjQrNBsUAKONpIHpVHrACv4o54HcaKDYYXY1VBTxi
         FdpErrt/reVvnUw7LOgGFFr2UgYT2VPyqljLTajEH95p0REHEFdoPmXBEMYLtdPMHHea
         o4uVbgut6kjD1CAW7QzfDdTvNUjT20edYr13WRQIBXF66RQ6dntoWf436gObq/XTDWpA
         TGCm4jX51FdI1eXqIn2vNMWBtY36/Oa58I7snAxNhe+2+gRnmwzWssrgEOnpXMMeXcMn
         n1rA==
X-Gm-Message-State: AOAM530OFS/csOVWbwPbWy52YyE6gHEK2XSDsSDodblCigfkKTBXawCi
        M4QV+y9/QTIT9QLpL4ipFdXdSeFIWiGbMQ==
X-Google-Smtp-Source: ABdhPJwXIw4t9n+Pki2/ses4caFBMHTvByhu+SlnkPGeLRaFk04OS+EeJp0RUGREn+YhCxI/wQ5cRg==
X-Received: by 2002:a17:906:1907:: with SMTP id a7mr16541355eje.142.1614612448439;
        Mon, 01 Mar 2021 07:27:28 -0800 (PST)
Received: from [172.16.10.100] (130.43.22.10.dsl.dyn.forthnet.gr. [130.43.22.10])
        by smtp.gmail.com with ESMTPSA id g25sm5078328edp.95.2021.03.01.07.27.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 07:27:27 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] dm era: Update in-core bitset after
 committing the metadata" failed to apply to 5.4-stable tree
To:     gregkh@linuxfoundation.org, snitzer@redhat.com
Cc:     stable@vger.kernel.org
References: <161460644719394@kroah.com>
From:   Nikos Tsironis <ntsironis@arrikto.com>
Message-ID: <e8307822-5358-c3e3-7361-481034d0685e@arrikto.com>
Date:   Mon, 1 Mar 2021 17:27:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <161460644719394@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------56D739330ED4552A256122A7"
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------56D739330ED4552A256122A7
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/21 3:47 PM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
Hi Greg,

Attached is the backport, which applies to all stable branches until
4.4-stable.

Thanks,
Nikos

--------------56D739330ED4552A256122A7
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-dm-era-Update-in-core-bitset-after-committing-the-me.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-dm-era-Update-in-core-bitset-after-committing-the-me.pa";
 filename*1="tch"

From e08d6f2b4a5c568a7e08a5d76c9c9bd677713a64 Mon Sep 17 00:00:00 2001
From: Nikos Tsironis <ntsironis@arrikto.com>
Date: Fri, 22 Jan 2021 17:19:31 +0200
Subject: [PATCH] dm era: Update in-core bitset after committing the metadata

commit 2099b145d77c1d53f5711f029c37cc537897cee6 upstream.

In case of a system crash, dm-era might fail to mark blocks as written
in its metadata, although the corresponding writes to these blocks were
passed down to the origin device and completed successfully.

Consider the following sequence of events:

1. We write to a block that has not been yet written in the current era
2. era_map() checks the in-core bitmap for the current era and sees
   that the block is not marked as written.
3. The write is deferred for submission after the metadata have been
   updated and committed.
4. The worker thread processes the deferred write
   (process_deferred_bios()) and marks the block as written in the
   in-core bitmap, **before** committing the metadata.
5. The worker thread starts committing the metadata.
6. We do more writes that map to the same block as the write of step (1)
7. era_map() checks the in-core bitmap and sees that the block is marked
   as written, **although the metadata have not been committed yet**.
8. These writes are passed down to the origin device immediately and the
   device reports them as completed.
9. The system crashes, e.g., power failure, before the commit from step
   (5) finishes.

When the system recovers and we query the dm-era target for the list of
written blocks it doesn't report the aforementioned block as written,
although the writes of step (6) completed successfully.

The issue is that era_map() decides whether to defer or not a write
based on non committed information. The root cause of the bug is that we
update the in-core bitmap, **before** committing the metadata.

Fix this by updating the in-core bitmap **after** successfully
committing the metadata.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-era-target.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index bdb84b8e7162..72dc046fd8f9 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -134,7 +134,7 @@ static int writeset_test_and_set(struct dm_disk_bitset *info,
 {
 	int r;
 
-	if (!test_and_set_bit(block, ws->bits)) {
+	if (!test_bit(block, ws->bits)) {
 		r = dm_bitset_set_bit(info, ws->md.root, block, &ws->md.root);
 		if (r) {
 			/* FIXME: fail mode */
@@ -1226,8 +1226,10 @@ static void process_deferred_bios(struct era *era)
 	int r;
 	struct bio_list deferred_bios, marked_bios;
 	struct bio *bio;
+	struct blk_plug plug;
 	bool commit_needed = false;
 	bool failed = false;
+	struct writeset *ws = era->md->current_writeset;
 
 	bio_list_init(&deferred_bios);
 	bio_list_init(&marked_bios);
@@ -1237,9 +1239,11 @@ static void process_deferred_bios(struct era *era)
 	bio_list_init(&era->deferred_bios);
 	spin_unlock(&era->deferred_lock);
 
+	if (bio_list_empty(&deferred_bios))
+		return;
+
 	while ((bio = bio_list_pop(&deferred_bios))) {
-		r = writeset_test_and_set(&era->md->bitset_info,
-					  era->md->current_writeset,
+		r = writeset_test_and_set(&era->md->bitset_info, ws,
 					  get_block(era, bio));
 		if (r < 0) {
 			/*
@@ -1247,7 +1251,6 @@ static void process_deferred_bios(struct era *era)
 			 * FIXME: finish.
 			 */
 			failed = true;
-
 		} else if (r == 0)
 			commit_needed = true;
 
@@ -1263,9 +1266,19 @@ static void process_deferred_bios(struct era *era)
 	if (failed)
 		while ((bio = bio_list_pop(&marked_bios)))
 			bio_io_error(bio);
-	else
-		while ((bio = bio_list_pop(&marked_bios)))
+	else {
+		blk_start_plug(&plug);
+		while ((bio = bio_list_pop(&marked_bios))) {
+			/*
+			 * Only update the in-core writeset if the on-disk one
+			 * was updated too.
+			 */
+			if (commit_needed)
+				set_bit(get_block(era, bio), ws->bits);
 			generic_make_request(bio);
+		}
+		blk_finish_plug(&plug);
+	}
 }
 
 static void process_rpc_calls(struct era *era)
-- 
2.11.0


--------------56D739330ED4552A256122A7--
