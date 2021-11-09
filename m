Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E6944B78A
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344734AbhKIWfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:35:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345201AbhKIWdh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:33:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B812361AA3;
        Tue,  9 Nov 2021 22:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496505;
        bh=aTjvIykUk5TfpE6/YuOUKRXdaX4dsBSl3NKee7ot4fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7cFW7e0SSFUyxSnnfwpOsMaTsSdtBo+eHGfXHr69xg62H2ZuEOK7/hybZJrDn8e3
         iigNQoMS20jAFLz8KHkgwuLC9BM0RMELdnARWmeVOnS5NR4r5awtleeYdxmI0vMZgM
         qdYhXKYJIvuNVgzDgQvJz/ons6UYNAbVIGPd85JWISBR104u7wVlyqtyJq5898VbeB
         HZfHVxC+MuqHbuRvvL9AuHpgSqAvSqRpLoo48+2JJqHrAh735GsavbYeAcK+CeL9uU
         qpUgcaaCkOEG2j5CyQ41s+/044wg3UcsBIkD2HL71yTrEwHKAPyeqavemezdqzYk2D
         z5nT4YPc8IEcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 24/50] arm64: dts: freescale: fix arm,sp805 compatible string
Date:   Tue,  9 Nov 2021 17:20:37 -0500
Message-Id: <20211109222103.1234885-24-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 99a7cacc66cae92db40139b57689be2af75fc6b8 ]

According to Documentation/devicetree/bindings/watchdog/arm,sp805.yaml
the compatible is:
  compatible = "arm,sp805", "arm,primecell";

The current compatible string doesn't exist at all. Fix it.

Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi | 16 ++++++++--------
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi | 16 ++++++++--------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
index 692d8f4a206da..334af263d7b5d 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
@@ -673,56 +673,56 @@
 		};
 
 		cluster1_core0_watchdog: wdt@c000000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc000000 0x0 0x1000>;
 			clocks = <&clockgen 4 15>, <&clockgen 4 15>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster1_core1_watchdog: wdt@c010000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc010000 0x0 0x1000>;
 			clocks = <&clockgen 4 15>, <&clockgen 4 15>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster1_core2_watchdog: wdt@c020000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc020000 0x0 0x1000>;
 			clocks = <&clockgen 4 15>, <&clockgen 4 15>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster1_core3_watchdog: wdt@c030000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc030000 0x0 0x1000>;
 			clocks = <&clockgen 4 15>, <&clockgen 4 15>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster2_core0_watchdog: wdt@c100000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc100000 0x0 0x1000>;
 			clocks = <&clockgen 4 15>, <&clockgen 4 15>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster2_core1_watchdog: wdt@c110000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc110000 0x0 0x1000>;
 			clocks = <&clockgen 4 15>, <&clockgen 4 15>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster2_core2_watchdog: wdt@c120000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc120000 0x0 0x1000>;
 			clocks = <&clockgen 4 15>, <&clockgen 4 15>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster2_core3_watchdog: wdt@c130000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc130000 0x0 0x1000>;
 			clocks = <&clockgen 4 15>, <&clockgen 4 15>;
 			clock-names = "wdog_clk", "apb_pclk";
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
index 4d34d82b898a4..eb6641a3566e1 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
@@ -351,56 +351,56 @@
 		};
 
 		cluster1_core0_watchdog: wdt@c000000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc000000 0x0 0x1000>;
 			clocks = <&clockgen 4 3>, <&clockgen 4 3>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster1_core1_watchdog: wdt@c010000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc010000 0x0 0x1000>;
 			clocks = <&clockgen 4 3>, <&clockgen 4 3>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster2_core0_watchdog: wdt@c100000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc100000 0x0 0x1000>;
 			clocks = <&clockgen 4 3>, <&clockgen 4 3>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster2_core1_watchdog: wdt@c110000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc110000 0x0 0x1000>;
 			clocks = <&clockgen 4 3>, <&clockgen 4 3>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster3_core0_watchdog: wdt@c200000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc200000 0x0 0x1000>;
 			clocks = <&clockgen 4 3>, <&clockgen 4 3>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster3_core1_watchdog: wdt@c210000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc210000 0x0 0x1000>;
 			clocks = <&clockgen 4 3>, <&clockgen 4 3>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster4_core0_watchdog: wdt@c300000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc300000 0x0 0x1000>;
 			clocks = <&clockgen 4 3>, <&clockgen 4 3>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster4_core1_watchdog: wdt@c310000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc310000 0x0 0x1000>;
 			clocks = <&clockgen 4 3>, <&clockgen 4 3>;
 			clock-names = "wdog_clk", "apb_pclk";
-- 
2.33.0

