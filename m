Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294D9261BEF
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731225AbgIHTLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731218AbgIHQFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:05:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96722223C7;
        Tue,  8 Sep 2020 15:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579947;
        bh=P5jnhtT33Oq8lnZmSI2Idi6KUJNovb0cJrHELk4FGGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OyHzLwVZn21T08fuf0e336bwx6hcfLvuzT9MLuwlNTiAFGylcBMWDwROr12SS5qQ1
         hQApGA+HKA2nu8Qt1ErzPldvsKPctv7k52/2XKLVhxCf+kfoW2ArYyfMYx6u8HY/MD
         u91kEqTUKLjH6pDFUI1AQdMlgCMVDAFgdHoKoxeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adrien Crivelli <adrien.crivelli@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 097/129] ALSA: hda/realtek: Add quirk for Samsung Galaxy Book Ion NT950XCJ-X716A
Date:   Tue,  8 Sep 2020 17:25:38 +0200
Message-Id: <20200908152234.646756609@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
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
@@ -7678,7 +7678,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc169, "Samsung Notebook 9 Pen (NP930SBE-K01US)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
-	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
+	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
+	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),


