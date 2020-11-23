Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053D82C01B4
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 09:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgKWIwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 03:52:53 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:39537 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726776AbgKWIwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 03:52:53 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id A5969E46;
        Mon, 23 Nov 2020 03:52:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 03:52:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=j2fM7H
        aDZ5xA1jfjKwU4HCoVzWkw6E2D7CXZYRQnYoc=; b=rnDD+Y0J6Ja/WcP6KaRvkU
        V3klmFSfrSdQXdzY9Ij0IEceF+wN0f7/qhsD0bic+qiDXD1FaHmk/TBudOFKWCQb
        6CS3CU2c7BsNrKI1tGcRKb2G9ySWfYnn51DybxrLNe2XYsw08qbYfwtU0s0b2YAu
        5r4C2c8+ppTttBgm9HY+QwG5bBxERYHu9FpcrUkfmpXk/T5b7g0z4fozuH7MDoAa
        hVruL3GpPCFZJ/iYNERusR2dfxDN6gI+z9GwfEJ9LrDUE1VlUcJ6T/TxFIpQduaK
        ghbhFgVfFh41yKHuORwyY0dNNeSJego471itw0du8zpMotasDfYiibnzWhuT2N6w
        ==
X-ME-Sender: <xms:ZHi7XxROtmRKt6HfQZHLjGu7jq8vZ9OdudodMSfLY3fjIxhtvPYFzQ>
    <xme:ZHi7X6xSK0Y95Oe2nL_RwJd9ijX289TcHAelvfcLvmN_cWkXk6aMlQlKg_4bzCVHH
    y6h71bZuHjXPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ZHi7X20TqSIUFPpqerlOiZSERHF9Nsim3hZ5m4yyne-BDVpbwqtp0Q>
    <xmx:ZHi7X5Cf0FyqRu00HSBpMoPms8Ghm7aC7CwqSxUPhu8g4pdfkP-nag>
    <xmx:ZHi7X6gUMykCIRjKZw4HG0xn7tLthIfSwn2cVSeJjIo3uOXVh5UqPg>
    <xmx:ZHi7XyJR6iT4tl28X8eBKI1Xt71BQhPcjFw35tFRburJGbhUcvMgXf7Y7JY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E5D163064AAF;
        Mon, 23 Nov 2020 03:52:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] spi: bcm2835aux: Fix use-after-free on unbind" failed to apply to 4.4-stable tree
To:     lukas@wunner.de, broonie@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 09:54:02 +0100
Message-ID: <160612164211937@kroah.com>
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

From e13ee6cc4781edaf8c7321bee19217e3702ed481 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Wed, 11 Nov 2020 20:07:30 +0100
Subject: [PATCH] spi: bcm2835aux: Fix use-after-free on unbind

bcm2835aux_spi_remove() accesses the driver's private data after calling
spi_unregister_master() even though that function releases the last
reference on the spi_master and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound.

Fixes: b9dd3f6d4172 ("spi: bcm2835aux: Fix controller unregister order")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.4+: 123456789abc: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.4+: b9dd3f6d4172: spi: bcm2835aux: Fix controller unregister order
Cc: <stable@vger.kernel.org> # v4.4+
Link: https://lore.kernel.org/r/b290b06357d0c0bdee9cecc539b840a90630f101.1605121038.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-bcm2835aux.c b/drivers/spi/spi-bcm2835aux.c
index 03b034c15d2b..fd58547110e6 100644
--- a/drivers/spi/spi-bcm2835aux.c
+++ b/drivers/spi/spi-bcm2835aux.c
@@ -494,7 +494,7 @@ static int bcm2835aux_spi_probe(struct platform_device *pdev)
 	unsigned long clk_hz;
 	int err;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*bs));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*bs));
 	if (!master)
 		return -ENOMEM;
 
@@ -524,29 +524,24 @@ static int bcm2835aux_spi_probe(struct platform_device *pdev)
 
 	/* the main area */
 	bs->regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(bs->regs)) {
-		err = PTR_ERR(bs->regs);
-		goto out_master_put;
-	}
+	if (IS_ERR(bs->regs))
+		return PTR_ERR(bs->regs);
 
 	bs->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(bs->clk)) {
-		err = PTR_ERR(bs->clk);
 		dev_err(&pdev->dev, "could not get clk: %d\n", err);
-		goto out_master_put;
+		return PTR_ERR(bs->clk);
 	}
 
 	bs->irq = platform_get_irq(pdev, 0);
-	if (bs->irq <= 0) {
-		err = bs->irq ? bs->irq : -ENODEV;
-		goto out_master_put;
-	}
+	if (bs->irq <= 0)
+		return bs->irq ? bs->irq : -ENODEV;
 
 	/* this also enables the HW block */
 	err = clk_prepare_enable(bs->clk);
 	if (err) {
 		dev_err(&pdev->dev, "could not prepare clock: %d\n", err);
-		goto out_master_put;
+		return err;
 	}
 
 	/* just checking if the clock returns a sane value */
@@ -581,8 +576,6 @@ static int bcm2835aux_spi_probe(struct platform_device *pdev)
 
 out_clk_disable:
 	clk_disable_unprepare(bs->clk);
-out_master_put:
-	spi_master_put(master);
 	return err;
 }
 

