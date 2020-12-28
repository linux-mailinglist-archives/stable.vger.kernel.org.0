Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981332E360C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 11:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgL1Ktc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 05:49:32 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:42495 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbgL1Ktc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 05:49:32 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id A13267AE;
        Mon, 28 Dec 2020 05:48:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 05:48:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=38vmtU
        z58PpKuZw6rEqgvTe+YSBjXM9GPMBAYwpOfG4=; b=V8lLQMRRgyfJteODGsyYS7
        WIT2/m5MZxvDvcmZ9l0YIjGPb162d5NytNUK3QHTGd69GNfG+zPPuscMhz/q8fOT
        FVh+FC9dQPtx3PdVWhT61ZYHB8rlDcN4ugJxIcHg8umdvs9OkBLTK0z0EEYiJyDZ
        LKTXWAXWAyfiUKZqQegnegHmbbvpAhYLbxj4GKfU+8mSbqeV1vWSjP1xDzXf0yA7
        h0X64bb5RmRozlnbH5++qTXIX4chh5BATxLjFcEJD5ZWPJt2++0fpuU2VCl1PJrr
        hvt4w9DMLGH8DYdXd7+uQx6ZOh8JDTYsMx8TKMMj+j2kaGRJV+EeHxvaFtWqknlQ
        ==
X-ME-Sender: <xms:-rfpX0zyXl2UqV8s6eB3uqJHpIl5flUF2C8i5fTFRViYEVS_topZ-A>
    <xme:-rfpX4SOI52xwLe201dpplbXWcJs3uAUE09NLCdjuzu4DVxLhgE9UwxDfpVF9aQ5Y
    nyEFnM1sdHl7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-rfpX2WePqsy_HzpVMSThLn_IMDKWJ68-pHKxWI4n5cHc3YRhktBrw>
    <xmx:-rfpXyib9wurqnX125hBG0HEdhwKXlv3VkyZB1XWc4DGxmM-odHh1w>
    <xmx:-rfpX2DE9oJJHPGAVLnUrF4oLTrnrBNjSulg5NQj_mBMzgr0ipoQaw>
    <xmx:-rfpXxpDWb92RuYJBrdXTRT4HSNqNkIEZywrMem7gITBhUmb4bOIuGMBU4k>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BBDE424005C;
        Mon, 28 Dec 2020 05:48:25 -0500 (EST)
Subject: FAILED: patch "[PATCH] spi: pxa2xx: Fix use-after-free on unbind" failed to apply to 4.14-stable tree
To:     lukas@wunner.de, broonie@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 11:49:38 +0100
Message-ID: <160915257822973@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

