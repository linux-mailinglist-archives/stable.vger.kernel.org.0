Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C744261429
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730981AbgIHQHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:07:30 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:36741 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731106AbgIHQG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 12:06:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 1B144F6D;
        Tue,  8 Sep 2020 07:59:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 08 Sep 2020 07:59:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=drP9z5
        GNx4ImftOf4SiGHgAOmYLknMpBuOychzPpL/M=; b=JPpdUJB6eddsZUFwS9g1vd
        dff+glpK/Z5bxDHPV1t3U/pbKRvxiLUEppYJfzp84GES8bsro7B8YpfN7Qvnwh8E
        /tVMyvEzg3qJtRY0j3/WJZS5PPRo0Umw+LIsg19/1fs1T8ZTbE9m7B4sWqc8015J
        2PZSKCchkfxxOch8zdzQGkSc6AKphOGCgERU9l5ICDAypMJq+t7gxkmUYhUXelaq
        DKiATioOyxNup58t5beSmodngWPuFVJH0vNzGpQVHFTtGoghmWI4B3MEOZCCCs4L
        4F5jXTNGP/mQeFk8/JXU9gTYgXsuHk4ldscJ4pRS1SNCerQHHzmepyG5345RsRtg
        ==
X-ME-Sender: <xms:D3JXXzvaVLlf3oWjJP9sWa-dygwYFMZjlKC0FZXLFAFpqrHov8Gr5A>
    <xme:D3JXX0cJjMVpyfr0RvXzcyS0B0EWFRdtfcPXF4hUC220UmQAhYxqhT5KN1FKNGDxh
    gsKdpTJY0foFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehfedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:D3JXX2wVygPX5eqCjc-x9OT3fSjQQH6l0TyuTSdLj3whZC8KcUHdGA>
    <xmx:D3JXXyOTvdjHJpEk85Rs-y2Oc7MRTeDlgqwwLlds69BHPce8rS4vnA>
    <xmx:D3JXXz_ccNUxMUTOwQdnXzp4P-L0NhRB7yYTiKSysQDHMd4Rp-KVVA>
    <xmx:D3JXXwH0Q1Uz7FDQU9Xwu-MjATWXTzdtXAtskSLSo8NJjkwG4xOb8sHyYTI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5DBC0328005D;
        Tue,  8 Sep 2020 07:59:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA; firewire-tascam: exclude Tascam FE-8 from detection" failed to apply to 4.4-stable tree
To:     o-takashi@sakamocchi.jp, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Sep 2020 13:59:22 +0200
Message-ID: <1599566362199225@kroah.com>
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

From 0bd8bce897b6697bbc286b8ba473aa0705fe394b Mon Sep 17 00:00:00 2001
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Date: Sun, 23 Aug 2020 16:55:37 +0900
Subject: [PATCH] ALSA; firewire-tascam: exclude Tascam FE-8 from detection

Tascam FE-8 is known to support communication by asynchronous transaction
only. The support can be implemented in userspace application and
snd-firewire-ctl-services project has the support. However, ALSA
firewire-tascam driver is bound to the model.

This commit changes device entries so that the model is excluded. In a
commit 53b3ffee7885 ("ALSA: firewire-tascam: change device probing
processing"), I addressed to the concern that version field in
configuration differs depending on installed firmware. However, as long
as I checked, the version number is fixed. It's safe to return version
number back to modalias.

Fixes: 53b3ffee7885 ("ALSA: firewire-tascam: change device probing processing")
Cc: <stable@vger.kernel.org> # 4.4+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20200823075537.56255-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/firewire/tascam/tascam.c b/sound/firewire/tascam/tascam.c
index 5dac0d9fc58e..75f2edd8e78f 100644
--- a/sound/firewire/tascam/tascam.c
+++ b/sound/firewire/tascam/tascam.c
@@ -39,9 +39,6 @@ static const struct snd_tscm_spec model_specs[] = {
 		.midi_capture_ports = 2,
 		.midi_playback_ports = 4,
 	},
-	// This kernel module doesn't support FE-8 because the most of features
-	// can be implemented in userspace without any specific support of this
-	// module.
 };
 
 static int identify_model(struct snd_tscm *tscm)
@@ -211,11 +208,39 @@ static void snd_tscm_remove(struct fw_unit *unit)
 }
 
 static const struct ieee1394_device_id snd_tscm_id_table[] = {
+	// Tascam, FW-1884.
+	{
+		.match_flags = IEEE1394_MATCH_VENDOR_ID |
+			       IEEE1394_MATCH_SPECIFIER_ID |
+			       IEEE1394_MATCH_VERSION,
+		.vendor_id = 0x00022e,
+		.specifier_id = 0x00022e,
+		.version = 0x800000,
+	},
+	// Tascam, FE-8 (.version = 0x800001)
+	// This kernel module doesn't support FE-8 because the most of features
+	// can be implemented in userspace without any specific support of this
+	// module.
+	//
+	// .version = 0x800002 is unknown.
+	//
+	// Tascam, FW-1082.
+	{
+		.match_flags = IEEE1394_MATCH_VENDOR_ID |
+			       IEEE1394_MATCH_SPECIFIER_ID |
+			       IEEE1394_MATCH_VERSION,
+		.vendor_id = 0x00022e,
+		.specifier_id = 0x00022e,
+		.version = 0x800003,
+	},
+	// Tascam, FW-1804.
 	{
 		.match_flags = IEEE1394_MATCH_VENDOR_ID |
-			       IEEE1394_MATCH_SPECIFIER_ID,
+			       IEEE1394_MATCH_SPECIFIER_ID |
+			       IEEE1394_MATCH_VERSION,
 		.vendor_id = 0x00022e,
 		.specifier_id = 0x00022e,
+		.version = 0x800004,
 	},
 	{}
 };

