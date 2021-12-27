Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C48E4800C5
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhL0Pt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbhL0PrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:47:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8E0C0617A1;
        Mon, 27 Dec 2021 07:43:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70A06610B1;
        Mon, 27 Dec 2021 15:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A73FC36AEA;
        Mon, 27 Dec 2021 15:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619787;
        bh=SQynjD/gO8qVV+53+s6MOoRg6pg+dgZHkyHPBaUkksA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=caTtKIus/wlUIJhrkvKD1z+SW1y8LMv+kyF3SpkUid1dtyzdo1Xrfl+tq2Bv0iJm9
         PsroL8iAckUuRPKWMcTFrzU8Ve/GFP1+HxqSet4XSNlIaMvZjH44fpA4iBJLCc4964
         wcam1bULKnQqgjRADbWto9jaHcAQ+8PWuvvmyvZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bradley Scott <Bradley.Scott@zebra.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 069/128] ALSA: hda/realtek: Amp init fixup for HP ZBook 15 G6
Date:   Mon, 27 Dec 2021 16:30:44 +0100
Message-Id: <20211227151333.793149982@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
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
@@ -8660,6 +8660,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x84da, "HP OMEN dc0019-ur", ALC295_FIXUP_HP_OMEN),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8519, "HP Spectre x360 15-df0xxx", ALC285_FIXUP_HP_SPECTRE_X360),
+	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),


