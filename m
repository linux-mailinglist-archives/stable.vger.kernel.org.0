Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1EED1A9C42
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896986AbgDOL2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:28:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60861 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896945AbgDOL2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:28:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3F4E85C01C7;
        Wed, 15 Apr 2020 07:28:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:28:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NKm30d
        F8qMeJhk6EfGpUBLnda6SVpJYh+jtzSexpU84=; b=KzHn9FH9xttMimLVvydD+7
        c6RaqgOrbKWl2bPykLow2sqi1gbvG4KqercY+D/UwWvLJiUdQ2UynRwkNIlUCSJK
        nE1+jgJZKBw+iNXZv1CpysuU+gRK0pOIStDPij8RSq5GJnJb10AllGNbmSnm9KPu
        l1/f48gI4/6sLmWrz2rt+dBoC8ZJIbXcXu/4kImUOxNvf8NkDlHznzMKRvIClahd
        bkOq3jg0HEh2CeYBX4WTDV+veoA7nMtsFDi/7ZsPW7XQFcgcpqAO6m6xm5OwkK36
        +NMxhKFyeUxicU5HmT7LoZOCqxRs1Bx+rtm9dhqX0ueXXbLbKbFr5NJK2S0kFHHQ
        ==
X-ME-Sender: <xms:1--WXkJyA5k-TmWNIsYpk_T7D1IdOl6ooxGdR582M7oUib7F--bfxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:1--WXoaO8Z1_YGOnOeE0O88oawmE1EjpxvnJEFRyPbODuNjC6pJlKw>
    <xmx:1--WXoQGv9_VnhoZ_6yPTXloiAOKDv2KUsAYpWdm99UXDuI8-rGuxQ>
    <xmx:1--WXghvDLYBOsdCYq0lnJah7U85yTmTyv7yBcQWj2uVhLP9lBUagQ>
    <xmx:2O-WXrinZ_kBYUcdUE5nveooYMsmWTA4J5n3kNPZE9vk-uwf0XnpWg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7D819306005B;
        Wed, 15 Apr 2020 07:28:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] rtc: max8907: add missing select REGMAP_IRQ" failed to apply to 5.6-stable tree
To:     clabbe@baylibre.com, alexandre.belloni@bootlin.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:28:22 +0200
Message-ID: <1586950102173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
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

