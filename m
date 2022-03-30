Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82BF04EC26C
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344395AbiC3Lzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344734AbiC3Lxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B356226E55E;
        Wed, 30 Mar 2022 04:49:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CA6661624;
        Wed, 30 Mar 2022 11:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D64C340F3;
        Wed, 30 Mar 2022 11:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640968;
        bh=BIereeSl8OOvQHyMUSmTZlEVrUWpAJuLOWV5juCjHcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MyYCKV4tJuuvnrEfwf+StS8ubhVcry2Sh9TCHJBGx8defkQS4ceC4egRLsuFUV3pY
         EIVexgaW6naemHwGinhDy+9HcPs11pmDfiqpW/mpvoB46PwWy10KQDXqxt6m0pAc6g
         HbG6RdNjzpAFXrbyN5oGjdvQ1jUgF8NH5aERWxOIKIZyL5fGdvB7Tcc3NjPabykVYI
         LgdIkXzzj9Z8KMNyznjuc+3k8Q5uzQDjyPUO9opre90m/yud2ElMQPFp1RFFQAhwAG
         L7+ntx0Ehffi5rALNwarlZvnc9o4Cri89luVy69UIniCxgTMZJWLe2XO645bz0G3O/
         RvTlULHjHy8nQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.16 36/59] ASoC: Intel: sof_es8336: add quirk for Huawei D15 2021
Date:   Wed, 30 Mar 2022 07:48:08 -0400
Message-Id: <20220330114831.1670235-36-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
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

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit ce6a70bfce21bb4edb7c0f29ecfb0522fa34ab71 ]

Huawei D15 uses SSP_CODEC(0).

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Link: https://lore.kernel.org/r/d560a1c76edb633c37acf04a9a82518b6233a719.1640351150.git.mchehab@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_es8336.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 20d577eaab6d..e6d599f0cd26 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -247,6 +247,14 @@ static const struct dmi_system_id sof_es8336_quirk_table[] = {
 					SOF_ES8336_TGL_GPIO_QUIRK |
 					SOF_ES8336_ENABLE_DMIC)
 	},
+	{
+		.callback = sof_es8336_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HUAWEI"),
+			DMI_MATCH(DMI_BOARD_NAME, "BOHB-WAX9-PCB-B2"),
+		},
+		.driver_data = (void *)SOF_ES8336_SSP_CODEC(0)
+	},
 	{}
 };
 
-- 
2.34.1

