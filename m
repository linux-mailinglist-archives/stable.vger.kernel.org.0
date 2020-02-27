Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6278C171DF1
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730926AbgB0ONf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:13:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388646AbgB0ONf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:13:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42D9F20578;
        Thu, 27 Feb 2020 14:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812814;
        bh=3EolLwvc+k88M83+i/a854yj4iSWyAk5AmAkLOkVqFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w9wqs9A60ILELBqCBPd/YU0yOEXiMSjzIZp+jMI6o3X82rMNr0u1Q3CZFmgUxNgTO
         6FYskGNNTNLutczM1DhxNO1U5NUAM4/81n/s5wsHnHN9cyy1tKVm7W9b4woapd1Est
         W5W+8trYh6iBlbd/5ga0K5j8iClZiLLUAfUJDpJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.5 008/150] ALSA: hda/realtek - Apply quirk for MSI GP63, too
Date:   Thu, 27 Feb 2020 14:35:45 +0100
Message-Id: <20200227132233.951343970@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit a655e2b107d463ce2745188ce050d07daed09a71 upstream.

The same quirk that was applied to MSI GL73 is needed for MSI GP63,
too.  Adding the entry with the SSID 1462:1228.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206503
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200217151947.17528-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2447,6 +2447,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1071, 0x8258, "Evesham Voyaeger", ALC882_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x1458, 0xa002, "Gigabyte EP45-DS3/Z87X-UD3H", ALC889_FIXUP_FRONT_HP_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1458, 0xa0b8, "Gigabyte AZ370-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1462, 0x1228, "MSI-GP63", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1276, "MSI-GL73", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x7350, "MSI-7350", ALC889_FIXUP_CD),
 	SND_PCI_QUIRK(0x1462, 0xda57, "MSI Z270-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),


