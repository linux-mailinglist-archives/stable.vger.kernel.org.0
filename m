Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1477E3C8F30
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241139AbhGNTwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236618AbhGNTsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:48:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF28161404;
        Wed, 14 Jul 2021 19:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291824;
        bh=jh2jcy3zaJ/o2I2ivrDEqRXe026FW98yPavfk4B6pAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbb3bk+QJABBOpWrfiSITNuIWZrGC9I/abNkJNdxB7dkKpSmhYLTQ7+iKrEsLICi9
         3W0OVeKCRH7CkX/UXOzS6AvpTqDR8U0VKsNpmINYS2LaD2WgDuvyVcRE6XOjChaiM4
         TJLp6CdGvfOfPEDM2/+w0y34X3WTpP7DwyGpeH9he/4nI6LFE+yKegyysO2+YD5VhF
         2r/4sgK3LVWlN4Mp9FxVg/uaUT8w25pqI3sh7LyKo3DBG8CNAL+KnUUfiDaKt+Puu2
         Z+t5lBIamLUqnskiRyj/iA3FFcpamb1Rwc1k+eFUkivzHJkkb0YH52tUxH4HUm7VfF
         7JMD/5QgEFH2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 25/88] ARM: dts: ux500: Fix interrupt cells
Date:   Wed, 14 Jul 2021 15:42:00 -0400
Message-Id: <20210714194303.54028-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
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
index aab5719cc1a9..5fde474ade22 100644
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
@@ -169,13 +169,13 @@ ab8500_chargalg {
 
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
@@ -192,8 +192,8 @@ ab8500_usb {
 
 				ab8500-ponkey {
 					compatible = "stericsson,ab8500-poweron-key";
-					interrupts = <6 IRQ_TYPE_LEVEL_HIGH
-						      7 IRQ_TYPE_LEVEL_HIGH>;
+					interrupts = <6 IRQ_TYPE_LEVEL_HIGH>,
+						     <7 IRQ_TYPE_LEVEL_HIGH>;
 					interrupt-names = "ONKEY_DBF", "ONKEY_DBR";
 				};
 
diff --git a/arch/arm/boot/dts/ste-ab8505.dtsi b/arch/arm/boot/dts/ste-ab8505.dtsi
index 67bc69e67b33..dbaedda2824d 100644
--- a/arch/arm/boot/dts/ste-ab8505.dtsi
+++ b/arch/arm/boot/dts/ste-ab8505.dtsi
@@ -38,8 +38,8 @@ ab8505_gpio: ab8505-gpio {
 
 				ab8500-rtc {
 					compatible = "stericsson,ab8500-rtc";
-					interrupts = <17 IRQ_TYPE_LEVEL_HIGH
-						      18 IRQ_TYPE_LEVEL_HIGH>;
+					interrupts = <17 IRQ_TYPE_LEVEL_HIGH>,
+						     <18 IRQ_TYPE_LEVEL_HIGH>;
 					interrupt-names = "60S", "ALARM";
 				};
 
@@ -131,13 +131,13 @@ ab8500_chargalg {
 
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
@@ -154,8 +154,8 @@ ab8500_usb: ab8500_usb {
 
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

