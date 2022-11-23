Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F344635DAD
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237575AbiKWMq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237780AbiKWMpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:45:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52742252E;
        Wed, 23 Nov 2022 04:42:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7574161C99;
        Wed, 23 Nov 2022 12:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8BAC433C1;
        Wed, 23 Nov 2022 12:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207362;
        bh=vI2XmKZgqatvP3vfjv7XrJc4fMBw3Ck3tGlFPEqEFUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQ4qNA0Hyo+i2lRSwfo7ljsb8Eim3fLc0d9THY3VrBosC65izCSlOSq9VwCb2kW2d
         OUowiZn/+k/nF7/BPsjL/pn5iLTxO7pBVze8F4sqbHN5yXUTGeQppZ3NZIIx/+AACw
         rnh2urYYSGvnHEHDSiHFYQ1vplkc+5iE0PD2keKp9JJv/ExhbkjItBfBlS7KSXo2+r
         zpGJt3ykWuN0s/Bfmi2FNUaad/Rek82Bgqsu/QJ1WudSmUmzjOXxK3SzV/w5lqoS6L
         LXZEDg3S51pG27EnB4HwPxqJXcA0MFNkYTltmIbc/LxFzAp4ohMUGRUXOrvkhYFSzZ
         UfqfSmXSZNFtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@linux.intel.com,
        yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com,
        kai.vehmanen@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        ckeepax@opensource.cirrus.com, akihiko.odaki@gmail.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 03/31] ASoC: Intel: bytcht_es8316: Add quirk for the Nanote UMPC-01
Date:   Wed, 23 Nov 2022 07:42:04 -0500
Message-Id: <20221123124234.265396-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124234.265396-1-sashal@kernel.org>
References: <20221123124234.265396-1-sashal@kernel.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 8bb0ac0e6f64ebdf15d963c26b028de391c9bcf9 ]

The Nanote UMPC-01 mini laptop has stereo speakers, while the default
bytcht_es8316 settings assume a mono speaker setup. Add a quirk for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20221025140942.509066-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcht_es8316.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
index 4d313d0d0f23..950457bcc28f 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -443,6 +443,13 @@ static const struct dmi_system_id byt_cht_es8316_quirk_table[] = {
 					| BYT_CHT_ES8316_INTMIC_IN2_MAP
 					| BYT_CHT_ES8316_JD_INVERTED),
 	},
+	{	/* Nanote UMPC-01 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "RWC CO.,LTD"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "UMPC-01"),
+		},
+		.driver_data = (void *)BYT_CHT_ES8316_INTMIC_IN1_MAP,
+	},
 	{	/* Teclast X98 Plus II */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "TECLAST"),
-- 
2.35.1

