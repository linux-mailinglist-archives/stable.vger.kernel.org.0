Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC3466C08F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjAPOCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbjAPOCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:02:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F7421972;
        Mon, 16 Jan 2023 06:02:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F44C60FD9;
        Mon, 16 Jan 2023 14:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DACC433F0;
        Mon, 16 Jan 2023 14:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877727;
        bh=kiHwUifiCG//om76OU+JIAh3guueRo7nVV+ZCGhevnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gejzWAvwPM5eKc+yZUwsS2KjxcA48UJezyJl6CIFNiZoZXZUceADXZUHwFvv0aFEQ
         lsfDyjCOY1hsDaiy9akkhPjIiSMJtTuBqIJ0wV+zWVfMvghUlBUavh2k0Otz+VO7nU
         f5rNOWGJv8X1ZyUFNqWlYmPtaA3EYg9tJjmcJCnmhbdnCKHQQMInP18jBLnIcQT45f
         caLlFW+r61WWpwh6P1+pmlXXPPzh2Zgl9Aijr3970np27NMRgCu6zTkfRN6qQa1IO8
         A7cAdcAqPThIj3hQ+VSl1C+aEaePXS7VLzZqPqixF8jSzTHyliYEiDxeb1ZVD2D20j
         CeBjro40pgSQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wim Van Boven <wimvanboven@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, Syed.SabaKareem@amd.com,
        lxy.lixiaoyan@gmail.com, aniol@aniolmarti.cat, mendiebm@gmail.com,
        dukzcry@ya.ru, xazrael@hotmail.com, leohearts@leohearts.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 05/53] ASoC: amd: yc: Add Razer Blade 14 2022 into DMI table
Date:   Mon, 16 Jan 2023 09:01:05 -0500
Message-Id: <20230116140154.114951-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
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

From: Wim Van Boven <wimvanboven@gmail.com>

[ Upstream commit 68506a173dd700c2bd794dcc3489edcdb8ee35c6 ]

Razer Blade 14 (2022) - RZ09-0427 needs the quirk to enable the built in microphone

Signed-off-by: Wim Van Boven <wimvanboven@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20221216081828.12382-1-wimvanboven@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1f0b5527c594..469c5e79e0ea 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -220,6 +220,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Redmi Book Pro 14 2022"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Razer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Blade 14 (2022) - RZ09-0427"),
+		}
+	},
 	{}
 };
 
-- 
2.35.1

