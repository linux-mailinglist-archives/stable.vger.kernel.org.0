Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85932E3C53
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408188AbgL1OBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:01:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391643AbgL1OBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:01:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0EC820715;
        Mon, 28 Dec 2020 14:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164038;
        bh=tuOXWwdMXvuxtKj92Djh4yTxssllE4L2bymP8gCgLh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WaGbEANHfLe4w1KxlP0kATD6+2VbO1yztyXh9lBbiSf/alk9VTKrIpgzph63NybR9
         ojaPFfJtzBs2pmE/G5zIGT8zqaiw1qRAVaTg2aOb9TDj0EQmGhZfiZt1QTLlH52Viw
         6pL571yhiMjJwLtYF+F5DBuMEPfhC0dxFrTKP8zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Parent <fparent@baylibre.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/717] arm64: dts: mediatek: mt8183: fix gce incorrect mbox-cells value
Date:   Mon, 28 Dec 2020 13:40:09 +0100
Message-Id: <20201228125021.529908718@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Parent <fparent@baylibre.com>

[ Upstream commit e55c56df43dd11de4a6c08e3ea52ca45b51c8800 ]

The binding documentation says:
- #mbox-cells: Should be 2.
	<&phandle channel priority>
	phandle: Label name of a gce node.
	channel: Channel of mailbox. Be equal to the thread id of GCE.
	priority: Priority of GCE thread.

Fix the value of #mbox-cells.

Fixes: d3c306e31bc7 ("arm64: dts: add gce node for mt8183")
Signed-off-by: Fabien Parent <fparent@baylibre.com>
Link: https://lore.kernel.org/r/20201018194225.3361182-1-fparent@baylibre.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index 9cfd961c45eb3..08a914d3a6435 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -363,7 +363,7 @@
 			compatible = "mediatek,mt8183-gce";
 			reg = <0 0x10238000 0 0x4000>;
 			interrupts = <GIC_SPI 162 IRQ_TYPE_LEVEL_LOW>;
-			#mbox-cells = <3>;
+			#mbox-cells = <2>;
 			clocks = <&infracfg CLK_INFRA_GCE>;
 			clock-names = "gce";
 		};
-- 
2.27.0



