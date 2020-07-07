Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B4A216CC0
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 14:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgGGMXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 08:23:48 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:38319 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728088AbgGGMXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 08:23:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5B39319401E6;
        Tue,  7 Jul 2020 08:23:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 07 Jul 2020 08:23:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GwI+6k
        ft1pzks5Kx3kvXO8oRgY5P1tfghRKzri6jkTI=; b=iKHBL40s7w2r2E5qpk7Pbf
        LzBuR6BdzAY0pUXkqxUtha6ImnAq+ehxFzjq/rLSWuOe0jaqOkdpvfuNqwfas4Zq
        osQv0fw8IKR2Xn2/TcY7HP2eEM359Ym6gOVgjv8xdC3jwDvCTy/lJiX/eUm6N0cW
        +2JaBmYtW1kaCdt3pKlaAKRLsw6lrPkHw/h9mrHUe288jkSBrjv7Sskfji/RHtD1
        iddmLWldGnmYcmyMTsTxHv46Uu14yyUCTT5HmEfRAeDkG82BMFEtO+VOndWv35pm
        +nU5Uc34o77Nbs3mWmkG1yzV4yjVFPB9hCsgO4tIneOI+mDa7jJWCYmLaRaGO+1g
        ==
X-ME-Sender: <xms:U2kEXyUhem44FjTJ7UHEFefnOCV2yN-AZeDavlyilO1vj1jOBg8afw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:U2kEX-l22a-F2gCKjdB0mUDVvz5wkcY3zhZ3PC_UH79JT9A0bygY5g>
    <xmx:U2kEX2ZPmeR_n6pkuuPQgR1ATfEBDbwXThqlpKAQsmU5eeVmU__vIA>
    <xmx:U2kEX5Xeh_1_djvsaQFzMudoS6BLMqnNCaSe1lB4ElZ0IJCIEtGbCA>
    <xmx:U2kEXzuzHqx3zRMTdQ4dEtyerh3uV_Zulnjuf_MY89rmVmv5X2KMuw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C520830653C5;
        Tue,  7 Jul 2020 08:23:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: spi-fsl-dspi: Fix external abort on interrupt in resume" failed to apply to 4.4-stable tree
To:     krzk@kernel.org, broonie@kernel.org, stable@vger.kernel.org,
        vladimir.oltean@nxp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Jul 2020 14:23:46 +0200
Message-ID: <159412462616259@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 3d87b613d6a3c6f0980e877ab0895785a2dde581 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Mon, 22 Jun 2020 13:05:42 +0200
Subject: [PATCH] spi: spi-fsl-dspi: Fix external abort on interrupt in resume
 or exit paths

If shared interrupt comes late, during probe error path or device remove
(could be triggered with CONFIG_DEBUG_SHIRQ), the interrupt handler
dspi_interrupt() will access registers with the clock being disabled.
This leads to external abort on non-linefetch on Toradex Colibri VF50
module (with Vybrid VF5xx):

    $ echo 4002d000.spi > /sys/devices/platform/soc/40000000.bus/4002d000.spi/driver/unbind

    Unhandled fault: external abort on non-linefetch (0x1008) at 0x8887f02c
    Internal error: : 1008 [#1] ARM
    Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
    Backtrace:
      (regmap_mmio_read32le)
      (regmap_mmio_read)
      (_regmap_bus_reg_read)
      (_regmap_read)
      (regmap_read)
      (dspi_interrupt)
      (free_irq)
      (devm_irq_release)
      (release_nodes)
      (devres_release_all)
      (device_release_driver_internal)

The resource-managed framework should not be used for shared interrupt
handling, because the interrupt handler might be called after releasing
other resources and disabling clocks.

Similar bug could happen during suspend - the shared interrupt handler
could be invoked after suspending the device.  Each device sharing this
interrupt line should disable the IRQ during suspend so handler will be
invoked only in following cases:
1. None suspended,
2. All devices resumed.

Fixes: 349ad66c0ab0 ("spi:Add Freescale DSPI driver for Vybrid VF610 platform")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200622110543.5035-3-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index ec7919d9c0d9..e0b30e4b1b69 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1109,6 +1109,8 @@ static int dspi_suspend(struct device *dev)
 	struct spi_controller *ctlr = dev_get_drvdata(dev);
 	struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
 
+	if (dspi->irq)
+		disable_irq(dspi->irq);
 	spi_controller_suspend(ctlr);
 	clk_disable_unprepare(dspi->clk);
 
@@ -1129,6 +1131,8 @@ static int dspi_resume(struct device *dev)
 	if (ret)
 		return ret;
 	spi_controller_resume(ctlr);
+	if (dspi->irq)
+		enable_irq(dspi->irq);
 
 	return 0;
 }
@@ -1385,8 +1389,8 @@ static int dspi_probe(struct platform_device *pdev)
 		goto poll_mode;
 	}
 
-	ret = devm_request_irq(&pdev->dev, dspi->irq, dspi_interrupt,
-			       IRQF_SHARED, pdev->name, dspi);
+	ret = request_threaded_irq(dspi->irq, dspi_interrupt, NULL,
+				   IRQF_SHARED, pdev->name, dspi);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Unable to attach DSPI interrupt\n");
 		goto out_clk_put;
@@ -1400,7 +1404,7 @@ poll_mode:
 		ret = dspi_request_dma(dspi, res->start);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "can't get dma channels\n");
-			goto out_clk_put;
+			goto out_free_irq;
 		}
 	}
 
@@ -1415,11 +1419,14 @@ poll_mode:
 	ret = spi_register_controller(ctlr);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Problem registering DSPI ctlr\n");
-		goto out_clk_put;
+		goto out_free_irq;
 	}
 
 	return ret;
 
+out_free_irq:
+	if (dspi->irq)
+		free_irq(dspi->irq, dspi);
 out_clk_put:
 	clk_disable_unprepare(dspi->clk);
 out_ctlr_put:
@@ -1445,6 +1452,8 @@ static int dspi_remove(struct platform_device *pdev)
 	regmap_update_bits(dspi->regmap, SPI_MCR, SPI_MCR_HALT, SPI_MCR_HALT);
 
 	dspi_release_dma(dspi);
+	if (dspi->irq)
+		free_irq(dspi->irq, dspi);
 	clk_disable_unprepare(dspi->clk);
 
 	return 0;

