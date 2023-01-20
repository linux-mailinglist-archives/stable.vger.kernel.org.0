Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFAE67556E
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 14:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjATNSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 08:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbjATNSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 08:18:34 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74962C41D0
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 05:14:52 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id k16so4034522wms.2
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 05:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AfFIuRH2b9FfD0CydIJ5oSJmwUczAEd83CzMQhgLMzM=;
        b=V0vHFo7ysajexa+NmYC+hGR0na69vwSKGypzgdxWvgYKSvjzxKe352iDiDda+iA3mx
         yV1M86QhpEfjVSIfxLh7krDmwkDhF1x6zb78M3srZw5LGqDLW3bKJYIhANFA63HuYH2k
         PtsSQbuSmNOD2lKTl5e8lILbSdv3Sr8Xv/lVYIgFsuYJ0V9nnw6tfT4DGjAtY5B8TwcW
         vJUB3A04EV0j2x4NJa8OvGtYMo+UKu+CEKXa08aQrgEpwxxi7U9hdaA968AwQ1mykVlM
         qR/gfFLCDu2i0Pb0UeHyyhPK/KzcJe33g2to4tX1G50G4DtKjFJLXPzIVkKMhWELCs0o
         TCGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AfFIuRH2b9FfD0CydIJ5oSJmwUczAEd83CzMQhgLMzM=;
        b=RxjJ7SZjXqst8Cx+Cs276vYE4tqHo+IxugYfhFOTIc1kxyjR2iH9eKQ400I6LSxGtU
         zW/iHBTdQ7lkvnNU7+1PXoOv9NCJGMHFUSrurIufCUF9PlgiV2rUVPjQKZWJZBOCamub
         qbbYfNhMZkfo/9qW0CAGZfAcBludDiybvmjTFeNrkabt07GVoo6hnIFvhUJCaj3zjhxo
         WeWgGSWWWaEfyYIg+OEnTZYtrtWlNLJhyhzukRsnIBFFTzrtOmaj3hJ84CfKOiAHKmO7
         DNqfEOfi79UMWvSAxEkJrIq+ZJe7N3QUDxhl99Y1u4oakyZ/BuqV1lN2PivjInkrHmq8
         scSg==
X-Gm-Message-State: AFqh2kqXLMW/QhWO3i8s8luBmGrXuSo9Q62PhT5zF1uN8LjHLyDqqWcF
        RXwdu7mjiRXnMhPjEQGCbLh2Vg==
X-Google-Smtp-Source: AMrXdXvP3mf/U+3R2kQJkj9RTHm/6Qvd9bJpocAhTuHbHTW4xJISAGMZj4sGLykeOAtsY+vu4wFQ6Q==
X-Received: by 2002:a05:600c:a29e:b0:3d9:ee01:ae5b with SMTP id hu30-20020a05600ca29e00b003d9ee01ae5bmr14064047wmb.12.1674220491033;
        Fri, 20 Jan 2023 05:14:51 -0800 (PST)
Received: from krzk-bin.. ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id q18-20020adfdfd2000000b002bdc129c8f6sm24518977wrn.43.2023.01.20.05.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 05:14:50 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] regulator: dt-bindings: samsung,s2mps14: add lost samsung,ext-control-gpios
Date:   Fri, 20 Jan 2023 14:14:47 +0100
Message-Id: <20230120131447.289702-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
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

The samsung,ext-control-gpios property was lost during conversion to DT
schema:

  exynos3250-artik5-eval.dtb: pmic@66: regulators:LDO11: Unevaluated properties are not allowed ('samsung,ext-control-gpios' was unexpected)

Fixes: ea98b9eba05c ("regulator: dt-bindings: samsung,s2m: convert to dtschema")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../bindings/regulator/samsung,s2mps14.yaml   | 21 +++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/samsung,s2mps14.yaml b/Documentation/devicetree/bindings/regulator/samsung,s2mps14.yaml
index 01f9d4e236e9..a7feb497eb89 100644
--- a/Documentation/devicetree/bindings/regulator/samsung,s2mps14.yaml
+++ b/Documentation/devicetree/bindings/regulator/samsung,s2mps14.yaml
@@ -19,8 +19,8 @@ description: |
   additional information and example.
 
 patternProperties:
-  # 25 LDOs
-  "^LDO([1-9]|[1][0-9]|2[0-5])$":
+  # 25 LDOs, without LDO10-12
+  "^LDO([1-9]|1[3-9]|2[0-5])$":
     type: object
     $ref: regulator.yaml#
     unevaluatedProperties: false
@@ -30,6 +30,23 @@ patternProperties:
     required:
       - regulator-name
 
+  "^LDO(1[0-2])$":
+    type: object
+    $ref: regulator.yaml#
+    unevaluatedProperties: false
+    description:
+      Properties for single LDO regulator.
+
+    properties:
+      samsung,ext-control-gpios:
+        maxItems: 1
+        description:
+          LDO10, LDO11 and LDO12 can be configured to external control over
+          GPIO.
+
+    required:
+      - regulator-name
+
   # 5 bucks
   "^BUCK[1-5]$":
     type: object
-- 
2.34.1

