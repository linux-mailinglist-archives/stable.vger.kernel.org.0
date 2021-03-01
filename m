Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD77327DF9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbhCAMNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:13:21 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:32833 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232283AbhCAMNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 07:13:19 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 83CDD194163B;
        Mon,  1 Mar 2021 07:12:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 07:12:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aVUDdi
        I1p9P7KM6wDiO0PLc5Gcl3w/fh3OWiD92vzE4=; b=rv6JTsQq1jewqiNn+//IZr
        K2Yd2C1dnG6fyvl0DmeB4dPcYVNsKcujX831DsxlfFFp6SnUv8vaXP3v1ZDHf7/I
        SOuN9jcmdQsbVs1lj12hF702FNH9SLbitrae1hsBKqZOZwrQyhhClNs2tyd5FnlB
        ul/0OQhcdMmAEv92wabi84skzjaxBa40rNyLxb9UNPSIahx4Ol9LGL60LAm6YIEr
        5o5EqcpDLkPJQIA91jeAKcgij7vzUQV/s+xLheKtr9X9rKLxEklRBBCMonZ80fU5
        qUJ3SOHnNjTNZy1miR5sIjir0aCvC0xiuHrV6fQq1Q8iIxW8tGnemg9Hg/cDW0jA
        ==
X-ME-Sender: <xms:G9o8YL8LvxFgZknGdaTfTXoo2yTJVQG4G0K49K3E6YwOHUZ3zptfsQ>
    <xme:G9o8YHu27_BIFQrHm0cQzEHH693bgoWTOybtpWn221UVEHhQ6725ElLiFET8tPlbb
    A8zaYAKVh23Ug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:G9o8YJCMx87WlAnUILpto3bjJBO-uqSG0dcsXragWoXTOR5mi7N9cQ>
    <xmx:G9o8YHel4wxHEQEHEZobyGk-P5FHe-FaRMbc88hkEODGBZLf32TkkA>
    <xmx:G9o8YAMijvukC0f3kLHMI4klDnpGq5XdzAe9Ss7Uc-_dA27j2rF3jQ>
    <xmx:G9o8YKWrI4H1BpdN4OiSprPDhNxYW8uW-jHp89hJCwKTi6Hinr6x9g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DC261240057;
        Mon,  1 Mar 2021 07:12:10 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: fix inconsistent lock state" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 13:12:00 +0100
Message-ID: <161460072068230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9ae1f8dd372e0e4c020b345cf9e09f519265e981 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 1 Feb 2021 18:59:51 +0000
Subject: [PATCH] io_uring: fix inconsistent lock state

WARNING: inconsistent lock state

inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
syz-executor217/8450 [HC1[1]:SC0[0]:HE0:SE1] takes:
ffff888023d6e620 (&fs->lock){?.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff888023d6e620 (&fs->lock){?.+.}-{2:2}, at: io_req_clean_work fs/io_uring.c:1398 [inline]
ffff888023d6e620 (&fs->lock){?.+.}-{2:2}, at: io_dismantle_req+0x66f/0xf60 fs/io_uring.c:2029

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&fs->lock);
  <Interrupt>
    lock(&fs->lock);

 *** DEADLOCK ***

1 lock held by syz-executor217/8450:
 #0: ffff88802417c3e8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x1071/0x1f30 fs/io_uring.c:9442

stack backtrace:
CPU: 1 PID: 8450 Comm: syz-executor217 Not tainted 5.11.0-rc5-next-20210129-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
[...]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 io_req_clean_work fs/io_uring.c:1398 [inline]
 io_dismantle_req+0x66f/0xf60 fs/io_uring.c:2029
 __io_free_req+0x3d/0x2e0 fs/io_uring.c:2046
 io_free_req fs/io_uring.c:2269 [inline]
 io_double_put_req fs/io_uring.c:2392 [inline]
 io_put_req+0xf9/0x570 fs/io_uring.c:2388
 io_link_timeout_fn+0x30c/0x480 fs/io_uring.c:6497
 __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
 __hrtimer_run_queues+0x609/0xe40 kernel/time/hrtimer.c:1583
 hrtimer_interrupt+0x334/0x940 kernel/time/hrtimer.c:1645
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1085 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1102
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_sysvec_on_irqstack arch/x86/include/asm/irq_stack.h:37 [inline]
 run_sysvec_on_irqstack_cond arch/x86/include/asm/irq_stack.h:89 [inline]
 sysvec_apic_timer_interrupt+0xbd/0x100 arch/x86/kernel/apic/apic.c:1096
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:629
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x25/0x40 kernel/locking/spinlock.c:199
 spin_unlock_irq include/linux/spinlock.h:404 [inline]
 io_queue_linked_timeout+0x194/0x1f0 fs/io_uring.c:6525
 __io_queue_sqe+0x328/0x1290 fs/io_uring.c:6594
 io_queue_sqe+0x631/0x10d0 fs/io_uring.c:6639
 io_queue_link_head fs/io_uring.c:6650 [inline]
 io_submit_sqe fs/io_uring.c:6697 [inline]
 io_submit_sqes+0x19b5/0x2720 fs/io_uring.c:6960
 __do_sys_io_uring_enter+0x107d/0x1f30 fs/io_uring.c:9443
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Don't free requests from under hrtimer context (softirq) as it may sleep
or take spinlocks improperly (e.g. non-irq versions).

Cc: stable@vger.kernel.org # 5.6+
Reported-by: syzbot+81d17233a2b02eafba33@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6711200ece22..1310c074f4cc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1886,8 +1886,8 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 	__io_cqring_fill_event(req, res, 0);
 }
 
-static void io_req_complete_nostate(struct io_kiocb *req, long res,
-				    unsigned int cflags)
+static void io_req_complete_post(struct io_kiocb *req, long res,
+				 unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
@@ -1898,6 +1898,12 @@ static void io_req_complete_nostate(struct io_kiocb *req, long res,
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	io_cqring_ev_posted(ctx);
+}
+
+static inline void io_req_complete_nostate(struct io_kiocb *req, long res,
+					   unsigned int cflags)
+{
+	io_req_complete_post(req, res, cflags);
 	io_put_req(req);
 }
 
@@ -6489,9 +6495,10 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	if (prev) {
 		req_set_fail_links(prev);
 		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
-		io_put_req(prev);
+		io_put_req_deferred(prev, 1);
 	} else {
-		io_req_complete(req, -ETIME);
+		io_req_complete_post(req, -ETIME, 0);
+		io_put_req_deferred(req, 1);
 	}
 	return HRTIMER_NORESTART;
 }

