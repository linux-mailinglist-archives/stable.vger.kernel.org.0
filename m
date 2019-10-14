Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F08BD65C3
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 17:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733155AbfJNPCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 11:02:24 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:54061 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732968AbfJNPCX (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 14 Oct 2019 11:02:23 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 423C0926;
        Mon, 14 Oct 2019 11:02:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 14 Oct 2019 11:02:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Vhezoo
        pYRzi1jl31R7qZ2CLKtxV6hgSi9fjdKFhgXhg=; b=g6ZBL9cKDiu28MqqtXxbWQ
        QPma6z+cnac6MhJviUUJFkWwr1wqTqu5Q2aNLrrJbBQ8GRYBlAC8Hp2kMt629Qt7
        sTak944BDJYNlKAoYiBc2VK4rnaUBsNvYTzWzQE2IdnWzLfP7jNLDdoXqcZxioLi
        PGNLy+XPX1Ttu98YyAzBqbExCemw5bFEbLKLt3OFgH5c7ONVX9elwlrKVYCLbKTQ
        950Olhs/cTxFjVGxPFd4j42/gVZ8yaspE1upermDKMNRGZw0XFV3c9W6tY4F6eY4
        xHJKfQJBtQBDbeNRt3SbPGDY5gm2pMISD6AnOquZsruChLqwpVxm6/1V7GaoWOfg
        ==
X-ME-Sender: <xms:_Y2kXRWurdQ8MaG2QdCHqNMFMk4TAUnTSXTraB6wDeEGF-wZMmNDpg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedugdekhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:_Y2kXSCTVI96zRtfe0Tklmtu8ujKLYLpC72yzAapvOH9hZRFWg1bQw>
    <xmx:_Y2kXUSngz-krfldLH4f4k8UNDz_uBvVuIRDkB3uWidlvvX3UdXrMQ>
    <xmx:_Y2kXam_GNUDKzrba75Fa2X_J817Myh5TSkN1EXfrFm9lV-k6a2g5A>
    <xmx:_Y2kXQvGTAlWMO-_XHJu9joNiTjuN0X6UBdQ-QbvEMr7Pvtu4WhW9w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 963BB80063;
        Mon, 14 Oct 2019 11:02:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: adc: stm32-adc: move registers definitions" failed to apply to 4.14-stable tree
To:     fabrice.gasnier@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Oct 2019 17:02:19 +0200
Message-ID: <1571065339180103@kroah.com>
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

From 31922f62bb527d749b99dbc776e514bcba29b7fe Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@st.com>
Date: Tue, 17 Sep 2019 14:38:15 +0200
Subject: [PATCH] iio: adc: stm32-adc: move registers definitions

Move STM32 ADC registers definitions to common header.
This is precursor patch to:
- iio: adc: stm32-adc: fix a race when using several adcs with dma and irq

It keeps registers definitions as a whole block, to ease readability and
allow simple access path to EOC bits (readl) in stm32-adc-core driver.

Fixes: 2763ea0585c9 ("iio: adc: stm32: add optional dma support")

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/stm32-adc-core.c b/drivers/iio/adc/stm32-adc-core.c
index 9b85fefc0a96..84ac326bb714 100644
--- a/drivers/iio/adc/stm32-adc-core.c
+++ b/drivers/iio/adc/stm32-adc-core.c
@@ -24,33 +24,6 @@
 
 #include "stm32-adc-core.h"
 
-/* STM32F4 - common registers for all ADC instances: 1, 2 & 3 */
-#define STM32F4_ADC_CSR			(STM32_ADCX_COMN_OFFSET + 0x00)
-#define STM32F4_ADC_CCR			(STM32_ADCX_COMN_OFFSET + 0x04)
-
-/* STM32F4_ADC_CSR - bit fields */
-#define STM32F4_EOC3			BIT(17)
-#define STM32F4_EOC2			BIT(9)
-#define STM32F4_EOC1			BIT(1)
-
-/* STM32F4_ADC_CCR - bit fields */
-#define STM32F4_ADC_ADCPRE_SHIFT	16
-#define STM32F4_ADC_ADCPRE_MASK		GENMASK(17, 16)
-
-/* STM32H7 - common registers for all ADC instances */
-#define STM32H7_ADC_CSR			(STM32_ADCX_COMN_OFFSET + 0x00)
-#define STM32H7_ADC_CCR			(STM32_ADCX_COMN_OFFSET + 0x08)
-
-/* STM32H7_ADC_CSR - bit fields */
-#define STM32H7_EOC_SLV			BIT(18)
-#define STM32H7_EOC_MST			BIT(2)
-
-/* STM32H7_ADC_CCR - bit fields */
-#define STM32H7_PRESC_SHIFT		18
-#define STM32H7_PRESC_MASK		GENMASK(21, 18)
-#define STM32H7_CKMODE_SHIFT		16
-#define STM32H7_CKMODE_MASK		GENMASK(17, 16)
-
 #define STM32_ADC_CORE_SLEEP_DELAY_MS	2000
 
 /* SYSCFG registers */
diff --git a/drivers/iio/adc/stm32-adc-core.h b/drivers/iio/adc/stm32-adc-core.h
index 8af507b3f32d..94aa2d2577dc 100644
--- a/drivers/iio/adc/stm32-adc-core.h
+++ b/drivers/iio/adc/stm32-adc-core.h
@@ -27,6 +27,142 @@
 #define STM32_ADC_MAX_ADCS		3
 #define STM32_ADCX_COMN_OFFSET		0x300
 
+/* STM32F4 - Registers for each ADC instance */
+#define STM32F4_ADC_SR			0x00
+#define STM32F4_ADC_CR1			0x04
+#define STM32F4_ADC_CR2			0x08
+#define STM32F4_ADC_SMPR1		0x0C
+#define STM32F4_ADC_SMPR2		0x10
+#define STM32F4_ADC_HTR			0x24
+#define STM32F4_ADC_LTR			0x28
+#define STM32F4_ADC_SQR1		0x2C
+#define STM32F4_ADC_SQR2		0x30
+#define STM32F4_ADC_SQR3		0x34
+#define STM32F4_ADC_JSQR		0x38
+#define STM32F4_ADC_JDR1		0x3C
+#define STM32F4_ADC_JDR2		0x40
+#define STM32F4_ADC_JDR3		0x44
+#define STM32F4_ADC_JDR4		0x48
+#define STM32F4_ADC_DR			0x4C
+
+/* STM32F4 - common registers for all ADC instances: 1, 2 & 3 */
+#define STM32F4_ADC_CSR			(STM32_ADCX_COMN_OFFSET + 0x00)
+#define STM32F4_ADC_CCR			(STM32_ADCX_COMN_OFFSET + 0x04)
+
+/* STM32F4_ADC_SR - bit fields */
+#define STM32F4_STRT			BIT(4)
+#define STM32F4_EOC			BIT(1)
+
+/* STM32F4_ADC_CR1 - bit fields */
+#define STM32F4_RES_SHIFT		24
+#define STM32F4_RES_MASK		GENMASK(25, 24)
+#define STM32F4_SCAN			BIT(8)
+#define STM32F4_EOCIE			BIT(5)
+
+/* STM32F4_ADC_CR2 - bit fields */
+#define STM32F4_SWSTART			BIT(30)
+#define STM32F4_EXTEN_SHIFT		28
+#define STM32F4_EXTEN_MASK		GENMASK(29, 28)
+#define STM32F4_EXTSEL_SHIFT		24
+#define STM32F4_EXTSEL_MASK		GENMASK(27, 24)
+#define STM32F4_EOCS			BIT(10)
+#define STM32F4_DDS			BIT(9)
+#define STM32F4_DMA			BIT(8)
+#define STM32F4_ADON			BIT(0)
+
+/* STM32F4_ADC_CSR - bit fields */
+#define STM32F4_EOC3			BIT(17)
+#define STM32F4_EOC2			BIT(9)
+#define STM32F4_EOC1			BIT(1)
+
+/* STM32F4_ADC_CCR - bit fields */
+#define STM32F4_ADC_ADCPRE_SHIFT	16
+#define STM32F4_ADC_ADCPRE_MASK		GENMASK(17, 16)
+
+/* STM32H7 - Registers for each ADC instance */
+#define STM32H7_ADC_ISR			0x00
+#define STM32H7_ADC_IER			0x04
+#define STM32H7_ADC_CR			0x08
+#define STM32H7_ADC_CFGR		0x0C
+#define STM32H7_ADC_SMPR1		0x14
+#define STM32H7_ADC_SMPR2		0x18
+#define STM32H7_ADC_PCSEL		0x1C
+#define STM32H7_ADC_SQR1		0x30
+#define STM32H7_ADC_SQR2		0x34
+#define STM32H7_ADC_SQR3		0x38
+#define STM32H7_ADC_SQR4		0x3C
+#define STM32H7_ADC_DR			0x40
+#define STM32H7_ADC_DIFSEL		0xC0
+#define STM32H7_ADC_CALFACT		0xC4
+#define STM32H7_ADC_CALFACT2		0xC8
+
+/* STM32H7 - common registers for all ADC instances */
+#define STM32H7_ADC_CSR			(STM32_ADCX_COMN_OFFSET + 0x00)
+#define STM32H7_ADC_CCR			(STM32_ADCX_COMN_OFFSET + 0x08)
+
+/* STM32H7_ADC_ISR - bit fields */
+#define STM32MP1_VREGREADY		BIT(12)
+#define STM32H7_EOC			BIT(2)
+#define STM32H7_ADRDY			BIT(0)
+
+/* STM32H7_ADC_IER - bit fields */
+#define STM32H7_EOCIE			STM32H7_EOC
+
+/* STM32H7_ADC_CR - bit fields */
+#define STM32H7_ADCAL			BIT(31)
+#define STM32H7_ADCALDIF		BIT(30)
+#define STM32H7_DEEPPWD			BIT(29)
+#define STM32H7_ADVREGEN		BIT(28)
+#define STM32H7_LINCALRDYW6		BIT(27)
+#define STM32H7_LINCALRDYW5		BIT(26)
+#define STM32H7_LINCALRDYW4		BIT(25)
+#define STM32H7_LINCALRDYW3		BIT(24)
+#define STM32H7_LINCALRDYW2		BIT(23)
+#define STM32H7_LINCALRDYW1		BIT(22)
+#define STM32H7_ADCALLIN		BIT(16)
+#define STM32H7_BOOST			BIT(8)
+#define STM32H7_ADSTP			BIT(4)
+#define STM32H7_ADSTART			BIT(2)
+#define STM32H7_ADDIS			BIT(1)
+#define STM32H7_ADEN			BIT(0)
+
+/* STM32H7_ADC_CFGR bit fields */
+#define STM32H7_EXTEN_SHIFT		10
+#define STM32H7_EXTEN_MASK		GENMASK(11, 10)
+#define STM32H7_EXTSEL_SHIFT		5
+#define STM32H7_EXTSEL_MASK		GENMASK(9, 5)
+#define STM32H7_RES_SHIFT		2
+#define STM32H7_RES_MASK		GENMASK(4, 2)
+#define STM32H7_DMNGT_SHIFT		0
+#define STM32H7_DMNGT_MASK		GENMASK(1, 0)
+
+enum stm32h7_adc_dmngt {
+	STM32H7_DMNGT_DR_ONLY,		/* Regular data in DR only */
+	STM32H7_DMNGT_DMA_ONESHOT,	/* DMA one shot mode */
+	STM32H7_DMNGT_DFSDM,		/* DFSDM mode */
+	STM32H7_DMNGT_DMA_CIRC,		/* DMA circular mode */
+};
+
+/* STM32H7_ADC_CALFACT - bit fields */
+#define STM32H7_CALFACT_D_SHIFT		16
+#define STM32H7_CALFACT_D_MASK		GENMASK(26, 16)
+#define STM32H7_CALFACT_S_SHIFT		0
+#define STM32H7_CALFACT_S_MASK		GENMASK(10, 0)
+
+/* STM32H7_ADC_CALFACT2 - bit fields */
+#define STM32H7_LINCALFACT_SHIFT	0
+#define STM32H7_LINCALFACT_MASK		GENMASK(29, 0)
+
+/* STM32H7_ADC_CSR - bit fields */
+#define STM32H7_EOC_SLV			BIT(18)
+#define STM32H7_EOC_MST			BIT(2)
+
+/* STM32H7_ADC_CCR - bit fields */
+#define STM32H7_PRESC_SHIFT		18
+#define STM32H7_PRESC_MASK		GENMASK(21, 18)
+#define STM32H7_CKMODE_SHIFT		16
+#define STM32H7_CKMODE_MASK		GENMASK(17, 16)
+
 /**
  * struct stm32_adc_common - stm32 ADC driver common data (for all instances)
  * @base:		control registers base cpu addr
diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index 6a7dd08b1e0b..663f8a5012d6 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -28,115 +28,6 @@
 
 #include "stm32-adc-core.h"
 
-/* STM32F4 - Registers for each ADC instance */
-#define STM32F4_ADC_SR			0x00
-#define STM32F4_ADC_CR1			0x04
-#define STM32F4_ADC_CR2			0x08
-#define STM32F4_ADC_SMPR1		0x0C
-#define STM32F4_ADC_SMPR2		0x10
-#define STM32F4_ADC_HTR			0x24
-#define STM32F4_ADC_LTR			0x28
-#define STM32F4_ADC_SQR1		0x2C
-#define STM32F4_ADC_SQR2		0x30
-#define STM32F4_ADC_SQR3		0x34
-#define STM32F4_ADC_JSQR		0x38
-#define STM32F4_ADC_JDR1		0x3C
-#define STM32F4_ADC_JDR2		0x40
-#define STM32F4_ADC_JDR3		0x44
-#define STM32F4_ADC_JDR4		0x48
-#define STM32F4_ADC_DR			0x4C
-
-/* STM32F4_ADC_SR - bit fields */
-#define STM32F4_STRT			BIT(4)
-#define STM32F4_EOC			BIT(1)
-
-/* STM32F4_ADC_CR1 - bit fields */
-#define STM32F4_RES_SHIFT		24
-#define STM32F4_RES_MASK		GENMASK(25, 24)
-#define STM32F4_SCAN			BIT(8)
-#define STM32F4_EOCIE			BIT(5)
-
-/* STM32F4_ADC_CR2 - bit fields */
-#define STM32F4_SWSTART			BIT(30)
-#define STM32F4_EXTEN_SHIFT		28
-#define STM32F4_EXTEN_MASK		GENMASK(29, 28)
-#define STM32F4_EXTSEL_SHIFT		24
-#define STM32F4_EXTSEL_MASK		GENMASK(27, 24)
-#define STM32F4_EOCS			BIT(10)
-#define STM32F4_DDS			BIT(9)
-#define STM32F4_DMA			BIT(8)
-#define STM32F4_ADON			BIT(0)
-
-/* STM32H7 - Registers for each ADC instance */
-#define STM32H7_ADC_ISR			0x00
-#define STM32H7_ADC_IER			0x04
-#define STM32H7_ADC_CR			0x08
-#define STM32H7_ADC_CFGR		0x0C
-#define STM32H7_ADC_SMPR1		0x14
-#define STM32H7_ADC_SMPR2		0x18
-#define STM32H7_ADC_PCSEL		0x1C
-#define STM32H7_ADC_SQR1		0x30
-#define STM32H7_ADC_SQR2		0x34
-#define STM32H7_ADC_SQR3		0x38
-#define STM32H7_ADC_SQR4		0x3C
-#define STM32H7_ADC_DR			0x40
-#define STM32H7_ADC_DIFSEL		0xC0
-#define STM32H7_ADC_CALFACT		0xC4
-#define STM32H7_ADC_CALFACT2		0xC8
-
-/* STM32H7_ADC_ISR - bit fields */
-#define STM32MP1_VREGREADY		BIT(12)
-#define STM32H7_EOC			BIT(2)
-#define STM32H7_ADRDY			BIT(0)
-
-/* STM32H7_ADC_IER - bit fields */
-#define STM32H7_EOCIE			STM32H7_EOC
-
-/* STM32H7_ADC_CR - bit fields */
-#define STM32H7_ADCAL			BIT(31)
-#define STM32H7_ADCALDIF		BIT(30)
-#define STM32H7_DEEPPWD			BIT(29)
-#define STM32H7_ADVREGEN		BIT(28)
-#define STM32H7_LINCALRDYW6		BIT(27)
-#define STM32H7_LINCALRDYW5		BIT(26)
-#define STM32H7_LINCALRDYW4		BIT(25)
-#define STM32H7_LINCALRDYW3		BIT(24)
-#define STM32H7_LINCALRDYW2		BIT(23)
-#define STM32H7_LINCALRDYW1		BIT(22)
-#define STM32H7_ADCALLIN		BIT(16)
-#define STM32H7_BOOST			BIT(8)
-#define STM32H7_ADSTP			BIT(4)
-#define STM32H7_ADSTART			BIT(2)
-#define STM32H7_ADDIS			BIT(1)
-#define STM32H7_ADEN			BIT(0)
-
-/* STM32H7_ADC_CFGR bit fields */
-#define STM32H7_EXTEN_SHIFT		10
-#define STM32H7_EXTEN_MASK		GENMASK(11, 10)
-#define STM32H7_EXTSEL_SHIFT		5
-#define STM32H7_EXTSEL_MASK		GENMASK(9, 5)
-#define STM32H7_RES_SHIFT		2
-#define STM32H7_RES_MASK		GENMASK(4, 2)
-#define STM32H7_DMNGT_SHIFT		0
-#define STM32H7_DMNGT_MASK		GENMASK(1, 0)
-
-enum stm32h7_adc_dmngt {
-	STM32H7_DMNGT_DR_ONLY,		/* Regular data in DR only */
-	STM32H7_DMNGT_DMA_ONESHOT,	/* DMA one shot mode */
-	STM32H7_DMNGT_DFSDM,		/* DFSDM mode */
-	STM32H7_DMNGT_DMA_CIRC,		/* DMA circular mode */
-};
-
-/* STM32H7_ADC_CALFACT - bit fields */
-#define STM32H7_CALFACT_D_SHIFT		16
-#define STM32H7_CALFACT_D_MASK		GENMASK(26, 16)
-#define STM32H7_CALFACT_S_SHIFT		0
-#define STM32H7_CALFACT_S_MASK		GENMASK(10, 0)
-
-/* STM32H7_ADC_CALFACT2 - bit fields */
-#define STM32H7_LINCALFACT_SHIFT	0
-#define STM32H7_LINCALFACT_MASK		GENMASK(29, 0)
-
 /* Number of linear calibration shadow registers / LINCALRDYW control bits */
 #define STM32H7_LINCALFACT_NUM		6
 

