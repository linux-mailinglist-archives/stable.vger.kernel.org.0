Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C446B8B68
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 07:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjCNGlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 02:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjCNGkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 02:40:53 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BDB96C28
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 23:40:48 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id i3so15541632plg.6
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 23:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678776048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N2MPzlugivK4Ijuy+t0DKqQ6NTGW83MyOKBmk9RxIvA=;
        b=RNxGlWsJByqLMn3faZJ7mmQPFNMhuoy6YN611TXcg0K9MnTuSXww3Q1UVe3eGAYmT3
         c2xb1DUSwo6VvEet5UkNXjbb8kbhqOaQ8SWYnqNkcnAl7T8ikOW2Yl85hZ+pXoEbmLH5
         Do8tkJz/Xz/4hQliBWWV1JCrErqRIE8Axi+sMIz59ws+A8EXaoaSCt8Xvh6y867wJEtE
         oCgq/u3WdNIgLsD0WHYJBb6/qQMktQrOR+YlZXs+q0+JwaS9Y+U4qLuGzGJQJUwTjFFg
         oUd1fjhhJPM6GfNvdKlr8WXYrTHRPmtiAAp1x+JCBE4shZ+oPBd+8D5ZnpsljDdE0XVe
         givQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678776048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N2MPzlugivK4Ijuy+t0DKqQ6NTGW83MyOKBmk9RxIvA=;
        b=1+n6IIaOlqDko557OKZkBbwhWdQP6/ZlFE7U12G8pJXfgfXcFEKiLguMc2Iixag4Ug
         2aXW8TIz6XEKQbsfV1+XlRRzAaVgpsLjfbqT9DTw/KD/FCFuP0bJSox3LltuMqcagIoZ
         0tR33wJMDYVvXSjjYhWwChqPwsYocMozeab/Sy1AcWpIEH9ws5y61rM2OcFmp5vO5Eo+
         ukynUdcLWTusb+3kGVR4WSrg9ta84ULJ7H3+kvtTpv4uhJyKf9i3eZ3/EJReQpNi8j5T
         zwe/YguuIVkcgOV/sYWWZjAMfGa2GNreXx52I/PPfTQxzz1grj1BpuUYu+G7ieh7tO8C
         HLUw==
X-Gm-Message-State: AO0yUKUWWPfFJa2lJdxZJ974v1crfZSaFMn/Fe0kaw9dTvkEBRCxQz+u
        6ITHtZftu9d3NXBMNtV8T/qj
X-Google-Smtp-Source: AK7set8xJc3W6rU5Q2MaeJpWqwzxt0ASF1iyo6Wouuegf0flvlJt1YCspVv5kgTQVxpR/wWmMXrn3w==
X-Received: by 2002:a17:903:190:b0:1a0:6dba:9a03 with SMTP id z16-20020a170903019000b001a06dba9a03mr385328plg.45.1678776048305;
        Mon, 13 Mar 2023 23:40:48 -0700 (PDT)
Received: from localhost.localdomain ([117.217.177.49])
        by smtp.gmail.com with ESMTPSA id l15-20020a170902f68f00b0019f363ed8c0sm897497plg.226.2023.03.13.23.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 23:40:47 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, bp@alien8.de, mchehab@kernel.org
Cc:     james.morse@arm.com, rric@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_saipraka@quicinc.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v6 2/2] EDAC/qcom: Get rid of hardcoded register offsets
Date:   Tue, 14 Mar 2023 12:10:32 +0530
Message-Id: <20230314064032.16433-3-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230314064032.16433-1-manivannan.sadhasivam@linaro.org>
References: <20230314064032.16433-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The LLCC EDAC register offsets varies between each SoC. Hardcoding the
register offsets won't work and will often result in crash due to
accessing the wrong locations.

Hence, get the register offsets from the LLCC driver matching the
individual SoCs.

