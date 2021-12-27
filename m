Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1436C47FFC6
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238657AbhL0PlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238841AbhL0PjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:39:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68764C07E5F2;
        Mon, 27 Dec 2021 07:37:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EA734CE10CB;
        Mon, 27 Dec 2021 15:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84E4C36AEA;
        Mon, 27 Dec 2021 15:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619477;
        bh=2eQnyZm8XUbFpi1PzPra1LTTdi7+tMRrjUf75uDgyf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJEnuF9x1EnYS9fvTXkps+9V1hYp3XwlTgX9PXFcKWQpt/mIXK/A2m4Nm6FdSqD+N
         hwGJsj1HFqKOZnPgBv5xX0Vo7WutL7vHuS3wW9WnhkB8SQCPAbrlRLC9BtjCkkdgxF
         H08V+fL7FVPSsGJliEwloKzMf6XL4pZIGwqMwino=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bradley Scott <Bradley.Scott@zebra.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 36/76] ALSA: hda/realtek: Amp init fixup for HP ZBook 15 G6
Date:   Mon, 27 Dec 2021 16:30:51 +0100
Message-Id: <20211227151325.952951634@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
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
@@ -8599,6 +8599,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x84da, "HP OMEN dc0019-ur", ALC295_FIXUP_HP_OMEN),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8519, "HP Spectre x360 15-df0xxx", ALC285_FIXUP_HP_SPECTRE_X360),
+	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),


