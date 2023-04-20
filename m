Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7242A6E9194
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 13:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbjDTLEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 07:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbjDTLEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 07:04:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5995C8A71;
        Thu, 20 Apr 2023 04:03:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26BF7647BF;
        Thu, 20 Apr 2023 11:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB23EC4339E;
        Thu, 20 Apr 2023 11:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681988523;
        bh=d0X3yg7haQvgsR2Vxh0jBkmYqiZKufzWZYdFlrBGUqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ezVcqUeSR9dSgjLSw0n3Eyt5elJqr6yOtX3KDYBdWsoxx6c7UgQxRdoH0uNeQuNkA
         JRHzvXIUC7tzi6UqVlqsK5nZ7QkIQ/ZFy++V/reMU498Bf0NZyPnd2ChmboL6X0cF0
         N1Rh92yHxRsrSMigJwrBb7rsq0RpNJI2kE3YGqv+oKrp8Cog06VJKlys3garPYtpJr
         wtF5avOnOYI+VhlGckmNwgCHfCv35pHQVHz9gcnRs/IyKmEfWqH0Yjrrv59d1FLcBG
         tOwSGzRQvI3jBseeY2n39Iz0xnTVHkcj3W9z0ErK/0LyqVkeUI8lTw+oQc7ezq6hUV
         vzhlz+OzBtcnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ge-org Brohammer <gbrohammer@outlook.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, mario.limonciello@amd.com,
        Syed.SabaKareem@amd.com, lxy.lixiaoyan@gmail.com,
        fengwk94@gmail.com, leohearts@leohearts.com, mendiebm@gmail.com,
        aniol@aniolmarti.cat, wimvanboven@gmail.com, xazrael@hotmail.com,
        dukzcry@ya.ru, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.2 05/17] ASoC: amd: yc: Add DMI entries to support Victus by HP Laptop 16-e1xxx (8A22)
Date:   Thu, 20 Apr 2023 07:01:34 -0400
Message-Id: <20230420110148.505779-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420110148.505779-1-sashal@kernel.org>
References: <20230420110148.505779-1-sashal@kernel.org>
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

From: Ge-org Brohammer <gbrohammer@outlook.com>

[ Upstream commit 205efd4619b860404ebb5882e5a119eb3b3b3716 ]

This model requires an additional detection quirk to
enable the internal microphone.

Tried to use git send-email this time.

Signed-off-by: Ge-org Brohammer <gbrohammer@outlook.com>
Link: https://lore.kernel.org/r/PAVP195MB2261322C220E95D7F4B2732ADABC9@PAVP195MB2261.EURP195.PROD.OUTLOOK.COM
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 4a69ce702360c..0acdf0156f075 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -269,6 +269,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8A43"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8A22"),
+		}
+	},
 	{}
 };
 
-- 
2.39.2

