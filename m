Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A930DE687A
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731888AbfJ0VVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731883AbfJ0VVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:21:14 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B092621726;
        Sun, 27 Oct 2019 21:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211273;
        bh=jshiL9Gc0DG93snG39ZSp1k8ScCCGWQ/85w28QJllew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYlsGCn0zqHrHYXAY1xVTHiEVRtqbNs046dp7WhO1QHyNzrsW5+h2/Z972YX7m3Pm
         5v75XcqndrWdJNkgxXXY7P/2SRJRGD3enGiGQ1HG+kjuvzmT3uba96C/i/35homCP6
         UQ+s0yqrUq0H8QrIyDVGgUBYEJXSP+5OxE3idJFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Nyekjaer <sean.nyekjaer@prevas.dk>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH 5.3 086/197] net: phy: micrel: Update KSZ87xx PHY name
Date:   Sun, 27 Oct 2019 22:00:04 +0100
Message-Id: <20191027203356.363900834@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 1d951ba3da67bbc7a9b0e05987e09552c2060e18 ]

The KSZ8795 PHY ID is in fact used by KSZ8794/KSZ8795/KSZ8765 switches.
Update the PHY ID and name to reflect that, as this family of switches
is commonly refered to as KSZ87xx

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Sean Nyekjaer <sean.nyekjaer@prevas.dk>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c   |    4 ++--
 include/linux/micrel_phy.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -395,7 +395,7 @@ static int ksz8061_config_init(struct ph
 
 static int ksz8795_match_phy_device(struct phy_device *phydev)
 {
-	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ8795);
+	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ87XX);
 }
 
 static int ksz9021_load_values_from_of(struct phy_device *phydev,
@@ -1174,7 +1174,7 @@ static struct phy_driver ksphy_driver[]
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-	.name		= "Micrel KSZ8795",
+	.name		= "Micrel KSZ87XX Switch",
 	/* PHY_BASIC_FEATURES */
 	.config_init	= kszphy_config_init,
 	.config_aneg	= ksz8873mll_config_aneg,
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -31,7 +31,7 @@
 #define PHY_ID_KSZ886X		0x00221430
 #define PHY_ID_KSZ8863		0x00221435
 
-#define PHY_ID_KSZ8795		0x00221550
+#define PHY_ID_KSZ87XX		0x00221550
 
 #define	PHY_ID_KSZ9477		0x00221631
 


