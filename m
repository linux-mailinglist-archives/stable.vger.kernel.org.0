Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C402CD6C5
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 14:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbgLCN3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 08:29:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728067AbgLCN3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 08:29:18 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maciej Matuszczyk <maccraft123mc@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 02/39] arm64: dts: rockchip: Remove system-power-controller from pmic on Odroid Go Advance
Date:   Thu,  3 Dec 2020 08:27:56 -0500
Message-Id: <20201203132834.930999-2-sashal@kernel.org>
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

From: Maciej Matuszczyk <maccraft123mc@gmail.com>

[ Upstream commit 01fe332800d0d2f94337b45c1973f4cf28ae6195 ]

This fixes a poweroff issue when this is supposed to happen
via PSCI.

Signed-off-by: Maciej Matuszczyk <maccraft123mc@gmail.com>
Link: https://lore.kernel.org/r/20201023181629.119727-1-maccraft123mc@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3326-odroid-go2.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3326-odroid-go2.dts b/arch/arm64/boot/dts/rockchip/rk3326-odroid-go2.dts
index 35bd6b904b9c7..3376810385193 100644
--- a/arch/arm64/boot/dts/rockchip/rk3326-odroid-go2.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3326-odroid-go2.dts
@@ -243,7 +243,6 @@ rk817: pmic@20 {
 		interrupts = <RK_PB2 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pmic_int>;
-		rockchip,system-power-controller;
 		wakeup-source;
 		#clock-cells = <1>;
 		clock-output-names = "rk808-clkout1", "xin32k";
-- 
2.27.0

