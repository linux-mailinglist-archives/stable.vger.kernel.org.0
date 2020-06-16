Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141C81FB743
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731986AbgFPPob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731981AbgFPPoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:44:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F157208D5;
        Tue, 16 Jun 2020 15:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322270;
        bh=+z2rEzPrdmHOBWRCBOlmjBsTUF6O4EPLsLOg3tNTKG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohl29LXQar4iaKJO8ET6kl43ovC46AfRZx40G7DEvrYLzsFweaKRWgXx98R0NJRit
         UqvIeLbVFYGRmEm4LTHkUYsDPCqVwQCAPEQd5Yl9Ci6GecUz6BVReD8YEhfszowalO
         amQDImkw4UAaHg/SFf3c56gQDesG5rQfue6p5Cjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.7 067/163] ALSA: hda/realtek - add a pintbl quirk for several Lenovo machines
Date:   Tue, 16 Jun 2020 17:34:01 +0200
Message-Id: <20200616153110.053491329@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 573fcbfd319ccef26caa3700320242accea7fd5c upstream.

A couple of Lenovo ThinkCentre machines all have 2 front mics and they
use the same codec alc623 and have the same pin config, so add a
pintbl entry for those machines to apply the fixup
ALC283_FIXUP_HEADSET_MIC.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20200608115541.9531-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8124,6 +8124,12 @@ static const struct snd_hda_pin_quirk al
 		ALC225_STANDARD_PINS,
 		{0x12, 0xb7a60130},
 		{0x17, 0x90170110}),
+	SND_HDA_PIN_QUIRK(0x10ec0623, 0x17aa, "Lenovo", ALC283_FIXUP_HEADSET_MIC,
+		{0x14, 0x01014010},
+		{0x17, 0x90170120},
+		{0x18, 0x02a11030},
+		{0x19, 0x02a1103f},
+		{0x21, 0x0221101f}),
 	{}
 };
 


