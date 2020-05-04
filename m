Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81B61C38AC
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 13:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgEDLzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 07:55:53 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:48923 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726797AbgEDLzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 07:55:53 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 275BC571;
        Mon,  4 May 2020 07:55:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 04 May 2020 07:55:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vqaV5K
        qQgf97YK2PfK9ccZFPcLAfN/OKgE7TPpVGL74=; b=n+ka2EghZTRC2Do23Mv7D+
        8lAMpy1Dp8pm1Y73Jg6m+TnlNpdS9UanFDaqBxU/UQyaVYec6HOFf5o9lhncuTby
        8Ekm37qBJNi22cA8IN4UTf+EEj5SkBM87QS/EMt/L1mYPXSUJZbVscTWf9z6/UBK
        iJfDtQ8c29Ip/brpCN4qFVSfQpnWOkQU0Okl37m1fKSJzENfQn8pVpVWMIhRNNGB
        9BtfXxZ3gi+4FvfhJfCDKD868J2Izo75xbSoV6bQTVeKttUCCV0gHOyWNOk5gLpD
        22AJCaGYGXXegBHMru2csrTWUwjqg9P/1lu7mrOkW10ncs4ZhexsOT8EshaqFRaw
        ==
X-ME-Sender: <xms:xwKwXvXZLLDOsT9QPJPMuPOGT4DQxJED6UoUoGzpjQtkaGWzdd7v4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeeggdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:xwKwXuLY7UKbugv03nsf7Nx9rks7gml75v01HY-Y2jHenyqS4Vf3kw>
    <xmx:xwKwXoL5ewznr1ERuFgQCM6YqZhGxWcREf5dOxq_JCYM26UOI-8scA>
    <xmx:xwKwXi_zLhXYIDBbGIK_s_hqwl9gnId0HeJsyT2AGCDoyhrGskUfVg>
    <xmx:xwKwXn3h5DGfdIN6Qpv5YrdoizgHBcWlkppEzP2XX7angf2CXQqNAhzrFNw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 62A4A3280060;
        Mon,  4 May 2020 07:55:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] i2c: aspeed: Avoid i2c interrupt status clear race condition." failed to apply to 4.19-stable tree
To:     ryan_chen@aspeedtech.com, benh@kernel.crashing.org,
        wsa@the-dreams.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 13:55:42 +0200
Message-ID: <1588593342143146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

