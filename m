Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AA53D6248
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhGZPfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237239AbhGZPed (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:34:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3540160F5A;
        Mon, 26 Jul 2021 16:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316100;
        bh=3BuFv/ls4B2ldkV9/p4Hg0KsRTj2PIeZ0TQMVvQ9DRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ByEnlKUJcSGH6bh1rja/Qu4GZyDbJmisrE7d4dBTUBdD/kWaLNOgoTC4WDI6Uzd7o
         BGMMTwfYO4pMIj5Z6lNFXO0tzTTESaRiWO6J8usFOb3sylRnQDqNcjFx9wzlGTdpAN
         2YCoF1KtndWM2qPBNOU7wEbX6Ii3OtzFey4gTdqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damjan Georgievski <gdamjan@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 152/223] ALSA: hdmi: Expose all pins on MSI MS-7C94 board
Date:   Mon, 26 Jul 2021 17:39:04 +0200
Message-Id: <20210726153851.201454657@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 33f735f137c6539e3ceceb515cd1e2a644005b49 upstream.

The BIOS on MSI Mortar B550m WiFi (MS-7C94) board with AMDGPU seems
disabling the other pins than HDMI although it has more outputs
including DP.

This patch adds the board to the allow list for enabling all pins.

Reported-by: Damjan Georgievski <gdamjan@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAEk1YH4Jd0a8vfZxORVu7qg+Zsc-K+pR187ezNq8QhJBPW4gpw@mail.gmail.com
Link: https://lore.kernel.org/r/20210716135600.24176-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1940,6 +1940,7 @@ static int hdmi_add_cvt(struct hda_codec
 static const struct snd_pci_quirk force_connect_list[] = {
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
+	SND_PCI_QUIRK(0x1462, 0xec94, "MS-7C94", 1),
 	{}
 };
 


