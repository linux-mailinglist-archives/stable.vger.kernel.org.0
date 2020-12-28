Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301822E6463
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730940AbgL1NjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:39:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:39398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391286AbgL1Ni7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:38:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF64B20719;
        Mon, 28 Dec 2020 13:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162698;
        bh=KYlu5SC7gait3Hv275QjXFtKtU8AN/vqYVplx/fyv0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+S4JtFbEzxsZhma0I34eR4YDPdQ9sbxC4mbUzN7QPl1inLrjSSkKj7IB2izGRz7X
         kSEXTyC09oyW8z6Sv81Aac8EJYShHuDwVnIzXKlkntBBpe8kygDKwYjlFfqeYMKjx6
         PkeNoYAwFNz6qNjiJZ4cG5O5hhg8HCq6mNYyaDlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Greco <pgreco@centosproject.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/453] ARM: dts: sun8i: r40: bananapi-m2-berry: Fix dcdc1 regulator
Date:   Mon, 28 Dec 2020 13:43:58 +0100
Message-Id: <20201228124937.355959406@linuxfoundation.org>
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

[ Upstream commit bd5cdcdc66e1f7179ff6d172d1e5f55e43403aa8 ]

DCDC1 regulator powers many different subsystems. While some of them can
work at 3.0 V, some of them can not. For example, VCC-HDMI can only work
between 3.24 V and 3.36 V. According to OS images provided by the board
manufacturer this regulator should be set to 3.3 V.

Set DCDC1 and DCDC1SW to 3.3 V in order to fix this.

Fixes: 23edc168bd98 ("ARM: dts: sun8i: Add board dts file for Banana Pi M2 Berry")
Fixes: 27e81e1970a8 ("ARM: dts: sun8i: v40: bananapi-m2-berry: Enable GMAC ethernet controller")
Signed-off-by: Pablo Greco <pgreco@centosproject.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/1604326755-39742-1-git-send-email-pgreco@centosproject.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts b/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts
index 15c22b06fc4b6..84eb082957183 100644
--- a/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts
+++ b/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts
@@ -198,16 +198,16 @@
 };
 
 &reg_dc1sw {
-	regulator-min-microvolt = <3000000>;
-	regulator-max-microvolt = <3000000>;
+	regulator-min-microvolt = <3300000>;
+	regulator-max-microvolt = <3300000>;
 	regulator-name = "vcc-gmac-phy";
 };
 
 &reg_dcdc1 {
 	regulator-always-on;
-	regulator-min-microvolt = <3000000>;
-	regulator-max-microvolt = <3000000>;
-	regulator-name = "vcc-3v0";
+	regulator-min-microvolt = <3300000>;
+	regulator-max-microvolt = <3300000>;
+	regulator-name = "vcc-3v3";
 };
 
 &reg_dcdc2 {
-- 
2.27.0



