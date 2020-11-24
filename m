Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAF92C286F
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 14:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388509AbgKXNla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 08:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388513AbgKXNl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 08:41:27 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F7AC0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 05:41:27 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id p19so2070938wmg.0
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 05:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=81TZJSTdAM9gkqTO2K64LE/DMg2bPi6fsqpPe+LZShw=;
        b=Yr3BXJlMiAcKfHiNHXoR2iLq9QlEVDEoscUIzVxR55HG2gk+31ZuWde1MIUqFMqU4S
         BxohZxsOrauPhkv2hVTLA2EntCsifFtnv6DTthlC4yooudnpCftP06GpMaOQ0PN3R7eh
         st6/5n+Hbp5iWePc2XiO9BiSkolAY+m5/jlbyXPpJ8hCL5uRfIRjqyE1JIGtdKmlxcnB
         d4kPRCWESE28TLwHLP0rSBuAjXEAGw7mB0YbeVa0UzmEVUK+c2SDdbK1IYba3aR6K6/E
         YYiknQxkRKa4HgJjUDgDRDlqgfwFesYrvaSU/xFQG8JnQDaw6DwpcKXJelghHLcAr2zv
         oNuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=81TZJSTdAM9gkqTO2K64LE/DMg2bPi6fsqpPe+LZShw=;
        b=RDJKBUw+XhOR/LXT4x+PPaGirn8HI3UqFUEE5joJYpjlqBdPnZ+25+ROfU2zxI2p24
         5nh70WznrYvhGC0rc39yCqw+M1D1hE5QIuSk2iD/9HeR8an9C4eGny/W7tNmJP+XaMQo
         DjG3zsDnNX/J3hnUCEjwG+Bq9lXtE0BQ70m1/VPTCka1/LBEAPeU8iEPrd3Ss2LAggra
         otWjnoIHwpPmFZk5SoAxokgoDXBdbHc6kdqxE7aXSYL1XAUlrIIQg3LajR+s0PcfL+eN
         8Oc1wCIApqjcY789As1Lhpdxp/PpzjIidV+NTScfivPy/cBcRa4BrUI7NtPmbn8KL4xC
         Q+WA==
X-Gm-Message-State: AOAM533rGRAzLzAzrV48pJ3v65T4ip46ndTlk3GIIyPcbmLeOvesADx1
        ust5wRCJJl65OFi59PtHYeg=
X-Google-Smtp-Source: ABdhPJw3/As87kd60XqeCubPYMKO3GWr8OGcp3Sf6A7K5H+EqBfvHX0ZPeI72oHeAuceSd+BHljtgQ==
X-Received: by 2002:a1c:c309:: with SMTP id t9mr4407122wmf.149.1606225285810;
        Tue, 24 Nov 2020 05:41:25 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id j71sm5583065wmj.10.2020.11.24.05.41.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Nov 2020 05:41:25 -0800 (PST)
Date:   Tue, 24 Nov 2020 13:41:23 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     lukas@wunner.de, broonie@kernel.org, f.fainelli@gmail.com,
        kdasu.kdev@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: bcm-qspi: Fix use-after-free on
 unbind" failed to apply to 5.4-stable tree
Message-ID: <20201124134123.ie5jvzygygayajo5@debian>
References: <160612300715987@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mgo4zsr2hmfayiln"
Content-Disposition: inline
In-Reply-To: <160612300715987@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mgo4zsr2hmfayiln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Nov 23, 2020 at 10:16:47AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport for all the stable tree from v4.9.y to v5.4.y.

--
Regards
Sudip

--mgo4zsr2hmfayiln
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-spi-bcm-qspi-Fix-use-after-free-on-unbind.patch"

From 230cfe3365d13ae6144c7fd0321a9f10fa9fc7f4 Mon Sep 17 00:00:00 2001
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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/spi/spi-bcm-qspi.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index d0afe0b1599f..8a4be34bccfd 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1213,7 +1213,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	if (!of_match_node(bcm_qspi_of_match, dev->of_node))
 		return -ENODEV;
 
-	master = spi_alloc_master(dev, sizeof(struct bcm_qspi));
+	master = devm_spi_alloc_master(dev, sizeof(struct bcm_qspi));
 	if (!master) {
 		dev_err(dev, "error allocating spi_master\n");
 		return -ENOMEM;
@@ -1252,21 +1252,17 @@ int bcm_qspi_probe(struct platform_device *pdev,
 
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
@@ -1277,18 +1273,14 @@ int bcm_qspi_probe(struct platform_device *pdev,
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
@@ -1357,7 +1349,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	qspi->xfer_mode.addrlen = -1;
 	qspi->xfer_mode.hp = -1;
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret < 0) {
 		dev_err(dev, "can't register master\n");
 		goto qspi_reg_err;
@@ -1370,8 +1362,6 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	clk_disable_unprepare(qspi->clk);
 qspi_probe_err:
 	kfree(qspi->dev_ids);
-qspi_resource_err:
-	spi_master_put(master);
 	return ret;
 }
 /* probe function to be called by SoC specific platform driver probe */
@@ -1381,10 +1371,10 @@ int bcm_qspi_remove(struct platform_device *pdev)
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


--mgo4zsr2hmfayiln--
