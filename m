Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074EA2E3609
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 11:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgL1KtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 05:49:25 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:50709 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbgL1KtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 05:49:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 874E87F2;
        Mon, 28 Dec 2020 05:48:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 05:48:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LAsePG
        SNDBnwiWAcqklwku/WBirBZ8sfBv4/croCrUg=; b=hVTp38Fg1D9gUwpduqdCHo
        B1L4qFU9tAYfwRfZB1YVZqyumw1ZxXfl5DLmx6WMX01BDZFOVb2vI+u9eI5He4bi
        hTjzosOaAOT5Xhh2cEgbCzmJqt9g73sXpJNRm/oqK7nWU+x8AJk7HDL2uOHAQtG3
        tga5fJHxAk3GMBl6U1A9+zvzuJ1u0neGSxbIIMA5YkMLWW4smmMPqVbdLwRXXTRJ
        9VjHax5262euEW93m3NPqvdEoDmhJ34jEUgwK0gxFec7EHq+v2YbOfkarDbQAqDf
        RN3Vt3U7L/hdAnhgb1V+RYd3u+BVxd7b/j040RBJLUJXKExmUBUkm1QU1WjeyIzw
        ==
X-ME-Sender: <xms:BrjpX79haDOkZJcg35dI3Nuoxko9VgZhTJ2EnuBrdfeN8hM2x_MAuw>
    <xme:BrjpX3tUTbHUCkxhKfdIMo4T6x61f51x1D7Y6b6fkW5zbGmhF4GLrOEjBEyJcF_yE
    Fj3dhhgQK1bGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:BrjpX5DSl3q1pRVKi1ynJEe224dx10ZfIiFUEEUamN79jKMhxI_8LA>
    <xmx:BrjpX3dzddsT1m0tO1DOvbS_Lf8FT_xOe6_s_j8RobGFWPvkiYLxvg>
    <xmx:BrjpXwPYttavNS2doec6I0e0wPElMzsPW7KRQ5uvipsEj0I4TA-KEQ>
    <xmx:B7jpX63WZPHaRo9RHv8Fc2BYIXpVZv286M1aqrO0ewD0bzV_GMUIrEaOV38>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A300E1080064;
        Mon, 28 Dec 2020 05:48:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] spi: spi-sh: Fix use-after-free on unbind" failed to apply to 4.4-stable tree
To:     lukas@wunner.de, axel.lin@ingics.com, broonie@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 11:50:02 +0100
Message-ID: <1609152602115140@kroah.com>
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

From e77df3eca12be4b17f13cf9f215cff248c57d98f Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 7 Dec 2020 09:17:04 +0100
Subject: [PATCH] spi: spi-sh: Fix use-after-free on unbind

spi_sh_remove() accesses the driver's private data after calling
spi_unregister_master() even though that function releases the last
reference on the spi_master and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound.

Fixes: 680c1305e259 ("spi/spi_sh: use spi_unregister_master instead of spi_master_put in remove path")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v3.0+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v3.0+
Cc: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/6d97628b536baf01d5e3e39db61108f84d44c8b2.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-sh.c b/drivers/spi/spi-sh.c
index 20bdae5fdf3b..15123a8f41e1 100644
--- a/drivers/spi/spi-sh.c
+++ b/drivers/spi/spi-sh.c
@@ -440,7 +440,7 @@ static int spi_sh_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(struct spi_sh_data));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(struct spi_sh_data));
 	if (master == NULL) {
 		dev_err(&pdev->dev, "spi_alloc_master error.\n");
 		return -ENOMEM;
@@ -458,16 +458,14 @@ static int spi_sh_probe(struct platform_device *pdev)
 		break;
 	default:
 		dev_err(&pdev->dev, "No support width\n");
-		ret = -ENODEV;
-		goto error1;
+		return -ENODEV;
 	}
 	ss->irq = irq;
 	ss->master = master;
 	ss->addr = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (ss->addr == NULL) {
 		dev_err(&pdev->dev, "ioremap error.\n");
-		ret = -ENOMEM;
-		goto error1;
+		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&ss->queue);
 	spin_lock_init(&ss->lock);
@@ -477,7 +475,7 @@ static int spi_sh_probe(struct platform_device *pdev)
 	ret = request_irq(irq, spi_sh_irq, 0, "spi_sh", ss);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "request_irq error\n");
-		goto error1;
+		return ret;
 	}
 
 	master->num_chipselect = 2;
@@ -496,9 +494,6 @@ static int spi_sh_probe(struct platform_device *pdev)
 
  error3:
 	free_irq(irq, ss);
- error1:
-	spi_master_put(master);
-
 	return ret;
 }
 

