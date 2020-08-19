Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92502249CFC
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgHSL7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:59:13 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:36061 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728268AbgHSLtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:49:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id E5E2C1942242;
        Wed, 19 Aug 2020 07:47:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:47:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+xrqWn
        o5AFrh120zJe82B9swru6e0nA9IdeUcLyS+lA=; b=hKG125yGKjmGltUOA1ahWK
        Kp5HQHd23Rvdb+dalddFWtm2rwRHQLvEblPP6H4cBWMGbv7uEkG2vWJPPRRVCf6D
        eOIZSRhEZNYC4uaP967kErMj1cx8aKvCsN8ErWcN8Yb9t/uWNpd9r6gUYGh4l+li
        d7rePKxnhewHeLk7OkjM1pZ/GzngKA5Ho9NZegoj39Xc1+mHN+1a388c2/nEUcCv
        yBWJLHwTmboF/6+jwjnjgaks0qQ7gDWdlgwkOlhvoRGrFU7sc45v0VQZhM2A5JEr
        EA1v74xWsjUgc13YYCckFK+JeA27evC/B0g1LZpkZ8OqEdpizFY62GdWNkDtZXGQ
        ==
X-ME-Sender: <xms:aRE9XwHbMV6KjttRkMtcTGrho8I8KsdLMC-8g1lhGXn-ptTRZzbShA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:aRE9X5VB3_DLVxDphPQD_aj2gr6fHyVsrGHEtdH8nC2KKO1rPfWtvg>
    <xmx:aRE9X6Iit8b_jK5N3w7Gfqi5u0HTq0-UVh92ZaPKUxkdmNRNKMidog>
    <xmx:aRE9XyG3UtO3fbo0RcAoj_Dl10ub0_QRwmy_WDcuVGFf8Vuui_Jxxg>
    <xmx:aRE9X_cx1SMoijhhDXHoSKLLIWkyKn2gx-820DJ2MySvqiZVxTNyYw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F45C3060067;
        Wed, 19 Aug 2020 07:47:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] pinctrl: ingenic: Properly detect GPIO direction when" failed to apply to 5.4-stable tree
To:     paul@crapouillou.net, johnnyonflame@hotmail.com,
        linus.walleij@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:48:16 +0200
Message-ID: <1597837696152155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 84e7a946da71f678affacea301f6d5cb4d9784e8 Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Mon, 22 Jun 2020 23:45:48 +0200
Subject: [PATCH] pinctrl: ingenic: Properly detect GPIO direction when
 configured for IRQ
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The PAT1 register contains information about the IRQ type (edge/level)
for input GPIOs with IRQ enabled, and the direction for non-IRQ GPIOs.
So it makes sense to read it only if the GPIO has no interrupt
configured, otherwise input GPIOs configured for level IRQs are
misdetected as output GPIOs.

Fixes: ebd6651418b6 ("pinctrl: ingenic: Implement .get_direction for GPIO chips")
Reported-by: João Henrique <johnnyonflame@hotmail.com>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200622214548.265417-2-paul@crapouillou.net
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index 241e563d5814..a8d1b53ec4c1 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -1958,7 +1958,8 @@ static int ingenic_gpio_get_direction(struct gpio_chip *gc, unsigned int offset)
 	unsigned int pin = gc->base + offset;
 
 	if (jzpc->info->version >= ID_JZ4760) {
-		if (ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PAT1))
+		if (ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_INT) ||
+		    ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PAT1))
 			return GPIO_LINE_DIRECTION_IN;
 		return GPIO_LINE_DIRECTION_OUT;
 	}

