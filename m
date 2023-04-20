Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8ED6E9181
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 13:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbjDTLEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 07:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235118AbjDTLDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 07:03:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E49272C;
        Thu, 20 Apr 2023 04:02:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DED2647A6;
        Thu, 20 Apr 2023 11:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D5AC433D2;
        Thu, 20 Apr 2023 11:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681988513;
        bh=vxYpiowukmD12f1AvqoxGgUi+Xl6hpB2XU99StdEHIw=;
        h=From:To:Cc:Subject:Date:From;
        b=uNqgZ8DAQOkkf2hX93QUzs2PMzx3j9tgiCCVGsGckosOJLNf/paEzH+dK86HVSD+E
         QvE+0dMT87nlGUyYfdjcHIvUeAUUIBFW7ikGTv60rrhkIcQBV7hhshIuZ9S9OBO2xz
         4eaHQw6eMriykf5IQaJ90W9GiY84cQL080ePvtREjOSLdfFosw1K6ltobxHpO1qf2s
         H5VEfbywUldjoKi8/45nQa/bmY87/QwqiyuNUqZWFj2NEozCg9CdelUPRfFpVvQWgU
         DsDrgJQHHNzsq9jiPMCkvjrkj6hhdkQDYNaMt7MNGmY6bwS0XGFioXgkb381WB+nKP
         hCxTBYwQhSYWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eugene Huang <eugene.huang99@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, ranjani.sridharan@linux.intel.com,
        kai.vehmanen@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        gongjun.song@intel.com, shumingf@realtek.com, yong.zhi@intel.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.2 01/17] ASOC: Intel: sof_sdw: add quirk for Intel 'Rooks County' NUC M15
Date:   Thu, 20 Apr 2023 07:01:30 -0400
Message-Id: <20230420110148.505779-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
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

From: Eugene Huang <eugene.huang99@gmail.com>

[ Upstream commit 3c728b1bc5b99c5275ac5c7788ef814c0e51ef54 ]

Same quirks as the 'Bishop County' NUC M15, except the rt711 is in the
'JD2 100K' jack detection mode.

Link: https://github.com/thesofproject/linux/issues/4088
Signed-off-by: Eugene Huang <eugene.huang99@gmail.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20230314090553.498664-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index d2ed807abde95..767fa89d08708 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -213,6 +213,17 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_SDW_PCH_DMIC |
 					RT711_JD1),
 	},
+	{
+		/* NUC15 'Rooks County' LAPRC510 and LAPRC710 skews */
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel(R) Client Systems"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LAPRC"),
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_SDW_PCH_DMIC |
+					RT711_JD2_100K),
+	},
 	/* TigerLake-SDCA devices */
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.39.2

