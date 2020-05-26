Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7421E2D01
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391790AbgEZTNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404221AbgEZTNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:13:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDB3E208B6;
        Tue, 26 May 2020 19:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520394;
        bh=D+iRbQC6z8MOvPf+wJ8QtqomMFjyJtXjEcd/jU/C5hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFCH7wBMJ2dPvm09Ri52R8+nB0brOuN2dP+dSzgBnNeZ8eFYVXzpAbHRgbO/XpY2j
         wsmpZ/cjdEtc/QyovdqH7nIdBgurgIDSR8CifTmvb5K4UW2cu9CtnSz+NuH3+qlj9h
         J8RAkY0YWWjtLivtRMMI35VJSwr0kSRKWRcfVhpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian-Hong Pan <jian-hong@endlessm.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 061/126] ALSA: hda/realtek: Enable headset mic of ASUS UX581LV with ALC295
Date:   Tue, 26 May 2020 20:53:18 +0200
Message-Id: <20200526183943.277586143@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian-Hong Pan <jian-hong@endlessm.com>

[ Upstream commit 7900e81797613b92f855f9921392a7430cbdf88c ]

The ASUS UX581LV laptop's audio (1043:19e1) with ALC295 can't detect the
headset microphone until ALC295_FIXUP_ASUS_MIC_NO_PRESENCE quirk
applied.

Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Link: https://lore.kernel.org/r/20200512061525.133985-3-jian-hong@endlessm.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index ece762d0c714..dc2302171a71 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7436,6 +7436,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA", ALC294_FIXUP_ASUS_HPE),
+	SND_PCI_QUIRK(0x1043, 0x19e1, "ASUS UX581LV", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),
 	SND_PCI_QUIRK(0x1043, 0x1a30, "ASUS X705UD", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1b11, "ASUS UX431DA", ALC294_FIXUP_ASUS_COEF_1B),
-- 
2.25.1



