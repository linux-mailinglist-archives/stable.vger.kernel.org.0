Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7925F3D27C6
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhGVPws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229998AbhGVPwm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:52:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 479016135C;
        Thu, 22 Jul 2021 16:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971597;
        bh=eHDzVLrTGNZHvuGWi9FSXx1K+lRfflSL8xqRAwwUepc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGe9YQvf2HukCQuXt3ACCCorFzZAGkqkjGD1p3t+3DNiM7g2AZ9U6zL3goeONGfni
         Adnl6BGAWBCgAg4NGhK+994G1/c3z6Vk+FHiq9pjv1PXIohnmrUeFIxg8GtaVK8a8Q
         bjxqoABYAqXOaVuLQs6zrjQiNr59dyyUjhoo/rFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/71] ARM: dts: stm32: fix timer nodes on STM32 MCU to prevent warnings
Date:   Thu, 22 Jul 2021 18:31:01 +0200
Message-Id: <20210722155618.742560870@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1476d3eaf6fa..dd41342ef017 100644
--- a/arch/arm/boot/dts/stm32f429.dtsi
+++ b/arch/arm/boot/dts/stm32f429.dtsi
@@ -283,8 +283,6 @@
 		};
 
 		timers13: timers@40001c00 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40001C00 0x400>;
 			clocks = <&rcc 0 STM32F4_APB1_CLOCK(TIM13)>;
@@ -299,8 +297,6 @@
 		};
 
 		timers14: timers@40002000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40002000 0x400>;
 			clocks = <&rcc 0 STM32F4_APB1_CLOCK(TIM14)>;
@@ -623,8 +619,6 @@
 		};
 
 		timers10: timers@40014400 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40014400 0x400>;
 			clocks = <&rcc 0 STM32F4_APB2_CLOCK(TIM10)>;
@@ -639,8 +633,6 @@
 		};
 
 		timers11: timers@40014800 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40014800 0x400>;
 			clocks = <&rcc 0 STM32F4_APB2_CLOCK(TIM11)>;
diff --git a/arch/arm/boot/dts/stm32f746.dtsi b/arch/arm/boot/dts/stm32f746.dtsi
index d26f93f8b9c2..974dc71b2fe3 100644
--- a/arch/arm/boot/dts/stm32f746.dtsi
+++ b/arch/arm/boot/dts/stm32f746.dtsi
@@ -265,8 +265,6 @@
 		};
 
 		timers13: timers@40001c00 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40001C00 0x400>;
 			clocks = <&rcc 0 STM32F7_APB1_CLOCK(TIM13)>;
@@ -281,8 +279,6 @@
 		};
 
 		timers14: timers@40002000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40002000 0x400>;
 			clocks = <&rcc 0 STM32F7_APB1_CLOCK(TIM14)>;
@@ -533,8 +529,6 @@
 		};
 
 		timers10: timers@40014400 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40014400 0x400>;
 			clocks = <&rcc 0 STM32F7_APB2_CLOCK(TIM10)>;
@@ -549,8 +543,6 @@
 		};
 
 		timers11: timers@40014800 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-timers";
 			reg = <0x40014800 0x400>;
 			clocks = <&rcc 0 STM32F7_APB2_CLOCK(TIM11)>;
diff --git a/arch/arm/boot/dts/stm32h743.dtsi b/arch/arm/boot/dts/stm32h743.dtsi
index c065266ee377..82a234c64b8b 100644
--- a/arch/arm/boot/dts/stm32h743.dtsi
+++ b/arch/arm/boot/dts/stm32h743.dtsi
@@ -438,8 +438,6 @@
 		};
 
 		lptimer4: timer@58002c00 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-lptimer";
 			reg = <0x58002c00 0x400>;
 			clocks = <&rcc LPTIM4_CK>;
@@ -454,8 +452,6 @@
 		};
 
 		lptimer5: timer@58003000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
 			compatible = "st,stm32-lptimer";
 			reg = <0x58003000 0x400>;
 			clocks = <&rcc LPTIM5_CK>;
-- 
2.30.2



