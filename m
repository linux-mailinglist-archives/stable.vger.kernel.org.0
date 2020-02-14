Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B5C15E1CB
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392752AbgBNQUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:20:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405229AbgBNQUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:20:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E925D2472C;
        Fri, 14 Feb 2020 16:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697232;
        bh=Sxg0R93GbOQROQbzavKod+ynQMnPQ8PoZ+nJxzzu8sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1myqndC6G2Py91ceLy47Wt9RKwfQ9Q/58vAqFYn0g83VdIsYYjNMEQ6GVRvNht/v
         E8KHZeQV1OoCeKhjuPg3Ts0HzIgamQqg/X0RfJWUknMsQqD24ZrlfxsEe2paLK4VYQ
         9u/QSYvqm9rBBSeEXGkz5ULw8B/ql5nM6wuJxjKs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Peter=20Gro=C3=9Fe?= <pegro@friiks.de>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 154/186] ALSA: hda - Add docking station support for Lenovo Thinkpad T420s
Date:   Fri, 14 Feb 2020 11:16:43 -0500
Message-Id: <20200214161715.18113-154-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Große <pegro@friiks.de>

[ Upstream commit ef7d84caa5928b40b1c93a26dbe5a3f12737c6ab ]

Lenovo Thinkpad T420s uses the same codec as T420, so apply the
same quirk to enable audio output on a docking station.

Signed-off-by: Peter Große <pegro@friiks.de>
Link: https://lore.kernel.org/r/20200122180106.9351-1-pegro@friiks.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 382b6d2ed8036..9cc9304ff21a7 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -969,6 +969,7 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x17aa, 0x215f, "Lenovo T510", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21ce, "Lenovo T420", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21cf, "Lenovo T520", CXT_PINCFG_LENOVO_TP410),
+	SND_PCI_QUIRK(0x17aa, 0x21d2, "Lenovo T420s", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21da, "Lenovo X220", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21db, "Lenovo X220-tablet", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo IdeaPad Z560", CXT_FIXUP_MUTE_LED_EAPD),
-- 
2.20.1

