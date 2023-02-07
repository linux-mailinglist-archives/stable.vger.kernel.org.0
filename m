Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6980F68D870
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjBGNJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbjBGNJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:09:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274107AA0
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:09:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 069BD611AA
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067DCC433D2;
        Tue,  7 Feb 2023 13:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775349;
        bh=5a+ulbbA7NMy18E4IWkE3teezZPoPNZddaHS1T9/6n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cgdm3L829JlQQlOU4o9afL6Yr4kIVN+5q9uLY4gtEQEITTYhGQQd/hx7G/SPLMAyu
         fG2fL6FEZT60kms/+hKdL1Q0ETQoksyeVZHTCcLMAxEResHyh7wzsGAxB4pfEcTjdn
         8z5V2Tkmbc4+qMDj/AmrYUCPv5FO2sDyodVphGts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        FRED OH <fred.oh@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/120] ASoC: Intel: boards: fix spelling in comments
Date:   Tue,  7 Feb 2023 13:56:14 +0100
Message-Id: <20230207125618.882177074@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit f1eebb3bf707b267bd8ed945d00a81c8ca31bd73 ]

copy/paste spelling issues with platforms and buttons.

Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: FRED OH <fred.oh@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220301194903.60859-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 6b1c0bd6fdef ("ASoC: Intel: bytcht_es8316: Drop reference count of ACPI device after use")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bdw-rt5650.c           | 2 +-
 sound/soc/intel/boards/bdw-rt5677.c           | 2 +-
 sound/soc/intel/boards/broadwell.c            | 2 +-
 sound/soc/intel/boards/bxt_da7219_max98357a.c | 2 +-
 sound/soc/intel/boards/bxt_rt298.c            | 2 +-
 sound/soc/intel/boards/bytcht_cx2072x.c       | 2 +-
 sound/soc/intel/boards/bytcht_da7213.c        | 2 +-
 sound/soc/intel/boards/bytcht_es8316.c        | 2 +-
 sound/soc/intel/boards/bytcr_rt5640.c         | 2 +-
 sound/soc/intel/boards/bytcr_rt5651.c         | 2 +-
 sound/soc/intel/boards/cht_bsw_max98090_ti.c  | 4 ++--
 sound/soc/intel/boards/cht_bsw_nau8824.c      | 4 ++--
 sound/soc/intel/boards/cht_bsw_rt5645.c       | 2 +-
 sound/soc/intel/boards/cht_bsw_rt5672.c       | 2 +-
 sound/soc/intel/boards/glk_rt5682_max98357a.c | 2 +-
 sound/soc/intel/boards/haswell.c              | 2 +-
 16 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/sound/soc/intel/boards/bdw-rt5650.c b/sound/soc/intel/boards/bdw-rt5650.c
index c5122d3b0e6c..7c8c2557d685 100644
--- a/sound/soc/intel/boards/bdw-rt5650.c
+++ b/sound/soc/intel/boards/bdw-rt5650.c
@@ -299,7 +299,7 @@ static int bdw_rt5650_probe(struct platform_device *pdev)
 	if (!bdw_rt5650)
 		return -ENOMEM;
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	mach = pdev->dev.platform_data;
 	ret = snd_soc_fixup_dai_links_platform_name(&bdw_rt5650_card,
 						    mach->mach_params.platform);
diff --git a/sound/soc/intel/boards/bdw-rt5677.c b/sound/soc/intel/boards/bdw-rt5677.c
index e01b7a90ca6c..e99094017909 100644
--- a/sound/soc/intel/boards/bdw-rt5677.c
+++ b/sound/soc/intel/boards/bdw-rt5677.c
@@ -426,7 +426,7 @@ static int bdw_rt5677_probe(struct platform_device *pdev)
 	if (!bdw_rt5677)
 		return -ENOMEM;
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	mach = pdev->dev.platform_data;
 	ret = snd_soc_fixup_dai_links_platform_name(&bdw_rt5677_card,
 						    mach->mach_params.platform);
diff --git a/sound/soc/intel/boards/broadwell.c b/sound/soc/intel/boards/broadwell.c
index 3c3aff9c61cc..f18dcda23e74 100644
--- a/sound/soc/intel/boards/broadwell.c
+++ b/sound/soc/intel/boards/broadwell.c
@@ -292,7 +292,7 @@ static int broadwell_audio_probe(struct platform_device *pdev)
 
 	broadwell_rt286.dev = &pdev->dev;
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	mach = pdev->dev.platform_data;
 	ret = snd_soc_fixup_dai_links_platform_name(&broadwell_rt286,
 						    mach->mach_params.platform);
