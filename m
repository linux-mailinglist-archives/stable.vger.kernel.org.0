Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE1B330BF5
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 12:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhCHLIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 06:08:09 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:51799 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230047AbhCHLHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 06:07:44 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 27BB01940690;
        Mon,  8 Mar 2021 06:07:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 08 Mar 2021 06:07:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YuzP5/
        9wg+U0ok/mw7YuuI/hicmon5amIrBGb28kMKg=; b=QyEJMfU2Vp58kirZt58ajV
        /HGG8eubEwvMeXOxZXHhM/T1ZmXDcfHT6a+J6K/0s5Ji2OreSO9CBElFXhax3r6B
        h0hSMGjoRut9rA0U7Pc7FRrl88VP3mxOWgLpiWUPDRl0pEQNNAwEnJiHo85O5Acf
        w61NqM73oY3diQYcIvkWnPV8sz86fsC2lN3EW/B99GhdryySoNMPrSeedMIXC2KI
        476j+w7MlOAd3vcZitOCS+CqdIBwRuWlZw9gL83JpoC3w78tyBOFURBWfWbQlwZC
        0qJkfbb8CYOkUIPYh9qdud28O5ZJppFlkiDFZwJEL4uGkaw4Wc5YOzL9KksBHQrg
        ==
X-ME-Sender: <xms:gAVGYGFBXg90LWEauu-PLky1jXXb1enf6tIuDEwInF7_vBlxAbTjPQ>
    <xme:gAVGYHUYQeXyrc80vV9oV80k5mgnCzpx3pUd78uD-FZPwCVwyEonFYnlq5fmlQLFG
    H0IhuzpJvWhxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudduvddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:gAVGYALg7BHRPqe_z1e8QIhw5-zV4dxliOED8Q9lLzpIbcdnEkhzuQ>
    <xmx:gAVGYAGZ2PWRMZmZLMqilsAXOz1k9PR0_eQJY_Ibspr3pdFR-AtFaA>
    <xmx:gAVGYMXP3205azLSi0H2F3BI7ilhiy1zdhOCCEZCDcOoVzOizAolcQ>
    <xmx:gAVGYJgwKUsitWVhVWpEM0droTDZD-NA4xbhHdZ41WMCNF-t20bZzg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BD6001080059;
        Mon,  8 Mar 2021 06:07:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: don't hold uring_lock when calling" failed to apply to 5.10-stable tree
To:     haoxu@linux.alibaba.com, abaci@linux.alibaba.com,
        asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Mar 2021 12:07:33 +0100
Message-ID: <1615201653167153@kroah.com>
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

From 8bad28d8a305b0e5ae444c8c3051e8744f5a4296 Mon Sep 17 00:00:00 2001
From: Hao Xu <haoxu@linux.alibaba.com>
Date: Fri, 19 Feb 2021 17:19:36 +0800
Subject: [PATCH] io_uring: don't hold uring_lock when calling
 io_run_task_work*

Abaci reported the below issue:
[  141.400455] hrtimer: interrupt took 205853 ns
[  189.869316] process 'usr/local/ilogtail/ilogtail_0.16.26' started with executable stack
[  250.188042]
[  250.188327] ============================================
[  250.189015] WARNING: possible recursive locking detected
[  250.189732] 5.11.0-rc4 #1 Not tainted
[  250.190267] --------------------------------------------
[  250.190917] a.out/7363 is trying to acquire lock:
[  250.191506] ffff888114dbcbe8 (&ctx->uring_lock){+.+.}-{3:3}, at: __io_req_task_submit+0x29/0xa0
[  250.192599]
[  250.192599] but task is already holding lock:
[  250.193309] ffff888114dbfbe8 (&ctx->uring_lock){+.+.}-{3:3}, at: __x64_sys_io_uring_register+0xad/0x210
[  250.194426]
[  250.194426] other info that might help us debug this:
[  250.195238]  Possible unsafe locking scenario:
[  250.195238]
[  250.196019]        CPU0
[  250.196411]        ----
[  250.196803]   lock(&ctx->uring_lock);
[  250.197420]   lock(&ctx->uring_lock);
[  250.197966]
[  250.197966]  *** DEADLOCK ***
[  250.197966]
[  250.198837]  May be due to missing lock nesting notation
[  250.198837]
[  250.199780] 1 lock held by a.out/7363:
[  250.200373]  #0: ffff888114dbfbe8 (&ctx->uring_lock){+.+.}-{3:3}, at: __x64_sys_io_uring_register+0xad/0x210
[  250.201645]
[  250.201645] stack backtrace:
[  250.202298] CPU: 0 PID: 7363 Comm: a.out Not tainted 5.11.0-rc4 #1
[  250.203144] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  250.203887] Call Trace:
[  250.204302]  dump_stack+0xac/0xe3
[  250.204804]  __lock_acquire+0xab6/0x13a0
[  250.205392]  lock_acquire+0x2c3/0x390
[  250.205928]  ? __io_req_task_submit+0x29/0xa0
[  250.206541]  __mutex_lock+0xae/0x9f0
[  250.207071]  ? __io_req_task_submit+0x29/0xa0
[  250.207745]  ? 0xffffffffa0006083
[  250.208248]  ? __io_req_task_submit+0x29/0xa0
[  250.208845]  ? __io_req_task_submit+0x29/0xa0
[  250.209452]  ? __io_req_task_submit+0x5/0xa0
[  250.210083]  __io_req_task_submit+0x29/0xa0
[  250.210687]  io_async_task_func+0x23d/0x4c0
[  250.211278]  task_work_run+0x89/0xd0
[  250.211884]  io_run_task_work_sig+0x50/0xc0
[  250.212464]  io_sqe_files_unregister+0xb2/0x1f0
[  250.213109]  __io_uring_register+0x115a/0x1750
[  250.213718]  ? __x64_sys_io_uring_register+0xad/0x210
[  250.214395]  ? __fget_files+0x15a/0x260
[  250.214956]  __x64_sys_io_uring_register+0xbe/0x210
[  250.215620]  ? trace_hardirqs_on+0x46/0x110
[  250.216205]  do_syscall_64+0x2d/0x40
[  250.216731]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  250.217455] RIP: 0033:0x7f0fa17e5239
[  250.218034] Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05  3d 01 f0 ff ff 73 01 c3 48 8b 0d 27 ec 2c 00 f7 d8 64 89 01 48
[  250.220343] RSP: 002b:00007f0fa1eeac48 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
[  250.221360] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0fa17e5239
[  250.222272] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000008
[  250.223185] RBP: 00007f0fa1eeae20 R08: 0000000000000000 R09: 0000000000000000
[  250.224091] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  250.224999] R13: 0000000000021000 R14: 0000000000000000 R15: 00007f0fa1eeb700

