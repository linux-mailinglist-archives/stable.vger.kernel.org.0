Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F202F17B5
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbhAKOKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:10:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729687AbhAKNDN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:03:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CE122255F;
        Mon, 11 Jan 2021 13:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370139;
        bh=s9P0H2beS1hkBa84Ipr0WB3WWJpJ+glHXUYeKA/HrQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AvqxIk1/qnWgDIPP25Pwh45oyhShBNNFg87zHyzWY3coBS5I6uwBroaJCGTBZUJj8
         I8Oqk3jVEzzF6v7wsWuTv5UWdluVD8cZNBUMB2DiTDy0M9qBjKkHbBGRq8IZOkNlvl
         T3PFY+0+EdNS24y10qxHB1D0ri3cHQemtyGhfrcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, bo liu <bo.liu@senarytech.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 34/38] ALSA: hda/conexant: add a new hda codec CX11970
Date:   Mon, 11 Jan 2021 14:01:06 +0100
Message-Id: <20210111130034.095200616@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130032.469630231@linuxfoundation.org>
References: <20210111130032.469630231@linuxfoundation.org>
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
@@ -1011,6 +1011,7 @@ static int patch_conexant_auto(struct hd
 static const struct hda_device_id snd_hda_id_conexant[] = {
 	HDA_CODEC_ENTRY(0x14f11f86, "CX8070", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f12008, "CX8200", patch_conexant_auto),
+	HDA_CODEC_ENTRY(0x14f120d0, "CX11970", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15045, "CX20549 (Venice)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15047, "CX20551 (Waikiki)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15051, "CX20561 (Hermosa)", patch_conexant_auto),


