Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B856A21DA33
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 17:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbgGMPgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 11:36:36 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:41287 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730092AbgGMPgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 11:36:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 67454578;
        Mon, 13 Jul 2020 11:36:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 13 Jul 2020 11:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=mKCaE6
        3eQEMHhn2GlMfGtuVp2/8r3bq6ZUpXpCV86P8=; b=gI9327rDYJlgAy4jQ8rIae
        Cdjb6UJkvBZP7YB850tBIeLpP1DXGb5CqvIt9SOVTED4TTP9hnTyHiPdiK63bc7A
        f7h0g+2EgS3ro4Fpf1m5/dot5Cp/QHdsFUhN7sANThEhGocVzyG1Udi6YZNZ4kpb
        FwXhgUb1nwDz6buiBN/is5c5YwOuEG+IW82TBOFWWzbm1FOcymAsw6oEIuphkOML
        irErt62epeNaR8GoNexQwfwqJg3pStd1pC0rbcRqdyk3myLboX1uHlcfI7R0s/nF
        /Pbuhg00ltYmgwuzFwyVqOzFWtk9juin85doO8Q9SYtAMzWBuC8cTnLOs04GXWXQ
        ==
X-ME-Sender: <xms:gX8MX-e5uxNCvuQ514g7MNKhVbCz_o23t4wEFSzDh5lWJWGnr2-h8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvdekgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpedtueevueduhfdtffdtvdeiteetkeeggfeuveetgfeffe
    euteffgedvieeludevkeenucffohhmrghinhepghhithhhuhgsrdgtohhmpdhkvghrnhgv
    lhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:gX8MX4PN3QpD_SW2AUj9v188-6B9FghdeVhCVBQXRqZ0EG5kseEU8w>
    <xmx:gX8MX_iKOO3c_xF3UqmtNcW6AT9K7vMewgwL1IgJVrCRSsmFHXsEGw>
    <xmx:gX8MX79ncT_ubP7yDJVIg20lu2sLwHfbQ7X_FQziDShDctWpV5DCaw>
    <xmx:g38MX-JRe95PaRfBDcmuCDg15b03z1VPk0x3MDcC-TA-Zf2aTqbOCt6bugk>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 65E0230600A6;
        Mon, 13 Jul 2020 11:36:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek - Fix Lenovo Thinkpad X1 Carbon 7th quirk" failed to apply to 4.19-stable tree
To:     benjamin.poirier@gmail.com, evenbrenden@gmail.com,
        kailang@realtek.com, perex@perex.cz, stable@vger.kernel.org,
        tiwai@suse.de, vincent@bernat.ch
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jul 2020 17:36:33 +0200
Message-ID: <1594654593154185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 9774dc218bb628974dcbc76412f970e9258e5f27 Mon Sep 17 00:00:00 2001
From: Benjamin Poirier <benjamin.poirier@gmail.com>
Date: Fri, 3 Jul 2020 17:00:04 +0900
Subject: [PATCH] ALSA: hda/realtek - Fix Lenovo Thinkpad X1 Carbon 7th quirk
 subdevice id

1)
In snd_hda_pick_fixup(), quirks are first matched by PCI SSID and then, if
there is no match, by codec SSID. The Lenovo "ThinkPad X1 Carbon 7th" has
an audio chip with PCI SSID 0x2292 and codec SSID 0x2293[1]. Therefore, fix
the quirk meant for that device to match on .subdevice == 0x2292.

2)
The "Thinkpad X1 Yoga 7th" does not exist. The companion product to the
Carbon 7th is the Yoga 4th. That device has an audio chip with PCI SSID
0x2292 and codec SSID 0x2292[2]. Given the behavior of
snd_hda_pick_fixup(), it is not possible to have a separate quirk for the
Yoga based on SSID. Therefore, merge the quirks meant for the Carbon and
Yoga. This preserves the current behavior for the Yoga.

[1] This is the case on my own machine and can also be checked here
https://github.com/linuxhw/LsPCI/tree/master/Notebook/Lenovo/ThinkPad
https://gist.github.com/hamidzr/dd81e429dc86f4327ded7a2030e7d7d9#gistcomment-3225701
[2]
https://github.com/linuxhw/LsPCI/tree/master/Convertible/Lenovo/ThinkPad
https://gist.github.com/hamidzr/dd81e429dc86f4327ded7a2030e7d7d9#gistcomment-3176355

Fixes: d2cd795c4ece ("ALSA: hda - fixup for the bass speaker on Lenovo Carbon X1 7th gen")
Fixes: 54a6a7dc107d ("ALSA: hda/realtek - Add quirk for the bass speaker on Lenovo Yoga X1 7th gen")
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Kailang Yang <kailang@realtek.com>
Tested-by: Vincent Bernat <vincent@bernat.ch>
Tested-by: Even Brenden <evenbrenden@gmail.com>
Signed-off-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200703080005.8942-2-benjamin.poirier@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 737ef82a75fd..d6dd2aea146d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7571,8 +7571,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x224c, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x224d, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x225d, "Thinkpad T480", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-	SND_PCI_QUIRK(0x17aa, 0x2292, "Thinkpad X1 Yoga 7th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
-	SND_PCI_QUIRK(0x17aa, 0x2293, "Thinkpad X1 Carbon 7th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
+	SND_PCI_QUIRK(0x17aa, 0x2292, "Thinkpad X1 Carbon 7th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x22be, "Thinkpad X1 Carbon 8th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x30bb, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x30e2, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),

