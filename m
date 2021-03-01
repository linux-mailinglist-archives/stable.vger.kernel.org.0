Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4D1327E09
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbhCAMPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:15:12 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:59395 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233678AbhCAMPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 07:15:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id A813919418B2;
        Mon,  1 Mar 2021 07:14:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 07:14:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Wi4hwW
        +8kVWV7RiuO9UgWwOKN4H0TWV01sLMfzCjOHk=; b=a0IDV34QgQsp4/TgNClzka
        QoVlN7qZtqIrra2bJqnNOuh/LQ43XCqD2s6m72bsiLe7LVz77tDhWrAy8JQgsJtR
        QRHm9FeCPOZBlh4/ySTx8dIrc0TC3TX3ZmxS1QTsZHT6dC4tY1bcW2PEDqPO9GZR
        JGL7s50jANcZgu9F6JzlnLUVw7AA+Q5i/sEWBVAuu3VedoTDsiX1dGSHsoc4xRDy
        qNl3efFlTy8/JPSQ8bDfgg1wjoEelpE9PPLBxcodXuGPs1gZ0W9e0owRwCmPpl2Z
        BCNscX3LGVkEOobfzNlATBOVWIfSgKfHEtnSy7UlvQh3whwSMflwpLNgH+MhTOZw
        ==
X-ME-Sender: <xms:lNo8YM7M91LaaTVGIoFQBsam3dpLK1giNjJ9E5nIO0oLrzjyuRC4LQ>
    <xme:lNo8YN5jYa_u4inEQYdr8k2RXJ9_QR6nGG9kYM-BatGPfZAZmyLhHBYs_nF67Myzn
    4KqG2sGw1nZGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:lNo8YLdRObhwz9svFyd7FPv-bufxYHE-wi9zwbXNtZXO6sf5EroYOQ>
    <xmx:lNo8YBKhaTut8aiWtTDmCsbeGNB5ruYF6ACwMKZfIaJ3nudRTkUeDw>
    <xmx:lNo8YAKFi4dRzmLtRpFRv24uNslmtt8nGHwC68hn04muvviHnWnfuw>
    <xmx:lNo8YHn0btn5SYMV-pvCMK8h-aAwJkB_Asu-CKFOqtgJW8RUudSsdg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2E4861080054;
        Mon,  1 Mar 2021 07:14:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: don't attempt IO reissue from the ring exit path" failed to apply to 5.10-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 13:14:02 +0100
Message-ID: <161460084221125@kroah.com>
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

From 7c977a58dc83366e488c217fd88b1469d242bee5 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 23 Feb 2021 19:17:35 -0700
Subject: [PATCH] io_uring: don't attempt IO reissue from the ring exit path

If we're exiting the ring, just let the IO fail with -EAGAIN as nobody
will care anyway. It's not the right context to reissue from.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf9ad810c621..275ad84e8227 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2839,6 +2839,13 @@ static bool io_rw_reissue(struct io_kiocb *req)
 		return false;
 	if ((req->flags & REQ_F_NOWAIT) || io_wq_current_is_worker())
 		return false;
+	/*
+	 * If ref is dying, we might be running poll reap from the exit work.
+	 * Don't attempt to reissue from that path, just let it fail with
+	 * -EAGAIN.
+	 */
+	if (percpu_ref_is_dying(&req->ctx->refs))
+		return false;
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 

