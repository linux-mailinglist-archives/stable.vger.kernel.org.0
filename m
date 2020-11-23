Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7B62C0B4B
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388998AbgKWNWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:22:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731602AbgKWMfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:35:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07E3E2065E;
        Mon, 23 Nov 2020 12:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134951;
        bh=KQHgldinaXVU4ptnrhh+NXgdwdh0aUB+OeY0+doq9Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elgpC8ufIghgOiOB4CJZQnlvK3UP/Qnb66rrIz1gylnr111s19GMXc+m84u5EuNSr
         KNS9iPXg6DLuqve8jhP50OFX2Lza1aSh0pWrz5ZmaZLwdCWhp+uYsItNB+WpTQgUo/
         rueqEL7cOd+vU/gcdE9r9AuLw0s6rI4NaSrdt5Js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/158] ARM: dts: sun8i: r40: bananapi-m2-ultra: Fix ethernet node
Date:   Mon, 23 Nov 2020 13:21:18 +0100
Message-Id: <20201123121822.345295587@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit b3eec3212e66ece33f69be0de98d54e67834e798 ]

Ethernet PHY on BananaPi M2 Ultra provides RX and TX delays. Fix
ethernet node to reflect that fact.

Fixes: c36fd5a48bd2 ("ARM: dts: sun8i: r40: bananapi-m2-ultra: Enable GMAC ethernet controller")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20201025081949.783443-1-jernej.skrabec@siol.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts b/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts
index ea15073f0c79c..7db89500f399c 100644
--- a/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts
+++ b/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts
@@ -129,7 +129,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-supply = <&reg_dc1sw>;
 	status = "okay";
 };
-- 
2.27.0



