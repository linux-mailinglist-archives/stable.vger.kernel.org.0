Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12A53F5643
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 04:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhHXDAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 23:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234667AbhHXC7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 22:59:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B22961248;
        Tue, 24 Aug 2021 02:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629773934;
        bh=fjhCcYgGUDy/1+uGRWMEmSOmIYbP4IkFbMzbZ+jlAjY=;
        h=From:To:Cc:Subject:Date:From;
        b=lllpOdHcJbhonx0jRrxnpYS3Oe9Z3oXwe+t5Chk+spM2LG5J8q4HDVwc3kwC27OBi
         7YWUUswUiWro+mE2T7mFA2dgUZJoSDLCcbOzFneqFkI6JnmPczxhkIzANfvfdAIWi7
         ND5w9e1ir8VNHax4Y26qeVn/u44ixs4AFF4HqDTWk2vIH+3nQMIHmuduzBOMEadoTn
         U2baD9uEmnP7Yh1rDwwNg6emwacx9uW/bB4MXJ/BTOwDn+nheGS6863XzPJQBmocKs
         0gjcIXY/de1ECW3EO15+xE/3nsxS1FegnhXtpLFptWWCBUVyA2lFo/l/QiaYzZqsnD
         aZvaFHuwCxy2g==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, kristin@tombom.co.uk
Cc:     Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: FAILED: Patch "ALSA: hda/realtek: Enable 4-speaker output for Dell XPS 15 9510 laptop" failed to apply to 4.4-stable tree
Date:   Mon, 23 Aug 2021 22:58:52 -0400
Message-Id: <20210824025853.660089-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From da94692001ea45ffa1f5e9f17ecdef7aecd90c27 Mon Sep 17 00:00:00 2001
From: Kristin Paget <kristin@tombom.co.uk>
Date: Sat, 14 Aug 2021 15:46:05 -0700
Subject: [PATCH] ALSA: hda/realtek: Enable 4-speaker output for Dell XPS 15
 9510 laptop

The 2021-model XPS 15 appears to use the same 4-speakers-on-ALC289 audio
setup as the Precision models, so requires the same quirk to enable woofer
output. Tested on my own 9510.

Signed-off-by: Kristin Paget <kristin@tombom.co.uk>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/e1fc95c5-c10a-1f98-a5c2-dd6e336157e1@tombom.co.uk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index a065260d0d20..96f32eaa24df 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8332,6 +8332,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0a2e, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a30, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a58, "Dell", ALC255_FIXUP_DELL_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1028, 0x0a61, "Dell XPS 15 9510", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
-- 
2.30.2




