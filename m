Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83CA4154C2C
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgBFTY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:24:56 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40259 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727738AbgBFTY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 14:24:56 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D9CAF21DC6;
        Thu,  6 Feb 2020 14:24:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 06 Feb 2020 14:24:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cdWQfi
        EWkOhqG34Pe2UjuOn/JXbsGlwVNiK/koFPwKI=; b=EfP2SruWj63BmC+PZeW13E
        BAsTx6JUVLcgDRw7jP/uTOxMeTQXDimPQ/nJ+UYyVegwWxgcHHxS4RuARvwyITsU
        gyyTiGbioiWJGNtybhT/UI58wQ3gp4APMaDDxfBjDlo5bExTTQ9e1ciFIVOsLfGC
        J7ghJ6YP4Q5IK80bydDXpDNVXAkXqrBpBl17zvyh2G7Ka0RL/V4qZEQRGWkf+T4v
        fSdrYVC7cqlWeiDLGlNwnf3jL+JW7FRkcG+0Z22oHxeeH0VrG+jMRxC+zk+MW8Qy
        ct+x5VJ6fyYs0FPZC6GjAnoPQkcdhNeGGUCd02kqoxMgjK0d4dqd46aMYJU8r5uw
        ==
X-ME-Sender: <xms:B2g8XoKbPdWYrW7hDUCJTdi-Lz8M5CXcp6S4U4Zug_SToU1W7r82ig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheefgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:B2g8Xsb37t06jJxylAcX3qYytSjb45jNOpGZunFwMGmiGRPBBBjPpw>
    <xmx:B2g8XjtQjhF6w4aZPSRjK8VqP0mHlVeg1yeF1L4N_UBuej91_m1W0g>
    <xmx:B2g8Xps0EIXmzDDbropOlgfWhaqJ2C-MmD_SZtuBiwYItSZFDc749Q>
    <xmx:B2g8XvoGp3Qv_-BiaXIS1yD6IhTTqscgxkWwvPQen_xM4ze1qH5sIQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1AEE1328005A;
        Thu,  6 Feb 2020 14:24:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: sdhci-of-at91: fix memleak on clk_get failure" failed to apply to 5.4-stable tree
To:     mirq-linux@rere.qmqm.pl, adrian.hunter@intel.com,
        ludovic.desroches@microchip.com, stable@vger.kernel.org,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 06 Feb 2020 20:08:47 +0100
Message-ID: <1581016127238229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From a04184ce777b46e92c2b3c93c6dcb2754cb005e1 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Date: Thu, 2 Jan 2020 11:42:16 +0100
Subject: [PATCH] mmc: sdhci-of-at91: fix memleak on clk_get failure
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

sdhci_alloc_host() does its work not using managed infrastructure, so
needs explicit free on error path. Add it where needed.

Cc: <stable@vger.kernel.org>
Fixes: bb5f8ea4d514 ("mmc: sdhci-of-at91: introduce driver for the Atmel SDMMC")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/b2a44d5be2e06ff075f32477e466598bb0f07b36.1577961679.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-of-at91.c b/drivers/mmc/host/sdhci-of-at91.c
index b2a8c45c9c23..ab2bd314a390 100644
--- a/drivers/mmc/host/sdhci-of-at91.c
+++ b/drivers/mmc/host/sdhci-of-at91.c
@@ -345,20 +345,23 @@ static int sdhci_at91_probe(struct platform_device *pdev)
 			priv->mainck = NULL;
 		} else {
 			dev_err(&pdev->dev, "failed to get baseclk\n");
-			return PTR_ERR(priv->mainck);
+			ret = PTR_ERR(priv->mainck);
+			goto sdhci_pltfm_free;
 		}
 	}
 
 	priv->hclock = devm_clk_get(&pdev->dev, "hclock");
 	if (IS_ERR(priv->hclock)) {
 		dev_err(&pdev->dev, "failed to get hclock\n");
-		return PTR_ERR(priv->hclock);
+		ret = PTR_ERR(priv->hclock);
+		goto sdhci_pltfm_free;
 	}
 
 	priv->gck = devm_clk_get(&pdev->dev, "multclk");
 	if (IS_ERR(priv->gck)) {
 		dev_err(&pdev->dev, "failed to get multclk\n");
-		return PTR_ERR(priv->gck);
+		ret = PTR_ERR(priv->gck);
+		goto sdhci_pltfm_free;
 	}
 
 	ret = sdhci_at91_set_clks_presets(&pdev->dev);

