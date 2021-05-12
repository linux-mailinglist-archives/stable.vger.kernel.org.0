Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E2837BC8A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhELMbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbhELMbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:31:24 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A02C061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:30:16 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 69-20020aed304b0000b02901c6d87aed7fso15585295qte.21
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BmABl+M8Y4qIcGVqqVE7xy0QHPuQk0xm435nxxY0y9g=;
        b=raXDmoxmneMurJhHoonKoH4QndQegMbfYeFzoP/dfSOfWXk3w+UiCqAFicP1rcrqbO
         oo0BwZixEZKHGYL40GCwj622b7T0HViPvucLIiLiveZHVcpBcP1Mjj2T2KLmvTdWDjNk
         /3MbQ0pmWYkzI8yKvegmYSWz4ix5iv9BBG1BaSGj6QZS2fEZ94k1p9HEv9soMmnFd58U
         zlR0A8zKw5CIBHg8mm+Pw0aHKCFRl3y0I0ffBVdyBFMIuf4BMzZIOGFvT7Vgr1QXYgyy
         lLLABu1zwZOQpMuL0465vU5jZCtlyGJhuLptglfQabkgqwj0BkjUyINV0k14I0c7pjzX
         887Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BmABl+M8Y4qIcGVqqVE7xy0QHPuQk0xm435nxxY0y9g=;
        b=lQZvavJTon3FleDGrKo9lYp3qQHXcabAfOhEq154JRdlTBUMHUMO+fmYoRbob0gjNs
         pbMezX8QRe/Fz1plwmOYoJ1O19NURpe4saysJskCeZkW4B8So8NwNSCwQslrWpz3JDcd
         x/r23FzxtwSH72ASYrKNClbtTOcUWr7WOFRDhdtZqLVWKhwoqkkJpCqw15Ypn5KWxtin
         /jNNswNBh9VtjA4yNn9Z+6eQ2afvUpjgkFUlNj4rwHl2KLwV1p55HSC1k+iChaTET290
         kt/IRDtknx3tsqa7cK5PdwHHNMgGURsCxIN/cWsk0m/4gXljr0FdFtBwW5IU9ND5zAtY
         RDmg==
X-Gm-Message-State: AOAM530m7zHNdtckZ0wHPux0xS+bvq3+SUWebkXb0uj7H43omE0gTZMY
        ZGASHOJHfI31puqGpYjNaAsqnGA2jn+qTFrXRu2mwW9OxAh1nJ/6gpj3UcXGiG/njdLn/Io3DCs
        9C2SZJT9aLspi3KF838T7tY6uQkkQIBkzvqycfKNFyF+imQkNs5p2DIQewyZugk57
X-Google-Smtp-Source: ABdhPJwH7nIejUpVmAfZJauL1AdGvsfSM2MKJuoK4g0Qli9syESx3Yprwj+UHquog+qrN8XxbOqYngrUdCM+
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:e486:: with SMTP id
 n6mr34592755qvl.21.1620822615519; Wed, 12 May 2021 05:30:15 -0700 (PDT)
Date:   Wed, 12 May 2021 12:30:11 +0000
In-Reply-To: <20210512123011.3285670-1-qperret@google.com>
Message-Id: <20210512123011.3285670-2-qperret@google.com>
Mime-Version: 1.0
References: <20210512122853.3243417-1-qperret@google.com> <20210512123011.3285670-1-qperret@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH stable 4.19 2/2] Revert "fdt: Properly handle "no-map" field
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

This reverts commit 03972d6b1bbac1620455589e0367f6f69ff7b2df.
It is not really a fix, and the backport misses dependencies, which
breaks existing platforms.

Reported-by: Alexandre TORGUE <alexandre.torgue@foss.st.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 drivers/of/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index aa15e5d183c1..800ad252cf9c 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1173,7 +1173,7 @@ int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
 					phys_addr_t size, bool nomap)
 {
 	if (nomap)
-		return memblock_mark_nomap(base, size);
+		return memblock_remove(base, size);
 	return memblock_reserve(base, size);
 }
 
-- 
2.31.1.607.g51e8a6a459-goog

