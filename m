Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945033C3CC1
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 15:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbhGKNO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 09:14:56 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:52947 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232544AbhGKNO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 09:14:56 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 16B8D1AC0679;
        Sun, 11 Jul 2021 09:12:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 11 Jul 2021 09:12:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=68EG5q
        eFSTusxJ0r/zoZo/rVfj1rVw4rt1CDw2Vwve4=; b=i2PZS2/tcOGLFeEUayqRIJ
        x1NeoyH5V6qV6ZfYC88UETecp338Mz0GJk5+bB4OVjrqhTKLPsr2Yip049ap3s8F
        7o0IXtLvldyEY5SC1c2FCz+aqh9MPfhjmHbY1NadrgudeC0uk196cUGmAVnkvhUB
        Cf96ETVKYDimpCw0ARHhTSPcGXgQVLVKGtxSztsRvN/b+czYd874Ei0fX+weCnJL
        OlRFutvNa/aiMxUtGbuHP7Lw/GKiUaI2yPDdhwsqrgStOJ41VjnlsHyj7Ss00SCI
        Lq+UdxSh1Lq8Wb42F9muUQq3Ex1swpDJ1u7TyzMEAT8miAHvOSGi29z6xSoqGjOA
        ==
X-ME-Sender: <xms:KO7qYDfJ8LhjExLVXHZv9q7Ikjh2J-5jUDVHrc7icpr7Hj1ESCObAg>
    <xme:KO7qYJMy94uX42tvualfepVpHqvbcKu3ue8pzziKHJg96VfpM3WNpIK_WGHGsBZyy
    8bSnzTHK0NS4Q>
X-ME-Received: <xmr:KO7qYMjylMAXcxdp34Vgu6mcjDUU2UEU5cuixFVQ-pQWEwXjnnM5KU5H6o5kZnrhPG63qsVGOiv3fTojC1L7UqtO2w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:KO7qYE97zlYTSwB9dzv8g0sJfdI68VOFO-QDJMOSIann2KIkfNjYYQ>
    <xmx:KO7qYPs-y-OiQ4vq1gZJi7fFd4wo00DeWrmhDBEODqKxCvizBL8VFw>
    <xmx:KO7qYDHvadJniRiU6NJ-K0DEjMIFQG6ipKX3y5krrWYF8pp_XGSzjw>
    <xmx:KO7qYI4QY1VqxNOj2jMJ19d46NK1Fx6iw7HZ0gqjxoj0uDuq3uAFMQ7QQTs>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 09:12:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] fuse: reject internal errno" failed to apply to 4.14-stable tree
To:     mszeredi@redhat.com, anatoly.trosinenko@gmail.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 15:11:59 +0200
Message-ID: <16260091193762@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 49221cf86d18bb66fe95d3338cb33bd4b9880ca5 Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 22 Jun 2021 09:15:35 +0200
Subject: [PATCH] fuse: reject internal errno

Don't allow userspace to report errors that could be kernel-internal.

Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Fixes: 334f485df85a ("[PATCH] FUSE - device functions")
Cc: <stable@vger.kernel.org> # v2.6.14
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 6e63bcba2a40..b8d58aa08206 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1867,7 +1867,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	}
 
 	err = -EINVAL;
-	if (oh.error <= -1000 || oh.error > 0)
+	if (oh.error <= -512 || oh.error > 0)
 		goto copy_finish;
 
 	spin_lock(&fpq->lock);

