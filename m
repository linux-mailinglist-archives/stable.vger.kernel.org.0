Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84ABE272F7E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgIUQmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729480AbgIUQmP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:42:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67839238E6;
        Mon, 21 Sep 2020 16:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706534;
        bh=TIK1v6CNuGcMrG72smXjwUvk4mM9NTZ/+S2C1he4QDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxDYK4xKg1VK205hvmzoF+rDPkzyMFQjgGi0G2cUtisoD0+ioCQyykHPG0jNnxCml
         JicPFICFJBLcBTaaFuqcVc2keSIblPnOUAaR4RUqex7SuQnhNVYeClvRht6UghrgY/
         CTQf9YNEcxGO+hgQayFUGJ59OQAmfcCIh6wE/T4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dan Crawford <dnlcrwfrd@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 41/49] Revert "ALSA: hda - Fix silent audio output and corrupted input on MSI X570-A PRO"
Date:   Mon, 21 Sep 2020 18:28:25 +0200
Message-Id: <20200921162036.481431699@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit c0a7b7fe0e0f7baa7c1779e401d293d176307c51 which is
commit 15cbff3fbbc631952c346744f862fb294504b5e2 upstream.

It causes know regressions and will be reverted in Linus's tree soon.

Reported-by: Hans de Goede <hdegoede@redhat.com>
Cc: Dan Crawford <dnlcrwfrd@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/7efd2fe5-bf38-7f85-891a-eee3845d1493@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2452,7 +2452,6 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1462, 0x1276, "MSI-GL73", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1293, "MSI-GP65", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x7350, "MSI-7350", ALC889_FIXUP_CD),
-	SND_PCI_QUIRK(0x1462, 0x9c37, "MSI X570-A PRO", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0xda57, "MSI Z270-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK_VENDOR(0x1462, "MSI", ALC882_FIXUP_GPIO3),
 	SND_PCI_QUIRK(0x147b, 0x107a, "Abit AW9D-MAX", ALC882_FIXUP_ABIT_AW9D_MAX),


