Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41589344321
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhCVMst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230337AbhCVMqI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:46:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31B1C619E3;
        Mon, 22 Mar 2021 12:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416945;
        bh=WegZV95ubwc/5q81jmIPAlE7op5k8dUWzXRjKiwXAeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srMJF61nRUi6eaRbkqtbVFp4ADyQaYoZV2JONdO5xWELZ86aRpwnHagsGFLTuy5iy
         L57TCkHuxwV+xz5idu6/EtjrXMOgmf3zlwg9QUcr14WyK7uSfdYuPkPZ2N4CmpH5p1
         U7XU2DCjSjvmRBaTOpSSQFpObX5ikxtjBVOP6WC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoliang Yu <yxl_22@outlook.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 04/60] ALSA: hda/realtek: apply pin quirk for XiaomiNotebook Pro
Date:   Mon, 22 Mar 2021 13:27:52 +0100
Message-Id: <20210322121922.514833297@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoliang Yu <yxl_22@outlook.com>

commit b95bc12e0412d14d5fc764f0b82631c7bcaf1959 upstream.

Built-in microphone and combojack on Xiaomi Notebook Pro (1d72:1701) needs
to be fixed, the existing quirk for Dell works well on that machine.

Signed-off-by: Xiaoliang Yu <yxl_22@outlook.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/OS0P286MB02749B9E13920E6899902CD8EE6C9@OS0P286MB0274.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8102,6 +8102,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1b35, 0x1237, "CZC L101", ALC269_FIXUP_CZC_L101),
 	SND_PCI_QUIRK(0x1b7d, 0xa831, "Ordissimo EVE2 ", ALC269VB_FIXUP_ORDISSIMO_EVE2), /* Also known as Malata PC-B1303 */
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1c06, 0x2013, "Lemote A1802", ALC269_FIXUP_LEMOTE_A1802),


