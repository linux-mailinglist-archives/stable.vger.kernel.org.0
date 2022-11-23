Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC68635D19
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbiKWMlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbiKWMlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:41:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B44663E9;
        Wed, 23 Nov 2022 04:41:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F41DA61C3D;
        Wed, 23 Nov 2022 12:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2296FC433D7;
        Wed, 23 Nov 2022 12:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207265;
        bh=epmD0tTAQXiu0uvyCUkg1ZiD6OqaWlhScVGmeJtFJn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlLnXPQYIvedyIrZYLqwMQXRjQ1OjqB1f1+eRQZ+4nxd5/UCT6q3HkHVvuO+1iViI
         lzAEGGtjd8uY0q5LlYfgLfu6PxROS2k5PFJLElDQHLa2B7BY4PHyQa25NatMMkZ+hB
         kyfnpF5EKA1/SD1DyoXgx9Zc7r3DLPNf67kSNPbVNzy4GnfpcUP/FkvfB1tlxQWFDA
         ko8/mffR4MUN/4OGbrSPJkCjW0vmHM4d7yWp6L+spK+77m+BxxihWc32lxNww8GmrA
         JfQN61fx8PQAX16c2uzU4ZKg0co4WhG4sNtUv6o5KfbIfWiAVCBCqFvICYpceRW6DO
         OWC6euncxjVGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brent Mendelsohn <mendiebm@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, Syed.SabaKareem@amd.com,
        leohearts@leohearts.com, xazrael@hotmail.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 03/44] ASoC: amd: yc: Add Alienware m17 R5 AMD into DMI table
Date:   Wed, 23 Nov 2022 07:40:12 -0500
Message-Id: <20221123124057.264822-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
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

From: Brent Mendelsohn <mendiebm@gmail.com>

[ Upstream commit d40b6529c6269cd5afddb1116a383cab9f126694 ]

This model requires an additional detection quirk to enable the
internal microphone - BIOS doesn't seem to support AcpDmicConnected
(nothing in acpidump output).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216590
Signed-off-by: Brent Mendelsohn <mendiebm@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20221024174227.4160-1-mendiebm@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 2cb50d5cf1a9..a868a890f00c 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -185,6 +185,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "UM5302TA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m17 R5 AMD"),
+		}
+	},
 	{}
 };
 
-- 
2.35.1

