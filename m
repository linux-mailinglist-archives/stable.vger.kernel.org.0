Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4CA3C9042
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241088AbhGNTyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241057AbhGNTuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B052613D0;
        Wed, 14 Jul 2021 19:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292002;
        bh=zOeanC9POnTB2I2VTjYfpP5ZPLbMf/OB5zgMO4kotJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGsG5OMcN5qnGs5BAe5EzoiNIG5/ulH28aK3C4Bim00ggwNqbl7L7Frhzcj5WX+sL
         moYEKrG+9taM1k2xn1v2B9ZCS7uHQm62LDFkJaSARleB4S4AwpoZqTt94By2Xd+nBE
         RMLm65FlHjpvDA5qWbOIvwTPJREwTJKmpgNO5JOK2luTswWwr9kohqA8CSbSC5ozqT
         vgx9R/ryC5ZTWCBiIUshB0FOppklbpUGhwuZ6sbzxhuwEd3/IEDPF5PRw20pJSX2x4
         FF7LgVjbkses4k4tt2amkedZi0FvYeyLq8fJAdmk5vvQA9UR3/lW5RIjWspAqVVX46
         zXFfz+BulpXsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 12/39] ARM: NSP: dts: fix NAND nodes names
Date:   Wed, 14 Jul 2021 15:45:57 -0400
Message-Id: <20210714194625.55303-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
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
index b395cb195db2..71918d208fb3 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -259,7 +259,7 @@ mailbox: mailbox@25c00 {
 			dma-coherent;
 		};
 
-		nand: nand@26000 {
+		nand_controller: nand-controller@26000 {
 			compatible = "brcm,nand-iproc", "brcm,brcmnand-v6.1";
 			reg = <0x026000 0x600>,
 			      <0x11b408 0x600>,
diff --git a/arch/arm/boot/dts/bcm958522er.dts b/arch/arm/boot/dts/bcm958522er.dts
index f9dd342cc2ae..56f9181975b1 100644
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
index 374508a9cfbf..93a3e23ec7ae 100644
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
index 403250c5ad8e..fad974212d8a 100644
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
index ecd05e26c262..76ff9c50f62c 100644
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
index f5e85b301497..c2c90ea328a1 100644
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
index ea3fc194f8f3..6d0179acab38 100644
--- a/arch/arm/boot/dts/bcm958625hr.dts
+++ b/arch/arm/boot/dts/bcm958625hr.dts
@@ -76,8 +76,8 @@ &ehci0 {
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
index 3ea5f739e90b..579a88ce5b7f 100644
--- a/arch/arm/boot/dts/bcm958625k.dts
+++ b/arch/arm/boot/dts/bcm958625k.dts
@@ -69,8 +69,8 @@ &ehci0 {
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
index ea9a0806b446..a03224c54bbb 100644
--- a/arch/arm/boot/dts/bcm988312hr.dts
+++ b/arch/arm/boot/dts/bcm988312hr.dts
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
-- 
2.30.2

