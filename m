Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBB365018C
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiLRQdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbiLRQdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:33:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A92FDF5B;
        Sun, 18 Dec 2022 08:12:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02CA660DC8;
        Sun, 18 Dec 2022 16:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F277C433F0;
        Sun, 18 Dec 2022 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379921;
        bh=Z1+QdG5qxU2B1H5u1JGOnxupPA9gwVz/YGQf95Ij7Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cKa9UdB5D09foYZ8EHqWJAhnzUDnzyZoJSJNSpjmFvnhAUOMEolFDKj5MC1N0+dzA
         R4r5j+YqMiOHHg7CweE0alQyTAliMJvwgx90swNvXzgM0mAqMojVN9tmyKu1/MZAWc
         hn+p/fO+KP4xoGM1yBnsY5Q6R5eRvCt0gMEblqkovT+y6KrxBpyXP/mjEYjAchrWZq
         bA+QpW8FfJoT7sI3F/ZjWdakZZLOEhUDva2eUHR2FCAfoA7E3eRecxKveH1OOwwm7D
         SWMLr+b79PKLPO59apJPeBr31WTTtgOEj+p9SmlyfIQ4QYhmkVmFEVXD8r1igkg8RO
         vd2vFhHTyl2ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Artem Lukyanov <dukzcry@ya.ru>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, mario.limonciello@amd.com,
        Syed.SabaKareem@amd.com, mendiebm@gmail.com,
        leohearts@leohearts.com, xazrael@hotmail.com,
        lxy.lixiaoyan@gmail.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 57/73] ASoC: amd: yc: Add Xiaomi Redmi Book Pro 14 2022 into DMI table
Date:   Sun, 18 Dec 2022 11:07:25 -0500
Message-Id: <20221218160741.927862-57-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
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

