Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D279F6406
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbfKJC4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:56:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:47170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728947AbfKJC4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03F5322558;
        Sun, 10 Nov 2019 02:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354111;
        bh=s+qDWJiCsCOtUONRrtoz3ETIwaa58Xm2dheg+889mKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqQwFawfZL06YkQKZsmjK0mgiyelE6EcDW7P3G+SIUyufTCYdy3BDZlvZSe4q/Vx1
         oHjD3F9K5DjWz7u21T32nVtQlQATuWQuJVWzLfNbg224kcu3JIBnwJjQ2GlPXBhQ5y
         KBrEPjY4eb6CiuxubNbmsSL7S/MCR9PAu3bb55h8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, Chanho Min <chanho.min@lge.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 101/109] arm64: dts: lg: Fix SPI controller node names
Date:   Sat,  9 Nov 2019 21:45:33 -0500
Message-Id: <20191110024541.31567-101-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
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
index 860c8fb107950..4bde7b6f2b113 100644
--- a/arch/arm64/boot/dts/lg/lg1312.dtsi
+++ b/arch/arm64/boot/dts/lg/lg1312.dtsi
@@ -168,14 +168,14 @@
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
index 1887af654a7db..16ced1ff1ad36 100644
--- a/arch/arm64/boot/dts/lg/lg1313.dtsi
+++ b/arch/arm64/boot/dts/lg/lg1313.dtsi
@@ -168,14 +168,14 @@
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