Cc: <stable@vger.kernel.org> # 6.0: 5365cea199c7 ("soc: qcom: llcc: Rename reg_offset structs to reflect LLCC version")
Cc: <stable@vger.kernel.org> # 6.0: c13d7d261e36 ("soc: qcom: llcc: Pass LLCC version based register offsets to EDAC driver")
Cc: <stable@vger.kernel.org> # 6.0
Fixes: a6e9d7ef252c ("soc: qcom: llcc: Add configuration data for SM8450 SoC")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/edac/qcom_edac.c           | 116 ++++++++++++++---------------
 include/linux/soc/qcom/llcc-qcom.h |   6 --
 2 files changed, 58 insertions(+), 64 deletions(-)

diff --git a/drivers/edac/qcom_edac.c b/drivers/edac/qcom_edac.c
index 9cac49596a6f..c0fd0640d362 100644
--- a/drivers/edac/qcom_edac.c
+++ b/drivers/edac/qcom_edac.c
@@ -21,30 +21,9 @@
 #define TRP_SYN_REG_CNT                 6
 #define DRP_SYN_REG_CNT                 8
 
-#define LLCC_COMMON_STATUS0             0x0003000c
 #define LLCC_LB_CNT_MASK                GENMASK(31, 28)
 #define LLCC_LB_CNT_SHIFT               28
 
-/* Single & double bit syndrome register offsets */
-#define TRP_ECC_SB_ERR_SYN0             0x0002304c
-#define TRP_ECC_DB_ERR_SYN0             0x00020370
-#define DRP_ECC_SB_ERR_SYN0             0x0004204c
-#define DRP_ECC_DB_ERR_SYN0             0x00042070
-
-/* Error register offsets */
-#define TRP_ECC_ERROR_STATUS1           0x00020348
-#define TRP_ECC_ERROR_STATUS0           0x00020344
-#define DRP_ECC_ERROR_STATUS1           0x00042048
-#define DRP_ECC_ERROR_STATUS0           0x00042044
-
-/* TRP, DRP interrupt register offsets */
-#define DRP_INTERRUPT_STATUS            0x00041000
-#define TRP_INTERRUPT_0_STATUS          0x00020480
-#define DRP_INTERRUPT_CLEAR             0x00041008
-#define DRP_ECC_ERROR_CNTR_CLEAR        0x00040004
-#define TRP_INTERRUPT_0_CLEAR           0x00020484
-#define TRP_ECC_ERROR_CNTR_CLEAR        0x00020440
-
 /* Mask and shift macros */
 #define ECC_DB_ERR_COUNT_MASK           GENMASK(4, 0)
 #define ECC_DB_ERR_WAYS_MASK            GENMASK(31, 16)
@@ -60,15 +39,6 @@
 #define DRP_TRP_INT_CLEAR               GENMASK(1, 0)
 #define DRP_TRP_CNT_CLEAR               GENMASK(1, 0)
 
-/* Config registers offsets*/
-#define DRP_ECC_ERROR_CFG               0x00040000
-
-/* Tag RAM, Data RAM interrupt register offsets */
-#define CMN_INTERRUPT_0_ENABLE          0x0003001c
-#define CMN_INTERRUPT_2_ENABLE          0x0003003c
-#define TRP_INTERRUPT_0_ENABLE          0x00020488
-#define DRP_INTERRUPT_ENABLE            0x0004100c
-
 #define SB_ERROR_THRESHOLD              0x1
 #define SB_ERROR_THRESHOLD_SHIFT        24
 #define SB_DB_TRP_INTERRUPT_ENABLE      0x3
