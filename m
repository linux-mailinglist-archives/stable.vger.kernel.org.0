Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87020F65E9
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKJCoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:44:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbfKJCoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB6BB21D7F;
        Sun, 10 Nov 2019 02:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353843;
        bh=ruwTrmd0clXQGGZZmo8V50xrv053nKh84sC0o73hv7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEP4YpOM+Vi3Y5Ex1H/s9wUwibRaB5HNWe/SOsede1vh4eS5Myj8DX9rX6Fo3/xDz
         w9hjjLfL4V7zoyoLzfZdCL3Pq7/JkX6mwKxXbpalpHAq8OR3X/4C2+wbPliDYBJTkc
         Gwb0AZbCGhCuPgmVpt+nxPSjEiKCslsD2tw/BXqE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 131/191] arm64: dts: fsl: Fix I2C and SPI bus warnings
Date:   Sat,  9 Nov 2019 21:39:13 -0500
Message-Id: <20191110024013.29782-131-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit b739c177e1aeab532f355493439a1901b85be38c ]

dtc has new checks for I2C and SPI buses. Fix the SPI bus node names
and warnings in unit-addresses.

arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dtb: Warning (i2c_bus_reg): /soc/i2c@2180000/eeprom@57: I2C bus unit address format error, expected "53"
arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dtb: Warning (i2c_bus_reg): /soc/i2c@2180000/eeprom@56: I2C bus unit address format error, expected "52"

Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Acked-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi    | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi    | 6 +++---
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts | 4 ++--
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi    | 4 ++--
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi    | 4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi
index 68ac78c4564dc..5da732f82fa0c 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi
@@ -337,7 +337,7 @@
 			status = "disabled";
 		};
 
-		dspi: dspi@2100000 {
+		dspi: spi@2100000 {
 			compatible = "fsl,ls1012a-dspi", "fsl,ls1021a-v1.0-dspi";
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi
index 7881e3d81a9ab..b9c0f2de8f12c 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi
@@ -284,7 +284,7 @@
 			interrupts = <0 43 0x4>;
 		};
 
-		qspi: quadspi@1550000 {
+		qspi: spi@1550000 {
 			compatible = "fsl,ls1043a-qspi", "fsl,ls1021a-qspi";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -382,7 +382,7 @@
 			ranges = <0x0 0x5 0x00000000 0x8000000>;
 		};
 
-		dspi0: dspi@2100000 {
+		dspi0: spi@2100000 {
 			compatible = "fsl,ls1043a-dspi", "fsl,ls1021a-v1.0-dspi";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -395,7 +395,7 @@
 			status = "disabled";
 		};
 
-		dspi1: dspi@2110000 {
+		dspi1: spi@2110000 {
 			compatible = "fsl,ls1043a-dspi", "fsl,ls1021a-v1.0-dspi";
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
index 440e111651d53..a59b48203688a 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
@@ -57,12 +57,12 @@
 		reg = <0x4c>;
 	};
 
-	eeprom@56 {
+	eeprom@52 {
 		compatible = "atmel,24c512";
 		reg = <0x52>;
 	};
 
-	eeprom@57 {
+	eeprom@53 {
 		compatible = "atmel,24c512";
 		reg = <0x53>;
 	};
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
index ef83786b8b905..de6af453a6e16 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
@@ -202,7 +202,7 @@
 			interrupts = <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
-		qspi: quadspi@1550000 {
+		qspi: spi@1550000 {
 			compatible = "fsl,ls1021a-qspi";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -361,7 +361,7 @@
 			#thermal-sensor-cells = <1>;
 		};
 
-		dspi: dspi@2100000 {
+		dspi: spi@2100000 {
 			compatible = "fsl,ls1021a-v1.0-dspi";
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
index 8cb78dd996728..ebe0cd4bf2b7e 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
@@ -469,7 +469,7 @@
 			mmu-masters = <&fsl_mc 0x300 0>;
 		};
 
-		dspi: dspi@2100000 {
+		dspi: spi@2100000 {
 			status = "disabled";
 			compatible = "fsl,ls2080a-dspi", "fsl,ls2085a-dspi";
 			#address-cells = <1>;
@@ -595,7 +595,7 @@
 				  3 0 0x5 0x20000000 0x00010000>;
 		};
 
-		qspi: quadspi@20c0000 {
+		qspi: spi@20c0000 {
 			status = "disabled";
 			compatible = "fsl,ls2080a-qspi", "fsl,ls1021a-qspi";
 			#address-cells = <1>;
-- 
2.20.1

