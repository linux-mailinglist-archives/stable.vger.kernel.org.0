Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5964D1A9C43
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896945AbgDOL2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:28:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34379 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896929AbgDOL2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:28:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1EA005C01CF;
        Wed, 15 Apr 2020 07:28:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:28:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4zXd/q
        pGCfm5C88lvuWQq7ebr98QXnmtTWqq7uYwX9g=; b=eDpcIPT8xZzyvBwJTpVWll
        FpF3TFp4Xh+3lOkKt4pO1NGH0hZDBf/rNfw2gIICSlhAqHqLwkwqdJUVNfZqBPrE
        qQF0bQtX/702hRNAZwmY8pX7BpXEjQFTn1eh0ThuQhtekGmZnjNYImBAHzWBIQzO
        LKhw3/8GmCTfqNUXvZLplVGVixhEKOmbFvKMh5G0z9Rhn2i2f4hsN1YcwvLbO+ax
        YAJQ5mbksyWyAoR1lQcJ0lz/FQYxULChs1MJiidrM0xuIT9nP15+jVFQaeHJ3t5X
        5W+i4tYvoFYm2uOp+sFgTcjQkpTCgNn7jVsmMSNDx8BVqCP1ufm2LMp+BsJ6cc9Q
        ==
X-ME-Sender: <xms:4O-WXpxiCVKyvB_kdjDRFy3dc5vbtgeTBYuISIDrL7GWtNTzRvmbCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:4O-WXmha-wRMi30bz15bXsqkSEMIda8HeSORgk6ehQ4yP4vfpH0iew>
    <xmx:4O-WXouKX7LvPiesL0ASuhrKcNAIaCP71XjsOa71-8tjwSZG7ipz9Q>
    <xmx:4O-WXuXEc4qKglr15iVZpRDInP5ZF2ZD40RWNS1eHotLMjNUDcsFQg>
    <xmx:4O-WXoTSkyOlxsyGXOm6yzDLnb6wLAXB_oiOBKNHJFsI54a1pCvpQw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B33F83280064;
        Wed, 15 Apr 2020 07:28:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] rtc: max8907: add missing select REGMAP_IRQ" failed to apply to 5.5-stable tree
To:     clabbe@baylibre.com, alexandre.belloni@bootlin.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:28:22 +0200
Message-ID: <1586950102206156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c05a31f4d1de8f49f66f499e67da9c3d745c4f19 Mon Sep 17 00:00:00 2001
From: Corentin Labbe <clabbe@baylibre.com>
Date: Wed, 18 Mar 2020 15:26:49 +0000
Subject: [PATCH] rtc: max8907: add missing select REGMAP_IRQ

I have hit the following build error:
armv7a-hardfloat-linux-gnueabi-ld: drivers/rtc/rtc-max8907.o: in function `max8907_rtc_probe':
rtc-max8907.c:(.text+0x400): undefined reference to `regmap_irq_get_virq'

max8907 should select REGMAP_IRQ

Fixes: 94c01ab6d7544 ("rtc: add MAX8907 RTC driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Link: https://lore.kernel.org/r/1584545209-20433-1-git-send-email-clabbe@baylibre.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 7d6cb60ee010..6c99156cbe57 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -327,6 +327,7 @@ config RTC_DRV_MAX6900
 config RTC_DRV_MAX8907
 	tristate "Maxim MAX8907"
 	depends on MFD_MAX8907 || COMPILE_TEST
+	select REGMAP_IRQ
 	help
 	  If you say yes here you will get support for the
 	  RTC of Maxim MAX8907 PMIC.

