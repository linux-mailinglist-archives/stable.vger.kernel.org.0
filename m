Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48928327C2A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbhCAKau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:30:50 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:37089 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234251AbhCAKat (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:30:49 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 265AB1940C61;
        Mon,  1 Mar 2021 05:30:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:30:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=F7tW40
        p05YcwXPsW9njVgg4yxZVykuw5buaG7/7VecA=; b=jF9iegn/wj0T7wz1XARv7L
        ZHeEdcwN+xj2qTH/Q9jltQKF6RLdaCAOIPJYs7ax3pTtWD4kYNIzoBFungnKDzii
        zw7YO1m1snzpEWaU0Ls4KMD72Kdf2ro0T8ay9XBLS4sgvrp0Gfa988i71d/QrKod
        YLrdI8s7k/gn2UUwyCfMqZR0YUK/rV4BnHOj0ESHM02YGcaj/kHWe/XBV1aUVxmN
        l+nBuuBTT/7UNqYnhwwStxw/KCsSttZo1qKdaLjows2gYKtAiy6z4/mxYffKQWuF
        wWT8UG057OMzTRR8HbCuv6zz2PbzgXD6mtKMaAlEzcBAB0r6713R0EXyTzIATPtQ
        ==
X-ME-Sender: <xms:J8I8YAhhmqHOt9spnbgKlLZ4qXokPGneANxS6upirWDMCIce639QhQ>
    <xme:J8I8YJCcPi2En-lKi2kTRjWCyTOjUlnb1wvx3qU5y6O1GU1Tl0qEzlxGtSDUKFTT6
    cR5Fg1vMa3-jw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:KMI8YIFhcrCz2Uvj4jjBBtdKGUuGXrMinpgcslgAj1X8xMtJSVkD_g>
    <xmx:KMI8YBTWHOpE7mnE3EztAPqrZvqP6JSpAa_cbglP40QIbYpi1AjfDg>
    <xmx:KMI8YNziUIVPNw_UYidvSfdfRflJhr5LMPZVll--qR_MocFIR750GA>
    <xmx:KMI8YLbNPyjsbAjz-JM_CuVknsEX_Gqg3A9YlI4jH0S_2niUVs-xhg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A577E108005C;
        Mon,  1 Mar 2021 05:29:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] crypto: sun4i-ss - checking sg length is not sufficient" failed to apply to 4.9-stable tree
To:     clabbe@baylibre.com, herbert@gondor.apana.org.au,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:29:50 +0100
Message-ID: <16145945908433@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 7bdcd851fa7eb66e8922aa7f6cba9e2f2427a7cf Mon Sep 17 00:00:00 2001
From: Corentin Labbe <clabbe@baylibre.com>
Date: Mon, 14 Dec 2020 20:02:26 +0000
Subject: [PATCH] crypto: sun4i-ss - checking sg length is not sufficient

The optimized cipher function need length multiple of 4 bytes.
But it get sometimes odd length.
This is due to SG data could be stored with an offset.

So the fix is to check also if the offset is aligned with 4 bytes.
Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index 19f1aa577ed4..f49797588329 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -186,12 +186,12 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	 * we can use the SS optimized function
 	 */
 	while (in_sg && no_chunk == 1) {
-		if (in_sg->length % 4)
+		if ((in_sg->length | in_sg->offset) & 3u)
 			no_chunk = 0;
 		in_sg = sg_next(in_sg);
 	}
 	while (out_sg && no_chunk == 1) {
-		if (out_sg->length % 4)
+		if ((out_sg->length | out_sg->offset) & 3u)
 			no_chunk = 0;
 		out_sg = sg_next(out_sg);
 	}

