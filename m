Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2A437C165
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhELO7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:59:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232045AbhELO5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:57:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CEB061425;
        Wed, 12 May 2021 14:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831352;
        bh=q3aKXAH4spsmzc0F33Z0G+ehCbWXZEKD1iat1FGcYlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvKCJxqRafK4vUV2Yw1nmYvvrujHNeYTeBHacIiwrU6emCBxnzeQRKcpBrIZkhynX
         0o3fk2U6vBHRYuxYO5IJPazPKNj4ugnO4u/7jKzauvGjHn2m38505wsk2eK9aA/Fpl
         GgkbiEzr3Loj/vdKnVXyF6s0TeMhtPw0k1izRwAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 050/244] ALSA: hda/realtek: Re-order ALC269 Sony quirk table entries
Date:   Wed, 12 May 2021 16:47:01 +0200
Message-Id: <20210512144744.651439241@linuxfoundation.org>
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

commit cab561f8d4bc9b196ae20c960aa5da89fd786ab5 upstream.

Just re-order the alc269_fixup_tbl[] entries for Sony devices for
avoiding the oversight of the duplicated or unapplied item in future.
No functional changes.

Also Cc-to-stable for the further patch applications.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210428112704.23967-9-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7979,12 +7979,12 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x8398, "ASUS P1005", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x83ce, "ASUS P1005", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x8516, "ASUS X101CH", ALC269_FIXUP_ASUS_X101),
-	SND_PCI_QUIRK(0x104d, 0x90b5, "Sony VAIO Pro 11", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0x104d, 0x90b6, "Sony VAIO Pro 13", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x104d, 0x9073, "Sony VAIO", ALC275_FIXUP_SONY_VAIO_GPIO2),
 	SND_PCI_QUIRK(0x104d, 0x907b, "Sony VAIO", ALC275_FIXUP_SONY_HWEQ),
 	SND_PCI_QUIRK(0x104d, 0x9084, "Sony VAIO", ALC275_FIXUP_SONY_HWEQ),
 	SND_PCI_QUIRK(0x104d, 0x9099, "Sony VAIO S13", ALC275_FIXUP_SONY_DISABLE_AAMIX),
+	SND_PCI_QUIRK(0x104d, 0x90b5, "Sony VAIO Pro 11", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x104d, 0x90b6, "Sony VAIO Pro 13", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x10cf, 0x1475, "Lifebook", ALC269_FIXUP_LIFEBOOK),
 	SND_PCI_QUIRK(0x10cf, 0x159f, "Lifebook E780", ALC269_FIXUP_LIFEBOOK_NO_HP_TO_LINEOUT),
 	SND_PCI_QUIRK(0x10cf, 0x15dc, "Lifebook T731", ALC269_FIXUP_LIFEBOOK_HP_PIN),


