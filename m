Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D29470F2
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 17:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfFOPeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 11:34:00 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:40255 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbfFOPeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 11:34:00 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E25D0436;
        Sat, 15 Jun 2019 11:33:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 15 Jun 2019 11:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1ALULs
        g/dyt0kcjOQZpJysj/03xMfQCQNGwwEN1pNkc=; b=mB1zOTxrSDGOL1vS71VNSG
        p9GAzr5IurCDAMGvE0ySRfXeFSxQG3awKuhR9KZygT9NYr8I1o17zTAXufKDmRp6
        rtXyFXdrZZIat9pTKvAN3zOLRf4+wAiRPBcpde1LZi3bxRxZLbeieNES3oYCf/jf
        GQHtrPCFMQvPID+5EL1l0wpmWqa1oEbCQUt1fGqgybhrBz3cRKw+CMNVnGb/1JTQ
        MK0EGoBVd8c3yXNN1wjRO8kP/W55CcSC66t0Kl1Zz4MzdIK+SjtAji9Y2W5svYZK
        mL3cZzyyYe4ygz4wsCarsmzGicYeD+0kmB9tZXFmgtMHojE5yJZIHoLWX+oHifgQ
        ==
X-ME-Sender: <xms:5Q8FXZW_WhYdgYiY6PSdydqJQTr9P0Gika7glEnQJOyibfVzuo4y3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:5Q8FXWuGlOo8VKpjkWtdD5KysLfApLHk1tFkRXg_XXuzkHDV-z4M0w>
    <xmx:5Q8FXV1FFqXYAYTPZ2qszyrTHQkdH3Lh67Luy0-rWbRISNaIAefvXw>
    <xmx:5Q8FXdWXYoDf4nUMGZUHmldra-RmBX-aE2yDkj7AnzRyvc5yNyBm5g>
    <xmx:5g8FXcGCKZCes0q-1xRmnNNmRsKIgXM0TOeI9bzUfxatVcz2elksgg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 517D58005C;
        Sat, 15 Jun 2019 11:33:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek - Update headset mode for ALC256" failed to apply to 4.9-stable tree
To:     kailang@realtek.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 15 Jun 2019 17:33:55 +0200
Message-ID: <156061283538164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 717f43d81afc1250300479075952a0e36d74ded3 Mon Sep 17 00:00:00 2001
From: Kailang Yang <kailang@realtek.com>
Date: Fri, 31 May 2019 17:16:53 +0800
Subject: [PATCH] ALSA: hda/realtek - Update headset mode for ALC256

ALC255 and ALC256 were some difference for hidden register.
This update was suitable for ALC256.

