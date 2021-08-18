Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093B53F03C8
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 14:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbhHRMfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 08:35:03 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:43696
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233634AbhHRMfC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 08:35:02 -0400
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 710704066A
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 12:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629290067;
        bh=66IjiltKkESwtV98qXBzRqL08BxcvFvMBexm+KtmZxU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=qxrzo5AI3i91lUnp355+QgjxW6rRwVyJoOdZE4hgtYApDYkjSiqwIkMK1iremO8e+
         i8SktjsyVNOx0+dqUSXzYWsDC6WAQhsyqJvz9vJV5RBst4EOlr9eMHNALctPSKndh3
         sV8L1b+dGzG/jW4x2j8s80tlwbFtG/d/6gRsSk3Yot1V9MQBUzpWe71LPAA4oc1AK0
         zzynXOIdxSKWuhMvoo1TtUV3FVUO9KwgCcRoRgOmoO/7+ns5igKv0/CcHsVUC1qEbr
         i2g7IqNPAtkPw3eU3VdfFYIxPqMZsWIRO0WmpIFcYHjKN9ChpftOY3Int9idmbH7HR
         LZRUHG4Ebm3yw==
Received: by mail-pg1-f198.google.com with SMTP id t10-20020a63eb0a000000b0025243699e3cso1341479pgh.2
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 05:34:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=66IjiltKkESwtV98qXBzRqL08BxcvFvMBexm+KtmZxU=;
        b=CbpwYlMpP2GnCX6RCqWqfESoPP0V7IZ5KPgW04njU/jps6kjpKZ9onay7mOp/WdLLQ
         86EDMkwlS9ikcRX1YHinniMSzad15Zae/kE4DEmZUloXGnayxHMgG6Ne1+srW4mISiIG
         3raxYKUU6xB6nvUapaHwKXokspGt2SE3t/InQPSOk4bwOtGdHQiVCZPAoPTqrcd/FVZl
         XLwmA6YJYApxtYvqaMS2PryvTHQq9ne3GXBzz59B5hbf/9At0p2d8VuLntz9Gdz8Ln3p
         5b6osIOEYpFxnlZFXZjacMsVdJibgmxf/nV44BfhBN1jRCRUY7/e7N6dnZ1uk4EwdQDI
         VB/Q==
X-Gm-Message-State: AOAM530RKVQDibSxvjKTo4CBpyHrQqgCZGGEeQmugsTEo8ZUK5DL2liD
        VL/tSyqVwcc6xfZiQQ6LTOLrG2dCZ5cwfYK+k4RQOEu9JwWkscAj/NRCexJseez3tA7uniPMOh9
        a48N/DHbb8i2Q4EvUQfnhMX+G5Xxw6z2NSw==
X-Received: by 2002:a17:90a:4498:: with SMTP id t24mr9120242pjg.235.1629290065904;
        Wed, 18 Aug 2021 05:34:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXmqk1Cuge3TeCCcnRJ0ksDxzJsmeXBK0Grwr2bz03xaOoMC1hzfWsCMCd8FSLzNysoOE9UQ==
X-Received: by 2002:a17:90a:4498:: with SMTP id t24mr9120220pjg.235.1629290065663;
        Wed, 18 Aug 2021 05:34:25 -0700 (PDT)
Received: from localhost ([2a01:4b00:85fd:d700:1397:609:e787:2244])
        by smtp.gmail.com with ESMTPSA id m2sm7102910pgu.15.2021.08.18.05.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 05:34:25 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     stable@vger.kernel.org
Cc:     Guo Ren <guoren@linux.alibaba.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10.y 1/2] riscv: Fixup wrong ftrace remove cflag
Date:   Wed, 18 Aug 2021 13:34:05 +0100
Message-Id: <20210818123406.197638-2-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818123406.197638-1-dimitri.ledkov@canonical.com>
References: <20210818123406.197638-1-dimitri.ledkov@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

commit 67d945778099b14324811fe67c5aff2cda7a7ad5 upstream.

We must use $(CC_FLAGS_FTRACE) instead of directly using -pg. It
will cause -fpatchable-function-entry error.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
---
 arch/riscv/kernel/Makefile | 4 ++--
 arch/riscv/mm/Makefile     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index fa896c5f7ccb..27f10eb28bd3 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -4,8 +4,8 @@
 #
 
 ifdef CONFIG_FTRACE
-CFLAGS_REMOVE_ftrace.o	= -pg
-CFLAGS_REMOVE_patch.o	= -pg
+CFLAGS_REMOVE_ftrace.o	= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_patch.o	= $(CC_FLAGS_FTRACE)
 endif
 
 extra-y += head.o
diff --git a/arch/riscv/mm/Makefile b/arch/riscv/mm/Makefile
index c0185e556ca5..6b4b7ec1bda2 100644
--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -2,7 +2,7 @@
 
 CFLAGS_init.o := -mcmodel=medany
 ifdef CONFIG_FTRACE
-CFLAGS_REMOVE_init.o = -pg
+CFLAGS_REMOVE_init.o = $(CC_FLAGS_FTRACE)
 endif
 
 KCOV_INSTRUMENT_init.o := n
-- 
2.30.2

