Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CF2463818
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243013AbhK3O6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:58:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49908 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243014AbhK3O4H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:56:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31B91B81A31;
        Tue, 30 Nov 2021 14:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE191C53FC1;
        Tue, 30 Nov 2021 14:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283965;
        bh=MXJM4KECyjKgUXjKamI2pB1K5WxiFoZJwPw+dgV6Dy0=;
        h=From:To:Cc:Subject:Date:From;
        b=gNsEgF4CFNnwD1uC782iH9GycRqPAOeU8K/OfkN3fz0FUaue65LqpQWKqhDboQ4Dv
         9gPfBTsK0q3eGtZ5Q09tMxqdLenEzEEwptARayOkeMkb7DigxeyCFR6Ro03NdBFLms
         uDHrWUwHNhVaQj9q4NRDZFsdF4pByQ69y0VTyV9I9+AOFXRDxAbk2rfUHJERJKOB4u
         kIxoLbhhLH/E99Buj2fAxbNnY8GYS7yhNhUzES5kxjxLR0J+tORzNCuGdeLwKiHmoV
         9FsibxOs4eXlNNXXI+a9LSnBt1QJFcdPWJriN1j+GsNBqxsqpdIRzonE0mmvFiGIme
         EPd1z1fj7Ft/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, matthias.bgg@gmail.com,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 01/17] ASoC: mediatek: mt8173-rt5650: Rename Speaker control to Ext Spk
Date:   Tue, 30 Nov 2021 09:52:25 -0500
Message-Id: <20211130145243.946407-1-sashal@kernel.org>
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
index 7a89b4aad182f..6cae0e4d33710 100644
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

