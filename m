Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A263C444C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbhGLGSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233533AbhGLGSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:18:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E88FE610D2;
        Mon, 12 Jul 2021 06:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070527;
        bh=TsZ4KfOYZppvUAO2HBjn40McR1kiLgqYlZCEC97zxHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=voj52CKMRYE9ysaIVm3H9SeHfo+EagdWhx594VSONZ2QOPiP3oNGhsXdZ+U9eWw3I
         ++g35oFEYRoZUyuzODGX9kOGzrkDIj22bDeGL7mANf6IW54p970uKibSKqE6A+5QZ3
         H6iSeCuYMGyvI/TY35awhBkfklVBxsrLOL489D70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 008/348] ALSA: hda/realtek: Apply LED fixup for HP Dragonfly G1, too
Date:   Mon, 12 Jul 2021 08:06:32 +0200
Message-Id: <20210712060701.179799071@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
@@ -8093,6 +8093,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x84da, "HP OMEN dc0019-ur", ALC295_FIXUP_HP_OMEN),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8519, "HP Spectre x360 15-df0xxx", ALC285_FIXUP_HP_SPECTRE_X360),
+	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8724, "HP EliteBook 850 G7", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8729, "HP", ALC285_FIXUP_HP_GPIO_LED),


