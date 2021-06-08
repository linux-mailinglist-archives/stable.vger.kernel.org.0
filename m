Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B0C3A0022
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbhFHSkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233989AbhFHSib (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:38:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56C7C6141D;
        Tue,  8 Jun 2021 18:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177211;
        bh=u9ijdiLZ58zRkFOYx05hbfmQ//5xB0RBK76wR/AeI+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WURAT0Am8y9dZLOKROmsuxXqTmT4r5DWXVjxN3hNVXvP3aLJNVotzNyE1TnYaYBEz
         0KeQYTvptByujSxkVBVQDLeDLntFTfLax6cZP0nxXv/ovvcZyZYhsPUnQJ/6hIfLOu
         uX41Q6y5FWCYAbF1mtwQD9dsN04zOmOPQn+gYhCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlos M <carlos.marr.pz@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 27/58] ALSA: hda: Fix for mute key LED for HP Pavilion 15-CK0xx
Date:   Tue,  8 Jun 2021 20:27:08 +0200
Message-Id: <20210608175933.182293746@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
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
@@ -7095,6 +7095,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x82bf, "HP G3 mini", ALC221_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x82c0, "HP G3 mini premium", ALC221_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x83b9, "HP Spectre x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
+	SND_PCI_QUIRK(0x103c, 0x841c, "HP Pavilion 15-CK0xx", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8497, "HP Envy x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_LED),


