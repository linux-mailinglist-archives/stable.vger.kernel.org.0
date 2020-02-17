Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB0E8161169
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 12:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbgBQLu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 06:50:28 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59785 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728682AbgBQLu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 06:50:28 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C63E822008;
        Mon, 17 Feb 2020 06:50:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 06:50:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=b/4se5
        FiJgKIw81oqw4xLZps48muzQZa8IjM/TEfJZY=; b=NmefhHjU5+vHMh2s9WwBBb
        T7bRBgh8DlAz+vL3DZttVTkon6lxuVSf1gX72WovykEHfzAZjNG1CskhAf/W3sPP
        TJc1ohHHr1JcJVpbiZI4kMBdMmsGfmMXiCUEX22+iTYA9yPAMkqIBl48xMSgTB/1
        iyNmRaCVmVS+xrzGlrApXf6DkDmQ1HM6EJncBA2g49Jj/bt0PN/4RVNu9BsEQE1x
        h3z4EoWsElFYTPue+uuY5JMRU8rCpvZEqAjck6NZJ4Peetu72JzJEs61e+Rd7lIa
        +o40+eLahx+IdB/Id8+TOc8NTNi0lxR7DvNVW1X7onGz1VOJ54PFZ+3Onx++hZYQ
        ==
X-ME-Sender: <xms:A35KXinL2WHX129sVopg9HtZLFaep7elrM4_2hNj_DFxURYC6XkmLw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:A35KXlreX0Lu1OeHb6s6BPV-2PEhbiCc6U0IVs9XxeROBPR3QHhD3w>
    <xmx:A35KXmLGFEsa5xABsjDdMI7gTBuY-WYJSFzdref-IyJMbrlc_GMZPA>
    <xmx:A35KXpCfaPYYKGNhFX8sjTxdGJtGVjqYE2NKYDgw96ykLgOA3E60sg>
    <xmx:A35KXuGT0cheGFWoUUONM470htZ-y18TzXsQstZet1XW0fVqP6H5ag>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 772D03280062;
        Mon, 17 Feb 2020 06:50:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] ALSA: usb-audio: Add clock validity quirk for Denon" failed to apply to 4.19-stable tree
To:     alexander@tsoy.me, stable@vger.kernel.org, tiwai@suse.de,
        toszlanyi@yahoo.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 12:50:17 +0100
Message-ID: <1581940217141140@kroah.com>
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

From 9f35a31283775e6f6af73fb2c95c686a4c0acac7 Mon Sep 17 00:00:00 2001
From: Alexander Tsoy <alexander@tsoy.me>
Date: Thu, 13 Feb 2020 02:54:50 +0300
Subject: [PATCH] ALSA: usb-audio: Add clock validity quirk for Denon
 MC7000/MCX8000

It should be safe to ignore clock validity check result if the following
conditions are met:
 - only one single sample rate is supported;
 - the terminal is directly connected to the clock source;
 - the clock type is internal.

This is to deal with some Denon DJ controllers that always reports that
clock is invalid.

Tested-by: Tobias Oszlanyi <toszlanyi@yahoo.de>
Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200212235450.697348-1-alexander@tsoy.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/usb/clock.c b/sound/usb/clock.c
index 018b1ecb5404..a48313dfa967 100644
--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -151,8 +151,34 @@ static int uac_clock_selector_set_val(struct snd_usb_audio *chip, int selector_i
 	return ret;
 }
 
