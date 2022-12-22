Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEFE06541C5
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 14:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbiLVNUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 08:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235719AbiLVNTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 08:19:41 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853002CC9C
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 05:19:12 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so1841078pjm.2
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 05:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dXKaXgl0o6EC/Ht61vc6HyWaaFSyppq0dnbu5Bb4EnE=;
        b=UeU8tN3RMctOSr0GBqF9tdf+Fnsp2i8GcHeh4jxA3p9jGCptgfW/UgSuOFRO5dbpse
         5uiMnmCmFtKVr3t/fedUbZBr+KJmM9QOYlpBd58Yitx82E7k+xw/ih7Rj+Mdald3jxsa
         embKcwzVJ06cj+EFQMp/f1/34nzj5ia0daMAt8ViqqC4oK1dPLjRHijOXR1+H1RAH2zm
         kkGeDE/k5ZgSNKgERTojiwWTS2AwMDvK+M/EQPBm6hT3pRUVkPTzExv8OrBcs2SR5Qzw
         utWvQI5Tz0as/tGeSavc6Pqmtiirh20BQBrMiy1zz5Ipzb+MveSUoqsAIbfxvrHZ+Iq7
         YkFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dXKaXgl0o6EC/Ht61vc6HyWaaFSyppq0dnbu5Bb4EnE=;
        b=PPwqL8dCpDH8BqlvvhNAx8wALKmvde11449ODIncQ5M0fQhDrBSdvTmHIHzI3iynEE
         SjvEdUrvFfVY4r/u9VYaUf761Et0jk8JQwNUPEmuYq0AJVsZqzHmXFnGVIBfqsuhYcpC
         YBE7JQkJtxlOXFvAVdGG+OT8+epnzm7+6LMCl+po+VVNKuip4/jJoEUch0aVezgA+MvR
         hAw25p2PK+3wG44npO1URoUcs1QonKPIHm5eDjnsDJlCf2KCWbZN51f/CWM1N1fMLo41
         4NgRoxzs+KmOwCqQDfuZZtfK3BjgxjZWd6i8SbGB9VIddUTuCoDTkPj6mEyvU8ooD0KB
         m0Lg==
X-Gm-Message-State: AFqh2kpU/F4VceEnBX+EzGqyzgcA29+9gBscntApdY0DqqJMrGHbbNhm
        5GU+GQqiNaZYybUid2Oj3A1aZBxmgxDvlfg=
X-Google-Smtp-Source: AMrXdXsWQe2JmZT4ybf1Q8yo+pzwkZjnU2NlsEBQ+uWgK1veOwKhyHp+NxSzLqNEnE+w5+11gASKMQ==
X-Received: by 2002:a17:902:c40f:b0:189:d4c5:f155 with SMTP id k15-20020a170902c40f00b00189d4c5f155mr7723058plk.63.1671715151974;
        Thu, 22 Dec 2022 05:19:11 -0800 (PST)
Received: from localhost.localdomain ([117.217.177.99])
        by smtp.gmail.com with ESMTPSA id g12-20020a170902fe0c00b001896040022asm491570plj.190.2022.12.22.05.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 05:19:11 -0800 (PST)
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
Subject: [PATCH v4 14/16] EDAC/qcom: Do not pass llcc_driv_data as edac_device_ctl_info's pvt_info
Date:   Thu, 22 Dec 2022 18:46:54 +0530
Message-Id: <20221222131656.49584-15-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221222131656.49584-1-manivannan.sadhasivam@linaro.org>
References: <20221222131656.49584-1-manivannan.sadhasivam@linaro.org>
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

