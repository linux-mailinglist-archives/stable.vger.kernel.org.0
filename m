Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C4329B97A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802515AbgJ0Pty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901076AbgJ0PQW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:16:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25DC92225E;
        Tue, 27 Oct 2020 15:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811781;
        bh=NpJaHbGeIIvE8rsE0MW0vmwhcN/eP4gt8C1Cw8J8JwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOymmholT/DcOnNUW4LUmpjqtV4WLQ8fclm34MZvvJVz3gpE+zN7qyzjnPTsbDhT6
         xjy0WyzBgPeeMRzyh6GwBkg7kBR4pWiAwF6jVI0rxeer6Yg1TV7LkdaZjHG6abJHyt
         iMlbitwpd9JS+D1JJ6gTt5inw/spdmnqQN36638w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Connor McAdams <conmanx360@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 613/633] ALSA: hda/ca0132 - Add new quirk ID for SoundBlaster AE-7.
Date:   Tue, 27 Oct 2020 14:55:56 +0100
Message-Id: <20201027135551.585389601@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Connor McAdams <conmanx360@gmail.com>

[ Upstream commit 620f08eea6d6961b789af3fa3ea86725c8c93ece ]

Add a new PCI subsystem ID for the SoundBlaster AE-7 card.

Signed-off-by: Connor McAdams <conmanx360@gmail.com>
Link: https://lore.kernel.org/r/20200825201040.30339-11-conmanx360@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_ca0132.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 62a9be5b827eb..a49c322bdbe9d 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1065,6 +1065,7 @@ enum {
 	QUIRK_R3DI,
 	QUIRK_R3D,
 	QUIRK_AE5,
+	QUIRK_AE7,
 };
 
 #ifdef CONFIG_PCI
@@ -1184,6 +1185,7 @@ static const struct snd_pci_quirk ca0132_quirks[] = {
 	SND_PCI_QUIRK(0x1102, 0x0013, "Recon3D", QUIRK_R3D),
 	SND_PCI_QUIRK(0x1102, 0x0018, "Recon3D", QUIRK_R3D),
 	SND_PCI_QUIRK(0x1102, 0x0051, "Sound Blaster AE-5", QUIRK_AE5),
+	SND_PCI_QUIRK(0x1102, 0x0081, "Sound Blaster AE-7", QUIRK_AE7),
 	{}
 };
 
-- 
2.25.1



