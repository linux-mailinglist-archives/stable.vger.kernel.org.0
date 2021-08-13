Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41863EB8F1
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241259AbhHMPS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242075AbhHMPQW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:16:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0F7B610A5;
        Fri, 13 Aug 2021 15:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867717;
        bh=B102KMD6TWtwkDLnhEKPzxzIVwWXK14OA98eURIJzA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHgU/8630s0S3WsyCBWiPCzihtbrMgfCQFqBPc69KnX2GaEpZup1CWiq46/JWIkBK
         7n+Vuh2MHxagfOecs+OMSVhDcCGwC1Khd4zv57w1HLRdHfPt32STo2OYkoPhNtI6aq
         K3VCC8sC7nrB/swRlfZ3rj8tjEXSGYnGK7l0iYdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luke D Jones <luke@ljones.dev>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 6/8] ALSA: hda: Add quirk for ASUS Flow x13
Date:   Fri, 13 Aug 2021 17:07:43 +0200
Message-Id: <20210813150520.281990142@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150520.090373732@linuxfoundation.org>
References: <20210813150520.090373732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke D Jones <luke@ljones.dev>

commit 739d0959fbed23838a96c48fbce01dd2f6fb2c5f upstream.

The ASUS GV301QH sound appears to work well with the quirk for
ALC294_FIXUP_ASUS_DUAL_SPK.

Signed-off-by: Luke D Jones <luke@ljones.dev>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210807025805.27321-1-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8406,6 +8406,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1740, "ASUS UX430UA", ALC295_FIXUP_ASUS_DACS),
 	SND_PCI_QUIRK(0x1043, 0x17d1, "ASUS UX431FL", ALC294_FIXUP_ASUS_DUAL_SPK),
+	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1881, "ASUS Zephyrus S/M", ALC294_FIXUP_ASUS_GX502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),


