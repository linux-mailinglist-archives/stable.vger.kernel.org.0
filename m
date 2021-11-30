Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71209463706
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242365AbhK3Oum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242363AbhK3Ouh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:50:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFF0C061746;
        Tue, 30 Nov 2021 06:47:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E4B69CE19D8;
        Tue, 30 Nov 2021 14:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70322C53FC1;
        Tue, 30 Nov 2021 14:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283634;
        bh=C0wFLqsmgyh5IjHqFdH8crhMJ/X3jzHE4aKYxgjLFgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNrl+mtfZmLr0o9rYXAPlgkZvstIyRAdZ7nC1NDqLsDIy30pQx/TVaN2qXDIiOtz0
         +ISUKsWqcqQ4NNIWIURqmtfnIuSYAtbVffL9YkwWvaiygM4mLG1cQPy00F5wFeTXmf
         hYei6X7JbqFvwosaS1nDuyTtWy7gbMUXhDxA5Ud3ZhsmA93fDTZu26l2vW1owTmX0R
         fuIUeexslw0/W1ekUzjSb5AzTwEAuZIMmIWdojEzzZJWQFvUr6NUDTjh5/YavlYYPr
         Bjyv2M4kjRPBZhA84izJuo8+Zh05yRfUkVpU6dj9mWRllfkfOYkI8NJdXW6ZYNIT6Z
         AzYLVj/iEwl4A==
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
        libin.yang@intel.com, yong.zhi@intel.com,
        vamshi.krishna.gopal@intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 02/68] ASoC: Intel: sof_sdw: Add support for SKU 0AF3 product
Date:   Tue, 30 Nov 2021 09:45:58 -0500
Message-Id: <20211130144707.944580-2-sashal@kernel.org>
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

[ Upstream commit 8f4fa45982b3f2daf5b3626ca0f12bde735f31ff ]

This product supports SoundWire capture from local microphones
and two SoundWire amplifiers(no headset codec).

Signed-off-by: Gongjun Song <gongjun.song@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20211105022646.26305-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index f10496206ceed..584f9f2db2076 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -248,6 +248,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_BT_OFFLOAD_SSP(2) |
 					SOF_SSP_BT_OFFLOAD_PRESENT),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0AF3"),
+		},
+		/* No Jack */
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_SDW_FOUR_SPK),
+	},
 	{}
 };
 
-- 
2.33.0

