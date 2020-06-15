Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFA41F9B66
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbgFOPFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:05:25 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:53517 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730213AbgFOPFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:05:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 69A2C48F;
        Mon, 15 Jun 2020 11:05:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=i3Urbh
        GYVtPQcRYxDblz+DdJH9dTLqxOkZvVE4/bPMA=; b=s93VYPB/qr8YiJSZJ2QHsz
        RXXp/qyo91BFRzH/QpxrE6nPKIOu5JTBB2xn+MBtycJOOQ90TiC6Sg8pGciLT1IJ
        gG169FSliEnVabP5BkDMbcnBugYLuXHzEpQEESBGT7UIvkg4/8cuYhNGIutre94F
        D/O5LHllxMiafgkVfvLzN1CphAtrU/QAjLYF6I2TH+dq0vff7xHYvGApGHS1Ch0w
        sj3zxYlVsgGAqvrEA+PYbE+I0hAVkPEzgJawlmtZaRpBUtQDwr/KShav7MPVBYei
        3uOIWigSz7nLhTMmkEl7zHugOChiz1GKaw1DEr5tHXoQOc56e19AbECzc4anQmUA
        ==
X-ME-Sender: <xms:M47nXhp_hClZhqeZW1Fl6306YisxI_ssEFbEGPLxY6HhL-Jmbd9CKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:M47nXjqWibflT5oCJfqzhaA4_ZEc3p-8dgUNn_AgsUqln0tTbu6dVA>
    <xmx:M47nXuNqZYOq27--3gd_x1P8CO2D1L-6CZSR-AAYkdUdnEBLe-EO9w>
    <xmx:M47nXs7gXbjxutrV_9x31JuM8p8OhOQWqBtnAM7lIwFZmQ5N2wRA1A>
    <xmx:NI7nXlWWMEnbx5IaAo1eP7NPALKauZNpwk78cVSofuoCnfTet3TE1wZX4s8>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4CB0030618B7;
        Mon, 15 Jun 2020 11:05:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: pcm: disallow linking stream to itself" failed to apply to 4.19-stable tree
To:     mirq-linux@rere.qmqm.pl, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:05:11 +0200
Message-ID: <1592233511148188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

