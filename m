Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73486BD5B0
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 17:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjCPQcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 12:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjCPQcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 12:32:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C5FE4C42;
        Thu, 16 Mar 2023 09:32:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97989B82289;
        Thu, 16 Mar 2023 16:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA08C433EF;
        Thu, 16 Mar 2023 16:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678984358;
        bh=wzNYGPQ2ZO9aN05FrHAznKpf3bpWUmj89P5ta91N3+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KB7oi4iFQSkgo/sU5242h4Zm6bBKpJDeVIkBzq4KzaLZnIaShKoxRiEZ2VNz8LT6M
         IKPSIVvDPFmQ+7/68v/g46UlXg7y/wEZoclvQfcREEUzj9HTvlv4CIXqKh+BC+3WSb
         lsi4tZ5qvK8Ti+qbAunyfZSqC7oUn0plQYhdsn4M/5Ydx/3wB9hzLbGsuUSeUC1pjO
         RTK+wYI1PDBYiZPoBQLN1MgRhZ1DoVixd3eBF5mcMIT6infEtTaxU2OnoaBpraFyX7
         SMKbxl1fQJXJEuRa4q7TE5TlOBxj+oCsrYdgUZj5EpxttrnWwqp+rOQ/OV19UTUsZ2
         o9ViYGg8uKN/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Dharageswari.R" <dharageswari.r@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, yung-chuan.liao@linux.intel.com,
        kai.vehmanen@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        brent.lu@intel.com, yong.zhi@intel.com,
        ajye_huang@compal.corp-partner.google.com, akihiko.odaki@gmail.com,
        vamshi.krishna.gopal@intel.com, ye.xingchen@zte.com.cn,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.2 2/7] ASoC: Intel: sof_rt5682: Add quirk for Rex board with mx98360a amplifier
Date:   Thu, 16 Mar 2023 12:32:19 -0400
Message-Id: <20230316163227.708614-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316163227.708614-1-sashal@kernel.org>
References: <20230316163227.708614-1-sashal@kernel.org>
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

From: "Dharageswari.R" <dharageswari.r@intel.com>

[ Upstream commit 7e43b75d6a062197b3bf39ddd1b10ce2e2d2a9b0 ]

Add mtl_mx98360a_rt5682 driver data for Chrome Rex board support.

Signed-off-by: Dharageswari.R <dharageswari.r@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230220080652.23136-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_rt5682.c           | 23 +++++++++++++++++++
 .../intel/common/soc-acpi-intel-mtl-match.c   | 12 ++++++++++
 2 files changed, 35 insertions(+)

diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index 71a11d747622a..4fe448295a902 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -223,6 +223,20 @@ static const struct dmi_system_id sof_rt5682_quirk_table[] = {
 					SOF_RT5682_SSP_AMP(2) |
 					SOF_RT5682_NUM_HDMIDEV(4)),
 	},
+	{
+		.callback = sof_rt5682_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "Google_Rex"),
+			DMI_MATCH(DMI_OEM_STRING, "AUDIO-MAX98360_ALC5682I_I2S"),
+		},
+		.driver_data = (void *)(SOF_RT5682_MCLK_EN |
+					SOF_RT5682_SSP_CODEC(2) |
+					SOF_SPEAKER_AMP_PRESENT |
+					SOF_MAX98360A_SPEAKER_AMP_PRESENT |
+					SOF_RT5682_SSP_AMP(0) |
+					SOF_RT5682_NUM_HDMIDEV(4)
+					),
+	},
 	{
 		.callback = sof_rt5682_quirk_cb,
 		.matches = {
@@ -1105,6 +1119,15 @@ static const struct platform_device_id board_ids[] = {
 					SOF_RT5682_SSP_AMP(1) |
 					SOF_RT5682_NUM_HDMIDEV(4)),
 	},
+	{
+		.name = "mtl_mx98360_rt5682",
+		.driver_data = (kernel_ulong_t)(SOF_RT5682_MCLK_EN |
+					SOF_RT5682_SSP_CODEC(0) |
+					SOF_SPEAKER_AMP_PRESENT |
+					SOF_MAX98360A_SPEAKER_AMP_PRESENT |
+					SOF_RT5682_SSP_AMP(1) |
+					SOF_RT5682_NUM_HDMIDEV(4)),
+	},
 	{
 		.name = "jsl_rt5682",
 		.driver_data = (kernel_ulong_t)(SOF_RT5682_MCLK_EN |
diff --git a/sound/soc/intel/common/soc-acpi-intel-mtl-match.c b/sound/soc/intel/common/soc-acpi-intel-mtl-match.c
index b1a66a0f68181..7911c3af8071f 100644
--- a/sound/soc/intel/common/soc-acpi-intel-mtl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-mtl-match.c
@@ -15,6 +15,11 @@ static const struct snd_soc_acpi_codecs mtl_max98357a_amp = {
 	.codecs = {"MX98357A"}
 };
 
+static const struct snd_soc_acpi_codecs mtl_max98360a_amp = {
+	.num_codecs = 1,
+	.codecs = {"MX98360A"}
+};
+
 static const struct snd_soc_acpi_codecs mtl_rt5682_rt5682s_hp = {
 	.num_codecs = 2,
 	.codecs = {"10EC5682", "RTL5682"},
@@ -28,6 +33,13 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_mtl_machines[] = {
 		.quirk_data = &mtl_max98357a_amp,
 		.sof_tplg_filename = "sof-mtl-max98357a-rt5682.tplg",
 	},
+	{
+		.comp_ids = &mtl_rt5682_rt5682s_hp,
+		.drv_name = "mtl_mx98360_rt5682",
+		.machine_quirk = snd_soc_acpi_codec_list,
+		.quirk_data = &mtl_max98360a_amp,
+		.sof_tplg_filename = "sof-mtl-max98360a-rt5682.tplg",
+	},
 	{},
 };
 EXPORT_SYMBOL_GPL(snd_soc_acpi_intel_mtl_machines);
-- 
2.39.2

