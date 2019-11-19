Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF531016F7
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730803AbfKSFvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:51:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731816AbfKSFvi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:51:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C5E2208C3;
        Tue, 19 Nov 2019 05:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142697;
        bh=CiWs7HHikm8Jl6O3S8E4plgF2fWYCecAL5qC1fbENDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FR1p3BywctsKINrQDhFNSrUvcC8e7pI3maUNe1tHk0mkiyDOyMfoe+zqa+h7r58Xz
         4kn9udm99+8tQmineLj0wiyedfP358UjT1ARupctc65j5P6EUPfJJAOAg36/UkNwwQ
         gY7nr/wlcmMwLNj89bSNpMltjyUf94yks6tM4dwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 167/239] ARM: dts: marvell: Fix SPI and I2C bus warnings
Date:   Tue, 19 Nov 2019 06:19:27 +0100
Message-Id: <20191119051333.757991706@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit cf680cc5251487b9a39919c3cda31a108af19cf8 ]

dtc has new checks for I2C and SPI buses. Fix the warnings in node names
and unit-addresses.

arch/arm/boot/dts/dove-cubox.dtb: Warning (i2c_bus_reg): /i2c-mux/i2c@0/clock-generator: I2C bus unit address format error, expected "60"
arch/arm/boot/dts/dove-cubox-es.dtb: Warning (i2c_bus_reg): /i2c-mux/i2c@0/clock-generator: I2C bus unit address format error, expected "60"
arch/arm/boot/dts/dove-cubox.dtb: Warning (spi_bus_bridge): /mbus/internal-regs/spi-ctrl@10600: node name for SPI buses should be 'spi'
arch/arm/boot/dts/dove-cubox-es.dtb: Warning (spi_bus_bridge): /mbus/internal-regs/spi-ctrl@10600: node name for SPI buses should be 'spi'
arch/arm/boot/dts/dove-dove-db.dtb: Warning (spi_bus_bridge): /mbus/internal-regs/spi-ctrl@10600: node name for SPI buses should be 'spi'
arch/arm/boot/dts/dove-sbc-a510.dtb: Warning (spi_bus_bridge): /mbus/internal-regs/spi-ctrl@10600: node name for SPI buses should be 'spi'
arch/arm/boot/dts/dove-sbc-a510.dtb: Warning (spi_bus_bridge): /mbus/internal-regs/spi-ctrl@14600: node name for SPI buses should be 'spi'
arch/arm/boot/dts/orion5x-kuroboxpro.dtb: Warning (i2c_bus_reg): /soc/internal-regs/i2c@11000/rtc: I2C bus unit address format error, expected "32"
arch/arm/boot/dts/orion5x-linkstation-lschl.dtb: Warning (i2c_bus_reg): /soc/internal-regs/i2c@11000/rtc: I2C bus unit address format error, expected "32"
arch/arm/boot/dts/orion5x-linkstation-lsgl.dtb: Warning (i2c_bus_reg): /soc/internal-regs/i2c@11000/rtc: I2C bus unit address format error, expected "32"
arch/arm/boot/dts/orion5x-linkstation-lswtgl.dtb: Warning (i2c_bus_reg): /soc/internal-regs/i2c@11000/rtc: I2C bus unit address format error, expected "32"

Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Gregory Clement <gregory.clement@bootlin.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dove-cubox.dts           | 2 +-
 arch/arm/boot/dts/dove.dtsi                | 6 +++---
 arch/arm/boot/dts/orion5x-linkstation.dtsi | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
index 580e3cbcfbf7c..3e1584e787aec 100644
--- a/arch/arm/boot/dts/dove-cubox.dts
+++ b/arch/arm/boot/dts/dove-cubox.dts
@@ -87,7 +87,7 @@
 	status = "okay";
 	clock-frequency = <100000>;
 
-	si5351: clock-generator {
+	si5351: clock-generator@60 {
 		compatible = "silabs,si5351a-msop";
 		reg = <0x60>;
 		#address-cells = <1>;
diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index f4a07bb7c3a29..c78471b05ab46 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -155,7 +155,7 @@
 				  0xffffe000 MBUS_ID(0x03, 0x01) 0 0x0000800   /* CESA SRAM  2k */
 				  0xfffff000 MBUS_ID(0x0d, 0x00) 0 0x0000800>; /* PMU  SRAM  2k */
 
-			spi0: spi-ctrl@10600 {
+			spi0: spi@10600 {
 				compatible = "marvell,orion-spi";
 				#address-cells = <1>;
 				#size-cells = <0>;
@@ -168,7 +168,7 @@
 				status = "disabled";
 			};
 
-			i2c: i2c-ctrl@11000 {
+			i2c: i2c@11000 {
 				compatible = "marvell,mv64xxx-i2c";
 				reg = <0x11000 0x20>;
 				#address-cells = <1>;
@@ -218,7 +218,7 @@
 				status = "disabled";
 			};
 
-			spi1: spi-ctrl@14600 {
+			spi1: spi@14600 {
 				compatible = "marvell,orion-spi";
 				#address-cells = <1>;
 				#size-cells = <0>;
diff --git a/arch/arm/boot/dts/orion5x-linkstation.dtsi b/arch/arm/boot/dts/orion5x-linkstation.dtsi
index e9991c83d7b70..117d71546ed0f 100644
--- a/arch/arm/boot/dts/orion5x-linkstation.dtsi
+++ b/arch/arm/boot/dts/orion5x-linkstation.dtsi
@@ -156,7 +156,7 @@
 &i2c {
 	status = "okay";
 
-	rtc {
+	rtc@32 {
 		compatible = "ricoh,rs5c372a";
 		reg = <0x32>;
 	};
-- 
2.20.1



