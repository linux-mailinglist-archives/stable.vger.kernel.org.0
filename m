Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4754B70BC
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239779AbiBOP1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:27:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239754AbiBOP1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:27:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A08BA2F1E;
        Tue, 15 Feb 2022 07:27:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3985D615EE;
        Tue, 15 Feb 2022 15:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920E7C340F2;
        Tue, 15 Feb 2022 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938830;
        bh=v4dDXwJubReDk2vJzh2yaDD2XZ0dk6Hd1kxbXVwlOPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxXsPb3tL1l0T84EC7ngSuh9K2dpEhsVdcHXtp2rxtdRFzPrM26H0k4CUYR1p1322
         ta/+B477wogTpxVnuDInvG3Ov+Kw1jzhzPKQDSn/3D6N+IpqUPdZ3ETy72QZbO8ZXO
         kDEGImo/a3qi+eIVs8VlP0FQmk80REbu8F3ybj4OJ6CmJI1NIf+TheYHoocag1sQaT
         aSUCRrQ/t+SNFqUKf+iQCnKo1yxz88w3Gu+FuJ11TcpXvp2TwetdxFCiK3n8Mivb0H
         3ysBQgsYBZG3WZpokm5D/khFM2PJzCZmqt2i1dJiDjuO0uQ9F4/FWCZed5zltK2cub
         BTxx+hLV6oQLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kishon@ti.com, matthias.bgg@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 05/34] phy: phy-mtk-tphy: Fix duplicated argument in phy-mtk-tphy
Date:   Tue, 15 Feb 2022 10:26:28 -0500
Message-Id: <20220215152657.580200-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152657.580200-1-sashal@kernel.org>
References: <20220215152657.580200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit 46e994717807f4b935c44d81dde9dd8bcd9a4f5d ]

Fix following coccicheck warning:
./drivers/phy/mediatek/phy-mtk-tphy.c:994:6-29: duplicated argument
to && or ||

The efuse_rx_imp is duplicate. Here should be efuse_tx_imp.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Acked-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20220107025050.787720-1-wanjiabing@vivo.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/mediatek/phy-mtk-tphy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/mediatek/phy-mtk-tphy.c b/drivers/phy/mediatek/phy-mtk-tphy.c
index 98a942c607a67..db39b0c4649a2 100644
--- a/drivers/phy/mediatek/phy-mtk-tphy.c
+++ b/drivers/phy/mediatek/phy-mtk-tphy.c
@@ -1125,7 +1125,7 @@ static int phy_efuse_get(struct mtk_tphy *tphy, struct mtk_phy_instance *instanc
 		/* no efuse, ignore it */
 		if (!instance->efuse_intr &&
 		    !instance->efuse_rx_imp &&
-		    !instance->efuse_rx_imp) {
+		    !instance->efuse_tx_imp) {
 			dev_warn(dev, "no u3 intr efuse, but dts enable it\n");
 			instance->efuse_sw_en = 0;
 			break;
-- 
2.34.1

