Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3DC8F63C7
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbfKJCzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:55:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729714AbfKJCuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:50:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 489A722790;
        Sun, 10 Nov 2019 02:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354225;
        bh=fDe/LvzwDE9ROI0LUyhW0TYuI0y2n6u5PqL3kgo9f/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STc5iAb/5k3t21MZJ25Ix59F40K/aKMkeNEKuHvqbFroePPFRPmDaNS4erXHEMazE
         NwjTvP9bJsXgHAN3xHbzKm3UIzDcugshmtbX2SudU6LOpglkcAyOef312CBwsMI4nI
         LHazaxnSUllU0a3AMBEuwOVxlEy3ek/998NikRqk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, Chanho Min <chanho.min@lge.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 62/66] arm64: dts: lg: Fix SPI controller node names
Date:   Sat,  9 Nov 2019 21:48:41 -0500
Message-Id: <20191110024846.32598-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024846.32598-1-sashal@kernel.org>
References: <20191110024846.32598-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 09bae3b64cb580c95329bd8d16f08f0a5cb81ec9 ]

SPI controller nodes should be named 'spi' rather than 'ssp'. Fixing the
name enables dtc SPI bus checks.

Cc: Chanho Min <chanho.min@lge.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/lg/lg1312.dtsi | 4 ++--
 arch/arm64/boot/dts/lg/lg1313.dtsi | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/lg/lg1312.dtsi b/arch/arm64/boot/dts/lg/lg1312.dtsi
index fbafa24cd5335..5e0c5dc973e33 100644
--- a/arch/arm64/boot/dts/lg/lg1312.dtsi
+++ b/arch/arm64/boot/dts/lg/lg1312.dtsi
@@ -167,14 +167,14 @@
 			clock-names = "apb_pclk";
 			status="disabled";
 		};
-		spi0: ssp@fe800000 {
+		spi0: spi@fe800000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x0 0xfe800000 0x1000>;
 			interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clk_bus>;
 			clock-names = "apb_pclk";
 		};
-		spi1: ssp@fe900000 {
+		spi1: spi@fe900000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x0 0xfe900000 0x1000>;
 			interrupts = <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm64/boot/dts/lg/lg1313.dtsi b/arch/arm64/boot/dts/lg/lg1313.dtsi
index e703e1149c757..f3b1ba6f74220 100644
--- a/arch/arm64/boot/dts/lg/lg1313.dtsi
+++ b/arch/arm64/boot/dts/lg/lg1313.dtsi
@@ -167,14 +167,14 @@
 			clock-names = "apb_pclk";
 			status="disabled";
 		};
-		spi0: ssp@fe800000 {
+		spi0: spi@fe800000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x0 0xfe800000 0x1000>;
 			interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clk_bus>;
 			clock-names = "apb_pclk";
 		};
-		spi1: ssp@fe900000 {
+		spi1: spi@fe900000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x0 0xfe900000 0x1000>;
 			interrupts = <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.20.1

