Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7CB2C021D
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 10:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgKWJPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 04:15:46 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:51845 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725287AbgKWJPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 04:15:46 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 1207DF6B;
        Mon, 23 Nov 2020 04:15:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 04:15:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LtMUTp
        RVjFkC/NoWHggwYoSIIb6ZSjAXutFuqM4J4Cs=; b=Sz4b4plxHCCwMzrcPJy11h
        bCEK5XuEW/WFK0hMyz9HJ8B5bmXMB5lcK6+7wMBALYV7JIi5Ot4oG7kZ/V41F6SG
        Tft/xZ9Vy00ulz8UbotK+rxrO6IG/HpBHzAsLDiSGmd7OF5qPJtQZFPYc0l7adb3
        NL7zGGl4Jp6JK8lv0Z5aQwDqMZ/HcxMQwgY1GnKfScs+4E5+u41FpCXnn4S+3uz+
        1tdW7ElpYgK+8vPUTgmGAQIJXJcRgCWb3Oz++toLWUTu97ItYvSFgXI/+HrnTIli
        uHGbfEOJwwCM7xdWrXGp1J2s8ZtOFDgyx7qG00FabS/Do4DNMjPe7+KI+VqFCrsA
        ==
X-ME-Sender: <xms:wH27X6aqtZgDDsnbRpznXHay9VwR5_zDK86Mm55IpA4cadYKJMJzCQ>
    <xme:wH27X9boqMmyQCfbxa1sRKLOiaqf5y6w8rY20LuV1eItNnSjwSmNkTFDLxQ0hZl0A
    IOSnszu0CWpuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:wH27X0-_w85VWlSdcWWgeaxc4GJbEd-kQldUpzkECH1YH360gQ5MsQ>
    <xmx:wH27X8ra8Ap_uhI-LqZkGGGyrqPiLpBok_63jskikHGlu8lh9SPK_A>
    <xmx:wH27X1pomieZCXRa232UoXgcNJN09fVbNcMNy7EmMf4eKRmctLwa3A>
    <xmx:wH27X81mhLkILazrGYTH3cBA-4nQ4GN2zs4-VnjPwORMwNZCBrS-3ABPzdo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 338E63280064;
        Mon, 23 Nov 2020 04:15:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] spi: bcm-qspi: Fix use-after-free on unbind" failed to apply to 4.14-stable tree
To:     lukas@wunner.de, broonie@kernel.org, f.fainelli@gmail.com,
        kdasu.kdev@gmail.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 10:16:49 +0100
Message-ID: <1606123009170180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 63c5395bb7a9777a33f0e7b5906f2c0170a23692 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Wed, 11 Nov 2020 20:07:40 +0100
Subject: [PATCH] spi: bcm-qspi: Fix use-after-free on unbind

bcm_qspi_remove() calls spi_unregister_master() even though
bcm_qspi_probe() calls devm_spi_register_master().  The spi_master is
therefore unregistered and freed twice on unbind.

Moreover, since commit 0392727c261b ("spi: bcm-qspi: Handle clock probe
deferral"), bcm_qspi_probe() leaks the spi_master allocation if the call
to devm_clk_get_optional() fails.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound and also
avoids the spi_master leak on probe.

While at it, fix an ordering issue in bcm_qspi_remove() wherein
spi_unregister_master() is called after uninitializing the hardware,
disabling the clock and freeing an IRQ data structure.  The correct
order is to call spi_unregister_master() *before* those teardown steps
because bus accesses may still be ongoing until that function returns.

Fixes: fa236a7ef240 ("spi: bcm-qspi: Add Broadcom MSPI driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.9+: 123456789abc: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.9+
Cc: Kamal Dasu <kdasu.kdev@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/5e31a9a59fd1c0d0b795b2fe219f25e5ee855f9d.1605121038.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index 14c9d0133bce..c028446c7460 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1327,7 +1327,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 
 	data = of_id->data;
 
-	master = spi_alloc_master(dev, sizeof(struct bcm_qspi));
+	master = devm_spi_alloc_master(dev, sizeof(struct bcm_qspi));
 	if (!master) {
 		dev_err(dev, "error allocating spi_master\n");
 		return -ENOMEM;
@@ -1367,21 +1367,17 @@ int bcm_qspi_probe(struct platform_device *pdev,
 
 	if (res) {
 		qspi->base[MSPI]  = devm_ioremap_resource(dev, res);
-		if (IS_ERR(qspi->base[MSPI])) {
-			ret = PTR_ERR(qspi->base[MSPI]);
-			goto qspi_resource_err;
-		}
+		if (IS_ERR(qspi->base[MSPI]))
+			return PTR_ERR(qspi->base[MSPI]);
 	} else {
-		goto qspi_resource_err;
+		return 0;
 	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "bspi");
 	if (res) {
 		qspi->base[BSPI]  = devm_ioremap_resource(dev, res);
-		if (IS_ERR(qspi->base[BSPI])) {
-			ret = PTR_ERR(qspi->base[BSPI]);
-			goto qspi_resource_err;
-		}
+		if (IS_ERR(qspi->base[BSPI]))
+			return PTR_ERR(qspi->base[BSPI]);
 		qspi->bspi_mode = true;
 	} else {
 		qspi->bspi_mode = false;
@@ -1392,18 +1388,14 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cs_reg");
 	if (res) {
 		qspi->base[CHIP_SELECT]  = devm_ioremap_resource(dev, res);
-		if (IS_ERR(qspi->base[CHIP_SELECT])) {
-			ret = PTR_ERR(qspi->base[CHIP_SELECT]);
-			goto qspi_resource_err;
-		}
+		if (IS_ERR(qspi->base[CHIP_SELECT]))
+			return PTR_ERR(qspi->base[CHIP_SELECT]);
 	}
 
 	qspi->dev_ids = kcalloc(num_irqs, sizeof(struct bcm_qspi_dev_id),
 				GFP_KERNEL);
-	if (!qspi->dev_ids) {
-		ret = -ENOMEM;
-		goto qspi_resource_err;
-	}
+	if (!qspi->dev_ids)
+		return -ENOMEM;
 
 	for (val = 0; val < num_irqs; val++) {
 		irq = -1;
@@ -1484,7 +1476,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	qspi->xfer_mode.addrlen = -1;
 	qspi->xfer_mode.hp = -1;
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret < 0) {
 		dev_err(dev, "can't register master\n");
 		goto qspi_reg_err;
@@ -1497,8 +1489,6 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	clk_disable_unprepare(qspi->clk);
 qspi_probe_err:
 	kfree(qspi->dev_ids);
-qspi_resource_err:
-	spi_master_put(master);
 	return ret;
 }
 /* probe function to be called by SoC specific platform driver probe */
@@ -1508,10 +1498,10 @@ int bcm_qspi_remove(struct platform_device *pdev)
 {
 	struct bcm_qspi *qspi = platform_get_drvdata(pdev);
 
+	spi_unregister_master(qspi->master);
 	bcm_qspi_hw_uninit(qspi);
 	clk_disable_unprepare(qspi->clk);
 	kfree(qspi->dev_ids);
-	spi_unregister_master(qspi->master);
 
 	return 0;
 }

