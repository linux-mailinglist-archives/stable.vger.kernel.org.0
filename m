Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3074B72E8
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240121AbiBOPa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:30:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240094AbiBOPaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:30:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A138B0C7A;
        Tue, 15 Feb 2022 07:28:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 040DAB81AFE;
        Tue, 15 Feb 2022 15:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE9CC340F6;
        Tue, 15 Feb 2022 15:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938922;
        bh=v4dDXwJubReDk2vJzh2yaDD2XZ0dk6Hd1kxbXVwlOPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZG1H3ZyXTgpP9s/9WIWVdfP60+uSYLNX0Q/WtzhF9rDTTfyFr2vvHkPUqNa8q+yXN
         QOld+HnCqd/5tuTbtXEuIGl+NbBSVGDHrVWiogWRjVHyBKRHshBGGZaauVSBfxD3vB
         6oLAH+MffDjOt4Y5GnKkZkLai/bieT2dCHvkY2/tJU8vDgbiDPQky1/wmUimuYuQpq
         F1hO2wwvQYScRJUgk5ManvQBfgQdB1E59BxImGgZA06sTSjrrs6/RLHbWdSTyIaw6t
         KG6h3JX4kUb2SC5G43R/YivAbCQYbZRdj7KeOkN2D8eauqyKJUXMoGWZ9xkq6ebsO7
         ISz9dsdEhiVjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kishon@ti.com, matthias.bgg@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 05/33] phy: phy-mtk-tphy: Fix duplicated argument in phy-mtk-tphy
Date:   Tue, 15 Feb 2022 10:28:03 -0500
Message-Id: <20220215152831.580780-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152831.580780-1-sashal@kernel.org>
References: <20220215152831.580780-1-sashal@kernel.org>
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

