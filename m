Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5361F18B1
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 14:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgFHMZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 08:25:03 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51059 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729628AbgFHMZD (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 8 Jun 2020 08:25:03 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 3A794596;
        Mon,  8 Jun 2020 08:25:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 08 Jun 2020 08:25:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vIkcdP
        qP7mNBiSbq/Wn42FLErkxu28Q/GhkQwsB85HA=; b=MDbPu9HHjhLNqbI8PF3evX
        wU8B6WOdL7DBz2ZZdT2/GAk3xDRLvvVAw2A8CjHlTSpXsmgz1C+FCHJRK3YsktB+
        0AmKVnz5wljR3BXUJ147NZU4RpGOCrrcag+eebk7pQp5OqMbiQk/kYRFvWIj4wLQ
        Wg+/LEU01qkxeGDNkfzKcQPXIh028VPrsPIgaNnVp8ObZMMs8sgS++DSk5V3lA1g
        m6X/QWQtT8YR3gAprPrc3hNjsPH6WKRnE1EJ8dG2TEkh3DcJtnPHr5NpjDtjEd8b
        BWDNX2JpfukRaNXORJeixAQNTel8twQCoyvcuTPA0jlJOGuv5h506AgAJHLxSxIQ
        ==
X-ME-Sender: <xms:HS7eXhxi5xCFn9_AtgwtA8njkWeZl41HfcFxglwthvuNZy-xfkpHmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudehuddgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:HS7eXhQKcBYoDKUfD_xjIxFZgpIXywAhtIdRKFOGZoEfKcDzlyeJRg>
    <xmx:HS7eXrWaktB_l7VkT34xOE-tjCUPeju0nKqSZw2DAsAOeRkwNjecYw>
    <xmx:HS7eXjjpKV_lNuUpn_MROfnnZfsykRZ_rDfWe7HuIfBxBmSpECuuKw>
    <xmx:HS7eXm_rW8tQuYiJE-oyVTkrYKQtC3TvCMrIsh9xINdV99otaPvwLQq4GoY>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3B4243060F09;
        Mon,  8 Jun 2020 08:25:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: adc: stm32-adc: fix a wrong error message when probing" failed to apply to 4.19-stable tree
To:     fabrice.gasnier@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Jun 2020 14:25:00 +0200
Message-ID: <1591619100221166@kroah.com>
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

From 10134ec3f8cefa6a40fe84987f1795e9e0da9715 Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@st.com>
Date: Tue, 12 May 2020 15:27:05 +0200
Subject: [PATCH] iio: adc: stm32-adc: fix a wrong error message when probing
 interrupts

A wrong error message is printed out currently, like on STM32MP15:
- stm32-adc-core 48003000.adc: IRQ index 2 not found.

This is seen since commit 7723f4c5ecdb ("driver core: platform: Add an
error message to platform_get_irq*()").
The STM32 ADC core driver wrongly requests up to 3 interrupt lines. It
should request only the necessary IRQs, based on the compatible:
- stm32f4/h7 ADCs share a common interrupt
- stm32mp1, has one interrupt line per ADC.
So add the number of required interrupts to the compatible data.

Fixes: d58c67d1d851 ("iio: adc: stm32-adc: add support for STM32MP1")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/stm32-adc-core.c b/drivers/iio/adc/stm32-adc-core.c
index 2df88d2b880a..0e2068ec068b 100644
--- a/drivers/iio/adc/stm32-adc-core.c
+++ b/drivers/iio/adc/stm32-adc-core.c
@@ -65,12 +65,14 @@ struct stm32_adc_priv;
  * @clk_sel:	clock selection routine
  * @max_clk_rate_hz: maximum analog clock rate (Hz, from datasheet)
  * @has_syscfg: SYSCFG capability flags
+ * @num_irqs:	number of interrupt lines
  */
 struct stm32_adc_priv_cfg {
 	const struct stm32_adc_common_regs *regs;
 	int (*clk_sel)(struct platform_device *, struct stm32_adc_priv *);
 	u32 max_clk_rate_hz;
 	unsigned int has_syscfg;
+	unsigned int num_irqs;
 };
 
 /**
@@ -375,21 +377,15 @@ static int stm32_adc_irq_probe(struct platform_device *pdev,
 	struct device_node *np = pdev->dev.of_node;
 	unsigned int i;
 
-	for (i = 0; i < STM32_ADC_MAX_ADCS; i++) {
+	/*
+	 * Interrupt(s) must be provided, depending on the compatible:
+	 * - stm32f4/h7 shares a common interrupt line.
+	 * - stm32mp1, has one line per ADC
+	 */
+	for (i = 0; i < priv->cfg->num_irqs; i++) {
 		priv->irq[i] = platform_get_irq(pdev, i);
-		if (priv->irq[i] < 0) {
-			/*
-			 * At least one interrupt must be provided, make others
-			 * optional:
-			 * - stm32f4/h7 shares a common interrupt.
-			 * - stm32mp1, has one line per ADC (either for ADC1,
-			 *   ADC2 or both).
-			 */
-			if (i && priv->irq[i] == -ENXIO)
-				continue;
-
+		if (priv->irq[i] < 0)
 			return priv->irq[i];
-		}
 	}
 
 	priv->domain = irq_domain_add_simple(np, STM32_ADC_MAX_ADCS, 0,
@@ -400,9 +396,7 @@ static int stm32_adc_irq_probe(struct platform_device *pdev,
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < STM32_ADC_MAX_ADCS; i++) {
-		if (priv->irq[i] < 0)
-			continue;
+	for (i = 0; i < priv->cfg->num_irqs; i++) {
 		irq_set_chained_handler(priv->irq[i], stm32_adc_irq_handler);
 		irq_set_handler_data(priv->irq[i], priv);
 	}
@@ -420,11 +414,8 @@ static void stm32_adc_irq_remove(struct platform_device *pdev,
 		irq_dispose_mapping(irq_find_mapping(priv->domain, hwirq));
 	irq_domain_remove(priv->domain);
 
-	for (i = 0; i < STM32_ADC_MAX_ADCS; i++) {
-		if (priv->irq[i] < 0)
-			continue;
+	for (i = 0; i < priv->cfg->num_irqs; i++)
 		irq_set_chained_handler(priv->irq[i], NULL);
-	}
 }
 
 static int stm32_adc_core_switches_supply_en(struct stm32_adc_priv *priv,
@@ -817,6 +808,7 @@ static const struct stm32_adc_priv_cfg stm32f4_adc_priv_cfg = {
 	.regs = &stm32f4_adc_common_regs,
 	.clk_sel = stm32f4_adc_clk_sel,
 	.max_clk_rate_hz = 36000000,
+	.num_irqs = 1,
 };
 
 static const struct stm32_adc_priv_cfg stm32h7_adc_priv_cfg = {
@@ -824,6 +816,7 @@ static const struct stm32_adc_priv_cfg stm32h7_adc_priv_cfg = {
 	.clk_sel = stm32h7_adc_clk_sel,
 	.max_clk_rate_hz = 36000000,
 	.has_syscfg = HAS_VBOOSTER,
+	.num_irqs = 1,
 };
 
 static const struct stm32_adc_priv_cfg stm32mp1_adc_priv_cfg = {
@@ -831,6 +824,7 @@ static const struct stm32_adc_priv_cfg stm32mp1_adc_priv_cfg = {
 	.clk_sel = stm32h7_adc_clk_sel,
 	.max_clk_rate_hz = 40000000,
 	.has_syscfg = HAS_VBOOSTER | HAS_ANASWVDD,
+	.num_irqs = 2,
 };
 
 static const struct of_device_id stm32_adc_of_match[] = {

