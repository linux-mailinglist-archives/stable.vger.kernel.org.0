Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A402C07CF
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733224AbgKWMo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:44:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:57610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733215AbgKWMoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:44:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FCA920857;
        Mon, 23 Nov 2020 12:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135464;
        bh=rTMv1Ro2795ODx6+PQMVFDA0yI0tpHTuhGfbt8L2tvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sGcB5i2a7tRq+PO+6Ln7mOMHa9Xpa3NoL4IWH6zJ+EQBVdqdWSGWYO6AXhji9OWmy
         iK0IaApnR+QQYiN6cw35bLsK2ladk00JYMQ1RxTpEleQeGyH10QmcjrEvqrNer8y91
         f8vdO3JHvW6HLS28XE/al9ItobaxPn5fiT/xm9iI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 076/252] arm64: dts: allwinner: Pine H64: Enable both RGMII RX/TX delay
Date:   Mon, 23 Nov 2020 13:20:26 +0100
Message-Id: <20201123121839.264007867@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 419c65f5000a6c25597ea52488528d75b287cbd0 ]

Since commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx delay config"),
the network is unusable on PineH64 model A.

This is due to phy-mode incorrectly set to rgmii instead of rgmii-id.

Fixes: 729e1ffcf47e ("arm64: allwinner: h6: add support for the Ethernet on Pine H64")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20201019063449.33316-1-clabbe@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64.dts
index af85b2074867f..961732c52aa0e 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-pine-h64.dts
@@ -100,7 +100,7 @@
 &emac {
 	pinctrl-names = "default";
 	pinctrl-0 = <&ext_rgmii_pins>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&ext_rgmii_phy>;
 	phy-supply = <&reg_gmac_3v3>;
 	allwinner,rx-delay-ps = <200>;
-- 
2.27.0



