Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F003C8FC3
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240376AbhGNTxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240458AbhGNTts (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0EEE613E4;
        Wed, 14 Jul 2021 19:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291922;
        bh=D9Q3+2c8pNWhiQdnkaAY2oJ8GRB/Mpx8mgKa/tUqdQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U750MVKcIp70r0l1+0rWnalRA5LPpn/1lz+LTxHMhlD4d1y4TvAdoHgJ3GQeCJSH4
         mBk8y5lgvVvWgu9nsTFrjBQSfuZP2hrQNuQukENwqKc3ZR6ry5K8zsNzLooYgooHqv
         e0fmcxZIkZ2MsYZIJ9TQJmGJ3KuNISvsfFEqNm2FThkuPuYBetW0i8hiWc1zGTD9FI
         9a9R5/fbY4zcyPtdBHkUGIU7XCf+TzLy2Pos2cPrKmkSd9vv7PfcvhGaC8jUgnGL55
         +6HPlA3Bbhz1zIUGNk0MuXzmZvFdkI2pyQVlWBsnXo+5KewYg5BKgnIYMgL7RsuOm2
         lTloJsJUSfCDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/51] ARM: dts: rockchip: Fix IOMMU nodes properties on rk322x
Date:   Wed, 14 Jul 2021 15:44:28 -0400
Message-Id: <20210714194513.54827-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

[ Upstream commit 6b023929666f0be5df75f5e0278d1b70effadf42 ]

Add '#" to iommu-cells properties.
Remove useless interrupt-names properties

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Link: https://lore.kernel.org/r/20210507090232.233049-4-benjamin.gaignard@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk322x.dtsi | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/rk322x.dtsi b/arch/arm/boot/dts/rk322x.dtsi
index 6bb78b19c555..140e22d74dcf 100644
--- a/arch/arm/boot/dts/rk322x.dtsi
+++ b/arch/arm/boot/dts/rk322x.dtsi
@@ -570,10 +570,9 @@ vpu_mmu: iommu@20020800 {
 		compatible = "rockchip,iommu";
 		reg = <0x20020800 0x100>;
 		interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "vpu_mmu";
 		clocks = <&cru ACLK_VPU>, <&cru HCLK_VPU>;
 		clock-names = "aclk", "iface";
-		iommu-cells = <0>;
+		#iommu-cells = <0>;
 		status = "disabled";
 	};
 
@@ -581,10 +580,9 @@ vdec_mmu: iommu@20030480 {
 		compatible = "rockchip,iommu";
 		reg = <0x20030480 0x40>, <0x200304c0 0x40>;
 		interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "vdec_mmu";
 		clocks = <&cru ACLK_RKVDEC>, <&cru HCLK_RKVDEC>;
 		clock-names = "aclk", "iface";
-		iommu-cells = <0>;
+		#iommu-cells = <0>;
 		status = "disabled";
 	};
 
@@ -614,7 +612,6 @@ vop_mmu: iommu@20053f00 {
 		compatible = "rockchip,iommu";
 		reg = <0x20053f00 0x100>;
 		interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "vop_mmu";
 		clocks = <&cru ACLK_VOP>, <&cru HCLK_VOP>;
 		clock-names = "aclk", "iface";
 		#iommu-cells = <0>;
@@ -625,10 +622,9 @@ iep_mmu: iommu@20070800 {
 		compatible = "rockchip,iommu";
 		reg = <0x20070800 0x100>;
 		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "iep_mmu";
 		clocks = <&cru ACLK_IEP>, <&cru HCLK_IEP>;
 		clock-names = "aclk", "iface";
-		iommu-cells = <0>;
+		#iommu-cells = <0>;
 		status = "disabled";
 	};
 
-- 
2.30.2

