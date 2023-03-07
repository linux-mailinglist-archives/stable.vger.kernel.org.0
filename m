Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7886AF47A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbjCGTRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbjCGTQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9CED6E94
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:59:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99A4EB819EB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB15C4339C;
        Tue,  7 Mar 2023 18:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215271;
        bh=fhbnYceD+vfQYOv0+AEgIErqTnMphHwvDCuBi4pn6qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mE0QjEFby8np5qml8OQeFYkiK8V6NXuyAgT0oXwSoYX60WJ0VP6ewHmPqYWODlYya
         lVyB79fZoTIV2pP8rbk+aSmdqOegqM4KgG0tIACDIYLUcYJ42EDPaa+hVXy6bHiUlQ
         mab+skfYXwW/qPqGpCZZw+R+WUN5sJ7WmjKIaVts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhiyong Tao <zhiyong.tao@mediatek.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 207/567] pinctrl: mediatek: fix coding style
Date:   Tue,  7 Mar 2023 17:59:03 +0100
Message-Id: <20230307165914.882977312@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhiyong Tao <zhiyong.tao@mediatek.com>

[ Upstream commit 25a74c0f4bf1338af29a32383fb4e1a960ec5063 ]

Fix Camel spelling coding style to avoid checkpatch
warning in a following patch.

Signed-off-by: Zhiyong Tao <zhiyong.tao@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20210924080632.28410-4-zhiyong.tao@mediatek.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: a298c70a10c6 ("pinctrl: mediatek: Initialize variable pullen and pullup to zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 02e2a259edd39..fc3487fccb948 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -572,7 +572,7 @@ static int mtk_hw_get_value_wrap(struct mtk_pinctrl *hw, unsigned int gpio, int
 	mtk_hw_get_value_wrap(hw, gpio, PINCTRL_PIN_REG_DRV)
 
 ssize_t mtk_pctrl_show_one_pin(struct mtk_pinctrl *hw,
-	unsigned int gpio, char *buf, unsigned int bufLen)
+	unsigned int gpio, char *buf, unsigned int buf_len)
 {
 	int pinmux, pullup, pullen, len = 0, r1 = -1, r0 = -1;
 	const struct mtk_pin_desc *desc;
@@ -608,7 +608,7 @@ ssize_t mtk_pctrl_show_one_pin(struct mtk_pinctrl *hw,
 	} else if (pullen != MTK_DISABLE && pullen != MTK_ENABLE) {
 		pullen = 0;
 	}
-	len += scnprintf(buf + len, bufLen - len,
+	len += scnprintf(buf + len, buf_len - len,
 			"%03d: %1d%1d%1d%1d%02d%1d%1d%1d%1d",
 			gpio,
 			pinmux,
@@ -622,10 +622,10 @@ ssize_t mtk_pctrl_show_one_pin(struct mtk_pinctrl *hw,
 			pullup);
 
 	if (r1 != -1) {
-		len += scnprintf(buf + len, bufLen - len, " (%1d %1d)\n",
+		len += scnprintf(buf + len, buf_len - len, " (%1d %1d)\n",
 			r1, r0);
 	} else {
-		len += scnprintf(buf + len, bufLen - len, "\n");
+		len += scnprintf(buf + len, buf_len - len, "\n");
 	}
 
 	return len;
-- 
2.39.2



