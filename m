Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0F963AF15
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbiK1Ri0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbiK1RiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:38:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CFCC778;
        Mon, 28 Nov 2022 09:38:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFA17612CF;
        Mon, 28 Nov 2022 17:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB60C433D7;
        Mon, 28 Nov 2022 17:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657096;
        bh=NhCnSawSEobZjid9+fA1B/I6eQ/GY3dTQGYeDOQ2MRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lc6xMI5a7rua4VnTZ/vDC35kQ7AiswltRY9fxjdVKC9uZqRETaQ/o8U2d3lGiSyxs
         H3vObxgvEaSUQQqg+deM8jnQB2s9kuhvkTG7sWbFO3lqsLtydydlISBlohPz59emdX
         mo7DKJ5GUxsoFl0WWipsL2YUUH8T3iDcXAxj9e2uJ8QYGsH4VthwQmJsaN1I32kQq8
         jKBRfFMKbzxT/WT0655yD62pMtYz+oyJ8FD5QmQG3u3qoIBXpNuqlzVUgXBgCpg/c1
         LPykERqgOdNHsjYXD8NXRhigdWnGHlnlpHlEh6S+ysMd7rNLy09yGBHTsytFvUqdtZ
         wsizWpHkv9/6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, robin.murphy@arm.com,
        macromorgan@hotmail.com, samuel@sholland.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 09/39] arm64: dts: rockchip: fix adc-keys sub node names
Date:   Mon, 28 Nov 2022 12:35:49 -0500
Message-Id: <20221128173642.1441232-9-sashal@kernel.org>
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

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit f2bd2e76d6ea13e12849975adae46145375532a4 ]

Fix adc-keys sub node names on Rockchip boards,
so that they match with regex: '^button-'

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/6a6a3603-5540-cacc-2672-c015af1ec684@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/px30-evb.dts            | 10 +++++-----
 arch/arm64/boot/dts/rockchip/rk3308-evb.dts          | 12 ++++++------
 arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts      |  2 +-
 arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi |  2 +-
 arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts    |  2 +-
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-m4b.dts   |  2 +-
 arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts     |  4 ++--
 arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi      |  2 +-
 .../boot/dts/rockchip/rk3399-sapphire-excavator.dts  |  4 ++--
 arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi    |  2 +-
 10 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/px30-evb.dts b/arch/arm64/boot/dts/rockchip/px30-evb.dts
index 848bc39cf86a..4249b42843da 100644
--- a/arch/arm64/boot/dts/rockchip/px30-evb.dts
+++ b/arch/arm64/boot/dts/rockchip/px30-evb.dts
@@ -30,31 +30,31 @@ adc-keys {
 		keyup-threshold-microvolt = <1800000>;
 		poll-interval = <100>;
 
-		esc-key {
+		button-esc {
 			label = "esc";
 			linux,code = <KEY_ESC>;
 			press-threshold-microvolt = <1310000>;
 		};
 
-		home-key {
+		button-home {
 			label = "home";
 			linux,code = <KEY_HOME>;
 			press-threshold-microvolt = <624000>;
 		};
 
-		menu-key {
+		button-menu {
 			label = "menu";
 			linux,code = <KEY_MENU>;
 			press-threshold-microvolt = <987000>;
 		};
 
-		vol-down-key {
+		button-down {
 			label = "volume down";
 			linux,code = <KEY_VOLUMEDOWN>;
 			press-threshold-microvolt = <300000>;
 		};
 
-		vol-up-key {
+		button-up {
 			label = "volume up";
 			linux,code = <KEY_VOLUMEUP>;
 			press-threshold-microvolt = <17000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3308-evb.dts b/arch/arm64/boot/dts/rockchip/rk3308-evb.dts
index 9fe9b0d11003..184b84fdde07 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-evb.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-evb.dts
@@ -23,7 +23,7 @@ adc-keys0 {
 		poll-interval = <100>;
 		keyup-threshold-microvolt = <1800000>;
 
-		func-key {
+		button-func {
 			linux,code = <KEY_FN>;
 			label = "function";
 			press-threshold-microvolt = <18000>;
@@ -37,31 +37,31 @@ adc-keys1 {
 		poll-interval = <100>;
 		keyup-threshold-microvolt = <1800000>;
 
-		esc-key {
+		button-esc {
 			linux,code = <KEY_MICMUTE>;
 			label = "micmute";
 			press-threshold-microvolt = <1130000>;
 		};
 
-		home-key {
+		button-home {
 			linux,code = <KEY_MODE>;
 			label = "mode";
 			press-threshold-microvolt = <901000>;
 		};
 
-		menu-key {
+		button-menu {
 			linux,code = <KEY_PLAY>;
 			label = "play";
 			press-threshold-microvolt = <624000>;
 		};
 
-		vol-down-key {
+		button-down {
 			linux,code = <KEY_VOLUMEDOWN>;
 			label = "volume down";
 			press-threshold-microvolt = <300000>;
 		};
 
-		vol-up-key {
+		button-up {
 			linux,code = <KEY_VOLUMEUP>;
 			label = "volume up";
 			press-threshold-microvolt = <18000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts b/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts
index 43c928ac98f0..1deef53a4c94 100644
--- a/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts
@@ -25,7 +25,7 @@ adc-keys {
 		keyup-threshold-microvolt = <1800000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <17000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
index 2a332763c35c..9d9297bc5f04 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
@@ -123,7 +123,7 @@ adc-keys {
 		keyup-threshold-microvolt = <1800000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "Recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <18000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts b/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts
index 452728b82e42..3bf8f959e42c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts
@@ -39,7 +39,7 @@ adc-keys {
 		keyup-threshold-microvolt = <1800000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "Recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <18000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-nanopi-m4b.dts b/arch/arm64/boot/dts/rockchip/rk3399-nanopi-m4b.dts
index 72182c58cc46..65cb21837b0c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopi-m4b.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopi-m4b.dts
@@ -19,7 +19,7 @@ adc-keys {
 		keyup-threshold-microvolt = <1500000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "Recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <18000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts b/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts
index 9e2e246e0bab..dba4d03bfc2b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts
@@ -52,13 +52,13 @@ button-down {
 			press-threshold-microvolt = <300000>;
 		};
 
-		back {
+		button-back {
 			label = "Back";
 			linux,code = <KEY_BACK>;
 			press-threshold-microvolt = <985000>;
 		};
 
-		menu {
+		button-menu {
 			label = "Menu";
 			linux,code = <KEY_MENU>;
 			press-threshold-microvolt = <1314000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
index acb174d3a8c5..4f3dd107e83e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
@@ -41,7 +41,7 @@ adc-keys {
 		keyup-threshold-microvolt = <1500000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "Recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <18000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts b/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
index 13927e7d0724..dbec2b7173a0 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
@@ -33,13 +33,13 @@ button-down {
 			press-threshold-microvolt = <300000>;
 		};
 
-		back {
+		button-back {
 			label = "Back";
 			linux,code = <KEY_BACK>;
 			press-threshold-microvolt = <985000>;
 		};
 
-		menu {
+		button-menu {
 			label = "Menu";
 			linux,code = <KEY_MENU>;
 			press-threshold-microvolt = <1314000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
index 0d45868132b9..8d61f824c12d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
@@ -23,7 +23,7 @@ adc-keys {
 		io-channel-names = "buttons";
 		keyup-threshold-microvolt = <1750000>;
 
-		recovery {
+		button-recovery {
 			label = "recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <0>;
-- 
2.35.1

