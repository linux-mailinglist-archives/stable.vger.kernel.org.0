Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB14DF66A8
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfKJDOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:14:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbfKJCm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:42:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E474214E0;
        Sun, 10 Nov 2019 02:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353747;
        bh=S8irZjjcVwZbHUEYCPydOOO1jUtQJw/MSB50Tu1i7fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFUfLMx9nFOxqSadCo+BJobs8URXBNKDSGivIKHzq4JOk4iago4JVBY0L6kGUlEzr
         0/zEKymYzPfE2SuvdTuvbJUGdhRIesPAxNQ/PmU8srGasogENiVyJt7BuhbAtJmU47
         kDXhE/LE7KzWYsYKat/ECgE46CkqQ9jGdOZzxB+E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        linux-omap@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 063/191] ARM: dts: ti: Fix SPI and I2C bus warnings
Date:   Sat,  9 Nov 2019 21:38:05 -0500
Message-Id: <20191110024013.29782-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit cc893871f092be9ac1184a78f9ae1e76b85d5317 ]

dtc has new checks for I2C and SPI buses. Fix the warnings in node names
and unit-addresses.

arch/arm/boot/dts/am437x-idk-evm.dtb: Warning (spi_bus_bridge): /ocp@44000000/qspi@47900000: node name for SPI buses should be 'spi'
arch/arm/boot/dts/am437x-sk-evm.dtb: Warning (spi_bus_bridge): /ocp@44000000/qspi@47900000: node name for SPI buses should be 'spi'
arch/arm/boot/dts/am43x-epos-evm.dtb: Warning (spi_bus_bridge): /ocp@44000000/qspi@47900000: node name for SPI buses should be 'spi'
arch/arm/boot/dts/omap3-n9.dtb: Warning (i2c_bus_reg): /ocp@68000000/i2c@48060000/ak8975@0f: I2C bus unit address format error, expected "f"
arch/arm/boot/dts/am335x-osd3358-sm-red.dtb: Warning (i2c_bus_reg): /ocp/i2c@44e0b000/pressure@78: I2C bus unit address format error, expected "76"
arch/arm/boot/dts/am335x-boneblack.dtb: Warning (i2c_bus_reg): /ocp/i2c@44e0b000/tda19988: I2C bus unit address format error, expected "70"
arch/arm/boot/dts/am335x-boneblack-wireless.dtb: Warning (i2c_bus_reg): /ocp/i2c@44e0b000/tda19988: I2C bus unit address format error, expected "70"
arch/arm/boot/dts/am335x-sancloud-bbe.dtb: Warning (i2c_bus_reg): /ocp/i2c@44e0b000/tda19988: I2C bus unit address format error, expected "70"
arch/arm/boot/dts/am571x-idk.dtb: Warning (spi_bus_bridge): /ocp/qspi@4b300000: node name for SPI buses should be 'spi'
arch/arm/boot/dts/am572x-idk.dtb: Warning (spi_bus_bridge): /ocp/qspi@4b300000: node name for SPI buses should be 'spi'
arch/arm/boot/dts/am574x-idk.dtb: Warning (spi_bus_bridge): /ocp/qspi@4b300000: node name for SPI buses should be 'spi'
arch/arm/boot/dts/am57xx-cl-som-am57x.dtb: Warning (spi_bus_bridge): /ocp/qspi@4b300000: node name for SPI buses should be 'spi'
arch/arm/boot/dts/am57xx-sbc-am57x.dtb: Warning (spi_bus_bridge): /ocp/qspi@4b300000: node name for SPI buses should be 'spi'
arch/arm/boot/dts/dra72-evm.dtb: Warning (spi_bus_bridge): /ocp/qspi@4b300000: node name for SPI buses should be 'spi'
arch/arm/boot/dts/dra72-evm-revc.dtb: Warning (spi_bus_bridge): /ocp/qspi@4b300000: node name for SPI buses should be 'spi'
arch/arm/boot/dts/dra76-evm.dtb: Warning (spi_bus_bridge): /ocp/qspi@4b300000: node name for SPI buses should be 'spi'
arch/arm/boot/dts/dra7-evm.dtb: Warning (spi_bus_bridge): /ocp/qspi@4b300000: node name for SPI buses should be 'spi'
arch/arm/boot/dts/am335x-pdu001.dtb: Warning (spi_bus_reg): /ocp/spi@481a0000/cfaf240320a032t: SPI bus unit address format error, expected "0"
arch/arm/boot/dts/keystone-k2g-evm.dtb: Warning (spi_bus_bridge): /soc@0/qspi@2940000: node name for SPI buses should be 'spi'
arch/arm/boot/dts/keystone-k2g-ice.dtb: Warning (spi_bus_bridge): /soc@0/qspi@2940000: node name for SPI buses should be 'spi'

