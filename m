Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125713D295B
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbhGVQDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233826AbhGVQC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:02:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DAB2619A9;
        Thu, 22 Jul 2021 16:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972180;
        bh=7mXtIEcO2nYmkxGlvKjKtzP8lnegayx1OGFreVjkv4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DiJm2th7wjbcH2OGZTFRXZmq9Bl1CtgP/2cYBQuOxApepKJ7tZt2EOZ+Xm/CPnsJ3
         D0JRk6iv7rYdq3AvktPEzWduwGu5qZwr4k1sonUT/ylIRPXYGUbulfMXeu+idfkujS
         gAj4ynPPLlLBmUpjJkEq7J5bMiej8o3GqUrO/zGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 016/156] ARM: dts: BCM5301X: Fix NAND nodes names
Date:   Thu, 22 Jul 2021 18:29:51 +0200
Message-Id: <20210722155628.910594371@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -24,8 +24,8 @@
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
@@ -25,8 +25,8 @@
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
index 86872e12c355..bf595269ed7f 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -501,7 +501,7 @@
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
@@ -49,8 +49,8 @@
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
@@ -306,7 +306,7 @@
 			interrupt-names = "nand";
 			status = "okay";
 
-			nandcs: nandcs@0 {
+			nandcs: nand@0 {
 				compatible = "brcm,nandcs";
 				reg = <0>;
 			};
-- 
2.30.2



