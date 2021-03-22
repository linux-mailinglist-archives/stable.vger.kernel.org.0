Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E648344323
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhCVMsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230347AbhCVMqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:46:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5392160238;
        Mon, 22 Mar 2021 12:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416950;
        bh=4K/7u2IFNftLVH6Fhu8Ra0glW9wB6xNfXSyxvLWfE44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZNI/WxbFxEycOxROHgNwbjwaqWmh1fC4uXIQxtKsvqfrGpveykcY7uEAZnY9hBoD
         Af6pu8XNAI+HerlyWknEUxzK/19RQK0mIW6kkJSqthd2se4h0t3bO3bZwjL6jRQitK
         ffwN+34xjUEmWZFM2d+IJmtJA8caw9HsYust5bRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoliang Yu <yxl_22@outlook.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 06/60] ALSA: hda/realtek: Apply headset-mic quirks for Xiaomi Redmibook Air
Date:   Mon, 22 Mar 2021 13:27:54 +0100
Message-Id: <20210322121922.575451697@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoliang Yu <yxl_22@outlook.com>

commit e1c86210fe27428399643861b81b080eccd79f87 upstream.

There is another fix for headset-mic problem on Redmibook (1d72:1602),
it also works on Redmibook Air (1d72:1947), which has the same issue.

Signed-off-by: Xiaoliang Yu <yxl_22@outlook.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/TYBP286MB02856DC016849DEA0F9B6A37EE6F9@TYBP286MB0285.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8104,6 +8104,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1c06, 0x2013, "Lemote A1802", ALC269_FIXUP_LEMOTE_A1802),
 	SND_PCI_QUIRK(0x1c06, 0x2015, "Lemote A190X", ALC269_FIXUP_LEMOTE_A190X),


