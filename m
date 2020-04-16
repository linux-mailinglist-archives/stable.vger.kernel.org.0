Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2FF1AC39C
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898540AbgDPNp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441633AbgDPNpx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:45:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27EDA208E4;
        Thu, 16 Apr 2020 13:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044752;
        bh=S7nX239u2h/t/AEuMNtsW8RA5Xt1MqxgFCsb+8eKRNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnyE5z8adKxum7QkjdyRlcBY2cAyanEQ4Mon7NJHP45JA44bPvGi9901c3BaC93X4
         q9depQDYHMlNsP5x/pfQZKfslRWWp7XDPdRAp3U4CENaGCyCTCb4zEgLiaeEk1C6yK
         k8emMuc7Q1Liuk0f0cFGT/uCE1a41uOQt/1Bz1h4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Hans de Goede <hdegoede@redhat.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 085/232] ALSA: hda/realtek - Add quirk for Lenovo Carbon X1 8th gen
Date:   Thu, 16 Apr 2020 15:22:59 +0200
Message-Id: <20200416131325.660624289@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit ca707b3f00b4f31a6e1eb37e8ae99f15f2bb1fe5 upstream.

The audio setup on the Lenovo Carbon X1 8th gen is the same as that on
the Lenovo Carbon X1 7th gen, as such it needs the same
ALC285_FIXUP_THINKPAD_HEADSET_JACK quirk.

This fixes volume control of the speaker not working among other things.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1820196
Cc: stable@vger.kernel.org
Suggested-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20200402174311.238614-1-hdegoede@redhat.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7325,6 +7325,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x225d, "Thinkpad T480", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x2292, "Thinkpad X1 Yoga 7th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x2293, "Thinkpad X1 Carbon 7th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
+	SND_PCI_QUIRK(0x17aa, 0x22be, "Thinkpad X1 Carbon 8th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x30bb, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x30e2, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x310c, "ThinkCentre Station", ALC294_FIXUP_LENOVO_MIC_LOCATION),


