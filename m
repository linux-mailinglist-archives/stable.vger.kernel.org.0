Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7023B45C1E8
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245063AbhKXNYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:24:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:39540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349262AbhKXNS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:18:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A78D61263;
        Wed, 24 Nov 2021 12:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757962;
        bh=sO1KZ1DwrtekWZ3Ueom3iIMku29c1maiDZkUaqZf0rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fk42TjiLinr0WNzV5JKO/RZa1Zg4hIBcZqphfJQdPSwGicLWENQfMn/itlUsI7++Q
         4DbAsQpFmNf8tLgfLYsG1sQ5p/L9O1zoU8diYYGx8nrLA4IBF5cXW6ejcHDzHLN/1E
         TVrhwAqNWwttgY+jnVSKyULEYbdqrdPhfQCPkX2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/100] arm64: dts: freescale: fix arm,sp805 compatible string
Date:   Wed, 24 Nov 2021 12:57:27 +0100
Message-Id: <20211124115655.213549318@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 407ebdb35cd2e..6b1b728de9e9c 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
@@ -637,56 +637,56 @@
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
 
 		cluster1_core2_watchdog: wdt@c020000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc020000 0x0 0x1000>;
 			clocks = <&clockgen 4 3>, <&clockgen 4 3>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster1_core3_watchdog: wdt@c030000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc030000 0x0 0x1000>;
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
 
 		cluster2_core2_watchdog: wdt@c120000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc120000 0x0 0x1000>;
 			clocks = <&clockgen 4 3>, <&clockgen 4 3>;
 			clock-names = "wdog_clk", "apb_pclk";
 		};
 
 		cluster2_core3_watchdog: wdt@c130000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xc130000 0x0 0x1000>;
 			clocks = <&clockgen 4 3>, <&clockgen 4 3>;
 			clock-names = "wdog_clk", "apb_pclk";
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
index 82f0fe6acbfb7..4bf4a22faa61a 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
@@ -227,56 +227,56 @@
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



