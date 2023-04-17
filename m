Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6F26E47BE
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 14:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbjDQMaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 08:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbjDQMaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 08:30:19 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE01468F
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 05:30:13 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2a8aea2a654so13220381fa.1
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 05:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681734612; x=1684326612;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G/JB5DRDshib4Tz8g7yVBW+9lQnfgBzFAQIBePQQwSg=;
        b=vCxJdFhdT+WCdGm7iu3cW5J4HK1ht+4ta0pd6M/4Mx/Jr+uAZq31KR0AYIxFlYex10
         nrmTFjSLjZKAKIadFTbS2ZPZvGno4TuQAUNY6xOyAR+rqoLdzLJqFpzk5w2QnY0zrU0B
         z9AUV+qXvtTi8r9hE0+HDTLzryfade54+QIUZcG+C94fqFyfOjTiRFU21BCEnWtGuTMh
         zdrSYa86ucUMDuuQtx7ESPaBvN/3LOQjI1uu5zpBTwkZFCPGx6fNgbrLg9HvFWqJlfJc
         i2F1r6ZshEcXDi6HRd4xOgP7ACrmFah9b3JDhVbOVwL5H/NtQzGHKVXVXZf1UfSl9s9+
         ipCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681734612; x=1684326612;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/JB5DRDshib4Tz8g7yVBW+9lQnfgBzFAQIBePQQwSg=;
        b=YN8JaorkzO8TJwQiznnqq+1tdQyHXVCUZw84ImbZAtmTX77WNJulUn1Iw7AbW1VXcJ
         qNren3YKpvz9tkqUbmMdmVlnf0Yam+hYQ56vGJdV99OTeFG2Hlhn/wETfhz5GES4/rXn
         lEom82EYXC2P0+T4UsCjLithXv1HBoqL+U+1RwI3DbMOaYtrSsA9cudHaw6LGpYsK5Bg
         bIJJ6LNX1FWiaHv0p3JToFVmdw+OmQFZp76K0lzPepXaJuhtKBYFk4ZCvMc6Hlyje46K
         PBIcDStbYG4fIF9P7R5nXfqm20U/13L8rJT/kpIOTEdmJliLx7dxHaveuLB4DwNTk1ah
         DSmw==
X-Gm-Message-State: AAQBX9ffmvYLQN7DGCGJ+vSd0AQNr8Kdp2NJNkCpHETz6RtAbq4X6ZqI
        tWaHtroeL3Ls2rnWxTZK+BGLrIUk7u8KyiotSOFEsw==
X-Google-Smtp-Source: AKy350asj3McUx7cd43SB9wv7K+s/l9AmPs16fLHun2t6r4FImgn7a2GqXnKPqh6TsP4gy2ji6dEKA==
X-Received: by 2002:ac2:4210:0:b0:4ea:f5dd:8aa1 with SMTP id y16-20020ac24210000000b004eaf5dd8aa1mr1972414lfh.18.1681734611756;
        Mon, 17 Apr 2023 05:30:11 -0700 (PDT)
Received: from localhost (c-9b0ee555.07-21-73746f28.bbcust.telenor.se. [85.229.14.155])
        by smtp.gmail.com with ESMTPSA id m10-20020ac2428a000000b004cb23904bd9sm2020078lfh.144.2023.04.17.05.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 05:30:11 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     stable@vger.kernel.org
Cc:     acme@redhat.com, andres@anarazel.de, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [backport PATCH 0/2] stable v5.15, v5.10 and v5.4: fix perf build errors
Date:   Mon, 17 Apr 2023 14:29:41 +0200
Message-Id: <20230417122943.2155502-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.39.2
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

Hi,

I would like to see these patches backported. They are needed so perf
can be cross compiled with gcc on v5.15, v5.10 and v5.4.
I built it with tuxmake [1] here are two example commandlines:
tuxmake --runtime podman --target-arch arm64 --toolchain gcc-12 --kconfig defconfig perf
tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-12 --kconfig defconfig perf

Tried to build perf with both gcc-11 and gcc-12.

Patch 'tools perf: Fix compilation error with new binutils'
and 'tools build: Add feature test for init_disassemble_info API changes'
didn't apply cleanly, thats why I send these in a patchset.

When apply 'tools build: Add feature test for
init_disassemble_info API changes' to 5.4 it will be a minor merge
conflict, do you want me to send this patch in two separate patches one
for 5.4 and another for v5.10?

The sha for these two patches in mainline are.
cfd59ca91467 tools build: Add feature test for init_disassemble_info API changes
83aa0120487e tools perf: Fix compilation error with new binutils

The above patches solves these:
util/annotate.c: In function 'symbol__disassemble_bpf':
util/annotate.c:1729:9: error: too few arguments to function 'init_disassemble_info'
 1729 |         init_disassemble_info(&info, s,
      |         ^~~~~~~~~~~~~~~~~~~~~


Please apply these to v5.10 and v5.4
a45b3d692623 tools include: add dis-asm-compat.h to handle version differences
d08c84e01afa perf sched: Cast PTHREAD_STACK_MIN to int as it may turn into sysconf(__SC_THREAD_STACK>

The above patches solves these:
/home/anders/src/kernel/stable-5.10/tools/include/linux/kernel.h:43:24: error: comparison of distinct pointer types lacks a cast [-Werror]
   43 |         (void) (&_max1 == &_max2);              \
      |                        ^~
builtin-sched.c:673:34: note: in expansion of macro 'max'
  673 |                         (size_t) max(16 * 1024, PTHREAD_STACK_MIN));
      |                                  ^~~


Please apply these to v5.15, v5.10 and v5.4
8e8bf60a6754 perf build: Fixup disabling of -Wdeprecated-declarations for the python scripting engine
4ee3c4da8b1b perf scripting python: Do not build fail on deprecation warnings
63a4354ae75c perf scripting perl: Ignore some warnings to keep building with perl headers

Build error that the above 3 patches solves are:
/usr/lib/x86_64-linux-gnu/perl/5.36/CORE/handy.h:125:23: error: cast from function call of type 'STRLEN' {aka 'long unsigned int'} to non-matching type '_Bool' [-Werror=bad-function-cast]
  125 | #define cBOOL(cbool) ((bool) (cbool))
      |                       ^

Cheers,
Anders
[1] https://tuxmake.org/

Andres Freund (2):
  tools perf: Fix compilation error with new binutils
  tools build: Add feature test for init_disassemble_info API changes

 tools/build/Makefile.feature                        |  1 +
 tools/build/feature/Makefile                        |  4 ++++
 tools/build/feature/test-all.c                      |  4 ++++
 tools/build/feature/test-disassembler-init-styled.c | 13 +++++++++++++
 tools/perf/Makefile.config                          |  8 ++++++++
 tools/perf/util/annotate.c                          |  7 ++++---
 6 files changed, 34 insertions(+), 3 deletions(-)
 create mode 100644 tools/build/feature/test-disassembler-init-styled.c

--
2.39.2

