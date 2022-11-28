Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C6F63AFA3
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbiK1Rnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiK1RnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:43:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F9B28E33;
        Mon, 28 Nov 2022 09:40:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80288B80EA3;
        Mon, 28 Nov 2022 17:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26145C433B5;
        Mon, 28 Nov 2022 17:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657234;
        bh=NU2X+HF+HAIFurq7l0JAPF1GX7mDTeJp537Y7pcIZs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+FrWy2Nbb+qsFDlsHhFXOoJ/kVmcjuPE68QbOLixEqrjZ161ITsetEb2ZN0Zsknl
         bb+7VJ0DdUKfNb1SMaGdM6+e02EypjZjpYHHBqlksTcQbLXzhPI7V0+TnFym2B1Rva
         EEcAvV/5XQiZjPJ/P7Y/DNltQvX8II0t9NokymvPGaPaT7/NLJ/SqvjMi3nVe0jS1e
         KhKmvhbPtVIoRJxGR7z5SHkJ5MVMYzdwJK4kkXbaghEwVEDT7Jat9jDMMOOLy2YyIG
         lxd1TnrTttJQRU9ajN2jNH4bVf0zxVOjdx4cqN6hBFvD3gpaGJtYKvkYhR0I0DT8jW
         myVLwWUPjGnow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/24] arm: dts: rockchip: remove clock-frequency from rtc
Date:   Mon, 28 Nov 2022 12:40:03 -0500
Message-Id: <20221128174027.1441921-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174027.1441921-1-sashal@kernel.org>
References: <20221128174027.1441921-1-sashal@kernel.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 6122f3be70d90a1b2a1188d8910256fc218376a9 ]

'clock-frequency' is not part of the DT binding and not supported by the
Linux driver.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20221024165549.74574-5-sebastian.reichel@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3036-evb.dts          | 1 -
 arch/arm/boot/dts/rk3288-firefly.dtsi     | 1 -
 arch/arm/boot/dts/rk3288-miqi.dts         | 1 -
 arch/arm/boot/dts/rk3288-rock2-square.dts | 1 -
 arch/arm/boot/dts/rk3288-vmarc-som.dtsi   | 1 -
 5 files changed, 5 deletions(-)

diff --git a/arch/arm/boot/dts/rk3036-evb.dts b/arch/arm/boot/dts/rk3036-evb.dts
index ea23ba98625e..94216f870b57 100644
--- a/arch/arm/boot/dts/rk3036-evb.dts
+++ b/arch/arm/boot/dts/rk3036-evb.dts
@@ -35,7 +35,6 @@ hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
-		clock-frequency = <32768>;
 		clock-output-names = "xin32k";
 	};
 };
diff --git a/arch/arm/boot/dts/rk3288-firefly.dtsi b/arch/arm/boot/dts/rk3288-firefly.dtsi
index c560afe3af78..74ba7e21850a 100644
--- a/arch/arm/boot/dts/rk3288-firefly.dtsi
+++ b/arch/arm/boot/dts/rk3288-firefly.dtsi
@@ -237,7 +237,6 @@ hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
-		clock-frequency = <32768>;
 		clock-output-names = "xin32k";
 		interrupt-parent = <&gpio7>;
 		interrupts = <RK_PA4 IRQ_TYPE_EDGE_FALLING>;
diff --git a/arch/arm/boot/dts/rk3288-miqi.dts b/arch/arm/boot/dts/rk3288-miqi.dts
index e3d5644f2915..db1eb648e0e1 100644
--- a/arch/arm/boot/dts/rk3288-miqi.dts
+++ b/arch/arm/boot/dts/rk3288-miqi.dts
@@ -166,7 +166,6 @@ hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
-		clock-frequency = <32768>;
 		clock-output-names = "xin32k";
 	};
 
diff --git a/arch/arm/boot/dts/rk3288-rock2-square.dts b/arch/arm/boot/dts/rk3288-rock2-square.dts
index d5ef99ebbddc..bc44606ca05d 100644
--- a/arch/arm/boot/dts/rk3288-rock2-square.dts
+++ b/arch/arm/boot/dts/rk3288-rock2-square.dts
@@ -169,7 +169,6 @@ hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
-		clock-frequency = <32768>;
 		clock-output-names = "xin32k";
 		interrupt-parent = <&gpio0>;
 		interrupts = <RK_PA4 IRQ_TYPE_EDGE_FALLING>;
diff --git a/arch/arm/boot/dts/rk3288-vmarc-som.dtsi b/arch/arm/boot/dts/rk3288-vmarc-som.dtsi
index 0ae2bd150e37..793951655b73 100644
--- a/arch/arm/boot/dts/rk3288-vmarc-som.dtsi
+++ b/arch/arm/boot/dts/rk3288-vmarc-som.dtsi
@@ -241,7 +241,6 @@ hym8563: rtc@51 {
 		interrupt-parent = <&gpio5>;
 		interrupts = <RK_PC3 IRQ_TYPE_LEVEL_LOW>;
 		#clock-cells = <0>;
-		clock-frequency = <32768>;
 		clock-output-names = "hym8563";
 		pinctrl-names = "default";
 		pinctrl-0 = <&hym8563_int>;
-- 
2.35.1

