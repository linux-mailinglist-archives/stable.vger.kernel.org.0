Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2AD200A85
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbgFSNpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:45:14 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:36637 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732007AbgFSNpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:45:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id BEC4B194574D;
        Fri, 19 Jun 2020 09:45:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:45:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2F4CES
        shBUgBlbiBPyBkcslIR2f9CmB01sueMwPrlF8=; b=BwV5CEQLZZtv6HSzKRDt0r
        RluH/uTCPJHGCoOY0Qcrzjbva8nFQlQUV8qbCzkce9BM5lgboGPN0R/urYOKkpyf
        /MHthnjw3IuIx8Bz7q2audOw0gxf29YLZxcOQgsSbiMDXB3nIFoD//iivBFVJM+T
        lEtb8DhjA7o9fSOs/Hl1/C2Oyk+pYZ2dtqDZppQbbGgOzqLtMwU+++UdGvpzGKyU
        Ab5mcOmj0eXr82nUcrj2d8yquyfnczdU7IfyG2mRTwf8xYL2tj+0Ghz1DhVmvxSv
        ezFmQnCMcvlPex/YZ0bZpbhvFTj5Zut/beIffDFoo8awJMQGHleLn6JUVols8G2A
        ==
X-ME-Sender: <xms:aMHsXjtro6ncEOkhUaO7TDW6BH6hyoRUb-f_sJqzuA8fIxJAb0ZvpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:aMHsXkfGRVnVQhDAeEbybh_3I3UmO8pq_pYcj0nHuaLVRd_idemuUw>
    <xmx:aMHsXmyOrQXY7oleQDWEty1zBlCPb0-P85mKNmzaSknXWH1APrBNJA>
    <xmx:aMHsXiMYTpGNas4sglxKQMckKse7c2sxBzP9uLsrzeB_mxu9oS6Uiw>
    <xmx:aMHsXgGNvVgZHAXaHOBOKnWR6MJoNn5OnpPIQ2FXMLkscHT0wJL9tA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 41F61328005A;
        Fri, 19 Jun 2020 09:45:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] pwm: jz4740: Enhance precision in calculation of duty cycle" failed to apply to 4.19-stable tree
To:     paul@crapouillou.net, stable@vger.kernel.org,
        thierry.reding@gmail.com, u.kleine-koenig@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:45:08 +0200
Message-ID: <1592574308152110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

