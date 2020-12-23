Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007702E1469
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbgLWCjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730083AbgLWCXz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFDC622482;
        Wed, 23 Dec 2020 02:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690219;
        bh=1yti10Y7NIYVoeeyGu4abk4to+H5Fd8eyt3vaODxOL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkTbjrq104TVa3oCH9bj+ntjEiHVBzPF/DA4rvfwn8GyVeBi/qZjJolM9HCJHNLGw
         Wmiyf6LJ2TFwBV5zJYy6lsDYO20twzyH+o0IyY7Eq/jTQXjBWBAXhTeUuIn/OLLgY8
         VbkQwJdYFmY77K9oP0fjyX2ma5OOKBxiKlod1SrdbFPm7p+6+xfVDSV1yyYbrxFlQT
         sEk+2QE5cohA/2Yr4AxbfSpKpV66GUCP7WZsGaNxVFcyY4zJ9KNkFajlHTdqcTrxml
         YYB5pJs20W29bPw15XA6/1wP9lAMw1IunVTQESgConiWcp5DtYYwE1k0mbDJRiR5g4
         HtjYDOJ+P1lGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 37/66] ARM: dts: hisilicon: fix errors detected by spi-pl022.yaml
Date:   Tue, 22 Dec 2020 21:22:23 -0500
Message-Id: <20201223022253.2793452-37-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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
index 5729ecfcdc8bf..723c451d1420e 100644
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

