Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7677444F895
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 15:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhKNOm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 09:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbhKNOm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Nov 2021 09:42:26 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D40DC061207
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 06:39:30 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id m9so17897432iop.0
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 06:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=p3y3m7+PUpR378v9tDILBwB7V994BIu+BeKwrParIrA=;
        b=j62KPqkdPXM+PKqMjpvnC/dAYailUxwEHj8E+XQRgDagS7QGotG4dbfHF7hVQWl+y7
         5gDlhX9q8biEPoIk72+NrDMj5hAjZ48N8U1L1nBl+mIWrpPQ4oUVgH5vOP6AJpbdCMFV
         s6bKJpx8aXwSkQmeYFvHRlr47XqIoI0OHSum2iuFQ8GQXCJoStpNAyDLfabBPcb+IUmX
         i0UZ8Fc/5t4J3yan5vbr+uiKJhDz5CSPegOJlDTTEXc6YCwbp164Yz1KwHOwrAqTD7PB
         uIq0uXiyQcTPEh+eE636I6aqzWgXJsToa/9ce3BFZCc7+P+4NFTfF+mxBrq3E9wqHPk/
         r12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=p3y3m7+PUpR378v9tDILBwB7V994BIu+BeKwrParIrA=;
        b=TWk12wCj/DKp9ctK9y85Ci8GX+HbNpgoXIoDLpuXA00CXPOpFN/A5dNiyfT4898vgC
         wcZgNtIPt63pyDq58gn5JUO6HaHxtrAvexeI7+X93/fcTrzpe4Du0Bagp7RgxVvnz9RA
         /wLUKvTDNY7aJuSkPOJus+r7FNpVBYAOFtjOAN3kWCDFuALhM9Mxxbg7snBMH6AF77t8
         GlqCuRJJs91I63iir7XvaT+UH9TVCVBG3fmyKUN2RRCD43A7dtrSNySQITDyW6RgArbd
         M8oyDzfJKMhLZdOIRNLx9cmxWJOjMg8zByX9gBPG3+rTVKZJOwtva1IH0WNOQp8Qf5Y6
         KrjQ==
X-Gm-Message-State: AOAM530Cq3FGQ4LCIMaAaQyav2prX+GDMsLoN9KwfSz1BBUxlrQ7DkYY
        T+vOVUW6Lhs0wKmmsvsuNwK8BKapln3QLVWI
X-Google-Smtp-Source: ABdhPJwPxPCMB8PrEEGalXU8CRU45M5y0A0ZErcOFxBxNE/lQJNf1JRHFRtYxWO1lUFpISN3ZQlAhw==
X-Received: by 2002:a05:6602:2cd4:: with SMTP id j20mr8505677iow.106.1636900769167;
        Sun, 14 Nov 2021 06:39:29 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y3sm7893908ilv.5.2021.11.14.06.39.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Nov 2021 06:39:28 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] io-wq: serialize hash clear with wakeup"
 failed to apply to 5.14-stable tree
To:     gregkh@linuxfoundation.org, daniel@mariadb.org
Cc:     stable@vger.kernel.org
References: <1636899953125228@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2b04ecb8-0c06-005e-115d-296ecbf41a4f@kernel.dk>
Date:   Sun, 14 Nov 2021 07:39:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1636899953125228@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------CD9FD6FD20A923EBEF763635"
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------CD9FD6FD20A923EBEF763635
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 11/14/21 7:25 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This needs a few more backports - here are two backports that it depends
on, and then this one backported as well.

-- 
Jens Axboe


--------------CD9FD6FD20A923EBEF763635
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-io-wq-serialize-hash-clear-with-wakeup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-io-wq-serialize-hash-clear-with-wakeup.patch"

From 32d9a0f2e60679746c1fbb9488b59273c641a1ad Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sun, 14 Nov 2021 07:36:47 -0700
Subject: [PATCH 3/3] io-wq: serialize hash clear with wakeup

commit d3e3c102d107bb84251455a298cf475f24bab995 upstream.

We need to ensure that we serialize the stalled and hash bits with the
wait_queue wait handler, or we could be racing with someone modifying
the hashed state after we find it busy, but before we then give up and
wait for it to be cleared. This can cause random delays or stalls when
handling buffered writes for many files, where some of these files cause
hash collisions between the worker threads.

Cc: stable@vger.kernel.org
Reported-by: Daniel Black <daniel@mariadb.org>
Fixes: e941894eae31 ("io-wq: make buffered file write hashed work map per-ctx")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 3ddad5f46114..0890d85ba285 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -401,9 +401,10 @@ static inline unsigned int io_get_work_hash(struct io_wq_work *work)
 	return work->flags >> IO_WQ_HASH_SHIFT;
 }
 
-static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
+static bool io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 {
 	struct io_wq *wq = wqe->wq;
+	bool ret = false;
 
 	spin_lock_irq(&wq->hash->wait.lock);
 	if (list_empty(&wqe->wait.entry)) {
@@ -411,9 +412,11 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 		if (!test_bit(hash, &wq->hash->map)) {
 			__set_current_state(TASK_RUNNING);
 			list_del_init(&wqe->wait.entry);
+			ret = true;
 		}
 	}
 	spin_unlock_irq(&wq->hash->wait.lock);
+	return ret;
 }
 
 /*
@@ -474,14 +477,21 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
 	}
 
 	if (stall_hash != -1U) {
+		bool unstalled;
+
 		/*
 		 * Set this before dropping the lock to avoid racing with new
 		 * work being added and clearing the stalled bit.
 		 */
 		wqe->flags |= IO_WQE_FLAG_STALLED;
 		raw_spin_unlock(&wqe->lock);
