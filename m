Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE861017A2
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfKSFl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:41:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730504AbfKSFlY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:41:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A185208C3;
        Tue, 19 Nov 2019 05:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142082;
        bh=LC0TPsH+HUPj01rsBWyN/9j4+EIjXpxXbLbHZ65ebpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2f3A6cwGfsve74b0gvZdhFdPjru8hCYMSqhWqeBD0YWm22Gc2WtiQg0IuaC5xAcT
         e1m4CNMoZYAxkoXAuwn9KrqcignzLErv2iNb+4ag1lR3rxP0yvM71tEIJx27roiODF
         Pu+L15fFkrKhFYAO4rYjsKS6LRnjK9VRtzdcIWrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 382/422] ARM: dts: realview: Fix SPI controller node names
Date:   Tue, 19 Nov 2019 06:19:39 +0100
Message-Id: <20191119051423.821026860@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 016add12977bcc30f77d7e48fc9a3a024cb46645 ]

SPI controller nodes should be named 'spi' rather than 'ssp'. Fixing the
name enables dtc SPI bus checks.

Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/arm-realview-eb.dtsi    | 2 +-
 arch/arm/boot/dts/arm-realview-pb1176.dts | 2 +-
 arch/arm/boot/dts/arm-realview-pb11mp.dts | 2 +-
 arch/arm/boot/dts/arm-realview-pbx.dtsi   | 2 +-
 arch/arm/boot/dts/versatile-ab.dts        | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/arm-realview-eb.dtsi b/arch/arm/boot/dts/arm-realview-eb.dtsi
index a917cf8825ca8..0e4c7c4c8c093 100644
--- a/arch/arm/boot/dts/arm-realview-eb.dtsi
+++ b/arch/arm/boot/dts/arm-realview-eb.dtsi
@@ -371,7 +371,7 @@
 			clock-names = "uartclk", "apb_pclk";
 		};
 
-		ssp: ssp@1000d000 {
+		ssp: spi@1000d000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x1000d000 0x1000>;
 			clocks = <&sspclk>, <&pclk>;
diff --git a/arch/arm/boot/dts/arm-realview-pb1176.dts b/arch/arm/boot/dts/arm-realview-pb1176.dts
index f935b72d3d964..f2a1d25eb6cf3 100644
--- a/arch/arm/boot/dts/arm-realview-pb1176.dts
+++ b/arch/arm/boot/dts/arm-realview-pb1176.dts
@@ -380,7 +380,7 @@
 			clock-names = "apb_pclk";
 		};
 
-		pb1176_ssp: ssp@1010b000 {
+		pb1176_ssp: spi@1010b000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x1010b000 0x1000>;
 			interrupt-parent = <&intc_dc1176>;
diff --git a/arch/arm/boot/dts/arm-realview-pb11mp.dts b/arch/arm/boot/dts/arm-realview-pb11mp.dts
index 36203288de426..7f9cbdf33a510 100644
--- a/arch/arm/boot/dts/arm-realview-pb11mp.dts
+++ b/arch/arm/boot/dts/arm-realview-pb11mp.dts
@@ -523,7 +523,7 @@
 			clock-names = "uartclk", "apb_pclk";
 		};
 
-		ssp@1000d000 {
+		spi@1000d000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x1000d000 0x1000>;
 			interrupt-parent = <&intc_pb11mp>;
diff --git a/arch/arm/boot/dts/arm-realview-pbx.dtsi b/arch/arm/boot/dts/arm-realview-pbx.dtsi
index 10868ba3277f5..a5676697ff3b7 100644
--- a/arch/arm/boot/dts/arm-realview-pbx.dtsi
+++ b/arch/arm/boot/dts/arm-realview-pbx.dtsi
@@ -362,7 +362,7 @@
 			clock-names = "uartclk", "apb_pclk";
 		};
 
-		ssp: ssp@1000d000 {
+		ssp: spi@1000d000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x1000d000 0x1000>;
 			clocks = <&sspclk>, <&pclk>;
diff --git a/arch/arm/boot/dts/versatile-ab.dts b/arch/arm/boot/dts/versatile-ab.dts
index 5f61d36090270..6f4f60ba5429c 100644
--- a/arch/arm/boot/dts/versatile-ab.dts
+++ b/arch/arm/boot/dts/versatile-ab.dts
@@ -373,7 +373,7 @@
 			clock-names = "apb_pclk";
 		};
 
-		ssp@101f4000 {
+		spi@101f4000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x101f4000 0x1000>;
 			interrupts = <11>;
-- 
2.20.1



