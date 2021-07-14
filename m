Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BBA3C8F6A
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239308AbhGNTwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239542AbhGNTtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3849061415;
        Wed, 14 Jul 2021 19:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291862;
        bh=IKkargNYveoVZdQwP1M904Kw1M7HIv9eHZwa28UYzPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSSPD1lPWRWx91JtizpUMpnbnYK/Mqt/cocFXBrKbU3PQpwn4tUNqOIBEpHcfMqPK
         ZJ1F/aJOGqSsdSzadWh9FkFpUmZFPyqnu5t8Jeegtgix8uX+N+qzOsgaPrz3h1Qhgi
         MWuI7n4yJbOpWxTH2kAkw6rCh9zlpfTJAsi/caCuN9B1ap8y0CSVBGWLQbFT0Sutqj
         92lVtCxi7TofwHzAlQBllp0iGVtVXrmjEWbd+IYbAPw6t5lhI2s4V9rkTvVnKJVO5g
         eDIr2QnL810gI+W5DNRaOD5C1kSP/G84KnlbJSQDZ3owFR9kOsM5rO+r66BFTJ3+zx
         CX6rkTAIBM6wA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 52/88] ARM: dts: stm32: fix timer nodes on STM32 MCU to prevent warnings
Date:   Wed, 14 Jul 2021 15:42:27 -0400
Message-Id: <20210714194303.54028-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@foss.st.com>

[ Upstream commit 2388f14d8747f8304e26ee870790e188c9431efd ]

Prevent warning seen with "make dtbs_check W=1" command:

Warning (avoid_unnecessary_addr_size): /soc/timers@40001c00: unnecessary
address-cells/size-cells without "ranges" or child "reg" property

Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32f429.dtsi | 8 --------
 arch/arm/boot/dts/stm32f746.dtsi | 8 --------
 arch/arm/boot/dts/stm32h743.dtsi | 4 ----
 3 files changed, 20 deletions(-)

diff --git a/arch/arm/boot/dts/stm32f429.dtsi b/arch/arm/boot/dts/stm32f429.dtsi
index 9adccd4209fb..0dc5fa94dbdf 100644
--- a/arch/arm/boot/dts/stm32f429.dtsi
+++ b/arch/arm/boot/dts/stm32f429.dtsi
@@ -283,8 +283,6 @@ timer@11 {
 		};
 
 		timers13: timers@40001c00 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40001C00 0x400>;
 			clocks = <&rcc 0 STM32F4_APB1_CLOCK(TIM13)>;
@@ -299,8 +297,6 @@ pwm {
 		};
 
 		timers14: timers@40002000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40002000 0x400>;
 			clocks = <&rcc 0 STM32F4_APB1_CLOCK(TIM14)>;
@@ -633,8 +629,6 @@ timer@8 {
 		};
 
 		timers10: timers@40014400 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40014400 0x400>;
 			clocks = <&rcc 0 STM32F4_APB2_CLOCK(TIM10)>;
@@ -649,8 +643,6 @@ pwm {
 		};
 
 		timers11: timers@40014800 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40014800 0x400>;
 			clocks = <&rcc 0 STM32F4_APB2_CLOCK(TIM11)>;
diff --git a/arch/arm/boot/dts/stm32f746.dtsi b/arch/arm/boot/dts/stm32f746.dtsi
index 640ff54ed00c..81a6fe653e66 100644
--- a/arch/arm/boot/dts/stm32f746.dtsi
+++ b/arch/arm/boot/dts/stm32f746.dtsi
@@ -265,8 +265,6 @@ timer@11 {
 		};
 
 		timers13: timers@40001c00 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40001C00 0x400>;
 			clocks = <&rcc 0 STM32F7_APB1_CLOCK(TIM13)>;
@@ -281,8 +279,6 @@ pwm {
 		};
 
 		timers14: timers@40002000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40002000 0x400>;
 			clocks = <&rcc 0 STM32F7_APB1_CLOCK(TIM14)>;
@@ -531,8 +527,6 @@ timer@8 {
 		};
 
 		timers10: timers@40014400 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40014400 0x400>;
 			clocks = <&rcc 0 STM32F7_APB2_CLOCK(TIM10)>;
@@ -547,8 +541,6 @@ pwm {
 		};
 
 		timers11: timers@40014800 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40014800 0x400>;
 			clocks = <&rcc 0 STM32F7_APB2_CLOCK(TIM11)>;
diff --git a/arch/arm/boot/dts/stm32h743.dtsi b/arch/arm/boot/dts/stm32h743.dtsi
index 7febe19e780d..1579707ea566 100644
--- a/arch/arm/boot/dts/stm32h743.dtsi
+++ b/arch/arm/boot/dts/stm32h743.dtsi
@@ -454,8 +454,6 @@ trigger@2 {
 		};
 
 		lptimer4: timer@58002c00 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-lptimer";
 			reg = <0x58002c00 0x400>;
 			clocks = <&rcc LPTIM4_CK>;
@@ -470,8 +468,6 @@ pwm {
 		};
 
 		lptimer5: timer@58003000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-lptimer";
 			reg = <0x58003000 0x400>;
 			clocks = <&rcc LPTIM5_CK>;
-- 
2.30.2

