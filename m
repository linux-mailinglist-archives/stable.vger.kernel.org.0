Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB6461A21D
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 21:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiKDU05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 16:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiKDU04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 16:26:56 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2D6112D
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 13:26:54 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d10so5455325pfh.6
        for <stable@vger.kernel.org>; Fri, 04 Nov 2022 13:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=xianwang.io; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dNuOKOg5TSGR3sEFnpto1NusoWdDGSQBWKpGFE9UhI8=;
        b=A6YYqRsV7b1o3r1ten+hFi3AdKoFqKwkSsJ7LlLLI+gQRTR9qIXn33903udZjOAJXf
         yZM12R+1etlmOGl5BkKrKb0mbFWBiIrevorP+bIfj0bIsdq3ztcfZqkz0dKTIr4gkUVe
         KBIStWfA99FY1Vj/0Y4dezGCTwwc2HSc65rHybRMYkT93+yE4ixX4w0M46meP7Dd5hSL
         9duvECP7lzr/9dEqPQvGmSeOyHmWQotau8tktl9PZWaq+85rl5Vts7WW2n8OJSo5DUyN
         cKlJqcWQpzhQ5ssqKPsju7JjPz8LM6YnXm7wIth5EH0mx89blONEAfPKbncavnkoO4qk
         L2Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dNuOKOg5TSGR3sEFnpto1NusoWdDGSQBWKpGFE9UhI8=;
        b=ux1m+IGYyGkwcuSlUTw69vDkytKsM4/JG0hslkqo1f3wI79Z6u9xSxtAudNWAsf0XL
         SbcrlbaMAdWQ0rfaKdWvBHLRzKZh9eirFVVtLOJfvRXRfbLB+wkeRrrnxdQFnO4HICt1
         jFblgm9f70QZE7fSOJSlRjxdZLSeQ/GVB4hJ8LApF5VjeYFwS2Glk64avUViiud6YLJw
         oogpatfI2vxcQs0jdosJID+5HV2CPluuuRonJAG+Ve69Gs2sVHK6m5PSxcqxbxTEL3Gx
         s2LJpz9aN14FqTxiFaJSlmtVpf6ywaxBr4RU4fBMPuBhDS0CUuujeWC2+0Y7Cb4s4Mgu
         k9Pw==
X-Gm-Message-State: ACrzQf2QQg1NktnslABtwzRft9lnGI3HaMyu3gQoZ3HRIk2NC9USntm8
        /YXeLC/xdl+WD09+6HiE6kYPF0wN4BbXZciB
X-Google-Smtp-Source: AMsMyM5ouK1DNbpbd7ocnxHKoqRVeWc95GHRU0pDgOGTO8bA9WILEcCS5JgH5SfFW7yYwO6ZEPCrPw==
X-Received: by 2002:a05:6a00:ad0:b0:555:ac02:433b with SMTP id c16-20020a056a000ad000b00555ac02433bmr37402372pfl.18.1667593614428;
        Fri, 04 Nov 2022 13:26:54 -0700 (PDT)
Received: from aurora.xw.lan (75-172-80-208.tukw.qwest.net. [75.172.80.208])
        by smtp.gmail.com with ESMTPSA id u132-20020a62798a000000b00561b53512b0sm29598pfc.195.2022.11.04.13.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 13:26:53 -0700 (PDT)
From:   Xian Wang <dev@xianwang.io>
To:     victor.xianwang@gmail.com
Cc:     Xian Wang <dev@xianwang.io>, stable@vger.kernel.org
Subject: [PATCH] patch_ca0132: add quirk for EVGA Z390 DARK
Date:   Fri,  4 Nov 2022 13:26:51 -0700
Message-Id: <20221104202651.13732-1-dev@xianwang.io>
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

