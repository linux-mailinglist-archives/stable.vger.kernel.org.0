Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEC52D4609
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731748AbgLIPzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:55:11 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:40257 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731454AbgLIPzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:55:00 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 785FE1942CA0;
        Wed,  9 Dec 2020 03:31:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 03:31:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=P+Xut8
        dHhADNtYSvaEJ9JWbTWeJ8UUAzLBpIO1PHO7Y=; b=nYOG2RN1h/x5S8gLlQaNsW
        5Ul9e8pURUdG21kSnn6eEqzd/FLjVYWYHqlgFTX2leKYfTut2kQJu9WcyiJ11FYo
        rIExnT8B3HVysez/GFUUB3VsOg3lpEoatiehGGC/OLj/4ih3TiWKz424YjJIDbkM
        6EDwb5Sw+8JVo9pnYIm7scAJqISXLPtM9jdFxQPnJ5II6jNMQKAPJApn4yXDkvTO
        0Qz4+iZKP1VJjM34lBoFAX8hy3iQ2kld/yHDY5HuKTOnc4oShoetL1xukSO2Jl/j
        R0SqVWK58wpY+6n1qgxymQJrNrCznNmzQvdM3Y5YAMLJghkMw7M3Rc7i/zk1EXyA
        ==
X-ME-Sender: <xms:cIvQX2zPSWZM0Sbb5fCacIIdV5BzJGb_h1AxgImWy0RgupJ4rAobcw>
    <xme:cIvQXyR1TgX8rjjfWE0-GACg-lOLZAxNpMS-_vKTciPATWwWWV_kKyBHIIXwpR7kA
    CoumbgwxMyEmw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:cIvQX4WQNuyRjkkODoTAKTwBkAgExOZI953Mpuk51t6U9nQxR5UPiw>
    <xmx:cIvQX8hykm5ACwBWS60UK2fkvkQ0hpbyODAh6Y9-NX1RvMqRSfxPbA>
    <xmx:cIvQX4BTHiSrb2WtcIGZcETTdlrw-wHINHSMrksnAG7cYMqa_8pbKA>
    <xmx:cIvQX7NQEMywHvSeWks0yCUj6j-RfDu-bZmK1TnhBD3Jlzgw2YohiQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1EEB424005D;
        Wed,  9 Dec 2020 03:31:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] i2c: imx: Check for I2SR_IAL after every byte" failed to apply to 4.14-stable tree
To:     ceggers@arri.de, krzk@kernel.org, o.rempel@pengutronix.de,
        wsa@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:33:01 +0100
Message-ID: <16075027818359@kroah.com>
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

