Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC393E7F02
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbhHJRgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:36:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233481AbhHJRfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:35:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50F9A6101E;
        Tue, 10 Aug 2021 17:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616901;
        bh=uVNMDWaLtWqN+dHepcfo3jD5DV7tUKQXw18nViLZdQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXDBMWPC/BjaVGEnopBXWBgyKA86Mvshe1J5bcf2otOsEnh2eqO8Q8vmw4wNR+t7x
         VzlI5xbF+m7de8bn73oyBJ2l4p+yLWT1cH0CwEJedfOJj6VHqruViY3ihcH+HfNj/O
         VLdC8wU1Ye3FXZS6RY3w/b7yy6jJ+RC08K5280AI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Monakov <amonakov@ispras.ru>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 42/85] ALSA: hda/realtek: add mic quirk for Acer SF314-42
Date:   Tue, 10 Aug 2021 19:30:15 +0200
Message-Id: <20210810172949.650720602@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
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
@@ -7971,6 +7971,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x1308, "Acer Aspire Z24-890", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x132a, "Acer TravelMate B114-21", ALC233_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1330, "Acer TravelMate X514-51T", ALC255_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x142b, "Acer Swift SF314-42", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
 	SND_PCI_QUIRK(0x1028, 0x054b, "Dell XPS one 2710", ALC275_FIXUP_DELL_XPS),


