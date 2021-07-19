Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928ED3CE3F4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344362AbhGSPlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348223AbhGSPfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11BA061601;
        Mon, 19 Jul 2021 16:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711222;
        bh=pZcMXx1l67f2NROb7JPoPMqXFjUa20hfB2QYR1czKLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVRUPUodp+9n7qmHcB+dl6g0jlJgTVpNtlqgWUWpfFs/v7GdTXfn6zmYMA6G3hrkO
         Xz9bgT/MX8Qwx2bl1FTnXWroxn6pA2PnjIS3MiQYNlugPxAhfvcaSiZNYiR9nAxacW
         VVThobiqg0fXCDWPb7DoL1DhIHTDqcCepU/7/ewQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 272/351] arm64: dts: rockchip: Drop fephy pinctrl from gmac2phy on rk3328 rock-pi-e
Date:   Mon, 19 Jul 2021 16:53:38 +0200
Message-Id: <20210719144953.937405562@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit e6526f90696e6a7d722d04b958f15b97d6fd9ce6 ]

Turns out the fephy pins are already claimed in the phy node, which is
rightfully where they should be claimed.

Drop the pinctrl properties from the gmac2phy node for the ROCK Pi E.

Fixes: b918e81f2145 ("arm64: dts: rockchip: rk3328: Add Radxa ROCK Pi E")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20210426095916.14574-1-wens@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts b/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
index c7e31efdd2e1..c02059c0a954 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
@@ -177,8 +177,6 @@
 };
 
 &gmac2phy {
-	pinctrl-names = "default";
-	pinctrl-0 = <&fephyled_linkm1>, <&fephyled_rxm1>;
 	status = "okay";
 };
 
-- 
2.30.2



