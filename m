Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AA8635D2E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbiKWMl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbiKWMlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:41:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89F667136;
        Wed, 23 Nov 2022 04:41:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73221B81F38;
        Wed, 23 Nov 2022 12:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB783C433D6;
        Wed, 23 Nov 2022 12:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207272;
        bh=i62pXkbM8jq3FwMIp1Yu4olWnfxvvXuVJj5DLFQdd78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VupwQjb9xzzZudenrkEC9vy/R1QoxZGhiYunjvcJ/+Nvc1my0ByDK6aoCPigKgFoR
         +4LyD5m/XI2PH3/x2Y8FLPMZC9ZXikQ0XArLyZBWAV0+ukjRGfkjEXte9KQL2aIJzq
         q0V6n8fUmg/UbRbs7bDYPWVek+ZAtWGTkSxMe0roADBrAI7fDjEdr0eIexOfnyDeUm
         FKD80re9gNt1WHnQcbtkjkwHSjxu6HIA24mBT3PzCNYpA+AWe6qoT0OCZjkUhKDOM2
         Xyp/G4oIlWpv03JrK3GOfxbTCXP5iicmITwWrkIqxa08kMwTkbD91PbyreIGfdERl9
         TF7+MfDSBFZtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@linux.intel.com,
        ranjani.sridharan@linux.intel.com, kai.vehmanen@linux.intel.com,
        perex@perex.cz, tiwai@suse.com, rander.wang@intel.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 05/44] ASoC: Intel: soc-acpi: add ES83x6 support to IceLake
Date:   Wed, 23 Nov 2022 07:40:14 -0500
Message-Id: <20221123124057.264822-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 9a1d248bb4beaf1b43d17ba12481ee0629fa29b9 ]

Missing entry to find a machine driver for ES83x6-based platforms.

Link: https://github.com/thesofproject/linux/issues/3873
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20221031195836.250193-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-icl-match.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/soc/intel/common/soc-acpi-intel-icl-match.c b/sound/soc/intel/common/soc-acpi-intel-icl-match.c
index b032bc07de8b..d0062f2cd256 100644
--- a/sound/soc/intel/common/soc-acpi-intel-icl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-icl-match.c
@@ -10,6 +10,11 @@
 #include <sound/soc-acpi-intel-match.h>
 #include "../skylake/skl.h"
 
+static const struct snd_soc_acpi_codecs essx_83x6 = {
+	.num_codecs = 3,
+	.codecs = { "ESSX8316", "ESSX8326", "ESSX8336"},
+};
+
 static struct skl_machine_pdata icl_pdata = {
 	.use_tplg_pcm = true,
 };
@@ -27,6 +32,14 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_icl_machines[] = {
 		.drv_name = "sof_rt5682",
 		.sof_tplg_filename = "sof-icl-rt5682.tplg",
 	},
+	{
+		.comp_ids = &essx_83x6,
+		.drv_name = "sof-essx8336",
+		.sof_tplg_filename = "sof-icl-es8336", /* the tplg suffix is added at run time */
+		.tplg_quirk_mask = SND_SOC_ACPI_TPLG_INTEL_SSP_NUMBER |
+					SND_SOC_ACPI_TPLG_INTEL_SSP_MSB |
+					SND_SOC_ACPI_TPLG_INTEL_DMIC_NUMBER,
+	},
 	{},
 };
 EXPORT_SYMBOL_GPL(snd_soc_acpi_intel_icl_machines);
-- 
2.35.1

