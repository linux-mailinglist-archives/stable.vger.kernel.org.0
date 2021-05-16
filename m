Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561E5381D8F
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 11:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhEPJNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 05:13:31 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:39873 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231771AbhEPJNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 05:13:30 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 00DACFB0;
        Sun, 16 May 2021 05:12:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 16 May 2021 05:12:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lcFljG
        2ODGQBpoLbPGfpgS5Ge/ghBLax9UDLnq035s8=; b=hm9OcC3IAEAh4kjGUTFxZr
        8HzqFAAWWw6Gyc2GNHcnVfe7B3Qu9Lc6f2Caa7BESYFQ6qRpR1gYVM0/MWM+MGkw
        MYeNAVet0mCj6dLrWp1ZQNBKG29MI09qP1tjOMMraIbPkNXt5Sms8YHhLysEP5tt
        ypx5y7gYbWZrQDkfoogFd97j5dEI3ntMpeJmJM0ZOS4vD6VQnqsvIq/0g0uZbHjS
        zMuDxn1cBLy41s367EuBmvZD4ZmsL58Xs9/c9oQqKEq8g+dENZB2dkyrqiepRwZd
        s5+/B6PDAoktSNa7fLS1ipFlGGTkFhNoySF4QkDO4vQuWNyuem0m+kDajd0IQ0Ug
        ==
X-ME-Sender: <xms:7-GgYIbs9g_pe3pgF-mFHycYU5jdgftLVuxI5B09Fc0YrAZpLkY79w>
    <xme:7-GgYDY1ISwIMMq4txNfCChqn0GU5BhWjBfBt1a4dSH4YO-ksq5zMnGiGz6hJ5bJw
    qrngSNT2UIPdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeifedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:7-GgYC-EGnn6_ly-P65iPiISVtREzl-mZDcZLc-p8onUFVOYxMSnlw>
    <xmx:7-GgYCruQ0V_aXCz1oRrojvJplZwLuiXfeecPnC7hOnwLqtfKmtZHw>
    <xmx:7-GgYDro4bwuL1wihIYhKacbCLM9GZh1C54zCfbDbeX0gENEGo8Y0A>
    <xmx:7-GgYCRYnIijj2vCcZKD7r_tE_LYZ5J75Me17RGdR3G8YH0DuslyVeYqMy0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 16 May 2021 05:12:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: fix ltout double free on completion race" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 May 2021 11:12:07 +0200
Message-ID: <1621156327144194@kroah.com>
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

From 447c19f3b5074409c794b350b10306e1da1ef4ba Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Fri, 14 May 2021 12:02:50 +0100
Subject: [PATCH] io_uring: fix ltout double free on completion race

Always remove linked timeout on io_link_timeout_fn() from the master
request link list, otherwise we may get use-after-free when first
io_link_timeout_fn() puts linked timeout in the fail path, and then
will be found and put on master's free.

Cc: stable@vger.kernel.org # 5.10+
Fixes: 90cd7e424969d ("io_uring: track link timeout's master explicitly")
Reported-and-tested-by: syzbot+5a864149dd970b546223@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/69c46bf6ce37fec4fdcd98f0882e18eb07ce693a.1620990121.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9ac5e278a91e..599102cc6dfc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6354,10 +6354,11 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	 * We don't expect the list to be empty, that will only happen if we
 	 * race with the completion of the linked work.
 	 */
-	if (prev && req_ref_inc_not_zero(prev))
+	if (prev) {
 		io_remove_next_linked(prev);
-	else
-		prev = NULL;
+		if (!req_ref_inc_not_zero(prev))
+			prev = NULL;
+	}
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (prev) {

