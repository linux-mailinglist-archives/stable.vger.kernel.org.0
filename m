Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427B115C590
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgBMPXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:23:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:33972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728306AbgBMPXP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:23:15 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D93F24689;
        Thu, 13 Feb 2020 15:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607393;
        bh=+CF7mt11u6g4si0+WAQufl6nfUnGGvBny/HBGsFI8yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rwzsbNrfHa/+XC0oP+hJi4XHX117V/OLhFuLE/F247OKs/cT0X5bzhtZaZHfSq2H6
         hdzaGsnGptQLT0uoFQsU0vurtPX58WOHUd+/wm4w/FUyDONjlghrnSc/tMPdKimioG
         l42usIYmpos7UU//eEb2nIAilTS1GBEDHosfgTds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Karl=20Rudb=C3=A6k=20Olsen?= <karl@micro-technic.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 4.4 83/91] ARM: dts: at91: sama5d3: fix maximum peripheral clock rates
Date:   Thu, 13 Feb 2020 07:20:40 -0800
Message-Id: <20200213151854.958338390@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

commit ee0aa926ddb0bd8ba59e33e3803b3b5804e3f5da upstream.

Currently the maximum rate for peripheral clock is calculated based on a
typical 133MHz MCK. The maximum frequency is defined in the datasheet as a
ratio to MCK. Some sama5d3 platforms are using a 166MHz MCK. Update the
device trees to match the maximum rate based on 166MHz.

Reported-by: Karl Rudbæk Olsen <karl@micro-technic.com>
Fixes: d2e8190b7916 ("ARM: at91/dt: define sama5d3 clocks")
Link: https://lore.kernel.org/r/20200110172007.1253659-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/sama5d3.dtsi      |   28 ++++++++++++++--------------
 arch/arm/boot/dts/sama5d3_can.dtsi  |    4 ++--
 arch/arm/boot/dts/sama5d3_uart.dtsi |    4 ++--
 3 files changed, 18 insertions(+), 18 deletions(-)

--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -1106,49 +1106,49 @@
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
@@ -1164,19 +1164,19 @@
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
@@ -1187,7 +1187,7 @@
 					adc_clk: adc_clk {
 						#clock-cells = <0>;
 						reg = <29>;
-						atmel,clk-output-range = <0 66000000>;
+						atmel,clk-output-range = <0 83000000>;
 					};
 
 					dma0_clk: dma0_clk {
@@ -1218,13 +1218,13 @@
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
--- a/arch/arm/boot/dts/sama5d3_can.dtsi
+++ b/arch/arm/boot/dts/sama5d3_can.dtsi
@@ -37,13 +37,13 @@
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
--- a/arch/arm/boot/dts/sama5d3_uart.dtsi
+++ b/arch/arm/boot/dts/sama5d3_uart.dtsi
@@ -42,13 +42,13 @@
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


