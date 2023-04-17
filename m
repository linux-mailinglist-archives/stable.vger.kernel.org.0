Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709C86E47C0
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 14:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjDQMaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 08:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjDQMaU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 08:30:20 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C762410EA
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 05:30:14 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id o8so5197239ljp.6
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 05:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681734613; x=1684326613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H9SW4BaZ1bnKVP1weVI2e85RynWnU48bLznC9wO1o9M=;
        b=n3zPin0s6G1kVf80R6NptUIL4S3g+P69ADkrw+7CjbBdWnHZAogR6n8d7yvle5PpkC
         N2qD3f66q4c1WuJJH3FC7IEyu49Ue0xXjqtxY5tz+Yd2eWdFli+V0m02Vs2vkkgobOb6
         /EEatrtb5D817UZRcI4zZUpNKlarszn2yTNKMc633kSVLPqSxgDv+hIl6fQRW0Th5rud
         5oJKMxbsSAn2FYb5E9GmEQTFxIKKSETJgwQToXiuD6bixtmU6h5/FXEYcmaysX9KpzuB
         kaQA2hMmfpEFr2V5bYiHWmVt/p17AW/+J57BCjvw7aP1yPVqYWnC7e6oHnl2kWsTAJJ3
         6DaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681734613; x=1684326613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H9SW4BaZ1bnKVP1weVI2e85RynWnU48bLznC9wO1o9M=;
        b=TfijtvrkK7ufv/VSLj/XZWsG9+XKttNuf06n+zxC03CwmBw4Q7Y7yxLPodVUBB9rJV
         pFVB6DSuBNf1mVjxwEnGlVsV2p5GQnuMwry2DX05g5Zhdkj5SZ6TghcZheNUhpQ0UPES
         wBQduwYM8Thx6XTCkUKPLuU/Bt62yFMAcJrD3dLu6WoopmJD5Os4N3+ilHsyGXxyi+DG
         8AnTF90KKSUAneyMHzA0lf3o0hflhQHfk6NxWHbRvhO9iSxDfGfwJIVk4vOG61cB6hrH
         qzcTl3LpH2nojo9eMPAUuVSUW8eANsnzvek/MvnnmoRhHtEwPWMcO2Y5Q6voFRIehvfW
         F0mg==
X-Gm-Message-State: AAQBX9cJihzcEOk3Q33n4yx6OePBi+v9tGgHQepDyQor2ebxFWRT7/BW
        /FMGAHz05kpcw5OexqSpUqYJhH+8AaEQccaOqb+k/g==
X-Google-Smtp-Source: AKy350bwGJE2C7V8hazROuRDBDgzLMhkcDD17prRT/qHi9ZNYNGhNGiMjSfhomMSdAYr9UncH37eIQ==
X-Received: by 2002:a2e:9857:0:b0:2a8:c82f:2996 with SMTP id e23-20020a2e9857000000b002a8c82f2996mr759543ljj.43.1681734612901;
        Mon, 17 Apr 2023 05:30:12 -0700 (PDT)
Received: from localhost (c-9b0ee555.07-21-73746f28.bbcust.telenor.se. [85.229.14.155])
        by smtp.gmail.com with ESMTPSA id l20-20020a19c214000000b004ed149acc08sm1889569lfc.93.2023.04.17.05.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 05:30:12 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     stable@vger.kernel.org
Cc:     acme@redhat.com, andres@anarazel.de, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ben Hutchings <benh@debian.org>, Jiri Olsa <jolsa@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>, bpf@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [backport PATCH 1/2] tools perf: Fix compilation error with new binutils
Date:   Mon, 17 Apr 2023 14:29:42 +0200
Message-Id: <20230417122943.2155502-2-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417122943.2155502-1-anders.roxell@linaro.org>
References: <20230417122943.2155502-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andres Freund <andres@anarazel.de>

binutils changed the signature of init_disassemble_info(), which now causes
compilation failures for tools/perf/util/annotate.c, e.g. on debian
unstable.

Relevant binutils commit:

  https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=60a3da00bd5407f07

Wire up the feature test and switch to init_disassemble_info_compat(),
which were introduced in prior commits, fixing the compilation failure.

