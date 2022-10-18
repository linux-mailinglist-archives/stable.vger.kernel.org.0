Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A57F602805
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 11:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiJRJLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 05:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiJRJLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 05:11:36 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038FCA99D3
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 02:11:35 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b1so21484347lfs.7
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 02:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hs5kolKpC/C8pusTeJANmsAcelkkPgG9+Ckh4D5mS3U=;
        b=cQ8VS/TMzJ1bSVnAog0nYXSe/HvTh2YhN3SDM1Scm7eOWSVxvVpxkFkmlo251b4uZe
         o58JpQozt15w1GWyyRhgQla9SHsqzbF34bVct1r16gTPQZVBLH6Y4aFn44JeP0hvqb2z
         sZtTzv7AMV0Ovc9PX8NqqnQEdVHtHsVJupNkFBGQ76niK/RwG4FigCN0yQ6SZJEcz8x/
         KGuxDhdMZN17yLgrw6XACbIesW5gBphTFZksraIq0pl+DLpUW0ub69Bu29YU8x3/HAnp
         GO1yyNPPyNZoEIfEYjWJYGwYlT+5Nz8d8VMDCBe1mIbjMVpQkRMXyGPZhwxKZT8UHxUF
         3IVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hs5kolKpC/C8pusTeJANmsAcelkkPgG9+Ckh4D5mS3U=;
        b=l6WCjJBW+FW3IB0qSnn02yUjBnsMEwlg8Ih4A/W19bD8dNy/C6r3+5etS8t3IUVpDF
         duH3h1TH1AmpfyT5Xdnqvn18aslVcjkPHhj6V9mwdx+NiD1QMmGKyqeSOMSwhAeLcXNq
         24iCTnxyoEAr7pbs96T+490cc3qcCP8h1H8/QEgaN4384MdX2di7+PnvOXO6AR6zJTKI
         BTPLqf5FVgLSgkSSVj/4AkMnYguIFC0vDPqdQmI2XJEFBTwDfnadlyHk3yPvrW91dCnS
         Kl8FdFMkZS+OCrSVhAvTZTp0Z6aIUbiBuTXqb9uKVDiKtLyJQH6W5eJo7Yimpd+BbtVl
         8zNQ==
X-Gm-Message-State: ACrzQf0eRsuMDBYOrmmMDu1wTlkCgZNg4wR02Z332zhXAaSnAREcuAY8
        rdM0YELlFTgMzJcxItEfRlkFug==
X-Google-Smtp-Source: AMsMyM7/KXg0yRfat7BbX8yGSAD6lyPNmkWy2TyM/wLC6fRxC6XiC7foevIFxBb/6zZQd41MqOcRew==
X-Received: by 2002:a19:ac04:0:b0:49a:7253:4a68 with SMTP id g4-20020a19ac04000000b0049a72534a68mr700876lfc.322.1666084293321;
        Tue, 18 Oct 2022 02:11:33 -0700 (PDT)
Received: from fedora.. ([85.235.10.72])
        by smtp.gmail.com with ESMTPSA id k15-20020ac24f0f000000b00498fc3d4d15sm1772701lfr.190.2022.10.18.02.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 02:11:32 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     linux-mtd@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2] mtd: parsers: bcm47xxpart: Fix halfblock reads
Date:   Tue, 18 Oct 2022 11:11:29 +0200
Message-Id: <20221018091129.280026-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.3
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

There is some code in the parser that tries to read 0x8000
bytes into a block to "read in the middle" of the block. Well
that only works if the block is also 0x10000 bytes all the time,
else we get these parse errors as we reach the end of the flash:

spi-nor spi0.0: mx25l1606e (2048 Kbytes)
mtd_read error while parsing (offset: 0x200000): -22
mtd_read error while parsing (offset: 0x201000): -22
(...)

Fix the code to do what I think was intended.

Cc: stable@vger.kernel.org
Fixes: f0501e81fbaa ("mtd: bcm47xxpart: alternative MAGIC for board_data partition")
Cc: Rafał Miłecki <zajec5@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Add some fixes and stable tags.
---
 drivers/mtd/parsers/bcm47xxpart.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/parsers/bcm47xxpart.c b/drivers/mtd/parsers/bcm47xxpart.c
index 50fcf4c2174b..13daf9bffd08 100644
--- a/drivers/mtd/parsers/bcm47xxpart.c
+++ b/drivers/mtd/parsers/bcm47xxpart.c
@@ -233,11 +233,11 @@ static int bcm47xxpart_parse(struct mtd_info *master,
 		}
 
 		/* Read middle of the block */
-		err = mtd_read(master, offset + 0x8000, 0x4, &bytes_read,
+		err = mtd_read(master, offset + (blocksize / 2), 0x4, &bytes_read,
 			       (uint8_t *)buf);
 		if (err && !mtd_is_bitflip(err)) {
 			pr_err("mtd_read error while parsing (offset: 0x%X): %d\n",
-			       offset + 0x8000, err);
+			       offset + (blocksize / 2), err);
 			continue;
 		}
 
-- 
2.34.1

