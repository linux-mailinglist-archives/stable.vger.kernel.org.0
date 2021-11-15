Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57D5450A9B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhKORMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:12:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231876AbhKORLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:11:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C11A261BE5;
        Mon, 15 Nov 2021 17:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996118;
        bh=BTNzDbqNSfNur6DftjDSz21AJY393vyHHa27lnoFSdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9vC1kpAszTjHBInjqrGhDaUFy26cpy922+kVooI6ab0wni57S9HQBhHOZLzHgYwO
         n3f1jSJ9rjcCmATuOtn/DP7QtZAD0gItqsJK/D4O05QTZMAFoJmRFwMHVGZ2U30/5E
         dhPIhn5+28SqpZcPGXkCe+y38KmKigF1fEDimUxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 022/355] ALSA: hda/realtek: Add a quirk for Acer Spin SP513-54N
Date:   Mon, 15 Nov 2021 17:59:06 +0100
Message-Id: <20211115165314.266223845@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

commit 2a5bb694488bb6593066d46881bfd9d07edd1628 upstream.

Another model requires ALC255_FIXUP_ACER_MIC_NO_PRESENCE fixup.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211853
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211104155726.2090997-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7977,6 +7977,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x1308, "Acer Aspire Z24-890", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x132a, "Acer TravelMate B114-21", ALC233_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1330, "Acer TravelMate X514-51T", ALC255_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x141f, "Acer Spin SP513-54N", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x142b, "Acer Swift SF314-42", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),


