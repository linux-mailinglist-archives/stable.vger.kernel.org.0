Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B08374492
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbhEEQ6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236716AbhEEQzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:55:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF25361464;
        Wed,  5 May 2021 16:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232741;
        bh=fOH8+Z1NGNGOEwSqzcjBU9mOjbTRyXHml1vP4tn/58Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijTaDwzzBUgaPG4Zh/UShnTIi5mYVLDOU1pmgLKKHe0bpB5meWM7wDFCBLo8gBcm6
         6bFvyQF24i2iXmNu2ORzTdlV5eW/KHLyWYaFp7JoEY/biFwVHnalKohhkCpdZa8V5E
         zRq3C3Q/Nwjag7QotllkKaE61arRqMudJ5oYSG8PwFx1zZeT/sNZxUvAYdy/xTieqj
         SU/Xa7b509T7MQY+Sk52d6SF92zwaThLnQ33ZVbftZFoqtPbVIIK4fZiNn+PfelsU9
         j36WEd3I5Yi+ko76mj3+/atFMRcmIq31Kxoy0une6sU8aRQGhafJaBNmaC8MwHoY4w
         gdeOq6uPj+dvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 03/46] ASoC: Intel: bytcr_rt5640: Enable jack-detect support on Asus T100TAF
Date:   Wed,  5 May 2021 12:38:13 -0400
Message-Id: <20210505163856.3463279-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163856.3463279-1-sashal@kernel.org>
References: <20210505163856.3463279-1-sashal@kernel.org>
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
index cfd307717473..006cf1e8b602 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -476,6 +476,9 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
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

