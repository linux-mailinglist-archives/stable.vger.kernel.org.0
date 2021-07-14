Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEAD3C902F
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhGNTyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:54:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241003AbhGNTuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A73D613F9;
        Wed, 14 Jul 2021 19:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291993;
        bh=MrvJvscpo2LTj7JAkW3EHLvumxFOVj2Qi/NLBhySmfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t61TaKijve8IMuTZ8GRyYHayiFSGKDr1ClJqk9Vsu7dQD7O0L/PieI9n2o0Cg/sjZ
         QmEm9TA2mOaGixdsS3hRl3hd2/FMdvvZUsQ00ab5LfahPYcIc9o2CP5DJN/EawIwu+
         CdHFd3eAP3XydD4w1Y7zyZ6qsgfuBvZNbyfN6sEqsuHMxADs/vv4HVPIjMBUwrW1jB
         31f3LIjUDhPWXKaxWIgURgZ8vnoo4wUDSUe9m4zN6Jw3N3mUUubCiFn4HO11GEi66i
         AMCxK6jO8ECi70ksQL9qrcxqe9DNqt3Cb/V+r4NesLxTXhpAhXjmkF4NS8ssJmNd7e
         Zad8ZJg79yCPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/39] ARM: dts: rockchip: Fix IOMMU nodes properties on rk322x
Date:   Wed, 14 Jul 2021 15:45:51 -0400
Message-Id: <20210714194625.55303-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
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
index 2aa74267ae51..3fe874cab38c 100644
--- a/arch/arm/boot/dts/rk322x.dtsi
+++ b/arch/arm/boot/dts/rk322x.dtsi
@@ -548,10 +548,9 @@ vpu_mmu: iommu@20020800 {
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
 
@@ -559,10 +558,9 @@ vdec_mmu: iommu@20030480 {
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
 
@@ -570,7 +568,6 @@ vop_mmu: iommu@20053f00 {
 		compatible = "rockchip,iommu";
 		reg = <0x20053f00 0x100>;
 		interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "vop_mmu";
 		clocks = <&cru ACLK_VOP>, <&cru HCLK_VOP>;
 		clock-names = "aclk", "iface";
 		iommu-cells = <0>;
@@ -581,10 +578,9 @@ iep_mmu: iommu@20070800 {
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

