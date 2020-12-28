Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736B32E3607
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 11:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgL1KtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 05:49:10 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:52589 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727085AbgL1KtK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 05:49:10 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 96DDA7DC;
        Mon, 28 Dec 2020 05:48:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 05:48:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=YDotkl
        /mwctdWeO8q0w/tQj4ngwsDCiin/e8jIm11Ww=; b=bQhI3/lvSb8TdoDvtwvYxa
        57Qipot9xiUn1SAXwAtrDInxGr2oW/h9MNNpFa0gdEJDUNSmW5kPF67hK0cEVG9L
        cg2ct1VhG8hJPtw4sHA6TfceDuoA1pqi/IRyb0wjqYxpbH7H+BxVmUE1Ek6tLRnO
        CbgmVmjMnpziJ40r2S4aUcknXfZJ4TeS0hQbA5il4mpt+j3Wpwj7jDaDyRoLhQ/V
        HC4MVsAoDf1REm64FHu9NXETKgLzC/OaVsJnN2B03TyK+W2LVBGFNwgi+cqDgypd
        HoMbyi4Pw4DE9P2tWxUuWnkWqczMCyUp2x/gMSLc9e2SxGa9Wk7Z5AJft4Os79+w
        ==
X-ME-Sender: <xms:-LfpX3WnC-6a0u_SKnj8Av9X2uyuNcMpzOVKvAoCzWemu3e99Echmg>
    <xme:-LfpX_mGO_EDntQZOpabUFIhK24ePM_v7UI-C69P6j8yp5TcBHdKtXe1AymmAtQum
    3SqWCEAd9LHeQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-LfpXzaGiITCf8FCmoczttgAWSvziLl3ErpJ0N54QmhlIkly4z8QyQ>
    <xmx:-LfpXyUVYekVjpihyBO2rPNiv0SpeeB1tShckp8p8OulR5o4pAEDcA>
    <xmx:-LfpXxkDtWdNLDwFvzWyDzAmJZvkVobzZzuTWDQZxgYKLJbysUbzYg>
    <xmx:-LfpXwv0D_kHrTBfuRV1Am-doQXNHeBP3fYVmdh7KrmN-EARZmaQMDhu4Qo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B46B4108005B;
        Mon, 28 Dec 2020 05:48:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] spi: pxa2xx: Fix use-after-free on unbind" failed to apply to 4.19-stable tree
To:     lukas@wunner.de, broonie@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 11:49:38 +0100
Message-ID: <160915257890155@kroah.com>
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

From 5626308bb94d9f930aa5f7c77327df4c6daa7759 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 7 Dec 2020 09:17:05 +0100
Subject: [PATCH] spi: pxa2xx: Fix use-after-free on unbind

pxa2xx_spi_remove() accesses the driver's private data after calling
spi_unregister_controller() even though that function releases the last
reference on the spi_controller and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master/slave() helper
which keeps the private data accessible until the driver has unbound.

Fixes: 32e5b57232c0 ("spi: pxa2xx: Fix controller unregister order")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v2.6.17+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v2.6.17+: 32e5b57232c0: spi: pxa2xx: Fix controller unregister order
Cc: <stable@vger.kernel.org> # v2.6.17+
Link: https://lore.kernel.org/r/5764b04d4a6e43069ebb7808f64c2f774ac6f193.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 62a0f0f86553..bd2354fd438d 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1691,9 +1691,9 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	}
 
 	if (platform_info->is_slave)
-		controller = spi_alloc_slave(dev, sizeof(struct driver_data));
+		controller = devm_spi_alloc_slave(dev, sizeof(*drv_data));
 	else
-		controller = spi_alloc_master(dev, sizeof(struct driver_data));
+		controller = devm_spi_alloc_master(dev, sizeof(*drv_data));
 
 	if (!controller) {
 		dev_err(&pdev->dev, "cannot alloc spi_controller\n");
@@ -1916,7 +1916,6 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	free_irq(ssp->irq, drv_data);
 
 out_error_controller_alloc:
-	spi_controller_put(controller);
 	pxa_ssp_free(ssp);
 	return status;
 }

