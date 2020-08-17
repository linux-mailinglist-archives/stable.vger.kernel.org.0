Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E642466F9
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgHQNIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbgHQNH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:07:56 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB23C061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:07:56 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id 2so7795322pjx.5
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=G4GA0D4igj300bLkoB6/sg15ML4RgkhUlWeJnOIJahc=;
        b=fuKhvlf0wmohnzGM4EMtWwJglJ7LZ+4FjogN2lgnp5NeaCPmm9B8LqLMEyFP1ryvy6
         89q9pSWb74xSKOWPkguMioZkjrYYV2KiTiGfgPEEgFOFVVZ8y0Mfp5W2PaEC5gWo5sI4
         nKGcBxogeNjZqTyyvHrZP/BICIFmicsrA4AQPsG7AuJADhxsy5/torzcmYHEuT2aHhia
         l9hZ9v6McAr1HYuUjpDeFg9K878cGX46cCYEIWygROS+0xY/kAHx6n0eu/Bjo6TjZVz5
         BGw3QU/XspC7bxgy5nm7tFN+oGPN/doV4H9C9R9W8yxqfnHuxnuw/KDu2iN8jKbDqLyS
         B80g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=G4GA0D4igj300bLkoB6/sg15ML4RgkhUlWeJnOIJahc=;
        b=PV6P/6lgfIGz8/7Omb61RkPlDETRPQ/3DVQmQS6Ca9oPDpoWOv9X1GpGZ0QJeyaYzy
         gn4xgSJRTV96FkFa2r41u7PIyjS9TCl/l4MWQCVd+EasfUBmOqHF/V5SVqW/P2BaOGP0
         Sljmfvudguh9K5xiBbMVPWQ2kGBhz3UHBw5/o7J6CO1turowyRGg/1umTxe/U8j8Y1OP
         +cVkHgzDPv+ZzFVfEHxwyszCJGeolEQhX1l3ek8dArGz9UtHDd1SFRudkAVc19hp4Jz9
         0KkUMyjG1x6Ew630bvB7SxZYEzGPJpmVrh7m7dRQWcoltxpJ9FILZOCrnREGikPPoJgc
         1Kyw==
X-Gm-Message-State: AOAM533rvyKQshZtVy2LgXHWs40AdN4mxbhD2w8tYD92mMurlUlmoFyh
        Nr0RhSo/T6DKv7ZN2nit5+gWOvL8MWX+Xw==
X-Google-Smtp-Source: ABdhPJwr5rW8trrvoUAzA/NisNAIc19L8/ZiqnNLn8Ub9r0ArXN/MylNbETJiwFgPa3WP0SpFmy+vA==
X-Received: by 2002:a17:902:ba8e:: with SMTP id k14mr10281777pls.256.1597669675395;
        Mon, 17 Aug 2020 06:07:55 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ff2c:a74f:a461:daa2? ([2605:e000:100e:8c61:ff2c:a74f:a461:daa2])
        by smtp.gmail.com with ESMTPSA id b22sm20216168pfb.52.2020.08.17.06.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 06:07:54 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: enable lookup of links holding
 inflight files" failed to apply to 5.8-stable tree
From:   Jens Axboe <axboe@kernel.dk>
To:     gregkh@linuxfoundation.org, josef.grieb@gmail.com
Cc:     stable@vger.kernel.org
References: <159766102815889@kroah.com>
 <bac8dccd-1a06-50a2-729d-8421aed4455d@kernel.dk>
Message-ID: <0f227a86-52fc-3fbf-12c8-d896466790bf@kernel.dk>
Date:   Mon, 17 Aug 2020 06:07:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bac8dccd-1a06-50a2-729d-8421aed4455d@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------11970608C9E8A9C8F83BC374"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------11970608C9E8A9C8F83BC374
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 8/17/20 6:05 AM, Jens Axboe wrote:
> On 8/17/20 3:43 AM, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.8-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
> 
> Needs a prep patch, please apply these two (last one being this patch).

Sorry, sent the wrong one, here's the right 2nd patch.

-- 
Jens Axboe


--------------11970608C9E8A9C8F83BC374
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-enable-lookup-of-links-holding-inflight-fil.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-io_uring-enable-lookup-of-links-holding-inflight-fil.pa";
 filename*1="tch"

