Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C78537666F
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 15:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbhEGNz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 09:55:59 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:51351 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234081AbhEGNz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 09:55:58 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9E4F91940ED7;
        Fri,  7 May 2021 09:54:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 07 May 2021 09:54:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LJxeX6
        z6E4V7ELDW8CMn+9EHkshWh/KPtOgHae4KVak=; b=hh6bgZMuDn3a2SAqL9gi1k
        m0FIRgh/yMheo5HzRh0vl2Ry+/mLJyKm6egb1QlvTfqJK3GcXrsrQS/FTdKfcnQ8
        rqyXKuCOgiMqRCXyGSHy/eIHcYEhPr+TaomtQx909A1rWkFIXk9vu89xpKB4bHeQ
        FDyiHFAaUL9AXk7MtmUhRMwbvq8+NFe6umrZj43sXZ/k1xoEj/1AqJiFSefBzs0x
        U9B8rqEt39sM+68MgpUqlp2SivGz26is16YW3oNG7euEufjMbn0YCwH4zzfp8pUO
        inRTAi8+aYgaKFVmlplZ1tn0kJHtVG0R359ikiRTukyaRMpaFbMIglJCWEmlLdCA
        ==
X-ME-Sender: <xms:skaVYDPQNQAnfYtELQZTVd7J0XyXTas075hW7eEZIh7l4dMvPapvXA>
    <xme:skaVYN-T8eB05amtK8pUuA9pbbrVIp4TeCeAnLHqMB-vpamYzZA2T2dMOngvSXika
    lFB6o1xenURng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegvddgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmdenucfjughrpefuvf
    fhfffkgggtgfesthekredttddtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihf
    ohhunhgurghtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltd
    etgedugeffgffhudffuddukeegfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghr
    nhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:skaVYCSoqnxqbv5a-TFn9figzXxZeC_I5H96NdU32c0Kt0Ufrk4YvA>
    <xmx:skaVYHtbzeULQs5o_Yp_nZiYu4yEG0rH2kAWAxYXz396YqCE10mfUQ>
    <xmx:skaVYLc5SJQg1Al1Rl6v-BY2ycJgh6OlXfJciklgycqpOXcMMnzIpw>
    <xmx:skaVYMomZrb-8hslHMPQI7Ao8m5HEgHee7Awg-bO4Uz48SCo2Jk0QA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri,  7 May 2021 09:54:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: spi-nor: core: Fix an issue of releasing resources" failed to apply to 4.9-stable tree
To:     chenxiang66@hisilicon.com, michael@walle.cc,
        tudor.ambarus@microchip.com, yangyicong@hisilicon.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 May 2021 15:54:47 +0200
Message-ID: <1620395687136122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

