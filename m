Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB06F6E0427
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjDMCg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjDMCgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:36:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D17E7EE3;
        Wed, 12 Apr 2023 19:36:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3822963A61;
        Thu, 13 Apr 2023 02:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40686C433D2;
        Thu, 13 Apr 2023 02:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353374;
        bh=d0X3yg7haQvgsR2Vxh0jBkmYqiZKufzWZYdFlrBGUqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dn4Ct3Cb96EUShoHhbzYgfP/dc0zaUfUJxd2365nVQKlxvyTuvxIMqiiORy7WJ15B
         ANBjS9g0H/oyQ8y3WyiZynRum1mYlGiICNnoB1zb1tUL6lYNcuPzABvVBCSIS7xraR
         VGBSJ1giS0dt0YdrSrrZ0X6twGWx2tAkpsAew9aZBT9sJ0+SL4p89+DaQoFD/QlnmK
         A+o0FsP2o4cmQcvn4MC4Dvx9lerrktu8WF8NhrRZ87p2iKcsJmRezaSM9g1Fbmx58O
         AgsthEvaUpSODKvu8Kd9V9lFeTa/s7Hc/JfVXg+1YeTEChaTRU5bT9GrsBku2k6BfD
         2eFYGKbKZcvlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ge-org Brohammer <gbrohammer@outlook.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, mario.limonciello@amd.com,
        Syed.SabaKareem@amd.com, leohearts@leohearts.com,
        wimvanboven@gmail.com, fengwk94@gmail.com, xazrael@hotmail.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.2 05/20] ASoC: amd: yc: Add DMI entries to support Victus by HP Laptop 16-e1xxx (8A22)
Date:   Wed, 12 Apr 2023 22:35:43 -0400
Message-Id: <20230413023601.74410-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023601.74410-1-sashal@kernel.org>
References: <20230413023601.74410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

