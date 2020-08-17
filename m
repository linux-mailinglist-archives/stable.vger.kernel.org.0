Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6CD24673B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgHQNQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728643AbgHQNPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:15:38 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C1AC061346
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:15:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mt12so7813168pjb.4
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=pqRvMxaf6fBI2wdZfTVrDn6OG/Cl9eNa8xJGx9YZnaI=;
        b=zMRTW0Mu8588S870aRg9/wp0oy1AF7+j9o2yKejWkxgy+AuwD6ZCTcAH6lssr84iZy
         FVYsJvHV1RcSHE3gc8Nem22tcP9RyDJ/VYtSod4I4OZJyuUXZcTsYhE8uF5xHpgcfJgo
         jcEcT7Klxh8lHYauyr0tDjMhYeYCxUCS6j2SjwQYZD+v2yPBPS29FyHXG3SEeQOK54j2
         r929UBiDD59V2qa1o7HFqa6qBBrNS6QM4x7yab5kK3i3Uc7Vb1k4KI4AhmNIwIryQ3iZ
         tUOBjh6yKr6zsalYXJjdkSvKU0yds8254AZJDhCZORxZJgatXrjLWAilb5/jOhzWPnaR
         jL8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=pqRvMxaf6fBI2wdZfTVrDn6OG/Cl9eNa8xJGx9YZnaI=;
        b=EE3ChG6UOi32Rp191AMXcPD2HVu3yXBD3d0ZkslUxMnI9pPIPRudZH5+YF/PbGyO50
         V7ZXq3/mmOHPd14sbQ69+8ZKUUn0J+2tZ/+wMTdYFHe4ftR5LJ6i+HAGycydU+8fijzH
         V0h6r7u/cPC1WkZkOi3Q7kbdNuKOtZMVaO7JmZXvj3pP6wzd/GZudq8Cpz6OvRGwlJUo
         BYo2vHOAxSoJIQMbxnMiaXBtkaBDOlNsGosKd0z+MJcCIClvIeYmvzserlFLq1/wCCaU
         fU4b8gMmZdSTr4Agsc3OdbPUeQlyR0Qs6fvpsntJegbpakVCqNUBwfrbnsK/T0HH6BG9
         Cw+A==
X-Gm-Message-State: AOAM531kkSqXdaBTcL4YbXsbU3kchjVyZ5JQ+SKWmvTDIMnANx7kZwsB
        izxAj4DE4aNivype8HpoXyC0RjZupKrd9g==
X-Google-Smtp-Source: ABdhPJxLBm0IPu8aS33jWJlWLfLtqcXdbXoMCflGchGXDo92qQIV24X2CItWPYSUU/otoLgFQtN5UA==
X-Received: by 2002:a17:90b:1107:: with SMTP id gi7mr3729903pjb.177.1597670136982;
        Mon, 17 Aug 2020 06:15:36 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ff2c:a74f:a461:daa2? ([2605:e000:100e:8c61:ff2c:a74f:a461:daa2])
        by smtp.gmail.com with ESMTPSA id c207sm19523164pfc.64.2020.08.17.06.15.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 06:15:36 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: sanitize double poll handling"
 failed to apply to 5.7-stable tree
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <1597660994188250@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <40b9659c-26c4-465f-562d-a89f80b6f361@kernel.dk>
Date:   Mon, 17 Aug 2020 06:15:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1597660994188250@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------1CDFF0B41AA99EC9EEC20A37"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------1CDFF0B41AA99EC9EEC20A37
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 8/17/20 3:43 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.7-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's one that works.

-- 
Jens Axboe


--------------1CDFF0B41AA99EC9EEC20A37
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-sanitize-double-poll-handling.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-io_uring-sanitize-double-poll-handling.patch"

From f82e53af6cfc19bde5c003ddfeeb5169c35fadf7 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sat, 15 Aug 2020 11:44:50 -0700
Subject: [PATCH] io_uring: sanitize double poll handling

There's a bit of confusion on the matching pairs of poll vs double poll,
depending on if the request is a pure poll (IORING_OP_POLL_ADD) or
poll driven retry.

Add io_poll_get_double() that returns the double poll waitqueue, if any,
and io_poll_get_single() that returns the original poll waitqueue. With
that, remove the argument to io_poll_remove_double().

Finally ensure that wait->private is cleared once the double poll handler
has run, so that remove knows it's already been seen.

Cc: stable@vger.kernel.org # v5.8
Reported-by: syzbot+7f617d4a9369028b8a2c@syzkaller.appspotmail.com
Fixes: 18bceab101ad ("io_uring: allow POLL_ADD with double poll_wait() users")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7e54da9d0dcb..11bb49fa9593 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4221,9 +4221,24 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 	return false;
 }
 
-static void io_poll_remove_double(struct io_kiocb *req, void *data)
+static struct io_poll_iocb *io_poll_get_double(struct io_kiocb *req)
 {
-	struct io_poll_iocb *poll = data;
+	/* pure poll stashes this in ->io, poll driven retry elsewhere */
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return (struct io_poll_iocb *) req->io;
+	return req->apoll->double_poll;
+}
+
+static struct io_poll_iocb *io_poll_get_single(struct io_kiocb *req)
+{
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return &req->poll;
+	return &req->apoll->poll;
+}
+
+static void io_poll_remove_double(struct io_kiocb *req)
+{
+	struct io_poll_iocb *poll = io_poll_get_double(req);
 
 	lockdep_assert_held(&req->ctx->completion_lock);
 
@@ -4243,7 +4258,7 @@ static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_poll_remove_double(req, req->io);
+	io_poll_remove_double(req);
 	req->poll.done = true;
 	io_cqring_fill_event(req, error ? error : mangle_poll(mask));
 	io_commit_cqring(ctx);
@@ -4285,7 +4300,7 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 			       int sync, void *key)
 {
 	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = req->apoll->double_poll;
+	struct io_poll_iocb *poll = io_poll_get_single(req);
 	__poll_t mask = key_to_poll(key);
 
 	/* for instances that support it check for an event match first: */
@@ -4299,6 +4314,8 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 		done = list_empty(&poll->wait.entry);
 		if (!done)
 			list_del_init(&poll->wait.entry);
+		/* make sure double remove sees this as being gone */
+		wait->private = NULL;
 		spin_unlock(&poll->head->lock);
 		if (!done)
 			__io_async_wake(req, poll, mask, io_poll_task_func);
@@ -4534,7 +4551,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
 	if (ret || ipt.error) {
-		io_poll_remove_double(req, apoll->double_poll);
+		io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
 		memcpy(&req->work, &apoll->work, sizeof(req->work));
 		kfree(apoll->double_poll);
@@ -4567,14 +4584,13 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 {
 	bool do_complete;
 
+	io_poll_remove_double(req);
+
 	if (req->opcode == IORING_OP_POLL_ADD) {
-		io_poll_remove_double(req, req->io);
 		do_complete = __io_poll_remove_one(req, &req->poll);
 	} else {
 		struct async_poll *apoll = req->apoll;
 
-		io_poll_remove_double(req, apoll->double_poll);
-
 		/* non-poll requests have submit ref still */
 		do_complete = __io_poll_remove_one(req, &apoll->poll);
 		if (do_complete) {
-- 
2.28.0


--------------1CDFF0B41AA99EC9EEC20A37--
