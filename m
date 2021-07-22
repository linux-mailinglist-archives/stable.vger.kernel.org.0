Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0493D282F
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhGVPzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:55:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232798AbhGVPzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:55:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08DBB61369;
        Thu, 22 Jul 2021 16:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971751;
        bh=Pq3joOhYmmFn6w6GAvqYy/TaWo42sF9KPs7VYLbRpxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHnvV+BjD70Zs/BsU8vlaEaw0kep1CRZIjra9+etKn1HcCC4y0+Drlfv54YUQaqSO
         hmzt+wb9Gh4grGN1nXuZFlmKnogyeFYi2txxpfLpp24KC5gs4+mzMvnIPIdR3hiAvg
         T1wdEBJJBxG1Fm858YS0sZxF7Gz3jQ3JXuB8St1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elaine Zhang <zhangqing@rock-chips.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/125] arm64: dts: rockchip: Fix power-controller node names for rk3399
Date:   Thu, 22 Jul 2021 18:30:04 +0200
Message-Id: <20210722155625.121732715@linuxfoundation.org>
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

[ Upstream commit 148bbe29f9108812c6fedd8a228f9e1ed6b422f7 ]

Use more generic names (as recommended in the device tree specification
or the binding documentation)

Signed-off-by: Elaine Zhang <zhangqing@rock-chips.com>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210417112952.8516-8-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 40 ++++++++++++------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index ee6287b872db..4b6065dbba55 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1000,26 +1000,26 @@
 			#size-cells = <0>;
 
 			/* These power domains are grouped by VD_CENTER */
