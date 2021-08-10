Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A444A3E8017
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbhHJRqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234650AbhHJRm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:42:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD00461220;
        Tue, 10 Aug 2021 17:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617135;
        bh=FfmmJD7KZuPEj6qAvPHT+C1lJf8TkG830CPW3qCCJEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BN9zAY9igkETmWDapO2FNx9L26sYKjzWhGydybOqMjQNZdUoCXdEMNRWX77tyrLfk
         5P5AXLJbw3WAZa7RpO5JR/EZDWnraMohIL9YUKa/jgtPHspXa2Goldz/z+47A4QDd+
         orohLz6+gW/7wzgX/Mmd30lxK3qgr1ATUOMWiLY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Monakov <amonakov@ispras.ru>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 060/135] ALSA: hda/realtek: add mic quirk for Acer SF314-42
Date:   Tue, 10 Aug 2021 19:29:54 +0200
Message-Id: <20210810172957.722006196@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
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
@@ -8203,6 +8203,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x1308, "Acer Aspire Z24-890", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x132a, "Acer TravelMate B114-21", ALC233_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1330, "Acer TravelMate X514-51T", ALC255_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x142b, "Acer Swift SF314-42", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),


