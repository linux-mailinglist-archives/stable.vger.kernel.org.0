Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0374D11AFF9
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732116AbfLKPST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731828AbfLKPSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9723324654;
        Wed, 11 Dec 2019 15:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077498;
        bh=aeHl2hUK7LBF8Pmrlaer525By0it5evnGSRGXGTa8CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyGL5Dec9LxCxrgGrV8TY+Y8r41GSLZiiNNFcUsmrZgHoNSrI3EB0uFpRBs9xU0HN
         qquR6TJbV3kbwhcTT3M1n0ilz6OqItiy7/3o6CQD+1K/khtHM0xZOwsH/Qz9py1DEc
         0R1n/YQb9Gh8Q9rLndpnDSrkPk8nFJhKd+/unvIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/243] arm64: dts: zynqmp: Fix node names which contain "_"
Date:   Wed, 11 Dec 2019 16:03:42 +0100
Message-Id: <20191211150343.152008812@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

[ Upstream commit d1d4445abffb2b17e841d37b555b6f1364b571c1 ]

s/_/-/ for node names.

It fixes warnings like this:
... Warning (node_name_chars_strict): /cpu_opp_table:
Character '_' not recommended in node name ...

Issues reported by make dtbs W=12

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/zynqmp-clk.dtsi        |  4 ++--
 arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts |  4 ++--
 arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dts | 10 +++++-----
 arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts |  2 +-
 arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dts |  2 +-
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi            |  4 ++--
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-clk.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp-clk.dtsi
index 9c09baca7dd78..306ad2157c988 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp-clk.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-clk.dtsi
@@ -58,13 +58,13 @@
 		clock-accuracy = <100>;
 	};
 
-	dpdma_clk: dpdma_clk {
+	dpdma_clk: dpdma-clk {
 		compatible = "fixed-clock";
 		#clock-cells = <0x0>;
 		clock-frequency = <533000000>;
 	};
 
-	drm_clock: drm_clock {
+	drm_clock: drm-clock {
 		compatible = "fixed-clock";
 		#clock-cells = <0x0>;
 		clock-frequency = <262750000>;
diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts b/arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts
index 8954c8c6f5475..14062b4535dd7 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts
@@ -82,7 +82,7 @@
 			linux,default-trigger = "bluetooth-power";
 		};
 
-		vbus_det { /* U5 USB5744 VBUS detection via MIO25 */
+		vbus-det { /* U5 USB5744 VBUS detection via MIO25 */
 			label = "vbus_det";
 			gpios = <&gpio 25 GPIO_ACTIVE_HIGH>;
 			default-state = "on";
@@ -98,7 +98,7 @@
 		regulator-boot-on;
 	};
 
-	sdio_pwrseq: sdio_pwrseq {
+	sdio_pwrseq: sdio-pwrseq {
 		compatible = "mmc-pwrseq-simple";
 		reset-gpios = <&gpio 7 GPIO_ACTIVE_LOW>; /* WIFI_EN */
 		post-power-on-delay-ms = <10>;
diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dts b/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dts
index 25dd574853235..d3b8e1a9c0761 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dts
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dts
@@ -53,7 +53,7 @@
 
 	leds {
 		compatible = "gpio-leds";
-		heartbeat_led {
+		heartbeat-led {
 			label = "heartbeat";
 			gpios = <&gpio 23 GPIO_ACTIVE_HIGH>;
 			linux,default-trigger = "heartbeat";
@@ -139,25 +139,25 @@
 		 * 7, 10 - 17 - not connected
 		 */
 
-		gtr_sel0 {
+		gtr-sel0 {
 			gpio-hog;
 			gpios = <0 0>;
 			output-low; /* PCIE = 0, DP = 1 */
 			line-name = "sel0";
 		};
-		gtr_sel1 {
+		gtr-sel1 {
 			gpio-hog;
 			gpios = <1 0>;
 			output-high; /* PCIE = 0, DP = 1 */
 			line-name = "sel1";
 		};
-		gtr_sel2 {
+		gtr-sel2 {
 			gpio-hog;
 			gpios = <2 0>;
 			output-high; /* PCIE = 0, USB0 = 1 */
 			line-name = "sel2";
 		};
-		gtr_sel3 {
+		gtr-sel3 {
 			gpio-hog;
 			gpios = <3 0>;
 			output-high; /* PCIE = 0, SATA = 1 */
diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts b/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts
index 259f21b0c0014..28dee4dad82c2 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts
@@ -53,7 +53,7 @@
 
 	leds {
 		compatible = "gpio-leds";
-		heartbeat_led {
+		heartbeat-led {
 			label = "heartbeat";
 			gpios = <&gpio 23 GPIO_ACTIVE_HIGH>;
 			linux,default-trigger = "heartbeat";
diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dts b/arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dts
index a61b3cc6f4c95..47b5989035e4e 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dts
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dts
@@ -53,7 +53,7 @@
 
 	leds {
 		compatible = "gpio-leds";
-		heartbeat_led {
+		heartbeat-led {
 			label = "heartbeat";
 			gpios = <&gpio 23 GPIO_ACTIVE_HIGH>;
 			linux,default-trigger = "heartbeat";
diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index 29ce23422acf2..a516c0e01429a 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -71,7 +71,7 @@
 		};
 	};
 
-	cpu_opp_table: cpu_opp_table {
+	cpu_opp_table: cpu-opp-table {
 		compatible = "operating-points-v2";
 		opp-shared;
 		opp00 {
@@ -124,7 +124,7 @@
 			     <1 10 0xf08>;
 	};
 
-	amba_apu: amba_apu@0 {
+	amba_apu: amba-apu@0 {
 		compatible = "simple-bus";
 		#address-cells = <2>;
 		#size-cells = <1>;
-- 
2.20.1



