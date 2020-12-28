Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A77D2E3623
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgL1K7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 05:59:52 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:40645 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727019AbgL1K7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 05:59:51 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B4FB17DC;
        Mon, 28 Dec 2020 05:59:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 05:59:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SMZI1C
        Faw5KyA15etew9E2jBId62bezIDxdfpccVfE4=; b=LRmJyA0eUPU7B+aAFy/Ka+
        zteuQceI+MHGE17VabWAKHmzZt3MOtV296ECeNg5kw6sBOxDnUoggFWphyCYEb5P
        5k9hKBm5V15e8+Wf1heEaQ8PEOSKTP9BZuRiay2e4ubHSzjzLiUAt2jTh2KpiC6T
        H4Q6zZZqgzXSZmNdoAYlAPAULnMCxtMLCyaskYy487fftMf6V6uyHjY4fWnDdBkt
        NTINzyrEpf8kPjpG4MOanCbM3n4gMMeAbfYZoCj8SIql5HZqI7GirD+lV/9autKI
        z6TdjP/0IAH4ayH58BkhV93XNmHiK/WT7mGLQ9zRb6xhylslTzdL+H4UzSN0orVQ
        ==
X-ME-Sender: <xms:ebrpXzDUsByuNqyFFBsc1taKojGTrjJgYqNn0A6pNXcg6Mu6ifAOCw>
    <xme:ebrpX5iUI5rWIDvuw4_raVrl3XfAV6xrJX7JBjaxZYbT9jeZfRxi1O76ZdGhg7ISs
    _qjT9K2vPOQrA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ebrpX-ksJ1x9n20GbZA9uZkfgbUNrsWwP6MWU6vj-aNEAbxDnFqEeg>
    <xmx:ebrpX1zhtiieM7WVhSXOChCfYCZzBBD4sT-4tBcJDidltXemJgrf6Q>
    <xmx:ebrpX4Rgamn99G7whmU93OUqNakNm_1_P738nIYh5r7YKeQVwxNQKQ>
    <xmx:ebrpXzI8Lqd68ufAkm98Fygo2LaeN577Phw49t8ixWuoEzbgQKQSXxBxBFY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CF23E108005B;
        Mon, 28 Dec 2020 05:59:04 -0500 (EST)
Subject: FAILED: patch "[PATCH] spi: npcm-fiu: Disable clock in probe error path" failed to apply to 5.4-stable tree
To:     lukas@wunner.de, broonie@kernel.org, stable@vger.kernel.org,
        tmaimon77@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:00:27 +0100
Message-ID: <160915322711352@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 234266a5168bbe8220d263e3aa7aa80cf921c483 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 7 Dec 2020 09:17:16 +0100
Subject: [PATCH] spi: npcm-fiu: Disable clock in probe error path

If the call to devm_spi_register_master() fails on probe of the NPCM FIU
SPI driver, the clock "fiu->clk" is erroneously not unprepared and
disabled.  Fix it.

Fixes: ace55c411b11 ("spi: npcm-fiu: add NPCM FIU controller driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v5.4+
Cc: Tomer Maimon <tmaimon77@gmail.com>
Link: https://lore.kernel.org/r/9ae62f4e1cfe542bec57ac2743e6fca9f9548f55.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-npcm-fiu.c b/drivers/spi/spi-npcm-fiu.c
index 1cb9329de945..b62471ab6d7f 100644
--- a/drivers/spi/spi-npcm-fiu.c
+++ b/drivers/spi/spi-npcm-fiu.c
@@ -677,7 +677,7 @@ static int npcm_fiu_probe(struct platform_device *pdev)
 	struct npcm_fiu_spi *fiu;
 	void __iomem *regbase;
 	struct resource *res;
-	int id;
+	int id, ret;
 
 	ctrl = devm_spi_alloc_master(dev, sizeof(*fiu));
 	if (!ctrl)
@@ -735,7 +735,11 @@ static int npcm_fiu_probe(struct platform_device *pdev)
 	ctrl->num_chipselect = fiu->info->max_cs;
 	ctrl->dev.of_node = dev->of_node;
 
-	return devm_spi_register_master(dev, ctrl);
+	ret = devm_spi_register_master(dev, ctrl);
+	if (ret)
+		clk_disable_unprepare(fiu->clk);
+
+	return ret;
 }
 
 static int npcm_fiu_remove(struct platform_device *pdev)

