Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F51F3C8C29
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhGNTlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231374AbhGNTlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E08AC61370;
        Wed, 14 Jul 2021 19:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291505;
        bh=/OMdn+Dia/YFkOhVcZhXZgsNWYdusmWoZUgFgMP1nyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eADHVMVYR30aV8e63xhzGoLwq0paAo+MCq+Fwh/T3+jldYtFYTyKk4q9Clv5K1qzq
         TGZj6o3W1Vtyw+UwozNZ01resJudWLMoCUpu6QKp32XCumnpiSYkdv0VQok3cFAbDH
         Z3dSRcee87Rw3wsdVpws7qrYdp/yW5ybwyBYYVN9lYcHkJkd0I3IsgNcjRCvEMIVlO
         Nx4leGdqkMCzu86biR611Tpf+SCjUGvVgSOp5Cjwea5R7QYX1QKW7BEWW/faC5Y3gH
         OTT2wp+6fbA9dIM1MFA2OYRFVuALyvX4cBRgMLWzgfB5o3p18FLadciChVObEtT5dk
         zxjYQ5COlIG3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 016/108] ARM: dts: BCM5301X: Fix NAND nodes names
Date:   Wed, 14 Jul 2021 15:36:28 -0400
Message-Id: <20210714193800.52097-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit b660269cba748dfd07eb5551a88ff34d5ea0b86e ]

This matches nand-controller.yaml requirements.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts      | 4 ++--
 arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts     | 4 ++--
 arch/arm/boot/dts/bcm5301x-nand-cs0.dtsi          | 4 ++--
 arch/arm/boot/dts/bcm5301x.dtsi                   | 2 +-
 arch/arm/boot/dts/bcm953012k.dts                  | 4 ++--
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts b/arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts
index 8636600385fd..c81944cd6d0b 100644
--- a/arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts
+++ b/arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts
@@ -24,8 +24,8 @@ memory@0 {
 		reg = <0x00000000 0x08000000>;
 	};
 
-	nand: nand@18028000 {
-		nandcs@0 {
+	nand_controller: nand-controller@18028000 {
+		nand@0 {
 			partitions {
 				compatible = "fixed-partitions";
 				#address-cells = <1>;
diff --git a/arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts b/arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts
index e635a15041dd..a6e2aeb28675 100644
--- a/arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts
+++ b/arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts
@@ -25,8 +25,8 @@ memory@0 {
 		      <0x88000000 0x08000000>;
 	};
 
-	nand: nand@18028000 {
-		nandcs@0 {
+	nand_controller: nand-controller@18028000 {
+		nand@0 {
 			partitions {
 				compatible = "fixed-partitions";
 				#address-cells = <1>;
diff --git a/arch/arm/boot/dts/bcm5301x-nand-cs0.dtsi b/arch/arm/boot/dts/bcm5301x-nand-cs0.dtsi
index 925a7c9ce5b7..be9a00ff752d 100644
--- a/arch/arm/boot/dts/bcm5301x-nand-cs0.dtsi
+++ b/arch/arm/boot/dts/bcm5301x-nand-cs0.dtsi
@@ -6,8 +6,8 @@
  */
 
 / {
-	nand@18028000 {
-		nandcs: nandcs@0 {
+	nand-controller@18028000 {
+		nandcs: nand@0 {
 			compatible = "brcm,nandcs";
 			reg = <0>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index 7db72a2f1020..092ec525c01c 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -501,7 +501,7 @@ rng: rng@18004000 {
 		reg = <0x18004000 0x14>;
 	};
 
-	nand: nand@18028000 {
+	nand_controller: nand-controller@18028000 {
 		compatible = "brcm,nand-iproc", "brcm,brcmnand-v6.1", "brcm,brcmnand";
 		reg = <0x18028000 0x600>, <0x1811a408 0x600>, <0x18028f00 0x20>;
 		reg-names = "nand", "iproc-idm", "iproc-ext";
diff --git a/arch/arm/boot/dts/bcm953012k.dts b/arch/arm/boot/dts/bcm953012k.dts
index 046c59fb4846..de40bd59a5fa 100644
--- a/arch/arm/boot/dts/bcm953012k.dts
+++ b/arch/arm/boot/dts/bcm953012k.dts
@@ -49,8 +49,8 @@ memory@80000000 {
 	};
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
index 8060178b365d..a5a64d17d9ea 100644
--- a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
@@ -306,7 +306,7 @@ nand@1800 {
 			interrupt-names = "nand";
 			status = "okay";
 
-			nandcs: nandcs@0 {
+			nandcs: nand@0 {
 				compatible = "brcm,nandcs";
 				reg = <0>;
 			};
-- 
2.30.2

