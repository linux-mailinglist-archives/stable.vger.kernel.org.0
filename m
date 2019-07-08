Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 956D762287
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388389AbfGHPYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:24:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388393AbfGHPYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:24:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45786204EC;
        Mon,  8 Jul 2019 15:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599482;
        bh=JOnXpZoAkxr5HRCjPqJLLa2F47gueyRCfD+CdK3N+qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytSkwA87C1tcObc5eTgRbFhDE9r5Y8C1V002X3sYXH2fa03v4tTpBBt3YHheT4GUy
         QPwcuRuKJn2/Cb8dsB8iJXn3YwHv7xUUJjyaDPuIc4oYtfZYcCus+f7ai96UnlhE9F
         LK3JHranCFQ9niW+dKJmsDkTkHIDZH94DmwdD2yQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Wassenberg <dennis.wassenberg@secunet.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 30/56] ALSA: hda/realtek - Change front mic location for Lenovo M710q
Date:   Mon,  8 Jul 2019 17:13:22 +0200
Message-Id: <20190708150522.710468375@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis Wassenberg <dennis.wassenberg@secunet.com>

commit bef33e19203dde434bcdf21c449e3fb4f06c2618 upstream.

On M710q Lenovo ThinkCentre machine, there are two front mics,
we change the location for one of them to avoid conflicts.

Signed-off-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6590,6 +6590,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x30bb, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x30e2, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x310c, "ThinkCentre Station", ALC294_FIXUP_LENOVO_MIC_LOCATION),
+	SND_PCI_QUIRK(0x17aa, 0x3111, "ThinkCentre Station", ALC294_FIXUP_LENOVO_MIC_LOCATION),
 	SND_PCI_QUIRK(0x17aa, 0x312a, "ThinkCentre Station", ALC294_FIXUP_LENOVO_MIC_LOCATION),
 	SND_PCI_QUIRK(0x17aa, 0x312f, "ThinkCentre Station", ALC294_FIXUP_LENOVO_MIC_LOCATION),
 	SND_PCI_QUIRK(0x17aa, 0x313c, "ThinkCentre Station", ALC294_FIXUP_LENOVO_MIC_LOCATION),


