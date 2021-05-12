Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6679437B9F5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhELKHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:07:33 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:51291 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230135AbhELKHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:07:32 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 4569512BE;
        Wed, 12 May 2021 06:06:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 06:06:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Qs6luM
        LBKKsSY6H2qDJXXeCUhemn/ct0ryCIEBhNKGI=; b=nPVKVLcUPj9Qc2vS5lVo+x
        z6ek2RmtqXjHKdYPPRfEGH3cEIwv5+2AHmp66Fs/BkD02JqJ6fQeSEiZPfRdec7V
        F7XXrHTobXiQgS6dqDvO/f6UZFuUcBU36fj861oM/RMtj7Gz3GfKKiQzlWwdlYEl
        rgDRpTimbCstfUIv6oZxC1bFTduLEgjQfgw9DlozcNKkMrcUi4dhM9vAhZ7L6xIA
        qloXjqV4NINpU0CDWliYdYW76ggPXM2HFZu8Y+5/bWpGHZhgRkcpYkmw1Efpq4a+
        GOJvNhcdbMf066p5QqSklxB3ZBS415oZu9fpIPeGL/hAlRxwNNSd6x5H4wJ6q13g
        ==
X-ME-Sender: <xms:nqibYPTEOivphn-79RmVg8b44DzFAN6IxGT0kftQIcfVgLbDBV_Dzw>
    <xme:nqibYAww36VLHKc1MuYWjVtVhHgQdHa5K0NaJMWjMmTl7KULi7idSgHiwR2UsTbsn
    YtSMOZX75O78w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnheptefhhffgjefgtdeihefgvdehieetuefgvefhgedvge
    dvgfdugfevgefgueeljedvnecuffhomhgrihhnpehlrghunhgthhhprggurdhnvghtpdhk
    vghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghruf
    hiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtgho
    mh
X-ME-Proxy: <xmx:nqibYE2Vos99iqHLsL6naF1ojZy5Vk0IiAbpfVjez-gWHlSuK0zZ0w>
    <xmx:nqibYPArPCjzFk-PA3nfpxK-IvJu5BYkxdZ-G4Pn0T8OH9ov6f6-Ig>
    <xmx:nqibYIgZnA7JQRdRx_mBJxjswTH4x-LiQHX4UicvdhsRFbHP-aMokQ>
    <xmx:nqibYBt-xi-qSOpxTyQBXdhZE4CIWPXxGzBkJ7ZoCtvZBRHQ_GKOp0QOSOM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:06:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hda/cirrus: Use CS8409 filter to fix abnormal sounds on" failed to apply to 5.11-stable tree
To:     sbinding@opensource.cirrus.com, stable@vger.kernel.org,
        tiwai@suse.de, vicamo.yang@canonical.com,
        vitalyr@opensource.cirrus.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:06:13 +0200
Message-ID: <16208139731544@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 45b14fe200ba0611b6c3874aa5bba584dc979fb9 Mon Sep 17 00:00:00 2001
From: Stefan Binding <sbinding@opensource.cirrus.com>
Date: Mon, 26 Apr 2021 17:37:49 +0100
Subject: [PATCH] ALSA: hda/cirrus: Use CS8409 filter to fix abnormal sounds on
 Bullseye

Cracking noises have been reported on the built-in speaker for certain
Bullseye platforms, when volume is > 80%.

This issue is caused by the specific combination of Codec and AMP in
this platform, and cannot be fixed by the AMP, so indead must be fixed
at codec level, by adding attenuation to the volume.

Tested on DELL Inspiron-3505, DELL Inspiron-3501, DELL Inspiron-3500

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Vitaly Rodionov <vitalyr@opensource.cirrus.com>
BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1924997
Reported-and-tested-by: You-Sheng Yang <vicamo.yang@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210426163749.196153-3-vitalyr@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index a4f82f147ff3..726507d0b04c 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -1481,6 +1481,34 @@ static const struct cs8409_cir_param cs8409_cs42l42_hw_cfg[] = {
 	{} /* Terminator */
 };
 
