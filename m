Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DB059D45D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242852AbiHWIWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243651AbiHWIVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:21:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DD570E44;
        Tue, 23 Aug 2022 01:12:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11AA8B81C3A;
        Tue, 23 Aug 2022 08:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B63BC43153;
        Tue, 23 Aug 2022 08:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242345;
        bh=1bcfY/F8tx9w3nXmNGlKoSMN7ZhIswwyXnG8I1zgTGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x64Y1xYC1JKeTXfF0Z6Opn22+v7mgb0ySx4B2YdVFS8j6viRUuGGNsxfpOqY4zh5S
         7vv7c8qsUAUD6DNPJyzfB2ZUyvknNSTEkZ2FvmK7/b7hxoma9L3222RDxcDQxgsS5A
         2u19XaNbGcvUlP2Q8xBVgCTwuxOowE4gzGVhuw94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Rob Herring <robh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.19 096/365] dt-bindings: pinctrl: mt8195: Fix name for mediatek,rsel-resistance-in-si-unit
Date:   Tue, 23 Aug 2022 09:59:57 +0200
Message-Id: <20220823080122.223668540@linuxfoundation.org>
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

commit 11bd0ffd165fce7aff1a2ed15c04c088239f3d42 upstream.

When this property was introduced, it contained underscores, but
the actual code wants dashes.

Change it from mediatek,rsel_resistance_in_si_unit to
mediatek,rsel-resistance-in-si-unit.

Fixes: 91e7edceda96 ("dt-bindings: pinctrl: mt8195: change pull up/down description")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220630122334.216903-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pinctrl/pinctrl-mt8195.yaml |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-mt8195.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-mt8195.yaml
@@ -49,7 +49,7 @@ properties:
     description: The interrupt outputs to sysirq.
     maxItems: 1
 
-  mediatek,rsel_resistance_in_si_unit:
+  mediatek,rsel-resistance-in-si-unit:
     type: boolean
     description: |
       Identifying i2c pins pull up/down type which is RSEL. It can support
@@ -142,7 +142,7 @@ patternProperties:
               "MTK_PUPD_SET_R1R0_11" define in mt8195.
               For pull down type is RSEL, it can add RSEL define & resistance
               value(ohm) to set different resistance by identifying property
-              "mediatek,rsel_resistance_in_si_unit".
+              "mediatek,rsel-resistance-in-si-unit".
               It can support "MTK_PULL_SET_RSEL_000" & "MTK_PULL_SET_RSEL_001"
               & "MTK_PULL_SET_RSEL_010" & "MTK_PULL_SET_RSEL_011"
               & "MTK_PULL_SET_RSEL_100" & "MTK_PULL_SET_RSEL_101"
@@ -161,7 +161,7 @@ patternProperties:
               };
               An example of using si unit resistance value(ohm):
               &pio {
-                mediatek,rsel_resistance_in_si_unit;
+                mediatek,rsel-resistance-in-si-unit;
               }
               pincontroller {
                 i2c0_pin {
@@ -190,7 +190,7 @@ patternProperties:
               "MTK_PUPD_SET_R1R0_11" define in mt8195.
               For pull up type is RSEL, it can add RSEL define & resistance
               value(ohm) to set different resistance by identifying property
-              "mediatek,rsel_resistance_in_si_unit".
+              "mediatek,rsel-resistance-in-si-unit".
               It can support "MTK_PULL_SET_RSEL_000" & "MTK_PULL_SET_RSEL_001"
               & "MTK_PULL_SET_RSEL_010" & "MTK_PULL_SET_RSEL_011"
               & "MTK_PULL_SET_RSEL_100" & "MTK_PULL_SET_RSEL_101"
@@ -209,7 +209,7 @@ patternProperties:
               };
               An example of using si unit resistance value(ohm):
               &pio {
-                mediatek,rsel_resistance_in_si_unit;
+                mediatek,rsel-resistance-in-si-unit;
               }
               pincontroller {
                 i2c0-pins {


