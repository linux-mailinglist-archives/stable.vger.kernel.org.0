Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2916B677C4E
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 14:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjAWNUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 08:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjAWNUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 08:20:05 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C4B252B0
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 05:20:03 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 36so8914149pgp.10
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 05:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WMZ85FVbs1razWOw43g+c6f7IoFKYG0ZHhwwE8xTxuk=;
        b=R7WF00+j43cj6mfbSwdgDbnXqdJSVInk67fmnpePKQTkc1eEkRY1aljW9i42KBmHtI
         MvhiEesapa/loy+KhbJD56v+31cNMXcs+3kdI94inkovtcm+TS7VGL9DMvth7jBBZlcA
         gRNkj+jw3ZE+BB6jVlIvADMp/u6BEKriJCINNoIL4wm4HQDlNIi1A5jHlaPDWD3U18Fu
         cjh5deSJvaq7b88shlvPBXuphs1LkSjY9+pN6Hyj21UTnoOSvxltYW2AorYouJIDb0iC
         ZUy2CsfyiJky0rLaHaTPYzVpn2EHt2I+FLCGXsKpinP+6ttzEoU1XiMNedEAC+fL03KZ
         mc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WMZ85FVbs1razWOw43g+c6f7IoFKYG0ZHhwwE8xTxuk=;
        b=5nhi/E3qa+oQaoOD+Fh9SN34V8x+LGC5xYm0MFjq56mmFh1+hhg09qK5qWSqSSe++e
         gXSIPtDXWLPaSCBG8p7oy8BJ3fuS+bekLUuZvO79do/9kUOntDmlYvzrA7NClNS/bP44
         nxdypPjD6JFywBIg2BLzqtsfGWk8nqLHUD9MAe8phDx/iwKSxg2jWBnzmLbsVUECXqzv
         gIRsdOsXG33Sh3C8aDlpU2X6BcvBo51iRxiIv7suSYmkkrN15FMas6j8VQUaVw9WsqCI
         z+CjNJU68dmYPV74XehH4spbZfZdgPak3jEXITKAYQwXEjo9quUZxRCpmPHQZ3MpMoi9
         +cqw==
X-Gm-Message-State: AFqh2kqtrU+QyTBiKoeZucEslhk6qYBagQ7f97FeYKayP8xff5axCFKu
        fnrmbbQkcqBycqc6RlhAFv/F
X-Google-Smtp-Source: AMrXdXsKSJ/78fSBRGoAKSM9zSxNELSCc0KEF/KCo6YUipinXSNM7DDgS0e3CeFF66QrCZvewH1Oug==
X-Received: by 2002:a05:6a00:44c5:b0:580:8c2c:d0ad with SMTP id cv5-20020a056a0044c500b005808c2cd0admr23386125pfb.13.1674480003621;
        Mon, 23 Jan 2023 05:20:03 -0800 (PST)
Received: from localhost.localdomain ([117.193.209.165])
        by smtp.gmail.com with ESMTPSA id q20-20020aa79834000000b0058134d2df41sm30818783pfl.146.2023.01.23.05.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 05:20:02 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, will@kernel.org, joro@8bytes.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux.dev, dmitry.baryshkov@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] ARM: dts: qcom: sdx65: Add Qcom SMMU-500 as the fallback for IOMMU node
Date:   Mon, 23 Jan 2023 18:49:31 +0530
Message-Id: <20230123131931.263024-4-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123131931.263024-1-manivannan.sadhasivam@linaro.org>
References: <20230123131931.263024-1-manivannan.sadhasivam@linaro.org>
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

SDX65 uses the Qcom version of the SMMU-500 IP. So use "qcom,smmu-500"
compatible as the fallback to the SoC specific compatible.

Cc: <stable@vger.kernel.org> # 5.19
Fixes: 98187f7b74bf ("ARM: dts: qcom: sdx65: Enable ARM SMMU")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 arch/arm/boot/dts/qcom-sdx65.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-sdx65.dtsi b/arch/arm/boot/dts/qcom-sdx65.dtsi
index b073e0c63df4..408c4b87d44b 100644
--- a/arch/arm/boot/dts/qcom-sdx65.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx65.dtsi
@@ -455,7 +455,7 @@ pil-reloc@94c {
 		};
 
 		apps_smmu: iommu@15000000 {
-			compatible = "qcom,sdx65-smmu-500", "arm,mmu-500";
+			compatible = "qcom,sdx65-smmu-500", "qcom,smmu-500", "arm,mmu-500";
 			reg = <0x15000000 0x40000>;
 			#iommu-cells = <2>;
 			#global-interrupts = <1>;
-- 
2.25.1

