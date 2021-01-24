Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D4B301C2D
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbhAXNY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:24:26 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:35857 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbhAXNYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:24:21 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 74DCFB21;
        Sun, 24 Jan 2021 08:23:15 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:23:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/c8Aa6
        UBcj9CUkRrFzWkE1Ay1KxdU6A4m8jooTrG+e8=; b=DkFUQcvpVOJXsnFfFkcPjL
        K+z0ys8F1MkxL9Gmg/XHnb+E68v0/y9VRLRM/w6avtCK9+MkU528mrlgeFMbLJ0v
        szQOSVcj2kf3SL0Bfnlj9Db4acwQ+J2hPsX5sK2n1lg6otcel8D8I/NbvTUAAw4o
        +7KlypEHe19NilYl7x5gu9HY4DGD+7oe6HGUIjisyC1EVYgC227cGzZq3qgmWaB3
        GDIbH1BvCaIQVTBCmMLXyBj7OxlXI1Gm+oZTpeuxV+/wUi6pLj5U8++H6ocX7w5i
        kTp1gSHtV/ZZn5ObLY3GHc9h7PO+WHjO3hok/si+5+QNixOXY0Fq+xAsriqNMxiA
        ==
X-ME-Sender: <xms:wnQNYHFSwxvF71fH5AMk-pgb5ufzqZ2zKenrYqqK7CU7U7loCm18vg>
    <xme:wnQNYEW8XZTtJU9TXwzg_F5RIzM37wWG9d7JYp9ok2rbJJx_QK7lvyb6njMIBCVFY
    XRw57U9aoKA6A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:wnQNYJJ_C8DTtoIh0QhQhwB6hrtolDkOCe0WrKjP9mbdiyb-DN6t9g>
    <xmx:wnQNYFHp_ZQ6wSswgSkXnqsllAsGmOGyzMp8ppdigOnFH1czIhwvWA>
    <xmx:wnQNYNXhqiABRfM8Ysfr9yHmnoJRVDk1rKY4QPO3LQK72vpxKUf3zw>
    <xmx:w3QNYOc8HixhE6gfdVKN7arvU_bjXTBd4Yko6I4ch9t0ewZoL1hrqP8z7oI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9314D108005B;
        Sun, 24 Jan 2021 08:23:14 -0500 (EST)
Subject: FAILED: patch "[PATCH] pinctrl: ingenic: Fix JZ4760 support" failed to apply to 5.4-stable tree
To:     paul@crapouillou.net, linus.walleij@linaro.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:23:13 +0100
Message-ID: <1611494593252195@kroah.com>
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

From 9a85c09a3f507b925d75cb0c7c8f364467038052 Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Fri, 11 Dec 2020 23:28:09 +0000
Subject: [PATCH] pinctrl: ingenic: Fix JZ4760 support

- JZ4760 and JZ4760B have a similar register layout as the JZ4740, and
  don't use the new register layout, which was introduced with the
  JZ4770 SoC and not the JZ4760 or JZ4760B SoCs.

- The JZ4740 code path only expected two function modes to be
  configurable for each pin, and wouldn't work with more than two. Fix
  it for the JZ4760, which has four configurable function modes.

Fixes: 0257595a5cf4 ("pinctrl: Ingenic: Add pinctrl driver for JZ4760 and JZ4760B.")
Cc: <stable@vger.kernel.org> # 5.3
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20201211232810.261565-1-paul@crapouillou.net
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index 53a6a24bd052..8ac3091c4469 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -1688,7 +1688,7 @@ static inline bool ingenic_gpio_get_value(struct ingenic_gpio_chip *jzgc,
 static void ingenic_gpio_set_value(struct ingenic_gpio_chip *jzgc,
 				   u8 offset, int value)
 {
-	if (jzgc->jzpc->info->version >= ID_JZ4760)
+	if (jzgc->jzpc->info->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_PAT0, offset, !!value);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_DATA, offset, !!value);
@@ -1718,7 +1718,7 @@ static void irq_set_type(struct ingenic_gpio_chip *jzgc,
 		break;
 	}
 
-	if (jzgc->jzpc->info->version >= ID_JZ4760) {
+	if (jzgc->jzpc->info->version >= ID_JZ4770) {
 		reg1 = JZ4760_GPIO_PAT1;
 		reg2 = JZ4760_GPIO_PAT0;
 	} else {
@@ -1758,7 +1758,7 @@ static void ingenic_gpio_irq_enable(struct irq_data *irqd)
 	struct ingenic_gpio_chip *jzgc = gpiochip_get_data(gc);
 	int irq = irqd->hwirq;
 
-	if (jzgc->jzpc->info->version >= ID_JZ4760)
+	if (jzgc->jzpc->info->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_INT, irq, true);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_SELECT, irq, true);
@@ -1774,7 +1774,7 @@ static void ingenic_gpio_irq_disable(struct irq_data *irqd)
 
 	ingenic_gpio_irq_mask(irqd);
 
-	if (jzgc->jzpc->info->version >= ID_JZ4760)
+	if (jzgc->jzpc->info->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_INT, irq, false);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_SELECT, irq, false);
@@ -1799,7 +1799,7 @@ static void ingenic_gpio_irq_ack(struct irq_data *irqd)
 			irq_set_type(jzgc, irq, IRQ_TYPE_LEVEL_HIGH);
 	}
 
