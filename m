Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9C81F9BE8
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbgFOPWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:22:23 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:49525 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730321AbgFOPWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:22:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id BB91D3B3;
        Mon, 15 Jun 2020 11:22:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:22:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=IOI3Lx
        9rHjmnhLCg2fiOUb59hvw0gCgui4Mvof94iLY=; b=twSPk7fDoaAoctPwt6zBk5
        5ptFqkuN9+82aIOxoG6b542dCef3rFRospw2/SeIjkc7kXcyvfUAlruhLkOHMlbl
        8tUkGGXHjTfFeNHL1uhjJ5FLtT7pT/Z16xhI2nEho1TeNJ8tiXW+vV92sttt1XWk
        fLYH4kop+WMZ2bp3I0/vf3DrDOFompfVBT4ZTahDbHw6BDWX7k7e4oT98uqU6HJh
        T+RPxnNiSYVa8Hs4ezimBzHec4Zerti/8Re7y5sSpTI8iDWLIQoB5fa52c27Bvl4
        FlpRQQMJcpd/Eq3Z7kKAxQfYfRCCZ2PhSQ8W5rUr7ageoVA+TZkmyM/y55eHgRwQ
        ==
X-ME-Sender: <xms:LZLnXhaYFuJHHuoHF267bAMmrrxIPlT-ATK4qwEclp6GLadA3bJwVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudehnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:LZLnXoahgCC3LzrFEsRSnsu2m3p6qzmfpMCBuG8FjlNhxnGmTk--ZQ>
    <xmx:LZLnXj-Cy3qCWKAE7-DwrDM57Argzb4f3lyFUPzc5HQNWS2G025jsA>
    <xmx:LZLnXvp6ohgQm5JWT5tduGXjHEzyhzVqTlrBXMGLYWqUOf317hTIJQ>
    <xmx:LZLnXiE_CRdNWe5R7epLcnpsogJNM7Gpccc0hmnriNWfymG0I9UKEVea6M8>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 05E0F3280066;
        Mon, 15 Jun 2020 11:22:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: bcm2835: Fix controller unregister order" failed to apply to 4.14-stable tree
To:     lukas@wunner.de, broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:22:03 +0200
Message-ID: <159223452398133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

