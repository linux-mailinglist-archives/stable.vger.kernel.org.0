Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE631A9D0F
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408904AbgDOLmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897500AbgDOLmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:42:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B2D820775;
        Wed, 15 Apr 2020 11:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950962;
        bh=GKSjlZDpSsH34pag1b7kvu2cZ6Kl6/zbeisGVvWw0j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fe9YshogVe9zh40cXSQr0xmAAU4S9SYyIGeLcik9a2+LppJMhLd4q9qNrKQH0OmJD
         USr7uc6ZCWsJzYDpyRO1J2H9Za1lCmzPUQIXCvkKe45CbntIscJe0PoitiqIqstswv
         +XzKiAMKcL8Xy/9vMCw43Sv70M7mvMPdACz1C+C4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jernej Skrabec <jernej.skrabec@siol.net>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 013/106] arm64: dts: allwinner: a64: Fix display clock register range
Date:   Wed, 15 Apr 2020 07:40:53 -0400
Message-Id: <20200415114226.13103-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 3e9a1a8b7f811de3eb1445d72f68766b704ad17c ]

Register range of display clocks is 0x10000, as it can be seen from
DE2 documentation.

Fix it.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Fixes: 2c796fc8f5dbd ("arm64: dts: allwinner: a64: add necessary device tree nodes for DE2 CCU")
[wens@csie.org: added fixes tag]
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 27e48234f1c23..38ecd227c34c1 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -227,7 +227,7 @@
 
 			display_clocks: clock@0 {
 				compatible = "allwinner,sun50i-a64-de2-clk";
-				reg = <0x0 0x100000>;
+				reg = <0x0 0x10000>;
 				clocks = <&ccu CLK_BUS_DE>,
 					 <&ccu CLK_DE>;
 				clock-names = "bus",
-- 
2.20.1

