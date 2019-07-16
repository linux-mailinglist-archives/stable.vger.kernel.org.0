Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232E76A2DA
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 09:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbfGPHVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 03:21:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43950 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfGPHVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jul 2019 03:21:43 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=hwang4-Vostro-5390.taipei.internal)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <hui.wang@canonical.com>)
        id 1hnHmN-0004Rx-Jx; Tue, 16 Jul 2019 07:21:40 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek: apply ALC891 headset fixup to one Dell machine
Date:   Tue, 16 Jul 2019 15:21:34 +0800
Message-Id: <20190716072134.10009-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Without this patch, the headset-mic and headphone-mic don't work.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1c84c12b39b3..de224cbea7a0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8803,6 +8803,11 @@ static const struct snd_hda_pin_quirk alc662_pin_fixup_tbl[] = {
 		{0x18, 0x01a19030},
 		{0x1a, 0x01813040},
 		{0x21, 0x01014020}),
+	SND_HDA_PIN_QUIRK(0x10ec0867, 0x1028, "Dell", ALC891_FIXUP_DELL_MIC_NO_PRESENCE,
+		{0x16, 0x01813030},
+		{0x17, 0x02211010},
+		{0x18, 0x01a19040},
+		{0x21, 0x01014020}),
 	SND_HDA_PIN_QUIRK(0x10ec0662, 0x1028, "Dell", ALC662_FIXUP_DELL_MIC_NO_PRESENCE,
 		{0x14, 0x01014010},
 		{0x18, 0x01a19020},
-- 
2.17.1

