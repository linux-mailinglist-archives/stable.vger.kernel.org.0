Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09552E3FBF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503340AbgL1O0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:26:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503417AbgL1O0A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:26:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09B2922B30;
        Mon, 28 Dec 2020 14:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165519;
        bh=VclSskW7CcH5l+iROueFf0/D8PmQpd+DHdYri4+xlE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMbL4YqQcztGk2Mle078+5hmPxQT3qWexzzl8WnGrsWNs4rXcLsIEuAxUCG8uPFBJ
         bAD+cbvYHUv2ehQY8KGPsWtzgoxmSJV9U5T+yqKHMb6L7XAs/ABayy/pUFOp3otuO/
         U1SxM9l7k2eKSoZlbfICjhrR0lqBNSzp7IdEH3tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 543/717] ALSA: hda/realtek: Add quirk for MSI-GP73
Date:   Mon, 28 Dec 2020 13:49:01 +0100
Message-Id: <20201228125046.964872641@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 09926202e939fd699650ac0fc0baa5757e069390 upstream.

MSI-GP73 (with SSID 1462:1229) requires yet again
ALC1220_FIXUP_CLEVO_P950 quirk like other MSI models.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=210793
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201220080943.24839-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2516,6 +2516,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1458, 0xa0ce, "Gigabyte X570 Aorus Xtreme", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x11f7, "MSI-GE63", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1228, "MSI-GP63", ALC1220_FIXUP_CLEVO_P950),
+	SND_PCI_QUIRK(0x1462, 0x1229, "MSI-GP73", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1275, "MSI-GL63", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1276, "MSI-GL73", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1293, "MSI-GP65", ALC1220_FIXUP_CLEVO_P950),


