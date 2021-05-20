Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08DD38A2D4
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhETJqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:46:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233719AbhETJoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:44:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09AD761446;
        Thu, 20 May 2021 09:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503188;
        bh=L5fofZOHSis60CyjvvEFi4iihJhq2ivW1qFpcqhGD6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZzDYFP2kowRynBGZdrK0LuetxikFlS1VTpGgGX3oLtmGnIzKWik7XSNZIr24Lb2W
         3DdjMX/PImVbwQcXfeOEUnFMvs1J62zWUX8MCsplSBi4lUzzPX/Hgcq7tBdVHHu8XB
         9iXOoWqVoLkZGaBXRnU4hyqaZwBkUgq/u81fM9wM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 075/425] ALSA: hda/conexant: Re-order CX5066 quirk table entries
Date:   Thu, 20 May 2021 11:17:24 +0200
Message-Id: <20210520092133.914102284@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 2e6a731296be9d356fdccee9fb6ae345dad96438 upstream.

Just re-order the cx5066_fixups[] entries for HP devices for avoiding
the oversight of the duplicated or unapplied item in future.
No functional changes.

Also Cc-to-stable for the further patch applications.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210428112704.23967-14-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -911,18 +911,18 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK(0x103c, 0x8079, "HP EliteBook 840 G3", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x807C, "HP EliteBook 820 G3", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x80FD, "HP ProBook 640 G2", CXT_FIXUP_HP_DOCK),
-	SND_PCI_QUIRK(0x103c, 0x828c, "HP EliteBook 840 G4", CXT_FIXUP_HP_DOCK),
-	SND_PCI_QUIRK(0x103c, 0x83b2, "HP EliteBook 840 G5", CXT_FIXUP_HP_DOCK),
-	SND_PCI_QUIRK(0x103c, 0x83b3, "HP EliteBook 830 G5", CXT_FIXUP_HP_DOCK),
-	SND_PCI_QUIRK(0x103c, 0x83d3, "HP ProBook 640 G4", CXT_FIXUP_HP_DOCK),
-	SND_PCI_QUIRK(0x103c, 0x8174, "HP Spectre x360", CXT_FIXUP_HP_SPECTRE),
 	SND_PCI_QUIRK(0x103c, 0x8115, "HP Z1 Gen3", CXT_FIXUP_HP_GATE_MIC),
 	SND_PCI_QUIRK(0x103c, 0x814f, "HP ZBook 15u G3", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x8174, "HP Spectre x360", CXT_FIXUP_HP_SPECTRE),
 	SND_PCI_QUIRK(0x103c, 0x822e, "HP ProBook 440 G4", CXT_FIXUP_MUTE_LED_GPIO),
-	SND_PCI_QUIRK(0x103c, 0x836e, "HP ProBook 455 G5", CXT_FIXUP_MUTE_LED_GPIO),
-	SND_PCI_QUIRK(0x103c, 0x837f, "HP ProBook 470 G5", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x828c, "HP EliteBook 840 G4", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x8299, "HP 800 G3 SFF", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x103c, 0x836e, "HP ProBook 455 G5", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x837f, "HP ProBook 470 G5", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x83b2, "HP EliteBook 840 G5", CXT_FIXUP_HP_DOCK),
+	SND_PCI_QUIRK(0x103c, 0x83b3, "HP EliteBook 830 G5", CXT_FIXUP_HP_DOCK),
+	SND_PCI_QUIRK(0x103c, 0x83d3, "HP ProBook 640 G4", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x8402, "HP ProBook 645 G4", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8455, "HP Z2 G4", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x8456, "HP Z2 G4 SFF", CXT_FIXUP_HP_MIC_NO_PRESENCE),


