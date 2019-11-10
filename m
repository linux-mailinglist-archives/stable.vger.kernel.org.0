Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8626F65EE
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbfKJCoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:44:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727406AbfKJCoL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6C4D21655;
        Sun, 10 Nov 2019 02:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353850;
        bh=yRG4lXGZHqVRRehlry61nL/wufOOr98J8YvVsQqt1zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQhaZeVCv4n8CGDmaX+10s2hPPFum1suUK7hFX/vWppsOnQrP9k1ln948CsoguSk2
         aSM4Pijv8nxuM0yVg2WgGAx6l7a2IU9SX6hZLKYJVLHcbgUNBdaorQqbxZYUYTQ7SQ
         61iTXOC+vg5H/D5tfDgaEVl5CoSYN/MT5lg4k0kc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 136/191] arm64: tegra: I2C on Tegra194 is not compatible with Tegra114
Date:   Sat,  9 Nov 2019 21:39:18 -0500
Message-Id: <20191110024013.29782-136-sashal@kernel.org>
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

