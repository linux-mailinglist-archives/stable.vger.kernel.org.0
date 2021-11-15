Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826B745260F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244995AbhKPCBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:01:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240143AbhKOSF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D49D3632FE;
        Mon, 15 Nov 2021 17:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998173;
        bh=8m/jAuasau/h5OxgDneoZDFt12mQCplE9uQwIKbw0yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPBXd7MVvTVO96zTvCp0415VSwn4V5/l6BGGXYrkWncrRImWQuR75XTOTft8RsT5S
         tZVRXgLzOd2eORNRocJ36UojHC2oWLBa5oRXey+VezZShtjfuMu66tCqJVdUfi6bRm
         bFF+J3Z1Q7cZzAGP2kCA6U0oP40VvWl7lhs/JMxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kemnade <andreas@kemnade.info>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 414/575] arm: dts: omap3-gta04a4: accelerometer irq fix
Date:   Mon, 15 Nov 2021 18:02:19 +0100
Message-Id: <20211115165358.082374217@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 7b8c18e6605e4..80c9e5e34136a 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -515,7 +515,7 @@
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



