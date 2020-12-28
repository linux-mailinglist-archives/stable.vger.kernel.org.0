Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38CD2E64D7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390789AbgL1Nh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:37:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390785AbgL1Nh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:37:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C190720867;
        Mon, 28 Dec 2020 13:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162607;
        bh=bdD5SzK7HqfaWQbaeNfuTRhLgnhB61qfPidL8ARsyA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AvKQdqI1J3L8u0MZOar8eF4Ccb5aJh4X6wg4szNl77fMdHjA4NhVNhBfz4edxsjRb
         0JXpeIFy9K/3epzj38yqIMIWt3nLDXOSBXxBZnKH5jy5DPL+6Pva1gmP5FSNpI1xzG
         /lbt3vWfwNPb21PqHJGXQHZuRzCHYxVH5E7iO6Pk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Greco <pgreco@centosproject.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 003/453] ARM: dts: sun8i: v40: bananapi-m2-berry: Fix ethernet node
Date:   Mon, 28 Dec 2020 13:43:59 +0100
Message-Id: <20201228124937.402658957@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Greco <pgreco@centosproject.org>

[ Upstream commit 8a82d91fa275aaea49be06d7f5b1407ce1c0dd4b ]

Ethernet PHY on BananaPi M2 Berry provides RX and TX delays. Fix ethernet
node to reflect that fact.

Fixes: 27e81e1970a8 ("ARM: dts: sun8i: v40: bananapi-m2-berry: Enable GMAC ethernet controller")
Signed-off-by: Pablo Greco <pgreco@centosproject.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/1604326769-39802-1-git-send-email-pgreco@centosproject.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts b/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts
index 84eb082957183..47954551f5735 100644
--- a/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts
+++ b/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts
@@ -120,7 +120,7 @@
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



