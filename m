Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E151A853C
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 18:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404437AbgDNQjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 12:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404434AbgDNQjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 12:39:53 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E05C061A0C
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 09:39:53 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m16so142712pls.4
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 09:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JIRCquJIo0JHmZz1YzgGb1q3w+tdj7eV1Qg2a/4hMcE=;
        b=yOWeDmE3hpwo8GzmnJ6mjn7vy79In5PBxsFwN3NEDigypoHqC+gfkjwVLUOQU+dsNG
         Suv0gUvxbixidU9ulHfoXecE7lQg/FrPQnZVRimrrXOH0CM5H4c6tZDdHuwYEzwudyps
         P48S6m7nkhknLTy3LJxCHirptNyWh8FnHuumxSiL7ZyApyjkzHZM8ITd/ABGasQIR2ce
         Z+KQfC9A7yb6vP0xN4DZ+6xXOKV3I8aq0uTJHIdFWFihrWW/NEluaSht2KT+yRdYV3VX
         5DUsdgNmwcHKnFMbvsWQVEht0WJ/ETCTjeVf+I37m8dcUphQp0hgX9pzbfzqsgXAozuX
         6tXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JIRCquJIo0JHmZz1YzgGb1q3w+tdj7eV1Qg2a/4hMcE=;
        b=MsU6wJgvcwuR0rkpbodBRluPdDV5rXHLLt8fzRGvy2gTE+URBBjXJMgRtyVXzvRROk
         XsNSn3q9/9WxmObLuftKamZmuFCVYNtuvfRXId/sOlOsLxTPXAaZ3v/ynb5/ZPBK6u1k
         yY9k5PbpojZ2ZcAOpMLcR7QW8AEhuds6raCoEi2YxrxGuvJlb9VirHsGfOdKOJX65107
         9j/HJc8x8UCQmh/1V86q+9///kQgzpKvL0g85PiDq6kjBd9KBjU5GYIGWSy69mypgQ1z
         MHFdLcjS7E375OoeFPs5iLj4OifALVJT4jj7GoHy8cEpNYQpbkuMLhVvShRBLb/okHIr
         Dgtw==
X-Gm-Message-State: AGi0PuZ9k1dQW1yW49F7o9TRC6et5L5tla77c8prYr/ulRgH60GTzTGw
        TEYV8V48jDU+NmbVQC2XGbN6sbeC0KEKVw==
X-Google-Smtp-Source: APiQypJzd68Ln+AQxYHhyyUwN8l+PIzYTgkVa5UEyjqvfmZbYr8BVpGFjN8gyw4IMTPOzSGDNUlt6Q==
X-Received: by 2002:a17:90a:7302:: with SMTP id m2mr1055228pjk.7.1586882392660;
        Tue, 14 Apr 2020 09:39:52 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 63sm11520451pfe.96.2020.04.14.09.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 09:39:52 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: honor original task
 RLIMIT_FSIZE" failed to apply to 5.5-stable tree
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <158686683043191@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <47bea220-946a-d2c2-d0f6-d8cb31b45425@kernel.dk>
Date:   Tue, 14 Apr 2020 10:39:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <158686683043191@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/14/20 6:20 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.5-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's a 5.5 backport.


From 4ed734b0d0913e566a9d871e15d24eb240f269f7 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 20 Mar 2020 11:23:41 -0600
Subject: [PATCH] io_uring: honor original task RLIMIT_FSIZE

With the previous fixes for number of files open checking, I added some
debug code to see if we had other spots where we're checking rlimit()
against the async io-wq workers. The only one I found was file size
checking, which we should also honor.

During write and fallocate prep, store the max file size and override
that for the current ask if we're in io-wq worker context.

Cc: stable@vger.kernel.org # 5.1+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index faa0198c99ff..3e412b86513d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -432,6 +432,7 @@ struct io_kiocb {
 #define REQ_F_INFLIGHT		16384	/* on inflight list */
 #define REQ_F_COMP_LOCKED	32768	/* completion under lock */
 #define REQ_F_HARDLINK		65536	/* doesn't sever on completion < 0 */
+	unsigned long		fsize;
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -1899,6 +1900,8 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
+	req->fsize = rlimit(RLIMIT_FSIZE);
+
 	if (!req->io)
 		return 0;
 
@@ -1970,10 +1973,17 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		}
 		kiocb->ki_flags |= IOCB_WRITE;
 
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
+
 		if (req->file->f_op->write_iter)
 			ret2 = call_write_iter(req->file, kiocb, &iter);
 		else
 			ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
+
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
+
 		/*
 		 * Raw bdev writes will -EOPNOTSUPP for IOCB_NOWAIT. Just
 		 * retry them without IOCB_NOWAIT.

-- 
Jens Axboe

