Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210762E3FB7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503885AbgL1Onr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:43:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503876AbgL1O0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:26:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FBC9229C5;
        Mon, 28 Dec 2020 14:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165565;
        bh=wa8P3a9c4JXo1nDCJJRuxtKZ0D+ERpqQnNdkJkXyKb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIkPQPkHrCVTAmOaLKn1uE33BaUP7WK+zgpiYchGIpyi5Vap804c1p7RvwEpEaMng
         EbMF3xcXHKoKUsTBkvXvDZkvVsWpohaoTqJbBdFdee4NrB0LvB/fDCFVNac6mgnpc/
         i6rjOtF02CKGswkSJTUmGewl0n3jM+SbIDhELTfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 546/717] ALSA: hda/realtek - Supported Dell fixed type headset
Date:   Mon, 28 Dec 2020 13:49:04 +0100
Message-Id: <20201228125047.100222017@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 150927c3674d7db4dd51a7269e01423c8c78e53b upstream.

This platform only supported iphone type headset.
It can't support Dell headset mode.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/b97e971978034bc9b772a08ec91265e8@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7885,6 +7885,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x09bf, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0a2e, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a30, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1028, 0x0a58, "Dell Precision 3650 Tower", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),


