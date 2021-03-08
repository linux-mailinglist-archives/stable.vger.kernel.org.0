Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64360330899
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 08:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhCHHGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 02:06:05 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:59803 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S235135AbhCHHFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 02:05:44 -0500
X-UUID: 7d22cd7318954b258a8c358406638bdb-20210308
X-UUID: 7d22cd7318954b258a8c358406638bdb-20210308
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1322121811; Mon, 08 Mar 2021 15:05:41 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 8 Mar 2021 15:05:37 +0800
Received: from mtkslt301.mediatek.inc (10.21.14.114) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 8 Mar 2021 15:05:37 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>
CC:     Rob Herring <robh+dt@kernel.org>,
        Cawa Cheng <cawa.cheng@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jie Qiu <jie.qiu@mediatek.com>, CK Hu <ck.hu@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] arm64: dts: mt8173: fix property typo of 'phys' in dsi node
Date:   Mon, 8 Mar 2021 15:05:20 +0800
Message-ID: <20210308070520.40429-1-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use 'phys' instead of 'phy'.

Fixes: 81ad4dbaf7af ("arm64: dts: mt8173: Add display subsystem related nodes")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
index 75040a820f0d..003a5653c505 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -1236,7 +1236,7 @@
 				 <&mmsys CLK_MM_DSI1_DIGITAL>,
 				 <&mipi_tx1>;
 			clock-names = "engine", "digital", "hs";
-			phy = <&mipi_tx1>;
+			phys = <&mipi_tx1>;
 			phy-names = "dphy";
 			status = "disabled";
 		};
-- 
2.18.0

