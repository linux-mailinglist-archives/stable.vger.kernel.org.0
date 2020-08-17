Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDED324674C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgHQNZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbgHQNZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:25:12 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F2AC061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:25:12 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t6so7692391pjr.0
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YG98J5KbW0i44eokU1YGnM0kXB/YXNc8SwJhd12baoY=;
        b=rT8QwVDlVApdcKrYsHqYXNIRd/eyne5US9BZfNWYmgL5SHDw4KqXszCLMcs12u12m6
         BPfhMLXXyCLpdoGKlMm0alyAeDJ+z5EG1MQGs4vY6+6Dg6KtklFzwBvLSak/gk7q8l/7
         cVsyjquYUKcjPB6T9k2zXDYYTI/etYcqshmCo4Cackvg79lFLl1KJw+iTgICqaIX7Edf
         Uz5cNjqwo0Gelbi6UhX0hbRq7E2TFj7EblVO7apr12Otrd6jTvMIdXvgbektHIqZZSGK
         WpAZ+PhIA4NIpRGs6R9I6IbHQTDDxu1LMV9A+0PqMzpP8Hw1AKDbPBUlgFNHD42ywyrR
         5eMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YG98J5KbW0i44eokU1YGnM0kXB/YXNc8SwJhd12baoY=;
        b=ZxbC7V2MVl41X2ARtTCwRfhn61HUMUn+wFEVNCckjcXq1qxQTbDSX0QJzgFW1eQ0d8
         wkyNlzsTi3tIcZrt2p+XxNMM8uX//tu9aRQ9l6BVvGL8JZKlpvc0yso3eXuBGXJ6FRx6
         R1hszCIqO3bJi8w5DV0fmO7Bhlk0uDnnYKxdXE13B5moxQzrgIcUnUJk2oFHCAiqZlG6
         01mhy1KjFM7arRdDS5QeC6ucp/qjjfe+bzd2aZOYilXbQNyBUZRBdb8KsCaNyl1xD+dx
         V4+egXvOl8Xa6/DP1RBsCgn0HsGw/aYK0LVc879zi8cmr9bTZili8K2hLwROxxhlgunm
         EOUQ==
X-Gm-Message-State: AOAM530MPgA/bCqaxffewqe630ezGtQbAjHK+/kvt8JnJbEd6Z+jMQLs
        EYL2exB79Wdd3rHfM83cD11DB6zlI81vrg==
X-Google-Smtp-Source: ABdhPJzqby5zqCVd/Loo2AM6r+GG21crZJIwgLWMTpKbsEjJNcTGuWzglz/83HPjcluXAcHBmCYiSQ==
X-Received: by 2002:a17:90a:f68b:: with SMTP id cl11mr12400986pjb.68.1597670711519;
        Mon, 17 Aug 2020 06:25:11 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ff2c:a74f:a461:daa2? ([2605:e000:100e:8c61:ff2c:a74f:a461:daa2])
        by smtp.gmail.com with ESMTPSA id i11sm17184642pjv.30.2020.08.17.06.25.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 06:25:11 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: Fix NULL pointer dereference in
 loop_rw_iter()" failed to apply to 5.4-stable tree
To:     gregkh@linuxfoundation.org, hgy5945@gmail.com
Cc:     stable@vger.kernel.org
References: <159766102242127@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4b16e8bd-c08e-b81d-bc6d-51e5d59fc30d@kernel.dk>
Date:   Mon, 17 Aug 2020 06:25:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159766102242127@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/17/20 3:43 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

5.4 version:


From 2dd2111d0d383df104b144e0d1f6b5a00cb7cd88 Mon Sep 17 00:00:00 2001
From: Guoyu Huang <hgy5945@gmail.com>
Date: Wed, 5 Aug 2020 03:53:50 -0700
Subject: [PATCH] io_uring: Fix NULL pointer dereference in loop_rw_iter()

loop_rw_iter() does not check whether the file has a read or
write function. This can lead to NULL pointer dereference
when the user passes in a file descriptor that does not have
read or write function.

The crash log looks like this:

