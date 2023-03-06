Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F056ABD38
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 11:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjCFKst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 05:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjCFKss (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 05:48:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C0222031
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 02:48:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31CE560DE9
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 10:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453A4C433EF;
        Mon,  6 Mar 2023 10:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678099724;
        bh=IrPU1DgfnAJREkVUhpqqiuWDsEAhH6/ceLvUvqEfUac=;
        h=Subject:To:Cc:From:Date:From;
        b=KCKgAKxpCVXaw5baY+iy+8zZmkSAEZI1ytEHBBnDKh5EsNNg1IrrCbdjGroIjybug
         UW4Vg9h06HMo2wXX3Z3/5Yv0Qj5OLf8zmp5ZRFw8x/JVFP5HAZHulmYzN7XU6v/uL2
         LulCjBc7rsWB+ifNo0Mx53pGfYdiPgiXy2ugUB1Y=
Subject: FAILED: patch "[PATCH] io_uring: add a conditional reschedule to the IOPOLL" failed to apply to 5.10-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 11:48:42 +0100
Message-ID: <167809972215341@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x fcc926bb857949dbfa51a7d95f3f5ebc657f198c
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167809972215341@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

fcc926bb8579 ("io_uring: add a conditional reschedule to the IOPOLL cancelation loop")
affa87db9010 ("io_uring: fix multi ctx cancellation")
9ca9fb24d5fe ("io_uring: mutex locked poll hashing")
e6f89be61410 ("io_uring: introduce a struct for hash table")
a2cdd5193218 ("io_uring: pass hash table into poll_find")
0ec6dca22319 ("io_uring: use state completion infra for poll reqs")
8b1dfd343ae6 ("io_uring: clean up io_ring_ctx_alloc")
4a07723fb4bb ("io_uring: limit the number of cancellation buckets")
1ab1edb0a104 ("io_uring: pass poll_find lock back")
38513c464d3d ("io_uring: switch cancel_hash to use per entry spinlock")
aff5b2df9e8b ("io_uring: better caching for ctx timeout fields")
735729844819 ("io_uring: move rsrc related data, core, and commands")
3b77495a9723 ("io_uring: split provided buffers handling into its own file")
7aaff708a768 ("io_uring: move cancelation into its own file")
329061d3e2f9 ("io_uring: move poll handling into its own file")
cfd22e6b3319 ("io_uring: add opcode name to io_op_defs")
92ac8beaea1f ("io_uring: include and forward-declaration sanitation")
c9f06aa7de15 ("io_uring: move io_uring_task (tctx) helpers into its own file")
a4ad4f748ea9 ("io_uring: move fdinfo helpers to its own file")
e5550a1447bf ("io_uring: use io_is_uring_fops() consistently")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fcc926bb857949dbfa51a7d95f3f5ebc657f198c Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 27 Jan 2023 09:28:13 -0700
Subject: [PATCH] io_uring: add a conditional reschedule to the IOPOLL
 cancelation loop

If the kernel is configured with CONFIG_PREEMPT_NONE, we could be
sitting in a tight loop reaping events but not giving them a chance to
finish. This results in a trace ala:

rcu: INFO: rcu_sched self-detected stall on CPU
rcu: 	2-...!: (5249 ticks this GP) idle=935c/1/0x4000000000000000 softirq=4265/4274 fqs=1
	(t=5251 jiffies g=465 q=4135 ncpus=4)
rcu: rcu_sched kthread starved for 5249 jiffies! g465 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_sched kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_sched       state:R  running task     stack:0     pid:12    ppid:2      flags:0x00000008
Call trace:
 __switch_to+0xb0/0xc8
 __schedule+0x43c/0x520
 schedule+0x4c/0x98
 schedule_timeout+0xbc/0xdc
 rcu_gp_fqs_loop+0x308/0x344
 rcu_gp_kthread+0xd8/0xf0
 kthread+0xb8/0xc8
 ret_from_fork+0x10/0x20
rcu: Stack dump where RCU GP kthread last ran:
Task dump for CPU 0:
task:kworker/u8:10   state:R  running task     stack:0     pid:89    ppid:2      flags:0x0000000a
Workqueue: events_unbound io_ring_exit_work
Call trace:
 __switch_to+0xb0/0xc8
 0xffff0000c8fefd28
CPU: 2 PID: 95 Comm: kworker/u8:13 Not tainted 6.2.0-rc5-00042-g40316e337c80-dirty #2759
Hardware name: linux,dummy-virt (DT)
Workqueue: events_unbound io_ring_exit_work
pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : io_do_iopoll+0x344/0x360
lr : io_do_iopoll+0xb8/0x360
sp : ffff800009bebc60
x29: ffff800009bebc60 x28: 0000000000000000 x27: 0000000000000000
x26: ffff0000c0f67d48 x25: ffff0000c0f67840 x24: ffff800008950024
x23: 0000000000000001 x22: 0000000000000000 x21: ffff0000c27d3200
x20: ffff0000c0f67840 x19: ffff0000c0f67800 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000001 x13: 0000000000000001 x12: 0000000000000000
x11: 0000000000000179 x10: 0000000000000870 x9 : ffff800009bebd60
x8 : ffff0000c27d3ad0 x7 : fefefefefefefeff x6 : 0000646e756f626e
x5 : ffff0000c0f67840 x4 : 0000000000000000 x3 : ffff0000c2398000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_do_iopoll+0x344/0x360
 io_uring_try_cancel_requests+0x21c/0x334
 io_ring_exit_work+0x90/0x40c
 process_one_work+0x1a4/0x254
 worker_thread+0x1ec/0x258
 kthread+0xb8/0xc8
 ret_from_fork+0x10/0x20

Add a cond_resched() in the cancelation IOPOLL loop to fix this.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9c92ca081c11..fab581a31dc1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3160,6 +3160,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		while (!wq_list_empty(&ctx->iopoll_list)) {
 			io_iopoll_try_reap_events(ctx);
 			ret = true;
+			cond_resched();
 		}
 	}
 

