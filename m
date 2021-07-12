Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C922C3C506C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241909AbhGLHcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346977AbhGLHbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:31:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77EA06052B;
        Mon, 12 Jul 2021 07:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074913;
        bh=PrZbMR1Qk18LQA5jyLGN73cu7RohUSrZJ06vDtZB6wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UvJUTBb/Z2CPXQ6nx2057Td6iUyh8JvCEckHMsgp6jhlqUbf2Do6CLvaPGgUkbDXO
         oORrWBR5ybG3XeawKstmYgBoCrWxGIdYmm6DGFNInSrwq8Ai1ErnnJwWNIt+EkeYWd
         2YmRvCaQf4o9X6r+OhxM/w3p58z652Oa7eYH3rRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Chi <andy.chi@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 010/800] ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 450 G8
Date:   Mon, 12 Jul 2021 08:00:33 +0200
Message-Id: <20210712060914.557489938@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Chi <andy.chi@canonical.com>

commit 2b70b264d34d398c77a5936e317336f00cf5badb upstream.

The HP ProBook 450 G8 using ALC236 codec which using 0x02 to
control mute LED and 0x01 to control micmute LED.
Therefore, add a quirk to make it works.

Signed-off-by: Andy Chi <andy.chi@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210701091417.9696-1-andy.chi@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8336,6 +8336,7 @@ static const struct snd_pci_quirk alc269
 		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87e7, "HP ProBook 450 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f2, "HP ProBook 640 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f4, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),


