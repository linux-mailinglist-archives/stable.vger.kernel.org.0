Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570A5216CB8
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 14:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgGGMXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 08:23:24 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:42769 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726540AbgGGMXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 08:23:24 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 89AB91942068;
        Tue,  7 Jul 2020 08:23:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 07 Jul 2020 08:23:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2j7fax
        kSp3Y027P0wcbpt4uMP+Lzm8AlJ9UEBXyn4tA=; b=ZoxNBa+43nC6bJuKNRVECB
        DnXJV7d4Cr/i1+/FV6SCOhD2UqPZ4ZIgvMcJ/U0AgIbrK7p+Bgr5u02XfqitdX0Y
        jO6wBPOIpH4QktbO7nGX9Cwx/Zn7rlGZTEyKswWEuEEUTQVmOSUuwSq3ziUD6tRT
        dY5SfRsfzsgt7E/qtQSeFroFbIbNXbWu0OKPVryYCFyksPBJm+cH7d2IPwp+YU+J
        SUvkoaajSzYEPZ6HajIs9UCyRgvShMDf4vdETMzZxfAqqwbPCUDtYO719dj8ltBt
        ZDljhJVehp7/DQScMs/8N1fGcOlf6i12EIzzPyTq/XkjCnZIK85CYZFN2iCuz+dw
        ==
X-ME-Sender: <xms:O2kEXwebcne3FEFU7Dnz7qPtWMNk4o28V1sb0tJcQ0vebhf-0Byung>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:O2kEXyNofhcgdPzY2U2AJiLzjb8rvDR2aiIBFqD2bj25ezlkyVbFXA>
    <xmx:O2kEXxghBuRThu4LX0GxrnQ0WkZHZJfgqzU6VdvdBmf1RoMwX_PUFA>
    <xmx:O2kEX18TWy_hyKy_3fspNOw-wXU5DkE56U-fmJa5CAILoUk2GXJ77Q>
    <xmx:O2kEXy1JHQxXR6jrir0IhAMFCngnstXbpRkSi7l0iWqQJ098i-Qwlg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E9874328005D;
        Tue,  7 Jul 2020 08:23:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: spi-fsl-dspi: Fix lockup if device is removed during SPI" failed to apply to 4.4-stable tree
To:     krzk@kernel.org, broonie@kernel.org, olteanv@gmail.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Jul 2020 14:23:13 +0200
Message-ID: <159412459320032@kroah.com>
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

