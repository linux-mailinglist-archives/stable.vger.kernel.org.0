Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B652C6AC5
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 18:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731755AbgK0Rlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 12:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730603AbgK0Rlj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 12:41:39 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E727AC0613D1
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 09:41:37 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id z7so6390889wrn.3
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 09:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VEGLUub6P4STD9f3eVFsfkognvHK0rHnNq2gOh4qHSs=;
        b=IY6fN13eTpk2hqApP9FMY7skL0+9Z+HBotTCxsFERRTD/tCY1M0TxvEyjmMMbK05si
         qvrdp7Cd5YpaGNQNBLVB1CGFDAf/Aa5dsXnF/SIlTrcD1Qf2mv141m+TAWA+PzToelOm
         gAj4VuFBZrgbO7pXdonNPg8JTzEoHP8E0f8Sw6Rw9sCx8nL2bVVFm1LaScnzvsSkcpvT
         Efqt0GsRnUXK5inelxgW+C+EvAoVUJHrTZ9Ioojz8qN+q84avGSePdsFDrR3K1AqQRWf
         mlmtGLP8G+ii+c6eOUVyaU8FbqCIdTQrPaaF06U5po+a7zQLqMFnHuQxxNCIcJstYG3K
         ylXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VEGLUub6P4STD9f3eVFsfkognvHK0rHnNq2gOh4qHSs=;
        b=Tmhqs4oCbKfmMxKfaeLLT0BB/RJsXzQ5xzdXTf38k98wNTbrevLJ8Vo70/SfYJPqDd
         OgixVv0LhbRKL8Nh4KRjAM62+WoYAkBFGTUVlMmU7VQ4TZCeGBd5GSTiv1fYcMe8ViRn
         LM5CJzVQVBLIuWNrT+Oc+MrgbBk6tyEJZ+tI4oxscA/mfAQrcMmzCr+BLcAMJAKMuh/4
         7l6gm0Y21784IxHoJWVwdzAQVe7peLh9TzN5ObeFOUiqvB2st45Fnps6UMeuxfPceJdL
         TOVRzEYghBajOMQl8hWI2Y7iwb+rCfL47p8g6R5FAAZEZLO++MZbpy7fpJBQtoH8XXTo
         hw8Q==
X-Gm-Message-State: AOAM5306/3jRx/sKft3z4gsj5b61LXftIWFWGZh2oaDTsuK8sljbE8eT
        zzV7P3dDPPXc9g7b7erIAsA=
X-Google-Smtp-Source: ABdhPJwv2ZcHhGlfo+h6MktftxwXwnRk9rO0PJF4K4cp/XKRqlvx7Bz0CqmRnzGik/QWAKl/PPCfgQ==
X-Received: by 2002:a5d:49ce:: with SMTP id t14mr12018273wrs.75.1606498896734;
        Fri, 27 Nov 2020 09:41:36 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id a12sm16654671wrq.58.2020.11.27.09.41.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Nov 2020 09:41:36 -0800 (PST)
Date:   Fri, 27 Nov 2020 17:41:34 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     kai.vehmanen@linux.intel.com, stable@vger.kernel.org, tiwai@suse.de
Subject: Re: FAILED: patch "[PATCH] ALSA: hda/hdmi: fix incorrect locking in
 hdmi_pcm_close" failed to apply to 4.14-stable tree
Message-ID: <20201127174134.5y2a2du37conejaw@debian>
References: <160293369792177@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gy4gkgtueqokw22i"
Content-Disposition: inline
In-Reply-To: <160293369792177@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gy4gkgtueqokw22i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sat, Oct 17, 2020 at 01:21:37PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport and also f69548ffafcc ("ALSA: hda/hdmi: Use single mutex unlock in error paths")
which is only needed to make the backport easier.
This will also apply to 4.9-stable.

--
Regards
Sudip

--gy4gkgtueqokw22i
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-ALSA-hda-hdmi-Use-single-mutex-unlock-in-error-paths.patch"

From 809e5730b91d8258c8fe956011ad242a98072111 Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Thu, 12 Jul 2018 23:06:51 +0200
Subject: [PATCH 1/2] ALSA: hda/hdmi: Use single mutex unlock in error paths

commit f69548ffafcc4942022f16f2f192b24143de1dba upstream

Instead of calling mutex_unlock() at each error path multiple times,
take the standard goto-and-a-single-unlock approach.  This will
simplify the code and make easier to find the unbalanced mutex locks.

