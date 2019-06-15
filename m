Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41BFF470F3
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 17:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfFOPeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 11:34:07 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:33181 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbfFOPeH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 11:34:07 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8948B435;
        Sat, 15 Jun 2019 11:34:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 15 Jun 2019 11:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=XlxDxt
        sE3AY0E5M/QMjsBpYjrqYRT6Os2rakBbx2+JQ=; b=QdfI85ncecNLYeKnMFGZYw
        eo6qMuepebhWDL5BMI7F3W3r1p7lWEjTUEOfOmPkIoWvcOhbpnwKYDKDI5Rb6eJt
        YgCwQLAABC4AFIz9fJRYB815LXAYyO2FuSStzUdbevPEWCf0PVMi0ZtuGb3X97NT
        WnQBBxxVf5PFRbPHMTKrsxLYKf8I7TEBHCptnYbLalfPbzkoUhMQWs0nWj6B8mv9
        7vNj3L8uQpvhA/qiqUBdXUaKlSySBxhsAtP7ibOQCUG5o7x3YZHE6KfORukEKZw6
        xg2WK/TvKeJ4T4O/hcqE3Trf7A3jDVV12MMDg56xnieefpLag1NminXAQJ38HfFA
        ==
X-ME-Sender: <xms:7Q8FXU9FGfyCllnkZjgt9CmtXPzmjTmGvSvWMcUat806x-3DaQFyUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepge
X-ME-Proxy: <xmx:7Q8FXfyHIHm7G_VwzLVlpKPeKLUconsWL_t2cmP3zTSDIa2-bERwOw>
    <xmx:7Q8FXYFycqQU9sTMasDxcZsJD_pvNM2P7lvorsUF-pCteHkS7RKU-Q>
    <xmx:7Q8FXX7nzuq54mXWx1DPTqeOyxNShI12VF0Wy2_dBRT7rvTcxPBMKg>
    <xmx:7g8FXYNKx2tD0e_C7rgKM7-XpxxDrI4fv8sZqGYa2FUoIpOzBqxSUA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6F671380086;
        Sat, 15 Jun 2019 11:34:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek - Update headset mode for ALC256" failed to apply to 4.4-stable tree
To:     kailang@realtek.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 15 Jun 2019 17:33:56 +0200
Message-ID: <1560612836584@kroah.com>
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

