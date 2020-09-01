Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BBF2597CA
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgIAQSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731166AbgIAPdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:33:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6C1621582;
        Tue,  1 Sep 2020 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974403;
        bh=cRTNBOTMIj2+KE/0u9AQCGRWTxUSPaOiR+upbYr0eV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtOvV4N+YTja0FIAMaJr9d3t4QIRQh7wPgTNleJrJtDJzGffR+beVeF6zrzZL9p08
         JLS8TgwuZ+GTaPjtLATbvn/9liqznJX7TdoHn8suqhK3V4Ttamn4rOst0iRlcuNLyw
         TMlx68UsYMpTQLNaibKPuhu+IXDbHbfykyyaUV3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Pozulp <pozulp.kernel@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 132/214] ALSA: hda/realtek: Add model alc298-samsung-headphone
Date:   Tue,  1 Sep 2020 17:10:12 +0200
Message-Id: <20200901150959.309280448@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Pozulp <pozulp.kernel@gmail.com>

[ Upstream commit 23dc958689449be85e39351a8c809c3d344b155b ]

The very quiet and distorted headphone output bug that afflicted my
Samsung Notebook 9 is appearing in many other Samsung laptops. Expose
the quirk which fixed my laptop as a model so other users can try it.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207423
Signed-off-by: Mike Pozulp <pozulp.kernel@gmail.com>
Link: https://lore.kernel.org/r/20200817043219.458889-1-pozulp.kernel@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3c7bc398c0cbc..d1b74c7cacd76 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7939,6 +7939,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC299_FIXUP_PREDATOR_SPK, .name = "predator-spk"},
 	{.id = ALC298_FIXUP_HUAWEI_MBX_STEREO, .name = "huawei-mbx-stereo"},
 	{.id = ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE, .name = "alc256-medion-headset"},
+	{.id = ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET, .name = "alc298-samsung-headphone"},
 	{}
 };
 #define ALC225_STANDARD_PINS \
-- 
2.25.1



