Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117984C1A0E
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 18:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243459AbiBWRpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 12:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243452AbiBWRpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 12:45:06 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827D741330;
        Wed, 23 Feb 2022 09:44:38 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id qe15so3392360pjb.3;
        Wed, 23 Feb 2022 09:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RfVO0n5bxGhQlU0yKBog2OCZbfoJHnMeC+GhXjg5mv4=;
        b=FB50oQpMVTkvBsoC0KbxLE+VZpLrQTlWwFsy7EK9J9qAReHSUwWc6dczvqjrhoXiWW
         hRNu28Fraan9kItEcBg/5xGB6GQMTjssUgAERodNsNe0Fc/JSRSxRlxh8oidw7118F9A
         wz5l+ieHkRQ1Qi7tJoBgVGsUJ3pfayiCr4kPXHyiCh8CzaSR2wkpDlC4G6pze8nfFjY3
         dzt44Pezz2s5tYfy1LgTQmBTYUf9chzIq0x58I2RnqWrkwY6maeZDCvdS3WRdkfuFyeW
         DKXgPhGGph+LUKqLlCJzoHRSfpxKF2I4U8oCJARAbamrTt6bgKhRI0J+xK/DDKUlcZwQ
         aGPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RfVO0n5bxGhQlU0yKBog2OCZbfoJHnMeC+GhXjg5mv4=;
        b=Z1/1SG/0uyAo1pw/gYEF7ccGes5gGRkc3ha+y/Dvv0E6L6DTPG7CXYfAGAdp4Z6Q3S
         aDL/YR/RhhXwQAVhe0et0zljVDPV0grQ2MvUna3ZfSTOzdAxSOPy7RbQ/vEgUDSfMAnB
         X5l2tkOxZxKkPEArN8cdWJcJBTp6O+jE6/HXVWkJhBK1QeZWhbvGKkgqWdoq5vLJjrvL
         TPktrRwrA6L7eq3UROvSk1i4KH/VMd4gUDfZTgGrxFpsLKc8QIazwcuvpcLkC4raTJJ2
         VzZR8niU/feTae7pjib+2iH90HSONhlKSb26JTf4bkTubV6Dj3Gw6B1Cngin5A/7zsA2
         X/hA==
X-Gm-Message-State: AOAM533xYFMC88ya7cCkNXWNecQsS7VXinPkKRu3JVfA0qCceHgXYBII
        QzIvCg/LofbL18rj1UJkAKqnvAEkbgY=
X-Google-Smtp-Source: ABdhPJw2uax1PBCZviYrUXWX3Z3VY8N34gBZnt0PjeFXJifAOgXxCBirlhQDkTPeK64MbaURo4wz8g==
X-Received: by 2002:a17:90a:7788:b0:1bc:6d1:a095 with SMTP id v8-20020a17090a778800b001bc06d1a095mr477839pjk.122.1645638277652;
        Wed, 23 Feb 2022 09:44:37 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g18sm127422pfc.108.2022.02.23.09.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 09:44:36 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        david regan <dregan@mail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org (open list:BROADCOM STB NAND FLASH DRIVER),
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM STB NAND
        FLASH DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH RESEND stable 4.19] mtd: rawnand: brcmnand: Fixed incorrect sub-page ECC status
Date:   Wed, 23 Feb 2022 09:44:29 -0800
Message-Id: <20220223174431.1083-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: david regan <dregan@mail.com>

commit 36415a7964711822e63695ea67fede63979054d9 upstream

The brcmnand driver contains a bug in which if a page (example 2k byte)
is read from the parallel/ONFI NAND and within that page a subpage (512
byte) has correctable errors which is followed by a subpage with
uncorrectable errors, the page read will return the wrong status of
correctable (as opposed to the actual status of uncorrectable.)

The bug is in function brcmnand_read_by_pio where there is a check for
uncorrectable bits which will be preempted if a previous status for
correctable bits is detected.

The fix is to stop checking for bad bits only if we already have a bad
bits status.

Fixes: 27c5b17cd1b1 ("mtd: nand: add NAND driver "library" for Broadcom STB NAND controller")
Signed-off-by: david regan <dregan@mail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/trinity-478e0c09-9134-40e8-8f8c-31c371225eda-1643237024774@3c-app-mailcom-lxa02
[florian: make patch apply to 4.19]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index 774ffa9e23f3..2b02f558b5e1 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -1637,7 +1637,7 @@ static int brcmnand_read_by_pio(struct mtd_info *mtd, struct nand_chip *chip,
 					mtd->oobsize / trans,
 					host->hwcfg.sector_size_1k);
 
-		if (!ret) {
+		if (ret != -EBADMSG) {
 			*err_addr = brcmnand_read_reg(ctrl,
 					BRCMNAND_UNCORR_ADDR) |
 				((u64)(brcmnand_read_reg(ctrl,
-- 
2.25.1

