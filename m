Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9369F38A6B1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbhETK3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236107AbhETK1w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:27:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC5F961C2B;
        Thu, 20 May 2021 09:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504246;
        bh=V1ohVyLN9meeVj0ZCiYQuolokfC4mYMVGLS5t0j7eSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVQP+4EXy0I8aR7nb0H20to3r2TjKvTMqckgF6orRjQwvkxVugkcLEpWOWk4qeglf
         fC0ZUoLDuavFOYMo9BdqA1c+GPaZVQfL0Uwoxiey30Gy82fwwIsQaGHZ/TT3B8B6RI
         WxZqZXByqUZGOioG3myJ13lTQs31R7gD7RXzSTd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 131/323] ALSA: hda/realtek: Re-order ALC269 Lenovo quirk table entries
Date:   Thu, 20 May 2021 11:20:23 +0200
Message-Id: <20210520092124.600335924@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit f552ff54c2a700616a02b038e4bf3cbf859f65b7 upstream.

Just re-order the alc269_fixup_tbl[] entries for Lenovo devices for
avoiding the oversight of the duplicated or unapplied item in future.
No functional changes.

Also Cc-to-stable for the further patch applications.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210428112704.23967-10-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6641,9 +6641,9 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x21b8, "Thinkpad Edge 14", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x21ca, "Thinkpad L412", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x21e9, "Thinkpad Edge 15", ALC269_FIXUP_SKU_IGNORE),
+	SND_PCI_QUIRK(0x17aa, 0x21f3, "Thinkpad T430", ALC269_FIXUP_LENOVO_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x21f6, "Thinkpad T530", ALC269_FIXUP_LENOVO_DOCK_LIMIT_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x21fa, "Thinkpad X230", ALC269_FIXUP_LENOVO_DOCK),
-	SND_PCI_QUIRK(0x17aa, 0x21f3, "Thinkpad T430", ALC269_FIXUP_LENOVO_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x21fb, "Thinkpad T430s", ALC269_FIXUP_LENOVO_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x2203, "Thinkpad X230 Tablet", ALC269_FIXUP_LENOVO_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x2208, "Thinkpad T431s", ALC269_FIXUP_LENOVO_DOCK),
@@ -6683,6 +6683,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
+	SND_PCI_QUIRK(0x17aa, 0x3bf8, "Quanta FL1", ALC269_FIXUP_PCM_44K),
 	SND_PCI_QUIRK(0x17aa, 0x5013, "Thinkpad", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x501a, "Thinkpad", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x501e, "Thinkpad L440", ALC292_FIXUP_TPT440_DOCK),
@@ -6701,7 +6702,6 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x5109, "Thinkpad", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x511e, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x511f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
-	SND_PCI_QUIRK(0x17aa, 0x3bf8, "Quanta FL1", ALC269_FIXUP_PCM_44K),
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
 	SND_PCI_QUIRK(0x1b7d, 0xa831, "Ordissimo EVE2 ", ALC269VB_FIXUP_ORDISSIMO_EVE2), /* Also known as Malata PC-B1303 */
 