-		io_wait_on_hash(wqe, stall_hash);
+		unstalled = io_wait_on_hash(wqe, stall_hash);
 		raw_spin_lock(&wqe->lock);
+		if (unstalled) {
+			wqe->flags &= ~IO_WQE_FLAG_STALLED;
+			if (wq_has_sleeper(&wqe->wq->hash->wait))
+				wake_up(&wqe->wq->hash->wait);
+		}
 	}
 
 	return NULL;
@@ -562,11 +572,14 @@ static void io_worker_handle_work(struct io_worker *worker)
 				io_wqe_enqueue(wqe, linked);
 
 			if (hash != -1U && !next_hashed) {
+				/* serialize hash clear with wake_up() */
+				spin_lock_irq(&wq->hash->wait.lock);
 				clear_bit(hash, &wq->hash->map);
+				wqe->flags &= ~IO_WQE_FLAG_STALLED;
+				spin_unlock_irq(&wq->hash->wait.lock);
 				if (wq_has_sleeper(&wq->hash->wait))
 					wake_up(&wq->hash->wait);
 				raw_spin_lock_irq(&wqe->lock);
-				wqe->flags &= ~IO_WQE_FLAG_STALLED;
 				/* skip unnecessary unlock-lock wqe->lock */
 				if (!work)
 					goto get_next;
-- 
2.33.1


--------------CD9FD6FD20A923EBEF763635
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io-wq-ensure-that-hash-wait-lock-is-IRQ-disabling.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io-wq-ensure-that-hash-wait-lock-is-IRQ-disabling.patch"

From bd0e0402c3cc5299703ac59ddc04f795b9fbcbd0 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 31 Aug 2021 06:57:25 -0600
Subject: [PATCH 1/3] io-wq: ensure that hash wait lock is IRQ disabling

commit 08bdbd39b58474d762242e1fadb7f2eb9ffcca71 upstream.

A previous commit removed the IRQ safety of the worker and wqe locks,
but that left one spot of the hash wait lock now being done without
already having IRQs disabled.

Ensure that we use the right locking variant for the hashed waitqueue
lock.

Fixes: a9a4aa9fbfc5 ("io-wq: wqe and worker locks no longer need to be IRQ safe")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index cb5d84f6b769..4f460797f962 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -405,7 +405,7 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 {
 	struct io_wq *wq = wqe->wq;
 
-	spin_lock(&wq->hash->wait.lock);
+	spin_lock_irq(&wq->hash->wait.lock);
 	if (list_empty(&wqe->wait.entry)) {
 		__add_wait_queue(&wq->hash->wait, &wqe->wait);
 		if (!test_bit(hash, &wq->hash->map)) {
@@ -413,7 +413,7 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 			list_del_init(&wqe->wait.entry);
 		}
 	}
-	spin_unlock(&wq->hash->wait.lock);
+	spin_unlock_irq(&wq->hash->wait.lock);
 }
 
 /*
-- 
2.33.1


--------------CD9FD6FD20A923EBEF763635
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io-wq-fix-queue-stalling-race.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-io-wq-fix-queue-stalling-race.patch"

From 955c228ba82f86c5c20fd9c56403f4abb0d7e384 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 31 Aug 2021 13:53:00 -0600
Subject: [PATCH 2/3] io-wq: fix queue stalling race

commit 0242f6426ea78fbe3933b44f8c55ae93ec37f6cc upstream.

We need to set the stalled bit early, before we drop the lock for adding
us to the stall hash queue. If not, then we can race with new work being
queued between adding us to the stall hash and io_worker_handle_work()
marking us stalled.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 4f460797f962..3ddad5f46114 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -436,8 +436,7 @@ static bool io_worker_can_run_work(struct io_worker *worker,
 }
 
 static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
-					   struct io_worker *worker,
-					   bool *stalled)
+					   struct io_worker *worker)
 	__must_hold(wqe->lock)
 {
 	struct io_wq_work_node *node, *prev;
@@ -475,10 +474,14 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
 	}
 
 	if (stall_hash != -1U) {
+		/*
+		 * Set this before dropping the lock to avoid racing with new
+		 * work being added and clearing the stalled bit.
+		 */
+		wqe->flags |= IO_WQE_FLAG_STALLED;
 		raw_spin_unlock(&wqe->lock);
 		io_wait_on_hash(wqe, stall_hash);
 		raw_spin_lock(&wqe->lock);
-		*stalled = true;
 	}
 
 	return NULL;
@@ -518,7 +521,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 
 	do {
 		struct io_wq_work *work;
-		bool stalled;
 get_next:
 		/*
 		 * If we got some work, mark us as busy. If we didn't, but
@@ -527,12 +529,9 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		stalled = false;
-		work = io_get_next_work(wqe, worker, &stalled);
+		work = io_get_next_work(wqe, worker);
 		if (work)
 			__io_worker_busy(wqe, worker, work);
-		else if (stalled)
-			wqe->flags |= IO_WQE_FLAG_STALLED;
 
 		raw_spin_unlock_irq(&wqe->lock);
 		if (!work)
-- 
2.33.1


--------------CD9FD6FD20A923EBEF763635--
