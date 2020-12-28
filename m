Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A242E6552
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391063AbgL1Ncp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:32:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391061AbgL1Nco (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:32:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC9C72063A;
        Mon, 28 Dec 2020 13:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162349;
        bh=A/k6bKIiOLiyP6gucccTM4Zi1xmb5RHRHTm4hovr+cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcG3EMh2rKt/DFzZ5kRELi7Bwnll/5yx7ww63FbX0kJkkPIGv/TRmRLKDHZI/ZYkC
         IUwCB7S/JyEi8pgafzqHx5+NzY+7u8H2B1IRZhmdPQAcYLSQZrb0ITsDjtffhzwMml
         yK6IsJUBrpQmR2Ol6aB6BgODvnrNDQIK5k7oCQ94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chiu@endlessos.org>,
        Jian-Hong Pan <jhp@endlessos.org>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 273/346] ALSA: hda/realtek - Enable headset mic of ASUS Q524UQK with ALC255
Date:   Mon, 28 Dec 2020 13:49:52 +0100
Message-Id: <20201228124932.970900529@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chiu@endlessos.org>

commit 7e413528474d5895e3e315c019fb0c43522eb6d9 upstream.

The ASUS laptop Q524UQK with ALC255 codec can't detect the headset
microphone until ALC255_FIXUP_ASUS_MIC_NO_PRESENCE quirk applied.

Signed-off-by: Chris Chiu <chiu@endlessos.org>
Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201209045730.9972-1-chiu@endlessos.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7101,6 +7101,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1b13, "Asus U41SV", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1bbd, "ASUS Z550MA", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1c23, "Asus X55U", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x1043, 0x125e, "ASUS Q524UQK", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),


