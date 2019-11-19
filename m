Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A345101462
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfKSFdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:33:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729517AbfKSFdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:33:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BADE621783;
        Tue, 19 Nov 2019 05:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141598;
        bh=3R1O+2sefDUBuO2KrxNRutCSxBn0BF/KyQKfUA/8QQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvhJq7VlBpE8sHTfD0QtUSv3L09zK5QyOHSG6pGyZAFLUkyqwx1i2xcBZJYNPlWZP
         /3+Y0HjVS2XreuGQ1Ot5SpLBQMDQOawLlXrsHZEKHTC6hDu4/l111bR9u6yUkssrN4
         N243hpGmiRAer2W8eSfIX17PhTruoJusuVAbK/Sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 214/422] ARM: dts: sunxi: Fix I2C bus warnings
Date:   Tue, 19 Nov 2019 06:16:51 +0100
Message-Id: <20191119051412.467259994@linuxfoundation.org>
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

[ Upstream commit 0729b4af5753b65aa031f58c435da53dbbf56d19 ]

dtc has new checks for I2C buses. Fix the warnings in unit-addresses.

arch/arm/boot/dts/sun8i-a23-gt90h-v4.dtb: Warning (i2c_bus_reg): /soc@1c00000/i2c@1c2ac00/touchscreen@0: I2C bus unit address format error, expected "40"
arch/arm/boot/dts/sun8i-a23-inet86dz.dtb: Warning (i2c_bus_reg): /soc@1c00000/i2c@1c2ac00/touchscreen@0: I2C bus unit address format error, expected "40"
arch/arm/boot/dts/sun8i-a23-polaroid-mid2407pxe03.dtb: Warning (i2c_bus_reg): /soc@1c00000/i2c@1c2ac00/touchscreen@0: I2C bus unit address format error, expected "40"
arch/arm/boot/dts/sun8i-a23-polaroid-mid2809pxe04.dtb: Warning (i2c_bus_reg): /soc@1c00000/i2c@1c2ac00/touchscreen@0: I2C bus unit address format error, expected "40"
arch/arm/boot/dts/sun8i-a33-ga10h-v1.1.dtb: Warning (i2c_bus_reg): /soc@1c00000/i2c@1c2ac00/touchscreen@0: I2C bus unit address format error, expected "40"
arch/arm/boot/dts/sun8i-a33-inet-d978-rev2.dtb: Warning (i2c_bus_reg): /soc@1c00000/i2c@1c2ac00/touchscreen@0: missing or empty reg property
arch/arm/boot/dts/sun8i-a33-ippo-q8h-v1.2.dtb: Warning (i2c_bus_reg): /soc@1c00000/i2c@1c2ac00/touchscreen@0: missing or empty reg property
arch/arm/boot/dts/sun8i-a33-q8-tablet.dtb: Warning (i2c_bus_reg): /soc@1c00000/i2c@1c2ac00/touchscreen@0: missing or empty reg property
arch/arm/boot/dts/sun5i-a13-utoo-p66.dtb: Warning (i2c_bus_reg): /soc@1c00000/i2c@1c2b000/touchscreen: I2C bus unit address format error, expected "40"
arch/arm/boot/dts/sun5i-a13-difrnce-dit4350.dtb: Warning (i2c_bus_reg): /soc@1c00000/i2c@1c2b000/touchscreen: missing or empty reg property
arch/arm/boot/dts/sun5i-a13-empire-electronix-m712.dtb: Warning (i2c_bus_reg): /soc@1c00000/i2c@1c2b000/touchscreen: missing or empty reg property
arch/arm/boot/dts/sun5i-a13-inet-98v-rev2.dtb: Warning (i2c_bus_reg): /soc@1c00000/i2c@1c2b000/touchscreen: missing or empty reg property
arch/arm/boot/dts/sun5i-a13-q8-tablet.dtb: Warning (i2c_bus_reg): /soc@1c00000/i2c@1c2b000/touchscreen: missing or empty reg property

Cc: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun5i-reference-design-tablet.dtsi | 3 ++-
 arch/arm/boot/dts/sun8i-reference-design-tablet.dtsi | 3 ++-
 arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts    | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/sun5i-reference-design-tablet.dtsi b/arch/arm/boot/dts/sun5i-reference-design-tablet.dtsi
index 8acbaab14fe51..d2a2eb8b3f262 100644
--- a/arch/arm/boot/dts/sun5i-reference-design-tablet.dtsi
+++ b/arch/arm/boot/dts/sun5i-reference-design-tablet.dtsi
@@ -92,7 +92,8 @@
 	 */
 	clock-frequency = <400000>;
 
-	touchscreen: touchscreen {
+	touchscreen: touchscreen@40 {
+		reg = <0x40>;
 		interrupt-parent = <&pio>;
 		interrupts = <6 11 IRQ_TYPE_EDGE_FALLING>; /* EINT11 (PG11) */
 		pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/sun8i-reference-design-tablet.dtsi b/arch/arm/boot/dts/sun8i-reference-design-tablet.dtsi
index 880096c7e2523..5e8a95af89b8c 100644
--- a/arch/arm/boot/dts/sun8i-reference-design-tablet.dtsi
+++ b/arch/arm/boot/dts/sun8i-reference-design-tablet.dtsi
@@ -69,7 +69,8 @@
 	 */
 	clock-frequency = <400000>;
 
-	touchscreen: touchscreen@0 {
+	touchscreen: touchscreen@40 {
+		reg = <0x40>;
 		interrupt-parent = <&pio>;
 		interrupts = <1 5 IRQ_TYPE_EDGE_FALLING>; /* PB5 */
 		pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts b/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts
index 35859d8f3267f..bf97f6244c233 100644
--- a/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts
+++ b/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts
@@ -95,7 +95,7 @@
 &i2c0 {
 	status = "okay";
 
-	axp22x: pmic@68 {
+	axp22x: pmic@34 {
 		compatible = "x-powers,axp221";
 		reg = <0x34>;
 		interrupt-parent = <&nmi_intc>;
-- 
2.20.1



