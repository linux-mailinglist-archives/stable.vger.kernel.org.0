Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A172466EF
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgHQNFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728452AbgHQNFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:05:37 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E14BC061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:05:37 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d19so8088721pgl.10
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=osMEurxyM6+UZMjcbyPe+diKT49IS0xinuybOxyKAKE=;
        b=bGNGQ7TYTy0H8I8SkMrwpdBooJOFr9r+9Cyfin1jdWyzxE6s9D6Zb9DV3n+wrJonmf
         JmRxOkEV0EGImMk79iQ5/bJObO8rBT1Ntu2kqLgTpgsqc2RF1pMdPUEha+TmqTOr9PKG
         gqSWczNiiQGaCWylzuURpBe+oBNrlf0SdSYsI0jrJQzOsxL14B0OR8LaYfUc/uPJXB9s
         r+aM/IZ4Qz4bJdVC+xpzBa/1hwJHRZodYYuOeElGvSEwCm2rOpzonvi4Wlaac1wHnwVa
         ig+YPmMHrcsRYyj+X28rKz2E2gOfvpkdMmgJtM+h2k/77JR4hfSW6HF7G4T3FvjklEWv
         VfDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=osMEurxyM6+UZMjcbyPe+diKT49IS0xinuybOxyKAKE=;
        b=AQnTmG4iMQRkGAC/uJVJ8XuJcBA3+DdIi/uD/LDg2JnfWZYwhYO9IOJBJ/4oEzXpoz
         fMR0ehS75srbLDkaxKIao3y5Oyq7Eo3saN8hHbfofF8mGthM77NzekNQhvL0MmDqnFfd
         LxXpoTBSKNeZihsKo3XlODfBdg88DZdn6NO5xECBqMpQSvO0FwaMDa+iB9zXJCNUEJDo
         LS6D8yKC1FrJcuxpW6bKkKoOz5KFHpRiXAoF1AB8bFvB2bcLkTwfU0aW8ECsB73xn18S
         AcpuydFvXRdb248F6u//RO/h7+KPEO/meWcDK0vAzFvgD4VWcW35gSoR7qbdBR3ATaJK
         iEaw==
X-Gm-Message-State: AOAM531bLesGNzGagCZ6etBbMq2o0zxsPrc1PV/PkY8RDpyv/tpLgIQR
        8wlQCptPCqIrKR802M4QqLPRkFtbQDI70g==
X-Google-Smtp-Source: ABdhPJwkBwQJ0un42JR7AM2/AlDyIB6C6N7xt2AF+aZ4vER6RNg+RHLUjpJ7D56iHJ2ZGH8Xz7dccA==
X-Received: by 2002:aa7:8a50:: with SMTP id n16mr11292770pfa.81.1597669536631;
        Mon, 17 Aug 2020 06:05:36 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ff2c:a74f:a461:daa2? ([2605:e000:100e:8c61:ff2c:a74f:a461:daa2])
        by smtp.gmail.com with ESMTPSA id n17sm17161829pgg.6.2020.08.17.06.05.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 06:05:35 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: enable lookup of links holding
 inflight files" failed to apply to 5.8-stable tree
To:     gregkh@linuxfoundation.org, josef.grieb@gmail.com
Cc:     stable@vger.kernel.org
References: <159766102815889@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bac8dccd-1a06-50a2-729d-8421aed4455d@kernel.dk>
Date:   Mon, 17 Aug 2020 06:05:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159766102815889@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------565CD51A4A209CE27DF7ABC9"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------565CD51A4A209CE27DF7ABC9
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 8/17/20 3:43 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.8-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,

Needs a prep patch, please apply these two (last one being this patch).

-- 
Jens Axboe


--------------565CD51A4A209CE27DF7ABC9
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-enable-lookup-of-links-holding-inflight-fil.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-io_uring-enable-lookup-of-links-holding-inflight-fil.pa";
 filename*1="tch"

From c639acbb614717332b1e76886a75883b0f7b0f28 Mon Sep 17 00:00:00 2001
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
index f81a22178d35..895365efa280 100644
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
+	list_del_init(&req->timeout.list);
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
+	list_for_each_entry(preq, &ctx->timeout_list, timeout.list) {
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


--------------565CD51A4A209CE27DF7ABC9
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-add-missing-REQ_F_COMP_LOCKED-for-nested-re.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-add-missing-REQ_F_COMP_LOCKED-for-nested-re.pa";
 filename*1="tch"

From f28a41d9cde2ccb398a57659dfa349aa09e74249 Mon Sep 17 00:00:00 2001
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
index 3c21e2e002b4..f81a22178d35 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1549,12 +1549,9 @@ static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
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
@@ -1568,13 +1565,29 @@ static void io_fail_links(struct io_kiocb *req)
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
 
@@ -4734,6 +4747,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 		return -EALREADY;
 
 	req_set_fail_links(req);
+	req->flags |= REQ_F_COMP_LOCKED;
 	io_cqring_fill_event(req, -ECANCELED);
 	io_put_req(req);
 	return 0;
-- 
2.28.0


--------------565CD51A4A209CE27DF7ABC9--
