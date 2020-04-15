Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA921A9C45
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896987AbgDOL2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:28:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35713 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896981AbgDOL2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:28:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 77D775C01F2;
        Wed, 15 Apr 2020 07:28:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:28:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qIxMce
        B3R5eAJbfdbswaK449+CrYUp/gv6DIrJdEZxI=; b=mMH57nHd4zBCmTZxVvU+Ml
        Q6sMoqog/GK9bcaobBDa8ab6KzOIZwRQhXnXQlW1I9cCklohRPnVzH4tV3MnMa6e
        NOGdBOpDjGxL6QTDiMtmqGsVpKWg+Hy4/LSf34MZKVYw2pQPCcvfuAgu8ljSORF2
        TSEdbP8URrcyzo6HQYzxFmR+xYB3ieCmrexeez6BUS3tnKhe+cDNL/l/y3z27WLh
        l8DuhpqyG3osb8Q2P2hvAIUeC/ltVC80a02hk/3qeJpja8bp+Qg4y7EKRvMeTkga
        67OFnOEP2c2YmRQKfhWi4mv6x8vvmWlB8VCAQRg2HfMYzKIBRDlEfVI87rKXsauQ
        ==
X-ME-Sender: <xms:4e-WXgQKgfFif-JnrjBtyYntdT9XoPTGzBMkCzWxAKH829OPjoWBSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:4e-WXjRyK728jj-5FF_C-SkYlQt7F50fGQHZTbl48DBe8dEFG7Qfdw>
    <xmx:4e-WXs4pCR-mvQXhpKXOkP-VZPpnOvk5zjBSK0d7Nl9oPkS4FgrOlg>
    <xmx:4e-WXoXu9mkX6XBqgDh9uWhL6p6k5Z-ALTBHg-MaSUd7ZKL4zNEJ7Q>
    <xmx:4e-WXuKfeoKLhPZOp84aD-A1VkbOEBiNQKvXRN2ErVtbsKuS8xi4ag>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 19165328005E;
        Wed, 15 Apr 2020 07:28:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] rtc: max8907: add missing select REGMAP_IRQ" failed to apply to 5.4-stable tree
To:     clabbe@baylibre.com, alexandre.belloni@bootlin.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:28:23 +0200
Message-ID: <158695010316141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

