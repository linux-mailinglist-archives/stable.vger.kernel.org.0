Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D5715ECC0
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390786AbgBNQHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390770AbgBNQHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:07:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB1952067D;
        Fri, 14 Feb 2020 16:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696467;
        bh=4aRcImrOu4g+QNWzAc/R2LGYo6/49kmJ5ZApdm2P06U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vanaCxTWOgzopwBEfoZcp9f7eOIlVk7kwzfSyoPJdsJu5UR3BqxV+0ocQL8gv293B
         qlb+wBSTCMaITNi65OO7dm0YO0b/aInyzaiwdyTT/dfsWAb4xmFftRPOiQgjUGaDh6
         LHJoxK3ArZUSGkgnQlPKAH8tutU75lpmF+5Lslo0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?q?Karl=20Rudb=C3=A6k=20Olsen?= <karl@micro-technic.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 277/459] ARM: dts: at91: sama5d3: fix maximum peripheral clock rates
Date:   Fri, 14 Feb 2020 10:58:47 -0500
Message-Id: <20200214160149.11681-277-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit ee0aa926ddb0bd8ba59e33e3803b3b5804e3f5da ]

Currently the maximum rate for peripheral clock is calculated based on a
typical 133MHz MCK. The maximum frequency is defined in the datasheet as a
ratio to MCK. Some sama5d3 platforms are using a 166MHz MCK. Update the
device trees to match the maximum rate based on 166MHz.

Reported-by: Karl Rudbæk Olsen <karl@micro-technic.com>
Fixes: d2e8190b7916 ("ARM: at91/dt: define sama5d3 clocks")
Link: https://lore.kernel.org/r/20200110172007.1253659-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sama5d3.dtsi      | 28 ++++++++++++++--------------
 arch/arm/boot/dts/sama5d3_can.dtsi  |  4 ++--
 arch/arm/boot/dts/sama5d3_uart.dtsi |  4 ++--
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index f770aace0efd6..203d40be70a51 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -1188,49 +1188,49 @@
 					usart0_clk: usart0_clk {
 						#clock-cells = <0>;
 						reg = <12>;
-						atmel,clk-output-range = <0 66000000>;
+						atmel,clk-output-range = <0 83000000>;
 					};
 
 					usart1_clk: usart1_clk {
 						#clock-cells = <0>;
 						reg = <13>;
-						atmel,clk-output-range = <0 66000000>;
+						atmel,clk-output-range = <0 83000000>;
 					};
 
 					usart2_clk: usart2_clk {
 						#clock-cells = <0>;
 						reg = <14>;
-						atmel,clk-output-range = <0 66000000>;
+						atmel,clk-output-range = <0 83000000>;
 					};
 
 					usart3_clk: usart3_clk {
 						#clock-cells = <0>;
 						reg = <15>;
-						atmel,clk-output-range = <0 66000000>;
+						atmel,clk-output-range = <0 83000000>;
 					};
 
 					uart0_clk: uart0_clk {
 						#clock-cells = <0>;
 						reg = <16>;
-						atmel,clk-output-range = <0 66000000>;
+						atmel,clk-output-range = <0 83000000>;
 					};
 
 					twi0_clk: twi0_clk {
 						reg = <18>;
 						#clock-cells = <0>;
-						atmel,clk-output-range = <0 16625000>;
+						atmel,clk-output-range = <0 41500000>;
 					};
 
 					twi1_clk: twi1_clk {
 						#clock-cells = <0>;
 						reg = <19>;
-						atmel,clk-output-range = <0 16625000>;
+						atmel,clk-output-range = <0 41500000>;
 					};
 
 					twi2_clk: twi2_clk {
 						#clock-cells = <0>;
 						reg = <20>;
-						atmel,clk-output-range = <0 16625000>;
+						atmel,clk-output-range = <0 41500000>;
 					};
 
 					mci0_clk: mci0_clk {
@@ -1246,19 +1246,19 @@
 					spi0_clk: spi0_clk {
 						#clock-cells = <0>;
 						reg = <24>;
-						atmel,clk-output-range = <0 133000000>;
+						atmel,clk-output-range = <0 166000000>;
 					};
 
 					spi1_clk: spi1_clk {
 						#clock-cells = <0>;
 						reg = <25>;
-						atmel,clk-output-range = <0 133000000>;
+						atmel,clk-output-range = <0 166000000>;
 					};
 
 					tcb0_clk: tcb0_clk {
 						#clock-cells = <0>;
 						reg = <26>;
-						atmel,clk-output-range = <0 133000000>;
+						atmel,clk-output-range = <0 166000000>;
 					};
 
 					pwm_clk: pwm_clk {
@@ -1269,7 +1269,7 @@
 					adc_clk: adc_clk {
 						#clock-cells = <0>;
 						reg = <29>;
-						atmel,clk-output-range = <0 66000000>;
+						atmel,clk-output-range = <0 83000000>;
 					};
 
 					dma0_clk: dma0_clk {
@@ -1300,13 +1300,13 @@
 					ssc0_clk: ssc0_clk {
 						#clock-cells = <0>;
 						reg = <38>;
-						atmel,clk-output-range = <0 66000000>;
+						atmel,clk-output-range = <0 83000000>;
 					};
 
 					ssc1_clk: ssc1_clk {
 						#clock-cells = <0>;
 						reg = <39>;
-						atmel,clk-output-range = <0 66000000>;
+						atmel,clk-output-range = <0 83000000>;
 					};
 
 					sha_clk: sha_clk {
diff --git a/arch/arm/boot/dts/sama5d3_can.dtsi b/arch/arm/boot/dts/sama5d3_can.dtsi
index cf06a018ed0f2..2470dd3fff25e 100644
--- a/arch/arm/boot/dts/sama5d3_can.dtsi
+++ b/arch/arm/boot/dts/sama5d3_can.dtsi
@@ -36,13 +36,13 @@
 					can0_clk: can0_clk {
 						#clock-cells = <0>;
 						reg = <40>;
-						atmel,clk-output-range = <0 66000000>;
+						atmel,clk-output-range = <0 83000000>;
 					};
 
 					can1_clk: can1_clk {
 						#clock-cells = <0>;
 						reg = <41>;
-						atmel,clk-output-range = <0 66000000>;
+						atmel,clk-output-range = <0 83000000>;
 					};
 				};
 			};
diff --git a/arch/arm/boot/dts/sama5d3_uart.dtsi b/arch/arm/boot/dts/sama5d3_uart.dtsi
index 4316bdbdc25dd..cb62adbd28ed6 100644
--- a/arch/arm/boot/dts/sama5d3_uart.dtsi
+++ b/arch/arm/boot/dts/sama5d3_uart.dtsi
@@ -41,13 +41,13 @@
 					uart0_clk: uart0_clk {
 						#clock-cells = <0>;
 						reg = <16>;
-						atmel,clk-output-range = <0 66000000>;
+						atmel,clk-output-range = <0 83000000>;
 					};
 
 					uart1_clk: uart1_clk {
 						#clock-cells = <0>;
 						reg = <17>;
-						atmel,clk-output-range = <0 66000000>;
+						atmel,clk-output-range = <0 83000000>;
 					};
 				};
 			};
-- 
2.20.1

