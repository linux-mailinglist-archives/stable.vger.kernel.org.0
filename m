Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED52E649EBF
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 13:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbiLLMeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 07:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbiLLMdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 07:33:43 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF86811C32
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 04:33:32 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so15541595pjr.3
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 04:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oXSmdk6KZcIB/MFPzIeXJxotTRaDgWgu6sR2dSlOVP0=;
        b=hv669BzV1GDNlxLlrOcoVm+wZFU1E1dKb985Oy4y+3WWBByJI+PVqNf5hJY0BN4E/q
         5XDqW3GoxNLDANL9Lkg/AWRhGGcDk1bRmE8HeglDBEKSMpLXNx039ApHC7e6ojmd1KhZ
         nP/65XIPZvSzoowT/qkd/5N3jSiueIsvUQknSWl51tUQkhEk641YuaNH9ua52p0Kj3Q0
         4rpH6aJPHKdnyyIP2fY20R7F1A/PbhT6omNtN3Y9DxrPUGTmpFrEq9p1CmcXNBfgu/o8
         Tvk3RDOE1/tZO4l2AouDY/HPxnAgTd3gUZ64g+wS0cFNuXJY2Ls9P6WU8Pkab/KAfjM4
         ZQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oXSmdk6KZcIB/MFPzIeXJxotTRaDgWgu6sR2dSlOVP0=;
        b=TL2dekSQxQEBllUz0RRp3QlybxuihElOceLJIhr58ltzHPUGPkPcIUURN/h6ahPbku
         aOrbL2ZRC6HXQpX1WyiQNBMJkLgdUllNWTRUOjiyARwx0hhKY3ddk0z//+RgXV7vrOmM
         8aU6A+3cm2Ad5k2yBxpHk/4nAwibxcMDuDq2eNQOFHyUvDOEG3PjF2SA8LMDsRMKhP/f
         ModU2nPnxSX9Iat5H6VNrIVKdVAz3r1Lzc+gJcKzcECru5A97PN4bd/Y50KZV18w+x9t
         bQOCZ+HVNC7G2dm6kfkGkgpGhvYo5rnyhEeNf0t8xantFLo+uY046pRMqM4iNgwrswoe
         yfWA==
X-Gm-Message-State: ANoB5pk7qPcspt6OOVAboeeugOB+JzUBmEiDIimYvwb+nqK6A3TLBm6O
        rIrIaVOuwBY9lblh9PZ0MvJX
X-Google-Smtp-Source: AA0mqf5zntEOyVqCEcUq2ZkGjr9XJImnZH+hxKgv86NAMpOZsFNEIoQU+AqnBq0L2/jaq6TH8Ad3QA==
X-Received: by 2002:a17:903:240c:b0:188:9806:2e2b with SMTP id e12-20020a170903240c00b0018898062e2bmr16266852plo.35.1670848412076;
        Mon, 12 Dec 2022 04:33:32 -0800 (PST)
Received: from localhost.localdomain ([220.158.159.33])
        by smtp.gmail.com with ESMTPSA id j14-20020a170902da8e00b00189c93ce5easm6252557plx.166.2022.12.12.04.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 04:33:31 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com
Cc:     quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        luca.weiss@fairphone.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 02/13] dt-bindings: arm: msm: Fix register regions used for LLCC banks
Date:   Mon, 12 Dec 2022 18:03:00 +0530
Message-Id: <20221212123311.146261-3-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
References: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
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

Register regions of the LLCC banks are located at separate addresses.
Currently, the binding just lists the LLCC0 base address and specifies
the size to cover all banks. This is not the correct approach since,
there are holes and other registers located in between.

So let's specify the base address of each LLCC bank and get rid of
reg-names property as it is not needed anymore. It should be noted that
the bank count differs for each SoC, so that also needs to be taken into
account in the binding.

Cc: <stable@vger.kernel.org> # 4.19
Fixes: 7e5700ae64f6 ("dt-bindings: Documentation for qcom, llcc")
Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 .../bindings/arm/msm/qcom,llcc.yaml           | 97 ++++++++++++++++---
 1 file changed, 83 insertions(+), 14 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml b/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
index d1df49ffcc1b..260bc87629a7 100644
--- a/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
+++ b/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
@@ -33,14 +33,8 @@ properties:
       - qcom,sm8550-llcc
 
   reg:
-    items:
-      - description: LLCC base register region
-      - description: LLCC broadcast base register region
-
-  reg-names:
-    items:
-      - const: llcc_base
-      - const: llcc_broadcast_base
+    minItems: 2
+    maxItems: 9
 
   interrupts:
     maxItems: 1
@@ -48,7 +42,76 @@ properties:
 required:
   - compatible
   - reg
-  - reg-names
+
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
 
 additionalProperties: false
 
@@ -56,9 +119,15 @@ examples:
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
+          interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
+        };
     };
-- 
2.25.1

