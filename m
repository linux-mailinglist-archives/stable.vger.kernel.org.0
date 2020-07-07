Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3EB216D98
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 15:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgGGNVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 09:21:38 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:46125 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbgGGNVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 09:21:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id CE065194164D;
        Tue,  7 Jul 2020 09:21:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 07 Jul 2020 09:21:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3ZqMmh
        0C69fxRy4HziV70+qxkP4GGkmsqttNmqh4TZk=; b=GANoxFYQfB8I9rpAVMDqwa
        PjZi6AfvthcZ4xVtFYlBeyY4PlxcZ1t67XWuP0W1eS+GbqV2J3lLd0bp1wrdsxvF
        kaVHMsqCjG9OQ3e6/z6X6CYMkgcTG1KARk8hlm8pZw7b24UhGT+93+icnKRhFIZM
        zMagdHwNbrakJjgsj8LrQcMBrmAmA5W8URvpBUeuSpot6wIQSjliQ78p5NgfY7f2
        cBTl0/J5PfV03+1iLwZliCL7bOaiRSfxXwKfFlL3TB+5DzNo3Cl2tIniWh0RWVvw
        SyUTInaUE5q9NB0xjh1B6xmq9Xjyj+bypMzCMDeBySVoX/mp+F/nvIA81rExP1Og
        ==
X-ME-Sender: <xms:4HYEX0DWVe_LS1puJrrmECSXhw0-uwkHCo58f-U5t84Q6Q8RkK9MNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:4HYEX2jV_1BYUd3YOTMROG-cZU2U_yXg90h1XTGcTURrUuAeXrJJfg>
    <xmx:4HYEX3ml6TkK91pyfUuDSCBU4e2Zyk_aLOUyTDEB-FcRlx4EmFdNZg>
    <xmx:4HYEX6yWlVHnZBsqmhZ80EqBAbuFuQPdu3HEbr-G5Tm3IKv42-yUfA>
    <xmx:4HYEX66Yrs59DvJqQHE1WHWmrPMCoGS4IiIRXLWVdwAQIK2D2nDEcQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5302A30600B7;
        Tue,  7 Jul 2020 09:21:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: spi-fsl-dspi: Fix lockup if device is removed during SPI" failed to apply to 5.4-stable tree
To:     krzk@kernel.org, broonie@kernel.org, olteanv@gmail.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Jul 2020 15:21:27 +0200
Message-ID: <1594128087138244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 7684580d45bd3d84ed9b453a4cadf7a9a5605a3f Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Mon, 22 Jun 2020 13:05:40 +0200
Subject: [PATCH] spi: spi-fsl-dspi: Fix lockup if device is removed during SPI
 transfer

During device removal, the driver should unregister the SPI controller
and stop the hardware.  Otherwise the dspi_transfer_one_message() could
wait on completion infinitely.

Additionally, calling spi_unregister_controller() first in device
removal reverse-matches the probe function, where SPI controller is
registered at the end.

Fixes: 05209f457069 ("spi: fsl-dspi: add missing clk_disable_unprepare() in dspi_remove()")
Reported-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200622110543.5035-1-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 58190c94561f..ec0fd0d366eb 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1434,9 +1434,18 @@ static int dspi_remove(struct platform_device *pdev)
 	struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
 
 	/* Disconnect from the SPI framework */
+	spi_unregister_controller(dspi->ctlr);
+
+	/* Disable RX and TX */
+	regmap_update_bits(dspi->regmap, SPI_MCR,
+			   SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF,
+			   SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF);
+
+	/* Stop Running */
+	regmap_update_bits(dspi->regmap, SPI_MCR, SPI_MCR_HALT, SPI_MCR_HALT);
+
 	dspi_release_dma(dspi);
 	clk_disable_unprepare(dspi->clk);
-	spi_unregister_controller(dspi->ctlr);
 
 	return 0;
 }

