Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACAB82D4628
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbgLIP5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:57:01 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:46427 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730664AbgLIPyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:54:07 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5667E19432D1;
        Wed,  9 Dec 2020 03:31:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 03:31:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xYgeqv
        H3nQj/OKwVIszent7duRGMy0l/evdJxTMo/Uk=; b=itTgSKNGxcO+if49PIMV7c
        EHXIULVoj+e4unvNcU6gqa08aZA8okUiRZ2C8qwOAnCvnv6hmH2ihLf+oRkOvXk5
        wQiUxBeN+5IB98n+qbb5MgWPBcf/mcHTiinHfpwphmLAG9vr3eZpgACUc3wHK2CJ
        WS8PyJfedV6dUGL99ZGw558V3OaLphq2+GY4HU3OX6MlNrI5tVNiU/8KZN0WAXDX
        BLlIXSEQHejh5QKXMrB45U8V30QJ+3RTn/6Ci/EllEiJ9tmchGPr0ZWvzwVmQhi+
        iPOkjqjqzx5fx8bo/UJcIWiZr9+rxPs8dw4LMPiKezRNf5zBTsuHeTSGKR/c0HgA
        ==
X-ME-Sender: <xms:c4vQX1_gC8R1eOqvUVeihiadgAmRRDVMxGeziWeYLe2iOrmPTKsdvA>
    <xme:c4vQX5v-LaZn8H_ANpc-zmSMYkjPJ6vdc4AT8ReGt6wfl-Gy9NKlGtR1j-2f6r3S5
    93ogPaf99kmDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:c4vQXzACmSxjbNWf6LQoGddKm017sy-rO2pjD1EJaWZtnoenPQLYXA>
    <xmx:c4vQX5d6QF5aixKn1V8UcCwoyza9xBaggAHS2mBsqBNkFSYB-e00SA>
    <xmx:c4vQX6OgD0EfkJWlK36UC0WY_p1T1Q7Gpbyp2kp_42WDJkI5JFRnrQ>
    <xmx:c4vQXzb_IkkWRt--cA-aQpFYPGCn4GrTF_s4LtegHMy8lgWJsyFbUw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id F2371240064;
        Wed,  9 Dec 2020 03:31:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] i2c: imx: Check for I2SR_IAL after every byte" failed to apply to 4.9-stable tree
To:     ceggers@arri.de, krzk@kernel.org, o.rempel@pengutronix.de,
        wsa@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:33:02 +0100
Message-ID: <160750278286215@kroah.com>
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

