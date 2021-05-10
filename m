Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB06537847E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhEJKwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:52:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233748AbhEJKud (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:50:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06A2261954;
        Mon, 10 May 2021 10:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643202;
        bh=sFNkAUFqPkld7N7J8ph5F7w+KUBRpZjz87UnLlxrk8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahnpDcixIkiCuxD5KZ9o3Lc/pVG/+RXXI9c/hddS2pNAFpn4Vol+kmAmrn78WsJT5
         PoaQXbwkBW6pv+tXrQe7KeNHPbtH/NkPNBsKr3UR+lljrvl8PDEFcpUyt/3T1dr+w7
         LZW5cWi1tEB8M1ToDIi9pggq1W00bapY3Yibum2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eckhart Mohr <e.mohr@tuxedocomputers.com>,
        Werner Sembach <wse@tuxedocomputers.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 219/299] ALSA: hda/realtek: Add quirk for Intel Clevo PCx0Dx
Date:   Mon, 10 May 2021 12:20:16 +0200
Message-Id: <20210510102012.169103035@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

commit 970e3012c04c96351c413f193a9c909e6d871ce2 upstream.

This applies a SND_PCI_QUIRK(...) to the Clevo PCx0Dx barebones. This
fix enables audio output over the headset jack and ensures that a
microphone connected via the headset combo jack is correctly recognized
when pluged in.

[ Rearranged the list entries in a sorted order -- tiwai ]

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Co-developed-by: Werner Sembach <wse@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210427153025.451118-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2552,8 +2552,10 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1558, 0x65d1, "Clevo PB51[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65d2, "Clevo PB51R[CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65e1, "Clevo PB51[ED][DF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x65e5, "Clevo PC50D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67d1, "Clevo PB71[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e1, "Clevo PB71[DE][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x67e5, "Clevo PC70D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x70d1, "Clevo PC70[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x7714, "Clevo X170", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK_VENDOR(0x1558, "Clevo laptop", ALC882_FIXUP_EAPD),


