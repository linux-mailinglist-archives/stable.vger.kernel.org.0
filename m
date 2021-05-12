Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7546937C11F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbhELO4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232178AbhELOzj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:55:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A438961432;
        Wed, 12 May 2021 14:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831271;
        bh=9xdEDKA/t+PIxcFEu0xGNcoFEBTbfVh37PmeNX7YrIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+iXzAC6+oFnGNd3KohnWE1/JKmI8WzCABIqMB+TbJ6NGwpWQCnOekttvpbrCL1cB
         L49ouHqgLPzdUx+QXYcJ/M+erMPIrQys5wSVS6iS8AcqYO5RQ4VXihgTBlal+cw3yY
         klzOgXq1dNSdoPggt27a012sr04xn0IXku53ZsK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 053/244] ALSA: hda/realtek: Re-order ALC662 quirk table entries
Date:   Wed, 12 May 2021 16:47:04 +0200
Message-Id: <20210512144744.744097700@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 9edeb1109d05953b2f0e24e5b2341a98c3fa78d5 upstream.

Just re-order the alc662_fixup_tbl[] entries for Acer and ASUS devices
for avoiding the oversight of the duplicated or unapplied item in
future.
No functional changes.

Also Cc-to-stable for the further patch applications.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210428112704.23967-12-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9880,6 +9880,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x1025, 0x0349, "eMachines eM250", ALC662_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x034a, "Gateway LT27", ALC662_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
+	SND_PCI_QUIRK(0x1025, 0x0566, "Acer Aspire Ethos 8951G", ALC669_FIXUP_ACER_ASPIRE_ETHOS),
 	SND_PCI_QUIRK(0x1025, 0x123c, "Acer Nitro N50-600", ALC662_FIXUP_ACER_NITRO_HEADSET_MODE),
 	SND_PCI_QUIRK(0x1025, 0x124e, "Acer 2660G", ALC662_FIXUP_ACER_X2660G_HEADSET_MODE),
 	SND_PCI_QUIRK(0x1028, 0x05d8, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
@@ -9896,9 +9897,9 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x103c, 0x873e, "HP", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x1043, 0x1080, "Asus UX501VW", ALC668_FIXUP_HEADSET_MODE),
 	SND_PCI_QUIRK(0x1043, 0x11cd, "Asus N550", ALC662_FIXUP_ASUS_Nx50),
-	SND_PCI_QUIRK(0x1043, 0x13df, "Asus N550JX", ALC662_FIXUP_BASS_1A),
 	SND_PCI_QUIRK(0x1043, 0x129d, "Asus N750", ALC662_FIXUP_ASUS_Nx50),
 	SND_PCI_QUIRK(0x1043, 0x12ff, "ASUS G751", ALC668_FIXUP_ASUS_G751),
+	SND_PCI_QUIRK(0x1043, 0x13df, "Asus N550JX", ALC662_FIXUP_BASS_1A),
 	SND_PCI_QUIRK(0x1043, 0x1477, "ASUS N56VZ", ALC662_FIXUP_BASS_MODE4_CHMAP),
 	SND_PCI_QUIRK(0x1043, 0x15a7, "ASUS UX51VZH", ALC662_FIXUP_BASS_16),
 	SND_PCI_QUIRK(0x1043, 0x177d, "ASUS N551", ALC668_FIXUP_ASUS_Nx51),
@@ -9918,7 +9919,6 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x1b0a, 0x01b8, "ACER Veriton", ALC662_FIXUP_ACER_VERITON),
 	SND_PCI_QUIRK(0x1b35, 0x1234, "CZC ET26", ALC662_FIXUP_CZC_ET26),
 	SND_PCI_QUIRK(0x1b35, 0x2206, "CZC P10T", ALC662_FIXUP_CZC_P10T),
-	SND_PCI_QUIRK(0x1025, 0x0566, "Acer Aspire Ethos 8951G", ALC669_FIXUP_ACER_ASPIRE_ETHOS),
 
 #if 0
 	/* Below is a quirk table taken from the old code.


