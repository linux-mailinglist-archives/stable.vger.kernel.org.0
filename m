Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CF245C077
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344505AbhKXNJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:09:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345795AbhKXNGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:06:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D31AE613B3;
        Wed, 24 Nov 2021 12:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757492;
        bh=QL/irukXJ92Hx5qsh1P6QG7mkZvMvEu0je94ZkOOt1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVsZBHzZ1lUdUA4aahTPdq9fFSCDLxPCk9TCsqlBtQoMHjfiBCyo1pK7MLEVokcD+
         V2ErkKCftUKPkDUVRp+m/tRBnRuvTO+7dvdNF6ANB0AECvtiiQbtDsDFOHQ1F6FZ8z
         BFNRvET/COLl0yT8xpScXTsWLCh0FnzczrCQiXYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kemnade <andreas@kemnade.info>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 185/323] arm: dts: omap3-gta04a4: accelerometer irq fix
Date:   Wed, 24 Nov 2021 12:56:15 +0100
Message-Id: <20211124115725.191697500@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index 0c39a2340030b..a5aed92ab54b1 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -364,7 +364,7 @@
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



