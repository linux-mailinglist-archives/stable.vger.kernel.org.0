Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E923C3BFE
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbhGKLu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:50:57 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:50063 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKLu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 07:50:57 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id A61FF1940929;
        Sun, 11 Jul 2021 07:48:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 07:48:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+ezXyH
        LFNOyPx56x1/yGkOBb947N0ySHDSY2ZFyqTmw=; b=HVwhXicupQHBrPe9DcpRs1
        gv1F/xEUQnSrK2mvjrc8gWpymgI5xtJW07dGEswQEdBpdORHWzXrRfugpPpXmXge
        u2a15JhIO3ALHh6y1UTEstPEgv8QpGe1sKDGRLHLhiP8Snn88tddISTgHhVANLEo
        aIo671tB1FIj9FMqWkbpl7Q9XrhGVHZXK5G/kl6VW8aQBjK8aBkuCHuayfvjaGr7
        qbQkV1PAlx8Zq1NAWjTBS5TsmZHVdvgvv9duYNiGjSqSsLmBuc3OCFc5EVXNGn8M
        6QKFBcSiE4DQLbvUxwAwDPWgU2+ab25Q+h4WvJaIYMvOqQYeoLXb2y/HISA29kdA
        ==
X-ME-Sender: <xms:etrqYCUxch45IuyKR-JpQYGo4diEZGYApVUpLYAXcA4j7Uq_xTG-Iw>
    <xme:etrqYOlG2Do9oNefYsBqa4sOW_bjfcOg5M-LUJMSvjU2154GilJqsiptySGp-WnRc
    8_m6ODs6GRVfQ>
X-ME-Received: <xmr:etrqYGbf98FvB_K46kytrGZczx5nZqUYwiRI2sArT7UhTauXuAVGMmJZSaGxLpw9HoIxsuh-DvmGGhTK_1XQL99WGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:etrqYJUuK_QCEUuACb2Nk4qMxxKtofRgf0V-Rgvo-D4yxMlXHR2PxQ>
    <xmx:etrqYMl33CVagabzRaBAmo5Mkk16x60QnOnAGWVrYIQdMXMq14PsuQ>
    <xmx:etrqYOcysG7dluJaVagT8rB3VNZwdgG_YDtCLrMFSPn3QIjkvUM06g>
    <xmx:etrqYIuXX63a_ymuqTSxdz-bokV_8hFxvA_2ywTjf4Zg_ubh_Uc2Pw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 07:48:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: usb-audio: Fix OOB access at proc output" failed to apply to 4.4-stable tree
To:     tiwai@suse.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 13:48:01 +0200
Message-ID: <16260040819250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 362372ceb6556f338e230f2d90af27b47f82365a Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Tue, 22 Jun 2021 11:06:47 +0200
Subject: [PATCH] ALSA: usb-audio: Fix OOB access at proc output

At extending the available mixer values for 32bit types, we forgot to
add the corresponding entries for the format dump in the proc output.
This may result in OOB access.  Here adds the missing entries.

Fixes: bc18e31c3042 ("ALSA: usb-audio: Fix parameter block size for UAC2 control requests")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210622090647.14021-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 428d581f988f..4ea4875abdf8 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3294,8 +3294,9 @@ static void snd_usb_mixer_dump_cval(struct snd_info_buffer *buffer,
 				    struct usb_mixer_elem_list *list)
 {
 	struct usb_mixer_elem_info *cval = mixer_elem_list_to_info(list);
-	static const char * const val_types[] = {"BOOLEAN", "INV_BOOLEAN",
-				    "S8", "U8", "S16", "U16"};
+	static const char * const val_types[] = {
+		"BOOLEAN", "INV_BOOLEAN", "S8", "U8", "S16", "U16", "S32", "U32",
+	};
 	snd_iprintf(buffer, "    Info: id=%i, control=%i, cmask=0x%x, "
 			    "channels=%i, type=\"%s\"\n", cval->head.id,
 			    cval->control, cval->cmask, cval->channels,

