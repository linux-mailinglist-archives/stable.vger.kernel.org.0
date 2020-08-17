Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE1C246743
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgHQNTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbgHQNTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:19:31 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CA5C061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:19:31 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d22so8230719pfn.5
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=aoImEp/vgbmDgwBwzXzw9HFwlYo2uOF42Ma9yd837pc=;
        b=XJ37dKA5EZdRQKRUDqj/Md425Izc9e8+6m2OX3BYLK5BQN8/3qUsGuhuCcPngfFl8h
         /R7KytrojQZpt7AmnTKGBlOpqpBcZaapmUhxF4fHQkuYSz9FAusFGFvrfIKuj/r4vNms
         hpGo6vpzy43JnmfCIy6EmILMKaCt5bN+mq0Pdikc12ByjqSvudQ6mxqAzz5xyTHa21sr
         uHgTv4OqSLZf/hzV2sAxhYzjHsFzu9CpSxvJZuWpE6b60YxOkzRVUn/jiAPEeR9VDP3w
         kpbIKYt89a2eXg13J7HBGom1fQheC+kb5jmmd9Mn31AL0YJ7gME0MmUcScdnhQUMGfHT
         k8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=aoImEp/vgbmDgwBwzXzw9HFwlYo2uOF42Ma9yd837pc=;
        b=dNpp/C0OSwMSOKkJJjV6oXusMnTCZYomkYKBJLhqPuGcwQ2qSg2ua0XaS80uqWYWlz
         1o7FkyxyL9S6SgTetWjz5T9QKoRqRzkMQDBAv0VtYUEsfTNKTdhREFiRjl6SUd/5a97I
         4Dvnf3dag2X/4votIZPvKsRfnZoTuF3gB9teU38ARtx6kMduzhOzjgWnJmwCQvq7hed5
         kQZJRJb1p1MqIOaJxG4k7/y9eInNTUtCZ95Q3xxTlqbKNYHWYnDx2vB8LVZlFaREzH+y
         c/txRg6RdX7UjloDdaTi4Asp53TwL9snvokvNAc0rWOgVQlj7J6/7UsR0NgJjvCIupgr
         fq9w==
X-Gm-Message-State: AOAM532bJNPfVVK7Hik5B+XfMSSIVg34nx66YqEU3+exE484etpk8tNo
        T0qLXt5kTI2dXQgOkFr37vWpYwd9mGD/TQ==
X-Google-Smtp-Source: ABdhPJwa6untOvTPHxBwRkplYEatW3Dwn6xLMGfTvHlzgALOE0pW81sS+N2NriGZtah1VWVm0EzVSA==
X-Received: by 2002:a62:9246:: with SMTP id o67mr11041011pfd.249.1597670370726;
        Mon, 17 Aug 2020 06:19:30 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ff2c:a74f:a461:daa2? ([2605:e000:100e:8c61:ff2c:a74f:a461:daa2])
        by smtp.gmail.com with ESMTPSA id j8sm20325303pfh.90.2020.08.17.06.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 06:19:29 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: enable lookup of links holding
 inflight files" failed to apply to 5.7-stable tree
To:     gregkh@linuxfoundation.org, josef.grieb@gmail.com
Cc:     stable@vger.kernel.org
References: <1597661027209127@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d56fd7ce-71d5-803e-93de-7f8acfb8ddd6@kernel.dk>
Date:   Mon, 17 Aug 2020 06:19:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1597661027209127@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------20ACC98A01CCC93CC7E4FC6B"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------20ACC98A01CCC93CC7E4FC6B
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 8/17/20 3:43 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.7-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Same as 5.8, needs the prep patch first. Attached the two patches.

-- 
Jens Axboe


--------------20ACC98A01CCC93CC7E4FC6B
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-enable-lookup-of-links-holding-inflight-fil.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-io_uring-enable-lookup-of-links-holding-inflight-fil.pa";
 filename*1="tch"

From 4acdfdda9d161327ed7dd1b5d7a84ed1d4dca24a Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Wed, 12 Aug 2020 17:33:30 -0600
Subject: [PATCH 2/2] io_uring: enable lookup of links holding inflight files

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
index 5b952ca8ecfd..5e6bbcb60fc4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4627,6 +4627,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(req->ctx);
 		req->flags |= REQ_F_COMP_LOCKED;
+		req_set_fail_links(req);
 		io_put_req(req);
 	}
 
@@ -4809,6 +4810,23 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
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
@@ -4816,7 +4834,6 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 
 	list_for_each_entry(req, &ctx->timeout_list, list) {
 		if (user_data == req->user_data) {
-			list_del_init(&req->list);
 			ret = 0;
 			break;
 		}
@@ -4825,15 +4842,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
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
@@ -7572,6 +7581,71 @@ static int io_uring_release(struct inode *inode, struct file *file)
 	return 0;
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
@@ -7622,6 +7696,9 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
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


--------------20ACC98A01CCC93CC7E4FC6B
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-add-missing-REQ_F_COMP_LOCKED-for-nested-re.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-add-missing-REQ_F_COMP_LOCKED-for-nested-re.pa";
 filename*1="tch"

From 4f65a22da4159dae4f6ad27a22cf13f5bd06ecf9 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 17 Aug 2020 06:02:02 -0700
Subject: [PATCH 1/2] io_uring: add missing REQ_F_COMP_LOCKED for nested
 requests

When we traverse into failing links or timeouts, we need to ensure we
propagate the REQ_F_COMP_LOCKED flag to ensure that we correctly signal
to the completion side that we already hold the completion lock.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0e31215f87fe..5b952ca8ecfd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1484,12 +1484,9 @@ static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
 /*
  * Called if REQ_F_LINK_HEAD is set, and we fail the head request
  */
-static void io_fail_links(struct io_kiocb *req)
+static void __io_fail_links(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctx->completion_lock, flags);
 
 	while (!list_empty(&req->link_list)) {
 		struct io_kiocb *link = list_first_entry(&req->link_list,
@@ -1503,13 +1500,29 @@ static void io_fail_links(struct io_kiocb *req)
 			io_link_cancel_timeout(link);
 		} else {
 			io_cqring_fill_event(link, -ECANCELED);
+			link->flags |= REQ_F_COMP_LOCKED;
 			__io_double_put_req(link);
 		}
 		req->flags &= ~REQ_F_LINK_TIMEOUT;
 	}
 
 	io_commit_cqring(ctx);
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+}
+
+static void io_fail_links(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!(req->flags & REQ_F_COMP_LOCKED)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->completion_lock, flags);
+		__io_fail_links(req);
+		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	} else {
+		__io_fail_links(req);
+	}
+
 	io_cqring_ev_posted(ctx);
 }
 
@@ -4817,6 +4830,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 		return -EALREADY;
 
 	req_set_fail_links(req);
+	req->flags |= REQ_F_COMP_LOCKED;
 	io_cqring_fill_event(req, -ECANCELED);
 	io_put_req(req);
 	return 0;
-- 
2.28.0


--------------20ACC98A01CCC93CC7E4FC6B--
