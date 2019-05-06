Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8349014F79
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfEFOdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbfEFOdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:33:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BFAA204EC;
        Mon,  6 May 2019 14:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153230;
        bh=pMhP9hYDCvbkPzBkXYUMnzbfDXN+0RkVfcNp/wrXWE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHCvFgm77b0uc4mAgZLuT1fJ7mD8TjJrOiXD0HY4+GEA+xIvV83P9fDECH4H/q2ZJ
         HGB7uM0u+FB7nnpCnbVpHVdvhQuB0fsBrEE7mm9Z82OQIf3pFskWxVgxewhkWgtMv6
         7zEHFOkvY4zMFEfWAeUkQJWfYcpJG7N8jm0awYas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.0 011/122] ALSA: hda/realtek - Add new Dell platform for headset mode
Date:   Mon,  6 May 2019 16:31:09 +0200
Message-Id: <20190506143055.715787367@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 0a29c57b76624723b6b00c027e0e992d130ace49 upstream.

Add two Dell platform for headset mode.

[ Note: this is a further correction / addition of the previous
  pin-based quirks for Dell machines; another entry for ALC236 with
  the d-mic pin 0x12 and an entry for ALC295 -- tiwai ]

Fixes: b26e36b7ef36 ("ALSA: hda/realtek - add two more pin configuration sets to quirk table")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7266,6 +7266,10 @@ static const struct snd_hda_pin_quirk al
 		{0x21, 0x02211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0236, 0x1028, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE,
 		{0x21, 0x02211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0236, 0x1028, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE,
+		{0x12, 0x40000000},
+		{0x14, 0x90170110},
+		{0x21, 0x02211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0255, 0x1028, "Dell", ALC255_FIXUP_DELL2_MIC_NO_PRESENCE,
 		{0x14, 0x90170110},
 		{0x21, 0x02211020}),
@@ -7540,6 +7544,9 @@ static const struct snd_hda_pin_quirk al
 		{0x17, 0x90170110},
 		{0x21, 0x04211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1028, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE,
+		{0x14, 0x90170110},
+		{0x21, 0x04211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1028, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE,
 		ALC295_STANDARD_PINS,
 		{0x17, 0x21014020},
 		{0x18, 0x21a19030}),


