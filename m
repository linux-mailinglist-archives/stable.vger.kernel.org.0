Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959A829119B
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 13:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437372AbgJQLXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 07:23:45 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:56909 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726821AbgJQLUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 07:20:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2B3BD1940D3C;
        Sat, 17 Oct 2020 07:20:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 17 Oct 2020 07:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=MGj/3M
        tONQrwTfnpkw15GvWnNYw8Vy2BRLIoA8hZhfA=; b=jJRpbYIUTN76s0wlzgsHlx
        FaUcgpeNTjIVFjMp/pVu6gOHuQlsHQwKDqeMgnQFdnCXNRpyEUl6SpR2YOggiH18
        0RXIim5QXXpZG02EPcTiVG1HPOCkf21mM3Krt90Ijr5fC7ol6KWrR+jS+WIZfzK8
        t5+fuxMQviJreKsyQD8QHFHzck17rjb9eREyetR/uxD7+EzK9byMBanuxFePVHOS
        +4+LOxat8/ogexqfsqj2s71GU2w9gD1x1R3gN8nHh7iNBxkh2k0krE24PauhGCE4
        c3h1nV+rnGFoYxCJ12jA2shLARng1IpNn5tfuekQoagKQ9mTIbJKIG68XgP9FxTA
        ==
X-ME-Sender: <xms:jtOKX6-uiTZxe-m3xm0oUyB_U4Ad3F-s46hLeCvX0vdjI240Rl4RZw>
    <xme:jtOKX6u22v5ggE1rNX5VfIhrRUvNSELkB2Us0UKby-fEdG-Kavd0Uh684tDGEf6k0
    fKboUfbbVboyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrieejgdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:jtOKXwDBQapYi-PPeV32DeZSaAlxcPHVX3FOShio75GmcT3dF0o6WA>
    <xmx:jtOKXyeZSMLT_dMf6ciUg6-5tgDsbtrKnYC-yYJG8ZhoVcVLyI-25Q>
    <xmx:jtOKX_MDujABSMIDgZwxicatwNqDmuZ6zdxqf05zWMTZQNo4wsp_Qg>
    <xmx:j9OKXxX-pdatO6UKkscqVnqOrSje2lpeYTjOzcLCdsBIb1J_-TqykQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 704E6328005A;
        Sat, 17 Oct 2020 07:20:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hda/hdmi: fix incorrect locking in hdmi_pcm_close" failed to apply to 4.9-stable tree
To:     kai.vehmanen@linux.intel.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 17 Oct 2020 13:21:37 +0200
Message-ID: <16029336977950@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ce1558c285f9ad04c03b46833a028230771cc0a7 Mon Sep 17 00:00:00 2001
From: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Date: Tue, 13 Oct 2020 18:26:28 +0300
Subject: [PATCH] ALSA: hda/hdmi: fix incorrect locking in hdmi_pcm_close

A race exists between closing a PCM and update of ELD data. In
hdmi_pcm_close(), hinfo->nid value is modified without taking
spec->pcm_lock. If this happens concurrently while processing an ELD
update in hdmi_pcm_setup_pin(), converter assignment may be done
incorrectly.

This bug was found by hitting a WARN_ON in snd_hda_spdif_ctls_assign()
in a HDMI receiver connection stress test:

[2739.684569] WARNING: CPU: 5 PID: 2090 at sound/pci/hda/patch_hdmi.c:1898 check_non_pcm_per_cvt+0x41/0x50 [snd_hda_codec_hdmi]
...
[2739.684707] Call Trace:
[2739.684720]  update_eld+0x121/0x5a0 [snd_hda_codec_hdmi]
[2739.684736]  hdmi_present_sense+0x21e/0x3b0 [snd_hda_codec_hdmi]
[2739.684750]  check_presence_and_report+0x81/0xd0 [snd_hda_codec_hdmi]
[2739.684842]  intel_audio_codec_enable+0x122/0x190 [i915]

Fixes: 42b2987079ec ("ALSA: hda - hdmi playback without monitor in dynamic pcm bind mode")
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201013152628.920764-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 0ffbfcb91256..ccd1df059654 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2046,22 +2046,25 @@ static int hdmi_pcm_close(struct hda_pcm_stream *hinfo,
 	int pinctl;
 	int err = 0;
 
+	mutex_lock(&spec->pcm_lock);
 	if (hinfo->nid) {
 		pcm_idx = hinfo_to_pcm_index(codec, hinfo);
-		if (snd_BUG_ON(pcm_idx < 0))
-			return -EINVAL;
+		if (snd_BUG_ON(pcm_idx < 0)) {
+			err = -EINVAL;
+			goto unlock;
+		}
 		cvt_idx = cvt_nid_to_cvt_index(codec, hinfo->nid);
-		if (snd_BUG_ON(cvt_idx < 0))
-			return -EINVAL;
+		if (snd_BUG_ON(cvt_idx < 0)) {
+			err = -EINVAL;
+			goto unlock;
+		}
 		per_cvt = get_cvt(spec, cvt_idx);
-
 		snd_BUG_ON(!per_cvt->assigned);
 		per_cvt->assigned = 0;
 		hinfo->nid = 0;
 
 		azx_stream(get_azx_dev(substream))->stripe = 0;
 
-		mutex_lock(&spec->pcm_lock);
 		snd_hda_spdif_ctls_unassign(codec, pcm_idx);
 		clear_bit(pcm_idx, &spec->pcm_in_use);
 		pin_idx = hinfo_to_pin_index(codec, hinfo);
@@ -2091,10 +2094,11 @@ static int hdmi_pcm_close(struct hda_pcm_stream *hinfo,
 		per_pin->setup = false;
 		per_pin->channels = 0;
 		mutex_unlock(&per_pin->lock);
-	unlock:
-		mutex_unlock(&spec->pcm_lock);
 	}
 
+unlock:
+	mutex_unlock(&spec->pcm_lock);
+
 	return err;
 }
 

