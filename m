Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D900730A81D
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 13:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhBAMzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 07:55:41 -0500
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:53073 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231516AbhBAMzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 07:55:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C0CF27DC;
        Mon,  1 Feb 2021 07:54:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Feb 2021 07:54:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XfrqyT
        9Ju+2LhJ3o/dXHpA5psRGl0MLx9OQcfJx0bT8=; b=Cnp5QjXSkTL05llyY1IDfQ
        AK1JDfwnF+LrhYnIfZxA6fIWzT3keHedwopZQgOYylWnCyEKWHxV9+TuwbzCqjSV
        6GWuU87JQi8sKEFERb7t1cASVekDvDIa74Pz3EOXV64cDtacUWzswjsfPKyw5PEN
        r2jF6meIlXdjD8nhyt2IV2vWhFBgHGOKfBLhCP5mFU30R/W/ORZCzaULfgu53QmS
        +vedoC9Cj02cQb/UEJk9uzhnxio49Hatj2dgKz+cJmDMNk33Wb4ULwFXDXFzPxds
        57aufDP9bgwbwY/5imRYMIyyDpXHseH263xDulcR5vDz7u7fHv8sei/qXQgSVMMw
        ==
X-ME-Sender: <xms:APoXYJm-rMJ-e7JJvmJJ9khJXQcEtdT98vARENd53K9LuD2m2qE2SA>
    <xme:APoXYE25zMH0_bS4xfnEHCP407MU69ykj4FBo0NMauiNB3ZeiPUKpYdJY0jDy07_b
    aHykf2A4dVA6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:APoXYPprAgMDa2ynpOibCg8uJmADFKhQ7UlhKDGQFTYtXmOqNhgpKA>
    <xmx:APoXYJkBZhB0RQWPbs3dxx4pY8WVHzCH58O_KFUycWarcDchZZ9qFQ>
    <xmx:APoXYH3oLQRppTA60ZHmGJ-rAgqATHmMMzBQwSef3QzEdDaLwPEqgQ>
    <xmx:APoXYE9Oz-3U6aE9ifr6XBGWKY95waAWfj7ML_b8umP0-upF4yuSlCM8j08>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1A1611080057;
        Mon,  1 Feb 2021 07:54:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: fix list corruption for splice file_get" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 13:54:23 +0100
Message-ID: <161218406313176@kroah.com>
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

From f609cbb8911e40e15f9055e8f945f926ac906924 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 28 Jan 2021 18:39:24 +0000
Subject: [PATCH] io_uring: fix list corruption for splice file_get

kernel BUG at lib/list_debug.c:29!
Call Trace:
 __list_add include/linux/list.h:67 [inline]
 list_add include/linux/list.h:86 [inline]
 io_file_get+0x8cc/0xdb0 fs/io_uring.c:6466
 __io_splice_prep+0x1bc/0x530 fs/io_uring.c:3866
 io_splice_prep fs/io_uring.c:3920 [inline]
 io_req_prep+0x3546/0x4e80 fs/io_uring.c:6081
 io_queue_sqe+0x609/0x10d0 fs/io_uring.c:6628
 io_submit_sqe fs/io_uring.c:6705 [inline]
 io_submit_sqes+0x1495/0x2720 fs/io_uring.c:6953
 __do_sys_io_uring_enter+0x107d/0x1f30 fs/io_uring.c:9353
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

io_file_get() may be called from splice, and so REQ_F_INFLIGHT may
already be set.

Fixes: 02a13674fa0e8 ("io_uring: account io_uring internal files as REQ_F_INFLIGHT")
Cc: stable@vger.kernel.org # 5.9+
Reported-by: syzbot+6879187cf57845801267@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ae388cc52843..39ae1f821cef 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6460,7 +6460,8 @@ static struct file *io_file_get(struct io_submit_state *state,
 		file = __io_file_get(state, fd);
 	}
 
-	if (file && file->f_op == &io_uring_fops) {
+	if (file && file->f_op == &io_uring_fops &&
+	    !(req->flags & REQ_F_INFLIGHT)) {
 		io_req_init_async(req);
 		req->flags |= REQ_F_INFLIGHT;
 

