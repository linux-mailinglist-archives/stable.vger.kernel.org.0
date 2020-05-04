Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A511C38AB
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 13:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgEDLzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 07:55:47 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:42789 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726797AbgEDLzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 07:55:47 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 06302656;
        Mon,  4 May 2020 07:55:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 04 May 2020 07:55:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=eB9Y1f
        fQLJbGoxkZQS0VcCG1dpWjj6/CD09/ZWwfj4c=; b=uwXO3OVvjZtKtKRvHPyh0n
        IaAH+NaTWUK8zqgn68W6OPBv4Ptt9anrTm4WBs3g5I/K8LifKA8Y6ZpQeaQRPsfP
        bSt80vrzTvWPM6s+ZA93SKXNkCqe3vC2EAIjj/T9ZUO+n4Q6qZUr/YxawiJcs/Ml
        m7RU2AWR3K6z3fKntV4jKP0hLTZ6t62JLggjJtTgJZQ+pz93RI2UbzQ/ALxBDh/A
        qSMAiUO8sAV0We9Np+he25ZrskJEYxzm5r7O5BIm8CD5Dj253hMia//gJlgqClTA
        MZd/RqZxmJovqoQ6NU4zWyPWK2KW9KeQ0taWVpUq68hE2aYvRAh8Zee4a3Ct1BdQ
        ==
X-ME-Sender: <xms:wAKwXuGYc1O8wbgO3AJGxFEca9ytXvpzMhQgIVZ4GHC7s5CP5mFKIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeeggdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:wAKwXmiD2TOFeU5YKNF71oOwnojw8-BaOhnIPDEiZBqYEPA_3ACOWQ>
    <xmx:wAKwXshZ63tts2zYqiC-WWG_Xsjx3NxuizDPyR6V98w3WGBjpQhUHQ>
    <xmx:wAKwXgxUwYSGqQEWTWrqdi0RpQZdwYrx8kjpd106LUm1bkY8Z9xgbg>
    <xmx:wQKwXsdiXqZyOfXUUedRjBS-hV4H-aazBPpTobhOg9pL0N7GgcDPv9I_gEc>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 593773280059;
        Mon,  4 May 2020 07:55:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] i2c: aspeed: Avoid i2c interrupt status clear race condition." failed to apply to 4.14-stable tree
To:     ryan_chen@aspeedtech.com, benh@kernel.crashing.org,
        wsa@the-dreams.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 13:55:41 +0200
Message-ID: <1588593341155227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From c926c87b8e36dcc0ea5c2a0a0227ed4f32d0516a Mon Sep 17 00:00:00 2001
From: ryan_chen <ryan_chen@aspeedtech.com>
Date: Wed, 29 Apr 2020 11:37:37 +0800
Subject: [PATCH] i2c: aspeed: Avoid i2c interrupt status clear race condition.

In AST2600 there have a slow peripheral bus between CPU and i2c
controller. Therefore GIC i2c interrupt status clear have delay timing,
when CPU issue write clear i2c controller interrupt status. To avoid
this issue, the driver need have read after write clear at i2c ISR.

Fixes: f327c686d3ba ("i2c: aspeed: added driver for Aspeed I2C")
Signed-off-by: ryan_chen <ryan_chen@aspeedtech.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[wsa: added Fixes tag]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

diff --git a/drivers/i2c/busses/i2c-aspeed.c b/drivers/i2c/busses/i2c-aspeed.c
index 07c1993274c5..f51702d86a90 100644
--- a/drivers/i2c/busses/i2c-aspeed.c
+++ b/drivers/i2c/busses/i2c-aspeed.c
@@ -603,6 +603,7 @@ static irqreturn_t aspeed_i2c_bus_irq(int irq, void *dev_id)
 	/* Ack all interrupts except for Rx done */
 	writel(irq_received & ~ASPEED_I2CD_INTR_RX_DONE,
 	       bus->base + ASPEED_I2C_INTR_STS_REG);
+	readl(bus->base + ASPEED_I2C_INTR_STS_REG);
 	irq_remaining = irq_received;
 
 #if IS_ENABLED(CONFIG_I2C_SLAVE)
@@ -645,9 +646,11 @@ static irqreturn_t aspeed_i2c_bus_irq(int irq, void *dev_id)
 			irq_received, irq_handled);
 
 	/* Ack Rx done */
-	if (irq_received & ASPEED_I2CD_INTR_RX_DONE)
+	if (irq_received & ASPEED_I2CD_INTR_RX_DONE) {
 		writel(ASPEED_I2CD_INTR_RX_DONE,
 		       bus->base + ASPEED_I2C_INTR_STS_REG);
+		readl(bus->base + ASPEED_I2C_INTR_STS_REG);
+	}
 	spin_unlock(&bus->lock);
 	return irq_remaining ? IRQ_NONE : IRQ_HANDLED;
 }

