Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563E6645BEE
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 15:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiLGOCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 09:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiLGOCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 09:02:03 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296CC5E3FD
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 06:00:59 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q71so16458892pgq.8
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 06:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NhWX6rKQWUP57iw8+d4GFT7tQjEcrRRRTsFAecr4akA=;
        b=A9v9lLV56An3GhPsH89Ik473JrofRyBdoLoOAQPzQLQbyppH1iHysZpC0Uli4f28PT
         Jr+UzCAhJ4Wmoy3JXe25IScBIloO1gSmuRDg/+uUUiSrFA3Ynl/fFocpgyVhDgy4zcOM
         qjjxN2afRdMvUNXqPEmQQ+764HOjVcqIxAHRYgPi+ape3usBOAhruzcg2KTwLGMDc/wO
         yqYuQBDDfPOooe0BZ/f8ZXZQPlGYCAovECjM7P7/RSySESbiVolMeg4tljpXO7yboMlE
         VkUz0E2umgbcDz7IPJcOYaAsUgoxzeJ6NNR8J1XfkRA8WO8KFS6R38WBc7ozgXuvZQMF
         uZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NhWX6rKQWUP57iw8+d4GFT7tQjEcrRRRTsFAecr4akA=;
        b=os+fr2yPq2kxvLxfySd6aXbIwgLJe8m50kxqEgImlv1cph5isM2Dp5T43QjT0IBUMO
         1XTPOU2COMS4RbhGmtVD0UTwXLOHKH93jjfbDNuTQ5zqrBnYedaMhTtzJLYyseGmxr1p
         yfVJePLOd47yKKZJno3bQg3X+0nB5hgKosuDStu846g3wna6CJeAQ2NkMBWOGEw4if8m
         CGqY1Miaj6jX6jAAzfRkZPAy6eHEjHrruDityGcwkrRlHdIUB0hfk9lrodQB21kfouZi
         Ibix5V/KrCY3FkovR1ZvddNKHm56cb49DXfZxlLwwQ425q7YTkCHNrfFo6bbA4wFlGDh
         xcLA==
X-Gm-Message-State: ANoB5pmzSeTQeWEO1A9UxruOEZ0u9eC/O3MEOtdpvqam8Yps1R/XNTlT
        yqk6ZPCW00IsAG6Jyo+LMUtg
X-Google-Smtp-Source: AA0mqf4RYtHL2QYHXNhUfXa/ongclBqtFtdfIORIDRXHajHgTCyU9tFwKK+wtOPwDBZD/b7xdrRcJA==
X-Received: by 2002:a65:5aca:0:b0:478:b2d5:d843 with SMTP id d10-20020a655aca000000b00478b2d5d843mr14474926pgt.415.1670421658483;
        Wed, 07 Dec 2022 06:00:58 -0800 (PST)
Received: from localhost.localdomain ([117.216.123.5])
        by smtp.gmail.com with ESMTPSA id c18-20020a170902d49200b00186b69157ecsm14720160plg.202.2022.12.07.06.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:00:57 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com
Cc:     quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 12/12] qcom: llcc/edac: Fix the base address used for accessing LLCC banks
Date:   Wed,  7 Dec 2022 19:29:22 +0530
Message-Id: <20221207135922.314827-14-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221207135922.314827-1-manivannan.sadhasivam@linaro.org>
References: <20221207135922.314827-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Qualcomm LLCC/EDAC drivers were using a fixed register stride for
accessing the (Control and Status Registers) CSRs of each LLCC bank.
This stride only works for some SoCs like SDM845 for which driver
support was initially added.

But the later SoCs use different register stride that vary between the
banks with holes in-between. So it is not possible to use a single register
stride for accessing the CSRs of each bank. By doing so could result in a
crash.

For fixing this issue, let's obtain the base address of each LLCC bank from
devicetree and get rid of the fixed stride.

Cc: <stable@vger.kernel.org> # 4.20
Fixes: a3134fb09e0b ("drivers: soc: Add LLCC driver")
Fixes: 27450653f1db ("drivers: edac: Add EDAC driver support for QCOM SoCs")
Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/edac/qcom_edac.c           | 14 +++----
 drivers/soc/qcom/llcc-qcom.c       | 64 ++++++++++++++++++------------
 include/linux/soc/qcom/llcc-qcom.h |  4 +-
 3 files changed, 44 insertions(+), 38 deletions(-)

