Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B647A2E64E4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390741AbgL1PyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:54:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390540AbgL1Ng4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:36:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 998C622AAA;
        Mon, 28 Dec 2020 13:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162601;
        bh=4fSAbATC9athLGvhiMJddmqx99mVtF/ZbL6EnTz4K4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KsZa7ozkGoo95FZQ7AX5YXNckkxm1Oc3yN0EjK5DuC5fbOTNRlb+QLbnNsPMzdonF
         o898IpwcjxNNuYO800Jo7cEvZudcXbhOK++yyK07Sb/+d9MhvApsJEKl+hJKFij3eL
         3F1AtaBiiNdhdRyV29ZITt9jUnmRmV6u/dG07OXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Greco <pgreco@centosproject.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/453] ARM: dts: sun7i: bananapi: Enable RGMII RX/TX delay on Ethernet PHY
Date:   Mon, 28 Dec 2020 13:43:57 +0100
Message-Id: <20201228124937.323853446@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Greco <pgreco@centosproject.org>

[ Upstream commit 8c9cb4094ccf242eddd140efba13872c55f68a87 ]

The Ethernet PHY on the Bananapi M1 has the RX and TX delays enabled on
the PHY, using pull-ups on the RXDLY and TXDLY pins.

Fix the phy-mode description to correct reflect this so that the
implementation doesn't reconfigure the delays incorrectly. This
happened with commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e
rx/tx delay config").

Fixes: 8a5b272fbf44 ("ARM: dts: sun7i: Add Banana Pi board")
Signed-off-by: Pablo Greco <pgreco@centosproject.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/1604326600-39544-1-git-send-email-pgreco@centosproject.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun7i-a20-bananapi.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun7i-a20-bananapi.dts b/arch/arm/boot/dts/sun7i-a20-bananapi.dts
index bb3987e101c29..0b3d9ae756503 100644
--- a/arch/arm/boot/dts/sun7i-a20-bananapi.dts
+++ b/arch/arm/boot/dts/sun7i-a20-bananapi.dts
@@ -132,7 +132,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-supply = <&reg_gmac_3v3>;
 	status = "okay";
 };
-- 
2.27.0



