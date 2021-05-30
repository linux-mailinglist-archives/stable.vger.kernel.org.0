Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F04C39513D
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 16:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhE3OFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 10:05:32 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:58665 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3OFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 10:05:32 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id F12A619402AF;
        Sun, 30 May 2021 10:03:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 May 2021 10:03:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WFPkRc
        PLGnHaTbkNC6PM/9/cX82k5tPasX5djm2PlLM=; b=EXTawrzkuPv98pFpwJZOlN
        VRsBMhm1lPpUObAm8Q6HIMxEGiX0+VDx1B4wATxK5r0YWHZCL+6zL523FBUR57F4
        PNjCoDaKyLhDrE1u93aAxfxcVEIWKynIkGrrmvXy0lm/AbMcuqDeetVJPyCI8EdH
        tKHTMWS3qdl/Kcvdwz2PlNzx48lMoPpo7TzTN/xKcWYghMDT+7OqSV88PVEdvtL4
        pXKfhgG7vskpJFxVp0wTHA1mHHHgvqyRHbll2+3ndiXDHglzWqXf8KDlR76Bm57z
        BKq30dg/ZG9GtGga07+G6PRLDYQCZTDtTZ4nehiEEDXuqDJ1bOPEKfa1UC4z6eDg
        ==
X-ME-Sender: <xms:SZuzYF_oIxJ47eyFCB15nUFXRutXP8LBNnE4RJu6TgzNpMxQaS0sKg>
    <xme:SZuzYJtmmd1Hg5meMLxYSWU7L8oaIkap_gnzul-xiN-cVKiUPfxI0vpjFjbbf-Tmw
    tUD63ErtIehfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:SZuzYDBKxCRMH9tUoIGsKM3lA5T7KQhgVtPM49Com83n34bwl95olA>
    <xmx:SZuzYJciXkvyRqQdaTvZAVoN6QTgFvbRGWADE1gJFr2PSN6_7z88Zw>
    <xmx:SZuzYKMooLto3I0Vkqg5wctqyDnU1WJW3oS9F_jrVkpmbCdyVLrOPQ>
    <xmx:SZuzYHqiWxg4xp9yMaCfcw2vploZ7hKiUteWtWCGdFnOuNp9HG_5mQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 10:03:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: Assume GPIO CS active high in ACPI case" failed to apply to 5.12-stable tree
To:     andriy.shevchenko@linux.intel.com, broonie@kernel.org,
        f.fangjian@huawei.com, thesven73@gmail.com, xhao@linux.alibaba.com,
        zhangliguang@linux.alibaba.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 16:03:51 +0200
Message-ID: <1622383431200222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6b69546912a57ff8c31061f98e56383cc0beffd3 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Tue, 11 May 2021 17:09:12 +0300
Subject: [PATCH] spi: Assume GPIO CS active high in ACPI case

Currently GPIO CS handling, when descriptors are in use, doesn't
take into consideration that in ACPI case the default polarity
is Active High and can't be altered. Instead we have to use the
per-chip definition provided by SPISerialBus() resource.

Fixes: 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")
Cc: Liguang Zhang <zhangliguang@linux.alibaba.com>
Cc: Jay Fang <f.fangjian@huawei.com>
Cc: Sven Van Asbroeck <thesven73@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Xin Hao <xhao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20210511140912.30757-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index a565e7d6bf3b..98048af04abf 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -820,15 +820,29 @@ static void spi_set_cs(struct spi_device *spi, bool enable, bool force)
 
 	if (spi->cs_gpiod || gpio_is_valid(spi->cs_gpio)) {
 		if (!(spi->mode & SPI_NO_CS)) {
-			if (spi->cs_gpiod)
-				/* polarity handled by gpiolib */
-				gpiod_set_value_cansleep(spi->cs_gpiod, activate);
-			else
+			if (spi->cs_gpiod) {
+				/*
+				 * Historically ACPI has no means of the GPIO polarity and
+				 * thus the SPISerialBus() resource defines it on the per-chip
+				 * basis. In order to avoid a chain of negations, the GPIO
+				 * polarity is considered being Active High. Even for the cases
+				 * when _DSD() is involved (in the updated versions of ACPI)
+				 * the GPIO CS polarity must be defined Active High to avoid
+				 * ambiguity. That's why we use enable, that takes SPI_CS_HIGH
+				 * into account.
+				 */
+				if (has_acpi_companion(&spi->dev))
+					gpiod_set_value_cansleep(spi->cs_gpiod, !enable);
+				else
+					/* Polarity handled by GPIO library */
+					gpiod_set_value_cansleep(spi->cs_gpiod, activate);
+			} else {
 				/*
 				 * invert the enable line, as active low is
 				 * default for SPI.
 				 */
 				gpio_set_value_cansleep(spi->cs_gpio, !enable);
+			}
 		}
 		/* Some SPI masters need both GPIO CS & slave_select */
 		if ((spi->controller->flags & SPI_MASTER_GPIO_SS) &&

