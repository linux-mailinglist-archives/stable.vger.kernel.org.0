Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64193328B8D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238569AbhCAShO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:37:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233158AbhCAS3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:29:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AADEA65159;
        Mon,  1 Mar 2021 17:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618343;
        bh=FuZJLOVRkD+XGRz9qS1NRIB3qa7LT/2s/xHFh43HFfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXJxuYtoYEu2Zwnh/NjXuM9qQnQ0I5UvAcXvuRZSLbPuZMJxbxQBPJeg645UYo5JB
         OEzxXc4ZzE2zcsU2DJNPCfC5ybp7mUXXfJYvdGIgfINAKfDKDC2FN85ZOJfugVHy9Q
         mONRDo25lHIinZyHFZSjSmi4WR0Zsmf/Jggn6ZcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/663] arm64: dts: rockchip: rk3328: Add clock_in_out property to gmac2phy node
Date:   Mon,  1 Mar 2021 17:05:00 +0100
Message-Id: <20210301161144.338737545@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit c6433083f5930fdf52ad47c8c0459719c810dc89 ]

The gmac2phy is integrated with the PHY within the SoC. Any properties
related to this integration can be included in the .dtsi file, instead
of having board dts files specify them separately.

Add the clock_in_out property to specify the direction of the PHY clock.
This is the minimum required to have gmac2phy working on Linux. Other
examples include assigned-clocks, assigned-clock-rates, and
assigned-clock-parents properties, but the hardware default plus the
implementation requesting the appropriate clock rate also works.

Fixes: 9c4cc910fe28 ("ARM64: dts: rockchip: Add gmac2phy node support for rk3328")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20210117100710.4857-2-wens@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index db0d5c8e5f96a..93c734d8a46c2 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -928,6 +928,7 @@
 		phy-mode = "rmii";
 		phy-handle = <&phy>;
 		snps,txpbl = <0x4>;
+		clock_in_out = "output";
 		status = "disabled";
 
 		mdio {
-- 
2.27.0



