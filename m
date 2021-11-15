Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B504524D8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350516AbhKPBps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:45:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241380AbhKOSTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:19:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9916D63282;
        Mon, 15 Nov 2021 17:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998726;
        bh=0ZFUSWhYgCBt62EuFwuErWSdZclOUY01iZFf+R5gt/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ve80mdL/n5rg3Q7fDvss1asFEjaAaCLqakQME+qNn/WF4mgHnoF9qJ46AzaJllqhw
         uah4nPQjGwruysE+I25wEiM+BT1DP/e/B3zi3e7lJSf/mJ8vMVSoWo/Tfqs7HEv6gj
         KXWLB/OUOY21u8/IC7hjGAShLBy0YbwhfIHTlXmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Crawford <tcrawford@system76.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 031/849] ALSA: hda/realtek: Add quirk for Clevo PC70HS
Date:   Mon, 15 Nov 2021 17:51:54 +0100
Message-Id: <20211115165421.060544274@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Crawford <tcrawford@system76.com>

commit dbfe83507cf4ea66ce4efee2ac14c5ad420e31d3 upstream.

Apply the PB51ED PCI quirk to the Clevo PC70HS. Fixes audio output from
the internal speakers.

Signed-off-by: Tim Crawford <tcrawford@system76.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211101162134.5336-1-tcrawford@system76.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2551,6 +2551,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1558, 0x67d1, "Clevo PB71[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e1, "Clevo PB71[DE][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e5, "Clevo PC70D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x67f1, "Clevo PC70H[PRS]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x70d1, "Clevo PC70[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x7714, "Clevo X170SM", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x7715, "Clevo X170KM-G", ALC1220_FIXUP_CLEVO_PB51ED),


