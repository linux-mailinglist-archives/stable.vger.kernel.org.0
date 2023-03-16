Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4DA6BD5D1
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 17:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjCPQe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 12:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjCPQeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 12:34:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3F7E485C;
        Thu, 16 Mar 2023 09:33:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F864620B2;
        Thu, 16 Mar 2023 16:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AFCC4339E;
        Thu, 16 Mar 2023 16:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678984407;
        bh=KASXsKcwhzOFvQl9CRD+V3oEgR7AUj1FxHxAfxlkrZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ks9z3oxKXvFTUvqT172yFQ6sGLxLMmWx3jxYZkDMQ7UYUWl79iiMZyijHo2Fnxc4Y
         Nsw8XqfwhVURzNrWEuUhYSjbHZVLXatdyHdkANz2EeDE6T/ZBFmOA8JeUYXbBoL42K
         lVp8zFHTyef0wmOl6cDLe09CwGqB8jlUhv67vk0KNJ/rBWwFT3VqcYVkR/THYWGxEQ
         3xrVF7TuL+uEIT6hhLSfJ4YfcKOyvsMLv4+xZqdJN3C4vEsqqHxRBl9Oyd89tKuawZ
         aNMqYUm8CbJP5lD1YDxG7VuKqJlrIpQm20m/etmS+M/0ZQSfJr2wyBr65z8oKcoqhM
         PuM+WU3tFZlvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duc Anh Le <lub.the.studio@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, mario.limonciello@amd.com,
        Syed.SabaKareem@amd.com, aniol@aniolmarti.cat, mendiebm@gmail.com,
        wimvanboven@gmail.com, lxy.lixiaoyan@gmail.com,
        xazrael@hotmail.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 3/6] ASoC: amd: yc: Add DMI entries to support HP OMEN 16-n0xxx (8A43)
Date:   Thu, 16 Mar 2023 12:33:04 -0400
Message-Id: <20230316163309.708796-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316163309.708796-1-sashal@kernel.org>
References: <20230316163309.708796-1-sashal@kernel.org>
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

