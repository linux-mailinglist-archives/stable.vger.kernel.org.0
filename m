Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D12C37400F
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhEEQcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234123AbhEEQci (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:32:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78474613ED;
        Wed,  5 May 2021 16:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232301;
        bh=Rns+1bNxYcD0ifBOCha6MGvXKC1aHYbsZJ5327dThkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgwutEx6W9BvDG/PTuSKSVYtPoBaoWyexdPf/Y6CJszvFee5RG4JQmBSfwQFTJiR8
         vPU35+GQHIOUh94TaAovoldLjLqAgroey6zm/4weBt2RGRHiIywNvk2KLAh/N44+bm
         SGyA9in3OXAhHaOSwcSl8ti/2mJv38ok4WgCo14+Pgg27D8Z5jTl4DCDgFqCXwTqlN
         /SyPZj1hHtsvv0IZDBorfHokFEi4wV7lydjtHQlWqYc7abZ7oTtAxil83dUb5ZEgzP
         HD7oScqDbmoqn0BzzbcbPoOOyeSajQAvrbqir5XMFtH+SMEp0eyikAUfnTKu28+cPU
         fJY1hVOP8GD8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 012/116] ASoC: Intel: bytcr_rt5640: Enable jack-detect support on Asus T100TAF
Date:   Wed,  5 May 2021 12:29:40 -0400
Message-Id: <20210505163125.3460440-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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
index 5d48cc359c3d..19faababb78d 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -482,6 +482,9 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
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

