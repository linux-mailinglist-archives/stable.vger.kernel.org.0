Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0206D8F40
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 08:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbjDFGSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 02:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234783AbjDFGSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 02:18:13 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8910A8A60
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 23:18:10 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso41973447pjb.0
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 23:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680761890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zCEA1jaG6kIaIVjEfEFyy0ijLEpt43ZoFGLdbbk9ziM=;
        b=jkzquUiUYpzf1iUmoyDTbcxE37xDnI0gu5WXkP5hKCAGxi6OEyVXtFP4ruVsAp9e63
         al8bAnP0sT/SFIiTmODzsj9CeEBBEIrkOKRg8bPcof7XdwKRQaevu3Dy7Kd9cy4biLxE
         oyMrIzPmI6MZcLYJNmFwCiD2tVzlPu9prgeKd25EqqBNxxicDBbkGGKWjEZYHMJ8bczH
         HPI7ch6Rn/5rxG7FNRv5F3w0tRF+fh4Sk3SOFYjxSpA8p3Hnl2OkMFv7T8PJxrDQRElV
         Zzi1j2NQ6WpreAo0NqBywSadjeD15xW1ucjLQu7AzgwLnVXz+vkjKjVxH/FNE7/wKGBm
         Tjeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680761890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zCEA1jaG6kIaIVjEfEFyy0ijLEpt43ZoFGLdbbk9ziM=;
        b=psOveGvCjZx39+fqXtU5h54who9gw+/PyoZjoKopsTPx8Qol2Ex3DLH+xDmFl1mWdX
         T0Ew/qso3dclAz2DXwHlHzkWJfc4/djnxeEJi2ahYIHEBthMD0VS3fttmAjWZvW4XV01
         TrQbBlyy+CWt0bjM0Co4AnoNTh8yiiqJg6xLG5bm89yUVcO9fA5EIhyfEkBfG1FwGF2Q
         biHfZEHyiW7wCY7IjoC+N32m67pmugnhFwPo9HNB4PZ601oDXXmHtD3e3toB4+/EqtfC
         lFlNVCOhTyMt3dNLPDdBKn1LlZhaAXsvvYDqkwrnVWEZupT/rHtbVs8afEM8GOITdwbH
         Up8Q==
X-Gm-Message-State: AAQBX9eTc0nxGdaOlLzVaJ1KrmmNJrhwrXuOwRbNFHJTKE7cYA8mwMQt
        BpTDMA2Xy8tebXCP38Y2r9A=
X-Google-Smtp-Source: AKy350bmXKziSxPzbErymEv4CZ5tvv9TAV0tAlcHDIqTHmYRoV34GnZYqfQSK1Jp0Azb3vBtkXAp3A==
X-Received: by 2002:a17:902:ea07:b0:19c:3d78:6a54 with SMTP id s7-20020a170902ea0700b0019c3d786a54mr5539527plg.14.1680761889951;
        Wed, 05 Apr 2023 23:18:09 -0700 (PDT)
Received: from ISCN5CG2520RPD.infineon.com (sp49-98-38-119.msd.spmode.ne.jp. [49.98.38.119])
        by smtp.gmail.com with ESMTPSA id y11-20020a1709027c8b00b0019c919bccf8sm567622pll.86.2023.04.05.23.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 23:18:09 -0700 (PDT)
From:   tkuw584924@gmail.com
X-Google-Original-From: Takahiro.Kuwano@infineon.com
To:     linux-mtd@lists.infradead.org
Cc:     tudor.ambarus@linaro.org, pratyush@kernel.org, michael@walle.cc,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        d-gole@ti.com, tkuw584924@gmail.com, Bacem.Daassi@infineon.com,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        stable@vger.kernel.org
Subject: [PATCH v3 2/3] mtd: spi-nor: spansion: Enable JFFS2 write buffer for Infineon s25hx SEMPER flash
Date:   Thu,  6 Apr 2023 15:17:45 +0900
Message-Id: <a1cc128e094db4ec141f85bd380127598dfef17e.1680760742.git.Takahiro.Kuwano@infineon.com>
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

Fixes: b6b23833fc42 ("mtd: spi-nor: spansion: Add s25hl-t/s25hs-t IDs and fixups")
Suggested-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Cc: stable@vger.kernel.org
---
 drivers/mtd/spi-nor/spansion.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index 19b1436f36ea..4d0cc10e3d85 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -442,13 +442,10 @@ static void s25hx_t_post_sfdp_fixup(struct spi_nor *nor)
 
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
-- 
2.34.1

