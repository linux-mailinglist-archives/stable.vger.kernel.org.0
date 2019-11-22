Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE99106B7E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbfKVKov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:44:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727630AbfKVKov (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:44:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA7EE20717;
        Fri, 22 Nov 2019 10:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419490;
        bh=sbePzzQan0qJ7i3IEwqAf5vzUm2j7iCFP8XVjEA5+2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iz0V+qhJKQtnHNb2CCzDwCv6IRlwfrTphb6KCSWoTWUCiYquATziEoe9fx3YrXjBx
         hEUqTv4rJcneobepJJHIKqBrGzkcvNL5ESE6SrqZngBkZZt4GcOP4NhuRuGYb1eAJg
         rwnS4AkZ2cjMFKU7zLo3qa9+2rrAqgQkiM6a8IVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 130/222] ARM: dts: realview: Fix SPI controller node names
Date:   Fri, 22 Nov 2019 11:27:50 +0100
Message-Id: <20191122100912.365250983@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
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
index e2e9599596e25..05379b6c1c13b 100644
--- a/arch/arm/boot/dts/arm-realview-eb.dtsi
+++ b/arch/arm/boot/dts/arm-realview-eb.dtsi
@@ -334,7 +334,7 @@
 			clock-names = "uartclk", "apb_pclk";
 		};
 
-		ssp: ssp@1000d000 {
+		ssp: spi@1000d000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x1000d000 0x1000>;
 			clocks = <&sspclk>, <&pclk>;
diff --git a/arch/arm/boot/dts/arm-realview-pb1176.dts b/arch/arm/boot/dts/arm-realview-pb1176.dts
index c789564f28033..c1fd5615ddfe3 100644
--- a/arch/arm/boot/dts/arm-realview-pb1176.dts
+++ b/arch/arm/boot/dts/arm-realview-pb1176.dts
@@ -343,7 +343,7 @@
 			clock-names = "apb_pclk";
 		};
 
-		pb1176_ssp: ssp@1010b000 {
+		pb1176_ssp: spi@1010b000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x1010b000 0x1000>;
 			interrupt-parent = <&intc_dc1176>;
diff --git a/arch/arm/boot/dts/arm-realview-pb11mp.dts b/arch/arm/boot/dts/arm-realview-pb11mp.dts
index 3944765ac4b06..e306f1cceb4ec 100644
--- a/arch/arm/boot/dts/arm-realview-pb11mp.dts
+++ b/arch/arm/boot/dts/arm-realview-pb11mp.dts
@@ -480,7 +480,7 @@
 			clock-names = "uartclk", "apb_pclk";
 		};
 
-		ssp@1000d000 {
+		spi@1000d000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x1000d000 0x1000>;
 			interrupt-parent = <&intc_pb11mp>;
diff --git a/arch/arm/boot/dts/arm-realview-pbx.dtsi b/arch/arm/boot/dts/arm-realview-pbx.dtsi
index aeb49c4bd773f..2bf3958b2e6b9 100644
--- a/arch/arm/boot/dts/arm-realview-pbx.dtsi
+++ b/arch/arm/boot/dts/arm-realview-pbx.dtsi
@@ -318,7 +318,7 @@
 			clock-names = "uartclk", "apb_pclk";
 		};
 
-		ssp: ssp@1000d000 {
+		ssp: spi@1000d000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x1000d000 0x1000>;
 			clocks = <&sspclk>, <&pclk>;
diff --git a/arch/arm/boot/dts/versatile-ab.dts b/arch/arm/boot/dts/versatile-ab.dts
index 409e069b3a845..00d7d28e86f0b 100644
--- a/arch/arm/boot/dts/versatile-ab.dts
+++ b/arch/arm/boot/dts/versatile-ab.dts
@@ -303,7 +303,7 @@
 			clock-names = "apb_pclk";
 		};
 
-		ssp@101f4000 {
+		spi@101f4000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x101f4000 0x1000>;
 			interrupts = <11>;
-- 
2.20.1



