Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5F1676FCC
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbjAVPZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbjAVPZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:25:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB3B227BA
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:25:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B08260C64
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5DEC4339C;
        Sun, 22 Jan 2023 15:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401120;
        bh=m77qKFXT/8M69a4TSIEm41rDIJOJw78i/IdZkIaw2KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlI6LiCnsNM3mJUy6oSE0oT1k01YmLC18VzxEq8tmiJovNmT6BRRUvdGU3r0L/gwf
         iA2ZufxB6MXl633ebRm3It7Z7heIBICyqo5nhIU6T9M+CCUWibCNkFVVwU/56GKhq3
         KEuLym5nbL6598d/IZtofhPL8oXqss7UNvoJYxAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiner Kallweit <hkallweit1@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 117/193] dt-bindings: phy: g12a-usb2-phy: fix compatible string documentation
Date:   Sun, 22 Jan 2023 16:04:06 +0100
Message-Id: <20230122150251.679253112@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

commit c63835bf1c750c9b3aec1d5c23d811d6375fc23d upstream.

The compatible strings in the driver don't have the meson prefix.
Fix this in the documentation and rename the file accordingly.

Fixes: da86d286cce8 ("dt-bindings: phy: meson-g12a-usb2-phy: convert to yaml")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/8d960029-e94d-224b-911f-03e5deb47ebc@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/phy/amlogic,g12a-usb2-phy.yaml       |   78 ++++++++++
 Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml |   78 ----------
 2 files changed, 78 insertions(+), 78 deletions(-)
 rename Documentation/devicetree/bindings/phy/{amlogic,meson-g12a-usb2-phy.yaml => amlogic,g12a-usb2-phy.yaml} (85%)

--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/amlogic,g12a-usb2-phy.yaml
@@ -0,0 +1,78 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2019 BayLibre, SAS
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/phy/amlogic,g12a-usb2-phy.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Amlogic G12A USB2 PHY
+
+maintainers:
+  - Neil Armstrong <neil.armstrong@linaro.org>
+
+properties:
+  compatible:
+    enum:
+      - amlogic,g12a-usb2-phy
+      - amlogic,a1-usb2-phy
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: xtal
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    items:
+      - const: phy
+
+  "#phy-cells":
+    const: 0
+
+  phy-supply:
+    description:
+      Phandle to a regulator that provides power to the PHY. This
+      regulator will be managed during the PHY power on/off sequence.
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+  - "#phy-cells"
+
+if:
+  properties:
+    compatible:
+      enum:
+        - amlogic,meson-a1-usb-ctrl
+
+then:
+  properties:
+    power-domains:
+      maxItems: 1
+  required:
+    - power-domains
+
+additionalProperties: false
+
+examples:
+  - |
+    phy@36000 {
+          compatible = "amlogic,g12a-usb2-phy";
+          reg = <0x36000 0x2000>;
+          clocks = <&xtal>;
+          clock-names = "xtal";
+          resets = <&phy_reset>;
+          reset-names = "phy";
+          #phy-cells = <0>;
+    };
--- a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml
+++ /dev/null
@@ -1,78 +0,0 @@
-# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
-# Copyright 2019 BayLibre, SAS
-%YAML 1.2
----
-$id: "http://devicetree.org/schemas/phy/amlogic,meson-g12a-usb2-phy.yaml#"
-$schema: "http://devicetree.org/meta-schemas/core.yaml#"
-
-title: Amlogic G12A USB2 PHY
-
-maintainers:
-  - Neil Armstrong <neil.armstrong@linaro.org>
-
-properties:
-  compatible:
-    enum:
-      - amlogic,meson-g12a-usb2-phy
-      - amlogic,meson-a1-usb2-phy
-
-  reg:
-    maxItems: 1
-
-  clocks:
-    maxItems: 1
-
-  clock-names:
-    items:
-      - const: xtal
-
-  resets:
-    maxItems: 1
-
-  reset-names:
-    items:
-      - const: phy
-
-  "#phy-cells":
-    const: 0
-
-  phy-supply:
-    description:
-      Phandle to a regulator that provides power to the PHY. This
-      regulator will be managed during the PHY power on/off sequence.
-
-required:
-  - compatible
-  - reg
-  - clocks
-  - clock-names
-  - resets
-  - reset-names
-  - "#phy-cells"
-
-if:
-  properties:
-    compatible:
-      enum:
-        - amlogic,meson-a1-usb-ctrl
-
-then:
-  properties:
-    power-domains:
-      maxItems: 1
-  required:
-    - power-domains
-
-additionalProperties: false
-
-examples:
-  - |
-    phy@36000 {
-          compatible = "amlogic,meson-g12a-usb2-phy";
-          reg = <0x36000 0x2000>;
-          clocks = <&xtal>;
-          clock-names = "xtal";
-          resets = <&phy_reset>;
-          reset-names = "phy";
-          #phy-cells = <0>;
-    };


