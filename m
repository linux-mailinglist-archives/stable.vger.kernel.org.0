Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC096D8F3F
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 08:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbjDFGSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 02:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234783AbjDFGSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 02:18:05 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE62986B0
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 23:18:04 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso41913418pjb.3
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 23:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680761884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b35Olt+2PoC7el1azLVeaVvHulfg1FG1zStXaw6X/Qk=;
        b=V52CaGTHC1Xu1sjLJWaJagZMlC3iGIIHuOoLhUZ6j1jUFQtxb/kCbzZyzEzfOPPOeY
         I+zWj0q/1iD0khgR9XY2jOJdVzbzsqK1XLul4fTUgGDG5bsWbr26yWEnQWiDe6sCHX0+
         O0yMwRVPyc//09Mb8OATlvlCCMmHxIb0ehe9wvheZPVtyBC/muUKivaw6Y6KRX+eM2K9
         PxGH3TBxD+muoAO5LWjPnNhyXGn9qXUd7yhhNAZlC97YgDXOwGy96VB94sU17rxKqQgF
         YzWGIhKMxcuGut0UxugXcX92OVN6VELMhtVSuIfMjD9bNaRerHWRe8cjBqg4aiok+RyI
         lvwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680761884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b35Olt+2PoC7el1azLVeaVvHulfg1FG1zStXaw6X/Qk=;
        b=aC80teB0DIh622UtCvKu6ItIyh0DI+DTrNqAERJv93t8NCpjeEYePxX7uLbaDrXyWL
         v8TCpVluS6t53D3KMJY8AkLBS6CSh1lUz1gE03lE4RkYFYEJd73Q4YJSAmZJhIrP2uQh
         2gGqc1kX9n/mKZp1rxzjv3aPtkTKkG1nkYH1B8JpnrRWcB2iBJmE/KTWupvzGWav7ZBY
         Y6dKN5DQErIhv3ykdZniqN8AnMzu1vESPnk6GOAATE6TUmo7iZ3aGwgt+ZVdBkChHlSs
         rq0pPEVk2mJC0p37YHR4iOx77ZCfhi9SaMeIMU8i/y1ttPfIu1YWugTBTMorogu6VPSc
         VgCQ==
X-Gm-Message-State: AAQBX9f4j4WsLpd37gLDTWLuEfFxAszWEPXIuWl9NBXIOy6O5o5jpt0P
        h6Go4pgM7F6cv/XCRmOzrro=
X-Google-Smtp-Source: AKy350Yans3gBJucYJ20YAtV9EsW1lYpo3zGz6gjX5T1vZ8kr1f3FNKGS03spBkrBBkZ7y0SLyUjNA==
X-Received: by 2002:a17:90b:3b8a:b0:237:161d:f5ac with SMTP id pc10-20020a17090b3b8a00b00237161df5acmr9457506pjb.36.1680761884243;
        Wed, 05 Apr 2023 23:18:04 -0700 (PDT)
Received: from ISCN5CG2520RPD.infineon.com (sp49-98-38-119.msd.spmode.ne.jp. [49.98.38.119])
        by smtp.gmail.com with ESMTPSA id y11-20020a1709027c8b00b0019c919bccf8sm567622pll.86.2023.04.05.23.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 23:18:03 -0700 (PDT)
From:   tkuw584924@gmail.com
X-Google-Original-From: Takahiro.Kuwano@infineon.com
To:     linux-mtd@lists.infradead.org
Cc:     tudor.ambarus@linaro.org, pratyush@kernel.org, michael@walle.cc,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        d-gole@ti.com, tkuw584924@gmail.com, Bacem.Daassi@infineon.com,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        stable@vger.kernel.org
Subject: [PATCH v3 1/3] mtd: spi-nor: spansion: Enable JFFS2 write buffer for Infineon s28hx SEMPER flash
Date:   Thu,  6 Apr 2023 15:17:44 +0900
Message-Id: <d586723f6f12aaff44fbcd7b51e674b47ed554ed.1680760742.git.Takahiro.Kuwano@infineon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1680760742.git.Takahiro.Kuwano@infineon.com>
References: <cover.1680760742.git.Takahiro.Kuwano@infineon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>

