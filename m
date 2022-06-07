Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B060A5415F1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376374AbiFGUne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376392AbiFGU0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:26:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791911D7848;
        Tue,  7 Jun 2022 11:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91B20B81AEC;
        Tue,  7 Jun 2022 18:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0EBC385A2;
        Tue,  7 Jun 2022 18:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626749;
        bh=lU1F8CHismqBywHxeDVAeLkxHq9NN76mv0QXTjsH8PA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRKNCPvqcvahFT3sOuXlm+BIr6aPUm+/pZCygqWF2ccKfnUawvZ2HjkzGtXkkb1En
         c490++HR7T77YTKXZWdBskB1C1NgpUvLzQhiQAd7AzdbE83BlatDCkDOHxUgHsyZDi
         tIwLmn0v/Nh5vw8Oxxnr519YqB5PWDeKkTQnPW4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Parent <fparent@baylibre.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Miles Chen <miles.chen@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 490/772] pinctrl: mediatek: mt8195: enable driver on mtk platforms
Date:   Tue,  7 Jun 2022 19:01:22 +0200
Message-Id: <20220607165003.423666396@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Parent <fparent@baylibre.com>

[ Upstream commit 931d7fa89e640dea146e00b77c1d73459e66ab6e ]

Set the pinctrl driver as built-in by default if
ARM64 and ARCH_MEDIATEK are enabled.

Fixes: 6cf5e9ef362a ("pinctrl: add pinctrl driver on mt8195")
Signed-off-by: Fabien Parent <fparent@baylibre.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Miles Chen <miles.chen@mediatek.com>
Link: https://lore.kernel.org/r/20220327160813.2978637-1-fparent@baylibre.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/mediatek/Kconfig b/drivers/pinctrl/mediatek/Kconfig
index c7fa1525e42a..901c0ec0cca5 100644
--- a/drivers/pinctrl/mediatek/Kconfig
+++ b/drivers/pinctrl/mediatek/Kconfig
@@ -159,6 +159,7 @@ config PINCTRL_MT8195
 	bool "Mediatek MT8195 pin control"
 	depends on OF
 	depends on ARM64 || COMPILE_TEST
+	default ARM64 && ARCH_MEDIATEK
 	select PINCTRL_MTK_PARIS
 
 config PINCTRL_MT8365
-- 
2.35.1



