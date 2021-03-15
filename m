Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBA333B9A2
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbhCOOGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233460AbhCOOBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40B8D64F35;
        Mon, 15 Mar 2021 14:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816895;
        bh=AcZvpOfDmIVlxJS5liTO1vkvD80q7FGV+/T9uZpO1Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtzwK7Xl+cTYFTu490XawPOcbpItSnzChDy/dc82wPERbMit6vVM0ZvmN4uW3lbhz
         S4OZJzDchHGWnegyjdTxIRoS5d25G6VJFuSd7tcmwfja2++7lxHtowW0oUZlwDhAPQ
         kVs7Psnzpz8vxSlbFhlM0XIHMs96uaK1uImxbwIw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simeon Simeonoff <sim.simeonoff@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 174/290] ALSA: hda/ca0132: Add Sound BlasterX AE-5 Plus support
Date:   Mon, 15 Mar 2021 14:54:27 +0100
Message-Id: <20210315135547.783481944@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Simeon Simeonoff <sim.simeonoff@gmail.com>

commit f15c5c11abfbf8909eb30598315ecbec2311cfdc upstream.

The new AE-5 Plus model has a different Subsystem ID compared to the
non-plus model. Adding the new id to the list of quirks.

Signed-off-by: Simeon Simeonoff <sim.simeonoff@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/998cafbe10b648f724ee33570553f2d780a38963.camel@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_ca0132.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1275,6 +1275,7 @@ static const struct snd_pci_quirk ca0132
 	SND_PCI_QUIRK(0x1102, 0x0013, "Recon3D", QUIRK_R3D),
 	SND_PCI_QUIRK(0x1102, 0x0018, "Recon3D", QUIRK_R3D),
 	SND_PCI_QUIRK(0x1102, 0x0051, "Sound Blaster AE-5", QUIRK_AE5),
+	SND_PCI_QUIRK(0x1102, 0x0191, "Sound Blaster AE-5 Plus", QUIRK_AE5),
 	SND_PCI_QUIRK(0x1102, 0x0081, "Sound Blaster AE-7", QUIRK_AE7),
 	{}
 };


