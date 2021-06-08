Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AEA3A022E
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236510AbhFHTBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236435AbhFHS6n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:58:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2363613CD;
        Tue,  8 Jun 2021 18:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177783;
        bh=eA4nB1FTEd/cOScM/sJgwLjwxifG8bhytJE9dL/Tmqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfBSgb3DImauLQAHGKdaIYTjX7/SVE4YlITTxI42Wx5zZUMTGxr/hsnWa0A/jlP3z
         f1SdUtUZ0B6GgAdznSMEB2SF+pa4Fhyk1fYF5VWcWZSg7peM388hKNqJWO8/O9iBvm
         xOTVWkbyDR+ST3JYqEdDjw7NEBMjd/DzMsFfO2t4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlos M <carlos.marr.pz@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 098/137] ALSA: hda: Fix for mute key LED for HP Pavilion 15-CK0xx
Date:   Tue,  8 Jun 2021 20:27:18 +0200
Message-Id: <20210608175945.700870315@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carlos M <carlos.marr.pz@gmail.com>

commit 901be145a46eb79879367d853194346a549e623d upstream.

For the HP Pavilion 15-CK0xx, with audio subsystem ID 0x103c:0x841c,
adding a line in patch_realtek.c to apply the ALC269_FIXUP_HP_MUTE_LED_MIC3
fix activates the mute key LED.

Signed-off-by: Carlos M <carlos.marr.pz@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210531202026.35427-1-carlos.marr.pz@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8289,6 +8289,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x82bf, "HP G3 mini", ALC221_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x82c0, "HP G3 mini premium", ALC221_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x83b9, "HP Spectre x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
+	SND_PCI_QUIRK(0x103c, 0x841c, "HP Pavilion 15-CK0xx", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8497, "HP Envy x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x84da, "HP OMEN dc0019-ur", ALC295_FIXUP_HP_OMEN),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),


