Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE14730267D
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 15:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbhAYOrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 09:47:24 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:49997 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729666AbhAYOpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 09:45:19 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 46C69ED1;
        Mon, 25 Jan 2021 09:44:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 25 Jan 2021 09:44:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=MgiVKw
        JJyvkbilZ10tBeUo1IcMip98s3+KQfKR8pHJM=; b=r/heY1egGxB7T1srG0UxS+
        kHlSFgf37gKOHtAbkK5kTEeZBSv84kdoOosYhT235lriAtPG/KDvUeyAzDLejAWw
        bAMPZsxbf/NFajCG+AYHkfNYMFI1V/hXOtCrEZX8j08UK/LEtnWRbSL0AAabzC+/
        COBYFrkZa8VWgZLNzEGEgA6WC/v8STYglFLUiYHoiXfwnQgBejFUiXlGe6DRlHMl
        fl0PYc3si4bIvwDVjdwVt5aN8oLYFyc8/Hrcu8cLEEn8zacKQ1DivUVZMUpsFMA/
        bgs3xsdtdThcHFcEjxcagpm3XtRf9fUrLTiV/3D8N+NZtjGBidbkgLgktvOZBh7w
        ==
X-ME-Sender: <xms:SdkOYIUVHqIEDCSYM6yIKK8A2tlWOwJndxERCvvHE46p-OoWuMxqAQ>
    <xme:SdkOYMgoNqNByd8N2oAGpNFzzV72sxv15ohL6kIN9rFHsd_6OKPstASm95p4ac0y5
    kjoeVQ8me8iNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:SdkOYJQCONDpNpogvy1WKTVxMb36e9ATMpMKtuxaysI2Iu_1S_wQog>
    <xmx:SdkOYPH9RHQWEFrXqDEZqR5xFqOJ7y0gtuTLwxZCo1Eo9c4z6-aCnw>
    <xmx:SdkOYBmvsaTzYflUp5o4uqx7lHqoC8ktTuDE1UfWCdqDuZKkr9I9dQ>
    <xmx:StkOYDgTwsl9bA283vZhy1d4x58xJMF4300g7zHJioAiJ4FXOIbLfZmU3to>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 83DAC1080068;
        Mon, 25 Jan 2021 09:44:25 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: mvebu: fix pwm .get_state period calculation" failed to apply to 5.4-stable tree
To:     baruch@tkos.co.il, bgolaszewski@baylibre.com,
        linux@armlinux.org.uk, u.kleine-koenig@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:44:15 +0100
Message-ID: <161158585525169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

