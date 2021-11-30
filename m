Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66669463710
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242421AbhK3Ouv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242403AbhK3Out (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:50:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77BEC061748;
        Tue, 30 Nov 2021 06:47:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90E0DB81A20;
        Tue, 30 Nov 2021 14:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F11C53FCD;
        Tue, 30 Nov 2021 14:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283647;
        bh=4W5llaRX90jb34UHqiO6+pxJ+Y4yt0yNWYl2BYlawFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQH+z43eEL9QxI1Fq4fvHjfge6Y6E/hRoWTKl5MHXtFZ2O6xBVj05PGaHvlKUWezE
         yKa+Jeuk+IIRHqwXwa+24jEgf/BsslpptUxIHtoFSvfy4a5xVmI4Mwg0CHTOWGbimN
         bON33cNQDfxgUIhVSjIDSlqZHaRQsDH4uR06rVHfa3QNP6jhVE5Bds6M+PiQFy7+ji
         Nt+3WtEyeF9/Ry997P5rkEnYk15PJaqCFNCWLtMyUQma9ewgGsqnrASQbNY2D9sY7v
         gmY7tDv6H1vGpGol09epBZ2anZ87fGYTQ45NVFJh6EnSYCo4xMTn4BujMNq2L1PjKy
         08/DdMbyLzAVw==
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
        vamshi.krishna.gopal@intel.com, libin.yang@intel.com,
        yong.zhi@intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 05/68] ASoC: Intel: sof_sdw: Add support for SKU 0B11 product
Date:   Tue, 30 Nov 2021 09:46:01 -0500
Message-Id: <20211130144707.944580-5-sashal@kernel.org>
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

[ Upstream commit 6fef4c2f458680399b7c512cb810c1e1784d7444 ]

This product supports a SoundWire headset codec, SoundWire
capture from local microphones and two SoundWire amplifiers.

Signed-off-by: Gongjun Song <gongjun.song@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20211105022646.26305-5-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 55c3e5935585c..d0bea028b9b76 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -278,6 +278,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					RT711_JD2 |
 					SOF_SDW_FOUR_SPK),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0B11")
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					RT711_JD2 |
+					SOF_SDW_FOUR_SPK),
+	},
 	{}
 };
 
-- 
2.33.0

