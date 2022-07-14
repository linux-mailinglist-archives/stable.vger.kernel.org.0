Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D0B574266
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbiGNEY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbiGNEXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:23:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EFB286F5;
        Wed, 13 Jul 2022 21:22:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 565F261E91;
        Thu, 14 Jul 2022 04:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32763C34114;
        Thu, 14 Jul 2022 04:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772573;
        bh=14XCnMkq1arqiNi6FR7twGUnaj1vfw1y++YI1I9tfEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0Z4iWOrTV20fGjM94zK7D9kCZ5Kfxg+VeOCdeQpSMhOVOpLJ3BM8P8AeSk2SATSe
         dsEqKgksUVrUQsaojZFgfExFeUTKxTAWZjXtakilYYdiCTgjFx2gEK9uHW8+CkBXhx
         yNJPz4O5Te7PyebFDenJiSLHz5gINQOuvBu8P/Rti+Dm8LGlhHxYJtzTNZ2SbVcrJ/
         90/uROe9NZkLO1bp2+SLcEeOLu/eu2UgG7VZx6AOF7Cz2/0vGQGDnlSGgumJnsJ9Tr
         9izMmRrI99ecNobES0S2lMTVczWl/3hJa+6MzSfMTmNH0lTJr+7HFvgb/AlPPGuQ0g
         I9pudgAygHHCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        daniel.baluta@nxp.com, perex@perex.cz, tiwai@suse.com,
        kai.vehmanen@linux.intel.com, yang.jie@linux.intel.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 11/41] ASoC: SOF: Intel: hda-loader: Clarify the cl_dsp_init() flow
Date:   Thu, 14 Jul 2022 00:21:51 -0400
Message-Id: <20220714042221.281187-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit bbfef046c6613404c01aeb9e9928bebb78dd327a ]

Update the comment for the cl_dsp_init() to clarify what is done by the
function and use the chip->init_core_mask instead of BIT(0) when
unstalling/running the init core.

Complements: 2a68ff846164 ("ASoC: SOF: Intel: hda: Revisit IMR boot sequence")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20220609085949.29062-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-loader.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sof/intel/hda-loader.c b/sound/soc/sof/intel/hda-loader.c
index 9f624a84182b..88d23924e1bf 100644
--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -97,9 +97,9 @@ static struct hdac_ext_stream *cl_stream_prepare(struct snd_sof_dev *sdev, unsig
 }
 
 /*
- * first boot sequence has some extra steps. core 0 waits for power
- * status on core 1, so power up core 1 also momentarily, keep it in
- * reset/stall and then turn it off
+ * first boot sequence has some extra steps.
+ * power on all host managed cores and only unstall/run the boot core to boot the
+ * DSP then turn off all non boot cores (if any) is powered on.
  */
 static int cl_dsp_init(struct snd_sof_dev *sdev, int stream_tag)
 {
@@ -127,7 +127,7 @@ static int cl_dsp_init(struct snd_sof_dev *sdev, int stream_tag)
 			  ((stream_tag - 1) << 9)));
 
 	/* step 3: unset core 0 reset state & unstall/run core 0 */
-	ret = hda_dsp_core_run(sdev, BIT(0));
+	ret = hda_dsp_core_run(sdev, chip->init_core_mask);
 	if (ret < 0) {
 		if (hda->boot_iteration == HDA_FW_BOOT_ATTEMPTS)
 			dev_err(sdev->dev,
-- 
2.35.1

