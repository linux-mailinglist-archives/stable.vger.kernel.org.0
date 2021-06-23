Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4C03B21E5
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 22:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhFWUmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 16:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhFWUmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 16:42:05 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7734C06175F
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 13:39:47 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 13-20020a17090a08cdb029016eed209ca4so2116535pjn.1
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 13:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9GYkjjOQZ6Rz1pEOIf9K4RSl8mgGGEOKk2i3NOWLjLA=;
        b=oEmyBdL/O6vMQ+qVWEiW1NRHGzhz4sEKTZMQ6lOUKhPz+NU9pA0qtKyPEmtPkPcJ/T
         GFg4CLQSRyolenFblesTc/xamKo1azEcNE2e7G52IG9ckEWLkNoNPIZH+lwGdOv+zkLs
         E2Gz8zf4zFisvYsNtwUM+ePjJm2AW2kZbXzeM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9GYkjjOQZ6Rz1pEOIf9K4RSl8mgGGEOKk2i3NOWLjLA=;
        b=fIAjN4TN08l19ON9N39Kuz8GCeY/s0S+ZFlm6X2wxdUeQ8Bot0DfXwO2g7iod+5pWq
         mKU/EPxWksClVcQtCC9gL7uFvaGoaFbNegYt9YkYDSSTZl0lfDhseSDanz4K9XAoJt2p
         XJG7esf2yoYCyVGjxfGM7XOLjEGxvTM20MR+N5V4nDbL1vVXXvt1skEwqFOLIhmeqaJR
         7nahJU+YxFKxKftyWrgTQuXOskkdSlM78UtjDKAlkfj836TWKGXb4DJeTZ7gmVGt8Gfu
         MtosSGs+x13NBBGCPmWkq1TVRwM8Q7bx8rYN10zHb4fXNa43aCj06i3rYk4SrEU3kpft
         pVoQ==
X-Gm-Message-State: AOAM530ZFYl32FRVldiKnrTZmnpLCY/JfXlImF1iNql/zdULj+Xu5yuC
        dZ4URuRxr1WIQQ6Yo737f1Wlow==
X-Google-Smtp-Source: ABdhPJyiQ1Dq5u49OR3fXAfm+2eccv3ffMdE+z4V+DWcE7R4TT5inmbnDGnEzFjPHHMnRccPE95hkw==
X-Received: by 2002:a17:90a:a107:: with SMTP id s7mr11289459pjp.1.1624480787198;
        Wed, 23 Jun 2021 13:39:47 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y15sm408790pjy.38.2021.06.23.13.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 13:39:45 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        kernelci@groups.io, linux-kselftest@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 2/9] selftests/lkdtm: Fix expected text for CR4 pinning
Date:   Wed, 23 Jun 2021 13:39:29 -0700
Message-Id: <20210623203936.3151093-3-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210623203936.3151093-1-keescook@chromium.org>
References: <20210623203936.3151093-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=856; h=from:subject; bh=BtO+LH6joKjiA1jPQ0OLj8i4wDaw/FKwTM5xGU6TBl4=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBg05wFD1/rNKnVPI48nDGJ/4Gf4RKsbn3ohaIJBJ1z W+hDT3uJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYNOcBQAKCRCJcvTf3G3AJgPRD/ 9554BXu8baUchD9pqZuBakcbDtoPvR4mAfpwlKhZmDIAG1GjldVg2qs85A5/51LQ1mPCqv8HQUw/5y JucMju9+zN9hyC0j4+K+mz7kiWWsbTgpvRshpU9z89xohKpQO4RgwEhcJ80nVl+g6G7xtTBM9sZjDr ZsXxJE2vxcrsPc/Jk/ucVWI36iZw/JOrEwliKBaaoVEybyEbNPM9RoOGYTOaBJFPhencB0xSczI1YK ZoykQ09IfaXPfJG1cbYhdwyAU4Yo+oLY3VaWi47ELXLhwp9H4HbI0XpZBqNRlbK0Qd/YFnW614FjI/ f+piK+8e7mlAet+zuWdo9LrPQ84Q6toQSV2Y7YsksdVBY6ZVOfatpEDU3W4eKObM0234oE10xnAzJL nPeO610vI0wZ/OhmzHfwb/ybuomHS+e8L6MH0dYsOTU+5ON6bt8TgnX4clULypm89ihL9BrSEypG5c K+QqcbauDvH3EaLB0tP891W0aQ2f5He2M9QpqlvjIQiPWFHAHRmN5nHQTkWTxrY6sqW11nZll/OS1V +cHUbHbJWW5oiXsToLDOt9JBGoCUyqlqqde6vUoGyZZMU7kB1Cm98asIvoVCgcTFGXFaf3y48e4PrX MjdV0E8cknxC9Dr8pewPuwrhjptu/C8x3lPZeduzmOqHLbqxmVuUGORZ9rIA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The error text for CR4 pinning changed. Update the test to match.

Fixes: a13b9d0b9721 ("x86/cpu: Use pinning mask for CR4 bits needing to be 0")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 tools/testing/selftests/lkdtm/tests.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/lkdtm/tests.txt b/tools/testing/selftests/lkdtm/tests.txt
index 11ef159be0fd..a5fce7fd4520 100644
--- a/tools/testing/selftests/lkdtm/tests.txt
+++ b/tools/testing/selftests/lkdtm/tests.txt
@@ -11,7 +11,7 @@ CORRUPT_LIST_ADD list_add corruption
 CORRUPT_LIST_DEL list_del corruption
 STACK_GUARD_PAGE_LEADING
 STACK_GUARD_PAGE_TRAILING
-UNSET_SMEP CR4 bits went missing
+UNSET_SMEP pinned CR4 bits changed:
 DOUBLE_FAULT
 CORRUPT_PAC
 UNALIGNED_LOAD_STORE_WRITE
-- 
2.30.2

