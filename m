Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033C3655FA5
	for <lists+stable@lfdr.de>; Mon, 26 Dec 2022 05:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiLZECg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Dec 2022 23:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiLZECe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Dec 2022 23:02:34 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6802622
        for <stable@vger.kernel.org>; Sun, 25 Dec 2022 20:02:34 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id gt4so9759817pjb.1
        for <stable@vger.kernel.org>; Sun, 25 Dec 2022 20:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9CRiHDRLRGEN7XfGYfeHrEmJadcM+PUxYmrk5OdFTIg=;
        b=GV+gUxhRYl8TobTj0hbeYxhmgjN28h2u5d1sBet2++6Ocy+12PUvNfWmSYDku6iO/W
         0mCSKn31KTVQTv/wPqjxjTdLdRUYGLW+b3f/+KN8SN6All4iSsUb7yov6TOLDEapmkcg
         661zaoCsStoEUeSjDUAqLHj5kvACPawVL3Or72jaaf9GLVTMl1tKOZEZhAM6QeczcIOs
         PLK1CkVdRkmw3sBpLcl2sj+cdXawpxRLEV2Dxm//nZiMB56sZWhIUpmabhq1lmXp4SIL
         6DvVTz9GE6Dwt0BVloW4rLtGtJmvHf4LfrgUsXdVgNDFgs97R9nP1BwO9ih2uviUAY8O
         zUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9CRiHDRLRGEN7XfGYfeHrEmJadcM+PUxYmrk5OdFTIg=;
        b=NdScZ1o/fgsYiplqYLPYTBIhZrE7LF0ZrP9vEo454T1WaZdxo2gPVlhJARSxyx8mUg
         l5ahQBpLJvkVAIWUEJoRemvIQzXbjn1uTa4cTbAgLN5uF2xtMZojwGm2C3SPGUv1k98y
         T4I2a0avo2uKnooVBQukSleS4+x6rE7R4dlTR48rVs6mgybo5/n3Eat4CnmyTOcauosx
         osIVU2kUUPkrEWyHxiLpW6lZ/qmAsj4/CKGdSi3nB8lljahCaVHOudxpGyQRoQo78HT/
         S5SXigvj9gr47hDDTdCjj/3sfDSsx04vOceoziILr8VwbrYPCf+KS5h23vcUev1QID7b
         8+2Q==
X-Gm-Message-State: AFqh2kq90yd49gyWeM7mnVhJWkNB+XJMTbyLJxxhxknd90J3pPLWuN8p
        qVAyHL42O9MsTBrh1oMI0qA=
X-Google-Smtp-Source: AMrXdXtxseLj/6+2v5WtmXAwPBKPzASL/83NUOZEdxE3I89RWZzhHvRog7seEzwnqnpYrUzXOv+HFA==
X-Received: by 2002:a17:902:ab4d:b0:189:d0e1:4fcd with SMTP id ij13-20020a170902ab4d00b00189d0e14fcdmr21011332plb.55.1672027353630;
        Sun, 25 Dec 2022 20:02:33 -0800 (PST)
Received: from ISCNPF1JZGWX.infineon.com (KD106168128197.ppp-bb.dion.ne.jp. [106.168.128.197])
        by smtp.gmail.com with ESMTPSA id u2-20020a1709026e0200b001708c4ebbaesm2641401plk.309.2022.12.25.20.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Dec 2022 20:02:33 -0800 (PST)
From:   tkuw584924@gmail.com
X-Google-Original-From: Takahiro.Kuwano@infineon.com
To:     linux-mtd@lists.infradead.org
Cc:     tudor.ambarus@linaro.org, pratyush@kernel.org, michael@walle.cc,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        tkuw584924@gmail.com, Bacem.Daassi@infineon.com,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/3] mtd: spi-nor: sfdp: Fix index value for SCCR dwords
Date:   Mon, 26 Dec 2022 13:01:58 +0900
Message-Id: <d8a2a77c2c95cf776e7dcae6392d29fdcf5d6307.1672026365.git.Takahiro.Kuwano@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1672026365.git.Takahiro.Kuwano@infineon.com>
References: <cover.1672026365.git.Takahiro.Kuwano@infineon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>

Array index for SCCR 22th DOWRD should be 21.

Fixes: 981a8d60e01f ("mtd: spi-nor: Parse SFDP SCCR Map")
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Reviewed-by: Michael Walle <michael@walle.cc>
Cc: stable@vger.kernel.org
---
 drivers/mtd/spi-nor/sfdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index 8434f654eca1..5df2fcba5483 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -1228,7 +1228,7 @@ static int spi_nor_parse_sccr(struct spi_nor *nor,
 
 	le32_to_cpu_array(dwords, sccr_header->length);
 
-	if (FIELD_GET(SCCR_DWORD22_OCTAL_DTR_EN_VOLATILE, dwords[22]))
+	if (FIELD_GET(SCCR_DWORD22_OCTAL_DTR_EN_VOLATILE, dwords[21]))
 		nor->flags |= SNOR_F_IO_MODE_EN_VOLATILE;
 
 out:
-- 
2.25.1

