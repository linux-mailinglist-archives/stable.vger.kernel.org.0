Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034F3502950
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 14:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240824AbiDOMDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 08:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352925AbiDOMDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 08:03:13 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC29948E45
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 04:59:59 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m33-20020a05600c3b2100b0038ec0218103so4908433wms.3
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 04:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uyhcCx6yj8rjxb6a42YESztMokSP0tWlkBSMt8gW5Ow=;
        b=tdnhFnBX6qS2mTFAwfjMwaXKe4UZ3lRuPcgDGDVexws0JgIGdxWDmWkZiuBI3C4ibI
         dCpea726QjZh3DQSLEMBH9F5MlkdRRaYPTnyNKduv3UwKHzze4jc1FOwleDwrvP2Iutb
         ejLHGejj5fGwk+jLmV19Z45X+ETbw6LLkR+m+mV1M58ScRkac0yyVGyNEWcOiRo3QiCy
         zeU6E0PiqId7M0hPjx1ls5lk768SkqSD82R4kKvGbxdZayef8tFZApx3G+3K3Dx6H76J
         +00MegbyeSmm4UqrB3GdpobylmX9rg+m1LmKGp03Mvdu8sfq+j5A0p9ODshv4GHp88XU
         0WAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uyhcCx6yj8rjxb6a42YESztMokSP0tWlkBSMt8gW5Ow=;
        b=NU0nuDdvhn6lTGBKIscSIKdFgnJ/uLvdj/VKzUc8QnRNryn3npaSJW16iUaUrDzZKy
         TnNmYBuMVVC9a8cQp+T6DRmTs3y/eV3DCm+GWF6GeLylIiG3NEE8QewcU5pwxQr/doU4
         7DaQIRL9HproneMIAjas1n9yaQCYoksHHnIJOuVN2gvqnSmDAAU3hDuRb4HJKbEs4RWU
         eRID6guOxRVWQ4LypHj3hSXNyStG5PdLgx2zEjgpMVoUn6RUqgfCN7Mlu8o92u+BP/ad
         BlaU0PSajQSbTQaLpcYeJV0FoB6a9sLIb32DzZJ53vYYrAvKJgiHXrn4cAZRXZdRHhkD
         Bnxw==
X-Gm-Message-State: AOAM531G2/4chiuETVLsU8v53vD50espOAxGowlY4QgbAcpyiyd61OYB
        BcSmul/hDSMEQHmijBSxMqZElg==
X-Google-Smtp-Source: ABdhPJzG7CULNtuZz0PT2UdSsywjt2yheHKLf8RXO8Sojc1D4/EAWNozAB179tMXPw4/DVVaUyCvfg==
X-Received: by 2002:a7b:c844:0:b0:37b:b986:7726 with SMTP id c4-20020a7bc844000000b0037bb9867726mr3228116wml.160.1650023998511;
        Fri, 15 Apr 2022 04:59:58 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id bg8-20020a05600c3c8800b0038e4c5967besm5328568wmb.3.2022.04.15.04.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 04:59:58 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     sakari.ailus@iki.fi, jacopo@jmondi.org, paul.j.murphy@intel.com,
        daniele.alessandrelli@intel.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     robert.foss@linaro.org, hfink@snap.com, jgrahsl@snap.com,
        dmitry.baryshkov@linaro.org, vladimir.zapolskiy@linaro.org,
        bryan.odonoghue@linaro.org, stable@vger.kernel.org
Subject: [PATCH v5 1/4] media: i2c: imx412: Fix reset GPIO polarity
Date:   Fri, 15 Apr 2022 12:59:51 +0100
Message-Id: <20220415115954.1649217-2-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415115954.1649217-1-bryan.odonoghue@linaro.org>
References: <20220415115954.1649217-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The imx412/imx577 sensor has a reset line that is active low not active
high. Currently the logic for this is inverted.

The right way to define the reset line is to declare it active low in the
DTS and invert the logic currently contained in the driver.

The DTS should represent the hardware does i.e. reset is active low.
So:
+               reset-gpios = <&tlmm 78 GPIO_ACTIVE_LOW>;
not:
-               reset-gpios = <&tlmm 78 GPIO_ACTIVE_HIGH>;

I was a bit reticent about changing this logic since I thought it might
negatively impact @intel.com users. Googling a bit though I believe this
sensor is used on "Keem Bay" which is clearly a DTS based system and is not
upstream yet.

Fixes: 9214e86c0cc1 ("media: i2c: Add imx412 camera sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/media/i2c/imx412.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/imx412.c b/drivers/media/i2c/imx412.c
index be3f6ea55559..e6be6b4250f5 100644
--- a/drivers/media/i2c/imx412.c
+++ b/drivers/media/i2c/imx412.c
@@ -1011,7 +1011,7 @@ static int imx412_power_on(struct device *dev)
 	struct imx412 *imx412 = to_imx412(sd);
 	int ret;
 
-	gpiod_set_value_cansleep(imx412->reset_gpio, 1);
+	gpiod_set_value_cansleep(imx412->reset_gpio, 0);
 
 	ret = clk_prepare_enable(imx412->inclk);
 	if (ret) {
@@ -1024,7 +1024,7 @@ static int imx412_power_on(struct device *dev)
 	return 0;
 
 error_reset:
-	gpiod_set_value_cansleep(imx412->reset_gpio, 0);
+	gpiod_set_value_cansleep(imx412->reset_gpio, 1);
 
 	return ret;
 }
@@ -1040,7 +1040,7 @@ static int imx412_power_off(struct device *dev)
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct imx412 *imx412 = to_imx412(sd);
 
-	gpiod_set_value_cansleep(imx412->reset_gpio, 0);
+	gpiod_set_value_cansleep(imx412->reset_gpio, 1);
 
 	clk_disable_unprepare(imx412->inclk);
 
-- 
2.35.1

