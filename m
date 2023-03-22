Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03AD56C5649
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbjCVUER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbjCVUDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:03:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF536C6AD;
        Wed, 22 Mar 2023 12:59:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69EB6622C1;
        Wed, 22 Mar 2023 19:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BAEC4339C;
        Wed, 22 Mar 2023 19:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515179;
        bh=XrrhMWQnqt1ikQWLiMWwcVO1PUIEDtnXn1ngPJpkiys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KxacfEq2BwoiH8DZXwRT8+kS61/9HWFAmv1/dmkgzx/H4wUj+hhO67umqqPqAHVe+
         tspVrc/KWyaJBKyAiOcuY8pyDHRMZ5Q2+6ft0scrIHvWc2CyGDDJlGFZu+e+WTBuXY
         j7L+P9Di53N566PvbjIuarOFA9bPw3RRzvo1oT5yWO45fszC5GZLxLbrUZAoGmr6Mi
         s1ezv/oA3s3BVfshPMnq/cBdiBjfMZwXdjtSXvDNFbQwazkPQ1JYqfI+PQg+LffGSS
         s2JiaaueYofPozsCFbTl3WSaTQKeVaDyCQ2AvZLVc4GZNxh/YqIhLUGnLl9FDD9A+z
         d5zHh/FzdKaHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        pierre-louis.bossart@linux.intel.com,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@linux.intel.com,
        yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com,
        kai.vehmanen@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 03/34] ASoC: Intel: avs: max98357a: Explicitly define codec format
Date:   Wed, 22 Mar 2023 15:58:55 -0400
Message-Id: <20230322195926.1996699-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195926.1996699-1-sashal@kernel.org>
References: <20230322195926.1996699-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit d16c893425d07ada1fdd817ec06d322efcf69480 ]

max98357a is speaker codec configured in 48000/2/S16_LE format
regardless of front end format, so force it to be so.

Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20230303134854.2277146-2-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/boards/max98357a.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/soc/intel/avs/boards/max98357a.c b/sound/soc/intel/avs/boards/max98357a.c
index 921f42caf7e09..183123d08c5a3 100644
--- a/sound/soc/intel/avs/boards/max98357a.c
+++ b/sound/soc/intel/avs/boards/max98357a.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/soc-acpi.h>
 #include <sound/soc-dapm.h>
@@ -24,6 +25,26 @@ static const struct snd_soc_dapm_route card_base_routes[] = {
 	{ "Spk", NULL, "Speaker" },
 };
 
+static int
+avs_max98357a_be_fixup(struct snd_soc_pcm_runtime *runrime, struct snd_pcm_hw_params *params)
+{
+	struct snd_interval *rate, *channels;
+	struct snd_mask *fmt;
+
+	rate = hw_param_interval(params, SNDRV_PCM_HW_PARAM_RATE);
+	channels = hw_param_interval(params, SNDRV_PCM_HW_PARAM_CHANNELS);
+	fmt = hw_param_mask(params, SNDRV_PCM_HW_PARAM_FORMAT);
+
+	/* The ADSP will convert the FE rate to 48k, stereo */
+	rate->min = rate->max = 48000;
+	channels->min = channels->max = 2;
+
+	/* set SSP0 to 16 bit */
+	snd_mask_none(fmt);
+	snd_mask_set_format(fmt, SNDRV_PCM_FORMAT_S16_LE);
+	return 0;
+}
+
 static int avs_create_dai_link(struct device *dev, const char *platform_name, int ssp_port,
 			       struct snd_soc_dai_link **dai_link)
 {
@@ -55,6 +76,7 @@ static int avs_create_dai_link(struct device *dev, const char *platform_name, in
 	dl->num_platforms = 1;
 	dl->id = 0;
 	dl->dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS;
+	dl->be_hw_params_fixup = avs_max98357a_be_fixup;
 	dl->nonatomic = 1;
 	dl->no_pcm = 1;
 	dl->dpcm_playback = 1;
-- 
2.39.2

