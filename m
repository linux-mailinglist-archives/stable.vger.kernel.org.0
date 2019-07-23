Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D267715D2
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387866AbfGWKPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:15:18 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:34215 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730145AbfGWKPS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:15:18 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 12EF0408;
        Tue, 23 Jul 2019 06:15:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:15:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xtPEs+
        1k6UFqyPAoVlw7TNP13tc8pRck1P8c69dYsAI=; b=FCWOfyt/jRQvrXljL038y1
        6AGRg9sTcd39Koe7cTTcfXTeQvGVPZFs6j91F/Sgm1QL6y1T62hml5StfZdBkNhM
        IpJC+AvIT1mb1J72RDRwlwIqaZ8Yx2qJ6sRg96O7mpiIgHv8sIfD10AuXLE1Y8KP
        GLNRtah4tVsL6hNEkGmpJsGUab5qJhwOGBlWuQ+m438FSi3jhdV0HOy0uZNqkMaA
        ovSWOw5JxFTriwC6h+4zcDZb8D92hYOLzLTECK9Wv+YmCIIzvuvo2qP5rtfQO5eG
        kWPboC26f9HgNTHhqoteEw7/0j1XY5IwvPh3MogTucFWwwwmmae9RsOM6MgR6PxA
        ==
X-ME-Sender: <xms:NN42XYfr1Rs8aS8wGp6qfiZtyv6YCN6pFJcrh49m-AXO33Cls42mNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:NN42XWlxOA-_Ls7SsBy9YEryJgwmScT77YwCq589a1A2LSEw5wQ1fw>
    <xmx:NN42XcWMogtIzaWUBkYb3Es6tJoQ6wYFU1OmGJyjSMZNBwWuH_YiJg>
    <xmx:NN42XdDjQANKY7BTo6aw4rw5IlivnsSPqWujkarwTcNjpBE188kusQ>
    <xmx:NN42XbewOvJYvDO-cmmV3swr1IpL-vQ5UGGPlmw_S8SlEg_uES-Eyg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 32E75380074;
        Tue, 23 Jul 2019 06:15:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek - Fixed Headphone Mic can't record on Dell" failed to apply to 4.4-stable tree
To:     kailang@realtek.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:15:13 +0200
Message-ID: <156387691313429@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From fbc571290d9f7bfe089c50f4ac4028dd98ebfe98 Mon Sep 17 00:00:00 2001
From: Kailang Yang <kailang@realtek.com>
Date: Mon, 15 Jul 2019 10:41:50 +0800
Subject: [PATCH] ALSA: hda/realtek - Fixed Headphone Mic can't record on Dell
 platform

It assigned to wrong model. So, The headphone Mic can't work.

Fixes: 3f640970a414 ("ALSA: hda - Fix headset mic detection problem for several Dell laptops")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f24a757f8239..1c84c12b39b3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7657,9 +7657,12 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x12, 0x90a60130},
 		{0x17, 0x90170110},
 		{0x21, 0x03211020}),
-	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1028, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE,
+	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 		{0x14, 0x90170110},
 		{0x21, 0x04211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
+		{0x14, 0x90170110},
+		{0x21, 0x04211030}),
 	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1028, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE,
 		ALC295_STANDARD_PINS,
 		{0x17, 0x21014020},

