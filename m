Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6066659A1E5
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350993AbiHSQCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351373AbiHSQBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:01:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3AA3A49F;
        Fri, 19 Aug 2022 08:53:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8A726174E;
        Fri, 19 Aug 2022 15:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0571C433D7;
        Fri, 19 Aug 2022 15:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924368;
        bh=YxAJEhhP94cYJ02uCP5pklr8vGFVYVHdB7Fw9s4FR3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uypyxXH34EYBcEjZ5C/pX9q0Ti0Yx3GLe4kxP9rjPzJwLy/axon1KIcxIK45EBOy+
         xy3yEZwnLHc7n3QNxyL9rnnx5Un+uhZ7Nx1X0cKzSKD568gu+/NuWjmcNISHOIPA67
         6fuzliT1n3hT0+61ypF4QIRWcMs0EWvlwmTzqeG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Cheng <quic_wcheng@quicinc.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/545] dt-bindings: Update QCOM USB subsystem maintainer information
Date:   Fri, 19 Aug 2022 17:38:36 +0200
Message-Id: <20220819153835.859060503@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <quic_wcheng@quicinc.com>

[ Upstream commit e059da384ffdc93778e69a5f212c2ac7357ec09a ]

Update devicetree binding files with the proper maintainer, and updated
contact email.

Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220603021432.13365-1-quic_wcheng@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/phy/qcom,qmp-usb3-dp-phy.yaml | 2 +-
 Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml       | 2 +-
 .../devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml         | 2 +-
 .../devicetree/bindings/regulator/qcom,usb-vbus-regulator.yaml  | 2 +-
 Documentation/devicetree/bindings/usb/qcom,dwc3.yaml            | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/qcom,qmp-usb3-dp-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,qmp-usb3-dp-phy.yaml
index 33974ad10afe..1b5257cac54d 100644
--- a/Documentation/devicetree/bindings/phy/qcom,qmp-usb3-dp-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,qmp-usb3-dp-phy.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Qualcomm QMP USB3 DP PHY controller
 
 maintainers:
-  - Manu Gautam <mgautam@codeaurora.org>
+  - Wesley Cheng <quic_wcheng@quicinc.com>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml
index d457fb6a4779..6f5c6cd37426 100644
--- a/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Qualcomm QUSB2 phy controller
 
 maintainers:
-  - Manu Gautam <mgautam@codeaurora.org>
+  - Wesley Cheng <quic_wcheng@quicinc.com>
 
 description:
   QUSB2 controller supports LS/FS/HS usb connectivity on Qualcomm chipsets.
diff --git a/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml b/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
index 4949a2851532..cfa71351485b 100644
--- a/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
@@ -7,7 +7,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Qualcomm Synopsys Femto High-Speed USB PHY V2
 
 maintainers:
-  - Wesley Cheng <wcheng@codeaurora.org>
+  - Wesley Cheng <quic_wcheng@quicinc.com>
 
 description: |
   Qualcomm High-Speed USB PHY
diff --git a/Documentation/devicetree/bindings/regulator/qcom,usb-vbus-regulator.yaml b/Documentation/devicetree/bindings/regulator/qcom,usb-vbus-regulator.yaml
index 12ed98c28aaa..dbe78cd4adba 100644
--- a/Documentation/devicetree/bindings/regulator/qcom,usb-vbus-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/qcom,usb-vbus-regulator.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: The Qualcomm PMIC VBUS output regulator driver
 
 maintainers:
-  - Wesley Cheng <wcheng@codeaurora.org>
+  - Wesley Cheng <quic_wcheng@quicinc.com>
 
 description: |
   This regulator driver controls the VBUS output by the Qualcomm PMIC.  This
diff --git a/Documentation/devicetree/bindings/usb/qcom,dwc3.yaml b/Documentation/devicetree/bindings/usb/qcom,dwc3.yaml
index 2cf525d21e05..5b23b80b8c4e 100644
--- a/Documentation/devicetree/bindings/usb/qcom,dwc3.yaml
+++ b/Documentation/devicetree/bindings/usb/qcom,dwc3.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Qualcomm SuperSpeed DWC3 USB SoC controller
 
 maintainers:
-  - Manu Gautam <mgautam@codeaurora.org>
+  - Wesley Cheng <quic_wcheng@quicinc.com>
 
 properties:
   compatible:
-- 
2.35.1



