Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520445388B4
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 23:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242629AbiE3VyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 17:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242129AbiE3VyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 17:54:12 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AEA53B6F
        for <stable@vger.kernel.org>; Mon, 30 May 2022 14:54:10 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id i66so15354445oia.11
        for <stable@vger.kernel.org>; Mon, 30 May 2022 14:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5UQuwLpVA4OjRgP15iwD9HH2xQXEfpjnSzFpNwRNrhE=;
        b=VsuQfNj3Iv9yVAXonlTOc5/hmvE/qStqm02fRgMbHn1rEflpZZbn4HwzqMByiyse+s
         mQh7mtRna5sdhTRJPKe+msYrJTxx8W5/wiWm364c+i0HuNtU++xc7z8AjchbJmP03AAf
         kMfgB/irlFkGe/tN1/SfGDbkwxeUztw9WRpLZc+woVUi0LXtwD3ecJzrYUn1IdIoGV0x
         z1qvCsiIwPkIi1h8d+5vX9NB1/ID93TRKWC6hm30Muqx8cxRvOqNtBOFP8m5UIQnGyJr
         yaUe7Vgy7yqx+We8OxYZUwz9FDw0zohflcQcQkwG5gV19foH7At2Hz9EYkOzC1ZTO1ir
         rMOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5UQuwLpVA4OjRgP15iwD9HH2xQXEfpjnSzFpNwRNrhE=;
        b=oJC+uhYU/VuRSIMyCKYwuO2PcK2aCwS75DqKUO1cisv9fAshO/rRA3Q5O6dShp2mvx
         F1xZnEgBCOzUkQdJ5T+aohQx1E+jEQMj0Pb2JsHTrzTZQeFKyp+rlteHvCJfd8zcIszn
         lIa5Np8vyEl6kg1OIk6wAa90H6ij4dJjjk2hlWC4mH8NpHqp69g2UP03o9jhOGJyN4fr
         YJYv7zvoY34kVyHmJ6GpXvMnVeqerjuZlVuYBUhBS24FIU3eKY1XisiG1i/yHK+Wac7U
         oNbbumB4mkyH0OhL/tyBab6HUPqlM7Gcf1kKL65UCAw5RfoY6mDulHtchS4v/cmxVlrY
         R4OA==
X-Gm-Message-State: AOAM532WZuaiU0CPOiKL7ImJFeMjQYhCm6ooOw9kSn3UPodcONbhoRhu
        pnyJ3lmRAHmwRgoGT2PUF5UZZLJYk7U93N0a
X-Google-Smtp-Source: ABdhPJzU0GK7Q5Um92i4VssPulboE+k40OsU8k+TlEwJ6UbefSNs+2F27bQ8+QOx6vFC33NPiw/Esg==
X-Received: by 2002:a05:6808:2127:b0:32b:7dff:4f58 with SMTP id r39-20020a056808212700b0032b7dff4f58mr10813992oiw.124.1653947650136;
        Mon, 30 May 2022 14:54:10 -0700 (PDT)
Received: from alago.cortijodelrio.net ([189.219.75.147])
        by smtp.googlemail.com with ESMTPSA id fq11-20020a0568710b0b00b000f23989c532sm4230425oab.8.2022.05.30.14.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 14:54:09 -0700 (PDT)
From:   =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Darren Hart <dvhart@infradead.org>,
        linux-kernel@vger.kernel.org (open list:PERFORMANCE EVENTS SUBSYSTEM)
Subject: [PATCH 4.19 2/3] perf bench: Share some global variables to fix build with gcc 10
Date:   Mon, 30 May 2022 16:53:24 -0500
Message-Id: <20220530215325.921847-3-daniel.diaz@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220530215325.921847-1-daniel.diaz@linaro.org>
References: <20220530215325.921847-1-daniel.diaz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit e4d9b04b973b2dbce7b42af95ea70d07da1c936d ]

Noticed with gcc 10 (fedora rawhide) that those variables were not being
declared as static, so end up with:

  ld: /tmp/build/perf/bench/epoll-wait.o:/git/perf/tools/perf/bench/epoll-wait.c:93: multiple definition of `end'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  ld: /tmp/build/perf/bench/epoll-wait.o:/git/perf/tools/perf/bench/epoll-wait.c:93: multiple definition of `start'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  ld: /tmp/build/perf/bench/epoll-wait.o:/git/perf/tools/perf/bench/epoll-wait.c:93: multiple definition of `runtime'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  ld: /tmp/build/perf/bench/epoll-ctl.o:/git/perf/tools/perf/bench/epoll-ctl.c:38: multiple definition of `end'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  ld: /tmp/build/perf/bench/epoll-ctl.o:/git/perf/tools/perf/bench/epoll-ctl.c:38: multiple definition of `start'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  ld: /tmp/build/perf/bench/epoll-ctl.o:/git/perf/tools/perf/bench/epoll-ctl.c:38: multiple definition of `runtime'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  make[4]: *** [/git/perf/tools/build/Makefile.build:145: /tmp/build/perf/bench/perf-in.o] Error 1

