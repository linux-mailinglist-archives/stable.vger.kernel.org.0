Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77AB2E169F
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgLWDAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:00:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728821AbgLWCT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BBAB22573;
        Wed, 23 Dec 2020 02:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689977;
        bh=tRQVruxzzS+se+oMESlRnI8IqH3C2QYaeAVrLIrtn1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mhRmKuBtHB6/Qg0OmGQfK/YogHBsCCiJWXXIgo6PDG2k7bud643XyiR0weaYNyugH
         /v1tNJ3Kbygxq8rxyBXCrBSf2HSKfLyOLQQsAQ3BE3d139vxah/LfibUlUv5j/3eMQ
         ZrZE91bFU6dPmzDF1ed3m00JjG66aie4vpjrZWlTMhlu2eVfrASsKlBitg4NqvQSfY
         ZdcYHBb+T16zp7AHtpT1VjY0VWU8li0I5DJ5F8n67LEMltzzd/woiljjpsEMR8PO0P
         GJrHLwRrQvx3qicePb7/YtQyvJZKHzdRcZqADFWUuI8F6YPAMIDmzKTbp1uGNk7V/z
         8rhkyS+7gidww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 065/130] ARM: dts: hisilicon: fix errors detected by spi-pl022.yaml
Date:   Tue, 22 Dec 2020 21:17:08 -0500
Message-Id: <20201223021813.2791612-65-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 4c246408f0bdbc4100c95a5dad9e0688b4a3cfd0 ]

1. Change clock-names to "sspclk", "apb_pclk". Both of them use the same
   clock.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/hi3519.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/hi3519.dtsi b/arch/arm/boot/dts/hi3519.dtsi
index 630753c0d7044..c524c854d3192 100644
--- a/arch/arm/boot/dts/hi3519.dtsi
+++ b/arch/arm/boot/dts/hi3519.dtsi
@@ -127,8 +127,8 @@ spi_bus0: spi@12120000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x12120000 0x1000>;
 			interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&crg HI3519_SPI0_CLK>;
-			clock-names = "apb_pclk";
+			clocks = <&crg HI3519_SPI0_CLK>, <&crg HI3519_SPI0_CLK>;
+			clock-names = "sspclk", "apb_pclk";
 			num-cs = <1>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -139,8 +139,8 @@ spi_bus1: spi@12121000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x12121000 0x1000>;
 			interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&crg HI3519_SPI1_CLK>;
-			clock-names = "apb_pclk";
+			clocks = <&crg HI3519_SPI1_CLK>, <&crg HI3519_SPI1_CLK>;
+			clock-names = "sspclk", "apb_pclk";
 			num-cs = <1>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -151,8 +151,8 @@ spi_bus2: spi@12122000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x12122000 0x1000>;
 			interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&crg HI3519_SPI2_CLK>;
-			clock-names = "apb_pclk";
+			clocks = <&crg HI3519_SPI2_CLK>, <&crg HI3519_SPI2_CLK>;
+			clock-names = "sspclk", "apb_pclk";
 			num-cs = <1>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.27.0

