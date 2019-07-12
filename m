Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 865C566977
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 10:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfGLI6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 04:58:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55643 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbfGLI6G (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 12 Jul 2019 04:58:06 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 74E9F222E7;
        Fri, 12 Jul 2019 04:58:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 12 Jul 2019 04:58:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1X2UFY
        eBGNYanYHRO4XIMBq5hzck2ZBwP/NCJucx8dc=; b=V9B+taZAwEB828lx1jS5u2
        owPn1TeC83CtKcduBqE9Il5tIvLg8qRBRHtuvntvLzaMv9/DNAApageOT7YtxEPj
        eWGTnJ6TDEf0V6SD3tdr1XPAeaxayh+3DQd2UZV/gZGYXNqfmASZLoCX069Ehh4M
        9szGvZgrHG0jta871+SevafDapNqpIDHSfbeSYyvVraQOSUf2YWDSnrdsBPzR57v
        CynAQuFe3/tsSsuDpkG5EtjnT7hEP2JBn5ILWqYVYiwxrRoySRX29plqNGcThbVX
        fBbLcUrI55kM5QksI64Ngc7Nad3q3KtligJGTtP0V3Ryj3bfRN1a0BN6qGOocDXw
        ==
X-ME-Sender: <xms:nEsoXQ7JikkVvv8kyzjuBedZaH4Rm5p4xdwonguuUNFOrgVm9qIiIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrhedtgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:nEsoXSLkQ0hbgOwCeg3SkP-C43ohjHeRpbAoxdMt-oIl86Ee_21bUg>
    <xmx:nEsoXYVhZQmxiBqruNZm-jdZz4JIQgEp8BFElb7gaUZ2LlJc5si0PQ>
    <xmx:nEsoXZDo0YRwPPs1TzRM64yRQSfBDmdRkuEU_gbk9Ff_u9cX6VUKjw>
    <xmx:nUsoXQTAVN33eEkgvMQGy6Mcgbkm4LVQ4IfsVA22CsIYbnQAC3GYkw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 37870380076;
        Fri, 12 Jul 2019 04:58:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: adc: stm32-adc: add missing vdda-supply" failed to apply to 4.14-stable tree
To:     fabrice.gasnier@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Jul 2019 10:58:02 +0200
Message-ID: <1562921882143104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

