Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34C669065E
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjBILQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjBILP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:15:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23B576A1;
        Thu,  9 Feb 2023 03:15:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A461461A24;
        Thu,  9 Feb 2023 11:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC072C433EF;
        Thu,  9 Feb 2023 11:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941339;
        bh=sPsvOSqlhoWC/q+W+LIn1MJRKhl1TyhFwQxIEx9ez4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKmWVEah1UvMQ+KbxBAiB2IygwbRBSduInza0zQsQhwnFEfF2FQqBsl0KHiYzaRUC
         PwyPd8QmARRK9FGCF6SWcN20I7K1oy2hVNyVe99qvt5o7WpeESKkFLsCNwGZ6QqjAO
         sUspNGi0T4VazQ4msekFusVuRqOc0UgWvOHu0kZocMZUlxE4hUNVuwqDCIHohuFGFV
         izGH1+/4yZK8Ly6j59Zt+Cq90wDZ9xJNHL0OVo+1+Q1ZCdCtzncS6WaCD9HIXd2Avj
         UmpQ4nAlSf2WdVGnutwSFtFHiTZup5Fp9m3zHTvPPzAO9AA+59AF1yC9BCNxviKWNb
         b6wKGTbeiBMtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     fengwk <fengwk94@gmail.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, mario.limonciello@amd.com,
        Syed.SabaKareem@amd.com, mendiebm@gmail.com, xazrael@hotmail.com,
        dukzcry@ya.ru, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 10/38] ASoC: amd: yc: Add Xiaomi Redmi Book Pro 15 2022 into DMI table
Date:   Thu,  9 Feb 2023 06:14:29 -0500
Message-Id: <20230209111459.1891941-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
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

From: fengwk <fengwk94@gmail.com>

[ Upstream commit dcff8b7ca92d724bdaf474a3fa37a7748377813a ]

This model requires an additional detection quirk to enable the
internal microphone - BIOS doesn't seem to support AcpDmicConnected
(nothing in acpidump output).

Signed-off-by: fengwk <fengwk94@gmail.com>
Link: https://lore.kernel.org/r/Y8wmCutc74j/tyHP@arch
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 00fb976e0b81e..36314753923b8 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -227,6 +227,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Redmi Book Pro 14 2022"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "TIMI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Redmi Book Pro 15 2022"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.0

