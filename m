Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF61A323CF6
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbhBXNA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:00:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235410AbhBXMzj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:55:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D352964F30;
        Wed, 24 Feb 2021 12:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171104;
        bh=910D8+Yylqvm13qswY0EgiwoZgeRFlJskVXrguVGt3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sd/wQidLPaBwt0LFd4OeuUATUaWdY/m/N0+nH+h2/0FBgvgIhd2X80w6zc0LJkDhO
         O0dB5TI28tKJLLEEU/px/ZoycmdRjLeaZepmR59IOVnRAxV1IyPg7cqHD2IHY5Wj0L
         TPaxVTQVdctQ0kCrKgSHL/r80blT93gQlOuKGlNlN2Fm8QPqwf7diMhhqZ5hO0KRBh
         4giL3Gxo5d8Qy7gJw+FJvd+67Q1GjdYaUOSS09Zcj4KieF0UrXaDg7h4sA09j03tPc
         m6PdCV5/1Se8JXsyhbnX7eeuKGQzxyWjl2zKCpqwq3WlumXcLtFIAq4ko826xqLLaV
         O7GyPs+crdzhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.11 58/67] ASoC: Intel: sof-sdw: indent and add quirks consistently
Date:   Wed, 24 Feb 2021 07:50:16 -0500
Message-Id: <20210224125026.481804-58-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 8caf37e2be761688c396c609880936a807af490f ]

Use the same style for all quirks to avoid misses and errors

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210208233336.59449-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 6d0d6ef711e0f..6e4b2fdb0dcf6 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -123,9 +123,10 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME,
 				  "Tiger Lake Client Platform"),
 		},
-		.driver_data = (void *)(SOF_RT711_JD_SRC_JD1 |
-				SOF_SDW_TGL_HDMI | SOF_SDW_PCH_DMIC |
-				SOF_SSP_PORT(SOF_I2S_SSP2)),
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_RT711_JD_SRC_JD1 |
+					SOF_SDW_PCH_DMIC |
+					SOF_SSP_PORT(SOF_I2S_SSP2)),
 	},
 	{
 		.callback = sof_sdw_quirk_cb,
@@ -149,7 +150,8 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Volteer"),
 		},
-		.driver_data = (void *)(SOF_SDW_TGL_HDMI | SOF_SDW_PCH_DMIC |
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_SDW_PCH_DMIC |
 					SOF_SDW_FOUR_SPK),
 	},
 	{
@@ -158,7 +160,8 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Ripto"),
 		},
-		.driver_data = (void *)(SOF_SDW_TGL_HDMI | SOF_SDW_PCH_DMIC |
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_SDW_PCH_DMIC |
 					SOF_SDW_FOUR_SPK),
 	},
 
-- 
2.27.0

