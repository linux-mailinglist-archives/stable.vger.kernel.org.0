Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B4E2C07E5
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730966AbgKWMpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730956AbgKWMpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:45:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4805B20732;
        Mon, 23 Nov 2020 12:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135518;
        bh=jiifbgktABekOgHTteZXdhEsvNVSctBvb7XGC3R2klU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pveJzvYT+mvQcxMv6WZeUJdi1L6B4sbvzSYrt4YsokujhfySom09Ku2KpZdUKorjU
         dARg+qLN8ZeN49mjHr05/S/kxloqHk8jZwtTfaZI0USPVhQAd3kQ4UZtftxsv2rQBY
         yyopqkUH71QMeFJIZ46fnaoQWYgQS9/Qexm43g1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 079/252] arm64: dts: allwinner: h5: OrangePi PC2: Fix ethernet node
Date:   Mon, 23 Nov 2020 13:20:29 +0100
Message-Id: <20201123121839.408269452@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
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
index 7d7aad18f078b..8bf2db9dcbda0 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-pc2.dts
@@ -123,7 +123,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	status = "okay";
 };
 
-- 
2.27.0



