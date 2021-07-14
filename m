Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C044B3C8FCA
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240393AbhGNTxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240490AbhGNTtu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 059CF61370;
        Wed, 14 Jul 2021 19:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291929;
        bh=CeCUrSkVYpen4Na0pBiNXfILrVk5TDVB9FfMdMA4lkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bx/TVf1wlG2qjqbFeuZ5dZiPlbMq49G8eAtYNGwPCkARL6Pi98JS6/WzS/EoHUIsp
         IzCkLM6rnjRAIa5QJHud+eOtQyV7GoRqDHnBTZ5n8c/bYlVuZynalI63UherdKMT0Q
         ao6TL+Zbmgd63xvj/w6CtGSXxl9CezwGJlu7YYBbEjFbaS2BLwTPdrArSS15kVR6aO
         KS4JY/QMRBh05BJ/Nrbczo+g7iVk2LT/WBt++wLGLx0qk6Z/tK8c1I3rSaByPxiY4z
         1DmwCfvRI5zZ1gxPHkWwVBDCtTU1V3Kb8E6fix3Ivz0gKeL592pdanr8yrXCMtf5uP
         Tq9GpF5d0dQSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Elaine Zhang <zhangqing@rock-chips.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 10/51] arm64: dts: rockchip: Fix power-controller node names for px30
Date:   Wed, 14 Jul 2021 15:44:32 -0400
Message-Id: <20210714194513.54827-10-sashal@kernel.org>
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

From: Elaine Zhang <zhangqing@rock-chips.com>

[ Upstream commit d5de0d688ac6e0202674577b05d0726b8a6af401 ]

Use more generic names (as recommended in the device tree specification
or the binding documentation)

Signed-off-by: Elaine Zhang <zhangqing@rock-chips.com>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210417112952.8516-6-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/px30.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/px30.dtsi b/arch/arm64/boot/dts/rockchip/px30.dtsi
index 98b014a8f916..f297601c9f71 100644
--- a/arch/arm64/boot/dts/rockchip/px30.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30.dtsi
@@ -213,20 +213,20 @@ power: power-controller {
 			#size-cells = <0>;
 
 			/* These power domains are grouped by VD_LOGIC */
-			pd_usb@PX30_PD_USB {
+			power-domain@PX30_PD_USB {
 				reg = <PX30_PD_USB>;
 				clocks = <&cru HCLK_HOST>,
 					 <&cru HCLK_OTG>,
 					 <&cru SCLK_OTG_ADP>;
 				pm_qos = <&qos_usb_host>, <&qos_usb_otg>;
 			};
-			pd_sdcard@PX30_PD_SDCARD {
+			power-domain@PX30_PD_SDCARD {
 				reg = <PX30_PD_SDCARD>;
 				clocks = <&cru HCLK_SDMMC>,
 					 <&cru SCLK_SDMMC>;
 				pm_qos = <&qos_sdmmc>;
 			};
-			pd_gmac@PX30_PD_GMAC {
+			power-domain@PX30_PD_GMAC {
 				reg = <PX30_PD_GMAC>;
 				clocks = <&cru ACLK_GMAC>,
 					 <&cru PCLK_GMAC>,
@@ -234,7 +234,7 @@ pd_gmac@PX30_PD_GMAC {
 					 <&cru SCLK_GMAC_RX_TX>;
 				pm_qos = <&qos_gmac>;
 			};
-			pd_mmc_nand@PX30_PD_MMC_NAND {
+			power-domain@PX30_PD_MMC_NAND {
 				reg = <PX30_PD_MMC_NAND>;
 				clocks =  <&cru HCLK_NANDC>,
 					  <&cru HCLK_EMMC>,
@@ -247,14 +247,14 @@ pd_mmc_nand@PX30_PD_MMC_NAND {
 				pm_qos = <&qos_emmc>, <&qos_nand>,
 					 <&qos_sdio>, <&qos_sfc>;
 			};
-			pd_vpu@PX30_PD_VPU {
+			power-domain@PX30_PD_VPU {
 				reg = <PX30_PD_VPU>;
 				clocks = <&cru ACLK_VPU>,
 					 <&cru HCLK_VPU>,
 					 <&cru SCLK_CORE_VPU>;
 				pm_qos = <&qos_vpu>, <&qos_vpu_r128>;
 			};
-			pd_vo@PX30_PD_VO {
+			power-domain@PX30_PD_VO {
 				reg = <PX30_PD_VO>;
 				clocks = <&cru ACLK_RGA>,
 					 <&cru ACLK_VOPB>,
@@ -270,7 +270,7 @@ pd_vo@PX30_PD_VO {
 				pm_qos = <&qos_rga_rd>, <&qos_rga_wr>,
 					 <&qos_vop_m0>, <&qos_vop_m1>;
 			};
-			pd_vi@PX30_PD_VI {
+			power-domain@PX30_PD_VI {
 				reg = <PX30_PD_VI>;
 				clocks = <&cru ACLK_CIF>,
 					 <&cru ACLK_ISP>,
@@ -281,7 +281,7 @@ pd_vi@PX30_PD_VI {
 					 <&qos_isp_wr>, <&qos_isp_m1>,
 					 <&qos_vip>;
 			};
-			pd_gpu@PX30_PD_GPU {
+			power-domain@PX30_PD_GPU {
 				reg = <PX30_PD_GPU>;
 				clocks = <&cru SCLK_GPU>;
 				pm_qos = <&qos_gpu>;
-- 
2.30.2

