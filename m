Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AEB2A0D3E
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 19:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgJ3SSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 14:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgJ3SSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 14:18:35 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25919C0613D5
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 11:18:35 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id w14so7461344wrs.9
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 11:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=POr4JSNxo9Vex3KFhgjAL6YPhe46OQ89C08+ir6XPTs=;
        b=dTIDxPGPYckzrbOC6452Z1q6L3MaW1Z9CfWUkssYbkTuuKzC890B9DQnGXkQ7eYX4z
         u1en4kP44xS3sM/Sgpw6aBzPfKh4+PI/qo9M4VNRqIY1ByMdgt7DuqqF4VXyqEkLLyfF
         z/OlkU05m48R64suFmuHzsonZet4HZnEru7tKDc4g858Tiq/hW2+1Fzp8jNtMePX23Ki
         /w42o716i+5AxhmT5iFTFAo+uxQ2sYqjeYRU8rMYdXhAOtNfPmOik3Qc+Om9sR+Vf1op
         ySXnMFI1sW67thE7M1Q4bUoemFEL/KIT/fgNKzdMso1GUM7oddT9hVN602WGpg1RbCyu
         d2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=POr4JSNxo9Vex3KFhgjAL6YPhe46OQ89C08+ir6XPTs=;
        b=agzPLPeKlqKHjXqu9gaJ/5Pu0EH0aG0VBN2uXl2wmC+676liF0QtikgDa/JWNrmTrD
         YrLM337Jn60v7Zwnpj9gDnIROKLmTX/NJ0m23bapIQjAwd9HG3ul/Tl8nRIdDhucErxD
         mTpPZ5mTkglu+h5rjfKJ1jnSNg3NGLCX0R7itaCGN/QRcuuLmr/68qfSX5tKwBd713/I
         piGLOQTZxqmFvkQVidv6OnZvhKuj8Neqo2/wQxZgKexUEW3VyR4VLousgtWVD+jBGAUB
         aqpouNq7hfKKIs+I2IznQ+Vg8mfvR7Tt+zl4tJo9MYl2mINugmGH7Yz1e4u9bPjHR6V/
         vPUw==
X-Gm-Message-State: AOAM533XxwSocaCr85xZB4r9WRBafRzdTY0U747mH6m0obB8cdukauhE
        LwjW0FDSUyZYHbZBkYMdIocrmw==
X-Google-Smtp-Source: ABdhPJxonhFew2B7p2VHkxM2LDKbQTJFr887Y1UWz9SfxnrnktBXTh6CZjDeCt19buh2y+hpgrAsxw==
X-Received: by 2002:adf:b7c8:: with SMTP id t8mr4941556wre.143.1604081913792;
        Fri, 30 Oct 2020 11:18:33 -0700 (PDT)
Received: from dell.default ([91.110.221.176])
        by smtp.gmail.com with ESMTPSA id q6sm5666782wma.0.2020.10.30.11.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 11:18:32 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     daniel.vetter@ffwll.ch, gregkh@linuxfoundation.org,
        yepeilin.cs@gmail.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, stable@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 1/1] Fonts: font_acorn_8x8: Replace discarded const qualifier
Date:   Fri, 30 Oct 2020 18:18:22 +0000
Message-Id: <20201030181822.570402-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 09e5b3fd5672 ("Fonts: Support FONT_EXTRA_WORDS macros for
built-in fonts") introduced the following error when building
rpc_defconfig (only this build appears to be affected):

 `acorndata_8x8' referenced in section `.text' of arch/arm/boot/compressed/ll_char_wr.o:
    defined in discarded section `.data' of arch/arm/boot/compressed/font.o
 `acorndata_8x8' referenced in section `.data.rel.ro' of arch/arm/boot/compressed/font.o:
    defined in discarded section `.data' of arch/arm/boot/compressed/font.o
 make[3]: *** [/scratch/linux/arch/arm/boot/compressed/Makefile:191: arch/arm/boot/compressed/vmlinux] Error 1
 make[2]: *** [/scratch/linux/arch/arm/boot/Makefile:61: arch/arm/boot/compressed/vmlinux] Error 2
 make[1]: *** [/scratch/linux/arch/arm/Makefile:317: zImage] Error 2

The .data section is discarded at link time.  Reinstating
acorndata_8x8 as const ensures it is still available after linking.

Cc: <stable@vger.kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 lib/fonts/font_acorn_8x8.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/fonts/font_acorn_8x8.c b/lib/fonts/font_acorn_8x8.c
index 069b3e80c4344..fb395f0d40317 100644
--- a/lib/fonts/font_acorn_8x8.c
+++ b/lib/fonts/font_acorn_8x8.c
@@ -5,7 +5,7 @@
 
 #define FONTDATAMAX 2048
 
-static struct font_data acorndata_8x8 = {
+static const struct font_data acorndata_8x8 = {
 { 0, 0, FONTDATAMAX, 0 }, {
 /* 00 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* ^@ */
 /* 01 */  0x7e, 0x81, 0xa5, 0x81, 0xbd, 0x99, 0x81, 0x7e, /* ^A */
-- 
2.25.1

