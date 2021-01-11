Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC052F1417
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732710AbhAKNRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:17:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732697AbhAKNRt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:17:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFA692229C;
        Mon, 11 Jan 2021 13:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371054;
        bh=P7348G7f5k9qf6yyaJ9W3CJJGjlJaAXMT0h0uPG1Kok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmZYnkCdwVhjRrBtc59207dfPjQUjgLKTwu60g6EwZFWeDJPe1/EPAlWS3+pziP4C
         zqS2h5bi0G9LvURlboviFN0w7lnPpPruke3oLfSCIAndfGsn/uJh4K7DFrdtOamjLk
         F4l6+dMS2q//pp/WVVcHMh5rgk1J2UcmVRSniTBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Manuel=20Jim=C3=A9nez?= <mjbfm99@me.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 121/145] ALSA: hda/realtek: Add mute LED quirk for more HP laptops
Date:   Mon, 11 Jan 2021 14:02:25 +0100
Message-Id: <20210111130054.326163264@linuxfoundation.org>
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

From: Manuel Jiménez <mjbfm99@me.com>

commit 484229585a5e91eeb00ee10e05d5204e1ca6c481 upstream.

HP Pavilion 13-bb0000 (SSID 103c:87c8) needs the same
quirk as other models with ALC287.

Signed-off-by: Manuel Jiménez <mjbfm99@me.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/X+s/gKNydVrI6nLj@HP-Pavilion-13
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7969,6 +7969,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8760, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877d, "HP", ALC236_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f4, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),


