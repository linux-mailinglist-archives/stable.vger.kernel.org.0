Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41F83C3EAD
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 20:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhGKSHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 14:07:12 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:60783 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229801AbhGKSHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 14:07:11 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 901C419406C7;
        Sun, 11 Jul 2021 14:04:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 11 Jul 2021 14:04:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Jh7L00
        +ejqejVzr1TcFOeUL6fbeLpHGHEkJmiWvbJ/E=; b=AVwQQfZoZk0ymZsnVSb39G
        quXbsFN1b6Tjo6Lla1ygof+IyCnbX2o7jnZ0ElLNWWnv36Oa8F5U29h+CFPsXGDw
        sr3VZIntG/ZKWdLJbmE7ZBv5SUbFLf9jcrWBVWAmtcAvLYEq236A+bW9JeSMTmya
        YeX1pe6qpnAkEfxqmwT3r4ktbOihzZhCBPkj2w0ATH1sTk8pzl7UeaqvbYz9Y/Dv
        P30bh72oJEYmlnN+YYRtjn8deOob7cGsJVzTL4Lrvrt7mvwLI8y46zG1Z4u3dyTi
        VS4DtGYzHOUlZoTCKfsCyR3O/CPuNbnwrcUwyvxb5z0hexk5MqiCGUUlvSunCmzA
        ==
X-ME-Sender: <xms:pzLrYPMDcSDXCUnQc00UnY-_M9hz21GTWoHm3k6SD6gZVDUrV34WHw>
    <xme:pzLrYJ8cpf_R57ZgdZLc9NrDSr3EVsLDt8H44bdoEox-_sF_54Oqqv2YEceceN6Xs
    xU5l-Hl1TeKKQ>
X-ME-Received: <xmr:pzLrYORh-Gxc5_RlWUtujEBXYqkxwPmAz3Ro8r8cYNVSDyo2b8ml6wzO-SvXu-85lmdbXP1fSEmZA01_u9aCrNvn_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:pzLrYDvyx8jrpJ9AG22Yocc9029ozWSsk7UsTKRBEfQLJsINgaZ-IQ>
    <xmx:pzLrYHfpatVDLVUOkLAQ2ZtQXBcqccwJR1TOohzuKvrYDyPWLj3gig>
    <xmx:pzLrYP3t4NhcHDR4RxuLwbBIworA54PvZ0NGNaufdbUQ_5kolNqqvQ>
    <xmx:qDLrYIoOx01AqmvQS9KkBkel_ejEFERQzMvzh1WzcLKO4-dewNKiPQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 14:04:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: Fix race condition when sqp thread goes to sleep" failed to apply to 5.13-stable tree
To:     olivier@trillion01.com, asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 20:04:22 +0200
Message-ID: <1626026662135154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 997135017716c33f3405e86cca5da9567b40a08e Mon Sep 17 00:00:00 2001
From: Olivier Langlois <olivier@trillion01.com>
Date: Wed, 23 Jun 2021 11:50:11 -0700
Subject: [PATCH] io_uring: Fix race condition when sqp thread goes to sleep

If an asynchronous completion happens before the task is preparing
itself to wait and set its state to TASK_INTERRUPTIBLE, the completion
will not wake up the sqp thread.

Cc: stable@vger.kernel.org
Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/d1419dc32ec6a97b453bee34dc03fa6a02797142.1624473200.git.olivier@trillion01.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc8637f591a6..7c545fa66f31 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6902,7 +6902,7 @@ static int io_sq_thread(void *data)
 		}
 
 		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
-		if (!io_sqd_events_pending(sqd)) {
+		if (!io_sqd_events_pending(sqd) && !io_run_task_work()) {
 			needs_sched = true;
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 				io_ring_set_wakeup_flag(ctx);

