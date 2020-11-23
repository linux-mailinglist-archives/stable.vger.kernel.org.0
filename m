Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D142C01B7
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 09:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgKWIxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 03:53:05 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:42839 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726776AbgKWIxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 03:53:05 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 29C6AE0B;
        Mon, 23 Nov 2020 03:53:04 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 03:53:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dMQ9k3
        76/hN4vGTvWhC0nE8suomWlCXnjh1aM0WdKCQ=; b=Dc+fRvjh9IhJTKYszn0xef
        NNtxEFb4tbUnd9wYv3cEFxPGZJ8JVx2RMoQg9Dll6VbirPlc5jZDYMKF36BXFUX8
        8mEVm84ApClgc2bRJtmaQEptvZRNUzYrOVckrU/QTmNGIzulzuDYjx8K7Q5r0O2g
        hWLAa/JHbpMe5X5gC/PJ2d4UaDnQhYj14NP5N0pQmE0AbLkgEeDUDGR9jwD+yZpw
        /+vdBHRNYrUz4CM4CwwG6DrCcTAfNNtwcmQhjApg18pdnNzGxLroED/wYfMu+CuE
        XVTJ1LteAiGvldf7Ij/kVbL4ThyyzQ1MvlmLZ1DyK6ZrNMp6zj8SxmekuwLUvwcg
        ==
X-ME-Sender: <xms:b3i7X4nlewKajcdbxNXweeLtJr0NTPwAzHcvE0LuN5wNLQQdlzYI2w>
    <xme:b3i7X33tOw-eC4xlTxvCHY9PntcNm-e975JiTFmTm3RK7m6vxhxysPP9sevr5mriD
    YiDYBgRPnv4qg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:b3i7X2rEfqC5LwBHIRJhaORpGohy_T-0gQ3esI74hI9L8_n_retW5w>
    <xmx:b3i7X0lJDH0THtyMYV2T6Xduw-LG0ODgJUaElFsp8yUSnA-lAvS0Tg>
    <xmx:b3i7X22OomFcs3jd02Bfav4ym_UCqYbEDQJczA4WKR0v-Wo0y4ss5w>
    <xmx:b3i7X79E9M1TrJH5Z5e-QOR_DIPUtNNYktYGOX6avk_E5e5yOKGNGEHRtbw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7C953328005D;
        Mon, 23 Nov 2020 03:53:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] spi: bcm2835aux: Fix use-after-free on unbind" failed to apply to 4.19-stable tree
To:     lukas@wunner.de, broonie@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 09:54:04 +0100
Message-ID: <1606121644237255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From e13ee6cc4781edaf8c7321bee19217e3702ed481 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Wed, 11 Nov 2020 20:07:30 +0100
Subject: [PATCH] spi: bcm2835aux: Fix use-after-free on unbind

bcm2835aux_spi_remove() accesses the driver's private data after calling
spi_unregister_master() even though that function releases the last
reference on the spi_master and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound.

Fixes: b9dd3f6d4172 ("spi: bcm2835aux: Fix controller unregister order")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.4+: 123456789abc: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.4+: b9dd3f6d4172: spi: bcm2835aux: Fix controller unregister order
Cc: <stable@vger.kernel.org> # v4.4+
Link: https://lore.kernel.org/r/b290b06357d0c0bdee9cecc539b840a90630f101.1605121038.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-bcm2835aux.c b/drivers/spi/spi-bcm2835aux.c
index 03b034c15d2b..fd58547110e6 100644
--- a/drivers/spi/spi-bcm2835aux.c
+++ b/drivers/spi/spi-bcm2835aux.c
@@ -494,7 +494,7 @@ static int bcm2835aux_spi_probe(struct platform_device *pdev)
 	unsigned long clk_hz;
 	int err;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*bs));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*bs));
 	if (!master)
 		return -ENOMEM;
 
@@ -524,29 +524,24 @@ static int bcm2835aux_spi_probe(struct platform_device *pdev)
 
 	/* the main area */
 	bs->regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(bs->regs)) {
-		err = PTR_ERR(bs->regs);
-		goto out_master_put;
-	}
+	if (IS_ERR(bs->regs))
+		return PTR_ERR(bs->regs);
 
 	bs->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(bs->clk)) {
-		err = PTR_ERR(bs->clk);
 		dev_err(&pdev->dev, "could not get clk: %d\n", err);
-		goto out_master_put;
+		return PTR_ERR(bs->clk);
 	}
 
 	bs->irq = platform_get_irq(pdev, 0);
-	if (bs->irq <= 0) {
-		err = bs->irq ? bs->irq : -ENODEV;
-		goto out_master_put;
-	}
+	if (bs->irq <= 0)
+		return bs->irq ? bs->irq : -ENODEV;
 
 	/* this also enables the HW block */
 	err = clk_prepare_enable(bs->clk);
 	if (err) {
 		dev_err(&pdev->dev, "could not prepare clock: %d\n", err);
-		goto out_master_put;
+		return err;
 	}
 
 	/* just checking if the clock returns a sane value */
@@ -581,8 +576,6 @@ static int bcm2835aux_spi_probe(struct platform_device *pdev)
 
 out_clk_disable:
 	clk_disable_unprepare(bs->clk);
-out_master_put:
-	spi_master_put(master);
 	return err;
 }
 

