Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCE43960F7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhEaOdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233443AbhEaObf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:31:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86BA161424;
        Mon, 31 May 2021 13:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468970;
        bh=eLo54bfddh8VxsdFKzQUBZvxp1GtnerqVRhw+YvNId8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhcXstvUkIubIMyh4BbGrIrHPWISvGeVmkKEcfZUy4NTlMvlaswX6M90O/POaPsKx
         zTSqXlEyQCdsYbjK2uwkvrP7qzGXB9ALmdHmMeFLXHf6UwG/ElYVVs/H6HK9YaFhMx
         Zi/frf+rOa1NTXWhWDwCdokCUHxaUDFs808HN7F0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Szu <jeremy.szu@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 004/296] ALSA: hda/realtek: fix mute/micmute LEDs for HP 855 G8
Date:   Mon, 31 May 2021 15:10:59 +0200
Message-Id: <20210531130703.918604057@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Szu <jeremy.szu@canonical.com>

commit 0e68c4b11f1e66d211ad242007e9f1076a6b7709 upstream.

The HP EliteBook 855 G8 Notebook PC is using ALC285 codec which needs
ALC285_FIXUP_HP_MUTE_LED fixup to make it works. After applying the
fixup, the mute/micmute LEDs work good.

Signed-off-by: Jeremy Szu <jeremy.szu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210519170357.58410-1-jeremy.szu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8314,6 +8314,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87f7, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x103c, 0x8846, "HP EliteBook 850 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x884c, "HP EliteBook 840 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),


