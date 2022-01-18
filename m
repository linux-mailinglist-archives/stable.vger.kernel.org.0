Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24661492AE3
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347415AbiARQO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347555AbiARQMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:12:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB49C0613BD;
        Tue, 18 Jan 2022 08:11:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31976B81710;
        Tue, 18 Jan 2022 16:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49974C00446;
        Tue, 18 Jan 2022 16:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522307;
        bh=HtiRyzYHu/6rMFqYieOV5nQq8fpsVbNR671u3Qrhgk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtqr4rOAbMOGLIPdraku5L3euZ58PxeRrWJpMir2OteRekk1UuYanPdMVJ4CwJhai
         h44ZlfFS7yEfxPeMRN8LNmMTuWCzNkNa9N66Saw9/hclseRLXJfATIVl0/DSAwCzAd
         NqAp5bynmWqeAcdaTmN6IogvdXxiSC4J7X4lbbsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Kroon <bart@tarmack.eu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.16 25/28] ALSA: hda: ALC287: Add Lenovo IdeaPad Slim 9i 14ITL5 speaker quirk
Date:   Tue, 18 Jan 2022 17:06:20 +0100
Message-Id: <20220118160453.233898093@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
References: <20220118160452.384322748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Kroon <bart@tarmack.eu>

commit b81e9e5c723de936652653241d3dc4f33ae05e8c upstream.

The speaker fixup that is used for the Yoga 7 14ITL5 also applies to
the IdeaPad Slim 9i 14ITL5. The attached patch applies the quirk to
initialise the amplifier on the IdeaPad Slim 9i as well.

This is validated to work on my laptop.

[ corrected the quirk entry position by tiwai ]

Signed-off-by: Bart Kroon <bart@tarmack.eu>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/JAG24R.7NLJGWBF4G8U@tarmack.eu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8952,6 +8952,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x31af, "ThinkCentre Station", ALC623_FIXUP_LENOVO_THINKSTATION_P340),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940", ALC298_FIXUP_LENOVO_SPK_VOLUME),
 	SND_PCI_QUIRK(0x17aa, 0x3827, "Ideapad S740", ALC285_FIXUP_IDEAPAD_S740_COEF),
+	SND_PCI_QUIRK(0x17aa, 0x3834, "Lenovo IdeaPad Slim 9i 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3843, "Yoga 9i", ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),


