Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4936B3D282C
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhGVPzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232793AbhGVPzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:55:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1C9161363;
        Thu, 22 Jul 2021 16:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971746;
        bh=/MmbbZ2gtfgAbNhJYKCJ9dYB+zujD9MssojSTGCrGwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpun25WjOQOJexWnwJ/jhNeKjEBW0Q79Dgc5bQ0aNmoUVZRRHI2LyqqFeaWO2CZpM
         tKRBsBmNZUVkC2DGbyMfSPx8ceCPamhRH4KQCsSMqT6GxBZuwl8Iarz35QFKL9ISRh
         XCgnOnc8ehNUht36v1pHQ/yrmX2bCbavs6jeGc8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elaine Zhang <zhangqing@rock-chips.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/125] arm64: dts: rockchip: Fix power-controller node names for px30
Date:   Thu, 22 Jul 2021 18:30:02 +0200
Message-Id: <20210722155625.056000572@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 64193292d26c..0d6761074b11 100644
--- a/arch/arm64/boot/dts/rockchip/px30.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30.dtsi
@@ -244,20 +244,20 @@
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
@@ -265,7 +265,7 @@
 					 <&cru SCLK_GMAC_RX_TX>;
 				pm_qos = <&qos_gmac>;
 			};
-			pd_mmc_nand@PX30_PD_MMC_NAND {
+			power-domain@PX30_PD_MMC_NAND {
 				reg = <PX30_PD_MMC_NAND>;
 				clocks =  <&cru HCLK_NANDC>,
 					  <&cru HCLK_EMMC>,
@@ -278,14 +278,14 @@
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
@@ -301,7 +301,7 @@
 				pm_qos = <&qos_rga_rd>, <&qos_rga_wr>,
 					 <&qos_vop_m0>, <&qos_vop_m1>;
 			};
-			pd_vi@PX30_PD_VI {
+			power-domain@PX30_PD_VI {
 				reg = <PX30_PD_VI>;
 				clocks = <&cru ACLK_CIF>,
 					 <&cru ACLK_ISP>,
@@ -312,7 +312,7 @@
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