diff --git a/sound/soc/intel/boards/bxt_da7219_max98357a.c b/sound/soc/intel/boards/bxt_da7219_max98357a.c
index e67ddfb8e469..e49c64f54a12 100644
--- a/sound/soc/intel/boards/bxt_da7219_max98357a.c
+++ b/sound/soc/intel/boards/bxt_da7219_max98357a.c
@@ -825,7 +825,7 @@ static int broxton_audio_probe(struct platform_device *pdev)
 		}
 	}
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	mach = pdev->dev.platform_data;
 	platform_name = mach->mach_params.platform;
 
diff --git a/sound/soc/intel/boards/bxt_rt298.c b/sound/soc/intel/boards/bxt_rt298.c
index 47f6b1523ae6..0d1df37ecea0 100644
--- a/sound/soc/intel/boards/bxt_rt298.c
+++ b/sound/soc/intel/boards/bxt_rt298.c
@@ -628,7 +628,7 @@ static int broxton_audio_probe(struct platform_device *pdev)
 	card->dev = &pdev->dev;
 	snd_soc_card_set_drvdata(card, ctx);
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	mach = pdev->dev.platform_data;
 	platform_name = mach->mach_params.platform;
 
diff --git a/sound/soc/intel/boards/bytcht_cx2072x.c b/sound/soc/intel/boards/bytcht_cx2072x.c
index a9e51bbf018c..0fc57db6e92c 100644
--- a/sound/soc/intel/boards/bytcht_cx2072x.c
+++ b/sound/soc/intel/boards/bytcht_cx2072x.c
@@ -257,7 +257,7 @@ static int snd_byt_cht_cx2072x_probe(struct platform_device *pdev)
 		byt_cht_cx2072x_dais[dai_index].codecs->name = codec_name;
 	}
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	ret = snd_soc_fixup_dai_links_platform_name(&byt_cht_cx2072x_card,
 						    mach->mach_params.platform);
 	if (ret)
diff --git a/sound/soc/intel/boards/bytcht_da7213.c b/sound/soc/intel/boards/bytcht_da7213.c
index a28773fb7892..21b6bebc9a26 100644
--- a/sound/soc/intel/boards/bytcht_da7213.c
+++ b/sound/soc/intel/boards/bytcht_da7213.c
@@ -260,7 +260,7 @@ static int bytcht_da7213_probe(struct platform_device *pdev)
 		dailink[dai_index].codecs->name = codec_name;
 	}
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	platform_name = mach->mach_params.platform;
 
 	ret_val = snd_soc_fixup_dai_links_platform_name(card, platform_name);
diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
index 950457bcc28f..78b7e24b0c79 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -504,7 +504,7 @@ static int snd_byt_cht_es8316_mc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	byt_cht_es8316_card.dev = dev;
 	platform_name = mach->mach_params.platform;
 
diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 888e04c57757..7795632cb38f 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -1733,7 +1733,7 @@ static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 	byt_rt5640_card.long_name = byt_rt5640_long_name;
 #endif
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	platform_name = mach->mach_params.platform;
 
 	ret_val = snd_soc_fixup_dai_links_platform_name(&byt_rt5640_card,
diff --git a/sound/soc/intel/boards/bytcr_rt5651.c b/sound/soc/intel/boards/bytcr_rt5651.c
index e94c9124d4f4..31219874c2ae 100644
--- a/sound/soc/intel/boards/bytcr_rt5651.c
+++ b/sound/soc/intel/boards/bytcr_rt5651.c
@@ -1104,7 +1104,7 @@ static int snd_byt_rt5651_mc_probe(struct platform_device *pdev)
 	byt_rt5651_card.long_name = byt_rt5651_long_name;
 #endif
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	platform_name = mach->mach_params.platform;
 
 	ret_val = snd_soc_fixup_dai_links_platform_name(&byt_rt5651_card,
diff --git a/sound/soc/intel/boards/cht_bsw_max98090_ti.c b/sound/soc/intel/boards/cht_bsw_max98090_ti.c
index 131882378a59..ba6de1e389cd 100644
--- a/sound/soc/intel/boards/cht_bsw_max98090_ti.c
+++ b/sound/soc/intel/boards/cht_bsw_max98090_ti.c
@@ -296,7 +296,7 @@ static int cht_max98090_headset_init(struct snd_soc_component *component)
 	int ret;
 
 	/*
-	 * TI supports 4 butons headset detection
+	 * TI supports 4 buttons headset detection
 	 * KEY_MEDIA
 	 * KEY_VOICECOMMAND
 	 * KEY_VOLUMEUP
@@ -558,7 +558,7 @@ static int snd_cht_mc_probe(struct platform_device *pdev)
 			dev_dbg(dev, "Unable to add GPIO mapping table\n");
 	}
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	snd_soc_card_cht.dev = &pdev->dev;
 	mach = pdev->dev.platform_data;
 	platform_name = mach->mach_params.platform;
diff --git a/sound/soc/intel/boards/cht_bsw_nau8824.c b/sound/soc/intel/boards/cht_bsw_nau8824.c
index da5a5cbc8759..779b388db85d 100644
--- a/sound/soc/intel/boards/cht_bsw_nau8824.c
+++ b/sound/soc/intel/boards/cht_bsw_nau8824.c
@@ -100,7 +100,7 @@ static int cht_codec_init(struct snd_soc_pcm_runtime *runtime)
 	struct snd_soc_component *component = codec_dai->component;
 	int ret, jack_type;
 
-	/* NAU88L24 supports 4 butons headset detection
+	/* NAU88L24 supports 4 buttons headset detection
 	 * KEY_PLAYPAUSE
 	 * KEY_VOICECOMMAND
 	 * KEY_VOLUMEUP
@@ -257,7 +257,7 @@ static int snd_cht_mc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	snd_soc_card_set_drvdata(&snd_soc_card_cht, drv);
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	snd_soc_card_cht.dev = &pdev->dev;
 	mach = pdev->dev.platform_data;
 	platform_name = mach->mach_params.platform;
diff --git a/sound/soc/intel/boards/cht_bsw_rt5645.c b/sound/soc/intel/boards/cht_bsw_rt5645.c
index 804dbc7911d5..381bf6054047 100644
--- a/sound/soc/intel/boards/cht_bsw_rt5645.c
+++ b/sound/soc/intel/boards/cht_bsw_rt5645.c
@@ -653,7 +653,7 @@ static int snd_cht_mc_probe(struct platform_device *pdev)
 	    (cht_rt5645_quirk & CHT_RT5645_SSP0_AIF2))
 		cht_dailink[dai_index].cpus->dai_name = "ssp0-port";
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	platform_name = mach->mach_params.platform;
 
 	ret_val = snd_soc_fixup_dai_links_platform_name(card,
diff --git a/sound/soc/intel/boards/cht_bsw_rt5672.c b/sound/soc/intel/boards/cht_bsw_rt5672.c
index 9509b6e161b8..ba96741c7771 100644
--- a/sound/soc/intel/boards/cht_bsw_rt5672.c
+++ b/sound/soc/intel/boards/cht_bsw_rt5672.c
@@ -483,7 +483,7 @@ static int snd_cht_mc_probe(struct platform_device *pdev)
 		drv->use_ssp0 = true;
 	}
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	snd_soc_card_cht.dev = &pdev->dev;
 	platform_name = mach->mach_params.platform;
 
diff --git a/sound/soc/intel/boards/glk_rt5682_max98357a.c b/sound/soc/intel/boards/glk_rt5682_max98357a.c
index 71fe26a1b701..99b3d7642cb7 100644
--- a/sound/soc/intel/boards/glk_rt5682_max98357a.c
+++ b/sound/soc/intel/boards/glk_rt5682_max98357a.c
@@ -604,7 +604,7 @@ static int geminilake_audio_probe(struct platform_device *pdev)
 	card->dev = &pdev->dev;
 	snd_soc_card_set_drvdata(card, ctx);
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	mach = pdev->dev.platform_data;
 	platform_name = mach->mach_params.platform;
 
diff --git a/sound/soc/intel/boards/haswell.c b/sound/soc/intel/boards/haswell.c
index c763bfeb1f38..b5ca3177be6a 100644
--- a/sound/soc/intel/boards/haswell.c
+++ b/sound/soc/intel/boards/haswell.c
@@ -175,7 +175,7 @@ static int haswell_audio_probe(struct platform_device *pdev)
 
 	haswell_rt5640.dev = &pdev->dev;
 
-	/* override plaform name, if required */
+	/* override platform name, if required */
 	mach = pdev->dev.platform_data;
 	ret = snd_soc_fixup_dai_links_platform_name(&haswell_rt5640,
 						    mach->mach_params.platform);
-- 
2.39.0



