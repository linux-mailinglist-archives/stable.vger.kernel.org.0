Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AE13C8D5D
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbhGNToi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:44:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236258AbhGNTnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33F28613FE;
        Wed, 14 Jul 2021 19:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291651;
        bh=KZ7qtIBvJQCUHMJ7yqOjOv/AUPX2tA0r9ajKz661kdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4ncF90+XvpCXnzCvQ6WEVhsmZSr53h7yfz0q1ZWGcEJ2WE/qsjXiIQjmGwnJ3Yg9
         /z6Zs1Y2VdvxrAuy7Ui8HXluq/PG7X8Z/2Q9I8eZFVKjDV5Ig2BURHxwL0DAavOm7H
         2OpXuESonsokqZUF9dU/5Q+cxPYxqiHH5PM0aISQsaX4mnkQJwZLO/IYbDOUBY4h0F
         glgSpFjxzP18axb3xbFO1g5k4D2KNthiS2NaX7A4OkmADYF0lzxGuBejE4H2KHRp2A
         ts+/+GdHIDVNx0eF+bzjitiUDTiv0FyaCI5eGafEb8XUyOqgAW3gqWZhg42ygMDkfV
         /eeDm27nype1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Elaine Zhang <zhangqing@rock-chips.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 010/102] ARM: dts: rockchip: Fix power-controller node names for rk3188
Date:   Wed, 14 Jul 2021 15:39:03 -0400
Message-Id: <20210714194036.53141-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Elaine Zhang <zhangqing@rock-chips.com>

[ Upstream commit d3bcbcd396175ac26aa54919c0b31c7d2878fc24 ]

Use more generic names (as recommended in the device tree specification
or the binding documentation)

Signed-off-by: Elaine Zhang <zhangqing@rock-chips.com>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210417112952.8516-3-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3188.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index 2c08ae60e4a1..b6bde9d12c2b 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -699,7 +699,7 @@ power: power-controller {
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		pd_vio@RK3188_PD_VIO {
+		power-domain@RK3188_PD_VIO {
 			reg = <RK3188_PD_VIO>;
 			clocks = <&cru ACLK_LCDC0>,
 				 <&cru ACLK_LCDC1>,
@@ -721,7 +721,7 @@ pd_vio@RK3188_PD_VIO {
 				 <&qos_rga>;
 		};
 
-		pd_video@RK3188_PD_VIDEO {
+		power-domain@RK3188_PD_VIDEO {
 			reg = <RK3188_PD_VIDEO>;
 			clocks = <&cru ACLK_VDPU>,
 				 <&cru ACLK_VEPU>,
@@ -730,7 +730,7 @@ pd_video@RK3188_PD_VIDEO {
 			pm_qos = <&qos_vpu>;
 		};
 
-		pd_gpu@RK3188_PD_GPU {
+		power-domain@RK3188_PD_GPU {
 			reg = <RK3188_PD_GPU>;
 			clocks = <&cru ACLK_GPU>;
 			pm_qos = <&qos_gpu>;
-- 
2.30.2

