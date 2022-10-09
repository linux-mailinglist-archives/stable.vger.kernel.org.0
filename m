Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB70F5F9515
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbiJJAPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiJJANt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:13:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029B2DF6;
        Sun,  9 Oct 2022 16:51:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9338C60D17;
        Sun,  9 Oct 2022 23:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDB6C433D7;
        Sun,  9 Oct 2022 23:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359500;
        bh=92eQYMkXiqh2tRjqU7wqolS9xclS+SWR5TXgeWI09vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJ1AMXF/y0JWoaYoP9Hdeg3d55EY4WusQ8HqxrjOJ35Xp5K1NtR5vChwGUO5Adje3
         tQ+7Dgtx/CgR6u0deenFPSr1StpWObu0y2A5Hlh8AAeT/Dsl4K7kSvAfeXno5vjtn2
         PfDk3WQCHDzKDruokur0HIYBKgj5ZL2WVltBFwbqfa9SAbWJqWcAmZgXs1CcHUC2ez
         qpAEF1YJ1ccy/2SX+IVfLxwrRhBzt07r368EuEf64zqzh2PnscMt+2a/GfHGWqv8WX
         LzYQwpv9xlFGRYSX+Aog3kJc8dOqjsFGwoEGLxkiksIGYOfZJN/NgYcu4OLlNFts3j
         PtNVR4XCm07Qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Sebastian S <iam@decentr.al>,
        Travis Glenn Hansen <travisghansen@yahoo.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, Syed.SabaKareem@amd.com,
        lxy.lixiaoyan@gmail.com, Vijendar.Mukunda@amd.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 34/44] ASoC: amd: yc: Add Lenovo Yoga Slim 7 Pro X to quirks table
Date:   Sun,  9 Oct 2022 19:49:22 -0400
Message-Id: <20221009234932.1230196-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009234932.1230196-1-sashal@kernel.org>
References: <20221009234932.1230196-1-sashal@kernel.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 2232b2dd8cd4f1e6d554b2c3f6899ce36f791b67 ]

Lenovo Yoga Slim 7 Pro X has an ACP DMIC that isn't specified in the
ASL or existing quirk list.  Add it to the quirk table to let DMIC
work on these systems.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216299
Tested-by: Sebastian S <iam@decentr.al>
Reported-and-tested-by: Travis Glenn Hansen <travisghansen@yahoo.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20220920201436.19734-3-mario.limonciello@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 5eab3baf3573..2cb50d5cf1a9 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -171,6 +171,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21J6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.35.1

