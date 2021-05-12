Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B628837C33A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhELPR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:17:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234221AbhELPQP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:16:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03BE36194F;
        Wed, 12 May 2021 15:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831947;
        bh=BRPwrXsP9YWXAQ3WKN8Ihu9DTactgcTnJeM9LGSCjXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDb+3ULoGrYk4rg2SsHGd3fyyJU+p1O24yPe6Yuff0kAf0ObKWX3LosnHRDzbaevD
         MOB+2Qs/UODrBGiLXQyc3ECNh/lYoDMWZxCJm7u/6cb1UfLutpmgqN1BMEG72OJI7v
         yYvt7h/+WMocO5GGJVE9ZthAkUa9o4WL+b72TyNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 080/530] ALSA: hda/realtek: Re-order ALC662 quirk table entries
Date:   Wed, 12 May 2021 16:43:10 +0200
Message-Id: <20210512144822.411173328@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
@@ -10060,6 +10060,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x1025, 0x0349, "eMachines eM250", ALC662_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x034a, "Gateway LT27", ALC662_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
+	SND_PCI_QUIRK(0x1025, 0x0566, "Acer Aspire Ethos 8951G", ALC669_FIXUP_ACER_ASPIRE_ETHOS),
 	SND_PCI_QUIRK(0x1025, 0x123c, "Acer Nitro N50-600", ALC662_FIXUP_ACER_NITRO_HEADSET_MODE),
 	SND_PCI_QUIRK(0x1025, 0x124e, "Acer 2660G", ALC662_FIXUP_ACER_X2660G_HEADSET_MODE),
 	SND_PCI_QUIRK(0x1028, 0x05d8, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
@@ -10076,9 +10077,9 @@ static const struct snd_pci_quirk alc662
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
@@ -10098,7 +10099,6 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x1b0a, 0x01b8, "ACER Veriton", ALC662_FIXUP_ACER_VERITON),
 	SND_PCI_QUIRK(0x1b35, 0x1234, "CZC ET26", ALC662_FIXUP_CZC_ET26),
 	SND_PCI_QUIRK(0x1b35, 0x2206, "CZC P10T", ALC662_FIXUP_CZC_P10T),
-	SND_PCI_QUIRK(0x1025, 0x0566, "Acer Aspire Ethos 8951G", ALC669_FIXUP_ACER_ASPIRE_ETHOS),
 
 #if 0
 	/* Below is a quirk table taken from the old code.