+static const struct cs8409_cir_param cs8409_cs42l42_bullseye_atn[] = {
+	{ 0x47, 0x65, 0x4000 }, /* EQ_SEL=1, EQ1/2_EN=0 */
+	{ 0x47, 0x64, 0x4000 }, /* +EQ_ACC */
+	{ 0x47, 0x65, 0x4010 }, /* +EQ2_EN */
+	{ 0x47, 0x63, 0x0647 }, /* EQ_DATA_HI=0x0647 */
+	{ 0x47, 0x64, 0xc0c7 }, /* +EQ_WRT, +EQ_ACC, EQ_ADR=0, EQ_DATA_LO=0x67 */
+	{ 0x47, 0x63, 0x0647 }, /* EQ_DATA_HI=0x0647 */
+	{ 0x47, 0x64, 0xc1c7 }, /* +EQ_WRT, +EQ_ACC, EQ_ADR=1, EQ_DATA_LO=0x67 */
+	{ 0x47, 0x63, 0xf370 }, /* EQ_DATA_HI=0xf370 */
+	{ 0x47, 0x64, 0xc271 }, /* +EQ_WRT, +EQ_ACC, EQ_ADR=2, EQ_DATA_LO=0x71 */
+	{ 0x47, 0x63, 0x1ef8 }, /* EQ_DATA_HI=0x1ef8 */
+	{ 0x47, 0x64, 0xc348 }, /* +EQ_WRT, +EQ_ACC, EQ_ADR=3, EQ_DATA_LO=0x48 */
+	{ 0x47, 0x63, 0xc110 }, /* EQ_DATA_HI=0xc110 */
+	{ 0x47, 0x64, 0xc45a }, /* +EQ_WRT, +EQ_ACC, EQ_ADR=4, EQ_DATA_LO=0x5a */
+	{ 0x47, 0x63, 0x1f29 }, /* EQ_DATA_HI=0x1f29 */
+	{ 0x47, 0x64, 0xc574 }, /* +EQ_WRT, +EQ_ACC, EQ_ADR=5, EQ_DATA_LO=0x74 */
+	{ 0x47, 0x63, 0x1d7a }, /* EQ_DATA_HI=0x1d7a */
+	{ 0x47, 0x64, 0xc653 }, /* +EQ_WRT, +EQ_ACC, EQ_ADR=6, EQ_DATA_LO=0x53 */
+	{ 0x47, 0x63, 0xc38c }, /* EQ_DATA_HI=0xc38c */
+	{ 0x47, 0x64, 0xc714 }, /* +EQ_WRT, +EQ_ACC, EQ_ADR=7, EQ_DATA_LO=0x14 */
+	{ 0x47, 0x63, 0x1ca3 }, /* EQ_DATA_HI=0x1ca3 */
+	{ 0x47, 0x64, 0xc8c7 }, /* +EQ_WRT, +EQ_ACC, EQ_ADR=8, EQ_DATA_LO=0xc7 */
+	{ 0x47, 0x63, 0xc38c }, /* EQ_DATA_HI=0xc38c */
+	{ 0x47, 0x64, 0xc914 }, /* +EQ_WRT, +EQ_ACC, EQ_ADR=9, EQ_DATA_LO=0x14 */
+	{ 0x47, 0x64, 0x0000 }, /* -EQ_ACC, -EQ_WRT */
+	{} /* Terminator */
+};
+
 /**
  * cs8409_enable_i2c_clock - Enable I2C clocks
  * @codec: the codec instance
@@ -2029,6 +2057,7 @@ static void cs8409_enable_ur(struct hda_codec *codec, int flag)
 static void cs8409_cs42l42_hw_init(struct hda_codec *codec)
 {
 	const struct cs8409_cir_param *seq = cs8409_cs42l42_hw_cfg;
+	const struct cs8409_cir_param *seq_bullseye = cs8409_cs42l42_bullseye_atn;
 	struct cs_spec *spec = codec->spec;
 
 	if (spec->gpio_mask) {
@@ -2043,6 +2072,10 @@ static void cs8409_cs42l42_hw_init(struct hda_codec *codec)
 	for (; seq->nid; seq++)
 		cs_vendor_coef_set(codec, seq->cir, seq->coeff);
 
+	if (codec->fixup_id == CS8409_BULLSEYE)
+		for (; seq_bullseye->nid; seq_bullseye++)
+			cs_vendor_coef_set(codec, seq_bullseye->cir, seq_bullseye->coeff);
+
 	/* Disable Unsolicited Response during boot */
 	cs8409_enable_ur(codec, 0);
 

