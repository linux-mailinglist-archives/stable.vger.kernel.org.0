Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD383C3EAE
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 20:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhGKSHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 14:07:19 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:35839 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229801AbhGKSHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 14:07:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6934E194069E;
        Sun, 11 Jul 2021 14:04:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 11 Jul 2021 14:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FDIV7W
        2Vdy6CGX9l21bfnUk4UhVA4UcfS7MQf/intcI=; b=FO00ZAooMydShwcU/7SNKa
        RhebCCL9sbxBzo9lnj6pEvROyq/pzBmEegRJ29ugpBZzTS53is1ouavo/b/FW6nQ
        vZWgAapXb0DrBEbO+dy5QzI734HBJJA/s7dFhezN7EjBUzxWxykk47i9ew6T/zgD
        hWL7HEhrjNPyi1u0DtLOi0clLHfLbPejIrbRDPS6o3fmZ88JJRazw9t7tR8TYOgW
        yrVtUFTHibTjr4ppeqiI/qgq0p5BIEgu41QqFbhOry+fvgAOlatHdffl4qxIrbmE
        ZqVB/deczOOr6vjO3Vre1bqYbDCrW+j+VDO+LAM7TB2ZW6gM870Fxj+8cSSau6Kg
        ==
X-ME-Sender: <xms:rzLrYHrBx40sgjC_voHzJfbVKI-qVu9GZDcGwl-J1wa_PzjSJa7cww>
    <xme:rzLrYBoZT0Yrjm3eYDj3omzE-ZZ3WeT2AFZwqyRFhGbdUYwHuaagWVOIHN1VxuxVh
    AsnVlO-cVSd7g>
X-ME-Received: <xmr:rzLrYENkk6d_4Tg-Zr1UfzPi-uMGz2NEkWqyIvMYox6Jd1YzVeh85yy2P6rXY7Fb0JSWdabhvzAFdJrLlecNYUCq0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:rzLrYK5OfZLwgZmB_kbGK5ifi1uzbiLhK-lmcbYllbvua0EhZnLo3Q>
    <xmx:rzLrYG6YtpzHLrd50laYB_S5RjfAPwcM101j78Le3il6vTWWnwNvcw>
    <xmx:rzLrYChXADFEgxOv1762NDdSbLEgQ7P-impAPqJ3yLtuc7Z-P8K1kA>
    <xmx:sDLrYGEF57JOauR5ZV7fuhvcgt29tey3WKwPMi2yEdcEZaHVPb0FhQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 14:04:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: Fix race condition when sqp thread goes to sleep" failed to apply to 5.12-stable tree
To:     olivier@trillion01.com, asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 20:04:22 +0200
Message-ID: <1626026662108242@kroah.com>
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

