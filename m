Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9315E1C3B9D
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 15:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgEDNq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 09:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728116AbgEDNq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 09:46:59 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B58EC061A0E
        for <stable@vger.kernel.org>; Mon,  4 May 2020 06:46:58 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s10so6800568plr.1
        for <stable@vger.kernel.org>; Mon, 04 May 2020 06:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XOQoC/vbYET30dfT5nVG1laoqEtme9wUqFZLMmsl0ZQ=;
        b=sRZZ5C5ljYsLLIOKHTBYgV3FiyYX2JbF2qFg37/R4ezDTytIyeTNLx55x7UPxzLnNn
         OViqK957RtitU0AOeXdzrTeCY1wtpbgOtJE9IPyY440/AIWirW7btXKaVOkUkXhcM+zH
         VA+/rWcMuMc8aoANK1EOib8as4gioqxS637O5119qaHTd699sBuCFP8fEFXQHnpTQD+f
         XD7Psa6wFpTUO4IurdnoX91dwEvyvQg3u8sIcqwte3Uj3kATLUlGGwlPC2uJp4Go+wSv
         lAToEijJdI+6ds8B5P0tcHFdr/HEXt1sqzUQUV2g9wOM/mOWoA1VScObVJ/c09w+DFs0
         1rGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XOQoC/vbYET30dfT5nVG1laoqEtme9wUqFZLMmsl0ZQ=;
        b=CJwW5ZHKK7b/zOT0E+dpD+f9CDoKHvNW12kFgoCJ5Ux2Snot7P9XXmi5BWN+hbonp6
         DMqMvkIdQtOzWoJ8QxhY7tR+JxtIfTeJYZNa55cLZPvb9WEQGn0X5S9dlUd4QF+SjwR8
         Q8kWy3DZzA0qr/dhlQYnTy0YyDt0p6FqtolI7y9Jks1CkKpEOvu+iasMxCrQEFywP9GC
         6UIJP3N8vV9RrfEJjupruB4ZzJ93X99lHWCnsitRW2zI4xt4jGea8EQFkoUlIflsf0QS
         yMUpYqcjwQj7WRHQbWTkuX7NGacXRhYnWAL+/X+inRdpCGdD8LnkM9hO/9S9JXjHJ6X1
         aHYA==
X-Gm-Message-State: AGi0PublmZGEI5RSumm4ZIpRJ9G7pLe+eKjAtGfEkhAZlP7hdGxp9o1N
        sHkYXL3UI/WRrE/qE6cPaN0TkZMy6Car8w==
X-Google-Smtp-Source: APiQypLCg+MZazJXA+Eu/sdo3z16q8gwOaI/fQxnAKosM/n8g/Ku0ChCYQoBFMSfhj8cseZyul7YTQ==
X-Received: by 2002:a17:90a:3422:: with SMTP id o31mr17561234pjb.18.1588600017840;
        Mon, 04 May 2020 06:46:57 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id m12sm3773181pgj.46.2020.05.04.06.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 06:46:57 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: statx must grab the file table
 for valid fd" failed to apply to 5.6-stable tree
To:     gregkh@linuxfoundation.org, bugs@claycon.org
Cc:     stable@vger.kernel.org
References: <1588586161159248@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a4390838-d86d-2b0e-ec18-12ee0b74ab7f@kernel.dk>
Date:   Mon, 4 May 2020 07:46:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588586161159248@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/4/20 3:56 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.6-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's a 5.6 backport.


From 5b0bbee4732cbd58aa98213d4c11a366356bba3d Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 27 Apr 2020 10:41:22 -0600
Subject: [PATCH] io_uring: statx must grab the file table for valid fd

Clay reports that OP_STATX fails for a test case with a valid fd
and empty path:

 -- Test 0: statx:fd 3: SUCCEED, file mode 100755
 -- Test 1: statx:path ./uring_statx: SUCCEED, file mode 100755
 -- Test 2: io_uring_statx:fd 3: FAIL, errno 9: Bad file descriptor
 -- Test 3: io_uring_statx:path ./uring_statx: SUCCEED, file mode 100755

This is due to statx not grabbing the process file table, hence we can't
lookup the fd in async context. If the fd is valid, ensure that we grab
the file table so we can grab the file from async context.

Cc: stable@vger.kernel.org # v5.6
Reported-by: Clay Harris <bugs@claycon.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a46de2cfc28e..38b25f599896 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -479,6 +479,7 @@ enum {
 	REQ_F_COMP_LOCKED_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_OVERFLOW_BIT,
+	REQ_F_NO_FILE_TABLE_BIT,
 };
 
 enum {
@@ -521,6 +522,8 @@ enum {
 	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
 	/* in overflow list */
 	REQ_F_OVERFLOW		= BIT(REQ_F_OVERFLOW_BIT),
+	/* doesn't need file table for this request */
+	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
 };
 
 /*
@@ -711,6 +714,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 		.needs_fs		= 1,
+		.file_table		= 1,
 	},
 	[IORING_OP_READ] = {
 		.needs_mm		= 1,
@@ -2843,8 +2847,12 @@ static int io_statx(struct io_kiocb *req, struct io_kiocb **nxt,
 	struct kstat stat;
 	int ret;
 
-	if (force_nonblock)
+	if (force_nonblock) {
+		/* only need file table for an actual valid fd */
+		if (ctx->dfd == -1 || ctx->dfd == AT_FDCWD)
+			req->flags |= REQ_F_NO_FILE_TABLE;
 		return -EAGAIN;
+	}
 
 	if (vfs_stat_set_lookup_flags(&lookup_flags, ctx->how.flags))
 		return -EINVAL;
@@ -4632,7 +4640,7 @@ static int io_grab_files(struct io_kiocb *req)
 	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (req->work.files)
+	if (req->work.files || (req->flags & REQ_F_NO_FILE_TABLE))
 		return 0;
 	if (!ctx->ring_file)
 		return -EBADF;

-- 
Jens Axboe

