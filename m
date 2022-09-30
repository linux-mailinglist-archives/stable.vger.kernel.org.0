Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563C35F13B7
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 22:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbiI3UdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 16:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbiI3UdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 16:33:19 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32AB1D7BFC
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 13:33:16 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id ay1-20020a056a00300100b0053e7e97696bso3347562pfb.3
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 13:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=SMQsBtCCyLRrqpBDgN2Zoeao+ul/V+LJS6j1U8pzQAU=;
        b=JVe8vVsAiLOpWL3/NzYtEi2BruvEjHVm4AEMgx5mc+Ak77rP8Jn9WKf6W8EyjFam2W
         KfDCzI3KrvVgqbNhjxoez9qP5YEmbdUysYr9GoCP1FW6BXKAoMJg3z62g2AVRExvSItO
         ST7N4OvdR10yDD31HpFVvaviiwtZXkcWkUHN4BUBKZ6kbWrOx9bHCUDM1hnbjh0OB/LZ
         +4evEXvbMukJR3Z7UJPKMhEQvgUVk6VZoGsD4dxkiwBIDf5lgOZLoh6U9oNmPRixYW2z
         InT4O0wyUrlRVLU87m+DiRzIw7QXhJZJDPnK6cg+xujAwI/HKnh7B0Qa97c09DHyCmIL
         5A3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=SMQsBtCCyLRrqpBDgN2Zoeao+ul/V+LJS6j1U8pzQAU=;
        b=BwPiplPZzfVZPDqFIDNxW01u+cE3ELqGmF8zRwXzSeOMIh2JMBxdA8jXf+qdDIIgaJ
         WuTg5Gp5Tnyil1XLwLtwaO31duUCrtPNUi322eEoGk7wqhzTxS4n5HJMzyNCALtv07qm
         LqYnd/gaJzKMv4oBy+Jty8z1HWgJxZxDbBAechquRgGfJyh4yqoA7pg9VjTOoj6+nhnH
         OumhDu0yToaJjt2o7pFxTZPah/9OYAp9gFdpvnxWqt6eQxiAT71t9MjBUBQMksLf/8WX
         Kos4KBc7DPMIsf40SF7L0TOvFwE1ERw3zhAUk965GWVS4hr0Vofb3RShUaO1H3AoWO/s
         kc+w==
X-Gm-Message-State: ACrzQf0r+JMMBPV4R//PxIAwYe0S6mT03joHZnxzJpUtvmPNe88k5/hY
        QQ2di0T25mGh7HMLZo8XSLS96Nr+bObkH/pUQjM=
X-Google-Smtp-Source: AMsMyM4eAqTCDUfydVdhf5U7mW3z+20dr+NzSt2BRmPuylTSU+w9kmiWK1I1Beyd2swmkxphq45pk8BzPKKFXP13glo=
X-Received: from samitolvanen.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4f92])
 (user=samitolvanen job=sendgmr) by 2002:a17:90b:1b06:b0:20a:6d32:b05e with
 SMTP id nu6-20020a17090b1b0600b0020a6d32b05emr35559pjb.103.1664569996339;
 Fri, 30 Sep 2022 13:33:16 -0700 (PDT)
Date:   Fri, 30 Sep 2022 20:33:10 +0000
Mime-Version: 1.0
X-Developer-Key: i=samitolvanen@google.com; a=openpgp; fpr=35CCFB63B283D6D3AEB783944CB5F6848BBC56EE
X-Developer-Signature: v=1; a=openpgp-sha256; l=1362; i=samitolvanen@google.com;
 h=from:subject; bh=cb9uxuoR+cjTVhl0LEU/KRuB1nV8Tr++NRhDrxG0pH4=;
 b=owEB7QES/pANAwAKAUy19oSLvFbuAcsmYgBjN1KGfuXEg/p2HFc8oG4zdl0hi2M0tCCEpmBR8vbU
 mUEvbkOJAbMEAAEKAB0WIQQ1zPtjsoPW0663g5RMtfaEi7xW7gUCYzdShgAKCRBMtfaEi7xW7o3tC/
 4gIorPccJBNlneIDwxrzmurGTgMjEeX26RFRVwv1bFgkbufV7u5gYf1jZCrCRrckERcBv7s33gacaH
 yEHS51srndw7V5ol/CX17484w4zcqhkH2nNeZP996dY9m6tYwJsHHSYgRv5N6gcwzUaFa6+rPqHFbb
 5yH2tr+5q4c6aN5Ra9Wj83rCOw6aaNCnvOG8nhhT69MHyX6esWf1sec64IIyd8q7v1d8aXKIdz2PJ4
 Ae7bsBLZClrEcol4ijmrLF1iGizStoGTNj9xMwG9w5v/2b5mrtgqtq40qS0dW57Gp/QJjPuRcPYoMb
 dD8q9EpQazoDLbScLb62qEOwX1G/H7GRmB1Q21KJGAmwCinxforNZFI9L4RyQXmkVzx+G6aeFH2vcl
 tMleRf8wUgpPUQOHrLzwcC4hZwapkOsp2NYhpt6QjGO3nqowr769r+oK0/H5CN55y9+JJotNsKuaAg
 3ZRV9R/cRNiXFj9x7u3YnkUfAVkxpRQnoMA5t3T9cxrQs=
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220930203310.4010564-1-samitolvanen@google.com>
Subject: [PATCH] Makefile.extrawarn: Move -Wcast-function-type-strict to W=1
From:   Sami Tolvanen <samitolvanen@google.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We enable -Wcast-function-type globally in the kernel to warn about
mismatching types in function pointer casts. Compilers currently
warn only about ABI incompability with this flag, but Clang 16 will
enable a stricter version of the check by default that checks for an
exact type match. This will be very noisy in the kernel, so disable
-Wcast-function-type-strict without W=1 until the new warnings have
been addressed.

Cc: stable@vger.kernel.org
Link: https://reviews.llvm.org/D134831
Link: https://github.com/ClangBuiltLinux/linux/issues/1724
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 scripts/Makefile.extrawarn | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 6ae482158bc4..52bd7df84fd6 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -64,6 +64,7 @@ KBUILD_CFLAGS += -Wno-sign-compare
 KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 KBUILD_CFLAGS += -Wno-tautological-constant-out-of-range-compare
 KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
+KBUILD_CFLAGS += $(call cc-disable-warning, cast-function-type-strict)
 endif
 
 endif

base-commit: 7bc6e90d7aa4170039abe80b9f4e8c8e4eb35091
-- 
2.38.0.rc1.362.ged0d419d3c-goog

