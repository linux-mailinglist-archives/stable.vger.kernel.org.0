Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F933C8DA0
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbhGNTpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236922AbhGNToi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:44:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3185F6044F;
        Wed, 14 Jul 2021 19:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291680;
        bh=lGiuBppMhhfO9GiX/vKCQNCV/5l1emD0N5unZTaplBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RoHxOT0i6blmLrDo7f+G2Oo/n1NDHKhT+n+7dEU/qCo7sg1uckKCmZ7bVjjPB6fL7
         e9FMmwx7DsoS7H5pd/6gEK8fxbCFWOcRBB7KttklqSsyQ6V96eSgd1IW2pceNMlUcv
         XZrB8xVexQfWIZSHv8aHtAhLBcXgru0iT3KxAOhggXFIRO3axvZ9Tz6Gx42M2mixrc
         iTPB6XMKtNvxEtXIjcGATYCc78H8x0aPVPuqEFd8InX9nKVlY7LhNNztT5284/AoDw
         sJCKMbxqvfIkeBUBKFWWh8p0WuVdB6+6T3KBfOTZMiywspkwHdP5XXGMK6iJtdJEUq
         gJ26+TykSbLrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 030/102] ARM: dts: ux500: Fix interrupt cells
Date:   Wed, 14 Jul 2021 15:39:23 -0400
Message-Id: <20210714194036.53141-30-sashal@kernel.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit e4ff0112a03c2e353c8457cd33c88feb89dfec41 ]

Fix interrupt cells in DT AB8500/AB8505 source files. The
compiled DTB files will stay the same.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ab8500.dtsi | 26 +++++++++++++-------------
 arch/arm/boot/dts/ste-ab8505.dtsi | 22 +++++++++++-----------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ab8500.dtsi b/arch/arm/boot/dts/ste-ab8500.dtsi
