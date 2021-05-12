Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9438C37C12D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbhELO5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232302AbhELO4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:56:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CCED61438;
        Wed, 12 May 2021 14:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831292;
        bh=xIpC0rKTtmqM/Auu3+81co3K4Qnn0JOFD28qmNjJAkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yB3YDiQCycTJYfsDbLubuITbj8bZL5fXnUSV1c9upGwi+psW9fYQBOiuXTgx/5gQQ
         rOi/cvwpVfZ/7KDf0n7wHuJWRQyZY2vjgRoy//cSbtKqbUsG4MPPaWKULmSHGhvai9
         4CwcvEqIh2nvMwjWQdNHu+CmSuihkKnUjFUQJMg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 044/244] ALSA: hda/realtek: Re-order ALC882 Sony quirk table entries
Date:   Wed, 12 May 2021 16:46:55 +0200
Message-Id: <20210512144744.465489219@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit b7529c18feecb1af92f9db08c8e7fe446a82d96d upstream.

Just re-order the alc882_fixup_tbl[] entries for Sony devices for
avoiding the oversight of the duplicated or unapplied item in future.
No functional changes.

Also Cc-to-stable for the further patch applications.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210428112704.23967-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2479,11 +2479,11 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1043, 0x835f, "Asus Eee 1601", ALC888_FIXUP_EEE1601),
 	SND_PCI_QUIRK(0x1043, 0x84bc, "ASUS ET2700", ALC887_FIXUP_ASUS_BASS),
 	SND_PCI_QUIRK(0x1043, 0x8691, "ASUS ROG Ranger VIII", ALC882_FIXUP_GPIO3),
+	SND_PCI_QUIRK(0x104d, 0x9043, "Sony Vaio VGC-LN51JGB", ALC882_FIXUP_NO_PRIMARY_HP),
+	SND_PCI_QUIRK(0x104d, 0x9044, "Sony VAIO AiO", ALC882_FIXUP_NO_PRIMARY_HP),
 	SND_PCI_QUIRK(0x104d, 0x9047, "Sony Vaio TT", ALC889_FIXUP_VAIO_TT),
 	SND_PCI_QUIRK(0x104d, 0x905a, "Sony Vaio Z", ALC882_FIXUP_NO_PRIMARY_HP),
 	SND_PCI_QUIRK(0x104d, 0x9060, "Sony Vaio VPCL14M1R", ALC882_FIXUP_NO_PRIMARY_HP),
-	SND_PCI_QUIRK(0x104d, 0x9043, "Sony Vaio VGC-LN51JGB", ALC882_FIXUP_NO_PRIMARY_HP),
-	SND_PCI_QUIRK(0x104d, 0x9044, "Sony VAIO AiO", ALC882_FIXUP_NO_PRIMARY_HP),
 
 	/* All Apple entries are in codec SSIDs */
 	SND_PCI_QUIRK(0x106b, 0x00a0, "MacBookPro 3,1", ALC889_FIXUP_MBP_VREF),


