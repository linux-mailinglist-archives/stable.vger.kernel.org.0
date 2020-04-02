Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4042819C9DF
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389534AbgDBTSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:20 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53061 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgDBTSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:20 -0400
Received: by mail-wm1-f67.google.com with SMTP id t8so4638762wmi.2
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=p8LWrxA6zH1zzzzc2lI1WXxhrFnCRfVsxR9GFJcBEoQ=;
        b=IIvPkukTEc3jLE2M665tHwS8eEun3KS6wb0h4ujExf7JbCft0Nq58x17bDCZTqx063
         fLoWXkd9X5alfWftz6dc+KkKS0zL1UnADnTy6/SQxRc3245eudBOEELaviDdl3e4TXHj
         fswshTdrmk70MVBcyQZPDa7ZE/E2ED1vzdHK2P3dRgh/LRoEShCH93jYkVyMj234WbOp
         fxK+mz6pUa5Q2XJ0O7ThJL0tUVRsswPCKvvcnroFgADl9cULtXT/bYN2KaaoYOQBnVW4
         yv9YWdp5FutrboThfnziiJ8KeGoSvNKS8+M+Qmjju9N2s1fVImXiUhW55vPhYARMYBye
         zr0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p8LWrxA6zH1zzzzc2lI1WXxhrFnCRfVsxR9GFJcBEoQ=;
        b=ufHIHu8BTcNx32Bb0ecBjqRXFxu8FPNPx/7W7EWupsg9zrEBO44z1OtpC98pSpBap2
         seL9Pye0dS40CAJf2JD1BaS55qSWnlCsWf2e1olzl2Xbrkh256P1iokqX2mP3LRGkqYT
         L+z70SkER1iX/jPTMrfIcRwLRNAY6exE2Z//4Z7OOYqrneL4Oou8qR5qYzvKvEn1dHtY
         T0m7d06ToNvVX6qOuo6EjcUC2vZY0GBbutvpHXlTS9QADE7VRyiSN0l4/82nbofABg9g
         EhNdK48cpuDzQkgAEl40MlkZT5VTZPQ224ItyOyhO7p0xVHP5S28d/iWlAW4XL0IAWfU
         XwNg==
X-Gm-Message-State: AGi0PuY98F1f9BhIDAcd/znLhQFCsdTtP6sWu7Rrt4ibIa9hb1oNLD72
        33tPtWLcRUZpXOIk76C67eClGSmJMDn5+A==
X-Google-Smtp-Source: APiQypJ306NZuKr1v19/Imq9wChzekrbMbdBBhmF6AKjyaPgStfwHQu5mfMmj4bSx/npm2EUH2ryHQ==
X-Received: by 2002:a05:600c:da:: with SMTP id u26mr5163469wmm.117.1585855098017;
        Thu, 02 Apr 2020 12:18:18 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:17 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 16/20] soc: qcom: smem: Use le32_to_cpu for comparison
Date:   Thu,  2 Apr 2020 20:18:52 +0100
Message-Id: <20200402191856.789622-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
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
index 19019aa092e86..a1572075b8acc 100644
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

