Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DF72C01BD
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 09:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgKWIxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 03:53:24 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:40367 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727442AbgKWIxY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 03:53:24 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7BF73F62;
        Mon, 23 Nov 2020 03:53:23 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 03:53:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=eYLAe9
        GJDPwrXAnfyR9nZbTuotz9NHuQI728ywVz4lA=; b=JeVdNCeps+AJBEdGWMBpka
        A77hfD6ij5xzblRRGFQfcGcjKGHh5oS4r9Sz+x0yxPuxgw/43jjw5VeyiGMADNk0
        1iFzZVnRDdWM0PiCwJGuo31JpPA+AK55kiO5yHnOpp/l4mw69R9/f/gulyEmiiz/
        d91BOFcO5ubQpVulzrH09yt0EFUnYTwDaaRzaitYbbS+3prJnL7piODHJCeKwSbP
        iXsVPcXr4MMuoYi/+EIMNh5BtoYrG21eVbDbMhZ6Wy95sMaellvjRF6iXOvKqOHv
        iucXyuEOn5bxi0oLXGfn0OkB26ft94MTbX6Q0PdcxKswEJpSPoqmtKmxtbAK6gxg
        ==
X-ME-Sender: <xms:g3i7XyjjNnQqaIvikVzfrvrIMm94IjzoaS8x_68UOefZR5sKjjxnQQ>
    <xme:g3i7XzDESiyUXSPzXb5xRPGWLxnwveK-bNQXey57ETadRfBvrD7tvctrkqnoOmgsD
    5sPgIe13Y94ig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:g3i7X6EAuXvDsh_V8rhRg0O7Lsef8OUpsRqBWNeHrKDG30rwnNYNvg>
    <xmx:g3i7X7RWpVtUGyUifT2HULAwja5gRUMa3UrbheyoOYLgBfsbSJiMkA>
    <xmx:g3i7X_xmf9M1-HqtZt-xy4ww8kIDIcKE_snfGCkX9rQQVkDz_urgvg>
    <xmx:g3i7X_8Ym5qHuuBopgTu7Gm_36ecJ4gkKUYOqGs7HNphLVjWCvG8LY5iCaU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A7AA63280067;
        Mon, 23 Nov 2020 03:53:22 -0500 (EST)
Subject: FAILED: patch "[PATCH] spi: bcm2835: Fix use-after-free on unbind" failed to apply to 4.4-stable tree
To:     lukas@wunner.de, broonie@kernel.org, f.fainelli@gmail.com,
        olteanv@gmail.com, s.hauer@pengutronix.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 09:54:27 +0100
Message-ID: <160612166717546@kroah.com>
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

From e1483ac030fb4c57734289742f1c1d38dca61e22 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Wed, 11 Nov 2020 20:07:20 +0100
Subject: [PATCH] spi: bcm2835: Fix use-after-free on unbind

bcm2835_spi_remove() accesses the driver's private data after calling
spi_unregister_controller() even though that function releases the last
reference on the spi_controller and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound.

Fixes: f8043872e796 ("spi: add driver for BCM2835")
Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v3.10+: 123456789abc: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v3.10+
Cc: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/ad66e0a0ad96feb848814842ecf5b6a4539ef35c.1605121038.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 7104cf17b848..197485f2c2b2 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1278,7 +1278,7 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 	struct bcm2835_spi *bs;
 	int err;
 
-	ctlr = spi_alloc_master(&pdev->dev, ALIGN(sizeof(*bs),
+	ctlr = devm_spi_alloc_master(&pdev->dev, ALIGN(sizeof(*bs),
 						  dma_get_cache_alignment()));
 	if (!ctlr)
 		return -ENOMEM;
@@ -1299,23 +1299,17 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 	bs->ctlr = ctlr;
 
 	bs->regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(bs->regs)) {
-		err = PTR_ERR(bs->regs);
-		goto out_controller_put;
-	}
+	if (IS_ERR(bs->regs))
+		return PTR_ERR(bs->regs);
 
 	bs->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(bs->clk)) {
-		err = dev_err_probe(&pdev->dev, PTR_ERR(bs->clk),
-				    "could not get clk\n");
-		goto out_controller_put;
-	}
+	if (IS_ERR(bs->clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(bs->clk),
+				     "could not get clk\n");
 
 	bs->irq = platform_get_irq(pdev, 0);
-	if (bs->irq <= 0) {
-		err = bs->irq ? bs->irq : -ENODEV;
-		goto out_controller_put;
-	}
+	if (bs->irq <= 0)
+		return bs->irq ? bs->irq : -ENODEV;
 
 	clk_prepare_enable(bs->clk);
 
@@ -1349,8 +1343,6 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 	bcm2835_dma_release(ctlr, bs);
 out_clk_disable:
 	clk_disable_unprepare(bs->clk);
-out_controller_put:
-	spi_controller_put(ctlr);
 	return err;
 }
 