From 782e1b66f57b519088539381733412d816016507 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Wed, 12 Aug 2020 17:33:30 -0600
Subject: [PATCH] io_uring: enable lookup of links holding inflight files

When a process exits, we cancel whatever requests it has pending that
are referencing the file table. However, if a link is holding a
reference, then we cannot find it by simply looking at the inflight
list.

Enable checking of the poll and timeout list to find the link, and
cancel it appropriately.

Cc: stable@vger.kernel.org
Reported-by: Josef <josef.grieb@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 97 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f81a22178d35..3da73e58759e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4553,6 +4553,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(req->ctx);
 		req->flags |= REQ_F_COMP_LOCKED;
+		req_set_fail_links(req);
 		io_put_req(req);
 	}
 
@@ -4726,6 +4727,23 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
+static int __io_timeout_cancel(struct io_kiocb *req)
+{
+	int ret;
+
+	list_del_init(&req->list);
+
+	ret = hrtimer_try_to_cancel(&req->io->timeout.timer);
+	if (ret == -1)
+		return -EALREADY;
+
+	req_set_fail_links(req);
+	req->flags |= REQ_F_COMP_LOCKED;
+	io_cqring_fill_event(req, -ECANCELED);
+	io_put_req(req);
+	return 0;
+}
+
 static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 {
 	struct io_kiocb *req;
@@ -4733,7 +4751,6 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 
 	list_for_each_entry(req, &ctx->timeout_list, list) {
 		if (user_data == req->user_data) {
-			list_del_init(&req->list);
 			ret = 0;
 			break;
 		}
@@ -4742,15 +4759,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 	if (ret == -ENOENT)
 		return ret;
 
-	ret = hrtimer_try_to_cancel(&req->io->timeout.timer);
-	if (ret == -1)
-		return -EALREADY;
-
-	req_set_fail_links(req);
-	req->flags |= REQ_F_COMP_LOCKED;
-	io_cqring_fill_event(req, -ECANCELED);
-	io_put_req(req);
-	return 0;
+	return __io_timeout_cancel(req);
 }
 
 static int io_timeout_remove_prep(struct io_kiocb *req,
@@ -7506,6 +7515,71 @@ static bool io_wq_files_match(struct io_wq_work *work, void *data)
 	return work->files == files;
 }
 
+/*
+ * Returns true if 'preq' is the link parent of 'req'
+ */
+static bool io_match_link(struct io_kiocb *preq, struct io_kiocb *req)
+{
+	struct io_kiocb *link;
+
+	if (!(preq->flags & REQ_F_LINK_HEAD))
+		return false;
+
+	list_for_each_entry(link, &preq->link_list, link_list) {
+		if (link == req)
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * We're looking to cancel 'req' because it's holding on to our files, but
+ * 'req' could be a link to another request. See if it is, and cancel that
+ * parent request if so.
+ */
+static bool io_poll_remove_link(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	struct hlist_node *tmp;
+	struct io_kiocb *preq;
+	bool found = false;
+	int i;
+
+	spin_lock_irq(&ctx->completion_lock);
+	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
+		struct hlist_head *list;
+
+		list = &ctx->cancel_hash[i];
+		hlist_for_each_entry_safe(preq, tmp, list, hash_node) {
+			found = io_match_link(preq, req);
+			if (found) {
+				io_poll_remove_one(preq);
+				break;
+			}
+		}
+	}
+	spin_unlock_irq(&ctx->completion_lock);
+	return found;
+}
+
+static bool io_timeout_remove_link(struct io_ring_ctx *ctx,
+				   struct io_kiocb *req)
+{
+	struct io_kiocb *preq;
+	bool found = false;
+
+	spin_lock_irq(&ctx->completion_lock);
+	list_for_each_entry(preq, &ctx->timeout_list, list) {
+		found = io_match_link(preq, req);
+		if (found) {
+			__io_timeout_cancel(preq);
+			break;
+		}
+	}
+	spin_unlock_irq(&ctx->completion_lock);
+	return found;
+}
+
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
@@ -7563,6 +7637,9 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			}
 		} else {
 			io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
+			/* could be a link, check and remove if it is */
+			if (!io_poll_remove_link(ctx, cancel_req))
+				io_timeout_remove_link(ctx, cancel_req);
 			io_put_req(cancel_req);
 		}
 
-- 
2.28.0


--------------11970608C9E8A9C8F83BC374--
