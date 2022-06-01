Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9894D53A7AB
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354227AbiFAOCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355001AbiFAOBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:01:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407F4517D1;
        Wed,  1 Jun 2022 06:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E77AB81B08;
        Wed,  1 Jun 2022 13:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D1CC34119;
        Wed,  1 Jun 2022 13:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091790;
        bh=AwpP63mnwMx0YpBeBR+o75uBQzNi64ZU7FWswh0h5wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=diBVYcEXjBjVYFHzslVsM/BzxZ6jMADxL/7sm3dG8MWXVMUyS1UwMe9aJBCkOT3EL
         TmDpB4UfwndaWcbqUF5Ur8/zxDVIrv7MOPuUDI5mV+KPBT22R+vHCG6Ixwp7gu1qvW
         6HqkX8yUAlwr9a6IvG/HZ1g6bs3rfqzHzYXP2M9Vf5aCzh29WHXkROPJwmXa8SP9Kh
         c+2Vy/VRL1PwFhT7GDkqnPJigc/wShQ3FcseH69I1o5D7SziTjPKR6OBgC1c2Q0EZr
         SD12s7zLStrz7WAIh9lhD4NvXR68m8MO+17Z8jlVvnX5JGxsobgyo0Mw+dROkXB3t0
         7wOEpSi+jGMyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/37] ARM: dts: s5pv210: align DMA channels with dtschema
Date:   Wed,  1 Jun 2022 09:55:49 -0400
Message-Id: <20220601135622.2003939-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135622.2003939-1-sashal@kernel.org>
References: <20220601135622.2003939-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 9e916fb9bc3d16066286f19fc9c51d26a6aec6bd ]

dtschema expects DMA channels in specific order (tx, rx and tx-sec).
The order actually should not matter because dma-names is used however
let's make it aligned with dtschema to suppress warnings like:

  i2s@eee30000: dma-names: ['rx', 'tx', 'tx-sec'] is not valid under any of the given schemas

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Co-developed-by: Jonathan Bakker <xc-racer2@live.ca>
Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
Link: https://lore.kernel.org/r/CY4PR04MB056779A9C50DC95987C5272ACB1C9@CY4PR04MB0567.namprd04.prod.outlook.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s5pv210-aries.dtsi |  2 +-
 arch/arm/boot/dts/s5pv210.dtsi       | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/s5pv210-aries.dtsi b/arch/arm/boot/dts/s5pv210-aries.dtsi
index 160f8cd9a68d..148536a91676 100644
--- a/arch/arm/boot/dts/s5pv210-aries.dtsi
+++ b/arch/arm/boot/dts/s5pv210-aries.dtsi
@@ -636,7 +636,7 @@ touchscreen@4a {
 };
 
 &i2s0 {
-	dmas = <&pdma0 9>, <&pdma0 10>, <&pdma0 11>;
+	dmas = <&pdma0 10>, <&pdma0 9>, <&pdma0 11>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/s5pv210.dtsi b/arch/arm/boot/dts/s5pv210.dtsi
index 353ba7b09a0c..c5265f3ae31d 100644
--- a/arch/arm/boot/dts/s5pv210.dtsi
+++ b/arch/arm/boot/dts/s5pv210.dtsi
@@ -239,8 +239,8 @@ i2s0: i2s@eee30000 {
 			reg = <0xeee30000 0x1000>;
 			interrupt-parent = <&vic2>;
 			interrupts = <16>;
-			dma-names = "rx", "tx", "tx-sec";
-			dmas = <&pdma1 9>, <&pdma1 10>, <&pdma1 11>;
+			dma-names = "tx", "rx", "tx-sec";
+			dmas = <&pdma1 10>, <&pdma1 9>, <&pdma1 11>;
 			clock-names = "iis",
 				      "i2s_opclk0",
 				      "i2s_opclk1";
@@ -259,8 +259,8 @@ i2s1: i2s@e2100000 {
 			reg = <0xe2100000 0x1000>;
 			interrupt-parent = <&vic2>;
 			interrupts = <17>;
-			dma-names = "rx", "tx";
-			dmas = <&pdma1 12>, <&pdma1 13>;
+			dma-names = "tx", "rx";
+			dmas = <&pdma1 13>, <&pdma1 12>;
 			clock-names = "iis", "i2s_opclk0";
 			clocks = <&clocks CLK_I2S1>, <&clocks SCLK_AUDIO1>;
 			pinctrl-names = "default";
@@ -274,8 +274,8 @@ i2s2: i2s@e2a00000 {
 			reg = <0xe2a00000 0x1000>;
 			interrupt-parent = <&vic2>;
 			interrupts = <18>;
-			dma-names = "rx", "tx";
-			dmas = <&pdma1 14>, <&pdma1 15>;
+			dma-names = "tx", "rx";
+			dmas = <&pdma1 15>, <&pdma1 14>;
 			clock-names = "iis", "i2s_opclk0";
 			clocks = <&clocks CLK_I2S2>, <&clocks SCLK_AUDIO2>;
 			pinctrl-names = "default";
-- 
2.35.1

