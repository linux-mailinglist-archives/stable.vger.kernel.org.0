Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8D1205161
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 13:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732416AbgFWLzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 07:55:02 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:42147 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732225AbgFWLzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 07:55:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 2E54C9C2;
        Tue, 23 Jun 2020 07:55:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 07:55:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DjxbcW
        O1F4E8pFCPC3ByPWP5s36ZY3S6Qcsai7l0/D4=; b=upUi0HuqnPbvWn6gpa+Gjz
        d3bXg6jtN6YYqlR96eFxl7HfeCpsQuKBnEtBI3eFltLDIamFw8ty7IVlVhwPsA4A
        UV9UCiqlpSUONb6ux6Cp1azFrjQ/d737ccUXd2YKkx7KhnPzr6pSdAd7I8OTTLOP
        EbVgeYBihcvNyiPZNZ7NVE/Te8+ijZsS2EANKUamtYZVb6AA8Ycrr/9AAnctyqgR
        oHWgAV+Q3VEfDUdYge+Zr4HQpqjcsY7FelEWWH/igsbkeIKnj6+WmgtghmEiG9oK
        DwQMoBEqcB7fBzJEWROAQ00kEnjt7z2fPX0xlYh4pvSRei9eF/K/dNtB+/PRia8g
        ==
X-ME-Sender: <xms:lO3xXm0AFbiFkYT8YeZtSRkHnys2ddwiFPmkPG76ROn0137J4CDuew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:lO3xXpE4xXFuBLm_5u4dLsikeEmbtADz9Ait4TrAhGWVO__TlFJP9w>
    <xmx:lO3xXu6z13zcclBT6mXpsJaZGH-lEDesBHvuov64-BR94SEjzRpDTQ>
    <xmx:lO3xXn3cynuA34XtoB0Lrf2GBmbodfOgVKXnmW9-y--6cC0dEvHf8w>
    <xmx:lO3xXoyMR9R1Aix8CPsn49Z96FxNz56x2AcLwykrT6Hl4_Kl5XNhF_3KDy0>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4DB97328005A;
        Tue, 23 Jun 2020 07:55:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: algif_skcipher - Cap recv SG list at ctx->used" failed to apply to 4.9-stable tree
To:     herbert@gondor.apana.org.au, smueller@chronox.de,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 13:54:47 +0200
Message-ID: <1592913287117111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7cf81954705b7e5b057f7dc39a7ded54422ab6e1 Mon Sep 17 00:00:00 2001
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 29 May 2020 14:54:43 +1000
Subject: [PATCH] crypto: algif_skcipher - Cap recv SG list at ctx->used

Somewhere along the line the cap on the SG list length for receive
was lost.  This patch restores it and removes the subsequent test
which is now redundant.

Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index e2c8ab408bed..4c3bdffe0c3a 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -74,14 +74,10 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		return PTR_ERR(areq);
 
 	/* convert iovecs of output buffers into RX SGL */
-	err = af_alg_get_rsgl(sk, msg, flags, areq, -1, &len);
+	err = af_alg_get_rsgl(sk, msg, flags, areq, ctx->used, &len);
 	if (err)
 		goto free;
 
-	/* Process only as much RX buffers for which we have TX data */
-	if (len > ctx->used)
-		len = ctx->used;
-
 	/*
 	 * If more buffers are to be expected to be processed, process only
 	 * full block size buffers.

