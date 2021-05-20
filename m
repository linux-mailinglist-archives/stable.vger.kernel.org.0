Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBFD38A6E2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237285AbhETKb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:31:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237037AbhETK32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:29:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A27DC61C3B;
        Thu, 20 May 2021 09:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504277;
        bh=CGi/xxuZCryuy+5YfCN7ojft/9E3qEgxLhPOFjURu5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BLsoqRIaMJHYl3ENTeC8cQqFZ+9td3fcROFLOliRYFeYuL0Ll1m+NSGeBz+HK9MTR
         Nlzzv+9nae4C4ia4mC4scYKoPQVwJbxeIB7kWJb9pX6atmptXJ6fWZUW7d59Tx+Ei4
         Nv32uvICBjWjpiA7zrES62LyKEJhgEdNznK49cZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 128/323] ALSA: hda/realtek: Re-order ALC882 Acer quirk table entries
Date:   Thu, 20 May 2021 11:20:20 +0200
Message-Id: <20210520092124.498862829@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit b265047ac56bad8c4f3d0c8bf9cb4e828ee0d28e upstream.

Just re-order the alc882_fixup_tbl[] entries for Acer devices for
avoiding the oversight of the duplicated or unapplied item in future.
No functional changes.

Also Cc-to-stable for the further patch applications.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210428112704.23967-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2301,13 +2301,13 @@ static const struct snd_pci_quirk alc882
 		      ALC882_FIXUP_ACER_ASPIRE_8930G),
 	SND_PCI_QUIRK(0x1025, 0x0146, "Acer Aspire 6935G",
 		      ALC882_FIXUP_ACER_ASPIRE_8930G),
+	SND_PCI_QUIRK(0x1025, 0x0142, "Acer Aspire 7730G",
+		      ALC882_FIXUP_ACER_ASPIRE_4930G),
+	SND_PCI_QUIRK(0x1025, 0x0155, "Packard-Bell M5120", ALC882_FIXUP_PB_M5210),
 	SND_PCI_QUIRK(0x1025, 0x015e, "Acer Aspire 6930G",
 		      ALC882_FIXUP_ACER_ASPIRE_4930G),
 	SND_PCI_QUIRK(0x1025, 0x0166, "Acer Aspire 6530G",
 		      ALC882_FIXUP_ACER_ASPIRE_4930G),
-	SND_PCI_QUIRK(0x1025, 0x0142, "Acer Aspire 7730G",
-		      ALC882_FIXUP_ACER_ASPIRE_4930G),
-	SND_PCI_QUIRK(0x1025, 0x0155, "Packard-Bell M5120", ALC882_FIXUP_PB_M5210),
 	SND_PCI_QUIRK(0x1025, 0x021e, "Acer Aspire 5739G",
 		      ALC882_FIXUP_ACER_ASPIRE_4930G),
 	SND_PCI_QUIRK(0x1025, 0x0259, "Acer Aspire 5935", ALC889_FIXUP_DAC_ROUTE),


