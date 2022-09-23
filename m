Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000285E818D
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 20:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiIWSJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 14:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbiIWSJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 14:09:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350B02A42D
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 11:09:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4B53B8241F
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 18:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE75C433C1;
        Fri, 23 Sep 2022 18:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663956562;
        bh=4UG2Tj/jNSRavp3hIAmpHdMEixG+mfhBwKNoi2pS6R4=;
        h=Subject:To:Cc:From:Date:From;
        b=aABiFNPizpShujQpHM/q6pqqXqtQG0SYDY+CrkyT2opPcL36N84kTcriC9cin2XFr
         7udzSzjm6cXDGu6v2JX3MQEBU/DlOmZ5cMVRgHJXeZI9ubPbq56cc1S3sOGw3xHFI5
         9nLrizH43CYFI3n368/Ai/zz8A1yIWfwKxf+wkVo=
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek: Enable 4-speaker output Dell Precision" failed to apply to 4.14-stable tree
To:     callum.osmotherly@gmail.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 23 Sep 2022 20:09:19 +0200
Message-ID: <16639565595378@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1885ff13d4c4 ("ALSA: hda/realtek: Enable 4-speaker output Dell Precision 5530 laptop")
136824efaab2 ("ALSA: hda/realtek - Add support headset mode for DELL WYSE AIO")
c8a9afa632f0 ("ALSA: hda/realtek: merge alc_fixup_headset_jack to alc295_fixup_chromebook")
10f5b1b85ed1 ("ALSA: hda/realtek - Fixed Headset Mic JD not stable")
cbc05fd6708c ("ALSA: hda/realtek: Enable headset MIC of Acer TravelMate X514-51T with ALC255")
c8c6ee611926 ("ALSA: hda/realtek: Disable PC beep in passthrough on alc285")
89e3a5682eda ("ALSA: hda/realtek - Headset microphone support for System76 darp5")
d1dd42110d27 ("ALSA: hda/realtek - Disable headset Mic VREF for headset mode of ALC225")
c2a7c55a0406 ("ALSA: hda/realtek - Support Dell headset mode for New AIO platform")
46079bacb469 ("Merge branch 'for-linus' into for-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1885ff13d4c42910b37a0e3f7c2f182520f4eed1 Mon Sep 17 00:00:00 2001
From: Callum Osmotherly <callum.osmotherly@gmail.com>
Date: Thu, 15 Sep 2022 22:36:08 +0930
Subject: [PATCH] ALSA: hda/realtek: Enable 4-speaker output Dell Precision
 5530 laptop

Just as with the 5570 (and the other Dell laptops), this enables the two
subwoofer speakers on the Dell Precision 5530 together with the main
ones, significantly increasing the audio quality. I've tested this
myself on a 5530 and can confirm it's working as expected.

Signed-off-by: Callum Osmotherly <callum.osmotherly@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YyMjQO3mhyXlMbCf@piranha
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e722885da5f6..d309304cdc46 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9149,6 +9149,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0871, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0872, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0873, "Dell Precision 3930", ALC255_FIXUP_DUMMY_LINEOUT_VERB),
+	SND_PCI_QUIRK(0x1028, 0x087d, "Dell Precision 5530", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x08ad, "Dell WYSE AIO", ALC225_FIXUP_DELL_WYSE_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x08ae, "Dell WYSE NB", ALC225_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0935, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB),

