Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB9C61E3E0
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiKFRFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiKFREx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:04:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C0CFD16;
        Sun,  6 Nov 2022 09:04:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 059C4B8013C;
        Sun,  6 Nov 2022 17:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901A6C433C1;
        Sun,  6 Nov 2022 17:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754279;
        bh=kAigqeMZPJBt2ntHZIObOuDoIoBub1ivzXrK8HvDdIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXOtAbqw/Bc6B1xGtslwXa9sSmrmSJF2mO3aSo9oLeLGr9UNH/Wf9Y8xvQx2sP30m
         lG89sFmC5fKhlhNM4Be31R710nvTq+hMDKF5c2zGSvO4MkITcg73lPgjdwJzdOoSuj
         YPy9UTIczexSf7aifPqNbtppMZvTn1VSB3yrGgYE8VjhV3Cxbk7uDzpkOqiOpfuCh7
         fKifNUEOhrZpigBxQ9hDazVHF18Y8L1HYadTHZJvws5wVelvaFsepVY4Ii+K2tgVof
         9Jdmlrlwtpx5O6pZLHvDQkTPweh7IXQgq5M4R49Go7kXj3H4WG7BOtULsjcpwVlYP4
         kKZ9CMKydhnjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leohearts <leohearts@leohearts.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, mario.limonciello@amd.com,
        Syed.SabaKareem@amd.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 23/30] ASoC: amd: yc: Add Lenovo Thinkbook 14+ 2022 21D0 to quirks table
Date:   Sun,  6 Nov 2022 12:03:35 -0500
Message-Id: <20221106170345.1579893-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170345.1579893-1-sashal@kernel.org>
References: <20221106170345.1579893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leohearts <leohearts@leohearts.com>

[ Upstream commit a75481fa00cc06a8763e1795b93140407948c03a ]

Lenovo Thinkbook 14+ 2022 (ThinkBook 14 G4+ ARA) uses Ryzen
6000 processor, and has the same microphone problem as other
ThinkPads with AMD Ryzen 6000 series CPUs, which has been
listed in https://bugzilla.kernel.org/show_bug.cgi?id=216267.

Adding 21D0 to quirks table solves this microphone problem
for ThinkBook 14 G4+ ARA.

Signed-off-by: Taroe Leohearts <leohearts@leohearts.com>
Link: https://lore.kernel.org/r/26B141B486BEF706+313d1732-e00c-ea41-3123-0d048d40ebb6@leohearts.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 09a8aceff22f..6c0f1de10429 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -52,6 +52,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21D0"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21D0"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.35.1

