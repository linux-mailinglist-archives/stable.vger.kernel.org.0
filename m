Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACDF715D1
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387774AbfGWKPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:15:16 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:52565 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730145AbfGWKPQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:15:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9081F555;
        Tue, 23 Jul 2019 06:15:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:15:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=k7UmFA
        /ijvGCsN4Eg8dW9KiWT727vBmYhJrP24VMfok=; b=DMXZgVb58i3gaXKdiJ/W9/
        aCE07fOuv7ug1gFHurSTN8SJ1j9YR6tdnfKK41EpDXaSca4uqyaE0AVqFi/B9u/C
        ZXokiHaoiKypUwyw/g7RV1uQGwg1qOA8Bw0g5iKNlt5j2/Z4NRsl5REgflrjytEM
        6Er3786jL0NssuhkxqMoahlWMF3cmEEcNB72sWGuc7rFOnZ4N6Rf1IYTcqPd/mNp
        vljwwELvpGy9CYrnh27h6Dd40Z6q6iEMKU0QCGJP0WLvelDNegw8LFycY1Ic2Z3a
        MtJwMg3BkYSoQcM1uJVtqb9jcnpJQwDJzbT9RL1UA2Ee05WBcFj9u04hjyO75yNA
        ==
X-ME-Sender: <xms:M942Xf2RtPBZyk8yPVM6vHb4RTyRro0i_7GwRupxR4eCQgETg9IC5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:M942XXsp3I65jR25IgLy_bbRajMGXamX_rwb4Pve5g8HMaBCxuuWOw>
    <xmx:M942Xf4iODqUqdZd34LO-90786cEBGrYuetBhEqvUbwj4u4Fqls4Iw>
    <xmx:M942XYIi_fPXFGXxIeLuPg0cAaLU7E2zJ7PA_5pzaNco-_IJ9-5vYg>
    <xmx:M942XX0Z_qexF-5BVJ4D90bX9_HFjeFU4sd0Yi8kYN3ZY6ZXolfnmA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B714D80065;
        Tue, 23 Jul 2019 06:15:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek - Fixed Headphone Mic can't record on Dell" failed to apply to 4.9-stable tree
To:     kailang@realtek.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:15:12 +0200
Message-ID: <156387691210188@kroah.com>
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

From fbc571290d9f7bfe089c50f4ac4028dd98ebfe98 Mon Sep 17 00:00:00 2001
From: Kailang Yang <kailang@realtek.com>
Date: Mon, 15 Jul 2019 10:41:50 +0800
Subject: [PATCH] ALSA: hda/realtek - Fixed Headphone Mic can't record on Dell
 platform

It assigned to wrong model. So, The headphone Mic can't work.

Fixes: 3f640970a414 ("ALSA: hda - Fix headset mic detection problem for several Dell laptops")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f24a757f8239..1c84c12b39b3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7657,9 +7657,12 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x12, 0x90a60130},
 		{0x17, 0x90170110},
 		{0x21, 0x03211020}),
-	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1028, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE,
+	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 		{0x14, 0x90170110},
 		{0x21, 0x04211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
+		{0x14, 0x90170110},
+		{0x21, 0x04211030}),
 	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1028, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE,
 		ALC295_STANDARD_PINS,
 		{0x17, 0x21014020},