No functional changes, but only the code readability improvement as a
preliminary work for further changes.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 sound/pci/hda/patch_hdmi.c | 67 +++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 75bdcede04e6..062aa118991c 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -339,13 +339,13 @@ static int hdmi_eld_ctl_info(struct snd_kcontrol *kcontrol,
 	if (!per_pin) {
 		/* no pin is bound to the pcm */
 		uinfo->count = 0;
-		mutex_unlock(&spec->pcm_lock);
-		return 0;
+		goto unlock;
 	}
 	eld = &per_pin->sink_eld;
 	uinfo->count = eld->eld_valid ? eld->eld_size : 0;
-	mutex_unlock(&spec->pcm_lock);
 
+ unlock:
+	mutex_unlock(&spec->pcm_lock);
 	return 0;
 }
 
@@ -357,6 +357,7 @@ static int hdmi_eld_ctl_get(struct snd_kcontrol *kcontrol,
 	struct hdmi_spec_per_pin *per_pin;
 	struct hdmi_eld *eld;
 	int pcm_idx;
+	int err = 0;
 
 	pcm_idx = kcontrol->private_value;
 	mutex_lock(&spec->pcm_lock);
@@ -365,16 +366,15 @@ static int hdmi_eld_ctl_get(struct snd_kcontrol *kcontrol,
 		/* no pin is bound to the pcm */
 		memset(ucontrol->value.bytes.data, 0,
 		       ARRAY_SIZE(ucontrol->value.bytes.data));
-		mutex_unlock(&spec->pcm_lock);
-		return 0;
+		goto unlock;
 	}
-	eld = &per_pin->sink_eld;
 
+	eld = &per_pin->sink_eld;
 	if (eld->eld_size > ARRAY_SIZE(ucontrol->value.bytes.data) ||
 	    eld->eld_size > ELD_MAX_SIZE) {
-		mutex_unlock(&spec->pcm_lock);
 		snd_BUG();
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock;
 	}
 
 	memset(ucontrol->value.bytes.data, 0,
@@ -382,9 +382,10 @@ static int hdmi_eld_ctl_get(struct snd_kcontrol *kcontrol,
 	if (eld->eld_valid)
 		memcpy(ucontrol->value.bytes.data, eld->eld_buffer,
 		       eld->eld_size);
-	mutex_unlock(&spec->pcm_lock);
 
-	return 0;
+ unlock:
+	mutex_unlock(&spec->pcm_lock);
+	return err;
 }
 
 static const struct snd_kcontrol_new eld_bytes_ctl = {
@@ -1209,8 +1210,8 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
 	pin_idx = hinfo_to_pin_index(codec, hinfo);
 	if (!spec->dyn_pcm_assign) {
 		if (snd_BUG_ON(pin_idx < 0)) {
-			mutex_unlock(&spec->pcm_lock);
-			return -EINVAL;
+			err = -EINVAL;
+			goto unlock;
 		}
 	} else {
 		/* no pin is assigned to the PCM
@@ -1218,16 +1219,13 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
 		 */
 		if (pin_idx < 0) {
 			err = hdmi_pcm_open_no_pin(hinfo, codec, substream);
-			mutex_unlock(&spec->pcm_lock);
-			return err;
+			goto unlock;
 		}
 	}
 
 	err = hdmi_choose_cvt(codec, pin_idx, &cvt_idx);
-	if (err < 0) {
-		mutex_unlock(&spec->pcm_lock);
-		return err;
-	}
+	if (err < 0)
+		goto unlock;
 
 	per_cvt = get_cvt(spec, cvt_idx);
 	/* Claim converter */
@@ -1264,12 +1262,11 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
 			per_cvt->assigned = 0;
 			hinfo->nid = 0;
 			snd_hda_spdif_ctls_unassign(codec, pcm_idx);
-			mutex_unlock(&spec->pcm_lock);
-			return -ENODEV;
+			err = -ENODEV;
+			goto unlock;
 		}
 	}
 
-	mutex_unlock(&spec->pcm_lock);
 	/* Store the updated parameters */
 	runtime->hw.channels_min = hinfo->channels_min;
 	runtime->hw.channels_max = hinfo->channels_max;
@@ -1278,7 +1275,9 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
 
 	snd_pcm_hw_constraint_step(substream->runtime, 0,
 				   SNDRV_PCM_HW_PARAM_CHANNELS, 2);
-	return 0;
+ unlock:
+	mutex_unlock(&spec->pcm_lock);
+	return err;
 }
 
 /*
@@ -1876,7 +1875,7 @@ static int generic_hdmi_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	bool non_pcm;
 	int pinctl;
-	int err;
+	int err = 0;
 
 	mutex_lock(&spec->pcm_lock);
 	pin_idx = hinfo_to_pin_index(codec, hinfo);
@@ -1888,13 +1887,12 @@ static int generic_hdmi_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
 		pin_cvt_fixup(codec, NULL, cvt_nid);
 		snd_hda_codec_setup_stream(codec, cvt_nid,
 					stream_tag, 0, format);
-		mutex_unlock(&spec->pcm_lock);
-		return 0;
+		goto unlock;
 	}
 
 	if (snd_BUG_ON(pin_idx < 0)) {
-		mutex_unlock(&spec->pcm_lock);
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock;
 	}
 	per_pin = get_pin(spec, pin_idx);
 	pin_nid = per_pin->pin_nid;
@@ -1933,6 +1931,7 @@ static int generic_hdmi_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
 	/* snd_hda_set_dev_select() has been called before */
 	err = spec->ops.setup_stream(codec, cvt_nid, pin_nid,
 				 stream_tag, format);
