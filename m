Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E8C5BA36C
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 02:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiIPAK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 20:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiIPAKz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 20:10:55 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F73B57573;
        Thu, 15 Sep 2022 17:10:54 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id z6so902902wrq.1;
        Thu, 15 Sep 2022 17:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=3woIDE7yBUh/b9Nv8vLk6hJiU8oDnZbYkk/eVuZfaH8=;
        b=JC4H5My6AlEVhR7CTGxSOndCE1Qp6gSYfTQ+dq+sPchd1dbbxSEVyUzL31fRXjif8T
         UyQzXQ9K8ZAeDdt69Wv8IOxAGmhYP1otJGia1U8kmzIF4oYoZnRdg3TaoHRq9b7YjOd8
         vGfWyLMJlLpW0N0voALnKn3eiCM+hHiSuAPAbPIZn9BT8v6lneYM5Ilz8/YZ9+TZGNid
         NrgGez7AzkLA9QCSCrJ+IHYaryGG+heW2DKiKAA8xMO265rSggdZTbCaeMi58MQwxbez
         /Q7SGrdiKLUEE9De5rjk3a8ejyRNDno6RJ6p7+7Z6P/lMaw03Mj1MszhEEnJ6c9k9u1L
         S/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=3woIDE7yBUh/b9Nv8vLk6hJiU8oDnZbYkk/eVuZfaH8=;
        b=eBimeDHndB87oK/Itt5ooJvErBvTP2r8auIJOIGAKOJimKNOK7PjluCmm9eRC7x5Kz
         cSQRxZkCQzspP3Cp5TPwIlxWPO/DNGZxismqtL8f5QcHORf9TdvqzODWVqSKxtc3bDRM
         EE+/uNqlboLEGfFHRK31vpBFOLEhz6YebKqYg5SnI0X51wppah44vEzBfdwHPGT+ZBqo
         EBUAueFbSgBD0tDBt+J1EcGIlQ0eC0zAhILOpSj0K9rZrehgxdFqp2r8DBLnjRozOJ7T
         A/OPqTlcDzlWQLj7BtESkeKn05c5LYyp254POpA5ATA9ROYZRYKvVDgiA0zgPayzTmF1
         rYOQ==
X-Gm-Message-State: ACrzQf0TD3z/w9JhRag6JoQQ8O5bFJn88hwRhAjEZR/etz6qkxZYu3k6
        404FQKJ4df8428Du+WCByPQ=
X-Google-Smtp-Source: AMsMyM5byb8GS5ejazAxASqEwMhbEIC+bYI91ag1jKB+w4/P/le0oFvlmLB78VPGSK1zU9BtcPyJ+A==
X-Received: by 2002:a5d:608d:0:b0:228:d095:4a15 with SMTP id w13-20020a5d608d000000b00228d0954a15mr1235995wrt.499.1663287052713;
        Thu, 15 Sep 2022 17:10:52 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.googlemail.com with ESMTPSA id c9-20020adffb49000000b00228dbf15072sm3780686wrs.62.2022.09.15.17.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 17:10:51 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Manivannan Sadhasivam <mani@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Vinod Koul <vkoul@kernel.org>,
        Mark Brown <broonie@kernel.org>, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christian Marangi <ansuelsmth@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] mtd: nand: raw: qcom_nandc: handle error pointer from adm prep_slave_sg
Date:   Fri, 16 Sep 2022 02:10:38 +0200
Message-Id: <20220916001038.11147-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ADM dma engine has changed to also provide error pointer instaed of
plain NULL pointer on invalid configuration of prep_slave_sg function.
Currently this is not handled and an error pointer is detected as a
valid dma_desc. This cause kernel panic as the driver doesn't fail
with an invalid dma engine configuration.

Correctly handle this case by checking if dma_desc is NULL or IS_ERR.

Fixes: 03de6b273805 ("dmaengine: qcom-adm: stop abusing slave_id config")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v5.17+
---
 drivers/mtd/nand/raw/qcom_nandc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
index 8f80019a9f01..d7eac196dde0 100644
--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -1054,7 +1054,7 @@ static int prep_adm_dma_desc(struct qcom_nand_controller *nandc, bool read,
 	}
 
 	dma_desc = dmaengine_prep_slave_sg(nandc->chan, sgl, 1, dir_eng, 0);
-	if (!dma_desc) {
+	if (IS_ERR_OR_NULL(dma_desc)) {
 		dev_err(nandc->dev, "failed to prepare desc\n");
 		ret = -EINVAL;
 		goto err;
-- 
2.37.2

