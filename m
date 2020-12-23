Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C7A2E1530
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbgLWCWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:22:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728017AbgLWCWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBCCB22248;
        Wed, 23 Dec 2020 02:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690112;
        bh=274kkVyCGyvn1sZElpTE9JDUFmpG/Kt/Qp37na1q0G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSkdygGuclufghUybE4YSFK7bupV9Nhi/y3ICqo5UioSDNF+9NFvfN9UyfD6f808B
         NG8tDmGLAJtChceLCaa9brKnl6ZakLgFRAcQZKZ4OnU25Jczvz3vkZ5LQccQvTTjiq
         gJAvyPcY9YdPuGmOjsg6n5GUz+fpj1CQ5mjFlbh+v52Sw8SmbnsWIKsCZM0t94KWrN
         EjH9WA6lu0VpvdU1WQZKy1kzcOIH2wn61nc3uIJHxw1t2m6GJA+ndtI6DJu8PtR2dq
         3+659Zs/2Jhixkt7lj8SEhc4naZJbEO2VCut2ccL4k3VHfHH7R/0Munfa4sSaaxaHK
         hfq91zGDS3s6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 40/87] ARM: dts: hisilicon: fix errors detected by snps-dw-apb-uart.yaml
Date:   Tue, 22 Dec 2020 21:20:16 -0500
Message-Id: <20201223022103.2792705-40-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index f7cf4f53e764d..db4c813896b96 100644
--- a/arch/arm/boot/dts/hip01.dtsi
+++ b/arch/arm/boot/dts/hip01.dtsi
@@ -44,41 +44,41 @@ amba {
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
index ca48641d0f48d..9abf9bcf89e41 100644
--- a/arch/arm/boot/dts/hip04-d01.dts
+++ b/arch/arm/boot/dts/hip04-d01.dts
@@ -25,7 +25,7 @@ memory@0,10000000 {
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

