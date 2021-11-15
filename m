Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0FD450C9E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238004AbhKORlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:41:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237946AbhKORiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:38:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A214632E0;
        Mon, 15 Nov 2021 17:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997125;
        bh=Bo3GefjFkW/VJVX6lXs083hETx+NOQ85M4kRcMwA1uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzpHgmy0eaZimHvmRk+3LDAJobAc+2UAttCmui1iEdnqBpBcmc4dlzeQ2Wp6e7+EE
         f+if0HmnDN2WaMsaxebRJZHCy1oUTuE0AdOcH+cPZXAOGX0tqX+tL8RrtmhBT1EP2j
         dhizh+I7+5aylhhPXpLIRFHNAp8dzG/fqhLNNfvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 033/575] ALSA: hda/realtek: Add quirk for HP EliteBook 840 G7 mute LED
Date:   Mon, 15 Nov 2021 17:55:58 +0100
Message-Id: <20211115165344.770085371@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit c058493df7edcef8f48c1494d9a84218519f966b upstream.

The mute and micmute LEDs don't work on HP EliteBook 840 G7. The same
quirk for other HP laptops can let LEDs work, so apply it.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211110144033.118451-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8532,6 +8532,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8716, "HP Elite Dragonfly G2 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8720, "HP EliteBook x360 1040 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8724, "HP EliteBook 850 G7", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8728, "HP EliteBook 840 G7", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8729, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8730, "HP ProBook 445 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_AMP_INIT),


