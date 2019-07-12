Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7ABD66978
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 10:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbfGLI6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 04:58:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46147 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbfGLI6N (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 12 Jul 2019 04:58:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 049D62224E;
        Fri, 12 Jul 2019 04:58:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 12 Jul 2019 04:58:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=aH2GSX
        3SidOvKOaTovgSBImWJz7I6qxXds/3mutrJJk=; b=1PTFCGao/1rbpUIhoTExg/
        RUrUyOfGtR0szf9JKBPS+Qo7bmsiEQ0m4nZeSUhSdV2F7Gu/H3F8LxQhOkMXHosh
        2cdVlLkM0J59vqjEOjBOuVbkfWWJYi+XkdQzYwVh3K4gn2Na1Y3JYG36DGj2FARH
        cgQOJxhuWfbfIbi8PSM7+VDCEcaS2QoQ3azjmaX7DZ9MrR1vx82uAv8rKGgZbVuG
        vI1JjwYtMMd3si26+4UHYFwUWUpiKLYi8dX1Hb1YhRk48Y+5B8Chy4U9o+WcZM12
        5YkQ5CEOEBxKSyVspi7RzcXKGb7rCO2YsVhIaF40D7cgMSTK2/ao/5CmvBWoKp/w
        ==
X-ME-Sender: <xms:pEsoXewlaLmqZnQM7owu0bSTa2kLyk1-7fGKQHSvh_fT3yITTrfCOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrhedtgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:pEsoXWkapeIjSycneOWa5VBYbvMaMQvqgvbT1VDvZLzuOqYDgUF49A>
    <xmx:pEsoXTGe0UvwAKRSo1UwB-zfPwQSn2S6ONhQ26oS4QxLmftTFKr7Lw>
    <xmx:pEsoXWUAIMh88y7tDOs7oAlCqc5Q6ItBspxRcvWzZkfiPiXqB0wNvw>
    <xmx:pEsoXUTQhFKA9OyPMop_81_f1TegCt0TNvs6N0And_UB9KZ_N_ELpw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6A3C880060;
        Fri, 12 Jul 2019 04:58:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: adc: stm32-adc: add missing vdda-supply" failed to apply to 4.19-stable tree
To:     fabrice.gasnier@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Jul 2019 10:58:02 +0200
Message-ID: <156292188238246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 7685010fca2ba0284f31fd1380df3cffc96d847e Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@st.com>
Date: Wed, 19 Jun 2019 14:29:55 +0200
Subject: [PATCH] iio: adc: stm32-adc: add missing vdda-supply

Add missing vdda-supply, analog power supply, to STM32 ADC. When vdda is
an independent supply, it needs to be properly turned on or off to supply
the ADC.

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Fixes: 1add69880240 ("iio: adc: Add support for STM32 ADC core").
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/stm32-adc-core.c b/drivers/iio/adc/stm32-adc-core.c
index 2327ec18b40c..1f7ce5186dfc 100644
--- a/drivers/iio/adc/stm32-adc-core.c
+++ b/drivers/iio/adc/stm32-adc-core.c
@@ -87,6 +87,7 @@ struct stm32_adc_priv_cfg {
  * @domain:		irq domain reference
  * @aclk:		clock reference for the analog circuitry
  * @bclk:		bus clock common for all ADCs, depends on part used
+ * @vdda:		vdda analog supply reference
  * @vref:		regulator reference
  * @cfg:		compatible configuration data
  * @common:		common data for all ADC instances
@@ -97,6 +98,7 @@ struct stm32_adc_priv {
 	struct irq_domain		*domain;
 	struct clk			*aclk;
 	struct clk			*bclk;
+	struct regulator		*vdda;
 	struct regulator		*vref;
 	const struct stm32_adc_priv_cfg	*cfg;
 	struct stm32_adc_common		common;
@@ -394,10 +396,16 @@ static int stm32_adc_core_hw_start(struct device *dev)
 	struct stm32_adc_priv *priv = to_stm32_adc_priv(common);
 	int ret;
 
+	ret = regulator_enable(priv->vdda);
+	if (ret < 0) {
+		dev_err(dev, "vdda enable failed %d\n", ret);
+		return ret;
+	}
+
 	ret = regulator_enable(priv->vref);
 	if (ret < 0) {
 		dev_err(dev, "vref enable failed\n");
-		return ret;
+		goto err_vdda_disable;
 	}
 
 	if (priv->bclk) {
@@ -425,6 +433,8 @@ static int stm32_adc_core_hw_start(struct device *dev)
 		clk_disable_unprepare(priv->bclk);
 err_regulator_disable:
 	regulator_disable(priv->vref);
+err_vdda_disable:
+	regulator_disable(priv->vdda);
 
 	return ret;
 }
@@ -441,6 +451,7 @@ static void stm32_adc_core_hw_stop(struct device *dev)
 	if (priv->bclk)
 		clk_disable_unprepare(priv->bclk);
 	regulator_disable(priv->vref);
+	regulator_disable(priv->vdda);
 }
 
 static int stm32_adc_probe(struct platform_device *pdev)
@@ -468,6 +479,14 @@ static int stm32_adc_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->common.base);
 	priv->common.phys_base = res->start;
 
+	priv->vdda = devm_regulator_get(&pdev->dev, "vdda");
+	if (IS_ERR(priv->vdda)) {
+		ret = PTR_ERR(priv->vdda);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "vdda get failed, %d\n", ret);
+		return ret;
+	}
+
 	priv->vref = devm_regulator_get(&pdev->dev, "vref");
 	if (IS_ERR(priv->vref)) {
 		ret = PTR_ERR(priv->vref);

