Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280FD3C50AA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343951AbhGLHeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345890AbhGLHaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:30:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0C896052B;
        Mon, 12 Jul 2021 07:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074846;
        bh=QyJ8BT3dfYhCMD0Au2F+9yywrg4W/s+KKOEdNuMHf5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7im8EvupUHwBGCQwtvFDOma/PSBRLimRY2n97u2rYQxBlE7AGMy3xT/yRwTGxHsp
         B9mKkanxeYkegUc8QC5ugYmR1ohUyYfGOrrTd9PZl44vSz1Bu8lmdDxp0sxJHPQ8xF
         0WR1MIzDK0D/X6JbqUmj3s5wwGIpM7iG1JMXEaBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 017/800] ALSA: hda/realtek: Apply LED fixup for HP Dragonfly G1, too
Date:   Mon, 12 Jul 2021 08:00:40 +0200
Message-Id: <20210712060915.591913572@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 0ac05b25c3dd8299204ae9d50c1c2f7f05eef08f upstream.

HP Dragonfly G1 (SSID 103c:861f) also requires the same quirk for the
mute and mic-mute LED just as Dragonfly G2 model.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=213329
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210623122022.26179-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8345,6 +8345,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x84da, "HP OMEN dc0019-ur", ALC295_FIXUP_HP_OMEN),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8519, "HP Spectre x360 15-df0xxx", ALC285_FIXUP_HP_SPECTRE_X360),
+	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8716, "HP Elite Dragonfly G2 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),


