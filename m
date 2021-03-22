Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4151A343C67
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 10:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhCVJM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 05:12:28 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:51125 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229574AbhCVJMW (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 22 Mar 2021 05:12:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 974A61567;
        Mon, 22 Mar 2021 05:12:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 22 Mar 2021 05:12:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nE1fA9
        gkbPCZNGatzZ7BH/SUW6X8UMEOLqcOw873Tk0=; b=weCWa191X6LTpfQIuwofWr
        qPna5BWQaInoccOQQsmIG7tBl0ZuF62BId3Y1SVjIPWiXlqWViB6slF15j+RdJFH
        HhzPXe9iyKhTtv0qXZePQGSV7JQzvXv4PNZQOcXKRIYONMcI/rL+8Qo3KS5zYgUK
        iS28cY0FEvuSeJi8rsAScuAldwGnsjFtm0ixbCtxlufJ5yTvEfkFth47PHbTB/Ow
        gsmIIYnQSMWBsH8xR9bDwcy+IZiBArXPIS8vNqJ1avRztXaC0PNi2ouMvK+w4ldg
        vfd3VFvjwKZgjiAg+jSQXBkNhNbhw6XTzd/PMKxPVrpTnOlOIFECvcfC3naJoyOw
        ==
X-ME-Sender: <xms:dF9YYMtWmiVqNEq4M91y5JQbs39E8CE6NxxGGxlRIqtmDTvoN3JG6w>
    <xme:dF9YYJdyywEnLHzibQCrxLu3I0UIx-jweVSMjsbmxVkD7knhONNSTUvMO9pIm3pBt
    uUKJ0mRhO0V9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttdflne
    cuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgqeen
    ucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekgeefle
    egieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:dF9YYHzMJxmA0YuRW7dzlb1czwfX1F7C3XePdxQ1BOCpI0I-qQJDeA>
    <xmx:dF9YYPPk3MbeIjsYp1mItPE9bhcgVRiVm2LXageD5FZ_XkB_RrOjMw>
    <xmx:dF9YYM-RByhipTSSiIzMAJxmEumDQhoDyhZLisvebOqIT7tIZmeDdQ>
    <xmx:dV9YYKl7IvS3j-BwWrpdsvUCFmYTBgTcHCQgEkLjA_4ZX5pFOBl7Qwfwj4U>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6B961240426;
        Mon, 22 Mar 2021 05:12:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] counter: stm32-timer-cnt: fix ceiling miss-alignment with" failed to apply to 5.4-stable tree
To:     fabrice.gasnier@foss.st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, vilhelm.gray@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Mar 2021 10:12:18 +0100
Message-ID: <161640433820229@kroah.com>
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

From b14d72ac731753708a7c1a6b3657b9312b6f0042 Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Date: Wed, 3 Mar 2021 18:49:49 +0100
Subject: [PATCH] counter: stm32-timer-cnt: fix ceiling miss-alignment with
 reload register

Ceiling value may be miss-aligned with what's actually configured into the
ARR register. This is seen after probe as currently the ARR value is zero,
whereas ceiling value is set to the maximum. So:
- reading ceiling reports zero
- in case the counter gets enabled without any prior configuration,
  it won't count.
- in case the function gets set by the user 1st, (priv->ceiling) is used.

Fix it by getting rid of the cached "priv->ceiling" variable. Rather use
the ARR register value directly by using regmap read or write when needed.
There should be no drawback on performance as priv->ceiling isn't used in
performance critical path.
There's also no point in writing ARR while setting function (sms), so
it can be safely removed.

Fixes: ad29937e206f ("counter: Add STM32 Timer quadrature encoder")
Suggested-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Acked-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1614793789-10346-1-git-send-email-fabrice.gasnier@foss.st.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/counter/stm32-timer-cnt.c b/drivers/counter/stm32-timer-cnt.c
index 2295be3f309a..75bc401fdd18 100644
--- a/drivers/counter/stm32-timer-cnt.c
+++ b/drivers/counter/stm32-timer-cnt.c
@@ -31,7 +31,6 @@ struct stm32_timer_cnt {
 	struct counter_device counter;
 	struct regmap *regmap;
 	struct clk *clk;
-	u32 ceiling;
 	u32 max_arr;
 	bool enabled;
 	struct stm32_timer_regs bak;
@@ -75,8 +74,10 @@ static int stm32_count_write(struct counter_device *counter,
 			     const unsigned long val)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
+	u32 ceiling;
 
-	if (val > priv->ceiling)
+	regmap_read(priv->regmap, TIM_ARR, &ceiling);
+	if (val > ceiling)
 		return -EINVAL;
 
 	return regmap_write(priv->regmap, TIM_CNT, val);
@@ -138,10 +139,6 @@ static int stm32_count_function_set(struct counter_device *counter,
 
 	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_CEN, 0);
 
-	/* TIMx_ARR register shouldn't be buffered (ARPE=0) */
-	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, 0);
-	regmap_write(priv->regmap, TIM_ARR, priv->ceiling);
-
 	regmap_update_bits(priv->regmap, TIM_SMCR, TIM_SMCR_SMS, sms);
 
 	/* Make sure that registers are updated */
@@ -199,7 +196,6 @@ static ssize_t stm32_count_ceiling_write(struct counter_device *counter,
 	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, 0);
 	regmap_write(priv->regmap, TIM_ARR, ceiling);
 
-	priv->ceiling = ceiling;
 	return len;
 }
 
@@ -374,7 +370,6 @@ static int stm32_timer_cnt_probe(struct platform_device *pdev)
 
 	priv->regmap = ddata->regmap;
 	priv->clk = ddata->clk;
-	priv->ceiling = ddata->max_arr;
 	priv->max_arr = ddata->max_arr;
 
 	priv->counter.name = dev_name(dev);

