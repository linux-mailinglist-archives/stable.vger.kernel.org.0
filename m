Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51058200A87
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732854AbgFSNpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:45:22 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:47075 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732007AbgFSNpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:45:21 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 39F9C1945747;
        Fri, 19 Jun 2020 09:45:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:45:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JyIn2n
        E1dXwar0Ekl27r9AA7Q+H57em+bpdGPp0KuoQ=; b=EU1PIKRYZU7wOnS0JOJfj6
        emYDGZeR/bVY4Z35CZTl5HvhGE+MjUT7XRTNuKAQAWWU5jR3xDLwl4hiYzouL3Ar
        IhDF5raXiRDR7tde3VdPCT40myui109wcp0dKHaTCPU8O+QSSZaXSbNw18qpfSsf
        aLEmRZMVtZLXkjCXU1mWtdgDpyVuAVHsNanFpFDePhWNKfn6L4T+qrDLOjyQ1/1H
        Uj10IAuUAZPTNNwo6eB4ZWy/PyDM+t6HkBLnBhdv2y7cqw1g2vRPfEH8HN+qeMUR
        tsNBG+ksjGWuCceAJoMeVSgwCOnlVf/ZfFznqW9xutO0yLE9wkO/8+wk+7HtdLUw
        ==
X-ME-Sender: <xms:b8HsXsV-frzmDiSaptD4cAj3PhzI7amTWnTml9p5Qm89ilqECi9DtA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:b8HsXgkUU-OfOx7C2cV6b1rswNChVENI6DjcbSCcjYyPeyilELK30w>
    <xmx:b8HsXgb2C6x1Q902K5cpMIMMLQqJYsffELQDaB_D_PCcn197DdpkeA>
    <xmx:b8HsXrWQjEasMUJ46VK98lfa0RtV9AkuWp8gmV0Yvsbbh_SJaR-CFw>
    <xmx:b8HsXtuNgwzf3qAiQf7gr6arMbvA22mTkx6ZXaJQzKo0czFFbzqOig>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B64933280060;
        Fri, 19 Jun 2020 09:45:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] pwm: jz4740: Enhance precision in calculation of duty cycle" failed to apply to 4.9-stable tree
To:     paul@crapouillou.net, stable@vger.kernel.org,
        thierry.reding@gmail.com, u.kleine-koenig@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:45:12 +0200
Message-ID: <15925743124920@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

