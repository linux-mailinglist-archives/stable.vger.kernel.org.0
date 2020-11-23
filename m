Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66912C069A
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbgKWMcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:32:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731127AbgKWMcq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:32:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A643C20728;
        Mon, 23 Nov 2020 12:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134766;
        bh=kiwOr0/77xYzymp7bfP38DluIDS/GhoyOW7eHBaxpoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ewjyKhQMhjw6e3EgwOkZJrzxF0G5MqmAU8glN4AErO2R5Iu8e09AKePE6PkuEkk1n
         VZi/yRdMWRlSdCYUTq2m112C3Tg04333u5mylws0r/fPI8+zZW4jOWDPza9RU1wL28
         A2f2+sCSpNak82VhsGGdbrxiiL1q6wrTbSTc9S1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/91] arm64: dts: allwinner: h5: OrangePi PC2: Fix ethernet node
Date:   Mon, 23 Nov 2020 13:21:54 +0100
Message-Id: <20201123121810.976355991@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit b34bf9f6a623ddb82600a5ed5c644224122395e1 ]

RX and TX delay are provided by ethernet PHY. Reflect that in ethernet
node.

Fixes: 44a94c7ef989 ("arm64: dts: allwinner: H5: Restore EMAC changes")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20201023184858.3272918-1-jernej.skrabec@siol.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts
index 3e0d5a9c096d3..5fbfa76daae22 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts
@@ -157,7 +157,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	status = "okay";
 };
 
-- 
2.27.0



