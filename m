Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9B01EFB12
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgFEOSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728666AbgFEOS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:18:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27AB82086A;
        Fri,  5 Jun 2020 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366705;
        bh=jZU+7oxL2h7ADuMpEuIHAqjKMflvYcAP/bZoBRQXAHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLF4onLh1yj4enQZzCM6vkesoCAvojhDYDv87UI4Mboj/V0hURCV4qeAnKoPDgTvH
         ZhsErthTFbGbak7rBmZhSA6NIGIJwZWzAHYTl4TexSy9AsbZSWc0xtnqo/3SpAmVn+
         fZDDEQMKUN4AG2A3nFXhWo1hkpo7dw+8lIZm91oI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/38] ASoC: intel - fix the card names
Date:   Fri,  5 Jun 2020 16:15:03 +0200
Message-Id: <20200605140253.776451245@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.542768750@linuxfoundation.org>
References: <20200605140252.542768750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit d745cc1ab65945b2d17ec9c5652f38299c054649 ]

Those strings are exposed to the user space as the
card name thus used in the GUIs. The common
standard is to avoid '_' here. The worst case
is 'sof-skl_hda_card' string.

Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Mark Brown <broonie@kernel.org>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191028164624.14334-1-perex@perex.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c | 2 +-
 sound/soc/intel/boards/skl_hda_dsp_generic.c        | 2 +-
 sound/soc/intel/boards/sof_rt5682.c                 | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c b/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
index 67b276a65a8d..8ad31c91fc75 100644
--- a/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
+++ b/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
@@ -626,7 +626,7 @@ static int kabylake_card_late_probe(struct snd_soc_card *card)
  * kabylake audio machine driver for  MAX98927 + RT5514 + RT5663
  */
 static struct snd_soc_card kabylake_audio_card = {
-	.name = "kbl_r5514_5663_max",
+	.name = "kbl-r5514-5663-max",
 	.owner = THIS_MODULE,
 	.dai_link = kabylake_dais,
 	.num_links = ARRAY_SIZE(kabylake_dais),
diff --git a/sound/soc/intel/boards/skl_hda_dsp_generic.c b/sound/soc/intel/boards/skl_hda_dsp_generic.c
index 1778acdc367c..e8d676c192f6 100644
--- a/sound/soc/intel/boards/skl_hda_dsp_generic.c
+++ b/sound/soc/intel/boards/skl_hda_dsp_generic.c
@@ -90,7 +90,7 @@ skl_hda_add_dai_link(struct snd_soc_card *card, struct snd_soc_dai_link *link)
 }
 
 static struct snd_soc_card hda_soc_card = {
-	.name = "skl_hda_card",
+	.name = "hda-dsp",
 	.owner = THIS_MODULE,
 	.dai_link = skl_hda_be_dai_links,
 	.dapm_widgets = skl_hda_widgets,
diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index 06b7d6c6c9a0..302ca1920791 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -374,7 +374,7 @@ static int dmic_init(struct snd_soc_pcm_runtime *rtd)
 
 /* sof audio machine driver for rt5682 codec */
 static struct snd_soc_card sof_audio_card_rt5682 = {
-	.name = "sof_rt5682",
+	.name = "rt5682", /* the sof- prefix is added by the core */
 	.owner = THIS_MODULE,
 	.controls = sof_controls,
 	.num_controls = ARRAY_SIZE(sof_controls),
-- 
2.25.1



