Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C461F9B68
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbgFOPFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:05:33 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:53335 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730213AbgFOPFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:05:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 687B54AC;
        Mon, 15 Jun 2020 11:05:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:05:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tfizSa
        Z4a25UiEboLqgjMGqp282QeKsXxEt/kKEEKgA=; b=XPfibn4HlGkkqV7kKpNgSc
        WuMi897ctrPSObWHMqH5zG7IrRqp11xNOqXSTcPmMWZIRrmotfw1Ym+Oezy8CoIm
        Mz9cqarH7lf5+R+C7RysDQJWdxqKI8sTJGzGmFyAjmE/aBtCmu8J8CImIWTxkeh/
        VegrkOVqmMeLjshrzPxDmzi+k/vTbOb1/1s1sGW/L07OOm6j73eBDYIT77SAYgnw
        dkvodf0WDcl1UnIIdqWVMrQoiH5EoaqMBSQWUqvL3R7/4OFVE434XA2jvJr04cVE
        A0Qvw/YG79n6hlUkTOlSnguZLRNTfidGAy9jfr5dPJ+sSocKHPG07jPVI52+G2Ew
        ==
X-ME-Sender: <xms:O47nXkZmyq1HVLHd9NfyW6rkYEDHmubaHN_FxTZFC_7zC4rQ6XvHlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:O47nXvaLjhtkorlhIeRElIHS65r-pnjqJ61SX6PUKHW90sBX1MIEHw>
    <xmx:O47nXu_zmB_-v3N53Ev4rl7pw_lBUQG3OcqZm59h-xhiXTHbQB75NQ>
    <xmx:O47nXuoCgEaKFF94eg-nxw2kFyJtC07_suAvd4dw4bV3mP3dWZHQWQ>
    <xmx:PI7nXpEHoIr8Pc8FOAdFNCqaRJi2vbWRNBVISj0OR24nM4mNLtd4kjbEfRc>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D2C23060F09;
        Mon, 15 Jun 2020 11:05:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: pcm: disallow linking stream to itself" failed to apply to 4.9-stable tree
To:     mirq-linux@rere.qmqm.pl, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:05:12 +0200
Message-ID: <1592233512151187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 951e2736f4b11b58dc44d41964fa17c3527d882a Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Date: Mon, 8 Jun 2020 18:50:39 +0200
Subject: [PATCH] ALSA: pcm: disallow linking stream to itself
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Prevent SNDRV_PCM_IOCTL_LINK linking stream to itself - the code
can't handle it. Fixed commit is not where bug was introduced, but
changes the context significantly.

Cc: stable@vger.kernel.org
Fixes: 0888c321de70 ("pcm_native: switch to fdget()/fdput()")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/89c4a2487609a0ed6af3ecf01cc972bdc59a7a2d.1591634956.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index c08732998a42..eeab8850ed76 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2176,6 +2176,12 @@ static int snd_pcm_link(struct snd_pcm_substream *substream, int fd)
 	}
 	pcm_file = f.file->private_data;
 	substream1 = pcm_file->substream;
+
+	if (substream == substream1) {
+		res = -EINVAL;
+		goto _badf;
+	}
+
 	group = kzalloc(sizeof(*group), GFP_KERNEL);
 	if (!group) {
 		res = -ENOMEM;

