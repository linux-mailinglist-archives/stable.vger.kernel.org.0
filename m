Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778AE690641
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjBILPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBILPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:15:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7A644AD;
        Thu,  9 Feb 2023 03:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1CB5B820F4;
        Thu,  9 Feb 2023 11:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC649C433D2;
        Thu,  9 Feb 2023 11:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941303;
        bh=KlVsMxAVvKvxUT+qHdljU0jf9knMEDwhqc7W5rc9BhA=;
        h=From:To:Cc:Subject:Date:From;
        b=NykB9+Ftot3PFH5BMcLuaTFPgyps4UR4OHZJ3ZPGMnNVxzcQLT9HfX4cH3NDWgaXc
         yhwO0Kbhba9JpLPi+SxU/doIjqcFfXI/a2UZLyo6QBmfckf9913FNdiIvaovaSRtVt
         ib2JMNnOtU7GXEJNfO9DM+R5jdzkJCIA1OVzWdYkpcJS4GBPKdlhDAhNbMvj1s0WVE
         I42H4G4AnA1pXJ+j16LCqlbLZqMaYB878xlDKfpcXOG02xLWv9VjAGILKPx4bMgWM5
         1iIGft56OgqYqVRfdRINZTe5Vs0KTHFwgiWjw53w1EnMh7w4FLFrNhhBUqwfZ2wIvt
         RY3GLaRO2ctlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Syed Saba Kareem <Syed.SabaKareem@amd.com>,
        shanshengwang <shansheng.wang@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, mario.limonciello@amd.com,
        dukzcry@ya.ru, leohearts@leohearts.com, fengwk94@gmail.com,
        xazrael@hotmail.com, lxy.lixiaoyan@gmail.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 01/38] ASoC: amd: yc: Add DMI support for new acer/emdoor platforms
Date:   Thu,  9 Feb 2023 06:14:20 -0500
Message-Id: <20230209111459.1891941-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
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

From: Syed Saba Kareem <Syed.SabaKareem@amd.com>

[ Upstream commit 7fd26a27680aa9032920f798a5a8b38a2c61075f ]

Adding DMI entries to support new acer/emdoor platforms.

Suggested-by: shanshengwang <shansheng.wang@amd.com>
Signed-off-by: Syed Saba Kareem <Syed.SabaKareem@amd.com>
Link: https://lore.kernel.org/r/20230111102130.2276391-1-Syed.SabaKareem@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 0d283e41f66dc..00fb976e0b81e 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -234,6 +234,20 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Blade 14 (2022) - RZ09-0427"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "RB"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Swift SFA16-41"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "IRBIS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "15NBC1011"),
+		}
+	},
 	{}
 };
 
-- 
2.39.0

