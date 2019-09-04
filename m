Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39169A9116
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390687AbfIDSN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390684AbfIDSN0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:13:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3866208E4;
        Wed,  4 Sep 2019 18:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620806;
        bh=3srGCbj7ekQs7/Q2VMppiRyfVO4nSNJpbhCJvTAUeOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQ6jIuHHkjof0UuCuGhFbbLEdw6i7CcxMligFjFLwZieznYsa54iezwC/QKoDBEJj
         ZuNpmX2VSOmdE4wOqgS7eX3KpJ9FX0Cc7hxQEd0LC5P91cJYLYVlguZS7iOZyDwNQU
         Qf+F8BNMg30BcmNoFhdeLsaZWEsg272DiUcO0+LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Rekowski?= <p.rekowski@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.2 061/143] ALSA: hda/ca0132 - Add new SBZ quirk
Date:   Wed,  4 Sep 2019 19:53:24 +0200
Message-Id: <20190904175316.460609767@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paweł Rekowski <p.rekowski@gmail.com>

commit 2ca371d847511f97ef991ef612a2ce805489840e upstream.

This patch adds a new PCI subsys ID for the SBZ, as found and tested by
me and some reddit users.

Link: https://lore.kernel.org/lkml/20190819204008.14426-1-p.rekowski@gmail.com
Signed-off-by: Paweł Rekowski <p.rekowski@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_ca0132.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1175,6 +1175,7 @@ static const struct snd_pci_quirk ca0132
 	SND_PCI_QUIRK(0x1028, 0x0708, "Alienware 15 R2 2016", QUIRK_ALIENWARE),
 	SND_PCI_QUIRK(0x1102, 0x0010, "Sound Blaster Z", QUIRK_SBZ),
 	SND_PCI_QUIRK(0x1102, 0x0023, "Sound Blaster Z", QUIRK_SBZ),
+	SND_PCI_QUIRK(0x1102, 0x0027, "Sound Blaster Z", QUIRK_SBZ),
 	SND_PCI_QUIRK(0x1102, 0x0033, "Sound Blaster ZxR", QUIRK_SBZ),
 	SND_PCI_QUIRK(0x1458, 0xA016, "Recon3Di", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1458, 0xA026, "Gigabyte G1.Sniper Z97", QUIRK_R3DI),


