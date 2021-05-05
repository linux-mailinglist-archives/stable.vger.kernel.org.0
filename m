Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFC3374520
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237106AbhEERD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237524AbhEERAf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:00:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6C26619C8;
        Wed,  5 May 2021 16:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232809;
        bh=7lvypLq12sQUrNO/DaW5uxNfyv7rYwTPuISm65TMq0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6rX7gf8D6WKScNglFWhNXV2hKk63f1pm5JLPAwx82b+VvRv/NcpQwFbnskYFWZyk
         TVhIq6Ut3hjxpS5U8oIyLdmyd5qy82grTg8564rHjeOqbHAb6ZtAPVeCAZ3VT+ryi0
         vgjblt6R6KsuwAazObPsmxRJcErHXcs1vH88CaNJk3OdZIACMhTORdwAqhZOdgoTQr
         u2HvFlIZQ1NgwEXNb6gm9YqeenbEbVzU5Fs+tR6RRx48RFeI1+FPO2tuVAqHzzcv06
         w7HD0hMfaeqiE6Uknn19qmeuPfRyn83xRpXvDh26AMs1omhFxrmKoNUl8NJFLGSA8V
         E10r3wzo+OzAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 03/32] ASoC: Intel: bytcr_rt5640: Enable jack-detect support on Asus T100TAF
Date:   Wed,  5 May 2021 12:39:35 -0400
Message-Id: <20210505164004.3463707-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164004.3463707-1-sashal@kernel.org>
References: <20210505164004.3463707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b7c7203a1f751348f35fc4bcb157572d303f7573 ]

The Asus T100TAF uses the same jack-detect settings as the T100TA,
this has been confirmed on actual hardware.

Add these settings to the T100TAF quirks to enable jack-detect support
on the T100TAF.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210312114850.13832-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index d63d99776384..62b4187e9f44 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -473,6 +473,9 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T100TAF"),
 		},
 		.driver_data = (void *)(BYT_RT5640_IN1_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_2000UA |
+					BYT_RT5640_OVCD_SF_0P75 |
 					BYT_RT5640_MONO_SPEAKER |
 					BYT_RT5640_DIFF_MIC |
 					BYT_RT5640_SSP0_AIF2 |
-- 
2.30.2

