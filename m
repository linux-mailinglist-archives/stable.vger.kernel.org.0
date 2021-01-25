Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4FF302672
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 15:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbhAYOqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 09:46:42 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:39169 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729747AbhAYOph (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 09:45:37 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id CB108EC6;
        Mon, 25 Jan 2021 09:44:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 Jan 2021 09:44:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gVew+4
        66pXYPvHUY8xUXOPz/wpmd09eIPnPfzQjERL0=; b=CxtffcSeaLThpp7TrRbsPd
        MyGXZI+c8NvOTy0dCDo/eYU5xrZgqNws6e6O6G+4WtAoDoiwQKAkeD/fbhEMpKuk
        blnS0mHhHMmAom8gm9Z/rYoYAKU3AvxWuQ/j4O9CxPBrlEboMce0UTTla8r2UlRG
        snQ/D2/B1gMFeEDjbWv6AbbK5oWluJxjzHq37cMHgUPY4BUMBvG/H+SFJYPvtbii
        ApRmViDPzTAj2nGrfo8h+CESuEszOn7wmMWQfOw173KZ46/YbIjSezjLyd3jLG2L
        Zhyksctt5DOFLLy7YdZd/f8R0wyKTgvXmZ2oL9zeI38KsLy9s2xP+bOex5PC0yTQ
        ==
X-ME-Sender: <xms:QNkOYIK_n0LfvQEuYvQXusiX9s1RRG1e72ZRwg83DByEjLB7yPMyOA>
    <xme:QNkOYIJy4XOpyk01xCTMxj_1rPBUDm-aRFaVKnJiGrIm9gSxef4smJ6ErkaVvn54a
    aqNMh9uZrgklA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:QNkOYIvlFifj3rmvWEVb50uo_czfemyqHx-HloxcKhIjt9iU8mtDsA>
    <xmx:QNkOYFYKAqKumCRO9l5kRObLuh5eAo6POoYdfoMDqV6OmpIbqLxcqA>
    <xmx:QNkOYPZusydmjMTjkdtZVLDuHAS9-vKNG5xNvwORBm0on4i2ibdnjA>
    <xmx:QdkOYOkkZSCXN5cQOkGWwy3iP26sXarYZZZzFWRWvNUWLoUGxa1jCAc0FGk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8040524005C;
        Mon, 25 Jan 2021 09:44:16 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: mvebu: fix pwm .get_state period calculation" failed to apply to 5.10-stable tree
To:     baruch@tkos.co.il, bgolaszewski@baylibre.com,
        linux@armlinux.org.uk, u.kleine-koenig@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:44:14 +0100
Message-ID: <16115858543164@kroah.com>
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

From e73b0101ae5124bf7cd3fb5d250302ad2f16a416 Mon Sep 17 00:00:00 2001
From: Baruch Siach <baruch@tkos.co.il>
Date: Sun, 17 Jan 2021 15:17:02 +0200
Subject: [PATCH] gpio: mvebu: fix pwm .get_state period calculation
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The period is the sum of on and off values. That is, calculate period as

  ($on + $off) / clkrate

instead of

  $off / clkrate - $on / clkrate

that makes no sense.

Reported-by: Russell King <linux@armlinux.org.uk>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Fixes: 757642f9a584e ("gpio: mvebu: Add limited PWM support")
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 672681a976f5..a912a8fed197 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -676,20 +676,17 @@ static void mvebu_pwm_get_state(struct pwm_chip *chip,
 	else
 		state->duty_cycle = 1;
 
+	val = (unsigned long long) u; /* on duration */
 	regmap_read(mvpwm->regs, mvebu_pwmreg_blink_off_duration(mvpwm), &u);
-	val = (unsigned long long) u * NSEC_PER_SEC;
+	val += (unsigned long long) u; /* period = on + off duration */
+	val *= NSEC_PER_SEC;
 	do_div(val, mvpwm->clk_rate);
-	if (val < state->duty_cycle) {
+	if (val > UINT_MAX)
+		state->period = UINT_MAX;
+	else if (val)
+		state->period = val;
+	else
 		state->period = 1;
-	} else {
-		val -= state->duty_cycle;
-		if (val > UINT_MAX)
-			state->period = UINT_MAX;
-		else if (val)
-			state->period = val;
-		else
-			state->period = 1;
-	}
 
 	regmap_read(mvchip->regs, GPIO_BLINK_EN_OFF + mvchip->offset, &u);
 	if (u)

