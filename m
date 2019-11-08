Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD22F498E
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389954AbfKHLmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:42:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732711AbfKHLmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D472E21D82;
        Fri,  8 Nov 2019 11:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213342;
        bh=HFUeGsGjfvMfFSXB/QZfG3OacwRa96X7DnJEKW59VN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrXJykdZMygu3KrpiTK8opWY8pp2ohTzoXzaZYTaltsFv1GD/GbVzPl8Gj32lQFlH
         Ooqo7xvDEcnBM+wsmkn7sZljf+bKBmI7bGpgWlcn2L/YiOakxqLW1RABMgqOL5Gwfw
         CHBm1VT9cZd0ttNOZNxj1H2l1fbab9z/hHOOceog=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 179/205] arm64: dts: broadcom: Fix I2C and SPI bus warnings
Date:   Fri,  8 Nov 2019 06:37:26 -0500
Message-Id: <20191108113752.12502-179-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 7cdbe45da1a189e744e6801aebb462ee47235580 ]

dtc has new checks for I2C and SPI buses. Fix the warnings in node names
and unit-addresses.

arch/arm64/boot/dts/broadcom/stingray/bcm958742k.dtb: Warning (i2c_bus_reg): /hsls/i2c@e0000/pcf8574@20: I2C bus unit address format error, expected "27"
arch/arm64/boot/dts/broadcom/stingray/bcm958742t.dtb: Warning (i2c_bus_reg): /hsls/i2c@e0000/pcf8574@20: I2C bus unit address format error, expected "27"
arch/arm64/boot/dts/broadcom/stingray/bcm958742k.dtb: Warning (spi_bus_bridge): /hsls/ssp@180000: node name for SPI buses should be 'spi'
arch/arm64/boot/dts/broadcom/stingray/bcm958742k.dtb: Warning (spi_bus_bridge): /hsls/ssp@190000: node name for SPI buses should be 'spi'

Cc: Ray Jui <rjui@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: Jon Mason <jonmason@broadcom.com>
Cc: bcm-kernel-feedback-list@broadcom.com
Signed-off-by: Rob Herring <robh@kernel.org>
Acked-by: Scott Branden <sbranden@broadcom.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi          | 4 ++--
 arch/arm64/boot/dts/broadcom/stingray/bcm958742-base.dtsi | 2 +-
 arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi       | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi b/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi
index 1a406a76c86a2..ea854f689fda8 100644
--- a/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi
+++ b/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi
@@ -639,7 +639,7 @@
 			status = "disabled";
 		};
 
-		ssp0: ssp@66180000 {
+		ssp0: spi@66180000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x66180000 0x1000>;
 			interrupts = <GIC_SPI 404 IRQ_TYPE_LEVEL_HIGH>;
@@ -650,7 +650,7 @@
 			status = "disabled";
 		};
 
-		ssp1: ssp@66190000 {
+		ssp1: spi@66190000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x66190000 0x1000>;
 			interrupts = <GIC_SPI 405 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm64/boot/dts/broadcom/stingray/bcm958742-base.dtsi b/arch/arm64/boot/dts/broadcom/stingray/bcm958742-base.dtsi
index bc299c3d90683..a9b92e52d50e8 100644
--- a/arch/arm64/boot/dts/broadcom/stingray/bcm958742-base.dtsi
+++ b/arch/arm64/boot/dts/broadcom/stingray/bcm958742-base.dtsi
@@ -138,7 +138,7 @@
 &i2c1 {
 	status = "okay";
 
-	pcf8574: pcf8574@20 {
+	pcf8574: pcf8574@27 {
 		compatible = "nxp,pcf8574a";
 		gpio-controller;
 		#gpio-cells = <2>;
diff --git a/arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi b/arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi
index e283480bfc7e5..cfeaa855bd05a 100644
--- a/arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi
+++ b/arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi
@@ -521,7 +521,7 @@
 			status = "disabled";
 		};
 
-		ssp0: ssp@180000 {
+		ssp0: spi@180000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x00180000 0x1000>;
 			interrupts = <GIC_SPI 187 IRQ_TYPE_LEVEL_HIGH>;
@@ -533,7 +533,7 @@
 			status = "disabled";
 		};
 
-		ssp1: ssp@190000 {
+		ssp1: spi@190000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x00190000 0x1000>;
 			interrupts = <GIC_SPI 188 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.20.1

