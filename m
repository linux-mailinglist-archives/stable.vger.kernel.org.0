Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5821A5BACC2
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 13:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiIPLvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 07:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiIPLvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 07:51:22 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7D5AE209;
        Fri, 16 Sep 2022 04:51:21 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d2so75488wrq.2;
        Fri, 16 Sep 2022 04:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=QdifIquyoQ6mYOMD2HCI+tIRc44pzp+O1wcBGNhRN9Q=;
        b=GksRQCrwG3e+fxeVfNlj+wciQ1+OOo8qW5WHJWfCc8uPEg5L8lhTij9DYONG3hba/B
         UTcfAktsX4H3Wd4YoZyxYBlsHq7bfNSx6n+RNZktyJmQWcfnY1vjgrsonTJNLGN/SSXg
         odAKobaucCqSF2GLDjrB/iybd2NXOwTFcciZDc7KYilPuFG6JhArHivALhZUM+f1Gv8O
         rb45j9Fr5BRz8tDfKqP41BFV56WQIAb5iaNdO8Gklbc0svpkvfgJOACQPI06y/TUf8nS
         qHk3ULmBBanN9kbJB4ftW+gK6ou5ipZrfLdwJRXbtTJM0+cx4/S+DSvrqmek49kokXq/
         F87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=QdifIquyoQ6mYOMD2HCI+tIRc44pzp+O1wcBGNhRN9Q=;
        b=5jw4dMzpjd8CCv9UbGnqkA/0yFwAakGJpl56sOHSk+EV15Sw1sajg6rxCanPILzTer
         9nVqiK6Fcu+vYrVW3WBX6hf2pD+crKl2E5EBHmUg4pH2OXfkoH2db8PjRoSjhuSSmusM
         Pbs+iy0fX5/52zwTdcgbAi1JmiQRM261zGuyfTL7KBhK9+3SfzNr+rbZ0jHqRHvr4b9k
         k8ovOzyyg1/0+PaHDxSu8q2UUGcxZcKBRqnbwYn69qsD8blNcn2bngopa8aRfMp7T70O
         CDcX+nyzhjSuFD7OOUQzG1CkymtQsd3sk1B7KpF32ZCOZi5U66Uxktuy/02SNlfG5ya5
         BO3w==
X-Gm-Message-State: ACrzQf3lCjf092Ud++ko7IbTc+oKruBS7toxbCTDYQwIiRNf2jXZVi5E
        ByfWN0c9tAranEatzT3jv4EBgRgJGwk=
X-Google-Smtp-Source: AMsMyM6wHJ4A/f5KmGKYlgkzApjWskcP+QMNLhnCEMZu7n8HbmgW0O7i2+UqlNawipmDyuf2rf5vAA==
X-Received: by 2002:a5d:52d0:0:b0:21e:4923:fa09 with SMTP id r16-20020a5d52d0000000b0021e4923fa09mr2711712wrv.244.1663329079714;
        Fri, 16 Sep 2022 04:51:19 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.googlemail.com with ESMTPSA id d17-20020adffbd1000000b0022ac1be009esm4791245wrs.16.2022.09.16.04.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 04:51:19 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Vinod Koul <vkoul@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>,
        Thomas Pedersen <twp@codeaurora.org>,
        Jonathan McDowell <noodles@earth.li>,
        linux-arm-msm@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christian Marangi <ansuelsmth@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] dmaengine: qcom-adm: fix wrong calling convention for prep_slave_sg
Date:   Fri, 16 Sep 2022 06:12:56 +0200
Message-Id: <20220916041256.7104-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The calling convention for pre_slave_sg is to return NULL on error and
provide an error log to the system. Qcom-adm instead provide error
pointer when an error occur. This indirectly cause kernel panic for
example for the nandc driver that checks only if the pointer returned by
device_prep_slave_sg is not NULL. Returning an error pointer makes nandc
think the device_prep_slave_sg function correctly completed and makes
the kernel panics later in the code.

While nandc is the one that makes the kernel crash, it was pointed out
that the real problem is qcom-adm not following calling convention for
that function.

To fix this, drop returning error pointer and return NULL with an error
log.

Fixes: 03de6b273805 ("dmaengine: qcom-adm: stop abusing slave_id config")
Fixes: 5c9f8c2dbdbe ("dmaengine: qcom: Add ADM driver")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v5.11+
---
 drivers/dma/qcom/qcom_adm.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/qcom/qcom_adm.c b/drivers/dma/qcom/qcom_adm.c
index facdacf8aede..cd3f12cf4721 100644
--- a/drivers/dma/qcom/qcom_adm.c
+++ b/drivers/dma/qcom/qcom_adm.c
@@ -379,13 +379,13 @@ static struct dma_async_tx_descriptor *adm_prep_slave_sg(struct dma_chan *chan,
 		if (blk_size < 0) {
 			dev_err(adev->dev, "invalid burst value: %d\n",
 				burst);
-			return ERR_PTR(-EINVAL);
+			return NULL;
 		}
 
 		crci = achan->crci & 0xf;
 		if (!crci || achan->crci > 0x1f) {
 			dev_err(adev->dev, "invalid crci value\n");
-			return ERR_PTR(-EINVAL);
+			return NULL;
 		}
 	}
 
@@ -403,8 +403,10 @@ static struct dma_async_tx_descriptor *adm_prep_slave_sg(struct dma_chan *chan,
 	}
 
 	async_desc = kzalloc(sizeof(*async_desc), GFP_NOWAIT);
-	if (!async_desc)
-		return ERR_PTR(-ENOMEM);
+	if (!async_desc) {
+		dev_err(adev->dev, "not enough memory for async_desc struct\n");
+		return NULL;
+	}
 
 	async_desc->mux = achan->mux ? ADM_CRCI_CTL_MUX_SEL : 0;
 	async_desc->crci = crci;
@@ -414,8 +416,10 @@ static struct dma_async_tx_descriptor *adm_prep_slave_sg(struct dma_chan *chan,
 				sizeof(*cple) + 2 * ADM_DESC_ALIGN;
 
 	async_desc->cpl = kzalloc(async_desc->dma_len, GFP_NOWAIT);
-	if (!async_desc->cpl)
+	if (!async_desc->cpl) {
+		dev_err(adev->dev, "not enough memory for cpl struct\n");
 		goto free;
+	}
 
 	async_desc->adev = adev;
 
@@ -437,8 +441,10 @@ static struct dma_async_tx_descriptor *adm_prep_slave_sg(struct dma_chan *chan,
 	async_desc->dma_addr = dma_map_single(adev->dev, async_desc->cpl,
 					      async_desc->dma_len,
 					      DMA_TO_DEVICE);
-	if (dma_mapping_error(adev->dev, async_desc->dma_addr))
+	if (dma_mapping_error(adev->dev, async_desc->dma_addr)) {
+		dev_err(adev->dev, "dma mapping error for cpl\n");
 		goto free;
+	}
 
 	cple_addr = async_desc->dma_addr + ((void *)cple - async_desc->cpl);
 
@@ -454,7 +460,7 @@ static struct dma_async_tx_descriptor *adm_prep_slave_sg(struct dma_chan *chan,
 
 free:
 	kfree(async_desc);
-	return ERR_PTR(-ENOMEM);
+	return NULL;
 }
 
 /**
-- 
2.37.2

