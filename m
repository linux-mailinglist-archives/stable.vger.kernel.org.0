Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B366E47C2
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 14:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjDQMab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 08:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjDQMaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 08:30:23 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E722EA7
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 05:30:15 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-4ec8b1b6851so1428711e87.2
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 05:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681734614; x=1684326614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=75hX5LgqItGx5RLX1YQ5Q6RKXg/GRTXjzOrDItgmVU8=;
        b=bT94vu0Q6QRHgkHMEux4pflaaEqrFFc9jX1D805hEY084GlZmJv+1LygxuvQew1edM
         hctSDM0hY+ODTMcO7zHmtX8MLfqUUeP5ImlX+GX6vSDzXx2oH5mueGc2ohwmreBqIgDI
         5aBsWScygu9ggPb8ghX65lq+WFo54ITKOCDAQn5scP9waolP2+7UiCySk6p7FBWvJdOW
         +z9f3UsEORF2MNFIg4B7w0dVKtjBSwguQWZHQCRalTPBX4QZUSt6y09W8QfxqdaHDFPH
         i5QAfqKyUX1gTkREQBbNGvOqdmf4h1oXoeeCUgF7QJ8G2tNiG8DbvOcpPn+cMU3vRdaN
         iGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681734614; x=1684326614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=75hX5LgqItGx5RLX1YQ5Q6RKXg/GRTXjzOrDItgmVU8=;
        b=UuRC9KV2isJqVlVW1iZr+tNNhnIlRj3Qa3I6tHANZalWUX29Wf3CnPqsnA/CPcMP2v
         ffa4wqAMjilnv0kbD3t6m1dMUzFcUNPMocAPcqDI4JXYYwws4QnVXUQb2BxCPjo2Q/I8
         Vv9t82p/2aswPENAkatfN89TkfzL9nk8DFo15+bVwJ+gFynFR9lwV112dU+O9vkz1n6B
         yWK3cls9PqY9BSlBfYK12lfc4nonPzFvQEZa1jmRpD7aobCUx4hPt2mJtm3N9z38QHFJ
         6iFyVsDN4VZ1D/9VYrti4qejOZrTAM2p0L/kNmkKjDFDJlJfaC2qNL28MJCR6M8UqyuK
         xAVw==
X-Gm-Message-State: AAQBX9dqmcq2/hrWO2vgBWIqyi0ak0Gu0AXA0dOWQ7o6/FmLPPCb1FEc
        1TRSu+vIkdJP0DFoI/ufMR+T/+cgRyX+sc9HrMusZQ==
X-Google-Smtp-Source: AKy350alT7HiO9MfMmbe+E0WP+k1zFnMqspxl3ZlYTgElWMD/Xir4oBFbijc65PEYJil5tk+XpmFfw==
X-Received: by 2002:ac2:5a50:0:b0:4b3:d6e1:26bb with SMTP id r16-20020ac25a50000000b004b3d6e126bbmr1783540lfn.29.1681734613986;
        Mon, 17 Apr 2023 05:30:13 -0700 (PDT)
Received: from localhost (c-9b0ee555.07-21-73746f28.bbcust.telenor.se. [85.229.14.155])
        by smtp.gmail.com with ESMTPSA id d6-20020ac244c6000000b004eca2b8b6bdsm2027412lfm.4.2023.04.17.05.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 05:30:13 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     stable@vger.kernel.org
Cc:     acme@redhat.com, andres@anarazel.de, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ben Hutchings <benh@debian.org>, Jiri Olsa <jolsa@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>, bpf@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [backport PATCH 2/2] tools build: Add feature test for init_disassemble_info API changes
Date:   Mon, 17 Apr 2023 14:29:43 +0200
Message-Id: <20230417122943.2155502-3-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417122943.2155502-1-anders.roxell@linaro.org>
References: <20230417122943.2155502-1-anders.roxell@linaro.org>
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

From: Andres Freund <andres@anarazel.de>

binutils changed the signature of init_disassemble_info(), which now causes
compilation failures for tools/{perf,bpf}, e.g. on debian unstable.

Relevant binutils commit:

  https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=60a3da00bd5407f07

This commit adds a feature test to detect the new signature.  Subsequent
commits will use it to fix the build failures.

Signed-off-by: Andres Freund <andres@anarazel.de>
Acked-by: Quentin Monnet <quentin@isovalent.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Ben Hutchings <benh@debian.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Quentin Monnet <quentin@isovalent.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: bpf@vger.kernel.org
Link: http://lore.kernel.org/lkml/20220622181918.ykrs5rsnmx3og4sv@alap3.anarazel.de
Link: https://lore.kernel.org/r/20220801013834.156015-2-andres@anarazel.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 tools/build/Makefile.feature                        |  1 +
 tools/build/feature/Makefile                        |  4 ++++
 tools/build/feature/test-all.c                      |  4 ++++
 tools/build/feature/test-disassembler-init-styled.c | 13 +++++++++++++
 4 files changed, 22 insertions(+)
 create mode 100644 tools/build/feature/test-disassembler-init-styled.c

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index e1d2c255669e..a789ccbad93a 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -69,6 +69,7 @@ FEATURE_TESTS_BASIC :=                  \
         libaio				\
         libzstd				\
         disassembler-four-args		\
+        disassembler-init-styled	\
         file-handle
 
 # FEATURE_TESTS_BASIC + FEATURE_TESTS_EXTRA is the complete list
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 221250973d07..33ab9823ad0d 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -17,6 +17,7 @@ FILES=                                          \
          test-libbfd.bin                        \
          test-libbfd-buildid.bin		\
          test-disassembler-four-args.bin        \
+         test-disassembler-init-styled.bin	\
          test-reallocarray.bin			\
          test-libbfd-liberty.bin                \
          test-libbfd-liberty-z.bin              \
@@ -235,6 +236,9 @@ $(OUTPUT)test-libbfd-buildid.bin:
 $(OUTPUT)test-disassembler-four-args.bin:
 	$(BUILD) -DPACKAGE='"perf"' -lbfd -lopcodes
 
+$(OUTPUT)test-disassembler-init-styled.bin:
+	$(BUILD) -DPACKAGE='"perf"' -lbfd -lopcodes
+
 $(OUTPUT)test-reallocarray.bin:
 	$(BUILD)
 
diff --git a/tools/build/feature/test-all.c b/tools/build/feature/test-all.c
index 09517ff2fad5..0cfbdc83ffbc 100644
--- a/tools/build/feature/test-all.c
+++ b/tools/build/feature/test-all.c
@@ -170,6 +170,10 @@
 # include "test-disassembler-four-args.c"
 #undef main
 
+#define main main_test_disassembler_init_styled
+# include "test-disassembler-init-styled.c"
+#undef main
+
 #define main main_test_libzstd
 # include "test-libzstd.c"
 #undef main
diff --git a/tools/build/feature/test-disassembler-init-styled.c b/tools/build/feature/test-disassembler-init-styled.c
new file mode 100644
index 000000000000..f1ce0ec3bee9
--- /dev/null
+++ b/tools/build/feature/test-disassembler-init-styled.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <dis-asm.h>
+
+int main(void)
+{
+	struct disassemble_info info;
+
+	init_disassemble_info(&info, stdout,
+			      NULL, NULL);
+
+	return 0;
+}
-- 
2.39.2

