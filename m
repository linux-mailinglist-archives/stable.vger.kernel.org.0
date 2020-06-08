Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A101F237D
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbgFHXO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:14:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729951AbgFHXO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:14:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2FFA21534;
        Mon,  8 Jun 2020 23:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658097;
        bh=JnivCYcVOZ73WwbFWkQucbsHSKqUdGvKU95EX62tYBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pfy2QRSJUgcTMqjQr0g11kIETH6v3yyxrywI0DE1WWMoAg4uSq6Jbk+uqo1m6eXWD
         yrMknGtYka4FruzoNuSn/ViLokkCa2s5uAfaOFRV+rrWPR0naqMcymp7QGlgX25FQ/
         hMqMrJqkctGZ3cuPTKslUTZpRxB01pU+vv164T1k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Daniel Drake <drake@endlessm.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.6 139/606] ALSA: hda/realtek - Enable headset mic of ASUS UX550GE with ALC295
Date:   Mon,  8 Jun 2020 19:04:24 -0400
Message-Id: <20200608231211.3363633-139-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian-Hong Pan <jian-hong@endlessm.com>

[ Upstream commit ad97d667854c2fbce05a004e107f358ef4b04cf6 ]

The ASUS laptop UX550GE with ALC295 can't detect the headset microphone
until ALC295_FIXUP_ASUS_MIC_NO_PRESENCE quirk applied.

Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Signed-off-by: Daniel Drake <drake@endlessm.com>
Link: https://lore.kernel.org/r/20200512061525.133985-2-jian-hong@endlessm.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f92cd420e98d..ece762d0c714 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8050,6 +8050,10 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x12, 0x90a60130},
 		{0x17, 0x90170110},
 		{0x21, 0x03211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1043, "ASUS", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE,
+		{0x12, 0x90a60120},
+		{0x17, 0x90170110},
+		{0x21, 0x04211030}),
 	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1043, "ASUS", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE,
 		{0x12, 0x90a60130},
 		{0x17, 0x90170110},
-- 
2.25.1

