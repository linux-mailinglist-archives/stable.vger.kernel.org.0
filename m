Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D73432EA0B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhCEMgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:36:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232736AbhCEMfr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:35:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ECCB64FF0;
        Fri,  5 Mar 2021 12:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947746;
        bh=2JzeXGiCRDS5krpIcmdAwKl2U4+7AvqXfHk92N/3cAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kw5IJ+z4kvLkHeECdqkFGmVXGQlVSUKgXYCtLtivOLL8d2Vef9qWVVJ2/nPKJcmqW
         Mp10gKg2H8Dz6jssNX0Lb4QagaE7/1SiRh6jk9+m+NEUgpLMVfRWVxS54uEsUqSswk
         g8yToYrf5an3nyDVd4zxdDACYshvff8XC9lbIGZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eckhart Mohr <e.mohr@tuxedocomputers.com>,
        Werner Sembach <wse@tuxedocomputers.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 70/72] ALSA: hda/realtek: Add quirk for Clevo NH55RZQ
Date:   Fri,  5 Mar 2021 13:22:12 +0100
Message-Id: <20210305120900.763798747@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

commit 48698c973e6b4dde94d87cd1ded56d9436e9c97d upstream.

This applies a SND_PCI_QUIRK(...) to the Clevo NH55RZQ barebone. This
fixes the issue of the device not recognizing a pluged in microphone.

The device has both, a microphone only jack, and a speaker + microphone
combo jack. The combo jack already works. The microphone-only jack does
not recognize when a device is pluged in without this patch.

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Co-developed-by: Werner Sembach <wse@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/0eee6545-5169-ef08-6cfa-5def8cd48c86@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8001,6 +8001,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1558, 0x8551, "System76 Gazelle (gaze14)", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8560, "System76 Gazelle (gaze14)", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1558, 0x8561, "System76 Gazelle (gaze14)", ALC269_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1558, 0x8562, "Clevo NH[5|7][0-9]RZ[Q]", ALC269_FIXUP_DMIC),
 	SND_PCI_QUIRK(0x1558, 0x8668, "Clevo NP50B[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8680, "Clevo NJ50LU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8686, "Clevo NH50[CZ]U", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


