Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75276272E51
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbgIUQsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729644AbgIUQrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:47:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9568620874;
        Mon, 21 Sep 2020 16:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706855;
        bh=VC8TXcLX5XPFt4hAW36lxuH2pwpdMUISsTqqSdZ1a2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Bb4xb2D4Rm5+PZ4MpxbdKWm9F53VC9rKSu/RXPPYMLq3BuVhzgMwpSUm+dxVNK/Q
         OlcelbHCpLq58NCYxKjibFcsTfCERKhgFxMqcbVEUUBdIWAGA8Q5KsmOLy6Biendn0
         8AhyvszycFX7s7wN5pGgYZbMAWQvRIe265QKWhbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dan Crawford <dnlcrwfrd@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.8 092/118] Revert "ALSA: hda - Fix silent audio output and corrupted input on MSI X570-A PRO"
Date:   Mon, 21 Sep 2020 18:28:24 +0200
Message-Id: <20200921162040.633765174@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 8e83bd51016a35492c58e28312420e60ba8873f1 which is
commit 15cbff3fbbc631952c346744f862fb294504b5e2 upstream.

It causes know regressions and will be reverted in Linus's tree soon.

Reported-by: Hans de Goede <hdegoede@redhat.com>
Cc: Dan Crawford <dnlcrwfrd@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/7efd2fe5-bf38-7f85-891a-eee3845d1493@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2467,7 +2467,6 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1462, 0x1276, "MSI-GL73", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1293, "MSI-GP65", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x7350, "MSI-7350", ALC889_FIXUP_CD),
-	SND_PCI_QUIRK(0x1462, 0x9c37, "MSI X570-A PRO", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0xda57, "MSI Z270-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK_VENDOR(0x1462, "MSI", ALC882_FIXUP_GPIO3),
 	SND_PCI_QUIRK(0x147b, 0x107a, "Abit AW9D-MAX", ALC882_FIXUP_ABIT_AW9D_MAX),


