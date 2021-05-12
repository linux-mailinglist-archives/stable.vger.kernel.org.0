Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76C137BC89
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhELMbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbhELMbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:31:23 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6308DC061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:30:14 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id s123-20020a3777810000b02902e9adec2313so17174328qkc.4
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=90VLmxCFKcCVQ9CZUdCjU52HBRZu1Dfb8aZ8TEDuh38=;
        b=P7IGrAiv5Ess5o9zpBmWMh/Kb3zDIwcQ0ae/aqhAEI/lCzDb91VsWYzN0X32EA1Bzk
         15qG9IvSGrwpyknPYsZwqHjiPajl6rmDvR1NBfjjZvRfU6jP87f/MtJSWS/cyZRAgs1x
         jw6ra1foyEAPYMzqVsqjkCFd6LB4ud9lJCrxkC9jG908SAL8JeDLnB7Y9K2eeDAkVsuF
         JPJa5rE01FF2LDIhvx17e1SK0T1LG7cWspr1rqUDxagrD4QZq3elkF6KdKIMyhDdxsWn
         3BYEChwOncBRoQR//HKtqnzT1XgM5bsJjOhUzf5VHV2wIT2yt72/mR3z1pzQL3MocihX
         WDnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=90VLmxCFKcCVQ9CZUdCjU52HBRZu1Dfb8aZ8TEDuh38=;
        b=tjTosMfJhI9DNaPz1wIW9UqTtYn/ywXh/kNlO0K5lJBpjk8pMJDHJYdRPYIA/5BbQx
         Fm1BtWm2LgKYcbGqXhCIzE+rd9rlY9pJ1JSGl79S5QmNOXmnxPDynorlNc+RG1xca3TY
         h7FyexyOS1ocUfprSzBb5SLlj1f/GjB3Iy7uhAqRD7ZCagmMgPrTNN4Qx/fRfNADv1yb
         6rHOUPmgZLjKsH19qjeld7wniuFNY/ESTufDqemsTPRB45wFHnshU/NUofW8jEXhS/zm
         CZ8V6hGK7n47gXAR31FZk3PKblUiY9SLc6QkDPDHinQeIBR0eXxSxhSaLedXL0QqJPUS
         ys1w==
X-Gm-Message-State: AOAM533LjPl8glX9ym4O9pQ4lQH1JfYKBzg4LD37rJCi/mYaqQhSvztV
        mNuAZEvpz+Irci8QiNV6BMPyIGCFpR5cqUM9VPCxuqCN27JN+eoquSWxcpmF2XV/3x72mSrsnZ8
        HpTa6XERzKeo3b6yyUleG9zydphizMhT/bojgWdrfyDq3bKdahD3V+mJoJXiIoW5l
X-Google-Smtp-Source: ABdhPJwxZ/IYZRKNvgygz/74bXweAfnNcBWVAbc9O6mgFQubzueAtJqNybmTqoRYnQoOBiwqMscKbUxZuaGn
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:ad4:5bc2:: with SMTP id
 t2mr34572382qvt.50.1620822613409; Wed, 12 May 2021 05:30:13 -0700 (PDT)
Date:   Wed, 12 May 2021 12:30:10 +0000
In-Reply-To: <20210512122853.3243417-1-qperret@google.com>
Message-Id: <20210512123011.3285670-1-qperret@google.com>
Mime-Version: 1.0
References: <20210512122853.3243417-1-qperret@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH stable 4.19 1/2] Revert "of/fdt: Make sure no-map does not
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

This reverts commit 74f2678aab60c9915daa83e6e23d31a896932d9d.
It is not really a fix, and the backport misses dependencies, which
breaks existing platforms.

Reported-by: Alexandre TORGUE <alexandre.torgue@foss.st.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 drivers/of/fdt.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 21160a08ead4..aa15e5d183c1 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1172,16 +1172,8 @@ int __init __weak early_init_dt_mark_hotplug_memory_arch(u64 base, u64 size)
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

