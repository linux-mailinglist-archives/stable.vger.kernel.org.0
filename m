Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89902200A86
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732495AbgFSNpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:45:17 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:56381 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732007AbgFSNpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:45:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 01E08194573D;
        Fri, 19 Jun 2020 09:45:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=t1xJmT
        1FWiT3WcVRy/k3w+eJ2y9QaeUubM6Pu7oVWJI=; b=EZ3H4BE/x5Y/qTBRShtmxa
        TAdrPbliOIooK11qGH0gCOKEa3mqaXpwB4+sbw5gTOt9TZA/kmxbXa2UZSZWeN/t
        rp00g83BhDQTdm8YON6nhyqypP8LyB1jDfs+fzyOzStCUtMAeC8rngOsQVBDQyHz
        0TjDlpzwsglpWfiiAMqwQsG21FI2YfZRw4GpsOroPZ+PCdSsZPe13maLbbDZPxYc
        CZ+vpcmNEQoQM/DegdDZ2YhZlkMu78EH0BGzR7EDDO486ZJowtZYSy19AtKLmQNO
        Ydq9s7g/J3M/l0y3ZjWn2eTZ9ynmLfxzBmC572h6hPuAenfSsYr3jj8edv0ew4kQ
        ==
X-ME-Sender: <xms:asHsXqxbdSb9s8dVCB4y_Fz2-5Tjr0n39DsT9RZ64-dIatJpbn5aRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:asHsXmSs2sL7KLBuqX4iHmnOBgH4GTziEj2y_1MUAbE5qF1VPRIF7g>
    <xmx:asHsXsWWjQndfwggFTzbcpp7mJTJFAkrOohoVnuAn9KIkMDqWdnIYQ>
    <xmx:asHsXgicPV_3Vc_QuuIbkY2DGm04aT_rRGqlFQ3Y004kq3e1BMrEyQ>
    <xmx:a8HsXnrnqnlvhnRrxTAQcYKv3mZr-TWF6yg56qKa-qZd2apRFaJPew>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1D5FC3061CCB;
        Fri, 19 Jun 2020 09:45:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] pwm: jz4740: Enhance precision in calculation of duty cycle" failed to apply to 4.14-stable tree
To:     paul@crapouillou.net, stable@vger.kernel.org,
        thierry.reding@gmail.com, u.kleine-koenig@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:45:10 +0200
Message-ID: <1592574310127192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9017dc4fbd59c09463019ce494cfe36d654495a8 Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Wed, 27 May 2020 13:52:23 +0200
Subject: [PATCH] pwm: jz4740: Enhance precision in calculation of duty cycle
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Calculating the hardware value for the duty from the hardware value of
the period resulted in a precision loss versus calculating it from the
clock rate directly.

(Also remove a cast that doesn't really need to be here)

Fixes: f6b8a5700057 ("pwm: Add Ingenic JZ4740 support")
Cc: <stable@vger.kernel.org>
Suggested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>

diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
index 3cd5c054ad9a..4fe9d99ac9a9 100644
--- a/drivers/pwm/pwm-jz4740.c
+++ b/drivers/pwm/pwm-jz4740.c
@@ -158,11 +158,11 @@ static int jz4740_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	/* Calculate period value */
 	tmp = (unsigned long long)rate * state->period;
 	do_div(tmp, NSEC_PER_SEC);
-	period = (unsigned long)tmp;
+	period = tmp;
 
 	/* Calculate duty value */
-	tmp = (unsigned long long)period * state->duty_cycle;
-	do_div(tmp, state->period);
+	tmp = (unsigned long long)rate * state->duty_cycle;
+	do_div(tmp, NSEC_PER_SEC);
 	duty = period - tmp;
 
 	if (duty >= period)

