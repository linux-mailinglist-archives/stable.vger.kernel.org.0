Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20BE313789
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbhBHP1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:27:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231855AbhBHPTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:19:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DA9664EE9;
        Mon,  8 Feb 2021 15:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797177;
        bh=N7FE8Gh+PUregZe8oAXW1bc3sRaoBUoSpLd1++26rZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHRsW8HLTTGqdrgi8vgB4BwUTiWfHLCYSDSYjhjIvnQ9uAPMsJwUrtZ2yVn+F0G83
         iiZ5C7DGZhB1CV1WsjrevlPXl8UxsH7XG478dwVHdehrDOZEcznwP7l+GNgmOm79ph
         rUNj9hs4NVf3m/Qvl8IUT8HGUi6f/81pLNtKzqPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon South <simon@simonsouth.net>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/120] arm64: dts: rockchip: Use only supported PCIe link speed on Pinebook Pro
Date:   Mon,  8 Feb 2021 16:00:06 +0100
Message-Id: <20210208145819.168198981@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon South <simon@simonsouth.net>

[ Upstream commit 642fb2795290c4abe629ca34fb8ff6d78baa9fd3 ]

On Pinebook Pro laptops with an NVMe SSD installed, prevent random
crashes in the NVMe driver by not attempting to use a PCIe link speed
higher than that supported by the RK3399 SoC.

See commit 712fa1777207 ("arm64: dts: rockchip: add max-link-speed for
rk3399").

Fixes: 5a65505a6988 ("arm64: dts: rockchip: Add initial support for Pinebook Pro")
Signed-off-by: Simon South <simon@simonsouth.net>
Link: https://lore.kernel.org/r/20200930185627.5918-1-simon@simonsouth.net
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
index 06d48338c8362..219b7507a10fb 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -790,7 +790,6 @@
 &pcie0 {
 	bus-scan-delay-ms = <1000>;
 	ep-gpios = <&gpio2 RK_PD4 GPIO_ACTIVE_HIGH>;
-	max-link-speed = <2>;
 	num-lanes = <4>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pcie_clkreqn_cpm>;
-- 
2.27.0