Fixes: e69e7e03ed22 ("ALSA: hda/realtek - ALC256 speaker noise issue")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 18cb48054e54..1afb268f3da0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4133,18 +4133,19 @@ static struct coef_fw alc225_pre_hsmode[] = {
 static void alc_headset_mode_unplugged(struct hda_codec *codec)
 {
 	static struct coef_fw coef0255[] = {
+		WRITE_COEF(0x1b, 0x0c0b), /* LDO and MISC control */
 		WRITE_COEF(0x45, 0xd089), /* UAJ function set to menual mode */
 		UPDATE_COEFEX(0x57, 0x05, 1<<14, 0), /* Direct Drive HP Amp control(Set to verb control)*/
 		WRITE_COEF(0x06, 0x6104), /* Set MIC2 Vref gate with HP */
 		WRITE_COEFEX(0x57, 0x03, 0x8aa6), /* Direct Drive HP Amp control */
 		{}
 	};
-	static struct coef_fw coef0255_1[] = {
-		WRITE_COEF(0x1b, 0x0c0b), /* LDO and MISC control */
-		{}
-	};
 	static struct coef_fw coef0256[] = {
 		WRITE_COEF(0x1b, 0x0c4b), /* LDO and MISC control */
+		WRITE_COEF(0x45, 0xd089), /* UAJ function set to menual mode */
+		WRITE_COEF(0x06, 0x6104), /* Set MIC2 Vref gate with HP */
+		WRITE_COEFEX(0x57, 0x03, 0x09a3), /* Direct Drive HP Amp control */
+		UPDATE_COEFEX(0x57, 0x05, 1<<14, 0), /* Direct Drive HP Amp control(Set to verb control)*/
 		{}
 	};
 	static struct coef_fw coef0233[] = {
@@ -4207,13 +4208,11 @@ static void alc_headset_mode_unplugged(struct hda_codec *codec)
 
 	switch (codec->core.vendor_id) {
 	case 0x10ec0255:
-		alc_process_coef_fw(codec, coef0255_1);
 		alc_process_coef_fw(codec, coef0255);
 		break;
 	case 0x10ec0236:
 	case 0x10ec0256:
 		alc_process_coef_fw(codec, coef0256);
-		alc_process_coef_fw(codec, coef0255);
 		break;
 	case 0x10ec0234:
 	case 0x10ec0274:
@@ -4266,6 +4265,12 @@ static void alc_headset_mode_mic_in(struct hda_codec *codec, hda_nid_t hp_pin,
 		WRITE_COEF(0x06, 0x6100), /* Set MIC2 Vref gate to normal */
 		{}
 	};
+	static struct coef_fw coef0256[] = {
+		UPDATE_COEFEX(0x57, 0x05, 1<<14, 1<<14), /* Direct Drive HP Amp control(Set to verb control)*/
+		WRITE_COEFEX(0x57, 0x03, 0x09a3),
+		WRITE_COEF(0x06, 0x6100), /* Set MIC2 Vref gate to normal */
+		{}
+	};
 	static struct coef_fw coef0233[] = {
 		UPDATE_COEF(0x35, 0, 1<<14),
 		WRITE_COEF(0x06, 0x2100),
@@ -4313,14 +4318,19 @@ static void alc_headset_mode_mic_in(struct hda_codec *codec, hda_nid_t hp_pin,
 	};
 
 	switch (codec->core.vendor_id) {
-	case 0x10ec0236:
 	case 0x10ec0255:
-	case 0x10ec0256:
 		alc_write_coef_idx(codec, 0x45, 0xc489);
 		snd_hda_set_pin_ctl_cache(codec, hp_pin, 0);
 		alc_process_coef_fw(codec, coef0255);
 		snd_hda_set_pin_ctl_cache(codec, mic_pin, PIN_VREF50);
 		break;
+	case 0x10ec0236:
+	case 0x10ec0256:
+		alc_write_coef_idx(codec, 0x45, 0xc489);
+		snd_hda_set_pin_ctl_cache(codec, hp_pin, 0);
+		alc_process_coef_fw(codec, coef0256);
+		snd_hda_set_pin_ctl_cache(codec, mic_pin, PIN_VREF50);
+		break;
 	case 0x10ec0234:
 	case 0x10ec0274:
 	case 0x10ec0294:
@@ -4402,6 +4412,14 @@ static void alc_headset_mode_default(struct hda_codec *codec)
 		WRITE_COEF(0x49, 0x0049),
 		{}
 	};
+	static struct coef_fw coef0256[] = {
+		WRITE_COEF(0x45, 0xc489),
+		WRITE_COEFEX(0x57, 0x03, 0x0da3),
+		WRITE_COEF(0x49, 0x0049),
+		UPDATE_COEFEX(0x57, 0x05, 1<<14, 0), /* Direct Drive HP Amp control(Set to verb control)*/
+		WRITE_COEF(0x06, 0x6100),
+		{}
+	};
 	static struct coef_fw coef0233[] = {
 		WRITE_COEF(0x06, 0x2100),
 		WRITE_COEF(0x32, 0x4ea3),
@@ -4452,11 +4470,16 @@ static void alc_headset_mode_default(struct hda_codec *codec)
 		alc_process_coef_fw(codec, alc225_pre_hsmode);
 		alc_process_coef_fw(codec, coef0225);
 		break;
-	case 0x10ec0236:
 	case 0x10ec0255:
-	case 0x10ec0256:
 		alc_process_coef_fw(codec, coef0255);
 		break;
+	case 0x10ec0236:
+	case 0x10ec0256:
+		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
+		alc_write_coef_idx(codec, 0x45, 0xc089);
+		msleep(50);
+		alc_process_coef_fw(codec, coef0256);
+		break;
 	case 0x10ec0234:
 	case 0x10ec0274:
 	case 0x10ec0294:
@@ -4500,8 +4523,7 @@ static void alc_headset_mode_ctia(struct hda_codec *codec)
 	};
 	static struct coef_fw coef0256[] = {
 		WRITE_COEF(0x45, 0xd489), /* Set to CTIA type */
-		WRITE_COEF(0x1b, 0x0c6b),
-		WRITE_COEFEX(0x57, 0x03, 0x8ea6),
+		WRITE_COEF(0x1b, 0x0e6b),
 		{}
 	};
 	static struct coef_fw coef0233[] = {
@@ -4619,8 +4641,7 @@ static void alc_headset_mode_omtp(struct hda_codec *codec)
 	};
 	static struct coef_fw coef0256[] = {
 		WRITE_COEF(0x45, 0xe489), /* Set to OMTP Type */
-		WRITE_COEF(0x1b, 0x0c6b),
-		WRITE_COEFEX(0x57, 0x03, 0x8ea6),
+		WRITE_COEF(0x1b, 0x0e6b),
 		{}
 	};
 	static struct coef_fw coef0233[] = {
@@ -4752,13 +4773,37 @@ static void alc_determine_headset_type(struct hda_codec *codec)
 	};
 
 	switch (codec->core.vendor_id) {
-	case 0x10ec0236:
 	case 0x10ec0255:
+		alc_process_coef_fw(codec, coef0255);
+		msleep(300);
+		val = alc_read_coef_idx(codec, 0x46);
+		is_ctia = (val & 0x0070) == 0x0070;
+		break;
+	case 0x10ec0236:
 	case 0x10ec0256:
+		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
+		alc_write_coef_idx(codec, 0x06, 0x6104);
+		alc_write_coefex_idx(codec, 0x57, 0x3, 0x09a3);
+
+		snd_hda_codec_write(codec, 0x21, 0,
+			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
+		msleep(80);
+		snd_hda_codec_write(codec, 0x21, 0,
+			    AC_VERB_SET_PIN_WIDGET_CONTROL, 0x0);
+
 		alc_process_coef_fw(codec, coef0255);
 		msleep(300);
 		val = alc_read_coef_idx(codec, 0x46);
 		is_ctia = (val & 0x0070) == 0x0070;
+
+		alc_write_coefex_idx(codec, 0x57, 0x3, 0x0da3);
+		alc_update_coefex_idx(codec, 0x57, 0x5, 1<<14, 0);
+
+		snd_hda_codec_write(codec, 0x21, 0,
+			    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
+		msleep(80);
+		snd_hda_codec_write(codec, 0x21, 0,
+			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
 		break;
 	case 0x10ec0234:
 	case 0x10ec0274:

