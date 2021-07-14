Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0163C8DA3
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbhGNTpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235744AbhGNToq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:44:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E57B613D7;
        Wed, 14 Jul 2021 19:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291683;
        bh=R0Iy83AXnoDTxq5mWPLNLkyKgTaVdgDvAA9n2tczZMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ud2/iDzuU9FDRoJGJ//jBPHfyrLWbW5NCsg1uy0hPo0RaHlDQIjInzAJVcdGN62VG
         HU5ai7Vm5KQ2gqftEJag8sMD1Auwl0UlRKMHaMokzurbH4NqI2BHVgILxvciDRxY0R
         HZ7M/yc1aYGDvisoI0U6AIAq0/KpxjoxtO41YjrzxqyUEu32KzL3daaxI/QV/PFHHE
         IvF6i9M42DQwengg0IqUjyBvXt0xshYB2biFweP8smBzJz5NW627sFDNFCA9ntwSp7
         eWu1O8kABnQe5REyL1e7dCw/YOl0Y/vDaLjKbe1JAfPW9f9H0UMFQWJNqJkPJhR0qJ
         zKaay1M3uXlyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 033/102] ARM: dts: ux500: Fix some compatible strings
Date:   Wed, 14 Jul 2021 15:39:26 -0400
Message-Id: <20210714194036.53141-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 59ba546d1662c4beb738725965041f350afe24b4 ]

The Golden and Skomer phones have BCM4334 WLAN+BT chips,
so make the compatible strings reflect the new available
bindings for these.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ux500-samsung-golden.dts | 3 ++-
 arch/arm/boot/dts/ste-ux500-samsung-janice.dts | 4 ++--
 arch/arm/boot/dts/ste-ux500-samsung-skomer.dts | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ux500-samsung-golden.dts b/arch/arm/boot/dts/ste-ux500-samsung-golden.dts
index 0d43ee6583cf..40df7c61bf69 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-golden.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-golden.dts
@@ -121,7 +121,7 @@ mmc@80118000 {
 			#size-cells = <0>;
 
 			wifi@1 {
-				compatible = "brcm,bcm4329-fmac";
+				compatible = "brcm,bcm4334-fmac", "brcm,bcm4329-fmac";
 				reg = <1>;
 
 				/* GPIO216 (WLAN_HOST_WAKE) */
@@ -162,6 +162,7 @@ uart@80120000 {
 			pinctrl-1 = <&u0_a_1_sleep>;
 
 			bluetooth {
+				/* BCM4334B0 actually */
 				compatible = "brcm,bcm4330-bt";
 				/* GPIO222 (BT_VREG_ON) */
 				shutdown-gpios = <&gpio6 30 GPIO_ACTIVE_HIGH>;
diff --git a/arch/arm/boot/dts/ste-ux500-samsung-janice.dts b/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
index 7411bfeda285..382f4af08a68 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
@@ -401,8 +401,7 @@ mmc@80118000 {
 			status = "okay";
 
 			wifi@1 {
-				/* Actually BRCM4330 */
-				compatible = "brcm,bcm4329-fmac";
+				compatible = "brcm,bcm4330-fmac", "brcm,bcm4329-fmac";
 				reg = <1>;
 				/* GPIO216 WL_HOST_WAKE */
 				interrupt-parent = <&gpio6>;
@@ -439,6 +438,7 @@ uart@80120000 {
 			status = "okay";
 
 			bluetooth {
+				/* BCM4330B1 actually */
 				compatible = "brcm,bcm4330-bt";
 				/*
 				 * We actually have shutdown-gpios, BT_VREG_EN on GPIO222,
diff --git a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
index d28a00757d0b..94afd7a0fe1f 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
@@ -211,7 +211,7 @@ mmc@80118000 {
 			#size-cells = <0>;
 
 			wifi@1 {
-				compatible = "brcm,bcm4329-fmac";
+				compatible = "brcm,bcm4334-fmac", "brcm,bcm4329-fmac";
 				reg = <1>;
 				/* GPIO216 WL_HOST_WAKE */
 				interrupt-parent = <&gpio6>;
@@ -247,6 +247,7 @@ uart@80120000 {
 
 			/* FIXME: not quite working yet, probably needs regulators */
 			bluetooth {
+				/* BCM4334B0 actually */
 				compatible = "brcm,bcm4330-bt";
 				shutdown-gpios = <&gpio6 30 GPIO_ACTIVE_HIGH>;
 				device-wakeup-gpios = <&gpio6 7 GPIO_ACTIVE_HIGH>;
-- 
2.30.2

