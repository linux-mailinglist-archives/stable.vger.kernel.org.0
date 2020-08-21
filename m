Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F8A24DBBB
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgHUQqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbgHUQUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:20:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75A8022CA1;
        Fri, 21 Aug 2020 16:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026780;
        bh=KBZtrl9l7zLEZJan83MptJLbyr5aJyrD63fDN0bHUu8=;
        h=From:To:Cc:Subject:Date:From;
        b=eD8TOu6fx57NkSWndHLJyUU10FuM7T0wyFa/coS5/j+42fgrG0CuazzNnAGMCJToX
         a6FvGXYhKxl/m7jgWOTmmA6pjRyO45iSaz81jRcLLanVuf00P7uIUzOe6UqozM8gzD
         lDVhNurpuAQu06KpgX+J3n7rbj7p2EClO9a8vYzU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 01/26] ALSA: pci: delete repeated words in comments
Date:   Fri, 21 Aug 2020 12:19:12 -0400
Message-Id: <20200821161938.349246-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit c7fabbc51352f50cc58242a6dc3b9c1a3599849b ]

Drop duplicated words in sound/pci/.
{and, the, at}

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20200806021926.32418-1-rdunlap@infradead.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/cs46xx/cs46xx_lib.c       | 2 +-
 sound/pci/cs46xx/dsp_spos_scb_lib.c | 2 +-
 sound/pci/hda/hda_codec.c           | 2 +-
 sound/pci/hda/hda_generic.c         | 2 +-
 sound/pci/hda/patch_sigmatel.c      | 2 +-
 sound/pci/ice1712/prodigy192.c      | 2 +-
 sound/pci/oxygen/xonar_dg.c         | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/pci/cs46xx/cs46xx_lib.c b/sound/pci/cs46xx/cs46xx_lib.c
index 528102cc2d5d0..d824ff4ae3e3b 100644
--- a/sound/pci/cs46xx/cs46xx_lib.c
+++ b/sound/pci/cs46xx/cs46xx_lib.c
@@ -780,7 +780,7 @@ static void snd_cs46xx_set_capture_sample_rate(struct snd_cs46xx *chip, unsigned
 		rate = 48000 / 9;
 
 	/*
-	 *  We can not capture at at rate greater than the Input Rate (48000).
+	 *  We can not capture at a rate greater than the Input Rate (48000).
 	 *  Return an error if an attempt is made to stray outside that limit.
 	 */
 	if (rate > 48000)
diff --git a/sound/pci/cs46xx/dsp_spos_scb_lib.c b/sound/pci/cs46xx/dsp_spos_scb_lib.c
index 7488e1b7a7707..4e726d39b05d1 100644
--- a/sound/pci/cs46xx/dsp_spos_scb_lib.c
+++ b/sound/pci/cs46xx/dsp_spos_scb_lib.c
@@ -1742,7 +1742,7 @@ int cs46xx_iec958_pre_open (struct snd_cs46xx *chip)
 	struct dsp_spos_instance * ins = chip->dsp_spos_instance;
 
 	if ( ins->spdif_status_out & DSP_SPDIF_STATUS_OUTPUT_ENABLED ) {
-		/* remove AsynchFGTxSCB and and PCMSerialInput_II */
+		/* remove AsynchFGTxSCB and PCMSerialInput_II */
 		cs46xx_dsp_disable_spdif_out (chip);
 
 		/* save state */
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index cbe0248225c1c..4e67614f15f8e 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3496,7 +3496,7 @@ EXPORT_SYMBOL_GPL(snd_hda_set_power_save);
  * @nid: NID to check / update
  *
  * Check whether the given NID is in the amp list.  If it's in the list,
- * check the current AMP status, and update the the power-status according
+ * check the current AMP status, and update the power-status according
  * to the mute status.
  *
  * This function is supposed to be set or called from the check_power_status
diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 949c90a859fab..184089c5e8cbc 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -820,7 +820,7 @@ static void activate_amp_in(struct hda_codec *codec, struct nid_path *path,
 	}
 }
 
-/* sync power of each widget in the the given path */
+/* sync power of each widget in the given path */
 static hda_nid_t path_power_update(struct hda_codec *codec,
 				   struct nid_path *path,
 				   bool allow_powerdown)
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index d1a6d20ace0da..80b72d0702c5e 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -862,7 +862,7 @@ static int stac_auto_create_beep_ctls(struct hda_codec *codec,
 	static struct snd_kcontrol_new beep_vol_ctl =
 		HDA_CODEC_VOLUME(NULL, 0, 0, 0);
 
-	/* check for mute support for the the amp */
+	/* check for mute support for the amp */
 	if ((caps & AC_AMPCAP_MUTE) >> AC_AMPCAP_MUTE_SHIFT) {
 		const struct snd_kcontrol_new *temp;
 		if (spec->anabeep_nid == nid)
diff --git a/sound/pci/ice1712/prodigy192.c b/sound/pci/ice1712/prodigy192.c
index 3919aed39ca03..5e52086d7b986 100644
--- a/sound/pci/ice1712/prodigy192.c
+++ b/sound/pci/ice1712/prodigy192.c
@@ -31,7 +31,7 @@
  *		  Experimentally I found out that only a combination of
  *		  OCKS0=1, OCKS1=1 (128fs, 64fs output) and ice1724 -
  *		  VT1724_MT_I2S_MCLK_128X=0 (256fs input) yields correct
- *		  sampling rate. That means the the FPGA doubles the
+ *		  sampling rate. That means that the FPGA doubles the
  *		  MCK01 rate.
  *
  *	Copyright (c) 2003 Takashi Iwai <tiwai@suse.de>
diff --git a/sound/pci/oxygen/xonar_dg.c b/sound/pci/oxygen/xonar_dg.c
index 4cf3200e988b0..df44135e1b0c9 100644
--- a/sound/pci/oxygen/xonar_dg.c
+++ b/sound/pci/oxygen/xonar_dg.c
@@ -39,7 +39,7 @@
  *   GPIO 4 <- headphone detect
  *   GPIO 5 -> enable ADC analog circuit for the left channel
  *   GPIO 6 -> enable ADC analog circuit for the right channel
- *   GPIO 7 -> switch green rear output jack between CS4245 and and the first
+ *   GPIO 7 -> switch green rear output jack between CS4245 and the first
  *             channel of CS4361 (mechanical relay)
  *   GPIO 8 -> enable output to speakers
  *
-- 
2.25.1

