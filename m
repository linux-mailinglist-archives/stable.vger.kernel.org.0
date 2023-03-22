Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD7B6C5565
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 20:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjCVT6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 15:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjCVT5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:57:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2276A074;
        Wed, 22 Mar 2023 12:57:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D88096229C;
        Wed, 22 Mar 2023 19:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADCDC433EF;
        Wed, 22 Mar 2023 19:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515040;
        bh=Bxw8gk1frQfqGVVaV8G4o0rrL81Chi1otyRo1UbmXOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tj8BG08dmTBz/NOhk7QFynZg/adFjAaUEZbYeIgHWbpetO/SP9jxY4Upgze2a/KWT
         /KXpPH0NWV1H6FJWw3oCSN4+bYfsiNf5YeKe3dpWrTBScU5jlNThbVfMQUbfNDfWTH
         qcExYzlwwaU3Gnqn2yrY/Rl+lvNd6BzODDq2gZ51V43QEU+QKk2wjjoGhM0AnWtSMD
         f/Ho3o6ZBGyFPNW1ZBH5WqT/gv6818RNnaefHWTVlpkbgH3gOdbMLRLtiaG4WhOmui
         oG5fE6iVHmTmzYw7HcacNxN9stSKef8pjxET7SLlHli2Q2A5m3LEmI+55E1EimZVCa
         ptotyU0VQannA==
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
Subject: [PATCH AUTOSEL 6.2 05/45] ASoC: Intel: avs: rt5682: Explicitly define codec format
Date:   Wed, 22 Mar 2023 15:55:59 -0400
Message-Id: <20230322195639.1995821-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit d24dbc865c2bd5946bef62bb862a65df092dfc79 ]

rt5682 is headset codec configured in 48000/2/S24_LE format regardless
of front end format, so force it to be so.

Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20230303134854.2277146-4-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/boards/rt5682.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/soc/intel/avs/boards/rt5682.c b/sound/soc/intel/avs/boards/rt5682.c
index 473e9fe5d0bf7..b2c2ba93dcb56 100644
--- a/sound/soc/intel/avs/boards/rt5682.c
+++ b/sound/soc/intel/avs/boards/rt5682.c
@@ -169,6 +169,27 @@ static const struct snd_soc_ops avs_rt5682_ops = {
 	.hw_params = avs_rt5682_hw_params,
 };
 
+static int
+avs_rt5682_be_fixup(struct snd_soc_pcm_runtime *runtime, struct snd_pcm_hw_params *params)
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
+	/* set SSPN to 24 bit */
+	snd_mask_none(fmt);
+	snd_mask_set_format(fmt, SNDRV_PCM_FORMAT_S24_LE);
+
+	return 0;
+}
+
 static int avs_create_dai_link(struct device *dev, const char *platform_name, int ssp_port,
 			       struct snd_soc_dai_link **dai_link)
 {
@@ -201,6 +222,7 @@ static int avs_create_dai_link(struct device *dev, const char *platform_name, in
 	dl->id = 0;
 	dl->init = avs_rt5682_codec_init;
 	dl->exit = avs_rt5682_codec_exit;
+	dl->be_hw_params_fixup = avs_rt5682_be_fixup;
 	dl->ops = &avs_rt5682_ops;
 	dl->nonatomic = 1;
 	dl->no_pcm = 1;
-- 
2.39.2

