Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F77E2E134A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbgLWCZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:25:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728478AbgLWCZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4547222573;
        Wed, 23 Dec 2020 02:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690291;
        bh=1yti10Y7NIYVoeeyGu4abk4to+H5Fd8eyt3vaODxOL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+w6un5bTh7j50lhAZP/FPh33DWXZT6qlSsVPc2vXrIjzCnjUFh2MSvho5KHhkw0n
         4gFpfTuAKyDOIcBvQeKv6Ow78yut6ak96evIFYL+MdrvLu6C164HpijAc57w8wJ4mI
         r3GYBJh4RNkqZtJmNtOemxPsLMHSunqm8QUEE4k3/fJEZV2Wnw7aYjcuqWcIyMd3GD
         kA6LgqUcDiA+CStqDpf5I6SY1KyBIQ54TtXAYu11/67Y7TB4Q0ptADyeARLXTdld39
         istzk/TSQrLbc71O/XhNccIzprr9JOJpkjBBueMjrNiS6wDhO2mRrx3N6Wy3WfJYor
         m3LtJPjfZ6O0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 28/48] ARM: dts: hisilicon: fix errors detected by spi-pl022.yaml
Date:   Tue, 22 Dec 2020 21:23:56 -0500
Message-Id: <20201223022417.2794032-28-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
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

