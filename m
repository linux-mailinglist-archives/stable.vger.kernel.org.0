Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1A42E13B6
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgLWCdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:33:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730368AbgLWCZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81C69225AB;
        Wed, 23 Dec 2020 02:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690287;
        bh=Sr7TWs5AYpwfM26gOTNNMs79uDhXGjlaJEQ3+l3h5t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnBOB01DAP0BcAEGXW2tpB05bVQX86NpjswbXl7JqKFYizixmt9WKdmaUOhd8T9wW
         fbI4THMBVU/oB6J4Vay9RXIlyh4QR6es+RdU699KLWNdyW21ULN9Ivn+JvKBJN/2y2
         QOdIWZV0+xm7nVuYtvFxT83RWJV7pbcJTtTB6teA/wuDOmLk+kRtxXkwisR+tbcBGj
         uCu9E7iWEJvKqjwtxSzBK1d3c2lVEAf3vsYM8prout8ZVS38qpYFy5WUGDeypZHjvk
         pPI3mHi9KA3HcnHMQETqfwd4ahXQwyBzvsseiAp36POps/V3YhFl5BtQNbNmUxo0qh
         He0aUpB6k6gAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 25/48] ARM: dts: hisilicon: fix errors detected by snps-dw-apb-uart.yaml
Date:   Tue, 22 Dec 2020 21:23:53 -0500
Message-Id: <20201223022417.2794032-25-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 30ea026e33c6dda48849d9fe0d15c1d280a92d53 ]

1. Change node name to match '^serial(@[0-9a-f,]+)*$'
2. Change clock-names to "baudclk", "apb_pclk". Both of them use the same
   clock.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/hip01.dtsi    | 24 ++++++++++++------------
 arch/arm/boot/dts/hip04-d01.dts |  2 +-
 arch/arm/boot/dts/hip04.dtsi    |  6 +++---
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm/boot/dts/hip01.dtsi b/arch/arm/boot/dts/hip01.dtsi
index 4e9562f806a21..85e201ab216b9 100644
--- a/arch/arm/boot/dts/hip01.dtsi
+++ b/arch/arm/boot/dts/hip01.dtsi
@@ -46,41 +46,41 @@ amba {
 			compatible = "simple-bus";
 			ranges;
 
-			uart0: uart@10001000 {
+			uart0: serial@10001000 {
 				compatible = "snps,dw-apb-uart";
 				reg = <0x10001000 0x1000>;
-				clocks = <&hisi_refclk144mhz>;
-				clock-names = "apb_pclk";
+				clocks = <&hisi_refclk144mhz>, <&hisi_refclk144mhz>;
+				clock-names = "baudclk", "apb_pclk";
 				reg-shift = <2>;
 				interrupts = <0 32 4>;
 				status = "disabled";
 			};
 
-			uart1: uart@10002000 {
+			uart1: serial@10002000 {
 				compatible = "snps,dw-apb-uart";
 				reg = <0x10002000 0x1000>;
-				clocks = <&hisi_refclk144mhz>;
-				clock-names = "apb_pclk";
+				clocks = <&hisi_refclk144mhz>, <&hisi_refclk144mhz>;
+				clock-names = "baudclk", "apb_pclk";
 				reg-shift = <2>;
 				interrupts = <0 33 4>;
 				status = "disabled";
 			};
 
-			uart2: uart@10003000 {
+			uart2: serial@10003000 {
 				compatible = "snps,dw-apb-uart";
 				reg = <0x10003000 0x1000>;
-				clocks = <&hisi_refclk144mhz>;
-				clock-names = "apb_pclk";
+				clocks = <&hisi_refclk144mhz>, <&hisi_refclk144mhz>;
+				clock-names = "baudclk", "apb_pclk";
 				reg-shift = <2>;
 				interrupts = <0 34 4>;
 				status = "disabled";
 			};
 
-			uart3: uart@10006000 {
+			uart3: serial@10006000 {
 				compatible = "snps,dw-apb-uart";
 				reg = <0x10006000 0x1000>;
-				clocks = <&hisi_refclk144mhz>;
-				clock-names = "apb_pclk";
+				clocks = <&hisi_refclk144mhz>, <&hisi_refclk144mhz>;
+				clock-names = "baudclk", "apb_pclk";
 				reg-shift = <2>;
 				interrupts = <0 4 4>;
 				status = "disabled";
diff --git a/arch/arm/boot/dts/hip04-d01.dts b/arch/arm/boot/dts/hip04-d01.dts
index 40a9e33c2654e..9b2499635dc76 100644
--- a/arch/arm/boot/dts/hip04-d01.dts
+++ b/arch/arm/boot/dts/hip04-d01.dts
@@ -25,7 +25,7 @@ memory@00000000,10000000 {
 	};
 
 	soc {
-		uart0: uart@4007000 {
+		uart0: serial@4007000 {
 			status = "ok";
 		};
 	};
diff --git a/arch/arm/boot/dts/hip04.dtsi b/arch/arm/boot/dts/hip04.dtsi
index 44044f2751151..9593a78ccf067 100644
--- a/arch/arm/boot/dts/hip04.dtsi
+++ b/arch/arm/boot/dts/hip04.dtsi
@@ -253,12 +253,12 @@ arm-pmu {
 				     <0 79 4>;
 		};
 
-		uart0: uart@4007000 {
+		uart0: serial@4007000 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x4007000 0x1000>;
 			interrupts = <0 381 4>;
-			clocks = <&clk_168m>;
-			clock-names = "uartclk";
+			clocks = <&clk_168m>, <&clk_168m>;
+			clock-names = "baudclk", "apb_pclk";
 			reg-shift = <2>;
 			status = "disabled";
 		};
-- 
2.27.0

