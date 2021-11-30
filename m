Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85C9463707
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242364AbhK3Oun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:50:43 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56294 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242373AbhK3Oum (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:50:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 246B5CE19D8;
        Tue, 30 Nov 2021 14:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D482C53FC7;
        Tue, 30 Nov 2021 14:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283640;
        bh=l/E9q6V3Pxx/ScE7Yq5tH1t7/MF0MrJX+kETVf0bhBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdPXr9DkaJfDHKa9oUhA7xio73rr8X8GHKPV1pgpt2712qg8+7qa9VBsykYCfbHld
         fE8Ztis6Rg8KXyakwF3Cm6DZczTaBavFutgp3q1LQlwAGjqw2yOi6bR0D7nVTqO8s1
         WMu39GckKSuYfPjBes16cAcgw4e/OE7G1EhL93ND1dDVGxZZCGq0vdrxwPJNP753cP
         lQ6UuMA5sRa4Ng8pt8Pv8owSH+1gMzyTrz0pEX2WCbSP5/9xGIU8xzMwnJu/KLKHak
         fcGjUYRGmuv7E3CvI+WT4UZSGihWY9ylu9Q6MXerXSYdxLoSq2y5VdgAAuwSdRYaog
         SMAHIg3Qj0NJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gongjun Song <gongjun.song@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, yang.jie@linux.intel.com,
        perex@perex.cz, tiwai@suse.com, kai.vehmanen@linux.intel.com,
        brent.lu@intel.com, vamshi.krishna.gopal@intel.com,
        libin.yang@intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 03/68] ASoC: Intel: soc-acpi: add SKU 0AF3 SoundWire configuration
Date:   Tue, 30 Nov 2021 09:45:59 -0500
Message-Id: <20211130144707.944580-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gongjun Song <gongjun.song@intel.com>

[ Upstream commit a1797d61cb35848432867a5bc294ce43058b5ead ]

New product audio hardware configuration is rt714 on link0,
two rt1316s on link1 and link2

Signed-off-by: Gongjun Song <gongjun.song@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20211105022646.26305-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/common/soc-acpi-intel-adl-match.c   | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/sound/soc/intel/common/soc-acpi-intel-adl-match.c b/sound/soc/intel/common/soc-acpi-intel-adl-match.c
index a0f6a69c70386..4ce7859a67d98 100644
--- a/sound/soc/intel/common/soc-acpi-intel-adl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-adl-match.c
@@ -209,6 +209,25 @@ static const struct snd_soc_acpi_link_adr adl_sdca_3_in_1[] = {
 	{}
 };
 
+static const struct snd_soc_acpi_link_adr adl_sdw_rt1316_link12_rt714_link0[] = {
+	{
+		.mask = BIT(1),
+		.num_adr = ARRAY_SIZE(rt1316_1_group1_adr),
+		.adr_d = rt1316_1_group1_adr,
+	},
+	{
+		.mask = BIT(2),
+		.num_adr = ARRAY_SIZE(rt1316_2_group1_adr),
+		.adr_d = rt1316_2_group1_adr,
+	},
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(rt714_0_adr),
+		.adr_d = rt714_0_adr,
+	},
+	{}
+};
+
 static const struct snd_soc_acpi_link_adr adl_sdw_rt1316_link2_rt714_link0[] = {
 	{
 		.mask = BIT(2),
@@ -321,6 +340,13 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_adl_sdw_machines[] = {
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-adl-rt711-l0-rt1316-l13-rt714-l2.tplg",
 	},
+	{
+		.link_mask = 0x7, /* rt714 on link0 & two rt1316s on link1 and link2 */
+		.links = adl_sdw_rt1316_link12_rt714_link0,
+		.drv_name = "sof_sdw",
+		.sof_fw_filename = "sof-adl.ri",
+		.sof_tplg_filename = "sof-adl-rt1316-l12-rt714-l0.tplg",
+	},
 	{
 		.link_mask = 0x5, /* 2 active links required */
 		.links = adl_sdw_rt1316_link2_rt714_link0,
-- 
2.33.0

