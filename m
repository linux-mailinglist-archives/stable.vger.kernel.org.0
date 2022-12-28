Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B8A657410
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 09:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiL1Ils (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 03:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbiL1IlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 03:41:15 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75496FCDA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 00:41:06 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 6so7566373pfz.4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 00:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q1NrdFunM3umkB8l0ZcJbFNj2UhbwdZo1HlNf5THZjI=;
        b=YWqrz5eGRIMsG0Ei1l5tGH6itYViuDMDjNgd0hF1Elmf6sDEYzP7h6Q0Dsz2GRvwfo
         0uzKrsugC7Xg1enMvNSndm9h+svhJzCffttyCNPtG5P5obkMDMECSHXndyOQa+LF5jai
         I8caCiTs2IiLBTvWZdQomkKHw3UzLjkejpZdzOmm0DptQATdWVD4bIxbV2d8c60nOLYI
         cvfX1nSj0FtintmSBgA/JSPsPzpcOjGdtIUFX1Q3XQq88DPwcOBgIpvdbyQhCJ3FFZuR
         AjKKK8ffmlo6xuC8QcDy23H0S1BqiIFyJmLK4Wa5EY7fEL5gwNB0OL/IcX9Dp+nlOYQf
         u0bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q1NrdFunM3umkB8l0ZcJbFNj2UhbwdZo1HlNf5THZjI=;
        b=ATeaBFDLyPF6bWZcP/JODv3PoCCTxiDpQLUysmpL0OUHiwpBYKHb25yvXdu0OEXTcX
         AXp4p+6z4urDkD/xgxh5ErrsL3LtbreXrbSOR6hXq3kX5z4FwaEog6aZ4C1HUu7nD8aI
         fAuVH3JMFjL6axYkMZoJJ1vbz2CaELy2bsqb5DMMvt1Czm7EL3miToxjglqUB7FJ0p6u
         m8qUqDy90oyfZuZAOClpVhyk6rqqLFXj1L/5OFhv/EbSw7jTO4PKiy7OiVAfPc2/KV4l
         rTtDBALPkiRaeZ62cm30lOKp20O3iNmGVmD4z3Iuo70XszZpuVcR9g5DigI9S5ePEvvt
         4DcA==
X-Gm-Message-State: AFqh2kqwcQs7OncLpqp6d0M+83qo4cQlCoJAKA9gKR9FjK9GIwlLg59W
        uqGHpI20KK2j7MmgryRArL2K
X-Google-Smtp-Source: AMrXdXuTBu6noNpF7JLy+QzCkqm8KyQsaNzc/BRre60Z7rZiBxPRbvjGR6qk/JZ42RzJtzgkNDpG0Q==
X-Received: by 2002:aa7:83d1:0:b0:580:d71e:a2e5 with SMTP id j17-20020aa783d1000000b00580d71ea2e5mr13909138pfn.22.1672216865946;
        Wed, 28 Dec 2022 00:41:05 -0800 (PST)
Received: from localhost.localdomain ([117.217.178.73])
        by smtp.gmail.com with ESMTPSA id d188-20020a6236c5000000b0057a9b146592sm9786286pfa.186.2022.12.28.00.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 00:41:05 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com
Cc:     quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        luca.weiss@fairphone.com, ahalaney@redhat.com, steev@kali.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v5 03/17] EDAC/qcom: Do not pass llcc_driv_data as edac_device_ctl_info's pvt_info
Date:   Wed, 28 Dec 2022 14:10:14 +0530
Message-Id: <20221228084028.46528-4-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221228084028.46528-1-manivannan.sadhasivam@linaro.org>
References: <20221228084028.46528-1-manivannan.sadhasivam@linaro.org>
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

The memory for "llcc_driv_data" is allocated by the LLCC driver. But when
it is passed as "pvt_info" to the EDAC core, it will get freed during the
qcom_edac driver release. So when the qcom_edac driver gets probed again,
it will try to use the freed data leading to the use-after-free bug.

Fix this by not passing "llcc_driv_data" as pvt_info but rather reference
it using the "platform_data" in the qcom_edac driver.

Cc: <stable@vger.kernel.org> # 4.20
Fixes: 27450653f1db ("drivers: edac: Add EDAC driver support for QCOM SoCs")
Tested-by: Steev Klimaszewski <steev@kali.org> # Thinkpad X13s
Tested-by: Andrew Halaney <ahalaney@redhat.com> # sa8540p-ride
Reported-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/edac/qcom_edac.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/qcom_edac.c b/drivers/edac/qcom_edac.c
index 9e77fa84e84f..3256254c3722 100644
--- a/drivers/edac/qcom_edac.c
+++ b/drivers/edac/qcom_edac.c
@@ -252,7 +252,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
 static int
 dump_syn_reg(struct edac_device_ctl_info *edev_ctl, int err_type, u32 bank)
 {
-	struct llcc_drv_data *drv = edev_ctl->pvt_info;
+	struct llcc_drv_data *drv = edev_ctl->dev->platform_data;
 	int ret;
 
 	ret = dump_syn_reg_values(drv, bank, err_type);
@@ -289,7 +289,7 @@ static irqreturn_t
 llcc_ecc_irq_handler(int irq, void *edev_ctl)
 {
 	struct edac_device_ctl_info *edac_dev_ctl = edev_ctl;
-	struct llcc_drv_data *drv = edac_dev_ctl->pvt_info;
+	struct llcc_drv_data *drv = edac_dev_ctl->dev->platform_data;
 	irqreturn_t irq_rc = IRQ_NONE;
 	u32 drp_error, trp_error, i;
 	int ret;
@@ -358,7 +358,6 @@ static int qcom_llcc_edac_probe(struct platform_device *pdev)
 	edev_ctl->dev_name = dev_name(dev);
 	edev_ctl->ctl_name = "llcc";
 	edev_ctl->panic_on_ue = LLCC_ERP_PANIC_ON_UE;
-	edev_ctl->pvt_info = llcc_driv_data;
 
 	rc = edac_device_add_device(edev_ctl);
 	if (rc)
-- 
2.25.1

