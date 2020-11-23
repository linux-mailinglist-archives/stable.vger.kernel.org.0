Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49BA2C01B8
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 09:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgKWIxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 03:53:14 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:56793 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726776AbgKWIxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 03:53:14 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 347B3EBC;
        Mon, 23 Nov 2020 03:53:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 03:53:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ErKTBA
        rLL8dc6MlJq5aFOvSApWxwwfI9H5d0NTHZggo=; b=CZZXREn8kw1h+8mUiJCB1d
        cZVOnrvA3tQost5yBIKRrC3prDR4Q7faLi/iRv1+FJDMSZ6QcOYsRZyqw/cv9g9s
        zyS9cXL5Vxoip3v942kkH5jLvXy1iH/oDq28CQ1FPdekG4Gmei8lcWCjx1qCFEbA
        iRXW2wdW+1/fTnx+XiVho6jujbRWPN/B6GioH9VFwcsaPR4N3Gz1uV/jsKD4c37r
        mJG1D/T2PztLHSmiOM0AkkU3DW1qgJt1J0IL88iKa61SZccJbmFuRlYaL964QEdi
        AmDay79Dk2ptnaI/SsQfLESb+Cjzph46dStV8HfDQGR4fw3qSlAGKHRByx8tSD5Q
        ==
X-ME-Sender: <xms:eHi7X1xNbYvirpbiaiicnfTwvuBChagKOC6St4rEX3ADeH_8a5G_7A>
    <xme:eHi7X1S00PHPmmKUCnOOyRJeVDT-yjyP1eqKBedHM2_pzujC-4f_UDvKymM7j3fhV
    uucZaKC1LOqjQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:eHi7X_WXsISTIC3Y3gGnGEvvnnnlxP540FT1xZHqQq_hvZ7zK5OukA>
    <xmx:eHi7X3g9dviSfUyl2zjigRLxoG1IIzd5qvJ7xYGyi0mQmNVixZBdIA>
    <xmx:eHi7X3DAdfxFt_tXO2QLQC02KhVwFh05ifp8N_CMsgDZ3F29mFXdcQ>
    <xmx:eHi7X-NPO6STB1tj-3fMZNAvDDNvlZ_Qzg7cfZa0h627bVczuxTCiTFThxU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 19C513064AA7;
        Mon, 23 Nov 2020 03:53:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] spi: bcm2835: Fix use-after-free on unbind" failed to apply to 5.9-stable tree
To:     lukas@wunner.de, broonie@kernel.org, f.fainelli@gmail.com,
        olteanv@gmail.com, s.hauer@pengutronix.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 09:54:23 +0100
Message-ID: <1606121663128223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
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
 

