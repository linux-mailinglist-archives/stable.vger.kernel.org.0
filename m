Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773A16BD5A9
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 17:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjCPQcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 12:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjCPQcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 12:32:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D894E20DE;
        Thu, 16 Mar 2023 09:32:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02DC8B8226B;
        Thu, 16 Mar 2023 16:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4B0C433EF;
        Thu, 16 Mar 2023 16:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678984350;
        bh=ioD3xUhnDD/kN66mIEPreBlmwTQml2JuCHXZJ35GMJ4=;
        h=From:To:Cc:Subject:Date:From;
        b=uiJO9nM0AdieMf1tEkyY4z+SLUqgJ+ErYOHKzHyGKovuwgKuJVg9IXa3Sa6NTQTeN
         Uq0Q6lgshcP/6ufXr6/zO2jbv5eYcRqiCZT2XYZVwH7gBeppmGd3o7ZWNN+gx9zKpN
         M/q1mKC7I9PZmt1BI7kOjNc8HAEVCHFPiPdYfWTE3mDn64eTbuyOzq1OKo2I1J25DK
         aQRkw/DoIrxiXYM2uRz2+jtseN4Q+cZSpG52slDiElvQGtfeZpQC/AFDc4ShbbSih/
         9YhJdna0tbNn3+jhDqLUIgP49j7pZRkqZCkPOHQ1INvcss+X1QNPlFJ0oicbFAXO6N
         NHaR4M8LqSnRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joseph Hunkeler <jhunkeler@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, mario.limonciello@amd.com,
        Syed.SabaKareem@amd.com, xazrael@hotmail.com, aniol@aniolmarti.cat,
        leohearts@leohearts.com, dukzcry@ya.ru, fengwk94@gmail.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.2 1/7] ASoC: amd: yp: Add OMEN by HP Gaming Laptop 16z-n000 to quirks
Date:   Thu, 16 Mar 2023 12:32:18 -0400
Message-Id: <20230316163227.708614-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
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

From: Joseph Hunkeler <jhunkeler@gmail.com>

[ Upstream commit 22ce6843abec19270bf69b176d7ee0a4ef781da5 ]

Enables display microphone on the HP OMEN 16z-n000 (8A42) laptop

Signed-off-by: Joseph Hunkeler <jhunkeler@gmail.com>
Link: https://lore.kernel.org/r/20230216155007.26143-1-jhunkeler@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 36314753923b8..4e681e9c08fe5 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -255,6 +255,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "15NBC1011"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16z-n000"),
+		}
+	},
 	{}
 };
 
-- 
2.39.2

