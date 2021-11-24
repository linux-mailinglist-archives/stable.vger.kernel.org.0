Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0851A45BF34
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344822AbhKXMz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:55:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346674AbhKXMxv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:53:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35F39617E3;
        Wed, 24 Nov 2021 12:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757067;
        bh=D6eVoV17GiWvbFx4HcGu6x1dJ8Yx1kjveHkPcs2NrRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHQmtUiDuHe8cKmKmqaSUSQ/Pmizn2hxaeew18yCt7rk3858e2wRGP2MADbVfg05m
         4wGLJdSjTOZ2QbAurw/mBkXTlnvIli6AE6V/8B8ZKdnjcJJDJ3ktzGw0ACaVls8M/5
         Azx93TPQemr/D9/GiDvGpDG6A+xPjpnmfO5k7UzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Crawford <tcrawford@system76.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 015/323] ALSA: hda/realtek: Add quirk for Clevo PC70HS
Date:   Wed, 24 Nov 2021 12:53:25 +0100
Message-Id: <20211124115719.351328838@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
@@ -2525,6 +2525,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1558, 0x67d1, "Clevo PB71[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e1, "Clevo PB71[DE][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e5, "Clevo PC70D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x67f1, "Clevo PC70H[PRS]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x70d1, "Clevo PC70[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x7714, "Clevo X170SM", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x7715, "Clevo X170KM-G", ALC1220_FIXUP_CLEVO_PB51ED),