@@ -86,9 +56,6 @@ enum {
 static const struct llcc_edac_reg_data edac_reg_data[] = {
 	[LLCC_DRAM_CE] = {
 		.name = "DRAM Single-bit",
-		.synd_reg = DRP_ECC_SB_ERR_SYN0,
-		.count_status_reg = DRP_ECC_ERROR_STATUS1,
-		.ways_status_reg = DRP_ECC_ERROR_STATUS0,
 		.reg_cnt = DRP_SYN_REG_CNT,
 		.count_mask = ECC_SB_ERR_COUNT_MASK,
 		.ways_mask = ECC_SB_ERR_WAYS_MASK,
@@ -96,9 +63,6 @@ static const struct llcc_edac_reg_data edac_reg_data[] = {
 	},
 	[LLCC_DRAM_UE] = {
 		.name = "DRAM Double-bit",
-		.synd_reg = DRP_ECC_DB_ERR_SYN0,
-		.count_status_reg = DRP_ECC_ERROR_STATUS1,
-		.ways_status_reg = DRP_ECC_ERROR_STATUS0,
 		.reg_cnt = DRP_SYN_REG_CNT,
 		.count_mask = ECC_DB_ERR_COUNT_MASK,
 		.ways_mask = ECC_DB_ERR_WAYS_MASK,
@@ -106,9 +70,6 @@ static const struct llcc_edac_reg_data edac_reg_data[] = {
 	},
 	[LLCC_TRAM_CE] = {
 		.name = "TRAM Single-bit",
-		.synd_reg = TRP_ECC_SB_ERR_SYN0,
-		.count_status_reg = TRP_ECC_ERROR_STATUS1,
-		.ways_status_reg = TRP_ECC_ERROR_STATUS0,
 		.reg_cnt = TRP_SYN_REG_CNT,
 		.count_mask = ECC_SB_ERR_COUNT_MASK,
 		.ways_mask = ECC_SB_ERR_WAYS_MASK,
@@ -116,9 +77,6 @@ static const struct llcc_edac_reg_data edac_reg_data[] = {
 	},
 	[LLCC_TRAM_UE] = {
 		.name = "TRAM Double-bit",
-		.synd_reg = TRP_ECC_DB_ERR_SYN0,
-		.count_status_reg = TRP_ECC_ERROR_STATUS1,
-		.ways_status_reg = TRP_ECC_ERROR_STATUS0,
 		.reg_cnt = TRP_SYN_REG_CNT,
 		.count_mask = ECC_DB_ERR_COUNT_MASK,
 		.ways_mask = ECC_DB_ERR_WAYS_MASK,
@@ -126,7 +84,7 @@ static const struct llcc_edac_reg_data edac_reg_data[] = {
 	},
 };
 
-static int qcom_llcc_core_setup(struct regmap *llcc_bcast_regmap)
+static int qcom_llcc_core_setup(struct llcc_drv_data *drv, struct regmap *llcc_bcast_regmap)
 {
 	u32 sb_err_threshold;
 	int ret;
@@ -135,31 +93,31 @@ static int qcom_llcc_core_setup(struct regmap *llcc_bcast_regmap)
 	 * Configure interrupt enable registers such that Tag, Data RAM related
 	 * interrupts are propagated to interrupt controller for servicing
 	 */
-	ret = regmap_update_bits(llcc_bcast_regmap, CMN_INTERRUPT_2_ENABLE,
+	ret = regmap_update_bits(llcc_bcast_regmap, drv->edac_reg_offset->cmn_interrupt_2_enable,
 				 TRP0_INTERRUPT_ENABLE,
 				 TRP0_INTERRUPT_ENABLE);
 	if (ret)
 		return ret;
 
-	ret = regmap_update_bits(llcc_bcast_regmap, TRP_INTERRUPT_0_ENABLE,
+	ret = regmap_update_bits(llcc_bcast_regmap, drv->edac_reg_offset->trp_interrupt_0_enable,
 				 SB_DB_TRP_INTERRUPT_ENABLE,
 				 SB_DB_TRP_INTERRUPT_ENABLE);
 	if (ret)
 		return ret;
 
 	sb_err_threshold = (SB_ERROR_THRESHOLD << SB_ERROR_THRESHOLD_SHIFT);
-	ret = regmap_write(llcc_bcast_regmap, DRP_ECC_ERROR_CFG,
+	ret = regmap_write(llcc_bcast_regmap, drv->edac_reg_offset->drp_ecc_error_cfg,
 			   sb_err_threshold);
 	if (ret)
 		return ret;
 
-	ret = regmap_update_bits(llcc_bcast_regmap, CMN_INTERRUPT_2_ENABLE,
+	ret = regmap_update_bits(llcc_bcast_regmap, drv->edac_reg_offset->cmn_interrupt_2_enable,
 				 DRP0_INTERRUPT_ENABLE,
 				 DRP0_INTERRUPT_ENABLE);
 	if (ret)
 		return ret;
 
-	ret = regmap_write(llcc_bcast_regmap, DRP_INTERRUPT_ENABLE,
+	ret = regmap_write(llcc_bcast_regmap, drv->edac_reg_offset->drp_interrupt_enable,
 			   SB_DB_DRP_INTERRUPT_ENABLE);
 	return ret;
 }
@@ -173,24 +131,28 @@ qcom_llcc_clear_error_status(int err_type, struct llcc_drv_data *drv)
 	switch (err_type) {
 	case LLCC_DRAM_CE:
 	case LLCC_DRAM_UE:
-		ret = regmap_write(drv->bcast_regmap, DRP_INTERRUPT_CLEAR,
+		ret = regmap_write(drv->bcast_regmap,
+				   drv->edac_reg_offset->drp_interrupt_clear,
 				   DRP_TRP_INT_CLEAR);
 		if (ret)
 			return ret;
 
-		ret = regmap_write(drv->bcast_regmap, DRP_ECC_ERROR_CNTR_CLEAR,
+		ret = regmap_write(drv->bcast_regmap,
+				   drv->edac_reg_offset->drp_ecc_error_cntr_clear,
 				   DRP_TRP_CNT_CLEAR);
 		if (ret)
 			return ret;
 		break;
 	case LLCC_TRAM_CE:
 	case LLCC_TRAM_UE:
-		ret = regmap_write(drv->bcast_regmap, TRP_INTERRUPT_0_CLEAR,
+		ret = regmap_write(drv->bcast_regmap,
+				   drv->edac_reg_offset->trp_interrupt_0_clear,
 				   DRP_TRP_INT_CLEAR);
 		if (ret)
 			return ret;
 
-		ret = regmap_write(drv->bcast_regmap, TRP_ECC_ERROR_CNTR_CLEAR,
+		ret = regmap_write(drv->bcast_regmap,
+				   drv->edac_reg_offset->trp_ecc_error_cntr_clear,
 				   DRP_TRP_CNT_CLEAR);
 		if (ret)
 			return ret;
@@ -202,16 +164,54 @@ qcom_llcc_clear_error_status(int err_type, struct llcc_drv_data *drv)
 	return ret;
 }
 
+struct qcom_llcc_syn_regs {
+	u32 synd_reg;
+	u32 count_status_reg;
+	u32 ways_status_reg;
+};
+
+static void get_reg_offsets(struct llcc_drv_data *drv, int err_type,
+			    struct qcom_llcc_syn_regs *syn_regs)
+{
+	const struct llcc_edac_reg_offset *edac_reg_offset = drv->edac_reg_offset;
+
+	switch (err_type) {
+	case LLCC_DRAM_CE:
+		syn_regs->synd_reg = edac_reg_offset->drp_ecc_sb_err_syn0;
+		syn_regs->count_status_reg = edac_reg_offset->drp_ecc_error_status1;
+		syn_regs->ways_status_reg = edac_reg_offset->drp_ecc_error_status0;
+		break;
+	case LLCC_DRAM_UE:
+		syn_regs->synd_reg = edac_reg_offset->drp_ecc_db_err_syn0;
+		syn_regs->count_status_reg = edac_reg_offset->drp_ecc_error_status1;
+		syn_regs->ways_status_reg = edac_reg_offset->drp_ecc_error_status0;
+		break;
+	case LLCC_TRAM_CE:
+		syn_regs->synd_reg = edac_reg_offset->trp_ecc_sb_err_syn0;
+		syn_regs->count_status_reg = edac_reg_offset->trp_ecc_error_status1;
+		syn_regs->ways_status_reg = edac_reg_offset->trp_ecc_error_status0;
+		break;
+	case LLCC_TRAM_UE:
+		syn_regs->synd_reg = edac_reg_offset->trp_ecc_db_err_syn0;
+		syn_regs->count_status_reg = edac_reg_offset->trp_ecc_error_status1;
+		syn_regs->ways_status_reg = edac_reg_offset->trp_ecc_error_status0;
+		break;
+	}
+}
+
 /* Dump Syndrome registers data for Tag RAM, Data RAM bit errors*/
 static int
 dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
 {
 	struct llcc_edac_reg_data reg_data = edac_reg_data[err_type];
+	struct qcom_llcc_syn_regs regs = { };
 	int err_cnt, err_ways, ret, i;
 	u32 synd_reg, synd_val;
 
+	get_reg_offsets(drv, err_type, &regs);
+
 	for (i = 0; i < reg_data.reg_cnt; i++) {
-		synd_reg = reg_data.synd_reg + (i * 4);
+		synd_reg = regs.synd_reg + (i * 4);
 		ret = regmap_read(drv->regmap, drv->offsets[bank] + synd_reg,
 				  &synd_val);
 		if (ret)
@@ -222,7 +222,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
 	}
 
 	ret = regmap_read(drv->regmap,
-			  drv->offsets[bank] + reg_data.count_status_reg,
+			  drv->offsets[bank] + regs.count_status_reg,
 			  &err_cnt);
 	if (ret)
 		goto clear;
@@ -233,7 +233,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
 		    reg_data.name, err_cnt);
 
 	ret = regmap_read(drv->regmap,
-			  drv->offsets[bank] + reg_data.ways_status_reg,
+			  drv->offsets[bank] + regs.ways_status_reg,
 			  &err_ways);
 	if (ret)
 		goto clear;
@@ -296,7 +296,7 @@ llcc_ecc_irq_handler(int irq, void *edev_ctl)
 	/* Iterate over the banks and look for Tag RAM or Data RAM errors */
 	for (i = 0; i < drv->num_banks; i++) {
 		ret = regmap_read(drv->regmap,
-				  drv->offsets[i] + DRP_INTERRUPT_STATUS,
+				  drv->offsets[i] + drv->edac_reg_offset->drp_interrupt_status,
 				  &drp_error);
 
 		if (!ret && (drp_error & SB_ECC_ERROR)) {
@@ -312,7 +312,7 @@ llcc_ecc_irq_handler(int irq, void *edev_ctl)
 			irq_rc = IRQ_HANDLED;
 
 		ret = regmap_read(drv->regmap,
-				  drv->offsets[i] + TRP_INTERRUPT_0_STATUS,
+				  drv->offsets[i] + drv->edac_reg_offset->trp_interrupt_0_status,
 				  &trp_error);
 
 		if (!ret && (trp_error & SB_ECC_ERROR)) {
@@ -339,7 +339,7 @@ static int qcom_llcc_edac_probe(struct platform_device *pdev)
 	int ecc_irq;
 	int rc;
 
-	rc = qcom_llcc_core_setup(llcc_driv_data->bcast_regmap);
+	rc = qcom_llcc_core_setup(llcc_driv_data, llcc_driv_data->bcast_regmap);
 	if (rc)
 		return rc;
 
diff --git a/include/linux/soc/qcom/llcc-qcom.h b/include/linux/soc/qcom/llcc-qcom.h
index ad1fd718169d..3a2ea97e3d36 100644
--- a/include/linux/soc/qcom/llcc-qcom.h
+++ b/include/linux/soc/qcom/llcc-qcom.h
@@ -69,9 +69,6 @@ struct llcc_slice_desc {
 /**
  * struct llcc_edac_reg_data - llcc edac registers data for each error type
  * @name: Name of the error
- * @synd_reg: Syndrome register address
- * @count_status_reg: Status register address to read the error count
- * @ways_status_reg: Status register address to read the error ways
  * @reg_cnt: Number of registers
  * @count_mask: Mask value to get the error count
  * @ways_mask: Mask value to get the error ways
@@ -80,9 +77,6 @@ struct llcc_slice_desc {
  */
 struct llcc_edac_reg_data {
 	char *name;
-	u64 synd_reg;
-	u64 count_status_reg;
-	u64 ways_status_reg;
 	u32 reg_cnt;
 	u32 count_mask;
 	u32 ways_mask;
-- 
2.25.1

