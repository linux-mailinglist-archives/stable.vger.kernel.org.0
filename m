Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77A5677C4C
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 14:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjAWNUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 08:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbjAWNUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 08:20:01 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FAF1ABC2
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 05:19:58 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id f3so8935853pgc.2
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 05:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZUmagI3SrNjxAIFc/u/7wsXmsBaYydmEOg5h5RQ/H0=;
        b=Jj1AklBZUZFUxAjbjJiLjE+yWzx1KppOmQDis8z3iqM0Y3GqnU8mbwcEnsy5+6IhLp
         2wBbJSoTv41v5b1JeUYAxT0fZMamcfDnGtgpamzJDCZtLrB47hJd/hCxBMCbIisemiyA
         mN4cMjAVMveLN+zqmfgeFUiYQ2lOK8q/aJeUTa3/YNFzKyKhHshohHx7onSH+Bk7cHys
         IOM1UTRh9hjblpZfCgjIi+srvkZLknFIM3IHnXW8ga0jcUxKT6QYcoRuPYshDoBTNcyF
         JYZ1bzoaNlBMjZvL1Ec6aPR541ysPlz+voy9bV0xLim4UZ/cl87/SeTgEtjn9LZh1ecD
         Uwow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PZUmagI3SrNjxAIFc/u/7wsXmsBaYydmEOg5h5RQ/H0=;
        b=6r6yFak2zXS/KcNofNhXkoIgg5tCPaCfc8y36S7KsC1otJmkrLftU6wU99xZn8U320
         ljYKKQwbCAOLTSjBNuywTEoS9RX+hXD98jmTQObdqKko71ofGjcgRRpF/WU5PYPOC1hw
         dSDjSwkoH+rNmsNgu73y4ip002AEv1sDjzOQ6LM4eeeO/sKnP0oPLqMskXgfVWXZLElL
         G65oCq/jtzStWEvkPPJmVY/WWenupsGwG5cokOqme/xV798m+Qo6Q0+8Rj+YqUF7iBsS
         oR2w8hpL9NMJqxt7x/xzxX0knz8CJILcVKxAwDml6EZhrtiMlRbAywu6QOYQs6w+wSxA
         evLw==
X-Gm-Message-State: AFqh2kp/JfD6jGSIJw/VfGlh8nTUUjJMLeZq8OTm7sYRNsww/gLX8HxP
        JSb8XtnvWfyejuEp3yRjGrh0
X-Google-Smtp-Source: AMrXdXsQjHjsqB0aS9D5ob+m2qCxRvjFCD6D8OtfsSOgHjwKTb7cB01DJtWwhEX3tJb8eHEulZnPrw==
X-Received: by 2002:aa7:8283:0:b0:588:9c15:65c4 with SMTP id s3-20020aa78283000000b005889c1565c4mr24088303pfm.3.1674479998226;
        Mon, 23 Jan 2023 05:19:58 -0800 (PST)
Received: from localhost.localdomain ([117.193.209.165])
        by smtp.gmail.com with ESMTPSA id q20-20020aa79834000000b0058134d2df41sm30818783pfl.146.2023.01.23.05.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 05:19:57 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, will@kernel.org, joro@8bytes.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux.dev, dmitry.baryshkov@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] ARM: dts: qcom: sdx55: Add Qcom SMMU-500 as the fallback for IOMMU node
Date:   Mon, 23 Jan 2023 18:49:30 +0530
Message-Id: <20230123131931.263024-3-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123131931.263024-1-manivannan.sadhasivam@linaro.org>
References: <20230123131931.263024-1-manivannan.sadhasivam@linaro.org>
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

SDX55 uses the Qcom version of the SMMU-500 IP. So use "qcom,smmu-500"
compatible as the fallback to the SoC specific compatible.

Cc: <stable@vger.kernel.org> # 5.12
Fixes: a2bdfdfba2af ("ARM: dts: qcom: sdx55: Enable ARM SMMU")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 arch/arm/boot/dts/qcom-sdx55.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-sdx55.dtsi b/arch/arm/boot/dts/qcom-sdx55.dtsi
index f1c0dab40992..93d71aff3fab 100644
--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -578,7 +578,7 @@ pil-reloc@94c {
 		};
 
 		apps_smmu: iommu@15000000 {
-			compatible = "qcom,sdx55-smmu-500", "arm,mmu-500";
+			compatible = "qcom,sdx55-smmu-500", "qcom,smmu-500", "arm,mmu-500";
 			reg = <0x15000000 0x20000>;
 			#iommu-cells = <2>;
 			#global-interrupts = <1>;
-- 
2.25.1

