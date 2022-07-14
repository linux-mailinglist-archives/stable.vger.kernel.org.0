Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9248757431C
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbiGNEaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236899AbiGNE3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:29:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6482980E;
        Wed, 13 Jul 2022 21:24:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E962B8237A;
        Thu, 14 Jul 2022 04:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904C9C34114;
        Thu, 14 Jul 2022 04:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772692;
        bh=lcLO34MoPCLKVA/bKtAqWCoHH3fr4L1nHGwf+6hf4KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWr9CY/hb5a2ARvYmaW9c6irvMCiR2ELu6mWO2Qkgar8sCBzrLxR11k0CsL7Tj6Lp
         yV/iZ354OGXVWJOxvpLT8aGa6AuP1XmMVuKmh6xwmqWSEKm1Wvbr5gy+YCDVZ+C23l
         MNqayeYj3EEDrS5YLCwPzkLinpAlXjdJu5EUWAJytg2CbGjz6Vn8SWfv3avhEyDZp9
         jYeyDwFI7/aWn81kVuQsmcLgX+z10MToiqVerVvHJzNLXPV1ICB9KQYQ7dmJzMG7Nb
         2qYNL/lIDACnr3zktKzWiAaHNfJOxNBkfHh5AVmabCB26k7Jb1e5B9ywSOVFHSjw0H
         Tti18vf9xQAJA==
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
Subject: [PATCH AUTOSEL 5.15 09/28] ASoC: SOF: Intel: hda-loader: Clarify the cl_dsp_init() flow
Date:   Thu, 14 Jul 2022 00:24:10 -0400
Message-Id: <20220714042429.281816-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042429.281816-1-sashal@kernel.org>
References: <20220714042429.281816-1-sashal@kernel.org>
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
index 14469e087b00..ee09393d42cb 100644
--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -80,9 +80,9 @@ static struct hdac_ext_stream *cl_stream_prepare(struct snd_sof_dev *sdev, unsig
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
@@ -117,7 +117,7 @@ static int cl_dsp_init(struct snd_sof_dev *sdev, int stream_tag)
 			  ((stream_tag - 1) << 9)));
 
 	/* step 3: unset core 0 reset state & unstall/run core 0 */
-	ret = hda_dsp_core_run(sdev, BIT(0));
+	ret = hda_dsp_core_run(sdev, chip->init_core_mask);
 	if (ret < 0) {
 		if (hda->boot_iteration == HDA_FW_BOOT_ATTEMPTS)
 			dev_err(sdev->dev,
-- 
2.35.1

