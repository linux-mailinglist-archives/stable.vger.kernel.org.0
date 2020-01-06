Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7802A1311D5
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 13:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgAFMKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 07:10:41 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:53389 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbgAFMKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 07:10:40 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AD3EE4CF;
        Mon,  6 Jan 2020 07:10:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 06 Jan 2020 07:10:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SFOlJn
        WcCj6TtRFatadjg7GIokN5sp3Y8EtPec3M4vU=; b=gtn7AZXMb/Fj96ugRC5mA7
        Q4YwASbDBWnuIR6fh7mKyNolq8oVLYiQ95bWLzYt5fco0c0c+/lcOOruKvCGIRus
        AuOYvymV9yXxyygW4axEMHYaQ55/ywWH9ar71ZMuXTQfz3hrZLl2Dk1JJkAT+SIy
        BEYaiCQaG/UISUCH/0hzARm/J+5I3rOHsyfBCCyMUGW7p9lbhMN2tX7h7jsr7tu3
        SZFD/QOuf5Q9I0Pans5CI2wuhlV3aplHqzWYZokjOxD2hsPWxwlMJyd9msSL23mn
        YXg8tt5MXD69gkdoL8piWOEUDqDyRZGmE+JXvDh9rROuKV5DY9D2wQ3J4NwDSVEg
        ==
X-ME-Sender: <xms:vyMTXkFgLT0_j6F6vON2KaaCdpwtxMRj4ELTC4vUUvkpNy5SLMdVIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehtddgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:vyMTXhlX3YvijgzghWcKYE-mmtQ0382gTvEmo4MbkvwYVZjMT-soDA>
    <xmx:vyMTXpJ4NSQhAzGQ3w5kIu3Mj7f1OsnFe-zcSbjtXXZTPVPHMmEUJg>
    <xmx:vyMTXqaLrkZH_ruJ6UrepDKu1JWUsUg4Ot4ljzON1f96-jFwozHrTg>
    <xmx:vyMTXo1qiYMdUvpBlLePuzZAO2GIcCQvi6IjaciSFEJMeUBlisDs8Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE8208005A;
        Mon,  6 Jan 2020 07:10:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek - Enable the bass speaker of ASUS UX431FLC" failed to apply to 5.4-stable tree
To:     chiu@endlessm.com, jian-hong@endlessm.com, stable@vger.kernel.org,
        tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jan 2020 13:10:37 +0100
Message-ID: <157831263714182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 48e01504cf5315cbe6de9b7412e792bfcc3dd9e1 Mon Sep 17 00:00:00 2001
From: Chris Chiu <chiu@endlessm.com>
Date: Mon, 30 Dec 2019 11:11:18 +0800
Subject: [PATCH] ALSA: hda/realtek - Enable the bass speaker of ASUS UX431FLC

ASUS reported that there's an bass speaker in addition to internal
speaker and it uses DAC 0x02. It was not enabled in the commit
436e25505f34 ("ALSA: hda/realtek - Enable internal speaker of ASUS
UX431FLC") which only enables the amplifier and the front speaker.
This commit enables the bass speaker on top of the aforementioned
work to improve the acoustic experience.

Fixes: 436e25505f34 ("ALSA: hda/realtek - Enable internal speaker of ASUS UX431FLC")
Signed-off-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191230031118.95076-1-chiu@endlessm.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2ee703c2da78..1cd4906a67e1 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5905,11 +5905,12 @@ enum {
 	ALC256_FIXUP_ASUS_HEADSET_MIC,
 	ALC256_FIXUP_ASUS_MIC_NO_PRESENCE,
 	ALC299_FIXUP_PREDATOR_SPK,
-	ALC294_FIXUP_ASUS_INTSPK_HEADSET_MIC,
 	ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE,
-	ALC294_FIXUP_ASUS_INTSPK_GPIO,
 	ALC289_FIXUP_DELL_SPK2,
 	ALC289_FIXUP_DUAL_SPK,
+	ALC294_FIXUP_SPK2_TO_DAC1,
+	ALC294_FIXUP_ASUS_DUAL_SPK,
+
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -6984,16 +6985,6 @@ static const struct hda_fixup alc269_fixups[] = {
 			{ }
 		}
 	},
-	[ALC294_FIXUP_ASUS_INTSPK_HEADSET_MIC] = {
-		.type = HDA_FIXUP_PINS,
-		.v.pins = (const struct hda_pintbl[]) {
-			{ 0x14, 0x411111f0 }, /* disable confusing internal speaker */
-			{ 0x19, 0x04a11150 }, /* use as headset mic, without its own jack detect */
-			{ }
-		},
-		.chained = true,
-		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
-	},
 	[ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -7004,13 +6995,6 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC256_FIXUP_ASUS_HEADSET_MODE
 	},
-	[ALC294_FIXUP_ASUS_INTSPK_GPIO] = {
-		.type = HDA_FIXUP_FUNC,
-		/* The GPIO must be pulled to initialize the AMP */
-		.v.func = alc_fixup_gpio4,
-		.chained = true,
-		.chain_id = ALC294_FIXUP_ASUS_INTSPK_HEADSET_MIC
-	},
 	[ALC289_FIXUP_DELL_SPK2] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -7026,6 +7010,20 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC289_FIXUP_DELL_SPK2
 	},
+	[ALC294_FIXUP_SPK2_TO_DAC1] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_speaker2_to_dac1,
+		.chained = true,
+		.chain_id = ALC294_FIXUP_ASUS_HEADSET_MIC
+	},
+	[ALC294_FIXUP_ASUS_DUAL_SPK] = {
+		.type = HDA_FIXUP_FUNC,
+		/* The GPIO must be pulled to initialize the AMP */
+		.v.func = alc_fixup_gpio4,
+		.chained = true,
+		.chain_id = ALC294_FIXUP_SPK2_TO_DAC1
+	},
+
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7187,7 +7185,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
-	SND_PCI_QUIRK(0x1043, 0x17d1, "ASUS UX431FL", ALC294_FIXUP_ASUS_INTSPK_GPIO),
+	SND_PCI_QUIRK(0x1043, 0x17d1, "ASUS UX431FL", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),
 	SND_PCI_QUIRK(0x1043, 0x1a30, "ASUS X705UD", ALC256_FIXUP_ASUS_MIC),

