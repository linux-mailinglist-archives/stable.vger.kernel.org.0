Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469282D45E4
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbgLIPxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:53:52 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:34329 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730978AbgLIPwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:52:55 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9ECB619432CD;
        Wed,  9 Dec 2020 03:31:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 03:31:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TdOg82
        zcZRXJ0Kcg0bbcnxjSGGdEDts5+QVqQ1Li7MQ=; b=ZsR5+ABc2rNTpBMkUPj1BM
        ggM7asFRbw8nCtiEStqbrMdd6N+uZCmElcvOTHMeazL6hiaymWOdV5lQn3ixIvyS
        b2hTgfBYc0Kj/DdmVFLGEJ9pb4j1WzvCyL+dJzf+SfbyA4NhkOm+5y1d8Qp1tbre
        Pz7k3XEFtDl30bp90vgJpHQ/HJO8rGNllcWQpnDRdw7RLcgPXi6rarpVkVs7rQes
        xAbmHugGg668HxIT5Smzoix+kkWvlIzHCwC79AinO+qWLr+zqxtEoiujhMEzuQi9
        g7fZTpc1P44dVoDLmUPrhJf3jP0zWzGAbaNEHukLyJ6tFUJGdrlcaYObDefZ5FPQ
        ==
X-ME-Sender: <xms:d4vQX7apQKNcGWHKXbwgrtPr3muSjIY2wgYqfH9QW-xt2MdPufdZsQ>
    <xme:d4vQX6bivyo9tMA2OYTGgyPQRtr5BcGOUWPab044IGtLFASJG8nLLf787lc2AYQae
    jmNvLauCkn4jA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:d4vQX9_8vHW2J7lAqP-8l4_ODYFSlRemLcsblMe9SgpEOzqJLEjw1A>
    <xmx:d4vQXxpxH7FLaUjokg_dSmC9B_u1E0pEPDqecYLX09PCUOFUDSODnQ>
    <xmx:d4vQX2pIPLZlf5usRbbi99aelI3BmdGKWXL3DVBaV95hHVUwt9gUQg>
    <xmx:d4vQX9043PidGT2OvB51ZLhXyXUFw0PmuIs_dTKosMITFiPa2ZoxHA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 47D3D1080063;
        Wed,  9 Dec 2020 03:31:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] i2c: imx: Check for I2SR_IAL after every byte" failed to apply to 4.4-stable tree
To:     ceggers@arri.de, krzk@kernel.org, o.rempel@pengutronix.de,
        wsa@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:33:03 +0100
Message-ID: <1607502783102119@kroah.com>
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

