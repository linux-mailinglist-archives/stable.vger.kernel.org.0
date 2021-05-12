Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860C137C273
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhELPKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233310AbhELPIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:08:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9A7761480;
        Wed, 12 May 2021 15:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831709;
        bh=odQNHGGWOzWg3ByobigY1z/qy6Xiyszc18j4BnZnFMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4x+uRUdLlrdyL2qLL/JO5Ua6Gw8K8RTHTRS+VBGY/CMU6DvnYLz8JlG5TUzYiQ+B
         Q+IG6AFia5Esqv8yjsvfFwBJ37vvzOvOVvhAemLpL725DjuWssGNYHOzVv6B/orHfF
         n76oxbk6m8kaLgGD9pb6tbA7Pu7BcYDwdfBRc7Aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 227/244] arm64: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E
Date:   Wed, 12 May 2021 16:49:58 +0200
Message-Id: <20210512144750.271146714@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit dcabb06bf127b3e0d3fbc94a2b65dd56c2725851 ]

UniPhier LD20 and PXs3 boards have RTL8211E ethernet phy, and the phy have
the RX/TX delays of RGMII interface using pull-ups on the RXDLY and TXDLY
pins.

After the commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx
delay config"), the delays are working correctly, however, "rgmii" means
no delay and the phy doesn't work. So need to set the phy-mode to
"rgmii-id" to show that RX/TX delays are enabled.

Fixes: c73730ee4c9a ("arm64: dts: uniphier: add AVE ethernet node")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi | 2 +-
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi b/arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi
index b658f2b641e2..3348a32f7d0b 100644
--- a/arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi
+++ b/arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi
@@ -718,7 +718,7 @@
 			clocks = <&sys_clk 6>;
 			reset-names = "ether";
 			resets = <&sys_rst 6>;
-			phy-mode = "rgmii";
+			phy-mode = "rgmii-id";
 			local-mac-address = [00 00 00 00 00 00];
 			socionext,syscon-phy-mode = <&soc_glue 0>;
 
diff --git a/arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi b/arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi
index d6f6cee4d549..6537c69de3dd 100644
--- a/arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi
+++ b/arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi
@@ -509,7 +509,7 @@
 			clocks = <&sys_clk 6>;
 			reset-names = "ether";
 			resets = <&sys_rst 6>;
-			phy-mode = "rgmii";
+			phy-mode = "rgmii-id";
 			local-mac-address = [00 00 00 00 00 00];
 			socionext,syscon-phy-mode = <&soc_glue 0>;
 
@@ -530,7 +530,7 @@
 			clocks = <&sys_clk 7>;
 			reset-names = "ether";
 			resets = <&sys_rst 7>;
-			phy-mode = "rgmii";
+			phy-mode = "rgmii-id";
 			local-mac-address = [00 00 00 00 00 00];
 			socionext,syscon-phy-mode = <&soc_glue 1>;
 
-- 
2.30.2



