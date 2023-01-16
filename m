Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D41266C0A6
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjAPODQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjAPOC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:02:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5972E2202B;
        Mon, 16 Jan 2023 06:02:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8227260FD4;
        Mon, 16 Jan 2023 14:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85982C433EF;
        Mon, 16 Jan 2023 14:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877753;
        bh=jBxXofiDuMYrEyqP2oAXhBy9CTP5zsteBxobWUWQSW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DbtbqWImrBtoGgjSwtziE2ghkeP32f9gaZaEmbgsgBy7yUWLrYxJIT3hFMOt9RQU5
         54/HiYUyGUBTuQx0OtyXBzFeZJGSizR7UierPOqsrzB1kJlcp8/EqqINsEUJCXgf8C
         hF9L0PeXmhEBaiUvT8Rua7ThT25IHH/gTaeafhc/1tiDECh1LhGezS6DfSaaYHiDky
         sEIXEKTGtzhAjnFYkHSwUMTd09Z2Uwcxr3AQimokDVQdAIZ0y0bNAf+naahhtjBQnv
         VhGqBozQQWtlQF3bf/1TSe+pdkIBymMRZsF7pQpOmN80m/6PKppOuUvDNwJsF//SeG
         VKsaRvYXfEvwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Aniol=20Mart=C3=AD?= <aniol@aniolmarti.cat>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, mario.limonciello@amd.com,
        Syed.SabaKareem@amd.com, leohearts@leohearts.com,
        xazrael@hotmail.com, lxy.lixiaoyan@gmail.com,
        wimvanboven@gmail.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 11/53] ASoC: amd: yc: Add ASUS M5402RA into DMI table
Date:   Mon, 16 Jan 2023 09:01:11 -0500
Message-Id: <20230116140154.114951-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Aniol Martí <aniol@aniolmarti.cat>

[ Upstream commit a0dd7fcab5cd221fa960f594c586e1f9f16c02c0 ]

ASUS VivoBook 13 OLED (M5402RA) needs this quirk to get the built-in microphone working properly.

Signed-off-by: Aniol Martí <aniol@aniolmarti.cat>
Link: https://lore.kernel.org/r/20221227224932.9771-1-aniol@aniolmarti.cat
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 469c5e79e0ea..0d283e41f66d 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -206,6 +206,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "UM5302TA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M5402RA"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.35.1

