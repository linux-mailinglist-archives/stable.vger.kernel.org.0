Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5563C8D80
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbhGNToz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236618AbhGNToK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:44:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40A25613D9;
        Wed, 14 Jul 2021 19:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291660;
        bh=MigKeHk+d0yUqlclcbta5DIS8H+OA0+RmEPj7A5xbWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nc25pJgh/9WEscO7kNAyWHPdAIP8PidIfvSV4OKPVfjPIzItdsY+HNLZ3EEAKw144
         Kuej0UtkZ+0Bn6PIkermxg7PaAsfVkLbDRM/Dhlh2OXkeYN5nCmG9sp3918wAVxW6H
         2wKdzbUEy76SGKJP3EktcNBgd1YorXkid1A/i2lOTWW0rLrN6+aR7Qcyhmm7wX+q2i
         JiZKpbaerGnofXkffFYfPD24VXaQb9q2QfWSSsYyDHUNfH+Ml+ul7lru0bRuyM3AAM
         CXm5JiM8o0pUoxR3b/RSmo/UtAj8Z1iC4ivyWvwPR/B8Gf8VDQaD9mStZPTYXVhBB0
         uPtAVIz90h/5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 016/102] ARM: dts: BCM5301X: Fix NAND nodes names
Date:   Wed, 14 Jul 2021 15:39:09 -0400
Message-Id: <20210714194036.53141-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
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
index 9e799328c6db..037fdd07d43b 100644
--- a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
@@ -269,7 +269,7 @@ nand@1800 {
 			interrupt-names = "nand";
 			status = "okay";
 
-			nandcs: nandcs@0 {
+			nandcs: nand@0 {
 				compatible = "brcm,nandcs";
 				reg = <0>;
 			};
-- 
2.30.2

