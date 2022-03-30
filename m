Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BAD4EC0B4
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344245AbiC3Lwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344257AbiC3LwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:52:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33193278C54;
        Wed, 30 Mar 2022 04:48:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7ECC61602;
        Wed, 30 Mar 2022 11:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270E9C36AE7;
        Wed, 30 Mar 2022 11:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640901;
        bh=hpbWX8YBC6s4oo45QHF2m7r8EsVxECiMVkMLp+Qwi3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQ92ungwBCrBZ6dFhlaqJ28eCDZV6YWajgGeACyBJQbcWU/r9sFC73hasChZv7lBq
         AOLDAA7yPk55+t4EJMEmCCMp4MVfcUW88x96ram+a/47CbCGF0SasVWhYf15/r/tHa
         LzTrytyky9kNdfNQj6YYdfwO9h8HZTtBrKeZUXOWVuZAABLGsWAMOmmbNSURtKxuG8
         7CRuiv8JqIfpA2H4y3QwW4IW5nN703E+uJHEruhXkFx66Ty1flvFafmuGv2T62uSkC
         8/MWQJ5yX8dVw9vdEhRoYpPT4GCtSS60gBKQjCM/jPIoflK/5SY7AURQr1BwyIRDPD
         J6piy9obwnz2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 60/66] ASoC: Intel: sof_es8336: log all quirks
Date:   Wed, 30 Mar 2022 07:46:39 -0400
Message-Id: <20220330114646.1669334-60-sashal@kernel.org>
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

[ Upstream commit 9c818d849192491a8799b1cb14ca0f7aead4fb09 ]

We only logged the SSP quirk, make sure the GPIO and DMIC quirks are
exposed.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220308192610.392950-16-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_es8336.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 46e453915f82..764560439d46 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -63,7 +63,12 @@ static const struct acpi_gpio_mapping *gpio_mapping = acpi_es8336_gpios;
 
 static void log_quirks(struct device *dev)
 {
-	dev_info(dev, "quirk SSP%ld",  SOF_ES8336_SSP_CODEC(quirk));
+	dev_info(dev, "quirk mask %#lx\n", quirk);
+	dev_info(dev, "quirk SSP%ld\n",  SOF_ES8336_SSP_CODEC(quirk));
+	if (quirk & SOF_ES8336_ENABLE_DMIC)
+		dev_info(dev, "quirk DMIC enabled\n");
+	if (quirk & SOF_ES8336_TGL_GPIO_QUIRK)
+		dev_info(dev, "quirk TGL GPIO enabled\n");
 }
 
 static int sof_es8316_speaker_power_event(struct snd_soc_dapm_widget *w,
-- 
2.34.1

