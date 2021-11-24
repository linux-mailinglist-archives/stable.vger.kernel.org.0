Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471A945BE0F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243452AbhKXMod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:44:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242798AbhKXMme (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:42:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F689613E6;
        Wed, 24 Nov 2021 12:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756715;
        bh=RZ9fip72YhH5glGNgEjXSXAJX/JV08QQbQJQVIjG+zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hrWHnyAt9P5geZWpv9ZzfQ55ym9vVZzk4G4L8JT/BaKVYR7u+kzQ5fcGBbwoX5mbd
         xLk/t9fd+8/2sVwLOOpDfCanI24MMijqVL+blfpz3QJrg77Zr0fM+6sHf1HOL0ADcV
         3XyOtvhJ/JX3NGNXu8+CGeqir6tdxGUu9TcYe7eQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kemnade <andreas@kemnade.info>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 146/251] arm: dts: omap3-gta04a4: accelerometer irq fix
Date:   Wed, 24 Nov 2021 12:56:28 +0100
Message-Id: <20211124115715.344448478@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 884ea75d79a36faf3731ad9d6b9c29f58697638d ]

Fix typo in pinctrl. It did only work because the bootloader
seems to have initialized it.

Fixes: ee327111953b ("ARM: dts: omap3-gta04: Define and use bma180 irq pin")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index e83d0619b3b7c..ee028aa663fa6 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -353,7 +353,7 @@
 		compatible = "bosch,bma180";
 		reg = <0x41>;
 		pinctrl-names = "default";
-		pintcrl-0 = <&bma180_pins>;
+		pinctrl-0 = <&bma180_pins>;
 		interrupt-parent = <&gpio4>;
 		interrupts = <19 IRQ_TYPE_LEVEL_HIGH>; /* GPIO_115 */
 	};
-- 
2.33.0



