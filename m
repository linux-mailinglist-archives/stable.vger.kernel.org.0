Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A307147FF11
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbhL0PfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:35:10 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39724 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238587AbhL0PfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:35:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A607BCE10B3;
        Mon, 27 Dec 2021 15:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94255C36AEA;
        Mon, 27 Dec 2021 15:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619301;
        bh=ZoC8FFdqm5CY235+2Xhg1EckXjzUxhmZYTzofsOvb1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGUX1EwDfabwEQGuXufItpOvWH/TmABxTU9COXKgaMup5PT6TJcc/4rLbuaKoylKa
         xIA2z7fqtqdFapIA7XAGgtehg0LBWOFYJTDRqQY5PcSAYv9yZtS72tHWrMZ7HmjR9s
         Wr7wwzrBNS59MKw4bVssm6SmqTRs3/l5p9LqLMfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bradley Scott <Bradley.Scott@zebra.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 24/47] ALSA: hda/realtek: Amp init fixup for HP ZBook 15 G6
Date:   Mon, 27 Dec 2021 16:31:00 +0100
Message-Id: <20211227151321.629272580@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bradley Scott <Bradley.Scott@zebra.com>

commit d296a74b7b59ff9116236c17edb25f26935dbf70 upstream.

HP ZBook 15 G6 (SSID 103c:860f) needs the same speaker amplifier
initialization as used on several other HP laptops using ALC285.

Signed-off-by: Bradley Scott <Bradley.Scott@zebra.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211213154938.503201-1-Bradley.Scott@zebra.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8101,6 +8101,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x84da, "HP OMEN dc0019-ur", ALC295_FIXUP_HP_OMEN),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8519, "HP Spectre x360 15-df0xxx", ALC285_FIXUP_HP_SPECTRE_X360),
+	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8724, "HP EliteBook 850 G7", ALC285_FIXUP_HP_GPIO_LED),


