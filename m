Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFBE3766CB
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 16:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237465AbhEGOIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 10:08:45 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:49027 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237396AbhEGOIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 10:08:45 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6184B1941C32;
        Fri,  7 May 2021 10:07:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 07 May 2021 10:07:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JIvk4F
        7R5Nmq8bBzP1AF/pB35UPYR8nPgN1bcRnrKYU=; b=cKd43V7zXIeJPOm4f9LDtG
        NMIgoChwrXusIOOKeYC3sDIrJopv8dzDwJyZRcfchGtWUHClptG0FSbVEsM3Jc9m
        1ysFKqM985uRjFPDyIcYZg9qqETgy6NksoTCdHJRB9Spi2c6xKeHHAR2pk387C2e
        vV3FC83XaanWgEvJGBf0L5at9Ewe04g9XyOf/m0JoSfwubuQaLGKbogvJgp7hDEq
        dIlcc/RQSCdsVCRRuLFRg7VoRXA6MajS7MD7qEQjSmNDzrDfMeZnXfKHFuUv290H
        b7iOaQKpAFo7x9BTP8kdj04spNeXtQOQx333IaS9WwWPCqLSNR5U29GlzsFY1GkA
        ==
X-ME-Sender: <xms:sEmVYGj0mbhpVVVRILsUBq6rq645XrbKm3UdKdLoX-rdEZZvNBs6KQ>
    <xme:sEmVYHCc-LJaSYKwCSGE0AwUWJYsc74ozJl8wS1NRY8ccs0wglnNARxZRFxuhS6sg
    1ZrA1M5R-SQqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegvddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmdenucfjughrpefuvf
    fhfffkgggtgfesthekredttddtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihf
    ohhunhgurghtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltd
    etgedugeffgffhudffuddukeegfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghr
    nhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:sEmVYOGTB99gDM6gp8UHNO1-PNLUMRWXAfE4sXFxjaUX6KcKvytK8A>
    <xmx:sEmVYPSIZXsoSt9htjQNgMdPQai68ZOA1HGMDyWUJvGTaywg9d7Mfw>
    <xmx:sEmVYDxMetgf6k9T3NqkFR_hBIrWGdQfMyct9Ry8NB5qLhtpBSwIKg>
    <xmx:sUmVYO8klOI116ViOMO4Iho3LyQHw0pLbw_903sNgbzXyRRM-NN05w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri,  7 May 2021 10:07:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: spi-nor: core: Fix an issue of releasing resources" failed to apply to 4.19-stable tree
To:     chenxiang66@hisilicon.com, michael@walle.cc,
        tudor.ambarus@microchip.com, yangyicong@hisilicon.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 May 2021 16:07:41 +0200
Message-ID: <162039646118351@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From be94215be1ab19e5d38f50962f611c88d4bfc83a Mon Sep 17 00:00:00 2001
From: Xiang Chen <chenxiang66@hisilicon.com>
Date: Thu, 1 Apr 2021 15:34:46 +0800
Subject: [PATCH] mtd: spi-nor: core: Fix an issue of releasing resources
 during read/write

If rmmod the driver during read or write, the driver will release the
resources which are used during read or write, so it is possible to
refer to NULL pointer.

Use the testcase "mtd_debug read /dev/mtd0 0xc00000 0x400000 dest_file &
sleep 0.5;rmmod spi_hisi_sfc_v3xx.ko", the issue can be reproduced in
hisi_sfc_v3xx driver.

To avoid the issue, fill the interface _get_device and _put_device of
mtd_info to grab the reference to the spi controller driver module, so
the request of rmmod the driver is rejected before read/write is finished.

Fixes: b199489d37b2 ("mtd: spi-nor: add the framework for SPI NOR")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Tested-by: Michael Walle <michael@walle.cc>
Tested-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Reviewed-by: Michael Walle <michael@walle.cc>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1617262486-4223-1-git-send-email-yangyicong@hisilicon.com

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 8cf3cf92129e..bd2c7717eb10 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2905,6 +2905,37 @@ static void spi_nor_resume(struct mtd_info *mtd)
 		dev_err(dev, "resume() failed\n");
 }
 
+static int spi_nor_get_device(struct mtd_info *mtd)
+{
+	struct mtd_info *master = mtd_get_master(mtd);
+	struct spi_nor *nor = mtd_to_spi_nor(master);
+	struct device *dev;
+
+	if (nor->spimem)
+		dev = nor->spimem->spi->controller->dev.parent;
+	else
+		dev = nor->dev;
+
+	if (!try_module_get(dev->driver->owner))
+		return -ENODEV;
+
+	return 0;
+}
+
+static void spi_nor_put_device(struct mtd_info *mtd)
+{
+	struct mtd_info *master = mtd_get_master(mtd);
+	struct spi_nor *nor = mtd_to_spi_nor(master);
+	struct device *dev;
+
+	if (nor->spimem)
+		dev = nor->spimem->spi->controller->dev.parent;
+	else
+		dev = nor->dev;
+
+	module_put(dev->driver->owner);
+}
+
 void spi_nor_restore(struct spi_nor *nor)
 {
 	/* restore the addressing mode */
@@ -3099,6 +3130,8 @@ int spi_nor_scan(struct spi_nor *nor, const char *name,
 	mtd->_read = spi_nor_read;
 	mtd->_suspend = spi_nor_suspend;
 	mtd->_resume = spi_nor_resume;
+	mtd->_get_device = spi_nor_get_device;
+	mtd->_put_device = spi_nor_put_device;
 
 	if (info->flags & USE_FSR)
 		nor->flags |= SNOR_F_USE_FSR;

