Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE736D8F41
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 08:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbjDFGSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 02:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbjDFGSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 02:18:16 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA1E8A54
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 23:18:15 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id o2so36636134plg.4
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 23:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680761895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0AF6XRLMpMrC/rHnX59D2IU8B/emr6VxjeWEikNdIws=;
        b=Gy/FDNbSmw9KNj77j3hvIfS76DoSyMTDwMgXW9CLYrVcIMQ9k15VS0Sef/0nuxPji/
         0bdSoEk/+Jn6GeCQxkq7Z7I3Rl/IChvzdR6gf9lqFkWkAhM6LEKl8crAKTKg5pHMmY7U
         2aeUjbhVkloKT1wlbvpuaikFWN1bDZ6ZV3+UVPjdexS1QkhXCHeK5BGHCo9iIPSnZdjJ
         FC4v7zUy3I752PihpTtOPmKd3D168JkKpm5UIwO9OhyTOlheNeUs+RYgapl26gIDhsDl
         NoDsheTwMMSunH0NjGlu5bva1Qn3YGJ8pxUOxHFNhlxijnl8q2FrpZ5QifKmcnMbF+cw
         +SKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680761895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0AF6XRLMpMrC/rHnX59D2IU8B/emr6VxjeWEikNdIws=;
        b=JukPfZD3qZjik2JL207D/RENO+mc5OI/mf1PdBZ9MxRalE5aq8vBypYGG4P3e+ciA1
         sAX3fbx4YU7jzsL20kveIw58gtv0qEAqzHHm73xGGJwGKTEjV9TTHbtXW/8uXClabbaE
         cIgGZtkLSvHJdmig4ayNx7wXXkLHOUIug8ZXWQd5uvpEP2/FmcyiAEmL5YlaWMMMFnNB
         V1cbCjFCxdl7oQTNXX1g26vM987uymmyPL4LxUcua3ZayOojk6LK9t0zO+fOzkIgyi3j
         Px8DimfnsDWQti3I6Ba5/bM1JpcBAWoAl+DyEBFpiC2yf6EIOKxGZyh8cuH2lcndQmsp
         1wXg==
X-Gm-Message-State: AAQBX9crKSsjQJFP7kc9eQRgp5yFpqWO/niaIwyocLeEY66lhqlj5Hln
        c8KMdzxLyOMlibk9/caVO0A=
X-Google-Smtp-Source: AKy350Y5+oSVHHHfQ/F37Z6yx9V0prP6cBK490VXkt7WHzDAdD2BKK+fw29oqRJO+Kj0I9DZjDZz9w==
X-Received: by 2002:a17:902:dac1:b0:19c:f80c:df90 with SMTP id q1-20020a170902dac100b0019cf80cdf90mr11715307plx.45.1680761895191;
        Wed, 05 Apr 2023 23:18:15 -0700 (PDT)
Received: from ISCN5CG2520RPD.infineon.com (sp49-98-38-119.msd.spmode.ne.jp. [49.98.38.119])
        by smtp.gmail.com with ESMTPSA id y11-20020a1709027c8b00b0019c919bccf8sm567622pll.86.2023.04.05.23.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 23:18:14 -0700 (PDT)
From:   tkuw584924@gmail.com
X-Google-Original-From: Takahiro.Kuwano@infineon.com
To:     linux-mtd@lists.infradead.org
Cc:     tudor.ambarus@linaro.org, pratyush@kernel.org, michael@walle.cc,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        d-gole@ti.com, tkuw584924@gmail.com, Bacem.Daassi@infineon.com,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        stable@vger.kernel.org
Subject: [PATCH v3 3/3] mtd: spi-nor: spansion: Enable JFFS2 write buffer for S25FS256T
Date:   Thu,  6 Apr 2023 15:17:46 +0900
Message-Id: <641bfb26c6e059915ae920117b7ec278df1a6f0a.1680760742.git.Takahiro.Kuwano@infineon.com>
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
flag in order to enable JFFS2 write buffer mode support. Drop the
comment as the same info is now specified in cypress_nor_ecc_init().

Fixes: 6afcc84080c4 ("mtd: spi-nor: spansion: Add support for Infineon S25FS256T")
Suggested-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Cc: stable@vger.kernel.org
---
 drivers/mtd/spi-nor/spansion.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index 4d0cc10e3d85..ffeede78700d 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -384,13 +384,7 @@ static void s25fs256t_post_sfdp_fixup(struct spi_nor *nor)
 
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
-- 
2.34.1

