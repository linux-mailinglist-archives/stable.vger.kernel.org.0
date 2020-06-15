Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7201F9BE4
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgFOPWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:22:15 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:39281 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728326AbgFOPWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:22:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 9C8C671B;
        Mon, 15 Jun 2020 11:22:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:22:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=wW7dzl
        bTdyXEVVZN/3DAFL6diZx6iRvoczyeyff7wvs=; b=lAnVao95cQ8Rztkif88u9U
        86mOS9PaAWoQgM8C1n9jzldqe+Ud87c7+sd680i88jYe1knUcO6TmZh5G62JFyLu
        4mu3s7SdaB5w01jBupaWHW7TmVR6Jy45jq8+CyEU1k9u4ABK7mXQZEJg5ykMbjsP
        mjjYzuPXgFVP9hn/1lNIgXVutMKkR7QOR2cehkz3bA4U9TxlWR63tPNgq2P3eoRp
        jHBiicKr0RtRnAuD+G7E0UQcuKunFw29oFrN6xLT828DoMCPn34qq6q9+V2W8W40
        zJpMg1m6sgtI1QH6POFf/CQBh2cHoIWz67/0KRbCYYh5VLG+bHa4becXzQOA9axQ
        ==
X-ME-Sender: <xms:JpLnXtWO4Apxq2a2k-xC4aimN8UHT6h43Jdz2DArCn-s1jwqGN7_0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepuddvnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:JpLnXtlKQgzqgXbNhkcTIb3wCsBnpB1SdGzvhuYMeHU2XVBlqroFyA>
    <xmx:JpLnXpYs5ez0k4uuhpIocRfHHpnRw58S1XClJZPrbhRo9Cu5UYdgLQ>
    <xmx:JpLnXgUszjYWen-Pu1ecUAKa8CqusH66QQTJ1R8ETcJPxxtGUdr-2w>
    <xmx:JpLnXtSfKckNWAJwIrZ6xsJCXDYhmnHELbzNGI4iaRFJIr-bY4sWpR-wuK8>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D1638328006B;
        Mon, 15 Jun 2020 11:22:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: bcm2835: Fix controller unregister order" failed to apply to 4.4-stable tree
To:     lukas@wunner.de, broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:22:01 +0200
Message-ID: <159223452111158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 9dd277ff92d06f6aa95b39936ad83981d781f49b Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Fri, 15 May 2020 17:58:02 +0200
Subject: [PATCH] spi: bcm2835: Fix controller unregister order

The BCM2835 SPI driver uses devm_spi_register_controller() on bind.
As a consequence, on unbind, __device_release_driver() first invokes
bcm2835_spi_remove() before unregistering the SPI controller via
devres_release_all().

This order is incorrect:  bcm2835_spi_remove() tears down the DMA
channels and turns off the SPI controller, including its interrupts
and clock.  The SPI controller is thus no longer usable.

When the SPI controller is subsequently unregistered, it unbinds all
its slave devices.  If their drivers need to access the SPI bus,
e.g. to quiesce their interrupts, unbinding will fail.

As a rule, devm_spi_register_controller() must not be used if the
->remove() hook performs teardown steps which shall be performed
after unbinding of slaves.

Fix by using the non-devm variant spi_register_controller().  Note that
the struct spi_controller as well as the driver-private data are not
freed until after bcm2835_spi_remove() has finished, so accessing them
is safe.

Fixes: 247263dba208 ("spi: bcm2835: use devm_spi_register_master()")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v3.13+
Link: https://lore.kernel.org/r/2397dd70cdbe95e0bc4da2b9fca0f31cb94e5aed.1589557526.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 11c235879bb7..fd887a6492f4 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1347,7 +1347,7 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 		goto out_dma_release;
 	}
 
-	err = devm_spi_register_controller(&pdev->dev, ctlr);
+	err = spi_register_controller(ctlr);
 	if (err) {
 		dev_err(&pdev->dev, "could not register SPI controller: %d\n",
 			err);
@@ -1374,6 +1374,8 @@ static int bcm2835_spi_remove(struct platform_device *pdev)
 
 	bcm2835_debugfs_remove(bs);
 
+	spi_unregister_controller(ctlr);
+
 	/* Clear FIFOs, and disable the HW block */
 	bcm2835_wr(bs, BCM2835_SPI_CS,
 		   BCM2835_SPI_CS_CLEAR_RX | BCM2835_SPI_CS_CLEAR_TX);