diff --git a/drivers/edac/qcom_edac.c b/drivers/edac/qcom_edac.c
index 97a27e42dd61..70bd39a91b89 100644
--- a/drivers/edac/qcom_edac.c
+++ b/drivers/edac/qcom_edac.c
@@ -213,7 +213,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
 
 	for (i = 0; i < reg_data.reg_cnt; i++) {
 		synd_reg = reg_data.synd_reg + (i * 4);
-		ret = regmap_read(drv->regmap, drv->offsets[bank] + synd_reg,
+		ret = regmap_read(drv->regmap[bank], synd_reg,
 				  &synd_val);
 		if (ret)
 			goto clear;
@@ -222,8 +222,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
 			    reg_data.name, i, synd_val);
 	}
 
-	ret = regmap_read(drv->regmap,
-			  drv->offsets[bank] + reg_data.count_status_reg,
+	ret = regmap_read(drv->regmap[bank], reg_data.count_status_reg,
 			  &err_cnt);
 	if (ret)
 		goto clear;
@@ -233,8 +232,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
 	edac_printk(KERN_CRIT, EDAC_LLCC, "%s: Error count: 0x%4x\n",
 		    reg_data.name, err_cnt);
 
-	ret = regmap_read(drv->regmap,
-			  drv->offsets[bank] + reg_data.ways_status_reg,
+	ret = regmap_read(drv->regmap[bank], reg_data.ways_status_reg,
 			  &err_ways);
 	if (ret)
 		goto clear;
@@ -296,8 +294,7 @@ llcc_ecc_irq_handler(int irq, void *edev_ctl)
 
 	/* Iterate over the banks and look for Tag RAM or Data RAM errors */
 	for (i = 0; i < drv->num_banks; i++) {
-		ret = regmap_read(drv->regmap,
-				  drv->offsets[i] + DRP_INTERRUPT_STATUS,
+		ret = regmap_read(drv->regmap[i], DRP_INTERRUPT_STATUS,
 				  &drp_error);
 
 		if (!ret && (drp_error & SB_ECC_ERROR)) {
@@ -312,8 +309,7 @@ llcc_ecc_irq_handler(int irq, void *edev_ctl)
 		if (!ret)
 			irq_rc = IRQ_HANDLED;
 
-		ret = regmap_read(drv->regmap,
-				  drv->offsets[i] + TRP_INTERRUPT_0_STATUS,
+		ret = regmap_read(drv->regmap[i], TRP_INTERRUPT_0_STATUS,
 				  &trp_error);
 
 		if (!ret && (trp_error & SB_ECC_ERROR)) {
diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
index 23ce2f78c4ed..7264ac9993e0 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -62,8 +62,6 @@
 #define LLCC_TRP_WRSC_CACHEABLE_EN    0x21f2c
 #define LLCC_TRP_ALGO_CFG8	      0x21f30
 
-#define BANK_OFFSET_STRIDE	      0x80000
-
 #define LLCC_VERSION_2_0_0_0          0x02000000
 #define LLCC_VERSION_2_1_0_0          0x02010000
 #define LLCC_VERSION_4_1_0_0          0x04010000
@@ -927,6 +925,7 @@ static int qcom_llcc_probe(struct platform_device *pdev)
 	const struct llcc_slice_config *llcc_cfg;
 	u32 sz;
 	u32 version;
+	struct regmap *regmap;
 
 	drv_data = devm_kzalloc(dev, sizeof(*drv_data), GFP_KERNEL);
 	if (!drv_data) {
@@ -934,12 +933,46 @@ static int qcom_llcc_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	drv_data->regmap = qcom_llcc_init_mmio(pdev, "llcc_base");
-	if (IS_ERR(drv_data->regmap)) {
-		ret = PTR_ERR(drv_data->regmap);
+	/* Initialize the first LLCC bank regmap */
+	regmap = qcom_llcc_init_mmio(pdev, "llcc0_base");
+	if (IS_ERR(regmap)) {
+		ret = PTR_ERR(regmap);
+		goto err;
+	}
+
+	cfg = of_device_get_match_data(&pdev->dev);
+
+	ret = regmap_read(regmap, cfg->reg_offset[LLCC_COMMON_STATUS0],
+			  &num_banks);
+	if (ret)
+		goto err;
+
+	num_banks &= LLCC_LB_CNT_MASK;
+	num_banks >>= LLCC_LB_CNT_SHIFT;
+	drv_data->num_banks = num_banks;
+
+	drv_data->regmap = devm_kcalloc(dev, num_banks, sizeof(*drv_data->regmap), GFP_KERNEL);
+	if (!drv_data->regmap) {
+		ret = -ENOMEM;
 		goto err;
 	}
 
+	drv_data->regmap[0] = regmap;
+
+	/* Initialize rest of LLCC bank regmaps */
+	for (i = 1; i < num_banks; i++) {
+		char *base = kasprintf(GFP_KERNEL, "llcc%d_base", i);
+
+		drv_data->regmap[i] = qcom_llcc_init_mmio(pdev, base);
+		if (IS_ERR(drv_data->regmap[i])) {
+			ret = PTR_ERR(drv_data->regmap[i]);
+			kfree(base);
+			goto err;
+		}
+
+		kfree(base);
+	}
+
 	drv_data->bcast_regmap =
 		qcom_llcc_init_mmio(pdev, "llcc_broadcast_base");
 	if (IS_ERR(drv_data->bcast_regmap)) {
@@ -947,8 +980,6 @@ static int qcom_llcc_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	cfg = of_device_get_match_data(&pdev->dev);
-
 	/* Extract version of the IP */
 	ret = regmap_read(drv_data->bcast_regmap, cfg->reg_offset[LLCC_COMMON_HW_INFO],
 			  &version);
@@ -957,15 +988,6 @@ static int qcom_llcc_probe(struct platform_device *pdev)
 
 	drv_data->version = version;
 
-	ret = regmap_read(drv_data->regmap, cfg->reg_offset[LLCC_COMMON_STATUS0],
-			  &num_banks);
-	if (ret)
-		goto err;
-
-	num_banks &= LLCC_LB_CNT_MASK;
-	num_banks >>= LLCC_LB_CNT_SHIFT;
-	drv_data->num_banks = num_banks;
-
 	llcc_cfg = cfg->sct_data;
 	sz = cfg->size;
 
@@ -973,16 +995,6 @@ static int qcom_llcc_probe(struct platform_device *pdev)
 		if (llcc_cfg[i].slice_id > drv_data->max_slices)
 			drv_data->max_slices = llcc_cfg[i].slice_id;
 
-	drv_data->offsets = devm_kcalloc(dev, num_banks, sizeof(u32),
-							GFP_KERNEL);
-	if (!drv_data->offsets) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	for (i = 0; i < num_banks; i++)
-		drv_data->offsets[i] = i * BANK_OFFSET_STRIDE;
-
 	drv_data->bitmap = devm_bitmap_zalloc(dev, drv_data->max_slices,
 					      GFP_KERNEL);
 	if (!drv_data->bitmap) {
diff --git a/include/linux/soc/qcom/llcc-qcom.h b/include/linux/soc/qcom/llcc-qcom.h
index ad1fd718169d..4b8bf585f9ba 100644
--- a/include/linux/soc/qcom/llcc-qcom.h
+++ b/include/linux/soc/qcom/llcc-qcom.h
@@ -129,12 +129,11 @@ struct llcc_edac_reg_offset {
  * @max_slices: max slices as read from device tree
  * @num_banks: Number of llcc banks
  * @bitmap: Bit map to track the active slice ids
- * @offsets: Pointer to the bank offsets array
  * @ecc_irq: interrupt for llcc cache error detection and reporting
  * @version: Indicates the LLCC version
  */
 struct llcc_drv_data {
-	struct regmap *regmap;
+	struct regmap **regmap;
 	struct regmap *bcast_regmap;
 	const struct llcc_slice_config *cfg;
 	const struct llcc_edac_reg_offset *edac_reg_offset;
@@ -143,7 +142,6 @@ struct llcc_drv_data {
 	u32 max_slices;
 	u32 num_banks;
 	unsigned long *bitmap;
-	u32 *offsets;
 	int ecc_irq;
 	u32 version;
 };
-- 
2.25.1

