Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281DA4EC0A9
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343988AbiC3LwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344125AbiC3Lvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:51:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F549265E96;
        Wed, 30 Mar 2022 04:48:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0716A615E7;
        Wed, 30 Mar 2022 11:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E91CC340F3;
        Wed, 30 Mar 2022 11:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640885;
        bh=s0wj/LBQJuAxdPrtimr7Muy8fa/7WRNCVbi4aDUt0iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2gBcVKPD9aKNvGKz3adIqJeIvjPxCOHYeVNk6oL4x0bxefRpO4vWKzBzod2UJedj
         yDEyWekTcaDOWbatgHSGxu0Q54X29qnrelyGw8CJajS4JYdZnpM97fEgigk/H7qlxA
         TDtr7T/ZE0LRhhepXjG6R1/kKB2kvFemJEeFd8InNEFDD9IpD9Yq4OYtwd7AAZqVVG
         NgR8R9utEOyZhwfsBSr/I5d38YFyyo08XOKYkoUoMwQTOa/P1l3XnetU6BT5ZUPfAJ
         gjVXKBA3DNm/o4zjSSTNIhztRgDlPOL5az+N9FFySldwmyCfhkNlt5q+G4CLZUkNL4
         kNG0XAN4/AZCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 51/66] ASoC: SOF: debug: clarify operator precedence
Date:   Wed, 30 Mar 2022 07:46:30 -0400
Message-Id: <20220330114646.1669334-51-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 9188812539d1d9a13dac690c95ec657259859ba4 ]

cppcheck warning:

for '&' and '?'. [clarifyCalculation]
 char *level = flags & SOF_DBG_DUMP_OPTIONAL ? KERN_DEBUG : KERN_ERR;
                                             ^

sound/soc/sof/debug.c:398:46: style: Clarify calculation precedence
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220304205733.62233-10-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/debug.c b/sound/soc/sof/debug.c
index 6d6757075f7c..e755c0c5f86c 100644
--- a/sound/soc/sof/debug.c
+++ b/sound/soc/sof/debug.c
@@ -960,7 +960,7 @@ static void snd_sof_dbg_print_fw_state(struct snd_sof_dev *sdev, const char *lev
 
 void snd_sof_dsp_dbg_dump(struct snd_sof_dev *sdev, const char *msg, u32 flags)
 {
-	char *level = flags & SOF_DBG_DUMP_OPTIONAL ? KERN_DEBUG : KERN_ERR;
+	char *level = (flags & SOF_DBG_DUMP_OPTIONAL) ? KERN_DEBUG : KERN_ERR;
 	bool print_all = sof_debug_check_flag(SOF_DBG_PRINT_ALL_DUMPS);
 
 	if (flags & SOF_DBG_DUMP_OPTIONAL && !print_all)
-- 
2.34.1

