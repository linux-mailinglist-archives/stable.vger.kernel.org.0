Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B6F401BC5
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243022AbhIFM7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243131AbhIFM7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:59:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7094661052;
        Mon,  6 Sep 2021 12:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933078;
        bh=5pWxRXWS6BeYnRDm27Yaob4ot5rEujuppscH3KhZuNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArV/5VG0wvtE93qMa3q9eG/DhTVRQC0aWnxSeg4wv+N9UR+4xLZkLpsLt/2CUZ5KY
         ktSjLx6V7nQSiMrWwlqiIl4n13SJLiE9FpUMj3bhIO/8TLT08CVhqKicARUnDo8Y1Z
         z//bLv4xG7EXIBI3QNd9rA+Chh0LEwgly2X2Jles=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johnathon Clark <john.clark@cantab.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 20/24] ALSA: hda/realtek: Quirk for HP Spectre x360 14 amp setup
Date:   Mon,  6 Sep 2021 14:55:49 +0200
Message-Id: <20210906125449.780294969@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.112564040@linuxfoundation.org>
References: <20210906125449.112564040@linuxfoundation.org>
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
@@ -8378,6 +8378,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87f2, "HP ProBook 640 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f4, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87f6, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x103c, 0x87f7, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x103c, 0x8805, "HP ProBook 650 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x880d, "HP EliteBook 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),


