Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC443558F4
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 18:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346230AbhDFQO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 12:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbhDFQO2 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 6 Apr 2021 12:14:28 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AD7C06174A
        for <Stable@vger.kernel.org>; Tue,  6 Apr 2021 09:14:20 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so1334133wma.0
        for <Stable@vger.kernel.org>; Tue, 06 Apr 2021 09:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=czQ+fqcx2AjcQfoAVfmxUb492TPnervK5oWQa/WM/ls=;
        b=ZbrSRxKtbQLRzVC680BP1P7wgL2/jXvzyK6+nXNikPLgwZMnJBEgq4o3spOsHT/P3f
         Oi/UdBUuR15enFgdbfhm7L/61heN1BZrOE37e7ABS4Pc1+f7wOmrBjXCa5o68eEdY/J6
         sS6RnzYufaPRRXH/feXiAaZ4ePsPUxcYbhP0PmC2XajZKRiXaWFzXZpOE2XojYLwglAG
         4r1R8Sc8vF+oR5j7j1eJmAI5EzP99pgf1ZN+q+Bi+lsLNoE9Olx4AR7zZTWcmq99HtfH
         LTp2ofe6ZV5kcuOXHv7Hc/E1kx6MeZj6AaVhcCeJwC2g4hkaZV+J6rcbsEPWIi+yPUc+
         mYkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=czQ+fqcx2AjcQfoAVfmxUb492TPnervK5oWQa/WM/ls=;
        b=oQRQKgKQZQ3vQTLdkRpOT2dTiWHThBzxoU3XhXTaY45IDkcxtZ/qA/2PgCutRQMH3s
         AXfavKc+lh0yaUSZln0CvlEXw8y3ZmV7LhyVBOwDHGQZOWh+/MoENl5MngIRN6wYu+zR
         vsacI5+WCNynvLA4NqA70lu/I4HjfmXn2Q+zxb2F6fq0fP050GVehxCEtdzWcPoKaI8d
         w7UmaQjeTQD/U5C41srb4g6ADY7JmBTA3nm5JwMZ8O0PPxI5UdfwLEJ/0R6vP0LCl74b
         p7zzR/FLcdLQ+HSLCuBPuZiuC9R4s3Gb8R9UKUwsNzn9ZHVJYGk2pCwh/EyyqtD5lI4n
         Nsjg==
X-Gm-Message-State: AOAM531hhiqUH7WQ/PGMn3+KHOjrq2aMwfDVet0RyeK4jtvGzbjITJJK
        am88ey+1iOyVvcxBgId1wtxyy5GtYVWLzw==
X-Google-Smtp-Source: ABdhPJwRYbWOEiSSXQu4s4ZN7NoP6NpnGGNO4ftZUPOawxLRRkYosrNyercvSHZqdCSyA8Ts7f39KQ==
X-Received: by 2002:a1c:7e82:: with SMTP id z124mr4942939wmc.51.1617725658943;
        Tue, 06 Apr 2021 09:14:18 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id q14sm12583693wrg.64.2021.04.06.09.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 09:14:18 -0700 (PDT)
Date:   Tue, 6 Apr 2021 17:14:16 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     fabrice.gasnier@foss.st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, vilhelm.gray@gmail.com
Subject: Re: FAILED: patch "[PATCH] counter: stm32-timer-cnt: fix ceiling
 miss-alignment with" failed to apply to 5.4-stable tree
Message-ID: <YGyI2ICCPj2AJl9a@debian>
References: <161640433820229@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="edMSirGJ3hWm72Ia"
Content-Disposition: inline
In-Reply-To: <161640433820229@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--edMSirGJ3hWm72Ia
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Mar 22, 2021 at 10:12:18AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the bakport.


--
Regards
Sudip

--edMSirGJ3hWm72Ia
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-counter-stm32-timer-cnt-fix-ceiling-miss-alignment-w.patch"

From 90f7d51d99c6ebe7e5eb925da018653846eb05bd Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Date: Wed, 3 Mar 2021 18:49:49 +0100
Subject: [PATCH] counter: stm32-timer-cnt: fix ceiling miss-alignment with
 reload register

commit b14d72ac731753708a7c1a6b3657b9312b6f0042 upstream

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
[sudip: adjuct context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/counter/stm32-timer-cnt.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/counter/stm32-timer-cnt.c b/drivers/counter/stm32-timer-cnt.c
index 75e08a98d09b..889ea7a6ed63 100644
--- a/drivers/counter/stm32-timer-cnt.c
+++ b/drivers/counter/stm32-timer-cnt.c
@@ -24,7 +24,6 @@ struct stm32_timer_cnt {
 	struct counter_device counter;
 	struct regmap *regmap;
 	struct clk *clk;
-	u32 ceiling;
 	u32 max_arr;
 };
 
@@ -67,14 +66,15 @@ static int stm32_count_write(struct counter_device *counter,
 			     struct counter_count_write_value *val)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
-	u32 cnt;
+	u32 cnt, ceiling;
 	int err;
 
 	err = counter_count_write_value_get(&cnt, COUNTER_COUNT_POSITION, val);
 	if (err)
 		return err;
 
-	if (cnt > priv->ceiling)
+	regmap_read(priv->regmap, TIM_ARR, &ceiling);
+	if (cnt > ceiling)
 		return -EINVAL;
 
 	return regmap_write(priv->regmap, TIM_CNT, cnt);
@@ -136,10 +136,6 @@ static int stm32_count_function_set(struct counter_device *counter,
 
 	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_CEN, 0);
 
-	/* TIMx_ARR register shouldn't be buffered (ARPE=0) */
-	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, 0);
-	regmap_write(priv->regmap, TIM_ARR, priv->ceiling);
-
 	regmap_update_bits(priv->regmap, TIM_SMCR, TIM_SMCR_SMS, sms);
 
 	/* Make sure that registers are updated */
@@ -197,7 +193,6 @@ static ssize_t stm32_count_ceiling_write(struct counter_device *counter,
 	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, 0);
 	regmap_write(priv->regmap, TIM_ARR, ceiling);
 
-	priv->ceiling = ceiling;
 	return len;
 }
 
@@ -369,7 +364,6 @@ static int stm32_timer_cnt_probe(struct platform_device *pdev)
 
 	priv->regmap = ddata->regmap;
 	priv->clk = ddata->clk;
-	priv->ceiling = ddata->max_arr;
 	priv->max_arr = ddata->max_arr;
 
 	priv->counter.name = dev_name(dev);
-- 
2.30.2


--edMSirGJ3hWm72Ia--
