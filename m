Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BEF2F1747
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730209AbhAKNEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:04:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbhAKNEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:04:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D182E22527;
        Mon, 11 Jan 2021 13:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370247;
        bh=DZnO6qmvTaNiK6GDE1a8fPyxOytyZGcJ/Zn3wR8tVuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjBdK5lNpHJS5Iy7Asz7peMmyssRcf6UjpYvmfaP5eqzuXuycb6dtcy1Xw2wnb7VP
         MwfxcaKpGzJRI4MnbYzx7UCw4K4qcyVXHF7LiWKlxdaMZyARifRG5fGS55KmoSJoRq
         RMV3IdL1ji7VykOHB8aNVJxhtCk7+yDV+6SVdFMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, bo liu <bo.liu@senarytech.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 41/45] ALSA: hda/conexant: add a new hda codec CX11970
Date:   Mon, 11 Jan 2021 14:01:19 +0100
Message-Id: <20210111130035.623323823@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: bo liu <bo.liu@senarytech.com>

commit 744a11abc56405c5a106e63da30a941b6d27f737 upstream.

The current kernel does not support the cx11970 codec chip.
Add a codec configuration item to kernel.

[ Minor coding style fix by tiwai ]

Signed-off-by: bo liu <bo.liu@senarytech.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201229035226.62120-1-bo.liu@senarytech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1001,6 +1001,7 @@ static int patch_conexant_auto(struct hd
 static const struct hda_device_id snd_hda_id_conexant[] = {
 	HDA_CODEC_ENTRY(0x14f11f86, "CX8070", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f12008, "CX8200", patch_conexant_auto),
+	HDA_CODEC_ENTRY(0x14f120d0, "CX11970", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15045, "CX20549 (Venice)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15047, "CX20551 (Waikiki)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15051, "CX20561 (Hermosa)", patch_conexant_auto),


