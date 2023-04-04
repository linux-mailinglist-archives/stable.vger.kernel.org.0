Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4EA26D5949
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 09:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbjDDHRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 03:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbjDDHRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 03:17:33 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACA11FCB
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 00:17:32 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 184so4399872pga.12
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 00:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680592652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aoNmBxTLg4bYP1LzWqAv4g+6PvsLW4SUU9joYqsr0+E=;
        b=k6hBgeKIdLswuphk8o+msL6BlDoimoCvxzs5fev3hxxlU4tJwQarX6vd+ub13AU6Dk
         SwNq4E80Mi9J9d7Lih/t65WIm6+z7BkRg4Y4JS3OoRfuWNDiJu/YnUYwTexoxjCb/3m8
         zmLXSJ0gaOulTAVvE62rKhTEpEbWu+QFAUC0TTvbD+rS5l14WwdQE783UrRU+S/DHpi0
         Y3rWsYn4KSTOfFDs7NPEYGCs0HAYoKfKo2tQvhiutAb3CfBYaD8HTUfQ25TpbaQmi3Tk
         2WIzynPmCg1Xs7+c4uXeYdrVcrlQ0E7ZVj6WNYAaxSw4BCOVzX25LeLj86qbB0BOnX8p
         aGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680592652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aoNmBxTLg4bYP1LzWqAv4g+6PvsLW4SUU9joYqsr0+E=;
        b=sQ3y8DxhrbPMWivzVrWkfqAPHWduSQR+ashZ71I5l9jHEL7Hjvx82r45QnQls0tr2e
         cYvlLvS5NTFCptifXRFh4lnmKUggWYUGLMScPu4p6CAxB1HSwLDnyNJbaHZa/mUGPpci
         o7aOfefRBlxTGrIXbxhBxpDFStBnF11efJ4582gvRKjmqmt5oc67269qmrUAf0mJrD+d
         MVn1766YawSgu+dQqnzqAspawvhTsMo7W2VXm5eoLUshvAM0WgA2zJ6YY1FGYFyTYa70
         QKCuFPQUoCpJGuhJ1aj9SzMvevshOuUpwYikpgJyUEBwBYrVJjpWw0icNKzVVKWFRvEB
         oHaQ==
X-Gm-Message-State: AAQBX9dytkx4S/2DrCroQpVD542H28qbxi1ic6FcSbRcQMbG72lGUdg6
        cdUm5rrUb8DaSQmcDtWuLxU=
X-Google-Smtp-Source: AKy350bRh2Vl1mnEpBIpqLnJyt2P2UVwO5IlmA6g6W9a2DUHzZpM3dYtku/ox0FjeegmaSaUTs0QnQ==
X-Received: by 2002:a62:19c2:0:b0:62d:944e:b0b8 with SMTP id 185-20020a6219c2000000b0062d944eb0b8mr1250675pfz.32.1680592651766;
        Tue, 04 Apr 2023 00:17:31 -0700 (PDT)
Received: from ISCN5CG2520RPD.infineon.com (KD106168128197.ppp-bb.dion.ne.jp. [106.168.128.197])
        by smtp.gmail.com with ESMTPSA id v23-20020a62a517000000b00627f2f23624sm8004213pfm.159.2023.04.04.00.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 00:17:31 -0700 (PDT)
From:   tkuw584924@gmail.com
X-Google-Original-From: Takahiro.Kuwano@infineon.com
To:     linux-mtd@lists.infradead.org
Cc:     tudor.ambarus@linaro.org, pratyush@kernel.org, michael@walle.cc,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        d-gole@ti.com, tkuw584924@gmail.com, Bacem.Daassi@infineon.com,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] mtd: spi-nor: spansion: Enable JFFS2 write buffer for Infineon SEMPER flash
Date:   Tue,  4 Apr 2023 16:17:15 +0900
Message-Id: <20230404071715.27147-1-Takahiro.Kuwano@infineon.com>
X-Mailer: git-send-email 2.34.1
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
mode for ECC'd NOR flash. To activate it, MTD_BIT_WRITEABLE needs to be
unset in mtd->flags.

A new SNOR_F_ECC flag is introduced to determine if the part has on-die
ECC and if it has, MTD_BIT_WRITEABLE is unset.

In vendor specific driver, a common cypress_nor_ecc_init() helper is
added. This helper takes care for ECC related initialization for SEMPER
flash family by setting up params->writesize and SNOR_F_ECC.

Fixes: 6afcc84080c4 ("mtd: spi-nor: spansion: Add support for Infineon S25FS256T")
Fixes: b6b23833fc42 ("mtd: spi-nor: spansion: Add s25hl-t/s25hs-t IDs and fixups")
Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress Semper flash")
Suggested-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Cc: stable@vger.kernel.org
---
 drivers/mtd/spi-nor/core.c     |  3 +++
 drivers/mtd/spi-nor/core.h     |  1 +
 drivers/mtd/spi-nor/debugfs.c  |  1 +
 drivers/mtd/spi-nor/spansion.c | 28 +++++++++++++++-------------
 4 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index c67369815fde..46592e04d5ef 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -3406,6 +3406,9 @@ static void spi_nor_set_mtd_info(struct spi_nor *nor)
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
index 352c40dd3864..ffeede78700d 100644
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
@@ -373,13 +384,7 @@ static void s25fs256t_post_sfdp_fixup(struct spi_nor *nor)
 
 static void s25fs256t_late_init(struct spi_nor *nor)
 {
-	/*
-	 * Programming is supported only in 16-byte ECC data unit granularity.
-	 * Byte-programming, bit-walking, or multiple program operations to the
-	 * same ECC data unit without an erase are not allowed. See chapter
-	 * 5.3.1 and 5.6 in the datasheet.
-	 */
-	nor->params->writesize = 16;
+	cypress_nor_ecc_init(nor);
 }
 
 static struct spi_nor_fixups s25fs256t_fixups = {
@@ -431,13 +436,10 @@ static void s25hx_t_post_sfdp_fixup(struct spi_nor *nor)
 
 static void s25hx_t_late_init(struct spi_nor *nor)
 {
-	struct spi_nor_flash_parameter *params = nor->params;
-
 	/* Fast Read 4B requires mode cycles */
-	params->reads[SNOR_CMD_READ_FAST].num_mode_clocks = 8;
+	nor->params->reads[SNOR_CMD_READ_FAST].num_mode_clocks = 8;
 
-	/* The writesize should be ECC data unit size */
-	params->writesize = 16;
+	cypress_nor_ecc_init(nor);
 }
 
 static struct spi_nor_fixups s25hx_t_fixups = {
@@ -506,7 +508,7 @@ static int s28hx_t_post_bfpt_fixup(struct spi_nor *nor,
 static void s28hx_t_late_init(struct spi_nor *nor)
 {
 	nor->params->octal_dtr_enable = cypress_nor_octal_dtr_enable;
-	nor->params->writesize = 16;
+	cypress_nor_ecc_init(nor);
 }
 
 static const struct spi_nor_fixups s28hx_t_fixups = {
-- 
2.34.1

