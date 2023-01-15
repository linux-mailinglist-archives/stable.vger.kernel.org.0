Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B301066B3B9
	for <lists+stable@lfdr.de>; Sun, 15 Jan 2023 20:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjAOTxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Jan 2023 14:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbjAOTxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Jan 2023 14:53:43 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EE81285A
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 11:53:41 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id cf42so40137166lfb.1
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 11:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R/ejN6HxLTHHDXLF7+I38WOnnbW5uVWnufthnnCTFuY=;
        b=gJXRrElF7CiEw/HJ7DCcdwlFm3XWRSxYa8sKfkIb9+V0MoViSAFA+306myH0vk/15c
         zBGBVGKhahU/++SGNTqpnYFQbxxbmc+sqkpiosHZBAAwJG5UIvJT/aF5Ux4S5mqtg6S0
         ZggM3N/QjJlD7QKLe/5YqC2iOdAaCLpRqjcaMDw6bOtMm8h2EvMAXzH70Ft9bvV3ehju
         XDXqLyLJx4XAxJhOhs5prBTT6htMu3QHGSJ1vM7umoBXiJQM5nXNT10WyNxcmExZ1Cp0
         VOLsjA90BqVL0OBTjN4z83mCG9YWp6bTgm569VlU8H7wlrPdJRIe4vbRMcV3SISqNq8N
         kBwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R/ejN6HxLTHHDXLF7+I38WOnnbW5uVWnufthnnCTFuY=;
        b=q7qUDfTNw8+PNe1aOW4nVihvOlVatrxoF3oeEr4P3lIaXpXmc+jQ35MlQgZMrRg1/j
         j60lrZjq1KF4CeDkeiuLYWkI1dZR0IiFDrA1FBFxO4qOkN81QbJBg9htN6o479EtmEUn
         K+lua4hKzPE2OeNlHa6n9LEyJ16XCrZ1nY5OWwm7a6XQQVLdiFwUaSBRop1ySItUPK1L
         GOzzahXYQ9hKq6QI+4z+eGklpHbRHEfRz8GI33R3X+dqwRhuDhMHJKADYQB6jsH0ashZ
         WTZyJy+bWd2pBA2ksiPt7roWhPduzmJ0re8jOT93UNxmakQ7kpOX5KG13BTgn55by2c3
         cuhA==
X-Gm-Message-State: AFqh2kokoABw75bMMxU83TEIabm448sOapuyiNzOOPt5ONxnCRmRx3Ft
        o1lZnc6Ex+MaKqOQXY6B3+a2WQ==
X-Google-Smtp-Source: AMrXdXs8LtiGYJSIP5FOeFhtEK/WNqj7cUyCysUFLbo6kBFA6IQivfX45L/d2pXz58lsSMynXmkDzw==
X-Received: by 2002:a05:6512:224f:b0:4cc:586b:1834 with SMTP id i15-20020a056512224f00b004cc586b1834mr12702690lfu.45.1673812420160;
        Sun, 15 Jan 2023 11:53:40 -0800 (PST)
Received: from localhost.localdomain (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id r12-20020ac252ac000000b004aab0ca795csm4780439lfm.211.2023.01.15.11.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 11:53:39 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     u-boot@lists.denx.de, Tom Rini <trini@konsulko.com>
Cc:     Anand Gore <anand.gore@broadcom.com>,
        William Zhang <william.zhang@broadcom.com>,
        Kursad Oney <kursad.oney@broadcom.com>,
        Joel Peshkin <joel.peshkin@broadcom.com>,
        Philippe Reynes <philippe.reynes@softathome.com>,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, stable@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 07/14] mtd: rawnand: brcmnand: fix hamming oob layout
Date:   Sun, 15 Jan 2023 20:53:05 +0100
Message-Id: <20230115195312.1477845-8-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230115195312.1477845-1-linus.walleij@linaro.org>
References: <20230115195312.1477845-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Álvaro Fernández Rojas <noltari@gmail.com>

First 2 bytes are used in large-page nand.

Fixes: ef5eeea6e911 ("mtd: nand: brcm: switch to mtd_ooblayout_ops")
Cc: stable@vger.kernel.org
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200512075733.745374-2-noltari@gmail.com
[Ported to U-Boot from the Linux kernel]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index fdc1fc6c1043..7cb6f2651250 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -1059,11 +1059,14 @@ static int brcmnand_hamming_ooblayout_free(struct mtd_info *mtd, int section,
 		if (!section) {
 			/*
 			 * Small-page NAND use byte 6 for BBI while large-page
-			 * NAND use byte 0.
+			 * NAND use bytes 0 and 1.
 			 */
-			if (cfg->page_size > 512)
-				oobregion->offset++;
-			oobregion->length--;
+			if (cfg->page_size > 512) {
+				oobregion->offset += 2;
+				oobregion->length -= 2;
+			} else {
+				oobregion->length--;
+			}
 		}
 	}
 
-- 
2.39.0

