Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AEA37BC8C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhELMbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbhELMbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:31:36 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFD0C061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:30:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d20-20020a25add40000b02904f8960b23e8so17695673ybe.6
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Tl67DNcLJJ6frA3U3ojWPpQjhGxw7aJXL7f8Jzt3JKY=;
        b=KrEdjKOqz42tvMyJqEYeN1yL7DniN93eM4kKxcw+UPHZaRPC1VX0ahuiKEh14x9o8N
         +IqLMxU8dio9F9roTFpT4fEnBKzod2xBfmZfMPVwCrzVFgxaJmB8kXQ9WDZawOPnAuXV
         wK08SgJNG9V/5Zy/73M4w5BudYjlsmv+GQGKxFDufv5IpGlHEkbxyQr2CoJT7Ykrno75
         KgakFsLbnHlEEZTQJFIhtdCSbdszU+RArWMIzHmXUVndX6S1PKc2oO3P5+c411httP1Y
         fbIzXcpk9mH52z1RUSCuwCSaoEc9xiASK/MRHQ9GCf869R6fl2otSp4eSivnDJYYMFl4
         ziIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Tl67DNcLJJ6frA3U3ojWPpQjhGxw7aJXL7f8Jzt3JKY=;
        b=t+johlSQ2O+0GsJKdYwIgA/uWBcF0LGBHNk8eRpB0Vs/a8XDL0nCHDtKiLI2mXhZHC
         kZ2tf4zuJzrhuCy7Eab8+wm+k7Ujd/nrWYHbQmavW+wgDYTDfAB/r+EV1+EM1POFQLKf
         X9oME9TyUsfXIeFuA91W6o3r4AP1hbe9XyYauNV2FCBzkPYMKMBb0dlu7JbdJ1LGRofN
         M3EpY+LNhxbKT3RUucxYLRkPJ0joZrdCtZDagTIF5TlNyS1QUiG9P2umqzAHIxJn2NJg
         UIpFNn6i2u6xOrcxstCTdGme74M3cr3jgGCsPitpkCRskqWdLbm8Bb6awjHx3bIB/ib9
         bPlA==
X-Gm-Message-State: AOAM5300ylM95IVFmBIzNvFz3Kb7UBJlfO5uM7oMpJecmnRheq6GJdQA
        XKjVv/bPQZp00M3YZL+KfQjWPSOzNTdkrd6ROyXenwZ+FwjyMJ8biOEKmz7YXrsCZ4S64jQII7Z
        Fxt3RmbW1RuFKsX8xd17fDJNnfm/MPpttNrHT9BH0lnA4qP8VIhxwEK3ilbMB8zxh
X-Google-Smtp-Source: ABdhPJzZO55SZptaXz+DRv/1SPFSy8/bkvN/+bs0qkHsfszY0bOR901n9Ru2V2uw+Eh+PccwGBnDDRwG8W+N
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a25:4012:: with SMTP id
 n18mr2868363yba.295.1620822627335; Wed, 12 May 2021 05:30:27 -0700 (PDT)
Date:   Wed, 12 May 2021 12:30:23 +0000
In-Reply-To: <20210512123023.3286501-1-qperret@google.com>
Message-Id: <20210512123023.3286501-2-qperret@google.com>
Mime-Version: 1.0
References: <20210512122853.3243417-1-qperret@google.com> <20210512123023.3286501-1-qperret@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH stable 4.14 2/2] Revert "fdt: Properly handle "no-map" field
 in the memory region"
From:   Quentin Perret <qperret@google.com>
To:     stable@vger.kernel.org
Cc:     alexandre.torgue@foss.st.com, robh+dt@kernel.org,
        f.fainelli@gmail.com, ardb@kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 71bc5d496725f7f923904d2f41cd39e32c647fdf.
It is not really a fix, and the backport misses dependencies, which
breaks existing platforms.

Reported-by: Alexandre TORGUE <alexandre.torgue@foss.st.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 drivers/of/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 6df66fcefbb4..6337c394bfe3 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1213,7 +1213,7 @@ int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
 					phys_addr_t size, bool nomap)
 {
 	if (nomap)
-		return memblock_mark_nomap(base, size);
+		return memblock_remove(base, size);
 	return memblock_reserve(base, size);
 }
 
-- 
2.31.1.607.g51e8a6a459-goog