[   99.834071] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   99.835364] #PF: supervisor instruction fetch in kernel mode
[   99.836522] #PF: error_code(0x0010) - not-present page
[   99.837771] PGD 8000000079d62067 P4D 8000000079d62067 PUD 79d8c067 PMD 0
[   99.839649] Oops: 0010 [#2] SMP PTI
[   99.840591] CPU: 1 PID: 333 Comm: io_wqe_worker-0 Tainted: G      D           5.8.0 #2
[   99.842622] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
[   99.845140] RIP: 0010:0x0
[   99.845840] Code: Bad RIP value.
[   99.846672] RSP: 0018:ffffa1c7c01ebc08 EFLAGS: 00010202
[   99.848018] RAX: 0000000000000000 RBX: ffff92363bd67300 RCX: ffff92363d461208
[   99.849854] RDX: 0000000000000010 RSI: 00007ffdbf696bb0 RDI: ffff92363bd67300
[   99.851743] RBP: ffffa1c7c01ebc40 R08: 0000000000000000 R09: 0000000000000000
[   99.853394] R10: ffffffff9ec692a0 R11: 0000000000000000 R12: 0000000000000010
[   99.855148] R13: 0000000000000000 R14: ffff92363d461208 R15: ffffa1c7c01ebc68
[   99.856914] FS:  0000000000000000(0000) GS:ffff92363dd00000(0000) knlGS:0000000000000000
[   99.858651] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   99.860032] CR2: ffffffffffffffd6 CR3: 000000007ac66000 CR4: 00000000000006e0
[   99.861979] Call Trace:
[   99.862617]  loop_rw_iter.part.0+0xad/0x110
[   99.863838]  io_write+0x2ae/0x380
[   99.864644]  ? kvm_sched_clock_read+0x11/0x20
[   99.865595]  ? sched_clock+0x9/0x10
[   99.866453]  ? sched_clock_cpu+0x11/0xb0
[   99.867326]  ? newidle_balance+0x1d4/0x3c0
[   99.868283]  io_issue_sqe+0xd8f/0x1340
[   99.869216]  ? __switch_to+0x7f/0x450
[   99.870280]  ? __switch_to_asm+0x42/0x70
[   99.871254]  ? __switch_to_asm+0x36/0x70
[   99.872133]  ? lock_timer_base+0x72/0xa0
[   99.873155]  ? switch_mm_irqs_off+0x1bf/0x420
[   99.874152]  io_wq_submit_work+0x64/0x180
[   99.875192]  ? kthread_use_mm+0x71/0x100
[   99.876132]  io_worker_handle_work+0x267/0x440
[   99.877233]  io_wqe_worker+0x297/0x350
[   99.878145]  kthread+0x112/0x150
[   99.878849]  ? __io_worker_unuse+0x100/0x100
[   99.879935]  ? kthread_park+0x90/0x90
[   99.880874]  ret_from_fork+0x22/0x30
[   99.881679] Modules linked in:
[   99.882493] CR2: 0000000000000000
[   99.883324] ---[ end trace 4453745f4673190b ]---
[   99.884289] RIP: 0010:0x0
[   99.884837] Code: Bad RIP value.
[   99.885492] RSP: 0018:ffffa1c7c01ebc08 EFLAGS: 00010202
[   99.886851] RAX: 0000000000000000 RBX: ffff92363acd7f00 RCX: ffff92363d461608
[   99.888561] RDX: 0000000000000010 RSI: 00007ffe040d9e10 RDI: ffff92363acd7f00
[   99.890203] RBP: ffffa1c7c01ebc40 R08: 0000000000000000 R09: 0000000000000000
[   99.891907] R10: ffffffff9ec692a0 R11: 0000000000000000 R12: 0000000000000010
[   99.894106] R13: 0000000000000000 R14: ffff92363d461608 R15: ffffa1c7c01ebc68
[   99.896079] FS:  0000000000000000(0000) GS:ffff92363dd00000(0000) knlGS:0000000000000000
[   99.898017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   99.899197] CR2: ffffffffffffffd6 CR3: 000000007ac66000 CR4: 00000000000006e0

Fixes: 32960613b7c3 ("io_uring: correctly handle non ->{read,write}_iter() file_operations")
Cc: stable@vger.kernel.org
Signed-off-by: Guoyu Huang <hgy5945@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index be3d595a607f..6a6d08bf3737 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1433,8 +1433,10 @@ static int io_read(struct io_kiocb *req, const struct sqe_submit *s,
 
 		if (file->f_op->read_iter)
 			ret2 = call_read_iter(file, kiocb, &iter);
-		else
+		else if (req->file->f_op->read)
 			ret2 = loop_rw_iter(READ, file, kiocb, &iter);
+		else
+			ret2 = -EINVAL;
 
 		/*
 		 * In case of a short read, punt to async. This can happen
@@ -1524,8 +1526,10 @@ static int io_write(struct io_kiocb *req, const struct sqe_submit *s,
 
 		if (file->f_op->write_iter)
 			ret2 = call_write_iter(file, kiocb, &iter);
-		else
+		else if (req->file->f_op->write)
 			ret2 = loop_rw_iter(WRITE, file, kiocb, &iter);
+		else
+			ret2 = -EINVAL;
 
 		if (!force_nonblock)
 			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;

-- 
Jens Axboe

