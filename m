Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D76F7116215
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfLHN5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:57:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60126 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726691AbfLHNym (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:42 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1C-0007eS-WA; Sun, 08 Dec 2019 13:54:39 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1B-0002NN-NZ; Sun, 08 Dec 2019 13:54:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        "Shih-Yuan Lee (FourDollars)" <fourdollars@debian.org>
Date:   Sun, 08 Dec 2019 13:53:21 +0000
Message-ID: <lsq.1575813165.488210758@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 37/72] ALSA: hda - Add laptop imic fixup for ASUS M9V
 laptop
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Shih-Yuan Lee (FourDollars)" <fourdollars@debian.org>

commit 7b485d175631be676424aedb8cd2f66d0c93da78 upstream.

The same fixup to enable laptop imic is needed for ASUS M9V with AD1986A
codec like another HP machine.

Signed-off-by: Shih-Yuan Lee (FourDollars) <fourdollars@debian.org>
Link: https://lore.kernel.org/r/20190920134052.GA8035@localhost
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_analog.c | 1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -332,6 +332,7 @@ static const struct hda_fixup ad1986a_fi
 
 static const struct snd_pci_quirk ad1986a_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x30af, "HP B2800", AD1986A_FIXUP_LAPTOP_IMIC),
+	SND_PCI_QUIRK(0x1043, 0x1153, "ASUS M9V", AD1986A_FIXUP_LAPTOP_IMIC),
 	SND_PCI_QUIRK(0x1043, 0x1443, "ASUS Z99He", AD1986A_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x1043, 0x1447, "ASUS A8JN", AD1986A_FIXUP_EAPD),
 	SND_PCI_QUIRK_MASK(0x1043, 0xff00, 0x8100, "ASUS P5", AD1986A_FIXUP_3STACK),