+/*
+ * Assume the clock is valid if clock source supports only one single sample
+ * rate, the terminal is connected directly to it (there is no clock selector)
+ * and clock type is internal. This is to deal with some Denon DJ controllers
+ * that always reports that clock is invalid.
+ */
+static bool uac_clock_source_is_valid_quirk(struct snd_usb_audio *chip,
+					    struct audioformat *fmt,
+					    int source_id)
+{
+	if (fmt->protocol == UAC_VERSION_2) {
+		struct uac_clock_source_descriptor *cs_desc =
+			snd_usb_find_clock_source(chip->ctrl_intf, source_id);
+
+		if (!cs_desc)
+			return false;
+
+		return (fmt->nr_rates == 1 &&
+			(fmt->clock & 0xff) == cs_desc->bClockID &&
+			(cs_desc->bmAttributes & 0x3) !=
+				UAC_CLOCK_SOURCE_TYPE_EXT);
+	}
+
+	return false;
+}
+
 static bool uac_clock_source_is_valid(struct snd_usb_audio *chip,
-				      int protocol,
+				      struct audioformat *fmt,
 				      int source_id)
 {
 	int err;
@@ -160,7 +186,7 @@ static bool uac_clock_source_is_valid(struct snd_usb_audio *chip,
 	struct usb_device *dev = chip->dev;
 	u32 bmControls;
 
-	if (protocol == UAC_VERSION_3) {
+	if (fmt->protocol == UAC_VERSION_3) {
 		struct uac3_clock_source_descriptor *cs_desc =
 			snd_usb_find_clock_source_v3(chip->ctrl_intf, source_id);
 
@@ -194,10 +220,14 @@ static bool uac_clock_source_is_valid(struct snd_usb_audio *chip,
 		return false;
 	}
 
-	return data ? true :  false;
+	if (data)
+		return true;
+	else
+		return uac_clock_source_is_valid_quirk(chip, fmt, source_id);
 }
 
-static int __uac_clock_find_source(struct snd_usb_audio *chip, int entity_id,
+static int __uac_clock_find_source(struct snd_usb_audio *chip,
+				   struct audioformat *fmt, int entity_id,
 				   unsigned long *visited, bool validate)
 {
 	struct uac_clock_source_descriptor *source;
@@ -217,7 +247,7 @@ static int __uac_clock_find_source(struct snd_usb_audio *chip, int entity_id,
 	source = snd_usb_find_clock_source(chip->ctrl_intf, entity_id);
 	if (source) {
 		entity_id = source->bClockID;
-		if (validate && !uac_clock_source_is_valid(chip, UAC_VERSION_2,
+		if (validate && !uac_clock_source_is_valid(chip, fmt,
 								entity_id)) {
 			usb_audio_err(chip,
 				"clock source %d is not valid, cannot use\n",
@@ -248,8 +278,9 @@ static int __uac_clock_find_source(struct snd_usb_audio *chip, int entity_id,
 		}
 
 		cur = ret;
-		ret = __uac_clock_find_source(chip, selector->baCSourceID[ret - 1],
-					       visited, validate);
+		ret = __uac_clock_find_source(chip, fmt,
+					      selector->baCSourceID[ret - 1],
+					      visited, validate);
 		if (!validate || ret > 0 || !chip->autoclock)
 			return ret;
 
@@ -260,8 +291,9 @@ static int __uac_clock_find_source(struct snd_usb_audio *chip, int entity_id,
 			if (i == cur)
 				continue;
 
-			ret = __uac_clock_find_source(chip, selector->baCSourceID[i - 1],
-				visited, true);
+			ret = __uac_clock_find_source(chip, fmt,
+						      selector->baCSourceID[i - 1],
+						      visited, true);
 			if (ret < 0)
 				continue;
 
@@ -281,14 +313,16 @@ static int __uac_clock_find_source(struct snd_usb_audio *chip, int entity_id,
 	/* FIXME: multipliers only act as pass-thru element for now */
 	multiplier = snd_usb_find_clock_multiplier(chip->ctrl_intf, entity_id);
 	if (multiplier)
-		return __uac_clock_find_source(chip, multiplier->bCSourceID,
-						visited, validate);
+		return __uac_clock_find_source(chip, fmt,
+					       multiplier->bCSourceID,
+					       visited, validate);
 
 	return -EINVAL;
 }
 
-static int __uac3_clock_find_source(struct snd_usb_audio *chip, int entity_id,
-				   unsigned long *visited, bool validate)
+static int __uac3_clock_find_source(struct snd_usb_audio *chip,
+				    struct audioformat *fmt, int entity_id,
+				    unsigned long *visited, bool validate)
 {
 	struct uac3_clock_source_descriptor *source;
 	struct uac3_clock_selector_descriptor *selector;
@@ -307,7 +341,7 @@ static int __uac3_clock_find_source(struct snd_usb_audio *chip, int entity_id,
 	source = snd_usb_find_clock_source_v3(chip->ctrl_intf, entity_id);
 	if (source) {
 		entity_id = source->bClockID;
-		if (validate && !uac_clock_source_is_valid(chip, UAC_VERSION_3,
+		if (validate && !uac_clock_source_is_valid(chip, fmt,
 								entity_id)) {
 			usb_audio_err(chip,
 				"clock source %d is not valid, cannot use\n",
@@ -338,7 +372,8 @@ static int __uac3_clock_find_source(struct snd_usb_audio *chip, int entity_id,
 		}
 
 		cur = ret;
-		ret = __uac3_clock_find_source(chip, selector->baCSourceID[ret - 1],
+		ret = __uac3_clock_find_source(chip, fmt,
+					       selector->baCSourceID[ret - 1],
 					       visited, validate);
 		if (!validate || ret > 0 || !chip->autoclock)
 			return ret;
@@ -350,8 +385,9 @@ static int __uac3_clock_find_source(struct snd_usb_audio *chip, int entity_id,
 			if (i == cur)
 				continue;
 
-			ret = __uac3_clock_find_source(chip, selector->baCSourceID[i - 1],
-				visited, true);
+			ret = __uac3_clock_find_source(chip, fmt,
+						       selector->baCSourceID[i - 1],
+						       visited, true);
 			if (ret < 0)
 				continue;
 
@@ -372,7 +408,8 @@ static int __uac3_clock_find_source(struct snd_usb_audio *chip, int entity_id,
 	multiplier = snd_usb_find_clock_multiplier_v3(chip->ctrl_intf,
 						      entity_id);
 	if (multiplier)
-		return __uac3_clock_find_source(chip, multiplier->bCSourceID,
+		return __uac3_clock_find_source(chip, fmt,
+						multiplier->bCSourceID,
 						visited, validate);
 
 	return -EINVAL;
@@ -389,18 +426,18 @@ static int __uac3_clock_find_source(struct snd_usb_audio *chip, int entity_id,
  *
  * Returns the clock source UnitID (>=0) on success, or an error.
  */
-int snd_usb_clock_find_source(struct snd_usb_audio *chip, int protocol,
-			      int entity_id, bool validate)
+int snd_usb_clock_find_source(struct snd_usb_audio *chip,
+			      struct audioformat *fmt, bool validate)
 {
 	DECLARE_BITMAP(visited, 256);
 	memset(visited, 0, sizeof(visited));
 
-	switch (protocol) {
+	switch (fmt->protocol) {
 	case UAC_VERSION_2:
-		return __uac_clock_find_source(chip, entity_id, visited,
+		return __uac_clock_find_source(chip, fmt, fmt->clock, visited,
 					       validate);
 	case UAC_VERSION_3:
-		return __uac3_clock_find_source(chip, entity_id, visited,
+		return __uac3_clock_find_source(chip, fmt, fmt->clock, visited,
 					       validate);
 	default:
 		return -EINVAL;
@@ -501,8 +538,7 @@ static int set_sample_rate_v2v3(struct snd_usb_audio *chip, int iface,
 	 * automatic clock selection if the current clock is not
 	 * valid.
 	 */
-	clock = snd_usb_clock_find_source(chip, fmt->protocol,
-					  fmt->clock, true);
+	clock = snd_usb_clock_find_source(chip, fmt, true);
 	if (clock < 0) {
 		/* We did not find a valid clock, but that might be
 		 * because the current sample rate does not match an
@@ -510,8 +546,7 @@ static int set_sample_rate_v2v3(struct snd_usb_audio *chip, int iface,
 		 * and we will do another validation after setting the
 		 * rate.
 		 */
-		clock = snd_usb_clock_find_source(chip, fmt->protocol,
-						  fmt->clock, false);
+		clock = snd_usb_clock_find_source(chip, fmt, false);
 		if (clock < 0)
 			return clock;
 	}
@@ -577,7 +612,7 @@ static int set_sample_rate_v2v3(struct snd_usb_audio *chip, int iface,
 
 validation:
 	/* validate clock after rate change */
-	if (!uac_clock_source_is_valid(chip, fmt->protocol, clock))
+	if (!uac_clock_source_is_valid(chip, fmt, clock))
 		return -ENXIO;
 	return 0;
 }
diff --git a/sound/usb/clock.h b/sound/usb/clock.h
index 076e31b79ee0..68df0fbe09d0 100644
--- a/sound/usb/clock.h
+++ b/sound/usb/clock.h
@@ -6,7 +6,7 @@ int snd_usb_init_sample_rate(struct snd_usb_audio *chip, int iface,
 			     struct usb_host_interface *alts,
 			     struct audioformat *fmt, int rate);
 
-int snd_usb_clock_find_source(struct snd_usb_audio *chip, int protocol,
-			     int entity_id, bool validate);
+int snd_usb_clock_find_source(struct snd_usb_audio *chip,
+			      struct audioformat *fmt, bool validate);
 
 #endif /* __USBAUDIO_CLOCK_H */
diff --git a/sound/usb/format.c b/sound/usb/format.c
index 50cb183958bf..9f5cb4ed3a0c 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -336,8 +336,7 @@ static int parse_audio_format_rates_v2v3(struct snd_usb_audio *chip,
 	struct usb_device *dev = chip->dev;
 	unsigned char tmp[2], *data;
 	int nr_triplets, data_size, ret = 0, ret_l6;
-	int clock = snd_usb_clock_find_source(chip, fp->protocol,
-					      fp->clock, false);
+	int clock = snd_usb_clock_find_source(chip, fp, false);
 
 	if (clock < 0) {
 		dev_err(&dev->dev,

