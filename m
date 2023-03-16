Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE38A6BD5B7
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 17:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjCPQdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 12:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjCPQdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 12:33:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D89E4854;
        Thu, 16 Mar 2023 09:32:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58858620AC;
        Thu, 16 Mar 2023 16:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA0BC433EF;
        Thu, 16 Mar 2023 16:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678984375;
        bh=KASXsKcwhzOFvQl9CRD+V3oEgR7AUj1FxHxAfxlkrZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWuYFCfGRMPu9KpDKCDNT5mCuM0ko1ZWOVw4T1Au/VSJnDq1K0meLakoJOkZCb5b0
         agd3SlwXhDQJGB/VL19d+wiFOfm4CzwHN5DPeiDHeM/Oos67e1GoWpYUxVNejNxNw9
         EzUQ0UiE/4ZOtbVur0rDetzH0gOQuOk2YA6+gbZ86lk5mUZvML7qlKohQhqivT2WIN
         Ak6uiAV318FWVOSSZpRfI7v134fVpBA9s5aGHbrjkc0zcH0CwTV0qpSovZQ+VH0xwv
         0Ztar2IugFDz8xJD/9dQVOV+M9rDrNlSSIGW2s2T/65RCUJgjNVA0++B7bAG+1JeYN
         s7kbSZ7bC+Nrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duc Anh Le <lub.the.studio@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, mario.limonciello@amd.com,
        Syed.SabaKareem@amd.com, aniol@aniolmarti.cat, fengwk94@gmail.com,
        dukzcry@ya.ru, xazrael@hotmail.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.2 4/7] ASoC: amd: yc: Add DMI entries to support HP OMEN 16-n0xxx (8A43)
Date:   Thu, 16 Mar 2023 12:32:21 -0400
Message-Id: <20230316163227.708614-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316163227.708614-1-sashal@kernel.org>
References: <20230316163227.708614-1-sashal@kernel.org>
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

From: Duc Anh Le <lub.the.studio@gmail.com>

[ Upstream commit d52279d5c9204a041e9ba02a66a353573b2f96e4 ]

This model requires an additional detection quirk to enable the internal microphone.

Signed-off-by: Duc Anh Le <lub.the.studio@gmail.com>
Link: https://lore.kernel.org/r/20230227234921.7784-1-lub.the.studio@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 4e681e9c08fe5..4a69ce702360c 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -262,6 +262,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16z-n000"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8A43"),
+		}
+	},
 	{}
 };
 
-- 
2.39.2

