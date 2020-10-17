Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1208E29119D
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 13:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437367AbgJQLXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 07:23:47 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:46865 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726686AbgJQLU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 07:20:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3B1C51940D61;
        Sat, 17 Oct 2020 07:20:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 17 Oct 2020 07:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uac5rk
        HpYbecuioXHbTC7VoY7pK9q58n47dPdxGbHi0=; b=SvemSCxeGaFQleFyKu+uih
        NDRMG42IcufguP3CrWX93PHyLbd+siKSh+ZGHBeWlpQrBTcJemtf07GUef5R6gPX
        aKaLgPw/h61z4JtPt6HWlH14KByHxtM43lhZ9IcqQWTpMzKvvoSf1wy0VnzWFai2
        5ldPSqcqSO7N8NBBdDZMIofVRxTMY3gBIq11OoupSkdxid+rGc69RUds6Jou11j0
        7qv4VJmwHufnykTtAbQoq5djzqdscEe814DQjKssFxZRogHT1ytESaj8X1cW/SA/
        ui0MYCItpIOg1xKtTVYi+brTvKXRX3xwT74AoQTADREGQCZWfhYoloXpS8IqxnFQ
        ==
X-ME-Sender: <xms:mNOKX6TnCggdE-7bm3By0_hMfUjFRdbNGh_2DSLWnlO_IXoSKoZm-g>
    <xme:mNOKX_wU6EPzWen0tOXubNn3lUEUFiiyn2Uwa7xA6gqGSo50KdY4Grvh28tRgUjm7
    CboQgkFWDrtKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrieejgdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:mNOKX32vW0QFtrdtJMOyqwx5jbqG4BBlvBiy18rSqEQbXleXz0UPEg>
    <xmx:mNOKX2By0-w0KhZlvxhbA4dg-d5y9tnoKwriSF9MpcrHP2qHI4jI5w>
    <xmx:mNOKXzi3jbtATEd6JOjQ2uyjx4g4CO-HEMGqK-1ykxBElqeLsVkuwQ>
    <xmx:mNOKXzJfLuplxubhJXMtUBFzwlv2Z0FBO7y2ykMBngLsIk66-xKGQQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C9E2D306467D;
        Sat, 17 Oct 2020 07:20:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hda/hdmi: fix incorrect locking in hdmi_pcm_close" failed to apply to 4.14-stable tree
To:     kai.vehmanen@linux.intel.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 17 Oct 2020 13:21:37 +0200
Message-ID: <160293369792177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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
 

