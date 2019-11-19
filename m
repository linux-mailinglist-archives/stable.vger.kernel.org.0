Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16634101518
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbfKSFkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:40:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729961AbfKSFkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:40:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BD5A208C3;
        Tue, 19 Nov 2019 05:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142036;
        bh=yRG4lXGZHqVRRehlry61nL/wufOOr98J8YvVsQqt1zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYVJpdmNCP7NygYM6DiYb8OCIAXy8gGi+n3/VV+UngdTGf5IXlDzlppr+1lbVR7Ye
         u1X99bgERjiwc1/DC8/NPgL2uj5BN4M6cRquC3YHKfcFMxMhrJV+19zIUeb+0Oosi9
         JcJj8zAv0c/e2G5x9sV8tuqBtsFjQl73ixT7XpVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 367/422] arm64: tegra: I2C on Tegra194 is not compatible with Tegra114
Date:   Tue, 19 Nov 2019 06:19:24 +0100
Message-Id: <20191119051422.796145230@linuxfoundation.org>
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

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit d9fd22447ba59a9b53a202fade977e82bfba8d8d ]

Tegra194 contains a version of the I2C controller that is no longer
compatible with the version found in Tegra114.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index a4dfcd19b9e88..9fc14bb9a0aff 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -118,7 +118,7 @@
 		};
 
 		gen1_i2c: i2c@3160000 {
-			compatible = "nvidia,tegra194-i2c", "nvidia,tegra114-i2c";
+			compatible = "nvidia,tegra194-i2c";
 			reg = <0x03160000 0x10000>;
 			interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
@@ -143,7 +143,7 @@
 		};
 
 		cam_i2c: i2c@3180000 {
-			compatible = "nvidia,tegra194-i2c", "nvidia,tegra114-i2c";
+			compatible = "nvidia,tegra194-i2c";
 			reg = <0x03180000 0x10000>;
 			interrupts = <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
@@ -157,7 +157,7 @@
 
 		/* shares pads with dpaux1 */
 		dp_aux_ch1_i2c: i2c@3190000 {
-			compatible = "nvidia,tegra194-i2c", "nvidia,tegra114-i2c";
+			compatible = "nvidia,tegra194-i2c";
 			reg = <0x03190000 0x10000>;
 			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
@@ -171,7 +171,7 @@
 
 		/* shares pads with dpaux0 */
 		dp_aux_ch0_i2c: i2c@31b0000 {
-			compatible = "nvidia,tegra194-i2c", "nvidia,tegra114-i2c";
+			compatible = "nvidia,tegra194-i2c";
 			reg = <0x031b0000 0x10000>;
 			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
@@ -184,7 +184,7 @@
 		};
 
 		gen7_i2c: i2c@31c0000 {
-			compatible = "nvidia,tegra194-i2c", "nvidia,tegra114-i2c";
+			compatible = "nvidia,tegra194-i2c";
 			reg = <0x031c0000 0x10000>;
 			interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
@@ -197,7 +197,7 @@
 		};
 
 		gen9_i2c: i2c@31e0000 {
-			compatible = "nvidia,tegra194-i2c", "nvidia,tegra114-i2c";
+			compatible = "nvidia,tegra194-i2c";
 			reg = <0x031e0000 0x10000>;
 			interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
@@ -264,7 +264,7 @@
 		};
 
 		gen2_i2c: i2c@c240000 {
-			compatible = "nvidia,tegra194-i2c", "nvidia,tegra114-i2c";
+			compatible = "nvidia,tegra194-i2c";
 			reg = <0x0c240000 0x10000>;
 			interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
@@ -277,7 +277,7 @@
 		};
 
 		gen8_i2c: i2c@c250000 {
-			compatible = "nvidia,tegra194-i2c", "nvidia,tegra114-i2c";
+			compatible = "nvidia,tegra194-i2c";
 			reg = <0x0c250000 0x10000>;
 			interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
-- 
2.20.1



