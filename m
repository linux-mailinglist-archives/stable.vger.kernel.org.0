Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DCD377DF5
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhEJIUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:20:38 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:40471 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230116AbhEJIUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:20:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3EF9A1940BDE;
        Mon, 10 May 2021 04:19:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 10 May 2021 04:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=M4XSYU
        2ORGSfTLqj2zOnZR2G4Ae0dNcLlqeT6SxwyHI=; b=Z5jTuGAYxjhFQgFPkR6dTA
        p2LTLxu/5YCV4Wjt71h6ZqkJj48be9BUCux8N7jJ6vHwu9+92NCQiwNtKX9jKSQg
        zSJX/J/EOjK0dDlzI8mfuvh3gCAz3z6ymKl0WHvoeoPAdJiDHAzKpigPnFzqdAZ+
        xpjbQcOlepITFBqpaCYeOcWE+0uA1N7Wm/3Px3+fe+BQkUwIE223mVXbcF8DpKpu
        NwHC3KxE2mdybZwdRL0V7q9vSpE3i8lyDUVBnOrrziwN4cLM8KN3YoGmjU0qKyUb
        udXrpH1ciR65tHP2QB4nUR1U0DSasXZJ4MLqVCAcm+EUsY4eVI/k1vjPztrfcjbA
        ==
X-ME-Sender: <xms:k-yYYNSsb0d9EOyaMcj8C6DvySZoeOt0ecmD9q__-_zvF0-uTqCJsw>
    <xme:k-yYYGwqOTP94xP48CE-D0e3knVUB4Foe9tlh79gYirGFxyS0HiOkqiA45jn0xa4x
    1_4Zo6e4TPRPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:k-yYYC1wZOYm929DPe-0F9kUcCU9t7SE5cX6FHEl_Trps3oiYkl45A>
    <xmx:k-yYYFCd6wnV23AnCpO0jAwTthar9iRwm9usXj43SQIFo0M8F9FxUQ>
    <xmx:k-yYYGifq4o56tjhYD0dJwj_hRg8mg6pmj5-KETwxDoMCN40rsSPew>
    <xmx:k-yYYOKFbGbECjRHwH6BY2TbkhSfqKa_26FM1RoPSSvf-Do0pshe8g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:19:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: Check current->io_uring in io_uring_cancel_sqpoll" failed to apply to 5.11-stable tree
To:     hello@oswalpalash.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:19:21 +0200
Message-ID: <1620634761889@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6d042ffb598ed83e7d5623cc961d249def5b9829 Mon Sep 17 00:00:00 2001
From: Palash Oswal <hello@oswalpalash.com>
Date: Tue, 27 Apr 2021 18:21:49 +0530
Subject: [PATCH] io_uring: Check current->io_uring in io_uring_cancel_sqpoll

syzkaller identified KASAN: null-ptr-deref Write in
io_uring_cancel_sqpoll.

io_uring_cancel_sqpoll is called by io_sq_thread before calling
io_uring_alloc_task_context. This leads to current->io_uring being NULL.
io_uring_cancel_sqpoll should not have to deal with threads where
current->io_uring is NULL.

In order to cast a wider safety net, perform input sanitisation directly
in io_uring_cancel_sqpoll and return for NULL value of current->io_uring.
This is safe since if current->io_uring isn't set, then there's no way
for the task to have submitted any requests.

Reported-by: syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Palash Oswal <hello@oswalpalash.com>
Link: https://lore.kernel.org/r/20210427125148.21816-1-hello@oswalpalash.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 863420e184cf..81096f3b01ea 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9044,6 +9044,8 @@ static void io_uring_cancel_sqpoll(struct io_sq_data *sqd)
 	s64 inflight;
 	DEFINE_WAIT(wait);
 
+	if (!current->io_uring)
+		return;
 	WARN_ON_ONCE(!sqd || sqd->thread != current);
 
 	atomic_inc(&tctx->in_idle);

