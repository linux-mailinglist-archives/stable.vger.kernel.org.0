Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E5A32E989
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhCEMdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:33:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:43226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232326AbhCEMcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:32:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68A9465037;
        Fri,  5 Mar 2021 12:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947571;
        bh=zIzfEiICqLUOFy4wuynwo4ABZqY1RAf4/tgVevZVm+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYe/hxoRYG7gp7feN8e7Q9RV+iRxNLBqeZD/+6WeHp5lqWc9Iw+fiebrykvCup0h+
         X3Z4uJnjqTmqgtLpFL2cWIox048gOYU6Ol52vFSzcJtCjkVErJeKz/K5cKAZjZvrIB
         DSQNTdBQNdZNnrbpng7+0aVCPZU4MfAvj8fM6tX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/102] ASoC: Intel: sof-sdw: indent and add quirks consistently
Date:   Fri,  5 Mar 2021 13:21:34 +0100
Message-Id: <20210305120906.965585571@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 07e72ca1dfbc..d441ef324c06 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -115,9 +115,10 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
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
@@ -141,7 +142,8 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Volteer"),
 		},
-		.driver_data = (void *)(SOF_SDW_TGL_HDMI | SOF_SDW_PCH_DMIC |
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_SDW_PCH_DMIC |
 					SOF_SDW_FOUR_SPK),
 	},
 	{
@@ -150,7 +152,8 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Ripto"),
 		},
-		.driver_data = (void *)(SOF_SDW_TGL_HDMI | SOF_SDW_PCH_DMIC |
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_SDW_PCH_DMIC |
 					SOF_SDW_FOUR_SPK),
 	},
 
-- 
2.30.1



