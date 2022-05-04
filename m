Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5BB519A2D
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 10:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345797AbiEDIqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 04:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346559AbiEDIqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 04:46:18 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531572497F
        for <stable@vger.kernel.org>; Wed,  4 May 2022 01:42:34 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so4584590pjb.5
        for <stable@vger.kernel.org>; Wed, 04 May 2022 01:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/QyOJeDyGXwl5Bx88Om0rnmuC010KKBwL9CHoibu90Q=;
        b=uQmSVCA8Vn70bAlZqlHFGY0zK534lFsRZFsxphiKQokzX6wENHJj/OYL9o0GjLO0Yc
         sb6+ibl3XZ+3vMa9Gobo4vBDFQ+WtJ+sdSxkXiXPNN5wiS58S3VMU4elDLKxt+640qF4
         sNPUtnUgiEx6OCsdPNuUKsFLuyK92WU9t6pATh3CMQjEkd0XNRTCkCDxyHqyEJX0PY/L
         KydhHkhJ+cAe8FvEiHF/xOAoWFCFLSBZ8S9vEOmN5vVHqvF3utRh/JnbwrA05sVGrlqe
         J7iizhbcxbXHEV+i+EuPW0Y+PasIeJrosFx5Xegz/rDPVe+Yjes+7IIHvpDk9c8bnDmS
         uLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/QyOJeDyGXwl5Bx88Om0rnmuC010KKBwL9CHoibu90Q=;
        b=kJAxz9pue0kpkdBD0hI4epSyquezfP7Z5TG5FwDfCdqTwf2QFxqgGqvNDTedN+wa0N
         XeSSpeRg2RPdhJc9hizF+bC4BDyPmdmfOdxmbiaZO9OExOMvUuY8XyOIwU3oHqo2UE5x
         Gr5s4BqZzi3T8bVEZFbbO3WX63x7p8hDaUnyEIlsEMTjqogNgudke/bZwKTLl++f8PKT
         4QeGXHIoWStGX9HTGpKSp7ZCOXokytMXwTnGtNGnT8eaUMDN4FgBZM5DUHl4iBwJnN1P
         pIHTv9NwccR1/Gfm+esoq6ktXRfVUc/JIkwLj7IAjBz8U7BQ3HFrA3jje7s3O02FdEOe
         JPmw==
X-Gm-Message-State: AOAM5314BKK1GBtHTQBU7ZobiQrx3GQxaDY5WNyUwb9qJwPoK3Apagb3
        R7aMDBf8iNvnsUIyJLIb77tj
X-Google-Smtp-Source: ABdhPJzcwDo09+fKhHOOT4C79s8tTVdWNKJliXnr+1Ym042vc7sn+bwtA5HPMVxbsF79Dio5E3A3PA==
X-Received: by 2002:a17:903:244e:b0:15e:b3f7:9509 with SMTP id l14-20020a170903244e00b0015eb3f79509mr8651373pls.42.1651653753809;
        Wed, 04 May 2022 01:42:33 -0700 (PDT)
Received: from localhost.localdomain ([27.111.75.248])
        by smtp.gmail.com with ESMTPSA id i10-20020a170902c94a00b0015e8d4eb278sm1386561pla.194.2022.05.04.01.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 01:42:33 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     avri.altman@wdc.com, alim.akhtar@samsung.com,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org, ahalaney@redhat.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v3 3/5] scsi: ufs: qcom: Add a readl() to make sure ref_clk gets enabled
Date:   Wed,  4 May 2022 14:12:10 +0530
Message-Id: <20220504084212.11605-4-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504084212.11605-1-manivannan.sadhasivam@linaro.org>
References: <20220504084212.11605-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In ufs_qcom_dev_ref_clk_ctrl(), it was noted that the ref_clk needs to be
stable for at least 1us. Even though there is wmb() to make sure the write
gets "completed", there is no guarantee that the write actually reached
the UFS device. There is a good chance that the write could be stored in
a Write Buffer (WB). In that case, even though the CPU waits for 1us, the
ref_clk might not be stable for that period.

So lets do a readl() to make sure that the previous write has reached the
UFS device before udelay().

Also, the wmb() after writel_relaxed is not really needed. Both writel and
readl are ordered on all architectures and the CPU won't speculate
instructions after readl() due to the in-built control dependency with
read value on weakly ordered architectures. So it can be safely removed.

Cc: stable@vger.kernel.org
Fixes: f06fcc7155dc ("scsi: ufs-qcom: add QUniPro hardware support and power optimizations")
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 6126e50b9af4..b718c38fccc9 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -687,8 +687,11 @@ static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
 
 		writel_relaxed(temp, host->dev_ref_clk_ctrl_mmio);
 
-		/* ensure that ref_clk is enabled/disabled before we return */
-		wmb();
+		/*
+		 * Make sure the write to ref_clk reaches the destination and
+		 * not stored in a Write Buffer (WB).
+		 */
+		readl(host->dev_ref_clk_ctrl_mmio);
 
 		/*
 		 * If we call hibern8 exit after this, we need to make sure that
-- 
2.25.1

