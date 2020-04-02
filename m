Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188CD19C9A6
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388905AbgDBTNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45077 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388989AbgDBTNe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id t7so5540168wrw.12
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4pengcvy5Yycyp9fs4C3dUV4shvRnbagfJNMDgQf1lc=;
        b=AfRbKwlGHaSi6+M6Gq8BueNi6Ji6Zwg3q3E1kMdTrG6FOOWy1WSF+Bm0ORbJznbM4b
         JV3lymnN95eWs7bcENoKcU7MDXTfih8KU6TdShDlnSAKmJ+3LU7RYTlmp0s9y89cjWi9
         9Kmz0u0PwIM3DS/K1HDUQNETqlRi//UDq+DItzxRE25nSuV+J7q7y2mtZgADdEkKFC7N
         6bTDQeXqL/QUx0jmL1IHjJdziwTmuhhYQ7+wQnDKOsKJ3qh9ECfF8oYnIzbGwyZh6dqg
         xHC+O2pIgZ/2Y5sYyzJbu9CG5XxbuFR2tbL8cop1+WmRfykPhrIoyNLSt52wulMIRmj+
         3t+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4pengcvy5Yycyp9fs4C3dUV4shvRnbagfJNMDgQf1lc=;
        b=baHgB/zuTGd/8K9HPMp2X6Fi5Zk20ejh/6BUzL2p+sLgFfJK/+bZc6cClQWR3jFIiz
         j8KIqPy2NFpjeg5W9GV4wEIqkEjN1LoQL5PqDwFz+3N3HKIEwE/zcR4d75/nHNmeqrvr
         5mNUFH1ULPa0LLJL9HYCKHDcQGXoyvw+TFxo7wmjUGqM+fpja17OAm/VbdI/CLhV2vQf
         NAuJUmRzT/EwZcofKiFVsCJz7Lv6OO2Q93MEh8HuXk666c0n7gCDXO9ahq53CfK+8oyE
         /Ncq73KQHLfoc4KdKlSfU0bDU7WU2g9UlamHQOrDSO8BoySi7OAwVN3nTo+7mhJaJ82u
         Y7hQ==
X-Gm-Message-State: AGi0PuYeH5+dfYJ1cv/UzmG98FivRvMCXYOzJ7HmsTbll9zi5mdkak+c
        Jw8WxosOU+/DTFbpO2tBNn7fFYUVmLDvvg==
X-Google-Smtp-Source: APiQypIZNWKjRjaayP5ODVJhOEnmn65Q0QN3CAESYgobGot2+5w5qp9uDCD+EOs4DQJ8bcisk4xHrA==
X-Received: by 2002:adf:a348:: with SMTP id d8mr4970027wrb.83.1585854812084;
        Thu, 02 Apr 2020 12:13:32 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:31 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 30/33] perf/core: Reattach a misplaced comment
Date:   Thu,  2 Apr 2020 20:13:50 +0100
Message-Id: <20200402191353.787836-30-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

[ Upstream commit f25d8ba9e1b204b90fbf55970ea6e68955006068 ]

A comment is in a wrong place in perf_event_create_kernel_counter().
Fix that.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: https://lkml.kernel.org/r/20191030134731.5437-2-alexander.shishkin@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/events/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2ac73b4cb8a93..9d8f699f11873 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10430,10 +10430,6 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	struct perf_event *event;
 	int err;
 
-	/*
-	 * Get the target context (task or percpu):
-	 */
-
 	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
 				 overflow_handler, context, -1);
 	if (IS_ERR(event)) {
@@ -10444,6 +10440,9 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	/* Mark owner so we could distinguish it from user events. */
 	event->owner = TASK_TOMBSTONE;
 
+	/*
+	 * Get the target context (task or percpu):
+	 */
 	ctx = find_get_context(event->pmu, task, event);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
-- 
2.25.1

