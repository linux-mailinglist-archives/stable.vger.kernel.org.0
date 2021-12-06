Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E4B46A993
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350426AbhLFVSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350476AbhLFVRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:17:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984A3C061746;
        Mon,  6 Dec 2021 13:13:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B07CB815A0;
        Mon,  6 Dec 2021 21:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAF6C341CB;
        Mon,  6 Dec 2021 21:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825229;
        bh=DZXMIF+OEY1uELNTkn4ftoL8YdEPy7GtZ/kmBT6WmGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nNjOnks3FNYEU0fxhdBqc1toQ/iN5YG7yVe5NaqifE/FGb44veFaam7x2jQ7gZORC
         Bqg9S+AmbCdvZq28QR7P/ABOGqjhK739DPbl6bHsgNWrRzIihaShynhR7h0oIPdBrU
         zd/gf2ommbeqvtMiKWDucEvOU3HWqh24P7M+6nejz/rbxvlC4QaxEaNY7U6GqSTeTn
         RZIDU+8eIHNwMEo/F7ED6WnN7q4COSLT1BCKx1ZEcVhHz4Lpl3JXnzjaSP9DR0/TUM
         fgj8+qVVMmOL7UvgYo1dDxHlEuDHoC6d8LPyoyTVXVgryodB4wjDcM5z0gv35WMmVK
         JsFBZVdKbiqng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com,
        pierre-louis.bossart@linux.intel.com, broonie@kernel.org,
        imre.deak@intel.com, leon@kernel.org,
        ranjani.sridharan@linux.intel.com,
        guennadi.liakhovetski@linux.intel.com, hui.wang@canonical.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 11/24] ALSA: hda: Add Intel DG2 PCI ID and HDMI codec vid
Date:   Mon,  6 Dec 2021 16:12:16 -0500
Message-Id: <20211206211230.1660072-11-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211230.1660072-1-sashal@kernel.org>
References: <20211206211230.1660072-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit d85ffff5302b1509efc482e8877c253b0a668b33 ]

Add HD Audio PCI ID and HDMI codec vendor ID for Intel DG2.

Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20211130124732.696896-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c  | 12 +++++++++++-
 sound/pci/hda/patch_hdmi.c |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 90e9263ac0bd7..21fec82489bd7 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -335,7 +335,10 @@ enum {
 					((pci)->device == 0x0c0c) || \
 					((pci)->device == 0x0d0c) || \
 					((pci)->device == 0x160c) || \
-					((pci)->device == 0x490d))
+					((pci)->device == 0x490d) || \
+					((pci)->device == 0x4f90) || \
+					((pci)->device == 0x4f91) || \
+					((pci)->device == 0x4f92))
 
 #define IS_BXT(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0x5a98)
 
@@ -2472,6 +2475,13 @@ static const struct pci_device_id azx_ids[] = {
 	/* DG1 */
 	{ PCI_DEVICE(0x8086, 0x490d),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	/* DG2 */
+	{ PCI_DEVICE(0x8086, 0x4f90),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	{ PCI_DEVICE(0x8086, 0x4f91),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	{ PCI_DEVICE(0x8086, 0x4f92),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
 	/* Alderlake-S */
 	{ PCI_DEVICE(0x8086, 0x7ad0),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 65d2c55399195..98633d2684deb 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4382,6 +4382,7 @@ HDA_CODEC_ENTRY(0x80862814, "DG1 HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862815, "Alderlake HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x8086281c, "Alderlake-P HDMI", patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862816, "Rocketlake HDMI",	patch_i915_tgl_hdmi),
+HDA_CODEC_ENTRY(0x80862819, "DG2 HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x8086281a, "Jasperlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x8086281b, "Elkhartlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x80862880, "CedarTrail HDMI",	patch_generic_hdmi),
-- 
2.33.0

