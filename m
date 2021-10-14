Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C0142DA56
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 15:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhJNN2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 09:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbhJNN2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 09:28:50 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15A4C06174E
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 06:26:45 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id w14so4188423pll.2
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 06:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lambdal-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ebk7SpPm6BqbsfgGThol2pRxwCPynH3YSVHSd42533s=;
        b=5ck8uaGtJzIR3/mZp83FxgFLymMHubvhlgH7XJ+qzXI2Xegia9r40Sg4q2kzw7ti/r
         Ek1meYzOdYBi2N/euYWzAi1dF3mp0mp8u25qTbzhVOZaPN6LjiYUb7Q7/f1XfLTwXVya
         HG5oc1cg/Hbsyo1PI3O+1TnP5NCrPJBPB3guH+H1NMyHVIvxSU2Fmb9cLWLVfQm9aa0s
         7cW6fyvAJbR5Q2o9fphXShcDQaOD1lkWWblroyIzt7RfNa+YN5mcL5S/yJj0BSFkDOtu
         Ew/LnY5rspy9v6Or1O48O6sRswEa5l9vxiqQUYZQPQVT7T+Mw3ZgH64pww8tjz7L5/xb
         lb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ebk7SpPm6BqbsfgGThol2pRxwCPynH3YSVHSd42533s=;
        b=6kM5oU/z7iTN7gzyXQ7tmH2d2SORruky0QDlQmQL7pbFva64AcYcsFgX5OHseXIHvT
         bG/HnA+rwa9j+Ay1Jcle4iOTW3zj204a9Qg7/FjMp3K5JhABiMj8L4ygpbPgQ+0HRUbM
         E8Uu27cAZhz17ZihWTMQTediLvN5NgEIpeqY+PooM0B7m4gpWJkGVrUtbOfHcz8DRLQv
         Nk7IAdOq2ngS7/2WeAYsOpsX8CCkB8onqtBs9bGEwVFBJCA0jgrYrYXuuglufp0N1h3o
         9Eza2D70wuauM1sZWNL+whTq9iLQs2jL8NaALPAvSKnsU73kpBWUdL5O+ScZkHs5fItC
         S1hw==
X-Gm-Message-State: AOAM531h3ztsfI518J5W2Tg1+rzenFPp+TdGpOG1JmpA7FFnaxAnw65u
        QjELWu6d+vNwwdZq3Uhe5yaxsZA4z/3cUw==
X-Google-Smtp-Source: ABdhPJxIJWhMSHu2xZ1Ra5DA8NOcYq2Et+e0sJx2koGtUD4btGGNQ9Ew++0OhSoVGNQqYGYmxqns+w==
X-Received: by 2002:a17:90a:7892:: with SMTP id x18mr20662281pjk.33.1634218005295;
        Thu, 14 Oct 2021 06:26:45 -0700 (PDT)
Received: from mogadishu.hsd1.ca.comcast.net ([50.211.197.46])
        by smtp.gmail.com with ESMTPSA id s17sm2526467pge.50.2021.10.14.06.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 06:26:45 -0700 (PDT)
From:   Steven Clarkson <sc@lambdal.com>
To:     sc@lambdal.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek: Add quirk for Clevo PC50HS
Date:   Thu, 14 Oct 2021 06:26:31 -0700
Message-Id: <20211014132631.1326212-1-sc@lambdal.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Apply existing PCI quirk to the Clevo PC50HS and related models to fix
audio output on the built in speakers.

Signed-off-by: Steven Clarkson <sc@lambdal.com>
Cc: stable@vger.kernel.org
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4407f7da57c4..f44a3c7efbe6 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2533,6 +2533,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x65d2, "Clevo PB51R[CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65e1, "Clevo PB51[ED][DF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65e5, "Clevo PC50D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x65f1, "Clevo PC50HS", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67d1, "Clevo PB71[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e1, "Clevo PB71[DE][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e5, "Clevo PC70D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
-- 
2.25.1

