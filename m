Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35572608759
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbiJVIAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbiJVH7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:59:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EBB1AFAA7;
        Sat, 22 Oct 2022 00:49:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BB51B82E28;
        Sat, 22 Oct 2022 07:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10A7C433C1;
        Sat, 22 Oct 2022 07:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424939;
        bh=gcxnBUSa9foL5EqXXsgqGWDnGsdIU5fZNBC3EUE3+VA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxyFfoc3MTsa007Fm7Uy6todYx/t0CCzq5RrRHnfClFTpezB7BYEF5q5jj3tPnqJr
         vrAUCueQwGuES41NBLpQsaVi+nrMMDYHrI/jJi8TSKi1O6WEaYW9U5wTGXIiWpCPKQ
         d6VBSh3CQ35WCgYpjcDOLEHUBfqd8QSFGACY+Yac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 325/717] ASoC: SOF: mediatek: mt8195: Import namespace SND_SOC_SOF_MTK_COMMON
Date:   Sat, 22 Oct 2022 09:23:24 +0200
Message-Id: <20221022072508.941708621@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 30111ab23bf5..30ab2274fbf8 100644
--- a/sound/soc/sof/mediatek/mt8195/mt8195.c
+++ b/sound/soc/sof/mediatek/mt8195/mt8195.c
@@ -634,4 +634,5 @@ static struct platform_driver snd_sof_of_mt8195_driver = {
 module_platform_driver(snd_sof_of_mt8195_driver);
 
 MODULE_IMPORT_NS(SND_SOC_SOF_XTENSA);
+MODULE_IMPORT_NS(SND_SOC_SOF_MTK_COMMON);
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.35.1



