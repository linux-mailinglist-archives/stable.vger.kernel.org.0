Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD852D4606
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731237AbgLIPyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:54:52 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:58427 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731369AbgLIPyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:54:51 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 13F2B19427D1;
        Wed,  9 Dec 2020 03:31:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 03:31:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=QgRgz9
        5xDGet66fLr+F7cuXAbg4WApbcj7ToNVB9g7c=; b=jB+fWH/YLHVsWJdAUwyRJH
        OEP4yB3GukPdBNS548ZDaPAh179HB6LPhqTdkagRuUZaL9n1ejoREVl4+77SO6lJ
        CJL3eh/0QHSMDuc3GBiHqf8DbOgLW0Lty+K9ZmFyFqI3PlWCiDcM4Y7bygMMRaDc
        SVBVN8yb6I/CW3bD8lD/mWQphks4nUfXtWHsIBVp94YUR+7ZUW51zF/3oHXiLHvC
        0dUM+PGkSwYc1GalhLSEk0J3V+o7qLr27+FruGqy+GBbHzi5rGZszZIHzgNJce3k
        5pTu9GmEHhZRkFhrFTcSjzQZ17Su4UIeZuuAPFruxMgLJZlR4J4AJCAKDHP3+HkQ
        ==
X-ME-Sender: <xms:bovQX9N_vhfSS7_ZqfXGNypeTezW9gq9wwwg1UvyLdBhm8q6VVzRUw>
    <xme:bovQX_8abltd5eKOoDtBJI3fapcFBBKuz1UdfOe3gSVAu7bC9psVMQ_oOWJsVZBss
    uEbLKhjSdNTyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:bovQX8TwltZPkMFh77qtwTm59OINDQHJ0mYmK69H3YV49OYa13azsw>
    <xmx:bovQX5sHKCy5ozGSxrECZuvr-aTb7SyindVd6nwbuVF657hoEMLZ_A>
    <xmx:bovQX1dDCG0Cygo1erKZ6DcVlM_fhZZcWacQRvenXcL8qkhq2xXVLA>
    <xmx:cIvQX2rEQbF3JBRDYpxSUV0cu4_c0D5nbhkqV6mA21kkwWP6KITAVg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8DADE1080057;
        Wed,  9 Dec 2020 03:31:42 -0500 (EST)
Subject: FAILED: patch "[PATCH] i2c: imx: Check for I2SR_IAL after every byte" failed to apply to 5.4-stable tree
To:     ceggers@arri.de, krzk@kernel.org, o.rempel@pengutronix.de,
        wsa@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:33:00 +0100
Message-ID: <1607502780184102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1de67a3dee7a279ebe4d892b359fe3696938ec15 Mon Sep 17 00:00:00 2001
From: Christian Eggers <ceggers@arri.de>
Date: Fri, 9 Oct 2020 13:03:19 +0200
Subject: [PATCH] i2c: imx: Check for I2SR_IAL after every byte

Arbitration Lost (IAL) can happen after every single byte transfer. If
arbitration is lost, the I2C hardware will autonomously switch from
master mode to slave. If a transfer is not aborted in this state,
consecutive transfers will not be executed by the hardware and will
timeout.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Tested (not extensively) on Vybrid VF500 (Toradex VF50):
Tested-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Wolfram Sang <wsa@kernel.org>

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 39e98d216016..a2abae124342 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -490,6 +490,16 @@ static int i2c_imx_trx_complete(struct imx_i2c_struct *i2c_imx, bool atomic)
 		dev_dbg(&i2c_imx->adapter.dev, "<%s> Timeout\n", __func__);
 		return -ETIMEDOUT;
 	}
+
+	/* check for arbitration lost */
+	if (i2c_imx->i2csr & I2SR_IAL) {
+		dev_dbg(&i2c_imx->adapter.dev, "<%s> Arbitration lost\n", __func__);
+		i2c_imx_clear_irq(i2c_imx, I2SR_IAL);
+
+		i2c_imx->i2csr = 0;
+		return -EAGAIN;
+	}
+
 	dev_dbg(&i2c_imx->adapter.dev, "<%s> TRX complete\n", __func__);
 	i2c_imx->i2csr = 0;
 	return 0;

