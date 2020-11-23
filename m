Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4245A2C081E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387418AbgKWMpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:45:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732471AbgKWMpt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:45:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4929220857;
        Mon, 23 Nov 2020 12:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135547;
        bh=KQHgldinaXVU4ptnrhh+NXgdwdh0aUB+OeY0+doq9Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVAjQO7yJQmf8A17ixyprYFY0JeWsmdUVQNspjJJsB6gPillCWtB/1XdAdSy5bi6m
         +vEeCVD0OzhVkmuteaIm7+JF3Z01xcmSfNVYgBz0hd0yK/ujuPKwMDEXJGKsZMdD8k
         r31d8GP05+nsxM6QXBhi9uphnPcSPT83FohpngUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 080/252] ARM: dts: sun8i: r40: bananapi-m2-ultra: Fix ethernet node
Date:   Mon, 23 Nov 2020 13:20:30 +0100
Message-Id: <20201123121839.457525762@linuxfoundation.org>
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



