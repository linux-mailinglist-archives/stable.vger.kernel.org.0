Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C64A18F7D8
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 15:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgCWO7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 10:59:14 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43161 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgCWO7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 10:59:14 -0400
Received: by mail-pg1-f196.google.com with SMTP id u12so7306440pgb.10
        for <stable@vger.kernel.org>; Mon, 23 Mar 2020 07:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hY1gWmWBeTCeWUNp/GeXB3FEHwyKSlvFcL5CLmS+1QI=;
        b=Z4xT01QN5k2F/jAKmCifTSlhI+4YigNvGZ1Mf7tCXV2x9GNVCNMRinlJNUAtyT1hvN
         0F4XbqjbHiNy2nI1KfynONpnGMbQGICUDJSthcnWYvmBpEnlIs3SVDWoFvrwo0Ve9GRk
         z4pXuTKFGNbktsLFnBRnjVe6toBz6j0s5x+c3uXbRCZr5WeKeHsi4s45vGiUbFjXPPh3
         9bs5JGtNEdiqYno3jZMAxN6CN4ad4jgNRDvQtSq8SoFCaJsvWYk7joWptBZ3tYCbHldc
         Lygqzj6kNyfNL7Hfs4xzYMmxpHAwMwIZka9X6FA9sNVJtKIdMV8YIH4C2eZNEkRvGrNi
         1meA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hY1gWmWBeTCeWUNp/GeXB3FEHwyKSlvFcL5CLmS+1QI=;
        b=dp4pDcdXofk08wlHyCDaLSWsYdsqXHkkE9lwF3dZggRcULJ6N5eDZNs2Le9v6egvAU
         7077BJj2evuS8waZZ6j7hwqHb3P7u1XDC2rIpMsN9sNxbbar/FzuWULluz6fY1dtCqAm
         qAEvSVdNBUP+ZoMA9mOfdaZiVyB7YYvY8OiOAZoNRszlUoYc64/1f96v1XZXIKqgnbiV
         xOZZBz1v0qCbw/uffLWJDp6YB5fbMIjJ+9JUg4s5+dGwHtAwm2Phv08HkJjwgEcy4kNn
         GCC1Y9ttFPjBh/d2AgzqpkFxd+HbkNmbLlk0caaxltQDCUPbQZ0yTndBXuFDzkgA0/MB
         mV+g==
X-Gm-Message-State: ANhLgQ3KKZslAP7M/ULJFCRc/lPn4iDGDesiHl9AYn+2H533kMu+l7cL
        dzKC+nxYiwQWDp/0OrmhyukwiqScy7LQMw==
X-Google-Smtp-Source: ADFU+vuxa2lD9V0x3YtglKPwhUaZ6vjyy0/veldaFMKA3OmHF7R3t20jn/P7yeuMQBxx++ZYtyR93g==
X-Received: by 2002:a63:e70d:: with SMTP id b13mr22329942pgi.8.1584975551672;
        Mon, 23 Mar 2020 07:59:11 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id i13sm13628999pfd.180.2020.03.23.07.59.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 07:59:11 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: NULL-deref for
 IOSQE_{ASYNC,DRAIN}" failed to apply to 5.5-stable tree
To:     gregkh@linuxfoundation.org, asml.silence@gmail.com
Cc:     stable@vger.kernel.org
References: <158497417567105@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c2b8bb83-3b0e-1061-5966-00ac52a4dccd@kernel.dk>
Date:   Mon, 23 Mar 2020 08:59:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <158497417567105@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/23/20 8:36 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.5-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's a tested backport, thanks for letting us know!

From f1d96a8fcbbbb22d4fbc1d69eaaa678bbb0ff6e2 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Fri, 13 Mar 2020 22:29:14 +0300
Subject: [PATCH] io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}

Processing links, io_submit_sqe() prepares requests, drops sqes, and
passes them with sqe=NULL to io_queue_sqe(). There IOSQE_DRAIN and/or
IOSQE_ASYNC requests will go through the same prep, which doesn't expect
sqe=NULL and fail with NULL pointer deference.

Always do full prepare including io_alloc_async_ctx() for linked
requests, and then it can skip the second preparation.

Cc: stable@vger.kernel.org # 5.5
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2547c6395d5e..5383b225e48e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3097,6 +3097,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 {
 	ssize_t ret = 0;
 
+	if (!sqe)
+		return 0;
+
 	switch (req->opcode) {
 	case IORING_OP_NOP:
 		break;
@@ -3680,6 +3683,11 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			req->flags |= REQ_F_HARDLINK;
 
 		INIT_LIST_HEAD(&req->link_list);
+
+		if (io_alloc_async_ctx(req)) {
+			ret = -EAGAIN;
+			goto err_req;
+		}
 		ret = io_req_defer_prep(req, sqe);
 		if (ret)
 			req->flags |= REQ_F_FAIL_LINK;


-- 
Jens Axboe

