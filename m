Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502A9431C66
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhJRNks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233913AbhJRNjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:39:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A8EA6137B;
        Mon, 18 Oct 2021 13:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563959;
        bh=HLwTGSE58du4PqPraSak0BgGxv+ifkZHusjCW6tnRZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTGhMckSQXzI7NNzuZowWrPSk2mtjU6nJhnu1/6mNHzJ2Cj4pTnUn7YMH0dhVmFiC
         Ga5kxsJrwDIy9wgFfu7b7CSwTWbTT0ptGEhxyvTP7i6DHDrBuZ0in15QbU5b6z6w4o
         sJk9L2BNQDRFufzCEQQj+Q6Esk6a5kd5r940o/Zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Liu <johnliu55tw@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 004/103] ALSA: hda/realtek: Enable 4-speaker output for Dell Precision 5560 laptop
Date:   Mon, 18 Oct 2021 15:23:40 +0200
Message-Id: <20211018132334.846974518@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Liu <johnliu55tw@gmail.com>

commit eb676622846b34a751e2ff9b5910a5322a4e0000 upstream.

The Dell Precision 5560 laptop appears to use the 4-speakers-on-ALC289
audio just like its sibling product XPS 9510, so it requires the same
quirk to enable woofer output. Tested on my Dell Precision 5560.

Signed-off-by: John Liu <johnliu55tw@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210930115316.659-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8391,6 +8391,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0a30, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a58, "Dell", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a61, "Dell XPS 15 9510", ALC289_FIXUP_DUAL_SPK),
+	SND_PCI_QUIRK(0x1028, 0x0a62, "Dell Precision 5560", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),


