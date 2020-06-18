Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021791FE8A1
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgFRCuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbgFRBJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C086F21974;
        Thu, 18 Jun 2020 01:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442564;
        bh=GPCQ9o9OX610tutUcHN29RME33dv4QpzreXiArdMxI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Enf5E4lBLeV3zH8HIXGanKZ3trM/usw74hTVpi8lgdNI/a0CGKDsdMF7s39Z16qW9
         ousyKx3kbChuBSkDhskUdDzH9HYycIsRihsef7snhotmZztj3fPY6Gqv7SpZehdy0E
         B6O3/FD5axWECG4vAzYb12iyYwu7UDeKI6oji5nM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 059/388] arm64: dts: fvp/juno: Fix node address fields
Date:   Wed, 17 Jun 2020 21:02:36 -0400
Message-Id: <20200618010805.600873-59-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
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
index 5c183483ec3b..8010cdcdb37a 100644
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
index 60ec37d6c9d3..e2da63f78298 100644
--- a/arch/arm64/boot/dts/arm/foundation-v8.dtsi
+++ b/arch/arm64/boot/dts/arm/foundation-v8.dtsi
@@ -151,7 +151,7 @@ bus@8000000 {
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
index e3983ded3c3c..d5cefddde08c 100644
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
index 60703b5763c6..350cbf17e8b4 100644
--- a/arch/arm64/boot/dts/arm/rtsm_ve-motherboard-rs2.dtsi
+++ b/arch/arm64/boot/dts/arm/rtsm_ve-motherboard-rs2.dtsi
@@ -9,7 +9,7 @@ bus@8000000 {
 		motherboard {
 			arm,v2m-memory-map = "rs2";
 
-			iofpga@3,00000000 {
+			iofpga@300000000 {
 				virtio-p9@140000 {
 					compatible = "virtio,mmio";
 					reg = <0x140000 0x200>;
diff --git a/arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi b/arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi
index e333c8d2d0e4..d1bfa62ca073 100644
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

