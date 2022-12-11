Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84BDA649562
	for <lists+stable@lfdr.de>; Sun, 11 Dec 2022 18:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiLKRdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Dec 2022 12:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbiLKRdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Dec 2022 12:33:03 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53751104
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 09:33:02 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id v3so6726762pgh.4
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 09:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2EbutRdutiyHOUXm8xMoG4DaHQTUrOO9nmXDhdJFMFs=;
        b=nomWbVzhiVNecHYUfe4eJ7BUO5WuzSMcy8RLyqPHERl/apbLYGIwzuEkzli+5oQcyv
         07M2a9cp84LSOjRMh5n3OfV1tQ6IqWUq+4/uee7hfT/NU8NjX8ixl1zAQzqPj4JykcP7
         FiGdA6pQIlRePzOcV7EhK6PIlDdSIUkIDzwXu11BaprRdN1/+Tb420sMsem5dfYkXOvv
         QT67BNf3QP1pYak1aIK5IkXS1mo+zCR2XOWBFOn3Dcus7AB/oFw6H+W+KRdkti21ZZs1
         bWxBD4A55pAsm85ZTE9FJ4aLVEByTFICRtzgNXAdM1z2COGng2QC78/7v2QQLrVLPRvm
         BbKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2EbutRdutiyHOUXm8xMoG4DaHQTUrOO9nmXDhdJFMFs=;
        b=aXIGnQaJrOVu2hroOLCQ8FPHVQqoZWP8OXd/MLKj6rRlVfvzmy6LK+1LsXeXeXBs0H
         ZoiK92SLUNFGptQ1SCs0DwvDNLRVMAalKe3vu8MX30/uWCq3pLB0541sZ21vbnDo8ue/
         +aG5CQGM+eT5IM6Ycn/r4+hTRsTxAiyyggY0R3yWrQYbC3YxsbA082ftXnizoV2v9uqF
         PXXvdzBrdAT6FUtYy2VBLQw60WquLkvRHj9l9M23T6OWsFvrtSbqKEpfEybyb2/9j3ty
         fooCdEMZxLVJufWjrER0H23C0k3gYIDOu+ubm6/L8elK1vJc1HGzkzjKP1FuS9dYpqjG
         deuw==
X-Gm-Message-State: ANoB5pkj2IjvFqFu7kNjYKnmKm3pCjvEZck1LgKMgvMmxrwJUApQsGmB
        6YCZbkPYp+xyGhHzFzHCg8IZlCms5jiK83YwYlM=
X-Google-Smtp-Source: AA0mqf6QDQScyyhmsyPDZgkj/CF15BxLPO2u0L0sQ3aLwTaiOlFOcx5OaTElbPicBUJFCLTcVYqbOg==
X-Received: by 2002:a05:6a00:e0f:b0:56b:a661:5a5a with SMTP id bq15-20020a056a000e0f00b0056ba6615a5amr3080575pfb.2.1670779981705;
        Sun, 11 Dec 2022 09:33:01 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k24-20020aa79738000000b005750d6b4761sm4230151pfg.168.2022.12.11.09.33.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Dec 2022 09:33:00 -0800 (PST)
Message-ID: <24918edb-e6eb-a093-51cf-519c7ece88a3@kernel.dk>
Date:   Sun, 11 Dec 2022 10:32:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: FAILED: patch "[PATCH] io_uring: Fix a null-ptr-deref in
 io_tctx_exit_cb()" failed to apply to 5.15-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, harshit.m.mogalapalli@oracle.com,
        syzkaller@googlegroups.com
Cc:     stable@vger.kernel.org
References: <16707522923183@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <16707522923183@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/11/22 2:51?AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

It does apply fine, but it's in fs/io_uring.c rather than
io_uring/io_uring.c as for the newer kernels. Attached one here that
just does the patch change and it applies witha a slight offset:

checking file fs/io_uring.c
Hunk #1 succeeded at 9467 (offset 6760 lines).


From 998b30c3948e4d0b1097e639918c5cff332acac5 Mon Sep 17 00:00:00 2001
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Date: Tue, 6 Dec 2022 01:38:32 -0800
Subject: [PATCH] io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()

Syzkaller reports a NULL deref bug as follows:

 BUG: KASAN: null-ptr-deref in io_tctx_exit_cb+0x53/0xd3
 Read of size 4 at addr 0000000000000138 by task file1/1955

 CPU: 1 PID: 1955 Comm: file1 Not tainted 6.1.0-rc7-00103-gef4d3ea40565 #75
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0xcd/0x134
  ? io_tctx_exit_cb+0x53/0xd3
  kasan_report+0xbb/0x1f0
  ? io_tctx_exit_cb+0x53/0xd3
  kasan_check_range+0x140/0x190
  io_tctx_exit_cb+0x53/0xd3
  task_work_run+0x164/0x250
  ? task_work_cancel+0x30/0x30
  get_signal+0x1c3/0x2440
  ? lock_downgrade+0x6e0/0x6e0
  ? lock_downgrade+0x6e0/0x6e0
  ? exit_signals+0x8b0/0x8b0
  ? do_raw_read_unlock+0x3b/0x70
  ? do_raw_spin_unlock+0x50/0x230
  arch_do_signal_or_restart+0x82/0x2470
  ? kmem_cache_free+0x260/0x4b0
  ? putname+0xfe/0x140
  ? get_sigframe_size+0x10/0x10
  ? do_execveat_common.isra.0+0x226/0x710
  ? lockdep_hardirqs_on+0x79/0x100
  ? putname+0xfe/0x140
  ? do_execveat_common.isra.0+0x238/0x710
  exit_to_user_mode_prepare+0x15f/0x250
  syscall_exit_to_user_mode+0x19/0x50
  do_syscall_64+0x42/0xb0
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
 RIP: 0023:0x0
 Code: Unable to access opcode bytes at 0xffffffffffffffd6.
 RSP: 002b:00000000fffb7790 EFLAGS: 00000200 ORIG_RAX: 000000000000000b
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
 RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
  </TASK>
 Kernel panic - not syncing: panic_on_warn set ...

This happens because the adding of task_work from io_ring_exit_work()
isn't synchronized with canceling all work items from eg exec. The
execution of the two are ordered in that they are both run by the task
itself, but if io_tctx_exit_cb() is queued while we're canceling all
work items off exec AND gets executed when the task exits to userspace
rather than in the main loop in io_uring_cancel_generic(), then we can
find current->io_uring == NULL and hit the above crash.

It's safe to add this NULL check here, because the execution of the two
paths are done by the task itself.

Cc: stable@vger.kernel.org
Fixes: d56d938b4bef ("io_uring: do ctx initiated file note removal")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20221206093833.3812138-1-harshit.m.mogalapalli@oracle.com
[axboe: add code comment and also put an explanation in the commit msg]
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8840cf3e20f2..61cd7ffd0f6a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2707,8 +2707,10 @@ static __cold void io_tctx_exit_cb(struct callback_head *cb)
 	/*
 	 * When @in_idle, we're in cancellation and it's racy to remove the
 	 * node. It'll be removed by the end of cancellation, just ignore it.
+	 * tctx can be NULL if the queueing of this task_work raced with
+	 * work cancelation off the exec path.
 	 */
-	if (!atomic_read(&tctx->in_idle))
+	if (tctx && !atomic_read(&tctx->in_idle))
 		io_uring_del_tctx_node((unsigned long)work->ctx);
 	complete(&work->completion);
 }


-- 
Jens Axboe

