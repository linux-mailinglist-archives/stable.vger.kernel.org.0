Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 982404EC15E
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344822AbiC3L4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345136AbiC3LyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:54:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84957280EC7;
        Wed, 30 Mar 2022 04:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAE57B81C24;
        Wed, 30 Mar 2022 11:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260B9C340EE;
        Wed, 30 Mar 2022 11:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641020;
        bh=SokV46gloiKl6ccC8YUv3/mb+82/dUEF9FZvOlimcfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvPkpA4umlnDC4dPJYM6/6v5Q3ffMfQ8hE2VAE7OqbdvdS4OI2+DotLCSZ9y4s770
         2KfoyLkZ2KTe4quam//JAZvFSlXyKtfdX2IHHqVOiKKRWXCfHhC8l2Zsl66plxXNkh
         XeIzwiT5X/hSxdSi8YvruVmzro0ondy8+NjEEEtEj4pcaJdmhZCzrKLPHvuyG3Yrv0
         CzBzP4d26zxgvGcHiynNQ4P6ZlZwyaTwW2qjaI83jCVyVYaZ2cV7QUsfO5umgZMx4H
         n7xAA4L4s3R3b9IToMCNFAKvzqHUoGOqzwAhjUJypKaB/f6cPqi1CVOZzpxJvY+Gxa
         ew5yp6z1xdN8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 09/50] ASoC: SOF: Intel: hda: Remove link assignment limitation
Date:   Wed, 30 Mar 2022 07:49:23 -0400
Message-Id: <20220330115005.1671090-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115005.1671090-1-sashal@kernel.org>
References: <20220330115005.1671090-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 2ce0d008dcc59f9c01f43277b9f9743af7b01dad ]

The limitation to assign a link DMA channel for a BE iff the
corresponding host DMA channel is assigned to a connected FE is only
applicable if the PROCEN_FMT_QUIRK is set. So, remove it for platforms
that do not enable the quirk.

Complements: a792bfc1c2bc ("ASoC: SOF: Intel: hda-stream: limit PROCEN workaround")
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220128130017.28508-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dai.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index 6704dbcd101c..d15ca2564dbe 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -58,6 +58,8 @@ static struct hdac_ext_stream *
 {
 	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
 	struct sof_intel_hda_stream *hda_stream;
+	const struct sof_intel_dsp_desc *chip;
+	struct snd_sof_dev *sdev;
 	struct hdac_ext_stream *res = NULL;
 	struct hdac_stream *stream = NULL;
 
@@ -76,9 +78,20 @@ static struct hdac_ext_stream *
 			continue;
 
 		hda_stream = hstream_to_sof_hda_stream(hstream);
+		sdev = hda_stream->sdev;
+		chip = get_chip_info(sdev->pdata);
 
 		/* check if link is available */
 		if (!hstream->link_locked) {
+			/*
+			 * choose the first available link for platforms that do not have the
+			 * PROCEN_FMT_QUIRK set.
+			 */
+			if (!(chip->quirks & SOF_INTEL_PROCEN_FMT_QUIRK)) {
+				res = hstream;
+				break;
+			}
+
 			if (stream->opened) {
 				/*
 				 * check if the stream tag matches the stream
-- 
2.34.1

