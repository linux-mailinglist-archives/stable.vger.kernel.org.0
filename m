Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550AC376670
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 15:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbhEGN4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 09:56:01 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:59795 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234081AbhEGN4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 09:56:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E83311940ED3;
        Fri,  7 May 2021 09:55:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 07 May 2021 09:55:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TeGLLK
        onsZ43EsZnbjmVPYaorTueOOzOL/+fF82tZcU=; b=QMkAbYFYGt2sLq7ejWwKL4
        gGJDKp/ds3nhSx4TiXDzKd83uWw1QEo2F3siPhKOfwyAHOKkJHvnIV6dJVP8En4h
        sVG+sbDTrFQDlQhipkWQl0avYqU16RmHIFg3OZEjn9Zmzuy+6s4TY8fvOgs9J+VU
        +vLF7Fby+2JU1sMll9g6NmtqP4Huy23VnEhtHCn+kNl2PrzTXCFujjLnhhY0DLji
        enLzOQCwr+z3aKx6sxQwrwTDep+TegfLClFH5ODtdGto1nTGvT7zW5s8MLD1Bdjw
        s6HWjdf9/eGf7oYhVfbuTvvFXV/wzc8IJF/dhtA/6TrQstFGKX/+GUrrJVxnOrRA
        ==
X-ME-Sender: <xms:tEaVYKXZB8YPXLoFXhQWPLRYWBW7546x_Pb9vQvNwv_2apuYPSMMWw>
    <xme:tEaVYGkF9GDegwMLKLwAAA3wjaLhr2oOL02yl6eT70Mt6GztlTFa7xzyQsFhqfCe8
    G7ny4oHj0qRZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegvddgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmdenucfjughrpefuvf
    fhfffkgggtgfesthekredttddtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihf
    ohhunhgurghtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltd
    etgedugeffgffhudffuddukeegfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghr
    nhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiii
    gvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:tEaVYOb77oY9PQHoRpnbKqtE2HzuG099qwy_HpYZQM_8SFmwWAxoDg>
    <xmx:tEaVYBVR_Rrm5Laa6HsRm8Q3SRaNCJd8k4Y1KLEp8mRBC3B_h0_Sag>
    <xmx:tEaVYEkoVEY753iZsUAWO0WX1g1W6-2kv9vIzSqAlY7NY-zvrHuy2Q>
    <xmx:tEaVYJyVNjyeAnNtjLQdAaAJk1FCHcmo49MJH8CsKbnUwFScxqJGIw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri,  7 May 2021 09:55:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: spi-nor: core: Fix an issue of releasing resources" failed to apply to 4.4-stable tree
To:     chenxiang66@hisilicon.com, michael@walle.cc,
        tudor.ambarus@microchip.com, yangyicong@hisilicon.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 May 2021 15:54:48 +0200
Message-ID: <1620395688183172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

