Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0A837BC8D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhELMbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbhELMbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:31:49 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03CCC061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:30:40 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id q16-20020ac845100000b02901e11cd2e82fso84945qtn.12
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fIeJNs727FXDn6NfdD1M/slmzXXr0AQcOId6n+2knyc=;
        b=Ick28MZgRWNL680LpPhQW1qUcpSA2+bCCGVgYm8yrETlX4mWRYSlXG6CJwqUmtyHXY
         fX06ixspMuI1Ztz3smhJQE7jFCR5Z7D53EmUGYGNxWZYVicrPe3/yPgRj5pLQz7SP1hm
         uWT1W9K1ywtluu+mnDR+bIZqwuiE8+v1F7pEIbqwjzsukbBJX3hWsPBz3LD327ZuWD3S
         BQebeIBE7+XX50t+rDXO7ziHXIMBP6bx5JMpx2ZgVx62GrwvAGklf8ODzSRieIPmFPB/
         uYeTYzeDuEYTdNXASHo7KREOIJYpZRH8zLEchsCUz54UcOuqnabTpOiuEgfzCTgSn7HY
         xuhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fIeJNs727FXDn6NfdD1M/slmzXXr0AQcOId6n+2knyc=;
        b=EgeJaOA6i5LQvzT7e229EzJDKR6f4rCqRlLSyBSZUiAUvfkVmA2IKBIqEUNLrMA3cR
         S5vDSaMedjUXJiuxecful5awNEG5vuj5DgFwL/vRnLYtL86mSpy+UXHHTCLXy9VEhyRj
         gWOHEnFJbIrkCSmpK0WLldzkmQS/FDf5w+6ZNL+ZmJyHOdeBGU2LQZMgoFHa7Vlrmkw1
         9kgrgeioD9PqyRTuNfdDSwlxINIGZe56kL1ZrG7tknJ5oImbhXig9qe3pDt98OJPXJqq
         +NZbFXRkKSlkpKNBccv6rgClV67UEzXnX1LRjAM6xaMXoQw/VWAz4r9wcSq/rjS8fh38
         hEJw==
X-Gm-Message-State: AOAM532thN7p1d+kC/ni2T/TeSwfymMnsgbRFMjC9MLqNGjeE3bEHDV2
        K+Ff3vtlYLpXOEZQ+Rl/tIitjexeTdJ6nDXl2BOscxqU9f/+thWt066vK6xPkSwz6wPU8fnG0Vy
        q27NNCJd9qJcVLoakEg+IgEPK4dR4+tkvMCNTaEoWnEX2+WdxKV4k6z/QVE0MQDNJ
X-Google-Smtp-Source: ABdhPJwNP+nA6GFvraFDaZoJfxgP0tMNR6gmvLllW/rhoYrjvCP5vNtZHgsUpg3Ed8YHv1wG0c+z+DXz6W4S
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:ad4:5846:: with SMTP id
 de6mr34509580qvb.40.1620822640006; Wed, 12 May 2021 05:30:40 -0700 (PDT)
Date:   Wed, 12 May 2021 12:30:37 +0000
In-Reply-To: <20210512122853.3243417-1-qperret@google.com>
Message-Id: <20210512123038.3287684-1-qperret@google.com>
Mime-Version: 1.0
References: <20210512122853.3243417-1-qperret@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH stable 4.9 1/2] Revert "of/fdt: Make sure no-map does not
 remove already reserved regions"
From:   Quentin Perret <qperret@google.com>
To:     stable@vger.kernel.org
Cc:     alexandre.torgue@foss.st.com, robh+dt@kernel.org,
        f.fainelli@gmail.com, ardb@kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 666ae7c255f9eb7a8fd8e55641542f3624a78b43.
It is not really a fix, and the backport misses dependencies, which
breaks existing platforms.

Reported-by: Alexandre TORGUE <alexandre.torgue@foss.st.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 drivers/of/fdt.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 9054b8f218a7..f90b626269ab 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1158,16 +1158,8 @@ void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
 int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
 					phys_addr_t size, bool nomap)
 {
-	if (nomap) {
-		/*
-		 * If the memory is already reserved (by another region), we
-		 * should not allow it to be marked nomap.
-		 */
-		if (memblock_is_region_reserved(base, size))
-			return -EBUSY;
-
+	if (nomap)
 		return memblock_mark_nomap(base, size);
-	}
 	return memblock_reserve(base, size);
 }
 
-- 
2.31.1.607.g51e8a6a459-goog

