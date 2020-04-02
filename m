Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B325619C9C2
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389021AbgDBTRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:15 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35748 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388921AbgDBTRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:15 -0400
Received: by mail-wr1-f65.google.com with SMTP id g3so3306573wrx.2
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Da4R2mObgWasMS/Jsu1LIg5EJg09QgEbjMnbzzaCLcM=;
        b=DOS6Qwk17hcD7EQ+w/EO9hrgV/XWLxakPTBuC4MHQVerRGqXoZORyR1+q44sbsJWUs
         tX4Ouo0aEiBzeK7qQMNy7zgGfQSiRUkj7FLcppWIluACxwKkf9R3bCEGaPEly82lVCko
         kMBP5P6fHXkO1plvmkYrCdkuimmMYitqNw8HOa+hhZkdJgmsPSlG9EtJQGhhKAxzPM9B
         2QPtiXqNbhDy16QjGTXSSGxcoVu8R9mFCXLk78Uj3AxkpemoQ5pgO1DrI5d0OQXo9CUd
         KRS/6gftDT7GRj7HTIbNCPBp4bxqVWaukXLrEEana0lHiLIgESQlMpFuID0+HKjwUtO2
         TCCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Da4R2mObgWasMS/Jsu1LIg5EJg09QgEbjMnbzzaCLcM=;
        b=pFOuj+ulABd3IqKcZspJ5WQ9tzke3VIg4KRMcph8NEVb+z7XC3yQK2Ky4hiF/uv9Gc
         RAV5/dReydp5a/D5jy+IeIrqPNgiy538breSgXBloqAiMd3/4TsEUvKt3h1jYM2xhcP0
         TbuRwc0+HNgvS4bxaNRSEuRhBERLaeu9PGPf6SveZeE4f0B8+ugJb7TciAzg71hin19/
         1GAy3OxUpDObf1FkYUR4MWy/TzZFwHGPWing38DHwtifC0I6b4OxbqjVxeaoL2xMCOxK
         5Lza/z2R5bfqjV8et5rB3D8TKxL6LEbzLvqDedYkPsK4v0Tn9gU4aDld2pK7K/72Aefj
         CSnA==
X-Gm-Message-State: AGi0PuYSS5YHx9uVYtAc4h1JayyohxhpXADMfrkDp6Wwma4PF7WXg4K8
        KWy9WiQv9bJCmDJL4uH0P4+cB+MwjrGUaQ==
X-Google-Smtp-Source: APiQypLMXNjzBALWtFyuyUSWuMLbYE0SS373kQv+vPtscmOVbkKkzTiJzcc0a25t8LKTM/9ng5np9Q==
X-Received: by 2002:adf:e611:: with SMTP id p17mr4891680wrm.212.1585855033152;
        Thu, 02 Apr 2020 12:17:13 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:12 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 19/24] soc: qcom: smem: Use le32_to_cpu for comparison
Date:   Thu,  2 Apr 2020 20:17:42 +0100
Message-Id: <20200402191747.789097-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Lew <clew@codeaurora.org>

[ Upstream commit a216000f0140f415cec96129f777b5234c9d142f ]

Endianness can vary in the system, add le32_to_cpu when comparing
partition sizes from smem.

Signed-off-by: Chris Lew <clew@codeaurora.org>
Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/soc/qcom/smem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index 18ec52f2078aa..89dd50fa404f7 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -646,7 +646,7 @@ static int qcom_smem_enumerate_partitions(struct qcom_smem *smem,
 			return -EINVAL;
 		}
 
-		if (header->size != entry->size) {
+		if (le32_to_cpu(header->size) != le32_to_cpu(entry->size)) {
 			dev_err(smem->dev,
 				"Partition %d has invalid size\n", i);
 			return -EINVAL;
-- 
2.25.1

