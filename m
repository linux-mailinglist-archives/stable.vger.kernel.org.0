Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9BC2E16A8
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731166AbgLWDAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728811AbgLWCT4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D687323332;
        Wed, 23 Dec 2020 02:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689973;
        bh=GMAe2UMgOYbGY7Mdf/O9QkHrgo7nFBS6g9k+GXAtwI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=biOSgjKsyl30tVkhis8rLYdZbtaT7XQUScVSafmuGtU6Is5LEouq2SwAGJscDXdpO
         VTMhx8eyts4GSXOEj3EtDrKfHTKW8pNuNU5lnNnDv3ZNzBZ1IDQsvxLoi3HKetE6yC
         g3JBeqsGE11ulChiKPPmv4j6viD0g81pYLm8De6Xr0hvRVVFzyORnfBO8QS/SJS6Ih
         NP3Velmn7j16dZUh3xpVyWUfKzeMTh/tS6lzzAc2KReFw1XmldIPKWfV8ibyDgk0YV
         K8ALjsKUFN+eqa2XzvYNGmzB0FJjDVqJRb8UpFveUBqRW+aVH40eMHm+BIBkjQ5DtU
         F8Me16xAakVVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 062/130] ARM: dts: hisilicon: fix errors detected by pl011.yaml
Date:   Tue, 22 Dec 2020 21:17:05 -0500
Message-Id: <20201223021813.2791612-62-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit e5e225fd495ef1dffc64b81b2094e427f9cc4016 ]

1. Change node name to match '^serial(@[0-9a-f,]+)*$'
2. Change clock-names to "uartclk", "apb_pclk". Both of them use the same
   clock.
3. Change pinctrl-names to "default", "sleep".

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/hi3519.dtsi       | 20 +++++++++----------
 arch/arm/boot/dts/hi3620-hi4511.dts | 20 +++++++++----------
 arch/arm/boot/dts/hi3620.dtsi       | 30 ++++++++++++++---------------
 arch/arm/boot/dts/hisi-x5hd2.dtsi   | 30 ++++++++++++++---------------
 4 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/arch/arm/boot/dts/hi3519.dtsi b/arch/arm/boot/dts/hi3519.dtsi
index 410409a0ed662..630753c0d7044 100644
--- a/arch/arm/boot/dts/hi3519.dtsi
+++ b/arch/arm/boot/dts/hi3519.dtsi
@@ -52,8 +52,8 @@ uart0: serial@12100000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x12100000 0x1000>;
 			interrupts = <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&crg HI3519_UART0_CLK>;
-			clock-names = "apb_pclk";
+			clocks = <&crg HI3519_UART0_CLK>, <&crg HI3519_UART0_CLK>;
+			clock-names = "uartclk", "apb_pclk";
 			status = "disable";
 		};
 
@@ -61,8 +61,8 @@ uart1: serial@12101000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x12101000 0x1000>;
 			interrupts = <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&crg HI3519_UART1_CLK>;
-			clock-names = "apb_pclk";
+			clocks = <&crg HI3519_UART1_CLK>, <&crg HI3519_UART1_CLK>;
+			clock-names = "uartclk", "apb_pclk";
 			status = "disable";
 		};
 
@@ -70,8 +70,8 @@ uart2: serial@12102000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x12102000 0x1000>;
 			interrupts = <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&crg HI3519_UART2_CLK>;
-			clock-names = "apb_pclk";
+			clocks = <&crg HI3519_UART2_CLK>, <&crg HI3519_UART2_CLK>;
+			clock-names = "uartclk", "apb_pclk";
 			status = "disable";
 		};
 
@@ -79,8 +79,8 @@ uart3: serial@12103000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x12103000 0x1000>;
 			interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&crg HI3519_UART3_CLK>;
-			clock-names = "apb_pclk";
+			clocks = <&crg HI3519_UART3_CLK>, <&crg HI3519_UART3_CLK>;
+			clock-names = "uartclk", "apb_pclk";
 			status = "disable";
 		};
 
@@ -88,8 +88,8 @@ uart4: serial@12104000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x12104000 0x1000>;
 			interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&crg HI3519_UART4_CLK>;
-			clock-names = "apb_pclk";
+			clocks = <&crg HI3519_UART4_CLK>, <&crg HI3519_UART4_CLK>;
+			clock-names = "uartclk", "apb_pclk";
 			status = "disable";
 		};
 
