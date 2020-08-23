Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D51224EC06
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 09:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgHWHzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 03:55:44 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:60637 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727792AbgHWHzn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 03:55:43 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 31C189D2;
        Sun, 23 Aug 2020 03:55:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 23 Aug 2020 03:55:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=IrCmyO1hiKxuQwf57QOo9Vtkr+
        OdE2H1gJdT+fs0D3Q=; b=SZi+TmXqBxOFRSCCXqRQBaQwv8aBg6Il4ZIofNBb+Z
        CErQDF5DtvFL+veg8Y/ZlL0flhY+w3uk4EsYD/iL/PUfBqR4zw93UCy8g43MfInC
        2vSP1log1c7UA86N+bz7b2FLRnoy5yP12KkwXbLG+54Vcd/dkaBDqYwbPo/8NDpg
        uvjCyfGr7S7Ibr7wbQbixG+sBBmkL/XoleuGE3kKLWitXkIJIuTbOeiyxSmzymo0
        jOKb2NVVEWFXcVrdAjk04U+dDjxPSNzEhFnbZVqEjiSbbEIHXLxKODFsL7+IfXJG
        eZ8E0U0NJr6L8vsfFSYcjvJTMsOOch7I35g68u2N1Dog==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=IrCmyO1hiKxuQwf57
        QOo9Vtkr+OdE2H1gJdT+fs0D3Q=; b=Hutrz1rkwwyr92LT4otnbPa+58tjvFoFl
        IN2JEfinigdF72tWNcmBajZlpSv2uouDwL94TOKlI4NMHeRbcGXteeSMJ96Hc7Ul
        0VlcJ+3zgheWoyjMboIRQOdYVosqsuaS9GKJx0HfH0W7/OD4acYjzuzsqDLkqhQU
        3eFWZDnNYzmiFMrDJUodM2dOAhXxHQDxEiv0RxWQFIvVRYaZ7KZ3FYDWH199o8Le
        13Xr3Zt7kN9mATvkWLuzkUTMS04aIP2mTius0l6FKkC2QlEkYwxAktcYoiDjyQS5
        UhEOtr8RhGTrpOXsAvkA96+7n0ATgR8TWSpr1GiMKSFUf3efM+JGw==
X-ME-Sender: <xms:_CBCXxRQ33Xh_NDDy3jSxy191B6T_OZZL5J-kroeTwYPg1nFAra8SA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduhedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefvrghkrghshhhiucfurghkrghmohhtohcuoehoqdhtrghkrghs
    hhhisehsrghkrghmohgttghhihdrjhhpqeenucggtffrrghtthgvrhhnpedujeetlefhtd
    dtkefgtdeuieelhffgteejjeehkeegveduvdevgeeiheeuueekjeenucfkphepudektddr
    vdefhedrfedrheegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:_CBCX6wsbURYJ6DPbb3RJo1YxuCAQQs6GdGLrV_lp66dCR2ZE9JyDg>
    <xmx:_CBCX23ljoavcrHw3iZkmpts2GXLPhSWpR3X9Bdy9HU7oFZ44W6EqQ>
    <xmx:_CBCX5AJV_gakP_psrEqecn7KnCL8u0I4yVa7u1ikSAi5whjpOBQWw>
    <xmx:_SBCXyJj-Bz1xJ61wpTf9nej-aV5PSALdvNT-xL3oIwf8YokSePrYA>
Received: from workstation.flets-east.jp (ad003054.dynamic.ppp.asahi-net.or.jp [180.235.3.54])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE58A30600A3;
        Sun, 23 Aug 2020 03:55:39 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] ALSA; firewire-tascam: exclude Tascam FE-8 from detection
Date:   Sun, 23 Aug 2020 16:55:37 +0900
Message-Id: <20200823075537.56255-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 sound/firewire/tascam/tascam.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

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
-- 
2.25.1

