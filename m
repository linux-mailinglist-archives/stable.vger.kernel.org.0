Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3467230C092
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbhBBOBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:01:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232992AbhBBN7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:59:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EA1764FF4;
        Tue,  2 Feb 2021 13:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273584;
        bh=O+PoMpROyQbmr5x4sW6qxbZR2vpOPu1VK0sKg65xPxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBTY7DQ1wilW3M3dwUTOLKzVGqePgEbgUz20CHvS4CAI30C92geJwXJwXcxAY42F7
         oGs/39A8yShB1hsur/L0TKVFDWurberlVN9FDKJyANMg8nnd7Isa3Fm9aUa3VhL3Gu
         QRapgcd23L7AGnfGp6OKr/yVVUQAbVjjf2xDkjfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian-Hong Pan <jhp@endlessos.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 06/61] ALSA: hda/realtek: Enable headset of ASUS B1400CEPE with ALC256
Date:   Tue,  2 Feb 2021 14:37:44 +0100
Message-Id: <20210202132946.748492248@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian-Hong Pan <jhp@endlessos.org>

commit 5de3b9430221b11a5e1fc2f5687af80777c8392a upstream.

ASUS B1400CEPE laptop's headset audio is not enabled until
ALC256_FIXUP_ASUS_HPE quirk is applied.

Here is the original pin node values:

0x12 0x40000000
0x13 0x411111f0
0x14 0x90170110
0x18 0x411111f0
0x19 0x411111f0
0x1a 0x411111f0
0x1b 0x411111f0
0x1d 0x40461b45
0x1e 0x411111f0
0x21 0x04211020

Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210122054705.48804-1-jhp@endlessos.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7907,6 +7907,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x194e, "ASUS UX563FD", ALC294_FIXUP_ASUS_HPE),
+	SND_PCI_QUIRK(0x1043, 0x1982, "ASUS B1400CEPE", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19e1, "ASUS UX581LV", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),


