Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0813E8146
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbhHJR6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231652AbhHJR4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:56:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E16F610A7;
        Tue, 10 Aug 2021 17:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617496;
        bh=6t5roEvVzDw+yoWOz8mlzkaZjJ+hQavovfxODVQGqls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOBNaTJexmSFb82DnpTLyqd8FY8ZbKQs+zD+hpIMFHVIRUYcfN9535Eid7og1VWJY
         xaBDGlMpyolsKJyizBVzLWiB+TAzEghIvk/w7r39dNx7YHQS1vHFsaxXtlm6qez4sC
         z3/RdTItVl95w2CiPWhJuhDxy/PgoYrUegvouZ2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Monakov <amonakov@ispras.ru>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 084/175] ALSA: hda/realtek: add mic quirk for Acer SF314-42
Date:   Tue, 10 Aug 2021 19:29:52 +0200
Message-Id: <20210810173003.707927867@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Monakov <amonakov@ispras.ru>

commit 0d4867a185460397af56b9afe3e2243d3e610e37 upstream.

The Acer Swift SF314-42 laptop is using Realtek ALC255 codec. Add a
quirk so microphone in a headset connected via the right-hand side jack
is usable.

Signed-off-by: Alexander Monakov <amonakov@ispras.ru>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210721170141.24807-1-amonakov@ispras.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8217,6 +8217,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x1308, "Acer Aspire Z24-890", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x132a, "Acer TravelMate B114-21", ALC233_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1330, "Acer TravelMate X514-51T", ALC255_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x142b, "Acer Swift SF314-42", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),