This is caused by calling io_run_task_work_sig() to do work under
uring_lock while the caller io_sqe_files_unregister() already held
uring_lock.
To fix this issue, briefly drop uring_lock when calling
io_run_task_work_sig(), and there are two things to concern:

- hold uring_lock in io_ring_ctx_free() around io_sqe_files_unregister()
    this is for consistency of lock/unlock.
- add new fixed rsrc ref node before dropping uring_lock
    it's not safe to do io_uring_enter-->percpu_ref_get() with a dying one.
- check if rsrc_data->refs is dying to avoid parallel io_sqe_files_unregister

Reported-by: Abaci <abaci@linux.alibaba.com>
Fixes: 1ffc54220c44 ("io_uring: fix io_sqe_files_unregister() hangs")
Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
[axboe: fixes from Pavel folded in]
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 582306b1dfd1..7956c6751a67 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -236,6 +236,7 @@ struct fixed_rsrc_data {
 	struct fixed_rsrc_ref_node	*node;
 	struct percpu_ref		refs;
 	struct completion		done;
+	bool				quiesce;
 };
 
 struct io_buffer {
@@ -7316,38 +7317,57 @@ static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
 	percpu_ref_get(&rsrc_data->refs);
 }
 
-static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
-			       struct io_ring_ctx *ctx,
-			       struct fixed_rsrc_ref_node *backup_node)
+static void io_sqe_rsrc_kill_node(struct io_ring_ctx *ctx, struct fixed_rsrc_data *data)
 {
-	struct fixed_rsrc_ref_node *ref_node;
-	int ret;
+	struct fixed_rsrc_ref_node *ref_node = NULL;
 
 	io_rsrc_ref_lock(ctx);
 	ref_node = data->node;
 	io_rsrc_ref_unlock(ctx);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
+}
+
+static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
+			       struct io_ring_ctx *ctx,
+			       struct fixed_rsrc_ref_node *backup_node)
+{
+	int ret;
 
-	percpu_ref_kill(&data->refs);
+	if (data->quiesce)
+		return -ENXIO;
 
-	/* wait for all refs nodes to complete */
-	flush_delayed_work(&ctx->rsrc_put_work);
+	data->quiesce = true;
 	do {
+		io_sqe_rsrc_kill_node(ctx, data);
+		percpu_ref_kill(&data->refs);
+		flush_delayed_work(&ctx->rsrc_put_work);
+
 		ret = wait_for_completion_interruptible(&data->done);
 		if (!ret)
 			break;
+
+		percpu_ref_resurrect(&data->refs);
+		io_sqe_rsrc_set_node(ctx, data, backup_node);
+		backup_node = NULL;
+		reinit_completion(&data->done);
+		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
-		if (ret < 0) {
-			percpu_ref_resurrect(&data->refs);
-			reinit_completion(&data->done);
-			io_sqe_rsrc_set_node(ctx, data, backup_node);
-			return ret;
-		}
+		mutex_lock(&ctx->uring_lock);
+
+		if (ret < 0)
+			break;
+		backup_node = alloc_fixed_rsrc_ref_node(ctx);
+		ret = -ENOMEM;
+		if (!backup_node)
+			break;
+		init_fixed_file_ref_node(ctx, backup_node);
 	} while (1);
+	data->quiesce = false;
 
-	destroy_fixed_rsrc_ref_node(backup_node);
-	return 0;
+	if (backup_node)
+		destroy_fixed_rsrc_ref_node(backup_node);
+	return ret;
 }
 
 static struct fixed_rsrc_data *alloc_fixed_rsrc_data(struct io_ring_ctx *ctx)
@@ -7382,7 +7402,12 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	unsigned nr_tables, i;
 	int ret;
 
-	if (!data)
+	/*
+	 * percpu_ref_is_dying() is to stop parallel files unregister
+	 * Since we possibly drop uring lock later in this function to
+	 * run task work.
+	 */
+	if (!data || percpu_ref_is_dying(&data->refs))
 		return -ENXIO;
 	backup_node = alloc_fixed_rsrc_ref_node(ctx);
 	if (!backup_node)
@@ -8731,7 +8756,9 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		css_put(ctx->sqo_blkcg_css);
 #endif
 
+	mutex_lock(&ctx->uring_lock);
 	io_sqe_files_unregister(ctx);
+	mutex_unlock(&ctx->uring_lock);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
 	idr_destroy(&ctx->personality_idr);

