Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81ED37C7C9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbhELQCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235112AbhELPyP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:54:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2461261420;
        Wed, 12 May 2021 15:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833241;
        bh=Al+dmTqUWbeemajTi9SkzKs3Hb2QwcXWbn7vX+mbfbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqsWq3Jc+vJc0X7rQc3nXD5G4VTH5+t6bjHY67DEbVJcwxuxT1PllSh61y9/fP8c8
         yLhHV6W4Ruk7m72wyCRu5cB5GqhBNlonZRTTd+6RGWok1j4gii3psrb+Gi4WVJ9cZU
         /Cyme73ezPq1W0OV+oxeHd1S6gKH8TlOR7jX0sIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 075/601] ALSA: hda/realtek: Re-order ALC882 Acer quirk table entries
Date:   Wed, 12 May 2021 16:42:32 +0200
Message-Id: <20210512144830.295589681@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit b265047ac56bad8c4f3d0c8bf9cb4e828ee0d28e upstream.

Just re-order the alc882_fixup_tbl[] entries for Acer devices for
avoiding the oversight of the duplicated or unapplied item in future.
No functional changes.

Also Cc-to-stable for the further patch applications.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210428112704.23967-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2470,13 +2470,13 @@ static const struct snd_pci_quirk alc882
 		      ALC882_FIXUP_ACER_ASPIRE_8930G),
 	SND_PCI_QUIRK(0x1025, 0x0146, "Acer Aspire 6935G",
 		      ALC882_FIXUP_ACER_ASPIRE_8930G),
+	SND_PCI_QUIRK(0x1025, 0x0142, "Acer Aspire 7730G",
+		      ALC882_FIXUP_ACER_ASPIRE_4930G),
+	SND_PCI_QUIRK(0x1025, 0x0155, "Packard-Bell M5120", ALC882_FIXUP_PB_M5210),
 	SND_PCI_QUIRK(0x1025, 0x015e, "Acer Aspire 6930G",
 		      ALC882_FIXUP_ACER_ASPIRE_4930G),
 	SND_PCI_QUIRK(0x1025, 0x0166, "Acer Aspire 6530G",
 		      ALC882_FIXUP_ACER_ASPIRE_4930G),
-	SND_PCI_QUIRK(0x1025, 0x0142, "Acer Aspire 7730G",
-		      ALC882_FIXUP_ACER_ASPIRE_4930G),
-	SND_PCI_QUIRK(0x1025, 0x0155, "Packard-Bell M5120", ALC882_FIXUP_PB_M5210),
 	SND_PCI_QUIRK(0x1025, 0x021e, "Acer Aspire 5739G",
 		      ALC882_FIXUP_ACER_ASPIRE_4930G),
 	SND_PCI_QUIRK(0x1025, 0x0259, "Acer Aspire 5935", ALC889_FIXUP_DAC_ROUTE),


