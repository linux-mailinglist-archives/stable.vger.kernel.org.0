Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460452099FC
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 08:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390154AbgFYGqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 02:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390110AbgFYGqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 02:46:32 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BD5C0613ED
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:32 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o8so4416756wmh.4
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o2mKsGbb/PtyAVg9ggk1Hz11lyz25s2kgotXpuPO+cU=;
        b=va0D27LtDcF26UdSeyL0kkvFbOHBO1SeIpvY5r8WAMDpK/CuCoK6gWg7iSvitAeRaA
         ryg7SmradwXnqeEyywbJGFve2MOz/IujZphJ+CKI08KZftt8JvUgjx3ALYfqDAdSExgd
         HFdT4fk2Ys9jpWVzhGrmy6a9OlzwxMTl/hUthhMkgSFKi1SIOa6GcBG9oyZcebXLBZip
         m41Z5wANw8Seya5ZA7FXHiz7X8tSKqWX8afSxQcytVP36TcVt6gAXVYiuDMDmDzfss/o
         IYL49zByXMBr9NcuNAqRE9msPHvNrfyCmu1lgqgRm+/WycTKKMpJ0a+kxAcG5smLTvte
         pT5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o2mKsGbb/PtyAVg9ggk1Hz11lyz25s2kgotXpuPO+cU=;
        b=L2ylShsk629NnX3dTmg+6BGl+Mi0nrn6jmb09q9OLm940/lYX1Gp8L37DYJHSXZ7fV
         KUzYQ9jMsLQAL0b6Qvk0Ph1gFijm15zZ3ZsvXZyT36Y7ZtgpWYMhDZmvRHPMJGm3Thl4
         KWhhhqFZxPhWBKB0eb12TXd3yNnYSCoo1Z/V3y2EwSpLZPHv6nPxYmCHa23DMuui5TPb
         oaFZ7CTB231vROmRkvqpdCKgkotxFqoEBs9jxvHGvaiZf1wAfuXpRLrX79x8Rzj6tnrV
         f5QbdVzQiY1h/zzVAZ/CG5u+w9ukA71Mld6ZLL5zp6/HcYlztrt+aISIHT3me8uloS4i
         NXbg==
X-Gm-Message-State: AOAM530JZMrWS3L4OSbruZMOilj6twUMGKmNJXkQsVGV37yESeibPW7V
        H6cdYIuyFHV4KOEG9hp2XpNV/A==
X-Google-Smtp-Source: ABdhPJyhOlpqerGDG90ewZ1q/iBssKLA4GRwer9f7Kth+G9Ad0uiipRFOOtXx5GsQxexwKswpwtZRw==
X-Received: by 2002:a1c:2901:: with SMTP id p1mr1744242wmp.144.1593067590752;
        Wed, 24 Jun 2020 23:46:30 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id c20sm27235363wrb.65.2020.06.24.23.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 23:46:30 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 04/10] mfd: db8500-prcmu: Remove incorrect function header from .probe() function
Date:   Thu, 25 Jun 2020 07:46:13 +0100
Message-Id: <20200625064619.2775707-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625064619.2775707-1-lee.jones@linaro.org>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Not only is the current header incorrect, the isn't actually a
need to document the ubiquitous platform probe call.

Cc: <stable@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/db8500-prcmu.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 9b58b02967638..a9d9c1cdf546b 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -3006,10 +3006,6 @@ static int db8500_prcmu_register_ab8500(struct device *parent)
 	return mfd_add_devices(parent, 0, ab850x_cell, 1, NULL, 0, NULL);
 }
 
-/**
- * prcmu_fw_init - arch init call for the Linux PRCMU fw init logic
- *
- */
 static int db8500_prcmu_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-- 
2.25.1

