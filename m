Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA2963AF0F
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbiK1Rhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbiK1Rht (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:37:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37988FD8;
        Mon, 28 Nov 2022 09:37:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE355B80E9C;
        Mon, 28 Nov 2022 17:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9706BC433C1;
        Mon, 28 Nov 2022 17:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657065;
        bh=gmkBu6REaQ2FrvNzHeMXPL0I8IWMao1UQq/UCN7sQcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvOESTzqN+KQG2l+koteId1yA/uilVIzKP/D6EtcyGgU39U3c4S34lfqDHT+HKo7s
         QjM74w5WhxZnsYUcVTdL9IGRQKEaws9+XF7uvEdX1lM5YjfQ9IsrXU11cNozFU1qme
         3Fmx/eGsIVc+q47+RcmKsIuMzVeLW3gf93tKINdhDRJ0TWBS7KnnlhurUQj7ogDhs+
         ltKCdhmBYMB8QE1/OS/gkWWLuLnU97a7XH1gg3qMXIhdONZxu6ME8zMRVwSYIPktR3
         CamM9u1cI812bRHqEEcc8zHK+6EkPq40kEKYD65YkslnyVU4UbPlZKMvkXC4zau3l0
         5QKqc7lXQGPIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 07/39] arm: dts: rockchip: remove clock-frequency from rtc
Date:   Mon, 28 Nov 2022 12:35:47 -0500
Message-Id: <20221128173642.1441232-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
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
index 9267857beccb..3836c61cfb76 100644
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
index 07a3a52753d2..13cfdaa95cc7 100644
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

