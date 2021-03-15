Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF28833C71B
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 20:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhCOTvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 15:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbhCOTvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 15:51:38 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3209C06174A
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 12:51:37 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r15-20020a05600c35cfb029010e639ca09eso96848wmq.1
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 12:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RZCydtwSTz5P1aHRrcKDXD2GUombEQlWbGL0p8DHBdk=;
        b=ruKLpLm9ig/tjxFqGmdH+Ize0JbcsjTn/h1HVA1WaVt9dBZpS/+YbbKZvAsgl7R7Bu
         uSHi3ECffnbsQvCsrLrTL3jJIFtcl/AoJi+3YxcOqu0It55/H1cw2rT3W/t+CS+ByR1g
         W+WerFt3i+vdkAYTfjoJazGVoZ8UVLV7j7GMIbGl1c0iKI3JN4tqkTYRgpcVY7vNRUBD
         wyZkVh3MyysyUvpIBjAHbeXb6akDOpxfTqN0jlX3s3QynVTfP0oTtK4mM2jdS8K3x++n
         S0glw5gFy53ZCgNrVZ+DNt489YQopsOSYX3PhhKOin0d4zsbbf6DYuB5fmCH91Zh4i8A
         9A+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RZCydtwSTz5P1aHRrcKDXD2GUombEQlWbGL0p8DHBdk=;
        b=mynOjtK20e2jKIar7T9Qz+l9hKrJyWaJmyv1H9LhOV5q6rilRcQwZRk5E7reGZmNdK
         rdrmoktKKfvrCld3JIdijEx250iVWHSzV/bUuXLABJrAI/lU/88kck9GYLGNS9Q/Cp3m
         rWoAQX0yyU41WC9WQPZQipEtb792zE/0npr5QJlOoqrK2XU+qsft1ADuqLeu4Wge+E3Z
         S6pyl/F7oL7VGX5Ykcfp3mLQCAerawsuO/TJSCwxndD5iJMl9rrUVn/wAzZwVumN18If
         QmVPKKNw58K/Qr0uK4X47JyF7Do3ghwh6RfEDhgcV7Ac/4E5+hMbJCXUyvWmD/G8XBdE
         reqw==
X-Gm-Message-State: AOAM531FEKiKaFtrIiSEmpXalV+5e/VPnT6fudCrwsTND1GCijDvlv7n
        bOE+XvHp/7VS2G1CtDPqSTXvGHiGGpTnQQ==
X-Google-Smtp-Source: ABdhPJxrvYpMKFzyqK9b8PZyr6KiXnRmJ5d5JiyG4QdmmMigMWUoyGNZRMP/87h1nTtTGmEvUc0X3w==
X-Received: by 2002:a1c:b48a:: with SMTP id d132mr1221592wmf.108.1615837896712;
        Mon, 15 Mar 2021 12:51:36 -0700 (PDT)
Received: from debian (host-2-99-153-254.as13285.net. [2.99.153.254])
        by smtp.gmail.com with ESMTPSA id q4sm669922wma.20.2021.03.15.12.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 12:51:36 -0700 (PDT)
Date:   Mon, 15 Mar 2021 19:51:34 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     tiwai@suse.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ALSA: usb-audio: Don't avoid stopping the
 stream at" failed to apply to 5.10-stable tree
Message-ID: <YE+6xtgW4Jq+c14P@debian>
References: <161459255713788@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tqu8x/a0UyCtl9G1"
Content-Disposition: inline
In-Reply-To: <161459255713788@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tqu8x/a0UyCtl9G1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Mar 01, 2021 at 10:55:57AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--tqu8x/a0UyCtl9G1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-ALSA-usb-audio-Don-t-avoid-stopping-the-stream-at-di.patch"

From 7005e6a6d911d3e2f42802ba80b894b49b43cb72 Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Sat, 6 Feb 2021 21:30:52 +0100
Subject: [PATCH] ALSA: usb-audio: Don't avoid stopping the stream at
 disconnection

commit 257d2d7e9e798305d65825cb82b0a7d1c0511e89 upstream

In the later patch, we're going to issue the PCM sync_stop calls at
disconnection.  But currently the USB-audio driver can't handle it
because it has a check of shutdown flag for stopping the URBs.  This
is basically superfluous (the stopping URBs are safe at disconnection
state), so let's drop the check.

Fixes: dc5eafe7787c ("ALSA: usb-audio: Support PCM sync_stop")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210206203052.15606-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 sound/usb/endpoint.c | 3 ---
 sound/usb/pcm.c      | 5 +----
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index e2f9ce2f5b8b..8527267725bb 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -576,9 +576,6 @@ static int deactivate_urbs(struct snd_usb_endpoint *ep, bool force)
 {
 	unsigned int i;
 
-	if (!force && atomic_read(&ep->chip->shutdown)) /* to be sure... */
-		return -EBADFD;
-
 	clear_bit(EP_FLAG_RUNNING, &ep->flags);
 
 	INIT_LIST_HEAD(&ep->ready_playback_urbs);
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 1b08f52ef86f..f4494d054917 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -280,10 +280,7 @@ static int snd_usb_pcm_sync_stop(struct snd_pcm_substream *substream)
 {
 	struct snd_usb_substream *subs = substream->runtime->private_data;
 
-	if (!snd_usb_lock_shutdown(subs->stream->chip)) {
-		sync_pending_stops(subs);
-		snd_usb_unlock_shutdown(subs->stream->chip);
-	}
+	sync_pending_stops(subs);
 	return 0;
 }
 
-- 
2.30.1


--tqu8x/a0UyCtl9G1--
