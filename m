Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE15C3DBF
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 19:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbfJARCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 13:02:23 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:38433 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726219AbfJARCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 13:02:22 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id F128545C;
        Tue,  1 Oct 2019 13:02:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 01 Oct 2019 13:02:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=51n/Lb
        9U/aOt7N1urDwKT2MLU58q/fxRfNG4rzIzgJI=; b=vnyL8bJZidjLiwKhWd1lMS
        OCY6AgR9v3K8/WOQZyZ3TWiKjpmM4ld1AhmIXistR+JKaYVN0mvivOXuKjcx6f8b
        M36K5vXvGWUwgYHAna71NaT/vza88obfA/ptVFEe9noMuqXKAHua9izQ0hd3xuKK
        Kc57a1WPqXhmoKEuPft9CE5C0tFekX/YpWQOq6wisfVkkqSfWadjUHhiiOrCwH78
        FVN5myCnESpTuda44itTBIfPXsq8Zukrm1L8czdyi5UQTriTDofxRn1VLeOmXShd
        XL6fCLdZ2aZ6nZ23iVgt0HMflrKItkzltT+1cPDomO7WeZfR+exXtURCXVUM5GCw
        ==
X-ME-Sender: <xms:m4aTXQArJK5ExYhvCwNRBg99huHLEznlUA3gFuZJTqVE8FS_3_MC5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeggddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:m4aTXcg9qF2rWC2nNCmuryfm6aPZojFbyvvyzzu-CqD2BEYOAe5nWw>
    <xmx:m4aTXdr8VQ8N5sUu76p3QW9oxbCfELured1IYxauskllYfjag6Oxnw>
    <xmx:m4aTXYhaAgjIC3U6klBUY4-q1xFVznskXZGcWMtvgLrnWzP6SB-i4g>
    <xmx:nIaTXVFT6p4Q3ppewshwufLECrsGMPcKUG8RbtxZgDX9YQccDFH9gg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 616CED6005D;
        Tue,  1 Oct 2019 13:02:19 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek - PCI quirk for Medion E4254" failed to apply to 5.3-stable tree
To:     glogow@fbihome.de, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 01 Oct 2019 19:02:15 +0200
Message-ID: <1569949335234236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bd9c10bc663dd2eaac8fe39dad0f18cd21527446 Mon Sep 17 00:00:00 2001
From: Jan-Marek Glogowski <glogow@fbihome.de>
Date: Sun, 15 Sep 2019 16:57:28 +0200
Subject: [PATCH] ALSA: hda/realtek - PCI quirk for Medion E4254

The laptop has a combined jack to attach headsets on the right.
The BIOS encodes them as two different colored jacks at the front,
but otherwise it seems to be configured ok. But any adaption of
the pins config on its own doesn't fix the jack detection to work
in Linux. Still Windows works correct.

This is somehow fixed by chaining ALC256_FIXUP_ASUS_HEADSET_MODE,
which seems to register the microphone jack as a headset part and
also results in fixing jack sensing, visible in dmesg as:

-snd_hda_codec_realtek hdaudioC0D0:      Mic=0x19
+snd_hda_codec_realtek hdaudioC0D0:      Headset Mic=0x19

[ Actually the essential change is the location of the jack; the
  driver created "Front Mic Jack" without the matching volume / mute
  control element due to its jack location, which confused PA.
  -- tiwai ]

Signed-off-by: Jan-Marek Glogowski <glogow@fbihome.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/8f4f9b20-0aeb-f8f1-c02f-fd53c09679f1@fbihome.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e27ef434b60d..b000b36ac3c6 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5872,6 +5872,7 @@ enum {
 	ALC256_FIXUP_ASUS_MIC_NO_PRESENCE,
 	ALC299_FIXUP_PREDATOR_SPK,
 	ALC294_FIXUP_ASUS_INTSPK_HEADSET_MIC,
+	ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -6937,6 +6938,16 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
 	},
+	[ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x04a11040 },
+			{ 0x21, 0x04211020 },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC256_FIXUP_ASUS_HEADSET_MODE
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7200,6 +7211,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x1b7d, 0xa831, "Ordissimo EVE2 ", ALC269VB_FIXUP_ORDISSIMO_EVE2), /* Also known as Malata PC-B1303 */
+	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.
@@ -7368,6 +7380,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC295_FIXUP_CHROME_BOOK, .name = "alc-chrome-book"},
 	{.id = ALC299_FIXUP_PREDATOR_SPK, .name = "predator-spk"},
 	{.id = ALC298_FIXUP_HUAWEI_MBX_STEREO, .name = "huawei-mbx-stereo"},
+	{.id = ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE, .name = "alc256-medion-headset"},
 	{}
 };
 #define ALC225_STANDARD_PINS \

