Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D312137B9F3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhELKHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:07:16 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:33221 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230135AbhELKHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:07:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 07FEFF69;
        Wed, 12 May 2021 06:06:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 06:06:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=g7K875
        sQurDr/MZ4M9pqA8DZlJ2L6VT3ov/Fd/ygvcE=; b=eiF9XdJpfXdYD4fVarK0FH
        UV3zC5Uo7gSLJEZ0CKwp4fTcHNgFtjSf/ikDmQhL5Bhu1lxo6GoGWURktjtfLYVi
        0MAFGBRzdzA1kazic7sMra9qj6fSmyQ5ZeVvFuNvWmuFZeP8IHNbYHaKKerTZD4a
        M+AhwLUB0dgF2jREGdop08XKi92yggxXM9RoLorbwQYLJuBRnqqYkybYm2Yot3nK
        4JoHe3qr1VeY9hJCK54I6NDHX6RngId8xHelKAfqpYZFDcp70Ga4BcCY9hgFflks
        1mOM4/8sFYmn9RVtpkyY2T9fhIo2QSpH/FzsA8V+jauaDfNuHRRF+AhfIryXBiuQ
        ==
X-ME-Sender: <xms:jKibYO2fnddMjQuJRZyl2crH2m2ihhV0JZ6ZoPzUIcR4s7bp43olpA>
    <xme:jKibYBEiPqhhZ9rAS7-rvPfxZIHGpEoM3p8j9mfkYY98UxpuftRcmCa_Myv46uvww
    Ur0_MFba9Y3hg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnheptefhhffgjefgtdeihefgvdehieetuefgvefhgedvge
    dvgfdugfevgefgueeljedvnecuffhomhgrihhnpehlrghunhgthhhprggurdhnvghtpdhk
    vghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghruf
    hiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtgho
    mh
X-ME-Proxy: <xmx:jKibYG4fHJLIXBvRKGmWqfpEPJ0dVjSNNZ2z1DKUfgL6gAwfif4jkA>
    <xmx:jKibYP2hgRzieW-j5-YPvaRaEFE83f9C6SHNd78h59ICOdk5Ziv3pg>
    <xmx:jKibYBELO5JL4phPoxUIBAzJedy2NkMFB9_EGjA445Lw7OZZMwJYeQ>
    <xmx:jKibYBDhrtEOQCklXHwEfv67rP1OSUnwNnA8ozs1-K_pLy8vnBx3lo5HUbA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:06:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hda/cirrus: Set Initial DMIC volume for Bullseye to -26" failed to apply to 5.10-stable tree
To:     sbinding@opensource.cirrus.com, stable@vger.kernel.org,
        tiwai@suse.de, vicamo.yang@canonical.com,
        vitalyr@opensource.cirrus.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:05:49 +0200
Message-ID: <1620813949132157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0e853a9c3937caa9f13fdde547d6202f92457c2b Mon Sep 17 00:00:00 2001
From: Stefan Binding <sbinding@opensource.cirrus.com>
Date: Mon, 26 Apr 2021 17:37:48 +0100
Subject: [PATCH] ALSA: hda/cirrus: Set Initial DMIC volume for Bullseye to -26
 dB

After booting for first time on Bullseye, the DMIC is currently muted.
Instead, the DMIC volume should be set to a valid initial value.

Tested on DELL Inspiron-3505, DELL Inspiron-3501, DELL Inspiron-3500

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Vitaly Rodionov <vitalyr@opensource.cirrus.com>
BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1923557
Reported-and-tested-by: You-Sheng Yang <vicamo.yang@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210426163749.196153-2-vitalyr@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index 5d57096b3a95..a4f82f147ff3 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -2172,6 +2172,11 @@ static void cs8409_cs42l42_fixups(struct hda_codec *codec,
 			(get_wcaps(codec, CS8409_CS42L42_AMIC_PIN_NID) | AC_WCAP_UNSOL_CAP));
 		break;
 	case HDA_FIXUP_ACT_PROBE:
+
+		/* Set initial volume on Bullseye to -26 dB */
+		if (codec->fixup_id == CS8409_BULLSEYE)
+			snd_hda_codec_amp_init_stereo(codec, CS8409_CS42L42_DMIC_ADC_PIN_NID,
+					HDA_INPUT, 0, 0xff, 0x19);
 		snd_hda_gen_add_kctl(&spec->gen,
 			NULL, &cs8409_cs42l42_hp_volume_mixer);
 		snd_hda_gen_add_kctl(&spec->gen,

