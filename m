Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B751AED2B
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 15:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgDRNuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 09:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726854AbgDRNtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 09:49:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 930E522262;
        Sat, 18 Apr 2020 13:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217780;
        bh=T/YL4wSj4t5kATkJomXkEmdGf7krfiS37vvSS4eZTzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mABKqiULCWNP3z6FtQcELgGhDkwzcSMn39/fegq0tzCXosx8WJ8Qv4Y1W1XhgHEFG
         qnDwWNJCx/qivAkjRQK+48wAERknuc6YRUxkL4DjR/+gw5H6OITK4hJTJnAiFie4/r
         VKo1nTJhTj+8DoVZwdv2vc05eRVkh4ddkLPRClJc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.6 68/73] ALSA: hda/realtek - Add quirk for Lenovo Carbon X1 8th gen
Date:   Sat, 18 Apr 2020 09:48:10 -0400
Message-Id: <20200418134815.6519-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418134815.6519-1-sashal@kernel.org>
References: <20200418134815.6519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit ca707b3f00b4f31a6e1eb37e8ae99f15f2bb1fe5 ]

The audio setup on the Lenovo Carbon X1 8th gen is the same as that on
the Lenovo Carbon X1 7th gen, as such it needs the same
ALC285_FIXUP_THINKPAD_HEADSET_JACK quirk.

This fixes volume control of the speaker not working among other things.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1820196
Cc: stable@vger.kernel.org
Suggested-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20200402174311.238614-1-hdegoede@redhat.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 5cced684cf41f..3f3484455080d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7300,6 +7300,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x225d, "Thinkpad T480", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x2292, "Thinkpad X1 Yoga 7th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x2293, "Thinkpad X1 Carbon 7th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
+	SND_PCI_QUIRK(0x17aa, 0x22be, "Thinkpad X1 Carbon 8th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x30bb, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x30e2, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x310c, "ThinkCentre Station", ALC294_FIXUP_LENOVO_MIC_LOCATION),
-- 
2.20.1

