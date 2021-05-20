Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A12D38A33D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbhETJun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233786AbhETJsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:48:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D4A76101E;
        Thu, 20 May 2021 09:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503283;
        bh=g5HcKgSLCYjYBLDYV3W9RqTrkVJ9BKwOelZ4bFnCKpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jt/xCnD2Bs/qCsDMM23n3WeO1fZ44nuF8RqDGOaUbA39aDXkVz1tY9KDBxYJ+iq9l
         qII0KdTvMpwBYrWV3FPYVC28C9xAhb3NWveI1vOZfLRGoYD1YdcGJiaUAUINu5z6af
         voEeku4bmUZMag4AnCVMrJVWq0Eg6L9Ohus35C3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 152/425] ALSA: hda/realtek: Re-order ALC269 Dell quirk table entries
Date:   Thu, 20 May 2021 11:18:41 +0200
Message-Id: <20210520092136.426793863@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit aa143ad39a52d968ac69e426d329bb74f270e6ca upstream.

Just re-order the alc269_fixup_tbl[] entries for Dell devices for
avoiding the oversight of the duplicated or unapplied item in future.
No functional changes.

Also Cc-to-stable for the further patch applications.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210428112704.23967-7-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7009,8 +7009,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0738, "Dell Precision 5820", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1028, 0x075c, "Dell XPS 27 7760", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x1028, 0x075d, "Dell AIO", ALC298_FIXUP_SPK_VOLUME),
-	SND_PCI_QUIRK(0x1028, 0x07b0, "Dell Precision 7520", ALC295_FIXUP_DISABLE_DAC3),
 	SND_PCI_QUIRK(0x1028, 0x0798, "Dell Inspiron 17 7000 Gaming", ALC256_FIXUP_DELL_INSPIRON_7559_SUBWOOFER),
+	SND_PCI_QUIRK(0x1028, 0x07b0, "Dell Precision 7520", ALC295_FIXUP_DISABLE_DAC3),
 	SND_PCI_QUIRK(0x1028, 0x080c, "Dell WYSE", ALC225_FIXUP_DELL_WYSE_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x084b, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB),
 	SND_PCI_QUIRK(0x1028, 0x084e, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB),
@@ -7020,8 +7020,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x08ad, "Dell WYSE AIO", ALC225_FIXUP_DELL_WYSE_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x08ae, "Dell WYSE NB", ALC225_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0935, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB),
-	SND_PCI_QUIRK(0x1028, 0x097e, "Dell Precision", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x097d, "Dell Precision", ALC289_FIXUP_DUAL_SPK),
+	SND_PCI_QUIRK(0x1028, 0x097e, "Dell Precision", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x098d, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x09bf, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),


