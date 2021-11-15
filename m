Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C673450CBC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238615AbhKORmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:42:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237953AbhKORjx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:39:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 575836324A;
        Mon, 15 Nov 2021 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997198;
        bh=r8lz0dyZKz8fXwRGSzLHh99p+dcOFLime4hri3FIvFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6y1n2AYr1b3oGT2JUNxudCvk86+OBI1OyBrc/QF+pKw7Ifc2nsOJi9Yf1gBVL4En
         nyXOZuaEriB9HBu6HrljfLe0wd/JLM0JAii8zDs7Xv88fHK0Rh0k/rixwSBLFcD0tA
         ddOME3GibRdfyPVpu6951dfug1JKT5LmqpiFivfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/575] ARM: dts: sun7i: A20-olinuxino-lime2: Fix ethernet phy-mode
Date:   Mon, 15 Nov 2021 17:56:25 +0100
Message-Id: <20211115165345.719774124@linuxfoundation.org>
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

From: Bastien Roucariès <rouca@debian.org>

[ Upstream commit 55dd7e059098ce4bd0a55c251cb78e74604abb57 ]

Commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx delay
config") sets the RX/TX delay according to the phy-mode property in the
device tree. For the A20-olinuxino-lime2 board this is "rgmii", which is the
wrong setting.

Following the example of a900cac3750b ("ARM: dts: sun7i: a20: bananapro:
Fix ethernet phy-mode") the phy-mode is changed to "rgmii-id" which gets
the Ethernet working again on this board.

Signed-off-by: Bastien Roucariès <rouca@debian.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210916081721.237137-1-rouca@debian.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
index 9ba62774e89a1..488933b87ad5a 100644
--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
@@ -112,7 +112,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	status = "okay";
 };
 
-- 
2.33.0



