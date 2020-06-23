Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6E6205E7A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390236AbgFWUW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390192AbgFWUWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:22:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBDFC20723;
        Tue, 23 Jun 2020 20:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943769;
        bh=VGPAzjLTrTVnWU+AyKo8asc/OXb4vZBCkHqAZhSl1iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKB6ibM44YetFzKkEYf851/Ygrsqq+MBbdfqXvDiHvrTo7mFS4hBygdflJvM4NW5n
         FIlTuhHW9NYZ7h+01hwQKqKVANwxqAwgzenWKgCi60q4cGE6GRu7AlHganLqYAxGFW
         fYkJEKzORnnG8QLVDb01h2rxsE/s3T50sIlbubnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/314] arm64: dts: fvp/juno: Fix node address fields
Date:   Tue, 23 Jun 2020 21:53:59 +0200
Message-Id: <20200623195340.909807820@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit bb5cce12ac717c7462217cd493ed701d12d6dbce ]

The Arm Ltd. boards were using an outdated address convention in the DT
node names, by separating the high from the low 32-bits of an address by
a comma.

Remove the comma from the node name suffix to be DT spec compliant.

Link: https://lore.kernel.org/r/20200513103016.130417-3-andre.przywara@arm.com
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/vexpress-v2m-rs1.dtsi              | 10 +++++-----
 arch/arm64/boot/dts/arm/foundation-v8.dtsi           |  4 ++--
 arch/arm64/boot/dts/arm/juno-motherboard.dtsi        |  6 +++---
 arch/arm64/boot/dts/arm/rtsm_ve-motherboard-rs2.dtsi |  2 +-
 arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi     |  6 +++---
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi b/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi
index dfae90adbb7ca..ce64bfb22f22a 100644
--- a/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi
+++ b/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi
@@ -31,7 +31,7 @@
 			#interrupt-cells = <1>;
 			ranges;
 
-			nor_flash: flash@0,00000000 {
+			nor_flash: flash@0 {
 				compatible = "arm,vexpress-flash", "cfi-flash";
 				reg = <0 0x00000000 0x04000000>,
 				      <4 0x00000000 0x04000000>;
@@ -41,13 +41,13 @@
 				};
 			};
 
-			psram@1,00000000 {
+			psram@100000000 {
 				compatible = "arm,vexpress-psram", "mtd-ram";
 				reg = <1 0x00000000 0x02000000>;
 				bank-width = <4>;
 			};
 
-			ethernet@2,02000000 {
+			ethernet@202000000 {
 				compatible = "smsc,lan9118", "smsc,lan9115";
 				reg = <2 0x02000000 0x10000>;
 				interrupts = <15>;
@@ -59,14 +59,14 @@
 				vddvario-supply = <&v2m_fixed_3v3>;
 			};
 
-			usb@2,03000000 {
+			usb@203000000 {
 				compatible = "nxp,usb-isp1761";
 				reg = <2 0x03000000 0x20000>;
 				interrupts = <16>;
 				port1-otg;
 			};
 
-			iofpga@3,00000000 {
+			iofpga@300000000 {
 				compatible = "simple-bus";
 				#address-cells = <1>;
 				#size-cells = <1>;
diff --git a/arch/arm64/boot/dts/arm/foundation-v8.dtsi b/arch/arm64/boot/dts/arm/foundation-v8.dtsi
index 2a6aa43241b3b..05d1657170b49 100644
--- a/arch/arm64/boot/dts/arm/foundation-v8.dtsi
+++ b/arch/arm64/boot/dts/arm/foundation-v8.dtsi
@@ -151,7 +151,7 @@
 				<0 0 41 &gic 0 GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>,
 				<0 0 42 &gic 0 GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
 
-		ethernet@2,02000000 {
+		ethernet@202000000 {
 			compatible = "smsc,lan91c111";
 			reg = <2 0x02000000 0x10000>;
 			interrupts = <15>;
@@ -178,7 +178,7 @@
 			clock-output-names = "v2m:refclk32khz";
 		};
 
-		iofpga@3,00000000 {
+		iofpga@300000000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
 			#size-cells = <1>;
diff --git a/arch/arm64/boot/dts/arm/juno-motherboard.dtsi b/arch/arm64/boot/dts/arm/juno-motherboard.dtsi
index 9f60dacb4f80f..1234a8cfc0a92 100644
--- a/arch/arm64/boot/dts/arm/juno-motherboard.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-motherboard.dtsi
@@ -103,7 +103,7 @@
 				};
 			};
 
-			flash@0,00000000 {
+			flash@0 {
 				/* 2 * 32MiB NOR Flash memory mounted on CS0 */
 				compatible = "arm,vexpress-flash", "cfi-flash";
 				reg = <0 0x00000000 0x04000000>;
@@ -120,7 +120,7 @@
 				};
 			};
 
-			ethernet@2,00000000 {
+			ethernet@200000000 {
 				compatible = "smsc,lan9118", "smsc,lan9115";
 				reg = <2 0x00000000 0x10000>;
 				interrupts = <3>;
@@ -133,7 +133,7 @@
 				vddvario-supply = <&mb_fixed_3v3>;
 			};
 
-			iofpga@3,00000000 {
+			iofpga@300000000 {
 				compatible = "simple-bus";
 				#address-cells = <1>;
 				#size-cells = <1>;
diff --git a/arch/arm64/boot/dts/arm/rtsm_ve-motherboard-rs2.dtsi b/arch/arm64/boot/dts/arm/rtsm_ve-motherboard-rs2.dtsi
index 57b0b9d7f3fae..29e6962c70bd9 100644
--- a/arch/arm64/boot/dts/arm/rtsm_ve-motherboard-rs2.dtsi
+++ b/arch/arm64/boot/dts/arm/rtsm_ve-motherboard-rs2.dtsi
@@ -9,7 +9,7 @@
 		motherboard {
 			arm,v2m-memory-map = "rs2";
 
-			iofpga@3,00000000 {
+			iofpga@300000000 {
 				virtio-p9@140000 {
 					compatible = "virtio,mmio";
 					reg = <0x140000 0x200>;
diff --git a/arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi b/arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi
index 03a7bf079c8ff..ad20076357f50 100644
--- a/arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi
+++ b/arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi
@@ -17,14 +17,14 @@
 			#interrupt-cells = <1>;
 			ranges;
 
-			flash@0,00000000 {
+			flash@0 {
 				compatible = "arm,vexpress-flash", "cfi-flash";
 				reg = <0 0x00000000 0x04000000>,
 				      <4 0x00000000 0x04000000>;
 				bank-width = <4>;
 			};
 
-			ethernet@2,02000000 {
+			ethernet@202000000 {
 				compatible = "smsc,lan91c111";
 				reg = <2 0x02000000 0x10000>;
 				interrupts = <15>;
@@ -51,7 +51,7 @@
 				clock-output-names = "v2m:refclk32khz";
 			};
 
-			iofpga@3,00000000 {
+			iofpga@300000000 {
 				compatible = "simple-bus";
 				#address-cells = <1>;
 				#size-cells = <1>;
-- 
2.25.1



