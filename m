Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603A26720E1
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 16:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbjARPOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 10:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbjARPNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 10:13:17 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63AE3FF13
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 07:10:48 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id w2so11010025pfc.11
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 07:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t4t3wjs91jqYDdhcaBgIoHHF665G49/NIuIJvlGrcfA=;
        b=Do9F396SRyFEV5JxNfbhAFqRMWeNzyfD1WsRYMmoSI5NQ0nbug+TxY3SaKiPs5a9Pw
         fdR8QaB4M85v9GsVqYcqCnDclRF/RVSxmYBMgKF1l3LucUAiXBAf/086AwtifvXmAe/B
         MZBjJxOX4wrbKnG+PlVFDYcKiKCT09DhEsY/KikbgL/WiS1cQA2NFIM4RkmK+hru+Gfi
         m/hpxzgMjZ8x8brdl3PgOhZaKWJszwS+5Rthb8IF4PjcH/k+wjpkYOT8XEB5cUv/G0Oy
         1rcXFiGcE7RMaXs+ngfiDoWQqYvsrtt66hh3TzWLSVaDUTVKKlC/JhgxoeuhfqMu4NAS
         UTnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t4t3wjs91jqYDdhcaBgIoHHF665G49/NIuIJvlGrcfA=;
        b=DQitoh6vzZ/Ic1oJfo9Cvc1bpKMaT/wDcVrBfCMbLYO5Mcu4zzZHuSbcOaKapx+qW+
         0MRHfDLCrs8m4t0yhdAeQt30nCuvHh4DHeCxyTq9drZLFvq+HrqB/RGT94je/9e/1lSd
         ZCacByN0O0LVDwfewzqMDvuaYGCTRBoWdCKk/+t2xb/fV3hUzrDJnZsRGOOHASjhs054
         l97sPPUYyxhvgwsV/CVWqiIpwl7fN9ckn1k/9FgeJYEjEnfBtWBu2S5R5czXF2/UjyEq
         GfYNzxFmEGIIqE3le8wlu5afK+wG9fo74Ixv0hbux8oiZ2UaZ+qfzwqQ+8Xlkc/XijX8
         NeXw==
X-Gm-Message-State: AFqh2krGGkRYB5dkKnXbgsGA1O1C3kU2ln1b9B8Y+iiVaAuLBkPaH/l5
        5z8hr3i31/9btTOI4ngvHQQo
X-Google-Smtp-Source: AMrXdXsK7jXlYKJw2R2kMtVvIpTTwtJt9k0lK/4ARndplI5whavjRrr8Cxok5DG/utsHXMucEWMrog==
X-Received: by 2002:a05:6a00:2986:b0:58c:8bdd:2e3c with SMTP id cj6-20020a056a00298600b0058c8bdd2e3cmr7663075pfb.20.1674054648177;
        Wed, 18 Jan 2023 07:10:48 -0800 (PST)
Received: from localhost.localdomain ([27.111.75.61])
        by smtp.gmail.com with ESMTPSA id i15-20020aa796ef000000b0058d9623e7f1sm6721544pfq.73.2023.01.18.07.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:10:47 -0800 (PST)
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
Subject: [PATCH v6 17/17] soc: qcom: llcc: Do not create EDAC platform device on SDM845
Date:   Wed, 18 Jan 2023 20:39:04 +0530
Message-Id: <20230118150904.26913-18-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230118150904.26913-1-manivannan.sadhasivam@linaro.org>
References: <20230118150904.26913-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The platforms based on SDM845 SoC locks the access to EDAC registers in the
bootloader. So probing the EDAC driver will result in a crash. Hence,
disable the creation of EDAC platform device on all SDM845 devices.

The issue has been observed on Lenovo Yoga C630 and DB845c.

Cc: <stable@vger.kernel.org> # 5.10
Reported-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/soc/qcom/llcc-qcom.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
index 7b7c5a38bac6..8d840702df50 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -1012,11 +1012,18 @@ static int qcom_llcc_probe(struct platform_device *pdev)
 
 	drv_data->ecc_irq = platform_get_irq_optional(pdev, 0);
 
-	llcc_edac = platform_device_register_data(&pdev->dev,
-					"qcom_llcc_edac", -1, drv_data,
-					sizeof(*drv_data));
-	if (IS_ERR(llcc_edac))
-		dev_err(dev, "Failed to register llcc edac driver\n");
+	/*
+	 * The platforms based on SDM845 SoC locks the access to EDAC registers
+	 * in bootloader. So probing the EDAC driver will result in a crash.
+	 * Hence, disable the creation of EDAC platform device on SDM845.
+	 */
+	if (!of_device_is_compatible(dev->of_node, "qcom,sdm845-llcc")) {
+		llcc_edac = platform_device_register_data(&pdev->dev,
+						"qcom_llcc_edac", -1, drv_data,
+						sizeof(*drv_data));
+		if (IS_ERR(llcc_edac))
+			dev_err(dev, "Failed to register llcc edac driver\n");
+	}
 
 	return 0;
 err:
-- 
2.25.1

