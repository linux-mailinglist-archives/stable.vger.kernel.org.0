Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7355C2D45FF
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731346AbgLIPyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:54:50 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:43271 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731296AbgLIPyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:54:50 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0963C194399C;
        Wed,  9 Dec 2020 03:30:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 03:30:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TBAawh
        hEPzi7/wqn7CL2mYv87VU2OXiqd2mLglTSyFQ=; b=COmL+RDoedXAqS6vHQVhmR
        OOk0nryWBNM0zcxJNx7aVHr/gqg6EmLhbuy4LP9sRH1sIGcSmO8Glma/aLCuU5ft
        XHUzbAHT403eMDH8FtwU6bianXmimzjeFC4V5ofpyODptDDQJydFDo/MihlDjmMk
        u6N5uhKM5sQ5LfMJYy/Pjx6K7v9sU4hH1SJ/4MEx+ju0CJrFBgEJ7zwQsUieZ7Yy
        5yyjem7i7K1+RLxqRB//t+RxvL1IlNRskg5Y6f0bHwrZzbMGLfXNbiYVnfJhQnzi
        b/obdRS8+QLTS+3QOAcL8sKRIhbrsl94mk8MS8JTGYci4F8NnLjhl7dMhGScfFZg
        ==
X-ME-Sender: <xms:GIvQX-xt18YS8BwW5jESKpo3D09yr7iTBCVMHBGErGQ3-uYxJQ6GyQ>
    <xme:GIvQXzsLTeGNv8YjKkqbuG5VO8N6X0HZsB_CR-uf2gP42Yn1ogQQU3FYwyFQ_Sf9G
    H3c_RRlWz1ZWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefgge
    dvuedufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:GIvQX_4X3_jj2m_aoQI07OgfOigCvs4BtwO0dcOMcJ6Y-rPEzyR5wg>
    <xmx:GIvQX6R-nlCV8JGH2WlEUcfpykbZKuZ68Z7ZfRqmjzZNjvhT671KZA>
    <xmx:GIvQX2oqoMs0q8ZHBBB8lwxqNyHArIaXpwf03SA8mSNZS-JGd8ZWsA>
    <xmx:GYvQX9FIYaP6XgmHJDvyfIrSpriFM__C_tv09YOA2V2l8pXl-H3lqg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EAB12240067;
        Wed,  9 Dec 2020 03:30:15 -0500 (EST)
Subject: FAILED: patch "[PATCH] i2c: imx: Fix reset of I2SR_IAL flag" failed to apply to 5.4-stable tree
To:     ceggers@arri.de, o.rempel@pengutronix.de,
        u.kleine-koenig@pengutronix.de, wsa@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:31:33 +0100
Message-ID: <1607502693116181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

