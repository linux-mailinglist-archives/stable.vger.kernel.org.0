Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597774EC0B6
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344171AbiC3Lwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344176AbiC3Lv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:51:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6271C277967;
        Wed, 30 Mar 2022 04:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4F2C61618;
        Wed, 30 Mar 2022 11:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16163C340F2;
        Wed, 30 Mar 2022 11:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640892;
        bh=n1yKYr6ib+uBTiB1zGsnOcKC0HJM7ZyAz+w+jiqCJxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBpQPLT0aBW0QFdr9HHKiThT8aPMSAnC+p+cLIvT8ysk/F9pV0iLeOTlDkE9VoOjp
         N9u31NfL5e34VratvW3hQxfciEjEKeZm9LVoSQiA4fFJwt6w+Wwac+9MOiFeZwpu1O
         lymf4pvwwMjD8939XKf0LToLsAK/ysb+gqD8j1dX4y+CEXpwWtP+XOM2YCv844eEd+
         9qxlOqV6wrQ4qd7UMqCAvxbFzDPAgpjqjzyQU3chilaSNljKiGN2agvz9cGnxnJNs9
         g8kKbJZZleWUKQsfM2rVpg40xAaZl/1Di/PIXkdQIPQ2nEId94p/CUZs4whVoOUz9H
         xLuBLrZFiAbGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        anthony tonitch <d.tonitch@gmail.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 55/66] ALSA: intel-dsp-config: add more ACPI HIDs for ES83x6 devices
Date:   Wed, 30 Mar 2022 07:46:34 -0400
Message-Id: <20220330114646.1669334-55-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit de24d97fb845ffd2229811ee256438e42b5a8d12 ]

We only saw ESSX8336 so far, but now with reports of 'ESSX8326' we
need to expand to a full list. Let's reuse the 'snd_soc_acpi_codecs'
structure to store the information.

Reported-by: anthony tonitch <d.tonitch@gmail.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20220308192610.392950-8-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 4fb90ceb4053..b9b7bf5a5553 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -11,6 +11,7 @@
 #include <sound/core.h>
 #include <sound/intel-dsp-config.h>
 #include <sound/intel-nhlt.h>
+#include <sound/soc-acpi.h>
 
 static int dsp_driver;
 
@@ -31,7 +32,12 @@ struct config_entry {
 	u16 device;
 	u8 acpi_hid[ACPI_ID_LEN];
 	const struct dmi_system_id *dmi_table;
-	u8 codec_hid[ACPI_ID_LEN];
+	const struct snd_soc_acpi_codecs *codec_hid;
+};
+
+static const struct snd_soc_acpi_codecs __maybe_unused essx_83x6 = {
+	.num_codecs = 3,
+	.codecs = { "ESSX8316", "ESSX8326", "ESSX8336"},
 };
 
 /*
@@ -77,7 +83,7 @@ static const struct config_entry config_table[] = {
 	{
 		.flags = FLAG_SOF,
 		.device = 0x5a98,
-		.codec_hid = "ESSX8336",
+		.codec_hid =  &essx_83x6,
 	},
 #endif
 #if IS_ENABLED(CONFIG_SND_SOC_INTEL_APL)
@@ -163,7 +169,7 @@ static const struct config_entry config_table[] = {
 	{
 		.flags = FLAG_SOF,
 		.device = 0x3198,
-		.codec_hid = "ESSX8336",
+		.codec_hid =  &essx_83x6,
 	},
 #endif
 
@@ -251,7 +257,7 @@ static const struct config_entry config_table[] = {
 	{
 		.flags = FLAG_SOF,
 		.device = 0x02c8,
-		.codec_hid = "ESSX8336",
+		.codec_hid =  &essx_83x6,
 	},
 	{
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
@@ -280,7 +286,7 @@ static const struct config_entry config_table[] = {
 	{
 		.flags = FLAG_SOF,
 		.device = 0x06c8,
-		.codec_hid = "ESSX8336",
+		.codec_hid =  &essx_83x6,
 	},
 	{
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
@@ -327,7 +333,7 @@ static const struct config_entry config_table[] = {
 	{
 		.flags = FLAG_SOF,
 		.device = 0x4dc8,
-		.codec_hid = "ESSX8336",
+		.codec_hid =  &essx_83x6,
 	},
 	{
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC,
@@ -353,7 +359,7 @@ static const struct config_entry config_table[] = {
 	{
 		.flags = FLAG_SOF,
 		.device = 0xa0c8,
-		.codec_hid = "ESSX8336",
+		.codec_hid =  &essx_83x6,
 	},
 	{
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
@@ -414,8 +420,15 @@ static const struct config_entry *snd_intel_dsp_find_config
 			continue;
 		if (table->dmi_table && !dmi_check_system(table->dmi_table))
 			continue;
-		if (table->codec_hid[0] && !acpi_dev_present(table->codec_hid, NULL, -1))
-			continue;
+		if (table->codec_hid) {
+			int i;
+
+			for (i = 0; i < table->codec_hid->num_codecs; i++)
+				if (acpi_dev_present(table->codec_hid->codecs[i], NULL, -1))
+					break;
+			if (i == table->codec_hid->num_codecs)
+				continue;
+		}
 		return table;
 	}
 	return NULL;
-- 
2.34.1

