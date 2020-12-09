Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8ADC2D45EF
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbgLIPyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:54:11 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:58427 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730669AbgLIPyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:54:08 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5B18F1943996;
        Wed,  9 Dec 2020 03:30:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 03:30:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=iFTcfs
        xUPnkn0hUf+4QImentFnpoSAWq3azFPbqKFV0=; b=nyetWkwqK8MUq976SQ9DdE
        +wrx1WDN3XRux1w9nvdoTmcwQyTZU8TUbmIqpLRLV2Qa9C3Bukx0z1tLTzXelmfc
        xXKSk6UYjwUPjf6K31jZ47jJfwpsOC4C4l/1vjSzQmv+5boXW+fbGiDpXKZem+JC
        FqzRzEgcSN80nFrujHJjbKpF6uYEwCcMn/nLgWtzy+J3qExET+16Ng82OzehBXi/
        3to5EDTA/Y6Wylqjrm5yuPAusdtQKbuwVPblC+/VORVS0p/RreJp+oY+Xd68K6sh
        UZaiVoKra/039S8mAxyhFFqnqt/T7n1wOwKVZgDZBrvf1KioV7uqoIngSJchWz/Q
        ==
X-ME-Sender: <xms:G4vQX-5mVi-J_anlPIStCt0VJRovsDLA_TRpZYLwrCNzxBz-pJ0y3A>
    <xme:G4vQX37DoVeOwn5gYl2Jf0nqhRFOYnP5KdftyAVRlthXyvX5WTvYZWmmLygLS1VZm
    AxhZDkKakKSzg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefgge
    dvuedufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:G4vQX9fICxmZjnLUzBnJu4Lw-su_w2MG15ctVtXxdjruioBpjYyWgw>
    <xmx:G4vQX7IZjR0zlhrU2ODBYHW0PsCCZpgbU1X7EG1IsygbqIKiRrEjRQ>
    <xmx:G4vQXyKhhaI2zJjJ3YrTyuIa31m9fSNQXFOEBdqzBp8CxXt6zKuF7w>
    <xmx:G4vQX5XwAhekJ4Ce0GAhHkVZTIQid41RzBEKo76GBH2th-19fjYUUw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 07912240065;
        Wed,  9 Dec 2020 03:30:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] i2c: imx: Fix reset of I2SR_IAL flag" failed to apply to 4.19-stable tree
To:     ceggers@arri.de, o.rempel@pengutronix.de,
        u.kleine-koenig@pengutronix.de, wsa@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:31:34 +0100
Message-ID: <1607502694242235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 384a9565f70a876c2e78e58c5ca0bbf0547e4f6d Mon Sep 17 00:00:00 2001
From: Christian Eggers <ceggers@arri.de>
Date: Fri, 9 Oct 2020 13:03:18 +0200
Subject: [PATCH] i2c: imx: Fix reset of I2SR_IAL flag
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

According to the "VFxxx Controller Reference Manual" (and the comment
block starting at line 97), Vybrid requires writing a one for clearing
an interrupt flag. Syncing the method for clearing I2SR_IIF in
i2c_imx_isr().

Signed-off-by: Christian Eggers <ceggers@arri.de>
Fixes: 4b775022f6fd ("i2c: imx: add struct to hold more configurable quirks")
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Wolfram Sang <wsa@kernel.org>

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index c98529c76348..39e98d216016 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -412,6 +412,19 @@ static void i2c_imx_dma_free(struct imx_i2c_struct *i2c_imx)
 	dma->chan_using = NULL;
 }
 
+static void i2c_imx_clear_irq(struct imx_i2c_struct *i2c_imx, unsigned int bits)
+{
+	unsigned int temp;
+
+	/*
+	 * i2sr_clr_opcode is the value to clear all interrupts. Here we want to
+	 * clear only <bits>, so we write ~i2sr_clr_opcode with just <bits>
+	 * toggled. This is required because i.MX needs W0C and Vybrid uses W1C.
+	 */
+	temp = ~i2c_imx->hwdata->i2sr_clr_opcode ^ bits;
+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
+}
+
 static int i2c_imx_bus_busy(struct imx_i2c_struct *i2c_imx, int for_busy, bool atomic)
 {
 	unsigned long orig_jiffies = jiffies;
@@ -424,8 +437,7 @@ static int i2c_imx_bus_busy(struct imx_i2c_struct *i2c_imx, int for_busy, bool a
 
 		/* check for arbitration lost */
 		if (temp & I2SR_IAL) {
-			temp &= ~I2SR_IAL;
-			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
+			i2c_imx_clear_irq(i2c_imx, I2SR_IAL);
 			return -EAGAIN;
 		}
 
@@ -469,7 +481,7 @@ static int i2c_imx_trx_complete(struct imx_i2c_struct *i2c_imx, bool atomic)
 		 */
 		readb_poll_timeout_atomic(addr, regval, regval & I2SR_IIF, 5, 1000 + 100);
 		i2c_imx->i2csr = regval;
-		imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2SR);
+		i2c_imx_clear_irq(i2c_imx, I2SR_IIF | I2SR_IAL);
 	} else {
 		wait_event_timeout(i2c_imx->queue, i2c_imx->i2csr & I2SR_IIF, HZ / 10);
 	}
@@ -623,9 +635,7 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
 	if (temp & I2SR_IIF) {
 		/* save status register */
 		i2c_imx->i2csr = temp;
-		temp &= ~I2SR_IIF;
-		temp |= (i2c_imx->hwdata->i2sr_clr_opcode & I2SR_IIF);
-		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
+		i2c_imx_clear_irq(i2c_imx, I2SR_IIF);
 		wake_up(&i2c_imx->queue);
 		return IRQ_HANDLED;
 	}

