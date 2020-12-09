Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D3E2D460B
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731866AbgLIPzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:55:19 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:34335 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731464AbgLIPzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:55:12 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id A1A1519438E5;
        Wed,  9 Dec 2020 02:47:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 02:47:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=512VeC
        so1IWSCUIC7TTu2ejJjkZHjbsOGkyjPz9uJLA=; b=jH80FE9Djvos9D3zDhQRzr
        BlAej0iQWmrFUz+X2aZgdxusST7k4VXpZ0qK9IZ21ExTJqmtT3N3ynP2llQCTtHH
        uJh1ygRTVb/aqYw/+jkoVp0NDIxi5DJTt1yyGrX7+Ps7ACUcbJBkJskEDDyGh2WJ
        jxmbwv0sJpbDs4ZCqMPXWXwog26yBmJUwdeajipEpu9yFhkps96Y078yl/ponIHM
        IGeL8sNHjurDagg/lBmMyjbbQj8eSi99h6JsydxxUCp0ZDivpkmFvU7o8E76fCGE
        CDX6VcK62E1Xb6vSx/m022iVHLtUkcWJzsWWcRa+X1ffYsiPnRKW5LQp4nh+o/5Q
        ==
X-ME-Sender: <xms:J4HQX_ZP6G1AaNM-QR7RzJW4w2LzuWUDwhkTaJ346Dn3BDN-P0GA2Q>
    <xme:J4HQX-Yrf9aQT45Up5WuON_poImN916lwPujMmjulINw8J8PomTvRaK-Kbt_UqilV
    lEE3tzjFLobRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:J4HQXx-t_njL0ypH2uZZrVDs2IXAyS6B2qK87JQdUINJzRnRwuyuKw>
    <xmx:J4HQX1r8cBM1j75rR_dS0K834tYFOx9TGiCKfsPyeZ2Y4RMc4drY2g>
    <xmx:J4HQX6oSELWp2fhyNHm3aiNLS7u9wWsQcpd3l1P8b2f8UTkNbLQCsg>
    <xmx:KIHQXxSvIjWOM9QLtL3gMDIM-ZZQE4YxhHcXdlswp9cqyvify13ncQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AF5CD24005E;
        Wed,  9 Dec 2020 02:47:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek - Fixed Dell AIO wrong sound tone" failed to apply to 5.4-stable tree
To:     kailang@realtek.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 08:49:09 +0100
Message-ID: <160750014913248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 92666d45adcfd4a4a70580ff9f732309e16131f9 Mon Sep 17 00:00:00 2001
From: Kailang Yang <kailang@realtek.com>
Date: Thu, 19 Nov 2020 17:04:21 +0800
Subject: [PATCH] ALSA: hda/realtek - Fixed Dell AIO wrong sound tone

This platform only had one audio jack.
If it plugged speaker then replug with speaker or headset, the sound
tone will change to abnormal.
Headset Mic also can't record when this issue was happen.

[ Added a short comment about the COEF by tiwai ]

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/593c777dcfef4546aa050e105b8e53b5@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 739dbaf54517..b90cd4c65b58 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -119,6 +119,7 @@ struct alc_spec {
 	unsigned int no_shutup_pins:1;
 	unsigned int ultra_low_power:1;
 	unsigned int has_hs_key:1;
+	unsigned int no_internal_mic_pin:1;
 
 	/* for PLL fix */
 	hda_nid_t pll_nid;
@@ -4523,6 +4524,7 @@ static const struct coef_fw alc225_pre_hsmode[] = {
 
 static void alc_headset_mode_unplugged(struct hda_codec *codec)
 {
+	struct alc_spec *spec = codec->spec;
 	static const struct coef_fw coef0255[] = {
 		WRITE_COEF(0x1b, 0x0c0b), /* LDO and MISC control */
 		WRITE_COEF(0x45, 0xd089), /* UAJ function set to menual mode */
@@ -4597,6 +4599,11 @@ static void alc_headset_mode_unplugged(struct hda_codec *codec)
 		{}
 	};
 
+	if (spec->no_internal_mic_pin) {
+		alc_update_coef_idx(codec, 0x45, 0xf<<12 | 1<<10, 5<<12);
+		return;
+	}
+
 	switch (codec->core.vendor_id) {
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
@@ -5163,6 +5170,11 @@ static void alc_determine_headset_type(struct hda_codec *codec)
 		{}
 	};
 
+	if (spec->no_internal_mic_pin) {
+		alc_update_coef_idx(codec, 0x45, 0xf<<12 | 1<<10, 5<<12);
+		return;
+	}
+
 	switch (codec->core.vendor_id) {
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
@@ -6121,6 +6133,23 @@ static void alc274_fixup_hp_headset_mic(struct hda_codec *codec,
 	}
 }
 
+static void alc_fixup_no_int_mic(struct hda_codec *codec,
+				    const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		/* Mic RING SLEEVE swap for combo jack */
+		alc_update_coef_idx(codec, 0x45, 0xf<<12 | 1<<10, 5<<12);
+		spec->no_internal_mic_pin = true;
+		break;
+	case HDA_FIXUP_ACT_INIT:
+		alc_combo_jack_hp_jd_restart(codec);
+		break;
+	}
+}
+
 /* for hda_fixup_thinkpad_acpi() */
 #include "thinkpad_helper.c"
 
@@ -6320,6 +6349,7 @@ enum {
 	ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
 	ALC287_FIXUP_HP_GPIO_LED,
 	ALC256_FIXUP_HP_HEADSET_MIC,
+	ALC236_FIXUP_DELL_AIO_HEADSET_MIC,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7738,6 +7768,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc274_fixup_hp_headset_mic,
 	},
+	[ALC236_FIXUP_DELL_AIO_HEADSET_MIC] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc_fixup_no_int_mic,
+		.chained = true,
+		.chain_id = ALC255_FIXUP_DELL1_MIC_NO_PRESENCE
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7815,6 +7851,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x097d, "Dell Precision", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x098d, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x09bf, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0a2e, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1028, 0x0a30, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
@@ -8353,6 +8391,8 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x19, 0x02a11020},
 		{0x1a, 0x02a11030},
 		{0x21, 0x0221101f}),
+	SND_HDA_PIN_QUIRK(0x10ec0236, 0x1028, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC,
+		{0x21, 0x02211010}),
 	SND_HDA_PIN_QUIRK(0x10ec0236, 0x103c, "HP", ALC256_FIXUP_HP_HEADSET_MIC,
 		{0x14, 0x90170110},
 		{0x19, 0x02a11020},

