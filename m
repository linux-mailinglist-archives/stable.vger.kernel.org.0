Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA98431DA7
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhJRNyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:54:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233226AbhJRNvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:51:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BCBA6187D;
        Mon, 18 Oct 2021 13:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564295;
        bh=PZJKFPLbi6D97Zsen3k0r8/MiFX2MDOfvGJQNi47bUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRfJx1u4WQG4GfEPMSPiWtjxB5I5BRzj4I2y4HOVvH0en9q1yS9UuEoH/BLmH2/B0
         v/HpomslOFr90UVMwsAs+bdVzWZQNviTdmESWGHWvw5oB6qt/zBm2tw1+nss/R1WbP
         o/y3ggwE+yq/9l1VbFB59pmSuMt9Ty+vxsMo1D3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Werner Sembach <wse@tuxedocomputers.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 007/151] ALSA: hda/realtek: Complete partial device name to avoid ambiguity
Date:   Mon, 18 Oct 2021 15:23:06 +0200
Message-Id: <20211018132340.921865561@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Werner Sembach <wse@tuxedocomputers.com>

commit 1f8d398e1cd8813f8ec16d55c086e8270a9c18ab upstream.

The string "Clevo X170" is not enough to unambiguously identify the correct
device.

Fixing it so another Clevo barebone name starting with "X170" can be added
without causing confusion.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211001133111.428249-2-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2549,7 +2549,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1558, 0x67e1, "Clevo PB71[DE][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e5, "Clevo PC70D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x70d1, "Clevo PC70[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
-	SND_PCI_QUIRK(0x1558, 0x7714, "Clevo X170", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x7714, "Clevo X170SM", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x9501, "Clevo P950HR", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1558, 0x9506, "Clevo P955HQ", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1558, 0x950a, "Clevo P955H[PR]", ALC1220_FIXUP_CLEVO_P950),


