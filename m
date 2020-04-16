Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7011ACB0B
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895195AbgDPNft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897189AbgDPNfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:35:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E24821BE5;
        Thu, 16 Apr 2020 13:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044143;
        bh=P0Kbr+jaiAUTu7vRnV1VEh+m2Ui/C/b38dc6jJjmH4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4AT+ow6eH8z+0anKoLF4eztSz3uOfVAriR3LaRYaORJlY2NErqUIv1w0OMwHOlj7
         t0gj1tGAB7xz5BRQufJDbg3U0gFwlnVu0tXph0Uzt1brc7YBb4pt90C7aa4NiPsR1v
         KsBkD195FTLxF6WLdNePBdJoiR/LmJXSzAUWiuEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.5 098/257] ALSA: hda/realtek - Add quirk for MSI GL63
Date:   Thu, 16 Apr 2020 15:22:29 +0200
Message-Id: <20200416131338.316260890@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 1d3aa4a5516d2e4933fe3cca11d3349ef63bc547 upstream.

MSI GL63 laptop requires the similar quirk like other MSI models,
ALC1220_FIXUP_CLEVO_P950.  The board BIOS doesn't provide a PCI SSID
for the device, hence we need to take the codec SSID (1462:1275)
instead.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207157
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200408135645.21896-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2447,6 +2447,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1458, 0xa0b8, "Gigabyte AZ370-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1458, 0xa0cd, "Gigabyte X570 Aorus Master", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1228, "MSI-GP63", ALC1220_FIXUP_CLEVO_P950),
+	SND_PCI_QUIRK(0x1462, 0x1275, "MSI-GL63", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1276, "MSI-GL73", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1293, "MSI-GP65", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x7350, "MSI-7350", ALC889_FIXUP_CD),


