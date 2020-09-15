Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF5F26B463
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgIOXXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727197AbgIOOiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:38:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DE4522473;
        Tue, 15 Sep 2020 14:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180084;
        bh=Mt/qNSE8Xsx0QgG4r8hq6ijjX6NFOS904FufdN1uPcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqx/G+ao0C+hS86NzIRGUYuaBFCN+tpUPDgM0aMWoKOHM/G1/Ol83olT1Zuse8/rP
         qm/qFbgFpDRUrXLWpXzTYazFqUUX+6lIgK9hgOojeM+9GVlf29Z1ddLEU8/KEyWb/J
         Nqtook9pzwo8dkbq8qkHZ5RlqOBrvUn8QngSXgq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 103/177] ALSA: hda: use consistent HDAudio spelling in comments/docs
Date:   Tue, 15 Sep 2020 16:12:54 +0200
Message-Id: <20200915140658.586823370@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit b79de57b4378a93115307be6962d05b099eb0f37 ]

We use HDaudio and HDAudio, pick one to make searches easier.
No functionality change

Also fix timestamping typo in documentation.

Reported-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200902154250.1440585-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/sound/designs/timestamping.rst |  2 +-
 sound/hda/intel-dsp-config.c                 | 10 +++++-----
 sound/x86/Kconfig                            |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/sound/designs/timestamping.rst b/Documentation/sound/designs/timestamping.rst
index 2b0fff5034151..7c7ecf5dbc4bd 100644
--- a/Documentation/sound/designs/timestamping.rst
+++ b/Documentation/sound/designs/timestamping.rst
@@ -143,7 +143,7 @@ timestamp shows when the information is put together by the driver
 before returning from the ``STATUS`` and ``STATUS_EXT`` ioctl. in most cases
 this driver_timestamp will be identical to the regular system tstamp.
 
-Examples of typestamping with HDaudio:
+Examples of timestamping with HDAudio:
 
 1. DMA timestamp, no compensation for DMA+analog delay
 ::
diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 99aec73491676..1c5114dedda92 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -54,7 +54,7 @@ static const struct config_entry config_table[] = {
 #endif
 /*
  * Apollolake (Broxton-P)
- * the legacy HDaudio driver is used except on Up Squared (SOF) and
+ * the legacy HDAudio driver is used except on Up Squared (SOF) and
  * Chromebooks (SST)
  */
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_APOLLOLAKE)
@@ -89,7 +89,7 @@ static const struct config_entry config_table[] = {
 	},
 #endif
 /*
- * Skylake and Kabylake use legacy HDaudio driver except for Google
+ * Skylake and Kabylake use legacy HDAudio driver except for Google
  * Chromebooks (SST)
  */
 
@@ -135,7 +135,7 @@ static const struct config_entry config_table[] = {
 #endif
 
 /*
- * Geminilake uses legacy HDaudio driver except for Google
+ * Geminilake uses legacy HDAudio driver except for Google
  * Chromebooks
  */
 /* Geminilake */
@@ -157,7 +157,7 @@ static const struct config_entry config_table[] = {
 
 /*
  * CoffeeLake, CannonLake, CometLake, IceLake, TigerLake use legacy
- * HDaudio driver except for Google Chromebooks and when DMICs are
+ * HDAudio driver except for Google Chromebooks and when DMICs are
  * present. Two cases are required since Coreboot does not expose NHLT
  * tables.
  *
@@ -391,7 +391,7 @@ int snd_intel_dsp_driver_probe(struct pci_dev *pci)
 	if (pci->class == 0x040300)
 		return SND_INTEL_DSP_DRIVER_LEGACY;
 	if (pci->class != 0x040100 && pci->class != 0x040380) {
-		dev_err(&pci->dev, "Unknown PCI class/subclass/prog-if information (0x%06x) found, selecting HDA legacy driver\n", pci->class);
+		dev_err(&pci->dev, "Unknown PCI class/subclass/prog-if information (0x%06x) found, selecting HDAudio legacy driver\n", pci->class);
 		return SND_INTEL_DSP_DRIVER_LEGACY;
 	}
 
diff --git a/sound/x86/Kconfig b/sound/x86/Kconfig
index 77777192f6508..4ffcc5e623c22 100644
--- a/sound/x86/Kconfig
+++ b/sound/x86/Kconfig
@@ -9,7 +9,7 @@ menuconfig SND_X86
 if SND_X86
 
 config HDMI_LPE_AUDIO
-	tristate "HDMI audio without HDaudio on Intel Atom platforms"
+	tristate "HDMI audio without HDAudio on Intel Atom platforms"
 	depends on DRM_I915
 	select SND_PCM
 	help
-- 
2.25.1



