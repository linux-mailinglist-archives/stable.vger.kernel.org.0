Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84BE2E63AF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405216AbgL1Nql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:46:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405115AbgL1NqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:46:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D4E82063A;
        Mon, 28 Dec 2020 13:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163131;
        bh=9U3upSxYlBXjhkpUqNlElFC4H3T32885hb1ZB7T2aXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MlrLIGVLgwYqTpS3dlBwrot4TEPwyNCbf9cknjhd2nhHmvL8oYb8RSiPp6RcCTr8C
         j4QJKYvRCwpq+ahYkcfNRYDxl8g86YQNYAfK5mkWVu9PyA6WGepW2FriNkmpXT5nCo
         jplFMN/uSJYgnBy6MAhCtyEfIMQWqc44ZI36u1BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 181/453] arm64: dts: armada-3720-turris-mox: update ethernet-phy handle name
Date:   Mon, 28 Dec 2020 13:46:57 +0100
Message-Id: <20201228124945.912741305@linuxfoundation.org>
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

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 3aa669a994c9110a2dc7e08a5c0958a9ea5eb17c ]

Use property name `phy-handle` instead of the deprecated `phy` to
connect eth2 to the PHY.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 7109d817db2e ("arm64: dts: marvell: add DTS for Turris Mox")
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index c3668187b8446..aa52927e2e9c2 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -144,7 +144,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&rgmii_pins>;
 	phy-mode = "rgmii-id";
-	phy = <&phy1>;
+	phy-handle = <&phy1>;
 	status = "okay";
 };
 
-- 
2.27.0