index 4fd09997a2b9..5c5a5a2dadfc 100644
--- a/arch/arm/boot/dts/ste-ab8500.dtsi
+++ b/arch/arm/boot/dts/ste-ab8500.dtsi
@@ -42,15 +42,15 @@ ab8500_gpio: ab8500-gpio {
 
 				ab8500-rtc {
 					compatible = "stericsson,ab8500-rtc";
-					interrupts = <17 IRQ_TYPE_LEVEL_HIGH
-						      18 IRQ_TYPE_LEVEL_HIGH>;
+					interrupts = <17 IRQ_TYPE_LEVEL_HIGH>,
+						     <18 IRQ_TYPE_LEVEL_HIGH>;
 					interrupt-names = "60S", "ALARM";
 				};
 
 				gpadc: ab8500-gpadc {
 					compatible = "stericsson,ab8500-gpadc";
-					interrupts = <32 IRQ_TYPE_LEVEL_HIGH
-						      39 IRQ_TYPE_LEVEL_HIGH>;
+					interrupts = <32 IRQ_TYPE_LEVEL_HIGH>,
+						     <39 IRQ_TYPE_LEVEL_HIGH>;
 					interrupt-names = "HW_CONV_END", "SW_CONV_END";
 					vddadc-supply = <&ab8500_ldo_tvout_reg>;
 					#address-cells = <1>;
@@ -219,13 +219,13 @@ ab8500_chargalg {
 
 				ab8500_usb {
 					compatible = "stericsson,ab8500-usb";
-					interrupts = < 90 IRQ_TYPE_LEVEL_HIGH
-						       96 IRQ_TYPE_LEVEL_HIGH
-						       14 IRQ_TYPE_LEVEL_HIGH
-						       15 IRQ_TYPE_LEVEL_HIGH
-						       79 IRQ_TYPE_LEVEL_HIGH
-						       74 IRQ_TYPE_LEVEL_HIGH
-						       75 IRQ_TYPE_LEVEL_HIGH>;
+					interrupts = <90 IRQ_TYPE_LEVEL_HIGH>,
+						     <96 IRQ_TYPE_LEVEL_HIGH>,
+						     <14 IRQ_TYPE_LEVEL_HIGH>,
+						     <15 IRQ_TYPE_LEVEL_HIGH>,
+						     <79 IRQ_TYPE_LEVEL_HIGH>,
+						     <74 IRQ_TYPE_LEVEL_HIGH>,
+						     <75 IRQ_TYPE_LEVEL_HIGH>;
 					interrupt-names = "ID_WAKEUP_R",
 							  "ID_WAKEUP_F",
 							  "VBUS_DET_F",
@@ -242,8 +242,8 @@ ab8500_usb {
 
 				ab8500-ponkey {
 					compatible = "stericsson,ab8500-poweron-key";
-					interrupts = <6 IRQ_TYPE_LEVEL_HIGH
-						      7 IRQ_TYPE_LEVEL_HIGH>;
+					interrupts = <6 IRQ_TYPE_LEVEL_HIGH>,
+						     <7 IRQ_TYPE_LEVEL_HIGH>;
 					interrupt-names = "ONKEY_DBF", "ONKEY_DBR";
 				};
 
diff --git a/arch/arm/boot/dts/ste-ab8505.dtsi b/arch/arm/boot/dts/ste-ab8505.dtsi
index cc045b2fc217..3380afa74c14 100644
--- a/arch/arm/boot/dts/ste-ab8505.dtsi
+++ b/arch/arm/boot/dts/ste-ab8505.dtsi
@@ -39,8 +39,8 @@ ab8505_gpio: ab8505-gpio {
 
 				ab8500-rtc {
 					compatible = "stericsson,ab8500-rtc";
-					interrupts = <17 IRQ_TYPE_LEVEL_HIGH
-						      18 IRQ_TYPE_LEVEL_HIGH>;
+					interrupts = <17 IRQ_TYPE_LEVEL_HIGH>,
+						     <18 IRQ_TYPE_LEVEL_HIGH>;
 					interrupt-names = "60S", "ALARM";
 				};
 
@@ -182,13 +182,13 @@ ab8500_chargalg {
 
 				ab8500_usb: ab8500_usb {
 					compatible = "stericsson,ab8500-usb";
-					interrupts = < 90 IRQ_TYPE_LEVEL_HIGH
-						       96 IRQ_TYPE_LEVEL_HIGH
-						       14 IRQ_TYPE_LEVEL_HIGH
-						       15 IRQ_TYPE_LEVEL_HIGH
-						       79 IRQ_TYPE_LEVEL_HIGH
-						       74 IRQ_TYPE_LEVEL_HIGH
-						       75 IRQ_TYPE_LEVEL_HIGH>;
+					interrupts = <90 IRQ_TYPE_LEVEL_HIGH>,
+						     <96 IRQ_TYPE_LEVEL_HIGH>,
+						     <14 IRQ_TYPE_LEVEL_HIGH>,
+						     <15 IRQ_TYPE_LEVEL_HIGH>,
+						     <79 IRQ_TYPE_LEVEL_HIGH>,
+						     <74 IRQ_TYPE_LEVEL_HIGH>,
+						     <75 IRQ_TYPE_LEVEL_HIGH>;
 					interrupt-names = "ID_WAKEUP_R",
 							  "ID_WAKEUP_F",
 							  "VBUS_DET_F",
@@ -205,8 +205,8 @@ ab8500_usb: ab8500_usb {
 
 				ab8500-ponkey {
 					compatible = "stericsson,ab8500-poweron-key";
-					interrupts = <6 IRQ_TYPE_LEVEL_HIGH
-						      7 IRQ_TYPE_LEVEL_HIGH>;
+					interrupts = <6 IRQ_TYPE_LEVEL_HIGH>,
+						     <7 IRQ_TYPE_LEVEL_HIGH>;
 					interrupt-names = "ONKEY_DBF", "ONKEY_DBR";
 				};
 
-- 
2.30.2

