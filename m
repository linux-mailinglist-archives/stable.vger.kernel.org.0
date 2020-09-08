Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C1A261FB7
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 22:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgIHUGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 16:06:07 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:40385 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730357AbgIHPVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 11:21:53 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id AE01EF8F;
        Tue,  8 Sep 2020 07:59:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 08 Sep 2020 07:59:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=K4ECX7
        QJ8sc5FbtIV5255AN7MVeuAs09bA/nl/A7bos=; b=Kd5Zwo1HM9JMJXP+WPz7UB
        7XnpsRT/VqlgqS0OwBRQVceaqrsIAFA/yTOIaXlq0nKazA7tJYOHUEOzNOU7W64W
        0RY65v6JYbY26ifVXPje1VvCjUOqYD6j0Ksn1V2rYcFcIVEMW5w6a/tf7lIVm5GR
        TnqJ0gLCbsed1DKumwRmFMNjp9nsJ2NOU9bc+bBdWwUy/6m6wH/jo5A2jan5VO7E
        1oE5NgVopOlVqH2PfmDUG1R7r9+RADnvDdFN89x3AGZVSExaqVDyfoaeBRZd9O0D
        NH0NN8vFmTNNSYgZh2R7mbnL3gjUQz4Scsj4a0Qogktb12daiM481QNcKAZbLsVQ
        ==
X-ME-Sender: <xms:KnJXX4OJo-P-bA34srSpzwJw3ZejtQxhFR_oXaaHdQnNZxi4HIIrLw>
    <xme:KnJXX-9a54AJEJpE53LOEFcIz8OPJ1aJv5w4OmxwUwUKwnjmaBe5YLd2KjWoqlaFN
    H4ClVDcc9EdoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehfedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepjeeuhffhjedutdfgieehfeevfeekfeehjeffteevle
    etlefhtefgjeetudffheelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpghhithhh
    uhgsrdgtohhmpdhlohhrvghkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrd
    eigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:K3JXX_TJ6Mt-r_eaq4VSsY2kjyHINwWCZkcTGOm0VDq39aDCw89kUQ>
    <xmx:K3JXXwuhYgGKydKr5LPkWekllTK1XZeNzDMCsnXJ7Wv_HH8i9W_Gzg>
    <xmx:K3JXXwc4FnDMjAYLqHFYap88NAnCjFL-C2tIsUHg8WmU0SFaW9FWwA>
    <xmx:K3JXX8GiqqZoNgXvN6OHGrWbJLrjI9VMq2UsnHxOlzthHE2CXN5lb02bj0A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B22BB3064610;
        Tue,  8 Sep 2020 07:59:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek - Improved routing for Thinkpad X1 7th/8th" failed to apply to 4.19-stable tree
To:     tiwai@suse.de, benjamin.poirier@gmail.com, perex@perex.cz,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Sep 2020 13:59:52 +0200
Message-ID: <159956639212962@kroah.com>
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

From 6a6660d049f88b89fd9a4b9db3581b245f7782fa Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Thu, 3 Sep 2020 10:33:00 +0200
Subject: [PATCH] ALSA: hda/realtek - Improved routing for Thinkpad X1 7th/8th
 Gen

