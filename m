Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C8B2E1525
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgLWCsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:48:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729586AbgLWCWP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D386122AAF;
        Wed, 23 Dec 2020 02:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690117;
        bh=Xu40XiNNwVJAQAFqV2wYnjU/S41hM84C8gjgwXe5cZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3igqoCzgmNAMrB3aFtImjLKAADY/0J/KZE9ToIALOjLyyepgtgBJAC8R2IxdjUvR
         XOC1YimiXFx7vbKtKBW+qA3r6jh2Bq44zrwXp2Mi8fhR624u1EpHHwPlT2Np3XU8P2
         GGw0EAyhegLq+74TBx7TLHq3k3dPg5n5Hpj/uZ+Nq18yZYml0gNvSab3aCTqtySM1R
         0SH2jO0IGc2hPZVubljFsjE1MiRczzb2P5DhbJ17D6KF48NCWyqaqOBP9/oCnKF7V/
         +/BNOGsmtzL5fJS7I7EmWm+DzVtWCHiFcvDokAne96vn0a/M0g7PWnkgD/y58ZA+OY
         WqV37tvZBp20Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 44/87] ARM: dts: hisilicon: fix errors detected by spi-pl022.yaml
Date:   Tue, 22 Dec 2020 21:20:20 -0500
Message-Id: <20201223022103.2792705-44-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index 7df6358081d29..9955b6f0a6340 100644
--- a/arch/arm/boot/dts/hi3519.dtsi
+++ b/arch/arm/boot/dts/hi3519.dtsi
@@ -140,8 +140,8 @@ spi_bus0: spi@12120000 {
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
@@ -152,8 +152,8 @@ spi_bus1: spi@12121000 {
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
@@ -164,8 +164,8 @@ spi_bus2: spi@12122000 {
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

