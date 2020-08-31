Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F01257AAD
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 15:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgHaNqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 09:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgHaNqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 09:46:10 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8C1C061573
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 06:46:10 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id h11so1062319ilj.11
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 06:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5VlnGtcC729P61V0eTAaKsIzjjcpu7GtnMmvEzFndjY=;
        b=wztMdnjNIQi+gfi+9iNBhQTrhgvKE3qtD5DSSxLUg+GajO1TCU8zPK+PpO3ApNnQSj
         5pUSFuU+CiMIa7VgsIo6uRq+AeRMIoBq1IvoK6iB7JvHrlBUwm2u64Owv44Ocz4ehgr6
         CabkNmwXFp9oNd5iYyKoNsW3OQHpZSWOHylW2OQhRgu3K3tuDQXm12BpriqO6j4jv5vX
         bmPQZG+H9nsnVDQellboV686n/Kv0pddZ016aEU369U081X/LF4Ps0KTfpVR5mAgPCci
         0D3LsVLfNFm4ziyb0a2vv+MI8OmzqjyaQjy3LUlodOeAidTKigxwPkMCqTC8U5V2jbK1
         y2cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5VlnGtcC729P61V0eTAaKsIzjjcpu7GtnMmvEzFndjY=;
        b=hEkMyyYWEYHN4frZuQzlKPHMPz9ecCcSDmmNg0OzgBq4Nbg/ewHT6lTQxmcAtZaagU
         W+k1sEpSJ95RxcmW+GRqtCQAfq5Parj5l7WyVYMHzu3okA7S7CZG0RvTONFSCQvmZy5y
         mlSY9TrfL3ulcavN6GPDoglXxBjs3NwHPGy+sDx4CqBx7VPFAcp/ewePu+/e0V22RHJN
         8ecCG9Dy++FJQitjver3gnBLAOpkAXuuJQSz9LOYUHFxfGmqZvY9k9O0CuAcQ2SB8lF2
         rVAmVNMPb0P6EMIZ6GTlj2h0Lt5IRb8jwtLDTarHugnErJb46u4WR8qnzftQFcLVsV5o
         lw+g==
X-Gm-Message-State: AOAM533t22OR9eXxB+APygpTDH9V8qm8A5a/kbT4cz+mBpS55nUpBzbw
        k3pGRUw74uHtWpolbHSwcGyxYnKmOcU5+mC5
X-Google-Smtp-Source: ABdhPJwuI/x3cjr91j9uTgyvIEJPqTEQxpejSjfBWYsmHuH3volQkT3CmRz4fJQxtUO4p+uBSP2XfQ==
X-Received: by 2002:a92:dc0b:: with SMTP id t11mr1347367iln.34.1598881569515;
        Mon, 31 Aug 2020 06:46:09 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 137sm4051802ioc.20.2020.08.31.06.46.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 06:46:08 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: don't use poll handler if file
 can't be nonblocking" failed to apply to 5.8-stable tree
To:     gregkh@linuxfoundation.org, wisp3rwind@posteo.eu
Cc:     stable@vger.kernel.org
References: <159886792176158@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3b0624ac-fa9a-efdb-c122-4a7ab0ec6e83@kernel.dk>
Date:   Mon, 31 Aug 2020 07:46:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159886792176158@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/31/20 3:58 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.8-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's a backport:


From 84f81565a00f353c503d5b5bd98c77625af73b60 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 25 Aug 2020 12:27:50 -0600
Subject: [PATCH 2/3] io_uring: don't use poll handler if file can't be
 nonblocking read/written

There's no point in using the poll handler if we can't do a nonblocking
IO attempt of the operation, since we'll need to go async anyway. In
fact this is actively harmful, as reading from eg pipes won't return 0
to indicate EOF.

Cc: stable@vger.kernel.org # v5.7+
Reported-by: Benedikt Ames <wisp3rwind@posteo.eu>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c384caad6466..2b7018456091 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4503,12 +4503,20 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t mask, ret;
+	int rw;
 
 	if (!req->file || !file_can_poll(req->file))
 		return false;
 	if (req->flags & (REQ_F_MUST_PUNT | REQ_F_POLLED))
 		return false;
-	if (!def->pollin && !def->pollout)
+	if (def->pollin)
+		rw = READ;
+	else if (def->pollout)
+		rw = WRITE;
+	else
+		return false;
+	/* if we can't nonblock try, then no point in arming a poll handler */
+	if (!io_file_supports_async(req->file, rw))
 		return false;
 
 	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
-- 
2.28.0


-- 
Jens Axboe

