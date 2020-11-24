Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AF72C2846
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 14:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388440AbgKXNjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 08:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387700AbgKXNja (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 08:39:30 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D6AC0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 05:39:29 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id t4so9411196wrr.12
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 05:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qZhUUFccOTs5aG9ztgyY+lwuZnuttuRn7WutbADwOvc=;
        b=Z9V65En9/Do+FWpM8BjigWFSnaeExIKooq+Epeix+NyfB7BBH9z6qHy1mP8O2xt8Wl
         mTuhxveXbRX4/32etvDJgD0BfGSm8XZ6x0GLt9ws0CS3FfOnYqd6VGP3pLSiZnG9e+Xs
         XDiTQAcT4UL+9hnqN0qjLKjTffDre85eQUdYJBfgPaMmoXqHAxrRWeg8GKntSwOX2K+E
         FSZPNwPb3U5Icr+mf7ZhSgh+7QX8e171Bj1JPtXmT2K0leOO6/TMWOrH+6pBd7WDPp7Q
         DpyHGnSYJaSARo6+VLvUHYQ+bZjhaQCipCbtn1+y1yrWGb3pmwHTV4No8X7+KzGXoUP2
         Ok5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qZhUUFccOTs5aG9ztgyY+lwuZnuttuRn7WutbADwOvc=;
        b=D0eTfGY7LS6c/xOm45baZGcpCOoCuBiOOaV3JanY8gpJ/G1kNIpeSvVIPwRHuai6kK
         bFY5+2Qbxfvx6eU/AvatWkTFk8HfqrHBE75/G5vPqaLoexNPd+oDUA+2hCTxywLzuYqH
         wBjHkQCXNAv11Fbm7+RVVvyeHRpRNejXsF6hlasL702ECrJLU0rcRbmlKiQtkJofACqO
         AJ5eouwFacCrSrf20dNvaB6ZDu9Al80zsI79/dyhArV+wbeWGWu11+VEf3mvTXcYKObD
         9Y11Q4JJJ2lrlGZaKrrF7fmDTE8EljVf9PwbldsBxJ/1Z4Scbp1dg7ULvI5NEkW1jp8b
         SL2Q==
X-Gm-Message-State: AOAM5319CF1JHVpOOUOvL8b/TZRTMfj7PIZjNV+HhL4mKN52HTaXm+sF
        6LkT1jltXJsO3zb0CZmGZCc=
X-Google-Smtp-Source: ABdhPJwt3HlRvZ4EjLya3npjvUx/hNo6jehZVH4bYxZsGxAvCFcI5BoeFlII7sGEtnrHagLRgqn6Kw==
X-Received: by 2002:adf:b193:: with SMTP id q19mr5409864wra.426.1606225168197;
        Tue, 24 Nov 2020 05:39:28 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id g186sm5918791wmf.2.2020.11.24.05.39.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Nov 2020 05:39:27 -0800 (PST)
Date:   Tue, 24 Nov 2020 13:39:25 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     lukas@wunner.de, broonie@kernel.org, f.fainelli@gmail.com,
        kdasu.kdev@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: bcm-qspi: Fix use-after-free on
 unbind" failed to apply to 5.9-stable tree
Message-ID: <20201124133925.uqdwws2m4mna4c2v@debian>
References: <160612300624254@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y5qp3vme5gkp2oqi"
Content-Disposition: inline
In-Reply-To: <160612300624254@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--y5qp3vme5gkp2oqi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Nov 23, 2020 at 10:16:46AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport for 5.9-stable.

--
Regards
Sudip

--y5qp3vme5gkp2oqi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-spi-bcm-qspi-Fix-use-after-free-on-unbind.patch"

From ad8021558a1dc4db2b4eb58db9f7bafbc61e69db Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Wed, 11 Nov 2020 20:07:40 +0100
Subject: [PATCH] spi: bcm-qspi: Fix use-after-free on unbind

commit 63c5395bb7a9777a33f0e7b5906f2c0170a23692 upstream

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
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/spi/spi-bcm-qspi.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index 9cfa15ec8b08..5743e727b5f7 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1334,7 +1334,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 
 	data = of_id->data;
 
-	master = spi_alloc_master(dev, sizeof(struct bcm_qspi));
+	master = devm_spi_alloc_master(dev, sizeof(struct bcm_qspi));
 	if (!master) {
 		dev_err(dev, "error allocating spi_master\n");
 		return -ENOMEM;
@@ -1374,21 +1374,17 @@ int bcm_qspi_probe(struct platform_device *pdev,
 
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
@@ -1399,18 +1395,14 @@ int bcm_qspi_probe(struct platform_device *pdev,
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
@@ -1491,7 +1483,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	qspi->xfer_mode.addrlen = -1;
 	qspi->xfer_mode.hp = -1;
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret < 0) {
 		dev_err(dev, "can't register master\n");
 		goto qspi_reg_err;
@@ -1504,8 +1496,6 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	clk_disable_unprepare(qspi->clk);
 qspi_probe_err:
 	kfree(qspi->dev_ids);
-qspi_resource_err:
-	spi_master_put(master);
 	return ret;
 }
 /* probe function to be called by SoC specific platform driver probe */
@@ -1515,10 +1505,10 @@ int bcm_qspi_remove(struct platform_device *pdev)
 {
 	struct bcm_qspi *qspi = platform_get_drvdata(pdev);
 
+	spi_unregister_master(qspi->master);
 	bcm_qspi_hw_uninit(qspi);
 	clk_disable_unprepare(qspi->clk);
 	kfree(qspi->dev_ids);
-	spi_unregister_master(qspi->master);
 
 	return 0;
 }
-- 
2.11.0


--y5qp3vme5gkp2oqi--
