Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1E42F15FD
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731158AbhAKNKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:10:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731154AbhAKNKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:10:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F81B22795;
        Mon, 11 Jan 2021 13:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370579;
        bh=HFLXw64YrlEkSM+prgXkSVsLAxNofUjOyAixqjMf1tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zKXDez5hgP26wo6r0Vo2yNNSxBqat53qdX3g8bqsx/1AR50LqHmjBufSNerE6eouH
         +EU3j9gYWhDjtUquEGqO7MAqM9rd/DrCMhFN2TGKbC7cu6pxyPbJQmQjlCi4TqBHdb
         2MO2XrjIc/5/Fb/pcGgI/GxVBDSNNlBeBHCI2hRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, bo liu <bo.liu@senarytech.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 68/77] ALSA: hda/conexant: add a new hda codec CX11970
Date:   Mon, 11 Jan 2021 14:02:17 +0100
Message-Id: <20210111130039.675166370@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
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
@@ -1088,6 +1088,7 @@ static int patch_conexant_auto(struct hd
 static const struct hda_device_id snd_hda_id_conexant[] = {
 	HDA_CODEC_ENTRY(0x14f11f86, "CX8070", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f12008, "CX8200", patch_conexant_auto),
+	HDA_CODEC_ENTRY(0x14f120d0, "CX11970", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15045, "CX20549 (Venice)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15047, "CX20551 (Waikiki)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15051, "CX20561 (Hermosa)", patch_conexant_auto),


