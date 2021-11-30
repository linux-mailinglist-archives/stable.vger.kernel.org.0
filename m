Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EA946389D
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244815AbhK3PFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243254AbhK3O6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:58:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E63C061371;
        Tue, 30 Nov 2021 06:52:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22432B81A31;
        Tue, 30 Nov 2021 14:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C936C53FC1;
        Tue, 30 Nov 2021 14:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283919;
        bh=XnEByuIwJBtjfngOFe85Co/diFmzeN0hQrGIv4hrLQU=;
        h=From:To:Cc:Subject:Date:From;
        b=LcW4GCpFQ+e8qP+bZ5RfOxlme7Zjy2I5+QN+FOtMiteFhG9kSbDQI11XWSQ1vdcSr
         HAfVIOkgewBEDBwd/XXwGofDwlZtpLR8OJcO46fAcBxOLzxq6ZU4gFprRu+vO/epyD
         74GM/V9fwSF5RA/saL620tP/D73Gyv3bEyNJs9nhs7zUCqvULbSG4T3P5RaPXQKczP
         qvAd0JXWk+w96F3Q9gV2Ptc2Aymm9iiZB25sB9PyXN8j73jXGJ+baYM0UXDQVZc5Xz
         Mstq/Hj1xsAjr6gzMBu8VWH77DWJpWBfEsmhnmFtGLYQt/jYIipfCs+VaqWKpFhS8U
         3v3JnrSROX0mA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, matthias.bgg@gmail.com,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 01/25] ASoC: mediatek: mt8173-rt5650: Rename Speaker control to Ext Spk
Date:   Tue, 30 Nov 2021 09:51:31 -0500
Message-Id: <20211130145156.946083-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 0a8facac0d1e38dc8b86ade6d3f0d8b33dae7c58 ]

Some RT5645 and RT5650 powered platforms are using "Ext Spk"
instead of "Speaker", and this is also reflected in alsa-lib
configurations for the generic RT5645 usecase manager configs.

Rename the "Speaker" control to "Ext Spk" in order to be able
to make the userspace reuse/inherit the same configurations also
for this machine, along with the others.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20211105152013.75252-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8173/mt8173-rt5650.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8173/mt8173-rt5650.c b/sound/soc/mediatek/mt8173/mt8173-rt5650.c
index ef6f236752867..de3e3a55de4bf 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650.c
@@ -30,15 +30,15 @@ static struct mt8173_rt5650_platform_data mt8173_rt5650_priv = {
 };
 
 static const struct snd_soc_dapm_widget mt8173_rt5650_widgets[] = {
-	SND_SOC_DAPM_SPK("Speaker", NULL),
+	SND_SOC_DAPM_SPK("Ext Spk", NULL),
 	SND_SOC_DAPM_MIC("Int Mic", NULL),
 	SND_SOC_DAPM_HP("Headphone", NULL),
 	SND_SOC_DAPM_MIC("Headset Mic", NULL),
 };
 
 static const struct snd_soc_dapm_route mt8173_rt5650_routes[] = {
-	{"Speaker", NULL, "SPOL"},
-	{"Speaker", NULL, "SPOR"},
+	{"Ext Spk", NULL, "SPOL"},
+	{"Ext Spk", NULL, "SPOR"},
 	{"DMIC L1", NULL, "Int Mic"},
 	{"DMIC R1", NULL, "Int Mic"},
 	{"Headphone", NULL, "HPOL"},
@@ -48,7 +48,7 @@ static const struct snd_soc_dapm_route mt8173_rt5650_routes[] = {
 };
 
 static const struct snd_kcontrol_new mt8173_rt5650_controls[] = {
-	SOC_DAPM_PIN_SWITCH("Speaker"),
+	SOC_DAPM_PIN_SWITCH("Ext Spk"),
 	SOC_DAPM_PIN_SWITCH("Int Mic"),
 	SOC_DAPM_PIN_SWITCH("Headphone"),
 	SOC_DAPM_PIN_SWITCH("Headset Mic"),
-- 
2.33.0

