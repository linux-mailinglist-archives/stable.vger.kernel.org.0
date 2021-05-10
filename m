Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158923786AF
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235201AbhEJLKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:10:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234230AbhEJLCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:02:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C003561288;
        Mon, 10 May 2021 10:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644046;
        bh=zC6YJKNDJdW+K9zgC+rjKb0fuToZTU0nQsTNB/c8WyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BM3UpEVAHvimhLZ1zs8HgFRcDzMQFPLQ9zy/F22d02ky+ouW3jsGFZdCdKAJo/Syl
         4ECjUSFOkBhJogPd2q1eiSVJNpKrkBe6w62Lp+zm7+k/8VT/X3+MSyStpHXTnnWiCJ
         8X6lqRsnaQ302MzhHyznJYXCYlgZOEDDpvo2furk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 248/342] ALSA: hda/realtek - Headset Mic issue on HP platform
Date:   Mon, 10 May 2021 12:20:38 +0200
Message-Id: <20210510102018.279351937@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 1c9d9dfd2d254211cb37b1513b1da3e6835b8f00 upstream.

Boot with plugged headset, the Headset Mic will be gone.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/207eecfc3189466a820720bc0c409ea9@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8087,6 +8087,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x221c, "HP EliteBook 755 G2", ALC280_FIXUP_HP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x103c, 0x802e, "HP Z240 SFF", ALC221_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x802f, "HP Z240", ALC221_FIXUP_HP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x103c, 0x8077, "HP", ALC256_FIXUP_HP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x103c, 0x8158, "HP", ALC256_FIXUP_HP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x103c, 0x820d, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8256, "HP", ALC221_FIXUP_HP_FRONT_MIC),
 	SND_PCI_QUIRK(0x103c, 0x827e, "HP x360", ALC295_FIXUP_HP_X360),


