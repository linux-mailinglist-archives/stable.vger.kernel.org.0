Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C55261858
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731629AbgIHRwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731628AbgIHQNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 12:13:44 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC55C0619CF
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 06:53:50 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id p13so15455195ils.3
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 06:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language;
        bh=HpzViOM6XaeQk6Wc+fv0FBxQKdHacO4rKdeumggWBpU=;
        b=LnBaaN45TVn24+WLqlJZGU1NKrxwdEEzDgargevIyScxwwGkaDZafv8XRzkDYyi0Uo
         +qiPaOkV5XIFJ4pGgHsP4Xawju5RNx3AnX41HD3rX0tNk0JUq9QJacHtii5W2y1g6Xa4
         4jTnrVPgTg6rHhKw70gk+zZ9vUCu5CdRizZl/UGtRokgd2Xj5YHV2mRomun7DkphpFfD
         MZcAuKLyNkAdybeZvRghCPvcLea1SlEWHqwQwJysQVY90AdEqZjrIXjQ1liJgMiGEiYy
         Aie20iYGa/yTO+xrXZj5LadsZM2OKC0A/9SwCypxLEage5LFzrti5pAS1cCU55KTeaBw
         Cpug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=HpzViOM6XaeQk6Wc+fv0FBxQKdHacO4rKdeumggWBpU=;
        b=uHvzbQqiBGpfq3DWcYltgMgwqOMryzttaJY+UPrYRwAe4dQSr9PLJgy9dipSvFgEuD
         OuYo7hgLtcSxcDg+9z+er6iPmQn4lLqxYchRs5UZ43BnaWEBL3BqyLhwrh6HzmwGBTMR
         fL4We+psxfA3rha2j62p3DddwSZ1YS3qya54cH0cmA07j9OR2DxhX/FQn2UVUzLOWCMY
         GRyIAYUHXCvhZCax8B3sAVp6wQZtGeJFcVEmU/Ei+9f2BcGwVsF4ScxY8hTarQVUii7a
         GaHiyatem8zINVWKvaIT2Rag2gpffJnZuqSqBbSFyBkeY+PVh09rg/JVjtB9uVwnwy5Y
         mUvQ==
X-Gm-Message-State: AOAM5306y+apx8GDnlNJNJrc0z8S09OceoIP3ow0DUrZjqJdOyPE82xW
        IGUqCSV2uOsZR8n+Ehf/H/k2jkSG65t+lw9T
X-Google-Smtp-Source: ABdhPJwVlJn5ZuO1tZoIgtezdLZORbnuXJk1IJ+DdCIxuglUCImxABKIsVh1G+Dt89xo2c8lyziRBw==
X-Received: by 2002:a92:dcc3:: with SMTP id b3mr22408017ilr.285.1599573229054;
        Tue, 08 Sep 2020 06:53:49 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v11sm10589758ili.66.2020.09.08.06.53.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 06:53:48 -0700 (PDT)
Subject: Re: 5.8 stable inclusion request
From:   Jens Axboe <axboe@kernel.dk>
To:     stable@vger.kernel.org
References: <fc20c685-8cd1-37f3-8c8f-9ce70b0911c1@kernel.dk>
 <cf6761b6-2f20-9d0b-9f4c-dfde1d567beb@kernel.dk>
Message-ID: <c8d92453-94e9-d3f9-70b7-a42bfa005e79@kernel.dk>
Date:   Tue, 8 Sep 2020 07:53:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cf6761b6-2f20-9d0b-9f4c-dfde1d567beb@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------407CB2448800F642E48F6480"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------407CB2448800F642E48F6480
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 9/8/20 7:45 AM, Jens Axboe wrote:
> On 9/8/20 7:29 AM, Jens Axboe wrote:
>> Hi,
>>
>> Can I get these two queued up, in this order:
>>
>> commit b7ddce3cbf010edbfac6c6d8cc708560a7bcd7a4
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Sun Sep 6 00:45:14 2020 +0300
>>
>>     io_uring: fix cancel of deferred reqs with ->files
>>
>> and
>>
>> commit c127a2a1b7baa5eb40a7e2de4b7f0c51ccbbb2ef (tag: io_uring-5.9-2020-09-06, origin/i
>> o_uring-5.9, io_uring-5.9)
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Sun Sep 6 00:45:15 2020 +0300
>>
>>     io_uring: fix linked deferred ->files cancellation
>>
>> which should both cherry-pick cleanly into the 5.8-stable tree.
> 
> They do pick cleanly, but missing some infrastructure... I'll send these
> in separately.