I verified that perf can still disassemble bpf programs by using bpftrace
under load, recording a perf trace, and then annotating the bpf "function"
with and without the changes. With old binutils there's no change in output
before/after this patch. When comparing the output from old binutils (2.35)
to new bintuils with the patch (upstream snapshot) there are a few output
differences, but they are unrelated to this patch. An example hunk is:

       1.15 :   55:mov    %rbp,%rdx
       0.00 :   58:add    $0xfffffffffffffff8,%rdx
       0.00 :   5c:xor    %ecx,%ecx
  -    1.03 :   5e:callq  0xffffffffe12aca3c
  +    1.03 :   5e:call   0xffffffffe12aca3c
       0.00 :   63:xor    %eax,%eax
  -    2.18 :   65:leaveq
  -    2.82 :   66:retq
  +    2.18 :   65:leave
  +    2.82 :   66:ret

Signed-off-by: Andres Freund <andres@anarazel.de>
Acked-by: Quentin Monnet <quentin@isovalent.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Ben Hutchings <benh@debian.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: bpf@vger.kernel.org
Link: http://lore.kernel.org/lkml/20220622181918.ykrs5rsnmx3og4sv@alap3.anarazel.de
Link: https://lore.kernel.org/r/20220801013834.156015-5-andres@anarazel.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 tools/perf/Makefile.config | 8 ++++++++
 tools/perf/util/annotate.c | 7 ++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 3e7706c251e9..55905571f87b 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -281,6 +281,7 @@ FEATURE_CHECK_LDFLAGS-libpython := $(PYTHON_EMBED_LDOPTS)
 FEATURE_CHECK_LDFLAGS-libaio = -lrt
 
 FEATURE_CHECK_LDFLAGS-disassembler-four-args = -lbfd -lopcodes -ldl
+FEATURE_CHECK_LDFLAGS-disassembler-init-styled = -lbfd -lopcodes -ldl
 
 CORE_CFLAGS += -fno-omit-frame-pointer
 CORE_CFLAGS += -ggdb3
@@ -838,13 +839,16 @@ else
   ifeq ($(feature-libbfd-liberty), 1)
     EXTLIBS += -lbfd -lopcodes -liberty
     FEATURE_CHECK_LDFLAGS-disassembler-four-args += -liberty -ldl
+    FEATURE_CHECK_LDFLAGS-disassembler-init-styled += -liberty -ldl
   else
     ifeq ($(feature-libbfd-liberty-z), 1)
       EXTLIBS += -lbfd -lopcodes -liberty -lz
       FEATURE_CHECK_LDFLAGS-disassembler-four-args += -liberty -lz -ldl
+      FEATURE_CHECK_LDFLAGS-disassembler-init-styled += -liberty -ldl
     endif
   endif
   $(call feature_check,disassembler-four-args)
+  $(call feature_check,disassembler-init-styled)
 endif
 
 ifeq ($(feature-libbfd-buildid), 1)
@@ -957,6 +961,10 @@ ifeq ($(feature-disassembler-four-args), 1)
     CFLAGS += -DDISASM_FOUR_ARGS_SIGNATURE
 endif
 
+ifeq ($(feature-disassembler-init-styled), 1)
+    CFLAGS += -DDISASM_INIT_STYLED
+endif
+
 ifeq (${IS_64_BIT}, 1)
   ifndef NO_PERF_READ_VDSO32
     $(call feature_check,compile-32)
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 308189454788..f2d1741b7610 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1684,6 +1684,7 @@ static int dso__disassemble_filename(struct dso *dso, char *filename, size_t fil
 #define PACKAGE "perf"
 #include <bfd.h>
 #include <dis-asm.h>
+#include <tools/dis-asm-compat.h>
 
 static int symbol__disassemble_bpf(struct symbol *sym,
 				   struct annotate_args *args)
@@ -1726,9 +1727,9 @@ static int symbol__disassemble_bpf(struct symbol *sym,
 		ret = errno;
 		goto out;
 	}
-	init_disassemble_info(&info, s,
-			      (fprintf_ftype) fprintf);
-
+	init_disassemble_info_compat(&info, s,
+				     (fprintf_ftype) fprintf,
+				     fprintf_styled);
 	info.arch = bfd_get_arch(bfdf);
 	info.mach = bfd_get_mach(bfdf);
 
-- 
2.39.2

