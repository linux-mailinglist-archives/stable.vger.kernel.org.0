Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26037323D90
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236133AbhBXNN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:13:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:56136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235333AbhBXNBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:01:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5706E64F5F;
        Wed, 24 Feb 2021 12:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171195;
        bh=70Y7INUGQhr8PaoroJVk0Sxg0Wg0W4AT6d0SfdHzp90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ok9dUOa/KlOui5XpWGwEhUhHsOibxFV9QejShmqQaBfQ9qPXFxkloUmw5eDEtMiwJ
         0ndJtNm7bDBUFdBI1lZR2J99DFy2qyfEzMgRmkRv2Gf95OxgAKUwgD1qt8FgZcP1pg
         k7vVYI6blg2M+WaB96rBC+22OH7eio26zWRJF1cdxv2uzjfHlbUmDyqYNbgR/8M01G
         M1U1q/k7EdL/d+GhiEuVaVyD9qkeOfMas0ZgLrjXB7mnGJR+C+OfVmu5rJgNpMRlDv
         BztNxNqr3c1Awc0ibbGctd10lM8m7rpHyZTuKi0cROHnmHDgNEZrgGmX+0aOESYNL0
         SHXs86ndC8+MA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 47/56] ASoC: Intel: sof-sdw: indent and add quirks consistently
Date:   Wed, 24 Feb 2021 07:52:03 -0500
Message-Id: <20210224125212.482485-47-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
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
index a8d43c87cb5a2..2d2b0519eee25 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -113,9 +113,10 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
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
@@ -139,7 +140,8 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Volteer"),
 		},
-		.driver_data = (void *)(SOF_SDW_TGL_HDMI | SOF_SDW_PCH_DMIC |
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_SDW_PCH_DMIC |
 					SOF_SDW_FOUR_SPK),
 	},
 	{
@@ -148,7 +150,8 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
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

