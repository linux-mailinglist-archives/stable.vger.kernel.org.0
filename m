Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904544C1A12
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 18:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243463AbiBWRpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 12:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243457AbiBWRpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 12:45:09 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD2A41630;
        Wed, 23 Feb 2022 09:44:41 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id g1so16053850pfv.1;
        Wed, 23 Feb 2022 09:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bo6oFnHJAbU/j6h7MDnhNKM3GTAQUQeHdOFA1uJIsUk=;
        b=oJYZzP6GFPUp82PEMrpkxE2tpMjjHkYXVbYRnSdJyRdfqmTK7/EQNIaR8w3NIZmHya
         sZ+/6BvzTAs1hlT+RxW8gsRDZHFwuNf+NUp7MamT38U+XeQpUnmZ0Rp8QJ7JiUMbSB7H
         m2vqzA1DSdnjIcea62DI3tEfPfX/RCGDNuhE4H5nLSFyZPRl1SCSZePw7WmJQoLO4J4z
         xaQRgYyVRuEI3+YwXjVHfCCQ5CZy8L/fMU8i0fNfvhFswvYPgwGqAWaniAJjWfiTdgvx
         cW49KB6pZGJbSRy4w0F1lf8DatWYynCabPXB25oNKzl2fiOo9aI5M66wBLlmmRsnk2bY
         BW8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bo6oFnHJAbU/j6h7MDnhNKM3GTAQUQeHdOFA1uJIsUk=;
        b=1QUmvrX5wbYXf5JfI1UX2Xo71vm5rcCHCSf2DAcZTz8CoM9DhWRJngdikwwFWg8IKj
         XHvHNQ8qIbLWUjr4w8gBKl6nj0XSTZZpOWWaWNv8vS1AYetoaQ8bJc66RojvovaTZ/IF
         J+chbyZ83VSVIue7dAFLsocTYlg2w2NOsWnXu/ZkIxELLRnQCyJQ/Zq0D3eYI9WWat5V
         hNVTbfeNo1q4xJZhDtM3u1QO+wwk3Vj8Q2AhI0WSU+bRvAtZxjwTcilVkKvLAFUKWMMX
         Dn393oFCDfDhLMUh5x6VGxVTM3iqAvdoiC3W10+4BL/bMW3YffxOWM++PoCsAr4tonJc
         ZTRw==
X-Gm-Message-State: AOAM533S5qbfayeNlULGsLdMlGfcvptgRO3C9IR0Qp6yyLgBHzOq5XSO
        SVxR7wWb/eO5PEnZV2az3PFQ3rTAcoQ=
X-Google-Smtp-Source: ABdhPJwidJmEBQ9VvU3IKY6i4jO680dMGmsqMd6R3lsYnIOGnmZ99c2ZGxqVEhmgxaqFlAPkCPl3yw==
X-Received: by 2002:a63:1145:0:b0:373:7f7c:4a22 with SMTP id 5-20020a631145000000b003737f7c4a22mr566726pgr.208.1645638280986;
        Wed, 23 Feb 2022 09:44:40 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g18sm127422pfc.108.2022.02.23.09.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 09:44:40 -0800 (PST)
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
Subject: [PATCH RESEND stable 4.14] mtd: rawnand: brcmnand: Fixed incorrect sub-page ECC status
Date:   Wed, 23 Feb 2022 09:44:30 -0800
Message-Id: <20220223174431.1083-2-f.fainelli@gmail.com>
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
index c65724d0c725..0138c0c6a4b9 100644
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

