Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A130D377EC5
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhEJI6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:58:14 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:54327 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230145AbhEJI6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:58:14 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9B3951940A40;
        Mon, 10 May 2021 04:57:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 10 May 2021 04:57:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=sadJJc
        qlj4rohcsqgohInHR19ndjNpx+/XVgMyxO/DU=; b=cJhbAs3U2GjPQ7YZMk39xr
        0QkprL7FGSQ4ZXxVI3Dbpx9Z4TQfO3rUUHENo1KUfKZzVSDU+P5LnIxznoVKuk2f
        ehIOibntvXz6z27bjO92OmTgZrq9IDDJ04Hakz/duik2XJIe7ck+5VuC5gDeJIoF
        N6DC9uj/ixzIXOaAS7lC9zMs46uRBh5Dj1MHmMO5OTJth4B/TD2f29wNU1eOhgdN
        nJ4Ml7a19o1CDA/o/mpsd2mXoTfusD+u4tre97Xz2LraLWcpukacXLerlHQHof3p
        a5PkgVzR8ISo5cdr1ajxZJAPk6SkSvalpqKhVzFY8uOQlYHd757cKWM7g+XCs4WA
        ==
X-ME-Sender: <xms:ZPWYYOWG7FSBnFYOXj4bfU5tdyD0AA0ce_1MNd4VY4Fii0A8BDG82w>
    <xme:ZPWYYKlJ-eKuihE4_KrWC-vovNJnKuPkxcsUyU__ANDBXKBOimzKbzt3y3ue3K8M4
    WRz9CqRxs0tMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ZPWYYCaLfgmg6Dol_GZKNbj_BDyTgSJSCwevK6dpsZTG8HD5BAD5cg>
    <xmx:ZPWYYFXP0Dunng_8T0S9F0Hoxg_NHlXSiBIeUeIZ2tePvZZjliliiw>
    <xmx:ZPWYYIlpziZkLSRcJSQ2pN6vmGJmueJCgvYfHnCtbljQMBDKejwAPQ>
    <xmx:ZPWYYCj17AgmgaomqVkhTpy9XhB_YzWA9R0JrmiJ5gtHh9Al4iZ1Kg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:57:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] pinctrl: Ingenic: Add support for read the pin configuration" failed to apply to 5.10-stable tree
To:     zhouyanjie@wanyeetech.com, andy.shevchenko@gmail.com,
        linus.walleij@linaro.org, paul@crapouillou.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:56:31 +0200
Message-ID: <162063699165220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1d0bd580ef83b78a10c0b37f3313eaa59d8c80db Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?=
 <zhouyanjie@wanyeetech.com>
Date: Sun, 18 Apr 2021 22:44:23 +0800
Subject: [PATCH] pinctrl: Ingenic: Add support for read the pin configuration
 of X1830.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add X1830 support in "ingenic_pinconf_get()", so that it can read the
configuration of X1830 SoC correctly.

Fixes: d7da2a1e4e08 ("pinctrl: Ingenic: Add pinctrl driver for X1830.")
Cc: <stable@vger.kernel.org>
Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/1618757073-1724-3-git-send-email-zhouyanjie@wanyeetech.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index f15ef814b75a..02729da8abd6 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -2109,26 +2109,48 @@ static int ingenic_pinconf_get(struct pinctrl_dev *pctldev,
 	enum pin_config_param param = pinconf_to_config_param(*config);
 	unsigned int idx = pin % PINS_PER_GPIO_CHIP;
 	unsigned int offt = pin / PINS_PER_GPIO_CHIP;
-	bool pull;
+	unsigned int bias;
+	bool pull, pullup, pulldown;
 
-	if (jzpc->info->version >= ID_JZ4770)
-		pull = !ingenic_get_pin_config(jzpc, pin, JZ4770_GPIO_PEN);
-	else
-		pull = !ingenic_get_pin_config(jzpc, pin, JZ4740_GPIO_PULL_DIS);
+	if (jzpc->info->version >= ID_X1830) {
+		unsigned int half = PINS_PER_GPIO_CHIP / 2;
+		unsigned int idxh = (pin % half) * 2;
+
+		if (idx < half)
+			regmap_read(jzpc->map, offt * jzpc->info->reg_offset +
+					X1830_GPIO_PEL, &bias);
+		else
+			regmap_read(jzpc->map, offt * jzpc->info->reg_offset +
+					X1830_GPIO_PEH, &bias);
+
+		bias = (bias >> idxh) & (GPIO_PULL_UP | GPIO_PULL_DOWN);
+
+		pullup = (bias == GPIO_PULL_UP) && (jzpc->info->pull_ups[offt] & BIT(idx));
+		pulldown = (bias == GPIO_PULL_DOWN) && (jzpc->info->pull_downs[offt] & BIT(idx));
+
+	} else {
+		if (jzpc->info->version >= ID_JZ4770)
+			pull = !ingenic_get_pin_config(jzpc, pin, JZ4770_GPIO_PEN);
+		else
+			pull = !ingenic_get_pin_config(jzpc, pin, JZ4740_GPIO_PULL_DIS);
+
+		pullup = pull && (jzpc->info->pull_ups[offt] & BIT(idx));
+		pulldown = pull && (jzpc->info->pull_downs[offt] & BIT(idx));
+	}
 
 	switch (param) {
 	case PIN_CONFIG_BIAS_DISABLE:
-		if (pull)
+		if (pullup || pulldown)
 			return -EINVAL;
 		break;
 
 	case PIN_CONFIG_BIAS_PULL_UP:
-		if (!pull || !(jzpc->info->pull_ups[offt] & BIT(idx)))
+		if (!pullup)
 			return -EINVAL;
 		break;
 
 	case PIN_CONFIG_BIAS_PULL_DOWN:
-		if (!pull || !(jzpc->info->pull_downs[offt] & BIT(idx)))
+		if (!pulldown)
 			return -EINVAL;
 		break;
 
@@ -2146,7 +2168,7 @@ static void ingenic_set_bias(struct ingenic_pinctrl *jzpc,
 	if (jzpc->info->version >= ID_X1830) {
 		unsigned int idx = pin % PINS_PER_GPIO_CHIP;
 		unsigned int half = PINS_PER_GPIO_CHIP / 2;
-		unsigned int idxh = pin % half * 2;
+		unsigned int idxh = (pin % half) * 2;
 		unsigned int offt = pin / PINS_PER_GPIO_CHIP;
 
 		if (idx < half) {

