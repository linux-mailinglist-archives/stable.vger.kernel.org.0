Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B153C3088
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhGJCfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53317 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235624AbhGJCe4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:34:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EED5613E8;
        Sat, 10 Jul 2021 02:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884312;
        bh=BFDZWyFDejNApuddo9CBi3V3azu9osoEkmjq24ItQOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PMwSqhAaZIU05uaLNw59CrXDVB281Z/S1Usd0HatvjRSHaRtKNZFLArdtdP0ftaOF
         5PujPOjyxjYL7I3AZnD+WYmHnEl0Z7/ykj0s+7A/7owNqsvooUXnggDb9FK49MG1au
         Zy1EiMVOR7mBTZgq0CjITt6+PBBIj8YLqHYtjN68PU2T0XgAB0smKJOvZ6LCmrUf5U
         sLm3FgsuCWsKmtdZmYlJJpN0zK/6us0TR8nSGZsn6mvcRJsAiHRwevin0Zrf0Cc3hz
         wPjpPAoqQYV/tBhVEqbPFkcy6iQGw7v61ePDOQDEviz9A10rhAcGPYbYoHOezDgiBA
         PV0J2lBj/+0gg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Paul Olaru <paul.olaru@oss.nxp.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 55/63] ASoC: Intel: kbl_da7219_max98357a: shrink platform_id below 20 characters
Date:   Fri,  9 Jul 2021 22:27:01 -0400
Message-Id: <20210710022709.3170675-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 94efd726b947f265bd313605c9f73edec5469d65 ]

Sparse throws the following warnings:

sound/soc/intel/boards/kbl_da7219_max98357a.c:647:25: error: too long
initializer-string for array of char(no space for nul char)

Fix by using the 'mx' acronym for Maxim.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Paul Olaru <paul.olaru@oss.nxp.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Link: https://lore.kernel.org/r/20210621194057.21711-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/kbl_da7219_max98357a.c     | 4 ++--
 sound/soc/intel/common/soc-acpi-intel-kbl-match.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/boards/kbl_da7219_max98357a.c b/sound/soc/intel/boards/kbl_da7219_max98357a.c
index 537a88932bb6..69362eae65be 100644
--- a/sound/soc/intel/boards/kbl_da7219_max98357a.c
+++ b/sound/soc/intel/boards/kbl_da7219_max98357a.c
@@ -607,7 +607,7 @@ static int kabylake_audio_probe(struct platform_device *pdev)
 
 static const struct platform_device_id kbl_board_ids[] = {
 	{
-		.name = "kbl_da7219_max98357a",
+		.name = "kbl_da7219_mx98357a",
 		.driver_data =
 			(kernel_ulong_t)&kabylake_audio_card_da7219_m98357a,
 	},
@@ -629,4 +629,4 @@ module_platform_driver(kabylake_audio)
 MODULE_DESCRIPTION("Audio Machine driver-DA7219 & MAX98357A in I2S mode");
 MODULE_AUTHOR("Naveen Manohar <naveen.m@intel.com>");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:kbl_da7219_max98357a");
+MODULE_ALIAS("platform:kbl_da7219_mx98357a");
diff --git a/sound/soc/intel/common/soc-acpi-intel-kbl-match.c b/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
index e200baa11011..df7f82e55a5a 100644
--- a/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
@@ -113,7 +113,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_kbl_machines[] = {
 	},
 	{
 		.id = "DLGS7219",
-		.drv_name = "kbl_da7219_max98373",
+		.drv_name = "kbl_da7219_mx98373",
 		.fw_filename = "intel/dsp_fw_kbl.bin",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &kbl_7219_98373_codecs,
-- 
2.30.2

