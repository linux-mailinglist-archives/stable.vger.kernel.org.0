Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE4F6C55AE
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbjCVUAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjCVT7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:59:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FFF42BFA;
        Wed, 22 Mar 2023 12:58:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2B63B81DE7;
        Wed, 22 Mar 2023 19:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D252C433EF;
        Wed, 22 Mar 2023 19:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515086;
        bh=ngCYb9YfkC/oTCBrMAIKUM8kyMQxJhxBWrHXc+Ju2WI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLHD5HZ46GUQjlTNk6YmbQuWzxoAstjKtr9+mpkUvpN1/W5zZv5Li4ndebraNHF3d
         dAJlUPiUEOW5jtMNdOyDEn7NMfhsZiZaHdVwUm37Sqai8vhgmo+D+PmeWJ3c7z1ZQy
         gLS48JoWBsAXf0Z5sTPzDoau8htQ7EOlAdtuQ/u9xpadWsYzgJV2FmOiBOwI5CdOn1
         sObd3IAxI7fLb2Jowp0fUfngX1E4ln86P4LekNHPWeqtKZ7rle98jDey8ZYQ1LKxeF
         3rEo/t/8jexpDRyDUL3DcLMK4CMyi73ON5KNaZuUvK76aJu9ZSKbtt58H+yyw7mg0Z
         0GvJ6n/P3uEWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        yung-chuan.liao@linux.intel.com, daniel.baluta@nxp.com,
        perex@perex.cz, tiwai@suse.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.2 15/45] ASoC: SOF: ipc4-topology: Fix incorrect sample rate print unit
Date:   Wed, 22 Mar 2023 15:56:09 -0400
Message-Id: <20230322195639.1995821-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>

[ Upstream commit 9e269e3aa9006440de639597079ee7140ef5b5f3 ]

This patch fixes the sample rate print unit from KHz to Hz.
E.g. 48000KHz becomes 48000Hz.

Signed-off-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307110751.2053-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 59f4d42f9011e..65da1cf790d9c 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -155,7 +155,7 @@ static void sof_ipc4_dbg_audio_format(struct device *dev,
 	for (i = 0; i < num_format; i++, ptr = (u8 *)ptr + object_size) {
 		fmt = ptr;
 		dev_dbg(dev,
-			" #%d: %uKHz, %ubit (ch_map %#x ch_cfg %u interleaving_style %u fmt_cfg %#x)\n",
+			" #%d: %uHz, %ubit (ch_map %#x ch_cfg %u interleaving_style %u fmt_cfg %#x)\n",
 			i, fmt->sampling_frequency, fmt->bit_depth, fmt->ch_map,
 			fmt->ch_cfg, fmt->interleaving_style, fmt->fmt_cfg);
 	}
-- 
2.39.2

