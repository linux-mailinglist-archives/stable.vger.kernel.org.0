Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0158E1C43F9
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbgEDSDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731461AbgEDSDJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:03:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ADB420707;
        Mon,  4 May 2020 18:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615388;
        bh=K4rqI3B0UdQGyemnvV/xQqF1HMpwHU8XyHixCcdZV+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJWKemY79QZ9fJY0BlQPsP8VREZw7LSYKxR1m7MNTOFX6Qp99kxgQ+W3ZAmohmNo2
         VguccwQlayCqjScBgX4bf3TBZmba0KxNCeoMuunAlrTgb/5nMaq5GoclcQf41DOemh
         tiTGlxIGP+pRLoScQAqjHaIE/UTkK/or6GpfDMi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 19/57] ALSA: hda/realtek - Two front mics on a Lenovo ThinkCenter
Date:   Mon,  4 May 2020 19:57:23 +0200
Message-Id: <20200504165458.052707215@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit ef0b3203c758b6b8abdb5dca651880347eae6b8c upstream.

This new Lenovo ThinkCenter has two front mics which can't be handled
by PA so far, so apply the fixup ALC283_FIXUP_HEADSET_MIC to change
the location for one of the mics.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20200427030039.10121-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7295,6 +7295,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1558, 0x8560, "System76 Gazelle (gaze14)", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1558, 0x8561, "System76 Gazelle (gaze14)", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC233_FIXUP_LENOVO_MULTI_CODECS),
+	SND_PCI_QUIRK(0x17aa, 0x1048, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Thinkpad SL410/510", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x215e, "Thinkpad L512", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x21b8, "Thinkpad Edge 14", ALC269_FIXUP_SKU_IGNORE),


