Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B4C3C8D4B
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236135AbhGNToZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236166AbhGNTnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5254613E9;
        Wed, 14 Jul 2021 19:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291643;
        bh=trteg84HErb6xW1RjbmH17U4+O+oysBVVdFM4E+QcaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mew5LqD8t5v3Q6MjUpe3/j92eMEFvUnLYs0BQj7gX0zs8YmNEJoKMaM3513xJHlyS
         DUcgnyEjWiz+h57dAe+6h2N3EN8sEgQsGJVf7udQxvLDV3kgi4lY2QvnwzUs2bBe16
         72zPrUvFvsO7aA64hjdQgsDaQwmN1uephMMz5eNx1cz+bsgxYgWJhAr3eFq62tDmq5
         5I6wbpi8TkI/xsrFMFQQOCCO1sd2YiUYUT9p67D+BfG2iF/xpPTl1UJdvZdTMhsjjo
         28FkN6/MVArvRZsmuPET5EDZk3rHDh9WQQpwoJ7VFHNT3RbY5I4e6mInbGJtDhGMNq
         xuD70Ue+YDx9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 005/102] arm64: dts: rockchip: Use only supported PCIe link speed on rk3399
Date:   Wed, 14 Jul 2021 15:38:58 -0400
Message-Id: <20210714194036.53141-5-sashal@kernel.org>
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
index 48ed4aaa37f3..476787027e03 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopi4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopi4.dtsi
@@ -504,7 +504,6 @@ &pcie_phy {
 };
 
 &pcie0 {
-	max-link-speed = <2>;
 	num-lanes = <2>;
 	vpcie0v9-supply = <&vcca0v9_s3>;
 	vpcie1v8-supply = <&vcca1v8_s3>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
index fb7599f07af4..17ba7c3d9a9c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
@@ -469,7 +469,6 @@ &pcie_phy {
 
 &pcie0 {
 	ep-gpios = <&gpio4 RK_PD3 GPIO_ACTIVE_HIGH>;
-	max-link-speed = <2>;
 	num-lanes = <4>;
 	pinctrl-0 = <&pcie_clkreqnb_cpm>;
 	pinctrl-names = "default";
diff --git a/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi b/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi
index 7257494d2831..bc385ad45a13 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi
@@ -324,7 +324,6 @@ &pcie_phy {
 
 &pcie0 {
 	ep-gpios = <&gpio0 RK_PB4 GPIO_ACTIVE_HIGH>;
-	max-link-speed = <2>;
 	num-lanes = <4>;
 	pinctrl-0 = <&pcie_clkreqnb_cpm>;
 	pinctrl-names = "default";
-- 
2.30.2

