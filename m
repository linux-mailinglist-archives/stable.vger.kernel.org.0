Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2494E46A9C4
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351013AbhLFVT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350840AbhLFVTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:19:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C010C061D7E;
        Mon,  6 Dec 2021 13:16:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2653EB8110F;
        Mon,  6 Dec 2021 21:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48501C341C1;
        Mon,  6 Dec 2021 21:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825370;
        bh=0gv2sLSslX98X/4SZB+5tTFVgXgHd1/5d63Lh6cc4FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6eaRhx6nP58nd0WdKQvxTPr0ajAA8S0xRt1lDkpvkAwDsSoANxnABOehMDi54REE
         dcQWw2rH7nm4fTA5vtfXMwcvZWowiPDJBTzx/ZVnJ8EPh7JTvMIrTSwqHK50x5IeXa
         NXIIdPbwBBUf7ZFEMwhE102Jqhy6Sj2CygNAv1OMgcbpYBoDT6Ghc2AIDmZritsego
         364NZjCXYgS+emKtBcL19rS7KQyHj4NrGo1yFZ5Aev1WN5zdhljjzfUCG+qsFuDY5m
         NT/8l5Ym05uNpRtjiUyq5eGwz4MdANaEGf07ePIrPOISoFnNb/5lvjy+m2IdluEgS6
         uv+rg06DBsZpg==
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
Subject: [PATCH AUTOSEL 5.10 07/15] ALSA: hda: Add Intel DG2 PCI ID and HDMI codec vid
Date:   Mon,  6 Dec 2021 16:15:07 -0500
Message-Id: <20211206211520.1660478-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211520.1660478-1-sashal@kernel.org>
References: <20211206211520.1660478-1-sashal@kernel.org>
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
index 64115a796af06..3cc936f2cbf8d 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -369,7 +369,10 @@ enum {
 					((pci)->device == 0x0c0c) || \
 					((pci)->device == 0x0d0c) || \
 					((pci)->device == 0x160c) || \
-					((pci)->device == 0x490d))
+					((pci)->device == 0x490d) || \
+					((pci)->device == 0x4f90) || \
+					((pci)->device == 0x4f91) || \
+					((pci)->device == 0x4f92))
 
 #define IS_BXT(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0x5a98)
 
@@ -2540,6 +2543,13 @@ static const struct pci_device_id azx_ids[] = {
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
index c65144715af78..7b91615bcac32 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4364,6 +4364,7 @@ HDA_CODEC_ENTRY(0x80862814, "DG1 HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862815, "Alderlake HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x8086281c, "Alderlake-P HDMI", patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862816, "Rocketlake HDMI",	patch_i915_tgl_hdmi),
+HDA_CODEC_ENTRY(0x80862819, "DG2 HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x8086281a, "Jasperlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x8086281b, "Elkhartlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x80862880, "CedarTrail HDMI",	patch_generic_hdmi),
-- 
2.33.0

