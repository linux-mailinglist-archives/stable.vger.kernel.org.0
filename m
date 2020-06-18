Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E131FE818
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgFRBKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728594AbgFRBKq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C08121924;
        Thu, 18 Jun 2020 01:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442645;
        bh=lkznMDgVCVzO+9pK0+jc6BtPiuzmW9VHh4jQRwGuIFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qIWA67wOiIK4GEnugih9Atnx39f7szZMIX0ewQ9MgNVjgm94MMxvlaYbrDP0FVJV5
         S3suy1Exj3dZ80HLKJ7ABq0p7hueJVxAIMjwy+eFDwohyJJW0SPsiue+MwK1+D4XUQ
         lZpYjZc6WRIr1or8y+qve0x2NHI+RvhXJvG+eFo0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hsin-Yi Wang <hsinyi@chromium.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 119/388] arm64: dts: mt8173: fix unit name warnings
Date:   Wed, 17 Jun 2020 21:03:36 -0400
Message-Id: <20200618010805.600873-119-sashal@kernel.org>
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

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 72b29215aced394d01ca25e432963b619daa0098 ]

Fixing several unit name warnings:

Warning (unit_address_vs_reg): /oscillator@0: node has a unit name, but no reg property
Warning (unit_address_vs_reg): /oscillator@1: node has a unit name, but no reg property
Warning (unit_address_vs_reg): /oscillator@2: node has a unit name, but no reg property
Warning (unit_address_vs_reg): /thermal-zones/cpu_thermal/trips/trip-point@0: node has a unit name, but no reg property
Warning (unit_address_vs_reg): /thermal-zones/cpu_thermal/trips/trip-point@1: node has a unit name, but no reg property
Warning (unit_address_vs_reg): /thermal-zones/cpu_thermal/trips/cpu_crit@0: node has a unit name, but no reg property
Warning (unit_address_vs_reg): /thermal-zones/cpu_thermal/cooling-maps/map@0: node has a unit name, but no reg property
Warning (unit_address_vs_reg): /thermal-zones/cpu_thermal/cooling-maps/map@1: node has a unit name, but no reg property
Warning (unit_address_vs_reg): /reserved-memory/vpu_dma_mem_region: node has a reg or ranges property, but no unit name
Warning (simple_bus_reg): /soc/pinctrl@10005000: simple-bus unit address format error, expected "1000b000"
Warning (simple_bus_reg): /soc/interrupt-controller@10220000: simple-bus unit address format error, expected "10221000"

Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Link: https://lore.kernel.org/r/20200210063523.133333-4-hsinyi@chromium.org
[mb: drop fixes for '_' in property name]
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
index d819e44d94a8..6ad1053afd27 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -242,21 +242,21 @@ psci {
 		cpu_on	      = <0x84000003>;
 	};
 
-	clk26m: oscillator@0 {
+	clk26m: oscillator0 {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <26000000>;
 		clock-output-names = "clk26m";
 	};
 
-	clk32k: oscillator@1 {
+	clk32k: oscillator1 {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <32000>;
 		clock-output-names = "clk32k";
 	};
 
-	cpum_ck: oscillator@2 {
+	cpum_ck: oscillator2 {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <0>;
@@ -272,19 +272,19 @@ cpu_thermal: cpu_thermal {
 			sustainable-power = <1500>; /* milliwatts */
 
 			trips {
-				threshold: trip-point@0 {
+				threshold: trip-point0 {
 					temperature = <68000>;
 					hysteresis = <2000>;
 					type = "passive";
 				};
 
-				target: trip-point@1 {
+				target: trip-point1 {
 					temperature = <85000>;
 					hysteresis = <2000>;
 					type = "passive";
 				};
 
-				cpu_crit: cpu_crit@0 {
+				cpu_crit: cpu_crit0 {
 					temperature = <115000>;
 					hysteresis = <2000>;
 					type = "critical";
@@ -292,13 +292,13 @@ cpu_crit: cpu_crit@0 {
 			};
 
 			cooling-maps {
-				map@0 {
+				map0 {
 					trip = <&target>;
 					cooling-device = <&cpu0 0 0>,
 							 <&cpu1 0 0>;
 					contribution = <3072>;
 				};
-				map@1 {
+				map1 {
 					trip = <&target>;
 					cooling-device = <&cpu2 0 0>,
 							 <&cpu3 0 0>;
@@ -312,7 +312,7 @@ reserved-memory {
 		#address-cells = <2>;
 		#size-cells = <2>;
 		ranges;
-		vpu_dma_reserved: vpu_dma_mem_region {
+		vpu_dma_reserved: vpu_dma_mem_region@b7000000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0xb7000000 0 0x500000>;
 			alignment = <0x1000>;
@@ -365,7 +365,7 @@ syscfg_pctl_a: syscfg_pctl_a@10005000 {
 			reg = <0 0x10005000 0 0x1000>;
 		};
 
-		pio: pinctrl@10005000 {
+		pio: pinctrl@1000b000 {
 			compatible = "mediatek,mt8173-pinctrl";
 			reg = <0 0x1000b000 0 0x1000>;
 			mediatek,pctl-regmap = <&syscfg_pctl_a>;
@@ -572,7 +572,7 @@ mipi_tx1: mipi-dphy@10216000 {
 			status = "disabled";
 		};
 
-		gic: interrupt-controller@10220000 {
+		gic: interrupt-controller@10221000 {
 			compatible = "arm,gic-400";
 			#interrupt-cells = <3>;
 			interrupt-parent = <&gic>;
-- 
2.25.1

