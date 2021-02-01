Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6824F30A81C
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 13:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhBAMzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 07:55:25 -0500
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:50985 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231516AbhBAMzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 07:55:20 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id A7E3E7AE;
        Mon,  1 Feb 2021 07:54:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 01 Feb 2021 07:54:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=U0UMHX
        BDDIxZgcYZ1Ou7zu73g0IX5EQpb91fr9fFH3Y=; b=jy5sz1nvFyF3W8MKOqgE1x
        oIcC14zmv65Z2RB4Yr4apw8fikgyANrytSO5OrbPwHlv8WTck2l+lb+b2no+e//S
        QSK6CR3cZ6p7oSiCxds/FHkeSQ4gjP/1lLd0F243j1eB4DhCCuhY0HmBvhCQhFQE
        83Nf2vPgAddLel/NbLWuSdcc4uhYe840CeeY8G2+sUsiv7o2BlJ7h642A/IBe/mQ
        +oirN/J+YpSEPQBXV7BBiPDou5Q+Xys9PQVPKeGVC/ce/fR9GE/L4gzQmSnHE224
        CQK1iPDLHAqKp7OQCHtHnbHEsZ338LXVCAvjHN+1XQ5LQqmPAVGMLw6xgpzT3xHw
        ==
X-ME-Sender: <xms:CPoXYHXhr4wMYO3IRV5ia3vpCB7eha8VnhseHAy-Z31Z5IPN4MmbwA>
    <xme:CPoXYGndfJw0xL_FjHPyFDanxqTO6SvD9uVAP95KBIpVTo5iurYKeHwm03mgOENtd
    lEFabNiUYq97A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:CPoXYIapzGh-Nrp2-eYLXd9YSjkNH8-W0FYhvdxghWV0Ng1K8iym_Q>
    <xmx:CPoXYBOgGtTrPtHGmpI_vp6vZ1o92PShNa8IPLIWIfsRWkcsR5AD9w>
    <xmx:CPoXYNZv7PORU1RIfAlyJYhOB76iO0N1bgqYKWVHtS2Y2p4wXlDf_A>
    <xmx:CPoXYM9UvSGJk-ekt_paqAvpAfTIJuEk7Ayu2rFeJRzD3TgUQqrHA_kazl0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B902B24005D;
        Mon,  1 Feb 2021 07:54:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: fix sqo ownership false positive warning" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 13:54:30 +0100
Message-ID: <161218407067144@kroah.com>
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

From 70b2c60d3797bffe182dddb9bb55975b9be5889a Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 28 Jan 2021 18:39:25 +0000
Subject: [PATCH] io_uring: fix sqo ownership false positive warning

WARNING: CPU: 0 PID: 21359 at fs/io_uring.c:9042
    io_uring_cancel_task_requests+0xe55/0x10c0 fs/io_uring.c:9042
Call Trace:
 io_uring_flush+0x47b/0x6e0 fs/io_uring.c:9227
 filp_close+0xb4/0x170 fs/open.c:1295
 close_files fs/file.c:403 [inline]
 put_files_struct fs/file.c:418 [inline]
 put_files_struct+0x1cc/0x350 fs/file.c:415
 exit_files+0x7e/0xa0 fs/file.c:435
 do_exit+0xc22/0x2ae0 kernel/exit.c:820
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x427/0x20f0 kernel/signal.c:2773
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Now io_uring_cancel_task_requests() can be called not through file
notes but directly, remove a WARN_ONCE() there that give us false
positives. That check is not very important and we catch it in other
places.

Fixes: 84965ff8a84f0 ("io_uring: if we see flush on exit, cancel related tasks")
Cc: stable@vger.kernel.org # 5.9+
Reported-by: syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 39ae1f821cef..12bf7180c0f1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8967,8 +8967,6 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	struct task_struct *task = current;
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
-		/* for SQPOLL only sqo_task has task notes */
-		WARN_ON_ONCE(ctx->sqo_task != current);
 		io_disable_sqo_submit(ctx);
 		task = ctx->sq_data->thread;
 		atomic_inc(&task->io_uring->in_idle);