-			pd_iep@RK3399_PD_IEP {
+			power-domain@RK3399_PD_IEP {
 				reg = <RK3399_PD_IEP>;
 				clocks = <&cru ACLK_IEP>,
 					 <&cru HCLK_IEP>;
 				pm_qos = <&qos_iep>;
 			};
-			pd_rga@RK3399_PD_RGA {
+			power-domain@RK3399_PD_RGA {
 				reg = <RK3399_PD_RGA>;
 				clocks = <&cru ACLK_RGA>,
 					 <&cru HCLK_RGA>;
 				pm_qos = <&qos_rga_r>,
 					 <&qos_rga_w>;
 			};
-			pd_vcodec@RK3399_PD_VCODEC {
+			power-domain@RK3399_PD_VCODEC {
 				reg = <RK3399_PD_VCODEC>;
 				clocks = <&cru ACLK_VCODEC>,
 					 <&cru HCLK_VCODEC>;
 				pm_qos = <&qos_video_m0>;
 			};
-			pd_vdu@RK3399_PD_VDU {
+			power-domain@RK3399_PD_VDU {
 				reg = <RK3399_PD_VDU>;
 				clocks = <&cru ACLK_VDU>,
 					 <&cru HCLK_VDU>;
@@ -1028,94 +1028,94 @@
 			};
 
 			/* These power domains are grouped by VD_GPU */
-			pd_gpu@RK3399_PD_GPU {
+			power-domain@RK3399_PD_GPU {
 				reg = <RK3399_PD_GPU>;
 				clocks = <&cru ACLK_GPU>;
 				pm_qos = <&qos_gpu>;
 			};
 
 			/* These power domains are grouped by VD_LOGIC */
-			pd_edp@RK3399_PD_EDP {
+			power-domain@RK3399_PD_EDP {
 				reg = <RK3399_PD_EDP>;
 				clocks = <&cru PCLK_EDP_CTRL>;
 			};
-			pd_emmc@RK3399_PD_EMMC {
+			power-domain@RK3399_PD_EMMC {
 				reg = <RK3399_PD_EMMC>;
 				clocks = <&cru ACLK_EMMC>;
 				pm_qos = <&qos_emmc>;
 			};
-			pd_gmac@RK3399_PD_GMAC {
+			power-domain@RK3399_PD_GMAC {
 				reg = <RK3399_PD_GMAC>;
 				clocks = <&cru ACLK_GMAC>,
 					 <&cru PCLK_GMAC>;
 				pm_qos = <&qos_gmac>;
 			};
-			pd_sd@RK3399_PD_SD {
+			power-domain@RK3399_PD_SD {
 				reg = <RK3399_PD_SD>;
 				clocks = <&cru HCLK_SDMMC>,
 					 <&cru SCLK_SDMMC>;
 				pm_qos = <&qos_sd>;
 			};
-			pd_sdioaudio@RK3399_PD_SDIOAUDIO {
+			power-domain@RK3399_PD_SDIOAUDIO {
 				reg = <RK3399_PD_SDIOAUDIO>;
 				clocks = <&cru HCLK_SDIO>;
 				pm_qos = <&qos_sdioaudio>;
 			};
-			pd_tcpc0@RK3399_PD_TCPD0 {
+			power-domain@RK3399_PD_TCPD0 {
 				reg = <RK3399_PD_TCPD0>;
 				clocks = <&cru SCLK_UPHY0_TCPDCORE>,
 					 <&cru SCLK_UPHY0_TCPDPHY_REF>;
 			};
-			pd_tcpc1@RK3399_PD_TCPD1 {
+			power-domain@RK3399_PD_TCPD1 {
 				reg = <RK3399_PD_TCPD1>;
 				clocks = <&cru SCLK_UPHY1_TCPDCORE>,
 					 <&cru SCLK_UPHY1_TCPDPHY_REF>;
 			};
-			pd_usb3@RK3399_PD_USB3 {
+			power-domain@RK3399_PD_USB3 {
 				reg = <RK3399_PD_USB3>;
 				clocks = <&cru ACLK_USB3>;
 				pm_qos = <&qos_usb_otg0>,
 					 <&qos_usb_otg1>;
 			};
-			pd_vio@RK3399_PD_VIO {
+			power-domain@RK3399_PD_VIO {
 				reg = <RK3399_PD_VIO>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 
-				pd_hdcp@RK3399_PD_HDCP {
+				power-domain@RK3399_PD_HDCP {
 					reg = <RK3399_PD_HDCP>;
 					clocks = <&cru ACLK_HDCP>,
 						 <&cru HCLK_HDCP>,
 						 <&cru PCLK_HDCP>;
 					pm_qos = <&qos_hdcp>;
 				};
-				pd_isp0@RK3399_PD_ISP0 {
+				power-domain@RK3399_PD_ISP0 {
 					reg = <RK3399_PD_ISP0>;
 					clocks = <&cru ACLK_ISP0>,
 						 <&cru HCLK_ISP0>;
 					pm_qos = <&qos_isp0_m0>,
 						 <&qos_isp0_m1>;
 				};
-				pd_isp1@RK3399_PD_ISP1 {
+				power-domain@RK3399_PD_ISP1 {
 					reg = <RK3399_PD_ISP1>;
 					clocks = <&cru ACLK_ISP1>,
 						 <&cru HCLK_ISP1>;
 					pm_qos = <&qos_isp1_m0>,
 						 <&qos_isp1_m1>;
 				};
-				pd_vo@RK3399_PD_VO {
+				power-domain@RK3399_PD_VO {
 					reg = <RK3399_PD_VO>;
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-					pd_vopb@RK3399_PD_VOPB {
+					power-domain@RK3399_PD_VOPB {
 						reg = <RK3399_PD_VOPB>;
 						clocks = <&cru ACLK_VOP0>,
 							 <&cru HCLK_VOP0>;
 						pm_qos = <&qos_vop_big_r>,
 							 <&qos_vop_big_w>;
 					};
-					pd_vopl@RK3399_PD_VOPL {
+					power-domain@RK3399_PD_VOPL {
 						reg = <RK3399_PD_VOPL>;
 						clocks = <&cru ACLK_VOP1>,
 							 <&cru HCLK_VOP1>;
-- 
2.30.2



