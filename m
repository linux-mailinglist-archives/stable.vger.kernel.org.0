Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4674B2F141E
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbhAKNUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:20:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733060AbhAKNSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:18:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70C16229C4;
        Mon, 11 Jan 2021 13:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371060;
        bh=99ZFA5hG70LbIaxO3VQm7aN34gVu9P5nErod4wOobnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3dhOpLROjzcbyhaCabXD6I1CWWVO2/dvG9O5uF5PJuse66sQKrnae7QLFv6aMkG3
         bEkmOM4XTRm9OM/LwWkx8WUCCN3iVFleOAoWc+qTlZqQyHmohBygRtWfqJ76kW0X67
         wKqOW9iviUF7JQGHl8pZv9g9XA3c+brVuXjUtU8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, PeiSen Hou <pshou@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 123/145] ALSA: hda/realtek: Add two "Intel Reference board" SSID in the ALC256.
Date:   Mon, 11 Jan 2021 14:02:27 +0100
Message-Id: <20210111130054.419398980@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: PeiSen Hou <pshou@realtek.com>

commit ce2e79b223867b9e586021b55dee7035517a236b upstream.

Add two "Intel Reference boad" SSID in the alc256.
Enable "power saving mode" and Enable "headset jack mode".

Signed-off-by: PeiSen Hou <pshou@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/5978d2267f034c28973d117925ec9c63@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8028,6 +8028,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x10cf, 0x1845, "Lifebook U904", ALC269_FIXUP_LIFEBOOK_EXTMIC),
 	SND_PCI_QUIRK(0x10ec, 0x10f2, "Intel Reference board", ALC700_FIXUP_INTEL_REFERENCE),
 	SND_PCI_QUIRK(0x10ec, 0x1230, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
+	SND_PCI_QUIRK(0x10ec, 0x1252, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
+	SND_PCI_QUIRK(0x10ec, 0x1254, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10f7, 0x8338, "Panasonic CF-SZ6", ALC269_FIXUP_HEADSET_MODE),
 	SND_PCI_QUIRK(0x144d, 0xc109, "Samsung Ativ book 9 (NP900X3G)", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x144d, 0xc169, "Samsung Notebook 9 Pen (NP930SBE-K01US)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),


