Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EC4604176
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbiJSKot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbiJSKno (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:43:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FCB1EC75;
        Wed, 19 Oct 2022 03:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F1EFB823C5;
        Wed, 19 Oct 2022 08:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A122AC433D7;
        Wed, 19 Oct 2022 08:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169727;
        bh=T1lHPrYrwyqqpQ7QyucnPPp8EabRh658GuwlWjh8TFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y4lV0eDm5/HWtJDgKq+sC0AYJATWPH7757m+RZuDfWuM6jldErDSfoZLs5MENlt9j
         OBtPROUJV6+VD+j2Oy8vzlXVCKtejJ3/a4eJ6Jpc7n41G2lY+japcnpb0KlUQXOc3G
         CDj0jBfphAs2UWKwtkfPsqlrL+p0Ppt16cCleqtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 386/862] ASoC: SOF: mediatek: mt8195: Import namespace SND_SOC_SOF_MTK_COMMON
Date:   Wed, 19 Oct 2022 10:27:53 +0200
Message-Id: <20221019083307.011781861@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 404bec4c8f6c38ae5fa208344f1086d38026e93d ]

Here we're using function mtk_adsp_dump() from mtk-adsp-common:
explicitly import its namespace.

Fixes: 3a054f90e955 ("ASoC: SOF: mediatek: Add mt8195 debug dump")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220906092727.37324-3-angelogioacchino.delregno@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/mediatek/mt8195/mt8195.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/mediatek/mt8195/mt8195.c b/sound/soc/sof/mediatek/mt8195/mt8195.c
index 9c146015cd1b..ff575de7e46a 100644
--- a/sound/soc/sof/mediatek/mt8195/mt8195.c
+++ b/sound/soc/sof/mediatek/mt8195/mt8195.c
@@ -652,4 +652,5 @@ static struct platform_driver snd_sof_of_mt8195_driver = {
 module_platform_driver(snd_sof_of_mt8195_driver);
 
 MODULE_IMPORT_NS(SND_SOC_SOF_XTENSA);
+MODULE_IMPORT_NS(SND_SOC_SOF_MTK_COMMON);
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.35.1



