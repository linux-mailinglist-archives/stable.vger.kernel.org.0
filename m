Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092D44F3245
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbiDEJC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238397AbiDEIad (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:30:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE1524F01;
        Tue,  5 Apr 2022 01:22:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E277060FF5;
        Tue,  5 Apr 2022 08:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED36DC385A0;
        Tue,  5 Apr 2022 08:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146927;
        bh=n1yKYr6ib+uBTiB1zGsnOcKC0HJM7ZyAz+w+jiqCJxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5++4/LyjfiGDTUMcByMYQi5tLVZSI5Y+Td5vF2nZUHBB9rLZVeclnC6T/SxiDgjH
         KJb9pVigGQdanFaoA1odEdL3KAijIO4uGcjnZtEf7a04Pn/f1IWAVsZRvpHxSduCp7
         mdDO0r/ZSVr0hdEzUqAkK4b/sUet9vXl2TUK0Vto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, anthony tonitch <d.tonitch@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0939/1126] ALSA: intel-dsp-config: add more ACPI HIDs for ES83x6 devices
Date:   Tue,  5 Apr 2022 09:28:06 +0200
Message-Id: <20220405070435.073294196@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



