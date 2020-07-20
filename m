Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4DD22708F
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgGTVh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:37:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgGTVhz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:37:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9017922CAF;
        Mon, 20 Jul 2020 21:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281075;
        bh=BOKO7t/Dev2HgUzW5nquzFUNM4FL7ZyT25MzW3MvQis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2czx97xN29lK1x51gvSJA+u3udRcggAWE7NhV4c/M+j45FQrjcjK0Z8Wef299wmI
         Psn4xeXkoDCH0yILdmBbIu+8GkuI1T7AQ1ScHUTcsIBrI/Npr71SUZtw/FQto8Fxq8
         yeK59yLB1sOiNKEMnCo7vrGeCuFlepM/TydBSw0Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     PeiSen Hou <pshou@realtek.com.tw>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.7 32/40] ALSA: hda/realtek - fixup for yet another Intel reference board
Date:   Mon, 20 Jul 2020 17:37:07 -0400
Message-Id: <20200720213715.406997-32-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213715.406997-1-sashal@kernel.org>
References: <20200720213715.406997-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: PeiSen Hou <pshou@realtek.com.tw>

[ Upstream commit 5734e509d5d515c187f642937ef2de1e58d7715d ]

Add headset_jack for the intel reference board support with
10ec:1230.

Signed-off-by: PeiSen Hou <pshou@realtek.com.tw>
Link: https://lore.kernel.org/r/20200716090134.9811-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 16ecc8515db8e..1470321bf31ef 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7523,6 +7523,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x10cf, 0x1629, "Lifebook U7x7", ALC255_FIXUP_LIFEBOOK_U7x7_HEADSET_MIC),
 	SND_PCI_QUIRK(0x10cf, 0x1845, "Lifebook U904", ALC269_FIXUP_LIFEBOOK_EXTMIC),
 	SND_PCI_QUIRK(0x10ec, 0x10f2, "Intel Reference board", ALC700_FIXUP_INTEL_REFERENCE),
+	SND_PCI_QUIRK(0x10ec, 0x1230, "Intel Reference board", ALC225_FIXUP_HEADSET_JACK),
 	SND_PCI_QUIRK(0x10f7, 0x8338, "Panasonic CF-SZ6", ALC269_FIXUP_HEADSET_MODE),
 	SND_PCI_QUIRK(0x144d, 0xc109, "Samsung Ativ book 9 (NP900X3G)", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x144d, 0xc169, "Samsung Notebook 9 Pen (NP930SBE-K01US)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
-- 
2.25.1

