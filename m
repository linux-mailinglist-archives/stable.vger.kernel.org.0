Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA65645BBB
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 15:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiLGOAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 09:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiLGN7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 08:59:49 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7624C5C75C
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 05:59:48 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so1706894pjj.4
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 05:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vwHmJ0i8eRrdJL4Dl+R0aoA35/USIsHe1f5AGZFuBf8=;
        b=OD+cAweOssXB7azBKYQhL+0oMitp8X6VJm/J895F1RNtF5D7DB1DvZ5FPUk7WhE8rw
         isXLpinkr3G7y9cKcfV3FnVjIDieOZatDAOcVxyNQ/vwXiL23F/naOEvoVsgsgG9P8mJ
         GpDJEYXA4NF6NoPM0+ueSkwmAgMnHOX//uHCAHEg/YNYNOAFmpsEwygOVZ5ovSLVKArw
         i9yqbZ9pGodF0R+JWSoyxYQB+cwRwNq9HHY0ejgPlBCDZB+ZAXwn0lD1Ajq33IPwBAm6
         pHeHa4+QnZ1kMCk533DbWJILyP2X2/MlBW3bFWfjJ4tjwc9fTYTN65ZEChSzaHG8udnU
         cZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vwHmJ0i8eRrdJL4Dl+R0aoA35/USIsHe1f5AGZFuBf8=;
        b=ftaZmOL1eD7gB71bbPvpBHs1gApHnYlighW4Hp7texWrMoBwCvVOKSi7ViLWo2/u8e
         tk6671ch7Y2NJXHOTgLsrbXUhTXBt64jkEv7d9jq5flkTIN8yvfNWEj9cSjGAq+Sy1Fg
         hEVzgo9KjujAO2VnmvQaBL8BSltJb7cSlSpdg694kSNKJVSeaRmoZlvZkJlRuAqFKt9q
         FwKDPh35wU45Abmee7fIhf0814IDcjtutXlZzj+kEVNuo7zczqzXLsRk2r9y3KJhxQQm
         4Vz/hjK/tSJRwTGyrfFkvSlzk1nADi/YafLbWajlyeTq3rgxPZxLZyA4yx446lDZck0I
         tszw==
X-Gm-Message-State: ANoB5pnBZl8ofE01xM6FUrhCHtwxhA3lPqjS5WTH5a5PPcBGASrRggdR
        7d0u3YvxfKYqCxtNLHzxd967uwAGD4+DjHk=
X-Google-Smtp-Source: AA0mqf6NdZEB+vu0KzJADmdPGIY1PLQc10iKrjmXLFRFsLnXOzvyvN7SngE59U2WWlLhLkXXNN7N3A==
X-Received: by 2002:a17:902:e005:b0:189:c62e:ac2f with SMTP id o5-20020a170902e00500b00189c62eac2fmr21071383plo.144.1670421587941;
        Wed, 07 Dec 2022 05:59:47 -0800 (PST)
Received: from localhost.localdomain ([117.216.123.5])
        by smtp.gmail.com with ESMTPSA id c18-20020a170902d49200b00186b69157ecsm14720160plg.202.2022.12.07.05.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:59:47 -0800 (PST)
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
Subject: [PATCH 02/12] dt-bindings: arm: msm: Fix register regions used for LLCC banks
Date:   Wed,  7 Dec 2022 19:29:11 +0530
Message-Id: <20221207135922.314827-3-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221207135922.314827-1-manivannan.sadhasivam@linaro.org>
References: <20221207135922.314827-1-manivannan.sadhasivam@linaro.org>
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

Register regions of the LLCC banks are located at separate addresses.
Currently, the binding just lists the LLCC0 base address and specifies
the size to cover all banks. This is not the correct approach since,
there are holes and other registers located in between.

So let's specify the base address of each LLCC bank. It should be noted
that the bank count differs for each SoC, so that also needs to be taken
into account in the binding.

