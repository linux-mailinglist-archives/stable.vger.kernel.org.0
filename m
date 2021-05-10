Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0BF377DF4
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhEJIUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:20:30 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:57585 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230138AbhEJIU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:20:28 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id A9E871940BDA;
        Mon, 10 May 2021 04:19:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 10 May 2021 04:19:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EeNFfr
        frs9fRwUo0Rjs85zZ0717udFkD23kSX38Yb8Y=; b=IXatETCAXcFmEAr4ucgUh+
        SSCpZHNUf1sVow3C+Z1iHM/FSxTN99YyuXrYPILjIECHFhegpy4C1sCKnFp3lSg/
        wanb76UoHs7ODaFCrsx+ecxhqWwR/PoCjxIMaS794FBfJAJ4/YJCvBHv9px0JWrq
        TvhYWe5aL2VZ3jqFIlRJ8Hw0RRiOhqtM4kmLnn46a4rzvvyH57PVuMwOvhAtI6st
        7LeAm9OqLF6QKhm41cX1TOci7AVyFl6nYxYhWOLFUtXgqvW/KUEvTlCr0Sm6QkWd
        J+YPzKs7TwK0s5NTRM8E55mknXO49lFfmkdoKHlCCnnLOCT2GucaxelEOLJXgA9Q
        ==
X-ME-Sender: <xms:iuyYYBVl-0KWuyEFrFuGfcKhI4cL_gFK7xLgGIH7GN92SFBXm8QBeA>
    <xme:iuyYYBkELQ9T-l2XmF95OaUh-dZWiUEw36XDBt9i_i3Po6nIkkJXdwg6GM8F8HIpA
    uOrIIloKKbjCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:iuyYYNaMRVSJ0B-tFcPK1jwPC2OHijkoqrW4ZuuxPwa1mDHSLgUf2Q>
    <xmx:iuyYYEWnUAz9wT_eEMdLvUCPZkJJDy2mwDAyvJD8ys02YL-StNuSlA>
    <xmx:iuyYYLn6fvq9WRS-WelYXeNubD3MhHk8SHglLuV-8Hi6XMlR8XBGWw>
    <xmx:iuyYYKsuq3xw82CHzaaKj4GwlNJChfuEaogzcpSmQ1QaA2dw7Eymug>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:19:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: Check current->io_uring in io_uring_cancel_sqpoll" failed to apply to 5.10-stable tree
To:     hello@oswalpalash.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:19:21 +0200
Message-ID: <1620634761103178@kroah.com>
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

