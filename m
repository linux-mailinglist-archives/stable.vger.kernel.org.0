Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD3C4695E3
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 13:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243261AbhLFMrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 07:47:17 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:53010
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243300AbhLFMrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 07:47:16 -0500
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6A52D3F1F4
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 12:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1638794627;
        bh=2ccnvvjzh+vr27cmDIxMLKkuyPKdTXHoRsCzeOVPF7c=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=eEmJYfaiZO+/iHRvWxq8KF1GbQir4H1bi4y4JgahBCNZVqqIT9ihpBxN96LgC7NKQ
         dy2oIc0VlduOjJijtyz4aCMYi4VtN4ZPYzk1nfh9dw3iqYkoYLiL0ufzj3B/LRGjx3
         3cAqCAeAgxpBBCbHNfztfVHGD3uYcxJu/B/HbexftnWtT7seEz6p8Kq0FlcPP/JZXH
         R2V1eLvbfXXbVKHog2Nt14KEH8eSaC8C78TCUle1bRqfXQ/1kFsmdz6pOaQfdKsvxs
         ztO4+pc1yL4VIX0Fq38VunhuN7VW1ubc8ZP+0U5AIXCok8G1zRpNJ/WjWo28O7rSkM
         DgzTSZRjksvhg==
Received: by mail-lj1-f198.google.com with SMTP id i14-20020a2e864e000000b00218a2c57df8so3371572ljj.20
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 04:43:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2ccnvvjzh+vr27cmDIxMLKkuyPKdTXHoRsCzeOVPF7c=;
        b=mbSONYk7/P+ry+25HCs2LB1bvsIdy3zBtpawC16/8JlFywGqWUlXux1VG/t9N2vWIZ
         9nYMwlAh+3a2VZhSevBUsaQEuTt/qNNENowlwcorMyxooGmTR3GtwmsPAyX1xF91cwVO
         9er8zHaqrzjEzuLE9qrKlKQvmx70OqPJpg/7qGBMnST0aJOOqcxgRS7SmbF30Ul/xMjc
         xZCraka4D2I8SY0s3L10uaDK+rq4U0DKQEAs1i2NbrHu9GnbLeYvPbpUX2MfjHdwhp39
         Qr68u8PrEg6Y6uYWgPhrTXEv8xIvTxJcH2TfEAl6g1Y2/IUvwc3xDC/oishebnqDaOcM
         TM0A==
X-Gm-Message-State: AOAM531Ng7Ot4r+s4kJpP7oc87uWNDhxwi3ZcJYgVssaDFGcRIiidee+
        tleZHuoHM+LUljVL2hsS9qm7Oi4/sKohIQ8Y7eYH1tdi+ZN/8rseJZe+FkEp7NA6ZUVwXkEfG1H
        UMlSkerVsU3PXgWYjieuec2Yc2Y+LPfBpcA==
X-Received: by 2002:a05:6512:1313:: with SMTP id x19mr35524134lfu.279.1638794626787;
        Mon, 06 Dec 2021 04:43:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxEMmT5tdvgU9TQ9t8yV5F7fDNCa+/K4eYR8uaI1kK7FvQ6ULIl3dE3GYPMmHi49FXSHjzxDw==
X-Received: by 2002:a05:6512:1313:: with SMTP id x19mr35524106lfu.279.1638794626513;
        Mon, 06 Dec 2021 04:43:46 -0800 (PST)
Received: from localhost.localdomain (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id u14sm1296006ljd.12.2021.12.06.04.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 04:43:46 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] regulator: dt-bindings: samsung,s5m8767: add missing op_mode to bucks
Date:   Mon,  6 Dec 2021 13:43:06 +0100
Message-Id: <20211206124306.14006-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While converting bindings to dtschema, the buck regulators lost
"op_mode" property.  The "op_mode" is a valid property for all
regulators (both LDOs and bucks), so add it.

Reported-by: Rob Herring <robh@kernel.org>
Fixes: fab58debc137 ("regulator: dt-bindings: samsung,s5m8767: convert to dtschema")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../bindings/regulator/samsung,s5m8767.yaml   | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/samsung,s5m8767.yaml b/Documentation/devicetree/bindings/regulator/samsung,s5m8767.yaml
index 80a63d47790a..c98929a213e9 100644
--- a/Documentation/devicetree/bindings/regulator/samsung,s5m8767.yaml
+++ b/Documentation/devicetree/bindings/regulator/samsung,s5m8767.yaml
@@ -51,6 +51,19 @@ patternProperties:
     description:
       Properties for single BUCK regulator.
 
+    properties:
+      op_mode:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        enum: [0, 1, 2, 3]
+        default: 1
+        description: |
+          Describes the different operating modes of the regulator with power
+          mode change in SOC. The different possible values are:
+            0 - always off mode
+            1 - on in normal mode
+            2 - low power mode
+            3 - suspend mode
+
     required:
       - regulator-name
 
@@ -63,6 +76,18 @@ patternProperties:
       Properties for single BUCK regulator.
 
     properties:
+      op_mode:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        enum: [0, 1, 2, 3]
+        default: 1
+        description: |
+          Describes the different operating modes of the regulator with power
+          mode change in SOC. The different possible values are:
+            0 - always off mode
+            1 - on in normal mode
+            2 - low power mode
+            3 - suspend mode
+
       s5m8767,pmic-ext-control-gpios:
         maxItems: 1
         description: |
-- 
2.32.0

