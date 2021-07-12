Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44723C4740
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbhGLGbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234591AbhGLGbS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:31:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9C69610FA;
        Mon, 12 Jul 2021 06:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071310;
        bh=rFLuTibT9ebRR2z6fAajRhW8qZPM5+WS+djmPUD4AU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8SUZNT+xiuQhMUZqxQRmDpWyt31ML7ZzbUWED8tJPIdbLQxsoiCqC86qivOTVljr
         VbXqHUxX/T67mKDg3MzoVIEWS0jG7Zrh/r9Pw5VHrl5jnva/qvSmbE4mJ25FSNOBJS
         YoTnT4+LPumdcdeWUYbjjB/RBxYOI90K3z36K5jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 016/593] ALSA: hda/realtek: Apply LED fixup for HP Dragonfly G1, too
Date:   Mon, 12 Jul 2021 08:02:56 +0200
Message-Id: <20210712060844.969171119@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
@@ -8331,6 +8331,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x84da, "HP OMEN dc0019-ur", ALC295_FIXUP_HP_OMEN),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8519, "HP Spectre x360 15-df0xxx", ALC285_FIXUP_HP_SPECTRE_X360),
+	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8716, "HP Elite Dragonfly G2 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),