There've been quite a few regression reports about the lowered volume
(reduced to ca 65% from the previous level) on Lenovo Thinkpad X1
after the commit d2cd795c4ece ("ALSA: hda - fixup for the bass speaker
on Lenovo Carbon X1 7th gen").  Although the commit itself does the
right thing from HD-audio POV in order to have a volume control for
bass speakers, it seems that the machine has some secret recipe under
the hood.

Through experiments, Benjamin Poirier found out that the following
routing gives the best result:
* DAC1 (NID 0x02) -> Speaker pin (NID 0x14)
* DAC2 (NID 0x03) -> Shared by both Bass Speaker pin (NID 0x17) &
                     Headphone pin (0x21)
* DAC3 (NID 0x06) -> Unused

DAC1 seems to have some equalizer internally applied, and you'd get
again the output in a bad quality if you connect this to the
headphone pin.  Hence the headphone is connected to DAC2, which is now
shared with the bass speaker pin.  DAC3 has no volume amp, hence it's
not connected at all.

For achieving the routing above, this patch introduced a couple of
workarounds:

* The connection list of bass speaker pin (NID 0x17) is reduced not to
  include DAC3 (NID 0x06)
* Pass preferred_pairs array to specify the fixed connection

Here, both workarounds are needed because the generic parser prefers
the individual DAC assignment over others.

When the routing above is applied, the generic parser creates the two
volume controls "Front" and "Bass Speaker".  Since we have only two
DACs for three output pins, those are not fully controlling each
output individually, and it would confuse PulseAudio.  For avoiding
the pitfall, in this patch, we rename those volume controls to some
unique ones ("DAC1" and "DAC2").  Then PulseAudio ignore them and
concentrate only on the still good-working "Master" volume control.
If a user still wants to control each DAC volume, they can still
change manually via "DAC1" and "DAC2" volume controls.

Fixes: d2cd795c4ece ("ALSA: hda - fixup for the bass speaker on Lenovo Carbon X1 7th gen")
Reported-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Tested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Cc: <stable@vger.kernel.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207407#c10
BugLink: https://gist.github.com/hamidzr/dd81e429dc86f4327ded7a2030e7d7d9#gistcomment-3214171
BugLink: https://gist.github.com/hamidzr/dd81e429dc86f4327ded7a2030e7d7d9#gistcomment-3276276
Link: https://lore/kernel.org/r/20200829112746.3118-1-benjamin.poirier@gmail.com
Link: https://lore.kernel.org/r/20200903083300.6333-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2ef8b080d84b..c521a1f17096 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5868,6 +5868,39 @@ static void alc275_fixup_gpio4_off(struct hda_codec *codec,
 	}
 }
 
+/* Quirk for Thinkpad X1 7th and 8th Gen
+ * The following fixed routing needed
+ * DAC1 (NID 0x02) -> Speaker (NID 0x14); some eq applied secretly
+ * DAC2 (NID 0x03) -> Bass (NID 0x17) & Headphone (NID 0x21); sharing a DAC
+ * DAC3 (NID 0x06) -> Unused, due to the lack of volume amp
+ */
+static void alc285_fixup_thinkpad_x1_gen7(struct hda_codec *codec,
+					  const struct hda_fixup *fix, int action)
+{
+	static const hda_nid_t conn[] = { 0x02, 0x03 }; /* exclude 0x06 */
+	static const hda_nid_t preferred_pairs[] = {
+		0x14, 0x02, 0x17, 0x03, 0x21, 0x03, 0
+	};
+	struct alc_spec *spec = codec->spec;
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn), conn);
+		spec->gen.preferred_dacs = preferred_pairs;
+		break;
+	case HDA_FIXUP_ACT_BUILD:
+		/* The generic parser creates somewhat unintuitive volume ctls
+		 * with the fixed routing above, and the shared DAC2 may be
+		 * confusing for PA.
+		 * Rename those to unique names so that PA doesn't touch them
+		 * and use only Master volume.
+		 */
+		rename_ctl(codec, "Front Playback Volume", "DAC1 Playback Volume");
+		rename_ctl(codec, "Bass Speaker Playback Volume", "DAC2 Playback Volume");
+		break;
+	}
+}
+
 static void alc233_alc662_fixup_lenovo_dual_codecs(struct hda_codec *codec,
 					 const struct hda_fixup *fix,
 					 int action)
@@ -6136,6 +6169,7 @@ enum {
 	ALC289_FIXUP_DUAL_SPK,
 	ALC294_FIXUP_SPK2_TO_DAC1,
 	ALC294_FIXUP_ASUS_DUAL_SPK,
+	ALC285_FIXUP_THINKPAD_X1_GEN7,
 	ALC285_FIXUP_THINKPAD_HEADSET_JACK,
 	ALC294_FIXUP_ASUS_HPE,
 	ALC294_FIXUP_ASUS_COEF_1B,
@@ -7281,11 +7315,17 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC294_FIXUP_SPK2_TO_DAC1
 	},
+	[ALC285_FIXUP_THINKPAD_X1_GEN7] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_thinkpad_x1_gen7,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_THINKPAD_ACPI
+	},
 	[ALC285_FIXUP_THINKPAD_HEADSET_JACK] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_headset_jack,
 		.chained = true,
-		.chain_id = ALC285_FIXUP_SPEAKER2_TO_DAC1
+		.chain_id = ALC285_FIXUP_THINKPAD_X1_GEN7
 	},
 	[ALC294_FIXUP_ASUS_HPE] = {
 		.type = HDA_FIXUP_VERBS,