+ unlock:
 	mutex_unlock(&spec->pcm_lock);
 	return err;
 }
@@ -1954,6 +1953,7 @@ static int hdmi_pcm_close(struct hda_pcm_stream *hinfo,
 	struct hdmi_spec_per_cvt *per_cvt;
 	struct hdmi_spec_per_pin *per_pin;
 	int pinctl;
+	int err = 0;
 
 	if (hinfo->nid) {
 		pcm_idx = hinfo_to_pcm_index(codec, hinfo);
@@ -1972,14 +1972,12 @@ static int hdmi_pcm_close(struct hda_pcm_stream *hinfo,
 		snd_hda_spdif_ctls_unassign(codec, pcm_idx);
 		clear_bit(pcm_idx, &spec->pcm_in_use);
 		pin_idx = hinfo_to_pin_index(codec, hinfo);
-		if (spec->dyn_pcm_assign && pin_idx < 0) {
-			mutex_unlock(&spec->pcm_lock);
-			return 0;
-		}
+		if (spec->dyn_pcm_assign && pin_idx < 0)
+			goto unlock;
 
 		if (snd_BUG_ON(pin_idx < 0)) {
-			mutex_unlock(&spec->pcm_lock);
-			return -EINVAL;
+			err = -EINVAL;
+			goto unlock;
 		}
 		per_pin = get_pin(spec, pin_idx);
 
@@ -1998,10 +1996,11 @@ static int hdmi_pcm_close(struct hda_pcm_stream *hinfo,
 		per_pin->setup = false;
 		per_pin->channels = 0;
 		mutex_unlock(&per_pin->lock);
+	unlock:
 		mutex_unlock(&spec->pcm_lock);
 	}
 
-	return 0;
+	return err;
 }
 
 static const struct hda_pcm_ops generic_ops = {
-- 
2.11.0


--gy4gkgtueqokw22i
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-ALSA-hda-hdmi-fix-incorrect-locking-in-hdmi_pcm_clos.patch"

From 613a942e4b0013fb217ae1af9b4d70598d8aed9a Mon Sep 17 00:00:00 2001
From: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Date: Tue, 13 Oct 2020 18:26:28 +0300
Subject: [PATCH 2/2] ALSA: hda/hdmi: fix incorrect locking in hdmi_pcm_close

commit ce1558c285f9ad04c03b46833a028230771cc0a7 upstream

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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 sound/pci/hda/patch_hdmi.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 062aa118991c..21d9b7d96eb0 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1955,20 +1955,23 @@ static int hdmi_pcm_close(struct hda_pcm_stream *hinfo,
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
 
-		mutex_lock(&spec->pcm_lock);
 		snd_hda_spdif_ctls_unassign(codec, pcm_idx);
 		clear_bit(pcm_idx, &spec->pcm_in_use);
 		pin_idx = hinfo_to_pin_index(codec, hinfo);
@@ -1996,10 +1999,11 @@ static int hdmi_pcm_close(struct hda_pcm_stream *hinfo,
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
 
-- 
2.11.0


--gy4gkgtueqokw22i--
