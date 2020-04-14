Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5AC1A8538
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 18:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391839AbgDNQir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 12:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391830AbgDNQin (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 12:38:43 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1F3C061A0C
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 09:38:43 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t40so5437699pjb.3
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 09:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i2t+6mSY9G+yMUalb4ziu6937PNahhQchRAzuH8N2Vg=;
        b=Yev+isz0XjuW1nzG420rks1VzytjCEmb+XsLgm8QHfn7mmdI9cKkP6Y/pSauosHZYh
         YAn771Ndw4acgOf+O3Tez9kXuB11yJSukkXCRjbysre8y8OpUuR96oksRKSoRADhD/QZ
         LP0JDu+I+mP762sn+D4JZsZBm0qpsY5859FFnQu5jdKrQlnFZ3nRBCPydJhfc6CvoufH
         ckorciF4xmPTqe/OY291HjrptBCNHkRNyreNl3HQav7NwzS7+4mYJuCxJ3PvzhDeWBol
         IrKnRYE20DZ7w1h9NEXj4aj66INDhUlw0jAqsDtFZ2G1RhOz+yWy6zjAyOeCxh6wrq4e
         8eVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i2t+6mSY9G+yMUalb4ziu6937PNahhQchRAzuH8N2Vg=;
        b=K9be/XP14bWqrArTjN+RhM8rUtIaDHYYLbAAXCmcyAyuTp7Mufp/zV65GnvM7gXHJ6
         e9A0BwuoPPcZvb4OhWneOjOnpuxyroPbfyiIZe7btq6yIZRK47yo0Vn6pqQlC/sS+k1q
         iAvizuxtHE366fGsAU0xIJb7Qzvyv0UOIKNh3g8QM+H0zWBFjxHsdmgqupZi4ynO9qRo
         dgrRk1EwHIk01Gwg7Vo9+vYnjvXDeu3DbZBjslLGi/j1vOw9uRxXr86xtPxzgLermHsy
         nCVUJeIn/Aq+wc7thGClpYacVyX3LZ87c8yjBYUrjD0T4LHneq8yaFJOCY2vWdn66ndV
         Mmug==
X-Gm-Message-State: AGi0PuY7VandAchxfP4inf1ybRQ7HaR90rlfT15mp/8ou+aX3BqELv5d
        isTqAmxWLZxxd4jyhgTErUinJuQiXkiuyg==
X-Google-Smtp-Source: APiQypKjx1EG1QPJiaQGhaja6BltauhQ41EW17cek2w1QQ2TLPpLQ9KWRqCRCMWrN7k9mIRBPt+Cbw==
X-Received: by 2002:a17:902:7c06:: with SMTP id x6mr768685pll.178.1586882322949;
        Tue, 14 Apr 2020 09:38:42 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id t126sm10569966pfb.29.2020.04.14.09.38.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 09:38:42 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: honor original task
 RLIMIT_FSIZE" failed to apply to 5.4-stable tree
From:   Jens Axboe <axboe@kernel.dk>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <15868668307141@kroah.com>
 <898eca01-58e5-8452-34b3-100de2506b38@kernel.dk>
Message-ID: <6b6323fa-670e-a656-1bb6-82d89ed692ae@kernel.dk>
Date:   Tue, 14 Apr 2020 10:38:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <898eca01-58e5-8452-34b3-100de2506b38@kernel.dk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/14/20 10:31 AM, Jens Axboe wrote:
> On 4/14/20 6:20 AM, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.4-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
> 
> Here's a 5.4 backport.

Sorry, please use this one!


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
index e37b84146453..2519e57afbca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -331,6 +331,7 @@ struct io_kiocb {
 #define REQ_F_ISREG		2048	/* regular file */
 #define REQ_F_MUST_PUNT		4096	/* must be punted even for NONBLOCK */
 #define REQ_F_TIMEOUT_NOSEQ	8192	/* no timeout sequence */
+	unsigned long		fsize;
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -1085,6 +1086,9 @@ static int io_prep_rw(struct io_kiocb *req, const struct sqe_submit *s,
 	if (S_ISREG(file_inode(req->file)->i_mode))
 		req->flags |= REQ_F_ISREG;
 
+	if (force_nonblock)
+		req->fsize = rlimit(RLIMIT_FSIZE);
+
 	/*
 	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
 	 * we know to async punt it even if it was opened O_NONBLOCK
@@ -1504,10 +1508,17 @@ static int io_write(struct io_kiocb *req, const struct sqe_submit *s,
 		}
 		kiocb->ki_flags |= IOCB_WRITE;
 
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
+
 		if (file->f_op->write_iter)
 			ret2 = call_write_iter(file, kiocb, &iter);
 		else
 			ret2 = loop_rw_iter(WRITE, file, kiocb, &iter);
+
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
+
 		if (!force_nonblock || ret2 != -EAGAIN) {
 			io_rw_done(kiocb, ret2);
 		} else {

-- 
Jens Axboe

