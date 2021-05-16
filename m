Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F07381D90
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 11:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbhEPJNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 05:13:34 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:35397 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231771AbhEPJNd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 05:13:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 21CC8FCA;
        Sun, 16 May 2021 05:12:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 16 May 2021 05:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8WOTQp
        ikh1tCs/Kjm5yULD1Cy4vYUNJZ7kEvpy4kT4U=; b=GcjpH3Mc3SAVnOgRzjn/2O
        /UPu5/tfGGu9X7N6WS7tkmhI8sU/TQsFmGSbqgaZyjh+hqX0NDP0WBWAqjLTzruZ
        R01bGi1AwxZRRwo0sU36m0/1C1lc71Xfu3zLXoe3zWbUOsOJzj6ggW9kc8mPhaqL
        X4n4sSoSX5jNhzcrm5x5mfkO9my3y8uCRXPbd8cshBDa/HOxFBboum4EoT02Coat
        OnW5flZkEU4we+2XcdDt48ngpp89lmWHabkrQUgIW8b+HWPB5Lt0iq5ASmXETFCj
        nlVOI6NNcy4RCNDqvsNn9fKR9P+/4ofaZ+liG9MDgK9wpM/z5zbFhN+6SSggQGyQ
        ==
X-ME-Sender: <xms:8uGgYJlNkglI4j-tL8qnqucOd1gxYm3CoNQk1csnXzViO1ggy86XFA>
    <xme:8uGgYE2cBATmWVJX5j5FDCzP0A0F361qpXCitV0Lp8kkHslzDXo7UrJUfZFTC7yuA
    DH6T45B1DN1mw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeifedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:8uGgYPoSwK7ETF5I_vziMezScPg4zGBMpiLIsehmcw3LYJHPQlK0Gg>
    <xmx:8uGgYJkcMIjhFx-TAAt1DR7qmujwbaNoT_QHgp9SffeIFjcwa459jA>
    <xmx:8uGgYH1nfX0hBqfuYjcOoJw8ESMHdoi3wSfylhjrlqL23ZtEkXDELQ>
    <xmx:8uGgYE_V-v7LO6c9C91CDHgcFjzlNyM_7gRL3Cn-k8Pl7yAl1XqiwKKX5Ic>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 16 May 2021 05:12:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: fix ltout double free on completion race" failed to apply to 5.11-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 May 2021 11:12:07 +0200
Message-ID: <162115632745235@kroah.com>
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

