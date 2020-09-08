Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFD12619E8
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731688AbgIHS2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:28:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731408AbgIHQKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:10:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91C1424743;
        Tue,  8 Sep 2020 15:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579668;
        bh=fAwFO1P7fVr5Y3Eo8Ta4MRRO6FnQf2ilbIIAN3MRW8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhHjaWlF49E73yoDL7VvR1JLPukZyjk0ZrFTL2Z43E8rtOng3sMb5JL2eXKcfdGbt
         2AkKPh7kADft2kYHzZ8zmapp72k2BiO14Q3vB46+L4kvbt5X8LMYUiJD25IxtwFPCg
         4WU2saQIo3sSd8en+hWVijtDewydVyu47VfRDUds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adrien Crivelli <adrien.crivelli@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.8 143/186] ALSA: hda/realtek: Add quirk for Samsung Galaxy Book Ion NT950XCJ-X716A
Date:   Tue,  8 Sep 2020 17:24:45 +0200
Message-Id: <20200908152248.594845012@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrien Crivelli <adrien.crivelli@gmail.com>

commit 8bcea6cb2cbc1f749e574954569323dec5e2920e upstream.

The Galaxy Book Ion NT950XCJ-X716A (15 inches) uses the same ALC298
codec as other Samsung laptops which have the no headphone sound bug. I
confirmed on my own hardware that this fixes the bug.

This also correct the model name for the 13 inches version. It was
incorrectly referenced as NT950XCJ-X716A in commit e17f02d05. But it
should have been NP930XCJ-K01US.

Fixes: e17f02d0559c ("ALSA: hda/realtek: Add quirk for Samsung Galaxy Book Ion")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207423
Signed-off-by: Adrien Crivelli <adrien.crivelli@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200826084014.211217-1-adrien.crivelli@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7708,7 +7708,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc169, "Samsung Notebook 9 Pen (NP930SBE-K01US)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
-	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
+	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
+	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),


