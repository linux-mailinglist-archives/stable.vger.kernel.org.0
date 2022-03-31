Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A234EDE3B
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 18:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239577AbiCaQFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 12:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239539AbiCaQFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 12:05:33 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E038453B79
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 09:03:36 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y10so19163692pfa.7
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 09:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WaDQKrdaR8NaSNRfIclPcNB48xXWJFA4N51jB1EdyFU=;
        b=Sd8vND0bcSGNpXI7V83nDEWnQBVxmFeCHQze1YGBtV7kVi7vy36yxGVFDEoivw2yXU
         DCqpCaQduJqbAPWXL7Ryiq+j88nSJvLkoGme3GAndo69eV7PdASaPz13MZuE/1+0PIez
         0qw4Ky40o+pVofwIb0qklOUiObltmqjwPWZV4M7f78EiPS1JLyFiPlNXwGfgARe2In5C
         PbjMt85gNYSWp5jgUGhXEsqwSM93MOMNoOud9ukf3MFF4WZzT5joSJgFaIw8Mp463TP9
         CBEvhYWKKMJTKcOq0JsBVtVcvKWVJM+HnTPlmlCZilWqsioY3g01iUejnjRWjETENH+Y
         Aa2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WaDQKrdaR8NaSNRfIclPcNB48xXWJFA4N51jB1EdyFU=;
        b=S+Qf+3noIY/eB8PVbiEXu6jfMSUJnAlsSyc/49lZ/Pe693dlEHrGkqI4weC4cr4yz8
         N/XFxVaxFm5pkKI+zy8X2apF/fOLsXTlCDaG/UMiWhl4TyYG9cOAWAkBOa3bpB4SO5oQ
         M3kL7fa+SQtDw26eZxnTJcg69/98P5ww/ekHt9w7otWUOnXKTGsrT7KfGebnxi8t7qe2
         AyIDdj+j0ZktOgN3SIJtZxXSuW35GIKc3ylu0VHPwhwWg9weiwZOZaP3Fsp81KxEihab
         aH8hDeqFCokuWlvjAv3douDutBPNzMJmGGszhZIgiCMp8U5ePN66zLW8FPow70JQXuQU
         +T1A==
X-Gm-Message-State: AOAM531mnd/d335l93icxluGumxJIQnn/UnwQakRuqU8trLsjTxe0J6v
        CgF2REMbYal3nOgZo6MbhIBj/hurtthFWWJ0
X-Google-Smtp-Source: ABdhPJzKhngl0EfPohd/AIqm4zgOhESAQGdMQsBsau9eOfpVUQ36u8fvI78rVTu1BkfZepcsPxiMkQ==
X-Received: by 2002:a63:3f0e:0:b0:386:1d94:312a with SMTP id m14-20020a633f0e000000b003861d94312amr11379305pga.317.1648742615353;
        Thu, 31 Mar 2022 09:03:35 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id l67-20020a633e46000000b003986e01e982sm10180954pga.67.2022.03.31.09.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 09:03:34 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     stable@vger.kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10] ubsan: remove CONFIG_UBSAN_OBJECT_SIZE
Date:   Thu, 31 Mar 2022 09:02:19 -0700
Message-Id: <20220331160219.10687-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.35.1
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

From: Kees Cook <keescook@chromium.org>

Upstream commit: 69d0db01e210 ("ubsan: remove CONFIG_UBSAN_OBJECT_SIZE")

The object-size sanitizer is redundant to -Warray-bounds, and
inappropriately performs its checks at run-time when all information
needed for the evaluation is available at compile-time, making it quite
difficult to use:

https://bugzilla.kernel.org/show_bug.cgi?id=214861

This run-time object-size checks also trigger false-positive errors,
like the below, that make it quite difficult to test stable kernels in
test automations like syzkaller:

https://syzkaller.appspot.com/text?tag=Error&x=12b3aac3700000

With -Warray-bounds almost enabled globally, it doesn't make sense to
keep this around.

Link: https://lkml.kernel.org/r/20211203235346.110809-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 lib/test_ubsan.c       | 11 -----------
 scripts/Makefile.ubsan |  1 -
 2 files changed, 12 deletions(-)

diff --git a/lib/test_ubsan.c b/lib/test_ubsan.c
index 9ea10adf7a66..b1d0a6ecfe1b 100644
--- a/lib/test_ubsan.c
+++ b/lib/test_ubsan.c
@@ -89,16 +89,6 @@ static void test_ubsan_misaligned_access(void)
 	*ptr = val;
 }
 
-static void test_ubsan_object_size_mismatch(void)
-{
-	/* "((aligned(8)))" helps this not into be misaligned for ptr-access. */
-	volatile int val __aligned(8) = 4;
-	volatile long long *ptr, val2;
-
-	ptr = (long long *)&val;
-	val2 = *ptr;
-}
-
 static const test_ubsan_fp test_ubsan_array[] = {
 	test_ubsan_add_overflow,
 	test_ubsan_sub_overflow,
@@ -110,7 +100,6 @@ static const test_ubsan_fp test_ubsan_array[] = {
 	test_ubsan_load_invalid_value,
 	//test_ubsan_null_ptr_deref, /* exclude it because there is a crash */
 	test_ubsan_misaligned_access,
-	test_ubsan_object_size_mismatch,
 };
 
 static int __init test_ubsan_init(void)
diff --git a/scripts/Makefile.ubsan b/scripts/Makefile.ubsan
index 9716dab06bc7..2156e18391a3 100644
--- a/scripts/Makefile.ubsan
+++ b/scripts/Makefile.ubsan
@@ -23,7 +23,6 @@ ifdef CONFIG_UBSAN_MISC
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=integer-divide-by-zero)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=unreachable)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=signed-integer-overflow)
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=object-size)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=bool)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=enum)
 endif
-- 
2.35.1
