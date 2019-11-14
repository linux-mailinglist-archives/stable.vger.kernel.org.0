Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67416FD17E
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 00:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfKNXUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 18:20:17 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:45934 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfKNXUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 18:20:17 -0500
Received: by mail-il1-f193.google.com with SMTP id o18so7030901ils.12
        for <stable@vger.kernel.org>; Thu, 14 Nov 2019 15:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kFs5XbPF3HYTosWYp06fmiVryxSTFoWBcu4a+ZdX1+A=;
        b=Vy6GA8ddbLbjLQ0/vxsC1OSA5VAU5monEtQPIKzqFbxFLBEu5W07DTGCEUNuxvMCoT
         nsfLyheQYO63ApFFBM9PBav2L3dtOhJJNPH9orYwGwiKZNoPCURhAucodOQEyLdNXVdc
         qgi6uNyeIjrgrzGiU92WPrD4S2PRg2KHsuxZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kFs5XbPF3HYTosWYp06fmiVryxSTFoWBcu4a+ZdX1+A=;
        b=KtyPPRjcTaTRq6NLBWPqnsdBMcbYJhAz+NA+mT86L264OP3shO/u5j3nvlFc3Gz+JR
         L60FIx0T/gQK6Famd+BYL+j0OQ5mjn2NYadZus4NSN3bmdUkzcWBIoupjEF6xN0cxS1z
         thMuchJNTqI7GrS0pcfFVD7L8/QZ2q7w05UM3LSom8fuw5PRDiftyWjbQ64wace2X1f7
         mAuLcVlq8YVvJUyU6r/HCoLPsf5PYJB2Lt0tCBMrZMej0Y5cACksz5VrpynyKgxa83AG
         rrmQ7+e9q2z6j+NxrwhkL2FfNTmEVY9sLyLYh144/7IhVX0XXDmkqvSNm9PfWCygoX/p
         +GJQ==
X-Gm-Message-State: APjAAAWhRy9j2W55oGil6nrZwjTZf8ps/akaXM/8cHUYS1X0Wm1GWiBP
        M6cFu+Ws8I304nTdtH9/Dg1TaQ==
X-Google-Smtp-Source: APXvYqyYK3wJiqqhy/FBkuHJZyqIoqryDSG+Bdm4KNKKICytbtzzTrU2P8ejRbTFDQceewqACfSslw==
X-Received: by 2002:a5d:88c6:: with SMTP id i6mr3528170iol.251.1573773616389;
        Thu, 14 Nov 2019 15:20:16 -0800 (PST)
Received: from localhost ([2620:15c:183:200:2bde:b0e1:a0d8:ffc6])
        by smtp.gmail.com with ESMTPSA id q3sm1018269ill.0.2019.11.14.15.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 15:20:15 -0800 (PST)
From:   Jacob Rasmussen <jacobraz@chromium.org>
X-Google-Original-From: Jacob Rasmussen <jacobraz@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jacob Rasmussen <jacobraz@google.com>,
        Bard Liao <bardliao@realtek.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Oder Chiou <oder_chiou@realtek.com>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        Ross Zwisler <zwisler@google.com>, stable@vger.kernel.org
Subject: [PATCH v2] ASoC: rt5645: Fixed typo for buddy jack support.
Date:   Thu, 14 Nov 2019 16:20:11 -0700
Message-Id: <20191114232011.165762-1-jacobraz@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Had a typo in e7cfd867fd98 that resulted in buddy jack support not being
fixed.

Fixes: e7cfd867fd98 ("ASoC: rt5645: Fixed buddy jack support.")
Signed-off-by: Jacob Rasmussen <jacobraz@google.com>
Reviewed-by: Ross Zwisler <zwisler@google.com>
Cc: <jacobraz@google.com>
CC: stable@vger.kernel.org
---
 sound/soc/codecs/rt5645.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index 902ac98a3fbe..19662ee330d6 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3271,7 +3271,7 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 				    report, SND_JACK_MICROPHONE);
 		return;
 	case 4:
-		val = snd_soc_component_read32(rt5645->component, RT5645_A_JD_CTRL1) & 0x002;
+		val = snd_soc_component_read32(rt5645->component, RT5645_A_JD_CTRL1) & 0x0020;
 		break;
 	default: /* read rt5645 jd1_1 status */
 		val = snd_soc_component_read32(rt5645->component, RT5645_INT_IRQ_ST) & 0x1000;
-- 
2.21.0

