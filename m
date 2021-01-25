Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31167302671
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 15:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbhAYOq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 09:46:28 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:40285 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729752AbhAYOpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 09:45:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 37288D16;
        Mon, 25 Jan 2021 09:44:29 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 25 Jan 2021 09:44:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=UjnaXS
        31QfmxWQ2Q9kbPhBeGZF1cA5iCiFWGAJA6VJQ=; b=KOSjekNj3zKvOIo/TaX+q3
        3n9DDR/oI9A1pqMGzIVj3790/OrafDVkHXZsfZ8NO6oaVpUhC9sb/gKC217R2Vo1
        DPTY7nS9XLHOlQVZs5DQ8XdGDiciwcvIJPcYpARmF1itntZRpQehTtbHdbFtlPt0
        SuhZIFWUxa7ag5jeP3QAXwG6nex9Ianp2CvhBTrlREpOY3wRU/USHtnyEBu+KxxI
        juAozqd7ACaQRTyM3erGOC6BRNwCejeIodRCyZUkyZ6jq1s+pwHimcISEtBGh/2T
        OsAdWYa/K6Rxmcz6hymcbl6YUnAch7fCWxyZQi8sp8r2qE6PWjRRg2MB4YLarIaQ
        ==
X-ME-Sender: <xms:TNkOYLCxfpfspFddMxlY6swpCsbtIAEb_pEKDCcBSpwKRxAzwPtVVw>
    <xme:TNkOYBjkywoBEvEIp9y7PEf8C21lhYRjVegsyn9HeHdgwE37SPoNvt85NLl2R1i3F
    SJ8z3bAqwDZgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:TNkOYGkGPtVz9HX-KJnf1iiAX-lQn63G2Fov38_j6-KGhYqNthl_AA>
    <xmx:TNkOYNx82sCRbB6sxiHYMt-RWp8GnBc6Kzo6iGTiWo92HLZ0Vyp5mw>
    <xmx:TNkOYASWSIiLaqioUfIKNg1S9uZkRwNewne-9gAtIXvHgB4aUwOLjg>
    <xmx:TNkOYLff5o0I2Dsajoso-rbtOx0wI-2NZ_aMja9PeFkNVSAvLHbdFC54-6E>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7D5921080059;
        Mon, 25 Jan 2021 09:44:28 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: mvebu: fix pwm .get_state period calculation" failed to apply to 4.19-stable tree
To:     baruch@tkos.co.il, bgolaszewski@baylibre.com,
        linux@armlinux.org.uk, u.kleine-koenig@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:44:16 +0100
Message-ID: <161158585614998@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

