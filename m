Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C913EB8C9
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241533AbhHMPQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:16:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242285AbhHMPNt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:13:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31ED161107;
        Fri, 13 Aug 2021 15:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867588;
        bh=/BUXc2WfyMtXVi++uqIIe0i36f/NiLT/u13X4y+WtPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySBHf5GTEIJLbiQ/gv4Ge2rBn/sx0NskGC5WbUmivmeJkJgxzesYFWTKnYjkyOtoY
         hnQ9Ebg6dTohJbq/uQu9YaWJBRrdws7XOzVb/2uBY4vRJt4OC65CqH+HJsOWoXDleL
         s6uEEwJxYYYSw6maeQ607/z8KqAGQZHvUZe7USyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luke D Jones <luke@ljones.dev>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 14/27] ALSA: hda: Add quirk for ASUS Flow x13
Date:   Fri, 13 Aug 2021 17:07:12 +0200
Message-Id: <20210813150523.828655169@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
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
@@ -8122,6 +8122,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1740, "ASUS UX430UA", ALC295_FIXUP_ASUS_DACS),
 	SND_PCI_QUIRK(0x1043, 0x17d1, "ASUS UX431FL", ALC294_FIXUP_ASUS_DUAL_SPK),
+	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1881, "ASUS Zephyrus S/M", ALC294_FIXUP_ASUS_GX502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),


