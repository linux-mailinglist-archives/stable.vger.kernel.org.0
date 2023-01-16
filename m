Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F0666C0A1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjAPODJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjAPOCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:02:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465DD2278D;
        Mon, 16 Jan 2023 06:02:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA95660FCA;
        Mon, 16 Jan 2023 14:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E28C433EF;
        Mon, 16 Jan 2023 14:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877746;
        bh=5tOmvaesfULeH1TrSOZPXIY3fM3dEnOedhw0AXIl7kI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QeLvOGaafFog9e3sfNve0LsCpWqyNfPjvI1HApjuk1bUnwg8fQ8JVxd/MsmfTQnkL
         e1+4KRWc73QuRxFs/zrhW0cuTFvNQgfKPlceTmUXc3edAJsF41/KkM/oprVxS68cPw
         K+hUDyImmKJS9fGe3LnrEeBPtxoMH/K4p9uXwa/S+UPKoZhOCD4INPfOQ0xnrxBvLd
         U0S/As8xDi8uT7D8IHlT6KXbEH94kFh8iX5bwtrk9/PAp9c3COAjF5CvSXQf2QrxfT
         8///tomZ5Dbtttyq/1dilQM9UoWlN3BLdFus0bOORnGAD7ozuBOYCoswUbn+8YAHAt
         bq4g3f2dVrYtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     tongjian <tongjian@huaqin.corp-partner.google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com, nfraprado@collabora.com,
        jiaxin.yu@mediatek.com, chunxu.li@mediatek.com,
        ajye_huang@compal.corp-partner.google.com,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 09/53] ASoC: mediatek: mt8186: support rt5682s_max98360
Date:   Mon, 16 Jan 2023 09:01:09 -0500
Message-Id: <20230116140154.114951-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: tongjian <tongjian@huaqin.corp-partner.google.com>

[ Upstream commit 6e1dbf694d7cd1737ee14866e9e05016ccc9ac40 ]

Add support for using the rt5682s codec together with max98360a on
MT8186-MT6366-RT1019-RT5682S machines.

Signed-off-by: tongjian <tongjian@huaqin.corp-partner.google.com>
Link: https://lore.kernel.org/r/20221228122230.3818533-2-tongjian@huaqin.corp-partner.google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mt8186/mt8186-mt6366-rt1019-rt5682s.c     | 22 ++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c b/sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c
index 60fa55d0c91f..6babadb2e6fe 100644
--- a/sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c
+++ b/sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c
@@ -991,6 +991,21 @@ static struct snd_soc_card mt8186_mt6366_rt1019_rt5682s_soc_card = {
 	.num_configs = ARRAY_SIZE(mt8186_mt6366_rt1019_rt5682s_codec_conf),
 };
 
+static struct snd_soc_card mt8186_mt6366_rt5682s_max98360_soc_card = {
+	.name = "mt8186_rt5682s_max98360",
+	.owner = THIS_MODULE,
+	.dai_link = mt8186_mt6366_rt1019_rt5682s_dai_links,
+	.num_links = ARRAY_SIZE(mt8186_mt6366_rt1019_rt5682s_dai_links),
+	.controls = mt8186_mt6366_rt1019_rt5682s_controls,
+	.num_controls = ARRAY_SIZE(mt8186_mt6366_rt1019_rt5682s_controls),
+	.dapm_widgets = mt8186_mt6366_rt1019_rt5682s_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(mt8186_mt6366_rt1019_rt5682s_widgets),
+	.dapm_routes = mt8186_mt6366_rt1019_rt5682s_routes,
+	.num_dapm_routes = ARRAY_SIZE(mt8186_mt6366_rt1019_rt5682s_routes),
+	.codec_conf = mt8186_mt6366_rt1019_rt5682s_codec_conf,
+	.num_configs = ARRAY_SIZE(mt8186_mt6366_rt1019_rt5682s_codec_conf),
+};
+
 static int mt8186_mt6366_rt1019_rt5682s_dev_probe(struct platform_device *pdev)
 {
 	struct snd_soc_card *card;
@@ -1132,9 +1147,14 @@ static int mt8186_mt6366_rt1019_rt5682s_dev_probe(struct platform_device *pdev)
 
 #if IS_ENABLED(CONFIG_OF)
 static const struct of_device_id mt8186_mt6366_rt1019_rt5682s_dt_match[] = {
-	{	.compatible = "mediatek,mt8186-mt6366-rt1019-rt5682s-sound",
+	{
+		.compatible = "mediatek,mt8186-mt6366-rt1019-rt5682s-sound",
 		.data = &mt8186_mt6366_rt1019_rt5682s_soc_card,
 	},
+	{
+		.compatible = "mediatek,mt8186-mt6366-rt5682s-max98360-sound",
+		.data = &mt8186_mt6366_rt5682s_max98360_soc_card,
+	},
 	{}
 };
 #endif
-- 
2.35.1

