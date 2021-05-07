Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BE83766D7
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 16:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbhEGOJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 10:09:49 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:57511 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234314AbhEGOJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 10:09:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2AB7C1941C33;
        Fri,  7 May 2021 10:08:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 07 May 2021 10:08:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=w5reRj
        uDFTR7HAcW7U8A4stK1hPCpFsdZWsVrUWlSdA=; b=UEiEA7N+kayXPgcO4p1Bi9
        piSLqcaxE3/RZDUwlJVyetWByYtsIM/k4Q5n6QmL/z0kGenkidx6SO9FRzNOQEL2
        YKfaKrRdWxQh6WTSKZQIpdGkntPfC8UkzzKPp5dFhGMO1hw5xCj8jUsR6ElwGOEq
        hNUZSRbNWYBqlQPr6Shm31DyoEKBRWlK5k/ikcuh/d1Vm8rRfoWT9ihe134FALPi
        pXhGR7dk9ntBYT3dMtbN3gvETNajcJ5UGFnr1B+p+iklU0kh3e7anYbjL1pHuirV
        Lkm9KvmtYOLkMM0jFSdiBbBw39Iy5Wa1veQRBwFpA4j2uzF2yCd6Wd/y2O3QAlDQ
        ==
X-ME-Sender: <xms:70mVYC1V2NWKF6We2ikR7-xbEOdhruOYmJhQkiCK9Z_uNFQdikz7uw>
    <xme:70mVYFHOFD3Zd3X-2X_MhZsdzDZX7xE9C6tvpyKgmQ9-E2RwF9ODgtkqPD2mN8QYj
    7u8V8L9M8JRfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegvddgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmdenucfjughrpefuvf
    fhfffkgggtgfesthekredttddtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihf
    ohhunhgurghtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltd
    etgedugeffgffhudffuddukeegfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghr
    nhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:70mVYK72RBtNz0USJWU9XNLzKQ09rmwbQuGqqIZ4ulERUKvFxtJEng>
    <xmx:70mVYD3ISCMQFvK5_nDL_Jfyzgg9G1yT4wZGhS-H-1xiCN-ICl0-qg>
    <xmx:70mVYFHUYyQDaZ70gSalEky72nybg8t1iLeO-GmhHjbxP0c6cZ3DdA>
    <xmx:8EmVYKS6PG0IXBafdtu82nHlFELeEm4jxbEwQ7OcnASenu5YgjfGwQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri,  7 May 2021 10:08:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: spi-nor: core: Fix an issue of releasing resources" failed to apply to 5.4-stable tree
To:     chenxiang66@hisilicon.com, michael@walle.cc,
        tudor.ambarus@microchip.com, yangyicong@hisilicon.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 May 2021 16:08:29 +0200
Message-ID: <162039650937164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

