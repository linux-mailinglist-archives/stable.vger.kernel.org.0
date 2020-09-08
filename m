Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914E3261E8C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730585AbgIHTws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:52:48 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:57449 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730260AbgIHPsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 11:48:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 8CE19F7D;
        Tue,  8 Sep 2020 07:59:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 08 Sep 2020 07:59:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=k0D0mG
        6epurme9F9+N42qu0YqiRtudIsXBCA8bdLYcU=; b=CZ7zJHWiXAVO2y8jwM71Gj
        IScvpz4ktMQN9b5VhmAmfW3ksxO3B0eKghrAz4gmX5BTFtAp+iiA6US/1teF8Bpn
        UvjGk//CyAw8Y3vMmhjlCTpkIp7AiRLux7kdPxViJnU+KNMQwlztEsQiwBqxy0CM
        Tovp+4w9H5htDDUMbLDRu1FeclyyT5kFsWj228Ihgn9oYMt+PACoeDUAvulmHIR0
        hXNxZgHnNRH7dSAUGRUgEL9K8JJxy8+tQc4vGEv5kBbKtLtCiT7NjwBOEKOK97U2
        fwV2dO7h/bB8lczZ3lF5pj02sHBpeS1xcQD6SelPueDsQRbo+3NFCEXC2OJCY5WA
        ==
X-ME-Sender: <xms:FnJXX33aqWWCO7CjeOMfc_CVW0nAMqyX19Zvj74Y7C8TJJTuegJ05A>
    <xme:FnJXX2Fx0PwX2eSaJVOtO8ETc-KCn1jhQfwALsiBeAhJ2BqKZ3hoEqsw6FdKjId4L
    oAj0LDhit8VWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehfedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:FnJXX37EaYVct4SoOmVEHcondODQsjT8T1xKvY6VT-rzpdynQ0BFyw>
    <xmx:FnJXX81JnYFahNdopUJuP1f8aGVXqwcQK55ttLKxDCgnz5eXFts4pw>
    <xmx:FnJXX6Fehouyp3ZH5eEB3ebD9mtU5pJbFX_AGNvDim2kg3wK6aREjg>
    <xmx:FnJXX1OzL7Sv9ufNp4dCkycynBrZYVxSzcypo7qI1lah2pXJ7ahP50jjxL8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9B98B3064610;
        Tue,  8 Sep 2020 07:59:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA; firewire-tascam: exclude Tascam FE-8 from detection" failed to apply to 4.9-stable tree
To:     o-takashi@sakamocchi.jp, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Sep 2020 13:59:23 +0200
Message-ID: <1599566363128138@kroah.com>
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

