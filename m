Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83C361A229
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 21:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiKDU3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 16:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKDU3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 16:29:30 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B321ADB3
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 13:29:29 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id b62so5350074pgc.0
        for <stable@vger.kernel.org>; Fri, 04 Nov 2022 13:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=xianwang.io; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dNuOKOg5TSGR3sEFnpto1NusoWdDGSQBWKpGFE9UhI8=;
        b=Wz6o3Ssb6qoQQb4wDttx51bVElUbeXinkynJ9AE/ddy1Aob9geCC7eWuA/BbexLl2C
         VozOESQYheDe8Uqx97e8NHSVy07RRsHPoJ25VBi0cRLnFTbH9UcknIws3N0klm+FmXCM
         olD8RIzsAkJS6SdEWbtbnvrD91GzJSwG5Z2LHI1+wtF2uyLoc7i03a254R/zMbj0+jsc
         pYaKo2awRcVHZOzaikb7OH0p/3jqnyQbeux6oIV2JQUPzLQlt8R67R3bNTAOr744CVLS
         ZZX+dypVpy4bKOEKwwKqJk6k9ank0qZKedIOM9QkET0C40aonV9ap4s9I5AdnY84DftN
         mmHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dNuOKOg5TSGR3sEFnpto1NusoWdDGSQBWKpGFE9UhI8=;
        b=1ehtLfikH7o2J7hhlSoYGbS2BNRMaLAQlB4OLus75yxHDjjBY/o2x/I/xw9E2yT368
         e5gSD9cqOQbI7Z+R1T31XbZZxK12WRQ3J7j7PXROKn1O6GRwx32z+OYUK1zUQJP1Ogn0
         Dpf8lNoutqUQQYBg9sSYLLa10C9O4XTCn2IxF/chMn6Tq9gVXiaDkl0/7xGv/jKGSMVm
         3D1O9Eu1zVPq92SDN9zju4jP18RyVNZi89yb/E4SpaejgW3EpDW/ICmj3V2cE6twRH3Y
         eR0Sp0G45BsU8s62ekuwo6e6Ngcd10AnBA6NU/cLxvYBuUm+XKKqwZw9WjVAy3sOkYlI
         nFRA==
X-Gm-Message-State: ACrzQf39vaA9VdgE8kf5C/N099GjQkVweYmqwg1IXinH3FFCb+InL9Q5
        8qahzMOfYPLYplE5BEf1U5fdVA==
X-Google-Smtp-Source: AMsMyM6pF1IEuLJpCOWhcd/9mFu2k77dwgeQT5Ij3OZfPSun43ThrToOxj/+2bNwCeSyh1diar3UNA==
X-Received: by 2002:a63:5123:0:b0:46f:f329:c013 with SMTP id f35-20020a635123000000b0046ff329c013mr16440935pgb.428.1667593769432;
        Fri, 04 Nov 2022 13:29:29 -0700 (PDT)
Received: from aurora.xw.lan (75-172-80-208.tukw.qwest.net. [75.172.80.208])
        by smtp.gmail.com with ESMTPSA id u8-20020a1709026e0800b0017bb38e4588sm161464plk.135.2022.11.04.13.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 13:29:28 -0700 (PDT)
From:   Xian Wang <dev@xianwang.io>
To:     Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Xian Wang <dev@xianwang.io>, stable@vger.kernel.org
Subject: [PATCH] patch_ca0132: add quirk for EVGA Z390 DARK
Date:   Fri,  4 Nov 2022 13:29:13 -0700
Message-Id: <20221104202913.13904-1-dev@xianwang.io>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Z390 DARK mainboard uses a CA0132 audio controller. The quirk is
needed to enable surround sound and 3.5mm headphone jack handling in
the front audio connector as well as in the rear of the board when in
stereo mode.

Page 97 of the linked manual contains instructions to setup the
controller.

Link: https://www.evga.com/support/manuals/files/131-CS-E399.pdf

Cc: stable@vger.kernel.org

Signed-off-by: Xian Wang <dev@xianwang.io>
---
 sound/pci/hda/patch_ca0132.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 9580fe00cbd9..0a292bf271f2 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1306,6 +1306,7 @@ static const struct snd_pci_quirk ca0132_quirks[] = {
 	SND_PCI_QUIRK(0x1458, 0xA026, "Gigabyte G1.Sniper Z97", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1458, 0xA036, "Gigabyte GA-Z170X-Gaming 7", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x3842, 0x1038, "EVGA X99 Classified", QUIRK_R3DI),
+	SND_PCI_QUIRK(0x3842, 0x1055, "EVGA Z390 DARK", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1102, 0x0013, "Recon3D", QUIRK_R3D),
 	SND_PCI_QUIRK(0x1102, 0x0018, "Recon3D", QUIRK_R3D),
 	SND_PCI_QUIRK(0x1102, 0x0051, "Sound Blaster AE-5", QUIRK_AE5),
-- 
2.38.1

