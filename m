Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A698A5F9514
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiJJAPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbiJJANt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:13:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A403884;
        Sun,  9 Oct 2022 16:51:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35F3360CF5;
        Sun,  9 Oct 2022 23:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F71C433D6;
        Sun,  9 Oct 2022 23:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359494;
        bh=VIlYJ2ErGI6e9UFBzveHWStQsrDkc3EGp6+mnyrVdyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBekQ7XPdgHfM2gFJj1K0RGi02SHa4vpeLz8PVriJSo8v88kKexXjMxU/8o+rbcjd
         mOzutTd6W/+1QW6kBsDMiJBwINJQncDysKVerPrLIL3Bf3rbYhm7uGaf59vpqfFi0f
         i91Wy/LBhEvzSdzpQD+mhrlbAX6FQKW36luVKMSoLPNrc7NwLNM5aQerI02oLNhz7A
         Qqs6IQED4/KJzbtyWI1a/N7w1mbt1lt8EV1/SFd2/D+AoBVZs+APs+7O38bLwfIAlt
         oPaHFiN3PamAkfVwsjWd4EJ4brcoEd9c/hfh0p3dyGRbs27eh3lYoy3y6d67iqYej2
         OytrkJ299Fczw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoyan Li <lxy.lixiaoyan@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, Syed.SabaKareem@amd.com,
        Vijendar.Mukunda@amd.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 33/44] ASoC: amd: yc: Add ASUS UM5302TA into DMI table
Date:   Sun,  9 Oct 2022 19:49:21 -0400
Message-Id: <20221009234932.1230196-33-sashal@kernel.org>
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

From: Xiaoyan Li <lxy.lixiaoyan@gmail.com>

[ Upstream commit 4df5b13dec9e1b5a12db47ee92eb3f7da5c3deb5 ]

ASUS Zenbook S 13 OLED (UM5302TA) needs this quirk to get the built-in
microphone working properly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216270
Signed-off-by: Xiaoyan Li <lxy.lixiaoyan@gmail.com>
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20220920201436.19734-2-mario.limonciello@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index e0b24e1daef3..5eab3baf3573 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -171,6 +171,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21J6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "UM5302TA"),
+		}
+	},
 	{}
 };
 
-- 
2.35.1

