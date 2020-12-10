Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B1D2D5E09
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391090AbgLJOhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:37:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391085AbgLJOhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:37:31 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian-Hong Pan <jhp@endlessos.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.9 13/75] ALSA: hda/realtek: Enable headset of ASUS UX482EG & B9400CEA with ALC294
Date:   Thu, 10 Dec 2020 15:26:38 +0100
Message-Id: <20201210142606.726063210@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian-Hong Pan <jhp@endlessos.org>

commit eeacd80fcb29b769ea915cd06b7dd35e0bf0bc25 upstream.

Some laptops like ASUS UX482EG & B9400CEA's headset audio does not work
until the quirk ALC294_FIXUP_ASUS_HPE is applied.

Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201124092024.179540-1-jhp@endlessos.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8600,6 +8600,9 @@ static const struct snd_hda_pin_quirk al
 	SND_HDA_PIN_QUIRK(0x10ec0293, 0x1028, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE,
 		ALC292_STANDARD_PINS,
 		{0x13, 0x90a60140}),
+	SND_HDA_PIN_QUIRK(0x10ec0294, 0x1043, "ASUS", ALC294_FIXUP_ASUS_HPE,
+		{0x17, 0x90170110},
+		{0x21, 0x04211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0294, 0x1043, "ASUS", ALC294_FIXUP_ASUS_MIC,
 		{0x14, 0x90170110},
 		{0x1b, 0x90a70130},


