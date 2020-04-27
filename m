Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4361B9543
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 05:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgD0DAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 23:00:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36300 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgD0DAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Apr 2020 23:00:54 -0400
Received: from [111.196.67.54] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1jSu0o-0005qw-Ut; Mon, 27 Apr 2020 03:00:51 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek - Two front mics on a Lenovo ThinkCenter
Date:   Mon, 27 Apr 2020 11:00:39 +0800
Message-Id: <20200427030039.10121-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This new Lenovo ThinkCenter has two front mics which can't be handled
by PA so far, so apply the fixup ALC283_FIXUP_HEADSET_MIC to change
the location for one of the mics.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c1a85c8f7b69..c16f63957c5a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7420,6 +7420,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x8560, "System76 Gazelle (gaze14)", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1558, 0x8561, "System76 Gazelle (gaze14)", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC233_FIXUP_LENOVO_MULTI_CODECS),
+	SND_PCI_QUIRK(0x17aa, 0x1048, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Thinkpad SL410/510", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x215e, "Thinkpad L512", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x21b8, "Thinkpad Edge 14", ALC269_FIXUP_SKU_IGNORE),
-- 
2.17.1

