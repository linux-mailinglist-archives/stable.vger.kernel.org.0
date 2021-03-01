Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79229327B59
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 10:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbhCAJ61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 04:58:27 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:35679 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234399AbhCAJ4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 04:56:50 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 63CFD1940B35;
        Mon,  1 Mar 2021 04:56:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 04:56:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HPWvO/
        WwKsRoD5n40O+ejeArxqDzloN8V98GlaF4b+I=; b=UavfUC6IAuOrX8OurqDGmB
        GrM4ajBfYAr1EMu62T4xL/dDXIoO3SfP8Pz4a97pA8hBPRf0jjvNgmKaWG61C1uy
        P/oDd1jBFPR7q7j3RfbFh+ZSPIWr+Ln0JHF6hRE8RtBVvfmM3hmUiEtx8vFsI8MF
        GHdyQWv5HDHiEibALuK1NIJaY6HO7NvX6xf4HpNx6ui0VcZvAyEnncZm3XmK4fSa
        eNrZt9mBWvDAyXGImzSQMCdu3FN9MaBjUMNhveBpC3/HH6Y45Sz7nFnYrBkxTYJ9
        A4qWDstzLu1HablZZxmRhlkHS4Cls3ZLohCtObdHPO9+xDytIqx9exQwTcYIB9hw
        ==
X-ME-Sender: <xms:Mbo8YD0KSzzCTyJq5ynXLWCco6fGF0jbZwOkPWKxqXHr8WvGwWpr1w>
    <xme:Mbo8YM8zNduhQGCWn7INps0Vo3OSJNbNe_FIGJUWdThWl-gJ4-Gg6El8YyEURzk0Q
    VtS0lOshwGQTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Mbo8YLvJNcqeXcBbnLH6disy_fPIzBre7yhi-nfixyeGz0aaVdXccg>
    <xmx:Mbo8YHD0cvw1EA4iRM1hGGEOM-ZXSKLNLs-i4afGSCzyJDpo_3QIhQ>
    <xmx:Mbo8YLXB7hTADOw4AejFAddqmZr5u9PysX6qkvmtYo0PQIu4M4JZFQ>
    <xmx:Mbo8YOeU_rZq_TpsuN3AKG4ctt5TNwqExDHsmExd7IUPfU56wDgkKw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DFDDC24005A;
        Mon,  1 Mar 2021 04:56:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] ALSA: usb-audio: Don't avoid stopping the stream at" failed to apply to 5.10-stable tree
To:     tiwai@suse.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 10:55:57 +0100
Message-ID: <161459255713788@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 257d2d7e9e798305d65825cb82b0a7d1c0511e89 Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Sat, 6 Feb 2021 21:30:52 +0100
Subject: [PATCH] ALSA: usb-audio: Don't avoid stopping the stream at
 disconnection

In the later patch, we're going to issue the PCM sync_stop calls at
disconnection.  But currently the USB-audio driver can't handle it
because it has a check of shutdown flag for stopping the URBs.  This
is basically superfluous (the stopping URBs are safe at disconnection
state), so let's drop the check.

Fixes: dc5eafe7787c ("ALSA: usb-audio: Support PCM sync_stop")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210206203052.15606-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 4390075b2c6f..102d53515a76 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -890,9 +890,6 @@ static int stop_urbs(struct snd_usb_endpoint *ep, bool force)
 {
 	unsigned int i;
 
-	if (!force && atomic_read(&ep->chip->shutdown)) /* to be sure... */
-		return -EBADFD;
-
 	if (!force && atomic_read(&ep->running))
 		return -EBUSY;
 
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index dcadf8f164b2..bf5a0f3c1fad 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -270,10 +270,7 @@ static int snd_usb_pcm_sync_stop(struct snd_pcm_substream *substream)
 {
 	struct snd_usb_substream *subs = substream->runtime->private_data;
 
-	if (!snd_usb_lock_shutdown(subs->stream->chip)) {
-		sync_pending_stops(subs);
-		snd_usb_unlock_shutdown(subs->stream->chip);
-	}
+	sync_pending_stops(subs);
 	return 0;
 }
 

