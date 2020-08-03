Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5717223A6ED
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgHCMWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726955AbgHCMWL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:22:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D44672076E;
        Mon,  3 Aug 2020 12:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457330;
        bh=4G/hq+dWt7uTc7mT1QzkDw9j+ydSD1QMGb59w7BHS+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWnGuOQpPquS+6CSCTOwngCCmlyJO24W4zFdmRw+d8AsIrcbJj7spLKWxkHuR3fdh
         asBxkUoPuGLkhi4NM+fwc1qeDGvwJPJpZdfhsVXatDDbeBoZfVMRqcACNg3/qbAZT5
         0X7LNkbF0HRPGU0YBnc9EnQwoaMKe/WuXw5Wifa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Armas Spann <zappel@retarded.farm>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.7 005/120] ALSA: hda/realtek: typo_fix: enable headset mic of ASUS ROG Zephyrus G14(GA401) series with ALC289
Date:   Mon,  3 Aug 2020 14:17:43 +0200
Message-Id: <20200803121903.120043726@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Armas Spann <zappel@retarded.farm>

commit 293a92c1d9913248b9987b68f3a5d6d2f0aae62b upstream.

This patch fixes a small typo I accidently submitted with the initial patch. The board should be named GA401 not G401.

Fixes: ff53664daff2 ("ALSA: hda/realtek: enable headset mic of ASUS ROG Zephyrus G14(G401) series with ALC289")
Signed-off-by: Armas Spann <zappel@retarded.farm>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200724140837.302763-1-zappel@retarded.farm
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6117,7 +6117,7 @@ enum {
 	ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS,
 	ALC269VC_FIXUP_ACER_HEADSET_MIC,
 	ALC269VC_FIXUP_ACER_MIC_NO_PRESENCE,
-	ALC289_FIXUP_ASUS_G401,
+	ALC289_FIXUP_ASUS_GA401,
 	ALC289_FIXUP_ASUS_GA502,
 	ALC256_FIXUP_ACER_MIC_NO_PRESENCE,
 };
@@ -7329,7 +7329,7 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MIC
 	},
-	[ALC289_FIXUP_ASUS_G401] = {
+	[ALC289_FIXUP_ASUS_GA401] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
 			{ 0x19, 0x03a11020 }, /* headset mic with jack detect */
@@ -7535,7 +7535,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1c23, "Asus X55U", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
-	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_G401),
+	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x834a, "ASUS S101", ALC269_FIXUP_STEREO_DMIC),


