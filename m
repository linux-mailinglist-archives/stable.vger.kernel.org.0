Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D5928A660
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 10:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbgJKIje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 04:39:34 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:36871 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728968AbgJKIje (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Oct 2020 04:39:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2063E1940D06;
        Sun, 11 Oct 2020 04:39:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 11 Oct 2020 04:39:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mnPjfJ
        jxyb1rztk8pHh0x136aDQsgdZT/lavxynGAUg=; b=ZY7QFlgSmWWpLJErTeYkhz
        c5yCMQVxWVikSpi7SkZBCWktyiAOxJsfDuNIVCpvN7sc4NqLtBoWF5i+H63i1PK2
        y7Q2S2KiVgx7gIduZu4cuRqOVfBbwV7Pa0SGfHTOEwgMQBeyTaUFeHJm1Fb6nOkq
        1trkTPFEm2ie7bnFegZ8GbN0cuCdku22oa4LNz+7nkGJu6OWxXnvf1AGprNxPpil
        +gJZQq596IuASWE2lLOzn3i06kbPYYhOuXys8QapWd9sUapkX/zhx0JG+D0dH3hS
        DO1m/io3zGvUV9am2z0+pcHEUx/yFWFDIPe1bLdxIQWRfypMos02ih0bYJxBEtCg
        ==
X-ME-Sender: <xms:xMSCXwxGQ6Ok8bigCALBhuj68yEHLVpLIR6GYJltCcoLKeYU7VmqSA>
    <xme:xMSCX0S3mTdozwRWJSXaEFXE6RQ7Ef8DhfFySzHWHtwrY-CQgIxYOBLtAds87w9FP
    DtcEVCexzfQYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrheehgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:xcSCXyV4KqmvxZTsIOcvO7HenyaABKWaehkxqEI6Qrt7Ng3gefmSCw>
    <xmx:xcSCX-jRBUyqH7STpUvKC1QDQviJK_JOqEM-g5H_z02YD0k6LXz14Q>
    <xmx:xcSCXyCUNId5fbRdHFbLvRw_rSDDbgVnVfa4liKTCsaTvIIucOV7GQ>
    <xmx:xcSCXz4y_vMMoEHq-nTPq5D-9GHqmsxvVaXVmhTpHhlDyfOuzTK0rQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AFFAD328005E;
        Sun, 11 Oct 2020 04:39:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] i2c: imx: Fix reset of I2SR_IAL flag" failed to apply to 4.19-stable tree
To:     ceggers@arri.de, u.kleine-koenig@pengutronix.de, wsa@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Oct 2020 10:40:13 +0200
Message-ID: <160240561387188@kroah.com>
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

From fa4d30556883f2eaab425b88ba9904865a4d00f3 Mon Sep 17 00:00:00 2001
From: Christian Eggers <ceggers@arri.de>
Date: Wed, 7 Oct 2020 10:45:22 +0200
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
Cc: stable@vger.kernel.org
Signed-off-by: Wolfram Sang <wsa@kernel.org>

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 0ab5381aa012..cbdcab73a055 100644
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
+	 * toggled. This is required because i.MX needs W1C and Vybrid uses W0C.
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

