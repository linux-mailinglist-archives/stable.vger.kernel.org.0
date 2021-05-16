Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91670381D91
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 11:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbhEPJNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 05:13:36 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:54385 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231771AbhEPJNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 05:13:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 8BD93FB0;
        Sun, 16 May 2021 05:12:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 16 May 2021 05:12:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=syc9uo
        jvGL4zcgQpEv2827TM+nsL4zXyYc5P0e0g5Zg=; b=kkzxi1jIdtTmZ9rHmer2/S
        h/cFIHuNWnFUaxCQEZGOZUzTPwGC3parKV1+hct7UQ38qQFccaQ00dCVXp3AJTv0
        S2IsNqWaCSLGcYs4sAmLsq0owBJjvIZkCS0OP6vuxysagY7wXALBXj9EpaEV2d2U
        0LC1VP/vD0ofyhbO/yaAaJSwu5moBzHLzSORbHpkyLxlhlzIPbOovElxHKIdNe1/
        pu0kH9RPHkKT2XKWw65Jw1aG83lNIOEqAEQrBGAJn0C94DY4mRYzVpag/jHPISid
        Y+BFPRfYsDn9Wt11HIHONMRi+Y+rQkBKnNhcrFDEAEXq4MecJc9jmubm8PAYG3/g
        ==
X-ME-Sender: <xms:9eGgYMlMOId8ioPA0hCX2C7Rr1nuHOqRaqbKPcY9lCXnES3ftC7BJQ>
    <xme:9eGgYL1jN4dNYLmgXmWrw8Uh-zi3ob6fsFZ0vK907rzsMsmKrza-5-pCeD0coY2Dz
    RzTSZikRyXN-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeifedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:9eGgYKqdzSVXUlk__rERRiv4NRjMUzeJrdaaH7hVBmDpkmfDsXL4tQ>
    <xmx:9eGgYIlJzt1vH6pXAGpjhuBFPFAIhPFhXg2Kj81Qec5VehCp4BagAA>
    <xmx:9eGgYK0pdpui5Y10ikS8nu-AW2tL2hoS4S0F5jCXDXNPkd3uBrnT5g>
    <xmx:9eGgYP8FTRyP9yjP0lWSH4IQhuAUU-4z4u-KRpsWAyQaka7eE5PThAF5Z3k>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 16 May 2021 05:12:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: fix ltout double free on completion race" failed to apply to 5.12-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 May 2021 11:12:08 +0200
Message-ID: <1621156328149242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
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

