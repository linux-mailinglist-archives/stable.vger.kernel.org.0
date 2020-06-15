Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E851F9B6A
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbgFOPFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:05:38 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:40925 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730800AbgFOPFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:05:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id AA443427;
        Mon, 15 Jun 2020 11:05:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:05:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=98zLKY
        AasT2N7N16DG1FTk1nt4Jm8q8O80MKG0yZwME=; b=bkm1kZZ+AKJsSS7h/kN3gx
        +750n935CUVTQ6bI4ADUTcGu5TXNley0ioMtNfcsZYZgsALwd+62aCLsCndj7K15
        S0bbb0c+kKn/kaLca4UelJTurtHRc6d18QNCLXD3sWvAmkiHvkgV7bHpy7R/QFLZ
        Ome/AJepDW2QWlyzX25adCTQCOSxA4hX+JS85rS2JSzVIWP6obCHzNUqEJSCitjE
        +cYK8oNgWnPVtuKkUHSr8YKdjb4cTxBXWxaM8WgU/VYGAOw0qNe1y7NeaexAAGfs
        olq2A5dhUsby7xnLtkg+w7v1q3+LQ27iVmS10v+Koey6pFT7W8wY1nu5m3jHgn2w
        ==
X-ME-Sender: <xms:P47nXm4EXyIshUmIh8OSMhYg1L9fqd5h5buNy3rNjo_j8v2-1RzkxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:P47nXv7SzcENIkNbtVOI7fbaz472Mw_rhtRAZ5xe0_gdQ4de0INjWQ>
    <xmx:P47nXldiuy1zGlLVhoBuav_iKJ3yv9cdquNjroNXcO6VazRqAkiX0w>
    <xmx:P47nXjJ1OjKH1eIVbQoZ1EZ3Of_A1k1L2q9TkSVYILIHrkwGJrkLLA>
    <xmx:P47nXpknDoLchUbddd4UC0PfhAFFrYxhCUTZUU2o1tttH6_nYG4F2X8M7U4>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E4B963280065;
        Mon, 15 Jun 2020 11:05:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: pcm: disallow linking stream to itself" failed to apply to 4.4-stable tree
To:     mirq-linux@rere.qmqm.pl, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:05:13 +0200
Message-ID: <15922335138432@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

