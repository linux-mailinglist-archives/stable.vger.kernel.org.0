Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8872D450F11
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbhKOSZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:25:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241557AbhKOSWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:22:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DC866341B;
        Mon, 15 Nov 2021 17:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998802;
        bh=Or/UjN9T7HpCNkHXefxkh2sOMduUL2XrC+cymkMEUko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKQJzw1Wna61dp8kfOJN1TS1+zMbSCnRdZm96XHhNQxqVN5AXCtGH7BTgkf+siezd
         y94zh8j2Zgu8Sq8EicOxMTdHE1cqQDIiRkfa8o6bRPYTyiVt1riRAYhpGYmkERBW7l
         H+Guu+rQwysw9WpJoT12tPrfaxHtD0wE0ewbEZcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 034/849] ALSA: hda/realtek: Add quirk for ASUS UX550VE
Date:   Mon, 15 Nov 2021 17:51:57 +0100
Message-Id: <20211115165421.161697127@linuxfoundation.org>
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
@@ -8666,6 +8666,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x194e, "ASUS UX563FD", ALC294_FIXUP_ASUS_HPE),
+	SND_PCI_QUIRK(0x1043, 0x1970, "ASUS UX550VE", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1982, "ASUS B1400CEPE", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19e1, "ASUS UX581LV", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE),


