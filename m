Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB4F2C6AB4
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 18:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732241AbgK0Rhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 12:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731915AbgK0Rhm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 12:37:42 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D4CC0613D1
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 09:37:42 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id 64so6355418wra.11
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 09:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KtBR/TP40cdXomaxJbeIXMpwY+gtriM54Agwq01NAlM=;
        b=BBoKdEH1a067Rnn8M2fEsC76lL6HHMY3YHmrH8a7QznUZAMvMifC8Fw/ZOgVdp6rpA
         fpGnwvJB2kspMSpdsnBnNrfhWN4xFv6y7WRLUXghXuJaWUbHh5BqF2VjAh98146ZqygJ
         LgOEdM3KzfsCGM+P/ox0PwrLtRfcmOhfmOqAeK54fltBURU6kInH5hx5NY7R5MJI4G0T
         u/Qf/GxRn1xIv2aFdKUB0Or74MMcMKnTvL4k4kaFWNyX8C/T467ETbfTCdrTh+MUJSTh
         XxXvcgA54GGNF+5kYzf3NHJPtWM35qWrHcEPIsOKHZptWyR3smPxXCgN+5wp70BN4qTL
         RigA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KtBR/TP40cdXomaxJbeIXMpwY+gtriM54Agwq01NAlM=;
        b=sAcRZRuIMfUzHQZmgMQrWJNNPkPbftLE8fA6buHHzzCOo7WAvwhoET6ohDZV/ItqFE
         bw93YqpPaNgWZr49+S8Liyjy/5ciFECbja8TuNBsMzElz9UYEJweWwjDTFQR4Gmmdzla
         77lafu2x9cUw9MEyi7IywCCDPzhAAv09jJ6XGeF4YZGlTMKe0fpln7zl4jQDTH1DAqGJ
         NXei+VYH4piy/pYNSicMIlXoIBQF4HkfGKFnXmfpQVbMcPcMG2Pm8sLcVdkldTTXkTr0
         8Nu3AsyxQcPT0UIYmYOOUr1TOyAThCmK+4YLpUTPX/1GvZyvf01ccFkJwy++MS5xw1TR
         sqNA==
X-Gm-Message-State: AOAM532AmXzBjVwdSn6jRneS64OWZsr3lHtKmqsvJvYd7rFkbF6ACHyt
        k5WcXvm8J04VDVDDA839j/9YQqpiXMGSRw==
X-Google-Smtp-Source: ABdhPJyHYhddNMQkv/aCSorwqhmhvDozoFIZkyuzn8z1x370sSz7PS6V5IIQwv6EpKfh3LEHRo/EXw==
X-Received: by 2002:adf:f9c5:: with SMTP id w5mr12030291wrr.69.1606498661309;
        Fri, 27 Nov 2020 09:37:41 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id k81sm26172776wma.2.2020.11.27.09.37.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Nov 2020 09:37:40 -0800 (PST)
Date:   Fri, 27 Nov 2020 17:37:38 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     kai.vehmanen@linux.intel.com, stable@vger.kernel.org, tiwai@suse.de
Subject: Re: FAILED: patch "[PATCH] ALSA: hda/hdmi: fix incorrect locking in
 hdmi_pcm_close" failed to apply to 4.19-stable tree
Message-ID: <20201127173738.mvg5vamgc2v6zrrr@debian>
References: <1602933698101166@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ibjt4kzc6jnpl45w"
Content-Disposition: inline
In-Reply-To: <1602933698101166@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ibjt4kzc6jnpl45w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sat, Oct 17, 2020 at 01:21:38PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--ibjt4kzc6jnpl45w
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-ALSA-hda-hdmi-fix-incorrect-locking-in-hdmi_pcm_clos.patch"

From df2cb010461bb17851b0d1bb698f687d1a2ad5ce Mon Sep 17 00:00:00 2001
From: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Date: Tue, 13 Oct 2020 18:26:28 +0300
Subject: [PATCH] ALSA: hda/hdmi: fix incorrect locking in hdmi_pcm_close

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
index 708efb9b4387..f86b9b0a0607 100644
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


--ibjt4kzc6jnpl45w--
