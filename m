Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1719D37C726
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbhELP7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235667AbhELPy1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:54:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 354B56162B;
        Wed, 12 May 2021 15:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833259;
        bh=tnKtO0+I/5zYJ+GeDxBNIOWIJabaR+KjkeMlv/tTCc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5FRt7NR4PCb6WSPwXAM+KeNJOqzLChBk031iGCYqBSE/WMi91B5aNfes+JDgYQ4x
         Uu0thQvcv0Z2OQVzG431DaXJadAq4q218Sq4XMUS0fQtfOYuZtlOhsbUXjuMb3PwAr
         0FOKBqwPs+fGEwsB1arrSRI6PCg+DzDuimGSvPUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 079/601] ALSA: hda/realtek: Re-order ALC269 Acer quirk table entries
Date:   Wed, 12 May 2021 16:42:36 +0200
Message-Id: <20210512144830.429888053@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 433f894ec7fbd3b4bf1f3187b2ddd566078c4aef upstream.

Just re-order the alc269_fixup_tbl[] entries for Acer devices for
avoiding the oversight of the duplicated or unapplied item in future.
No functional changes.

Also Cc-to-stable for the further patch applications.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210428112704.23967-6-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7947,12 +7947,12 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x0349, "Acer AOD260", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x047c, "Acer AC700", ALC269_FIXUP_ACER_AC700),
 	SND_PCI_QUIRK(0x1025, 0x072d, "Acer Aspire V5-571G", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
-	SND_PCI_QUIRK(0x1025, 0x080d, "Acer Aspire V5-122P", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x0740, "Acer AO725", ALC271_FIXUP_HP_GATE_MIC_JACK),
 	SND_PCI_QUIRK(0x1025, 0x0742, "Acer AO756", ALC271_FIXUP_HP_GATE_MIC_JACK),
 	SND_PCI_QUIRK(0x1025, 0x0762, "Acer Aspire E1-472", ALC271_FIXUP_HP_GATE_MIC_JACK_E1_572),
 	SND_PCI_QUIRK(0x1025, 0x0775, "Acer Aspire E1-572", ALC271_FIXUP_HP_GATE_MIC_JACK_E1_572),
 	SND_PCI_QUIRK(0x1025, 0x079b, "Acer Aspire V5-573G", ALC282_FIXUP_ASPIRE_V5_PINS),
+	SND_PCI_QUIRK(0x1025, 0x080d, "Acer Aspire V5-122P", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x0840, "Acer Aspire E1", ALC269VB_FIXUP_ASPIRE_E1_COEF),
 	SND_PCI_QUIRK(0x1025, 0x101c, "Acer Veriton N2510G", ALC269_FIXUP_LIFEBOOK),
 	SND_PCI_QUIRK(0x1025, 0x102b, "Acer Aspire C24-860", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE),


