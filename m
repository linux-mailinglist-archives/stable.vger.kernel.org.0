Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E065F257AAF
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 15:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgHaNqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 09:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgHaNqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 09:46:31 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4826C061573
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 06:46:27 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g128so5866903iof.11
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 06:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZBC32/BNL6RpeAIxE/WsM9Y7eaf+MsluqGnqgwVH+hw=;
        b=R5JX0YR0phFKrVvi2VrxE/rYUngCqhiT2GOeJmvQ+a2AkFSqsFUyjqFVQgDi58riFX
         WPWntgBRzfpKbb+kiSMJm8AqBxtHuoQ2YfS6izTTOm+TsOuyfW0WaTVKO0lmpsyef+l4
         Mc9pERxLL+QRbE83TmgpGZCLDUghOMdAzC2vpO7P9TfawlCcW7vQZgYgCI30DvgbyaNO
         r9VWzKq2wPw8jUGhFQ0RInx1qFPEXxojBLjU0PpiyGIMSOpQzNMxCF7kMRrCpPdeDlji
         A8YCinlW+Xew5kBRn9/QH8qaC3pZ+s9MGCz1TNHZeibNAKobl/224bPnbXRlGz/5Hsbx
         YwxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZBC32/BNL6RpeAIxE/WsM9Y7eaf+MsluqGnqgwVH+hw=;
        b=Be0rwZwv7DLmzEerOKeGkSa5XPDFJ0RQz21JrvXXidswEF+rTjxju8uZylPP5foMKu
         PcJcsHiHxniBvayYPeyM+GWRlWNLPTahzA5rDjQ6StwwJsu8ZdrkmcvRb0YBynkRsM9j
         JxJoG5oDck4PuOv96HzGM0Z1M7rpNGhbr20y3ceapojXxMQx4WXg3mKIU26TRYzqreN2
         2FcobVYj6M2udbed/rvCjWcQPfY43E7OgGdoWuiIoIW1/R1cEKuPYhsiL+BvacN2WeNz
         GJ+7fw64GPzjeel41HaUSN3MCz4dIRD4Kas51yeupcpyCbhnRj7VSsSTQ/WIRFJDMfvA
         YvHg==
X-Gm-Message-State: AOAM533InnxUOfVEM9K8Jcc+cvedE+dlfkomVpshsWHQM42o8hRWtSNs
        cCAdXLQcEmVfmoL7F5D3JDMiD7x/BYG0DHwI
X-Google-Smtp-Source: ABdhPJy3sdSZMMP66M1Cda98l5KGhcdj3oTMalhZh6tqDIhFqMuLu71VbITSU0b2mJV4knc0ny+IQw==
X-Received: by 2002:a05:6602:1343:: with SMTP id i3mr1324623iov.134.1598881584294;
        Mon, 31 Aug 2020 06:46:24 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 2sm1878911ilj.24.2020.08.31.06.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 06:46:23 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: make offset == -1 consistent
 with preadv2/pwritev2" failed to apply to 5.8-stable tree
To:     gregkh@linuxfoundation.org, wisp3rwind@posteo.eu
Cc:     stable@vger.kernel.org
References: <1598867965216125@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d993f42e-03e9-cd9c-6a2a-6a0c11989865@kernel.dk>
Date:   Mon, 31 Aug 2020 07:46:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1598867965216125@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/31/20 3:59 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.8-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's a backport:


From 0414a859ee85f9a6b7d692fac115594e19f872ee Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Wed, 26 Aug 2020 10:36:20 -0600
Subject: [PATCH 3/3] io_uring: make offset == -1 consistent with
 preadv2/pwritev2

The man page for io_uring generally claims were consistent with what
preadv2 and pwritev2 accept, but turns out there's a slight discrepancy
in how offset == -1 is handled for pipes/streams. preadv doesn't allow
it, but preadv2 does. This currently causes io_uring to return -EINVAL
if that is attempted, but we should allow that as documented.

This change makes us consistent with preadv2/pwritev2 for just passing
in a NULL ppos for streams if the offset is -1.

Cc: stable@vger.kernel.org # v5.7+
Reported-by: Benedikt Ames <wisp3rwind@posteo.eu>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2b7018456091..4115bfedf15d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2518,6 +2518,11 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	return import_iovec(rw, buf, sqe_len, UIO_FASTIOV, iovec, iter);
 }
 
+static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
+{
+	return kiocb->ki_filp->f_mode & FMODE_STREAM ? NULL : &kiocb->ki_pos;
+}
+
 /*
  * For files that don't have ->read_iter() and ->write_iter(), handle them
  * by looping over ->read() or ->write() manually.
@@ -2553,10 +2558,10 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 
 		if (rw == READ) {
 			nr = file->f_op->read(file, iovec.iov_base,
-					      iovec.iov_len, &kiocb->ki_pos);
+					      iovec.iov_len, io_kiocb_ppos(kiocb));
 		} else {
 			nr = file->f_op->write(file, iovec.iov_base,
-					       iovec.iov_len, &kiocb->ki_pos);
+					       iovec.iov_len, io_kiocb_ppos(kiocb));
 		}
 
 		if (iov_iter_is_bvec(iter))
@@ -2681,7 +2686,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 		goto copy_iov;
 
 	iov_count = iov_iter_count(&iter);
-	ret = rw_verify_area(READ, req->file, &kiocb->ki_pos, iov_count);
+	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), iov_count);
 	if (!ret) {
 		ssize_t ret2;
 
@@ -2780,7 +2785,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 		goto copy_iov;
 
 	iov_count = iov_iter_count(&iter);
-	ret = rw_verify_area(WRITE, req->file, &kiocb->ki_pos, iov_count);
+	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), iov_count);
 	if (!ret) {
 		ssize_t ret2;
 
-- 
2.28.0


-- 
Jens Axboe

