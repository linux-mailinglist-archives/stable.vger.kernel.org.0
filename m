Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A22619C843
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 19:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390045AbgDBRnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 13:43:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20758 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389264AbgDBRnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 13:43:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585849398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zKFdpk7krCi2VIyyhqjptr8JEI4k0y6Kn2eHFfKxT0Y=;
        b=MHlaTHZ+OGdoVjEBxiDZKBeaMHk2qtzrvYJiK7Qc503HGPrnZP4iWFe4gctgiEi5kXdYM/
        cqbM9fVZrVw6OWMX2c74QFVGm9L7nBkoAOchkdhX97sxrnuETiTMKaIrkUu26TUQH/gMGk
        hbZy93i54eJdUca9GIE4oXXWAUlv4gA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-QydUYujnOb2m8SlgcZJMFQ-1; Thu, 02 Apr 2020 13:43:16 -0400
X-MC-Unique: QydUYujnOb2m8SlgcZJMFQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47DE9805721;
        Thu,  2 Apr 2020 17:43:15 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-135.ams2.redhat.com [10.36.112.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DAB35C541;
        Thu,  2 Apr 2020 17:43:13 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek - Add quirk for Lenovo Carbon X1 8th gen
Date:   Thu,  2 Apr 2020 19:43:11 +0200
Message-Id: <20200402174311.238614-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The audio setup on the Lenovo Carbon X1 8th gen is the same as that on
the Lenovo Carbon X1 7th gen, as such it needs the same
ALC285_FIXUP_THINKPAD_HEADSET_JACK quirk.

This fixes volume control of the speaker not working among other things.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D1820196
Cc: stable@vger.kernel.org
Suggested-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.=
c
index 63e1a56f705b..9c3bbf1df93e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7299,6 +7299,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[=
] =3D {
 	SND_PCI_QUIRK(0x17aa, 0x225d, "Thinkpad T480", ALC269_FIXUP_LIMIT_INT_M=
IC_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x2292, "Thinkpad X1 Yoga 7th", ALC285_FIXUP_THIN=
KPAD_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x2293, "Thinkpad X1 Carbon 7th", ALC285_FIXUP_TH=
INKPAD_HEADSET_JACK),
+	SND_PCI_QUIRK(0x17aa, 0x22be, "Thinkpad X1 Carbon 8th", ALC285_FIXUP_TH=
INKPAD_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x30bb, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LI=
NE2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x30e2, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LI=
NE2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x310c, "ThinkCentre Station", ALC294_FIXUP_LENOV=
O_MIC_LOCATION),
--=20
2.26.0

