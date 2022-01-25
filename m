Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E18B49BC4D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 20:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiAYTmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 14:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiAYTmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 14:42:32 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD41C061744;
        Tue, 25 Jan 2022 11:42:31 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id h23so19087425pgk.11;
        Tue, 25 Jan 2022 11:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=USylQJa0mmjFoWzFG1F23zqiuVgJzl9csCdHBPEVti0=;
        b=AGsZXhsZqaGaQ/7FfzfFQUPt6190AFi34+2oo7FWEiCMfJ2dQkry8b3ebO/HWyzyNf
         yYas0Sed2vJ+1rQP2DqXcs6KubmlR4O0GXIVJf3o2fPJj7yDT9F2iwSoYDW5IG/Fj8J3
         tNEOu1paHg+IET7AvKjyRKtos9b76YKbsebnuuAAgIBDfb109oWWczMCOqkdYelDnnPB
         3K4B28+IxTI06FiuaWO6YdGz7ivVR+kDSRGRbF3P8+83U/CIHMvbosmTjX1H/YhliCCL
         w/fvkcvugYjyH1GCNJ4P6rx38buOnjg74p+1VBcItyaVdhkk7WtdZ1g8Jt4NmbcfkpCJ
         BjwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=USylQJa0mmjFoWzFG1F23zqiuVgJzl9csCdHBPEVti0=;
        b=bHwGpgY4W8bmlZYMKb1RVp6IStnihApKSe8EUkW/Sv5Ql92/TEZ7TPpdolcbnI76/x
         1iDt/9+net/rcx8xwiGe4qG7BvmpUKmISn/LAVLZyj3s8aBqgQ1sMcq653CGMzbkqd9/
         mg6wtBKHEFTEfYeiGChr/DkHPOPreznUSKCr44/DhROW6AqhiHHfc19yblP9W7Z8Gtu2
         cplhga5GIHLAtcfRkUHo/mLnZyh2Y07ioekr6JBhT21ICWuVz07tLTFCyskzaBZxjx/E
         Ig8drkfQPSE2bzhSnZO6ZdLr7wXATbqvDAutsWzJYm8wTBaFhUEwNfcj5eMq9Vz4YTq8
         rLxg==
X-Gm-Message-State: AOAM530kQ223nF8jtZH0UVhRZyrB0bPLTASKFacaRpVAOWk5+JMHpWEe
        zDPLzEoxF6Fp3azTpHf63BzwRI9WHJc=
X-Google-Smtp-Source: ABdhPJxU7m+A1cnKQNKtl0hRt9J5+wU269A0iWMlPMN/4VtZ1CkP/A9+w2NkAkb813oA5xnFXwgTbw==
X-Received: by 2002:a63:5009:: with SMTP id e9mr13207593pgb.9.1643139750867;
        Tue, 25 Jan 2022 11:42:30 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a1sm15087343pgm.83.2022.01.25.11.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:42:30 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM
        BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE...),
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <wahrenst@gmx.net>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Phil Elwell <phil@raspberrypi.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-gpio@vger.kernel.org (open list:PIN CONTROL SUBSYSTEM),
        linux-rpi-kernel@lists.infradead.org (moderated list:BROADCOM
        BCM2711/BCM2835 ARM ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM
        BCM2711/BCM2835 ARM ARCHITECTURE)
Subject: [PATCH stable 5.4 1/7] pinctrl: bcm2835: Drop unused define
Date:   Tue, 25 Jan 2022 11:42:16 -0800
Message-Id: <20220125194222.12783-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220125194222.12783-1-f.fainelli@gmail.com>
References: <20220125194222.12783-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

commit be30d5de0a5a52c6ee2cc453a51301037ab94aa upstream

There is no usage for this define, so drop it.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/1580148908-4863-2-git-send-email-stefan.wahren@i2se.com
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index 0de1a3a96984..3fc26389a573 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -40,9 +40,6 @@
 #define BCM2835_NUM_BANKS 2
 #define BCM2835_NUM_IRQS  3
 
-#define BCM2835_PIN_BITMAP_SZ \
-	DIV_ROUND_UP(BCM2835_NUM_GPIOS, sizeof(unsigned long) * 8)
-
 /* GPIO register offsets */
 #define GPFSEL0		0x0	/* Function Select */
 #define GPSET0		0x1c	/* Pin Output Set */
-- 
2.25.1

