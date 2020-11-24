Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812422C2DB7
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 18:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgKXRCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 12:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgKXRCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 12:02:39 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A7EC0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 09:02:39 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id i2so4022946wrs.4
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 09:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3fBWaD7CKn0QJEnlsOJbzoMZLD9A1MS2ogF5fzkmq4c=;
        b=IYFKRfe9KnUqDV+luz86zTwmbAxnLVH/AXFu+LbERPH+k5pJu+8/ApT8v/+sTJQcH+
         GgHhvfYech+I3hnbWd6Thw8g22BJFmNB1GYWBeAVoCCWr6TXDADvTBSTJQMJD92NaUlG
         EonKZtrZJC/SVot1CKaB9Fdc/LmG8prW4WlRRo8nSrv4/+OZg5K1WNUKdPyGiOlNc2zN
         5GHnilckCW60AaJM5aDH+HnMBevHZC7FNgTPbZXnlVSxYPk/YsWaRxIhIuXm7g7+DeP6
         LQMPcv7htagh/VSZzCkrQO9LGh6R6MYN5GVFQev+psbqcHJrq4P3oTE6gnIGOTdSrSsB
         oaqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3fBWaD7CKn0QJEnlsOJbzoMZLD9A1MS2ogF5fzkmq4c=;
        b=oXSzWd6NYwFChQYdtkg0WlfHTRh8vjdFAcyjNaBuhCulS3j3FkaWifnFMXje1K5zwX
         XlrcPWh6VCTTOHuhZsQn+HoZ2p3BTSSdshZjn0XaoJmTvqlXpHzb4DhYmJgxCq5a3N+E
         RoaVrH1rsFU9vDD85BqFGZ+yB9ZXvDbKwujBt+HD2mrozm+RjO2d2Uct/xf50HV8Axq6
         FFukkeBPMpzKY4Di1XTNONzhOzFpPHVVlshJRCbIH7I08dlp+5179NFJvVs29zkWrtSY
         OwXir6+p7LF4mLn/lJYBviF2uTqjC6QIB4xbnjq3SOUOy8zwFfxYfnFrymlLPAWgPpre
         qKng==
X-Gm-Message-State: AOAM530UFlWXAkTtSN2FBuxsHSVwTov+CtAnfua2rScAjWqeycL7YA4V
        ExePG8gunkJXfB69gCnJtsg=
X-Google-Smtp-Source: ABdhPJwGK4+FhwYcxGibyJE5hv5/p6WlLREeZpQRR5AMdI7yIn3EuS0OHrC+TIQpn3fZaqO6T7lYWQ==
X-Received: by 2002:adf:aa4a:: with SMTP id q10mr1709222wrd.276.1606237357873;
        Tue, 24 Nov 2020 09:02:37 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id f5sm873036wmj.17.2020.11.24.09.02.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Nov 2020 09:02:37 -0800 (PST)
Date:   Tue, 24 Nov 2020 17:02:35 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     lukas@wunner.de, broonie@kernel.org, f.fainelli@gmail.com,
        olteanv@gmail.com, s.hauer@pengutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: bcm2835: Fix use-after-free on
 unbind" failed to apply to 5.9-stable tree
Message-ID: <20201124170235.gca5kbtncncr64dw@debian>
References: <1606121663128223@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nycsjpwyposek4kz"
Content-Disposition: inline
In-Reply-To: <1606121663128223@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nycsjpwyposek4kz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Nov 23, 2020 at 09:54:23AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--nycsjpwyposek4kz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-spi-bcm2835-Fix-use-after-free-on-unbind.patch"

From 357cbec3337f1ac35ccb87aaaddbb783b33c83b4 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Wed, 11 Nov 2020 20:07:20 +0100
Subject: [PATCH] spi: bcm2835: Fix use-after-free on unbind

commit e1483ac030fb4c57734289742f1c1d38dca61e22 upstream

bcm2835_spi_remove() accesses the driver's private data after calling
spi_unregister_controller() even though that function releases the last
reference on the spi_controller and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound.

Fixes: f8043872e796 ("spi: add driver for BCM2835")
Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v3.10+: 123456789abc: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v3.10+
Cc: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/ad66e0a0ad96feb848814842ecf5b6a4539ef35c.1605121038.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/spi/spi-bcm2835.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 9605abaaec67..197485f2c2b2 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1278,7 +1278,7 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 	struct bcm2835_spi *bs;
 	int err;
 
-	ctlr = spi_alloc_master(&pdev->dev, ALIGN(sizeof(*bs),
+	ctlr = devm_spi_alloc_master(&pdev->dev, ALIGN(sizeof(*bs),
 						  dma_get_cache_alignment()));
 	if (!ctlr)
 		return -ENOMEM;
@@ -1299,26 +1299,17 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 	bs->ctlr = ctlr;
 
 	bs->regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(bs->regs)) {
-		err = PTR_ERR(bs->regs);
-		goto out_controller_put;
-	}
+	if (IS_ERR(bs->regs))
+		return PTR_ERR(bs->regs);
 
 	bs->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(bs->clk)) {
-		err = PTR_ERR(bs->clk);
-		if (err == -EPROBE_DEFER)
-			dev_dbg(&pdev->dev, "could not get clk: %d\n", err);
-		else
-			dev_err(&pdev->dev, "could not get clk: %d\n", err);
-		goto out_controller_put;
-	}
+	if (IS_ERR(bs->clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(bs->clk),
+				     "could not get clk\n");
 
 	bs->irq = platform_get_irq(pdev, 0);
-	if (bs->irq <= 0) {
-		err = bs->irq ? bs->irq : -ENODEV;
-		goto out_controller_put;
-	}
+	if (bs->irq <= 0)
+		return bs->irq ? bs->irq : -ENODEV;
 
 	clk_prepare_enable(bs->clk);
 
@@ -1352,8 +1343,6 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 	bcm2835_dma_release(ctlr, bs);
 out_clk_disable:
 	clk_disable_unprepare(bs->clk);
-out_controller_put:
-	spi_controller_put(ctlr);
 	return err;
 }
 
-- 
2.11.0


--nycsjpwyposek4kz--
