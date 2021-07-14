Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C22C3C8F25
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbhGNTvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238648AbhGNTsI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:48:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A89261406;
        Wed, 14 Jul 2021 19:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291813;
        bh=G/1c8Lr9WLTV5oA8N6bPvQbRI94h8VFFWZjjw/vco6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQkg3Y3sSkJCFegaUyNjjLkcx3lS52/L4IFlA61xu8eYN6KwOxlzE5JfLYpTCk+78
         TPpQm68wCZSHxx0w4FNkElvB8m51+xF3A8EulBoFJ1CTtYDb5i2O/6tUeds2q0bcmD
         yi1adsEqaT52mx9PQnVA6q9NjWP+Q+cH6g4QokEpM5D9ZLThpIIReYLmyoqkSUIWkG
         izlNCXuZqwCsBsl6R33I0IXbAmD8nRTgMZBoDrPY3mTDN1RoGGowS4UtEV5qD7igDY
         GEJBgm28Hixdg8tiMmVjG8C596WPw3D7V00iJ2uQFJ6WYqFeXNPkA4b+XFtqxlZxeC
         yDwk3Et1NG19g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 17/88] ARM: NSP: dts: fix NAND nodes names
Date:   Wed, 14 Jul 2021 15:41:52 -0400
Message-Id: <20210714194303.54028-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 0484594be733d5cdf976f55a2d4e8d887f351b69 ]

This matches nand-controller.yaml requirements.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm-nsp.dtsi     | 2 +-
 arch/arm/boot/dts/bcm958522er.dts  | 4 ++--
 arch/arm/boot/dts/bcm958525er.dts  | 4 ++--
 arch/arm/boot/dts/bcm958525xmc.dts | 4 ++--
 arch/arm/boot/dts/bcm958622hr.dts  | 4 ++--
 arch/arm/boot/dts/bcm958623hr.dts  | 4 ++--
 arch/arm/boot/dts/bcm958625hr.dts  | 4 ++--
 arch/arm/boot/dts/bcm958625k.dts   | 4 ++--
 arch/arm/boot/dts/bcm988312hr.dts  | 4 ++--
 9 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index e895f7cb8c9f..605b6d2f4a56 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -269,7 +269,7 @@ mailbox: mailbox@25c00 {
 			dma-coherent;
 		};
 
-		nand: nand@26000 {
+		nand_controller: nand-controller@26000 {
 			compatible = "brcm,nand-iproc", "brcm,brcmnand-v6.1";
 			reg = <0x026000 0x600>,
 			      <0x11b408 0x600>,
diff --git a/arch/arm/boot/dts/bcm958522er.dts b/arch/arm/boot/dts/bcm958522er.dts
index 7be4c4e628e0..5dd1001255c6 100644
--- a/arch/arm/boot/dts/bcm958522er.dts
+++ b/arch/arm/boot/dts/bcm958522er.dts
@@ -74,8 +74,8 @@ &ehci0 {
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958525er.dts b/arch/arm/boot/dts/bcm958525er.dts
index e58ed7e95346..0e624c57b585 100644
--- a/arch/arm/boot/dts/bcm958525er.dts
+++ b/arch/arm/boot/dts/bcm958525er.dts
@@ -74,8 +74,8 @@ &ehci0 {
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958525xmc.dts b/arch/arm/boot/dts/bcm958525xmc.dts
index 21f922dc6019..2ac6d61ad297 100644
--- a/arch/arm/boot/dts/bcm958525xmc.dts
+++ b/arch/arm/boot/dts/bcm958525xmc.dts
@@ -90,8 +90,8 @@ rtc@68 {
 	};
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958622hr.dts b/arch/arm/boot/dts/bcm958622hr.dts
index a49c2fd21f4a..e072fa83537a 100644
--- a/arch/arm/boot/dts/bcm958622hr.dts
+++ b/arch/arm/boot/dts/bcm958622hr.dts
@@ -78,8 +78,8 @@ &ehci0 {
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958623hr.dts b/arch/arm/boot/dts/bcm958623hr.dts
index dd6dff6452b8..835f4765efbc 100644
--- a/arch/arm/boot/dts/bcm958623hr.dts
+++ b/arch/arm/boot/dts/bcm958623hr.dts
@@ -78,8 +78,8 @@ &ehci0 {
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958625hr.dts b/arch/arm/boot/dts/bcm958625hr.dts
index a71371b4065e..57974b8fab86 100644
--- a/arch/arm/boot/dts/bcm958625hr.dts
+++ b/arch/arm/boot/dts/bcm958625hr.dts
@@ -89,8 +89,8 @@ &ehci0 {
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958625k.dts b/arch/arm/boot/dts/bcm958625k.dts
index 7782b61c51a1..45a043ea77ce 100644
--- a/arch/arm/boot/dts/bcm958625k.dts
+++ b/arch/arm/boot/dts/bcm958625k.dts
@@ -68,8 +68,8 @@ &ehci0 {
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm988312hr.dts b/arch/arm/boot/dts/bcm988312hr.dts
index edd0f630e025..16b212cc8a2a 100644
--- a/arch/arm/boot/dts/bcm988312hr.dts
+++ b/arch/arm/boot/dts/bcm988312hr.dts
@@ -74,8 +74,8 @@ &ehci0 {
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
-- 
2.30.2

