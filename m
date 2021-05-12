Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5CF37BC7F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhELMaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbhELMaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:30:10 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1400AC061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:29:01 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id s7-20020adfc5470000b0290106eef17cbdso10038919wrf.11
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qdmN0r7BZDBEyNlRZ6VDSHRn+1EPLrx7XrmTWVohN2Q=;
        b=gnHYYBQ47l6f0lDUIpigJjekhxdUFlCEGWytkW8nQnNa998hpY3EGLw4tesocpGRLH
         MzpQB1CaPpzpEYPlokQrJlLXaRSe6NCCWubGCdISEH+CaWWL9aODPNdTnBhK9YcM5WIR
         sRnUej2CoKbXT7ZZqW+IAR1eisTtO/3VJ+U98YSuCcu03F0Rkp0VFTiTxm7GGFd+yi0D
         y2Gr7vOV+C5f1n4DFELAs6AYewhq8g8rt7sk8kdHc1gPcAQf5BiM9iIZZtjNxravOa5j
         Iv3jSqimEKqFFtKVaqH1luHrThwnmpZdLZGnWkVzoItBHs1SylzR4/sCFzBLc7FdpEzH
         xlkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qdmN0r7BZDBEyNlRZ6VDSHRn+1EPLrx7XrmTWVohN2Q=;
        b=JF+tajkqxbRzSY2HPXZMSfIooyTmlO3IwbhW/O6DNYK1LDUDGpMQWr8Rt3tpSytGsz
         oYDzW2iZ2PTjjqcCYKCTnykfSJ6iUdY65nuQwr5/3SAsMTEaFyD4BqrwBPTKtHufJLcM
         g+pWBznXl55Vcd1vbnKlqvcp7lWhx+2o6gY1XcKIn8yXQTp/ZTsL78JDG2pk/jqSFIzi
         Jz1HEEZRnBsYaQqYOqscKWnWf6I4VLXcEpM7sNpgV5uld2H8PCNp2riIKXiPhvMAI8wh
         ALMVEcdTdk5qYDH3kqGXhXH6YF7NIonmjAdZggCairIE2Q5ssondgyxCpOgmhV6gDWYk
         0Ghw==
X-Gm-Message-State: AOAM532nopMIFMGsbSRKfFdC/qWOGr+iqmuHDIwPw7ecEvnnEfjYcDHc
        82U9lJ8nrkxKHnIsVIdq7EjGgRyZMha6IeQC/yI8b9UYIiuaLSfS4bjj1IkAuAQxBp8YzOoccjo
        4cgL1K0TgOJoZXscJeDNGQed7vNDvnVdlKEltBKTBgP5wbgKTe+nKCXB0nEyA0zL8
X-Google-Smtp-Source: ABdhPJw7oniAkjhg1mRT5IZmz4UF8wI6mt2FH6f+vsQVAka4PPTAX8a5HenFua4aMaEYGhp4LcgMs83jUB7I
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a5d:64e1:: with SMTP id
 g1mr45179800wri.101.1620822539608; Wed, 12 May 2021 05:28:59 -0700 (PDT)
Date:   Wed, 12 May 2021 12:28:52 +0000
In-Reply-To: <20210512122853.3243417-1-qperret@google.com>
Message-Id: <20210512122853.3243417-2-qperret@google.com>
Mime-Version: 1.0
References: <20210512122853.3243417-1-qperret@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH stable 5.4 1/2] Revert "of/fdt: Make sure no-map does not
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

This reverts commit 3cbd3038c9155038020560729cde50588311105d.
It is not really a fix, and the backport misses dependencies, which
breaks existing platforms.

Reported-by: Alexandre TORGUE <alexandre.torgue@foss.st.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 drivers/of/fdt.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index fc24102e25ce..036af904e0cf 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1153,16 +1153,8 @@ int __init __weak early_init_dt_mark_hotplug_memory_arch(u64 base, u64 size)
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

