Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2803D2F1573
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731526AbhAKNMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:12:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731521AbhAKNMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:12:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C8E22253A;
        Mon, 11 Jan 2021 13:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370751;
        bh=Lx5D2+uK7b3CwnDygVD/eA/l7MCVcjIHAbmAGA2crVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwL2B0J/lrUwD6sdc/euSg92TBNHpbWiAqKQCMOQ0zFg8DYvv8sN2tq9+Amc8IpHb
         UEPe9gKfIUzlY5gH/P0iuTvalaxR5fhBNRGRODYYPcwhWchj3BFSLiALbcTcVWIjV7
         JoI+HDh/fbvd7haWvHaWj97FHHd+fj3W1mEkMv4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 81/92] ALSA: hda/realtek: Enable mute and micmute LED on HP EliteBook 850 G7
Date:   Mon, 11 Jan 2021 14:02:25 +0100
Message-Id: <20210111130043.057877299@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit a598098cc9737f612dbab52294433fc26c51cc9b upstream.

HP EliteBook 850 G7 uses the same GPIO pins as ALC285_FIXUP_HP_GPIO_LED
to enable mute and micmute LED. So apply the quirk to enable the LEDs.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201230125636.45028-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7880,6 +7880,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8497, "HP Envy x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x8724, "HP EliteBook 850 G7", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8729, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8760, "HP", ALC285_FIXUP_HP_MUTE_LED),


