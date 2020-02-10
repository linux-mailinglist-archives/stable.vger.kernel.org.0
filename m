Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51853157AA8
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgBJNYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:24:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728629AbgBJMhG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:06 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BBAB24671;
        Mon, 10 Feb 2020 12:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338225;
        bh=4IQ5zJE4sySLZcYqiaJgyRjIxTmR+KHTVtfdhSk4Ubo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jC4G8TTG3Y8Yufd9Qf0a+5pWiOnx+l8Wfd5RiCk/Pj+/QwcPZo2kvOJs243djQv3Z
         0iJPpmLX7u8SdjwPDVUMqhIbop5U9IL0GzOPPMS1cVg3ysYy28kpMo/ZtFG2vh/XT/
         oIVcTRO9wzdZCW+xjDIbmhcfdcSLPJogU8K+v8QU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Zhi <yong.zhi@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 064/309] ALSA: hda: Add JasperLake PCI ID and codec vid
Date:   Mon, 10 Feb 2020 04:30:20 -0800
Message-Id: <20200210122412.087485940@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Zhi <yong.zhi@intel.com>

commit 78be2228c15dd45865b102b29d72e721f0ace9b1 upstream.

Add HD Audio Device PCI ID and codec vendor_id for the Intel JasperLake
REV2/A0 silicon.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200131204003.10153-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c  |    2 ++
 sound/pci/hda/patch_hdmi.c |    1 +
 2 files changed, 3 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2417,6 +2417,8 @@ static const struct pci_device_id azx_id
 	/* Jasperlake */
 	{ PCI_DEVICE(0x8086, 0x38c8),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	{ PCI_DEVICE(0x8086, 0x4dc8),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
 	/* Tigerlake */
 	{ PCI_DEVICE(0x8086, 0xa0c8),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4153,6 +4153,7 @@ HDA_CODEC_ENTRY(0x8086280c, "Cannonlake
 HDA_CODEC_ENTRY(0x8086280d, "Geminilake HDMI",	patch_i915_glk_hdmi),
 HDA_CODEC_ENTRY(0x8086280f, "Icelake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x80862812, "Tigerlake HDMI",	patch_i915_tgl_hdmi),
+HDA_CODEC_ENTRY(0x8086281a, "Jasperlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x80862880, "CedarTrail HDMI",	patch_generic_hdmi),
 HDA_CODEC_ENTRY(0x80862882, "Valleyview2 HDMI",	patch_i915_byt_hdmi),
 HDA_CODEC_ENTRY(0x80862883, "Braswell HDMI",	patch_i915_byt_hdmi),


