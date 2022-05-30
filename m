Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C035388B7
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 23:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243295AbiE3VyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 17:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242806AbiE3VyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 17:54:15 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB9456777
        for <stable@vger.kernel.org>; Mon, 30 May 2022 14:54:14 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id v9so15373854oie.5
        for <stable@vger.kernel.org>; Mon, 30 May 2022 14:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=17BwL5DwmppT0Sezwf7O5p29EgWkqlCPCTI9oepOQ+I=;
        b=JxzThJZoc9ZJQp7kd6N2gSoBo/hvqH6btv+Ik9c+8HnYKALsc7XG4IJ9c+57xEdGV9
         +3yAY6z4w4TH8oTFlOEPOkNciGNuE9qZ/mG5gJovav05ag7Nc0QF+uoUlUfrF8vVuMBY
         b7Wyg9luPjun1Ehe75UlRgKcKq///saQQCOX445J6+OlbjaUsVZRt/BGUa76UNNGn2cm
         W+PrX7EVIti7F2bCwyWAMeQ3m/nggjlaUGXO5bI+rk9zmoQ9CQw/d/R8/vD+F43Q1rSi
         vIjX/rznJ255ehAfIBzZTKmkkQqjtH1YOHa0EL8iHh9XTcFyVALQUkDRUnoBv1DHLUjo
         UL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=17BwL5DwmppT0Sezwf7O5p29EgWkqlCPCTI9oepOQ+I=;
        b=3ZGg6KBAEO3K60XR5StxEDTORuU3XpVs6t4QAMloNyUPI8sAGjAvnvtCipzrOX7XTu
         89yGE4wxhok4+SgS7a/fz5eNum7GYxTrU9EwAx/mvNjE8U+aL5vwKbvNIo4Z3pEs67Cb
         DlGTa8SXhihJLfG6rhAhwwiCFebipiFIDT1Kv0dbcW/3LTG4S0ZfZ0Z++zZDYI4oStZe
         HJM6XRgtcj6i+UKhSY/3eazLHnae87Ktxwdyw1pP66sr7OHOWWwSVyMUvCZwzrLHfdHQ
         OIMuae1pXGlqO4yhGMrtvO6tKTyORMwjAG9+rJZTLQyZigUj7D9ncj7T9+vr18DXUGeq
         e2SQ==
X-Gm-Message-State: AOAM531MKvxLIfhO2jqNmkzGvV28a+/9wP8aDD+93XXHjwKUoPajB7/6
        LuTXUmnGiNAiChPq38WeX0F7IQ==
X-Google-Smtp-Source: ABdhPJxGAD0IWWAM266hIaw7gTeIhiTsPBvLhEIDtPYwuk57m/PuwzCDG9ZJ7Y0PbT1Tj+mWEFJSVw==
X-Received: by 2002:a05:6808:2125:b0:32b:1ba0:8b05 with SMTP id r37-20020a056808212500b0032b1ba08b05mr10578897oiw.20.1653947652699;
        Mon, 30 May 2022 14:54:12 -0700 (PDT)
Received: from alago.cortijodelrio.net ([189.219.75.147])
        by smtp.googlemail.com with ESMTPSA id fq11-20020a0568710b0b00b000f23989c532sm4230425oab.8.2022.05.30.14.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 14:54:12 -0700 (PDT)
From:   =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org (open list:PERFORMANCE EVENTS SUBSYSTEM)
Subject: [PATCH 4.19 3/3] perf tests bp_account: Make global variable static
Date:   Mon, 30 May 2022 16:53:25 -0500
Message-Id: <20220530215325.921847-4-daniel.diaz@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220530215325.921847-1-daniel.diaz@linaro.org>
References: <20220530215325.921847-1-daniel.diaz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit cff20b3151ccab690715cb6cf0f5da5cccb32adf ]

To fix the build with newer gccs, that without this patch exit with:

    LD       /tmp/build/perf/tests/perf-in.o
  ld: /tmp/build/perf/tests/bp_account.o:/git/perf/tools/perf/tests/bp_account.c:22: multiple definition of `the_var'; /tmp/build/perf/tests/bp_signal.o:/git/perf/tools/perf/tests/bp_signal.c:38: first defined here
  make[4]: *** [/git/perf/tools/build/Makefile.build:145: /tmp/build/perf/tests/perf-in.o] Error 1

First noticed in fedora:rawhide/32 with:

  [perfbuilder@a5ff49d6e6e4 ~]$ gcc --version
  gcc (GCC) 10.0.1 20200216 (Red Hat 10.0.1-0.8)

Reported-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Daniel Díaz <daniel.diaz@linaro.org>
---
 tools/perf/tests/bp_account.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/bp_account.c b/tools/perf/tests/bp_account.c
index a20cbc4454269..624e4ef73d1c0 100644
--- a/tools/perf/tests/bp_account.c
+++ b/tools/perf/tests/bp_account.c
@@ -22,7 +22,7 @@
 #include "perf.h"
 #include "cloexec.h"
 
-volatile long the_var;
+static volatile long the_var;
 
 static noinline int test_function(void)
 {
-- 
2.32.0

