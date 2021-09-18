Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8192D410679
	for <lists+stable@lfdr.de>; Sat, 18 Sep 2021 14:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbhIRMpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Sep 2021 08:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235206AbhIRMpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Sep 2021 08:45:43 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E30C061574
        for <stable@vger.kernel.org>; Sat, 18 Sep 2021 05:44:19 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 203so3945512pfy.13
        for <stable@vger.kernel.org>; Sat, 18 Sep 2021 05:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=+Oaa1o2hDinBJNbQ4A1iK1+jifcc8aLtpxP9mbkRbWM=;
        b=bfNTuLVQYHa4GEbi0kEHk2HUHcUBFkDgAqHLkyYgCnSwz9o2mxk3mvcEPm5ESWwiHu
         ohIJ0CZp8qeZO/Fd4n1EPMOui1cdseirIFNAnhj10CtoWRFJT0pxwJNhd6czdadiNaY7
         SPSj1YjHQjdnL8AT1U/XibCioHpkSs5Rq2t+LpaTvMOVL43uzNZ4cjKsAmQZzZiKz7dt
         FnpUO0pmpWJcYpm2K+zE0DjvdNotAVxo23Mk2C4KNTOPlj2wfVb53Fsic/OAOrd7ZjFM
         Ds+BQaROvEHHyK1UxM/A35zOwSojMMB/hmxaqVm9kNlVzO5h9a7GYeqgGPDWI4r1rZPk
         mUDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=+Oaa1o2hDinBJNbQ4A1iK1+jifcc8aLtpxP9mbkRbWM=;
        b=YiyuH/+tgjWLctWh7wV0chi4pp7a9FRXR03Tqge9QgFywAF2evk3qfsSbrYq3RV+fS
         pCRdpcnZRrS5MZepQiyxBZYJX4v5+I53rvafPjfjEF5DQOEWLwm62EjiUJVlyYkNafF7
         ZxilpCtkWjUq3hBW8CCFb3tERDzLQjtAdRUY+OluzB81q1skq56VvI5cdU8wYodMEXV2
         QEGQPCRxqk9urt6ijBEN8LIhT9sJBLmpxBWkXVoSQk1TTJGd20gD92ZjrZyoVpPmkx4x
         /AQBPfc4nGAuZWa3/4mKKMIpQm2Ru+TCpCsfZs/4MZM59Nr+JEF0D5lUSIvF53BfcU0i
         7VmA==
X-Gm-Message-State: AOAM530G13udEoVt/MwlR4r0jur5K/aQF5DlDgK8fExXgfSFhN2QZ53C
        BM1RVaAAziFEhaI7vbW6146sR3eCSS/HUg==
X-Google-Smtp-Source: ABdhPJy3abwwBqGcAn54DIQHJSvOLnMJVXHZZ5rdXxch/eeDkVVVjLoIQsXgis2jkJkjqvjZgeJqWA==
X-Received: by 2002:a65:6389:: with SMTP id h9mr14509575pgv.83.1631969058726;
        Sat, 18 Sep 2021 05:44:18 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21e8::1036? ([2620:10d:c090:400::5:d29])
        by smtp.gmail.com with ESMTPSA id h4sm9998412pgn.6.2021.09.18.05.44.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 05:44:17 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: allow retry for O_NONBLOCK if
 async is supported" failed to apply to 5.14-stable tree
To:     gregkh@linuxfoundation.org, dmm@fb.com
Cc:     stable@vger.kernel.org
References: <1631968451106199@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0c9365f0-e471-066d-0ab2-faee3ca2d927@kernel.dk>
Date:   Sat, 18 Sep 2021 06:44:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1631968451106199@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------E3AEE6B9CB08FC8B07491607"
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------E3AEE6B9CB08FC8B07491607
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 9/18/21 6:34 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Just a trivial fuzz, here's a fixed version.

-- 
Jens Axboe


--------------E3AEE6B9CB08FC8B07491607
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-allow-retry-for-O_NONBLOCK-if-async-is-supp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-allow-retry-for-O_NONBLOCK-if-async-is-supp.pa";
 filename*1="tch"

From 5d329e1286b0a040264e239b80257c937f6e685f Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 14 Sep 2021 11:08:37 -0600
Subject: [PATCH] io_uring: allow retry for O_NONBLOCK if async is supported

commit 5d329e1286b0a040264e239b80257c937f6e685f upstream.

A common complaint is that using O_NONBLOCK files with io_uring can be a
bit of a pain. Be a bit nicer and allow normal retry IFF the file does
support async behavior. This makes it possible to use io_uring more
reliably with O_NONBLOCK files, for use cases where it either isn't
possible or feasible to modify the file flags.

Cc: stable@vger.kernel.org
Reported-and-tested-by: Dan Melnic <dmm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ae489ab275dd..3077f85a2638 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2843,7 +2843,8 @@ static bool io_file_supports_nowait(struct io_kiocb *req, int rw)
 	return __io_file_supports_async(req->file, rw);
 }
 
-static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+		      int rw)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -2865,8 +2866,13 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(ret))
 		return ret;
 
-	/* don't allow async punt for O_NONBLOCK or RWF_NOWAIT */
-	if ((kiocb->ki_flags & IOCB_NOWAIT) || (file->f_flags & O_NONBLOCK))
+	/*
+	 * If the file is marked O_NONBLOCK, still allow retry for it if it
+	 * supports async. Otherwise it's impossible to use O_NONBLOCK files
+	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
+	 */
+	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
+	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req, rw)))
 		req->flags |= REQ_F_NOWAIT;
 
 	ioprio = READ_ONCE(sqe->ioprio);
@@ -3349,7 +3355,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(!(req->file->f_mode & FMODE_READ)))
 		return -EBADF;
-	return io_prep_rw(req, sqe);
+	return io_prep_rw(req, sqe, READ);
 }
 
 /*
@@ -3542,7 +3548,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
-	return io_prep_rw(req, sqe);
+	return io_prep_rw(req, sqe, WRITE);
 }
 
 static int io_write(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.33.0


--------------E3AEE6B9CB08FC8B07491607--
