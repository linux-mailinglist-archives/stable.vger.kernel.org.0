Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9479A6A0317
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 08:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbjBWHCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 02:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbjBWHC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 02:02:28 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397244AFE2;
        Wed, 22 Feb 2023 23:02:02 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id e9so6677917plh.2;
        Wed, 22 Feb 2023 23:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=mdqKjDpknoldjbXgVeqUHUTykf5w/8lk9H2d441sxtg=;
        b=FJ/Zl852LRpZfzweW3XjqZItvLfXb8d10BfQXkfC2dq/ORvjq0DRh2POWz/HnulYAQ
         4s1nItn+GP1RK5xIn6OcxS4NyMvRYRUjEtDNnG8+a9du+Cyn5edhETRqk6OB+CHljcTt
         hcwkzFIqZxJvusfp6Fm1QCXB8SYNY4PaFl3vYzapey6bNc0mnE+WedBtkBQiX3EwXLCZ
         uKGY7+RpaIRB8n3J6XOFVkcBhu1YQnZID2osD6tTQX02JqCSxv912Bjnj7tMrIdxeQV1
         q1DK/B2dPv6TAIKF1zhNDvELiyLz1uvW3X7KwDcnuf1pvlHKtsYejVasiHjmqvRXZ+u8
         YJFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mdqKjDpknoldjbXgVeqUHUTykf5w/8lk9H2d441sxtg=;
        b=VkoHq/C/7ISfvqTBNNrh7upVm7ed5/xuz8QlWk33HYKeeAPTxoFyosNLU5+8/i+St2
         8LcP+H06bxdL00Bip2HA4D9Inr2hZPF0OZgVg0xTxpfRSqaUBU55VdKUhQRrELhrxLk/
         TolJssWcq7aMnkAyG30g7v8sxAsiYh+cBP2+PD1Q80z1vlpqzPa0GW+lHhnnEBdhg5eU
         Fx+JC48AVa0cY7kZmTCrV8KWDS6I5L7TehrxxsuGdYWDj8+rihUWrAAGz0XrHztxFzTS
         JyRYmohDQ22Biw5eFRxH6OiCLX67kpPWAV+Vy2CENZTFK0q3kUkOs/HAskD5E73/dmH9
         aeoA==
X-Gm-Message-State: AO0yUKU3+tdqb1aLtn2pL3ssG4UOSr0uwofjHGPIiqC5KW9SKMGsi/nY
        faBxhFJbpkrPmeLo+vCXPRQ=
X-Google-Smtp-Source: AK7set82OYyCXPIb5mj39rMPSTyj4k8FAK3ZXtDeewEo0KuLS+Wd5dbFCKODHxACj0b43P/ArJPTlw==
X-Received: by 2002:a17:903:41cd:b0:19a:a6cd:35a8 with SMTP id u13-20020a17090341cd00b0019aa6cd35a8mr12692150ple.25.1677135718170;
        Wed, 22 Feb 2023 23:01:58 -0800 (PST)
Received: from balhae.hsd1.ca.comcast.net ([2601:647:6780:44b0:ad80:6c0b:4a23:5c4f])
        by smtp.gmail.com with ESMTPSA id gj5-20020a17090b108500b00231227781d5sm4570725pjb.2.2023.02.22.23.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 23:01:57 -0800 (PST)
Sender: Namhyung Kim <namhyung@gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-perf-users@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] perf inject: Fix --buildid-all not to eat up MMAP2
Date:   Wed, 22 Feb 2023 23:01:55 -0800
Message-Id: <20230223070155.54251-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When MMAP2 has PERF_RECORD_MISC_MMAP_BUILD_ID flag, it means the record
already has the build-id info.  So it marks the DSO as hit, to skip if
the same DSO is not processed if it happens to miss the build-id later.

But it missed to copy the MMAP2 record itself so it'd fail to symbolize
samples for those regions.

For example, the following generates 249 MMAP2 events.

  $ perf record --buildid-mmap -o- true | perf report --stat -i- | grep MMAP2
           MMAP2 events:        249  (86.8%)

Adding perf inject should not change the number of events like this

  $ perf record --buildid-mmap -o- true | perf inject -b | \
  > perf report --stat -i- | grep MMAP2
           MMAP2 events:        249  (86.5%)

But when --buildid-all is used, it eats most of the MMAP2 events.

  $ perf record --buildid-mmap -o- true | perf inject -b --buildid-all | \
  > perf report --stat -i- | grep MMAP2
           MMAP2 events:          1  ( 2.5%)

With this patch, it shows the original number now.

  $ perf record --buildid-mmap -o- true | perf inject -b --buildid-all | \
  > perf report --stat -i- | grep MMAP2
           MMAP2 events:        249  (86.5%)

Cc: stable@vger.kernel.org
Fixes: f7fc0d1c915a ("perf inject: Do not inject BUILD_ID record if MMAP2 has it")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-inject.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index f8182417b734..10bb1d494258 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -538,6 +538,7 @@ static int perf_event__repipe_buildid_mmap2(struct perf_tool *tool,
 			dso->hit = 1;
 		}
 		dso__put(dso);
+		perf_event__repipe(tool, event, sample, machine);
 		return 0;
 	}
 
-- 
2.39.2.637.g21b0678d19-goog

