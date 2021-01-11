Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4D02F1451
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732678AbhAKNRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:17:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732644AbhAKNRp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:17:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40BDA22CF6;
        Mon, 11 Jan 2021 13:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371049;
        bh=h/U1Uoc6/APUMIDpp27tcRaKFdjM+hD2KFESP9ZPg8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijN06jJiTVmug5ticazq9W06NXexeuJl/U1zG4XDlwMUcFM7OxIOHVyz9OVTSwHzs
         9Gm/NYlBw+IE2VynPtGzBzkIXeeRgI72Bj2QpE1j2I8HxdN2Sduk7ZoZrO/0rrHwA7
         ZptI8LcZtLJewGxkWOdil2MohIbejm6v1ZcOXiqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, bo liu <bo.liu@senarytech.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 119/145] ALSA: hda/conexant: add a new hda codec CX11970
Date:   Mon, 11 Jan 2021 14:02:23 +0100
Message-Id: <20210111130054.247167601@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
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
@@ -1070,6 +1070,7 @@ static int patch_conexant_auto(struct hd
 static const struct hda_device_id snd_hda_id_conexant[] = {
 	HDA_CODEC_ENTRY(0x14f11f86, "CX8070", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f12008, "CX8200", patch_conexant_auto),
+	HDA_CODEC_ENTRY(0x14f120d0, "CX11970", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15045, "CX20549 (Venice)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15047, "CX20551 (Waikiki)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15051, "CX20561 (Hermosa)", patch_conexant_auto),


