Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1496E04B7
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjDMClV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjDMCkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:40:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE12083C0;
        Wed, 12 Apr 2023 19:38:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E620763A95;
        Thu, 13 Apr 2023 02:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97790C433D2;
        Thu, 13 Apr 2023 02:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353476;
        bh=V6Ny1NJ/GvtGEhkh20qJcpxqEEJMH7RqmcRl3CsCd9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aPo64SnBNJGWGRWEtx2P+/XQFMFR7C1Nr3kDfjG4oSoToK9cEsAqY4iGfy+JBKWRm
         /TP08B5JmOsyg7oyqLlneChfWmi/95gLKEQc/eGE6voqBNpeV9IAo7+VN/cXGKAqKe
         c3i+vWXYywhK2eAMSaGasnP/lAOFB6wSpd9UvB2S7KV+wRkJy7sDtbC5OVraS05Xr9
         AWRmVCNHMWJdNLt8C8faPp20dJHimJDZxDYU9fFHv6Gvu2R9J7HaX3/ldbETWO4QWF
         NOzwKsDtfewuQ4bFvU+R/2HG+LeZ1ws7g3SlQXSFn0wljO2CbBkXzEFg0Z4Wihc5H2
         BVVU3ix8bSOpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@linux.intel.com,
        yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com,
        kai.vehmanen@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        moisesmcardona@gmail.com, andriy.shevchenko@linux.intel.com,
        oder_chiou@realtek.com, akihiko.odaki@gmail.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 3/4] ASoC: Intel: bytcr_rt5640: Add quirk for the Acer Iconia One 7 B1-750
Date:   Wed, 12 Apr 2023 22:37:43 -0400
Message-Id: <20230413023746.74984-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023746.74984-1-sashal@kernel.org>
References: <20230413023746.74984-1-sashal@kernel.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit e38c5e80c3d293a883c6f1d553f2146ec0bda35e ]

The Acer Iconia One 7 B1-750 tablet mostly works fine with the defaults
for an Bay Trail CR tablet. Except for the internal mic, instead of
an analog mic on IN3 a digital mic on DMIC1 is uses.

Add a quirk with these settings for this tablet.

Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230322145332.131525-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 8a99cb6dfcd69..9a5ab96f917d3 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -393,6 +393,18 @@ static int byt_rt5640_aif1_hw_params(struct snd_pcm_substream *substream,
 
 /* Please keep this list alphabetically sorted */
 static const struct dmi_system_id byt_rt5640_quirk_table[] = {
+	{	/* Acer Iconia One 7 B1-750 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "VESPA2"),
+		},
+		.driver_data = (void *)(BYT_RT5640_DMIC1_MAP |
+					BYT_RT5640_JD_SRC_JD1_IN4P |
+					BYT_RT5640_OVCD_TH_1500UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{	/* Acer Iconia Tab 8 W1-810 */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Acer"),
-- 
2.39.2

