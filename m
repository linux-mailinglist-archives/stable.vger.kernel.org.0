Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09EE3C8FD4
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240441AbhGNTxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240492AbhGNTtu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 996EE613FA;
        Wed, 14 Jul 2021 19:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291930;
        bh=PHjOBuNXRblZhdlU79d2NA7Go6TW91OePXaAR5wbuII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8ruC/n6lGLNhZoePZIr6hHezpNyMTMdjN2IYt34KHvmPFHOkc3ley9vJwLVZJi2e
         Qqc3YOHQ+jfig+2WUaEruQCS2VO4I2bE+CQ271stG88XqsGz04oaF4bM4YRyZLfY4H
         t7n+Y0h3cu5P0FTN80q6WHDIobG9Jp4asJn61RwpCfhe44IkQ+Kp9TBDgjO3JxVusn
         Ryh3rN7knW1DaYBgE5UoTk03SJ3Vj/OGwfXh0t6isw7B4nEqw6K923ge5SSX4FEtls
         NucAJqcNp2zfmxAwpS1gKQEDOW5I69HSuL2WCFhjo7MAoRDXtNp5NNe4HWXxNvCAyZ
         tyEbhwjaQpVxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Elaine Zhang <zhangqing@rock-chips.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 11/51] arm64: dts: rockchip: Fix power-controller node names for rk3328
Date:   Wed, 14 Jul 2021 15:44:33 -0400
Message-Id: <20210714194513.54827-11-sashal@kernel.org>
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

[ Upstream commit 6e6a282b49c6db408d27231e3c709fbdf25e3c1b ]

Use more generic names (as recommended in the device tree specification
or the binding documentation)

Signed-off-by: Elaine Zhang <zhangqing@rock-chips.com>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210417112952.8516-7-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index e0ed323935a4..44ad744c4710 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -270,13 +270,13 @@ power: power-controller {
 			#address-cells = <1>;
 			#size-cells = <0>;
 
-			pd_hevc@RK3328_PD_HEVC {
+			power-domain@RK3328_PD_HEVC {
 				reg = <RK3328_PD_HEVC>;
 			};
-			pd_video@RK3328_PD_VIDEO {
+			power-domain@RK3328_PD_VIDEO {
 				reg = <RK3328_PD_VIDEO>;
 			};
-			pd_vpu@RK3328_PD_VPU {
+			power-domain@RK3328_PD_VPU {
 				reg = <RK3328_PD_VPU>;
 				clocks = <&cru ACLK_VPU>, <&cru HCLK_VPU>;
 			};
-- 
2.30.2

