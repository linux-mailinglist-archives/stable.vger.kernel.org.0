Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F8D6A17A1
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 09:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjBXIA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 03:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjBXIA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 03:00:58 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8403C25BB5
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 00:00:57 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id c23so10750044pjo.4
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 00:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PcsnC67wn+CqlKF18BOklq3hhvo7C+mJm1DzOVZsLT8=;
        b=cRnat+0Cs7+bku17Q0RWfYOyZoaY/AM3gR/A4qjMETzHJ8K/6cMg6sGIDgVGEUi2us
         Siv6tVSk8OJ5+NMBcy4u69Wi+IRYTZb2yyEQ8cJnQqoajbwvM+r8ywhAxau9pRpMoh6z
         OxNBb8aaTRh7b3QNsM/2CObzPZWXqGwDli3mx5Z+XP6TFOlawPctW5DeNRZSNWo3fZfw
         /A0QLienw62/ybqG/1ipvDDFWQSzUISSJ47SFKk2HvEf//fPLO+YQKMZIg5CvhdKVQyw
         GX5AhiDnxUK5seaggpfa44E6V7EvuGqu0myYlM0AI72dHew3HhKu5t27GC7z75uN4+TN
         xRrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PcsnC67wn+CqlKF18BOklq3hhvo7C+mJm1DzOVZsLT8=;
        b=PExA6lTdFpncYJxQ7RuqzUfUkYPMb+L0qRkALaB7DcqluaC1eRlnVoVUuB0OUwiiIx
         7LPlmZSnu8aYkHTxv+XWGzpSct5iNNEd02/tmjjNYSuFmRb+U2seqViaM1BjmBIGDyzQ
         YKA8Tw4uRx0l5Te3i2gybJ0ko85iejkQmq/+taSW28m7ZV661hPj2qF3UiJvL9QhAwqr
         PXROteGPytnXPti8jFp5NFuyLnD1mhwV60I1i2HFaWFt59Aha509eS4govEa2ekjbpXF
         n5cq/Tq4bljCUGepiQ4PwYXJdmCPevsoKitw0n9EVGC2VXSjC2iICEHMOalvfT4Db5uQ
         vaAg==
X-Gm-Message-State: AO0yUKWwqGXDR50c5k8y5QypnQVK+ZwLaKFzPP1MQkGpdlJPQAX+Unad
        zrihI28qSf/Sr+dYaXHN5IpB
X-Google-Smtp-Source: AK7set/lzSiKZKtwDbb/ZwhiiXzU1IO4RluJP7aya+5eNvg/2KbycM28CZD5Iy/+ZPBhkHUjotDfcw==
X-Received: by 2002:a17:90b:3144:b0:237:99b9:c415 with SMTP id ip4-20020a17090b314400b0023799b9c415mr725021pjb.38.1677225656986;
        Fri, 24 Feb 2023 00:00:56 -0800 (PST)
Received: from localhost.localdomain ([117.217.187.3])
        by smtp.gmail.com with ESMTPSA id l3-20020a17090ac58300b002372106a5casm914211pjt.44.2023.02.24.00.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 00:00:56 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org
Cc:     konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.sharma@linaro.org, srinivas.kandagatla@linaro.org,
        quic_vkamble@quicinc.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] arm64: dts: qcom: sm8150: Fix the iommu mask used for PCIe controllers
Date:   Fri, 24 Feb 2023 13:30:45 +0530
Message-Id: <20230224080045.6577-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
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

The iommu mask should be 0x3f as per Qualcomm internal documentation.
Without the correct mask, the PCIe transactions from the endpoint will
result in SMMU faults. Hence, fix it!

Cc: stable@vger.kernel.org # 5.19
Fixes: a1c86c680533 ("arm64: dts: qcom: sm8150: Add PCIe nodes")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index fd20096cfc6e..13e0ce828606 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1826,7 +1826,7 @@ pcie0: pci@1c00000 {
 				      "slave_q2a",
 				      "tbu";
 
-			iommus = <&apps_smmu 0x1d80 0x7f>;
+			iommus = <&apps_smmu 0x1d80 0x3f>;
 			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
 				    <0x100 &apps_smmu 0x1d81 0x1>;
 
@@ -1925,7 +1925,7 @@ pcie1: pci@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommus = <&apps_smmu 0x1e00 0x7f>;
+			iommus = <&apps_smmu 0x1e00 0x3f>;
 			iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
 				    <0x100 &apps_smmu 0x1e01 0x1>;
 
-- 
2.25.1

