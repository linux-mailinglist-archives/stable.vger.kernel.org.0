Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636FE4638E4
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244839AbhK3PGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243270AbhK3O4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:56:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046CAC061D74;
        Tue, 30 Nov 2021 06:50:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5197ECE1A68;
        Tue, 30 Nov 2021 14:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6950C53FD1;
        Tue, 30 Nov 2021 14:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283845;
        bh=oYA65Mz1tebzDVy9kSsFd0niXTSnr3fsrQDgHn9FQ0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtKSegVCE1+2ExnU24T/3MIG9y7NsV5o+Uo6eAQ3x3xLmT+roieFCRJbyQbxcS2/K
         ze83ECwiVlEkPMWs/JQEfj9eEI9pbd5PQ9hhI2eEcmqNX001wAwPr8v2uj9i99ElRJ
         gVxqOCuwOnP5CvJ91sVaqtMFVQdqVTyguqHXWVVpBql+loCAyXcpN/+csxDArKk4hD
         BKITcDGi9gfMnwFioibuqEoPzyx/YeMKemMcN49TZNwCT+qf2G/swaCwxGTbJ1JP9i
         BBZkr66nE4hgEBhb7zXTe/rcwjVTTvLiLXBcI6aFrL9zs21PMU/6pl5AyAptxrkcPS
         jM7BeLzmnRiew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gongjun Song <gongjun.song@intel.com>,
        Libin Yang <libin.yang@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, yang.jie@linux.intel.com,
        perex@perex.cz, tiwai@suse.com, kai.vehmanen@linux.intel.com,
        vamshi.krishna.gopal@intel.com, yong.zhi@intel.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 07/43] ASoC: Intel: sof_sdw: Add support for SKU 0B12 product
Date:   Tue, 30 Nov 2021 09:49:44 -0500
Message-Id: <20211130145022.945517-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gongjun Song <gongjun.song@intel.com>

[ Upstream commit f55af7055cd465f6b767a0c1126977d4529c63c8 ]

This product supports a SoundWire headset codec, SoundWire
capture from local microphones and two SoundWire amplifiers.

Signed-off-by: Libin Yang <libin.yang@intel.com>
Signed-off-by: Gongjun Song <gongjun.song@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20211105022646.26305-10-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index de3706125fe1a..2a128a911dbe8 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -239,6 +239,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					RT711_JD2 |
 					SOF_SDW_FOUR_SPK),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0B12")
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					RT711_JD2 |
+					SOF_SDW_FOUR_SPK),
+	},
 	{
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
-- 
2.33.0

