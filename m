Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B435B13A560
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbgANKHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:07:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730620AbgANKHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:07:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47B5B24695;
        Tue, 14 Jan 2020 10:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996431;
        bh=jCi41ZsJLM7yYkSsH9juRlawv+6zNQHW4Q3VfUb71UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llIiidnwbRhsmFnG4f7b4z5kce9zhV5qo6c+SYDydlt64Nqy01EGtOST9DvBUB544
         Z+gbCKzGHB7XOYKXqrPxn2n1T/s+BqzISIYqgG1LwiMWaKc8DSwqQgjpxFWpZ2PtHn
         Uyh7j2DpO0DQUD5PbWti4qj/0PxiSFUe+8YLNqtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 07/46] ALSA: hda/realtek - Add quirk for the bass speaker on Lenovo Yoga X1 7th gen
Date:   Tue, 14 Jan 2020 11:01:24 +0100
Message-Id: <20200114094341.923274527@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094339.608068818@linuxfoundation.org>
References: <20200114094339.608068818@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 54a6a7dc107da0492a9e84fd7e9a107b3c58138d upstream.

Add quirk to ALC285_FIXUP_SPEAKER2_TO_DAC1, which is the same fixup
applied for X1 Carbon 7th gen in commit d2cd795c4ece ("ALSA: hda -
fixup for the bass speaker on Lenovo Carbon X1 7th gen").

Signed-off-by: Kailang Yang <kailang@realtek.com>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7042,6 +7042,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x224c, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x224d, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x225d, "Thinkpad T480", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x17aa, 0x2292, "Thinkpad X1 Yoga 7th", ALC285_FIXUP_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x17aa, 0x2293, "Thinkpad X1 Carbon 7th", ALC285_FIXUP_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x17aa, 0x30bb, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x30e2, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),


