Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4655E811F
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 19:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbiIWRvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 13:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiIWRvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 13:51:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CF61296BE
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 10:51:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0226EB80FF1
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 17:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60810C433D6;
        Fri, 23 Sep 2022 17:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663955480;
        bh=YRX7rxvpIDaRsEoEje6Q/ul8GCMQQJfcuH05xhH007w=;
        h=Subject:To:Cc:From:Date:From;
        b=ZyUfGq1tckhwPfh7X/7q47wmgVU9bYn0Nb0ebTIPvs1ZX9iccK3ExZ5IlPCBuXa0A
         EOmiBXq+fujkBAGLEwaVjFJS2c0pkfw82Z7RRs7tTaJlnwjZNZRgr/nAHlXEz4dWrS
         c5jCdoiGXa6uOqkSF2kLCAdv/zaytn2sMYnxDABY=
Subject: FAILED: patch "[PATCH] ALSA: hda/realtek: Re-arrange quirk table entries" failed to apply to 4.14-stable tree
To:     tiwai@suse.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 23 Sep 2022 19:51:09 +0200
Message-ID: <16639554692891@kroah.com>
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

b16c8f229a58 ("ALSA: hda/realtek: Re-arrange quirk table entries")
b7557267c233 ("ALSA: hda/realtek: Add quirk for ASUS GA402")
94db9cc8f8fa ("ALSA: hda/realtek: Add quirk for ASUS GU603")
3cd0ed636dd1 ("ALSA: hda/realtek: Re-order ALC269 ASUS quirk table entries")
5cfca59604e4 ("ALSA: hda/realtek - Enable headset mic of ASUS X430UN with ALC256")
ef9ce66fab95 ("ALSA: hda/realtek - Enable headphone for ASUS TM420")
8a8de09cb2ad ("ALSA: hda/realtek - Fixed HP headset Mic can't be detected")
08befca40026 ("ALSA: hda/realtek - Add mute Led support for HP Elitebook 845 G7")
13468bfa8c58 ("ALSA: hda/realtek - set mic to auto detect on a HP AIO machine")
fc19d559b0d3 ("ALSA: hda/realtek - The Mic on a RedmiBook doesn't work")
23dc95868944 ("ALSA: hda/realtek: Add model alc298-samsung-headphone")
e2d2fded6bdf ("ALSA: hda/realtek: Fix pin default on Intel NUC 8 Rugged")
f1ec5be17b9a ("ALSA: hda/realtek: Add alc269/alc662 pin-tables for Loongson-3 laptops")
5649625344fe ("ALSA: hda/realtek - Fixed HP right speaker no sound")
293a92c1d991 ("ALSA: hda/realtek: typo_fix: enable headset mic of ASUS ROG Zephyrus G14(GA401) series with ALC289")
4b43d05a1978 ("ALSA: hda/realtek: enable headset mic of ASUS ROG Zephyrus G15(GA502) series with ALC289")
f50a121d2f32 ("ALSA: hda/realtek: Enable headset mic of Acer TravelMate B311R-31 with ALC256")
ff53664daff2 ("ALSA: hda/realtek: enable headset mic of ASUS ROG Zephyrus G14(G401) series with ALC289")
781c90c034d9 ("ALSA: hda/realtek: Enable headset mic of Acer Veriton N4660G with ALC269VC")
6e15d1261d52 ("ALSA: hda/realtek: Enable headset mic of Acer C20-820 with ALC269VC")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b16c8f229a58eaddfc58aab447253464abd3c85e Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Thu, 15 Sep 2022 17:47:24 +0200
Subject: [PATCH] ALSA: hda/realtek: Re-arrange quirk table entries

A few entries have been mistakenly inserted in wrong positions without
considering the SSID ordering.  Place them at right positions.

Fixes: b7557267c233 ("ALSA: hda/realtek: Add quirk for ASUS GA402")
Fixes: 94db9cc8f8fa ("ALSA: hda/realtek: Add quirk for ASUS GU603")
Fixes: 739d0959fbed ("ALSA: hda: Add quirk for ASUS Flow x13")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220915154724.31634-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d309304cdc46..90fde53e6956 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9341,10 +9341,11 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x13b0, "ASUS Z550SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
+	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
+	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1740, "ASUS UX430UA", ALC295_FIXUP_ASUS_DACS),
 	SND_PCI_QUIRK(0x1043, 0x17d1, "ASUS UX431FL", ALC294_FIXUP_ASUS_DUAL_SPK),
-	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1881, "ASUS Zephyrus S/M", ALC294_FIXUP_ASUS_GX502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),
@@ -9361,13 +9362,12 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1bbd, "ASUS Z550MA", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1c23, "Asus X55U", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
-	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
-	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x834a, "ASUS S101", ALC269_FIXUP_STEREO_DMIC),