Here you go, these work and are tested.

-- 
Jens Axboe


--------------407CB2448800F642E48F6480
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-fix-linked-deferred-files-cancellation.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-io_uring-fix-linked-deferred-files-cancellation.patch"

From faaff9b554082ef41acdb314b920ea03b5ce95c9 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Sun, 6 Sep 2020 00:45:15 +0300
Subject: [PATCH 2/2] io_uring: fix linked deferred ->files cancellation

[ Upstream commit c127a2a1b7baa5eb40a7e2de4b7f0c51ccbbb2ef ]

While looking for ->files in ->defer_list, consider that requests there
may actually be links.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e1c11925d9ec..b69dd3be7522 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7600,6 +7600,28 @@ static bool io_match_link(struct io_kiocb *preq, struct io_kiocb *req)
 	return false;
 }
 
+static inline bool io_match_files(struct io_kiocb *req,
+				       struct files_struct *files)
+{
+	return (req->flags & REQ_F_WORK_INITIALIZED) && req->work.files == files;
+}
+
+static bool io_match_link_files(struct io_kiocb *req,
+				struct files_struct *files)
+{
+	struct io_kiocb *link;
+
+	if (io_match_files(req, files))
+		return true;
+	if (req->flags & REQ_F_LINK_HEAD) {
+		list_for_each_entry(link, &req->link_list, link_list) {
+			if (io_match_files(link, files))
+				return true;
+		}
+	}
+	return false;
+}
+
 /*
  * We're looking to cancel 'req' because it's holding on to our files, but
  * 'req' could be a link to another request. See if it is, and cancel that
@@ -7682,8 +7704,7 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_reverse(req, &ctx->defer_list, list) {
-		if ((req->flags & REQ_F_WORK_INITIALIZED)
-			&& req->work.files == files) {
+		if (io_match_link_files(req, files)) {
 			list_cut_position(&list, &ctx->defer_list, &req->list);
 			break;
 		}
-- 
2.28.0


--------------407CB2448800F642E48F6480
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-fix-cancel-of-deferred-reqs-with-files.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-fix-cancel-of-deferred-reqs-with-files.patch"

From 02cad2a0bbbfe48aa575573deae15cc2431872ff Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Sun, 6 Sep 2020 00:45:14 +0300
Subject: [PATCH 1/2] io_uring: fix cancel of deferred reqs with ->files

[ Upstream commit b7ddce3cbf010edbfac6c6d8cc708560a7bcd7a4 ]

While trying to cancel requests with ->files, it also should look for
requests in ->defer_list, otherwise it might end up hanging a thread.

Cancel all requests in ->defer_list up to the last request there with
matching ->files, that's needed to follow drain ordering semantics.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fe114511d6d6..e1c11925d9ec 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7674,12 +7674,38 @@ static void io_attempt_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
 	io_timeout_remove_link(ctx, req);
 }
 
+static void io_cancel_defer_files(struct io_ring_ctx *ctx,
+				  struct files_struct *files)
+{
+	struct io_kiocb *req = NULL;
+	LIST_HEAD(list);
+
+	spin_lock_irq(&ctx->completion_lock);
+	list_for_each_entry_reverse(req, &ctx->defer_list, list) {
+		if ((req->flags & REQ_F_WORK_INITIALIZED)
+			&& req->work.files == files) {
+			list_cut_position(&list, &ctx->defer_list, &req->list);
+			break;
+		}
+	}
+	spin_unlock_irq(&ctx->completion_lock);
+
+	while (!list_empty(&list)) {
+		req = list_first_entry(&list, struct io_kiocb, list);
+		list_del_init(&req->list);
+		req_set_fail_links(req);
+		io_cqring_add_event(req, -ECANCELED);
+		io_double_put_req(req);
+	}
+}
+
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
 	if (list_empty_careful(&ctx->inflight_list))
 		return;
 
+	io_cancel_defer_files(ctx, files);
 	/* cancel all at once, should be faster than doing it one by one*/
 	io_wq_cancel_cb(ctx->io_wq, io_wq_files_match, files, true);
 
-- 
2.28.0


--------------407CB2448800F642E48F6480--
