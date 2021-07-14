Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD42F3C8C0B
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhGNTlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230340AbhGNTlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3781613E3;
        Wed, 14 Jul 2021 19:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291488;
        bh=aNDyYKcACJG0/ugU4EXNpQ6crJZpl0S+SDAfkc9b6AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwH8Nt3luf0IpCxXMTE2mxhcEPoSPFVC5DG78rQYxagFM4W7SHRQT3p2ON/WarCo0
         CqB9mbDHiBUXqpwSypH+2QHfg8JbuUPP6StVHb1TH0w5rtVEU09xOkCyqLO7bceJv0
         vvpcvs4g56rrUyJ0WMEGfZBFIKHDI5hG4m883LX7ycXDA+tOE6cfBKNVdkmkV7h1aU
         M2WcMNfOxwIWmgKQGHapoRS9m8O8mklbGiJ+QjYnJjVHh9EH1G/xcZsHts1PP3IHWa
         fYTSsBCoZbpPrx4E89FnjLFTk6mLDC8mu6DMApWLU2jIND0bZKJSf9He+nJXTw5yyq
         YPJaKBNXwOvgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 005/108] arm64: dts: rockchip: Use only supported PCIe link speed on rk3399
Date:   Wed, 14 Jul 2021 15:36:17 -0400
Message-Id: <20210714193800.52097-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 954d5986afa50c178ea7554e6abdd611d08f5ade ]

The max link speed supported by the rk3399 is already set in the
rk3399.dtsi file so don't set unsupported link speeds in device
specific DTs. This is the same fix as 642fb27.

Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Link: https://lore.kernel.org/r/20210413141709.845592-1-pbrobinson@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-nanopi4.dtsi      | 1 -
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi    | 1 -
 arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi | 1 -
 3 files changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-nanopi4.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-nanopi4.dtsi
index 16fd58c4a80f..8c0ff6c96e03 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopi4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopi4.dtsi
@@ -510,7 +510,6 @@ &pcie_phy {
 };
 
 &pcie0 {
-	max-link-speed = <2>;
 	num-lanes = <2>;
 	vpcie0v9-supply = <&vcca0v9_s3>;
 	vpcie1v8-supply = <&vcca1v8_s3>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
index 7d0a7c697703..b28888ea9262 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
@@ -474,7 +474,6 @@ &pcie_phy {
 
 &pcie0 {
 	ep-gpios = <&gpio4 RK_PD3 GPIO_ACTIVE_HIGH>;
-	max-link-speed = <2>;
 	num-lanes = <4>;
 	pinctrl-0 = <&pcie_clkreqnb_cpm>;
 	pinctrl-names = "default";
diff --git a/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi b/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi
index c0074b3ed4af..01d1a75c8b4d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi
@@ -329,7 +329,6 @@ &pcie_phy {
 
 &pcie0 {
 	ep-gpios = <&gpio0 RK_PB4 GPIO_ACTIVE_HIGH>;
-	max-link-speed = <2>;
 	num-lanes = <4>;
 	pinctrl-0 = <&pcie_clkreqnb_cpm>;
 	pinctrl-names = "default";
-- 
2.30.2

