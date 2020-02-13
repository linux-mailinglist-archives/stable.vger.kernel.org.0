Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3692B15C4B5
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgBMPt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:49:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387600AbgBMP0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:35 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7BAA20661;
        Thu, 13 Feb 2020 15:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607594;
        bh=k+VGvaUM8YxIqc3FwL/5MQFhpytpuWKMtooRLcdWrdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dc3fa6MAZEs1QGTi6yvGNyFvc9QVQkp+b45aGe58kXeJ8fwzDdz0zfbj5BrFDtmrq
         XVaiwjYDxuCV+z474rSeOX3DE+3aKYnoLnpeewsSw9BZHHCNZe6dEJd+ZF3uwoT0le
         wPpf3WUqEtptIHEtH1UvRJeE4ayGdc5CGc41yn4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Karl=20Rudb=C3=A6k=20Olsen?= <karl@micro-technic.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 4.19 26/52] ARM: dts: at91: sama5d3: fix maximum peripheral clock rates
Date:   Thu, 13 Feb 2020 07:21:07 -0800
Message-Id: <20200213151820.986339466@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151810.331796857@linuxfoundation.org>
References: <20200213151810.331796857@linuxfoundation.org>
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
@@ -1187,49 +1187,49 @@
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
@@ -1245,19 +1245,19 @@
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
@@ -1268,7 +1268,7 @@
 					adc_clk: adc_clk {
 						#clock-cells = <0>;
 						reg = <29>;
-						atmel,clk-output-range = <0 66000000>;
+						atmel,clk-output-range = <0 83000000>;
 					};
 
 					dma0_clk: dma0_clk {
@@ -1299,13 +1299,13 @@
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


