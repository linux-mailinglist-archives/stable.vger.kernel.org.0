Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D59450A9C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbhKORMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:12:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232432AbhKORLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:11:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8317F61BD2;
        Mon, 15 Nov 2021 17:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996121;
        bh=mWd7YioabowH3NqcPxkwamBRa/BFvFJ9v/BsSgYcq7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWgKpY/wRscRkVMB15Y93elmCg9mOBaKmkBPzZ1Dphx2fEayLC8wX3m+ZdThr72Zu
         cs4am21jN55mSaSyolTHGv2z5YBw/M/LK5Tgs61IqzRsw7C9RfWOcOJ2Jg3/8mu5QN
         PZRVcztL92DCWmFBDU9XenmEHxt0wSXnBVX3E/jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 023/355] ALSA: hda/realtek: Add quirk for ASUS UX550VE
Date:   Mon, 15 Nov 2021 17:59:07 +0100
Message-Id: <20211115165314.297811659@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 4fad4fb9871b43389e4f4bead18ec693064697bb upstream.

ASUS UX550VE (SSID 1043:1970) requires a similar workaround for
managing the routing of the 4 speakers like some other ASUS models.
Add a corresponding quirk entry for fixing it.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212641
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211107083339.18013-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8134,6 +8134,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x194e, "ASUS UX563FD", ALC294_FIXUP_ASUS_HPE),
+	SND_PCI_QUIRK(0x1043, 0x1970, "ASUS UX550VE", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1982, "ASUS B1400CEPE", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19e1, "ASUS UX581LV", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE),


