Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD37401C07
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 15:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244964AbhIFNBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 09:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242904AbhIFNAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 09:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8236F6103E;
        Mon,  6 Sep 2021 12:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933141;
        bh=Tt+2MqFR0CXz9JRJWG773D2bt2ls0OdXjUq2oayWZds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnugNNd79jJVLJhlmswYJHaeXvEHekM5K8TegdJPkqTKDBDjC55+Np80vhLisSwzX
         LnOX3PibrL5NzllMSQBp+cFGRqs9amVIRoSLaTF8Dn7LH1ZgofoxkSnFKMLbeoq9gX
         2zQevGCdEAql2ksA/jz0DH61JRAP5A62Jcbm4Jzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johnathon Clark <john.clark@cantab.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 09/14] ALSA: hda/realtek: Quirk for HP Spectre x360 14 amp setup
Date:   Mon,  6 Sep 2021 14:55:55 +0200
Message-Id: <20210906125448.493003707@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
References: <20210906125448.160263393@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johnathon Clark <john.clark@cantab.net>

commit 93ab3eafb0b3551c54175cb38afed3b82356a047 upstream.

This patch extends support for the HP Spectre x360 14
amp enable quirk to support a model of the device with
an additional subdevice ID.

Signed-off-by: Johnathon Clark <john.clark@cantab.net>
Link: https://lore.kernel.org/r/20210823162110.8870-1-john.clark@cantab.net
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8438,6 +8438,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87f2, "HP ProBook 640 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f4, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87f6, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x103c, 0x87f7, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x103c, 0x8805, "HP ProBook 650 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x880d, "HP EliteBook 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),


