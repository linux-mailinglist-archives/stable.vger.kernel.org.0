Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC5533E8BA
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 06:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhCQFGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 01:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhCQFFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 01:05:30 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892E6C06175F
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 22:05:30 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id b184so288926pfa.11
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 22:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=subject:date:message-id:mime-version:content-transfer-encoding:cc
         :from:to;
        bh=74MWaAFPWeZRrJY/C5d35d6IGwQth/42igzA+G1JWys=;
        b=MGlPr2zNtZRWeH0WPOublJqa7uHznf2J3FG5zh7XjRx3S/ZeQ0KuQ5NQ3dS3AAqbnT
         /uJmhIvdium6Xrztsyx/YkwvWvPttDavnm8mmA7FBQ3fDtVD6QOFNnqW1uzRt5RoFEwq
         JFkW9Ys2gnzv6EItdJXk0H13KxkjBJLbeWCnQgLImGOw2yoodaX33yRLsWhTjy+1h/JX
         AQC7cWBzHXq0QMAUNTQonFITBCYf6wid1mA1ZfZcRot9q5XDH+s/U7m75NyPvM5lhx7r
         UpE+CDWBtTWQnFkQijdqLyyQIk2JXVmMxBELY9eb3EpV1TALRUP0oUpFjTsh1OYkp+QQ
         ZNcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:mime-version
         :content-transfer-encoding:cc:from:to;
        bh=74MWaAFPWeZRrJY/C5d35d6IGwQth/42igzA+G1JWys=;
        b=E3ljUy0Ia69V0a5WSLhaZdhYVA+cwbI1oHXyc0YH5Wlf932MVPoAEzcETHcRWJW+2O
         YkC6c1G8UxzO28ccBxLDESwL0dM+nUY+pHGqKPkmxkO56iNa4GsvV/wUKNOfo2I8SxWi
         V7wa8Iv1PmH1yjHzKNaJ9ZBi9R69uO3feUhB2dzhBDQuvUHLnEKnnn2LjQfQ7ZaTVfoV
         tyUd721N38Hyfd37o6t/GESDegEFgZuT0YyUs0XooLsfWLj3rWorUqeW8M7a+yBAql8w
         K1plje88LOZH3eaL1kfIrwFzBffSzkBGyC0OU4HNz3fYrGA6XVA2zImcQ3FXHsF6/Vpg
         TxPQ==
X-Gm-Message-State: AOAM531cgmRNq63hre8Knz0jtRgCyjVXH7oA5F9eZeUFF+yci2WtdQiL
        +Lx+ofYzdGVbO+xnwj84eY0W2Q==
X-Google-Smtp-Source: ABdhPJwyAS37AVZmYTT26BlYGq3rImNXpjkfbo7T3Sset77tFACl1dGuMH197K5UPPZZ6GRFEWR1bw==
X-Received: by 2002:a05:6a00:b86:b029:207:8ac9:85de with SMTP id g6-20020a056a000b86b02902078ac985demr2671100pfj.66.1615957530001;
        Tue, 16 Mar 2021 22:05:30 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id d14sm1031270pji.22.2021.03.16.22.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 22:05:29 -0700 (PDT)
Subject: [PATCH] RISC-V: kasan: Declare kasan_shallow_populate() static
Date:   Tue, 16 Mar 2021 22:02:48 -0700
Message-Id: <20210317050247.411628-1-palmer@dabbelt.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
        dvyukov@google.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, aou@eecs.berkeley.edu,
        kasan-dev@googlegroups.com, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:         linux-riscv@lists.infradead.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmerdabbelt@google.com>

Without this I get a missing prototype warning.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: e178d670f251 ("riscv/kasan: add KASAN_VMALLOC support")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
---
 arch/riscv/mm/kasan_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
index 5c35e0f71e88..4f85c6d0ddf8 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -155,7 +155,7 @@ static void __init kasan_populate(void *start, void *end)
 	memset(start, KASAN_SHADOW_INIT, end - start);
 }
 
-void __init kasan_shallow_populate(void *start, void *end)
+static void __init kasan_shallow_populate(void *start, void *end)
 {
 	unsigned long vaddr = (unsigned long)start & PAGE_MASK;
 	unsigned long vend = PAGE_ALIGN((unsigned long)end);
-- 
2.31.0.rc2.261.g7f71774620-goog

