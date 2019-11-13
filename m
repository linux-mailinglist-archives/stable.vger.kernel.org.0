Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42712FA64A
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfKMBuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:50:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:37350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbfKMBug (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8E4722466;
        Wed, 13 Nov 2019 01:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609836;
        bh=IeNKQvy9juCc7xi7oxqa/oqAhGZngI0NECDQy/pOYzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=md8gjvMxJkusqgQa9IwF3QRATn36g4MEy7Lqg1kwuKK9nSI4hrAc/e+fl3fZnKwAq
         M5VlI6021jFumqk08+hhICsXLDikiJFNWBBoj2/KwOebogHB3TSvjf+qQvb5eW3iJ2
         9ZM6zN26CoDwr5gt2WZHac1ETBX9sy7UUF1LG9+o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 009/209] ARM: dts: sun8i: h3: bpi-m2-plus: Fix address for external RGMII Ethernet PHY
Date:   Tue, 12 Nov 2019 20:47:05 -0500
Message-Id: <20191113015025.9685-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit db9fd9d13e30fc67737ac9893a82e6b095e85a64 ]

The external RTL8211E RGMII Ethernet PHY is configured via external
resistors to use the address 0x1. The 0x0 address is a broadcast address
for this family of PHYs, and should not be used explicitly.

Fixes: 8c7ba536e709 ("ARM: sun8i: bananapi-m2-plus: Enable dwmac-sun8i")
Fixes: 4904337fe34f ("ARM: dts: sunxi: Restore EMAC changes (boards)")
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-h3-bananapi-m2-plus.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun8i-h3-bananapi-m2-plus.dts b/arch/arm/boot/dts/sun8i-h3-bananapi-m2-plus.dts
index 30540dc8e0c5f..bdda0d99128e5 100644
--- a/arch/arm/boot/dts/sun8i-h3-bananapi-m2-plus.dts
+++ b/arch/arm/boot/dts/sun8i-h3-bananapi-m2-plus.dts
@@ -140,7 +140,7 @@
 &external_mdio {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
-		reg = <0>;
+		reg = <1>;
 	};
 };
 
-- 
2.20.1

