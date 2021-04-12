Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D2335BF0F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239284AbhDLJCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239678AbhDLJBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34EF561278;
        Mon, 12 Apr 2021 08:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217941;
        bh=Y/FOpGQfDfKahfzz2noUzC4GAigei/pehoiUzaI9vwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1cWDIDqey9SipBtZZvU0+mEN7o095RiPfyrVEOlrvgYNJEjD0GwGuwYbzf5ye1zuT
         drla3QAIao0gOyhRzE9i99S/QwiAPiIDWw0IF+whKpB50GgN4+ulQQ04FtJ919t/Wg
         XtTlrgnQLX2iSIzGPNucfM+AlnxYZpiWff7D4Yes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 004/210] ALSA: hda/conexant: Apply quirk for another HP ZBook G5 model
Date:   Mon, 12 Apr 2021 10:38:29 +0200
Message-Id: <20210412084016.151561282@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c6423ed2da6214a68527446b5f8e09cf7162b2ce upstream.

There is another HP ZBook G5 model with the PCI SSID 103c:844f that
requires the same quirk for controlling the mute LED.  Add the
corresponding entry to the quirk table.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212407
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210401171314.667-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -944,6 +944,7 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x8402, "HP ProBook 645 G4", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8427, "HP ZBook Studio G5", CXT_FIXUP_HP_ZBOOK_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x844f, "HP ZBook Studio G5", CXT_FIXUP_HP_ZBOOK_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8455, "HP Z2 G4", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x8456, "HP Z2 G4 SFF", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x8457, "HP Z2 G4 mini", CXT_FIXUP_HP_MIC_NO_PRESENCE),


