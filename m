Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B561EA242
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 12:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgFAKuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 06:50:06 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:36573 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725972AbgFAKuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 06:50:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0E5DF19407F8;
        Mon,  1 Jun 2020 06:49:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 01 Jun 2020 06:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5hoOHP
        Gve7fD7SuL8KdhkCcpezLuVxaeN9DfkXJmY/s=; b=tlOywLhPTtkCugX3emO2r3
        Ow+YK3FT7PDfQeVuMRORqrf2T2ZPbWaDIhaS6KwvxC6Pa9yucSA2k3U/EW/W96bx
        HsdPZzUvcV2Vn8v9t169kXoSgEbu/ivtmoSYh11UTXENJanevJN2H6uw7RmG81Bb
        XEW54CbQev4xhzUVvWnTGM+5arH/2dhvuvXG/oW8mpKfnYuzhJfuqQDWT3erxwWO
        t7Kare0QYwsyjZwjEoCgJi77SBqiFthTrnaLzFbObUCoVlRf0wAnO4MSW20vtiOD
        xDN6caztClAJF3FNfJqemON0q8xbQulqkgW7XaN+CWX3CkDTzuAmSrz7usq7jApA
        ==
X-ME-Sender: <xms:Ut3UXnuIEmDzANZ8m0-mPb-2XL2cNz-QMlS5kvXST3CVP0l5RtHaeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudefhedgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepgfettefhleehvdegteeuudfghfeftddvgedvudefhe
    efhffgteekveelieehkefgnecuffhomhgrihhnpehsuhhsvgdrtghomhdpkhgvrhhnvghl
    rdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpe
    dunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Ut3UXoe63FHBo6SHD5-xVyR2Gn9s824IDryq1GsKMx0__UM_NLQavw>
    <xmx:Ut3UXqwNZShwBygGMovRl3O3VRjq9JEde64SHSkSSRQR0RQ9ui274g>
    <xmx:Ut3UXmPGwgRWSCIjT3OSRMWVQvkIhv68gUR6dggirQuK31pTo_LHoQ>
    <xmx:U93UXqJnP5BIAJ61IYPdBqdNGD5xgONS4MXmLVH32wt19Bt2SbITrQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A2C0A328005D;
        Mon,  1 Jun 2020 06:49:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek - Add a model for Thinkpad T570 without DAC" failed to apply to 4.14-stable tree
To:     tiwai@suse.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Jun 2020 12:49:45 +0200
Message-ID: <1591008585200237@kroah.com>
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

From 399c01aa49e548c82d40f8161915a5941dd3c60e Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Tue, 26 May 2020 08:24:06 +0200
Subject: [PATCH] ALSA: hda/realtek - Add a model for Thinkpad T570 without DAC
 workaround

We fixed the regression of the speaker volume for some Thinkpad models
(e.g. T570) by the commit 54947cd64c1b ("ALSA: hda/realtek - Fix
speaker output regression on Thinkpad T570").  Essentially it fixes
the DAC / pin pairing by a static table.  It was confirmed and merged
to stable kernel later.

Now, interestingly, we got another regression report for the very same
model (T570) about the similar problem, and the commit above was the
culprit.  That is, by some reason, there are devices that prefer the
DAC1, and another device DAC2!

Unfortunately those have the same ID and we have no idea what can
differentiate, in this patch, a new fixup model "tpt470-dock-fix" is
provided, so that users with such a machine can apply it manually.
When model=tpt470-dock-fix option is passed to snd-hda-intel module,
it avoids the fixed DAC pairing and the DAC1 is assigned to the
speaker like the earlier versions.

Fixes: 54947cd64c1b ("ALSA: hda/realtek - Fix speaker output regression on Thinkpad T570")
BugLink: https://apibugzilla.suse.com/show_bug.cgi?id=1172017
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200526062406.9799-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 041d2a32059b..92c6e58c3862 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5484,18 +5484,9 @@ static void alc_fixup_tpt470_dock(struct hda_codec *codec,
 		{ 0x19, 0x21a11010 }, /* dock mic */
 		{ }
 	};
-	/* Assure the speaker pin to be coupled with DAC NID 0x03; otherwise
-	 * the speaker output becomes too low by some reason on Thinkpads with
-	 * ALC298 codec
-	 */
-	static const hda_nid_t preferred_pairs[] = {
-		0x14, 0x03, 0x17, 0x02, 0x21, 0x02,
-		0
-	};
 	struct alc_spec *spec = codec->spec;
 
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
-		spec->gen.preferred_dacs = preferred_pairs;
 		spec->parse_flags = HDA_PINCFG_NO_HP_FIXUP;
 		snd_hda_apply_pincfgs(codec, pincfgs);
 	} else if (action == HDA_FIXUP_ACT_INIT) {
@@ -5508,6 +5499,23 @@ static void alc_fixup_tpt470_dock(struct hda_codec *codec,
 	}
 }
 
+static void alc_fixup_tpt470_dacs(struct hda_codec *codec,
+				  const struct hda_fixup *fix, int action)
+{
+	/* Assure the speaker pin to be coupled with DAC NID 0x03; otherwise
+	 * the speaker output becomes too low by some reason on Thinkpads with
+	 * ALC298 codec
+	 */
+	static const hda_nid_t preferred_pairs[] = {
+		0x14, 0x03, 0x17, 0x02, 0x21, 0x02,
+		0
+	};
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		spec->gen.preferred_dacs = preferred_pairs;
+}
+
 static void alc_shutup_dell_xps13(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
@@ -6063,6 +6071,7 @@ enum {
 	ALC700_FIXUP_INTEL_REFERENCE,
 	ALC274_FIXUP_DELL_BIND_DACS,
 	ALC274_FIXUP_DELL_AIO_LINEOUT_VERB,
+	ALC298_FIXUP_TPT470_DOCK_FIX,
 	ALC298_FIXUP_TPT470_DOCK,
 	ALC255_FIXUP_DUMMY_LINEOUT_VERB,
 	ALC255_FIXUP_DELL_HEADSET_MIC,
@@ -6994,12 +7003,18 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC274_FIXUP_DELL_BIND_DACS
 	},
-	[ALC298_FIXUP_TPT470_DOCK] = {
+	[ALC298_FIXUP_TPT470_DOCK_FIX] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_tpt470_dock,
 		.chained = true,
 		.chain_id = ALC293_FIXUP_LENOVO_SPK_NOISE
 	},
+	[ALC298_FIXUP_TPT470_DOCK] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc_fixup_tpt470_dacs,
+		.chained = true,
+		.chain_id = ALC298_FIXUP_TPT470_DOCK_FIX
+	},
 	[ALC255_FIXUP_DUMMY_LINEOUT_VERB] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -7638,6 +7653,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC292_FIXUP_TPT440_DOCK, .name = "tpt440-dock"},
 	{.id = ALC292_FIXUP_TPT440, .name = "tpt440"},
 	{.id = ALC292_FIXUP_TPT460, .name = "tpt460"},
+	{.id = ALC298_FIXUP_TPT470_DOCK_FIX, .name = "tpt470-dock-fix"},
 	{.id = ALC298_FIXUP_TPT470_DOCK, .name = "tpt470-dock"},
 	{.id = ALC233_FIXUP_LENOVO_MULTI_CODECS, .name = "dual-codecs"},
 	{.id = ALC700_FIXUP_INTEL_REFERENCE, .name = "alc700-ref"},

