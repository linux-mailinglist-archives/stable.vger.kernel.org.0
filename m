Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1EF4679A37
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbjAXNpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbjAXNov (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:44:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0BC457F3;
        Tue, 24 Jan 2023 05:43:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A9DDB811D5;
        Tue, 24 Jan 2023 13:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A5DC433D2;
        Tue, 24 Jan 2023 13:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567811;
        bh=PkH1ckxbwV8PR9YZccXb30VGjW1ffGRBVluUZi7xmMk=;
        h=From:To:Cc:Subject:Date:From;
        b=nhAW6SgWYJI4jvbh2Wrs2zuLC9KIhV7V/JthHgE3DSbyk1M525BzLALCBMezpqD9J
         Av2gcoNSKwsKaAF7DQI38/Z6EDdR20XR1sYY3kTkrlwgPEUiw6xdpXjelhrNssjylA
         OWslw2T19VGr4mK5/PSrjaDYiCwRQ3AKmUFqkO7pjn9kk8AqoMoxDkD1Nh5TPS4jS3
         lCgjCSpXkHmgf1/CU+TZlHAku/yshE51yiijm6xXFNYjbod7LxUz9j40dszo0IFe+6
         7sfzcPdB/rlJ4u5w2bJg1Q22qhHu8MfW697aPOQXySutmroxC1LkUbwAXCrH9C3hf3
         m7Wa2IGbWTUlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 1/8] ARM: dts: imx: Fix pca9547 i2c-mux node name
Date:   Tue, 24 Jan 2023 08:43:21 -0500
Message-Id: <20230124134328.637707-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f78985f9f58380eec37f82c8a2c765aa7670fc29 ]

"make dtbs_check":

    arch/arm/boot/dts/imx53-ppd.dtb: i2c-switch@70: $nodename:0: 'i2c-switch@70' does not match '^(i2c-?)?mux'
	    From schema: Documentation/devicetree/bindings/i2c/i2c-mux-pca954x.yaml
    arch/arm/boot/dts/imx53-ppd.dtb: i2c-switch@70: Unevaluated properties are not allowed ('#address-cells', '#size-cells', 'i2c@0', 'i2c@1', 'i2c@2', 'i2c@3', 'i2c@4', 'i2c@5', 'i2c@6', 'i2c@7' were unexpected)
	    From schema: Documentation/devicetree/bindings/i2c/i2c-mux-pca954x.yaml

Fix this by renaming the PCA9547 node to "i2c-mux", to match the I2C bus
multiplexer/switch DT bindings and the Generic Names Recommendation in
the Devicetree Specification.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx53-ppd.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx53-ppd.dts b/arch/arm/boot/dts/imx53-ppd.dts
index 006fbd7f5432..54e39db447c4 100644
--- a/arch/arm/boot/dts/imx53-ppd.dts
+++ b/arch/arm/boot/dts/imx53-ppd.dts
@@ -487,7 +487,7 @@ &i2c1 {
 	scl-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 
-	i2c-switch@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9547";
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.39.0

