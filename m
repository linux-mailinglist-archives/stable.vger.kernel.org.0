Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA062650094
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiLRQRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiLRQQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:16:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8958910B58;
        Sun, 18 Dec 2022 08:07:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C534AB80BAA;
        Sun, 18 Dec 2022 16:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E1BC433D2;
        Sun, 18 Dec 2022 16:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379618;
        bh=Z1+QdG5qxU2B1H5u1JGOnxupPA9gwVz/YGQf95Ij7Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eiB4fJACuEt3RMxDexYJwIvOqdh2JAIRU++VrKY/6RYAd/vu/0gqWXdxeb4w7SIh0
         jXMVvSwWNtqg/Z67f3TLIbbW+pG5wBLEp9GhzTV2F7E6u0wYxjjrOpSQcv9HmaGVns
         28bdAzYWgbLpDnRk3gc7DqSZI020S/zgjVYYLTPr1uU40GUvFsgaCk7IRM6O+fOy7n
         nkr4x4H0tAnbOIHPwZRQD1CJFxq9mQ0Qc8+0JgzkzwD/VfpA0vlNyMNiDrCVIO5nvc
         Ugg3moI00BAmEH/gJqxK5NyOUV1pzyEbcf72Ln6YIFwVGDcCkxf5Wj858xemuXBoJa
         AnpW2fw+IQFYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Artem Lukyanov <dukzcry@ya.ru>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, mario.limonciello@amd.com,
        Syed.SabaKareem@amd.com, mendiebm@gmail.com,
        lxy.lixiaoyan@gmail.com, leohearts@leohearts.com,
        xazrael@hotmail.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 67/85] ASoC: amd: yc: Add Xiaomi Redmi Book Pro 14 2022 into DMI table
Date:   Sun, 18 Dec 2022 11:01:24 -0500
Message-Id: <20221218160142.925394-67-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
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

From: Artem Lukyanov <dukzcry@ya.ru>

[ Upstream commit c1dd6bf6199752890d8c59d895dd45094da51d1f ]

This model requires an additional detection quirk to enable the
internal microphone - BIOS doesn't seem to support AcpDmicConnected
(nothing in acpidump output).

Signed-off-by: Artem Lukyanov <dukzcry@ya.ru>
Link: https://lore.kernel.org/r/20221130085247.85126-1-dukzcry@ya.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index d9715bea965e..1f0b5527c594 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -213,6 +213,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m17 R5 AMD"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "TIMI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Redmi Book Pro 14 2022"),
+		}
+	},
 	{}
 };
 
-- 
2.35.1

