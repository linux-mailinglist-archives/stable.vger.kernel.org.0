Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14DA4F2D5E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236529AbiDEI2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239565AbiDEIUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D088B2603;
        Tue,  5 Apr 2022 01:16:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FD5C60B0B;
        Tue,  5 Apr 2022 08:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6D4C385A0;
        Tue,  5 Apr 2022 08:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146577;
        bh=jGIt1ZGHk2ZNqu7SMJGSKzTlEhP30eEkEnh7L+phfIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6dW8IfYLBxDgTfWbwl7ikUAOYOKKVSwWpdOva58j+tlhNG9GTT2EX+drYraVkUj6
         RyLUfBt/GZIA930/ua2PpN9TiDNYofem7Ah1VhcinIOFjlAPXFFk2IEhlL0r1mEzCD
         qSiFMZsj+I9YRkAz583ODIEhxec6a7i54PplC7XA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shunsuke Nakamura <nakamura.shun@fujitsu.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0814/1126] libperf tests: Fix typo in perf_evlist__open() failure error messages
Date:   Tue,  5 Apr 2022 09:26:01 +0200
Message-Id: <20220405070431.457256451@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shunsuke Nakamura <nakamura.shun@fujitsu.com>

[ Upstream commit c2eeac985657f61543e6c5a333b94f3bd18e6b9d ]

This patch corrects typos in error messages. I should be "evlist", not
"evsel" as the function that fails is perf_evlist__open().

Fixes: 3ce311afb5583cf3 ("libperf: Move to tools/lib/perf")
Fixes: a7f3713f6bf207e6 ("libperf tests: Add test_stat_multiplexing test")
Signed-off-by: Shunsuke Nakamura <nakamura.shun@fujitsu.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20220325043829.224045-2-nakamura.shun@fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/tests/test-evlist.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/perf/tests/test-evlist.c b/tools/lib/perf/tests/test-evlist.c
index fa854c83b7e7..ed616fc19b4f 100644
--- a/tools/lib/perf/tests/test-evlist.c
+++ b/tools/lib/perf/tests/test-evlist.c
@@ -69,7 +69,7 @@ static int test_stat_cpu(void)
 	perf_evlist__set_maps(evlist, cpus, NULL);
 
 	err = perf_evlist__open(evlist);
-	__T("failed to open evsel", err == 0);
+	__T("failed to open evlist", err == 0);
 
 	perf_evlist__for_each_evsel(evlist, evsel) {
 		cpus = perf_evsel__cpus(evsel);
@@ -130,7 +130,7 @@ static int test_stat_thread(void)
 	perf_evlist__set_maps(evlist, NULL, threads);
 
 	err = perf_evlist__open(evlist);
-	__T("failed to open evsel", err == 0);
+	__T("failed to open evlist", err == 0);
 
 	perf_evlist__for_each_evsel(evlist, evsel) {
 		perf_evsel__read(evsel, 0, 0, &counts);
@@ -187,7 +187,7 @@ static int test_stat_thread_enable(void)
 	perf_evlist__set_maps(evlist, NULL, threads);
 
 	err = perf_evlist__open(evlist);
-	__T("failed to open evsel", err == 0);
+	__T("failed to open evlist", err == 0);
 
 	perf_evlist__for_each_evsel(evlist, evsel) {
 		perf_evsel__read(evsel, 0, 0, &counts);
@@ -507,7 +507,7 @@ static int test_stat_multiplexing(void)
 	perf_evlist__set_maps(evlist, NULL, threads);
 
 	err = perf_evlist__open(evlist);
-	__T("failed to open evsel", err == 0);
+	__T("failed to open evlist", err == 0);
 
 	perf_evlist__enable(evlist);
 
-- 
2.34.1



