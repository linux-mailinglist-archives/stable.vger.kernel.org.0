Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AED75107F5
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353732AbiDZTF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353715AbiDZTFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0334199802;
        Tue, 26 Apr 2022 12:02:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2F4CB82249;
        Tue, 26 Apr 2022 19:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35745C385B0;
        Tue, 26 Apr 2022 19:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999732;
        bh=TM6ssMyvZvcASYsT6Apxm/GZUaH1RFTdyW2HscOYdQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mXHeulJNpeGGkbtWWrghXM9cDW3Ynr6s+TT1w1pvTJsLwunhlihTeJMT2WqcMntsu
         xsCYN9tgQUTAIpqBfARJdeSPuQ6kFLg0xkk8uaVkCcngI9TQCcK8Mc3quJl3j+x/H2
         IepitMmeyTNk9aQf7XuJG3jrMsesQPCkHfH76olV9pwiy9HwkMEYDODNo8uYZJJOxz
         eoWiK+rXf2CFSMDm6AQiYm63xaczvAwSrN0HkjgIfvFqMAdmBhWQBL6KXd0OZBi7C3
         OEQSTmu/ZeWSc4Zv7XAuVfbv2iAfJuXWgVVAm9T/CzE0T5QibIIJDMCS3WURtABr3x
         R5dPXGsW3p56A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gongjun Song <gongjun.song@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, yung-chuan.liao@linux.intel.com,
        broonie@kernel.org, brent.lu@intel.com,
        amadeuszx.slawinski@linux.intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 19/22] ALSA: hda: intel-dsp-config: Add RaptorLake PCI IDs
Date:   Tue, 26 Apr 2022 15:01:42 -0400
Message-Id: <20220426190145.2351135-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190145.2351135-1-sashal@kernel.org>
References: <20220426190145.2351135-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gongjun Song <gongjun.song@intel.com>

[ Upstream commit b07908ab26ceab51165c13714277c19252e62594 ]

Add RaptorLake-P PCI IDs

Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Gongjun Song <gongjun.song@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220421163546.319604-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 70fd8b13938e..55deb7447183 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -410,6 +410,15 @@ static const struct config_entry config_table[] = {
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = 0x54c8,
 	},
+	/* RaptorLake-P */
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = 0x51ca,
+	},
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = 0x51cb,
+	},
 #endif
 
 };
-- 
2.35.1

