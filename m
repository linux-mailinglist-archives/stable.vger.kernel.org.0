Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B26492A83
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347062AbiARQKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346531AbiARQJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:09:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD8DC061777;
        Tue, 18 Jan 2022 08:09:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FE0F61295;
        Tue, 18 Jan 2022 16:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541F1C00446;
        Tue, 18 Jan 2022 16:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522167;
        bh=Cz7xkI4u/hGuL3TO19+0oF1/lmDp0JRfYAOS1RYc1oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2N59pBDxMKawN21H1b9ERNWwWYZE4wYjlgpK5KodYhgWJkrOJDVr45kniESZurr18
         hb/CnN4QFs0iVY0obhG2pW1a914jz2Ok/hPWCay5vP/Y6aglDjo/8im2UQYkLPNNHm
         CTKPwZZ7eV0VsaBEnKr0hN6tk4nJCyO9eXc2hb+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arie Geiger <arsgeiger@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 21/28] ALSA: hda/realtek: Add speaker fixup for some Yoga 15ITL5 devices
Date:   Tue, 18 Jan 2022 17:06:07 +0100
Message-Id: <20220118160452.581433619@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
References: <20220118160451.879092022@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arie Geiger <arsgeiger@gmail.com>

commit 6dc86976220cc904e87ee58e4be19dd90d6a36d5 upstream.

This patch adds another possible subsystem ID for the ALC287 used by
the Lenovo Yoga 15ITL5.
It uses the same initalization as the others.
This patch has been tested and works for my device.

Signed-off-by: Arie Geiger <arsgeiger@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211223232857.30741-1-arsgeiger@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8927,6 +8927,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3853, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
+	SND_PCI_QUIRK(0x17aa, 0x384a, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3819, "Lenovo 13s Gen2 ITL", ALC287_FIXUP_13S_GEN2_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),