Prefix those with bench__ and add them to bench/bench.h, so that we can
share those on the tools needing to access those variables from signal
handlers.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/20200303155811.GD13702@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Daniel Díaz <daniel.diaz@linaro.org>
---
 tools/perf/bench/bench.h         |  4 ++++
 tools/perf/bench/futex-hash.c    | 12 ++++++------
 tools/perf/bench/futex-lock-pi.c | 11 +++++------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 6c9fcd757f310..b3e418afc21a2 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -2,6 +2,10 @@
 #ifndef BENCH_H
 #define BENCH_H
 
+#include <sys/time.h>
+
+extern struct timeval bench__start, bench__end, bench__runtime;
+
 /*
  * The madvise transparent hugepage constants were added in glibc
  * 2.13. For compatibility with older versions of glibc, define these
diff --git a/tools/perf/bench/futex-hash.c b/tools/perf/bench/futex-hash.c
index 9aa3a674829b3..ee9b280651093 100644
--- a/tools/perf/bench/futex-hash.c
+++ b/tools/perf/bench/futex-hash.c
@@ -35,7 +35,7 @@ static unsigned int nfutexes = 1024;
 static bool fshared = false, done = false, silent = false;
 static int futex_flag = 0;
 
-struct timeval start, end, runtime;
+struct timeval bench__start, bench__end, bench__runtime;
 static pthread_mutex_t thread_lock;
 static unsigned int threads_starting;
 static struct stats throughput_stats;
@@ -101,8 +101,8 @@ static void toggle_done(int sig __maybe_unused,
 {
 	/* inform all threads that we're done for the day */
 	done = true;
-	gettimeofday(&end, NULL);
-	timersub(&end, &start, &runtime);
+	gettimeofday(&bench__end, NULL);
+	timersub(&bench__end, &bench__start, &bench__runtime);
 }
 
 static void print_summary(void)
@@ -112,7 +112,7 @@ static void print_summary(void)
 
 	printf("%sAveraged %ld operations/sec (+- %.2f%%), total secs = %d\n",
 	       !silent ? "\n" : "", avg, rel_stddev_stats(stddev, avg),
-	       (int) runtime.tv_sec);
+	       (int)bench__runtime.tv_sec);
 }
 
 int bench_futex_hash(int argc, const char **argv)
@@ -159,7 +159,7 @@ int bench_futex_hash(int argc, const char **argv)
 
 	threads_starting = nthreads;
 	pthread_attr_init(&thread_attr);
-	gettimeofday(&start, NULL);
+	gettimeofday(&bench__start, NULL);
 	for (i = 0; i < nthreads; i++) {
 		worker[i].tid = i;
 		worker[i].futex = calloc(nfutexes, sizeof(*worker[i].futex));
@@ -202,7 +202,7 @@ int bench_futex_hash(int argc, const char **argv)
 	pthread_mutex_destroy(&thread_lock);
 
 	for (i = 0; i < nthreads; i++) {
-		unsigned long t = worker[i].ops/runtime.tv_sec;
+		unsigned long t = worker[i].ops / bench__runtime.tv_sec;
 		update_stats(&throughput_stats, t);
 		if (!silent) {
 			if (nfutexes == 1)
diff --git a/tools/perf/bench/futex-lock-pi.c b/tools/perf/bench/futex-lock-pi.c
index 8e9c4753e3040..017609ae35906 100644
--- a/tools/perf/bench/futex-lock-pi.c
+++ b/tools/perf/bench/futex-lock-pi.c
@@ -35,7 +35,6 @@ static bool silent = false, multi = false;
 static bool done = false, fshared = false;
 static unsigned int nthreads = 0;
 static int futex_flag = 0;
-struct timeval start, end, runtime;
 static pthread_mutex_t thread_lock;
 static unsigned int threads_starting;
 static struct stats throughput_stats;
@@ -62,7 +61,7 @@ static void print_summary(void)
 
 	printf("%sAveraged %ld operations/sec (+- %.2f%%), total secs = %d\n",
 	       !silent ? "\n" : "", avg, rel_stddev_stats(stddev, avg),
-	       (int) runtime.tv_sec);
+	       (int)bench__runtime.tv_sec);
 }
 
 static void toggle_done(int sig __maybe_unused,
@@ -71,8 +70,8 @@ static void toggle_done(int sig __maybe_unused,
 {
 	/* inform all threads that we're done for the day */
 	done = true;
-	gettimeofday(&end, NULL);
-	timersub(&end, &start, &runtime);
+	gettimeofday(&bench__end, NULL);
+	timersub(&bench__end, &bench__start, &bench__runtime);
 }
 
 static void *workerfn(void *arg)
@@ -183,7 +182,7 @@ int bench_futex_lock_pi(int argc, const char **argv)
 
 	threads_starting = nthreads;
 	pthread_attr_init(&thread_attr);
-	gettimeofday(&start, NULL);
+	gettimeofday(&bench__start, NULL);
 
 	create_threads(worker, thread_attr, cpu);
 	pthread_attr_destroy(&thread_attr);
@@ -209,7 +208,7 @@ int bench_futex_lock_pi(int argc, const char **argv)
 	pthread_mutex_destroy(&thread_lock);
 
 	for (i = 0; i < nthreads; i++) {
-		unsigned long t = worker[i].ops/runtime.tv_sec;
+		unsigned long t = worker[i].ops / bench__runtime.tv_sec;
 
 		update_stats(&throughput_stats, t);
 		if (!silent)
-- 
2.32.0

