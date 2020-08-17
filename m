Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C8724673C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgHQNQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728614AbgHQNQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:16:28 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C130BC061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:16:25 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id m71so8236316pfd.1
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=a+IB66eM1DwAPYpxqZ3OhS9485LnlLYbTh7zmRRUpQ0=;
        b=jpu8uM4Vk3CmRHKBp4lIpijJTbF60VzOjVOeAMgY+CO7FYKqqrA+dszvj81dC8Vctd
         IXio5gABLkELnS6hnUX5aey70gbwo85y5ifxQi+S+Dzieribg9+2691IXjbheWrgRvUS
         wQ0g+QU+OgvCV0IJ5yyYW2H/E5FfvPYOQaNr+lbzjEWdr2k9UboZo7t9hf8XjbcxJoC6
         VUFFOWfote1gYOedGWt8jkEhFCxVdEztWRf1Qxi1yiU2Hv/AUP1LgyJRhFWgQdw65jI+
         pOVe6NjPEMi5gRz6UaQ6lX2gcY6K/NsNsH48TlQRoG9YyyvucKwIL2gtuZkaxb66RZ5B
         TcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=a+IB66eM1DwAPYpxqZ3OhS9485LnlLYbTh7zmRRUpQ0=;
        b=NozWbreJxgowecxfTBxttWOyxrhcoL5Jz8+wWaZaqUu6FifUDvBS86qieBtPows3ak
         R3W9GPXVXp4Yy4ZFENGQlhvovQy0UheeBfDaHdxKzSDz+DsF05Q2nr5cgWIhY3/6Gjco
         kHqb/ahTs2EspMEihTz5ztbl3owgC+StjxAWwllf9OhEZHMZbYiHCpTnOKIe3BgDnmba
         heXz4fyYBErkn2hZhPph0fdEHVs5LyrMLcuxSWFFiCOxSoqh+VQMeYYF73ksJegvGCBY
         wrgCMs4YLo08TG2VX3xymJwqrOpCUIQdmz8QkG/WW1IZr4M6K9e9YdtQ2foE9yy/VgQU
         CBNg==
X-Gm-Message-State: AOAM531B1HVBlV/tBP/1C3VgoyykxqR9BpOEXT1Sqv7ZFf/b55uUsKis
        Htuk31kKYAd8S45+/DsH92JZhZvmebwoRQ==
X-Google-Smtp-Source: ABdhPJxmL73bCctP8kj2fyoE7cq6AbCRWDqR2C2tsG84UPCrCY0V1+YSzd/jG6hIzLV5egJ/FooHIw==
X-Received: by 2002:a63:7d8:: with SMTP id 207mr10242086pgh.263.1597670184785;
        Mon, 17 Aug 2020 06:16:24 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ff2c:a74f:a461:daa2? ([2605:e000:100e:8c61:ff2c:a74f:a461:daa2])
        by smtp.gmail.com with ESMTPSA id e7sm17147492pgn.64.2020.08.17.06.16.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 06:16:24 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: Fix NULL pointer dereference in
 loop_rw_iter()" failed to apply to 5.7-stable tree
To:     gregkh@linuxfoundation.org, hgy5945@gmail.com
Cc:     stable@vger.kernel.org
References: <1597661020166103@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <41fb1027-374f-1e9c-2ff7-6e1e008c7d40@kernel.dk>
Date:   Mon, 17 Aug 2020 06:16:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1597661020166103@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------5C582930BFDE31F5F52C710A"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------5C582930BFDE31F5F52C710A
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


--------------5C582930BFDE31F5F52C710A
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-Fix-NULL-pointer-dereference-in-loop_rw_ite.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-Fix-NULL-pointer-dereference-in-loop_rw_ite.pa";
 filename*1="tch"

From 9c6263b8ae6ed9e998661c0b833ac92db93348db Mon Sep 17 00:00:00 2001
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
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 11bb49fa9593..0e31215f87fe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2602,8 +2602,10 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 
 		if (req->file->f_op->read_iter)
 			ret2 = call_read_iter(req->file, kiocb, &iter);
-		else
+		else if (req->file->f_op->read)
 			ret2 = loop_rw_iter(READ, req->file, kiocb, &iter);
+		else
+			ret2 = -EINVAL;
 
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
@@ -2717,8 +2719,10 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 
 		if (req->file->f_op->write_iter)
 			ret2 = call_write_iter(req->file, kiocb, &iter);
-		else
+		else if (req->file->f_op->write)
 			ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
+		else
+			ret2 = -EINVAL;
 
 		if (!force_nonblock)
 			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
-- 
2.28.0


--------------5C582930BFDE31F5F52C710A--