-	if (jzgc->jzpc->info->version >= ID_JZ4760)
+	if (jzgc->jzpc->info->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_FLAG, irq, false);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_DATA, irq, true);
@@ -1856,7 +1856,7 @@ static void ingenic_gpio_irq_handler(struct irq_desc *desc)
 
 	chained_irq_enter(irq_chip, desc);
 
-	if (jzgc->jzpc->info->version >= ID_JZ4760)
+	if (jzgc->jzpc->info->version >= ID_JZ4770)
 		flag = ingenic_gpio_read_reg(jzgc, JZ4760_GPIO_FLAG);
 	else
 		flag = ingenic_gpio_read_reg(jzgc, JZ4740_GPIO_FLAG);
@@ -1938,7 +1938,7 @@ static int ingenic_gpio_get_direction(struct gpio_chip *gc, unsigned int offset)
 	struct ingenic_pinctrl *jzpc = jzgc->jzpc;
 	unsigned int pin = gc->base + offset;
 
-	if (jzpc->info->version >= ID_JZ4760) {
+	if (jzpc->info->version >= ID_JZ4770) {
 		if (ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_INT) ||
 		    ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PAT1))
 			return GPIO_LINE_DIRECTION_IN;
@@ -1996,7 +1996,7 @@ static int ingenic_pinmux_set_pin_fn(struct ingenic_pinctrl *jzpc,
 		ingenic_shadow_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, func & 0x2);
 		ingenic_shadow_config_pin(jzpc, pin, JZ4760_GPIO_PAT0, func & 0x1);
 		ingenic_shadow_config_pin_load(jzpc, pin);
-	} else if (jzpc->info->version >= ID_JZ4760) {
+	} else if (jzpc->info->version >= ID_JZ4770) {
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_INT, false);
 		ingenic_config_pin(jzpc, pin, GPIO_MSK, false);
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, func & 0x2);
@@ -2004,7 +2004,7 @@ static int ingenic_pinmux_set_pin_fn(struct ingenic_pinctrl *jzpc,
 	} else {
 		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_FUNC, true);
 		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_TRIG, func & 0x2);
-		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_SELECT, func > 0);
+		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_SELECT, func & 0x1);
 	}
 
 	return 0;
@@ -2061,7 +2061,7 @@ static int ingenic_pinmux_gpio_set_direction(struct pinctrl_dev *pctldev,
 		ingenic_shadow_config_pin(jzpc, pin, GPIO_MSK, true);
 		ingenic_shadow_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, input);
 		ingenic_shadow_config_pin_load(jzpc, pin);
-	} else if (jzpc->info->version >= ID_JZ4760) {
+	} else if (jzpc->info->version >= ID_JZ4770) {
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_INT, false);
 		ingenic_config_pin(jzpc, pin, GPIO_MSK, true);
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, input);
@@ -2091,7 +2091,7 @@ static int ingenic_pinconf_get(struct pinctrl_dev *pctldev,
 	unsigned int offt = pin / PINS_PER_GPIO_CHIP;
 	bool pull;
 
-	if (jzpc->info->version >= ID_JZ4760)
+	if (jzpc->info->version >= ID_JZ4770)
 		pull = !ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PEN);
 	else
 		pull = !ingenic_get_pin_config(jzpc, pin, JZ4740_GPIO_PULL_DIS);
@@ -2141,7 +2141,7 @@ static void ingenic_set_bias(struct ingenic_pinctrl *jzpc,
 					REG_SET(X1830_GPIO_PEH), bias << idxh);
 		}
 
-	} else if (jzpc->info->version >= ID_JZ4760) {
+	} else if (jzpc->info->version >= ID_JZ4770) {
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PEN, !bias);
 	} else {
 		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_PULL_DIS, !bias);
@@ -2151,7 +2151,7 @@ static void ingenic_set_bias(struct ingenic_pinctrl *jzpc,
 static void ingenic_set_output_level(struct ingenic_pinctrl *jzpc,
 				     unsigned int pin, bool high)
 {
-	if (jzpc->info->version >= ID_JZ4760)
+	if (jzpc->info->version >= ID_JZ4770)
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PAT0, high);
 	else
 		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_DATA, high);

