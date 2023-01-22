Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA23676D1D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjAVNTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjAVNTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:19:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0FE18165
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 05:19:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D152460B41
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E97C4339B;
        Sun, 22 Jan 2023 13:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674393553;
        bh=laQwwqRtAWqgNripsMyzrSfCa2HPzkZmbhh22Qbq0n4=;
        h=Subject:To:Cc:From:Date:From;
        b=ujFPuVD6RzR8Mx+z5+0gva4aA2n2FEdmpbY9piOnF7I9ZraGODMq5yQ6XBlArQWw+
         YnXVRJSuQOcqCNX37BrZHVa0FAdIyRnqEWQZRJdpnYvMK9sSi14fe8LZk6gVcphSPH
         HJUfpfgXYPfChwpH+lPZyPpgfxb5NM1MN4Qlotog=
Subject: FAILED: patch "[PATCH] dt-bindings: phy: g12a-usb2-phy: fix compatible string" failed to apply to 5.4-stable tree
To:     hkallweit1@gmail.com, krzysztof.kozlowski@linaro.org,
        martin.blumenstingl@googlemail.com, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 14:19:10 +0100
Message-ID: <1674393550113160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

c63835bf1c75 ("dt-bindings: phy: g12a-usb2-phy: fix compatible string documentation")
a7c85bcec679 ("dt-bindings: phy: Add Amlogic A1 USB2 PHY Bindings")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c63835bf1c750c9b3aec1d5c23d811d6375fc23d Mon Sep 17 00:00:00 2001
From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 16 Jan 2023 21:17:39 +0100
Subject: [PATCH] dt-bindings: phy: g12a-usb2-phy: fix compatible string
 documentation

The compatible strings in the driver don't have the meson prefix.
Fix this in the documentation and rename the file accordingly.

Fixes: da86d286cce8 ("dt-bindings: phy: meson-g12a-usb2-phy: convert to yaml")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/8d960029-e94d-224b-911f-03e5deb47ebc@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml b/Documentation/devicetree/bindings/phy/amlogic,g12a-usb2-phy.yaml
similarity index 85%
rename from Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml
rename to Documentation/devicetree/bindings/phy/amlogic,g12a-usb2-phy.yaml
index f3a5fbabbbb5..bb01c6b34dab 100644
--- a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/amlogic,g12a-usb2-phy.yaml
@@ -2,7 +2,7 @@
 # Copyright 2019 BayLibre, SAS
 %YAML 1.2
 ---
-$id: "http://devicetree.org/schemas/phy/amlogic,meson-g12a-usb2-phy.yaml#"
+$id: "http://devicetree.org/schemas/phy/amlogic,g12a-usb2-phy.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
 title: Amlogic G12A USB2 PHY
@@ -13,8 +13,8 @@ maintainers:
 properties:
   compatible:
     enum:
-      - amlogic,meson-g12a-usb2-phy
-      - amlogic,meson-a1-usb2-phy
+      - amlogic,g12a-usb2-phy
+      - amlogic,a1-usb2-phy
 
   reg:
     maxItems: 1
@@ -68,7 +68,7 @@ additionalProperties: false
 examples:
   - |
     phy@36000 {
-          compatible = "amlogic,meson-g12a-usb2-phy";
+          compatible = "amlogic,g12a-usb2-phy";
           reg = <0x36000 0x2000>;
           clocks = <&xtal>;
           clock-names = "xtal";

