Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBD91FDD12
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbgFRBXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730996AbgFRBXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:23:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C538521D82;
        Thu, 18 Jun 2020 01:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443413;
        bh=6xPYoE8X7XkNTACLzWGx9psDyOiI/Nu4/wzkklbhQnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9Hhi0dJ7HyaJG8bDOnZQzN2bASs+7a6XnWSYapbz+st4OHJb3pnq2O37FnDAcLpR
         zhEOcP1JooJ9J06cYpr9/djQg/WHDNiebo16VTMzRROXKBMI9GJGlw1aFNGW3KQTt6
         KGje+IEyP61qM1LzOLxp++FSnyd0c6wpktBhVbgM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Icenowy Zheng <icenowy@aosc.io>,
        Maxime Ripard <mripard@kernel.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 056/172] ARM: dts: sun8i-h2-plus-bananapi-m2-zero: Fix led polarity
Date:   Wed, 17 Jun 2020 21:20:22 -0400
Message-Id: <20200618012218.607130-56-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Stehlé <vincent.stehle@laposte.net>

[ Upstream commit 34b6826df7462c541752cf8b1de2691b26d78ae0 ]

The PWR-LED on the bananapi m2 zero board is on when gpio PL10 is low.
This has been verified on a board and in the schematics [1].

[1]: http://wiki.banana-pi.org/Banana_Pi_BPI-M2_ZERO#Documents

Fixes: 8b8061fcbfae ("ARM: dts: sun8i: h2+: add support for Banana Pi M2 Zero board")
Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Icenowy Zheng <icenowy@aosc.io>
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts b/arch/arm/boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts
index 1db2541135a7..00e0d6940c30 100644
--- a/arch/arm/boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts
+++ b/arch/arm/boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts
@@ -32,7 +32,7 @@ leds {
 
 		pwr_led {
 			label = "bananapi-m2-zero:red:pwr";
-			gpios = <&r_pio 0 10 GPIO_ACTIVE_HIGH>; /* PL10 */
+			gpios = <&r_pio 0 10 GPIO_ACTIVE_LOW>; /* PL10 */
 			default-state = "on";
 		};
 	};
-- 
2.25.1

