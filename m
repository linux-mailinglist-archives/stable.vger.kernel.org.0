Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD1F5358BA
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 07:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243390AbiE0FSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 01:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243099AbiE0FSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 01:18:01 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D8131380
        for <stable@vger.kernel.org>; Thu, 26 May 2022 22:17:59 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id b5so3211761plx.10
        for <stable@vger.kernel.org>; Thu, 26 May 2022 22:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a527G06H+rTZVQ9Z54L95xKvwRXeKSz+Vdkmm5vxnGU=;
        b=TzZc0MO6AfCtlteb9bCnmlhRJEVJvMRF3GI1QjfK6DuAUuzHwL6zhWECRnZ2JZl1JY
         Z77nIxa0np9ZOkDHvyfgQcFFUI8ptER4ES5juS2cPeaqTUslq9lNPZC+U7FuXLRK6TWd
         Qzy9wZ479GcfvWsXR1xDEHZK6oA7zDhwdg1oONTDxoMqhfpHKcUIQmqt+549nrdZWid7
         ln0vEhIAy3enxkwU+BHpwnK85yTozOM3ylbmNXqK0dC0fv4bMhROtEtVaeyM1tW4lBXP
         PK8nbF9aa4gb1QSDcJQE5slBaG9QgWoDlQ+mHUizYCzh/JBX14DiPHQMLGLnFIvMhK9B
         342Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a527G06H+rTZVQ9Z54L95xKvwRXeKSz+Vdkmm5vxnGU=;
        b=g5xsIeNNi7FhOJyK+itXU4ePT3pbkbWa78iO/gk5MWg4LwWk+yYl5FbCk6LM+rST+b
         ovIBew0cE1zlhABOZjY3AmCiKoRGyo3L/5/0if6bYvygQdYRYbjSuvB3f30QIhd04rsG
         9qx0+Z6z5Sch4cKPCPSHojTqRV9jd39JqzqUYwybyExiXgKFY0jYB0444WDHzl4Jnkw5
         kY7JpA9Bb3KA3cjQvB6AXmmhfAorXg4n6OxKhflqjfKLsNeKBmwKeT+nf1gRq0tTHpbG
         6eF0X2iJGKzoVfzrqurz4I6TfNYT1/gOJ/Md48fDvrvHH3lo5a/rjyd0xtISqRbtDSW3
         O2zA==
X-Gm-Message-State: AOAM531ByksISMY6cqs7sG3wtZjBoC17Wdx8c26y1YvnCgEuxNSIvDLG
        ifPGDvKYCZoujp0ZCDUR/j5lMg==
X-Google-Smtp-Source: ABdhPJww0P7BfKdwPMxOyVsREAc1pWap5/VTK+ciOW5Olpxk9SeJR3sDpMVAMRIM6moUHTH/ZUTdXw==
X-Received: by 2002:a17:902:cecc:b0:162:4d5c:3eac with SMTP id d12-20020a170902cecc00b001624d5c3eacmr15415645plg.82.1653628679351;
        Thu, 26 May 2022 22:17:59 -0700 (PDT)
Received: from kerodipc.Dlink ([49.206.9.238])
        by smtp.gmail.com with ESMTPSA id j34-20020a634a62000000b003c14af5063fsm2459003pgl.87.2022.05.26.22.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 22:17:58 -0700 (PDT)
From:   Sunil V L <sunilvl@ventanamicro.com>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Atish Patra <atishp@rivosinc.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Anup Patel <apatel@ventanamicro.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, Sunil V L <sunil.vl@gmail.com>,
        Sunil V L <sunilvl@ventanamicro.com>, stable@vger.kernel.org
Subject: [PATCH V3 2/5] riscv: spinwait: Fix hartid variable type
Date:   Fri, 27 May 2022 10:47:40 +0530
Message-Id: <20220527051743.2829940-3-sunilvl@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220527051743.2829940-1-sunilvl@ventanamicro.com>
References: <20220527051743.2829940-1-sunilvl@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The hartid variable is of type int but compared with
ULONG_MAX(INVALID_HARTID). This issue is fixed by changing
the hartid variable type to unsigned long.

Fixes: c78f94f35cf6 ("RISC-V: Use __cpu_up_stack/task_pointer only for spinwait method")
Cc: stable@vger.kernel.org

Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kernel/cpu_ops_spinwait.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/cpu_ops_spinwait.c b/arch/riscv/kernel/cpu_ops_spinwait.c
index 346847f6c41c..3ade9152a3c7 100644
--- a/arch/riscv/kernel/cpu_ops_spinwait.c
+++ b/arch/riscv/kernel/cpu_ops_spinwait.c
@@ -18,7 +18,7 @@ void *__cpu_spinwait_task_pointer[NR_CPUS] __section(".data");
 static void cpu_update_secondary_bootdata(unsigned int cpuid,
 				   struct task_struct *tidle)
 {
-	int hartid = cpuid_to_hartid_map(cpuid);
+	unsigned long hartid = cpuid_to_hartid_map(cpuid);
 
 	/*
 	 * The hartid must be less than NR_CPUS to avoid out-of-bound access
@@ -27,7 +27,7 @@ static void cpu_update_secondary_bootdata(unsigned int cpuid,
 	 * spinwait booting is not the recommended approach for any platforms
 	 * booting Linux in S-mode and can be disabled in the future.
 	 */
-	if (hartid == INVALID_HARTID || hartid >= NR_CPUS)
+	if (hartid == INVALID_HARTID || hartid >= (unsigned long) NR_CPUS)
 		return;
 
 	/* Make sure tidle is updated */
-- 
2.25.1