Cc: <stable@vger.kernel.org> # 4.19
Fixes: 7e5700ae64f6 ("dt-bindings: Documentation for qcom, llcc")
Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 .../bindings/arm/msm/qcom,llcc.yaml           | 125 ++++++++++++++++--
 1 file changed, 114 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml b/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
index d1df49ffcc1b..7f694baa017c 100644
--- a/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
+++ b/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
@@ -33,14 +33,12 @@ properties:
       - qcom,sm8550-llcc
 
   reg:
-    items:
-      - description: LLCC base register region
-      - description: LLCC broadcast base register region
+    minItems: 2
+    maxItems: 9
 
   reg-names:
-    items:
-      - const: llcc_base
-      - const: llcc_broadcast_base
+    minItems: 2
+    maxItems: 9
 
   interrupts:
     maxItems: 1
@@ -50,15 +48,120 @@ required:
   - reg
   - reg-names
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,sc7180-llcc
+              - qcom,sm6350-llcc
+    then:
+      properties:
+        reg:
+          items:
+            - description: LLCC0 base register region
+            - description: LLCC broadcast base register region
+        reg-names:
+          items:
+            - const: llcc0_base
+            - const: llcc_broadcast_base
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,sc7280-llcc
+    then:
+      properties:
+        reg:
+          items:
+            - description: LLCC0 base register region
+            - description: LLCC1 base register region
+            - description: LLCC broadcast base register region
+        reg-names:
+          items:
+            - const: llcc0_base
+            - const: llcc1_base
+            - const: llcc_broadcast_base
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,sc8180x-llcc
+              - qcom,sc8280xp-llcc
+    then:
+      properties:
+        reg:
+          items:
+            - description: LLCC0 base register region
+            - description: LLCC1 base register region
+            - description: LLCC2 base register region
+            - description: LLCC3 base register region
+            - description: LLCC4 base register region
+            - description: LLCC5 base register region
+            - description: LLCC6 base register region
+            - description: LLCC7 base register region
+            - description: LLCC broadcast base register region
+        reg-names:
+          items:
+            - const: llcc0_base
+            - const: llcc1_base
+            - const: llcc2_base
+            - const: llcc3_base
+            - const: llcc4_base
+            - const: llcc5_base
+            - const: llcc6_base
+            - const: llcc7_base
+            - const: llcc_broadcast_base
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,sdm845-llcc
+              - qcom,sm8150-llcc
+              - qcom,sm8250-llcc
+              - qcom,sm8350-llcc
+              - qcom,sm8450-llcc
+    then:
+      properties:
+        reg:
+          items:
+            - description: LLCC0 base register region
+            - description: LLCC1 base register region
+            - description: LLCC2 base register region
+            - description: LLCC3 base register region
+            - description: LLCC broadcast base register region
+        reg-names:
+          items:
+            - const: llcc0_base
+            - const: llcc1_base
+            - const: llcc2_base
+            - const: llcc3_base
+            - const: llcc_broadcast_base
+
 additionalProperties: false
 
 examples:
   - |
     #include <dt-bindings/interrupt-controller/arm-gic.h>
 
-    system-cache-controller@1100000 {
-      compatible = "qcom,sdm845-llcc";
-      reg = <0x1100000 0x200000>, <0x1300000 0x50000> ;
-      reg-names = "llcc_base", "llcc_broadcast_base";
-      interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
+    soc {
+        #address-cells = <2>;
+        #size-cells = <2>;
+
+        system-cache-controller@1100000 {
+          compatible = "qcom,sdm845-llcc";
+          reg = <0 0x01100000 0 0x50000>, <0 0x01180000 0 0x50000>,
+                <0 0x01200000 0 0x50000>, <0 0x01280000 0 0x50000>,
+                <0 0x01300000 0 0x50000>;
+          reg-names = "llcc0_base", "llcc1_base", "llcc2_base",
+                "llcc3_base", "llcc_broadcast_base";
+          interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
+        };
     };
-- 
2.25.1

