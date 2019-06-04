Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B51FD34342
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 11:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfFDJeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 05:34:09 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:43013 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726918AbfFDJeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 05:34:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 994CE3C1F;
        Tue,  4 Jun 2019 05:34:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 05:34:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZMDEFC
        E1JYsJbP29tVXHCBGF0zi2e+pY00cgULOQXu4=; b=P/o/vGypLdr5ry40npQELD
        QI76Y/chVpjHexvEW5pvJsJSCqxhGxKOXPHx/jHqy7wHPX7a6pPDfBgnTsnqf3Da
        J+mQUP5Lq/kCiZioVhpC0E6ORZorWx8DIwH50GYVNJdyqOhbEYESnWDKlLDGDXKX
        wJ7YtUpVIla2ln8A1evsgudtzZxstVuH15YFifEt12ZDNwzKOmgLtqPs900GzpAv
        nS8pQDt9+0ZoH01oODWZzFOttPlTBGmqj2uGVxGNxHUz6AXje7ieqe2CsH1c4aga
        yJf5Zc+lVuSixVkrHJsPJAhY7XHrSGRe2X6GyJd/riqftPTgY5f+xImICb6Hvq4A
        ==
X-ME-Sender: <xms:Dzv2XIP8OoXdjbq0vC27XZaR27E9PcDln-tUwhu-bHhXKzGKShQvyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehlrghunhgthhhprggurdhnvghtnecukfhppeekfedrkeeird
    ekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgt
    ohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Dzv2XJtG63PlWrDEbzlAasMZPZOe7e-skm8IkTtjhhXYfObtSV5qdQ>
    <xmx:Dzv2XOIhI0rNd14a4PmpjXd0DsOKynGlxIqtBReNIXbX93hA3djxJQ>
    <xmx:Dzv2XHfSBva6olmpEtgDkTE8tXgqtIbPB_g_2KJFtnpzH4WZjkU0WA>
    <xmx:EDv2XBynaolui8Ug-9EOwmjZWCN-JPWnkgaGhEJ8sCYM6ulrm2ZYMg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C6FF3380087;
        Tue,  4 Jun 2019 05:34:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek - Improve the headset mic for Acer Aspire" failed to apply to 4.14-stable tree
To:     hui.wang@canonical.com, chiu@endlessm.com, drake@endlessm.com,
        kailang@realtek.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 11:34:04 +0200
Message-ID: <155964084410076@kroah.com>
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

From 9cb40eb184c4220d244a532bd940c6345ad9dbd9 Mon Sep 17 00:00:00 2001
From: Hui Wang <hui.wang@canonical.com>
Date: Wed, 29 May 2019 12:41:38 +0800
Subject: [PATCH] ALSA: hda/realtek - Improve the headset mic for Acer Aspire
 laptops

We met another Acer Aspire laptop which has the problem on the
headset-mic, the Pin 0x19 is not set the corret configuration for a
mic and the pin presence can't be detected too after plugging a
headset. Kailang suggested that we should set the coeff to enable the
mic and apply the ALC269_FIXUP_LIFEBOOK_EXTMIC. After doing that,
both headset-mic presence and headset-mic work well.

The existing ALC255_FIXUP_ACER_MIC_NO_PRESENCE set the headset-mic
jack to be a phantom jack. Now since the jack can support presence
unsol event, let us imporve it to set the jack to be a normal jack.

https://bugs.launchpad.net/bugs/1821269
Fixes: 5824ce8de7b1c ("ALSA: hda/realtek - Add support for Acer Aspire E5-475 headset mic")
Cc: Chris Chiu <chiu@endlessm.com>
CC: Daniel Drake <drake@endlessm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f1bac03e954b..18cb48054e54 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6223,13 +6223,15 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chain_id = ALC269_FIXUP_THINKPAD_ACPI,
 	},
 	[ALC255_FIXUP_ACER_MIC_NO_PRESENCE] = {
-		.type = HDA_FIXUP_PINS,
-		.v.pins = (const struct hda_pintbl[]) {
-			{ 0x19, 0x01a1913c }, /* use as headset mic, without its own jack detect */
-			{ }
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* Enable the Mic */
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x45 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x5089 },
+			{}
 		},
 		.chained = true,
-		.chain_id = ALC255_FIXUP_HEADSET_MODE
+		.chain_id = ALC269_FIXUP_LIFEBOOK_EXTMIC
 	},
 	[ALC255_FIXUP_ASUS_MIC_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
@@ -7273,6 +7275,10 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x18, 0x02a11030},
 		{0x19, 0x0181303F},
 		{0x21, 0x0221102f}),
+	SND_HDA_PIN_QUIRK(0x10ec0255, 0x1025, "Acer", ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
+		{0x12, 0x90a60140},
+		{0x14, 0x90170120},
+		{0x21, 0x02211030}),
 	SND_HDA_PIN_QUIRK(0x10ec0255, 0x1025, "Acer", ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
 		{0x12, 0x90a601c0},
 		{0x14, 0x90171120},

