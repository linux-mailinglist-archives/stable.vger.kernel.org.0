Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B0F5F94F5
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiJJAOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiJJAMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:12:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157C157E32;
        Sun,  9 Oct 2022 16:50:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C159DB80DE4;
        Sun,  9 Oct 2022 23:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC29C433D7;
        Sun,  9 Oct 2022 23:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359456;
        bh=pMbxhj9oyvXcVZkWKcZXy1MVAYMbhd3RSfm4nlEApfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSvEg0VcX6f05tYyto5npAL1tZ5crLCTL80/mqLiwx4i1IYDW+SaIyeiZX7QJTNwb
         RBF5YiTFJuAYpSo0pP0uK5V9NOuHQaKXd1J2S0/tKQLGgnmaz9o9j/zsHoA/lsbVLi
         hlqbea6zmJU2XUF74k6KC5F37ZuaGepWhi6uarRbD0HoS5dVl3IujikREOeOhBwz0V
         Z35p8+qo5SNevauGVLoBlaEZ1UNOhxdExTC+WaKWYWhR9G50a+5fyfHYUjFNuNT+Qv
         2f0zlz8T96x9hh4GBUVnUyW/fr7nMaa3CkoEWlkNlFJvmmq7RUPk7OkAT8Jx96w8BN
         O1IUpBvqzeJew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jairaj Arava <jairaj.arava@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Chao Song <chao.song@intel.com>,
        Curtis Malainey <curtis@malainey.com>,
        Curtis Malainey <cujomalainey@chromium.org>,
        Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        peter.ujfalusi@linux.intel.com, yung-chuan.liao@linux.intel.com,
        daniel.baluta@nxp.com, perex@perex.cz, tiwai@suse.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 26/44] ASoC: SOF: pci: Change DMI match info to support all Chrome platforms
Date:   Sun,  9 Oct 2022 19:49:14 -0400
Message-Id: <20221009234932.1230196-26-sashal@kernel.org>
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

From: Jairaj Arava <jairaj.arava@intel.com>

[ Upstream commit c1c1fc8103f794a10c5c15e3c17879caf4f42c8f ]

In some Chrome platforms if OEM's use their own string as SYS_VENDOR than
"Google", it leads to firmware load failure from intel/sof/community path.

Hence, changing SYS_VENDOR to PRODUCT_FAMILY in which "Google" is used
as common prefix and is supported in all Chrome platforms.

Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Chao Song <chao.song@intel.com>
Reviewed-by: Curtis Malainey <curtis@malainey.com>
Signed-off-by: Jairaj Arava <jairaj.arava@intel.com>
Signed-off-by: Curtis Malainey <cujomalainey@chromium.org>
Signed-off-by: Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220919114429.42700-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-pci-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/sof-pci-dev.c b/sound/soc/sof/sof-pci-dev.c
index d627092b399d..643fd1036d60 100644
--- a/sound/soc/sof/sof-pci-dev.c
+++ b/sound/soc/sof/sof-pci-dev.c
@@ -138,7 +138,7 @@ static const struct dmi_system_id community_key_platforms[] = {
 		.ident = "Google Chromebooks",
 		.callback = chromebook_use_community_key,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "Google"),
 		}
 	},
 	{},
-- 
2.35.1

