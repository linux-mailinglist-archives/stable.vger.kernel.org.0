Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BF22C2DBA
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 18:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390187AbgKXREc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 12:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389441AbgKXREc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 12:04:32 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03B4C0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 09:04:31 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id a3so3609596wmb.5
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 09:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=T3werqyYROiBxakBAIbfsIQjyQh1ylr2TyWANBTGhRo=;
        b=HtqdtcT9/RvgiLxo/3LL7yl4poTDmwVP1RTWk8fmpqow3aIrFhGsS4a0HBiRnEpQXj
         TlWY0KaLWBzTmhJ+ZlvLzTmmpQ0vxnYegwIJEIN1SMbZMslx7dyGxwBSs7xetWhwTTR6
         zPCucoWbiHHnG6MXrgeOP90dSUuIJW/Yc8yAhnnmXNwZQTKNqdsZcDoAOsqwUK1yFniO
         vWqUrAVzBt0gWhlHSjbQacQIhV/+SprmP0r1mTKQIrzWM8Pcw4YrbCTJhgjNKyBWXcpy
         kgrScHYYUCs0wDsRA4qmqusoesbi/f3dMc4PvzP1iFhaw92eGhbuU3dzZjrakjZ/LgCJ
         NLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T3werqyYROiBxakBAIbfsIQjyQh1ylr2TyWANBTGhRo=;
        b=fxQSjbOWxfTzC9VkAlYtNeY4psH40QxHXXIwWcVX6oF1/aFG6PGBqr4kC17IWNU57b
         geIAgnld224G4eoBlGWAljfo7gUDlxEH7CFI5TnTD9LLWNOY/b5f1z3XE9ukCTIHuREy
         cK10Ufze6SZUQWOK4U9n3C6pM8L6C8xwfMX4L4Iy8i968RWPlvWQhZP3JGk+55FYTI5g
         XDYUQnGpXZx44AVmvlXDFw4hH/EmKD0aiXumqPPfkFT+YeWocTbC+9biLyclG2sBi5Z4
         AAwu9O2HpAPkhL8lg2XNN9A5RpiHtG9cOW81SbNw8cx0lUGVklg4Eb2ZMvztJN+rPMsT
         XdXw==
X-Gm-Message-State: AOAM533KELnuxr2vuM1kn/HKL8/7EUW3HcdYqOEOLWp99iRa4UCoPDuU
        d9QGREFIhufBc8WGZ9/X6L4=
X-Google-Smtp-Source: ABdhPJx9PlWpNSCTztFqo0PxH+909JDNf2m7s8Rqd7ZvHagpx7KZ5eMFqYDelwWdkAliUydxaMYWkQ==
X-Received: by 2002:a1c:61c2:: with SMTP id v185mr5530850wmb.152.1606237470623;
        Tue, 24 Nov 2020 09:04:30 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id q66sm7012132wme.6.2020.11.24.09.04.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Nov 2020 09:04:30 -0800 (PST)
Date:   Tue, 24 Nov 2020 17:04:28 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     lukas@wunner.de, broonie@kernel.org, f.fainelli@gmail.com,
        olteanv@gmail.com, s.hauer@pengutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: bcm2835: Fix use-after-free on
 unbind" failed to apply to 5.4-stable tree
Message-ID: <20201124170428.vfs6ffqraer7aumc@debian>
References: <1606121664109241@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fdsiczltkep76wao"
Content-Disposition: inline
In-Reply-To: <1606121664109241@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fdsiczltkep76wao
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Nov 23, 2020 at 09:54:24AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--fdsiczltkep76wao
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-spi-bcm2835-Fix-use-after-free-on-unbind.patch"

From b027b4de22e3030bb824b40e9cc934c248db9da0 Mon Sep 17 00:00:00 2001
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
[sudip: dev_err_probe() not yet available]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/spi/spi-bcm2835.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 9ae1c96f4d3d..5bc97b22491c 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1264,7 +1264,7 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 	struct bcm2835_spi *bs;
 	int err;
 
-	ctlr = spi_alloc_master(&pdev->dev, ALIGN(sizeof(*bs),
+	ctlr = devm_spi_alloc_master(&pdev->dev, ALIGN(sizeof(*bs),
 						  dma_get_cache_alignment()));
 	if (!ctlr)
 		return -ENOMEM;
@@ -1284,23 +1284,19 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 	bs = spi_controller_get_devdata(ctlr);
 
 	bs->regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(bs->regs)) {
-		err = PTR_ERR(bs->regs);
-		goto out_controller_put;
-	}
+	if (IS_ERR(bs->regs))
+		return PTR_ERR(bs->regs);
 
 	bs->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(bs->clk)) {
 		err = PTR_ERR(bs->clk);
 		dev_err(&pdev->dev, "could not get clk: %d\n", err);
-		goto out_controller_put;
+		return err;
 	}
 
 	bs->irq = platform_get_irq(pdev, 0);
-	if (bs->irq <= 0) {
-		err = bs->irq ? bs->irq : -ENODEV;
-		goto out_controller_put;
-	}
+	if (bs->irq <= 0)
+		return bs->irq ? bs->irq : -ENODEV;
 
 	clk_prepare_enable(bs->clk);
 
@@ -1330,8 +1326,6 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 
 out_clk_disable:
 	clk_disable_unprepare(bs->clk);
-out_controller_put:
-	spi_controller_put(ctlr);
 	return err;
 }
 
-- 
2.11.0


--fdsiczltkep76wao--
