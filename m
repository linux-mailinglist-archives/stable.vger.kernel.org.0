Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB393C50A8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344811AbhGLHeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345964AbhGLHaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:30:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDC7060230;
        Mon, 12 Jul 2021 07:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074852;
        bh=+5yI5t9VphCeN+tKBO+lm3OInrLfek6qG5IMItpdG5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J09oXpovlhneGwuQG+YCXmvHvBruFmUgorp9s80inaSwT/6uJND+E4ReO5Dcug/74
         jMGtaq3zYsN/j5SZy/2bhd0mDT4q/VboE3qBQU+ixHosJ8IC7ECfNiiYwtRTyMWa2U
         rxiq44V4cThPBiceOQr5N8MbP7khyVuocKcmhoCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 019/800] ALSA: hda/realtek: fix mute led of the HP Pavilion 15-eh1xxx series
Date:   Mon, 12 Jul 2021 08:00:42 +0200
Message-Id: <20210712060915.859645172@linuxfoundation.org>
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

From: Frank Schäfer <fschaefer.oss@googlemail.com>

commit 42334fbc219eb110e054cedf9e553a142f735b11 upstream.

The HP Pavilion 15-eh1xxx series uses the HP mainboard 88D0 with ALC287 and needs
the ALC287_FIXUP_HP_GPIO_LED quirk to make the mute led working.
Tested with a HP Pavilion 15-eh1557ng.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210703135416.13151-1-fschaefer.oss@googlemail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8382,6 +8382,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x888d, "HP ZBook Power 15.6 inch G8 Mobile Workstation PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),


