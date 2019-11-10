Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4A4F66F8
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfKJDRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:17:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbfKJCkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CAA221655;
        Sun, 10 Nov 2019 02:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353624;
        bh=RHlaMWsk/Gruwmgw+Oi5SSkGWnNFBDQD7HA7XGA8KwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xQ2hDwrdwVo4j6ZS8AuvA5cPnANK5tZ+9IFp3sIS3wCfs4dg5f4a9nPU7Yi4CnFk0
         HTYkxPnDizXnhuWbyzvJkPC+xdOEJI/7XF753aQ28kx/LXkxd7EXDiJ2n2B9ivfLc7
         CJXCsLx7F2teC8GTQuAWFoDm0zdApg6jpK7+L5Xs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 009/191] ARM: dts: xilinx: Fix I2C and SPI bus warnings
Date:   Sat,  9 Nov 2019 21:37:11 -0500
Message-Id: <20191110024013.29782-9-sashal@kernel.org>
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

[ Upstream commit f5054ceed420b1f38d37920a4c65446fcc5d6b90 ]

dtc has new checks for I2C and SPI buses. Fix the warnings in node names
and unit-addresses.

arch/arm/boot/dts/zynq-zc702.dtb: Warning (i2c_bus_reg): /amba/i2c@e0004000/i2c-mux@74/i2c@7/hwmon@52: I2C bus unit address format error, expected "34"
arch/arm/boot/dts/zynq-zc702.dtb: Warning (i2c_bus_reg): /amba/i2c@e0004000/i2c-mux@74/i2c@7/hwmon@53: I2C bus unit address format error, expected "35"
arch/arm/boot/dts/zynq-zc702.dtb: Warning (i2c_bus_reg): /amba/i2c@e0004000/i2c-mux@74/i2c@7/hwmon@54: I2C bus unit address format error, expected "36"
arch/arm/boot/dts/zynq-zc770-xm013.dtb: Warning (spi_bus_reg): /amba/spi@e0006000/eeprom@0: SPI bus unit address format error, expected "2"
arch/arm/boot/dts/zynq-zc770-xm010.dtb: Warning (spi_bus_reg): /amba/spi@e0007000/flash@0: SPI bus unit address format error, expected "1"

Cc: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/zynq-zc702.dts       | 12 ++++++------
 arch/arm/boot/dts/zynq-zc770-xm010.dts |  2 +-
 arch/arm/boot/dts/zynq-zc770-xm013.dts |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index cc5a3dc2b4a08..27cd6cb52f1ba 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -174,17 +174,17 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <7>;
-			hwmon@52 {
+			hwmon@34 {
 				compatible = "ti,ucd9248";
-				reg = <52>;
+				reg = <0x34>;
 			};
-			hwmon@53 {
+			hwmon@35 {
 				compatible = "ti,ucd9248";
-				reg = <53>;
+				reg = <0x35>;
 			};
-			hwmon@54 {
+			hwmon@36 {
 				compatible = "ti,ucd9248";
-				reg = <54>;
+				reg = <0x36>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/zynq-zc770-xm010.dts b/arch/arm/boot/dts/zynq-zc770-xm010.dts
index 0e1bfdd3421ff..0dd352289a45e 100644
--- a/arch/arm/boot/dts/zynq-zc770-xm010.dts
+++ b/arch/arm/boot/dts/zynq-zc770-xm010.dts
@@ -68,7 +68,7 @@
 	status = "okay";
 	num-cs = <4>;
 	is-decoded-cs = <0>;
-	flash@0 {
+	flash@1 {
 		compatible = "sst25wf080", "jedec,spi-nor";
 		reg = <1>;
 		spi-max-frequency = <1000000>;
diff --git a/arch/arm/boot/dts/zynq-zc770-xm013.dts b/arch/arm/boot/dts/zynq-zc770-xm013.dts
index 651913f1afa2a..4ae2c85df3a00 100644
--- a/arch/arm/boot/dts/zynq-zc770-xm013.dts
+++ b/arch/arm/boot/dts/zynq-zc770-xm013.dts
@@ -62,7 +62,7 @@
 	status = "okay";
 	num-cs = <4>;
 	is-decoded-cs = <0>;
-	eeprom: eeprom@0 {
+	eeprom: eeprom@2 {
 		at25,byte-len = <8192>;
 		at25,addr-mode = <2>;
 		at25,page-size = <32>;
-- 
2.20.1

