Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDFD2CD6BE
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 14:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388243AbgLCN3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 08:29:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387961AbgLCN3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 08:29:23 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Markus Reichl <m.reichl@fivetechno.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 05/39] arm64: dts: rockchip: Reorder LED triggers from mmc devices on rk3399-roc-pc.
Date:   Thu,  3 Dec 2020 08:27:59 -0500
Message-Id: <20201203132834.930999-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132834.930999-1-sashal@kernel.org>
References: <20201203132834.930999-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Reichl <m.reichl@fivetechno.de>

[ Upstream commit 7327c8b98e2e14c47021eea14d1ab268086a6408 ]

After patch [1] SD-card becomes mmc1 and eMMC becomes mmc2.
Correct trigger of LEDs accordingly.

[1]
https://patchwork.kernel.org/patch/11881427

Signed-off-by: Markus Reichl <m.reichl@fivetechno.de>
Link: https://lore.kernel.org/r/20201104192933.1001-1-m.reichl@fivetechno.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
index b85ec31cd2835..78ef0037ad4b5 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
@@ -74,14 +74,14 @@ diy_led: led-1 {
 			label = "red:diy";
 			gpios = <&gpio0 RK_PB5 GPIO_ACTIVE_HIGH>;
 			default-state = "off";
-			linux,default-trigger = "mmc1";
+			linux,default-trigger = "mmc2";
 		};
 
 		yellow_led: led-2 {
 			label = "yellow:yellow-led";
 			gpios = <&gpio0 RK_PA2 GPIO_ACTIVE_HIGH>;
 			default-state = "off";
-			linux,default-trigger = "mmc0";
+			linux,default-trigger = "mmc1";
 		};
 	};
 
-- 
2.27.0