diff --git a/arch/arm/boot/dts/hi3620-hi4511.dts b/arch/arm/boot/dts/hi3620-hi4511.dts
index 8c703c3f2fe09..1c62bdcca647a 100644
--- a/arch/arm/boot/dts/hi3620-hi4511.dts
+++ b/arch/arm/boot/dts/hi3620-hi4511.dts
@@ -27,36 +27,36 @@ dual_timer0: dual_timer@800000 {
 			status = "ok";
 		};
 
-		uart0: uart@b00000 {	/* console */
-			pinctrl-names = "default", "idle";
+		uart0: serial@b00000 {	/* console */
+			pinctrl-names = "default", "sleep";
 			pinctrl-0 = <&uart0_pmx_func &uart0_cfg_func>;
 			pinctrl-1 = <&uart0_pmx_idle &uart0_cfg_idle>;
 			status = "ok";
 		};
 
-		uart1: uart@b01000 { /* modem */
-			pinctrl-names = "default", "idle";
+		uart1: serial@b01000 { /* modem */
+			pinctrl-names = "default", "sleep";
 			pinctrl-0 = <&uart1_pmx_func &uart1_cfg_func>;
 			pinctrl-1 = <&uart1_pmx_idle &uart1_cfg_idle>;
 			status = "ok";
 		};
 
-		uart2: uart@b02000 { /* audience */
-			pinctrl-names = "default", "idle";
+		uart2: serial@b02000 { /* audience */
+			pinctrl-names = "default", "sleep";
 			pinctrl-0 = <&uart2_pmx_func &uart2_cfg_func>;
 			pinctrl-1 = <&uart2_pmx_idle &uart2_cfg_idle>;
 			status = "ok";
 		};
 
-		uart3: uart@b03000 {
-			pinctrl-names = "default", "idle";
+		uart3: serial@b03000 {
+			pinctrl-names = "default", "sleep";
 			pinctrl-0 = <&uart3_pmx_func &uart3_cfg_func>;
 			pinctrl-1 = <&uart3_pmx_idle &uart3_cfg_idle>;
 			status = "ok";
 		};
 
-		uart4: uart@b04000 {
-			pinctrl-names = "default", "idle";
+		uart4: serial@b04000 {
+			pinctrl-names = "default", "sleep";
 			pinctrl-0 = <&uart4_pmx_func &uart4_cfg_func>;
 			pinctrl-1 = <&uart4_pmx_idle &uart4_cfg_func>;
 			status = "ok";
diff --git a/arch/arm/boot/dts/hi3620.dtsi b/arch/arm/boot/dts/hi3620.dtsi
index 9c207a690df50..cb7e932e094f6 100644
--- a/arch/arm/boot/dts/hi3620.dtsi
+++ b/arch/arm/boot/dts/hi3620.dtsi
@@ -162,48 +162,48 @@ timer5: timer@600 {
 			interrupts = <1 13 0xf01>;
 		};
 
-		uart0: uart@b00000 {
+		uart0: serial@b00000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0xb00000 0x1000>;
 			interrupts = <0 20 4>;
-			clocks = <&clock HI3620_UARTCLK0>;
-			clock-names = "apb_pclk";
+			clocks = <&clock HI3620_UARTCLK0>, <&clock HI3620_UARTCLK0>;
+			clock-names = "uartclk", "apb_pclk";
 			status = "disabled";
 		};
 
-		uart1: uart@b01000 {
+		uart1: serial@b01000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0xb01000 0x1000>;
 			interrupts = <0 21 4>;
-			clocks = <&clock HI3620_UARTCLK1>;
-			clock-names = "apb_pclk";
+			clocks = <&clock HI3620_UARTCLK1>, <&clock HI3620_UARTCLK1>;
+			clock-names = "uartclk", "apb_pclk";
 			status = "disabled";
 		};
 
-		uart2: uart@b02000 {
+		uart2: serial@b02000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0xb02000 0x1000>;
 			interrupts = <0 22 4>;
-			clocks = <&clock HI3620_UARTCLK2>;
-			clock-names = "apb_pclk";
+			clocks = <&clock HI3620_UARTCLK2>, <&clock HI3620_UARTCLK2>;
+			clock-names = "uartclk", "apb_pclk";
 			status = "disabled";
 		};
 
-		uart3: uart@b03000 {
+		uart3: serial@b03000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0xb03000 0x1000>;
 			interrupts = <0 23 4>;
-			clocks = <&clock HI3620_UARTCLK3>;
-			clock-names = "apb_pclk";
+			clocks = <&clock HI3620_UARTCLK3>, <&clock HI3620_UARTCLK3>;
+			clock-names = "uartclk", "apb_pclk";
 			status = "disabled";
 		};
 
-		uart4: uart@b04000 {
+		uart4: serial@b04000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0xb04000 0x1000>;
 			interrupts = <0 24 4>;
-			clocks = <&clock HI3620_UARTCLK4>;
-			clock-names = "apb_pclk";
+			clocks = <&clock HI3620_UARTCLK4>, <&clock HI3620_UARTCLK4>;
+			clock-names = "uartclk", "apb_pclk";
 			status = "disabled";
 		};
 
diff --git a/arch/arm/boot/dts/hisi-x5hd2.dtsi b/arch/arm/boot/dts/hisi-x5hd2.dtsi
index 696e6982a688b..d8800992b4d0c 100644
--- a/arch/arm/boot/dts/hisi-x5hd2.dtsi
+++ b/arch/arm/boot/dts/hisi-x5hd2.dtsi
@@ -86,48 +86,48 @@ timer4: timer@a81000 {
 				status = "disabled";
 			};
 
-			uart0: uart@b00000 {
+			uart0: serial@b00000 {
 				compatible = "arm,pl011", "arm,primecell";
 				reg = <0x00b00000 0x1000>;
 				interrupts = <0 49 4>;
-				clocks = <&clock HIX5HD2_FIXED_83M>;
-				clock-names = "apb_pclk";
+				clocks = <&clock HIX5HD2_FIXED_83M>, <&clock HIX5HD2_FIXED_83M>;
+				clock-names = "uartclk", "apb_pclk";
 				status = "disabled";
 			};
 
-			uart1: uart@6000 {
+			uart1: serial@6000 {
 				compatible = "arm,pl011", "arm,primecell";
 				reg = <0x00006000 0x1000>;
 				interrupts = <0 50 4>;
-				clocks = <&clock HIX5HD2_FIXED_83M>;
-				clock-names = "apb_pclk";
+				clocks = <&clock HIX5HD2_FIXED_83M>, <&clock HIX5HD2_FIXED_83M>;
+				clock-names = "uartclk", "apb_pclk";
 				status = "disabled";
 			};
 
-			uart2: uart@b02000 {
+			uart2: serial@b02000 {
 				compatible = "arm,pl011", "arm,primecell";
 				reg = <0x00b02000 0x1000>;
 				interrupts = <0 51 4>;
-				clocks = <&clock HIX5HD2_FIXED_83M>;
-				clock-names = "apb_pclk";
+				clocks = <&clock HIX5HD2_FIXED_83M>, <&clock HIX5HD2_FIXED_83M>;
+				clock-names = "uartclk", "apb_pclk";
 				status = "disabled";
 			};
 
-			uart3: uart@b03000 {
+			uart3: serial@b03000 {
 				compatible = "arm,pl011", "arm,primecell";
 				reg = <0x00b03000 0x1000>;
 				interrupts = <0 52 4>;
-				clocks = <&clock HIX5HD2_FIXED_83M>;
-				clock-names = "apb_pclk";
+				clocks = <&clock HIX5HD2_FIXED_83M>, <&clock HIX5HD2_FIXED_83M>;
+				clock-names = "uartclk", "apb_pclk";
 				status = "disabled";
 			};
 
-			uart4: uart@b04000 {
+			uart4: serial@b04000 {
 				compatible = "arm,pl011", "arm,primecell";
 				reg = <0xb04000 0x1000>;
 				interrupts = <0 53 4>;
-				clocks = <&clock HIX5HD2_FIXED_83M>;
-				clock-names = "apb_pclk";
+				clocks = <&clock HIX5HD2_FIXED_83M>, <&clock HIX5HD2_FIXED_83M>;
+				clock-names = "uartclk", "apb_pclk";
 				status = "disabled";
 			};
 
-- 
2.27.0

