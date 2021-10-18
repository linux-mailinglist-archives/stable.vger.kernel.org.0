Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F585431B35
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbhJRNbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232132AbhJRNaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4095E61351;
        Mon, 18 Oct 2021 13:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563682;
        bh=yPqwLxKFBD/V8h+UWQGIFVtSE+u5JEz0Rdtya6pOk3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XoAS+deTCaj46FkGZgSAtoi7/kF8R7glvbxHjNghE0tXz2fhzPSqt86o+ka1QIEd1
         GN4mKvyNXIRAGe5pY1IhZ00qShld7WdQeEllIKPwIHZ6icjNYzTbZV46R9ROtwUWeo
         SKcgLzgl1xMBD2HjdvRVEz6gX6GtCC8PQWTV+Rkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Werner Sembach <wse@tuxedocomputers.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 03/50] ALSA: hda/realtek: Add quirk for Clevo X170KM-G
Date:   Mon, 18 Oct 2021 15:24:10 +0200
Message-Id: <20211018132326.635310179@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Werner Sembach <wse@tuxedocomputers.com>

commit cc03069a397005da24f6783835c274d5aedf6043 upstream.

This applies a SND_PCI_QUIRK(...) to the Clevo X170KM-G barebone. This
fixes the issue of the devices internal Speaker not working.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211001133111.428249-3-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2524,6 +2524,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1558, 0x67e5, "Clevo PC70D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x70d1, "Clevo PC70[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x7714, "Clevo X170SM", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x7715, "Clevo X170KM-G", ALC1220_FIXUP_CLEVO_PB51ED),
 	SND_PCI_QUIRK(0x1558, 0x9501, "Clevo P950HR", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1558, 0x9506, "Clevo P955HQ", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1558, 0x950a, "Clevo P955H[PR]", ALC1220_FIXUP_CLEVO_P950),