Infineon(Cypress) SEMPER NOR flash family has on-die ECC and its program
granularity is 16-byte ECC data unit size. JFFS2 supports write buffer
mode for ECC'd NOR flash. Provide a way to clear the MTD_BIT_WRITEABLE
flag in order to enable JFFS2 write buffer mode support.

A new SNOR_F_ECC flag is introduced to determine if the part has on-die
ECC and if it has, MTD_BIT_WRITEABLE is unset.

In vendor specific driver, a common cypress_nor_ecc_init() helper is
added. This helper takes care for ECC related initialization for SEMPER
flash family by setting up params->writesize and SNOR_F_ECC.

Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress Semper flash")
Suggested-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Cc: stable@vger.kernel.org
---
 drivers/mtd/spi-nor/core.c     |  3 +++
 drivers/mtd/spi-nor/core.h     |  1 +
 drivers/mtd/spi-nor/debugfs.c  |  1 +
 drivers/mtd/spi-nor/spansion.c | 13 ++++++++++++-
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 1e30737b607b..143ca3c9b477 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -3407,6 +3407,9 @@ static void spi_nor_set_mtd_info(struct spi_nor *nor)
 		mtd->name = dev_name(dev);
 	mtd->type = MTD_NORFLASH;
 	mtd->flags = MTD_CAP_NORFLASH;
+	/* Unset BIT_WRITEABLE to enable JFFS2 write buffer for ECC'd NOR */
+	if (nor->flags & SNOR_F_ECC)
+		mtd->flags &= ~MTD_BIT_WRITEABLE;
 	if (nor->info->flags & SPI_NOR_NO_ERASE)
 		mtd->flags |= MTD_NO_ERASE;
 	else
diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index ea9033cb0a01..8cfa82ed06c7 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -131,6 +131,7 @@ enum spi_nor_option_flags {
 	SNOR_F_SOFT_RESET	= BIT(12),
 	SNOR_F_SWP_IS_VOLATILE	= BIT(13),
 	SNOR_F_RWW		= BIT(14),
+	SNOR_F_ECC		= BIT(15),
 };
 
 struct spi_nor_read_command {
diff --git a/drivers/mtd/spi-nor/debugfs.c b/drivers/mtd/spi-nor/debugfs.c
index e200f5b9234c..082c0c5a8626 100644
--- a/drivers/mtd/spi-nor/debugfs.c
+++ b/drivers/mtd/spi-nor/debugfs.c
@@ -26,6 +26,7 @@ static const char *const snor_f_names[] = {
 	SNOR_F_NAME(SOFT_RESET),
 	SNOR_F_NAME(SWP_IS_VOLATILE),
 	SNOR_F_NAME(RWW),
+	SNOR_F_NAME(ECC),
 };
 #undef SNOR_F_NAME
 
diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index 352c40dd3864..19b1436f36ea 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -332,6 +332,17 @@ static int cypress_nor_set_page_size(struct spi_nor *nor)
 	return 0;
 }
 
+static void cypress_nor_ecc_init(struct spi_nor *nor)
+{
+	/*
+	 * Programming is supported only in 16-byte ECC data unit granularity.
+	 * Byte-programming, bit-walking, or multiple program operations to the
+	 * same ECC data unit without an erase are not allowed.
+	 */
+	nor->params->writesize = 16;
+	nor->flags |= SNOR_F_ECC;
+}
+
 static int
 s25fs256t_post_bfpt_fixup(struct spi_nor *nor,
 			  const struct sfdp_parameter_header *bfpt_header,
@@ -506,7 +517,7 @@ static int s28hx_t_post_bfpt_fixup(struct spi_nor *nor,
 static void s28hx_t_late_init(struct spi_nor *nor)
 {
 	nor->params->octal_dtr_enable = cypress_nor_octal_dtr_enable;
-	nor->params->writesize = 16;
+	cypress_nor_ecc_init(nor);
 }
 
 static const struct spi_nor_fixups s28hx_t_fixups = {
-- 
2.34.1

