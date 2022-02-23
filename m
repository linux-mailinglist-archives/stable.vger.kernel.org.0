Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436F44C1A11
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 18:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243467AbiBWRpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 12:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243470AbiBWRpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 12:45:12 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA4C41FA6;
        Wed, 23 Feb 2022 09:44:44 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id d17so16074561pfl.0;
        Wed, 23 Feb 2022 09:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=It4RGSp99XFUqiUGEzXdClglbEaTDz0QTVwNHQyEiwQ=;
        b=Y2CbrD5i5hegSugvrCKPHNPj29y8yZMoMRlLD0Wa8YKfeyXV3iIA9/W/w4QhNQCnvb
         nRCsJYfZPlNwk/+TREo0CqyVtZDAIgVRKn3UvyW1YcLtnU8nKtkimcfr2ZI4fJOs7aC3
         hOcltgb26dFihXregXwTYOspYF2buy36P3VCq6mmcWMgXJRI7nqcCKzz9vTIxtWnMbxh
         83OyF+aOj9tIJ706ZuM4kOGuiEoMt41L4DFQAzo7cNJC2cRoDQPuoqB/twJlmojud1wO
         GnMzlmdHQ+DuZGRZr/udfxmNHO28HBEhTM9Mg9vVxTDyQfGBCEX4G03dTEPSSh0pi9+f
         HV4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=It4RGSp99XFUqiUGEzXdClglbEaTDz0QTVwNHQyEiwQ=;
        b=Lc50exEBMbVw5wqiNXXj/XOocfpCPXiu1WGoAzFvNz3SHvp9v40Lg/3Oh43xOaopmk
         YbwjNgwg8CX2pqJBKsm/bANVRZmCXONXmtlS0xWJjaeoo+iu5n7hVK0YhdFUgeDELRsu
         PfGFQrEsoYtaNvL/vK9zxI2ySVD73Bmn2X++hDnQyZQVit1CiPhJ4IKxs88tLRveV/uN
         QAhTBgh6LjadD00DpTKZW4lEa62NCoYe2UFmJimHhMULsGzyLi+r7BJ8sA7/wzuAXo6q
         5XNB+hwcnchRd2cQtUEGRDH4WAPGQ21Tnq69NZl+yz4raA6H0r0MPqRXh8FNCg1HyRof
         K7bQ==
X-Gm-Message-State: AOAM530ecwB4w6yCp0IQiWLpP/a5Xqx1Is/rLzcwgkRD5WoO7Z+/9llI
        TVUp0DNFOmZYXhSZbqY1TgRkziIKTS4=
X-Google-Smtp-Source: ABdhPJw0SEQoMfxCDE2uBJBGJz4DQcbPvWLFTM/332KGvcRXUyWWAaCmjPtmpPPswO+vrYKctJjDPw==
X-Received: by 2002:a63:5945:0:b0:375:799a:281d with SMTP id j5-20020a635945000000b00375799a281dmr513413pgm.605.1645638283593;
        Wed, 23 Feb 2022 09:44:43 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g18sm127422pfc.108.2022.02.23.09.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 09:44:42 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        david regan <dregan@mail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org (open list:NAND FLASH SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH RESEND stable 4.9] mtd: rawnand: brcmnand: Fixed incorrect sub-page ECC status
Date:   Wed, 23 Feb 2022 09:44:31 -0800
Message-Id: <20220223174431.1083-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220223174431.1083-1-f.fainelli@gmail.com>
References: <20220223174431.1083-1-f.fainelli@gmail.com>
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
[florian: make patch apply to 4.14, file was renamed]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/mtd/nand/brcmnand/brcmnand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/brcmnand/brcmnand.c b/drivers/mtd/nand/brcmnand/brcmnand.c
index 40fdc9d267b9..1c8e95cf29d2 100644
--- a/drivers/mtd/nand/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/brcmnand/brcmnand.c
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

