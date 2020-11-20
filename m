Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8422BA394
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 08:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgKTHjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 02:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbgKTHjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 02:39:17 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF08C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 23:39:15 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id d142so9423626wmd.4
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 23:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jfPTCOwEycreCjYHBBr08e6mFViZKX3r3jGlSQp0SCM=;
        b=krgs2Lsoh7RjFNQY+PLvHqwiP8nZIucSU4Eav6GiCCibRsY8YnLX19F4vIDVhUhLK8
         pjTu0gSbskWpoGGWWmLXiu3EwMetCxsZ26Xinb6BOMxMAKEH6E0NduKsAsEF0lkLSVkq
         51ymkjX2Sm4d/xOsXYAacFG7HMiLZfnlyB/nbyUJiA8ZCU4JtjGCU8IclnUpl6ysUqfv
         ggFZ1lMFkWapn797gHmzvgO0VE/SPPXrO1BBkK4DeDcSlfSRUDZSmPbEDpgYW7bnnDlK
         O1Mn8kqK2lHI3+IcNSPqeo+BtrR/chCxvsKGAeE4tKAmKglUsohG/FOzp+Dw3TmtSnsc
         bmxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=jfPTCOwEycreCjYHBBr08e6mFViZKX3r3jGlSQp0SCM=;
        b=G94VdGq3MCjmLu1STfDcRD/lUdNG2APhTvWjTJQrjXSru3B38UYs/FqmSbd/v7iC+f
         3n01k+J8Xk4c1LwkyBgSZcDxMiN/0G/wnXyp8Gw62rzyLrPGbsgMaSUvJ3q8qJa05xrA
         bbDSIhcQKApx/nz59Ypi1/XOAI9PCvFRXyG/Rp8XGUEbtqRnNATLFMXuQPmghP12HaOw
         WORCNwKzU9ChSCnHowdo+tv+S0DrKgJO78AMiAiu8Qwnk2YDTPd+UYVwUYkKFJ+wuvxl
         LDs/p9q2guYoveJBjFaaGkJZG8M1t3ESm+FTGHcAR2YT8pYQG+lz41qlqjI3g2b9nNET
         0R+Q==
X-Gm-Message-State: AOAM5311GTOhvjPpg02IRIlQX6AF3ao/++umltLXR1CnlUKTLxtE0Yck
        c8XYTpzZIOwrtKEa+n3bO/Y=
X-Google-Smtp-Source: ABdhPJy3YFEsdBxnFeV3EQVQAUdhD1rIxsZfmvY0J96aur/Ses7s+2mmCcCsSzU9BBjma9A18RWtLA==
X-Received: by 2002:a1c:c309:: with SMTP id t9mr1256803wmf.149.1605857954556;
        Thu, 19 Nov 2020 23:39:14 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id q12sm3854196wrx.86.2020.11.19.23.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 23:39:12 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable@vger.kernel.org
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        Tor Jeremiassen <tor@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] Revert "perf cs-etm: Move definition of 'traceid_list' global variable from header file"
Date:   Fri, 20 Nov 2020 08:39:09 +0100
Message-Id: <20201120073909.357536-1-carnil@debian.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 168200b6d6ea0cb5765943ec5da5b8149701f36a upstream.
(but only from 4.19.y)

The original commit introduces a build failure as seen on Debian buster
when compiled with gcc (Debian 8.3.0-6) 8.3.0:

  $ LC_ALL=C.UTF-8 ARCH=x86 make perf
  [...]
  Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' differs from latest version at 'include/uapi/linux/bpf.h'
    CC       util/cs-etm-decoder/cs-etm-decoder.o
    CC       util/intel-pt.o
  util/cs-etm-decoder/cs-etm-decoder.c: In function 'cs_etm_decoder__buffer_packet':
  util/cs-etm-decoder/cs-etm-decoder.c:287:24: error: 'traceid_list' undeclared (first use in this function); did you mean 'trace_event'?
    inode = intlist__find(traceid_list, trace_chan_id);
                          ^~~~~~~~~~~~
                          trace_event
  util/cs-etm-decoder/cs-etm-decoder.c:287:24: note: each undeclared identifier is reported only once for each function it appears in
  make[6]: *** [/build/linux-stable/tools/build/Makefile.build:97: util/cs-etm-decoder/cs-etm-decoder.o] Error 1
  make[5]: *** [/build/linux-stable/tools/build/Makefile.build:139: cs-etm-decoder] Error 2
  make[5]: *** Waiting for unfinished jobs....
  make[4]: *** [/build/linux-stable/tools/build/Makefile.build:139: util] Error 2
  make[3]: *** [Makefile.perf:633: libperf-in.o] Error 2
  make[2]: *** [Makefile.perf:206: sub-make] Error 2
  make[1]: *** [Makefile:70: all] Error 2
  make: *** [Makefile:77: perf] Error 2

Link: https://lore.kernel.org/stable/20201114083501.GA468764@eldamar.lan/
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: Tor Jeremiassen <tor@ti.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org> # 4.19.y
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
---
 tools/perf/util/cs-etm.c | 3 ---
 tools/perf/util/cs-etm.h | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index ad33b99f5d21..7b5e15cc6b71 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -87,9 +87,6 @@ struct cs_etm_queue {
 	struct cs_etm_packet *packet;
 };
 
-/* RB tree for quick conversion between traceID and metadata pointers */
-static struct intlist *traceid_list;
-
 static int cs_etm__update_queues(struct cs_etm_auxtrace *etm);
 static int cs_etm__process_timeless_queues(struct cs_etm_auxtrace *etm,
 					   pid_t tid, u64 time_);
diff --git a/tools/perf/util/cs-etm.h b/tools/perf/util/cs-etm.h
index c7ef97b198c7..37f8d48179ca 100644
--- a/tools/perf/util/cs-etm.h
+++ b/tools/perf/util/cs-etm.h
@@ -53,6 +53,9 @@ enum {
 	CS_ETMV4_PRIV_MAX,
 };
 
+/* RB tree for quick conversion between traceID and CPUs */
+struct intlist *traceid_list;
+
 #define KiB(x) ((x) * 1024)
 #define MiB(x) ((x) * 1024 * 1024)
 
-- 
2.29.2

