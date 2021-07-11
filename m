Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC773C3EAF
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 20:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhGKSHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 14:07:21 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:52587 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229801AbhGKSHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 14:07:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3867319406C8;
        Sun, 11 Jul 2021 14:04:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 11 Jul 2021 14:04:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=MwZgd0
        bES0GGrNEla4hnGHSrgSjBFbJOm1sviA7Wl8c=; b=S3y6Nf3e7p63mbNyrxq9sM
        mhZqpbse/wMr334A6mU6C2bkJqUwspJLMZmEuMI35602wtQEgEylRrQQ4wS2WcfB
        8vz+y97uIJba76WOdmMiQpfFpKhvvRFU16nqqcMbsN1gBwgXMH37dKgDTrXpFfuT
        meRmeaNcS+UC6LhQi541XoY9XamxH8U00zO7VdY/0xYomo5jadup4UbCIt9w59ep
        Cw7EWkSXtaQ/c6mPxlQSpznrOd4vXQdQzB2pmM/iakwIxNsyW3D/yN/aDz8EpHP5
        Ye49ywUnnN+KgUI+9SuUr1+oaQXv1Uk7k08tqhAw+N8SOVmFDutmHEECRm5MbvxQ
        ==
X-ME-Sender: <xms:sjLrYKIf02xHSEfuuf44pHvftrOFv4kh6uxpq2wQ5QPY22Ug1PYVwg>
    <xme:sjLrYCIgnvEWo6u0jHfpiZxESHW5hpoWsw3thTgMTp6JXYVPL8jpODTwshFyHxamD
    yp_F31LGHVYGg>
X-ME-Received: <xmr:sjLrYKuS6gNOQ0d43bn5RzUBktM34YqFem19VeUtJdN0jti4mWdVbjmGODMScuXM5Ubu5Ux1qxDD9oSpXorv5-WNZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:sjLrYPaALS94HGEDL4uzsrenbjaW30ei1uKEOIFYYYkLLxe1t9iXeQ>
    <xmx:sjLrYBaxSGvAuG2jjtliRh6nN_V73D7C47QVhgtl7nXm54LZE-7Lzg>
    <xmx:sjLrYLDGO9Lfn0ZiMYgXhbAGGx0xOMC-y1CgBl8YfApM8N7Ezu6i6A>
    <xmx:sjLrYAmLVPkvZky8bBzM4shO3BQEbowkV-DmYi_F8rOQXTk1tRNqUA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 14:04:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: Fix race condition when sqp thread goes to sleep" failed to apply to 5.10-stable tree
To:     olivier@trillion01.com, asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 20:04:22 +0200
Message-ID: <1626026662187216@kroah.com>
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