Cc: "Benoît Cousson" <bcousson@baylibre.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Santosh Shilimkar <ssantosh@kernel.org>
Cc: linux-omap@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
[tony@atomide.com: fixed mode to 644 for am335x-osd3358-sm-red.dts while at it]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am335x-boneblack-common.dtsi | 2 +-
 arch/arm/boot/dts/am335x-osd3358-sm-red.dts    | 2 +-
 arch/arm/boot/dts/am335x-pdu001.dts            | 2 +-
 arch/arm/boot/dts/am4372.dtsi                  | 2 +-
 arch/arm/boot/dts/am57xx-cl-som-am57x.dts      | 2 +-
 arch/arm/boot/dts/dra7.dtsi                    | 2 +-
 arch/arm/boot/dts/keystone-k2g.dtsi            | 2 +-
 arch/arm/boot/dts/omap2.dtsi                   | 4 ++--
 arch/arm/boot/dts/omap2430.dtsi                | 2 +-
 arch/arm/boot/dts/omap3-n9.dts                 | 2 +-
 10 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-boneblack-common.dtsi b/arch/arm/boot/dts/am335x-boneblack-common.dtsi
index 325daae40278a..21bc1173fa6b9 100644
--- a/arch/arm/boot/dts/am335x-boneblack-common.dtsi
+++ b/arch/arm/boot/dts/am335x-boneblack-common.dtsi
@@ -88,7 +88,7 @@
 };
 
 &i2c0 {
-	tda19988: tda19988 {
+	tda19988: tda19988@70 {
 		compatible = "nxp,tda998x";
 		reg = <0x70>;
 
diff --git a/arch/arm/boot/dts/am335x-osd3358-sm-red.dts b/arch/arm/boot/dts/am335x-osd3358-sm-red.dts
index 4d969013f99a6..d9e92671055bd 100644
--- a/arch/arm/boot/dts/am335x-osd3358-sm-red.dts
+++ b/arch/arm/boot/dts/am335x-osd3358-sm-red.dts
@@ -161,7 +161,7 @@
 		invensense,key = [4e cc 7e eb f6 1e 35 22 00 34 0d 65 32 e9 94 89];*/
 	};
 
-	bmp280: pressure@78 {
+	bmp280: pressure@76 {
 		compatible = "bosch,bmp280";
 		reg = <0x76>;
 	};
diff --git a/arch/arm/boot/dts/am335x-pdu001.dts b/arch/arm/boot/dts/am335x-pdu001.dts
index 1ad530a39a957..34fb63ef420f5 100644
--- a/arch/arm/boot/dts/am335x-pdu001.dts
+++ b/arch/arm/boot/dts/am335x-pdu001.dts
@@ -373,7 +373,7 @@
 	ti,pindir-d0-out-d1-in;
 	status = "okay";
 
-	cfaf240320a032t {
+	display-controller@0 {
 		compatible = "orisetech,otm3225a";
 		reg = <0>;
 		spi-max-frequency = <1000000>;
diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index cf1e4f747242f..09e58fb810d95 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -1101,7 +1101,7 @@
 			};
 		};
 
-		qspi: qspi@47900000 {
+		qspi: spi@47900000 {
 			compatible = "ti,am4372-qspi";
 			reg = <0x47900000 0x100>,
 			      <0x30000000 0x4000000>;
diff --git a/arch/arm/boot/dts/am57xx-cl-som-am57x.dts b/arch/arm/boot/dts/am57xx-cl-som-am57x.dts
index 203266f884807..52ae8eef60fc3 100644
--- a/arch/arm/boot/dts/am57xx-cl-som-am57x.dts
+++ b/arch/arm/boot/dts/am57xx-cl-som-am57x.dts
@@ -518,7 +518,7 @@
 	};
 
 	/* touch controller */
-	ads7846@0 {
+	touchscreen@1 {
 		pinctrl-names = "default";
 		pinctrl-0 = <&ads7846_pins>;
 
diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 2cb45ddd2ae3b..9136b3cf9a2ce 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -1369,7 +1369,7 @@
 			status = "disabled";
 		};
 
-		qspi: qspi@4b300000 {
+		qspi: spi@4b300000 {
 			compatible = "ti,dra7xxx-qspi";
 			reg = <0x4b300000 0x100>,
 			      <0x5c000000 0x4000000>;
diff --git a/arch/arm/boot/dts/keystone-k2g.dtsi b/arch/arm/boot/dts/keystone-k2g.dtsi
index 738b44cf2b0bb..1c833105d6c54 100644
--- a/arch/arm/boot/dts/keystone-k2g.dtsi
+++ b/arch/arm/boot/dts/keystone-k2g.dtsi
@@ -416,7 +416,7 @@
 			clock-names = "fck", "mmchsdb_fck";
 		};
 
-		qspi: qspi@2940000 {
+		qspi: spi@2940000 {
 			compatible = "ti,k2g-qspi", "cdns,qspi-nor";
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/arch/arm/boot/dts/omap2.dtsi b/arch/arm/boot/dts/omap2.dtsi
index f1d6de8b3c193..000bf16de6517 100644
--- a/arch/arm/boot/dts/omap2.dtsi
+++ b/arch/arm/boot/dts/omap2.dtsi
@@ -114,7 +114,7 @@
 			dma-names = "tx", "rx";
 		};
 
-		mcspi1: mcspi@48098000 {
+		mcspi1: spi@48098000 {
 			compatible = "ti,omap2-mcspi";
 			ti,hwmods = "mcspi1";
 			reg = <0x48098000 0x100>;
@@ -125,7 +125,7 @@
 				    "tx2", "rx2", "tx3", "rx3";
 		};
 
-		mcspi2: mcspi@4809a000 {
+		mcspi2: spi@4809a000 {
 			compatible = "ti,omap2-mcspi";
 			ti,hwmods = "mcspi2";
 			reg = <0x4809a000 0x100>;
diff --git a/arch/arm/boot/dts/omap2430.dtsi b/arch/arm/boot/dts/omap2430.dtsi
index 84635eeb99cd4..7f57af2f10acb 100644
--- a/arch/arm/boot/dts/omap2430.dtsi
+++ b/arch/arm/boot/dts/omap2430.dtsi
@@ -285,7 +285,7 @@
 			ti,timer-alwon;
 		};
 
-		mcspi3: mcspi@480b8000 {
+		mcspi3: spi@480b8000 {
 			compatible = "ti,omap2-mcspi";
 			ti,hwmods = "mcspi3";
 			reg = <0x480b8000 0x100>;
diff --git a/arch/arm/boot/dts/omap3-n9.dts b/arch/arm/boot/dts/omap3-n9.dts
index ded5fcf084eb7..1f91646b89516 100644
--- a/arch/arm/boot/dts/omap3-n9.dts
+++ b/arch/arm/boot/dts/omap3-n9.dts
@@ -40,7 +40,7 @@
 };
 
 &i2c3 {
-	ak8975@0f {
+	ak8975@f {
 		compatible = "asahi-kasei,ak8975";
 		reg = <0x0f>;
 	};
-- 
2.20.1

