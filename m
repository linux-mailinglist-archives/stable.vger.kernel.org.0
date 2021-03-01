Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5B7327C29
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbhCAKao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:30:44 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:34227 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234251AbhCAKam (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:30:42 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2EA501940D1F;
        Mon,  1 Mar 2021 05:29:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 01 Mar 2021 05:29:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WCW33z
        2YuR+qH+tegLEtzN5fyVURFzUKn2S0Y2g6LHo=; b=gDDjQ7ZOXkvRqTqPZKQOIp
        K0go/JFROJiqEZCywbxKAgkWSqYo/WqcSoVh0eqYIyX5C1TRRD2etY9SY7m/kJhg
        7nQiQxjhrL4s5R793vp4TmUOZn2FaXLAgZ++Lb17KQe1LUuDQ/GZtRsO9lPIlekH
        3DbEzfVfjGZ0csT2wO1h1VJC1g2l/5T7wXfcouN1A1LPx5095pwKVDF2fb14VBB6
        mr/KMlxvh0MbPR1c7zCjif3uoOeXnYc/8wcRcIKIAwC2BAXLROOEHqgxA5ClEHzN
        i9BdXuYB7Hu7Vbd1xoPdRf44Wvh7hPEtS4LOJ+b6nwrYHE7yWEKAPsIpycDWtZ4w
        ==
X-ME-Sender: <xms:IMI8YDHppu1ZIjQc550CGUZPS4Vb6HvpUhQW5OzvIvH8a6hMEBa4Ug>
    <xme:IMI8YJ8CVHiB7PQjzUH1hLuMz7h8d0lVRGagOZHQniiof5JdA-igKp_wxSR3-0W2X
    OFufzVC1LkmLw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:IMI8YFLvhbTfTIKXfuPUNPAOmFb8enCnYdMjj2HO201q2drgg3ScGA>
    <xmx:IMI8YEaaICKU9ewmlcghsskhIpRX1BZLvPCqNP6vyAGJPelzFw9DoA>
    <xmx:IMI8YHIXz6e17EGwbPkh4z6Phi9hTa4VN2yljYxcdl5YnQQwa33CEg>
    <xmx:IsI8YBK5hlrI_9-RSW2-iY8PVCdS82QkDkQwO-qZhzIbF-g13mvoDA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 00FAC108005C;
        Mon,  1 Mar 2021 05:29:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] crypto: sun4i-ss - checking sg length is not sufficient" failed to apply to 4.4-stable tree
To:     clabbe@baylibre.com, herbert@gondor.apana.org.au,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:29:49 +0100
Message-ID: <161459458995188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

