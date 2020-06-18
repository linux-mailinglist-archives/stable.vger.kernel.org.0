Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDC31FDC2F
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbgFRBRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729005AbgFRBRd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:17:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6E0B206F1;
        Thu, 18 Jun 2020 01:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443052;
        bh=y7fxfotTlOnXluKVTV4AayibhTWYQl/IVgmeQ0l5TAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Afbe4DscnBkXY5dGbmNd7BX2Krv6vD5vSrRBsl9/iNAswZ02Wad2YOW/M3Z3AVbqV
         /sVCyu5gfPd0QIAbFQlJ1kqlxASz7A8svYCoBOupv2UR6J23uOMmDD6kcnroxFHBqo
         fA8AHz+SzN6PQjNf3i2rhQAe+tvA3zcgODCy1FM0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 045/266] arm64: dts: fvp/juno: Fix node address fields
Date:   Wed, 17 Jun 2020 21:12:50 -0400
Message-Id: <20200618011631.604574-45-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index dfae90adbb7c..ce64bfb22f22 100644
--- a/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi
+++ b/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi
@@ -31,7 +31,7 @@ motherboard {
 			#interrupt-cells = <1>;
 			ranges;
 
-			nor_flash: flash@0,00000000 {
+			nor_flash: flash@0 {
 				compatible = "arm,vexpress-flash", "cfi-flash";
 				reg = <0 0x00000000 0x04000000>,
 				      <4 0x00000000 0x04000000>;
@@ -41,13 +41,13 @@ partitions {
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
@@ -59,14 +59,14 @@ ethernet@2,02000000 {
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
index 2a6aa43241b3..05d1657170b4 100644
--- a/arch/arm64/boot/dts/arm/foundation-v8.dtsi
+++ b/arch/arm64/boot/dts/arm/foundation-v8.dtsi
@@ -151,7 +151,7 @@ smb@8000000 {
 				<0 0 41 &gic 0 GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>,
 				<0 0 42 &gic 0 GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
 
-		ethernet@2,02000000 {
+		ethernet@202000000 {
 			compatible = "smsc,lan91c111";
 			reg = <2 0x02000000 0x10000>;
 			interrupts = <15>;
@@ -178,7 +178,7 @@ v2m_refclk32khz: refclk32khz {
 			clock-output-names = "v2m:refclk32khz";
 		};
 
-		iofpga@3,00000000 {
+		iofpga@300000000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
 			#size-cells = <1>;
diff --git a/arch/arm64/boot/dts/arm/juno-motherboard.dtsi b/arch/arm64/boot/dts/arm/juno-motherboard.dtsi
index 9f60dacb4f80..1234a8cfc0a9 100644
--- a/arch/arm64/boot/dts/arm/juno-motherboard.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-motherboard.dtsi
@@ -103,7 +103,7 @@ nmi-button {
 				};
 			};
 
-			flash@0,00000000 {
+			flash@0 {
 				/* 2 * 32MiB NOR Flash memory mounted on CS0 */
 				compatible = "arm,vexpress-flash", "cfi-flash";
 				reg = <0 0x00000000 0x04000000>;
@@ -120,7 +120,7 @@ partitions {
 				};
 			};
 
-			ethernet@2,00000000 {
+			ethernet@200000000 {
 				compatible = "smsc,lan9118", "smsc,lan9115";
 				reg = <2 0x00000000 0x10000>;
 				interrupts = <3>;
@@ -133,7 +133,7 @@ ethernet@2,00000000 {
 				vddvario-supply = <&mb_fixed_3v3>;
 			};
 
-			iofpga@3,00000000 {
+			iofpga@300000000 {
 				compatible = "simple-bus";
 				#address-cells = <1>;
 				#size-cells = <1>;
diff --git a/arch/arm64/boot/dts/arm/rtsm_ve-motherboard-rs2.dtsi b/arch/arm64/boot/dts/arm/rtsm_ve-motherboard-rs2.dtsi
index 57b0b9d7f3fa..29e6962c70bd 100644
--- a/arch/arm64/boot/dts/arm/rtsm_ve-motherboard-rs2.dtsi
+++ b/arch/arm64/boot/dts/arm/rtsm_ve-motherboard-rs2.dtsi
@@ -9,7 +9,7 @@ smb@8000000 {
 		motherboard {
 			arm,v2m-memory-map = "rs2";
 
-			iofpga@3,00000000 {
+			iofpga@300000000 {
 				virtio-p9@140000 {
 					compatible = "virtio,mmio";
 					reg = <0x140000 0x200>;
diff --git a/arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi b/arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi
index 03a7bf079c8f..ad20076357f5 100644
--- a/arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi
+++ b/arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi
@@ -17,14 +17,14 @@ motherboard {
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
@@ -51,7 +51,7 @@ v2m_refclk32khz: refclk32khz {
 				clock-output-names = "v2m:refclk32khz";
 			};
 
-			iofpga@3,00000000 {
+			iofpga@300000000 {
 				compatible = "simple-bus";
 				#address-cells = <1>;
 				#size-cells = <1>;
-- 
2.25.1

