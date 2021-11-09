Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F0B44B5A1
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343944AbhKIWWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:22:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245700AbhKIWUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A40C6121F;
        Tue,  9 Nov 2021 22:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496268;
        bh=4RJ0u4tfOcnyO40i0ZMp0yNhlgWEllVPihWcP9B4HdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ed2ObTj/K0eTLXuyKWk+olL64mMI5lGDTWUZsynNvsiKUUioAbHcn7UHfbiRls2/5
         ClOn1yYcCYhUczyRjLVLOfzdNlprevgh88UvMAnKBxNnSU7Gsj1y+YHOrVsAzZyzPs
         0uf8UEtV0aowVRwuohDEOtk0frqn16KiRQP13VwMrgdhxWArIu8KY72j4oX43IT9KM
         TpvmxlDTnZTMU6TOk0k3BwbRGbUgsQLqO42puY7klcqFByz7iGHyr93b6NEWVqwzXw
         jxAPlLPJEv1gGutTBN/RlB0ZWjpFPxLWy075sDeqe7EaMDwvRnPmfHW1mU6DFnC/if
         q3Fb0581M1JTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 33/82] arm64: dts: freescale: fix arm,sp805 compatible string
Date:   Tue,  9 Nov 2021 17:15:51 -0500
Message-Id: <20211109221641.1233217-33-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
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
index f85e437f80b73..6050723172436 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
@@ -847,7 +847,7 @@
 		};
 
 		cluster1_core0_watchdog: wdt@c000000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc000000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(16)>,
@@ -857,7 +857,7 @@
 		};
 
 		cluster1_core1_watchdog: wdt@c010000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc010000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(16)>,
@@ -867,7 +867,7 @@
 		};
 
 		cluster1_core2_watchdog: wdt@c020000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc020000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(16)>,
@@ -877,7 +877,7 @@
 		};
 
 		cluster1_core3_watchdog: wdt@c030000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc030000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(16)>,
@@ -887,7 +887,7 @@
 		};
 
 		cluster2_core0_watchdog: wdt@c100000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc100000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(16)>,
@@ -897,7 +897,7 @@
 		};
 
 		cluster2_core1_watchdog: wdt@c110000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc110000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(16)>,
@@ -907,7 +907,7 @@
 		};
 
 		cluster2_core2_watchdog: wdt@c120000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc120000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(16)>,
@@ -917,7 +917,7 @@
 		};
 
 		cluster2_core3_watchdog: wdt@c130000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc130000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(16)>,
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
index 801ba9612d361..1282b61da8a55 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
@@ -387,7 +387,7 @@
 		};
 
 		cluster1_core0_watchdog: wdt@c000000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc000000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(4)>,
@@ -397,7 +397,7 @@
 		};
 
 		cluster1_core1_watchdog: wdt@c010000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc010000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(4)>,
@@ -407,7 +407,7 @@
 		};
 
 		cluster2_core0_watchdog: wdt@c100000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc100000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(4)>,
@@ -417,7 +417,7 @@
 		};
 
 		cluster2_core1_watchdog: wdt@c110000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc110000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(4)>,
@@ -427,7 +427,7 @@
 		};
 
 		cluster3_core0_watchdog: wdt@c200000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc200000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(4)>,
@@ -437,7 +437,7 @@
 		};
 
 		cluster3_core1_watchdog: wdt@c210000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc210000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(4)>,
@@ -447,7 +447,7 @@
 		};
 
 		cluster4_core0_watchdog: wdt@c300000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc300000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(4)>,
@@ -457,7 +457,7 @@
 		};
 
 		cluster4_core1_watchdog: wdt@c310000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc310000 0x0 0x1000>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(4)>,
-- 
2.33.0

