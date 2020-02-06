Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE032154C30
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgBFTZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:25:02 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55827 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727738AbgBFTZC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 14:25:02 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 12E982207D;
        Thu,  6 Feb 2020 14:25:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 06 Feb 2020 14:25:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fhZJPM
        HXjwrBXl/lvzXoRpR/vHMC4XfFbg+Ec52n9bI=; b=TCnW1F7nqkOyeyuqM8Cdh0
        0+c2oJVmd+NwmwfiWYWytonzbyQfe7LjV+sXqWxOUe9Y5GWHBSL88Dtlw4auTKtQ
        6WCisVvymHBCfMr8P70FuM7xFFUxcI51UYmOGuranW2qLIdMK4mm0j083Owu0uLa
        qQl1xC/12jdJArUzzJIC0hV0rRlVAjzDv59Ys8wwILS7c20hmeONDeM7w7Z1wxHx
        VuZQTBD88YY+d6q4PXkelASFjA2QK1WEJUV85pbDVssHKmrHG3fkXY36RMKdys7t
        sIFU4dxmH6C0FZIFAqk+wD5s3qBfrannPQFLPMJdopX4XZMaRCH/DY2DnE4jsA/g
        ==
X-ME-Sender: <xms:DGg8XleHflzYDQwOtgjzkzwMdcONaEk5klxoeM-AR9H2qBlVhdDa8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheefgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:DGg8Xv_zEORoe6GNZqj7A2QdB-LoPyJ5F2_ABtgBKbx-W6CEugVVTw>
    <xmx:DGg8XuHHpC_3PbGiXKIABvUmVQGBaMc0cxcPU6VREZz37DAjbfaOmw>
    <xmx:DGg8XnmbjYkk-A2NQ_WYjMAZdkyUP5sJF05tx65SZv5dZdCBse6ZTQ>
    <xmx:DWg8XoVxQrz_2NBzgvKMyEF7LAFavKPDsE9epcU9NYIyf8QTWEgUSQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A69493060986;
        Thu,  6 Feb 2020 14:25:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: sdhci-of-at91: fix memleak on clk_get failure" failed to apply to 4.4-stable tree
To:     mirq-linux@rere.qmqm.pl, adrian.hunter@intel.com,
        ludovic.desroches@microchip.com, stable@vger.kernel.org,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 06 Feb 2020 20:08:49 +0100
Message-ID: <158101612915633@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

