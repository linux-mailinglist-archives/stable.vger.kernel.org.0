Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC682CEE2A
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 13:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgLDMgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 07:36:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34538 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388097AbgLDMgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 07:36:21 -0500
Received: from 1.general.hwang4.uk.vpn ([10.172.195.16] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1klAJF-0004YC-6V; Fri, 04 Dec 2020 12:35:39 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de, stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek: make bass spk volume adjustable on a yoga laptop
Date:   Fri,  4 Dec 2020 20:34:59 +0800
Message-Id: <20201204123459.71474-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This also make the headset button work on this machine.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8616c5624870..5a905fa1b33a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3104,6 +3104,7 @@ static void alc_disable_headset_jack_key(struct hda_codec *codec)
 	case 0x10ec0215:
 	case 0x10ec0225:
 	case 0x10ec0285:
+	case 0x10ec0287:
 	case 0x10ec0295:
 	case 0x10ec0289:
 	case 0x10ec0299:
@@ -3130,6 +3131,7 @@ static void alc_enable_headset_jack_key(struct hda_codec *codec)
 	case 0x10ec0215:
 	case 0x10ec0225:
 	case 0x10ec0285:
+	case 0x10ec0287:
 	case 0x10ec0295:
 	case 0x10ec0289:
 	case 0x10ec0299:
@@ -8578,6 +8580,11 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x14, 0x90170110},
 		{0x19, 0x04a11040},
 		{0x21, 0x04211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0287, 0x17aa, "Lenovo", ALC285_FIXUP_THINKPAD_HEADSET_JACK,
+		{0x14, 0x90170110},
+		{0x17, 0x90170111},
+		{0x19, 0x03a11030},
+		{0x21, 0x03211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0286, 0x1025, "Acer", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE,
 		{0x12, 0x90a60130},
 		{0x17, 0x90170110},
-- 
2.25.1

