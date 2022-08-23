Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726F159D53E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243100AbiHWI1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243336AbiHWIYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:24:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247BF23D;
        Tue, 23 Aug 2022 01:13:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72757B81C36;
        Tue, 23 Aug 2022 08:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C059DC433C1;
        Tue, 23 Aug 2022 08:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242379;
        bh=YKpS4Mu6LeeKYPwDXTeHt6aFS9MfVXJBGaFLo3EJw9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7HR4zXHxuONWsTf3O8HgiXRCWVnb8UqzLwfy24qhzirwswbW6gbSa2EgKKZ/M7zc
         mLrRF2Gb4LYtLkrOY36cAthoq3NVNzrq2DUGR40gXRbaivB7TaI7dHOvdMoH3Qjt9Q
         HyVc6IQYha4sF92fcreqyIekmqC9XNzg5YyYLvjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Rob Herring <robh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.19 097/365] dt-bindings: pinctrl: mt8195: Add and use drive-strength-microamp
Date:   Tue, 23 Aug 2022 09:59:58 +0200
Message-Id: <20220823080122.262553045@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

commit 1b3ab63e56f0c30193b6787b083be4f4071b7fc6 upstream.

As was already done for MT8192 in commit b52e695324bb ("dt-bindings:
pinctrl: mt8192: Add drive-strength-microamp"), replace the custom
mediatek,drive-strength-adv property with the standardized pinconf
'drive-strength-microamp' one.

Similarly to the mt8192 counterpart, there's no user of property
'mediatek,drive-strength-adv', hence removing it is safe.

Fixes: 69c3d58dc187 ("dt-bindings: pinctrl: mt8195: Add mediatek,drive-strength-adv property")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220630131543.225554-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../bindings/pinctrl/pinctrl-mt8195.yaml      | 27 ++-----------------
 1 file changed, 2 insertions(+), 25 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-mt8195.yaml b/Documentation/devicetree/bindings/pinctrl/pinctrl-mt8195.yaml
index bb40398bb047..3d8afb3d5695 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-mt8195.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-mt8195.yaml
@@ -98,31 +98,8 @@ patternProperties:
           drive-strength:
             enum: [2, 4, 6, 8, 10, 12, 14, 16]
 
-          mediatek,drive-strength-adv:
-            description: |
-              Describe the specific driving setup property.
-              For I2C pins, the existing generic driving setup can only support
-              2/4/6/8/10/12/14/16mA driving. But in specific driving setup, they
-              can support 0.125/0.25/0.5/1mA adjustment. If we enable specific
-              driving setup, the existing generic setup will be disabled.
-              The specific driving setup is controlled by E1E0EN.
-              When E1=0/E0=0, the strength is 0.125mA.
-              When E1=0/E0=1, the strength is 0.25mA.
-              When E1=1/E0=0, the strength is 0.5mA.
-              When E1=1/E0=1, the strength is 1mA.
-              EN is used to enable or disable the specific driving setup.
-              Valid arguments are described as below:
-              0: (E1, E0, EN) = (0, 0, 0)
-              1: (E1, E0, EN) = (0, 0, 1)
-              2: (E1, E0, EN) = (0, 1, 0)
-              3: (E1, E0, EN) = (0, 1, 1)
-              4: (E1, E0, EN) = (1, 0, 0)
-              5: (E1, E0, EN) = (1, 0, 1)
-              6: (E1, E0, EN) = (1, 1, 0)
-              7: (E1, E0, EN) = (1, 1, 1)
-              So the valid arguments are from 0 to 7.
-            $ref: /schemas/types.yaml#/definitions/uint32
-            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+          drive-strength-microamp:
+            enum: [125, 250, 500, 1000]
 
           bias-pull-down:
             oneOf:
-- 
2.37.2



