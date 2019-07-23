Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8D25715D0
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732971AbfGWKPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:15:15 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:50121 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730145AbfGWKPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:15:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D1F9D438;
        Tue, 23 Jul 2019 06:15:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:15:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=iiw9vT
        qfMJbtzeWdQ3Dz4GPtv1xN1lY/B+7/c1ma3/c=; b=AwTqBR4lIrdzJI+y9vZ/AR
        nnYVsICS53KNkhGJ1k+hj/KAfed8DfwykNGgYbRStBS42WgioHYkfRpH5sag4z8J
        MY4PJGRT22Mmf8Tqf7f500Saps2wE9pUIWl7VCr0goM77wO9N8MmapBftsMxzWO2
        knIUhi17BAMNFZKP1yYn826pvU0is8ZergR/ZIxnjijxu1IdkpKLtNhutW+Z9wLs
        Y1C4CNgwnmvCPovX0XW6Nv/Alik/2wchuuEQiACfZvMJMUOl+ArLCtf6lGvuGtsu
        lpVwP7OsvACxLY5CIzyGV4sMn5q1H+0gOU/xej9gDYeNJVmAfno7Mw9Dt/lL2kww
        ==
X-ME-Sender: <xms:MN42XfibMrJyQlRZmTw8SeyYburht9PgtL2Grx_a5kNjKSqZRZEdHg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:MN42XS-WMEXczJFI5HjlYik3gwLNsqhHnpKb-yozEfM7TY2NP1lfqQ>
    <xmx:MN42XUJ-4QM1WkmyMAp229MD8CkYq3Rad2wRS1v8jnAyGre0S-LccQ>
    <xmx:MN42XTZGAAQNaIMNdmWLwxeKLWU0_ZahOm5vWPXgFsLyoMUQIgdzUA>
    <xmx:Md42XW0E02Q40KcolMJ1kVDVjFOaQxYO8UIvnOLQvnnN46Vqvo95hw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 636A1380075;
        Tue, 23 Jul 2019 06:15:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek - Fixed Headphone Mic can't record on Dell" failed to apply to 4.14-stable tree
To:     kailang@realtek.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:15:11 +0200
Message-ID: <156387691110846@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

