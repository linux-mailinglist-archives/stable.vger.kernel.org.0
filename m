Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1223E37BC8B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhELMbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbhELMbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:31:34 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943CAC061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:30:26 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id x10-20020adfc18a0000b029010d83c83f2aso10090705wre.8
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=44quH9h0v/ssSTsBsF6QUTp0nw21LsloMpFQ8AjM0kQ=;
        b=C0xuE2yozXLSMSpjPI9rTeWsK0+OgrdrzmIpri3JUkb3UOcpkGxVeIxButnxWU09wf
         ZT1yfChZpzrQICxqVjHRh2EDiVYSwpQCADnl5N2xuPonnKoTPAmodeNuxlQFXgQGzelU
         jEhQ4qNHcpUZePa9HX4MFYNUUSqOdDIkOO6SUHGnlZ1rBMu3tRcv7neSuB/dLpCFN4Zr
         f333T+8Jgllr1gqJ3nw9dWO85O4olzasaXTLib4yiP2BZbvt96/tOkZYUei7qd1d185n
         hH55s4QbykMUkO6PhVbIOsbA4x4YSpEJutlFW90jf85Bdfyu9Kl33I4ieaGbPMWnRzg8
         cDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=44quH9h0v/ssSTsBsF6QUTp0nw21LsloMpFQ8AjM0kQ=;
        b=XE+Gt2UbE/F2covieiYYeFqhUMxOc7J9Ve6e3v3QCeBbXX+3iNcHobIyEu/a/amblz
         brFcWmMB7ZAcqEusPIh3OfGblA81+VDTktXzLRBBDYSdK2XpZQ/Iot/VqViJ6uHVKyeU
         xr93LGXD3f7x0OlstN0vxRHeZ+Cbu20HywCeFD47d4GZhFw3vG8mna7f/zCsLFsUU5Bv
         iWy5yPTVarPiHGjNWZ5mK0DnCM7ll7INJP6gbSh6W8JhkY94fX/u+mK+vp0pgsWdpLJF
         K32rRx5/B39mdNNxxrWCtpyZHgTJxSiaU22304utG+LmI99c5QVc9RPW8btNvqZ9lQX9
         TeEg==
X-Gm-Message-State: AOAM530LhaAOuC1g0hjFkXC8d6xGRzBkdsoeX3wqhTwiTgTxH/s5pnCm
        iC201tYhrpqzj99JN+2cbERXOzeTpWgV7Qmr8waIt5MntIw4M4DUpMLqnP96IDeuwrd6lPEWfqM
        dINllNGizIkCPvWgjE/rIaIQ5vxrBY0qyp/WHmZrT5gr9ezvJO7BPnrlhoYFleiZ2
X-Google-Smtp-Source: ABdhPJzVeLKnaqLHjd0HMGsoCeY7/sX/MIuwiDF7tUSEoO+Im3Dg6bQIhAZ/AjWu2guTTmxWkCUdZbh5o9lD
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:193:: with SMTP id 141mr38601174wmb.99.1620822625180;
 Wed, 12 May 2021 05:30:25 -0700 (PDT)
Date:   Wed, 12 May 2021 12:30:22 +0000
In-Reply-To: <20210512122853.3243417-1-qperret@google.com>
Message-Id: <20210512123023.3286501-1-qperret@google.com>
Mime-Version: 1.0
References: <20210512122853.3243417-1-qperret@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH stable 4.14 1/2] Revert "of/fdt: Make sure no-map does not
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

This reverts commit 6793433fc8f263eaba1621d3724b6aeba511c6c5.
It is not really a fix, and the backport misses dependencies, which
breaks existing platforms.

Reported-by: Alexandre TORGUE <alexandre.torgue@foss.st.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 drivers/of/fdt.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 3f58812d02d9..6df66fcefbb4 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1212,16 +1212,8 @@ int __init __weak early_init_dt_mark_hotplug_memory_arch(u64 base, u64 size)
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

